# frozen_string_literal: true

RSpec.shared_examples 'currency list' do
  include_examples 'base example'

  before :all do
    Currency.delete_all

    @usd = create(:currency, name: 'USD', code: :USD)
    @eur = create(:currency, name: 'EUR', code: :EUR)
    @rub = create(:currency, name: 'RUB', code: :RUB)
    @gbp = create(:currency, name: 'GBP', code: :GBP)
  end
end

