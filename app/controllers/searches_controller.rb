# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    @vacancies = Vacancy.look keywords: params['request'], filters: filters_params

    # respond_to do |format|
    #   format.js { render layout: false }
    # end
  end

  def filters_params
    params.permit(:category_id, :currency_id, :city_id, :experience_id)
  end

  private

  def current_page
    request&.referer || root_path
  end
end
