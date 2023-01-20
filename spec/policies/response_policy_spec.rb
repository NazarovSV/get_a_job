# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Candidate::ResponsePolicy, type: :policy do
  subject { described_class.new(user, response) }

  let(:response) { create(:response) }
  let(:user) { Employee.new }

  describe 'being a employee' do
    context 'as response author' do
      let(:user) { response.employee }

      it do
        expect(subject).to permit_actions(:show)
      end

      it { is_expected.to permit_new_and_create_actions }
    end

    context 'as another user' do
      let!(:user) { create(:employee) }

      it { is_expected.to forbid_actions(%i[show]) }
    end
  end

  context 'being a guest' do
    let!(:user) { nil }

    it { is_expected.to forbid_actions(%i[show]) }
  end
end
