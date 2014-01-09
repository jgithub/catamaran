$: << '../lib'

# ruby simple_benchmark.rb 2>/dev/null

require 'catamaran'
require 'benchmark'

DEFAULT_NUM_ITERATIONS = 1000000

Catamaran.logger.log_level = :warn 
CATAMARAN_LOGGER = Catamaran.logger


n = DEFAULT_NUM_ITERATIONS

STDOUT.puts ""
STDOUT.puts "Writing logs"
STDOUT.puts "============="

Benchmark.bm(7) do |x|
  x.report("STDERR.puts") {
    n.times do |i|
      STDERR.puts "This is your last warning"      
    end
  }  
  x.report("warn       ") {
    n.times do |i|
      CATAMARAN_LOGGER.warn "This is your last warning"      
    end
  }
end 

STDOUT.puts ""
STDOUT.puts "Conditional disabled"
STDOUT.puts "===================="

n = DEFAULT_NUM_ITERATIONS
Benchmark.bm(7) do |x|
  x.report("STDERR.puts") {
    n.times do |i|
      STDERR.puts "This debug message will not be output by the logger" if false    
    end
  } 
  x.report("debug      ") {
    n.times do |i|
      CATAMARAN_LOGGER.debug "This debug message will not be output by the logger"  if CATAMARAN_LOGGER.debug?
    end
  }
end

# Writing logs
# =============
#               user     system      total        real
# STDERR.puts  2.050000   1.460000   3.510000 (  3.515167)
# warn        13.710000   1.990000  15.700000 ( 15.710708)

# Conditional disabled
# ====================
#               user     system      total        real
# STDERR.puts  0.050000   0.000000   0.050000 (  0.056674)
# debug        0.150000   0.000000   0.150000 (  0.150484)

