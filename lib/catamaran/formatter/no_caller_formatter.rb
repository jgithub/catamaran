module Catamaran
  module Formatter
    ##
    # Construct a properly formatted log message based

    class NoCallerFormatter < BaseFormatter
      def self.construct_formatted_message( log_level, path, msg, opts )        
        suffix_info = contruct_suffix_info( opts )
        if suffix_info && suffix_info.length > 0 
          base_construct_formatted_message( log_level, path, msg, opts ) + ' ' + suffix_info
        else
          base_construct_formatted_message( log_level, path, msg, opts )
        end
      end
    end
  end
end
      