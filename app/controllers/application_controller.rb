class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do
    # Render sign up form
    erb :'/registrations/signup'
  end

  post '/registrations' do
    # Handle post request 
    # Gets new user's info from params hash
    # Creates new user, signs them in, redirects
    @user = User.new(name: params[:user]["name"], email: params[:user]["email"], password: params[:user]["password"])
    @user.save
    # Sign user in
    session[:user_id] = @user.id
    
    redirect '/users/home'
  end

  get '/sessions/login' do

    # the line of code below render the view page in app/views/sessions/login.erb
    erb :'sessions/login'
  end

  post '/sessions' do
    @user = User.find_by(email: params[:user][:email], password: params[:user][:password])
    if @user
      session[:user_id] = @user.id
      # puts params
      redirect '/users/home'
    end
    redirect '/sessions/login'
  end

  get '/sessions/logout' do
    # Logging the user out by clearing the session hash
    session.clear
    redirect '/'
  end

  get '/users/home' do
    # Rendering the user's homepage view
    # Finds the current user based on ID value stored in session hash
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end
end
