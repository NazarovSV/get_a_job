# frozen_string_literal: true

class USDSalaryUpdaterJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    USDSalaryService.call
  end
end
