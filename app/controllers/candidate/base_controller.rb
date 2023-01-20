# frozen_string_literal: true

module Candidate
  class BaseController < ApplicationController
    before_action :authenticate_employee!

    alias current_user current_employee
  end
end
