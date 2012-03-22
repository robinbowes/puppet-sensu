# puppet-sensu

A puppet module for managing Sensu on servers and clients.

sensu::server is only tested on Ubuntu 11.04.

sensu::client is only tested on Ubuntu 11.04 and Debian 5.0.

## Usage

### Server

To install the sensu server components on a node, add the following to your node manifest.

    node 'foobar.acme.c.bitbit.net' {
      include sensu::server
    }

This installs the following components on that node:

* RabbitMQ
* Redis
* sensu-api
* sensu-client
* sensu-dashboard
* sensu-server

### Client

To install the sensu-client on a node, add the following to your node manifest.

    node 'foobar.acme.c.bitbit.net' {
      include sensu::client
    }

## NB!

Note that the ruby::rubygems-class which is included in *manifests/init.pp* is a basic class that downloads and installs rubygems on the system.
