$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Robbie

require "yaml"

DEPLOY_TO           = '/var/www/apps'
MONGREL_CONF_PATH   = '/etc/mongrel_cluster/sites-enabled'

@black_list =  ["..", "."]

def is_an_app?(f)
  return false if @black_list.include? f
  return false if File.file? f
  return true
end

def apps_list(folder)
  list = []
  Dir.foreach(folder){|d| list <<  d if is_an_app?(d)}
  list
end

def load_yml(f)
  File.open(f) { |yf| YAML::load(yf) }
end

def shoot_list
  apps_list(DEPLOY_TO).map{|app|
    conf = load_yml( "#{DEPLOY_TO}/#{app}/current/config/database.yml" )
    { app => conf["production"]["shooting_star"] }
  }
end

def mongrel_conf_files(mc_conf_path)
  Dir.glob("#{mc_conf_path}/*.yml")
end

def mongrel_app_port(arr_conf)
  app = arr_conf["cwd"].split(DEPLOY_TO).last.split("/")[1]
  ports = add_ports(arr_conf)
  { :app => app, :ports => ports, :servers => arr_conf["servers"] }
end

def add_ports(arr_ports)
  size = arr_ports["servers"].to_i
  size.times.map{|n| arr_ports["port"].to_i + n}
end

# puts mongrel_conf_files(MONGREL_CONF_PATH).map{|f| mongrel_app_port(load_yml(f))}.inspect
# puts shoot_list.inspect
end
