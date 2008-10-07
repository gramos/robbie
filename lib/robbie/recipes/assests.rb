Capistrano::Configuration.instance.load do

#############################################################################
# ASSETS

namespace :assets do
  task :symlink, :roles => :app do
    assets.create_dirs
    run <<-CMD
      rm -rf #{release_path}/public/uploads;
      rm -rf #{release_path}/public/images/avatars;
      ln -nfs #{shared_path}/uploads #{release_path}/public/uploads;
      ln -nfs #{shared_path}/avatars #{release_path}/public/images/avatars;
    CMD
  end
  task :create_dirs, :roles => :app do
    %w(uploads avatars).each do |name|
      run "mkdir -p #{shared_path}/#{name}; true"
    end
  end
end

after "deploy:update_code" , "assets:symlink"

end
