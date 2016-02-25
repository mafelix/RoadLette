# Homepage (Root path)
get '/' do
  @address = "Whistler,+BC"
  erb :index
end


get '/results' do
  page = HTTParty.get('http://www.gasbuddy.com/')
  @parse_page = Nokogiri::HTML(page)
  @parse_page = @parse_page.css('.gb-price-lg')[0].children[0].to_s.to_f
  binding.pry
  erb :'results/index'
end