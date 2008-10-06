Gem::Specification.new do |s|
  s.name = %q{robbie}
  s.version = "0.1.0"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Gastón Ramos"]
  s.date = %q{2008-10-06}
  s.description = %q{A bunch of useful recipes to help deployment}
  s.email = %q{ramos.gaston@gmail.com}
  # s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  #  s.files = []
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--main", "README.txt"]
  # s.require_paths = ["lib"]
  s.rubyforge_project = %q{eycap}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Capistrano tasks}

  s.add_dependency(%q<capistrano>, [">= 2.2.0"])
  s.add_dependency(%q<hoe>, [">= 1.5.1"])
end
