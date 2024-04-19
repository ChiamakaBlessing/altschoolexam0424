### EXAM PROJECT DOCUMENTATION 
# I. This automation contains the provisioning of two Ubuntu-based servers, named “Master” and “Slave”, using Vagrant, with a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack, and cloned a laravel framework from GitHub, with all packages, and configured Apache web server and MySQL, using ansible to execute the bash script on the Slave node and cronjob to create check the server's uptime every 12:00am.

# II. Provisioning of "master" and "slave"
the file "vagrant-file.sh" when runned/executed, runs the two ubuntu master and slave machines while creating a vagrantfile.


# III. laravel deployment on master node
the file "lamp-config.sh" deploys laravel cloned from github repository only on the master node. 


# IV. the ansible playbook
in the absible-playbook directory contains ansible.cfg, inventory, play-slave.yml and a directory called "files"
#### a. Ansible.cfg:- Is the mainframe file of Ansible, the file that commands the behavior of all interactions performed by the control node.

#### b. Iventory:- Inventory is a list of managed nodes, or hosts, that Ansible deploys and configures. this inventory carries the ip address of the slave node in this project.

#### c. play-slave.yml:- the Ansible Playbook contains the blueprint of automation tasks on the slave node, which are IT actions executed with limited manual effort, across an inventory of IT solutions.

#### d. files:- contains the file "lamp-config.sh" which the playbook use to deploy laravel cloned from github repository only on the slave node. https://github.com/laravel/laravel.git



