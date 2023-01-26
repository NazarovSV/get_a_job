# frozen_string_literal: true

module Hire
  class ResponsesController < Hire::BaseController
    before_action :load_vacancy

    def index
      @responses = @vacancy.responses
    end

    private

    def load_vacancy
      @vacancy = Vacancy.find(params[:vacancy_id])
      authorize [:hire, @vacancy], :list_of_response?
    end
  end
end