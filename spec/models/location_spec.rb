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

  describe '.geocode' do
    context 'when address is valid' do
      it 'returns coordinates and create country and cite' do
        location = create(:location, :blank, address: 'Россия, Москва, улица Новый Арбат, 21с1')

        expect(location.latitude).not_to be_nil
        expect(location.longitude).not_to be_nil
        expect(location.country.name).to eq('Russia')
        expect(location.city.name).to eq('Moscow')
        expect(location.city.country.name).to eq('Russia')
      end

      it 'not create new country and city if already exists' do
        first_location = create(:location, :blank, address: 'Россия, Москва, улица Новый Арбат, 21с1')
        second_location = create(:location, :blank, address: 'Россия, Москва, Новочерёмушкинская улица, 39к1')

        expect(second_location.country).to eq(first_location.country)
        expect(second_location.city).to eq(first_location.city)
      end
    end

    context 'when address is not valid' do
      it 'returns nil' do
        location = build(:location, :blank, address: '')

        location.valid?

        expect(location.errors.messages).to_not be_empty
        expect(location.latitude).to be_nil
        expect(location.longitude).to be_nil
      end
    end
  end

  describe '.first_five_address_contains' do
    context 'when a matching address exists' do
      let!(:location_one) do
        create(:location, address: 'Россия, Москва, улица Новый Арбат, 21с1', vacancy: create(:vacancy))
      end
      let!(:location_two) do
        create(:location, address: 'Россия, Москва, Новочерёмушкинская улица, 39к1', vacancy: create(:vacancy))
      end
      let!(:location_three) do
        create(:location, address: 'Россия, Москва, Нахимовский проспект, 31к2', vacancy: create(:vacancy))
      end

      it 'returns the matching addresses' do
        results = Location.first_five_address_contains(search_letters: 'Нов')
        expect(results).to include('Россия, Москва, улица Новый Арбат, 21с1')
        expect(results).to include('Россия, Москва, Новочерёмушкинская улица, 39к1')
        expect(results).not_to include('Россия, Москва, Нахимовский проспект, 31к2')
      end
    end

    context 'when no matching address exists' do
      let!(:location_one) do
        create(:location, address: 'Россия, Москва, улица Новый Арбат, 21с1', vacancy: create(:vacancy))
      end

      it 'returns an empty array' do
        results = Location.first_five_address_contains(search_letters: 'Сов')
        expect(results).to be_empty
      end
    end
  end
end
