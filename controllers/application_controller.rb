require_relative "../config/environment"
require_relative "../models/user"
require_relative "../models/item"

class ApplicationController < Sinatra::Base
  
  enable :sessions
  set :session_secret, 'this is a cookie secret'
  
  set :views, "views"
  set :public_folder, "public"

  before do
    if session[:logged_in]
      @user = User.find(session[:user_id])
      @username = @user.username
    end
  end
  
  get "/" do
    erb :index
  end
  
  get "/signup" do
    erb :signup
  end
  
  post "/signup" do
    @user = User.new(:username => params[:username], :password => params[:password], :name => params[:name], :gender => params[:gender], :age => params[:age], :email => params[:email] )
    @user.save
    session[:logged_in] = true
    session[:user_id] = @user.id
    erb :home
  end
  
  get "/login" do
    erb :login
  end

  post "/login" do
    @user = User.find_by_username(params[:username])
    if @user == nil
      session[:logged_in] = false
      erb :login
    else
    if params[:password] == @user.password 
      session[:logged_in] = true
      session[:user_id] = @user.id
      erb :home
    else
      session[:logged_in] = false
      erb :login
    end
    end
  end
  
  get "/logout" do    
    session[:logged_in] = false
    session[:user_id] = -1
    redirect to("/")
  end
  
  get "/home" do
    erb :home
  end
  
  get "/profile" do
    erb :profile
  end
  
  post "/profile" do
    @item = Item.new(:name => params[:name], :description => params[:description], :image => params[:image])
    @item.save
    erb :profile
  end

 
end
