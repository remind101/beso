require 'comma'

module Beso
  class Job
    def initialize( name, options )
      @name  = name
      @table = options.delete :table
      @props = { }
    end

    def prop( name, title=nil )
      @props[ name.to_sym ] = "Prop:#{title || name.to_s.titleize}"
    end

    def event_title
      @name.to_s.titleize
    end

    def model_class
      @table.to_s.classify.constantize
    end

    def to_csv
      model_class.class_eval <<-EOS
        def event_title
          "#{event_title}"
        end
      EOS

      model_class.instance_exec( @props ) do |props|
        comma do
          id          'Identity'
          created_at  'Timestamp' do |m|
            m.to_i
          end
          event_title 'Event'

          props.each do |name, title|
            self.send name, title
          end
        end
      end

      model_class.all.to_comma
    end
  end
end
