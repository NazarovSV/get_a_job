# frozen_string_literal: true

class RussianCentralBankProvider
  def current_rate(from:, to:)
    return 1 if from == to

    Money.default_bank = Money::Bank::RussianCentralBank.new
    Money.default_bank.update_rates

    if from.code != :RUB || to.code != :RUB
      Money.default_bank.rates["#{from.code}_TO_RUB"].to_f * Money.default_bank.rates["RUB_TO_#{to.code}"].to_f
    else
      Money.default_bank.rates["#{from.code}_TO_#{to.code}"].to_f
    end
  end
end
