require 'catamaran/logger'
require 'catamaran/manager'
require 'catamaran/formatter/caller_formatter'
require 'catamaran/formatter/no_caller_formatter'
require 'catamaran/outputter'
require 'catamaran/output_file'

require 'catamaran/log_level'
require 'catamaran/version'


module Catamaran
  def self.debugging?
    @debugging || false
  end
  
  def self.debugging( msg )
    $stderr.puts( "[CATAMARAN DEBUGGING] #{msg}" ) if self.debugging?
  end

  def self.debugging=( value )
    @debugging = value
  end  

  def self.logger( optional_string = nil )
    Catamaran::Manager.root_logger().get_logger( optional_string )
  end

  ##
  # get_logger() is an alias for logger()
  class << self
    alias_method :get_logger, :logger
  end

  LOG_LEVEL_TRACE = LogLevel::TRACE 
  LOG_LEVEL_DEBUG = LogLevel::DEBUG
  LOG_LEVEL_INFO = LogLevel::INFO
  LOG_LEVEL_WARN = LogLevel::WARN
  LOG_LEVEL_ERROR = LogLevel::ERROR
  LOG_LEVEL_SEVERE = LogLevel::SEVERE
  LOG_LEVEL_FATAL = LogLevel::FATAL  
end

# add rails integration
require('catamaran/integration/rails') if defined?(Rails)

# Catamaran::Manager.stderr = true
# Catamaran::Manager.stdout = false

##
# Define the CatLogger alias for the Catamaran root logger
Kernel.send( :remove_const, 'CatLogger' ) if Kernel.const_defined?( 'CatLogger' )
Kernel.const_set( 'CatLogger', Catamaran.logger )

