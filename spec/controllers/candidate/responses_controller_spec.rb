# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Candidate::ResponsesController, type: :controller do
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

  describe 'GET #show' do
    let!(:vacancy_response) { create(:response, vacancy:) }

    context 'as an author' do
      it 'renders show view' do
        login_employee(vacancy_response.employee)

        get :show, params: { id: vacancy_response }
        expect(response).to render_template :show
      end
    end

    context 'as another user' do
      it 'throw Pundit error' do
        login_employee(employee)

        expect do
          get :show, params: { id: vacancy_response }
        end.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    context 'as a guest' do
      it 'redirect to new_employee_session_path' do
        get :show, params: { id: vacancy_response }

        expect(response).to redirect_to new_employee_session_path
      end
    end
  end

  describe 'POST #create' do
    context 'as an employee' do
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

    context 'as a guest' do
      context 'valid attribute' do
        it 'doesnt saves new response in DB' do
          expect do
            post :create, params: { response: attributes_for(:response), vacancy_id: vacancy }
          end.not_to change(vacancy.responses, :count)
        end
      end
    end
  end
end
