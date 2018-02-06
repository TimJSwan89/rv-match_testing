printheader="In libs.sh section: "
sudo apt-get update
sudo apt -y upgrade
sudo apt-key update
sudo apt-get update

#sed -i -e "s/trusty/xenial/g" /etc/apt/sources.list
#apt-get update && apt-get -y dist-upgrade
#sudo dpkg --configure -a

echo $printheader"kcc"
sudo apt -y install libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg
sudo apt -y install libffi-dev

echo $printheader"helloworld" # copied
sudo apt -y install bash
sudo apt -y install gcc
sudo apt -y install build-essential
sudo apt -y install perl
sudo apt -y install git-all

echo $printheader"prepare.sh"
sudo apt -y install bc

echo $printheader"bind9" # copied
sudo apt -y install openssl
sudo apt -y install libssl-dev

echo $printheader"bogosort" # copied
which cpan
cpan YAML
cpan String::Escape
cpan Getopt::Declare
cpan UUID::Tiny

echo $printheader"cFE" # copied
sudo apt -y install cmake
cmake --version
sudo apt -y install libc6
sudo apt -y install libc6-dev
sudo apt -y install libc6-dev-i386
sudo apt -y install g++-multilib

echo $printheader"cineform" # copied
# The following 4 lines installed 3.2.x but cineform needs 3.5.x
#sudo -E add-apt-repository -y ppa:george-edison55/cmake-3.x
#sudo apt-get update
#sudo apt -y upgrade
#sudo apt -y install cmake

# Build takes forever, commented for now
#cmake --version
#strtatdir=$(pwd)
#version=3.10
#build=0
#mkdir ./tempun1qu5ch4ract3r2
#cd tempun1qu5ch4ract3r2/
#wget https://cmake.org/files/v$version/cmake-$version.$build.tar.gz
#tar -xzvf cmake-$version.$build.tar.gz
#cd cmake-$version.$build/
#./bootstrap
#make -j4
#sudo make install
#cmake --version
#cd $strtatdir
#rm -r tempun1qu5ch4ract3r2/

echo $printheader"curl" # copied
#See bind9: sudo apt -y install libssl-dev

echo $printheader"dpkg" # copied
sudo apt -y install autotools-dev
sudo apt -y install dh-autoreconf
sudo apt -y purge gettext
sudo apt-get -y install gettext
gettext --version
apt-cache policy gettext

echo $printheader"FFmpeg" # copied
sudo apt -y install yasm

echo $printheader"hostapd" # copied
sudo apt -y install pkg-config
sudo apt -y install libnl-3-dev
sudo apt -y install libnl-route-3-dev
sudo apt -y install libnl-genl-3-dev

echo $printheader"libpcap" # copied
sudo apt -y install bison
sudo apt -y install flex

echo $printheader"lua" # copied
sudo apt -y install libreadline-dev

echo $printheader"makefs" # copied
sudo apt -y install fuse
sudo apt -y install libfuse-dev

echo $printheader"mawk" # copied
sudo apt -y install apt
apt --version
sudo apt -y dist-upgrade
echo "BEFORE CHANGES"
cat /etc/apt/sources.list
#sed -i -e 's/#deb-src/deb-src/g' /etc/apt/sources.list
sudo echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main restricted' >> /etc/apt/sources.list
echo "AFTER CHANGES"
cat /etc/apt/sources.list

echo $printheader"netdata" # copied
sudo apt -y install zlib1g-dev
sudo apt -y install uuid-dev

echo $printheader"php-src" # copied
ldd --version
apt-cache policy libc6
# See cFE, may fix this, too "configure: error: C compiler cannot create executables": sudo apt install libc6-dev
sudo apt -y install libxml2-dev

echo $printheader"Reptile" # copied
sudo apt -y install linux-generic
sudo apt -y install linux-headers-`uname -r`

echo $printheader"spin" # copied
# See libpcap: sudo apt -y install bison

echo $printheader"tcpdump" # copied
sudo apt -y install libpcap-dev

echo $printheader"tmux" # copied
sudo apt -y install libevent-dev

echo $printheader"vim" # copied
sudo apt -y install ncurses-dev
sudo apt -y install libncurses5-dev
sudo apt -y install libncursesw5-dev
sudo apt -y build-dep vim

echo $printheader"wget" # copied
sudo apt -y install autopoint
sudo apt -y install texinfo
sudo apt -y install gperf
sudo apt -y install libgnutls-dev

echo $printheader"[For any remaining apt kinks...]"
sudo apt update
sudo apt -y upgrade