# frozen_string_literal: true

class ExchangeRatesController < ApplicationController
  before_action :load_currency
  def index
    amount = exchange_params[:amount].to_i

    @exchange_amounts = ExchangeRatesService.new.call(from: @current_currency, amount:)

    render json: @exchange_amounts
  end

  private

  def load_currency
    @current_currency = Currency.find_by(id: exchange_params[:currency_id])
  end

  def exchange_params
    params.require(:exchange_rate).permit(:currency_id, :amount)
  end
end
