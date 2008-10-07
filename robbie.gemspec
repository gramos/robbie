Gem::Specification.new do |s|
  s.name = %q{robbie}
  s.version = "0.0.2"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gastón Ramos"]
  s.date = %q{2008-10-06}
  s.description = %q{A bunch of useful recipes (based on eycap) to help deployment}
  s.email = %q{ramos.gaston@gmail.com}
  # s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  candidates =  ["lib/robbie", "lib/robbie/lib", "lib/robbie/lib/ey_logger.rb", "lib/robbie/lib/ey_logger_hooks.rb", "lib/robbie/recipes", "lib/robbie/recipes/backgroundrb.rb", "lib/robbie/recipes/database.rb", "lib/robbie/recipes/deploy.rb", "lib/robbie/recipes/ferret.rb", "lib/robbie/recipes/juggernaut.rb", "lib/robbie/recipes/memcached.rb", "lib/robbie/recipes/mongrel.rb", "lib/robbie/recipes/monit.rb", "lib/robbie/recipes/nginx.rb", "lib/robbie/recipes/slice.rb", "lib/robbie/recipes/solr.rb", "lib/robbie/recipes/sphinx.rb", "lib/robbie/recipes/templates", "lib/robbie/recipes/templates/maintenance.rhtml", "lib/robbie/recipes/tomcat.rb", "lib/robbie/recipes/shooting_star.rb", "lib/robbie/recipes/admin.rb", "lib/robbie/recipes/assets.rb", "lib/robbie/recipes/admin.rb~", "lib/robbie/recipes.rb", "lib/robbie/version.rb", "lib/robbie.rb"]
  # Dir.glob("{lib}/**/*")
  candidates << "README.txt"
  s.files = candidates.delete_if do |item|
    item.include?("~") || item.include?("git")
  end
  s.has_rdoc = true
  s.homepage = %q{}
  # s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{robbie}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Capistrano tasks}

  s.add_dependency(%q<capistrano>, [">= 2.2.0"])
end
