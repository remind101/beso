namespace :beso do

  desc "Run Beso jobs and upload to S3"
  task :run => :environment do

    raise 'Beso has no jobs to run. Please define some in the beso initializer.' if Beso.jobs.empty?

    Beso.jobs.each do |job|
      puts "==> #{job.event.inspect}"
      puts job.to_csv
      puts
    end
  end
end
