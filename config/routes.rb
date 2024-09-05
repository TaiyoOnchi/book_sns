Rails.application.routes.draw do
  devise_for :users

  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  post "user/search"=>"users#search",as: "search"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  get "new_sort"=>"books#new_sort",as: "new_sort"
  get "rating_sort"=>"books#rating_sort",as: "rating_sort"
  get "book/search"=>"books#search",as: "search_books"
  
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy] do
      resources :chats,only: [:show,:create]
    end
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # get '/search', to: 'searches#search'
  
  resources :groups do
    resource :group_users, only: [:create, :destroy] #子
    resources :events, only: [:new, :create,:show]
  	#get 'complete' => 'events#complete', as: 'complete'
  end
  
  
end
