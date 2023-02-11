# == Schema Information
#
# Table name: locations
#
#  id              :bigint           not null, primary key
#  full_address    :string
#  latitude        :float
#  longitude       :float
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  city_id         :bigint           not null
#  country_id      :bigint           not null
#  house_number_id :bigint           not null
#  street_id       :bigint           not null
#  vacancy_id      :bigint           not null
#
# Indexes
#
#  index_locations_on_city_id          (city_id)
#  index_locations_on_country_id       (country_id)
#  index_locations_on_house_number_id  (house_number_id)
#  index_locations_on_street_id        (street_id)
#  index_locations_on_vacancy_id       (vacancy_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (country_id => countries.id)
#  fk_rails_...  (house_number_id => house_numbers.id)
#  fk_rails_...  (street_id => streets.id)
#  fk_rails_...  (vacancy_id => vacancies.id)
#
require 'rails_helper'

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to(:country) }
  it { is_expected.to belong_to(:city) }
  it { is_expected.to belong_to(:street) }
  it { is_expected.to belong_to(:house_number) }
end
