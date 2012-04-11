require 'spec_helper'

describe Beso::Job do

  describe 'attributes' do
    subject { Beso::Job.new :message_sent, :table => :users }

    its( :event_title ){ should eq( 'Message Sent' ) }
    its( :model_class ){ should eq( User ) }
  end

end
