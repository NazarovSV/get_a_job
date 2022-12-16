# frozen_string_literal: true

class VacanciesController < ApplicationController
  before_action :load_vacancy, only: :show
  def index
    @vacancies = Vacancy.all
  end

  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = Vacancy.new(vacancy_params)
    if @vacancy.save
      redirect_to @vacancy, notice: t('vacancy.created')
    else
      render :new
    end
  end

  def show; end

  private

  def vacancy_params
    params.require(:vacancy).permit(:title, :description, :email, :phone)
  end

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end
end
