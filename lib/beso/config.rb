module Beso
  module Config
    extend ActiveSupport::Concern

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

      def job( name, options )
        jobs << Job.new( name, options )
      end

      def jobs
        @jobs ||= [ ]
      end
    end
  end
end
