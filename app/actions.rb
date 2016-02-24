# Homepage (Root path)
get '/' do
  @address = "Whistler,+BC"
  erb :index
end
