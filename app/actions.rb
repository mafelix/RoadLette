require 'pry'
include Math
# Homepage (Root path)
helpers do

  # def calculate_destination    #(starting_lat, starting_long)
  #   @EARTH_RADIUS = 6371   #km
  #   @R = @EARTH_RADIUS
  #   @d = @total_distance
    
  #   distance = 300

  #   @destination_array = []
  #   starting_lat = radians(49.2820150) #lighthouse labs location
  #   starting_long = radians(-123.1082410)
  #   #radians 
    
  #   @direction = (rand(0..360))

  #   @end_latitude = Math.asin(Math.sin(starting_lat)*Math.cos(distance/@R)+ Math.cos(starting_lat)*Math.sin(distance/@R)*Math.cos(@direction))
  #   @end_longitude = starting_long + Math.atan2(Math.sin(@direction)*Math.sin(distance/@R)*Math.cos(starting_lat), Math.cos(distance/@R)-Math.sin(starting_lat)*Math.sin(@end_latitude))


  #   @destination_array << degree(@end_latitude)
  #   @destination_array << degree(@end_longitude)
  # end

  def calculate_destination
    @destination_array=[]
    lat1 = radians(49.2820150) # starting point's latitude (in radians)
    lon1 = radians(-123.1082410) # starting point's longitude (in radians)
    brng = rand(360).to_f   # bearing (in radians)
    d = 250.8     # distance to travel in km
    @r = 6371.0    # earth's radius in km

    lat2 = Math.asin( Math.sin(lat1)*Math.cos(d/@r) + 
    Math.cos(lat1)*Math.sin(d/@r)*Math.cos(brng) )
    # => 0.9227260710962849                  

    lon2 = lon1 + Math.atan2(Math.sin(brng)*Math.sin(d/@r)*Math.cos(lat1), 
     Math.cos(d/@r)-Math.sin(lat1)*Math.sin(lat2))
    # => 0.0497295729068199      
    @lat1 = 49.2820150
    @long1 = -123.1082410
    lat2 = degree(lat2)
    lon2 = degree(lon2)
    @destination_array << lat2
    @destination_array << lon2
  end

  def travel_distance
    page = HTTParty.get('http://www.gasbuddy.com/')
    @parse_page = Nokogiri::HTML(page)
    @average_gas_price = @parse_page.css('.gb-price-lg')[0].children[0].to_s.to_f
    @total_distance = @income/@average_gas_price
  end

  # def login_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  # end

  def radians(degree)
    (degree*PI)/180
  end

  def degree(radian)
    (radian*180)/PI
  end
end

enable :sessions


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
  calculate_destination
  @end_lat = @destination_array[0]
  @end_long = @destination_array[1]
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

post '/users/signin' do
  @user = User.find_by(
    name: params[:name],
    password: params[:password]
    )
  if @user.password == params[:password] 
    session[:user_id] = @user.id
    redirect '/'
  else
    erb :'/users/signin'
  end
end


