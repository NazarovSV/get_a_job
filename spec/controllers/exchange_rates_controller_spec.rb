# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRatesController, type: :controller do
  render_views

  let!(:usd) { create(:currency, name: 'USD', code: :USD) }
  let!(:eur) { create(:currency, name: 'EUR', code: :EUR) }
  let!(:gbp) { create(:currency, name: 'GBP', code: :GBP) }
  let!(:exchange_service) { double('ExchangeRatesService') }

  describe 'GET #index' do
    before do
      returned_json = [{ amount: 80, currency: 'EUR' }, { amount: 70, currency: 'GBP' }]
      allow(ExchangeRatesService).to receive(:new).and_return(exchange_service)
      allow(exchange_service).to receive(:call).with(from: usd, amount: 100).and_return(returned_json)
      get :index, params: { exchange_rate: { amount: 100, currency_id: usd } }, format: :js
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
end
