# What is an imperative programming language?
- are powerful programming languages
- examples
  C/C++, Java, Python, Scala, Shell Scripting, Batch Scripts, Powershell
- in a imperative language to do anything
  we need to write code to express
  1. What?
     I wanted to install latest version of Weblogic on all Servers
     Servers
     1. Some could be Windows OS
     2. Some are installed with Unix OS
     3. Some are installed with Linux OS
  2. How 

# What is a declarative language?
- Only we need express the What part?
- The How part the code logic to perform the actual automation will be taken care by the declarative language

# What is Ansible?
- is a configuration management tool
- it helps in automating software installations on an already provisioned machine
- Ansible is developed by Python by Michael Deehan
- Michael Deehan was an employee of RedHat, looks like he was an automation tool at RedHat, but later due to some reason decommissioned
- Michael quit RedHat a founded a company called Ansible Inc and he started developing Ansible Core - which CLI based tool
-  

# What is an Ansible Node?
- are the servers where the software installation automation must be done
- this could be a 
  - Mac machine
  - Windows machine
  - Unix machine
  - Linux machine
  - Routers/Switches
- Sofware requirements
  On Windows Ansible Nodes
  - PowerShell should be there
  - .Net Framework should be there
  - WinRM (Remote Desktop enabled)
  On Unix/Mac/Linux Ansible Nodes
  - SSH Server
  - Python

# What are Ansible Modules?
- Ansible Modules are Python scripts for automating software installations on Unix/Mac/Linux based Ansible nodes
- Ansible Modules are PowerShel scripts for automating software installations on Windows Nodes
- When you install Ansible, it installs many ansible modules by default
Examples:
  - Shell module to execute shell commands on Ansible Node from Ansible Controller Machine
  - Copy module to copy files from ACM to Ansible Node and vice versa
  - Service module to manage services ( start, enable, stop, restart, disable )

# What is an Ansible Controller Machine?
- the machine where Ansible is installed that is called Ansible Controller Machine(ACM)
- ACM can be only be Unix based machine

# What is the DSL used in Ansible?
- the language in which the automation can be written
- Domain Specific Language
- The DSL used in Ansible is YAML (Yet Another Markup Language - superset of JSON)

# What is an inventory file?
- is a text file that can be created by hand using any plain text editor of your choice
- it has connection details to Ansible Nodes
- in case of Unix/Linux/Mac based Ansible Nodes
  - it has SSH connection details including credentials
- in case of Windows based Ansible Nodes
  - it has WinRM connection details including credentials
- it is of two types
  1. Static Inventory and ( text file )
  2. Dynamic Inventory ( Python is script )


# What is Ansible ad-hoc commands?
- trivial commands that you can directly type in the command-line
- for example you wish to see if ansible controller machine is able to ping ansible nodes
- the tool used is called 'ansible'
- Example:
  ansible -i hosts all -m ping
  ansible -i hosts all -m shell -a hostname 

# What is an Ansible Playbook?
- Ansible Playbook is a YAML file that has declarative automation code
- A Single Playbook may have one or more Play
- Each Play follows a particular structure
- Each Play will target one or more Ansible Nodes
- Each Play will have one or more Tasks
- Each Task can invoke at the most one Ansible Module

