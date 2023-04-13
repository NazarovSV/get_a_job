# frozen_string_literal: true

# == Schema Information
#
# Table name: vacancies
#
#  id                :bigint           not null, primary key
#  description       :string           not null
#  email             :string           not null
#  phone             :string
#  salary_max        :integer
#  salary_min        :integer
#  state             :string
#  title             :string           not null
#  usd_salary_max    :float
#  usd_salary_min    :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  currency_id       :bigint
#  employer_id       :bigint           not null
#  employment_id     :bigint           not null
#  experience_id     :bigint           not null
#  specialization_id :bigint
#
# Indexes
#
#  index_vacancies_on_currency_id        (currency_id)
#  index_vacancies_on_employer_id        (employer_id)
#  index_vacancies_on_employment_id      (employment_id)
#  index_vacancies_on_experience_id      (experience_id)
#  index_vacancies_on_specialization_id  (specialization_id)
#
# Foreign Keys
#
#  fk_rails_...  (currency_id => currencies.id)
#  fk_rails_...  (employer_id => employers.id)
#  fk_rails_...  (employment_id => employments.id)
#  fk_rails_...  (experience_id => experiences.id)
#  fk_rails_...  (specialization_id => specializations.id)
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
  it { is_expected.to belong_to :employment }
  it { is_expected.to belong_to :experience }
  it { is_expected.to belong_to :specialization }
  it { is_expected.to belong_to(:currency).optional }
  it { is_expected.to have_one(:location).dependent(:destroy) }
  it { is_expected.to have_many(:responses).dependent(:destroy) }
  it { is_expected.to accept_nested_attributes_for :location }
  it { is_expected.to transition_from(:drafted).to(:published).on_event(:publish) }
  it { is_expected.to transition_from(:published).to(:archived).on_event(:archive) }
  it { is_expected.to transition_from(:archived).to(:published).on_event(:publish) }
  it { is_expected.to validate_numericality_of(:salary_min).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:salary_max).is_greater_than_or_equal_to(0) }

  describe 'validate phone number' do
    it { expect(build(:vacancy)).to allow_value(Faker::PhoneNumber.phone_number).for(:phone) }
    it { expect(build(:vacancy, :blank_phone)).to allow_value('').for(:phone) }
    it { expect(build(:vacancy, :nil_phone)).to allow_value('').for(:phone) }
    it { expect(build(:vacancy)).not_to allow_value('123123123123123').for(:phone) }
  end

  describe 'validate salary' do
    it { expect(build(:vacancy)).to allow_value(Faker::Number.number(digits: 2)).for(:salary_min) }
    it { expect(build(:vacancy)).to allow_value(Faker::Number.number(digits: 2)).for(:salary_max) }
    it { expect(build(:vacancy)).to allow_value(nil).for(:salary_min) }
    it { expect(build(:vacancy)).to allow_value(nil).for(:salary_max) }

    context 'when salary_min is greater then salary_max' do
      let!(:vacancy) { build(:vacancy, salary_min: 2, salary_max: 1) }

      it 'not valid' do
        expect(vacancy).not_to be_valid
      end
    end

    context 'when salary_min is lesser then salary_max' do
      let!(:vacancy) { build(:vacancy, salary_min: 1, salary_max: 2) }

      it 'is valid' do
        expect(vacancy).to be_valid
      end
    end

    context 'when salary_min is filled and salary_max is not' do
      let!(:vacancy) { build(:vacancy, salary_min: 1, salary_max: nil) }

      it 'is valid' do
        expect(vacancy).to be_valid
      end
    end
  end

  describe 'validate currency' do
    it 'no currency where salary not filled' do
      vacancy = create(:vacancy, :without_salary)
      expect(vacancy.currency_id).to be_nil
    end

    it 'have currency where only min salary filled' do
      vacancy = create(:vacancy, salary_min: nil)
      expect(vacancy.currency_id).not_to be_nil
    end

    it 'have currency where only max salary filled' do
      vacancy = create(:vacancy, salary_max: nil)
      expect(vacancy.currency_id).not_to be_nil
    end

    it 'have currency where both min and max salary filled' do
      vacancy = create(:vacancy)
      expect(vacancy.currency_id).not_to be_nil
    end
  end


  describe '.filtered_by_city' do
    let!(:moscow_vacancies) { create_list(:vacancy, 2, address: 'Russia, Moscow')}
    let!(:london_vacancies) { create_list(:vacancy, 2, address: 'UK, London')}

    it 'return only moscow vacancies' do
      expect(Vacancy.filtered_by_city(City.find_by(name: 'Moscow').id) ).to match_array(moscow_vacancies)
    end
  end

  describe '.filtered_by_experience' do
    let!(:experiences) { create_list(:experience, 2)}
    let!(:first_experiences_vacancies) { create_list(:vacancy, 2, experience: experiences.first)}
    let!(:second_experiences_vacancies) { create_list(:vacancy, 2, experience: experiences.second)}

    it 'return only first experience vacancies' do
      expect(Vacancy.filtered_by_experience(experiences.first.id) ).to match_array(first_experiences_vacancies)
    end
  end

  describe '.filtered_by_employment' do
    let!(:employments) { create_list(:employment, 2)}
    let!(:first_employment_vacancies) { create_list(:vacancy, 2, employment: employments.first)}
    let!(:second_employment_vacancies) { create_list(:vacancy, 2, employment: employments.second)}

    it 'return only first employment vacancies' do
      expect(Vacancy.filtered_by_employment(employments.first.id) ).to match_array(first_employment_vacancies)
    end
  end

  describe '.filtered_by_specialization' do
    let!(:specializations) { create_list(:specialization, 2)}
    let!(:first_specialization_vacancies) { create_list(:vacancy, 2, specialization: specializations.first)}
    let!(:second_specialization_vacancies) { create_list(:vacancy, 2, specialization: specializations.second)}

    it 'return only first specialization vacancies' do
      expect(Vacancy.filtered_by_specialization(specializations.first.id) ).to match_array(first_specialization_vacancies)
    end
  end

  describe '.filtered_by_salary' do
    include_context 'Vacancies'

    it 'return vacancy with suitable salary' do
      expected_result = [@ruby_dev, @js_dev, @go_dev, @java_dev]
      expect(Vacancy.filtered_by_salary(salary_min: 10_000, salary_max: 20_000, currency_id: @rub.id)).to match_array(expected_result)
    end
  end
end
