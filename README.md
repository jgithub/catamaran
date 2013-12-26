Catamaran
=========

I think logging is a powerful and often undervalued tool in software development.  When done right, it's a great way to document code, and it provides a simple &amp; effective way to solve problems when things go awry.  All an important part of maintainable code.

Gemfile
-------

    gem 'catamaran', '~> 0.4.0'

Rails-related setup:

    rails g catamaran:install

Now modify `development.rb` as needed

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

    Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::DEBUG 
    Catamaran::Manager.formatter_class = Catamaran::Formatter::NoCallerFormatter

    class SecondRubyDemo
      LOGGER = Catamaran.logger( { :class => name(), :file => __FILE__ } )

      def run
        LOGGER.debug( "Sample DEBUG statement", { :line => __LINE__, :method => 'run'} ) if LOGGER.debug?
      end
    end 

    class ThirdRubyDemo
      LOGGER = Catamaran.logger( "com.mycompany.ThirdRubyDemo", { :class => name(), :file => __FILE__ } )

      def run
        LOGGER.debug( "Sample DEBUG statement", { :line => __LINE__, :method => 'run'} ) if LOGGER.debug?
      end
    end   

    SecondRubyDemo.new.run
    ThirdRubyDemo.new.run

And the output

     DEBUG pid-2729 [2013-12-23 19:35:35:732]                                                 - Sample DEBUG statement (catamaran_ruby_demos.rb:21:in `SecondRubyDemo.run')
     DEBUG pid-2729 [2013-12-23 19:35:35:732]                     com.mycompany.ThirdRubyDemo - Sample DEBUG statement (catamaran_ruby_demos.rb:29:in `ThirdRubyDemo.run')


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
    require 'catamaran'
    require 'benchmark'

    Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::INFO 
    Catamaran::Manager.formatter_class = Catamaran::Formatter::NoCallerFormatter

    class CatamaranPerformanceTest
      LOGGER = Catamaran.logger( "CatamaranPerformanceTest" )

      # NOTE that the log level for this test is set to INFO, 
      # so 'warn' logs are enabled and 'debug' logs are disabled

      n = 500000
      Benchmark.bm(7) do |x|
        x.report("warn WITHOUT if LOGGER.warn?  ") {
          n.times do |i|
            LOGGER.warn "This is a WARN"
          end
        }
        x.report("warn WITH if LOGGER.warn?     ") {
          n.times do |i|
            LOGGER.warn "This is a WARN" if LOGGER.warn?
          end
        }
      end

      Benchmark.bm(7) do |x|
        x.report("debug WITHOUT if LOGGER.debug?") {
          n.times do |i|
            LOGGER.debug "This is a DEBUG"
          end
        }
        x.report("debug WITH if LOGGER.debug?   ") {
          n.times do |i|
            LOGGER.debug "This is a DEBUG" if LOGGER.debug?       
          end
        }
      end 

    end


    #                                     user     system      total        real
    # warn WITHOUT if LOGGER.warn?    6.520000   0.020000   6.540000 (  6.533741)
    # warn WITH if LOGGER.warn?       7.110000   0.020000   7.130000 (  7.129708)
    #                                     user     system      total        real
    # debug WITHOUT if LOGGER.debug?  0.610000   0.010000   0.620000 (  0.623714)
    # debug WITH if LOGGER.debug?     0.530000   0.010000   0.540000 (  0.544295)



Ideas around what's next
------------------------

* Make it easier to change the formatting pattern
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and local files
* Ongoing performance considerations
* Something like `filter_parameter_logging`
* Optional backtrace support for certain logs
* Color support



