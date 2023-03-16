# frozen_string_literal: true

# == Schema Information
#
# Table name: vacancies
#
#  id            :bigint           not null, primary key
#  description   :string           not null
#  email         :string           not null
#  phone         :string
#  salary_max    :integer
#  salary_min    :integer
#  state         :string
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :bigint           not null
#  currency_id   :bigint
#  employer_id   :bigint           not null
#  experience_id :bigint           not null
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

  def self.look(keywords: '', filters: {})
    vacancies = published

    return vacancies if keywords.blank? && filters.empty?

    if filters[:city_id].present?
      vacancies = vacancies.joins(:location).where(locations: { city_id: filters[:city_id] })
      filters.delete(:city_id)
    end

    return vacancies.where(filters) if keywords.blank?

    vacancies.where(filters).search(keywords)
  end

  private

  def clear_currency_if_no_salary
    self.currency_id = nil if salary_min.blank? && salary_max.blank?
  end

  def located_at; end
end
