require 'spec_helper'

describe Beso do
  subject { Beso }

  describe '#configure' do
    it { should respond_to( :configure ) }

    it 'should yield itself to #configure' do
      subject.configure do |config|
        config.should eql( subject )
      end
    end
  end

  describe '#job' do
    subject { Beso }

    before do
      yielded = nil
      subject.job :foo, :table => :users do
        yielded = self
      end
      yielded.should be_a( Beso::Job )
    end

    it { should have( 1 ).jobs }
  end

  describe '#reset' do
    subject { Beso }
    it { should respond_to( :reset! ) }

    it 'should reset the #jobs array' do
      Beso.jobs << 123
      Beso.reset!
      Beso.jobs.should be_empty
    end

    it 'should reset the #access_key' do
      Beso.access_key = 'foo'
      Beso.reset!
      Beso.access_key.should be_nil
    end

    it 'should reset the #secret_key' do
      Beso.secret_key = 'foo'
      Beso.reset!
      Beso.secret_key.should be_nil
    end

    it 'should reset the #bucket_name' do
      Beso.bucket_name = 'beso'
      Beso.reset!
      Beso.bucket_name.should be_nil
    end

    it 'should reset the #aws_region' do
      Beso.aws_region = 'us-east-1'
      Beso.reset!
      Beso.aws_region.should be_nil
    end
  end

  describe '#access_key' do
    subject { Beso }
    it { should respond_to( :access_key ) }
    its( :access_key ){ should be_nil }
  end

  describe '#secret_key' do
    subject { Beso }
    it { should respond_to( :secret_key ) }
    its( :secret_key ){ should be_nil }
  end

  describe '#bucket_name' do
    subject { Beso }
    it { should respond_to( :bucket_name ) }
    its( :bucket_name ){ should be_nil}
  end

  describe '#aws_region' do
    subject { Beso }
    it { should respond_to( :aws_region ) }
    its( :aws_region ){ should be_nil }
  end
end
