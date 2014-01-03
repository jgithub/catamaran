require 'spec_helper'

describe Catamaran do
  before(:each) do
    Catamaran::Manager.stderr = false
  end

  it "should define TRACE" do
    Catamaran::LogLevel::TRACE.should > 0
  end

  it "should have a version" do
    Catamaran::VERSION.length.should > 0
  end

  it "should reuse the same root logger instance" do
    Catamaran.logger.object_id.should == Catamaran.logger.object_id
  end

  context "when working with a blank path" do
    it "should reuse the same root logger instance" do
      Catamaran.logger( '' ).object_id.should == Catamaran.logger.object_id
    end
  end  

  it "should reuse the same logger instance when contextually the same" do
    Catamaran.logger.com.mycompany.myrailsproject.app.models.User.object_id.should == Catamaran.logger.com.mycompany.myrailsproject.app.models.User.object_id
  end  

  it "should reuse the same logger instance when contextually the same regardless of if the logger was determined by a string or by sequential method calls" do
    Catamaran.logger( "com.mycompany.myrailsproject.app.models.User" ).object_id.should == Catamaran.logger.com.mycompany.myrailsproject.app.models.User.object_id        
  end  

  it "should provide access to the root logger through CatLogger" do
    CatLogger.object_id.should == Catamaran::Manager.root_logger.object_id
    Catamaran.logger.object_id.should == CatLogger.object_id
  end

  it "should define Catamaran.logger and Catamaran.get_logger methods.  They should be equivalent." do
    Catamaran.logger.object_id.should == Catamaran::get_logger.object_id
  end

  it "should provide access to loggers after a reset" do
    logger = Catamaran.logger.com.mycompany.myrailsproject.app.models.User
    Catamaran::Manager.reset
    logger2 = Catamaran.logger.com.mycompany.myrailsproject.app.models.User
    logger2.should be_instance_of( Catamaran::Logger )
    logger2.object_id.should == logger.object_id
  end

  it "should create a new loggers for each point in the path" do
    Catamaran.logger
    Catamaran::Manager.num_loggers.should == 1
    Catamaran.logger.com.mycompany.myrailsproject.app.models.User
    Catamaran::Manager.num_loggers.should == 7    
  end     

  it "should be possible for the user to modify the log level of root logger" do
    Catamaran.logger.log_level = Catamaran::LogLevel::TRACE
    Catamaran.logger.log_level.should == Catamaran::LogLevel::TRACE
  end

  it "should be possible for the user to modify the log level of non-root loggers" do
    Catamaran.logger.whatever.log_level.should be_nil
    Catamaran.logger.whatever.log_level = Catamaran::LogLevel::TRACE
    Catamaran.logger.whatever.log_level.should == Catamaran::LogLevel::TRACE
  end  

  it "should not provide the same object ID for different paths" do
    Catamaran.logger.A.C.object_id.should_not == Catamaran.logger.B.C
    Catamaran.logger.A.C.object_id.should_not == Catamaran.logger.A.B
  end  

  context "by default" do
    it "should log INFO messages" do
      logger = Catamaran.logger.com.mycompany.myrailsproject.app.models.User
    end

    it "should NOT log DEBUG messages" do
      logger = Catamaran.logger.com.mycompany.myrailsproject.app.models.User
    end

    describe "the Root Logger" do
      it "should have a log level set to NOTICE" do
        Catamaran.logger.log_level.should == Catamaran::LogLevel::NOTICE
      end

      it "should have a backtrace log level set to WARN" do
        Catamaran.logger.backtrace_log_level.should == Catamaran::LogLevel::WARN
      end      
    end

    describe "a non-root Logger" do
      before(:each) do
        @non_root_logger = Catamaran.logger.whatever
      end


      it "should have an empty log level" do
        @non_root_logger.log_level.should be_nil
      end

      it "should have a backtrace log level set to WARN" do
        @non_root_logger.backtrace_log_level.should be_nil
      end 

      it "should have a smart log level set to NOTICE" do
        @non_root_logger.smart_log_level.should == Catamaran::LogLevel::NOTICE
      end

      it "should have a smart backtrace log level set to WARN" do
        @non_root_logger.smart_backtrace_log_level.should == Catamaran::LogLevel::WARN
      end      
    end    

    describe "Catamaran::Manager" do
      it "should have one logger configured" do
        Catamaran::Manager.num_loggers.should == 1
      end
    end

    it "should have an IO log level that corresponds to IO_LESS_CRITICAL_THAN_INFO" do
      Catamaran::LogLevel::IO.should == Catamaran::LogLevel::IO_LESS_CRITICAL_THAN_INFO
    end
  end

  context "after a (soft) reset" do
    describe "the Root Logger" do
      it "should have a log level of NOTICE" do
        logger = Catamaran.logger
        logger.log_level = Catamaran::LogLevel::ERROR
        logger.log_level.should == Catamaran::LogLevel::ERROR
        Catamaran::Manager.reset
        logger.log_level.should == Catamaran::LogLevel::NOTICE      
      end

      it "should have a backtrace log level of WARN" do
        logger = Catamaran.logger
        logger.backtrace_log_level = Catamaran::LogLevel::ERROR
        logger.backtrace_log_level.should == Catamaran::LogLevel::ERROR
        Catamaran::Manager.reset
        logger.backtrace_log_level.should == Catamaran::LogLevel::WARN      
      end 
    end   

    it "should have the same number of loggers" do
      Catamaran.logger
      Catamaran::Manager.num_loggers.should == 1
      Catamaran.logger.com.mycompany.myrailsproject.app.models.User
      Catamaran::Manager.num_loggers.should == 7 
      Catamaran::Manager.reset
      Catamaran::Manager.num_loggers.should == 7      
    end

    it "should have the same root logger object before and after the reset" do
      before_logger = Catamaran.logger
      Catamaran::Manager.reset
      Catamaran.logger.object_id.should == before_logger.object_id        
    end

    it "should reuse the same logger non-root logger instance" do
      before_logger = Catamaran.logger.com.mycompany.myrailsproject.app.models.User
      Catamaran::Manager.reset
      before_logger.object_id.should == Catamaran.logger.com.mycompany.myrailsproject.app.models.User.object_id   
    end      
  end

  context "after a hard reset" do
    it "should have a default log level of NOTICE" do
      logger = Catamaran.logger
      logger.log_level.should == Catamaran::LogLevel::NOTICE
      logger.log_level = Catamaran::LogLevel::ERROR
      logger.log_level.should == Catamaran::LogLevel::ERROR
      Catamaran::Manager.hard_reset
      logger.log_level.should == Catamaran::LogLevel::NOTICE      
    end

    it "should reset the number of loggers to 1" do
      Catamaran.logger
      Catamaran::Manager.num_loggers.should == 1
      Catamaran.logger.com.mycompany.myrailsproject.app.models.User
      Catamaran::Manager.num_loggers.should == 7 
      Catamaran::Manager.hard_reset
      Catamaran::Manager.num_loggers.should == 1      
    end

    it "should have the same root logger object before and after the reset" do
      before_logger = Catamaran.logger
      Catamaran::Manager.hard_reset
      Catamaran.logger.object_id.should == before_logger.object_id        
    end

    it "should NOT reuse the same non-root logger instance" do
      before_logger = Catamaran.logger.com.mycompany.myrailsproject.app.models.User
      Catamaran::Manager.hard_reset
      before_logger.object_id.should_not == Catamaran.logger.com.mycompany.myrailsproject.app.models.User.object_id   
    end     
  end

  describe "Backtrace Logging" do
    it "should capture a backtrace when the requested log is DEBUG and the log_level and backtrace_log_level are TRACE" do
      logger = Catamaran.logger
      logger.should_receive( :_format_msg ).with( Catamaran::LogLevel::DEBUG, 'message', {:backtrace=>true} )
      logger.log_level = Catamaran::LogLevel::TRACE
      logger.backtrace_log_level = Catamaran::LogLevel::TRACE
      Catamaran.logger.debug( "message", { :backtrace => true } ) if Catamaran.logger.debug?
    end

    it "should capture a backtrace when the requested log is DEBUG and the log_level and backtrace_log_level are DEBUG" do
      logger = Catamaran.logger
      logger.should_receive( :_format_msg ).with( Catamaran::LogLevel::DEBUG, 'message', {:backtrace=>true} )
      logger.log_level = Catamaran::LogLevel::DEBUG
      logger.backtrace_log_level = Catamaran::LogLevel::DEBUG
      Catamaran.logger.debug( "message", { :backtrace => true } ) if Catamaran.logger.debug?
    end    

    it "should capture a backtrace when the requested log is DEBUG and the log_level is TRACE and the backtrace_log_level is DEBUG" do
      logger = Catamaran.logger
      logger.should_receive( :_format_msg ).with( Catamaran::LogLevel::DEBUG, 'message', {:backtrace=>true} )
      logger.log_level = Catamaran::LogLevel::TRACE
      logger.backtrace_log_level = Catamaran::LogLevel::DEBUG
      Catamaran.logger.debug( "message", { :backtrace => true } ) if Catamaran.logger.debug?
    end

    it "should NOT capture a backtrace when the backtrace_log_level is greater than the severity of the log" do
      logger = Catamaran.logger
      logger.log_level = Catamaran::LogLevel::TRACE
      logger.backtrace_log_level = Catamaran::LogLevel::WARN      
      logger.should_receive( :_format_msg ).with( Catamaran::LogLevel::DEBUG, 'message', {} )
      Catamaran.logger.debug( "message", { :backtrace => true } ) if Catamaran.logger.debug?
    end    
  end

  describe Catamaran::Manager do
    describe "#reset" do
      it "should call reset on the root logger" do
        root_logger = Catamaran.logger
        root_logger.should_receive( :reset ).once
        Catamaran::Manager.reset
      end
    end

     describe "#forget_memoizations" do
      it "should forget all the memoized log levels" do
        Catamaran.logger.log_level = Catamaran::LogLevel::ERROR
        Catamaran.logger.Test.smart_log_level.should == Catamaran::LogLevel::ERROR   
        Catamaran.logger.log_level = Catamaran::LogLevel::INFO   
        Catamaran.logger.Test.smart_log_level.should == Catamaran::LogLevel::ERROR  
        Catamaran.logger.forget_memoizations
        Catamaran.logger.Test.smart_log_level.should == Catamaran::LogLevel::INFO  
      end
    end   
  end

  describe Catamaran::Logger do
    it "should inherit it's log level (via smart_log_level) from an ancestor" do
      Catamaran.logger.com.mycompany.myproject.controllers.log_level = Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myproject.controllers.MyController.smart_log_level.should == Catamaran::LogLevel::ERROR
    end 

    it "should inherit the log level from the root logger as needed" do
      root_log_level = Catamaran.logger.smart_log_level      
      Catamaran.logger.com.mycompany.myrailsproject.app.models.User.log_level.should be_nil     
      Catamaran.logger.com.mycompany.myrailsproject.app.models.User.smart_log_level.should == root_log_level
    end

    it "should have a nil log_level unless explicitly set" do
      Catamaran.logger.com.mycompany.myrailsproject.app.models.User.log_level.should be_nil     
    end

    it "should always have a smart_log_level set" do
      Catamaran.logger.whatever.log_level.should be_nil           
      Catamaran.logger.whatever.smart_log_level.should_not be_nil
    end    

    it "should support the TRACE log severity and trace()" do
      Catamaran.logger.log_level = Catamaran::LogLevel::TRACE
      Catamaran.logger.should_receive( :log ).once
      Catamaran.logger.trace( "A TRACE log should be received" )
    end

    it "should support the TRACE log severity and trace?()" do
      Catamaran.logger.log_level = Catamaran::LogLevel::TRACE      
      Catamaran.logger.trace?.should be_true
    end

    it "should support the FATAL log severity and fatal()" do
      Catamaran.logger.smart_log_level.should < Catamaran::LogLevel::FATAL
      Catamaran.logger.should_receive( :log ).once
      Catamaran.logger.fatal( "A FATAL log should be received" )
    end

    it "should support the FATAL log severity and fatal?()" do
      Catamaran.logger.smart_log_level.should < Catamaran::LogLevel::FATAL
      Catamaran.logger.fatal?.should be_true
    end    

    it "should write the log message if the requested log does have sufficient severity" do
      Catamaran.logger.smart_log_level.should <= Catamaran::LogLevel::NOTICE
      Catamaran.logger.should_receive( :log ).once
      Catamaran.logger.notice( "A NOTICE log should be received" )
    end

    it "should NOT write the log message if the requested log does not have sufficient severity" do
      Catamaran.logger.smart_log_level.should > Catamaran::LogLevel::DEBUG
      Catamaran.logger.should_not_receive( :log )
      Catamaran.logger.debug( "And INFO log should NOT be received" )
    end

    describe "#determine_path_and_opts_arguments" do
      it "should return the correct path when one string parameter is specified" do
        Catamaran.logger.send( :determine_path_and_opts_arguments, "mycompany.myrailsproject.app.models.User" ).should == [ "mycompany.myrailsproject.app.models.User", nil ]
      end

      it "should return the correct opts when one hash parameter is specified" do
        Catamaran.logger.send( :determine_path_and_opts_arguments, {} ).should == [ nil, {} ]
      end      

      it "should return the correct path and opts when two parameters are specified" do
        Catamaran.logger.send( :determine_path_and_opts_arguments, "mycompany.myrailsproject.app.models.User", {} ).should == [ "mycompany.myrailsproject.app.models.User", {} ]
      end      
    end

    it "should inherit the log level (via smart_log_level) from it's ancestors" do
      Catamaran.logger.log_level = Catamaran::LogLevel::INFO
      Catamaran.logger.com.mycompany.myrailsproject.app.models.log_level = Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.controllers.log_level = Catamaran::LogLevel::WARN
      Catamaran.logger.com.mycompany.myrailsproject.app.models.User.smart_log_level.should == Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.controllers.UsersController.smart_log_level.should == Catamaran::LogLevel::WARN
      Catamaran.logger.Company.Product.App.smart_log_level.should == Catamaran::LogLevel::INFO
    end

    it "should memoize the log level of an ancestor as needed" do
      Catamaran.logger.log_level = Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_log_level ).should be_nil
      Catamaran.logger.should_receive( :log_level ).once.with( {:recursive=>true} ).and_return Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_log_level.should == Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_log_level ).should == Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_log_level.should == Catamaran::LogLevel::ERROR
      Catamaran.logger.forget_memoizations
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_log_level ).should be_nil      
      Catamaran.logger.should_receive( :log_level ).once.with( {:recursive=>true} ).and_return Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_log_level.should == Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_log_level ).should == Catamaran::LogLevel::ERROR      
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_log_level.should == Catamaran::LogLevel::ERROR
    end

    it "should memoize the backtrace log level of an ancestor as needed" do
      Catamaran.logger.backtrace_log_level = Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_backtrace_log_level ).should be_nil
      Catamaran.logger.should_receive( :backtrace_log_level ).once.with( {:recursive=>true} ).and_return Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_backtrace_log_level.should == Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_backtrace_log_level ).should == Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_backtrace_log_level.should == Catamaran::LogLevel::ERROR
      Catamaran.logger.forget_memoizations
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_backtrace_log_level ).should be_nil      
      Catamaran.logger.should_receive( :backtrace_log_level ).once.with( {:recursive=>true} ).and_return Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_backtrace_log_level.should == Catamaran::LogLevel::ERROR
      Catamaran.logger.com.mycompany.myrailsproject.app.models.instance_variable_get( :@memoized_backtrace_log_level ).should == Catamaran::LogLevel::ERROR      
      Catamaran.logger.com.mycompany.myrailsproject.app.models.smart_backtrace_log_level.should == Catamaran::LogLevel::ERROR
    end    

    context "when the log level is specified, the default is no longer used" do
      it "should makeuse of the specified log level rather than the inherited one" do
        initial_log_level = Catamaran.logger.smart_log_level
        Catamaran.logger.log_level = Catamaran::LogLevel::ERROR
        initial_log_level.should_not == Catamaran.logger.smart_log_level
        Catamaran.logger.smart_log_level.should == Catamaran::LogLevel::ERROR
      end
    end
  end # ends describe Catamaran::Logger do

  describe Catamaran::LogLevel do
    describe ".severity_to_s" do
      it "should be able to convert a numeric log level into a string" do
        Catamaran::LogLevel.severity_to_s( Catamaran::LogLevel::NOTICE ).should == 'NOTICE'
      end

      it "should be able to handle IO log levels" do
        Catamaran::LogLevel.severity_to_s( Catamaran::LogLevel::IO_LESS_CRITICAL_THAN_TRACE ).should == 'IO'        
        Catamaran::LogLevel.severity_to_s( Catamaran::LogLevel::IO_LESS_CRITICAL_THAN_INFO ).should == 'IO'
        Catamaran::LogLevel.severity_to_s( Catamaran::LogLevel::IO_LESS_CRITICAL_THAN_DEBUG ).should == 'IO'
      end
    end
  end
end  # ends describe Catamaran do
