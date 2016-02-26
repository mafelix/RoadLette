require 'net/http'
require 'json'
require 'uri'
require 'pry'
@request = Net::HTTP.get(URI.parse('https://maps.googleapis.com/maps/api/directions/json?origin=Vancouver,+BC&destination=RIchmond,+BC&departure_time=1343641500&mode=transit&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc'))


# response = JSON.parse(@request)["routes"][0]["legs"][0]["distance"]
response = JSON.parse(@request)["routes"][0]["legs"][0]["distance"]




@request2 =Net::HTTP.get(URI.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=50.84635593500744,-120.576518434131572&key=AIzaSyAPV0_sCF_Qe5jsKsHd5DCfVC1c3yI3MLc'))
response = JSON.parse(@request2)["results"][0]["address_components"]
p response