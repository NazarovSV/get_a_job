# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hire::VacanciesController, type: :controller do
  describe 'POST #create' do
    let!(:employer) { create(:employer) }
    let(:vacancy) { create(:vacancy, employer:) }

    before { login_employer(employer) }

    context 'with valid attributes' do
      it 'saves a new vacancy in the database' do
        expect {
          post :create, params: { vacancy: attributes_for(:vacancy), country: 'Russia' }
        }.to change(Vacancy, :count).by(1)
         .and change(Country, :count).by(1)
         .and change(Location, :count).by(1)
      end

      it 'redirects to created vacancy' do
        post :create, params: { vacancy: attributes_for(:vacancy), country: '' }

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

  describe 'PATCH #publish' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, employer:) }

    describe 'as author' do
      before { login_employer(vacancy.employer) }

      it 'change vacancy`s state' do
        patch :publish, params: { id: vacancy }, format: :js
        vacancy.reload
        expect(vacancy).to have_state(:published)
      end

      it 'render publish template' do
        patch :publish, params: { id: vacancy }, format: :js
        expect(response).to render_template :publish
      end
    end

    describe 'as another employer' do
      before { login_employer(create(:employer)) }

      it 'fails with publish' do
        expect { patch :publish, params: { id: vacancy }, format: :js }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    describe 'as guest' do
      it 'vacancy`s state not changed' do
        patch :publish, params: { id: vacancy }, format: :js
        vacancy.reload
        expect(vacancy).to have_state(:drafted)
      end

      it 'not render publish template' do
        patch :publish, params: { id: vacancy }, format: :js
        expect(response).not_to render_template :publish
      end
    end
  end

  describe 'PATCH #archive' do
    let!(:employer) { create(:employer) }
    let!(:vacancy) { create(:vacancy, :published, employer:) }

    describe 'as author' do
      before { login_employer(vacancy.employer) }

      it 'change vacancy`s state' do
        patch :archive, params: { id: vacancy }, format: :js
        vacancy.reload
        expect(vacancy).to have_state(:archived)
      end

      it 'render archive template' do
        patch :archive, params: { id: vacancy }, format: :js
        expect(response).to render_template :archive
      end
    end

    describe 'as another employer' do
      before { login_employer(create(:employer)) }

      it 'fails with archive' do
        expect { patch :archive, params: { id: vacancy }, format: :js }.to raise_error(Pundit::NotAuthorizedError)
      end
    end

    describe 'as guest' do
      it 'vacancy`s state not changed' do
        patch :archive, params: { id: vacancy }, format: :js
        vacancy.reload
        expect(vacancy).to have_state(:published)
      end

      it 'not render archive template' do
        patch :archive, params: { id: vacancy }, format: :js
        expect(response).not_to render_template :archive
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'as author' do
      let!(:employer) { create(:employer) }

      describe 'drafted vacancy' do
        let!(:vacancy) { create(:vacancy, employer:) }

        before { login_employer(vacancy.employer) }

        it 'destroy vacancy' do
          expect { delete :destroy, params: { id: vacancy }, format: :js }.to change(Vacancy, :count).by(-1)
        end

        it 'render destroy view' do
          delete :destroy, params: { id: vacancy }, format: :js

          expect(response).to render_template :destroy
          expect(flash[:notice]).to match('Your vacancy successfully deleted.')
        end

        it 'redirect to hire index view' do
          delete :destroy, params: { id: vacancy }

          expect(response).to redirect_to hire_vacancies_path
          expect(flash[:notice]).to match('Your vacancy successfully deleted.')
        end
      end

      describe 'published vacancy' do
        let!(:vacancy) { create(:vacancy, :published, employer:) }

        before { login_employer(vacancy.employer) }

        it 'destroy vacancy' do
          expect { delete :destroy, params: { id: vacancy }, format: :js }.not_to change(Vacancy, :count)
        end

        it 'not render destroy view' do
          delete :destroy, params: { id: vacancy }, format: :js

          expect(response).to render_template :destroy
          expect(flash[:alert]).to match('Vacancy is not drafted. Can`t delete this vacancy!')
        end
      end

      describe 'archived vacancy' do
        let!(:vacancy) { create(:vacancy, :archived, employer:) }

        before { login_employer(vacancy.employer) }

        it 'destroy vacancy' do
          expect { delete :destroy, params: { id: vacancy }, format: :js }.not_to change(Vacancy, :count)
        end

        it 'not render destroy view' do
          delete :destroy, params: { id: vacancy }, format: :js

          expect(response).to render_template :destroy
          expect(flash[:alert]).to match('Vacancy is not drafted. Can`t delete this vacancy!')
        end
      end
    end

    describe 'as another user' do
      let!(:vacancy) { create(:vacancy) }

      before { login_employer(create(:employer)) }

      it 'can`t destroy vacancy' do
        expect { delete :destroy, params: { id: vacancy }, format: :js }.to raise_error(Pundit::NotAuthorizedError)
      end
    end
  end
end
