module Catamaran
  class Formatter
    @@caller_enabled = false

    FAVORITE_FORMATTER_PATTERNS = {
      "%-6p pid-%pid [%d{yyyy-M-d HH:mm:ss:SSS}] %47C - %m"  => 1,
      "%c pid-%P [%d] %p - %m" => 2
    }      


    def self.construct_formatted_message( severity, path, msg, opts = nil )
      if opts && opts[:pattern]
        full_msg = construct_custom_pattern( severity, path, msg, opts )
      else
        unless @favorite_pattern_number
          @favorite_pattern_number = FAVORITE_FORMATTER_PATTERNS[Manager::formatter_pattern]
        end

        if ( @favorite_pattern_number == 1 )
          full_msg = construct_favorite_pattern_number_1( severity, path, msg, opts )
        elsif ( @favorite_pattern_number == 2 )
          full_msg = construct_favorite_pattern_number_2( severity, path, msg, opts )
        else
          # A "favorite pattern" (better for performance) was not specified.  Construct a custom message
          full_msg = construct_custom_pattern( severity, path, msg, opts )
        end
      end


      ##
      # Should the caller component be added to the msg

      if ( ( opts && opts[:file] && opts[:line] && opts[:method] ) || !@@caller_enabled )
        # if file and line number are specified or the caller_enabled is disabled
        # then construct a formatted message that does NOT make use of the caller (caller is slow)
        append_caller_information = false
      elsif @@caller_enabled
        # else if the caller is enabled, make use of it
        append_caller_information = true
      else
        # Otherwise, do NOT use the caller (as it is slow)
        append_caller_information = false
      end


      ##
      # If the user has requested making use of the caller, then use it
      # Otherwise append what optional information we can determine

      if append_caller_information
        full_msg << " (#{caller(4)[0]})"
      else
        ##
        # Append some suffix info if it has been specified
        #
        if opts
          if opts[:file]
            full_msg << " (#{opts[:file]}"

            if opts[:line]
              full_msg << ":#{opts[:line]}"
            end

            if opts[:class] || opts[:method]
              full_msg << ":in `"
            
              if opts[:class] 
                full_msg << "#{opts[:class]}."
              end

              full_msg << "#{opts[:method]}" if opts[:method]
              full_msg << "'"
            end

            full_msg << ')'
          end
        end  
      end 


      ##
      # Append the backtrace information if it has been requested by the user                   
      if opts && opts[:backtrace] == true
        # Implicit return
        full_msg << " from:\n#{caller(4).take(10).join("\n")}"
      end

      full_msg
    end

    def self.caller_enabled=( boolean_value )
      @@caller_enabled = boolean_value
    end

    def self.caller_enabled
      @@caller_enabled
    end

    def self.append_caller_information?
      @@caller_enabled
    end

    def self.reset
      @favorite_pattern_number = nil 
    end


    protected

    def self.construct_favorite_pattern_number_1( severity, path, msg, opts )
      sprintf( "%6s pid-#{Process.pid} [#{Time.now.strftime( "%G-%m-%d %H:%M:%S:%L" )}] %47s - #{msg}", 
                        LogLevel.severity_to_s( severity ), 
                        ( path.length > 47 ) ? path.dup[-47,47] : path  )
    end

    def self.construct_favorite_pattern_number_2( severity, path, msg, opts )
      sprintf( "%6s pid-#{Process.pid} [#{Time.now.to_s}] %s - #{msg}", 
                         LogLevel.severity_to_s( severity ),
                         path )
    end 

    def self.construct_custom_pattern( severity, path, msg, opts )
      if opts && opts[:pattern]
        full_msg = opts[:pattern].dup    # dup may be extra work
      else
        full_msg = Manager::formatter_pattern.dup
      end

      full_msg.gsub! /%d/, Time.now.to_s
      full_msg.gsub! /%c/, LogLevel.severity_to_s(severity).rjust(6)
      full_msg.gsub! /%P/, Process.pid.to_s
      full_msg.gsub! /%p/, path
      full_msg.gsub! /%m/, msg
    end  

  end
end

