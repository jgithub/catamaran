$: << '../lib'
require 'catamaran'

Catamaran::Manager.delimiter = '::'
Catamaran::logger.log_level = :debug

module MyCoolModule
  class WithDoubleColonDelimiter
    LOGGER = Catamaran.logger( "MyCoolModule::WithDoubleColonDelimiter" )

    def run
      LOGGER.debug( "Does this look more like Ruby?", { :file => __FILE__, :line => __LINE__ } ) if LOGGER.debug?
    end
  end
end

with_double_colon_delimiter = MyCoolModule::WithDoubleColonDelimiter.new
with_double_colon_delimiter.run



#  DEBUG pid-829 [2014-01-08 13:55:09:979]          MyCoolModule::WithDoubleColonDelimiter - Does this look more like Ruby? (with_double_colon_delimiter.rb:12)



