module Catamaran
  class Logger
    attr_accessor :name
    attr_accessor :path
    attr_reader :parent

    ## 
    # The getter associated with retrieving the current log level for this logger.
    # Similar is the smart_log_level getter

    def log_level( opts = {} )
      if instance_variable_defined?( :@log_level ) && @log_level
        retval = @log_level
      elsif self.parent.nil?
        # No parent means this logger(self) is the root logger.  So use the default log level
        retval = Catamaran::LogLevel.default_log_level()
      else
        recursive = opts[:recursive]
        if recursive == true 

          # Remember the log level we found so we don't have to recursively look for it ever time
          if !instance_variable_defined?( :@memoized_log_level ) || @memoized_log_level.nil?
            @memoized_log_level = parent.log_level( opts ) if parent
          end

          retval = @memoized_log_level
        else
          Catamaran.debugging( "Catamaran::Logger#log_level() - non-recrusive request for log level.  And log level is nil.  This shouldn't happen too often." ) if Catamaran.debugging?        
          retval = nil
        end
      end

      # Implicit return
      retval
    end

    ## 
    # We usually want a logger to have a level.   The smart_log_level() reader determines a log level even if one isn't
    # explicitly set on this logger instance by making use of recursion up to the root logger if needed

    def smart_log_level
      self.log_level( { :recursive => true } )
    end

    ##
    # Setter used to explicitly set the log level for this logger

    def log_level=( value )
      @log_level = value
      remove_instance_variable( :@memoized_log_level ) if instance_variable_defined?( :@memoized_log_level )      
    end

    ##
    # Is trace-level logging currently enabled?

    def trace?
      if self.smart_log_level() <= LogLevel::TRACE
        true
      else
        false
      end
    end

    def trace( msg, opts = nil )
      if trace?
        _write_to_log( LogLevel::TRACE, msg, opts )
      end
    end

    ##
    # Is debug-level logging currently enabled?

    def debug?
      if self.smart_log_level() <= LogLevel::DEBUG
        true
      else
        false
      end
    end

    def debug( msg, opts = nil )
      if debug?
        _write_to_log( LogLevel::DEBUG, msg, opts )
      end
    end


    ##
    # Is io-level logging currently enabled?

    def io?
      if self.smart_log_level() <= LogLevel::IO
        true
      else
        false
      end
    end

    def io( msg, opts = nil )
      if io?
        _write_to_log( LogLevel::IO, msg, opts )
      end
    end

    ##
    # Is info-level logging currently enabled?

    def info?
      if self.smart_log_level() <= LogLevel::INFO
        true
      else
        false
      end
    end

    def info( msg, opts = nil )
      if info?
        _write_to_log( LogLevel::INFO, msg, opts )
      end
    end 

    ##
    # Is warn-level logging currently enabled?

    def warn?
      if self.smart_log_level() <= LogLevel::WARN
        true
      else
        false
      end
    end

    def warn( msg, opts = nil )
      if warn?
        _write_to_log( LogLevel::WARN, msg, opts )
      end
    end     

    ##
    # Is error-level logging currently enabled?

    def error?
      if self.smart_log_level() <= LogLevel::ERROR
        true
      else
        false
      end
    end

    def error( msg, opts = nil )
      if error?
        _write_to_log( LogLevel::ERROR, msg, opts )
      end
    end 

    ##
    # Is severe-level logging currently enabled?

    def severe?
      if self.smart_log_level() <= LogLevel::SEVERE
        true
      else
        false
      end
    end

    def severe( msg, opts = nil )
      if severe?
        _write_to_log( LogLevel::SEVERE, msg, opts )
      end
    end   

    ##
    # Is fatal-level logging currently enabled?

    # def fatal?
    #   if self.smart_log_level() <= LogLevel::FATAL
    #     true
    #   else
    #     false
    #   end
    # end

    # def fatal( msg, opts = nil )
    #   if fatal?
    #     _write_to_log( LogLevel::FATAL, msg, opts )
    #   end
    # end            

    ##
    # Usually get_logger is a reference to self, unless a path has been specified as a parameter

    def get_logger( path = nil )
      current_logger = self
      if path
        method_names = path.split(/\./)

        method_names.each do |method_name|
          current_logger = current_logger.send( method_name.to_sym ) 
        end
      end

      # Implicit return
      current_logger
    end


    ##
    # method_missing provides a mechanism to create sub loggers.  
    # Let's say I have a logger and I want to create a sub logger
    #
    #    root_logger = CatLogger
    #    logger_reserved_for_app_stuff  = CatLogger.App   # App is a missing method
    #    logger_reserved_just_for_controller_stuff = CatLogger.App.Controller  # Controller is a missing method


    def method_missing( meth, *args, &block )
      Catamaran.debugging( "Catamaran::Logger#method_missing() - meth = #{meth}" )            

      if ( meth.to_sym == :define_method || meth.to_sym == :to_ary )
        # Catamaran.debugging( "Catamaran::Logger#method_missing() - ERROR!  Ignoring method: #{meth}" ) 
        _msg = "[CATAMARAN INTERNAL] Catamaran::Logger#method_missing() - ERROR!  Ignoring method: #{meth}"
        $stderr.puts( _msg )
        raise Exception.new _msg        
      else
        # Create a new logger object
        logger_obj = Logger.new( meth.to_s, self.path, self )

        # Keep track of this new sub-logger
        @sub_loggers[meth.to_sym] = logger_obj

        # Define a method so method_missing will not be called next time this method name is called
        singleton = class << self; self end
        singleton.send :define_method, meth.to_sym, lambda { 
          @sub_loggers[meth.to_sym] 
        } 
      end

      # Implicit return
      logger_obj
    end

    ##
    # Human-readable path

    def path_to_s
      _path = self.path
      if _path
        # Implicit return
        _path.join( delimiter )
      else
        # Implicit return
        nil
      end
    end

    ##
    # Forget any cached memoization log levels within this logger or within sub-loggers of this logger

    def forget_memoizations
      remove_instance_variable(:@memoized_log_level) if instance_variable_defined?( :@memoized_log_level )
      @sub_loggers.values.each do |logger|
        logger.forget_memoizations()
      end
    end


    ##
    # Number of loggers known about by this logger (including sub-loggers)

    def num_loggers
      retval = 1  # me!
      @sub_loggers.values.each do |logger|
        retval = retval + logger.num_loggers()
      end

      # Implicit return
      Catamaran.debugging( "Catamaran::Logger#num_loggers() - Returning #{retval} from '#{path_to_s()}'" )  if Catamaran.debugging?                 

      retval
    end

    def reset
      _reset()
      Catamaran.debugging( "Catamaran::Logger#reset() - Reset complete." )  if Catamaran.debugging?
    end

    def depth 
      @depth
    end

    def to_s
      # Implicit return
      "#<#{self.class}:0x#{object_id.to_s(16)}>[name=#{self.name},path=#{path_to_s},depth=#{self.depth},log_level=#{@log_level}]"
    end

    private

    ##
    # I used to delete the root level logger, but now I reset it instead.  
    # Among other reasons, the CatLogger constant now works

    def _reset
      remove_instance_variable(:@memoized_log_level) if instance_variable_defined?( :@memoized_log_level )      
      remove_instance_variable(:@log_level) if instance_variable_defined?( :@log_level )      

      self.name = @initialized_name
      self.path = @initialized_path_so_far ? @initialized_path_so_far.dup : []

      if @initialized_name && @initialized_name.length > 0  # Root logger has no name
        self.path << @initialized_name
      end

      @parent = @initialized_parent

      # @sub_loggers already exist, iterate through each and undefine the associated method missing
      if @sub_loggers
        @sub_loggers.keys.each do |method_name_as_symbol|
          Catamaran.debugging( "Catamaran::Logger#_reset() - Attempting to remove dynamically created method: #{method_name_as_symbol}" )  if Catamaran.debugging?

          singleton = class << self; self end
          singleton.send :remove_method, method_name_as_symbol 
        end
      end

      @sub_loggers = {}
    end

    ##
    # All log statements eventually call _write_to_log

    def _write_to_log( log_level, msg, opts )
      formatted_msg = Manager.formatter_class.construct_formatted_message( log_level, self.path_to_s(), msg, opts )
      Outputter.write( formatted_msg )
    end

    ##
    # Initialize this logger.

    def initialize( name, path_so_far, parent = nil )
      Catamaran.debugging( "Catamaran::Logger#initialize() - Entering with name = #{name ? name : '<nil>'}, path_so_far = #{path_so_far}, parent = #{parent ? parent : '<nil>'}" )  if Catamaran.debugging?
      
      @initialized_name = name
      @initialized_path_so_far = path_so_far ? path_so_far.dup : []
      @initialized_parent = parent

      if parent
        @depth = parent.depth + 1
      else
        @depth = 0
      end

      _reset()

      Catamaran.debugging( "Catamaran::Logger#initialize() - I am #{self.to_s}" )  if Catamaran.debugging?
    end

    ##
    # The delimiter is a period

    def delimiter
      "."
    end

  end
end 