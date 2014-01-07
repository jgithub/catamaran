$: << '../lib'
require 'catamaran'

class QuickstartWithRuby
  LOGGER = Catamaran.logger( "com.mytld.QuickstartWithRuby" )
  # or equivalently: 
  # LOGGER = Catamaran.logger.com.mytld.QuickstartWithRuby

  def demonstrating_log_levels
    # Disabled by default
    LOGGER.trace( "TRACE logs are NOT captured by default" ) if LOGGER.trace?    
    LOGGER.debug( "DEBUG logs are NOT captured by default" ) if LOGGER.debug?
    LOGGER.info( "INFO logs are NOT captured by default" ) if LOGGER.info?

    # Enabled by default
    LOGGER.notice( "NOTICE logs are captured by default" )
    LOGGER.warn( "WARN logs are captured by default" )    
    LOGGER.error( "ERROR logs are captured by default" )
    LOGGER.severe( "SEVERE logs are captured by default" )
    LOGGER.fatal( "FATAL logs are captured by default" )
  end

  def using_the_caller
    # Enable the caller (it's disabled by default)
    Catamaran::Manager.formatter_caller_enabled = true

    LOGGER.notice( "The caller will append log location info to this message" )
    LOGGER.notice( "If the user specifies the :file, :line, AND :method, the caller will NOT get invoked", { :file => __FILE__, :line => __LINE__, :method => 'run' } )
    LOGGER.notice( "To prove the caller is not used, we can put dummy data in and see that it's being used instead", { :file => 'just_kidding.rb', :line => 123456789, :method => 'whatever' } )    
  
    # Turn it back off
    Catamaran::Manager.formatter_caller_enabled = false
  end

  def changing_the_log_level
    # Note that the log level can be changed
    Catamaran.logger.log_level = Catamaran::LogLevel::DEBUG
    Catamaran::Manager.forget_cached_log_levels()

    LOGGER.trace( "TRACE logs are STILL NOT captured" ) if LOGGER.trace?    
    LOGGER.debug( "Now DEBUG messages should show up" ) if LOGGER.debug?
  end

  def displaying_backtrace_information
    Catamaran.logger.log_level = Catamaran::LogLevel::NOTICE
    Catamaran.logger.backtrace_log_level = Catamaran::LogLevel::ERROR 
    Catamaran::Manager.forget_cached_log_levels()

    LOGGER.debug( "Sample DEBUG statement with backtrace requested", { :backtrace => true } )
    LOGGER.warn( "Sample WARN statement with backtrace requested", { :backtrace => true } )
    LOGGER.error( "Sample ERROR statement with backtrace requested", { :backtrace => true } )
  end
end

quickstart_with_ruby = QuickstartWithRuby.new
quickstart_with_ruby.demonstrating_log_levels
quickstart_with_ruby.using_the_caller
quickstart_with_ruby.changing_the_log_level
quickstart_with_ruby.displaying_backtrace_information



# NOTICE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - NOTICE logs are captured by default
#   WARN pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - WARN logs are captured by default
#  ERROR pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - ERROR logs are captured by default
# SEVERE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - SEVERE logs are captured by default
#  FATAL pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - FATAL logs are captured by default
# NOTICE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - The caller will append log location info to this message (quickstart_with_ruby.rb:27:in `using_the_caller')
# NOTICE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - If the user specifies the :file, :line, AND :method, the caller will NOT get invoked (quickstart_with_ruby.rb:28:in `run')
# NOTICE pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - To prove the caller is not used, we can put dummy data in and see that it's being used instead (just_kidding.rb:123456789:in `whatever')
#  DEBUG pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - Now DEBUG messages should show up
#   WARN pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - Sample WARN statement with backtrace requested
#  ERROR pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - Sample ERROR statement with backtrace requested from:
# quickstart_with_ruby.rb:51:in `displaying_backtrace_information'
# quickstart_with_ruby.rb:59:in `<main>'

