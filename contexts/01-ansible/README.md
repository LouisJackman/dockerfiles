# ansible

Ansible installed on top of the `debian-slim` image. Suitable for running
playbooks over SSH. However, it installs no development tools in order to reduce
the number of 3rd party tools with access to your SSH key. To comfortably
develop the playbooks themselves without running them, use the `ansible-dev`
image instead.

