# frozen_string_literal: true

Rails.application.routes.draw do
  get 'responses/index'
  devise_for :employees
  devise_for :employers

  root to: 'vacancies#index'

  namespace :hire do
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
end
