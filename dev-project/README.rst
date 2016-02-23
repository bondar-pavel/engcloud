=================================
Dev Project Templates and Scripts
=================================

Scripts and Heat templates for setting up dev projects.

Usage
-----

::

  $ ./create.sh <user>
  $ source ./<user>-openrc.sh
  $ heat stack-create -e <user>-env.yaml control.yaml

`create.sh` creates a tenant and a user, and adds the user and admin to that
tenant.

`control.yaml` creates a stack that includes a dev network, router, and
a VM named 'control' with a user account for the specified user. This VM will
also have <user>-openrc.sh in the home directory, and that file will be sourced
automatically. So, logging in as the user to that VM, you should be able to run
OpenStack clients immediately.
