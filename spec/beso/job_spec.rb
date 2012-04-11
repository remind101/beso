require 'spec_helper'

describe Beso::Job do

  describe 'attributes' do
    subject { Beso::Job.new :message_sent, :table => :users }

    its( :event_title ){ should eq( 'Message Sent' ) }
    its( :model_class ){ should eq( User ) }
  end

  describe 'to_csv' do
    subject { Beso::Job.new :message_sent, :table => :users }

    before do
      User.destroy_all
    end

    let!( :foo ){ User.create! :name => 'Foo' }
    let!( :bar ){ User.create! :name => 'Bar' }

    context 'with the default properties' do
      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event
#{foo.id},#{foo.created_at.to_i},Message Sent
#{bar.id},#{bar.created_at.to_i},Message Sent
      EOS
      ) }
    end

    context 'with a custom property' do
      before do
        subject.prop :name
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:Name
#{foo.id},#{foo.created_at.to_i},Message Sent,#{foo.name}
#{bar.id},#{bar.created_at.to_i},Message Sent,#{bar.name}
      EOS
      ) }
    end

    context 'with a custom property with a custom title' do
      before do
        subject.prop :name, 'Handle'
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:Handle
#{foo.id},#{foo.created_at.to_i},Message Sent,#{foo.name}
#{bar.id},#{bar.created_at.to_i},Message Sent,#{bar.name}
      EOS
      ) }
    end

    context 'with a custom property and a block' do
      before do
        subject.prop :name do |name|
          name.length
        end
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:Name
#{foo.id},#{foo.created_at.to_i},Message Sent,#{foo.name.length}
#{bar.id},#{bar.created_at.to_i},Message Sent,#{bar.name.length}
      EOS
      )}
    end

    context 'with a custom property with a custom title and a block' do
      before do
        subject.prop :name, 'Name Length' do |name|
          name.length
        end
      end

      its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event,Prop:Name Length
#{foo.id},#{foo.created_at.to_i},Message Sent,#{foo.name.length}
#{bar.id},#{bar.created_at.to_i},Message Sent,#{bar.name.length}
      EOS
      )}
    end
  end

end
