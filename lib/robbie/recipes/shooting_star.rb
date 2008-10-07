require 'erb'

Capistrano::Configuration.instance.load do

##########################################################################
# shoot_star for CHAT system

namespace :shooting_star do

  desc "start shoot_star server"
  task :start do
    run "cd #{latest_release} && sudo nohup shooting_star start -d"
  end

  desc "stop shoot_star server"
  task :stop do
    run "cd #{latest_release} && sudo shooting_star stop"
  end

  desc "restart shoot_star server"
  task :restart do
    stop
    start
  end

  desc "Create shooting_star yaml in shared path"
  task :default do
    shoot_config = ERB.new <<-EOF
    server:
      host: 0.0.0.0
      port: #{shoot_server_port}
    shooter:
      uri: druby://0.0.0.0:#{shoot_drb_port}
    EOF

    sudo "mkdir -p #{shared_path}/config"
    sudo "chown -R #{user}:#{mongrel_group} #{deploy_to}/"
    sudo "chmod 774 -R #{shared_path}/config"
    put shoot_config.result, "#{shared_path}/config/shooting_star.yml"
  end

  desc "Make symlink for shooting star yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/shooting_star.yml #{release_path}/config/shooting_star.yml"
  end
end


end
