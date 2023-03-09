# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRatesService do
  let(:currency_converter) { double('CurrencyConverter') }
  let(:usd) { create(:currency, name: 'USD', code: :USD) }
  let(:eur) { create(:currency, name: 'EUR', code: :EUR) }
  let(:gbp) { create(:currency, name: 'GBP', code: :GBP) }
  let(:amount) { 1000 }

  subject { described_class.new(currency_converter:) }

  describe '#call' do
    before do
      allow(currency_converter).to receive(:convert).with(amount, from: usd, to: eur).and_return(800)
      allow(currency_converter).to receive(:convert).with(amount, from: usd, to: gbp).and_return(700)
    end

    it 'returns an array of converted amounts and currency names' do
      expected_result = [
        { amount: 800, currency: 'EUR' },
        { amount: 700, currency: 'GBP' }
      ]
      expect(subject.call(from: usd, amount:)).to eq(expected_result)
    end
  end
end
