# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    return redirect_to current_page, alert: t('.empty') if params['request'].blank?

    @vacancies = Vacancy.published.search(params['request'])
    render :index
  end

  def query_params
    params.permit(:request)
  end

  private

  def current_page
    request&.referer || root_path
  end
end
