require 'beso/version'

module Beso
  autoload :Config,     'beso/config'
  autoload :Connection, 'beso/connection'
  autoload :CSV,        'beso/csv'
  autoload :Job,        'beso/job'
  autoload :Railtie,    'beso/railtie'

  include Config
  include Connection

  class BesoError < StandardError; end
  class MissingIdentityError < BesoError; end
  class MissingTimestampError < BesoError; end
  class MissingAccessKeyError < BesoError; end
  class InvalidTimestampError < BesoError; end
  class MissingSecretKeyError < BesoError; end
  class MissingBucketNameError < BesoError; end
  class TooManyPropertiesError < BesoError; end
end

require 'beso/railtie' if defined?(Rails)
