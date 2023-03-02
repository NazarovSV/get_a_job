# frozen_string_literal: true

# == Schema Information
#
# Table name: vacancies
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  email       :string           not null
#  phone       :string
#  salary_max  :integer
#  salary_min  :integer
#  state       :string
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint           not null
#  currency_id :bigint
#  employer_id :bigint           not null
#
# Indexes
#
#  index_vacancies_on_category_id  (category_id)
#  index_vacancies_on_currency_id  (currency_id)
#  index_vacancies_on_employer_id  (employer_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (currency_id => currencies.id)
#  fk_rails_...  (employer_id => employers.id)
#
FactoryBot.define do
  factory :vacancy do
    title { Faker::Lorem.sentence[0..127] }
    description { Faker::Lorem.paragraph(sentence_count: 25) }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    employer
    category
    currency
    salary_min { rand(1_000..300_000) }
    salary_max { rand(300_001..1_000_000) }

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

    after(:build) do |vacancy|
      build(:location, vacancy:)
    end

    after(:create) do |vacancy|
      build(:location, vacancy:)
    end
  end
end
