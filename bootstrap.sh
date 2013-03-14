#
# outhouse/bitnami - cloud init script
#

# fail fast
set -e

# vars
home="/home/bitnami"
bin="$home/bin"
lib="$home/lib"
src="$home/src"

# scaffold
mkdir -p "$bin"
mkdir -p "$lib"
mkdir -p "$src"

# system packages
sudo apt-get install git -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install postfix -y

# custom packages
cd "$src"
git clone https://github.com/jessetane/argue
git clone https://github.com/jessetane/bitnami-mkapp
git clone https://github.com/jessetane/ubuntu-email
git clone https://github.com/jessetane/httpcat

# generate builds
cd "$lib"
mkdir argue         && ln -s ../src/argue ./argue/0.0.1
mkdir bitnami-mkapp && ln -s ../src/bitnami-mkapp ./bitnami-mkapp/current
mkdir ubuntu-email  && ln -s ../src/ubuntu-email ./ubuntu-email/current
mkdir httpcat       && ln -s ../src/httpcat ./httpcat/current

# link executables
echo "echo $lib/bitnami-mkapp/current/bin/mkapp" '"$@"' > "$bin"/mkapp
echo "echo $lib/ubuntu-email/current/bin/email" '"$@"' > "$bin"/email
echo "echo $lib/httpcat/current/bin/httpcat" '"$@"' > "$bin"/httpcat