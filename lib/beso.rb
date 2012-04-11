require 'beso/version'

module Beso
  autoload :Railtie, 'beso/railtie'

  class << self
    def configure
      yield self
    end
  end
end

require 'beso/railtie' if defined?(Rails)
