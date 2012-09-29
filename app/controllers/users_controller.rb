class UsersController < ApplicationController
  respond_to :html, :json  

  def create
    respond_with User.create params[:user]
  end

  def index
    respond_with @users = User.all
  end

  # def update
  #   respond_with User.find(params[:id]).update_attributes params[:user]
  # end

  # def destroy
  #   respond_with User.find(params[:id]).destroy
  # end

end