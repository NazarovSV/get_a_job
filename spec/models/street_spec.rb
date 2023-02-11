# == Schema Information
#
# Table name: streets
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city_id    :bigint           not null
#
# Indexes
#
#  index_streets_on_city_id  (city_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#
require 'rails_helper'

RSpec.describe Street, type: :model do
  it { is_expected.to belong_to(:city) }
  it { is_expected.to validate_presence_of :name }
end
