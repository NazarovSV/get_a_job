# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VacancyPolicy, type: :policy do
  let(:user) { User.new }

  subject { described_class }

  permissions :index? do
    it 'grants access any user' do
      expect(subject).to permit(create(:vacancy))
    end
  end

  permissions :show? do
    it 'grants access any user' do
      expect(subject).to permit(create(:vacancy))
    end
  end
end
