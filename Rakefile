require 'rubygems'
require 'hoe'
require 'lib/robbie'

Hoe.new('robbie', Robbie::VERSION) do |p|
  p.author = 'Gastón Ramos'
  p.email = 'ramos.gaston@gmail.com'
  p.summary = 'Capistrano tasks for my apps'
  p.description = 'A bunch of useful recipes to help deployment'
  p.url = 'http://github.com/engineyard/eycap/tree/master'
  p.changes = p.paragraphs_of('History.txt', 0..1).join("\n\n")
  p.extra_deps << ['capistrano', '>= 2.2.0']
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -r ./lib/eycap.rb"
end

task :coverage do
  system("rm -fr coverage")
  system("rcov test/test_*.rb")
  system("open coverage/index.html")
end

desc "Upload site to Rubyforge"
task :site do
end

desc 'Install the package as a gem.'
task :install_gem_no_doc => [:clean, :package] do
  sh "#{'sudo ' unless Hoe::WINDOZE}gem install --local --no-rdoc --no-ri pkg/*.gem"
end
