# frozen_string_literal: true

module Hire
  class VacanciesController < Hire::BaseController
    before_action :load_vacancy, only: %i[show edit update]

    def edit
      authorize [:hire, @vacancy]
    end

    def index
      @vacancies = current_user.vacancies
    end

    def new
      @vacancy = Vacancy.new
    end

    def create
      @vacancy = Vacancy.new(vacancy_params)
      @vacancy.employer = current_employer

      if @vacancy.save
        redirect_to hire_vacancy_path(id: @vacancy), notice: t('vacancy.created')
      else
        render :new
      end
    end

    def show
      authorize [:hire, @vacancy]
    end

    def update
      authorize [:hire, @vacancy]

      if @vacancy.update(vacancy_params)
        redirect_to [:hire, @vacancy], notice: t('vacancy.updated')
      else
        render :edit
      end
    end

    private

    def vacancy_params
      params.require(:vacancy).permit(:title, :description, :email, :phone)
    end

    def load_vacancy
      @vacancy = Vacancy.find(params[:id])
    end
  end
end
