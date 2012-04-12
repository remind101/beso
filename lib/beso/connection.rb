require 'fog'

module Beso
  module Connection

    class AWS
      def initialize( options )
        @access_key  = options.delete( :access_key  ) or raise MissingAccessKeyError
        @secret_key  = options.delete( :secret_key  ) or raise MissingSecretKeyError
        @bucket_name = options.delete( :bucket_name ) or raise MissingBucketNameError
        @aws_region  = options.delete( :aws_region  )
      end

      def read( filename )
        bucket.files.get( filename ).try( :body ) || ''
      end

      def write( filename, body )
        if file = read( filename )
          file.body = body
          file.save
        else
          storage.put_object @bucket_name, filename, body, headers
        end
      end

      protected

      def headers
        { 'x-amz-acl' => 'public-read' }
      end

      def bucket
        @bucket ||= storage.directories.get @bucket_name
      end

      def storage
        @storage ||= begin
          storage = Fog::Storage.new :provider              => 'AWS',
                                     :aws_access_key_id     => @access_key,
                                     :aws_secret_access_key => @secret_key,
                                     :region                => @aws_region
          storage.sync_clock
          storage
        end
      end
    end

    extend ActiveSupport::Concern

    module ClassMethods

      def connect( &block )
        aws = AWS.new :access_key => Beso.access_key,
                      :secret_key => Beso.secret_key,
                      :aws_region => Beso.aws_region

        aws.connect!

        puts '==> connect'
        puts con.inspect
        puts con.methods.sort - Object.methods
      end
    end
  end
end
