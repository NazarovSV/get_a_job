# frozen_string_literal: true

# == Schema Information
#
# Table name: vacancies
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  email       :string           not null
#  phone       :string
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
  belongs_to :employer

  validates_with PhoneNumberValidator
  validates :title, :description, :email, presence: true
  validates :title, length: { maximum: 255 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
