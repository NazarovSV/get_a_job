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

  describe 'GET #show' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, :published, employer:) }
    let!(:current_response) { create(:response, vacancy:) }

    describe 'as author of vacancy' do
      before do
        login_employer(vacancy.employer)
        get :show, params: { id: current_response }
      end

      it 'return response of vacancy' do
        expect(assigns(:response)).to eq(current_response)
      end

      it 'render show view' do
        expect(response).to render_template :show
      end
    end

    describe 'as another employer' do
      before do
        login_employer(create(:employer))
      end

      it 'fails with show' do
        expect { get :show, params: { id: current_response } }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
