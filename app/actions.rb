# Homepage (Root path)
get '/' do
  @address = "Whistler,+BC"
  erb :index
end


get '/results' do
  @address = "Whistler,+BC"
  erb :'results/index'
end

