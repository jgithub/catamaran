module Catamaran
  class Logger
    attr_accessor :name
    attr_accessor :path
    attr_reader :parent
    attr_reader :specified_file
    attr_reader :specified_class

    ## 
    # The getter associated with retrieving the current log level for this logger.
    # Similar is the smart_log_level getter

    def log_level( opts = nil )
      if @log_level
        # Implicit return
        @log_level
      elsif self.parent.nil?
        # No parent means this logger(self) is the root logger.  So use the default log level
        if !@memoized_log_level
          if ENV['CATAMARAN_ROOT_LOGGER_LOG_LEVEL']
            @memoized_log_level = LogLevel.string_to_severity( ENV['CATAMARAN_ROOT_LOGGER_LOG_LEVEL'] )
          else
            @memoized_log_level = Catamaran::LogLevel::NOTICE
          end
        end

        # Implicit return
        @memoized_log_level
      else
        recursive = ( opts && ( opts[:recursive] == true || opts[:be_populated] == true ) )
        if recursive == true 

          # Remember the log level we found so we don't have to recursively look for it ever time
          if @memoized_log_level.nil?
            @memoized_log_level = parent.log_level( opts ) if parent
          end

          # Implicit return
          @memoized_log_level
        else
          Catamaran.debugging( "Catamaran::Logger#log_level() - non-recrusive request for log level.  And log level is nil.  This shouldn't happen too often." ) if Catamaran.debugging?        
          
          # Implicit return
          nil
        end
      end
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
      if value 
        if value.kind_of?( Symbol )
          @log_level = LogLevel.symbol_to_severity( value )
        elsif value.kind_of?( String )
          @log_level = LogLevel.string_to_severity( value )
        else 
          @log_level = value
        end     
      else
        @log_level = nil
      end
      
      @memoized_log_level = nil      
    end












    def backtrace_log_level( opts = {} )
      if @backtrace_log_level
        retval = @backtrace_log_level
      elsif self.parent.nil?
        # No parent means this logger(self) is the root logger.  So use the default log level
        retval = Catamaran::LogLevel::WARN
      else
        recursive = opts[:recursive]
        if recursive == true 

          # Remember the log level we found so we don't have to recursively look for it ever time
          if @memoized_backtrace_log_level.nil?
            @memoized_backtrace_log_level = parent.backtrace_log_level( opts ) if parent
          end

          retval = @memoized_backtrace_log_level
        else
          Catamaran.debugging( "Catamaran::Logger#backtrace_log_level() - non-recrusive request for log level.  And log level is nil.  This shouldn't happen too often." ) if Catamaran.debugging?        
          retval = nil
        end
      end

      # Implicit return
      retval
    end

    ## 
    # We usually want a logger to have a level.   The smart_backtrace_log_level() reader determines a log level even if one isn't
    # explicitly set on this logger instance by making use of recursion up to the root logger if needed

    def smart_backtrace_log_level
      self.backtrace_log_level( { :recursive => true } )
    end

    ##
    # Setter used to explicitly set the log level for this logger

    def backtrace_log_level=( value )
      @backtrace_log_level = value
      @memoized_backtrace_log_level = nil  
    end





    ##
    # Severity-specific log methods

    def trace( msg, opts = nil )
      if trace?
        log( LogLevel::TRACE, msg, opts )
      end
    end

    def debug( msg, opts = nil )
       if debug?
        log( LogLevel::DEBUG, msg, opts )
      end
    end

    def io( msg, opts = nil )
      if io?
        log( LogLevel::IO, msg, opts )
      end
    end

    def info( msg, opts = nil )
      if info?
        log( LogLevel::INFO, msg, opts )
      end
    end 

    def notice( msg, opts = nil )
      if notice?
        log( LogLevel::NOTICE, msg, opts )
      end
    end    

    def warn( msg, opts = nil )
      if warn?
        log( LogLevel::WARN, msg, opts )
      end
    end     

    def error( msg, opts = nil )
      if error?
        log( LogLevel::ERROR, msg, opts )
      end
    end 

    def severe( msg, opts = nil )
      if severe?
        log( LogLevel::SEVERE, msg, opts )
      end
    end   

    def fatal( msg, opts = nil )
      if fatal?
        log( LogLevel::FATAL, msg, opts )
      end
    end            




    ##
    # Usually get_logger is a reference to self, unless a path has been specified as a parameter

    def get_logger( *args )        
      current_logger = self

      path, opts = determine_path_and_opts_arguments( *args )
      Catamaran.debugging( "Catamaran::Logger#get_logger() - path = '#{path}'  opts = #{opts} from args = #{args}" ) if Catamaran.debugging?        

        
      if path
        method_names = path.split(/\.|\:\:/)

        method_names.each do |method_name|
          current_logger = current_logger.send( method_name.to_sym ) 
        end
      end

      if opts
        if opts[:file]
          current_logger.instance_variable_set( :@specified_file, opts[:file] )
        end

        if opts[:class]
          current_logger.instance_variable_set( :@specified_class, opts[:class] )
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
      unless @memoized_delimiter
        @memoized_delimiter = Catamaran::Manager.delimiter
      end

      _path = self.path
      if _path
        # Implicit return
        _path.join( @memoized_delimiter )
      else
        # Implicit return
        nil
      end
    end

    ##
    # Forget any cached memoization log levels within this logger or within sub-loggers of this logger

    def forget_memoizations
      @memoized_log_level = nil
      @memoized_backtrace_log_level = nil
      @memoized_delimiter = nil

      # This is arguably a form of memoization
      define_all_logging_conditional_defaults()

      @sub_loggers.values.each do |logger|
        logger.forget_memoizations()
      end
    end



    def define_all_logging_conditional_defaults
      [ :io, :trace, :debug, :info, :notice, :warn, :error, :severe, :fatal ].each do |log_level_as_symbol|
        define_default_logging_conditional( log_level_as_symbol )
      end
    end

    def define_default_logging_conditional( log_level_as_symbol )
      singleton = class << self; self end
      singleton.send( :define_method, "#{log_level_as_symbol}?".to_sym ) do
        if self.log_level( { :be_populated => true } ) <= LogLevel.symbol_to_severity( log_level_as_symbol )
          inner_singleton = class << self; self end
          inner_singleton.send( :define_method, "#{log_level_as_symbol}?".to_sym ) do
            true
          end 

          true
        else
          inner_singleton = class << self; self end
          inner_singleton.send( :define_method, "#{log_level_as_symbol}?".to_sym ) do
            false
          end 

          false
        end
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


    ##
    # I used to delete the root level logger, but now I reset it instead.  
    # Among other reasons, the CatLogger constant now works.
    # Unless otherwise specified, a reset() is a soft reset by default.

    def reset( opts = {} )
      @log_level = nil 
      @backtrace_log_level = nil

      forget_memoizations()

      self.name = @initialized_name
      self.path = @initialized_path_so_far ? @initialized_path_so_far.dup : []

      if @initialized_name && @initialized_name.length > 0  # Root logger has no name
        self.path << @initialized_name
      end

      @parent = @initialized_parent



      if opts[:hard_reset]
        ##
        # Hard reset - delete the sub-loggers by removing references to them

        # @sub_loggers already exist, iterate through each and undefine the associated method missing
        @sub_loggers.keys.each do |method_name_as_symbol|
          Catamaran.debugging( "Catamaran::Logger#reset() - Attempting to remove dynamically created method: #{method_name_as_symbol}" )  if Catamaran.debugging?
          singleton = class << self; self end
          singleton.send :remove_method, method_name_as_symbol 
        end if @sub_loggers

        @sub_loggers = {}
        Catamaran.debugging( "Catamaran::Logger#reset() - Hard reset complete for #{self}." )  if Catamaran.debugging?
      else
        ##
        # Soft reset - reset each of the sub-loggers

        # @sub_loggers already exist, iterate through each and reset them
        @sub_loggers.values.each do |logger|
          logger.reset()
        end if @sub_loggers
        Catamaran.debugging( "Catamaran::Logger#reset() - Soft reset complete for #{self}." )  if Catamaran.debugging?        
      end
    end

    def soft_reset( opts = {} )
      # This is a soft reset 
      opts = opts.dup
      opts[:hard_reset] = false      
      reset( opts )
    end

    def hard_reset( opts = {} )
      # This is a hard reset 
      opts = opts.dup
      opts[:hard_reset] = true
      reset( opts )
    end


    def depth 
      @depth
    end

    def to_s
      # Implicit return
      "#<#{self.class}:0x#{object_id.to_s(16)}>[name=#{self.name},path=#{path_to_s},depth=#{self.depth},log_level=#{@log_level},backtrace_log_level=#{@backtrace_log_level}]"
    end

    protected

      

    def determine_path_and_opts_arguments( *args )
      Catamaran.debugging( "Catamaran::Logger#reset() - Entering with args = #{args}" )  if Catamaran.debugging?

      if ( args.length == 0 )
        opts = nil
        path = nil
      elsif ( args.length == 1 )
        argument1 = args[0]

        if ( argument1.nil? )
          path = nil
          opts = nil
        elsif ( argument1.kind_of?( String ) )
          path = argument1
          opts = nil
        elsif ( argument1.kind_of?( Hash ) )
          path = nil
          opts = argument1
        else
          raise ArgumentError.new "Unsupported argument type"
        end
      elsif ( args.length == 2 )
        path, opts = *args
      else
        raise ArgumentError.new "Unexpected number of arguments: #{args.length}"
      end 

      [ path, opts ]
    end   

    private


    ##
    # All log statements eventually call log

    def log( severity, msg, opts )

      if self.specified_file || self.specified_class
        opts = {} unless opts
        opts[:file] = self.specified_file if self.specified_file
        opts[:class] = self.specified_class if self.specified_class
      end

      if opts && opts[:backtrace] == true
        _smart_backtrace_log_level = self.backtrace_log_level( { :recursive => true } )

        # If the specified log message has a level that's 
        # greater than or equal to the current backtrace_log_level
        Catamaran.debugging( "Catamaran::Logger#initialize() - Considering a backtrace:  severity = #{severity}, backtrace_log_level = #{_smart_backtrace_log_level}" )  if Catamaran.debugging?


        if severity >= _smart_backtrace_log_level
          # no-op -- display the backtrace
        else
          # overwrite opts with a new value

          # For performance it's probably acceptable to just remove the backtrace option from the options list...
          # opts.delete(:backtrace)
        
          # But for now it might be cleaner to duplicate the hash first, before modifying it 
          opts = opts.dup
          opts.delete( :backtrace )
        end
      end

      # Implicit return
      Outputter.write( _format_msg( severity, msg, opts ) )
    end


    def _format_msg( severity, msg, opts )
      # Implicit return
      Formatter.construct_formatted_message( severity, self.path_to_s(), (msg && msg.respond_to?(:force_encoding) ? msg.force_encoding('UTF-8') : msg), opts )
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

      # Create the hash of sub_loggers as needed
      @sub_loggers ||= {}

      # These will all be set to nil as part of the reset()
      # @memoized_log_level = nil
      # @log_level = nil
      # @backtrace_log_level = nil
      # @memoized_backtrace_log_level = nil

      reset()

      Catamaran.debugging( "Catamaran::Logger#initialize() - I am #{self.to_s}" )  if Catamaran.debugging?
    end

  end
end 
