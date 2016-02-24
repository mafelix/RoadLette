# Homepage (Root path)
get '/' do
  @address = "Kamloops,+BC"
  erb :index
end
