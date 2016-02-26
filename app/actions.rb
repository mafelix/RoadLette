require 'pry'
# Homepage (Root path)
include Math
helpers do

  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def get_city_name(json)
    begin
      return json["geonames"][0]["name"]
    rescue NoMethodError
      return nil
    end
  end

  def calculate_destination
    @destination_array=[]
    lat1 = radians(49.2820150) # starting point's latitude (in radians)
    lon1 = radians(-123.1082410) # starting point's longitude (in radians)
    brng = rand(360).to_f   # bearing (in radians)
    d = @travel_distance     # distance to travel in km
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

    @end_lat = @destination_array[0]
    @end_long = @destination_array[1]
    
    #geonames get request to find nearby city
    @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{@end_lat}&lng=#{@end_long}&cities=cities1000&username=powerup7")
    @geonames = Net::HTTP.get(@uri)
    if get_city_name(JSON.parse(@geonames)).nil?
      calculate_destination
    else
      @cityname = get_city_name(JSON.parse(@geonames))
    end
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
  # user_id: current_user.id
)
  #this will calculate the total travel distance that is valid by budget and days
  @travel_distance = travel_distance(params[:price].to_i, params[:days].to_i)
  redirect "/results/index?travel_distance=#{@travel_distance}"
end

get '/results/index' do
  @travel_distance = params[:travel_distance].to_f
  calculate_destination

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


