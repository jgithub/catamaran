catamaran
=========

Gemfile:

    gem 'catamaran', :git => 'git://github.com/jgithub/catamaran.git'

Rails-related setup:

    rails g catamaran:install
    # Now modify development.rb as needed

Quickstart coding:

    class WelcomeController < ApplicationController
      LOGGER = CatLogger.MyCompany.MyAppName.App.Controller.WelcomeController

      def index
        LOGGER.io "Entering with params = #{params}" if LOGGER.io?

        LOGGER.debug "The params are: #{params}" if LOGGER.debug?

        LOGGER.io "Returning" if LOGGER.io?        
      end
    end

Reload the `index` page and check out your `development.log` file


TODO:

* Better formatter support
* Another iteration of improvements on logger.io
* Consider capturing log messages beyond stderr, stdout, and files
* Performance considerations


