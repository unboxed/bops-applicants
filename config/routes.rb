# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :validation_requests, only: %i[index]
  resources :description_change_validation_requests, only: %i[show edit update]
  resources :replacement_document_validation_requests, only: %i[show edit update]
  resources :additional_document_validation_requests, only: %i[show edit update]
  resources :other_change_validation_requests, only: %i[show edit update]
  resources :red_line_boundary_change_validation_requests, only: %i[show edit update]

  resources :planning_applications, only: %i[show] do
    resources :neighbour_responses, only: %i[new create]
  end

  controller "pages" do
    get :accessibility, action: :accessibility
  end

  get :healthcheck, to: proc { [200, {}, %w[OK]] }
end
