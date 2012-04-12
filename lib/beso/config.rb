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

      def start_time
        if @start_time
          @start_time
        elsif defined? BESO_START_TIME
          BESO_START_TIME.to_i
        else
          @start_time = 1.hour.ago.to_i
        end
      end

      def start_time=( value )
        @start_time = value
      end

      def job( name, options, &block )
        job = Job.new( name, options )
        job.instance_eval &block if block_given?
        jobs << job
      end

      def jobs
        @jobs ||= [ ]
      end

      def reset!
        @jobs       = [ ]
        @start_time = nil
      end
    end
  end
end
