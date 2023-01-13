# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do
  describe 'GET #show' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, employer:) }

    it 'renders show view' do
      get :show, params: { id: vacancy }
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    let!(:employer) { create(:employer) }
    let!(:vacancies) { create(:vacancy, :published, employer:) }

    before { get :index }

    it 'populates an array of all vacancies' do
      expect(assigns(:vacancies)).to match_array(vacancies)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
