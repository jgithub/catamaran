$: << '../lib'
require 'catamaran'
require 'ruby-prof'

class WithTheRubyProfiler
  LOGGER = Catamaran.logger( "com.mycompany.WithTheRubyProfiler" )

  def run
    # Disabled by default
    LOGGER.trace( "TRACE logs are NOT captured by default" ) if LOGGER.trace?
    LOGGER.debug( "DEBUG logs are NOT captured by default" ) if LOGGER.debug?
    LOGGER.info( "INFO logs are NOT captured by default" ) if LOGGER.info?

    # Enabled by default
    LOGGER.notice( "NOTICE logs are captured by default" )
    LOGGER.warn( "WARN logs are captured by default" )
    LOGGER.error( "ERROR logs are captured by default" )
    LOGGER.severe( "SEVERE logs are captured by default" )
    LOGGER.fatal( "FATAL logs are captured by default" )
  end
end

RubyProf.start

demo = WithTheRubyProfiler.new
1000.times do
  demo.run
end

result = RubyProf.stop

printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT)

# Results are currently part of README.md