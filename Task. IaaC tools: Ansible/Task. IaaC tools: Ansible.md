Project structure

1) hosts  -inventory file with host groups

2) group_vars/all/vars.yml - variables that belong to all project

3) roles - folder  with two roles:
- create_file
- fetch_linux_distro_name_version 

4) ansible.cfg -configure  file

5) hometsk5.yml - main file with  playbooks

hosts  

```
all:
  children:
    webservers_group_1:
      hosts:
        "{{ web_server_1 }}"
      vars:
        ansible_user: "{{ user }}"
    webservers_group_2:
      hosts:
        "{{ web_server_2 }}"
      vars:
        ansible_user: "{{ user }}"
    webservers_group_3:
      hosts:
        "{{ web_server_3 }}"
      vars:
        ansible_user: "{{ user }}"
    iaas:
      children:
        webservers_group_1:
        webservers_group_2:
```

group_vars/all/vars.yml

define hosts and user variables for entire project

```
web_server_1 :  18.192.99.31
web_server_2 :  18.192.6.74
web_server_3 :  3.75.234.119
user: ubuntu
```

roles
- create file creating a empty file /etc/iaac with rigths 0500 

- create_file/tasks/main.yml

```
---
- name: create a new file
  file:
    path: "/etc/iaac"
    state: touch
    owner: root
    group: root
    mode: '0500'
    
```

fetch a linux distro name/version

fetch_linux_distro_name_version/tasks/main.yml

```
---
- name: System details
  debug: 
    msg:
    - "Hostname - {{ ansible_hostname }} --- Distribution - {{ ansible_distribution }} --- Version - {{ ansible_distribution_version }}"
```

ansible.cfg

```
# basic default values
[defaults]
inventory = ./hosts
host_key_checking = false
```

hometsk5.yml with two playbooks

```
---

- name: creating a empty file /etc/iaac with rigths 0500
  hosts: iaas
  become: yes
  roles:
    - create_file

   


- name: fetch a linux distro name_version
  hosts: 
    all
  gather_facts: yes
  become: no
  roles:
    - fetch_linux_distro_name_version

```
run playbook file  with private ssh key(one  for  all hosts)

```
ansible-playbook hometsk5.yml  --private-key /path_to_key/devops.pem
```

![зображення](https://user-images.githubusercontent.com/97990456/209868283-6c6093d4-c6dc-4d3d-ba92-5ea7c83a1110.png)




