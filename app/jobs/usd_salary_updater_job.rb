class USDSalaryUpdaterJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    USDSalaryService.new.call
  end
end
