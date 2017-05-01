Rails.application.routes.draw do

scope 'api' do
  scope 'v1' do
    match "*all", :controller => "application", :action =>"cors_preflight_check", :via => :options
    resources :searches, only: [:index, :create]
    resources :users, only: :create
    resources :sessions, only: :create
  end
end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
