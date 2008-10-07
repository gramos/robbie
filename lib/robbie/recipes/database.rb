Capistrano::Configuration.instance(:must_exist).load do

  namespace :db do
    task :backup_name, :roles => :db, :only => { :primary => true } do
      now = Time.now
      run "mkdir -p #{shared_path}/db_backups"
      backup_time = [now.year,now.month,now.day,now.hour,now.min,now.sec].join('-')
      set :backup_file, "#{shared_path}/db_backups/#{environment_database}-snapshot-#{backup_time}.sql"
    end

    desc "Clone Production Database to Staging Database."
    task :clone_prod_to_staging, :roles => :db, :only => { :primary => true } do
      backup_name
      on_rollback { run "rm -f #{backup_file}" }
      run("cat #{shared_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)[rails_env] }
      if @environment_info['adapter'] == 'mysql'
        run "mysqldump --add-drop-table -u #{dbuser} -h #{production_dbhost.gsub('-master', '-replica')} -p#{dbpass} #{production_database} > #{backup_file}"
        run "mysql -u #{dbuser} -p#{dbpass} -h #{staging_dbhost} #{staging_database} < #{backup_file}"
      else
        run "PGPASSWORD=#{dbpass} pg_dump -c -U #{dbuser} -h #{production_dbhost} -f #{backup_file} #{production_database}"
        run "PGPASSWORD=#{dbpass} psql -U #{dbuser} -h #{staging_dbhost} -f #{backup_file} #{staging_database}"
      end
      run "rm -f #{backup_file}"
    end

    desc "Backup your MySQL or PostgreSQL database to shared_path+/db_backups"
    task :dump, :roles => :db, :only => {:primary => true} do
      backup_name
      run("cat #{shared_path}/config/database.yml") { |channel, stream, data| @environment_info = YAML.load(data)[rails_env] }
      if @environment_info['adapter'] == 'mysql'
        run "mysqldump --add-drop-table -u #{dbuser} -h #{environment_dbhost.gsub('-master', '-replica')} -p#{dbpass} #{environment_database} | bzip2 -c > #{backup_file}.bz2"
      else
        run "PGPASSWORD=#{dbpass} pg_dump -c -U #{dbuser} -h #{environment_dbhost} #{environment_database} | bzip2 -c > #{backup_file}.bz2"
      end
    end

    desc "Sync your production database to your local workstation"
    task :clone_to_local, :roles => :db, :only => {:primary => true} do
      backup_name
      dump
      get "#{backup_file}.bz2", "/tmp/#{application}.sql.gz"
      development_info = YAML.load_file("config/database.yml")['development']
      if development_info['adapter'] == 'mysql'
        run_str = "bzcat /tmp/#{application}.sql.gz | mysql -u #{development_info['username']} -p#{development_info['password']} -h #{development_info['host']} #{development_info['database']}"
      else
        run_str = "PGPASSWORD=#{development_info['password']} bzcat /tmp/#{application}.sql.gz | psql -U #{development_info['username']} -h #{development_info['host']} #{development_info['database']}"
      end
      %x!#{run_str}!
    end
  end

###########################################################################
# DATABASE YAML

# after "deploy:setup", :db
# after "deploy:update_code", "db:symlink"

namespace :db do

  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: mysql
      username: #{runner}
      password: #{password}
      host: 127.0.0.1

    development:
      database: #{db_name}_dev
      <<: *base

    test:
      database: #{db_name}_test
      <<: *base

    production:
      database: #{db_name}_prod
      shooting_star:
        server: #{shoot_server}:#{shoot_server_port}
        shooter: druby://localhost:#{shoot_drb_port}
      <<: *base
    EOF

    sudo "mkdir -p #{shared_path}/config"
    sudo "chown -R #{user}:#{mongrel_group} #{deploy_to}/"
    sudo "chmod 774 -R #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

end

end
