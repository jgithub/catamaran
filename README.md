Catamaran
=========

I think logging is a powerful and often undervalued tool in software development.  When done right, it's a great way to document code, and it provides a simple &amp; effective way to solve problems when things go awry.  All an important part of maintainable code.

Gemfile
-------

    gem 'catamaran', '~> 0.2.0'

Rails-related setup:

    rails g catamaran:install

Now modify `development.rb` as needed

Ruby Quickstart
-------------------------------
    Catamaran::Manager.stderr = true
    Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::DEBUG 
    Catamaran::Manager.formatter_class = Catamaran::Formatter::NoCallerFormatter

    class FirstRubyDemo
      LOGGER = Catamaran.logger( "FirstRubyDemo" )

      def run
        LOGGER.debug( "Note that DEBUG messages are getting logged" ) if LOGGER.debug?
        LOGGER.trace( "Note that TRACE messages are NOT getting logged" ) if LOGGER.trace?
      end
    end

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


    puts "Catamaran VERSION = #{Catamaran::VERSION}"
    FirstRubyDemo.new.run
    SecondRubyDemo.new.run
    ThirdRubyDemo.new.run

And the output

     Catamaran VERSION = 0.3.0
     DEBUG pid-2729 [2013-12-23 19:35:35:732]                                   FirstRubyDemo - Note that DEBUG messages are getting logged
     DEBUG pid-2729 [2013-12-23 19:35:35:732]                                                 - Sample DEBUG statement (catmaran_ruby_demos.rb:21:in `SecondRubyDemo.run')
     DEBUG pid-2729 [2013-12-23 19:35:35:732]                     com.mycompany.ThirdRubyDemo - Sample DEBUG statement (catmaran_ruby_demos.rb:29:in `ThirdRubyDemo.run')


Rails Quickstart
--------------------------------

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

Ideas around what's next
------------------------

* Make it easier to change the formatting pattern
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and local files
* Ongoing performance considerations
* Something like `filter_parameter_logging`
* Optional backtrace support for certain logs
* Color support



