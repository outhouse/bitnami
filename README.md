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
`ssh myserver "curl https://raw.github.com/outhouse/bitnami/master/bootstrap.sh | bash"`

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

## Backups and Snapshotting
Snapshots are currently set up to run hourly via cron. See [bitnami-ec2-consistent-snapshot](https://github.com/jessetane/bitnami-ec2-consistent-snapshot) for details.  
To restore a snapshot, follow these steps:  
* Log into the AWS control panel and navigate to ec2 > instances
* Right click the running instance and stop it
* Navigate to ec2 > eb2 > snapshots
* Create a volume from the snapshot you'd like to restore
* Navigate to ec2 > ebs > volumes
* Detach the old volume from the stopped instance
* Attach the new volume created from the snapshot
* Navigate to ec2 > instances
* Restart the instance

## Caching with Varnish
See http://wiki.bitnami.com/Components/Varnish
