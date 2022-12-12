# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VacanciesController, type: :controller do
  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new vacancy in the database' do
        expect { post :create, params: { vacancy: attributes_for(:vacancy) } }.to change(Vacancy, :count).by(1)
      end

      it 'redirects to created vacancy' do
        post :create, params: { vacancy: attributes_for(:vacancy) }

        expect(response).to redirect_to assigns(:vacancy)
        expect(flash[:notice]).to match('Your vacancy successfully created.')
      end
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #show' do
    let!(:vacancy) { create(:vacancy) }

    it 'renders show view' do
      get :show, params: { id: vacancy }
      expect(response).to render_template :show
    end
  end
end
