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

  private

  def current_rate(from:, to:)
    key = "exchange_rate_#{from.code}_#{to.code}"
    rate = @cache.read(key, expires_in: CACHE_TTL)

    return rate if rate

    rate = @bank.current_rate(from:, to:)

    @cache.write(key, rate, expires_in: CACHE_TTL)
    rate
  end
end
