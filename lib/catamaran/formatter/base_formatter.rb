module Catamaran
  module Formatter
    ##
    # Construct a properly formatted log message based

    class BaseFormatter
      def self.base_construct_formatted_message( severity, path, msg, opts )
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

      def self.construct_backtrace_info( opts )
        if opts && opts[:backtrace] == true
          # Implicit return
          " from:\n#{caller(5).take(10).join("\n")}"
        else
          # Implicit return
          ''
        end
      end


      def self.contruct_suffix_info( opts )
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


      def self.construct_class_method_info( opts )
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

    end
  end
end
      