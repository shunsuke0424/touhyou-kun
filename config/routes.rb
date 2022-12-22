Rails.application.routes.draw do
  post "user_keywords/:keyword_id/create" => "user_keywords#create"
  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get "users/index" => "users#index"
  get "users/ranking" => "users#index"
  get "users/:id" => "users#show"
  post "votes/:keyword_id/:voter_id/:voted_id/create" => "votes#create"
  post "votes/:keyword_id/:voter_id/:voted_id/destroy" => "votes#destroy"
  post "login" => "users#login"
  post "logout" => "users#logout"
  get "login" => "users#login_form"

  get "/" => "home#top"
  get "about" => "home#about"
end

