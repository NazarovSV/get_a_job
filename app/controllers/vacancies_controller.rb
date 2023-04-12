# frozen_string_literal: true

class VacanciesController < ApplicationController
  before_action :load_vacancy, only: :show

  add_breadcrumb I18n.t('.bread_vacancies'), :root_path

  def index
    @pagy, @vacancies = pagy(Vacancy.published, items: 10)
  end

  def show
    add_breadcrumb @vacancy.id.to_s, :vacancy_path

    render 'vacancies/archived_vacancy' if @vacancy.archived?
    head :forbidden if @vacancy.drafted?
  end

  private

  def load_vacancy
    @vacancy = Vacancy.find(params[:id])
  end
end
