# frozen_string_literal: true

module Hire
  class ResponsesController < Hire::BaseController
    before_action :load_vacancy, only: :index
    before_action :load_response, only: :show
    def show; end

    def index
      @responses = @vacancy.responses
    end

    private

    def load_vacancy
      @vacancy = Vacancy.find(params[:vacancy_id])
      authorize [:hire, @vacancy], :list_of_response?
    end

    def load_response
      @response = Response.find(params[:id])
      authorize [:hire, @response]
    end
  end
end
