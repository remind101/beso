# Clean up the app a bit
run 'rm -r test'
run 'rm -r doc'
run 'rm -r README.rdoc'
run 'rm -r vendor'

# Create some models
generate 'model', 'user name:string deleted_at:datetime'

inject_into_class 'app/models/user.rb', 'User', <<-EOS
  has_many :messages
  default_scope where( 'deleted_at is null' )
EOS

generate 'model', 'message user_id:integer'

inject_into_class 'app/models/message.rb', 'Message', <<-EOS
  belongs_to :user
EOS

# Set up the database
rake 'db:migrate'
rake 'test:prepare'

# Add our gem dependency
gem 'beso'
