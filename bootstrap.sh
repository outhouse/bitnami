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
echo "-- scaffolding directories --"
mkdir -p "$bin"
mkdir -p "$lib"
mkdir -p "$src"

# system packages
echo "-- installing system packages --"
sudo apt-get update
sudo apt-get install git -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install postfix -y

# custom packages
echo "-- installing custom packages --"
cd "$src"
git clone https://github.com/jessetane/argue
git clone https://github.com/jessetane/bitnami-mkapp
git clone https://github.com/jessetane/ubuntu-email
git clone https://github.com/jessetane/httpcat

# generate builds
echo "-- building custom packages --"
cd "$lib"
mkdir argue         && ln -s ../../src/argue ./argue/0.0.1
mkdir bitnami-mkapp && ln -s ../../src/bitnami-mkapp ./bitnami-mkapp/current
mkdir ubuntu-email  && ln -s ../../src/ubuntu-email ./ubuntu-email/current
mkdir httpcat       && ln -s ../../src/httpcat ./httpcat/current

# link executables
echo "-- linking custom executables --"
echo "exec $lib/bitnami-mkapp/current/bin/mkapp" '"$@"' > "$bin"/mkapp && chmod +x "$bin/"mkapp
echo "exec $lib/ubuntu-email/current/bin/email" '"$@"' > "$bin"/email && chmod +x "$bin/"email
echo "exec $lib/httpcat/current/bin/httpcat" '"$@"' > "$bin"/httpcat && chmod +x "$bin/"httpcat

# bash profile
echo "-- configuring bash profile --"
cd

# these should work even for non-interactive shells
echo "export PATH=\"$bin:\$PATH\"" >> temp
echo 'function l { ls -alhBi --group-directories --color "$@"; }' >> temp
cat .bashrc >> temp
cat temp > .bashrc
rm temp

# these are interactive only
PS1='\u@\h:\w\$(git branch 2> /dev/null | grep -e '\''\* '\'' | sed '\''s/^..\(.*\)/ {\1}/'\'')\$ '
echo "export PS1=\"$PS1\"" >> .bashrc
echo "unalias l" >> .bashrc
