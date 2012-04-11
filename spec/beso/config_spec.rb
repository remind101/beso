require 'spec_helper'

describe Beso do

  subject { Beso }

  it { should respond_to( :configure ) }

  it 'should yield itself to #configure' do
    subject.configure do |config|
      config.should eql( subject )
    end
  end
end
