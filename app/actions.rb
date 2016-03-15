# Homepage (Root path)
include Math

enable :sessions
helpers do
  WIKIBOOK = "https://upload.wikimedia.org/wikipedia/en/9/99/Question_book-new.svg" #img for when no wiki img is found
  START_LAT = 49.2820150
  START_LONG = -123.1082410

  #defines the current logged in user
  def check_flash
    @flash = session[:flash] if session[:flash]
    session[:flash] = nil
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  #returns city if able with json file, else returns nil
  def get_city_name(json)
    begin
      return json["geonames"][0]["name"]
    rescue NoMethodError
      return nil
    end
  end

  #finds a random destination location at a given distance and returns an array[lat,long]
  def calculate_destination
    @destination_array=[]
    lat1 = radians(START_LAT) # starting point's latitude (in radians)
    lon1 = radians(START_LONG) # starting point's longitude (in radians)
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
    @end_lat = degree(lat2)
    @end_long = degree(lon2)
    @destination_array << @end_lat
    @destination_array << @end_long
  end

  #finds the name of the province of the city
  def get_city_province (coordinates)
    #geonames province getter
    @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{coordinates[0]}&lng=#{coordinates[1]}&cities=cities1000&username=powerup7")
    geonames = Net::HTTP.get(@uri)
    @province = JSON.parse(geonames)["geonames"][0]["adminName1"]
  end

  #find the name of the nearest city with population 5000+ given coordinates
  def city_name (coordinates)
    #geonames get request to find nearby city
    @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{coordinates[0]}&lng=#{coordinates[1]}&cities=cities5000&username=powerup7")
    @geonames = Net::HTTP.get(@uri)
    json_city_name = get_city_name(JSON.parse(@geonames))
    if json_city_name.nil?
      nil
    else
      @cityname = json_city_name
      @real_city_name = @cityname.gsub(' ', '')
    end
  end

  #find the coordinates of the city given city and province
  def get_geolocation_of_city(city,province)
    #get the geolocation of the city_name search so that google views has coordinates to be put in
    #googlegeocode lat long
    city = city.gsub(' ','')
    province = province.gsub(' ','')
    @uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=#{city}+#{province}&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc")
    @geolocation = Net::HTTP.get(@uri)
    @geolocation = JSON.parse(@geolocation)["results"][0]["geometry"]["location"]
  end

  #gets the wikipedia link of the city given coordinates
  def get_wiki_link (latitude, longitude)
    @wiki_link = URI.parse("http://api.geonames.org/findNearbyWikipediaJSON?lat=#{latitude}&lng=#{longitude}&username=powerup7")
    geowiki = Net::HTTP.get(@wiki_link)
    if geowiki == "{\"geonames\":[]}"
      nil
    else
      gif_link = JSON.parse(geowiki)["geonames"][0]["wikipediaUrl"]
      gif_link = "http://#{gif_link}"
    end
  end

  #get the furthest distance one can travel with budget and days
  def travel_distance (price, days)
    page = HTTParty.get('http://www.gasbuddy.com/')
    @parse_page = Nokogiri::HTML(page)
    @average_gas_price = @parse_page.css('.gb-price-lg')[0].children[0].to_s.to_f / 100
    @total_distance = price / @average_gas_price *6
    @total_distance = @total_distance**0.98
    @total_distance > (days * 800) ? (days * 800) : @total_distance
  end

  #calculates radians with degrees
  def radians(degree)
    (degree*PI)/180
  end

  #calculates degrees with radians
  def degree(radian)
    (radian*180)/PI
  end

  #pull out the first 2 paragraphs with wikipedia link
  def get_wiki_paragraph (wiki_link)
    output = []
    if wiki_link.nil?
      nil
    else
      page = HTTParty.get (wiki_link)
      parse_page = Nokogiri::HTML(page)

      (0..1).each do |paragraphs|
        pg = parse_page.css('p')[paragraphs]
        unless pg.nil?
          para = pg.text
          output << para.gsub(/\[\d\]/,'')
        end
      end
      output[0]+output[1]
    end
  end

  #pulls out the main image from a wikipedia link
  def wiki_picture (wiki_link)
    wiki_page = wiki_link

    page = HTTParty.get (wiki_page)

    parse_page = Nokogiri::HTML(page)

    wiki_pic = []
    (0..4).each do |i|
      parse_css = parse_page.css('div#mw-content-text table tr')[i]
      unless parse_css.nil?
        acss = parse_css.css('a')
        (wiki_pic << acss[0]['href']) unless acss.empty?
      end
    end

    pic_link = []
    wiki_pic.each do |link|
      pic_link << "https://en.wikipedia.org#{link}"
    end


    real_image = []
    pic_link.each do |i|
      a_image = Nokogiri::HTML(HTTParty.get(i)).css('.fullImageLink a')[0]
      (real_image << "https:#{a_image['href']}") unless a_image.nil?
    end

    if real_image[0].nil?
      WIKIBOOK
    elsif (real_image == WIKIBOOK) && real_image[1] != nil
      real_image[1]
    else
      real_image[0]
    end
  end
end

enable :sessions
before do
	current_user
	check_flash
end


post '/' do
  # @price = params[:price].gsub('$','').gsub(',','').to_i
  # @days = params[:days].to_i
  # (@price = 700) if (@price > 700)


  # @search = Search.create(
  # price: @price,
  # days: @days
  # )
  # # user_id: current_user.id
  # @travel_distance = travel_distance(@price, @days)
  # session[:distance] = @travel_distance
  # redirect "/results/index?travel_distance=#{@travel_distance}"
  redirect "/results/index?travel_distance=250"
end



post '/results/index' do

  #this will calculate the total travel distance that is valid by budget and days
  # @travel_distance = travel_distance(params[:price].to_i, params[:days].to_i)

  @travel_distance = session[:distance]
  # redirect "/results/index?travel_distance=#{@travel_distance}"
  redirect "/results/index?travel_distance=250"
end

get '/results/index' do
  @travel_distance = params[:travel_distance].to_f

  @city_name = nil
  while @city_name.nil?
    calculate_destination
    @end_lat = @destination_array[0]
    @end_long = @destination_array[1]
    @city_name = city_name(@destination_array)
  end
  #getting city province only if cityname is found and valid
  @province = get_city_province(@destination_array)
  get_geolocation_of_city(@city_name, @province)

  @street_view_lat = @geolocation["lat"]
  @street_view_long = @geolocation["lng"]

  @wiki_link = get_wiki_link(@street_view_lat, @street_view_long)
  @wiki_paragraph = get_wiki_paragraph(@wiki_link)
  # getting wikipedia picture

  @wiki_img = WIKIBOOK
  @wiki_img = wiki_picture(@wiki_link) unless @wiki_link.nil?
  erb :'/results/index'

  # get photos
  # #return array of photo urls,
  # @photo = get_photos[]
end

get '/' do
  erb :index
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
    session[:flash] = "Successfully created user!"
    redirect '/'
  else
    session[:flash] = "User could not be created.  Username must be greater than 3 characters and the password must be between 5 and 20 characters."
    redirect 'users/signup'
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
  if @user != nil && @user.password == params[:password]
    session[:user_id] = @user.id
    redirect '/'
  else
    session[:flash] = "Invalid username or password"
    redirect '/users/signin'
  end
end

get '/users/signout' do
  session.clear
  redirect '/'
end
