Catamaran
=========

Logging is a powerful and often undervalued tool in software development.  When done right, it's a great way to document code, and it provides a simple &amp; effective way to solve problems when things go awry.  All an important part of maintainable code.

Gemfile
-------

    gem 'catamaran', '~> 0.10.0'

Rails-related setup:

    rails g catamaran:install

Now modify `config/initializers/catamaran/development.rb` as needed

Ruby Quickstart
---------------
```ruby
require 'catamaran'

class FirstRubyDemo
  LOGGER = Catamaran.logger( "com.mytld.FirstRubyDemo" )
  # or equivalently: 
  # LOGGER = Catamaran.logger.com.mytld.FirstRubyDemo

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

FirstRubyDemo.new.run
```

And the output

```
NOTICE pid-23773 [2014-01-01 13:09:47:551]                     com.mytld.FirstRubyDemo - NOTICE logs are captured by default
  WARN pid-23773 [2014-01-01 13:09:47:551]                     com.mytld.FirstRubyDemo - WARN logs are captured by default
 ERROR pid-23773 [2014-01-01 13:09:47:551]                     com.mytld.FirstRubyDemo - ERROR logs are captured by default
SEVERE pid-23773 [2014-01-01 13:09:47:551]                     com.mytld.FirstRubyDemo - SEVERE logs are captured by default
 FATAL pid-23773 [2014-01-01 13:09:47:551]                     com.mytld.FirstRubyDemo - FATAL logs are captured by default
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


Other Ruby Examples
-------------------
```ruby
require 'catamaran'

Catamaran.logger.log_level = Catamaran::LogLevel::INFO 
Catamaran.logger.backtrace_log_level = Catamaran::LogLevel::ERROR 
Catamaran::Manager.formatter_class = Catamaran::Formatter::NoCallerFormatter

class SecondRubyDemo
  LOGGER = Catamaran.logger( { :class => name(), :file => __FILE__ } )

  def run
    LOGGER.info( "Sample INFO statement", { :line => __LINE__, :method => 'run'} ) if LOGGER.info?
  end
end 

class ThirdRubyDemo
  LOGGER = Catamaran.logger( "com.mytld.ThirdRubyDemo", { :class => name(), :file => __FILE__ } )

  def run
    LOGGER.warn( "Sample WARN statement", { :line => __LINE__, :method => 'run' } )
    LOGGER.warn( "Sample WARN statement with backtrace option", { :line => __LINE__, :method => 'run', :backtrace => true } )
    LOGGER.error( "Sample ERROR statement with backtrace option", { :line => __LINE__, :method => 'run', :backtrace => true } )        
  end
end   

