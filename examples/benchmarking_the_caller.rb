$: << '../lib'
require 'catamaran'
require 'benchmark'

Catamaran::Manager.stderr = false

class CatamaranCallerBenchmark
  LOGGER = Catamaran.logger( "CatamaranCallerBenchmark" )

  n = 500000
  Benchmark.bm(7) do |x|
    Catamaran::Manager.formatter_caller_enabled = false
    
    x.report("Catamaran::Manager.formatter_caller_enabled = false") {
      n.times do |i|
        LOGGER.error "This is a ERROR log"
      end
    }   
    
    Catamaran::Manager.formatter_caller_enabled = true
    
    x.report("Catamaran::Manager.formatter_caller_enabled = true ") {
      n.times do |i|
        LOGGER.error "This is a ERROR log"
      end
    }
  end
end


#                                                            user     system      total        real
# Catamaran::Manager.formatter_caller_enabled = false    5.870000   0.060000   5.930000 (  5.943813)
# Catamaran::Manager.formatter_caller_enabled = true    13.120000   0.350000  13.470000 ( 13.469126)

