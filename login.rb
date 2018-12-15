require 'sinatra'
require 'redis'
require 'erb'

redis = Redis.new()

configure do 
	enable :sessions
	set :show_exceptions, false
end

before do 
	content_type:txt
	# Storing initial values on the application level
	@before_value = 'foo'
end 

get '/' do 
	# session['current_user.email'] = "m.fouad@email.com"
	redirect '/home'
end 

get '/env' do 
	# will itrate over all the values in the @env variable and display them as output 
	request.env.map { |e| e.to_s + "\n" }
end 

get '/cache' do 
	expires 3600, :public, :must_revalidate 
	"this page is rendered at #{Time.now}"
end

before '/profile' do 
	# check if profile user is the logged in user
	# check current energy points & add it to session energy points variable
	if session[:energy]  then 
		session[:energy] = session[:energy] + 1
		redis.set "energy", session[:energy]
	else   
		session[:energy] =  1
		redis.set "energy", session[:energy]
	end
end 

get '/profile' do 
=begin  
if session[:user] = "database user" then
  # nothing you are logged in
erb :profile 
 else  
  redirect '/home'
 end
=end 
	# add energy points 
	session['current_user.email'] = "m.fouad@email.com"
	current_energy =  redis.get "energy"
	session[:energy] = current_energy.to_i + 1 
	erb :profile 
end

after '/profile' do 
	puts # check if profile user is the logged in user 
	# check current energy points 
	session[:energy] 
end

error '/profile' do #is this sinatra ruby code? please check sinatra docs
	puts "Been an Error on Profile route and you coded to avoid this nasty stack...."
end

not_found do 
	#	haml :about
	#	slim :about
	puts "Be Cool! as ekoki.me is overloaded or your page not found!"	
end

get '/home' do 
	session[:db_energy] =  redis.get "energy"
	erb :home
end 
get '/logout' do 
	session.clear 
	redirect '/home'
end 

after do 
	#session.clear 
	puts "After filter called to perform some task. such as session.clear"
end
