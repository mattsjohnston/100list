class ApplicationController < ActionController::Base
  protect_from_forgery
  lock actions: ["todos#create", "todos#update", "todos#destroy", "users#create"]
end