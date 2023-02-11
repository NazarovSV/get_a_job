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
require 'rails_helper'

RSpec.describe HouseNumber, type: :model do
  it { is_expected.to belong_to(:street) }
  it { is_expected.to validate_presence_of :number }
end
