catamaran
=========
Rails-related setup:

    rails g catamaran:install
    # Now modify development.rb as needed

Quickstart:

    class WelcomeController < ApplicationController
      LOGGER = CatLogger.MyCompany.MyAppName.App.Controller.WelcomeController

      def index
        LOGGER.io "Entering with params = #{params}" if LOGGER.io?

        LOGGER.debug "The params are: #{params}" if LOGGER.debug?

        LOGGER.io "Returning" if LOGGER.io?        
      end
    end

TODO:

* Better formatter support
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and files

