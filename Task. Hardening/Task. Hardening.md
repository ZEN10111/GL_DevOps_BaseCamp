This  project implements policy  "Do not use your username in password"


Project structure

1) hosts  -inventory file with host groups

2) group_vars/all/vars.yml - variables that belong to all project

3) roles - folder  with two roles:
- Install_pwquality # PAM module that perform password quality checking
- Do_not use_username_in_password # implement policy

4) ansible.cfg -configure file

5) hometask7-8.yml - main file with  playbooks

hosts

```

all:
  children:
    webservers_group_1:
      hosts:
        "{{ web_server_1 }}"
      vars:
        ansible_user: "{{ user }}"

```

group_vars/all/vars.yml

```
web_server_1 :  35.159.38.227
user: ubuntu

```
roles 

- Install_pwquality

```
- name: Install pwquality
  ansible.builtin.apt:
    pkg:
    - libpam-pwquality
    - cracklib-runtime
    state: present
    update_cache: yes

```
- Do_not use_username_in_password
- 
```
- name: Add a rule for  users and root  "Do not use your username in password" 
  ansible.builtin.replace:
    path: /etc/pam.d/common-password 
    regexp: 'pam_pwquality.so retry=3'
    replace: 'pam_pwquality.so retry=3 usercheck = 1 enforce_for_root'

```
ansible.cfg

```
# basic default values
[defaults]
inventory = ./hosts
host_key_checking = false

```

hometask7-8.yml

```
---

- name: Install_pwquality
  hosts: webservers_group_1
  become: yes
  roles:
    - Install_pwquality
    - Do_not use_username_in_password
    
```

run playbook file  with private ssh key

```
ansible-playbook hometask7-8.yml --private-key /path_to_key/Dev0ps2.pem

```

![зображення](https://user-images.githubusercontent.com/97990456/212216049-50b5fc5e-9a7f-4e15-8036-249e84db4911.png)

go to server

```
ssh -i "/path_to_key" ubuntu@35.159.38.227

```
create user and try setup password  same as users login 

![зображення](https://user-images.githubusercontent.com/97990456/212216876-44d96ade-ce37-425c-bd79-5861a27e0c36.png)

we have an error

try setup simply password 12345678  and  we have an error too

![зображення](https://user-images.githubusercontent.com/97990456/212217103-fb57dc13-60c2-42a9-a290-4ea01f175cd4.png)

setup more secure password and it`s updated successfully

![зображення](https://user-images.githubusercontent.com/97990456/212217322-0a82bdbd-3d4b-4fff-b979-e9181e4c1673.png)


the  same  situation when  a  user  try change his password

- simplepsssword 12345678
- password  same as users login
- more secure password

![зображення](https://user-images.githubusercontent.com/97990456/212218097-a8635d00-334c-4707-940a-c4265d29ba84.png)




