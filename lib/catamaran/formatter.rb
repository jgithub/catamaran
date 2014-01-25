module Catamaran
  class Formatter
    @@caller_enabled = false

    def self.construct_formatted_message( severity, path, msg, opts={} )
      pattern = opts.fetch :pattern, "%c pid-%P [%d] %p - %m"
      msg = construct_from_pattern( pattern, {:severity => severity, :path => path, :msg => msg} )
      msg << append_caller_information(msg, opts)
      msg << append_backtrace_information(msg, opts)
      msg
    end

    def self.construct_from_pattern pattern, error_detail
      log_line = pattern
      log_line.gsub! /%d/, get_date
      log_line.gsub! /%c/, get_severity(error_detail[:severity])
      log_line.gsub! /%P/, get_pid
      log_line.gsub! /%p/, error_detail[:path]
      log_line.gsub! /%m/, error_detail[:msg]
    end

    def self.caller_enabled=( boolean_value )
      @@caller_enabled = boolean_value
    end

    def self.caller_enabled
      @@caller_enabled
    end

    def self.get_pid
      Process.pid.to_s
    end

    def self.get_severity severity
      LogLevel.severity_to_s(severity).rjust(6)
    end

    def self.get_date
      Time.now.to_s
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

  end
end

