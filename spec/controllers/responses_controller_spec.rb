# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResponsesController, type: :controller do
  let!(:employee) { create(:employee) }
  let!(:vacancy) { create(:vacancy, :published) }

  describe 'GET #new' do
    before do
      login_employee(employee)
      get :new, params: { vacancy_id: vacancy }
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before do
      login_employee(employee)
    end

    context 'valid attribute' do
      it 'saves new response in DB' do
        expect do
          post :create, params:  { response: attributes_for(:response), vacancy_id: vacancy }
        end.to change(vacancy.responses, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { response: attributes_for(:response), vacancy_id: vacancy }
        expect(response).to redirect_to action: :show, id: assigns(:response).id
      end
    end

    context 'invalid attributes' do
      it 'does not save new response in DB' do
        expect do
          post :create, params:  { response: attributes_for(:response, :invalid), vacancy_id: vacancy }
        end.not_to change(vacancy.responses, :count)
      end

      it 'render new view' do
        post :create, params: { response: attributes_for(:response, :invalid), vacancy_id: vacancy }
        expect(response).to render_template :new
      end
    end
  end
end
