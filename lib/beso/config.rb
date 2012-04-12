module Beso
  module Config
    extend ActiveSupport::Concern

    included do
      reset!
    end

    module ClassMethods
      def configure
        yield self
      end

      mattr_accessor :access_key
      mattr_accessor :secret_key
      mattr_accessor :bucket_name
      mattr_accessor :aws_region

      def job( name, options, &block )
        job = Job.new( name, options )
        job.instance_eval &block if block_given?
        jobs << job
      end

      def jobs
        @@jobs ||= [ ]
      end

      def reset!
        @@jobs        = [ ]
        @@access_key  = nil
        @@secret_key  = nil
        @@bucket_name = nil
        @@aws_region  = nil
      end
    end
  end
end
