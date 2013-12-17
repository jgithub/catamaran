module Catamaran
  module Formatter
    ##
    # Construct a properly formatted log message based

    class CallerFormatter
      def self.construct_formatted_message( log_level, path, msg, opts )
        
        ##
        # If the client has specified a __FILE__ or a __LINE__ in the log opts, make use of them

        if opts 
          if opts[:file] && opts[:line]
            path = path + " (#{opts[:file]}:#{opts[:line]})" 
          end
        end

        # Truncate on the left
        if path.length > 42
          updated_path = path.dup[-42,42]
        else
          updated_path = path
        end

        # Making use of the caller here is slow.   
        # TODO:  Abstract out the logger so that it's easy to use different formats
        # Implicit return
        sprintf( "%6s pid-#{Process.pid} [#{Time.now.strftime( "%G-%m-%d %H:%M:%S:%L" )}] %42s - #{msg} (#{caller(3)[0]})", LogLevel.to_s(log_level), updated_path  )
      end
    end
  end
end
      