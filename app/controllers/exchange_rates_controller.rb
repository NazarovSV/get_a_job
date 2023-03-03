class ExchangeRatesController < ApplicationController
  def exchange
    currency_from = params[:currency_id]
    amount = exchange_params[:amount].to_f

    @exchange_sums = ExchangeRateService.call(currency_from:, amount:)

    render json: @exchange_sums
  end

  private

  def exchange_params
    params.require(:exchange_rate).permit(:currency_id, :amount)
  end
end
