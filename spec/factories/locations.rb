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
FactoryBot.define do
  factory :location do
    country
    city
    address { 'Russia, Moscow, Klimentovskiy Pereulok, 65' }
    latitude { 55.7409061 }
    longitude { 37.6265976 }

    association :vacancy # , factory: :vacancy, strategy: :build

    trait :blank do
      address { '' }
      latitude { nil }
      longitude { nil }
    end
  end
end
