# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRatesController, type: :controller do
  render_views

  include_examples 'currency list'

  let!(:exchange_service) { double('ExchangeRatesService') }
  let!(:currency_converter) { double('CurrencyConverter') }

  describe 'GET #index' do
    before do
      returned_json = [{ amount: 80, currency: @eur.code }, { amount: 70, currency: @gbp.code }]
      allow(ExchangeRatesService).to receive(:new).and_return(exchange_service)
      allow(exchange_service).to receive(:call).with(from: @usd, amount: 100).and_return(returned_json)
      get :index, params: { exchange_rate: { amount: 100, currency_from_id: @usd } }, format: :js
    end

    it 'returns an array of converted amounts and currency names' do
      expected_result = [
        { amount: 80, currency: 'EUR' },
        { amount: 70, currency: 'GBP' }
      ]

      expect(assigns(:exchange_amounts)).to eq expected_result
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns JSON data' do
      expect(response.content_type).to have_content('application/json')
    end
  end

  describe 'GET #convert' do
    before do
      allow(CurrencyConverter).to receive(:new).and_return(currency_converter)
      allow(currency_converter).to receive(:convert).with(amount: 100, from: @usd, to: @eur).and_return(80)
      get :convert, params: { exchange_rate: { amount: 100, currency_from_id: @usd.id, currency_to_id: @eur.id } },
                    format: :js
    end

    it 'returns json data' do
      expect(assigns(:amount)).to eq 80
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns JSON data' do
      expect(response.content_type).to have_content('application/json')
    end
  end
end
