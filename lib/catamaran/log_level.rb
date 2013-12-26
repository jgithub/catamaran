module Catamaran
  class LogLevel
    # By default, logger.io messages will be captured when the log level is DEBUG (IO_LESS_CRITICAL_THAN_INFO)
    # If that's too verbose, the level can be changed to IO_LESS_CRITICAL_THAN_DEBUG and logger.io messages won't be
    # visible unless the log level is set to TRACE.  
    # See development.rb for an example of this
    IO_LESS_CRITICAL_THAN_DEBUG = 2080
    IO_LESS_CRITICAL_THAN_INFO = 3080

    BACKTRACE_LESS_CRITICAL_THAN_TRACE = 1070
    BACKTRACE_LESS_CRITICAL_THAN_DEBUG = 2070
    BACKTRACE_LESS_CRITICAL_THAN_INFO = 3070

    ALL = 100

    TRACE = 2000 
    DEBUG = 3000
    INFO = 4000
    WARN = 5000
    ERROR = 6000
    SEVERE = 7000
    FATAL = 8000

    IO = IO_LESS_CRITICAL_THAN_INFO
    BACKTRACE = BACKTRACE_LESS_CRITICAL_THAN_INFO



    def self.reset
      @@default_log_level = INFO

      self.send( :remove_const, 'IO' ) if self.const_defined?( 'IO' )
      self.const_set( 'IO', IO_LESS_CRITICAL_THAN_INFO )      

      self.send( :remove_const, 'BACKTRACE' ) if self.const_defined?( 'BACKTRACE' )
      self.const_set( 'BACKTRACE', BACKTRACE_LESS_CRITICAL_THAN_INFO )       
    end

    self.reset()
    

    def self.to_s( log_level )
      case log_level
      when TRACE
        retval = 'TRACE'
      when DEBUG
        retval = 'DEBUG'
      when INFO
        retval = 'INFO'
      when WARN
        retval = 'WARN'
      when ERROR
        retval =  'ERROR'
      when SEVERE
        retval =  'SEVERE'
      when FATAL
        retval =  'FATAL'
      when IO_LESS_CRITICAL_THAN_INFO
        retval =  'IO'
      when IO_LESS_CRITICAL_THAN_DEBUG
        retval =  'IO'
      end

      retval
    end

    def self.default_log_level
      @@default_log_level
    end    

    def self.default_log_level=( value )
      Catamaran.debugging( "Catamaran::LogLevel#default_log_level=() - Switching the default log level to #{value}" ) if Catamaran.debugging?            
      @@default_log_level = value
    end

    def self.log_level_io=( value )
      self.send( :remove_const, 'IO' ) if self.const_defined?( 'IO' )
      self.const_set( 'IO', value )
    end

    def self.log_level_io
      IO
    end 

    def self.log_level_backtrace=( value )
      self.send( :remove_const, 'BACKTRACE' ) if self.const_defined?( 'BACKTRACE' )
      self.const_set( 'BACKTRACE', value ) 
    end

    def self.log_level_backtrace
      BACKTRACE
    end        
  end
end