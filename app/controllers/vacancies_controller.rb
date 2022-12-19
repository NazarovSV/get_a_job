# frozen_string_literal: true

class VacanciesController < ApplicationController
  before_action :load_vacancy, only: :show

  def index
    @vacancies = Vacancy.all
  end

  def show; end

  private

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end
end
