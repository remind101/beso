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

    its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event
#{foo.id},#{foo.created_at.to_i},Message Sent
#{bar.id},#{bar.created_at.to_i},Message Sent
    EOS
    ) }
  end

end
