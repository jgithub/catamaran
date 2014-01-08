$: << '../lib'

require 'catamaran'
require 'benchmark'

Catamaran.logger.log_level = Catamaran::LogLevel::INFO 
Catamaran::Manager.stderr = false

class BenchmarkingConditionalLogStatements
  LOGGER = Catamaran.logger( "BenchmarkingConditionalLogStatements" )

  # NOTE that the log level for this test is set to INFO, 
  # so 'warn' logs are enabled and 'debug' logs are disabled

  n = 500000
  Benchmark.bm(7) do |x|
    x.report("LOGGER.warn WITHOUT if LOGGER.warn?  ") {
      n.times do |i|
        LOGGER.warn "Based on the current log level, this log is being captured"
      end
    }
    x.report("LOGGER.warn WITH if LOGGER.warn?     ") {
      n.times do |i|
        LOGGER.warn "Based on the current log level, this log is being captured" if LOGGER.warn?
      end
    }
    x.report("LOGGER.debug WITHOUT if LOGGER.debug?") {
      n.times do |i|
        LOGGER.debug "Based on the current log level, this log is NOT being captured"
      end
    }
    x.report("LOGGER.debug WITH if LOGGER.debug?   ") {
      n.times do |i|
        LOGGER.debug "Based on the current log level, this log is NOT being captured" if LOGGER.debug?       
      end
    }
  end 
end

#                                            user     system      total        real
# LOGGER.warn WITHOUT if LOGGER.warn?    6.440000   0.090000   6.530000 (  6.533838)
# LOGGER.warn WITH if LOGGER.warn?       7.110000   0.120000   7.230000 (  7.242870)
# LOGGER.debug WITHOUT if LOGGER.debug?  0.530000   0.020000   0.550000 (  0.548454)
# LOGGER.debug WITH if LOGGER.debug?     0.450000   0.030000   0.480000 (  0.474419)
