module Catamaran
  class LogLevel
    # By default, logger.io messages will be captured when the log level is DEBUG (IO_LESS_CRITICAL_THAN_INFO)
    # If that's too verbose, the level can be changed to IO_LESS_CRITICAL_THAN_DEBUG and logger.io messages won't be
    # visible unless the log level is set to TRACE.  
    # See development.rb for an example of this
    IO_LESS_CRITICAL_THAN_TRACE = 1780
    IO_LESS_CRITICAL_THAN_DEBUG = 2780
    IO_LESS_CRITICAL_THAN_INFO = 3780
    

    ALL = 100

    TRACE = 2000 
    DEBUG = 3000
    INFO = 4000
    # Adding notice per http://www.faqs.org/rfcs/rfc3164.html
    NOTICE = 5000  
    WARN = 6000
    ERROR = 7000
    SEVERE = 8000  # versus critical
    
    # FATAL is currently unused.  In logger.rb you can see the fatal-related methods are commented out
    FATAL = 9000   # versus alert
                   # versus emergency

    IO = IO_LESS_CRITICAL_THAN_INFO


    SEVERITY_TO_STRING_MAP = {
      TRACE => 'TRACE',
      DEBUG => 'DEBUG',
      INFO => 'INFO',
      NOTICE => 'NOTICE',
      WARN => 'WARN',
      ERROR => 'ERROR',
      SEVERE => 'SEVERE',
      FATAL => 'FATAL',
      IO_LESS_CRITICAL_THAN_TRACE => 'IO',
      IO_LESS_CRITICAL_THAN_INFO => 'IO',
      IO_LESS_CRITICAL_THAN_DEBUG => 'IO'
    }

    STRING_TO_SEVERITY_MAP = {
      'TRACE' => TRACE,
      'DEBUG' => DEBUG,
      'INFO' => INFO,
      'NOTICE' => NOTICE,
      'WARN' => WARN,
      'ERROR' => ERROR,
      'SEVERE' => SEVERE,
      'FATAL' => FATAL
    }

    SYMBOL_TO_SEVERITY_MAP = {
      :trace => TRACE,
      :debug => DEBUG,
      :info => INFO,
      :notice => NOTICE,
      :warn => WARN,
      :error => ERROR,
      :severe => SEVERE,
      :fatal => FATAL
    }         


    def self.reset
      self.send( :remove_const, 'IO' ) if self.const_defined?( 'IO' )
      self.const_set( 'IO', IO_LESS_CRITICAL_THAN_INFO )            
    end

    self.reset()
    

    def self.severity_to_s( severity )
      SEVERITY_TO_STRING_MAP[severity] || ''
    end  

    def self.string_to_severity( str )
      str ? STRING_TO_SEVERITY_MAP[str.strip.upcase] : nil
    end     

    def self.symbol_to_severity( sym )
      sym ? SYMBOL_TO_SEVERITY_MAP[sym] : nil
    end 

    def self.log_level_io=( value )
      self.send( :remove_const, 'IO' ) if self.const_defined?( 'IO' )
      self.const_set( 'IO', value )
    end

    def self.log_level_io
      IO
    end        
  end
end