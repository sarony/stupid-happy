require 'sinatra/activerecord/rake'
require './app'

# Include all rake tasks located in lib/tasks folder.
Dir.glob('lib/tasks/*.rake').each { |r| load r }

# TravisCI integration.
if Sinatra::Base.development? || Sinatra::Base.test?
	require 'rspec/core/rake_task'
	
	RSpec::Core::RakeTask.new(:spec)
	task :default => :spec
end