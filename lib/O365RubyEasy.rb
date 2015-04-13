
require_relative 'O365RubyEasy/version'
require_relative 'O365RubyEasy/logging'
require_relative 'O365RubyEasy/onedriveclient'

module O365RubyEasy
	# # Clean-up the parameters convert them to Strings. 
	#     def self.clean_params(params)
	#         r = {}
	#         params.each do |k,v|
	#             r[k] = v.to_s if not v.nil?
	#         end
	#         r
	#     end

	#include O365RubyEasy::Logging

	def self.say_hello
		logger.debug {'debug: ...'}
		logger.warn  {'warning: ...'}
		logger.error  {'Error: ...'}
		logger.fatal  {'fatal: ...'}
	end

	


end
