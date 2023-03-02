# frozen_string_literal: true

# == Schema Information
#
# Table name: currencies
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :currency do
    sequence(:name) { |n| "Currency #{n}" }
    sequence(:code) { |n| "CUR#{n}" }
  end
end
