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

  describe '#start_time' do
    before do
      Beso.start_time = nil
    end

    subject { Beso.start_time }

    context 'when not set' do
      it { should eq( 1.hour.ago.to_i ) }
    end

    context 'when ENV["BESO_START_TIME"] is set' do
      around do |example|
        with_const( :BESO_START_TIME, 2.hours.ago.to_i ) do
          example.run
        end
      end

      it { should eq( 2.hours.ago.to_i ) }
    end

    context 'when explicitly set in the config' do
      around do |example|
        with_const( :BESO_START_TIME, 2.hours.ago.to_i ) do
          example.run
        end
      end

      before do
        Beso.start_time = 3.hours.ago.to_i
      end

      it { should eq( 3.hours.ago.to_i ) }
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
end
