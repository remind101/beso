namespace :beso do

  desc "Run Beso jobs and upload to S3"
  task :run => :environment do

    raise 'Beso has no jobs to run. Please define some in the beso initializer.' if Beso.jobs.empty?

    puts '==> Connecting...'

    Beso.connect do |bucket|

      puts '==> Connected!'

      config = YAML.load( bucket.read 'beso.yml' ) || { }

      puts '==> Config:'
      puts config.inspect

      Beso.jobs.each do |job|

        puts "==> Processing job: #{job.event.inspect} since #{config[ job.event ]}"

        csv = job.to_csv :since => config[ job.event ]

        bucket.write "#{job.event}-#{config[ job.event ].to_i}.csv", csv

        puts " ==> #{job.event}-#{config[ job.event ].to_i}.csv saved to S3"

        config[ job.event ] = job.last_timestamp

        puts " ==> New timestamp is #{config[ job.event ]}"
      end

      bucket.write 'beso.yml', config.to_yaml

      puts '==> Config saved. Donezo.'
    end
  end
end
