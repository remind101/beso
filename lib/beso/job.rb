require 'comma'

module Beso
  class Job
    def initialize( name, options )
      @name  = name
      @table = options.delete :table
      @props = { }
    end

    def prop( name, title=nil )
      @props[ name.to_s ] = ( title || name.to_s.titleize )
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

      model_class.instance_eval <<-EOS
        comma do
          id          'Identity'
          created_at  'Timestamp' do |t|
            t.to_i
          end
          event_title 'Event'
          #{custom_props}
        end
      EOS

      model_class.all.to_comma
    end

    protected

    def custom_props
      @props.reduce( '' ) do |memo, (name, title)|
        memo << "#{name} 'Prop:#{title}'\n"
      end
    end
  end
end
