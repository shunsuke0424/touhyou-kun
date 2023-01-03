Rails.application.routes.draw do
  # user
  post "users/create" => "users#create"
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
  post "groups/all_create/:id_token" => "groups#all_create"
  get "groups/index" => "groups#index"
  get "groups/:id_token" => "groups#show"
  get "create_group" => "groups#create_form"
  get "join_group" => "groups#join_form"
  get "/" => "groups#top"

  # vote
  post "votes/:keyword_id/:voter_id/:voted_id/create" => "votes#create"
  post "votes/:keyword_id/:voter_id/:voted_id/destroy" => "votes#destroy"

  # like
  post "likes/:liked_user_id/create" => "likes#create"
  post "likes/:liked_user_id/destroy" => "likes#destroy"

  # home
  get "about" => "home#about"
end

