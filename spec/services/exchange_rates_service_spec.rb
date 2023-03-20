# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExchangeRatesService do
  include_examples 'currency list'
  subject { described_class.new(currency_converter:) }

  let(:currency_converter) { double('CurrencyConverter') }
  let(:amount) { 1000 }

  describe '#call' do
    before do
      allow(currency_converter).to receive(:convert).with(amount:, from: @usd, to: @eur).and_return(800)
      allow(currency_converter).to receive(:convert).with(amount:, from: @usd, to: @gbp).and_return(700)
      allow(currency_converter).to receive(:convert).with(amount:, from: @usd, to: @rub).and_return(600)
    end

    it 'returns an array of converted amounts and currency names' do
      expected_result = [
        { amount: 800, currency: 'EUR' },
        { amount: 700, currency: 'GBP' },
        { amount: 600, currency: 'RUB' }
      ]
      expect(subject.call(from: @usd, amount:)).to match_array(expected_result)
    end
  end
end
