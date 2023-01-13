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
FactoryBot.define do
  factory :vacancy do
    title { Faker::Lorem.sentence[0..127] }
    description { Faker::Lorem.paragraph(sentence_count: 25) }
    phone { Faker::PhoneNumber.phone_number }
    email { Faker::Internet.email }
    employer

    trait :blank_phone do
      phone { '' }
    end

    trait :nil_phone do
      phone { nil }
    end

    trait :published do
      state { 'published' }
    end
  end
end
