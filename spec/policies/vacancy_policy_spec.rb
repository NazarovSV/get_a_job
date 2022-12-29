# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VacancyPolicy, type: :policy do
  subject { described_class }

  let(:user) { User.new }

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
