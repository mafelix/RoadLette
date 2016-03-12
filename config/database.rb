configure do
  # Log queries to STDOUT in development
  if Sinatra::Application.development?
    ActiveRecord::Base.logger = Logger.new(STDOUT)
  end



  if development?
    set :database, {
      adapter: "sqlite3",
      database: "db/db.sqlite3"
    }
  else
    # set :database, ENV['DATABASE_URL']
    set :database, "postgres://gyeiqfrlmhdpzw:6r8uEb6heofyKTAiZqEg5MfzYv@ec2-107-21-101-67.compute-1.amazonaws.com:5432/d3280r388v8v1v"
  end

  # old database settings
  # set :database, {
  #   adapter: "sqlite3",
  #   database: "db/db.sqlite3"
  # }

  # Load all models from app/models, using autoload instead of require
  # See http://www.rubyinside.com/ruby-techniques-revealed-autoload-1652.html
  Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
    filename = File.basename(model_file).gsub('.rb', '')
    autoload ActiveSupport::Inflector.camelize(filename), model_file
  end

end


