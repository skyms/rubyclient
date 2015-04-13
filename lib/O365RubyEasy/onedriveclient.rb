require 'net/https'
require 'uri'

module O365RubyEasy

class OneDriveClient
	@@filev1segment = '/_api/v1.0/me/'
	@@auth_path = '/common/oauth2/'

	attr_accessor :auth_server, :client_id, :secret, :redirect_uri, :tenant_name, :authcode, :access_token, :refresh_token

	def initialize(session={})
		@auth_server = session[:auth_server] || 'login.windows.net'
		@client_id = session[:client_id] || nil
		@secret = session[:secret] || nil	
		@redirect_uri = session[:redirect_uri] || nil
		@tenant_name = session[:tenant_name] || nil
	end

	include O365RubyEasy::Logging


	##
    # Returns the authorization URL that the application use to re-direct the user for 
    # login and authorization purpose.
    #
    # @return Authozation URL
	def get_authurl

		params = {
            "client_id" => @client_id,
            "response_type" => "code",
            "redirect_uri" => @redirect_uri
        }
        auth_uri = URI::Generic.new("https", nil, @auth_server, nil, nil, "#{@@auth_path}authorize", 
        							 nil, nil, nil)
        auth_uri.query = URI.encode_www_form(params)
        logger.debug "Generated URI: #{auth_uri.to_s}"
        return auth_uri.to_s
    	# return "#{@aad_server}/authorize?response_type=code&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}"
	end

	def get_accesstoken
	end

	def get_auth_url
	end
	
	def print_close
		logger.debug "#{@auth_server}"
		logger.debug "#{@client_id}"
		logger.debug "#{@secret}"
		logger.debug "#{@redirect_uri}"
		logger.debug "#{@tenant_name}"
	end
end

end


	