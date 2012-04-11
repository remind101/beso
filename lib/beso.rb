require 'beso/version'

module Beso
  autoload :Railtie, 'beso/railtie'
end

require 'beso/railtie' if defined?(Rails)
