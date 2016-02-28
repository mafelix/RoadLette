require 'net/http'
require 'json'
require 'uri'
require 'pry'
# @request = Net::HTTP.get(URI.parse('https://maps.googleapis.com/maps/api/directions/json?origin=Vancouver,+BC&destination=RIchmond,+BC&departure_time=1343641500&mode=transit&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc'))

# response = JSON.parse(@request)["photos"]["photo"]
# p response



# # response = JSON.parse(@request)["routes"][0]["legs"][0]["distance"]
# @request = Net::HTTP.get(URI.parse('https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=06b3edd0e485fa8e237ea30fb17c1b50&safe_search=vancouver&format=json&nojsoncallback=1&auth_token=72157664962446491-8e324e4f345430b0&api_sig=d5058ce551bb380499f653434df16bd9'))
# response = JSON.parse(@request)["photos"]["photo"][0]["farm"]
# p response

# response = JSON.parse(@request)
# p response["routes"][0]["legs"][0]["distance"]
# response = JSON.parse(@request)["routes"][0]["legs"][0]["distance"]

# id = JSON.parse(@request)["photos"]["photo"][0]["id"]
# puts id
# secret = JSON.parse(@request)["photos"]["photo"][0]["secret"]
# puts secret
# server = JSON.parse(@request)["photos"]["photo"][0]["server"]
# puts server
# farm = JSON.parse(@request)["photos"]["photo"][0]["farm"]
# puts farm

# http://farm{farm}.static.flickr.com/{server-id}/{id}_{secret}.jpg


# @request2 =Net::HTTP.get(URI.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=50.84635593500744,-120.576518434131572&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc'))
# response = JSON.parse(@request2)  
# p response

# geonames 
# places_nearby = Net::HTTP.get(URI.parse('http://api.geonames.org/findNearbyPlaceNameJSON?lat=49.2820150&lng=-123.1082410&cities=cities15000&username=powerup7'))
# response = JSON.parse(places_nearby)["geonames"][0]["name"]
# p response

# @end_lat = 49.2820150
# @end_long = -123.1082410
# @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{@end_lat}&lng=#{@end_long}&cities=cities1000&username=powerup7")
# geonames = Net::HTTP.get(@uri)

# @cityname = JSON.parse(geonames)["geonames"][0]["name"]  
# p geonames
# p @cityname

#geonames province getter
# @end_lat = 49.2820150
# @end_long = -123.1082410
# @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{@end_lat}&lng=#{@end_long}&cities=cities1000&username=powerup7")
# geonames = Net::HTTP.get(@uri)
# p JSON.parse(geonames)["geonames"][0]["adminName1"]

#googlegeocode lat long
@uri = URI.parse("https://maps.googleapis.com/maps/api/geocode/json?address=Vancouver+BC&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc"
)
@geolocation = Net::HTTP.get(@uri)
p JSON.parse(@geolocation)["results"][0]["geometry"]["location"]



#looking for wiki links
# @wiki_link = URI.parse("http://api.geonames.org/findNearbyWikipediaJSON?lat=#{@end_lat}&lng=#{@end_long}&username=powerup7")
# geowiki = Net::HTTP.get(@wiki_link)

# wikipedia_link_string = JSON.parse(geowiki)["geonames"][0]["wikipediaUrl"]

# p wikipedia_link_string




# # p response
# @end_lat = 49.2820150
# @end_long = -123.1082410
# @uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{@end_lat}&lng=#{@end_long}&cities=cities1000&username=powerup7")
# geonames = Net::HTTP.get(@uri)
# @cityname = JSON.parse(geonames)["geonames"][0]["name"]  
# p @cityname



# @request = Net::HTTP.get(URI.parse('https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=06b3edd0e485fa8e237ea30fb17c1b50&safe_search=vancouver&format=json&nojsoncallback=1&auth_token=72157664962446491-8e324e4f345430b0&api_sig=d5058ce551bb380499f653434df16bd9'))
 
# p @request
# p geonames


# @request = Net::HTTP.get(URI.parse('https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=06b3edd0e485fa8e237ea30fb17c1b50&safe_search=vancouver&format=json&nojsoncallback=1&auth_token=72157664962446491-8e324e4f345430b0&api_sig=d5058ce551bb380499f653434df16bd9'))
# response = JSON.parse(@request)["photos"]["photo"][0]
# p response

