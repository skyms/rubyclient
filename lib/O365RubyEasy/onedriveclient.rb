require 'net/https'
require 'uri'
require 'json'

module O365RubyEasy

class OneDriveClient
	@@filev1segment = '/_api/v1.0/me/'
	@@auth_path = '/common/oauth2/'

	attr_accessor :client_id, :secret, :redirect_uri, :files_resource_path, :authcode, :access_token, :refresh_token,
                  :files_serviceResourceId

	def initialize(session={})
		@client_id = session[:client_id] || nil
		@secret = session[:secret] || nil	
		@redirect_uri = session[:redirect_uri] || nil
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
        auth_uri = URI::Generic.new("https", nil, O365RubyEasy::AAD_AUTH_SERVER, nil, nil, "authorize", 
        							 nil, nil, nil)
        auth_uri.query = URI.encode_www_form(params)
        logger.debug "Generated URI: #{auth_uri.to_s}"
        return auth_uri.to_s
    	# return "#{@aad_server}/authorize?response_type=code&client_id=#{@client_id}&redirect_uri=#{@redirect_uri}"
	end

	##
	# Return Access token for a given authorization code. 
	# If session is initialized with an auth-code, then it'll 
	# used to return the access token
	#
	def set_access_token(authcodeParam = nil, resource = nil, update_refToken = false) 
		logger.debug "D, #{__method__.to_s}, resource= #{resource}, authcode passed = #{authcodeParam} "
      	@auth_code = authcodeParam unless authcodeParam.nil?  
		puts @auth_code 
		#access_token = #call oauth to get the access token...	
		#refresh_token = #save refresh token
		uri = URI.parse("https://#{O365RubyEasy::AAD_AUTH_SERVER}token")
        request = Net::HTTP::Post.new(uri.request_uri)
        resource = resource 
        params = {
            "grant_type" => "authorization_code",
            "client_id" => @client_id,
            #"client_secret" => CGI.escape(@client_secret),
            "client_secret" => @secret,
            "code" => @auth_code,
            "redirect_uri" => @redirect_uri,
            "resource" => resource
        }
        # request.set_form_data(params)
        response = O365RubyEasy::do_http_with_body(uri, request, params)
        j = JSON.parse(response.body) 
        @access_token = j['access_token']
        if update_refToken
            @refresh_token = j['refresh_token']
        end
     	return 
    end

	##
	# Call Discovery Service and obtain the service end points 
	#
	def return_file_source_hash(authcodeParam = nil)
        logger.debug "D, #{__method__.to_s}"
        libArray = []
        set_access_token(authcodeParam, O365RubyEasy::DISCOVER_RESOURCE)        
        j = doGetRequest (O365RubyEasy::DISCOVERY_SERVER)
        logger.debug "D, #{j.to_s}"

        j["value"].each do |resource|
            if resource["capability"] == "MyFiles"
                @files_resource_path = resource["serviceEndpointUri"]
                @files_serviceResourceId = resource["serviceResourceId"]
                libArray.push @files_resource_path
            end
        end

        if (@files_serviceResourceId)
           logger.debug "D, CALLING SET ACCESS TOKEN AGAIN WITH #{@files_serviceResourceId}"
           set_access_token(authcodeParam, @files_serviceResourceId, true)
           j = doGetRequest(@files_serviceResourceId+O365RubyEasy::SEARCH_SEGMENT, true, true) 
           hArray = j["PrimaryQueryResult"]["RelevantResults"]["Table"]["Rows"]
           hArray.each do |r|
                r["Cells"].each do |s|
                    if s["Key"] == "Path"
                        libArray.push s["Value"]
                    end
                end
           end
        end
        return libArray.to_s
	end

	##
	# Generic GET Request initiator
	#
	def doGetRequest(geturl, useJsonFormat=true, oDataMetadata=false)
        logger.debug "D, #{__method__.to_s}"		
        uri = URI.parse(geturl)
        request = Net::HTTP::Get.new(uri)
        request['Authorization']= "Bearer #{@access_token}"
        if oDataMetadata
            request['Accept']= "application/json"
        else
            request['Accept']= "application/json;odata.metadata=none"
        end
        response = O365RubyEasy::do_http(uri, request)
        if useJsonFormat
            return JSON.parse(response.body)
        else
            return response.body
        end
    end

    ##
    # Test Print
    #	
	def print_close
		logger.debug "#{@auth_server}"
		logger.debug "#{@client_id}"
		logger.debug "#{@secret}"
		logger.debug "#{@redirect_uri}"
		logger.debug "#{@tenant_name}"
	end

	private :doGetRequest
end

end


	