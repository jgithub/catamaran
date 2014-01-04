module Catamaran
  class Formatter
    include Singleton

    def self.instance
      @@instance ||= new
    end    

    def caller_enabled=( boolean_value )
      @caller_enabled = boolean_value
    end

    def caller_enabled
      @caller_enabled
    end    

    ##
    # Construct a properly formatted log message based


    def construct_formatted_message( log_level, path, msg, opts )
      if ( ( opts && opts[:file] && opts[:line] && opts[:method] ) || !@caller_enabled )
        # if file and line number are specified or the caller_enabled is disabled
        # then construct a formatted message that does NOT make use of the caller (caller is slow)

        base_construct_formatted_message( log_level, path, msg, opts ) + contruct_suffix_info( opts ) + construct_backtrace_info( opts )
      elsif @caller_enabled
        # else if the caller is enabled, make use of it
        "#{base_construct_formatted_message( log_level, path, msg, opts )} (#{caller(4)[0]})" +  construct_backtrace_info( opts )
      else
        # Otherwise, do NOT use the caller (as it is slow)
        base_construct_formatted_message( log_level, path, msg, opts ) + contruct_suffix_info( opts ) + construct_backtrace_info( opts )
      end
    end


    protected

    def base_construct_formatted_message( severity, path, msg, opts )
      # Truncate on the left
      if path.length > 47
        updated_path = path.dup[-47,47]
      else
        updated_path = path
      end

      # TODO:  Abstract out the logger so that it's easy to use different formats
      # Implicit return
      sprintf( "%6s pid-#{Process.pid} [#{Time.now.strftime( "%G-%m-%d %H:%M:%S:%L" )}] %47s - #{msg}", LogLevel.severity_to_s( severity ), updated_path  )
    end

    def construct_backtrace_info( opts )
      if opts && opts[:backtrace] == true
        # Implicit return
        " from:\n#{caller(5).take(10).join("\n")}"
      else
        # Implicit return
        ''
      end
    end


    def contruct_suffix_info( opts )
      msg = ''

      if opts
        if opts[:file]
          msg << " (#{opts[:file]}"

          if opts[:line]
            msg << ":#{opts[:line]}"
          end

          if opts[:class] || opts[:method]
            msg << ":in `"
          
            msg << construct_class_method_info( opts )

            msg << "'"
          end

          msg << ')'
        end
      end

      # Implicit return
      msg        
    end


    def construct_class_method_info( opts )
      msg = ''
      if opts
        if opts[:class] || opts[:method]
          if opts[:class] 
            msg << "#{opts[:class]}."
          end

          msg << "#{opts[:method]}" if opts[:method]
        end
      end

      # Implicit Return
      msg
    end

    private

    def initialize
      # Using caller() in the log messages is DISABLED by default
      @caller_enabled = false
    end    

  end
end
      