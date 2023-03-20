# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchService do
  include_examples 'vacancies list'

  describe '#call' do
    it 'returns all published vacancies if no filter and keywords' do
      expect(SearchService.call).to contain_exactly(@ruby_dev, @js_dev, @c_sharp_dev, @c_plus_dev, @go_dev)
    end

    it { expect(SearchService.call(filters: { city_id: City.find_by(name: 'Kyiv') })).to contain_exactly(@ruby_dev, @js_dev) }
    it { expect(SearchService.call(filters: { category_id: @category.second })).to contain_exactly(@ruby_dev) }
    it { expect(SearchService.call(filters: { experience_id: @experience.first })).to contain_exactly(@ruby_dev, @js_dev) }

    it {
      expect(SearchService.call(filters: { salary_min: 17_000, currency_id: @rub.id })).to contain_exactly(@ruby_dev, @js_dev, @c_sharp_dev, @c_plus_dev)
    }

    it {
      expect(SearchService.call(filters: { salary_max: 9_000, currency_id: @rub.id })).to contain_exactly(@ruby_dev, @go_dev)
    }

    it 'returns vacancy filtered by filter and keywords' do
      expect(SearchService.call(keywords: 'JS',
                          filters: { category_id: @category.first })).to contain_exactly(@js_dev)
    end

    it 'not returns vacancy filtered by filter and keywords' do
      expect(SearchService.call(keywords: 'Ruby', filters: { category_id: @category.first })).to be_empty
    end
  end
end