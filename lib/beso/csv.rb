module Beso
  class CSV
    class << self

      def method_missing( method, *args, &block )
        csv.send method, *args, &block
      end

      protected

      def csv
        @csv ||= Object.const_get( :CSV ) || begin
          if require 'csv'
            ::CSV
          else
            begin
              require 'fastercsv'
              FasterCSV
            rescue
              raise "Ruby version #{RUBY_VERSION} users need to require 'fastercsv'"
            end
          end
        end
      end

    end
  end
end
