Install
=======

Download
^^^^^^^^
Download the vm from `here <https://docs.qtibia.ro/qgis.vdi.xz>`_

.. note::

  The size of the VM is around 2GB compressed and up to 15GB uncompressed.

Extract
^^^^^^^^
The virtual disk is archived using XZ compression.

To extract the archive:

- **Windows:** you can use `7-Zip <http://7-zip.org/>`_ to extract the archive.
- **Linux:** cd to the download directory and run ``xz -d qgis.vdi.xz``

You can run the VM as you would do with any VirtualBox VM.

.. note::

 As the VM is based on Linux it is fairly simple to convert the image to a raw disk
 and put it on a USB stick (minimum 16GB) or a faster storage. This would enable you
 to run the app without the virtualization penalty and enjoy the full speed of your hardware.

Run TWW
^^^^^^^^

After logging in with ``qgis`` user and the same password, by  clicking the QGIS icon located in the bottom bar
you will get the following image:

.. figure:: images/vm_demo.jpg

Clicking the **tww_en** project and following the :ref:`user-guide` should get you started.
