# frozen_string_literal: true

# == Schema Information
#
# Table name: responses
#
#  id              :bigint           not null, primary key
#  covering_letter :string
#  email           :string           not null
#  phone           :string
#  resume_url      :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  employee_id     :bigint
#  vacancy_id      :bigint
#
# Indexes
#
#  index_responses_on_employee_id  (employee_id)
#  index_responses_on_vacancy_id   (vacancy_id)
#
class Response < ApplicationRecord
  belongs_to :employee
  belongs_to :vacancy

  validates :email, :resume_url, presence: true
  validates :resume_url, url: true

  validates_with PhoneNumberValidator
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
