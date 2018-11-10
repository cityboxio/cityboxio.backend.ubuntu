require "sinatra"

get "/ping" do
	"pong!"
end

get "/opendatahub" do
	`./endpoints/opendatahub.sh`
end
