# Clean up the app a bit
run 'rm -r test'
run 'rm -r doc'
run 'rm -r README.rdoc'
run 'rm -r vendor'

# Create some models
generate 'model', 'user name:string'
generate 'model', 'message user_id:integer'

# Set up the database
rake 'db:migrate'
rake 'test:prepare'

# Add our gem dependency
gem 'beso'
