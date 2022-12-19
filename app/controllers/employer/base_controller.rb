# frozen_string_literal: true

module Employer
  class BaseController < ApplicationController
    layout 'employer'

    before_action :authenticate_employer!

    def current_user
      current_employer
    end
  end
end
