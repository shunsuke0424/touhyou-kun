Rails.application.routes.draw do
  post "users/create" => "users#create"
  get "signup" => "users#new"
  get "/" => "users#index"
  get "users/:id" => "users#show"
  post "votes/:keyword_id/:voter_id/:voted_id/create" => "votes#create"
  post "votes/:keyword_id/:voter_id/:voted_id/destroy" => "votes#destroy"
  post "likes/:liked_user_id/create" => "likes#create"
  post "likes/:liked_user_id/destroy" => "likes#destroy"
  post "login" => "users#login"
  post "logout" => "users#logout"
  get "login" => "users#login_form"
  get "users/ranking/:id" => "users#ranking"

  get "about" => "home#about"
end

