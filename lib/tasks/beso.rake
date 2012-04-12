namespace :beso do

  desc "Run Beso jobs and upload to S3"
  task :run => :environment do

    raise 'Beso has no jobs to run. Please define some in the beso initializer.' if Beso.jobs.empty?

    Beso.connect do |bucket|

      config = YAML.load( bucket.read 'beso.yml' ) || { }

      Beso.jobs.each do |job|

        csv = job.to_csv :since => config[ job.event ]

        config[ job.event ] = job.last_timestamp

        bucket.write "#{job.event}-#{config[ job.event ]}.csv", csv
      end

      bucket.write 'beso.yml', config.to_yaml
    end
  end
end
