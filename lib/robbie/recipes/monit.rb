Capistrano::Configuration.instance(:must_exist).load do
##########################################################################
# monit

  namespace :monit do
    desc "Get the status of your mongrels"
    task :status, :roles => :app do
      @monit_output ||= { }
      sudo "/usr/bin/monit status" do |channel, stream, data|
        @monit_output[channel[:server].to_s] ||= [ ]
        @monit_output[channel[:server].to_s].push(data.chomp)
      end
      @monit_output.each do |k,v|
        puts "#{k} -> #{'*'*55}"
        puts v.join("\n")
      end
    end

  desc "reload monit server"
  task :reload do
    run "sudo /etc/init.d/monit force-reload"
  end

  desc "Create monit file in /etc/monit.d/ror-apps/"
  task :default do
    monit_config_str =  ""
    cluster_mongrel_port = mongrel_port.to_i

    cluster_mongrel_port.upto(cluster_mongrel_port + mongrel_servers - 1) {|cluster_port|
      monit_config_str += <<-EOF

###############################################################################################
# #{application}

check process mongrel_#{cluster_port} with pidfile #{shared_path}/pids/mongrel.#{cluster_port}.pid
start program = "/usr/bin/mongrel_rails cluster::start -C #{mongrel_conf} --clean --only #{cluster_port}"
stop program = "/usr/bin/mongrel_rails cluster::stop -C  #{mongrel_conf} --clean --only #{cluster_port}"

if failed host 127.0.0.1 port #{cluster_port} protocol http
  with timeout 10 seconds
  then restart

if totalmem > 100 Mb then restart
if cpu is greater than 90% for 2 cycles then alert
if cpu > 90% for 5 cycles then restart
if loadavg(5min) greater than 10 for 8 cycles then restart
if 5 restarts within 5 cycles then timeout
group mongrel-#{application}
EOF
}

  monit_config = ERB.new(monit_config_str)
  sudo "mkdir -p /etc/monit.d/ror-apps/"
  sudo "chown -R #{user}:#{mongrel_group} /etc/monit.d/ror-apps/"
  sudo "chmod 774 -R /etc/monit.d/ror-apps/"
  put monit_config.result, "/etc/monit.d/ror-apps/#{application}"
end

end


end

