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

get '/results' do
  page = HTTParty.get('http://www.gasbuddy.com/')
  @parse_page = Nokogiri::HTML(page)
  @parse_page = @parse_page.css('.gb-price-lg')[0].children[0].to_s.to_f

  erb :'results/index'
end


#What we need to implement:
# Once given a budget value, need to see how far
# user can drive based on average gas prices..
