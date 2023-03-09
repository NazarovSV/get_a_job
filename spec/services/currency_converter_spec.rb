# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencyConverter do
  let(:cache) { double('ActiveSupport::Cache::MemoryStore') }
  let(:bank) { double('RussianCentralBankProvider') }
  let(:from_currency) { create(:currency, name: 'USD', code: :USD) }
  let(:to_currency) { create(:currency, name: 'EUR', code: :EUR) }
  let(:amount) { 100 }

  subject { described_class.new(cache:, bank:) }

  describe '#convert' do
    context 'when from and to currencies are the same' do
      it 'returns the same amount' do
        expect(subject.convert(amount, from: from_currency, to: from_currency)).to eq(amount)
      end
    end

    context 'when from and to currencies are different' do
      let(:rate) { 0.8 }

      before do
        allow(cache).to receive(:read).and_return(nil)
        allow(bank).to receive(:current_rate).and_return(rate)
        allow(cache).to receive(:write)
      end

      it 'returns the converted amount' do
        expected_result = (amount * rate).round(2)
        expect(subject.convert(amount, from: from_currency, to: to_currency)).to eq(expected_result)
      end

      it 'caches the exchange rate' do
        key = "exchange_rate_#{from_currency.code}_#{to_currency.code}"
        expect(cache).to receive(:read).with(key, expires_in: described_class::CACHE_TTL).and_return(nil)
        expect(bank).to receive(:current_rate).with(from: from_currency, to: to_currency).and_return(rate)
        expect(cache).to receive(:write).with(key, rate, expires_in: described_class::CACHE_TTL)
        subject.convert(amount, from: from_currency, to: to_currency)
      end

      it 'returns the cached exchange rate when available' do
        expected_result = (amount * rate).round(2)
        key = "exchange_rate_#{from_currency.code}_#{to_currency.code}"
        allow(cache).to receive(:read).with(key, expires_in: described_class::CACHE_TTL).and_return(rate)

        expect(bank).not_to receive(:current_rate)
        expect(subject.convert(amount, from: from_currency, to: to_currency)).to eq(expected_result)
      end
    end
  end
end
