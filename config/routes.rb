Rails.application.routes.draw do
  # user
  post "users/create" => "users#create"
  post "users/destroy/:id" => "users#destroy"
  get "signup" => "users#new"
  # get "users/index" => "users#index"
  get "users/:id" => "users#show"
  post "login" => "users#login"
  post "logout" => "users#logout"
  # post "create_guest_user" => "users#create_guest_user"
  # get "create_guest_user" => "users#create_guest_user"
  get "login" => "users#login_form"
  get "users/ranking/:id" => "users#ranking"
  get "detail" => "users#detail"

  # group
  post "groups/create" => "groups#create"
  post "groups/join" => "groups#join"
  post "groups/signup_join/:id_token" => "groups#signup_join"
  post "groups/login_join/:id_token" => "groups#login_join"
  get "groups/index" => "groups#index"
  get "groups/:id_token" => "groups#show"
  get "create_group" => "groups#create_form"
  get "join_group" => "groups#join_form"
  get "/signup_join_form/:id_token" => "groups#signup_join_form"
  get "/login_join_form/:id_token" => "groups#login_join_form"
  get "/invite/:id_token" => "groups#invite"
  
  # vote
  post "votes/:keyword_id/:voter_id/:voted_id/create" => "votes#create"
  post "votes/:keyword_id/:voter_id/:voted_id/destroy" => "votes#destroy"

  # like
  post "likes/:liked_user_id/create" => "likes#create"
  post "likes/:liked_user_id/destroy" => "likes#destroy"

  # home
  get "/" => "home#about"
end

