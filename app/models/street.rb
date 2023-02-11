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
class Street < ApplicationRecord
  belongs_to :city
  has_many :house_numbers
  has_many :locations

  validates :name, presence: true
end
