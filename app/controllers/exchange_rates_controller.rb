# frozen_string_literal: true

class ExchangeRatesController < ApplicationController
  before_action :load_currency, only: :index
  before_action :load_currencies, only: :convert
  def index
    amount = exchange_params[:amount].to_i
    @exchange_amounts = ExchangeRatesService.new.call(from: @current_currency, amount:)

    render json: @exchange_amounts
  end

  def convert
    @amount = CurrencyConverter.new.convert(amount: exchange_params[:amount].to_i, from: @from, to: @to)
    render json: { amount: @amount }
  end

  private

  def load_currency
    @current_currency = Currency.find_by(id: exchange_params[:currency_from_id])
  end

  def load_currencies
    @from = Currency.find_by(id: exchange_params[:currency_from_id])
    @to = Currency.find_by(id: exchange_params[:currency_to_id])
  end

  def exchange_params
    params.require(:exchange_rate).permit(:amount, :currency_from_id, :currency_to_id)
  end
end
