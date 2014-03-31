begin
  require 'paratrooper'
rescue LoadError
  nil
end

namespace :assets do
  task :precompile do
    sh 'middleman build'
  end
end

if defined? Paratrooper
  require_relative 'lib/search_engine_notifier'

  desc 'Deploy site'
  task :deploy do
    deployment = Paratrooper::Deploy.new('agv',
                                         notifiers: [
                                             Paratrooper::Notifiers::ScreenNotifier.new,
                                             SearchEngineNotifier.new('https://www.agv-muenchen.de'),
                                         ]
    )

    deployment.setup
    deployment.update_repo_tag
    deployment.push_repo
    deployment.teardown
  end
end
