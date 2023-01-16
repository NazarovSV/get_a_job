# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    let!(:employer) { create(:employer) }
    let!(:vacancies) { create_list(:vacancy, 10, :published, employer:) }

    before { get :index, params: { request: vacancies.first.title } }

    it "renders index view" do
      expect(response).to render_template :index
    end

    it "200" do
      expect(response).to be_successful
    end

    it "return only first vacancy" do
      expect(assigns(:vacancies)).to eq([vacancies.first])
    end

  end
end
