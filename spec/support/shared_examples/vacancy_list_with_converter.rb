# frozen_string_literal: true
# # frozen_string_literal: true
#
# RSpec.shared_examples 'vacancy with converter stub' do
#   include_examples 'currency list'
#   #include_examples 'vacancies list'
#
#   let!(:currency_converter) { double('CurrencyConverter') }
#
#   before do
#     allow(CurrencyConverter).to receive(:new).and_return(currency_converter)
#     allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @usd.id).and_return(1.0)
#     allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @rub.id).and_return(1.0 / 80)
#     allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @eur.id).and_return(0.9)
#     allow(currency_converter).to receive(:current_rate_to_usd).with(currency_id: @eur.id).and_return(0.9)
#     allow(currency_converter).to receive(:convert).with(amount: 100, from: @usd, to: @eur).and_return(80)
#     # allow(currency_converter).to receive(:convert).with(amount: 10_000, from: rub, to: rub).and_return(10_000)
#     # allow(currency_converter).to receive(:convert).with(amount: 16_000, from: rub, to: rub).and_return(16_000)
#     # allow(currency_converter).to receive(:convert).with(amount: 20_000, from: rub, to: rub).and_return(20_000)
#     # allow(currency_converter).to receive(:convert).with(amount: 4_500, from: usd, to: rub).and_return(4_500 / 80)
#     # allow(currency_converter).to receive(:convert).with(amount: 5_000, from: usd, to: rub).and_return(5_000 / 80)
#     # allow(currency_converter).to receive(:convert).with(amount: 15_000, from: usd, to: rub).and_return(15_000 / 80)
#     # allow(currency_converter).to receive(:convert).with(amount: 16_000, from: usd, to: rub).and_return(16_000 / 80)
#
#   end
# end
#
