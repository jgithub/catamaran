require 'spec_helper'

describe Catamaran do
  it "should define TRACE" do
    Catamaran::LogLevel::TRACE.should > 0
  end

  it "should have a version" do
    Catamaran::VERSION.length.should > 0
  end

  it "should reuse the same root logger instance" do
    Catamaran.logger.object_id.should == Catamaran.logger.object_id
  end

  it "should reuse the same logger instance when contextually the same" do
    Catamaran.logger.Company.Product.App.Model.User.object_id.should == Catamaran.logger.Company.Product.App.Model.User.object_id
    Catamaran.logger( "Company.Product.App.Model.User" ).object_id.should == Catamaran.logger.Company.Product.App.Model.User.object_id        
  end  

  it "should provide access to the root logger through CatLogger" do
    CatLogger.object_id.should == Catamaran::Manager.root_logger.object_id
    Catamaran.logger.object_id.should == CatLogger.object_id
  end

  it "should define Catamaran.logger and Catamaran.get_logger methods.  They should be equivalent." do
    Catamaran.logger.object_id.should == Catamaran::get_logger.object_id
  end

  it "should provide access to loggers after a reset" do
    logger = Catamaran.logger.Company.Product.App.Model.User
    Catamaran::Manager.reset
    logger = Catamaran.logger.Company.Product.App.Model.User
    logger.should be_instance_of( Catamaran::Logger )
  end

  it "should create a new loggers for each point in the path" do
    Catamaran.logger
    Catamaran::Manager.num_loggers.should == 1
    Catamaran.logger.Company.Product.App.Model.User
    Catamaran::Manager.num_loggers.should == 6    
  end     

  it "should be possible for the user to modify the default log level" do
    Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::TRACE
    Catamaran.logger.smart_log_level.should == Catamaran::LogLevel::TRACE
  end

  it "should not provide the same object ID for different paths" do
    Catamaran.logger.A.C.object_id.should_not == Catamaran.logger.B.C
    Catamaran.logger.A.C.object_id.should_not == Catamaran.logger.A.B
  end  

  context "by default" do
    it "should log INFO messages" do
      logger = Catamaran.logger.Company.Product.App.Model.User
    end

    it "should NOT log DEBUG messages" do
      logger = Catamaran.logger.Company.Product.App.Model.User
    end

    it "should have an INFO log level set for the root logger" do
      Catamaran.logger.log_level.should == Catamaran::LogLevel::INFO
    end

    it "should have an UNSET log level for any non-root loggers" do
      Catamaran.logger.log_level = Catamaran::LogLevel::ERROR
      Catamaran.logger.Test.log_level.should be_nil
    end

    it "should have one logger configured" do
      Catamaran::Manager.num_loggers.should == 1
    end

    it "should be that the IO log level is the same as IO_LESS_CRITICAL_THAN_INFO" do
      Catamaran::LogLevel::IO.should == Catamaran::LogLevel::IO_LESS_CRITICAL_THAN_INFO
    end
  end

  context "when the log level is set to INFO" do
    Catamaran.logger.log_level = Catamaran::LogLevel::INFO
    Catamaran.logger.Company.Product.App.Model.User
  end

  context "after a reset" do
    it "should have a default log level of INFO" do
      logger = Catamaran.logger
      logger.log_level.should == Catamaran::LogLevel::INFO
      logger.log_level = Catamaran::LogLevel::ERROR
      logger.log_level.should == Catamaran::LogLevel::ERROR
      Catamaran::Manager.reset
      logger.log_level.should == Catamaran::LogLevel::INFO      
    end

    it "should return the number of loggers to 1" do
      Catamaran.logger
      Catamaran::Manager.num_loggers.should == 1
      Catamaran.logger.Company.Product.App.Model.User
      Catamaran::Manager.num_loggers.should == 6 
      Catamaran::Manager.reset
      Catamaran::Manager.num_loggers.should == 1      
    end

    it "should have the same root logger object before and after the reset" do
      before_logger = Catamaran.logger
      Catamaran::Manager.reset
      Catamaran.logger.object_id.should == before_logger.object_id        
    end
  end

  describe Catamaran.logger do
    it "should be able to inherit it's parent's log level" do
      Catamaran.logger.log_level = Catamaran::LogLevel::ERROR
      Catamaran.logger.Test.smart_log_level.should == Catamaran::LogLevel::ERROR
    end  
  end

  describe Catamaran::Manager do
    describe "#reset" do
      it "should reset Catamaran" do
        before_reset_logger = Catamaran.logger.Company.Product.App.Model.User
        Catamaran.logger.num_loggers.should == 6
        Catamaran::Manager.reset
        Catamaran.logger.num_loggers.should == 1
        after_reset_logger = Catamaran.logger.Company.Product.App.Model.User
        before_reset_logger.object_id.should_not == after_reset_logger.object_id        
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
    it "should inherit the log level from the root logger as needed" do
      Catamaran.logger.smart_log_level.should == Catamaran::LogLevel::INFO
      Catamaran.logger.Company.Product.App.Model.User.log_level.should be_nil     
      Catamaran.logger.Company.Product.App.Model.User.smart_log_level.should == Catamaran::LogLevel::INFO
    end

    it "should have a nil log_level unless explicitly set" do
      Catamaran.logger.Company.Product.App.Model.User.log_level.should be_nil     
    end

    it "should always have a smart_log_level set" do
      Catamaran.logger.Company.Product.App.Model.User.log_level.should be_nil           
      Catamaran.logger.Company.Product.App.Model.User.smart_log_level.should_not be_nil
    end    

    it "should write the log if the log has sufficient weight" do
      Catamaran.logger.smart_log_level.should == Catamaran::LogLevel::INFO
      Catamaran.logger.should_receive( :_write_to_log ).once
      Catamaran.logger.info( "Testing an INFO log" )
    end

    it "should NOT write the log if the log does NOT have sufficient" do
      Catamaran.logger.smart_log_level.should == Catamaran::LogLevel::INFO
      # DEBUG is disabled
      Catamaran.logger.should_not_receive( :_write_to_log )
      Catamaran.logger.debug( "Testing a DEBUG log" )
    end

    context "when using smart_log_level" do
      it "should inherit the log level from a parent" do
        Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::INFO
        Catamaran.logger.Company.Product.App.Model.log_level = Catamaran::LogLevel::ERROR
        Catamaran.logger.Company.Product.App.Controller.log_level = Catamaran::LogLevel::WARN
        Catamaran.logger.Company.Product.App.Model.User.smart_log_level.should == Catamaran::LogLevel::ERROR
        Catamaran.logger.Company.Product.App.Controller.UsersController.smart_log_level.should == Catamaran::LogLevel::WARN
        Catamaran.logger.Company.Product.App.smart_log_level.should == Catamaran::LogLevel::INFO
      end
    end

    context "when the log level is specified, the default is no longer used" do
      it "should be " do
        Catamaran.logger.smart_log_level.should == Catamaran::LogLevel::INFO
        Catamaran.logger.log_level = Catamaran::LogLevel::ERROR
        Catamaran.logger.smart_log_level.should == Catamaran::LogLevel::ERROR
      end
    end
  end    
end
