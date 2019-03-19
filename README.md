Docker debian-ntp
============

Configuration Docker with Debian Stable and package : ntp

Quick Start
===========
    docker run -d -p 123:123/udp --cap-add=SYS_TIME --cap-add=SYS_RESOURCE --name ntp mnival/debian-ntp

Interfaces
===========

Ports
-------

* 123(udp) -- NTP

Volumes
-------

N/A

Maintainer
==========

Please submit all issues/suggestions/bugs via
https://github.com/mnival/doker-ntp
