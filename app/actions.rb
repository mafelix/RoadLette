require 'pry'
# Homepage (Root path)
include Math
helpers do
  WIKIBOOK = "https://upload.wikimedia.org/wikipedia/en/9/99/Question_book-new.svg" 


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
    @end_lat = degree(lat2)
    @end_long = degree(lon2)
    @destination_array << @end_lat
    @destination_array << @end_long
  end


  def city_name (coordinates)
    #geonames get request to find nearby city
    @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{coordinates[0]}&lng=#{coordinates[1]}&cities=cities1000&username=powerup7")
    @geonames = Net::HTTP.get(@uri)
    json_city_name = get_city_name(JSON.parse(@geonames))
    if json_city_name.nil?
      nil
    else
      @cityname = json_city_name
      @real_city_name = @cityname.gsub(' ', '')
    end
  end


  def get_wiki_link (coordinates)
    @wiki_link = URI.parse("http://api.geonames.org/findNearbyWikipediaJSON?lat=#{@end_lat}&lng=#{@end_long}&username=powerup7")
    geowiki = Net::HTTP.get(@wiki_link)
    if geowiki == "{\"geonames\":[]}"
      nil
    else
      gif_link = JSON.parse(geowiki)["geonames"][0]["wikipediaUrl"]
      gif_link = "http://#{gif_link}"
    end
  end

  def travel_distance (price, days)
    page = HTTParty.get('http://www.gasbuddy.com/')
    @parse_page = Nokogiri::HTML(page)
    @average_gas_price = @parse_page.css('.gb-price-lg')[0].children[0].to_s.to_f / 100
    @total_distance = price / @average_gas_price *6
    @total_distance = @total_distance**0.98
    @total_distance > (days * 800) ? (days * 800) : @total_distance
  end

  def radians(degree)
    (degree*PI)/180
  end

  def degree(radian)
    (radian*180)/PI
  end

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

  @city_name = nil
  while @city_name.nil?
    calculate_destination
    @end_lat = @destination_array[0]
    @end_long = @destination_array[1]
    @city_name = city_name(@destination_array)
  end
  
  @wiki_link = get_wiki_link(@destination_array)
  @wiki_paragraph = get_wiki_paragraph(@wiki_link)
  # getting wikipedia picture

  @wiki_img = WIKIBOOK
  @wiki_img = wiki_picture(@wiki_link) unless @wiki_link.nil?
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

get '/users/signout' do 
  session.clear
  redirect '/'
end
