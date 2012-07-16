# PSigner

**PSigner** is a [sinatra](http://www.sinatrarb.com) application that allows you to sign and 
delete [Puppet](http://www.puppetlabs.com) certificates via a simple web service. It is 
designed as an example prototype to show you how you can use an automatic signing and deleting 
process with a simple shared secret when (de-)provisioning hosts.

NOTE: You could also do this directly via the Puppet API but that requires SSL authentication. 
This is less secure but potentially somewhat simpler.

##  Signing a new certificate
It allows the remote signing of Puppet client certificates via an API call, by passing the
`certname` to be signed and the shared secret as the value of the
`secret` parameter.

    $ curl -d 'secret=SHAREDSECRET' -d 'certname=bob' -X POST http://localhost:4567/api/cert

You can configure the shared secret via the `config.yml` file in the `config` directory.

## Cleaning out an old certificate
To revoke and remove a cert from Puppet's CA

    $ curl -d 'secret=SHAREDSECRET' -d 'certname=bob' -X DELETE http://localhost:4567/api/cert

## Running standalone
Simply run the ``bundle`` and then ``rackup`` commands. 

To sign certificates you will need to run PSigner on the Puppet master as the `root` user.

## A note on security
You should run the API service behind a web server with HTTPS/SSL enabled to prevent someone
sniffing the network and getting your shared secret. There are also a number of ways you could
store and retrieve the shared secret other than a config file that would this more functional.

## Bundling as a gem
    gem build psigner.gemspec
    sudo gem install psigner-0.0.1.gem
