# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    @pagy, @vacancies = pagy(SearchService.call(keywords: params['request'], filters: filters_params), items: 1)
  end

  def filters_params
    params.permit(:category_id, :currency_id, :city_id, :experience_id, :salary_min, :salary_max)
  end

  private

  def current_page
    request&.referer || root_path
  end
end
