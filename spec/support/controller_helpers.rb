# frozen_string_literal: true

module ControllerHelpers
  def login_employer(employer)
    @request.env['devise.mapping'] = Devise.mappings[:employer]
    sign_in employer
  end
end
