# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsdSalaryUpdaterJob, type: :job do
  it 'calls USDSalaryService#call' do
    allow(UsdSalaryService).to receive(:call)
    described_class.perform_now
    expect(UsdSalaryService).to have_received(:call)
  end
end
