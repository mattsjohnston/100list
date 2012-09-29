App::Application.routes.draw do

  get   '/todos/user/:user_id'      => 'todos#index_by_user'

  resources :todos
  resources :users
  root to: 'todos#index'
end
