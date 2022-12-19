# frozen_string_literal: true

module Employer
  class VacanciesController < Employer::BaseController
    before_action :load_vacancy, only: :show

    def index
      @vacancies = Vacancy.all
    end

    def new
      @vacancy = Vacancy.new
    end

    def create
      @vacancy = Vacancy.new(vacancy_params)
      @vacancy.employer = current_employer

      if @vacancy.save
        redirect_to employer_vacancy_path(id: @vacancy), notice: t('vacancy.created')
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
end
