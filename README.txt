= robbie

script/plugin install git://github.com/gramos/robbie.git

or

gem sources -a http://gems.github.com (you only have to do this once)
gem install gramos-robbie

and then should be inlude into deploy.rb

require 'robbie/recipes'

