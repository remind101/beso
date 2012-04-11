module Beso
  class Job
    def initialize( name, options )
      @name  = name
      @table = options.delete :table
    end

    def model_class
      @table.to_s.classify.constantize
    end
  end
end
