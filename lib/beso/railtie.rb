module Beso
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/beso.rake'
    end
  end
end
