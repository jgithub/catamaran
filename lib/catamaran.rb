require 'singleton'
require 'catamaran/logger'
require 'catamaran/manager'
require 'catamaran/formatter'
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

  def self.logger( *args )
    Catamaran.debugging( "Catamaran.logger() - Entering with args = #{args}" ) if Catamaran.debugging?        
    Catamaran::Manager.root_logger().get_logger( *args )
  end

  ##
  # get_logger() is an alias for logger()
  class << self
    alias_method :get_logger, :logger
  end

  LOG_LEVEL_TRACE = LogLevel::TRACE 
  LOG_LEVEL_DEBUG = LogLevel::DEBUG
  LOG_LEVEL_INFO = LogLevel::INFO
  LOG_LEVEL_NOTICE = LogLevel::NOTICE
  LOG_LEVEL_WARN = LogLevel::WARN
  LOG_LEVEL_ERROR = LogLevel::ERROR
  LOG_LEVEL_SEVERE = LogLevel::SEVERE
  LOG_LEVEL_FATAL = LogLevel::FATAL  
end

# add rails integration
require('catamaran/integration/rails') if defined?(Rails)

# By default, Catamaran should not write message to STDOUT
# Catamaran::Manager.stderr = false

# By default, Catamaran should not write message to STDOUT
# Catamaran::Manager.stdout = false

if [1,'1','t', 'true', 'y', 'yes','T', 'TRUE', 'Y', 'YES', true].include?( ENV['CATAMARAN_STDERR'] ) 
  Catamaran::Manager.stderr = true
end

if [1,'1','t', 'true', 'y', 'yes','T', 'TRUE', 'Y', 'YES', true].include?( ENV['CATAMARAN_STDOUT'] ) 
  Catamaran::Manager.stdout = true
end

##
# Define the CatLogger alias for the Catamaran root logger
Kernel.send( :remove_const, 'CatLogger' ) if Kernel.const_defined?( 'CatLogger' )
Kernel.const_set( 'CatLogger', Catamaran.logger )

Catamaran::Manager::reset
