# frozen_string_literal: true

module Hire
  class VacanciesController < Hire::BaseController
    before_action :load_vacancy, only: %i[archive show edit update publish destroy]
    before_action :check_authorize, only: %i[new create]

    add_breadcrumb I18n.t('.my_vacancies', scope: :hire), :hire_vacancies_path

    def edit
      add_breadcrumb @vacancy.id, [:hire, @vacancy]
      add_breadcrumb 'Edit', edit_hire_vacancy_url
    end

    def index
      @vacancies = policy_scope([:hire, Vacancy])
    end

    def new
      @vacancy = Vacancy.new
      add_breadcrumb 'New', new_hire_vacancy_url
    end

    def create
      @vacancy = Vacancy.new(vacancy_params)
      @vacancy.employer = current_employer

      if @vacancy.save
        redirect_to [:hire, @vacancy], notice: t('vacancy.created')
      else
        render :new
      end
    end

    def show
      add_breadcrumb @vacancy.id, [:hire, @vacancy]
    end

    def destroy
      if @vacancy.drafted?
        @vacancy.destroy!
        flash.now[:notice] = t('.successfully')
      else
        flash.now[:alert] = t('.unsuccessfully')
      end
    end

    def update
      if @vacancy.update(vacancy_params)
        redirect_to [:hire, @vacancy], notice: t('vacancy.updated')
      else
        render :edit
      end
    end

    def archive
      @vacancy.archive!
    end

    def publish
      @vacancy.publish!
    end

    private

    def check_authorize
      authorize [:hire, Vacancy]
    end

    def vacancy_params
      params.require(:vacancy).permit(:title, :description, :email, :phone)
    end

    def load_vacancy
      @vacancy = Vacancy.find(params[:id])
      authorize [:hire, @vacancy]
    end
  end
end
