# frozen_string_literal: true

module Hire
  class VacanciesController < Hire::BaseController
    before_action :load_vacancy, except: %i[index new create]
    before_action :check_authorize, only: %i[new create]

    add_breadcrumb I18n.t('.my_vacancies', scope: :hire), :hire_vacancies_path

    def index
      @vacancies = policy_scope([:hire, Vacancy])
    end

    def new
      @vacancy = Vacancy.new
      @vacancy.build_location
      add_breadcrumb 'New', new_hire_vacancy_url
    end

    def edit
      add_breadcrumb @vacancy.id, [:hire, @vacancy]
      add_breadcrumb 'Edit', edit_hire_vacancy_url
    end

    def create
      @vacancy = current_employer.vacancies.build(vacancy_params)
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

      respond_to do |format|
        format.js
        format.html { redirect_to hire_vacancies_path }
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
      params.require(:vacancy).permit(:title,
                                      :description,
                                      :email,
                                      :phone,
                                      :employment_id,
                                      :currency_id,
                                      :experience_id,
                                      :salary_min,
                                      :salary_max,
                                      location_attributes: [:address])
    end

    def load_vacancy
      @vacancy = Vacancy.find(params[:id])
      authorize [:hire, @vacancy]
    end
  end
end
