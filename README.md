# bitnami on EC2

## Provisioning a Bitnami server
* Log in to your AWS control panel
* Create an instance in your desired location with your desired ssh key from the image: ami-7b9f0b12

## Local SSH configuration
Create a file in ~/.ssh/config
```
Host myserver
	User bitnami
  HostName http://ec2-XX-XX-XX-XX.compute-1.amazonaws.com/
	IdentityFile ~/.ssh/<ssh-key>
```

## Accessing phpMyAdmin
* Create an ssh tunnel `ssh -N -L 8000:127.0.0.1:80 -i ~/.ssh/<ssh-key> bitnami@ec2-XX-XX-XX-XX.compute-1.amazonaws.com`
* Navigate to localhost:8000/phpmyadmin u: root p: bitnami

## Deploying an app