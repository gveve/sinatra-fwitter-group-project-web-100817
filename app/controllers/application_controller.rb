require './config/environment'
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    # @tweets = Tweet.all
    # @users = User.all
    # erb :index
  end

  get '/tweets/new' do
    erb :create_tweet
  end

  get '/tweets' do
    # binding.pry
    if session[:username]
      erb :index
    else
      redirect to "/login"
    end
  end

  post '/tweets' do
    @tweet = Tweet.create(content: params[:content], user: params[:user])
    reditect to "/tweets/#{@tweet.id}"
  end

  get '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    erb :show_tweet
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    erb :edit_tweet
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.content = params[:id]
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.delete
    # erb :?????--
  end

  get '/signup' do
    erb :sign_up
  end

  post '/signup' do
    # binding.pry
    @user = User.create(username: params[:username], email: params[:email], password: params[:password])
    # session[:username] = @user.username
    redirect to "/tweets"
  end

  get '/login' do
    erb :login
  end

  post '/login' do
     user = User.find_by(:username => params[:username])
     if user
        session[:username] = user.username
        redirect "/tweets"
     else
        redirect "/signup"
     end
  end

  get '/logout' do
    session.destroy
    redirect '/login'
  end

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  helpers do
    def logged_in?
      session[:username]
    end

    def current_user
      User.find(sessions[:username])
    end
  end

end
