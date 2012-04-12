# Set the environment variables for the test app
ENV[ 'RAILS_ENV' ] = 'test'

# Add the test app to the load path
$: << ENV[ 'BESO_RAILS_PATH' ]

# Require all dependencies
Bundler.require

# Boot the rails app
require 'config/environment'

# Helpers
module ConstHelper

  def with_const( const, value )
    Object.const_set const, value
    yield
    Object.send :remove_const, const
  end
end

# Configure RSpec
RSpec.configure do |config|
  # Use color
  config.color_enabled = true
  # Change the formatter
  config.formatter = :documentation
  # Include helpers
  config.include ConstHelper
  # Reset Beso after each test
  config.after :each do
    Beso.reset!
  end
end
