require 'beso/version'

module Beso
  autoload :Config,  'beso/config'
  autoload :Job,     'beso/job'
  autoload :Railtie, 'beso/railtie'

  include Config
end

require 'beso/railtie' if defined?(Rails)
