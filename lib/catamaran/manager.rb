module Catamaran
  class Manager
    class << self; 
      attr_accessor :_root_logger_instance; 
      attr_accessor :_stdout_flag; 
      attr_accessor :_stderr_flag;
      attr_accessor :_output_files; 

      ##
      # The default delimiter
      #
      def delimiter
        @delimiter || '.' 
      end      

      def delimiter=( value )
        @delimiter = value
      end
    end


    def self.formatter_caller_enabled=( boolean_value )
      Catamaran::Formatter.instance.caller_enabled = boolean_value
    end

    def self.formatter_caller_enabled
      # Implicit return
      Catamaran::Formatter.instance.caller_enabled
    end    



    ##
    # Used to reset Catamaran

    def self.reset( opts = {} )
      Catamaran.debugging( "Catamaran::Manager#reset - Resetting Catamaran with opts = #{opts}" ) if Catamaran.debugging?                  

      # Old way.   I used to null-out the old logger.   But resetting it is better for using the CatLogger constant
      # self.send( :_root_logger_instance=, nil )

      # New way
      root_logger = self.send( :_root_logger_instance )
      root_logger.reset( opts ) if root_logger

      # Also reset the default log level
      Catamaran::LogLevel::reset
      
      # Resetting Catamaran probably should not reset the output settings
      # self.send( :_stdout_flag=, nil )
      # self.send( :_stderr_flag=, nil )
      # self.send( :_output_files=, nil )
    end

    def self.hard_reset( opts = {} )
      opts = opts.dup
      opts[:hard_reset] = true      
      self.reset( opts )
    end




    ##
    # Allow the client to access the root logger

    def self.root_logger
      logger = self.send( :_root_logger_instance )

      unless logger
        Catamaran.debugging( "Catamaran::Logger#root_logger() - Initializing new root logger" ) if Catamaran.debugging?                  

        path_so_far = []
        logger = Logger.new( nil, path_so_far )

        self.send( :_root_logger_instance=, logger )

        # Get the instance back as a double-confirm
        logger = self.send( :_root_logger_instance )
      end

      if logger && logger.instance_of?( Catamaran::Logger ) 
        Catamaran.debugging( "Catamaran::Logger#root_logger() - Returning #{logger}" ) if Catamaran.debugging?
      else
        Catamaran.debugging( "Catamaran::Logger#root_logger() - Error!  root logger is not an instance of Logger as would expect" ) if Catamaran.debugging?
      end

      logger
    end

    ##
    # Specify a destination location for logs

    def self.add_output_file( output_file )
      unless self.send( :_output_files )
        self.send( :_output_files=, [] )
      end

      self.send( :_output_files ).push( output_file )

      Catamaran.debugging( "Catamaran::Logger#add_output_file() - Added output file: #{output_file}.   Number of _loggers is now #{self.send( :_output_files ).length}" ) if Catamaran.debugging?                 
    end   

    def self.output_files
      self.send( :_output_files )
    end 

    ##
    # Memoizations are used to cache log levels.  Used to clear out the memoization cache.

    def self.forget_memoizations
      self.root_logger().forget_memoizations()
    end

    def self.forget_cached_log_levels
      self.forget_memoizations
    end

    ##
    # How many loggers is Catamaran currently aware of

    def self.num_loggers
      self.root_logger().num_loggers()
    end

    ##
    # Call this method with true if you'd like Catamaran to write logs to STDOUT

    def self.stdout=( bool )
      self.send( :_stdout_flag=, bool )
    end

    ##
    # Is logging to STDOUT enabled?

    def self.stdout?
      if self.send( :_stdout_flag ) == true
        true
      else
        false
      end
    end

    ##
    # Call this method with true if you'd like Catamaran to write logs to STDERR

    def self.stderr=( bool )
      self.send( :_stderr_flag=, bool )
    end

    ##
    # Is logging to STDERR enabled?

    def self.stderr?
      if self.send( :_stderr_flag ) == true
        true
      else
        false
      end
    end 

    private_class_method :_root_logger_instance
    private_class_method :_stdout_flag
    private_class_method :_stderr_flag
           
  end
end