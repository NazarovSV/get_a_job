# frozen_string_literal: true

class ResponsesController < ApplicationController
  before_action :authenticate_employee!
  before_action :load_vacancy, only: %i[new create]
  before_action :load_response, only: :show

  def show; end

  def new
    @response = @vacancy.responses.new
  end

  def create
    @response = @vacancy.responses.new(response_params)
    @response.employee = current_employee

    if @response.save
      redirect_to @response, notice: t('.successful')
    else
      render :new
    end
  end

  private

  def load_vacancy
    @vacancy = Vacancy.published.find(params[:vacancy_id])
  end

  def load_response
    @response = Response.find(params[:id])
  end

  def response_params
    params.require(:response).permit(:email, :phone, :resume_url, :covering_letter)
  end
end
