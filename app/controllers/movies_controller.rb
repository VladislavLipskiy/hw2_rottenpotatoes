class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    @all_ratings = Movie.possible_ratings
    
    args = {}
    params.has_key?(:ratings) ? 
    Proc.new {
      keys = params[:ratings].keys
      @selected_ratings = keys
      args[:conditions] = ["rating IN (?)", keys]
    }.call
    : Proc.new {
      @selected_ratings = @all_ratings
    }.call
    #params[:ratings].keys : @all_ratings
    

    #if params.has_key?(:ratings) do
    #  keys = params[:ratings].keys
    #  args[:conditions] = ["rating = ?", keys]
    #end
  
    args, @title_class, @date_class = case params[:sortBy]
    when "title"
      [
        args[:order] = "title ASC",
        #@movies = Movie.all(args),
        @title_class = "hilite",
        @date_class = ""
      ]
    when "release_date"
      [
        args[:order] = "release_date ASC",
        #@movies = Movie.all(args),
        @title_class = "",
        @date_class = "hilite"
      ]
    else
      [
        args,
        #@movies = Movie.all,
        @title_class = "",
        @date_class = ""
      ]
    end
    @movies = Movie.all(args)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
