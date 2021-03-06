Request Tracker RPM
=============

This repository contains an RPM spec file, Shipwright shipyard of RT, and any
ancillary files needed to contain a single, (mostly) self-contained RPM of [RT](https://github.com/bestpractical/rt)
for RedHat systems.

This project uses
[bestpractical/shipwright](https://github.com/bestpractical/shipwright) to
build and install all the necessary Perl modules, plus some system libraries,
in a relocatable and repeatable fashion.

History
-------
* 2016 March 14: Create this repository with a 99% up-to-date shipyard for RT 4.4.0


Build
-----


Usage
-----

Notes
-----
The test stage for Test::HTTP::Server::Simple::StashWarnings will fail if you have anything listening on 8080/tcp, as will other tests likely.

Sometimes, but not always, the build will fail randomly, or will (rarely) hang, usually during a test.
