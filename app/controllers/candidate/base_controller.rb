# frozen_string_literal: true

module Candidate
  class BaseController < ApplicationController
    include Pundit::Authorization

    before_action :authenticate_employee!
    after_action :verify_authorized

    alias current_user current_employee
  end
end
