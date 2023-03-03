# frozen_string_literal: true

class ExchangeRateService
  def self.call(currency_from:, amount:)
    exchange_currencies = Currency.find_another(currency)

    exchange_currencies.map do |currency_to|
      rate = get_exchange_rate(currency_from:, currency_to:)
      [amount * rate, currency_to.name]
    end
  end

  private

  def get_exchange_rate(currency_from:, currency_to:)
    exchange_rate = ExchangeRate.find_by(from_currency_id: currency_from.id, to_currency_id: currency_to.id)

    if exchange_rate.nil?
      rate = get_actual_exchange_rate(currency_from:, currency_to:)
      ExchangeRate.create(from_currency_id: currency_from.id, to_currency_id: currency_to.id, rate:)
      rate
    elsif  exchange_rate.updated_at < 12.hours.ago
      rate = get_actual_exchange_rate(currency_from:, currency_to:)
      exchange_rate.update(rate:)
      rate
    else
      exchange_rate.rate
    end
  end

  def get_actual_exchange_rate(currency_from:, currency_to:)
    #TODO Get actual exchange rate from WEB API
    1.0
  end
end

