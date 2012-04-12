require 'spec_helper'

describe Beso::Job do

  after do
    User.destroy_all
  end

  describe 'to_csv' do
    subject { Beso::Job.new :message_sent, :table => :users }

    let!( :foo ){ User.create! :name => 'Foo' }
    let!( :bar ){ User.create! :name => 'Bar' }

    context 'without an identity defined' do
      before do
        subject.timestamp :created_at
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

    context 'with a timestamp that is not a symbol' do
      it 'should raise an error' do
        expect { subject.timestamp 123 }.to raise_error( Beso::InvalidTimestampError )
      end
    end

    context 'with only the mandatory columns defined' do
      before do
        subject.identity { |user| user.id }
        subject.timestamp :created_at
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
        subject.timestamp :created_at
        subject.prop( :user_name ){ |user| user.name }
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:User Name
#{foo.id},#{foo.created_at.to_i},Message Sent,Foo
#{bar.id},#{bar.created_at.to_i},Message Sent,Bar
      EOS
      ) }
    end

    context 'with literal properties defined' do
      before do
        subject.identity 22
        subject.timestamp :created_at
        subject.prop :foo, 'bar'
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:Foo
22,#{foo.created_at.to_i},Message Sent,bar
22,#{bar.created_at.to_i},Message Sent,bar
      EOS
      ) }
    end

    context 'with symbol properties defined' do
      before do
        subject.identity :id
        subject.timestamp :created_at
        subject.prop :name
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:Name
#{foo.id},#{foo.created_at.to_i},Message Sent,#{foo.name}
#{bar.id},#{bar.created_at.to_i},Message Sent,#{bar.name}
      EOS
      ) }
    end

    context 'with 10 custom properties defined' do
      before do
        subject.identity 22
        subject.timestamp :created_at
        (1..10).each do |i|
          subject.prop :"foo #{i}", i
        end
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:Foo 1,Prop:Foo 2,Prop:Foo 3,Prop:Foo 4,Prop:Foo 5,Prop:Foo 6,Prop:Foo 7,Prop:Foo 8,Prop:Foo 9,Prop:Foo 10
22,#{foo.created_at.to_i},Message Sent,1,2,3,4,5,6,7,8,9,10
22,#{bar.created_at.to_i},Message Sent,1,2,3,4,5,6,7,8,9,10
      EOS
      ) }
    end

    context 'with more than 10 custom properties defined' do
      before do
        subject.identity 22
        subject.timestamp :created_at
      end
      it 'should raise an error' do
        expect {
          (1..11).each do |i|
            subject.prop :"foo #{i}", i
          end
        }.to raise_error Beso::TooManyPropertiesError
      end
    end

    context 'with custom options given to #to_csv' do
      before do
        subject.identity { |user| user.id }
        subject.timestamp :created_at
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

    context 'with custom options given to constructor' do
      subject { Beso::Job.new :message_sent, :table => :users, :col_sep => ';' }

      before do
        subject.identity { |user| user.id }
        subject.timestamp :created_at
      end

      its( :to_csv ){ should eq( <<-EOS
Identity;Timestamp;Event
#{foo.id};#{foo.created_at.to_i};Message Sent
#{bar.id};#{bar.created_at.to_i};Message Sent
      EOS
      ) }
    end
  end

  describe 'with since specified' do
    let!( :foo ){ User.create :name => 'Foo', :created_at => 100, :updated_at => 300 }
    let!( :bar ){ User.create :name => 'Bar', :created_at => 200, :updated_at => 200 }
    let!( :baz ){ User.create :name => 'Baz', :created_at => 300, :updated_at => 300 }

    context 'and the timestamp keyed on `created_at`' do
      subject { Beso::Job.new :message_sent, :table => :users, :since => 101 }

      before do
        subject.identity { |user| user.id }
        subject.timestamp :created_at
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event
#{bar.id},#{bar.created_at.to_i},Message Sent
#{baz.id},#{baz.created_at.to_i},Message Sent
      EOS
      ) }
    end

    context 'and the timestamp keyed on `updated_at`' do
      subject { Beso::Job.new :message_sent, :table => :users, :since => 201 }

      before do
        subject.identity { |user| user.id }
        subject.timestamp :updated_at
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event
#{foo.id},#{foo.updated_at.to_i},Message Sent
#{baz.id},#{baz.updated_at.to_i},Message Sent
      EOS
      ) }
    end
  end
end
