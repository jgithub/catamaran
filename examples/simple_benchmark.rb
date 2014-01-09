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
# STDERR.puts  2.030000   1.450000   3.480000 (  3.478798)
# warn        13.760000   2.040000  15.800000 ( 15.807082)

# Conditional disabled
# ====================
#               user     system      total        real
# STDERR.puts  0.060000   0.000000   0.060000 (  0.052521)
# debug        0.600000   0.040000   0.640000 (  0.653023)

