# Puppet Development environment for Anthill Platform

This repository contains a simple "proof-of-concept" environment that is required to
test necessary <a href="https://github.com/anthill-platform/puppet-anthill">Puppet Modules for Anthill Platform</a>.

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

## Environments

### `vm`

This environment is used to test Anthill Platform on a virtual machine with Debian 8.9 installed.