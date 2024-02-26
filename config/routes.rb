# frozen_string_literal: true

Rails.application.routes.draw do
  resources :validation_requests, only: %i[index]

  with_options only: %i[show edit update] do
    resources :description_change_validation_requests
    resources :replacement_document_validation_requests
    resources :additional_document_validation_requests
    resources :other_change_validation_requests
    resources :fee_change_validation_requests
    resources :red_line_boundary_change_validation_requests
    resources :ownership_certificate_validation_requests
    resources :pre_commencement_condition_validation_requests
  end

  resources :planning_applications, only: %i[show] do
    resource :site_notices, only: %i[] do
      get :download
    end

    resources :neighbour_responses, only: %i[new create] do
      get :start, :thank_you, on: :collection
    end

    resources :ownership_certificates, except: %i[destroy] do
      resources :land_owners, only: %i[new create]
      post :submit
      get :thank_you
    end
  end

  resources :os_places_api, only: %i[index]

  controller "pages" do
    get :accessibility
  end

  get :healthcheck, to: proc { [200, {}, %w[OK]] }
end
