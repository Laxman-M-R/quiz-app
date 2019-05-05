Rails.application.routes.draw do
  
  resources :questions do
  	member do
  		get 'check_answer'
  	end
  end
  root to: 'pages#home'
  get 'users/users_page'
 

  devise_for :users, :controllers => { :registrations => 'registrations'}
  match 'users/:id' => 'users#destroy', :via => :delete, :as => :admin_destroy_user
  resources 'users' do
    member do
      post 'change_user_role'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
