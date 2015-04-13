require 'logger'

module O365RubyEasy
    
    class << self
      ##
      # Logger for the API client
      #
      # @return [Logger] logger instance.
      attr_accessor :logger
    end

    self.logger = Logger.new(STDOUT)
    self.logger.level = Logger::DEBUG  

    ##
    # Module to make accessing the logger simpler
    module Logging
      ##
      # Logger for the API client
      #
      # @return [Logger] logger instance.
      def logger
        O365RubyEasy::logger
      end
    end
  
end