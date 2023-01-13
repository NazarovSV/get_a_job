# frozen_string_literal: true

module Hire
  class BaseController < ApplicationController
    layout 'hire'

    before_action :authenticate_employer!

    alias current_user current_employer
  end
end