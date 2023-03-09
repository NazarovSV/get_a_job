# frozen_string_literal: true

class ExchangeRatesService
  def initialize(currency_converter: CurrencyConverter.new)
    @currency_converter = currency_converter
  end

  def call(from:, amount:)
    Currency.where.not(id: from.id).map do |to|
      { amount: @currency_converter.convert(amount, from:, to:), currency: to.name }
    end
  end
end
