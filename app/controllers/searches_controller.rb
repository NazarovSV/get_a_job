# frozen_string_literal: true

class SearchesController < ApplicationController
  def index
    return redirect_to :root, alert: t('.empty') if params['request'].blank?

    @vacancies = Vacancy.published.search(params['request'])
    render :index
  end

  def query_params
    params.permit(:request)
  end
end
