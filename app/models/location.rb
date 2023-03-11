# frozen_string_literal: true

# == Schema Information
#
# Table name: locations
#
#  id         :bigint           not null, primary key
#  address    :string
#  latitude   :float
#  longitude  :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  city_id    :bigint           not null
#  country_id :bigint           not null
#  vacancy_id :bigint           not null
#
# Indexes
#
#  index_locations_on_city_id     (city_id)
#  index_locations_on_country_id  (country_id)
#  index_locations_on_vacancy_id  (vacancy_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (vacancy_id => vacancies.id)
#
class Location < ApplicationRecord
  belongs_to :country
  belongs_to :city
  belongs_to :vacancy

  validates_with AddressValidator
  validates :country_id, :city_id, :address, presence: true

  geocoded_by :address, if: ->(record) { record.address.present? and record.address_changed? }
  before_validation :geocode

  def self.first_five_address_contains(letters:)
    where('LOWER(address) LIKE ?', "%#{letters.downcase}%").select(:address).distinct.limit(5)
  end

  private

  def geocode
    geo_data = Geocoder.search(address)

    return unless geo_data.present?

    self.latitude = geo_data.first.latitude
    self.longitude = geo_data.first.longitude
    self.country = Country.find_or_create_by(name: geo_data.first.country)
    self.city = country.cities.find_or_create_by(name: geo_data.first.city)
  end
end
