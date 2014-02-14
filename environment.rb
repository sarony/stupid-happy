# Require Authentication / Configuration File
require './config/authentication' if File.exists?('./config/authentication.rb')

# Include Debug Capabilities in Development
configure :development do
  require 'sinatra/reloader'

  require 'better_errors'
  require 'binding_of_caller'

  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)

  register Sinatra::Reloader
  also_reload 'lib/*/*.rb'
end

# Database Configuration & Setup
configure :development do
  set :database, 'sqlite:///db/development.sqlite3'
  set :show_exceptions, true
end

configure :test do
  set :database, 'sqlite:///db/test.sqlite3'
  set :show_exceptions, true
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')
 
 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end

# Include all models, concerns, & helpers in /lib/*/*.rb
Dir.glob('./lib/*').each do |folder|
  Dir.glob(folder +'/*.rb').each do |file|
    require file
  end
end