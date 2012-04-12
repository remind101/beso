module Beso
  class CSV
    class << self

      def method_missing( method, *args, &block )
        csv.send method, *args, &block
      end

      protected

      def csv
        @csv ||= if require 'csv'
          ::CSV
        else
          require 'fastercsv'
          FasterCSV
        end
      end

    end
  end
end
