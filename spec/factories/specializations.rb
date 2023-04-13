# frozen_string_literal: true

# == Schema Information
#
# Table name: specializations
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :specialization do
    sequence(:name) { |n| "Specialization #{n}" }
  end
end
