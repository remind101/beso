# Beso

Sync your historical events to KISSmetrics via CSV.

## Installation

Add this line to your application's Gemfile:

    gem 'beso'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install beso

Next, create an initializer for **beso**. There, you can set up your S3 bucket information and define your
serialization jobs:

``` rb
# config/initializers/beso.rb
Beso.configure do |config|

  # First, set up your S3 credentials:

  config.access_key  = '[your AWS access key]'
  config.secret_key  = '[your AWS secret key]'
  config.bucket_name = 'beso' # recommended, but you can really call this anything

  # Then, define some jobs:

  config.job :message_delivered, :table => :messages do
    identity { |message| message.user.id }
    timestamp :created_at
    prop( :message_id ) { |message| message.id }
  end

  config.job :signed_up, :table => :users do
    identity { |user| user.id }
    timestamp :created_at
    prop( :age ){ |user| user.age }
  end
end
```

## Usage

### Defining Jobs

KISSmetrics events have three properties that *must* be defined:

- Identity
- Timestamp
- Event

The **Identity** field is some sort of identifier for your user. Even if your job
is working on another table, you should probably have a way to tie the event back
to the user who caused it. Here, you can provide one of three things:

- A proc that should receive the record and return the identity value
- A symbol that will get passed to `record.send`
- A literal (You'll probably want to do one of the other two options)

The **Timestamp** field is slightly different in that it should always be part of
the table you are querying, not the user. This symbol will get sent to each record,
but will also be used in determining the query for the job.

The **Event** name is inferred by the name of your job. It will be provided and
formatted for you.

On top of this, you can specify up to **ten** custom properties. Like `identity`,
you can pass either a proc, a symbol, or a literal:

``` rb
config.job :signed_up, :table => :users do
  identity :id
  timestamp :created_at
  prop( :age ){ |user| user.age }
  prop( :new_user, true )
end
```

### Using the rake task

By requiring `beso`, you get the `beso:run` rake task. This task will do the following:

- Connect to your S3 bucket
- Pull down 'beso.yml' if it exists

> `beso.yml` contains the timestamp of the last record queried for each job.
> If it doesn't exist, it will be created after the first run.

- Iterate over the jobs defined in the initializer you set up
- Create a CSV representation of all records newer than the timestamp found in `beso.yml`
- Upload each CSV to your S3 bucket with the event name and timestamp
- Update `beso.yml` with the latest timestamp for each job

The rake task is designed to be used via cron. For the moment, KISSmetrics will only process
one CSV file per hour, so it makes sense that this task should be run at an interval of hours
equal to the number of jobs you have defined. For example, if you have defined 4 jobs, this
task should run once every 4 hours.

The rake task also accepts two options that you can set via environment variables.

`BESO_PREFIX` will change the prefix of the CSV filenames that get uploaded to S3. The default
is 'beso', so it is recommended you use that when telling KISSmetrics what your filename
pattern is. You can then adjust the prefix if you would like to upload CSV's that you don't
want KISSmetrics to recognize.

`BESO_ORIGIN` will change the behavior of the task when there is no previous timestamp
defined for a job in `beso.yml`.

> By default, the task will use the last timestamp in your table (which effectively
> means the first run of this task will do nothing). This is because KISSmetrics
> charges you for every event you log through their system, so you probably don't
> want to upload 8 months worth of events straight away.

This option will accept two values to alter the behavior:

- `now` will set the first run timestamp to now, which will obviously not create any events.
- `first` will set the first run timestamp to the first timestamp in each table. Use this with
  `BESO_PREFIX` if you want to dump an entire table's worth of events to S3 without having
  KISSmetrics process them.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
