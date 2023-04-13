# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    @pagy, @vacancies = pagy(SearchService.call(keywords: params['request'], filters: filters_params), items: 10)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def filters_params
    params.permit(:employment_id, :currency_id, :city_id, :experience_id, :salary_min, :salary_max, :specialization_id)
  end

  private

  def current_page
    request&.referer || root_path
  end
end
