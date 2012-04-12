module Beso
  class AWS
    def initialize( options )
      @access_key = options.delete( :access_key ) or raise MissingAccessKeyError
      @secret_key = options.delete( :secret_key ) or raise MissingSecretKeyError
    end
  end
end
