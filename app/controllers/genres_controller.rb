class GenresController < ApplicationController
  before_filter :signed_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_filter :admin_user,     only: :destroy

  def index
    @genres = Genre.paginate(page: params[:page])
  end

	def show
		@genre = Genre.find(params[:id])
	end

  def new
  	@genre = Genre.new
  end

  def create
  	@genre = Genre.new(params[:genre])
  	if @genre.save
  		flash[:success] = "Create new genre."
  		redirect_to @genre
  	else
  		render "new"
  	end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update_attributes(params[:genre])
      flash[:success] = "Genre updated"
      redirect_to @genre
    else
      render 'edit'
    end
  end

  def destroy
    Genre.find(params[:id]).destroy
    flash[:success] = "Genre destroyed"
    redirect_to genres_path
  end
end
