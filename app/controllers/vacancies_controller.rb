# frozen_string_literal: true

class VacanciesController < ApplicationController
  before_action :load_vacancy, only: :show

  add_breadcrumb I18n.t('.vacancies'), :root_path

  def index
    @vacancies = Vacancy.published
  end

  def show
    if @vacancy.drafted?
      head :forbidden
    elsif @vacancy.archived?
      render 'vacancies/archived_vacancy'
      add_breadcrumb @vacancy.id.to_s, :vacancy_path
    else
      add_breadcrumb @vacancy.id.to_s, :vacancy_path
    end
  end

  private

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end
end
