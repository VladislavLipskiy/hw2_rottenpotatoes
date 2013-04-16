class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    @all_ratings = Movie.possible_ratings
    
    args = {}
    if !params.has_key?(:ratings) and session.has_key?(:ratings)
      hash = Hash[session[:ratings].map {|x| [x, 1]}]
      args[:ratings] = hash
    end
    
    if !params.has_key?(:sortBy) and session.has_key?(:sortBy)
      args[:sortBy] = session[:sortBy]
    end
    
    if !args.empty?
      redirect_to movies_path(args)
    end
    
    params.has_key?(:ratings) ? 
    Proc.new {
      @selected_ratings = params[:ratings].empty? ? session[:ratings] : params[:ratings].keys
      session[:ratings] = @selected_ratings
    }.call
    : Proc.new {
      session.has_key?(:ratings) ? @selected_ratings = session[:ratings] :
      Proc.new {
        @selected_ratings = @all_ratings
        session[:ratings] = @selected_ratings
      }.call
    }.call
    
    args = {}
    args[:conditions] = ["rating IN (?)", @selected_ratings]
    #params[:ratings].keys : @all_ratings
    

    #if params.has_key?(:ratings) do
    #  keys = params[:ratings].keys
    #  args[:conditions] = ["rating = ?", keys]
    #end
    
  
    @movies, @title_class, @date_class = case params[:sortBy]
    when "title"
      [
        @movies = Movie.order("title ASC").all(args),
        @title_class = "hilite",
        @date_class = "",
        session[:sortBy] = params[:sortBy]
      ]
    when "release_date"
      [
        @movies = Movie.order("release_date ASC").all(args),
        @title_class = "",
        @date_class = "hilite",
        session[:sortBy] = params[:sortBy]
      ]
    else
      [
        @movies = session.has_key?(:sortBy) ? Movie.order(session[:sortBy]).all(args) : Movie.all(args),
        @title_class = "",
        @date_class = ""
      ]
    end
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
