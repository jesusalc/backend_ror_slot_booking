cat install.sh 

brew install rbenv

# RBENV
export RBENV_ROOT="$/.rbenv"
export PATH="$HOME/.rbenv/bin:${PATH}"
eval "$(rbenv init -)"

rbenv install 
rbenv local 3.2.2
rbenv rehash

sudo chown -R $(whoami) /Library/Ruby

gem install bundler
gem install bundler:2.4.17
gem update --system 3.2.3

$SHELL 

ruby --version

gem install rails
gem update --system 3.4.18

./bin/bundle exec rails db:drop
./bin/bundle exec rails db:create
./bin/bundle exec rails db:migrate
./bin/bundle exec rails db:seed

./bin/bundle exec rails s
./bin/bundle exec rails c

./dev.sh