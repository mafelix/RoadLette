require 'net/http'
require 'json'
require 'uri'
require 'pry'
@request = Net::HTTP.get(URI.parse('https://maps.googleapis.com/maps/api/directions/json?origin=Vancouver,+BC&destination=RIchmond,+BC&departure_time=1343641500&mode=transit&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc'))


# response = JSON.parse(@request)["routes"][0]["legs"][0]["distance"]
# response = JSON.parse(@request)["routes"][0]["legs"][0]["distance"]




# @request2 =Net::HTTP.get(URI.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=50.84635593500744,-120.576518434131572&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc'))
# response = JSON.parse(@request2)  
# p response

# geonames 
# places_nearby = Net::HTTP.get(URI.parse('http://api.geonames.org/findNearbyPlaceNameJSON?lat=49.2820150&lng=-123.1082410&cities=cities15000&username=powerup7'))
# response = JSON.parse(places_nearby)["geonames"][0]["name"]
# p response
@end_lat = 49.2820150
@end_long = -123.1082410
@uri = URI.parse("http://api.geonames.org/findNearbyPlaceNameJSON?lat=#{@end_lat}&lng=#{@end_long}&cities=cities1000&username=powerup7")
geonames = Net::HTTP.get(@uri)
@cityname = JSON.parse(geonames)["geonames"][0]["name"]  
p geonames
