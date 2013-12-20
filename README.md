Catamaran
=========

I think logging is a powerful and often undervalued tool in software development.  When done right, it's a great way to document code, and it provides a simple &amp; effective way to solve problems when things go awry.  All an important part of maintainable code.

Gemfile
-------

    gem 'catamaran', :git => 'git://github.com/jgithub/catamaran.git'

Rails-related setup:

    rails g catamaran:install

Now modify `development.rb` as needed

Quickstart coding
-----------------

    class WelcomeController < ApplicationController
      LOGGER = CatLogger.MyCompany.MyAppName.App.Controller.WelcomeController

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

Sample log entry (in your development.log file)
-----------------------------------------------
    IO pid-86000 [2013-12-17 17:26:39:176] MyAppName.App.Controller.WelcomeController - Entering with params = {"controller"=>"welcome", "action"=>"index"} (`/my_rails_project/app/controllers/welcome_controller.rb:7`:in `index`)

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



