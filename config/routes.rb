Rails.application.routes.draw do
  resources :locations
  resources :invites
  resources :users
  resources :messages

  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'register'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "profile" => "users#show"
  root to: "users#index"
end
