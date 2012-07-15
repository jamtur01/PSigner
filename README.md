# PSigner

**PSigner** is a [sinatra](http://www.sinatrarb.com) app/middleware that
can be run standalone app or required as a gem. It allows the remote
signing of Puppet client certificates via an API call, by passing the
`certname` to be signed and the shared secret as the value of the
`secret` parameter.

    $ curl -d "secret=SHAREDSECRET&certname=bob" http://localhost:4567/api/sign

You can configure the shared secret via the `config.yml` file in the `config` directory.

## Running standalone
Simply run the ``bundle`` and then ``rackup`` commands. To sign certificates you will need to run PSigner on the Puppet master as the `root` user.

## Bundling as a gem
    gem build psigner.gemspec
    sudo gem install psigner-0.0.1.gem
