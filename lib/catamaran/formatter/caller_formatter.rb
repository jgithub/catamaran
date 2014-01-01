module Catamaran
  module Formatter
    ##
    # Construct a properly formatted log message based

    class CallerFormatter < BaseFormatter
      def self.construct_formatted_message( log_level, path, msg, opts )
        "#{base_construct_formatted_message( log_level, path, msg, opts )} (#{caller(4)[0]})" +  construct_backtrace_info( opts )
      end
    end
  end
end
      