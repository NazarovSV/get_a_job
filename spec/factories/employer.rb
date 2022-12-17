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
  factory :employer do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end

