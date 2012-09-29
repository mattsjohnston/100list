class TodosController < ApplicationController
  respond_to :html, :json

  def create
    respond_with Todo.create params[:todo]
  end

  def index_by_user
    respond_with Todo.where user_id: params[:user_id]
  end

  def index
    respond_with @todos = Todo.all
  end

  def update
    respond_with Todo.find(params[:id]).update_attributes params[:todo]
  end

  def destroy
    respond_with Todo.find(params[:id]).destroy
  end

end
