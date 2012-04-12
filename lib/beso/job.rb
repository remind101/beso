module Beso
  class Job
    def initialize( event, options )
      @event = event.to_sym
      @table = options.delete :table
      @props = { }
      @extra = options
    end
    attr_reader :event

    def identity( value=nil, &block )
      @identity = value || block
    end

    def timestamp( value=nil, &block )
      @timestamp = value || block
    end

    def prop( name, value=nil, &block )
      raise TooManyPropertiesError if @props.length == 10
      @props[ name.to_sym ] = value || block
    end

    def to_csv( options={} )
      raise MissingIdentityError  if @identity.nil?
      raise MissingTimestampError if @timestamp.nil?

      Beso::CSV.generate( @extra.merge( options ) ) do |csv|
        csv << ( required_headers + custom_headers )

        model_class.all.each do |model|
          csv << ( required_columns( model ) + custom_columns( model ) )
        end
      end
    end

    protected

    def required_headers
      %w| Identity Timestamp Event |
    end

    def custom_headers
      @props.keys.map { |name| "Prop:#{name.to_s.titleize}" }
    end

    def required_columns( model )
      [ ].tap do |row|
        row << block_or_value( @identity,  model )
        row << block_or_value( @timestamp, model ).to_i
        row << event_title
      end
    end

    def custom_columns( model )
      @props.values.map { |value| block_or_value( value, model ) }
    end

    def event_title
      @event.to_s.titleize
    end

    def model_class
      @table.to_s.classify.constantize
    end

    def block_or_value( value, model )
      case value
      when Symbol
        model.send value
      when Proc
        value.call model
      else
        value
      end
    end
  end
end
