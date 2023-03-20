# frozen_string_literal: true

class USDSalaryService
  def self.call
    usd = Currency.find_by(code: 'USD')

    return if usd.blank?

    converter = CurrencyConverter.new

    Currency.where.not(id: usd.id).each do |currency|
      rate = converter.current_rate(from: currency, to: usd)
      Vacancy.where(currency_id: currency).update_all("usd_salary_min = salary_min * #{rate}, usd_salary_max = salary_max * #{rate}")
    end
  end
end
