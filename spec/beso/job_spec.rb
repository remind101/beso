require 'spec_helper'

describe Beso::Job do
  fixtures :all

  let!( :foo ){ users( :foo ) }
  let!( :bar ){ users( :bar ) }
  let!( :baz ){ users( :baz ) }

  describe 'to_csv' do
    subject { Beso::Job.new :message_sent, :table => :users }

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

      it 'should generate the correct to_csv' do
        verify do
          subject.to_csv
        end
      end
    end

    context 'with custom properties defined' do
      before do
        subject.identity { |user| user.id }
        subject.timestamp :created_at
        subject.prop( :user_name ){ |user| user.name }
      end

      it 'should generate the correct to_csv' do
        verify do
          subject.to_csv
        end
      end
    end

    context 'with literal properties defined' do
      before do
        subject.identity 22
        subject.timestamp :created_at
        subject.prop :foo, 'bar'
      end

      it 'should generate the correct to_csv' do
        verify do
          subject.to_csv
        end
      end
    end

    context 'with symbol properties defined' do
      before do
        subject.identity :id
        subject.timestamp :created_at
        subject.prop :name
      end

      it 'should generate the correct to_csv' do
        verify do
          subject.to_csv
        end
      end
    end

    context 'with 10 custom properties defined' do
      before do
        subject.identity 22
        subject.timestamp :created_at
        (1..10).each do |i|
          subject.prop :"foo #{i}", i
        end
      end

      it 'should generate the correct to_csv' do
        verify do
          subject.to_csv
        end
      end
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

      it 'should generate the correct to_csv' do
        verify do
          subject.to_csv :force_quotes => true, :col_sep => ';'
        end
      end
    end

    context 'with custom options given to constructor' do
      subject { Beso::Job.new :message_sent, :table => :users, :col_sep => ';' }

      before do
        subject.identity { |user| user.id }
        subject.timestamp :created_at
      end

      it 'should generate the correct to_csv' do
        verify do
          subject.to_csv
        end
      end
    end

    context 'when no records match the query' do
      subject { Beso::Job.new :message_sent, :table => :users }

      before do
        User.destroy_all
        subject.identity { |user| user.id }
        subject.timestamp :created_at
      end

      its( :to_csv ){ should be_nil }
    end
  end

  describe 'with since specified' do

    context 'in the constructor' do
      context 'and the timestamp keyed on `created_at`' do
        subject { Beso::Job.new :message_sent, :table => :users, :since => 101 }

        before do
          subject.identity { |user| user.id }
          subject.timestamp :created_at
        end

        it 'should generate the correct to_csv' do
          verify do
            subject.to_csv
          end
        end
      end
    end

    context 'in to_csv' do
      context 'and the timestamp keyed on `created_at`' do
        subject { Beso::Job.new :message_sent, :table => :users }

        before do
          subject.identity { |user| user.id }
          subject.timestamp :created_at
        end

        it 'should generate the correct to_csv' do
          verify do
            subject.to_csv :since => 101
          end
        end
      end
    end

    context 'in the constructor' do
      context 'and the timestamp keyed on `updated_at`' do
        subject { Beso::Job.new :message_sent, :table => :users, :since => 201 }

        before do
          subject.identity { |user| user.id }
          subject.timestamp :updated_at
        end

        it 'should generate the correct to_csv' do
          verify do
            subject.to_csv
          end
        end
      end
    end

    context 'in to_csv' do
      context 'and the timestamp keyed on `updated_at`' do
        subject { Beso::Job.new :message_sent, :table => :users }

        before do
          subject.identity { |user| user.id }
          subject.timestamp :updated_at
        end

        it 'should generate the correct to_csv' do
          verify do
            subject.to_csv :since => 201
          end
        end
      end
    end
  end

  describe 'custom event names' do
    subject { Beso::Job.new :message_sent, :table => :users, :event => 'Messages Sent Action' }

    before do
      subject.identity :id
      subject.timestamp :created_at
    end

    it 'should generate the correct to_csv' do
      verify do
        subject.to_csv
      end
    end
  end

  describe '#last_timestamp' do
    subject { Beso::Job.new :message_sent, :table => :users }

    before do
      subject.identity :id
    end

    context 'with the timestamp keyed on `created_at`' do
      before do
        subject.timestamp :created_at
      end

      its( :last_timestamp ){ should eq( 300 ) }
    end

    context 'with the timestamp keyed on `updated_at`' do
      before do
        subject.timestamp :updated_at
      end

      its( :last_timestamp ){ should eq( 301 ) }
    end
  end
end
