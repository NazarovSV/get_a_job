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
  it { is_expected.to belong_to :category }
  it { is_expected.to belong_to :experience }
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

  describe '#look' do
    let!(:category) { create_list :category, 3 }
    let!(:usd) { create(:currency, name: 'USD', code: :USD) }
    let!(:eur) { create(:currency, name: 'EUR', code: :EUR) }
    let!(:rub) { create(:currency, name: 'RUB', code: :RUB) }

    let!(:experience) { create_list :experience, 3 }
    let!(:vacancy1) do
      create(:vacancy,
             :published,
             :without_salary,
             title: 'Ruby developer',
             description: 'Ruby developer',
             category: category.second,
             currency: rub,
             experience: experience.first,
             address: 'Ukraine, Kyiv')
    end
    let!(:vacancy2) do
      create(:vacancy,
             :published,
             salary_min: 10_000,
             salary_max: 20_000,
             title: 'Ruby developer 3',
             description: 'Ruby developer 3',
             category: category.first,
             currency: rub,
             experience: experience.first,
             address: 'Ukraine, Kyiv')
    end
    let!(:vacancy3) do
      create(:vacancy,
             :published,
             salary_min: 15_000,
             salary_max: nil,
             title: 'Ruby developer 23',
             description: 'Ruby developer 23',
             category: category.first,
             currency: usd,
             experience: experience.last,
             address: 'UK, London')
    end
    let!(:vacancy4) do
      create(:vacancy,
             :published,
             salary_min: 4_500,
             salary_max: 5_000,
             title: 'Ruby developer 4',
             description: 'Ruby developer 4',
             category: category.first,
             currency: usd,
             experience: experience.second,
             address: 'Russia, Moscow')
    end
    let!(:vacancy5) do
      create(:vacancy,
             :published,
             salary_min: nil,
             salary_max: 16_000,
             title: 'Go developer',
             description: 'Go developer',
             category: category.first,
             currency: rub,
             experience: experience.second,
             address: 'Russia, Moscow')
    end
    let!(:vacancy6) do
      create(:vacancy,
             salary_min: nil,
             salary_max: 16_000,
             title: 'Java developer',
             description: 'Java developer',
             category: category.first,
             currency: rub,
             experience: experience.second,
             address: 'Russia, Moscow')
    end

    let!(:currency_converter) { double('CurrencyConverter') }

    before do
      allow(CurrencyConverter).to receive(:new).and_return(currency_converter)
      allow(currency_converter).to receive(:convert).with(amount: 10_000, from: rub, to: rub).and_return(10_000)
      allow(currency_converter).to receive(:convert).with(amount: 16_000, from: rub, to: rub).and_return(16_000)
      allow(currency_converter).to receive(:convert).with(amount: 20_000, from: rub, to: rub).and_return(20_000)
      allow(currency_converter).to receive(:convert).with(amount: 4_500, from: usd, to: rub).and_return(4_500 * 80)
      allow(currency_converter).to receive(:convert).with(amount: 5_000, from: usd, to: rub).and_return(5_000 * 80)
      allow(currency_converter).to receive(:convert).with(amount: 15_000, from: usd, to: rub).and_return(15_000 * 80)
      allow(currency_converter).to receive(:convert).with(amount: 16_000, from: usd, to: rub).and_return(16_000 * 80)
    end

    it 'returns all published vacancies if no filter and keywords' do
      expect(Vacancy.look).to contain_exactly(vacancy1, vacancy2, vacancy3, vacancy4, vacancy5)
    end

    it { expect(Vacancy.look(filters: { city_id: City.find_by(name: 'Kyiv') })).to contain_exactly(vacancy1, vacancy2) }
    it { expect(Vacancy.look(filters: { category_id: category.second })).to contain_exactly(vacancy1) }
    it { expect(Vacancy.look(filters: { experience_id: experience.first })).to contain_exactly(vacancy1, vacancy2) }

    it {
      expect(Vacancy.look(filters: { salary_min: 17_000,
                                     currency_id: rub.id })).to contain_exactly(vacancy1, vacancy2, vacancy3, vacancy4)
    }

    it {
      expect(Vacancy.look(filters: { salary_max: 9_000, currency_id: rub.id })).to contain_exactly(vacancy1, vacancy5)
    }

    it 'returns vacancy filtered by filter and keywords' do
      expect(Vacancy.look(keywords: 'Ruby developer 3',
                          filters: { category_id: category.first })).to contain_exactly(vacancy2)
    end

    it 'not returns vacancy filtered by filter and keywords' do
      expect(Vacancy.look(keywords: 'Ruby developer 2', filters: { category_id: category.first })).to be_empty
    end
  end
end
