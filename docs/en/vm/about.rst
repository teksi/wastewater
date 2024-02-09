About
=====

This represents a guide on how to download and install a virtual machine (VM) that has a
working TWW installation with a demo dataset. The VM also has a working demo of the `QWAT water project <https://github.com/qwat/QWAT>`_ .

The VM is based on Debian Testing with Cinnamon Desktop.

Debian Testing was chosen in order to have GDAL 2.x and also benefit from latest linux kernel so that latest hardware
won't be a problem for the case where the VM is used outside virtualization (e.g use the virtual disk as basis to create
a non-virtualized usb-stick to be used for demo purposes).

Installed software:

- PostgreSQL 9.6.0 with Postgis 2.3
- QGIS 2.18
- pgAdmin 4 (open the browser at http://localhost:5050 to access it)


Settings that are changed from a default software install:

- ``pg_hba.conf`` has ``trust`` for local connections
- QGIS is setup with `multithreaded rendering enabled <http://www.lutraconsulting.co.uk/products/qgis-mtr>`_

.. note::

 The users ``qgis`` and ``root`` have the password ``qgis``

.. note::

 If you decide to use the VM in production, it is recommended to:

  - change the passwords
  - regenerate the ssh keys by running in a terminal ``sudo rm /etc/ssh/ssh_host_* && sudo dpkg-reconfigure openssh-server``
