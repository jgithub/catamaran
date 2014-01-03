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

    def self.reset
      self.send( :remove_const, 'IO' ) if self.const_defined?( 'IO' )
      self.const_set( 'IO', IO_LESS_CRITICAL_THAN_INFO )            
    end

    self.reset()
    

    def self.severity_to_s( severity )
      case severity
      when TRACE
        'TRACE'
      when DEBUG
        'DEBUG'
      when INFO
        'INFO'
      when NOTICE
        'NOTICE'
      when WARN
        'WARN'
      when ERROR
        'ERROR'
      when SEVERE
        'SEVERE'
      when FATAL
        'FATAL'
      when IO_LESS_CRITICAL_THAN_TRACE
        'IO'              
      when IO_LESS_CRITICAL_THAN_INFO
        'IO'
      when IO_LESS_CRITICAL_THAN_DEBUG
        'IO'  
      else
        # Unknown
        ''
      end
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