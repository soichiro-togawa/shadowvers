Rails.application.routes.draw do

  get '/' => "users#index"

  get 'users/:id' => "users#new"

  post 'users/create' => "users#create"
  post "users/:id/update" => "users#update"
  
  
  get "users/:id/show" => "users#show"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
