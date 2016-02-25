# Require config/environment.rb
require ::File.expand_path('../config/environment',  __FILE__)
require 'uri'
require 'net/http'
set :app_file, __FILE__
run Sinatra::Application
