Capistrano::Configuration.instance(:must_exist).load do

######################################################################################
# NGINX

  namespace :nginx do
    desc "Start Nginx on the app slices."
    task :start, :roles => :app do
      sudo "/etc/init.d/nginx start"
    end

    desc "Restart the Nginx processes on the app slices."
    task :restart , :roles => :app do
      sudo "/etc/init.d/nginx restart"
    end

    desc "Stop the Nginx processes on the app slices."
    task :stop , :roles => :app do
      sudo "/etc/init.d/nginx stop"
    end

    desc "Tail the nginx access logs for this application"
    task :tail, :roles => :app do
      sudo "tail -f /var/log/nginx/#{application}.access.log" do |channel, stream, data|
        puts "#{channel[:server]}: #{data}" unless data =~ /^10\.[01]\.0/ # skips lb pull pages
        break if stream == :err
      end
    end

    desc "Tail the nginx error logs on the app slices"
    task :tail_error, :roles => :app do
      sudo "sudo tail -f /var/log/nginx/error.log" do |channel, stream, data|
        puts "#{channel[:server]}: #{data}" unless data =~ /^10\.[01]\.0/ # skips lb pull pages
        break if stream == :err
      end
    end

    @nginx_path     = "/etc/nginx"
    @tmp            = "/tmp"
    @enabled_path   = "#{@nginx_path}/sites-enabled"
    @available_path = "#{@nginx_path}/sites-available"

  desc 'Habilita un host virtual'
  task :en_vhost do
    sudo "test -L #{@available_path}/#{application} || sudo ln -s #{@available_path}/#{application}; true " +
         "#{@enabled_path}/#{application}"
  end

  desc 'Deshabilita un host virtual'
  task :dis_vhost do
    sudo  "rm -f #{@enabled_path}/#{application}"
  end

  desc 'Hace un reload del nginx'
  task :reload do
    sudo "/etc/init.d/nginx reload"
  end

  desc "Agrega una vhost para nginx"
  task :add_vhost do
    nginx_config = ERB.new <<-EOF
    upstream mongrel-#{application} {
      server 127.0.0.1:#{mongrel_port};
      server 127.0.0.1:#{mongrel_port.to_i + 1};
    }
    server {
        listen       80;
        server_name  #{nginx_server_name};
        root #{deploy_to}/current/public;
        index  index.html index.htm;

        access_log  /var/log/nginx/localhost.access.log;

        location / {
           index index.html index.htm;
           proxy_set_header  X-Real-IP  $remote_addr;
           proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header Host $http_host;
           proxy_redirect false;

        # If the file exists as a static file serve it directly without
        # running all the other rewite tests on it
           if (-f $request_filename) {
             break;
           }

           if (-f $request_filename/index.html) {
             rewrite (.*) $1/index.html break;
           }

           if (-f $request_filename.html) {
             rewrite (.*) $1.html break;
           }

           if (!-f $request_filename) {
             proxy_pass http://mongrel-#{application};
             break;
           }

        }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /500.html;
        location = /500.html {
            root   #{deploy_to}/current/public/;
        }

    }
    EOF
    sudo "test -d #{@nginx_path}/sites-available || mkdir #{@nginx_path}/sites-available"
    sudo "test -d #{@nginx_path}/sites-enabled || mkdir #{@nginx_path}/sites-enabled"
    put nginx_config.result, "#{@tmp}/#{application}"
    sudo "cp #{@tmp}/#{application} #{@nginx_path}/sites-available/#{application}"
    sudo "rm #{@tmp}/#{application}"
  end

end

#  after "nginx:add_vhost", "nginx:en_vhost"
#  after "deploy:cold", "nginx:add_vhost"
#  after "deploy:cold", "nginx:reload"
end


