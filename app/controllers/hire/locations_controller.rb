# frozen_string_literal: true

module Hire
  class LocationsController < Hire::BaseController
    skip_after_action :verify_authorized

    def search
      #pry.byebug
      @locations = Location.first_five_address_contains(letters: params[:letters])
      render json: @locations
    end

    private

    def letters_params
      params.require(:letters).permit(:letters)
    end
  end
end
