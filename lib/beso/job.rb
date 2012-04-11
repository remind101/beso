module Beso
  class Job
    def initialize( name, options )
      @name  = name
      @table = options.delete :table
    end

    def event_title
      @name.to_s.titleize
    end

    def model_class
      @table.to_s.classify.constantize
    end
  end
end
