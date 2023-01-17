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
FactoryBot.define do
  factory :response do
    employee
    vacancy
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    resume_url { Faker::Internet.url }
    covering_letter { Faker::Lorem.paragraph(sentence_count: 25) }

    trait :invalid do
      email { '12345' }
      phone { '12345' }
      resume_url { '12345' }
    end
  end
end
