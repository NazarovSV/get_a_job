# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    let!(:employer) { create(:employer) }
    let!(:category) { create_list(:category, 3) }
    let!(:vacancies) do
      [
        create(:vacancy, :published, title: 'title published one', category: category.first),
        create(:vacancy, :published, title: 'title published second', category: category.second),
        create(:vacancy, title: 'title drafted', category: category.third),
        create(:vacancy, :archived, title: 'title archived', category: category.second)
      ]
    end

    describe 'valid request' do
      before { get :index, params: { request: vacancies.first.title, category_id: category.first }, xhr: true }

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it '200' do
        expect(response).to be_successful
      end

      it 'return only first vacancy' do
        expect(assigns(:vacancies)).to eq([vacancies.first])
      end
    end

    describe 'invalid request' do
      before { get :index, params: { request: 'rertefgdfg' }, xhr: true }

      it 'renders index view' do
        expect(response).to render_template :index
      end

      it '200' do
        expect(response).to be_successful
      end

      it 'return will be empty' do
        expect(assigns(:vacancies)).to be_empty
      end
    end
  end
end
