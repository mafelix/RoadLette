require 'pry'
include Math
# Homepage (Root path)
helpers do

  # def calculate_destination    #(starting_lat, starting_long)
  #   @EARTH_RADIUS = 6371   #km
  #   @R = @EARTH_RADIUS
  #   @d = @total_distance

  # def get_pictures
  #   URL: https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=06b3edd0e485fa8e237ea30fb17c1b50&safe_search=@&format=json&nojsoncallback=1&auth_token=72157664962446491-8e324e4f345430b0&api_sig=d5058ce551bb380499f653434df16bd9
  # end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end


  def calculate_destination
    @destination_array=[]
    lat1 = radians(49.2820150) # starting point's latitude (in radians)
    lon1 = radians(-123.1082410) # starting point's longitude (in radians)
    brng = rand(360).to_f   # bearing (in radians)
    d = 500.8     # distance to travel in km
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

  def travel_distance (price, days)
    page = HTTParty.get('http://www.gasbuddy.com/')
    @parse_page = Nokogiri::HTML(page)
    @average_gas_price = @parse_page.css('.gb-price-lg')[0].children[0].to_s.to_f / 100
    @total_distance = price / @average_gas_price *10
    @total_distance > (days * 800) ? (days * 800) : @total_distance
  end

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
  @search = Search.create(
  price: params[:price].to_i,
  days: params[:days].to_i,
  user_id: current_user.id
)
  #this will calculate the total travel distance that is valid by budget and days
  travel_distance(params[:price].to_i, params[:days].to_i)
   
  redirect '/results/index'
end

get '/results/index' do
  calculate_destination
  @end_lat = @destination_array[0]
  @end_long = @destination_array[1]
  erb :'/results/index'

  # get photos
  # #return array of photo urls,
  # @photo = get_photos[]
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


