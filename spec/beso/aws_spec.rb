require 'spec_helper'

describe Beso::Connection::AWS do

  context 'without an access key' do
    it 'should raise an error' do
      expect { Beso::AWS.new :secret_key => 'foo' }.to raise_error Beso::MissingAccessKeyError
    end
  end

  context 'without a secret key' do
    it 'should raise an error' do
      expect { Beso::AWS.new :access_key => 'foo' }.to raise_error Beso::MissingSecretKeyError
    end
  end
end
