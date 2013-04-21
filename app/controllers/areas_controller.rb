class AreasController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_filter :admin_user,     only: :destroy
  
  def index
    @areas = Area.paginate(page: params[:page])
  end
  
  def show
    @area = Area.find(params[:id])
  end
  
  def new
    @area = Area.new
  end
  
  def create
    @area = Area.new(params[:area])
    if @area.save
      flash[:success] = "Create new area."
      redirect_to @area
    else
      render "new"
    end      
  end
  
  def edit
    @area = Area.find(params[:id])
  end
  
  def update
    @area = Area.find(params[:id])
    if @area.update_attributes(params[:area])
      flash[:success] = "Area updated"
      redirect_to @area
    else
      render 'edit'
    end
  end  
  
  def destroy
    Area.find(params[:id]).destroy
    flash[:success] = "Area destroyed"
    redirect_to areas_path
  end
end
