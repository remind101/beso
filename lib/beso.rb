require 'beso/version'

module Beso
  autoload :AWS,     'beso/aws'
  autoload :Config,  'beso/config'
  autoload :CSV,     'beso/csv'
  autoload :Job,     'beso/job'
  autoload :Railtie, 'beso/railtie'

  include Config

  class BesoError < StandardError; end
  class MissingIdentityError < BesoError; end
  class MissingTimestampError < BesoError; end
  class MissingAccessKeyError < BesoError; end
  class MissingSecretKeyError < BesoError; end
end

require 'beso/railtie' if defined?(Rails)
