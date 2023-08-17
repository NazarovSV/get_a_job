# frozen_string_literal: true

class UsdSalaryUpdaterJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    UsdSalaryService.call
  end
end
