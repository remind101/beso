module Beso
  class Job
    def initialize( event, options )
      @event = event.to_sym
      @table = options.delete :table
      @props = { }
    end

    def identity( &block )
      @identity = block
    end

    def timestamp( &block )
      @timestamp = block
    end

    def prop( name, &block )
      @props[ name.to_sym ] = block
    end

    def to_csv
      raise MissingIdentityError  if @identity.nil?
      raise MissingTimestampError if @timestamp.nil?

      Beso::CSV.generate do |csv|
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
        row << @identity.call( model )
        row << @timestamp.call( model ).to_i
        row << event_title
      end
    end

    def custom_columns( model )
      @props.values.map { |block| block.call( model ) }
    end

    def event_title
      @event.to_s.titleize
    end

    def model_class
      @table.to_s.classify.constantize
    end
  end
end
