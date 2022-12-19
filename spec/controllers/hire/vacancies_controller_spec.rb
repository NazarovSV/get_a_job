# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hire::VacanciesController, type: :controller do
  describe 'POST #create' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, employer:) }

    before { login_employer(employer) }

    context 'with valid attributes' do
      it 'saves a new vacancy in the database' do
        expect { post :create, params: { vacancy: attributes_for(:vacancy) } }.to change(Vacancy, :count).by(1)
      end

      it 'redirects to created vacancy' do
        post :create, params: { vacancy: attributes_for(:vacancy) }

        expect(response).to redirect_to hire_vacancy_path(id: assigns(:vacancy).id)
        expect(flash[:notice]).to match('Your vacancy successfully created.')
      end
    end
  end

  describe 'GET #new' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, employer:) }

    before { login_employer(employer) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, employer:) }

    before { login_employer(employer) }

    it 'renders show view' do
      get :show, params: { id: vacancy }
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    let!(:employer) { create(:employer) }
    let!(:vacancies) { create_list(:vacancy, 10, employer:) }

    before do
      login_employer(employer)
      get :index
    end

    it 'populates an array of all vacancies' do
      expect(assigns(:vacancies)).to match_array(vacancies)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
