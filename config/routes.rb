Rails.application.routes.draw do
  devise_for :users
  root 'posts#index'
  resources :posts do
    resources :comments do
      post 'accept', :on => :member
      post 'decline', :on => :member
    end
  end
end
