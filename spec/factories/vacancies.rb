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
FactoryBot.define do
  factory :vacancy do
    title { Faker::Lorem.sentence[0..127] }
    description { Faker::Lorem.paragraph(sentence_count: 25) }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    employer
    employment
    currency
    experience
    specialization
    salary_min { rand(1_000..300_000) }
    salary_max { rand(300_001..1_000_000) }
    usd_salary_min { nil }
    usd_salary_max { nil }

    transient do
      address { 'Russia, Moscow, Klimentovskiy Pereulok, 65' }
      skip_fill_usd_salaries { true }
    end

    trait :blank_phone do
      phone { '' }
    end

    trait :nil_phone do
      phone { nil }
    end

    trait :published do
      state { :published }
    end

    trait :archived do
      state { :archived }
    end

    trait :without_salary do
      salary_min { nil }
      salary_max { nil }
    end

    after(:build) do |vacancy, evaluator|
      vacancy.skip_fill_usd_salaries = evaluator.skip_fill_usd_salaries
      build(:location, vacancy:, address: evaluator.address)
    end
  end
end
