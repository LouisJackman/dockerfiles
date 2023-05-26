# ansible-dev

Ansible installed on top of the base-dev image. Suitable for developing Ansible
playbooks. However, the amount of 3rd party packages in the base-dev image make
exposing your SSH key more risky; use the `ansible` image instead for running
playbooks over SSH, which doesn't include so many 3rd party packages as part of
a development environment

