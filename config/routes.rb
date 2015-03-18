CCWebApp::Application.routes.draw do

  # - Subscriptions -
  get "subscriptions/new"
  post "subscriptions/create_group"

  resources :orders

  devise_for :users, :controllers => {:sessions => "sessions", :confirmations => 'users', :passwords => "passwords"}
  resources :home

  match '/subscription' => 'subscribe#new', :as => 'subscription'

  resources :subscribe do
    get 'edit_billing_information'
    get 'providers'
    post 'providers'
    collection do
      get 'edit_billing_information'
      get 'billing_information'
      post 'create_billing_info'
      put 'update_billing_info'
      get 'checkout_confirmation'
    end
  end

  match 'reset_password/:id' => "admin/home#reset_password", :as => :reset_password
  match 'billing' => "activities#billing"
  namespace :admin do
    resources :home
  end

  resources :physician_groups, :path => 'groups' do
    post 'change_agency', :on => :collection
  end

  resources :physicians do
    get :photo
    get :change_billing_agency, :on => :collection
    post :upload
  end

  resources :providers


  resources :billing_agencies, :path => 'billing/agencies' do
    get 'profile'
    collection do
      get 'change_billing_agency'
      post 'search'
      post 'report'
      get 'history'
      post 'history'
      get 'physicians'
    end
  end

  resources :agency_employees, :path => 'agency/employees'

  resources :superbills do
    get :autocomplete_cpt_group_name, :on => :collection
    get :autocomplete_icd_description, :on => :collection
    get :autocomplete_cpt_code, :on => :collection
    get :add, :on => :collection
  end

  resources :referring_physicians, :path => 'referring/physicians'
  resources :facilities
  resources :activities do
    get :history, :on => :collection
  end
  resources :patients

  resources :capture_codes, :as => :encounters do
    get :autocomplete_icd_description, :on => :collection
    get :icd, :on => :collection
  end

  resources :notes

  resources :reports do
    get :autocomplete_physician_name, :on => :collection
    get :referral_volume,  :on => :collection
    post :referral_volume_report, :on => :collection
    get :list, :on => :collection
    post :generate, :on => :collection
  end

  match '/auth' => 'home#client_authentication', :as => 'http_auth', :method => :post
  match '/hm11' => 'home#index'
  match '/unsubscribe/:email' => 'home#unsubscribe'
  #match '/password' => 'home#forgot_password', :as => 'http_auth', :method => :post
  match '/pin' => 'home#set_pin', :as => 'http_auth', :method => :post

  match '/store_pin' => 'services#store_pin', :method => :post
  match '/forgot_pin' => 'services#forgot_pin', :method => :post
  match '/forgot_password' => 'services#forgot_password', :method => :post
  match '/superbill_pull' => 'services#superbill_pull', :method => :post

  root :to => "home#index"

  match ':controller(/:action(/:id(.:format)))'

  # - Searches -
  post '/search/npi' => 'searches#npi', :as => :npi_search

end
