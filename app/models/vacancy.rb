# frozen_string_literal: true

# == Schema Information
#
# Table name: vacancies
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  email       :string           not null
#  phone       :string
#  state       :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employer_id :bigint           not null
#
# Indexes
#
#  index_vacancies_on_employer_id  (employer_id)
#
# Foreign Keys
#
#  fk_rails_...  (employer_id => employers.id)
#
class Vacancy < ApplicationRecord
  include AASM
  include PgSearch::Model

  belongs_to :employer
  has_many :responses, dependent: :destroy
  has_one :location, dependent: :destroy

  accepts_nested_attributes_for :location, allow_destroy: true

  validates_associated :location
  validates :location, presence: true

  validates :title, :description, :email, presence: true
  validates :title, length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_with PhoneNumberValidator

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
end
