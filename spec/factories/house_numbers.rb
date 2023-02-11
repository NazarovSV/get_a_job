# == Schema Information
#
# Table name: house_numbers
#
#  id         :bigint           not null, primary key
#  number     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  street_id  :bigint           not null
#
# Indexes
#
#  index_house_numbers_on_street_id  (street_id)
#
# Foreign Keys
#
#  fk_rails_...  (street_id => streets.id)
#
FactoryBot.define do
  factory :house_number do
    number { '38' }
    street
  end
end