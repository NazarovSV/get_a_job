# frozen_string_literal: true

require 'rails_helper'

RSpec.describe USDSalaryService do
  subject { described_class }

  describe '#call' do
    context 'when no USD currency' do
      let!(:vacancies) { create_list(:vacancy, 3) }

      it 'doings nothing' do
        subject.call

        vacancies.each do |vacancy|
          expect(vacancy.usd_salary_min).to be_nil
          expect(vacancy.usd_salary_max).to be_nil
        end
      end
    end

    context 'when USD currency exist' do
      include_context 'Currency'

      let!(:currency_converter) { double('CurrencyConverter') }
      let!(:usd_rates) { { @usd.id => 1, @eur.id => 2, @rub.id => 0.5 } }

      before do
        allow(CurrencyConverter).to receive(:new).and_return(currency_converter)
        allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @eur.id).and_return(usd_rates[@eur.id])
        allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @rub.id).and_return(usd_rates[@rub.id])
      end

      describe 'when all vacancy with USD' do
        let!(:vacancies) { create_list(:vacancy, 3, currency: @usd) }

        it 'usd_salary equal salary' do
          subject.call

          Vacancy.all.each do |vacancy|
            expect(vacancy.usd_salary_min).to eq(vacancy.salary_min)
            expect(vacancy.usd_salary_max).to eq(vacancy.salary_max)
          end
        end
      end

      describe 'when vacancy with no USD currency it converted' do
        let!(:vacancies_usd) { create_list(:vacancy, 3, currency: @usd) }
        let!(:vacancies_rub) { create_list(:vacancy, 3, currency: @rub) }
        let!(:vacancies_eur) { create_list(:vacancy, 3, currency: @eur) }

        it 'usd_salary equal salary' do
          subject.call

          Vacancy.all.each do |vacancy|
            expect(vacancy.usd_salary_min).to eq(vacancy.salary_min * usd_rates[vacancy.currency_id])
            expect(vacancy.usd_salary_max).to eq(vacancy.salary_max * usd_rates[vacancy.currency_id])
          end
        end
      end
    end
  end
end
