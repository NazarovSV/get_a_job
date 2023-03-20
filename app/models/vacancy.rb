# frozen_string_literal: true

# == Schema Information
#
# Table name: vacancies
#
#  id             :bigint           not null, primary key
#  description    :string           not null
#  email          :string           not null
#  phone          :string
#  salary_max     :integer
#  salary_min     :integer
#  state          :string
#  title          :string           not null
#  usd_salary_max :integer
#  usd_salary_min :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  category_id    :bigint           not null
#  currency_id    :bigint
#  employer_id    :bigint           not null
#  experience_id  :bigint           not null
#
# Indexes
#
#  index_vacancies_on_category_id    (category_id)
#  index_vacancies_on_currency_id    (currency_id)
#  index_vacancies_on_employer_id    (employer_id)
#  index_vacancies_on_experience_id  (experience_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (currency_id => currencies.id)
#  fk_rails_...  (employer_id => employers.id)
#  fk_rails_...  (experience_id => experiences.id)
#
class Vacancy < ApplicationRecord
  before_validation :fill_usd_salaries
  before_validation :clear_currency_if_no_salary

  include AASM
  include PgSearch::Model

  belongs_to :category
  belongs_to :employer
  belongs_to :experience
  belongs_to :currency, optional: true
  has_many :responses, dependent: :destroy
  has_one :location, dependent: :destroy, validate: true

  accepts_nested_attributes_for :location, allow_destroy: true

  validates :location, presence: true
  validates :title, :description, :email, presence: true
  validates :title, length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :salary_min, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :salary_max, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates_with PhoneNumberValidator
  validates_with SalaryForkValidator

  pg_search_scope :search, against: %i[title description]
  scope :look, ->(keywords = '') { search(keywords) unless keywords.blank? }
  scope :filtered_by_city, ->(city_id) { joins(:location).where(locations: { city_id: }) if city_id.present? }
  scope :filtered_by_experience, ->(experience_id) { where(experience_id:) if experience_id.present? }
  scope :filtered_by_category, ->(category_id) { where(category_id:) if category_id.present? }


  aasm column: 'state' do
    state :drafted, initial: true
    state :published
    state :archived

    event :publish do
      transitions from: %i[drafted archived], to: :published
    end

    event :archive do
      transitions from: :published, to: :archived
    end
  end

  def self.filtered_by_salary(salary_min:, salary_max:, currency_id:)
    return all if salary_min.blank? && salary_max.blank?

    rate = CurrencyConverter.new.current_rate_to_usd(currency_id:)

    salary_min = salary_min.present? ? salary_min * rate : 0
    salary_max = salary_max.present? ? salary_max * rate : Float::MAX.to_i

    where('(usd_salary_min is NULL or usd_salary_min <= ?) and (usd_salary_max is NULL or usd_salary_max >= ?)',
          salary_max, salary_min)
  end

  private

  def fill_usd_salaries
    rate = CurrencyConverter.new.current_rate_to_usd(currency_id:)

    self.usd_salary_min = salary_min.present? ? salary_min * rate : nil
    self.usd_salary_max = salary_max.present? ? salary_max * rate : nil
  end

  def clear_currency_if_no_salary
    self.currency_id = nil if salary_min.blank? && salary_max.blank?
  end
end
