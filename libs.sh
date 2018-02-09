printheader="In libs.sh section: "

echo $printheader"pre-flushing apt"
sudo apt-get update
sudo apt -y upgrade
sudo apt-key update
sudo apt-get update

#sed -i -e "s/trusty/xenial/g" /etc/apt/sources.list
#apt-get update && apt-get -y dist-upgrade
sudo dpkg --configure -a

echo $printheader"merged.sh"
sudo apt -y install html-xml-utils

echo $printheader"kcc"
sudo apt -y install libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg
sudo apt -y install libffi-dev

echo $printheader"test.sh common dependencies"
sudo apt -y install bash
sudo apt -y install gcc
sudo apt -y install build-essential
sudo apt -y install perl
sudo apt -y install git-all

echo $printheader"prepare.sh"
sudo apt -y install bc

echo $printheader"post-flushing apt"
sudo apt update
sudo apt -y upgrade

#    which cpan
#    cpan YAML
#    cpan String::Escape
#    cpan Getopt::Declare
#    cpan UUID::Tiny
