require 'pry'
# Homepage (Root path)
get '/' do
  @address = "Whistler,+BC"
  erb :index
end

post '/results/index' do
  @search = Search.new(
  price: params[:price],
  days: params[:days]
)
  redirect '/results/index'
end



