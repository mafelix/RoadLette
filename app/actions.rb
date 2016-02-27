require 'pry'
# Homepage (Root path)
include Math
helpers do
  
  # def calculate_destination    #(starting_lat, starting_long)
  #   @EARTH_RADIUS = 6371   #km
  #   @R = @EARTH_RADIUS
  #   @d = @total_distance

  def get_pictures
    request = Net::HTTP.get(URI.parse('https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=06b3edd0e485fa8e237ea30fb17c1b50&safe_search=vancouver&format=json&nojsoncallback=1&auth_token=72157664962446491-8e324e4f345430b0&api_sig=d5058ce551bb380499f653434df16bd9'))
    # response = JSON.parse(@request)["photos"]["photo"][0]["farm"]
    id = JSON.parse(@request)["photos"]["photo"][0]["id"]
    secret = JSON.parse(@request)["photos"]["photo"][0]["secret"]
    server = JSON.parse(@request)["photos"]["photo"][0]["server"]
    farm = JSON.parse(@request)["photos"]["photo"][0]["farm"]
  end


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
    @end_lat = degree(lat2)
    @end_long = degree(lon2)
    @destination_array << @end_lat
    @destination_array << @end_long
  end


  def city_name (coordinates)
    #geonames get request to find nearby city
    @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{@end_lat}&lng=#{@end_long}&cities=cities1000&username=powerup7")
    @geonames = Net::HTTP.get(@uri)
    if get_city_name(JSON.parse(@geonames)).nil?
      calculate_destination
    else
      @cityname = get_city_name(JSON.parse(@geonames))
    end
  end

  def get_wiki_link (coordinates)
    @wiki_link = URI.parse("http://api.geonames.org/findNearbyWikipediaJSON?lat=#{@end_lat}&lng=#{@end_long}&username=powerup7")
    geowiki = Net::HTTP.get(@wiki_link)
    if geowiki == "{\"geonames\":[]}"
      nil
    else
      gif_link = JSON.parse(geowiki)["geonames"][0]["wikipediaUrl"]
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

  # def wiki_picture (wiki_link)
  #   wiki_page = wiki_link
    
    
  #   page = HTTParty.get (wiki_page)
       
  #   parse_page = Nokogiri::HTML(page)

  #   wiki_pic = []
  #   (0..4).each do |i|
  #     test = parse_page.css('div#mw-content-text table tr')[i].css('a')
  #     (wiki_pic << test[0]['href']) unless test.empty?
  #   end

  #   pic_link = []
  #   wiki_pic.each do |link|
  #     pic_link << "https://en.wikipedia.org#{link}"
  #   end

    
  #   real_image = []
  #   pic_link.each do |i|
  #     a_image = Nokogiri::HTML(HTTParty.get(i)).css('.fullImageLink a')[0]
  #     (real_image << "https:#{a_image['href']}") unless a_image.nil?
  #   end

  #   real_image[0]
  # end

end

enable :sessions


post '/' do
  @search = Search.create(
  price: params[:price].to_i,
  days: params[:days].to_i)
  # user_id: current_user.id
  @travel_distance = travel_distance(params[:price].to_i, params[:days].to_i)
  session[:distance] = @travel_distance
  redirect "/results/index?travel_distance=#{@travel_distance}"
end

get '/' do
  erb :index
end

post '/results/index' do

  #this will calculate the total travel distance that is valid by budget and days
  # @travel_distance = travel_distance(params[:price].to_i, params[:days].to_i)
  @travel_distance = session[:distance]
  redirect "/results/index?travel_distance=#{@travel_distance}"
end

get '/results/index' do
  @travel_distance = params[:travel_distance].to_f
  calculate_destination


  @end_lat = @destination_array[0]
  @end_long = @destination_array[1]

  city_name(@destination_array)
  @wiki_link = get_wiki_link(@destination_array)
  #getting wikipedia picture

  # wiki_picture(@wiki_link) unless @wiki_link.nil?


  # wiki_picture(wiki_link)



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



