require 'spec_helper'

describe Beso::Job do

  describe 'to_csv' do
    subject { Beso::Job.new :message_sent, :table => :users }

    after do
      User.destroy_all
    end

    let!( :foo ){ User.create! :name => 'Foo' }
    let!( :bar ){ User.create! :name => 'Bar' }

    context 'without an identity defined' do
      before do
        subject.timestamp { |user| user.created_at }
      end
      it 'should raise an error' do
        expect { subject.to_csv }.to raise_error( Beso::MissingIdentityError )
      end
    end

    context 'without a timestamp defined' do
      before do
        subject.identity { |user| user.id }
      end
      it 'should raise an error' do
        expect { subject.to_csv }.to raise_error( Beso::MissingTimestampError )
      end
    end

    context 'with only the mandatory columns defined' do
      before do
        subject.identity { |user| user.id }
        subject.timestamp { |user| user.created_at }
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event
#{foo.id},#{foo.created_at.to_i},Message Sent
#{bar.id},#{bar.created_at.to_i},Message Sent
      EOS
      ) }
    end

    context 'with custom properties defined' do
      before do
        subject.identity { |user| user.id }
        subject.timestamp { |user| user.created_at }
        subject.prop( :user_name ){ |user| user.name }
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:User Name
#{foo.id},#{foo.created_at.to_i},Message Sent,Foo
#{bar.id},#{bar.created_at.to_i},Message Sent,Bar
      EOS
      ) }
    end

    context 'with custom options' do
      before do
        subject.identity { |user| user.id }
        subject.timestamp { |user| user.created_at }
      end

      it 'should support all options that CSV supports' do
        subject.to_csv( :force_quotes => true, :col_sep => ';' ).should eq( <<-EOS
"Identity";"Timestamp";"Event"
"#{foo.id}";"#{foo.created_at.to_i}";"Message Sent"
"#{bar.id}";"#{bar.created_at.to_i}";"Message Sent"
        EOS
        )
      end
    end
  end
end
