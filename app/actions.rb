require 'pry'
include Math
# Homepage (Root path)
helpers do

  def calculate_destination    #(starting_lat, starting_long)
    @EARTH_RADIUS = 6371   #km
    @R = @EARTH_RADIUS
    @d = @total_distance
    
    distance = 300



    @destination_array = []
    starting_lat = 49.2820150 #lighthouse labs location
    starting_long = -123.1082410
    @direction = rand(0..360)

    @end_latitude = Math.asin(Math.sin(starting_lat)*Math.cos(distance/@R)+ Math.cos(starting_lat)*Math.sin(distance/@R)*Math.cos(@direction))
    @end_longitude = starting_long + Math.atan2(Math.sin(@direction)*Math.sin(distance/@R)*Math.cos(starting_lat), Math.cos(distance/@R)-Math.sin(starting_lat)*Math.sin(@end_latitude))
    @destination_array << @end_latitude
    @destination_array << @end_longitude
    puts "#{@destination_array} and #{@direction}"
    binding.pry
    puts ""
  end


  def travel_distance
    page = HTTParty.get('http://www.gasbuddy.com/')
    @parse_page = Nokogiri::HTML(page)
    @average_gas_price = @parse_page.css('.gb-price-lg')[0].children[0].to_s.to_f
    @total_distance = @income/@average_gas_price
  end


end

enable :sessions
# Homepage (Root path)

# helpers do
#   def current_user
#     @current_user ||= User.find(session[:user_id]) if session[:user_id]
#   end
# end
get '/' do
  calculate_destination
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


