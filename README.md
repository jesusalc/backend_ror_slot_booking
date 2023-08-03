# README

### Best Practices

*Separation of Concerns*: Controllers handle HTTP-related logic; services encapsulate business logic; models handle data persistence; validators encapsulate validation logic.

*Don't Repeat Yourself (DRY)*: Reusable code is moved into separate classes or modules.

*Single Responsibility Principle*: Each class or method does one thing. For example, the validator class only validates data; it doesn't perform any actions on the database.

*Use Service Objects*: For complex business logic, using service objects keeps the controllers and models clean and focused on their primary responsibilities.

*Error Handling*: Controllers handle all errors and present a consistent API to the client. Logging is used for unexpected errors, making them easier to diagnose.

*Testability*: By breaking the logic into smaller parts (controller, service, validator), it becomes easier to write unit tests for each part.

*Security*: Sanitize inputs and use strong parameters. Handle authentication and authorization appropriately.


### Install
cat install.sh 

brew install rbenv


# RBENV

this works in Linux (brew_linux) and Mac (brew) 
you can run 

```bash
    ./install.sh 
```

or follow these commands

```bash

    brew install rbenv
    sudo chown -R $(whoami) $HOME/.rbenv


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

    ./dev.sh

```

### Run 

```bash
    ./dev.sh
```
or    
```bash
    ./bin/bundle exec rails s
```

### Debug console

```bash
    ./kbuc.sh
```
or    
```bash
    ./bin/bundle exec rails c
```


### Test 

```bash
    ./test.sh
```
or    
```bash
    ./bin/bundle exec rspec
```


### Linting

run this to generate .rubocop_todo.yml
```bash
    rubocop --auto-gen-config
```
to run linter 
do
```bash
    ./test.sh
```
or   
```bash
    rubocop -a
```
