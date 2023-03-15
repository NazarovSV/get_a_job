# frozen_string_literal: true

# == Schema Information
#
# Table name: experiences
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :experience do
    sequence(:description) { |n| "Experience #{n} years" }
  end
end
