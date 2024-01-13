# Ansible files

Set SSH agent

```bash
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
ssh-add -l
```

Setup servers

```bash
ansible-playbook -i ../../terraform/files/output/public/inventory.yml public-servers.yml -u USER --private-key=~/.ssh/id_rsa --ask-become-pass
```

Following this, SSH into the Rancher guest VM and retrieve the
