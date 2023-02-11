# == Schema Information
#
# Table name: countries
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Country < ApplicationRecord
  has_many :cities
  has_many :locations

  validates :name, presence: true
end
