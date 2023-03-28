# frozen_string_literal: true

class USDSalaryService
  def self.call
    usd = Currency.find_by(code: 'USD')

    return unless usd.present?

    Currency.all.each do |currency|
      vacancies = Vacancy.where(currency_id: currency)

      next unless vacancies.present?

      rate = currency == usd ? 1 : currency_converter.current_rate_to_usd(currency_id: currency.id)
      vacancies.update_all("usd_salary_min = salary_min * #{rate}, usd_salary_max = salary_max * #{rate}")
    end
  end

  def self.currency_converter
    @currency_converter ||= CurrencyConverter.new
  end
end
