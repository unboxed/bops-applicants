Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :change_requests, only: %i[index]
  resources :description_change_requests, only: %i[show edit update]
  resources :document_change_requests, only: %i[show edit update]
  resources :document_create_requests, only: %i[show edit update]
  resources :red_line_boundary_change_requests, only: %i[show edit update]
  resources :other_change_validation_requests, only: %i[show edit update]
end
