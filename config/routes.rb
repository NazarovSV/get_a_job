# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'vacancies#index'

  get 'responses/index'
  devise_for :employees
  devise_for :employers

  namespace :hire do
    resources :locations, only: [] do
      get :search, on: :collection
    end

    resources :vacancies, shallow: true do
      resources :responses, only: %i[index show]

      patch :publish, on: :member
      patch :archive, on: :member
    end
  end

  namespace :candidate do
    resources :vacancies, shallow: true do
      resources :responses, only: %i[show new create]
    end
  end

  resources :vacancies, shallow: true, only: %i[index show]
  resources :searches, only: :index
  resources :exchange_rates, only: [:index] do
    get :convert, on: :collection
  end
end
