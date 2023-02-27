# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hire::LocationsController, type: :controller do
  render_views

  describe 'GET #search' do
    let!(:vacancy) { create(:vacancy) }

    before do
      login_employer(vacancy.employer)

      get :search, params: { letters: 'Mos' }, format: :json
    end

    it 'return http success' do
      expect(response).to have_http_status(:success)
    end

    it 'return the correct address' do
      expect(response.body).to include('Russia, Moscow, Klimentovskiy Pereulok, 65')
    end
  end
end
