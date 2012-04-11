require 'spec_helper'

describe Beso::Job do

  describe 'attributes' do
    subject { Beso::Job.new :message_sent, :table => :users }

    its( :model_class ){ should eq( User ) }
  end

end
