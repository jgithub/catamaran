Catamaran
=========

Logging is a powerful and often undervalued tool in software development.  When done right, it's a great way to document code, and it provides a simple &amp; effective way to solve problems when things go awry.  All an important part of maintainable code.

Gemfile
-------

    gem 'catamaran', '~> 2.0.0'

Rails-related setup:

    rails g catamaran:install

Now modify `config/initializers/catamaran/development.rb` as needed

Ruby Quickstart
---------------
```ruby

class WorkingWithCatamaran
  LOGGER = Catamaran.logger( "com.mytld.WorkingWithCatamaran" )
  # or equivalently: 
  # LOGGER = Catamaran.logger.com.mytld.WorkingWithCatamaran

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

working_with_catamaran = WorkingWithCatamaran.new
working_with_catamaran.demonstrating_log_levels
working_with_catamaran.using_the_caller
working_with_catamaran.changing_the_log_level
working_with_catamaran.displaying_backtrace_information
```

And the output

```
NOTICE pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - NOTICE logs are captured by default
  WARN pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - WARN logs are captured by default
 ERROR pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - ERROR logs are captured by default
SEVERE pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - SEVERE logs are captured by default
 FATAL pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - FATAL logs are captured by default
NOTICE pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - The caller will append log location info to this message (working_with_catamaran.rb:27:in `using_the_caller')
NOTICE pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - If the user specifies the :file, :line, AND :method, the caller will NOT get invoked (working_with_catamaran.rb:28:in `run')
NOTICE pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - To prove the caller is not used, we can put dummy data in and see that it's being used instead (just_kidding.rb:123456789:in `whatever')
 DEBUG pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - Now DEBUG messages should show up
  WARN pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - Sample WARN statement with backtrace requested
 ERROR pid-28828 [2014-01-04 15:42:18:664]                  com.mytld.WorkingWithCatamaran - Sample ERROR statement with backtrace requested from:
working_with_catamaran.rb:51:in `displaying_backtrace_information'
working_with_catamaran.rb:59:in `<main>'
```


Rails Quickstart
----------------

```ruby
class WidgetsController < ApplicationController
  LOGGER = Catamaran.logger.com.mytld.myrailsapp.app.controllers.WidgetsController

  def index
    LOGGER.debug "Handling a Widgets index request with params = #{params}" if LOGGER.debug?       
  end
end
```

Load the `index` page and check out your `development.log` file

### Sample log entry (in your development.log file)

    DEBUG pid-86000 [2013-12-17 17:26:39:176] ld.myrailsapp.app.controllers.WidgetsController - "Handling a Widgets index request with params = {"controller"=>"widgets", "action"=>"index"} (`/myrailsapp/app/controllers/widgets_controller.rb:7`:in `index`)

Log Levels
----------
Available log levels:  `TRACE` (verbose and trivial log messages), `DEBUG`, `INFO`, `NOTICE`, `WARN`, `ERROR`, `SEVERE` (logs related to very serious error conditions), `FATAL`

The `NOTICE` log level severity is the default.   Any logs with `NOTICE` or higher severity will be captured.


Inspiration
-----------
I'm looking for a logging utility that:

* records granular timestamps with each log entry
* records the process ID with each log entry
* captures from where each log entry was generated
* works equally well with classes that do and do *not* extend Rails base classes
* supports the TRACE log level (or other log level less critical than DEBUG). 
* is capable of capturing logs at different severity thresholds from different parts of the app simultaneously (I always liked the Named Hierarchy and Level Inheritance aspects of log4j)
* readily works with Rails
* http://stackoverflow.com/questions/462651/rails-logger-format-string-configuration
* http://stackoverflow.com/questions/3654827/logging-in-rails-app
* http://stackoverflow.com/questions/11991967/rails-log-too-verbose
* http://www.ietf.org/rfc/rfc3164.txt
* http://logging.apache.org/log4j/1.2

Performance Considerations
--------------------------

### With or without `if LOGGER.debug?`
```ruby
require 'catamaran'
require 'benchmark'

Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::INFO 
Catamaran::Manager.stderr = false

class CatamaranConditionalLogStatementBenchmark
  LOGGER = Catamaran.logger( "CatamaranConditionalLogStatementBenchmark" )

  # NOTE that the log level for this test is set to INFO, 
  # so 'warn' logs are enabled and 'debug' logs are disabled

  n = 500000
  Benchmark.bm(7) do |x|
    x.report("warn WITHOUT if LOGGER.warn?  ") {
      n.times do |i|
        LOGGER.warn "Based on the current log level, this log is being captured"
      end
    }
    x.report("warn WITH if LOGGER.warn?     ") {
      n.times do |i|
        LOGGER.warn "Based on the current log level, this log is being captured" if LOGGER.warn?
      end
    }
  end

  Benchmark.bm(7) do |x|
    x.report("debug WITHOUT if LOGGER.debug?") {
      n.times do |i|
        LOGGER.debug "Based on the current log level, this log is NOT being captured"
      end
    }
    x.report("debug WITH if LOGGER.debug?   ") {
      n.times do |i|
        LOGGER.debug "Based on the current log level, this log is NOT being captured" if LOGGER.debug?       
      end
    }
  end 

end

#                                     user     system      total        real
# warn WITHOUT if LOGGER.warn?    6.940000   0.010000   6.950000 (  6.950691)
# warn WITH if LOGGER.warn?       7.650000   0.000000   7.650000 (  7.658004)
#                                     user     system      total        real
# debug WITHOUT if LOGGER.debug?  0.660000   0.010000   0.670000 (  0.665775)
# debug WITH if LOGGER.debug?     0.560000   0.010000   0.570000 (  0.574397)
```

#### Summary

* For log messages that are usually *disabled* in the production environment ( TRACE, DEBUG, INFO ), it's generally better to invoke the log only after confirming that the log level is enabled 

ex:

```ruby
LOGGER.trace "This is a TRACE log" if LOGGER.trace?
LOGGER.debug "This is a DEBUG log" if LOGGER.debug?
LOGGER.info "This is a INFO log" if LOGGER.info?
```

* For log messages that are usually *enabled* in the production environment ( NOTICE, WARN, ERROR, SEVERE, FATAL ), it's generally better to invoke the log WITHOUT first testing the log level

ex:

```ruby
LOGGER.notice "This is a NOTICE log"
LOGGER.warn "This is a WARN log"
LOGGER.error "This is a ERROR log" 
LOGGER.severe "This is a SEVERE log" 
LOGGER.severe "This is a FATAL log" 
```

### Performance implications of using `caller`

```ruby
require 'catamaran'
require 'benchmark'

Catamaran::Manager.stderr = false

class CatamaranCallerBenchmark
  LOGGER = Catamaran.logger( "CatamaranCallerBenchmark" )

  n = 500000
  Benchmark.bm(7) do |x|
    Catamaran::Manager.formatter_caller_enabled = false
    
    x.report("Catamaran::Manager.formatter_caller_enabled = false") {
      n.times do |i|
        LOGGER.error "This is a ERROR log"
      end
    }   
    
    Catamaran::Manager.formatter_caller_enabled = true
    
    x.report("Catamaran::Manager.formatter_caller_enabled = true ") {
      n.times do |i|
        LOGGER.error "This is a ERROR log"
      end
    }
  end
end
                         

#                                                          user     system      total        real
# Catamaran::Manager.formatter_caller_enabled = false  6.710000   0.060000   6.770000 (  6.780703)
# Catamaran::Manager.formatter_caller_enabled = true  13.940000   0.400000  14.340000 ( 14.345921)
```

#### Summary

Using the `caller()` is slower but generate more details in the log statements

##### Sample log from when formatter_caller_enabled is set to `false`

    WARN pid-4407 [2013-12-26 14:18:19:697]                                   FirstRubyDemo - Note that WARN messages are getting logged

##### Sample log from when formatter_caller_enabled is set to `true`

    WARN pid-4410 [2013-12-26 14:18:38:276]                                   FirstRubyDemo - Note that WARN messages are getting logged (catamaran_ruby_demos.rb:12:in `run')

Because of this performance difference, the `caller()` is disabled by default.  Though enabling it tends to be especially useful in the development and test environments when debugging problems during the course of functional testing.

### Ruby Profiler
```ruby
require 'catamaran'
require 'ruby-prof'


class CatamaranProfilerTest
  LOGGER = Catamaran.logger( "com.mycompany.CatamaranProfilerTest" )
  # or equivalently: 
  # LOGGER = Catamaran.logger.com.mycompany.CatamaranProfilerTest

  def run
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
end


RubyProf.start

demo = FirstRubyDemo.new
1000.times do
  demo.run
end

result = RubyProf.stop

printer = RubyProf::GraphPrinter.new(result)

printer.print(STDOUT)
```

#### Summary

```
Thread ID: 2156341060
Fiber ID: 2156558900
Total Time: 0.792647
Sort by: total_time

  %total   %self      total       self       wait      child            calls    Name
--------------------------------------------------------------------------------
 100.00%   0.01%      0.793      0.000      0.000      0.793                1      Global#[No method]
                      0.793      0.003      0.000      0.790              1/1      Integer#times
                      0.000      0.000      0.000      0.000              1/2      Class#new
--------------------------------------------------------------------------------
                      0.793      0.003      0.000      0.790              1/1      Global#[No method]
  99.99%   0.36%      0.793      0.003      0.000      0.790                1      Integer#times
                      0.790      0.021      0.000      0.768        1000/1000      ProfilerTest#run
--------------------------------------------------------------------------------
                      0.790      0.021      0.000      0.768        1000/1000      Integer#times
  99.64%   2.70%      0.790      0.021      0.000      0.768             1000      ProfilerTest#run
                      0.147      0.012      0.000      0.135        1000/1000      Catamaran::Logger#severe
                      0.146      0.007      0.000      0.138        1000/1000      Catamaran::Logger#fatal
                      0.144      0.007      0.000      0.137        1000/1000      Catamaran::Logger#error
                      0.140      0.007      0.000      0.133        1000/1000      Catamaran::Logger#warn
                      0.128      0.007      0.000      0.122        1000/1000      Catamaran::Logger#notice
                      0.021      0.006      0.000      0.015        1000/1000      Catamaran::Logger#debug?
                      0.021      0.006      0.000      0.015        1000/1000      Catamaran::Logger#trace?
                      0.021      0.006      0.000      0.015        1000/1000      Catamaran::Logger#info?
--------------------------------------------------------------------------------
                      0.107      0.006      0.000      0.100        1000/5000      Catamaran::Logger#notice
                      0.119      0.007      0.000      0.113        1000/5000      Catamaran::Logger#warn
                      0.120      0.007      0.000      0.113        1000/5000      Catamaran::Logger#severe
                      0.121      0.007      0.000      0.115        1000/5000      Catamaran::Logger#error
                      0.123      0.007      0.000      0.117        1000/5000      Catamaran::Logger#fatal
  74.54%   4.23%      0.591      0.034      0.000      0.557             5000      Catamaran::Logger#log
                      0.381      0.028      0.000      0.353        5000/5000      Catamaran::Logger#_format_msg
                      0.176      0.047      0.000      0.129        5000/5000      <Class::Catamaran::Outputter>#write
--------------------------------------------------------------------------------
                      0.381      0.028      0.000      0.353        5000/5000      Catamaran::Logger#log
  48.08%   3.49%      0.381      0.028      0.000      0.353             5000      Catamaran::Logger#_format_msg
                      0.288      0.107      0.000      0.181        5000/5000      Catamaran::Formatter#construct_formatted_message
                      0.051      0.033      0.000      0.018        5000/5000      Catamaran::Logger#path_to_s
                      0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#instance
--------------------------------------------------------------------------------
                      0.288      0.107      0.000      0.181        5000/5000      Catamaran::Logger#_format_msg
  36.32%  13.50%      0.288      0.107      0.000      0.181             5000      Catamaran::Formatter#construct_formatted_message
                      0.086      0.064      0.000      0.022        5000/5000      Time#strftime
                      0.038      0.018      0.000      0.020        5000/5000      <Class::Time>#now
                      0.025      0.025      0.000      0.000        5000/5000      Kernel#sprintf
                      0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::LogLevel>#severity_to_s
                      0.011      0.011      0.000      0.000        5000/5000      Fixnum#to_s
                      0.006      0.006      0.000      0.000        5000/5000      <Module::Process>#pid
--------------------------------------------------------------------------------
                      0.176      0.047      0.000      0.129        5000/5000      Catamaran::Logger#log
  22.23%   5.96%      0.176      0.047      0.000      0.129             5000      <Class::Catamaran::Outputter>#write
                      0.095      0.020      0.000      0.075        5000/5000      IO#puts
                      0.018      0.018      0.000      0.000        5000/5000      <Class::Catamaran::Manager>#stdout?
                      0.016      0.016      0.000      0.000        5000/5000      <Class::Catamaran::Manager>#stderr?
--------------------------------------------------------------------------------
                      0.147      0.012      0.000      0.135        1000/1000      ProfilerTest#run
  18.53%   1.54%      0.147      0.012      0.000      0.135             1000      Catamaran::Logger#severe
                      0.120      0.007      0.000      0.113        1000/5000      Catamaran::Logger#log
                      0.015      0.012      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.146      0.007      0.000      0.138        1000/1000      ProfilerTest#run
  18.39%   0.94%      0.146      0.007      0.000      0.138             1000      Catamaran::Logger#fatal
                      0.123      0.007      0.000      0.117        1000/5000      Catamaran::Logger#log
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.144      0.007      0.000      0.137        1000/1000      ProfilerTest#run
  18.20%   0.94%      0.144      0.007      0.000      0.137             1000      Catamaran::Logger#error
                      0.121      0.007      0.000      0.115        1000/5000      Catamaran::Logger#log
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.140      0.007      0.000      0.133        1000/1000      ProfilerTest#run
  17.64%   0.85%      0.140      0.007      0.000      0.133             1000      Catamaran::Logger#warn
                      0.119      0.007      0.000      0.113        1000/5000      Catamaran::Logger#log
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.128      0.007      0.000      0.122        1000/1000      ProfilerTest#run
  16.19%   0.84%      0.128      0.007      0.000      0.122             1000      Catamaran::Logger#notice
                      0.107      0.006      0.000      0.100        1000/5000      Catamaran::Logger#log
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000           3/8003      Catamaran::Logger#log_level
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#warn
                      0.015      0.012      0.000      0.002        1000/8003      Catamaran::Logger#severe
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#notice
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#fatal
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#info?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#trace?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#debug?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#error
  15.07%  12.83%      0.119      0.102      0.000      0.018             8003     *Catamaran::Logger#log_level
                      0.018      0.018      0.000      0.000      16001/16001      Kernel#nil?
                      0.000      0.000      0.000      0.000              4/4      NilClass#nil?
                      0.000      0.000      0.000      0.000           3/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.095      0.020      0.000      0.075        5000/5000      <Class::Catamaran::Outputter>#write
  11.98%   2.49%      0.095      0.020      0.000      0.075             5000      IO#puts
                      0.075      0.075      0.000      0.000      10000/10000      IO#write
--------------------------------------------------------------------------------
                      0.086      0.064      0.000      0.022        5000/5000      Catamaran::Formatter#construct_formatted_message
  10.89%   8.09%      0.086      0.064      0.000      0.022             5000      Time#strftime
                      0.016      0.016      0.000      0.000      10000/10000      Fixnum#divmod
                      0.006      0.006      0.000      0.000        5000/5000      Fixnum#%
--------------------------------------------------------------------------------
                      0.075      0.075      0.000      0.000      10000/10000      IO#puts
   9.49%   9.49%      0.075      0.075      0.000      0.000            10000      IO#write
--------------------------------------------------------------------------------
                      0.051      0.033      0.000      0.018        5000/5000      Catamaran::Logger#_format_msg
   6.49%   4.20%      0.051      0.033      0.000      0.018             5000      Catamaran::Logger#path_to_s
                      0.018      0.018      0.000      0.000        5000/5000      Array#join
                      0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#delimiter
--------------------------------------------------------------------------------
                      0.038      0.018      0.000      0.020        5000/5000      Catamaran::Formatter#construct_formatted_message
   4.78%   2.22%      0.038      0.018      0.000      0.020             5000      <Class::Time>#now
                      0.020      0.014      0.000      0.006        5000/5000      Time#initialize
--------------------------------------------------------------------------------
                      0.025      0.025      0.000      0.000        5000/5000      Catamaran::Formatter#construct_formatted_message
   3.15%   3.15%      0.025      0.025      0.000      0.000             5000      Kernel#sprintf
--------------------------------------------------------------------------------
                      0.021      0.006      0.000      0.015        1000/1000      ProfilerTest#run
   2.70%   0.75%      0.021      0.006      0.000      0.015             1000      Catamaran::Logger#debug?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.021      0.006      0.000      0.015        1000/1000      ProfilerTest#run
   2.69%   0.77%      0.021      0.006      0.000      0.015             1000      Catamaran::Logger#trace?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.021      0.006      0.000      0.015        1000/1000      ProfilerTest#run
   2.60%   0.70%      0.021      0.006      0.000      0.015             1000      Catamaran::Logger#info?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.020      0.014      0.000      0.006        5000/5000      <Class::Time>#now
   2.56%   1.80%      0.020      0.014      0.000      0.006             5000      Time#initialize
                      0.006      0.006      0.000      0.000        5000/5000      Fixnum#+
--------------------------------------------------------------------------------
                      0.018      0.018      0.000      0.000        5000/5000      <Class::Catamaran::Outputter>#write
   2.31%   2.31%      0.018      0.018      0.000      0.000             5000      <Class::Catamaran::Manager>#stdout?
--------------------------------------------------------------------------------
                      0.018      0.018      0.000      0.000        5000/5000      Catamaran::Logger#path_to_s
   2.28%   2.28%      0.018      0.018      0.000      0.000             5000      Array#join
--------------------------------------------------------------------------------
                      0.018      0.018      0.000      0.000      16001/16001      Catamaran::Logger#log_level
   2.24%   2.24%      0.018      0.018      0.000      0.000            16001      Kernel#nil?
--------------------------------------------------------------------------------
                      0.016      0.016      0.000      0.000      10000/10000      Time#strftime
   1.99%   1.99%      0.016      0.016      0.000      0.000            10000      Fixnum#divmod
--------------------------------------------------------------------------------
                      0.016      0.016      0.000      0.000        5000/5000      <Class::Catamaran::Outputter>#write
   1.97%   1.97%      0.016      0.016      0.000      0.000             5000      <Class::Catamaran::Manager>#stderr?
--------------------------------------------------------------------------------
                      0.014      0.014      0.000      0.000        5000/5000      Catamaran::Formatter#construct_formatted_message
   1.79%   1.79%      0.014      0.014      0.000      0.000             5000      <Class::Catamaran::LogLevel>#severity_to_s
--------------------------------------------------------------------------------
                      0.014      0.014      0.000      0.000        5000/5000      Catamaran::Logger#_format_msg
   1.78%   1.78%      0.014      0.014      0.000      0.000             5000      <Class::Catamaran::Formatter>#instance
                      0.000      0.000      0.000      0.000              1/2      Class#new
--------------------------------------------------------------------------------
                      0.011      0.011      0.000      0.000        5000/5000      Catamaran::Formatter#construct_formatted_message
   1.44%   1.44%      0.011      0.011      0.000      0.000             5000      Fixnum#to_s
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      Time#strftime
   0.81%   0.81%      0.006      0.006      0.000      0.000             5000      Fixnum#%
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      Catamaran::Formatter#construct_formatted_message
   0.77%   0.77%      0.006      0.006      0.000      0.000             5000      <Module::Process>#pid
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      Time#initialize
   0.76%   0.76%      0.006      0.006      0.000      0.000             5000      Fixnum#+
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/2      Global#[No method]
                      0.000      0.000      0.000      0.000              1/2      <Class::Catamaran::Formatter>#instance
   0.00%   0.00%      0.000      0.000      0.000      0.000                2      Class#new
                      0.000      0.000      0.000      0.000              1/1      Catamaran::Formatter#initialize
                      0.000      0.000      0.000      0.000              1/1      BasicObject#initialize
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#path_to_s
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#delimiter
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              4/4      Catamaran::Logger#log_level
   0.00%   0.00%      0.000      0.000      0.000      0.000                4      NilClass#nil?
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Class#new
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Formatter#initialize
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Class#new
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      BasicObject#initialize

* indicates recursively called methods
```



Ideas around what's next
------------------------

* Make it easier to change the formatting pattern
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and local files
* Ongoing performance considerations
* Something like `filter_parameter_logging`
* Color support
* Log rotation
* Heroku support (https://blog.heroku.com/archives/2013/7/15/logging-on-heroku)
* Buffered file I/O considerations




