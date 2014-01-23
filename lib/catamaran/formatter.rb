module Catamaran
  class Formatter
    # Using caller() in the log messages is DISABLED by default
    @@caller_enabled = false

    def self.caller_enabled=( boolean_value )
      @@caller_enabled = boolean_value
    end

    def self.caller_enabled
      @@caller_enabled
    end

    ##
    # Construct a properly formatted log message based

    def self.get_pid
      "pid-#{Process.pid}"
    end

    def self.get_severity severity
      LogLevel.severity_to_s(severity).rjust(6)
    end

    def self.get_date
      "[#{Time.now}]"
    end

    def self.parse_elements pattern, data
      pattern.each_with_object([]) do | element, log_line |
        case element
        when '%c'
          log_line << get_severity(data[:severity])
        when '%P'
          log_line << get_pid
        when '%d'
          log_line << get_date
        when '%p'
          log_line << data[:path]
        when '%m'
          log_line << data[:msg]
        else
          log_line << element
        end
      end
    end

    def self.construct_formatted_message( severity, path, msg, opts )
      pattern = "%c %P %d %p - %m".split(" ")
      log_elements = parse_elements pattern, {:severity => severity, :path => path, :msg => msg}
      return log_elements.join " "

      # msg = sprintf( "%6s pid-#{Process.pid} [#{Time.now.strftime( "%G-%m-%d %H:%M:%S:%L" )}] %47s - #{msg}",
                    # LogLevel.severity_to_s( severity ),
                    # ( path.length > 47 ) ? path.dup[-47,47] : path  )



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
        msg << " (#{caller(4)[0]})"
      else
        ##
        # Append some suffix info if it has been specified
        #
        if opts
          if opts[:file]
            msg << " (#{opts[:file]}"

            if opts[:line]
              msg << ":#{opts[:line]}"
            end

            if opts[:class] || opts[:method]
              msg << ":in `"

              if opts[:class]
                msg << "#{opts[:class]}."
              end

              msg << "#{opts[:method]}" if opts[:method]
              msg << "'"
            end

            msg << ')'
          end
        end
      end


      ##
      # Append the backtrace information if it has been requested by the user
      if opts && opts[:backtrace] == true
        # Implicit return
        msg << " from:\n#{caller(4).take(10).join("\n")}"
      end

      # Implicit return
      msg
    end
  end
end

