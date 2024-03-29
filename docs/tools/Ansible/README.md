# [Ansible](https://www.ansible.com/)

Ansible is a declarative configuration management tool used to configure infrastructure resources.

## [Installation](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)

## [Inventories](https://docs.ansible.com/ansible/latest/getting_started/get_started_inventory.html#get-started-inventory)

An inventory file looks like:

```init
# inventory.ini

[myhosts]
192.0.2.50
192.0.2.51
192.0.2.52

[other_hosts]
192.0.3.50
```

Verify hosts are up:

```bash
ansible myhosts -m ping -i inventory.ini
```

## Configuration

Exists at `/etc/ansible/ansible.cfg` or `~/.ansible.cfg`

### Disable Fingerprint Checking

```toml
[defaults]
host_key_checking = False
```

## [Playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html#playbooks-intro)

### Syntax

```yaml
# playbook.yaml
---
- name: Update web servers
  hosts: webservers
  remote_user: root

  tasks:
    - name: Ensure apache is at the latest version
      ansible.builtin.yum:
        name: httpd
        state: latest

    - name: Write the apache config file
      ansible.builtin.template:
        src: /srv/httpd.j2
        dest: /etc/httpd.conf

- name: Update db servers
  hosts: databases
  remote_user: root

  tasks:
    - name: Ensure postgresql is at the latest version
      ansible.builtin.yum:
        name: postgresql
        state: latest

    - name: Ensure that postgresql is started
      ansible.builtin.service:
        name: postgresql
        state: started
```

### Running Playbooks

```bash
ansible-playbook playbook.yaml

# or with an encrypted ssh key

ansible-playbook -i inventory_file playbook.yml -u remote_user --private-key=/path/to/your/private/key --ask-pass

# or can provide sudo password
ansible-playbook -i inventory_file playbook.yml -u remote_user --ask-become-pass
```

#### With encrypted SSH key

```bash
ansible-playbook -i inventory_file playbook.yml -u remote_user --private-key=/path/to/your/private/key --ask-pass
```

If you find this doesn't work try creating an ssh agent...

```bash
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
ssh-add -l
```

Then you will not have to use `--ask-pass`

### Verify playbook sytax

```bash
ansible-lint playbook.yml
```
