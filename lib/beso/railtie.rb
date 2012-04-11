module Beso
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'lib/beso.rake'
    end
  end
end
