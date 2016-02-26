require 'pry'
enable :sessions
# Homepage (Root path)

# helpers do
#   def current_user
#     @current_user ||= User.find(session[:user_id]) if session[:user_id]
#   end
# end

get '/' do
  erb :index
end

post '/results/index' do
  @search = Search.new(
  price: params[:price],
  days: params[:days]
)
  redirect '/results/index'
end

get '/results/index' do
  @address = 'Whistler,+BC'
  erb :'/results/index'
end

get '/users/signup' do
  erb :'users/signup'
end

post '/users/signup' do
  @user = User.new(
    name: params[:name],
    password: params[:password]
    )
  if @user.save
    redirect '/'
  else
    erb :'users/signup'
  end
end

get '/users/signin' do
  erb :'users/signin'
end

# get '/users/signin' do
#   @user = User.find_by(
#     name: params[:name],
#     password: params[:password]
#     )
#   if @user 
#     session[:user_id] = @user.id
#     redirect '/'
#   else
#     erb :'/users/signin'
#   end
# end



