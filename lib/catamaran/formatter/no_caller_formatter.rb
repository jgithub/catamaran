module Catamaran
  module Formatter
    ##
    # Construct a properly formatted log message based

    class NoCallerFormatter < BaseFormatter
      def self.construct_formatted_message( log_level, path, msg, opts )        
        base_construct_formatted_message( log_level, path, msg, opts ) + contruct_suffix_info( opts ) + construct_backtrace_info( opts )
      end
    end
  end
end
      