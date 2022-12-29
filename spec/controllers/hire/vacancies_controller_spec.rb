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

    before do
      login_employer(employer)
      get :new
    end

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

  describe 'PATCH #update' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, employer:) }
    let!(:second_vacancy) { create(:vacancy, employer: create(:employer)) }

    context 'sign in as vacancy author' do
      before { login_employer(vacancy.employer) }

      context 'with valid attributes' do
        before { patch :update, params: { id: vacancy, vacancy: { description: 'New description' } } }

        it 'changes vacancy attributes' do
          vacancy.reload

          expect(vacancy.description).to eq 'New description'
        end

        it 'renders show view' do
          expect(response).to redirect_to hire_vacancy_path(id: vacancy.id)
        end
      end

      context 'with invalid attributes' do
        it 'does not change vacancy attributes' do
          expect do
            patch :update, params: { id: vacancy, vacancy: { description: nil } }
          end.not_to change(vacancy, :description)
        end

        it 'renders update view' do
          patch :update, params: { id: vacancy, vacancy: { description: nil } }
          expect(response).to render_template :edit
        end
      end
    end

    context 'trying to change other employers vacancy' do
      it 'does not change answer attributes' do
        patch :update, params: { id: second_vacancy, vacancy: { description: 'New description' } }

        second_vacancy.reload

        expect(second_vacancy.description).not_to eq 'New description'
      end
    end
  end
end
