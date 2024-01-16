# Ansible files

Set SSH agent

```bash
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa
ssh-add -l
```

Setup servers

```bash
ansible-playbook -i ../../terraform/files/output/k8s/inventory.yml public-servers.yml -u USER --private-key=~/.ssh/id_rsa --ask-become-pass
```

To spin up from scratch run these playbooks in order:

- `k8s-server.yml`
- `k8s-nodes.yml`
- `sonarqube.yml`
