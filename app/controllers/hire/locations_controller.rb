# frozen_string_literal: true

class Hire::LocationsController < Hire::BaseController
  skip_after_action :verify_authorized
  
  def search
    search_letters = params[:search_letters]
    @locations = Location.first_five_address_contains(search_letters:)
  end
end
