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
require 'rails_helper'

RSpec.describe Response, type: :model do
  it { is_expected.to belong_to(:vacancy) }
  it { is_expected.to belong_to(:employee) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :resume_url }
  it { is_expected.to validate_url_of :resume_url }
  it { is_expected.to allow_value('address@email.com').for(:email) }
  it { is_expected.not_to allow_value('address').for(:email) }

  describe 'validate phone number' do
    it { expect(build(:vacancy)).to allow_value(Faker::PhoneNumber.phone_number).for(:phone) }
    it { expect(build(:vacancy)).not_to allow_value('123123123123123').for(:phone) }
  end
end
