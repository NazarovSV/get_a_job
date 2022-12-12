# frozen_string_literal: true

class VacanciesController < ApplicationController
  before_action :vacancy_by_id, only: :show
  def index; end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = Vacancy.new(vacancy_params)
    if @vacancy.save
      redirect_to @vacancy, notice: 'Your vacancy successfully created.'
    else
      render :new
    end
  end

  def show; end

  private

  def vacancy_params
    params.require(:vacancy).permit(:title, :description, :email, :phone)
  end

  def vacancy_by_id
    @vacancy = Vacancy.find(params[:id])
  end
end
