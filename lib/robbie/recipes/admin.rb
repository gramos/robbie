Capistrano::Configuration.instance(:must_exist).load do

##########################################################################
# ADMIN and MONITORING

namespace :admin do

desc "tail log files"
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/*.log" do |channel, stream, data|
    puts  "\n\n"# for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

desc "show server conections"
task :netstat, :roles => :app do
  run "netstat -a" do |channel, stream, data|
    puts  "\n\n"# for an extra line break before the host name
    puts "#{data}"
    break if stream == :err
  end
end



###############################################################################
# SETUP SSH

desc "Copies contents of ssh public keys into authorized_keys file"
task :setup_ssh_keys do

  unless ssh_options[:keys]
    puts <<-ERROR

      You need to define the name of your SSH key(s)
      e.g. ssh_options[:keys] = %w(/Users/someuser/.ssh/id_dsa)

      You can put this in your .caprc file in your home directory.

      ERROR
    exit
  end

  sudo "test -d ~/.ssh || mkdir ~/.ssh"
  sudo "chmod 0700 ~/.ssh"
  put(ssh_options[:keys].collect{|key| File.read(key+'.pub')}.join("\n"),
      File.join('/home', user, '.ssh/authorized_keys'),
      :mode => 0600 )
end

end

end
