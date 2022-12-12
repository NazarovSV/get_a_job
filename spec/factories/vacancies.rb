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
#
FactoryBot.define do
  factory :vacancy do
    title { FFaker::Lorem.sentence[0..127] }
    description { FFaker::Lorem.paragraph }
    phone { FFaker::PhoneNumberRU.phone_number }
    email { FFaker::Internet.email }

    trait :blank_phone do
      phone { '' }
    end

    trait :nil_phone do
      phone { nil }
    end
  end
end
