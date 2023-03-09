# frozen_string_literal: true

class RussianCentralBankProvider
  def current_rate(from:, to:)
    return 1 if from == to

    Money.default_bank = Money::Bank::RussianCentralBank.new
    Money.default_bank.update_rates

    Money.default_bank.rates["#{from.code}_TO_#{to.code}"]
  end
end
