Catamaran
=========

Logging is a powerful and often undervalued tool in software development.  When done right, it's a great way to document code, and it provides a simple &amp; effective way to solve problems when things go awry.  All an important part of maintainable code.

Gemfile
-------

    gem 'catamaran', '~> 0.6.0'

Rails-related setup:

    rails g catamaran:install

Now modify `config/initializers/catamaran/development.rb` as needed

Ruby Quickstart
---------------
    require 'catamaran'

    class FirstRubyDemo
      LOGGER = Catamaran.logger( "FirstRubyDemo" )

      def run
        LOGGER.warn( "Note that WARN messages are getting logged" ) if LOGGER.warn?
        LOGGER.trace( "Note that TRACE messages are NOT getting logged" ) if LOGGER.trace?
      end
    end

    FirstRubyDemo.new.run

And the output

     WARN pid-2729 [2013-12-23 19:35:35:732]                                   FirstRubyDemo - Note that WARN messages are getting logged


Rails Quickstart
----------------

    class PagesController < ApplicationController
      LOGGER = Catamaran.logger.com.mycompany.myrailsapp.app.controllers.PagesController

      def index
        # LOGGER.io methods are reserved for logs related to entering and returning from methods
        LOGGER.io "Entering with params = #{params}" if LOGGER.io?

        LOGGER.trace "This is my TRACE log" if LOGGER.trace?
        LOGGER.debug "This is my DEBUG log" if LOGGER.debug?
        LOGGER.info "This is my INFO log" if LOGGER.info?
        LOGGER.warn "This is my WARN log" if LOGGER.warn?
        LOGGER.error "This is my ERROR log" if LOGGER.error?

        LOGGER.io "Returning" if LOGGER.io?        
      end
    end

Load the `index` page and check out your `development.log` file

### Sample log entry (in your development.log file)
    IO pid-86000 [2013-12-17 17:26:39:176] pany.myrailsapp.app.controllers.PagesController - Entering with params = {"controller"=>"pages", "action"=>"index"} (`/myrailsapp/app/controllers/pages_controller.rb:7`:in `index`)


Other Ruby Examples
-------------------
    require 'catamaran'

    Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::TRACE 
    Catamaran::Manager.formatter_class = Catamaran::Formatter::NoCallerFormatter

    class SecondRubyDemo
      LOGGER = Catamaran.logger( { :class => name(), :file => __FILE__ } )

      def run
        LOGGER.trace( "Sample TRACE statement", { :line => __LINE__, :method => 'run'} ) if LOGGER.trace?
      end
    end 

    class ThirdRubyDemo
      LOGGER = Catamaran.logger( "com.mycompany.ThirdRubyDemo", { :class => name(), :file => __FILE__ } )

      def run
        LOGGER.debug( "Sample DEBUG statement", { :line => __LINE__, :method => 'run' } ) if LOGGER.debug?
        LOGGER.debug( "Sample DEBUG statement with backtrace option", { :line => __LINE__, :method => 'run', :backtrace => true } ) if LOGGER.debug?
      end
    end   

    SecondRubyDemo.new.run
    ThirdRubyDemo.new.run

And the output

     TRACE pid-4714 [2013-12-26 15:33:05:311]                                                 - Sample TRACE statement (catamaran_ruby_demos.rb:11:in `SecondRubyDemo.run')
     DEBUG pid-4714 [2013-12-26 15:33:05:311]                     com.mycompany.ThirdRubyDemo - Sample DEBUG statement (catamaran_ruby_demos.rb:19:in `ThirdRubyDemo.run')
     DEBUG pid-4714 [2013-12-26 15:33:05:311]                     com.mycompany.ThirdRubyDemo - Sample DEBUG statement with backtrace option (catamaran_ruby_demos.rb:20:in `ThirdRubyDemo.run') from:
    catamaran_ruby_demos.rb:20:in `run'
    catamaran_ruby_demos.rb:25:in `<main>'



Inspiration
-----------
I'm looking for a logging utility that:

* records granular timestamps with each log entry
* records the process ID with each log entry
* captures from where each log entry was generated
* works equally well with classes that do and do *not* extend Rails base classes
* supports the TRACE log level (or other log level less critical than DEBUG). 
* is capable of capturing logs at different log level thresholds from different parts of the app simultaneously
* readily works with Rails


Performance Considerations
--------------------------

### With or without `if LOGGER.debug?`
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

#### Summary

* For log messages that are usually *disabled* in the production environment ( TRACE, DEBUG ), it's generally better to invoke the log only after confirming that the log level is enabled 

ex:

    LOGGER.trace "This is a TRACE log" if LOGGER.trace?
    LOGGER.debug "This is a DEBUG log" if LOGGER.debug?

* For log messages that are usually *enabled* in the production environment ( INFO, WARN, ERROR, SEVERE ), it's generally better to invoke the log WITHOUT first testing the log level

ex:

    LOGGER.info "This is a INFO log"
    LOGGER.warn "This is a WARN log"
    LOGGER.error "This is a ERROR log" 

### NoCallerFormatter vs CallerFormatter

    require 'catamaran'
    require 'benchmark'

    Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::INFO 
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

#### Summary

`CallerFormatter` is slower but contains more details in the log statements as compared to `NoCallerFormatter`

##### Sample log from NoCallerFormatter

    WARN pid-4407 [2013-12-26 14:18:19:697]                                   FirstRubyDemo - Note that WARN messages are getting logged

##### Sample log from CallerFormatter

    WARN pid-4410 [2013-12-26 14:18:38:276]                                   FirstRubyDemo - Note that WARN messages are getting logged (catamaran_ruby_demos.rb:12:in `run')

Because of this performance difference, `NoCallerFormatter` is the Catamaran default.  Though `CallerFormatter` tends to be especially useful in the development and test environments when debugging problems during the course of functional testing.


Ideas around what's next
------------------------

* Make it easier to change the formatting pattern
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and local files
* Ongoing performance considerations
* Something like `filter_parameter_logging`
* Optional backtrace support for certain logs
* Color support



