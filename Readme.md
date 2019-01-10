# Puppet Development environment for Anthill Platform

This repository contains a simple "proof-of-concept" environment that is required to
test necessary <a href="https://github.com/anthill-platform/puppet-anthill">Puppet Modules for Anthill Platform</a>.

## How To Setup

You need [Librarian Puppet](https://librarian-puppet.com/) to setup this repository. Install Ruby on your machine, install `gem install librarian-puppet` and just do `librarian-puppet install` in the repository folder. 

Alternatively, you can install [Hiera Editor](https://github.com/desertkun/hiera-editor) and then simply open the repositorin in it, the editor will setup everything automatically.

## Project Structure

It consists of a two main parts:

### The `environments/` folder

This folder contains all of your environments you need. For example, you may need two environments: `dev` for a 
development and early-testing of new features and `production` for actual production releases.

Every environment folder should have such structure:

```
environments/
    dev/
        manifests/
            init.pp
        modules/
            keys/
                anthill.pem
                anthill.pub
                * other keys *
```

File `manifests/init.pp` is the main configuration file for the environment. According to the Puppet language,
it tells which service belongs to each node. Please see <a href="https://github.com/anthill-platform/anthill/blob/master/doc/Puppet.md">Puppet Configuration</a> for details.

The submodule `modules/keys` is a special module for your private keys. Anthill Platform uses asymmetric cryptography 
to authenticate users. To do so, an encrypted private/public key pair should be generated 
(`anthill.pem` and `anthill.pub` from the example above). 

Please see <a href="https://github.com/anthill-platform/anthill/blob/master/doc/Keys.md">How To Generate Keys</a> for a simple instruction on how to generate your keys.

### The `modules/` folder

This folder contains all modules Puppet needs, including modules for Anthill Platform itself, and some external modules
from open-source developers.
