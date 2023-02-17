class Hire::LocationsController < Hire::BaseController
  skip_after_action :verify_authorized

  def search
    request.format = :json
    q = params[:q].downcase
    @locations = Location.where("LOWER(address) LIKE ?", "%#{q}%").pluck(:address).uniq.first(5)
  end
end
