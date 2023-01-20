# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :employees
  devise_for :employers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'vacancies#index'

  namespace :hire do
    resources :vacancies, only: %i[create destroy index new show edit update] do
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
