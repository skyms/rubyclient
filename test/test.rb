require_relative '../lib/o365rubyeasy'
require 'logger'
require 'sinatra'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG  


SESSION = {
    client_id: "32ea5265-35bc-49c7-bf03-fa7928bc07dc",
    redirect_uri: "http://localhost:4567/go",
    secret: "C+WTbpXIt26drLsv3lXY/qyOQn6hPfGcLHo8IYnHO1Q=",
    tenant_name: "marsmons"
	}

client = O365RubyEasy::OneDriveClient.new (SESSION)
auth_url = client.get_authurl

def html_page(title, body='')
    "<html>" +
        "<head><title> #{title} </title></head>" +
        "<body><h1> #{title} </h1> #{body} </body>" +
    "</html>"
end

##
# Main entry point for the application
# Provides link to the authorization code to determine the 
#
# @return Authozation URL

get '/' do 
	logger.debug "T entering the main sinatra loop"	
	out = "<center> <h3> Click <a href=#{auth_url}> here </a> to access file browser </h3></center> "
end

get '/go' do 
	logger.debug "T inside /go with: #{params[:code]}"
end
