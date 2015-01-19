require "O365RubyEasy/version"
require_relative 'O365RubyEasy/session'
require_relative 'O365RubyEasy/onedriveclient'
require 'uri'
require 'net/https'
require 'cgi'
require 'json'
require 'yaml'
require 'base64'
require 'securerandom'
require 'pp'


module O365RubyEasy


	# Clean-up the parameters convert them to Strings. 
	    def self.clean_params(params)
	        r = {}
	        params.each do |k,v|
	            r[k] = v.to_s if not v.nil?
	        end
	        r
	    end

	  def self.do_http(uri, request) # :nodoc:
	        http = Net::HTTP.new(uri.host, uri.port)
	        http.use_ssl = true
	        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	        puts __method__.to_s
	        http = Net::HTTP.new(uri.host, uri.port)
	        http.use_ssl = true
	        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
	#        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
	#        http.ca_file = O365API::TRUSTED_CERT_FILE
	        http.set_debug_output($stdout) 

	        pp request 
	        pp http 

	        begin
	            http.request(request)
	        rescue 
	            raise RuntimeError.new("Error connecting")
	        end
	    end

	    def self.do_http_with_body(uri, request, body)
	        puts __method__.to_s
	        puts body 
	        if body != nil
	            if body.is_a?(Hash)
	                request.set_form_data(O365RubyEasy::clean_params(body))
	            elsif body.respond_to?(:read)
	                if body.respond_to?(:length)
	                    request["Content-Length"] = body.length.to_s
	                elsif body.respond_to?(:stat) && body.stat.respond_to?(:size)
	                    request["Content-Length"] = body.stat.size.to_s
	                else
	                    raise ArgumentError, "Don't know how to handle 'body' (responds to 'read' but not to 'length' or 'stat.size')."
	                end
	                request.body_stream = body
	            else
	                s = body.to_s
	                request["Content-Length"] = s.length
	                request.body = s
	            end
	        end
	        puts 'request  is...'
	        pp request 
	        do_http(uri, request)
	    end


end
