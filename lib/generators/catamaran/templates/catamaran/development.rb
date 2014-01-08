## 
# Custom settings for Catamaran in development

# The default log level is INFO.  Switch to DEBUG in development
Catamaran.logger.log_level = Catamaran::LogLevel::DEBUG

# By default, logger.io messages will be captured when the log level is DEBUG (IO_LESS_CRITICAL_THAN_INFO)
# If that's too verbose, uncomment this
# Catamaran::LogLevel.log_level_io = Catamaran::LogLevel::IO_LESS_CRITICAL_THAN_DEBUG

# There is a performance hit for using the caller, but it generates more detailed logs
Catamaran::Manager.formatter_caller_enabled = true

# Uncomment if you'd prefer Ruby-style delimiters
Catamaran::Manager.delimiter = '::'

# Uncomment to enable Catamaran internal debugging
# Catamaran::debugging = true

##
# Detailed log levels

# Uncomment to set the default log level for all models to be TRACE
# Catamaran.logger.com.mycompany.myrailsapp.app.models = Catamaran::LogLevel::TRACE

# Uncomment to set the default log level for all controllers to be WARN
# Catamaran.logger.com.mycompany.myrailsapp.app.controllers = Catamaran::LogLevel::WARN