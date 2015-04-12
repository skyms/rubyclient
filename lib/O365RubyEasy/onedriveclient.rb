require 'net/https'


module O365RubyEasy

class OneDriveClient
	attr_accessor :auth_server, :client_id, :secret, :redirect_uri, :tenant_name, :authcode, :access_token, :refresh_token

	def initialize(session={})
		@auth_server = session[:auth_server] || 'login.windows.net'
		@client_id = session[:client_id] || nil
		@secret = session[:secret] || nil	
		@redirect_uri = session[:redirect_uri] || nil
		@tenant_name = session[:tenant_name] || nil
	end

	def get_authcode
	end

	def get_accesstoken
	end

	def get_auth_url
	end
	
end

end


	