SecondRubyDemo.new.run
ThirdRubyDemo.new.run
```

And the output

      INFO pid-5973 [2013-12-27 17:18:09:115]                                                 - Sample INFO statement (catamaran_ruby_demos.rb:12:in `SecondRubyDemo.run')
      WARN pid-5973 [2013-12-27 17:18:09:115]                     com.mytld.ThirdRubyDemo - Sample WARN statement (catamaran_ruby_demos.rb:20:in `ThirdRubyDemo.run')
      WARN pid-5973 [2013-12-27 17:18:09:115]                     com.mytld.ThirdRubyDemo - Sample WARN statement with backtrace option (catamaran_ruby_demos.rb:21:in `ThirdRubyDemo.run')
     ERROR pid-5973 [2013-12-27 17:18:09:115]                     com.mytld.ThirdRubyDemo - Sample ERROR statement with backtrace option (catamaran_ruby_demos.rb:22:in `ThirdRubyDemo.run') from:
    catamaran_ruby_demos.rb:22:in `run'
    catamaran_ruby_demos.rb:27:in `<main>'




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
Catamaran::Manager.formatter_class = Catamaran::Formatter::NoCallerFormatter
Catamaran::Manager.stderr = false

class CatamaranPerformanceTest
  LOGGER = Catamaran.logger( "CatamaranPerformanceTest" )

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

### NoCallerFormatter vs CallerFormatter

```ruby
require 'catamaran'
require 'benchmark'

Catamaran::Manager.stderr = false

class CatamaranPerformanceTest
  LOGGER = Catamaran.logger( "CatamaranPerformanceTest" )

  n = 500000
  Benchmark.bm(7) do |x|
    Catamaran::Manager.formatter_class = Catamaran::Formatter::NoCallerFormatter
    
    x.report("Using NoCallerFormatter") {
      n.times do |i|
        LOGGER.error "This is a ERROR log"
      end
    }   
    
    Catamaran::Manager.formatter_class = Catamaran::Formatter::CallerFormatter
    
    x.report("Using CallerFormatter") {
      n.times do |i|
        LOGGER.error "This is a ERROR log"
      end
    }
  end
end
                         

#                              user     system      total        real
# Using NoCallerFormatter  6.850000   0.010000   6.860000 (  6.864649)
# Using CallerFormatter   14.700000   0.150000  14.850000 ( 14.867592)
```

#### Summary

`CallerFormatter` is slower but contains more details in the log statements as compared to `NoCallerFormatter`

##### Sample log from NoCallerFormatter

    WARN pid-4407 [2013-12-26 14:18:19:697]                                   FirstRubyDemo - Note that WARN messages are getting logged

##### Sample log from CallerFormatter

    WARN pid-4410 [2013-12-26 14:18:38:276]                                   FirstRubyDemo - Note that WARN messages are getting logged (catamaran_ruby_demos.rb:12:in `run')

Because of this performance difference, `NoCallerFormatter` is the Catamaran default.  Though `CallerFormatter` tends to be especially useful in the development and test environments when debugging problems during the course of functional testing.

### Ruby Profiler
```ruby
require 'catamaran'
require 'ruby-prof'


class FirstRubyDemo
  LOGGER = Catamaran.logger( "com.mycompany.FirstRubyDemo" )
  # or equivalently: 
  # LOGGER = Catamaran.logger.com.mycompany.FirstRubyDemo

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
Fiber ID: 2164637460
Total Time: 0.8493040000000001
Sort by: total_time

  %total   %self      total       self       wait      child            calls    Name
--------------------------------------------------------------------------------
 100.00%   0.00%      0.849      0.000      0.000      0.849                1      Global#[No method]
                      0.849      0.003      0.000      0.846              1/1      Integer#times
                      0.000      0.000      0.000      0.000              1/1      Class#new
--------------------------------------------------------------------------------
                      0.849      0.003      0.000      0.846              1/1      Global#[No method]
  99.99%   0.38%      0.849      0.003      0.000      0.846                1      Integer#times
                      0.846      0.023      0.000      0.823        1000/1000      FirstRubyDemo#run
--------------------------------------------------------------------------------
                      0.846      0.023      0.000      0.823        1000/1000      Integer#times
  99.62%   2.72%      0.846      0.023      0.000      0.823             1000      FirstRubyDemo#run
                      0.164      0.008      0.000      0.156        1000/1000      Catamaran::Logger#severe
                      0.158      0.011      0.000      0.147        1000/1000      Catamaran::Logger#warn
                      0.150      0.007      0.000      0.142        1000/1000      Catamaran::Logger#error
                      0.149      0.008      0.000      0.141        1000/1000      Catamaran::Logger#fatal
                      0.139      0.007      0.000      0.132        1000/1000      Catamaran::Logger#notice
                      0.022      0.007      0.000      0.016        1000/1000      Catamaran::Logger#trace?
                      0.021      0.006      0.000      0.016        1000/1000      Catamaran::Logger#debug?
                      0.020      0.005      0.000      0.015        1000/1000      Catamaran::Logger#info?
--------------------------------------------------------------------------------
                      0.118      0.006      0.000      0.112        1000/5000      Catamaran::Logger#notice
                      0.126      0.007      0.000      0.119        1000/5000      Catamaran::Logger#fatal
                      0.126      0.007      0.000      0.119        1000/5000      Catamaran::Logger#error
                      0.131      0.007      0.000      0.125        1000/5000      Catamaran::Logger#warn
                      0.140      0.007      0.000      0.134        1000/5000      Catamaran::Logger#severe
  75.52%   3.91%      0.641      0.033      0.000      0.608             5000      Catamaran::Logger#log
                      0.438      0.028      0.000      0.409        5000/5000      Catamaran::Logger#_format_msg
                      0.170      0.048      0.000      0.123        5000/5000      <Class::Catamaran::Outputter>#write
--------------------------------------------------------------------------------
                      0.438      0.028      0.000      0.409        5000/5000      Catamaran::Logger#log
  51.55%   3.34%      0.438      0.028      0.000      0.409             5000      Catamaran::Logger#_format_msg
                      0.339      0.040      0.000      0.299        5000/5000      <Class::Catamaran::Formatter::NoCallerFormatter>#construct_formatted_message
                      0.053      0.033      0.000      0.021        5000/5000      Catamaran::Logger#path_to_s
                      0.017      0.017      0.000      0.000        5000/5000      <Class::Catamaran::Manager>#formatter_class
--------------------------------------------------------------------------------
                      0.339      0.040      0.000      0.299        5000/5000      Catamaran::Logger#_format_msg
  39.95%   4.71%      0.339      0.040      0.000      0.299             5000      <Class::Catamaran::Formatter::NoCallerFormatter>#construct_formatted_message
                      0.261      0.077      0.000      0.184        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
                      0.021      0.021      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#contruct_suffix_info
                      0.017      0.017      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#construct_backtrace_info
--------------------------------------------------------------------------------
                      0.261      0.077      0.000      0.184        5000/5000      <Class::Catamaran::Formatter::NoCallerFormatter>#construct_formatted_message
  30.77%   9.07%      0.261      0.077      0.000      0.184             5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
                      0.085      0.060      0.000      0.024        5000/5000      Time#strftime
                      0.039      0.019      0.000      0.020        5000/5000      <Class::Time>#now
                      0.027      0.027      0.000      0.000        5000/5000      Kernel#sprintf
                      0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::LogLevel>#severity_to_s
                      0.013      0.013      0.000      0.000        5000/5000      Fixnum#to_s
                      0.007      0.007      0.000      0.000        5000/5000      <Module::Process>#pid
--------------------------------------------------------------------------------
                      0.170      0.048      0.000      0.123        5000/5000      Catamaran::Logger#log
  20.05%   5.61%      0.170      0.048      0.000      0.123             5000      <Class::Catamaran::Outputter>#write
                      0.089      0.020      0.000      0.069        5000/5000      IO#puts
                      0.018      0.018      0.000      0.000        5000/5000      <Class::Catamaran::Manager>#stdout?
                      0.015      0.015      0.000      0.000        5000/5000      <Class::Catamaran::Manager>#stderr?
--------------------------------------------------------------------------------
                      0.164      0.008      0.000      0.156        1000/1000      FirstRubyDemo#run
  19.26%   0.90%      0.164      0.008      0.000      0.156             1000      Catamaran::Logger#severe
                      0.140      0.007      0.000      0.134        1000/5000      Catamaran::Logger#log
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.158      0.011      0.000      0.147        1000/1000      FirstRubyDemo#run
  18.60%   1.34%      0.158      0.011      0.000      0.147             1000      Catamaran::Logger#warn
                      0.131      0.007      0.000      0.125        1000/5000      Catamaran::Logger#log
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.150      0.007      0.000      0.142        1000/1000      FirstRubyDemo#run
  17.61%   0.88%      0.150      0.007      0.000      0.142             1000      Catamaran::Logger#error
                      0.126      0.007      0.000      0.119        1000/5000      Catamaran::Logger#log
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.149      0.008      0.000      0.141        1000/1000      FirstRubyDemo#run
  17.52%   0.89%      0.149      0.008      0.000      0.141             1000      Catamaran::Logger#fatal
                      0.126      0.007      0.000      0.119        1000/5000      Catamaran::Logger#log
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.139      0.007      0.000      0.132        1000/1000      FirstRubyDemo#run
  16.37%   0.77%      0.139      0.007      0.000      0.132             1000      Catamaran::Logger#notice
                      0.118      0.006      0.000      0.112        1000/5000      Catamaran::Logger#log
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000           3/8003      Catamaran::Logger#log_level
                      0.014      0.012      0.000      0.002        1000/8003      Catamaran::Logger#notice
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#info?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#warn
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#debug?
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#severe
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#fatal
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#trace?
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#error
  14.49%  12.32%      0.123      0.105      0.000      0.018             8003     *Catamaran::Logger#log_level
                      0.018      0.018      0.000      0.000      16001/16001      Kernel#nil?
                      0.000      0.000      0.000      0.000              4/4      NilClass#nil?
                      0.000      0.000      0.000      0.000           3/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.089      0.020      0.000      0.069        5000/5000      <Class::Catamaran::Outputter>#write
  10.48%   2.40%      0.089      0.020      0.000      0.069             5000      IO#puts
                      0.069      0.069      0.000      0.000      10000/10000      IO#write
--------------------------------------------------------------------------------
                      0.085      0.060      0.000      0.024        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
   9.96%   7.09%      0.085      0.060      0.000      0.024             5000      Time#strftime
                      0.018      0.018      0.000      0.000      10000/10000      Fixnum#divmod
                      0.006      0.006      0.000      0.000        5000/5000      Fixnum#%
--------------------------------------------------------------------------------
                      0.069      0.069      0.000      0.000      10000/10000      IO#puts
   8.08%   8.08%      0.069      0.069      0.000      0.000            10000      IO#write
--------------------------------------------------------------------------------
                      0.053      0.033      0.000      0.021        5000/5000      Catamaran::Logger#_format_msg
   6.28%   3.85%      0.053      0.033      0.000      0.021             5000      Catamaran::Logger#path_to_s
                      0.021      0.021      0.000      0.000        5000/5000      Array#join
                      0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#delimiter
--------------------------------------------------------------------------------
                      0.039      0.019      0.000      0.020        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
   4.62%   2.29%      0.039      0.019      0.000      0.020             5000      <Class::Time>#now
                      0.020      0.014      0.000      0.006        5000/5000      Time#initialize
--------------------------------------------------------------------------------
                      0.027      0.027      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
   3.21%   3.21%      0.027      0.027      0.000      0.000             5000      Kernel#sprintf
--------------------------------------------------------------------------------
                      0.022      0.007      0.000      0.016        1000/1000      FirstRubyDemo#run
   2.63%   0.78%      0.022      0.007      0.000      0.016             1000      Catamaran::Logger#trace?
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.021      0.006      0.000      0.016        1000/1000      FirstRubyDemo#run
   2.53%   0.70%      0.021      0.006      0.000      0.016             1000      Catamaran::Logger#debug?
                      0.016      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.021      0.021      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::NoCallerFormatter>#construct_formatted_message
   2.52%   2.52%      0.021      0.021      0.000      0.000             5000      <Class::Catamaran::Formatter::BaseFormatter>#contruct_suffix_info
--------------------------------------------------------------------------------
                      0.021      0.021      0.000      0.000        5000/5000      Catamaran::Logger#path_to_s
   2.42%   2.42%      0.021      0.021      0.000      0.000             5000      Array#join
--------------------------------------------------------------------------------
                      0.020      0.005      0.000      0.015        1000/1000      FirstRubyDemo#run
   2.38%   0.64%      0.020      0.005      0.000      0.015             1000      Catamaran::Logger#info?
                      0.015      0.013      0.000      0.002        1000/8003      Catamaran::Logger#log_level
--------------------------------------------------------------------------------
                      0.020      0.014      0.000      0.006        5000/5000      <Class::Time>#now
   2.33%   1.62%      0.020      0.014      0.000      0.006             5000      Time#initialize
                      0.006      0.006      0.000      0.000        5000/5000      Fixnum#+
--------------------------------------------------------------------------------
                      0.018      0.018      0.000      0.000      16001/16001      Catamaran::Logger#log_level
   2.16%   2.16%      0.018      0.018      0.000      0.000            16001      Kernel#nil?
--------------------------------------------------------------------------------
                      0.018      0.018      0.000      0.000        5000/5000      <Class::Catamaran::Outputter>#write
   2.16%   2.16%      0.018      0.018      0.000      0.000             5000      <Class::Catamaran::Manager>#stdout?
--------------------------------------------------------------------------------
                      0.018      0.018      0.000      0.000      10000/10000      Time#strftime
   2.15%   2.15%      0.018      0.018      0.000      0.000            10000      Fixnum#divmod
--------------------------------------------------------------------------------
                      0.017      0.017      0.000      0.000        5000/5000      Catamaran::Logger#_format_msg
   1.98%   1.98%      0.017      0.017      0.000      0.000             5000      <Class::Catamaran::Manager>#formatter_class
--------------------------------------------------------------------------------
                      0.017      0.017      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::NoCallerFormatter>#construct_formatted_message
   1.96%   1.96%      0.017      0.017      0.000      0.000             5000      <Class::Catamaran::Formatter::BaseFormatter>#construct_backtrace_info
--------------------------------------------------------------------------------
                      0.015      0.015      0.000      0.000        5000/5000      <Class::Catamaran::Outputter>#write
   1.81%   1.81%      0.015      0.015      0.000      0.000             5000      <Class::Catamaran::Manager>#stderr?
--------------------------------------------------------------------------------
                      0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
   1.61%   1.61%      0.014      0.014      0.000      0.000             5000      <Class::Catamaran::LogLevel>#severity_to_s
--------------------------------------------------------------------------------
                      0.013      0.013      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
   1.52%   1.52%      0.013      0.013      0.000      0.000             5000      Fixnum#to_s
--------------------------------------------------------------------------------
                      0.007      0.007      0.000      0.000        5000/5000      <Class::Catamaran::Formatter::BaseFormatter>#base_construct_formatted_message
   0.78%   0.78%      0.007      0.007      0.000      0.000             5000      <Module::Process>#pid
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      Time#strftime
   0.72%   0.72%      0.006      0.006      0.000      0.000             5000      Fixnum#%
--------------------------------------------------------------------------------
                      0.006      0.006      0.000      0.000        5000/5000      Time#initialize
   0.70%   0.70%      0.006      0.006      0.000      0.000             5000      Fixnum#+
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Global#[No method]
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      Class#new
                      0.000      0.000      0.000      0.000              1/1      BasicObject#initialize
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              4/4      Catamaran::Logger#log_level
   0.00%   0.00%      0.000      0.000      0.000      0.000                4      NilClass#nil?
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Class#new
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      BasicObject#initialize
--------------------------------------------------------------------------------
                      0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#path_to_s
   0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#delimiter

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
* Revisit how the formatters work




