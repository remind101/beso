require 'beso'

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
end
