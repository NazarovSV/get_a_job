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
require 'rails_helper'

RSpec.describe Location, type: :model do
  it { is_expected.to belong_to :country }
  it { is_expected.to belong_to :city }
  it { is_expected.to belong_to :vacancy }
  it { is_expected.to validate_presence_of :city_id }
  it { is_expected.to validate_presence_of :country_id }
  it { is_expected.to validate_presence_of :address }

  describe 'validate coordinate' do
    it { expect(build(:location)).to allow_value(0).for(:latitude) }
    it { expect(build(:location)).to allow_value(0).for(:longitude) }

    it 'is not valid without coordinates' do
      location = build(:location, :blank)
      location.valid?
      expect(location.errors[:address]).to include('is invalid')
    end
  end
end
