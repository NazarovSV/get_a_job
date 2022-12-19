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
require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  subject { build(:vacancy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :description }
  it { should validate_presence_of :email }
  it { should validate_length_of(:title).is_at_most(255) }
  it { should allow_value('address@email.com').for(:email) }
  it { should belong_to(:employer) }

  describe 'validate phone number' do
    it { expect(build(:vacancy)).to allow_value(Faker::PhoneNumber.phone_number).for(:phone) }
    it { expect(build(:vacancy, :blank_phone)).to allow_value('').for(:phone) }
    it { expect(build(:vacancy, :nil_phone)).to allow_value('').for(:phone) }
    it { expect(build(:vacancy)).to_not allow_value('123123123123123').for(:phone) }
  end
end
