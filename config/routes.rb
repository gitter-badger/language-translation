Rails.application.routes.draw do

  devise_for :users, ActiveAdmin::Devise.config, controllers: { registrations: "registrations" }
  ActiveAdmin.routes(self)

  # :path_prefix - to customise routes
  # :controllers - to override the devise default - 
  #  - for admin to edit the user table records other than username or password without knowing the password.

  resources :users, path: :members

  resources :installations do
    resources :sites
  end

  resources :sites do
    resources :volunteers
    resources :contributors
  end

  resources :languages do
    resources :articles
  end

  resources :articles

  # You can have the root of your site routed with "root"
   root 'welcome#index'
end
