require 'pry'
# Homepage (Root path)
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


