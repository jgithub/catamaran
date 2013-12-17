# Enable logging to STDERR
Catamaran::Manager.stderr = true

# The default log level is INFO.  Switch to DEBUG in development
Catamaran::LogLevel.default_log_level = Catamaran::LogLevel::DEBUG

# By default, logger.io messages will be captured when the log level is DEBUG (IO_LESS_CRITICAL_THAN_INFO)
# If that's too verbose, uncomment this
# Catamaran::LogLevel.log_level_io = Catamaran::LogLevel::IO_LESS_CRITICAL_THAN_DEBUG

# The NoCallerFormatter is the default.  
Catamaran::Manager.formatter_class = Catamaran::Formatter::CallerFormatter
