# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hire::ResponsesController, type: :controller do
  describe 'GET #index' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, :published, employer:) }
    let!(:responses) { create_list(:response, 3, vacancy:) }

    describe 'as author of vacancy' do
      before do
        login_employer(vacancy.employer)
        get :index, params: { vacancy_id: vacancy }
      end

      it 'return all responses of vacancy' do
        expect(assigns(:responses)).to match_array(responses)
      end

      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    describe 'as another employer' do
      before do
        login_employer(create(:employer))
      end

      it 'fails with index' do
        expect { get :index, params: { vacancy_id: vacancy } }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
