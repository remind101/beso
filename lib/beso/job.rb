require 'comma'

module Beso
  class Job
    def initialize( name, options )
      @name  = name.to_sym
      @table = options.delete :table
      @props = { }
    end

    def prop( sym, *args, &block )
      # TODO this is weak, find a better way
      # to do what you mean to do
      args[ 0 ] = "Prop:#{args[ 0 ] || sym.to_s.titleize}"

      @props[ sym.to_sym ] = [ args, block ]
    end

    def to_csv
      model_class.class_exec( event_title ) do |event|
        define_method( :event_title ) { event }
      end

      model_class.instance_exec( @name, @props ) do |name, props|
        comma name do
          id          'Identity'
          created_at  'Timestamp' do |m|
            m.to_i
          end
          event_title 'Event'

          props.each do |sym, (args, block)|
            self.send sym, *args, &block
          end
        end
      end

      model_class.all.to_comma @name
    end

    protected

    def event_title
      @name.to_s.titleize
    end

    def model_class
      @table.to_s.classify.constantize
    end
  end
end
