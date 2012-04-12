module Beso
  module Connection
    extend ActiveSupport::Concern

    module ClassMethods

      def connect
        aws = Beso::AWS.new :access_key => Beso.access_key,
                            :secret_key => Beso.secret_key,
                            :aws_region => Beso.aws_region
        con = aws.connect!

        puts '==> connect'
        puts con.inspect
        puts con.methods.sort - Object.methods
      end
    end
  end
end
