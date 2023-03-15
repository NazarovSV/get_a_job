# frozen_string_literal: true

class SearchesController < ApplicationController
  before
  def index
    # return redirect_to current_page, alert: t('.empty') if params['request'].blank? && filters_params.empty?

    #@vacancies = Vacancy.published.where(filters_params).search(params['request'])
    @vacancies = Vacancy.look keywords: params['request'], filters: filters_params
    render :index
  end

  # def query_params
  #   params.permit(:request, :category_id, :currency_id, :city_id, :experience_id)
  # end

  def filters_params
    params.permit(:category_id, :currency_id, :city_id, :experience_id).to_h.compact
  end

  private

  def current_page
    request&.referer || root_path
  end
end
