# frozen_string_literal: true

class CurrencyConverter
  CACHE_TTL = 12.hours

  def initialize(cache: Rails.cache, bank: RussianCentralBankProvider.new)
    @cache = cache
    @bank = bank
  end

  def convert(amount:, from:, to:)
    return amount if from == to

    rate = current_rate(from:, to:)
    (amount * rate).round(2)
  end

  def current_rate(from:, to:)
    return 0 unless from.present? && to.present?

    key = "exchange_rate_#{from.code}_#{to.code}"
    rate = @cache.read(key, expires_in: CACHE_TTL)

    return rate if rate

    rate = @bank.current_rate(from:, to:)

    @cache.write(key, rate, expires_in: CACHE_TTL)
    rate
  end

  def current_rate_to_usd(currency_id:)
    usd = Currency.find_by(code: 'USD')
    from = Currency.find_by(id: currency_id)

    usd == from ? 1 : current_rate(from:, to: usd)
  end
end
