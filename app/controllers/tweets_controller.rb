class TweetsController < ApplicationController

get '/tweets' do
    if session[:id]
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end   
  end

  get '/tweets/new' do
    if session[:id]
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:content] == ""
      redirect to "/tweets/new"
    else
      user = User.find_by_id(session[:id])
      @tweet = Tweet.create(:content => params[:content], :user_id => user.id)
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  get '/tweets/:id' do 
    if session[:id]
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else 
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if session[:id] 
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == session[:id]
       erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do 
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id/delete' do 
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == session[:id]
        @tweet.delete
        redirect to '/tweets'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end
end 