Ansible Drupal Devbox
=====================

Wanna be devtools and devbox for drupal, using ansible.

## Install

Do not install just yet, this is a proof of concept. The following are just
notes for myself

### Stand alone

`git clone git@github.com:esclapes/ansible-drupal-devbox.git addbox`


### Within a project repository

`git submodule add git@github.com:esclapes/ansible-drupal-devbox.git addbox`

### Defaults

For ansible to work you need at least a hosts file and use -i option when
executing playbooks. To avoid using -i all the time you can either use the
defalt location ant `/etc/ansible/hosts` or include an `ansible.cfg` file at the
same directory where you execute `ansible-playbook`, we assume it will be the
`addbox` directory created when clonig this repo

Two default files are include:

* `hosts.default`
* `ansible.cfg.default`

Both `hosts` and `ansible.cfg` are gitignored so you don't get your settings
overwritten.
