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



# Thread ID: 2156341060
# Fiber ID: 2160160240
# Total Time: 0.632719
# Sort by: total_time

#   %total   %self      total       self       wait      child            calls    Name
# --------------------------------------------------------------------------------
#  100.00%   0.01%      0.633      0.000      0.000      0.633                1      Global#[No method]
#                       0.633      0.003      0.000      0.630              1/1      Integer#times
#                       0.000      0.000      0.000      0.000              1/1      Class#new
# --------------------------------------------------------------------------------
#                       0.633      0.003      0.000      0.630              1/1      Global#[No method]
#   99.99%   0.47%      0.633      0.003      0.000      0.630                1      Integer#times
#                       0.630      0.022      0.000      0.608        1000/4000      WithTheRubyProfiler#run
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000        3000/4000      WithTheRubyProfiler#run
#                       0.630      0.022      0.000      0.608        1000/4000      Integer#times
#   99.52%   3.50%      0.630      0.022      0.000      0.608             4000     *WithTheRubyProfiler#run
#                       0.123      0.005      0.000      0.118        1000/2000      Catamaran::Logger#notice
#                       0.120      0.006      0.000      0.115        1000/2000      Catamaran::Logger#error
#                       0.120      0.006      0.000      0.114        1000/2000      Catamaran::Logger#severe
#                       0.119      0.005      0.000      0.114        1000/2000      Catamaran::Logger#warn
#                       0.118      0.006      0.000      0.112        1000/2000      Catamaran::Logger#fatal
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_trace?
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_info?
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_debug?
#                       0.000      0.000      0.000      0.000              3/8      String#to_sym
#                       0.000      0.000      0.000      0.000              3/8      Symbol#to_s
#                       0.000      0.000      0.000      0.000        3000/4000      WithTheRubyProfiler#run
# --------------------------------------------------------------------------------
#                       0.109      0.007      0.000      0.103        1000/5000      Catamaran::Logger#fatal
#                       0.111      0.006      0.000      0.105        1000/5000      Catamaran::Logger#warn
#                       0.112      0.007      0.000      0.105        1000/5000      Catamaran::Logger#severe
#                       0.112      0.007      0.000      0.105        1000/5000      Catamaran::Logger#error
#                       0.115      0.007      0.000      0.108        1000/5000      Catamaran::Logger#notice
#   88.36%   5.32%      0.559      0.034      0.000      0.525             5000      Catamaran::Logger#log
#                       0.362      0.022      0.000      0.340        5000/5000      Catamaran::Logger#_format_msg
#                       0.164      0.060      0.000      0.104        5000/5000      <Class::Catamaran::Outputter>#write
# --------------------------------------------------------------------------------
#                       0.362      0.022      0.000      0.340        5000/5000      Catamaran::Logger#log
#   57.15%   3.48%      0.362      0.022      0.000      0.340             5000      Catamaran::Logger#_format_msg
#                       0.289      0.102      0.000      0.187        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
#                       0.051      0.033      0.000      0.018        5000/5000      Catamaran::Logger#path_to_s
# --------------------------------------------------------------------------------
#                       0.289      0.102      0.000      0.187        5000/5000      Catamaran::Logger#_format_msg
#   45.64%  16.16%      0.289      0.102      0.000      0.187             5000      <Class::Catamaran::Formatter>#construct_formatted_message
#                       0.091      0.069      0.000      0.022        5000/5000      Time#strftime
#                       0.038      0.017      0.000      0.020        5000/5000      <Class::Time>#now
#                       0.028      0.028      0.000      0.000        5000/5000      Kernel#sprintf
#                       0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::LogLevel>#severity_to_s
#                       0.009      0.009      0.000      0.000        5000/5000      Fixnum#to_s
#                       0.007      0.007      0.000      0.000        5000/5000      <Module::Process>#pid
# --------------------------------------------------------------------------------
#                       0.164      0.060      0.000      0.104        5000/5000      Catamaran::Logger#log
#   25.88%   9.46%      0.164      0.060      0.000      0.104             5000      <Class::Catamaran::Outputter>#write
#                       0.093      0.021      0.000      0.072        5000/5000      IO#puts
#                       0.011      0.011      0.000      0.000       9998/10015      Kernel#nil?
#                       0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#stdout?
#                       0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#stderr?
#                       0.000      0.000      0.000      0.000              2/6      NilClass#nil?
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#notice
#                       0.123      0.005      0.000      0.118        1000/2000      WithTheRubyProfiler#run
#   19.45%   0.87%      0.123      0.005      0.000      0.118             2000     *Catamaran::Logger#notice
#                       0.115      0.007      0.000      0.108        1000/5000      Catamaran::Logger#log
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_notice?
#                       0.000      0.000      0.000      0.000              1/8      Symbol#to_s
#                       0.000      0.000      0.000      0.000              1/8      String#to_sym
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#notice
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#error
#                       0.120      0.006      0.000      0.115        1000/2000      WithTheRubyProfiler#run
#   19.00%   0.90%      0.120      0.006      0.000      0.115             2000     *Catamaran::Logger#error
#                       0.112      0.007      0.000      0.105        1000/5000      Catamaran::Logger#log
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_error?
#                       0.000      0.000      0.000      0.000              1/8      Symbol#to_s
#                       0.000      0.000      0.000      0.000              1/8      String#to_sym
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#error
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#severe
#                       0.120      0.006      0.000      0.114        1000/2000      WithTheRubyProfiler#run
#   18.95%   0.89%      0.120      0.006      0.000      0.114             2000     *Catamaran::Logger#severe
#                       0.112      0.007      0.000      0.105        1000/5000      Catamaran::Logger#log
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_severe?
#                       0.000      0.000      0.000      0.000              1/8      Symbol#to_s
#                       0.000      0.000      0.000      0.000              1/8      String#to_sym
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#severe
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#warn
#                       0.119      0.005      0.000      0.114        1000/2000      WithTheRubyProfiler#run
#   18.85%   0.85%      0.119      0.005      0.000      0.114             2000     *Catamaran::Logger#warn
#                       0.111      0.006      0.000      0.105        1000/5000      Catamaran::Logger#log
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_warn?
#                       0.000      0.000      0.000      0.000              1/8      String#to_sym
#                       0.000      0.000      0.000      0.000              1/8      Symbol#to_s
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#warn
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#fatal
#                       0.118      0.006      0.000      0.112        1000/2000      WithTheRubyProfiler#run
#   18.59%   0.90%      0.118      0.006      0.000      0.112             2000     *Catamaran::Logger#fatal
#                       0.109      0.007      0.000      0.103        1000/5000      Catamaran::Logger#log
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#default_fatal?
#                       0.000      0.000      0.000      0.000              1/8      Symbol#to_s
#                       0.000      0.000      0.000      0.000              1/8      String#to_sym
#                       0.000      0.000      0.000      0.000        1000/2000      Catamaran::Logger#fatal
# --------------------------------------------------------------------------------
#                       0.093      0.021      0.000      0.072        5000/5000      <Class::Catamaran::Outputter>#write
#   14.67%   3.28%      0.093      0.021      0.000      0.072             5000      IO#puts
#                       0.072      0.072      0.000      0.000      10000/10000      IO#write
# --------------------------------------------------------------------------------
#                       0.091      0.069      0.000      0.022        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
#   14.44%  10.95%      0.091      0.069      0.000      0.022             5000      Time#strftime
#                       0.015      0.015      0.000      0.000      10000/10000      Fixnum#divmod
#                       0.007      0.007      0.000      0.000        5000/5000      Fixnum#%
# --------------------------------------------------------------------------------
#                       0.072      0.072      0.000      0.000      10000/10000      IO#puts
#   11.39%  11.39%      0.072      0.072      0.000      0.000            10000      IO#write
# --------------------------------------------------------------------------------
#                       0.051      0.033      0.000      0.018        5000/5000      Catamaran::Logger#_format_msg
#    8.03%   5.25%      0.051      0.033      0.000      0.018             5000      Catamaran::Logger#path_to_s
#                       0.018      0.018      0.000      0.000        5000/5000      Array#join
#                       0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Manager>#delimiter
# --------------------------------------------------------------------------------
#                       0.038      0.017      0.000      0.020        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
#    5.94%   2.73%      0.038      0.017      0.000      0.020             5000      <Class::Time>#now
#                       0.020      0.014      0.000      0.006        5000/5000      Time#initialize
# --------------------------------------------------------------------------------
#                       0.028      0.028      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
#    4.36%   4.36%      0.028      0.028      0.000      0.000             5000      Kernel#sprintf
# --------------------------------------------------------------------------------
#                       0.020      0.014      0.000      0.006        5000/5000      <Class::Time>#now
#    3.21%   2.24%      0.020      0.014      0.000      0.006             5000      Time#initialize
#                       0.006      0.006      0.000      0.000        5000/5000      Fixnum#+
# --------------------------------------------------------------------------------
#                       0.018      0.018      0.000      0.000        5000/5000      Catamaran::Logger#path_to_s
#    2.78%   2.78%      0.018      0.018      0.000      0.000             5000      Array#join
# --------------------------------------------------------------------------------
#                       0.015      0.015      0.000      0.000      10000/10000      Time#strftime
#    2.43%   2.43%      0.015      0.015      0.000      0.000            10000      Fixnum#divmod
# --------------------------------------------------------------------------------
#                       0.014      0.014      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
#    2.28%   2.28%      0.014      0.014      0.000      0.000             5000      <Class::Catamaran::LogLevel>#severity_to_s
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000         17/10015      Catamaran::Logger#log_level
#                       0.011      0.011      0.000      0.000       9998/10015      <Class::Catamaran::Outputter>#write
#    1.76%   1.76%      0.011      0.011      0.000      0.000            10015      Kernel#nil?
# --------------------------------------------------------------------------------
#                       0.009      0.009      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
#    1.39%   1.39%      0.009      0.009      0.000      0.000             5000      Fixnum#to_s
# --------------------------------------------------------------------------------
#                       0.007      0.007      0.000      0.000        5000/5000      <Class::Catamaran::Formatter>#construct_formatted_message
#    1.07%   1.07%      0.007      0.007      0.000      0.000             5000      <Module::Process>#pid
# --------------------------------------------------------------------------------
#                       0.007      0.007      0.000      0.000        5000/5000      Time#strftime
#    1.06%   1.06%      0.007      0.007      0.000      0.000             5000      Fixnum#%
# --------------------------------------------------------------------------------
#                       0.006      0.006      0.000      0.000        5000/5000      Time#initialize
#    0.96%   0.96%      0.006      0.006      0.000      0.000             5000      Fixnum#+
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000             3/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_notice?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_info?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_debug?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_warn?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_fatal?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_error?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_severe?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#default_trace?
#    0.03%   0.02%      0.000      0.000      0.000      0.000               11     *Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000         17/10015      Kernel#nil?
#                       0.000      0.000      0.000      0.000              4/6      NilClass#nil?
#                       0.000      0.000      0.000      0.000              1/1      <Object::Object>#[]
#                       0.000      0.000      0.000      0.000             3/11      Catamaran::Logger#log_level
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      WithTheRubyProfiler#run
#    0.01%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_trace?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_debug?
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_error?
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_fatal?
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_severe?
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_warn?
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_notice?
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_info?
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#default_trace?
#    0.01%   0.01%      0.000      0.000      0.000      0.000                8      Module#define_method
#                       0.000      0.000      0.000      0.000              8/8      BasicObject#singleton_method_added
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#error
#    0.01%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_error?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#fatal
#    0.01%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_fatal?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#severe
#    0.01%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_severe?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#warn
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_warn?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      WithTheRubyProfiler#run
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_info?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#notice
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_notice?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      WithTheRubyProfiler#run
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      Catamaran::Logger#default_debug?
#                       0.000      0.000      0.000      0.000             1/11      Catamaran::Logger#log_level
#                       0.000      0.000      0.000      0.000              1/8      Module#define_method
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#fatal
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#notice
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#severe
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#error
#                       0.000      0.000      0.000      0.000              3/8      WithTheRubyProfiler#run
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#warn
#    0.00%   0.00%      0.000      0.000      0.000      0.000                8      String#to_sym
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              8/8      Module#define_method
#    0.00%   0.00%      0.000      0.000      0.000      0.000                8      BasicObject#singleton_method_added
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#fatal
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#notice
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#severe
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#error
#                       0.000      0.000      0.000      0.000              1/8      Catamaran::Logger#warn
#                       0.000      0.000      0.000      0.000              3/8      WithTheRubyProfiler#run
#    0.00%   0.00%      0.000      0.000      0.000      0.000                8      Symbol#to_s
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              2/6      <Class::Catamaran::Outputter>#write
#                       0.000      0.000      0.000      0.000              4/6      Catamaran::Logger#log_level
#    0.00%   0.00%      0.000      0.000      0.000      0.000                6      NilClass#nil?
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Outputter>#write
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#stdout?
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Global#[No method]
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      Class#new
#                       0.000      0.000      0.000      0.000              1/1      BasicObject#initialize
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#path_to_s
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#delimiter
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      <Class::Catamaran::Outputter>#write
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Class::Catamaran::Manager>#stderr?
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Catamaran::Logger#log_level
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      <Object::Object>#[]
# --------------------------------------------------------------------------------
#                       0.000      0.000      0.000      0.000              1/1      Class#new
#    0.00%   0.00%      0.000      0.000      0.000      0.000                1      BasicObject#initialize

# * indicates recursively called methods
