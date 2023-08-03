cat install.sh 

    if ( command -v brew >/dev/null 2>&1; )  ; then
    {
        brew install rbenv
        sudo chown -R $(whoami) $HOME/.rbenv
    } 
    else 
    {
        echo "Warning: could not find brew to install ruby"
    }
    fi
   
    export RBENV_ROOT="$/.rbenv"
    export PATH="$HOME/.rbenv/bin:${PATH}"
    eval "$(rbenv init -)"

    if ( command -v rbenv >/dev/null 2>&1; )  ; then
    {
        rbenv install 
        rbenv local 3.2.2
        rbenv rehash
    }
    else 
    {
        echo "Warning: could not find rbenv to select correct ruby version"
    }
    fi
   
   
    # Mac only
    if [[ "$(uname)" == "Darwin" ]] ; then
    {
        sudo chown -R $(whoami) /Library/Ruby
    }
    else 
    {
        echo "Warning: This is not a Mac, 
        if you on windows, it is weird to see this, 
        if you are on linux, make sure your ruby folder has correct right for gems install without sudo "
    }
    fi

    if ! ( command -v ruby >/dev/null 2>&1; )  ; then
    {
        echo "Error: Cannot continue. I cannot find ruby executable"
        exit 1
    }
    fi
    if ! ( command -v gem >/dev/null 2>&1; )  ; then
    {
        echo "Error: Cannot continue. I cannot find gem executable"
        exit 1
    }
    fi

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
