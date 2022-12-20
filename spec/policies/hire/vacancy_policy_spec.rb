require 'rails_helper'

RSpec.describe Hire::VacancyPolicy, type: :policy do
  let!(:employer) { create(:employer) }

  subject { described_class }

  permissions :show?, :edit?, :update? do
    it 'grant access if user is author' do
      expect(subject).to permit(employer, create(:vacancy, employer:))
    end

    it 'not grant access if user is not author' do
      expect(subject).to_not permit(employer, create(:vacancy, employer: create(:employer)))
    end
  end
end
