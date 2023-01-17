# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SearchesController, type: :controller do
  describe 'GET #index' do
    let!(:employer) { create(:employer) }
    let!(:vacancies) do
      [
        create(:vacancy, :published, title: 'title published one'),
        create(:vacancy, :published, title: 'title published second'),
        create(:vacancy, title: 'title drafted'),
        create(:vacancy, :archived, title: 'title archived')
      ]
    end

    describe 'valid request' do
      before { get :index, params: { request: vacancies.first.title } }

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
      it 'renders index view' do
        get :index, params: { request: nil }

        expect(response).to redirect_to :root
      end
    end
  end
end
