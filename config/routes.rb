Rails.application.routes.draw do
#  get 'posts/index'
#  get 'posts/show'
#  get 'posts/new'
#  get 'posts/edit'
#  get 'welcome/index'
#  get 'welcome/about'

  resources :topics do
    resources :posts, except: [:index]
  end
  resources :users, only: [:new, :create, :display]

  resources :sessions, only: [:new, :create, :destroy]

  post 'users/confirm' => 'users#confirm'

  get 'about' => 'welcome#about'

  root 'welcome#index'

end
