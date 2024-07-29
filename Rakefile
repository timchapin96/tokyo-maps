# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :boot do
  desc "Precompile assets and start Rails server"
  task start_server: :environment do
    # Precompile assets
    Rake::Task['assets:precompile'].invoke

    # Start Rails server
    exec "rails s"
  end
end
