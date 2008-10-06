require 'robbie/lib/ey_logger'
require 'robbie/lib/ey_logger_hooks'
require 'robbie/recipes/database'
require 'robbie/recipes/ferret'
require 'robbie/recipes/mongrel'
require 'robbie/recipes/nginx'
require 'robbie/recipes/slice'
require 'robbie/recipes/deploy'
require 'robbie/recipes/sphinx'
require 'robbie/recipes/backgroundrb'
require 'robbie/recipes/memcached'
require 'robbie/recipes/solr'
require 'robbie/recipes/monit'
require 'robbie/recipes/tomcat'
require 'robbie/recipes/juggernaut'

Capistrano::Configuration.instance(:must_exist).load do

  default_run_options[:pty] = true if respond_to?(:default_run_options)
  set :keep_releases, 3
  set :runner, defer { user }

end
