
require_relative 'O365RubyEasy/version'
require_relative 'O365RubyEasy/logging'
require_relative 'O365RubyEasy/onedriveclient'
require 'net/https'
require 'uri'

module O365RubyEasy

    DISCOVERY_SERVER = "https://api.office.com/discovery/v1.0/me/services"
    AAD_AUTH_SERVER = "login.windows.net/common/oauth2/"
    DISCOVER_RESOURCE = "https://api.office.com/discovery/"
    SEARCH_SEGMENT = "_api/search/"



	# Clean-up the parameters convert them to Strings. 
	    def self.clean_params(params)
	        r = {}
	        params.each do |k,v|
	            r[k] = v.to_s if not v.nil?
	        end
	        r
	    end

	#include O365RubyEasy::Logging

	def self.say_hello
		logger.debug {'debug: ...'}
		logger.warn  {'warning: ...'}
		logger.error  {'Error: ...'}
		logger.fatal  {'fatal: ...'}
	end


	def self.do_http(uri, request) # :nodoc:
		logger.debug "D, #{__method__.to_s}"
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
#        http.ca_file = O365API::TRUSTED_CERT_FILE
        http.set_debug_output($stdout) 
        begin
            http.request(request)
        rescue 
        	logger.fatal "F, Error while executing the HTTP command"
            raise RuntimeError.new("Error while executing the HTTP command")
        end
    end

    def self.do_http_with_body(uri, request, body)
    	logger.debug "D, #{__method__.to_s}"
        if body != nil
            if body.is_a?(Hash)
                request.set_form_data(O365RubyEasy::clean_params(body))
            elsif body.respond_to?(:read)
                if body.respond_to?(:length)
                    request["Content-Length"] = body.length.to_s
                elsif body.respond_to?(:stat) && body.stat.respond_to?(:size)
                    request["Content-Length"] = body.stat.size.to_s
                else
                	logger.fatal "F, Error while processing the HTTP body"
                    raise ArgumentError, "Don't know how to handle 'body' (responds to 'read' but not to 'length' or 'stat.size')."
                end
                request.body_stream = body
            else
                s = body.to_s
                request["Content-Length"] = s.length
                request.body = s
            end
        end
        do_http(uri, request)
    end

end
