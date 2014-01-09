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
# STDERR.puts  2.060000   1.460000   3.520000 (  3.529794)
# warn        12.950000   2.010000  14.960000 ( 14.971881)

# Conditional disabled
# ====================
#               user     system      total        real
# STDERR.puts  0.060000   0.000000   0.060000 (  0.052432)
# debug        0.150000   0.000000   0.150000 (  0.150887)

