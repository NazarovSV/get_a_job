# frozen_string_literal: true

module Hire
  class BaseController < ApplicationController
    include Pundit::Authorization

    layout 'hire'

    before_action :authenticate_employer!
    after_action :verify_authorized, except: :index

    alias current_user current_employer
  end
end
