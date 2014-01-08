Catamaran
=========

Logging is a powerful and often undervalued tool in software development.  When done right, it's a great way to document code, and it provides a simple &amp; effective way to solve problems when things go awry.  All an important part of maintainable code.

Gemfile
-------

    gem 'catamaran', '~> 2.2.0'

Rails-related setup:

    rails g catamaran:install

Now modify `config/initializers/catamaran/development.rb` as needed

Ruby Quickstart
---------------
```ruby
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
```

And the output

```
NOTICE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - NOTICE logs are captured by default
  WARN pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - WARN logs are captured by default
 ERROR pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - ERROR logs are captured by default
SEVERE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - SEVERE logs are captured by default
 FATAL pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - FATAL logs are captured by default
NOTICE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - The caller will append log location info to this message (quickstart_with_ruby.rb:27:in `using_the_caller')
NOTICE pid-50247 [2014-01-07 13:22:28:516]                    com.mytld.QuickstartWithRuby - If the user specifies the :file, :line, AND :method, the caller will NOT get invoked (quickstart_with_ruby.rb:28:in `run')
NOTICE pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - To prove the caller is not used, we can put dummy data in and see that it's being used instead (just_kidding.rb:123456789:in `whatever')
 DEBUG pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - Now DEBUG messages should show up
  WARN pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - Sample WARN statement with backtrace requested
 ERROR pid-50247 [2014-01-07 13:22:28:517]                    com.mytld.QuickstartWithRuby - Sample ERROR statement with backtrace requested from:
quickstart_with_ruby.rb:51:in `displaying_backtrace_information'
quickstart_with_ruby.rb:59:in `<main>'
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

More Examples
-------------
See the [examples folder](https://github.com/jgithub/catamaran/tree/master/examples).

Log Levels
----------
Available log levels:  `TRACE` (verbose and trivial log messages), `DEBUG`, `INFO`, `NOTICE`, `WARN`, `ERROR`, `SEVERE` (logs related to very serious error conditions), `FATAL`

The `NOTICE` log level severity is the default.   Any logs with `NOTICE` or higher severity will be captured.

Inspiration
-----------
I always liked working with log4j.  Much of the inspriation comes from that.

* Named Hierarchy
* Level Inheritance
* `TRACE`

I'm looking for a logging utility that:

* records granular timestamps with each log entry
* records the process ID with each log entry
* captures from where each log entry was generated
* works equally well with classes that do and do *not* extend Rails base classes
* supports the TRACE log level (or other log level less critical than DEBUG).
* is capable of capturing logs at different severity thresholds from different parts of the app simultaneously 
* readily works with Rails

Performance Considerations
--------------------------

### With or without `if LOGGER.debug?`
```ruby
$: << '../lib'

require 'catamaran'
require 'benchmark'

Catamaran.logger.log_level = Catamaran::LogLevel::INFO 
Catamaran::Manager.stderr = false

class BenchmarkingConditionalLogStatements
  LOGGER = Catamaran.logger( "BenchmarkingConditionalLogStatements" )

  # NOTE that the log level for this test is set to INFO, 
  # so 'warn' logs are enabled and 'debug' logs are disabled

  n = 500000
  Benchmark.bm(7) do |x|
    x.report("LOGGER.warn WITHOUT if LOGGER.warn?  ") {
      n.times do |i|
        LOGGER.warn "Based on the current log level, this log is being captured"
      end
    }
    x.report("LOGGER.warn WITH if LOGGER.warn?     ") {
      n.times do |i|
        LOGGER.warn "Based on the current log level, this log is being captured" if LOGGER.warn?
      end
    }
    x.report("LOGGER.debug WITHOUT if LOGGER.debug?") {
      n.times do |i|
        LOGGER.debug "Based on the current log level, this log is NOT being captured"
      end
    }
    x.report("LOGGER.debug WITH if LOGGER.debug?   ") {
      n.times do |i|
        LOGGER.debug "Based on the current log level, this log is NOT being captured" if LOGGER.debug?       
      end
    }
  end 
end

#                                            user     system      total        real
# LOGGER.warn WITHOUT if LOGGER.warn?    6.440000   0.090000   6.530000 (  6.533838)
# LOGGER.warn WITH if LOGGER.warn?       7.110000   0.120000   7.230000 (  7.242870)
# LOGGER.debug WITHOUT if LOGGER.debug?  0.530000   0.020000   0.550000 (  0.548454)
# LOGGER.debug WITH if LOGGER.debug?     0.450000   0.030000   0.480000 (  0.474419)
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

catamaran_profiler_test = CatamaranProfilerTest.new
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
Fiber ID: 2160266620
Total Time: 0.744246
Sort by: total_time

  %total   %self      total       self       wait      child            calls    Name
--------------------------------------------------------------------------------
 100.00%   0.01%      0.744      0.000      0.000      0.744                1      Global#[No method]
                      0.744      0.003      0.000      0.741              1/1      Integer#times
                      0.000      0.000      0.000      0.000              1/1      Class#new
--------------------------------------------------------------------------------
                      0.744      0.003      0.000      0.741              1/1      Global#[No method]
  99.99%   0.38%      0.744      0.003      0.000      0.741                1      Integer#times
                      0.741      0.021      0.000      0.720        1000/1000      ProfilerTest#run
--------------------------------------------------------------------------------
                      0.741      0.021      0.000      0.720        1000/1000      Integer#times
  99.61%   2.85%      0.741      0.021      0.000      0.720             1000      ProfilerTest#run
                      0.136      0.007      0.000      0.129        1000/1000      Catamaran::Logger#severe
                      0.136      0.007      0.000      0.128        1000/1000      Catamaran::Logger#fatal
                      0.132      0.007      0.000      0.124        1000/1000      Catamaran::Logger#error
                      0.130      0.007      0.000      0.123        1000/1000      Catamaran::Logger#warn
                      0.122      0.006      0.000      0.115        1000/1000      Catamaran::Logger#notice
                      0.025      0.009      0.000      0.015        1000/1000      Catamaran::Logger#trace?
                      0.021      0.006      0.000      0.015        1000/1000      Catamaran::Logger#debug?
                      0.020      0.005      0.000      0.015        1000/1000      Catamaran::Logger#info?
--------------------------------------------------------------------------------
                      0.101      0.006      0.000      0.095        1000/5000      Catamaran::Logger#notice
                      0.109      0.006      0.000      0.102        1000/5000      Catamaran::Logger#error
                      0.109      0.007      0.000      0.102        1000/5000      Catamaran::Logger#warn
                      0.113      0.007      0.000      0.107        1000/5000      Catamaran::Logger#fatal
                      0.115      0.007      0.000      0.108        1000/5000      Catamaran::Logger#severe
  73.47%   4.35%      0.547      0.032      0.000      0.514             5000      Catamaran::Logger#log
                      0.360      0.021      0.000      0.339        5000/5000      Catamaran::Logger#_format_msg
                      0.155      0.058      0.000      0.096        5000/5000      <Class::Catamaran::Outputter>#write
--------------------------------------------------------------------------------
                      0.360      0.021      0.000      0.339        5000/5000      Catamaran::Logger#log
  48.36%   2.87%      0.360      0.021      0.000      0.339             5000      Catamaran::Logger#_format_msg
                      0.287      0.105      0.000      0.182        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
                      0.052      0.032      0.000      0.020        5000/5000      Catamaran::Logger#path_to_s
--------------------------------------------------------------------------------
                      0.287      0.105      0.000      0.182        5000/5000      Catamaran::Logger#_format_msg
  38.53%  14.11%      0.287      0.105      0.000      0.182             5000      <Class::Catamaran::Formatter>#construct_formatted_message
                      0.086      0.065      0.000      0.021        5000/5000      Time#strftime
                      0.036      0.016      0.000      0.019        5000/5000      <Class::Time>#now
                      0.029      0.029      0.000      0.000        5000/5000      Kernel#sprintf
                      0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::LogLevel>#severity_to_s
                      0.011      0.011      0.000      0.000        5000/5000      Fixnum#to_s
                      0.006      0.006      0.000      0.000        5000/5000      <Module::Process>#pid
--------------------------------------------------------------------------------
                      0.155      0.058      0.000      0.096        5000/5000      Catamaran::Logger#log
  20.76%   7.85%      0.155      0.058      0.000      0.096             5000      <Class::Catamaran::Outputter>#write
                      0.085      0.020      0.000      0.066        5000/5000      IO#puts
                      0.011      0.011      0.000      0.000       9998/25999      Kernel#nil?
                      0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#stdout?
                      0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#stderr?
                      0.000      0.000      0.000      0.000              2/6      NilClass#nil?
--------------------------------------------------------------------------------
                      0.136      0.007      0.000      0.129        1000/1000      ProfilerTest#run
  18.29%   0.92%      0.136      0.007      0.000      0.129             1000      Catamaran::Logger#severe
                      0.115      0.007      0.000      0.108        1000/5000      Catamaran::Logger#log
                      0.015      0.012      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.136      0.007      0.000      0.128        1000/1000      ProfilerTest#run
  18.26%   1.00%      0.136      0.007      0.000      0.128             1000      Catamaran::Logger#fatal
                      0.113      0.007      0.000      0.107        1000/5000      Catamaran::Logger#log
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.132      0.007      0.000      0.124        1000/1000      ProfilerTest#run
  17.68%   0.96%      0.132      0.007      0.000      0.124             1000      Catamaran::Logger#error
                      0.109      0.006      0.000      0.102        1000/5000      Catamaran::Logger#log
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.130      0.007      0.000      0.123        1000/1000      ProfilerTest#run
  17.41%   0.90%      0.130      0.007      0.000      0.123             1000      Catamaran::Logger#warn
                      0.109      0.007      0.000      0.102        1000/5000      Catamaran::Logger#log
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.122      0.006      0.000      0.115        1000/1000      ProfilerTest#run
  16.34%   0.87%      0.122      0.006      0.000      0.115             1000      Catamaran::Logger#notice
                      0.101      0.006      0.000      0.095        1000/5000      Catamaran::Logger#log
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000           3/8003      Catamaran::Logger#log_level
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#warn
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#notice
                      0.015      0.012      0.000      0.002        1000/8003      Catamaran::Logger#severe
                      0.015      0.012      0.000      0.002        1000/8003      Catamaran::Logger#info?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#debug?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#fatal
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#trace?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#error
  15.87%  13.54%      0.118      0.101      0.000      0.017             8003     *Catamaran::Logger#log_level
                      0.017      0.017      0.000      0.000      16001/25999      Kernel#nil?
                      0.000      0.000      0.000      0.000              4/6      NilClass#nil?
                      0.000      0.000      0.000      0.000           3/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.086      0.065      0.000      0.021        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
  11.58%   8.69%      0.086      0.065      0.000      0.021             5000      Time#strftime
                      0.015      0.015      0.000      0.000      10000/10000      Fixnum#divmod
                      0.006      0.006      0.000      0.000        5000/5000      Fixnum#%
--------------------------------------------------------------------------------
                      0.085      0.020      0.000      0.066        5000/5000      <Class::Catamaran::Outputter>#write
  11.46%   2.63%      0.085      0.020      0.000      0.066             5000      IO#puts
                      0.066      0.066      0.000      0.000      10000/10000      IO#write
--------------------------------------------------------------------------------
                      0.066      0.066      0.000      0.000      10000/10000      IO#puts
   8.84%   8.84%      0.066      0.066      0.000      0.000            10000      IO#write
--------------------------------------------------------------------------------
                      0.052      0.032      0.000      0.020        5000/5000      Catamaran::Logger#_format_msg
   6.96%   4.28%      0.052      0.032      0.000      0.020             5000      Catamaran::Logger#path_to_s
                      0.020      0.020      0.000      0.000        5000/5000      Array#join
                      0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#delimiter
--------------------------------------------------------------------------------
                      0.036      0.016      0.000      0.019        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
   4.77%   2.19%      0.036      0.016      0.000      0.019             5000      <Class::Time>#now
                      0.019      0.013      0.000      0.006        5000/5000      Time#initialize
--------------------------------------------------------------------------------
                      0.029      0.029      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
   3.92%   3.92%      0.029      0.029      0.000      0.000             5000      Kernel#sprintf
--------------------------------------------------------------------------------
                      0.011      0.011      0.000      0.000       9998/25999      <Class::Catamaran::Outputter>#write
                      0.017      0.017      0.000      0.000      16001/25999      Catamaran::Logger#log_level
   3.77%   3.77%      0.028      0.028      0.000      0.000            25999      Kernel#nil?
--------------------------------------------------------------------------------
                      0.025      0.009      0.000      0.015        1000/1000      ProfilerTest#run
   3.31%   1.26%      0.025      0.009      0.000      0.015             1000      Catamaran::Logger#trace?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.021      0.006      0.000      0.015        1000/1000      ProfilerTest#run
   2.78%   0.77%      0.021      0.006      0.000      0.015             1000      Catamaran::Logger#debug?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.020      0.005      0.000      0.015        1000/1000      ProfilerTest#run
   2.70%   0.74%      0.020      0.005      0.000      0.015             1000      Catamaran::Logger#info?
                      0.015      0.012      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.020      0.020      0.000      0.000        5000/5000      Catamaran::Logger#path_to_s
   2.67%   2.67%      0.020      0.020      0.000      0.000             5000      Array#join
--------------------------------------------------------------------------------
                      0.019      0.013      0.000      0.006        5000/5000      <Class::Time>#now
   2.58%   1.80%      0.019      0.013      0.000      0.006             5000      Time#initialize
                      0.006      0.006      0.000      0.000        5000/5000      Fixnum#+
--------------------------------------------------------------------------------
                      0.015      0.015      0.000      0.000      10000/10000      Time#strftime
   2.06%   2.06%      0.015      0.015      0.000      0.000            10000      Fixnum#divmod
--------------------------------------------------------------------------------
                      0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
   1.82%   1.82%      0.014      0.014      0.000      0.000             5000      <Class::Catamaran::LogLevel>#severity_to_s
--------------------------------------------------------------------------------
                      0.011      0.011      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
   1.48%   1.48%      0.011      0.011      0.000      0.000             5000      Fixnum#to_s
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
   0.84%   0.84%      0.006      0.006      0.000      0.000             5000      <Module::Process>#pid
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      Time#strftime
   0.82%   0.82%      0.006      0.006      0.000      0.000             5000      Fixnum#%
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      Time#initialize
   0.78%   0.78%      0.006      0.006      0.000      0.000             5000      Fixnum#+
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              2/6      <Class::Catamaran::Outputter>#write
                      0.000      0.000      0.000      0.000              4/6      Catamaran::Logger#log_level
   0.00%   0.00%      0.000      0.000      0.000      0.000                6      NilClass#nil?
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Outputter>#write
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#stdout?
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Global#[No method]
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      Class#new
                      0.000      0.000      0.000      0.000              1/1      BasicObject#initialize
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Outputter>#write
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#stderr?
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#path_to_s
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#delimiter
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Class#new
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      BasicObject#initialize

* indicates recursively called methods
```



Ideas around what's next
------------------------

* Make it easier to change the formatting pattern (Perhaps support for something similar to this:  http://logging.apache.org/log4j/1.2/apidocs/org/apache/log4j/PatternLayout.html?)
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and local files
* Ongoing performance considerations
* Something like `filter_parameter_logging`
* Color support
* Log rotation
* Heroku support (https://blog.heroku.com/archives/2013/7/15/logging-on-heroku)
* Buffered file I/O considerations

See also
--------
* http://stackoverflow.com/questions/462651/rails-logger-format-string-configuration
* http://stackoverflow.com/questions/3654827/logging-in-rails-app
* http://stackoverflow.com/questions/11991967/rails-log-too-verbose
* http://www.ietf.org/rfc/rfc3164.txt
* http://logging.apache.org/log4j/1.2
* https://github.com/TwP/logging
* https://github.com/colbygk/log4r
* http://guides.rubyonrails.org/debugging_rails_applications.html#the-logger


