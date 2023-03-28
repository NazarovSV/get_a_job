# frozen_string_literal: true

RSpec.shared_context 'Currency' do
  before do
    Currency.delete_all
    @usd = create(:currency, name: 'USD', code: :USD)
    @eur = create(:currency, name: 'EUR', code: :EUR)
    @rub = create(:currency, name: 'RUB', code: :RUB)
    @gbp = create(:currency, name: 'GBP', code: :GBP)
  end
end
