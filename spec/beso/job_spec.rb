require 'spec_helper'

describe Beso::Job do

  describe 'attributes' do
    subject { Beso::Job.new :message_sent, :table => :users }

    its( :event_title ){ should eq( 'Message Sent' ) }
    its( :model_class ){ should eq( User ) }
  end

  describe 'to_csv' do
    subject { Beso::Job.new :message_sent, :table => :users }

    let!( :user ){ User.create :name => 'Foo Bar' }

    its( :to_csv ){ should eq( <<-EOS
Identity,Timestamp,Event
1,#{user.created_at.to_i},Message Sent
    EOS
    ) }
  end

end
