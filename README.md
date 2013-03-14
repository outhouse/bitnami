# Bitnami on EC2

## Provisioning
* Log in to your AWS control panel
* Create instances from the AWS Marketplace: https://aws.amazon.com/marketplace/pp/B0062NF3ME

## Local SSH configuration
Create a file in ~/.ssh/config
```
Host myserver
  User bitnami
  HostName ec2-XX-XX-XX-XX.compute-1.amazonaws.com/
  IdentityFile ~/.ssh/<ssh-key>
```

## Bootstrap script
You should only have to do this once
`ssh myserver "curl https://github.com/outhouse/bitnami | bash"`

## Deploying an app
* Use `mkapp` to scaffold directories and create apache vhost entries
* Copy over your app's files with rsync

```
ssh myserver "sudo mkapp <domain> [alias1] [alias2] ..."
rsync -auvz local/files/ myserver:apps/<domain>/htdocs/
```

## phpMyAdmin
* Create an ssh tunnel `ssh -N -L 9999:127.0.0.1:80 myserver`
* Navigate to localhost:9999/phpmyadmin u: root p: bitnami

## MX record setup for receiving mail for a domain
* Create a subdomain `mail.domain` using an A record to the server's IP
* Create an MX record `domain` with value `1 mail.domain`
