# frozen_string_literal: true

# == Schema Information
#
# Table name: employments
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :employment do
    name { Faker::Name.unique.name }
  end
end
