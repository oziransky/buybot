# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Buybot::Application.initialize!

# Use log4r as default logger
Rails.logger = Log4r::Logger.new("Application Log")
