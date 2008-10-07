require File.join(File.dirname(__FILE__), "..", "lib", "ey_logger.rb")
Capistrano::Configuration.instance(:must_exist).load do

  namespace :deploy do
    # This is here to hook into the logger for deploy and deploy:long tasks
    ["deploy", "deploy:long"].each do |tsk|
      before(tsk) do
        Capistrano::EYLogger.setup( self, tsk )
        at_exit{ Capistrano::EYLogger.post_process if Capistrano::EYLogger.setup? }
      end
    end

  end

end
