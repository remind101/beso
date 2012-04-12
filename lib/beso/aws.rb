require 'fog'

module Beso
  class AWS
    def initialize( options )
      @access_key  = options.delete( :access_key  ) or raise MissingAccessKeyError
      @secret_key  = options.delete( :secret_key  ) or raise MissingSecretKeyError
      @bucket_name = options.delete( :bucket_name ) or raise MissingBucketNameError
      @aws_region  = options.delete( :aws_region  )
    end

    def connect!
      storage = Fog::Storage.new :provider              => 'AWS',
                                 :aws_access_key_id     => @access_key,
                                 :aws_secret_access_key => @secret_key,
                                 :region                => @aws_region
      storage.sync_clock
      storage
    end
  end
end
