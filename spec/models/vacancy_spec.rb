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
require 'rails_helper'

RSpec.describe Vacancy, type: :model do
  subject { build(:vacancy) }

  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :location }
  it { is_expected.to validate_length_of(:title).is_at_most(255) }
  it { is_expected.to allow_value('address@email.com').for(:email) }
  it { is_expected.to belong_to :employer }
  it { is_expected.to have_one(:location).dependent(:destroy) }
  it { is_expected.to have_many(:responses).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for :location }
  it { is_expected.to transition_from(:drafted).to(:published).on_event(:publish) }
  it { is_expected.to transition_from(:published).to(:archived).on_event(:archive) }
  it { is_expected.to transition_from(:archived).to(:published).on_event(:publish) }

  describe 'validate phone number' do
    it { expect(build(:vacancy)).to allow_value(Faker::PhoneNumber.phone_number).for(:phone) }
    it { expect(build(:vacancy, :blank_phone)).to allow_value('').for(:phone) }
    it { expect(build(:vacancy, :nil_phone)).to allow_value('').for(:phone) }
    it { expect(build(:vacancy)).not_to allow_value('123123123123123').for(:phone) }
  end
end
