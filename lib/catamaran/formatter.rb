module Catamaran
  class Formatter
    @@caller_enabled = false

    def self.construct_formatted_message( severity, path, msg, opts, pattern: "%c %P %d %p - %m" )
      msg = construct_from_pattern( pattern, {:severity => severity, :path => path, :msg => msg} ).join " "
      msg << append_caller_information(msg, opts)
      msg << append_backtrace_information(msg, opts)
      msg
    end

    def self.caller_enabled=( boolean_value )
      @@caller_enabled = boolean_value
    end

    def self.caller_enabled
      @@caller_enabled
    end

    def self.get_pid
      "pid-#{Process.pid}"
    end

    def self.get_severity severity
      LogLevel.severity_to_s(severity).rjust(6)
    end

    def self.get_date
      "[#{Time.now}]"
    end

    def self.tokenize pattern
      pattern.split " "
    end

    def self.append_caller_information?
      @@caller_enabled
    end

    def self.append_caller_information msg, opts
      return msg << " (#{caller(4)[0]})" if append_caller_information?
      msg << append_explicit_caller_information(msg, opts)
    end

    def self.append_explicit_caller_information msg, opts
      if opts[:file]
        msg << " (#{opts[:file]}"
        msg << ":#{opts[:line]}" if opts[:line]

        if opts[:class] || opts[:method]
          msg << ":in `"
          msg << "#{opts[:class]}." if opts[:class]
          msg << opts.fetch(:method, "")
          msg << "'"
        end

        msg << ')'
      end
      msg
    end

    def self.append_backtrace_information msg, opts
      msg << " from:\n#{caller(4).take(10).join("\n")}" if opts.fetch(:backtrace, false)
      msg
    end

    def self.construct_from_pattern pattern, error_detail
      tokens = tokenize pattern
      tokens.each_with_object([]) do | element, log_line |
        case element
        when '%c'
          log_line << get_severity(error_detail[:severity])
        when '%P'
          log_line << get_pid
        when '%d'
          log_line << get_date
        when '%p'
          log_line << error_detail[:path]
        when '%m'
          log_line << error_detail[:msg]
        else
          log_line << element
        end
      end
    end
  end
end

