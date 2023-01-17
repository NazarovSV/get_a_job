# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResponsePolicy, type: :policy do
  subject { described_class.new(user, response) }

  let(:response) { create(:response) }
  let(:user) { Employee.new }

  describe 'being a employee' do
    context 'as response author' do
      let(:user) { response.employee }

      it { is_expected.to permit_new_and_create_actions }
    end

    # context 'as not an author' do
    #   let!(:user) { create(:employer) }
    #
    #   it { is_expected.to forbid_actions(%i[show update edit]) }
    # end
  end
end
