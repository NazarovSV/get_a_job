# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :employers
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'vacancies#index'

  resources :vacancies, only: %i[create index new show update]
end
