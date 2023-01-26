# frozen_string_literal: true

require 'rails_helper'

describe Hire::ResponsePolicy do
  subject { described_class.new(user, response) }

  let(:response) { create(:response) }

  describe 'being a employer' do
    context 'as vacancy author' do
      let(:user) { response.vacancy.employer }

      it do
        expect(subject).to permit_actions(%i[show])
      end
    end

    context 'as not an author' do
      let!(:user) { create(:employer) }

      it { is_expected.to forbid_actions(%i[show]) }
    end
  end

  context 'being a guest' do
    let!(:user) { nil }

    it { is_expected.to forbid_actions([:show]) }
  end
end
