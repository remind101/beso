#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'appraisal'
require 'rspec/core/rake_task'

namespace :beso do

  desc "Set up current environment variables"
  task :env do
    require 'rails/version'
    ENV[ 'BESO_RAILS_NAME' ] = "rails-#{Rails::VERSION::STRING}"
    ENV[ 'BESO_RAILS_PATH' ] = "spec/rails/#{ENV[ 'BESO_RAILS_NAME' ]}"
  end

  desc "Remove all test rails apps"
  task :clean => [ :env ] do
    Dir[ 'spec/rails/rails-*' ].each do |app|
      FileUtils.rm_rf app
    end
  end

  desc "Create a test rails app if necessary"
  task :rails do
    if File.exist? ENV[ 'BESO_RAILS_PATH' ]
      puts "Using existing #{ENV[ 'BESO_RAILS_NAME' ]} app"
    else
      sh "bundle exec rails new #{ENV[ 'BESO_RAILS_PATH' ]} -m spec/support/rails_template.rb"
    end
  end
end

RSpec::Core::RakeTask.new :spec => [ :'beso:env', :'beso:rails' ]

desc "Run specs for all supported rails versions"
task :all do
  exec 'rake appraisal spec'
end

desc "Default: Clean, install dependencies, and run specs"
task :default => [ :'beso:clean', :'appraisal:install', :all ]
