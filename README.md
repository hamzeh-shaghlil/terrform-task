# Exersices 2
This project uses Terrraform script to providion resources:

• An EC2 instance of type t2.micro based on a Debian Stretch Image.
• A Loadbalancer forwarding incoming requests to the EC2 instance.

The EC2 instance runs an Nginx webserver serving one HTML file (index.html cloned from a Github repo). The Nginx is a Docker container started on the EC2 instance (DockerFile cloned from a GitHub repo).

## main.tf

This Terraform script is used to provision AWS infrastructure based on the region variable.

Inputs:

## userdata.sh

**This shell script is used to bootstrap the EC2 instance, including the following steps:**

1. Install packages to allow apt to use a repository over HTTPS:
2.Add Docker’s official GPG key:
3.Add Docker repository to the system
4.Update the apt package index.
5.Install the latest version of Docker CE 
Clone repository data from My Github account into the server (DockerFile and index.html)
Sudo git clone htps://github.com/hamzehsh/terrform-task.git /home/admin/repo
Build docker-image using  the docker-file that we cloned from the GitHub repository
Run Docker container  using webserver-image:v1 image on port 80


## main.tf


```python
import foobar

foobar.pluralize('word') # returns 'words'
foobar.pluralize('goose') # returns 'geese'
foobar.singularize('phenomena') # returns 'phenomenon'
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)
