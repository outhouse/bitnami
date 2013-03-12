#!/usr/bin/env bash
#
# mkapp.sh - scaffold up a new app for bitnami
#

BITNAMI_ROOT="/opt/bitnami"

mkapp() {
  
  # vars
  name="$1"
  aliases=("${@:2}")
  dir="$BITNAMI_ROOT"/apps/"$name"
  
  # ensure app doesn't exist
  [ ! -d "$dir" ] && echo "cannot create $name: app exists" >&2 && return 1
  
  # build the requisite dirs
  __mkapp_create_dirs || return 1
  
  # create an apache conf file for our new app
  __mkapp_create_apache_conf || return 1
  
  # edit apache's config file to include our app
  __mkapp_include_apache_conf || return 1
  
  # reload apache with the new app's config
  __mkapp_reload_apache || return 1
}

__mkapp_create_dirs() {
  mkdir -p "$dir"/conf
  mkdir -p "$dir"/htdocs
}

__mkapp_create_apache_conf() {
  vhost="NameVirtualHost *:*
<VirtualHost *:*>
  DocumentRoot $dir/htdocs
  ServerName $1
  <Directory $dir/htdocs>
    Options +FollowSymLinks
    AllowOverride None
    <IfVersion < 2.3 >
    Order allow,deny
    Allow from all
    </IfVersion>
    <IfVersion >= 2.3>
    Require all granted
    </IfVersion>
  </Directory>
</VirtualHost>"
}

__mkapp_include_apache_conf() {
  echo "Include "
}

__mkapp_reload_apache() {
  
}

# main
mkapp "$@"
