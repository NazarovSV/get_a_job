# frozen_string_literal: true

require 'rails_helper'

describe Hire::VacancyPolicy do
  subject { described_class.new(user, vacancy) }

  let(:vacancy) { create(:vacancy) }

  describe 'being a employer' do
    context 'as vacancy author' do
      let(:user) { vacancy.employer }

      it do
        expect(subject).to permit_actions(%i[archive show update edit publish])
      end

      it { is_expected.to permit_new_and_create_actions }
    end

    context 'as not an author' do
      let!(:user) { create(:employer) }

      it { is_expected.to forbid_actions(%i[show update edit]) }
    end
  end

  context 'being a guest' do
    let!(:user) { nil }

    it { is_expected.to forbid_actions(%i[show update edit create new]) }
  end
end
