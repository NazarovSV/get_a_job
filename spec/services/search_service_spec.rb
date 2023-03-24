# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchService do
  include_context 'Vacancies'

  describe '#call' do
    context 'when no filter and keywords' do
      it 'returns all published vacancies' do
        expect(described_class.call).to contain_exactly(@ruby_dev, @js_dev, @c_sharp_dev, @c_plus_dev, @go_dev)
      end
    end

    context 'when filtering without keywords' do
      context 'when filtering by all filters' do
        let(:moscow_city) { City.find_by(name: 'Moscow') }
        let(:category) { @category.first }
        let(:experience) { @experience.first }

        it 'return vacancy filtered by all filters' do
          expect(described_class.call(filters: { city_id: moscow_city,
                                                 category_id: category,
                                                 experience_id: experience,
                                                 salary_min: 10_000,
                                                 salary_max: 20_000,
                                                 currency: @rub })).to contain_exactly(@go_dev)
        end
      end

      context 'when filtering by city' do
        let(:kyiv_city) { City.find_by(name: 'Kyiv') }

        it 'returns only vacancies in Kyiv' do
          expect(described_class.call(filters: { city_id: kyiv_city })).to contain_exactly(@ruby_dev, @js_dev)
        end
      end

      context 'when filtering by category' do
        it 'returns only vacancies in the second category' do
          expect(described_class.call(filters: { category_id: @category.second })).to contain_exactly(@ruby_dev)
        end
      end

      context 'when filtering by experience' do
        it 'returns only vacancies in the first experience' do
          expect(described_class.call(filters: { experience_id: @experience.first })).to contain_exactly(@ruby_dev, @js_dev, @go_dev)
        end
      end

      context 'when filtering by salary' do
        it 'return vacancy filtered by min salary equal or greater then 17_000 rub' do
          expect(described_class.call(filters: { salary_min: 17_000, currency_id: @rub.id })).to contain_exactly(@ruby_dev, @js_dev, @c_sharp_dev, @c_plus_dev)
        end

        it 'return vacancy filtered by max salary equal or lesser then 9_000 rub' do
          expect(described_class.call(filters: { salary_max: 9_000, currency_id: @rub.id })).to contain_exactly(@ruby_dev, @go_dev)
        end
      end
    end

    context 'when filtering by filter and keywords' do
      it 'returns vacancy filtered by filter and keywords' do
        expect(described_class.call(keywords: 'JS', filters: { category_id: @category.first })).to contain_exactly(@js_dev)
      end

      it 'does not return vacancy filtered by filter and keywords' do
        expect(described_class.call(keywords: 'Ruby', filters: { category_id: @category.first })).to be_empty
      end

      it 'return vacancy filtered by all filters and keywords' do
        moscow_city = City.find_by(name: 'Moscow')
        category = @category.first
        experience = @experience.first

        expect(described_class.call(keywords: 'Go', filters: { city_id: moscow_city,
                                               category_id: category,
                                               experience_id: experience,
                                               salary_min: 10_000,
                                               salary_max: 20_000,
                                               currency: @rub })).to contain_exactly(@go_dev)
      end
    end

    context 'filtered by keywords' do
      it 'returns vacancies filtered by keywords' do
        expect(described_class.call(keywords: 'JS')).to contain_exactly(@js_dev)
      end
    end
  end
end