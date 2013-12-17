catamaran
=========

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

        LOGGER.trace "This is my DEBUG log" if LOGGER.trace?
        LOGGER.debug "This is my DEBUG log" if LOGGER.debug?
        LOGGER.info "This is my DEBUG log" if LOGGER.info?
        LOGGER.warn "This is my DEBUG log" if LOGGER.warn?
        LOGGER.error "This is my DEBUG log" if LOGGER.error?

        LOGGER.io "Returning" if LOGGER.io?        
      end
    end

Load the `index` page and check out your `development.log` file


TODO
----

* Better formatter support
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and files
* Performance considerations


