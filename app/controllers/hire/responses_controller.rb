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
    end
  end
end
