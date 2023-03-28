# frozen_string_literal: true

require 'rails_helper'

RSpec.describe USDSalaryUpdaterJob, type: :job do
  it 'calls USDSalaryService#call' do
    expect(USDSalaryService).to receive(:call)
    USDSalaryUpdaterJob.perform_now
  end
end
