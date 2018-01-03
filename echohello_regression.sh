#!/bin/bash
echo "Hello, world from "$(pwd)
#find . -type d

# Part 1 Network Test
echo " === Network testing. === "
ping -c 1 www.google.com

# Part 2 Configure Local Jenkins Dependencies
#  2a Copy project scripts
hostspace="/mnt/jenkins"
mkdir -p tests/helloworld/
touch tests/helloworld/test.sh
cd $hostspace
cp tests/helloworld/test.sh /root/tests/helloworld/test.sh
cp run_regression_set.sh /root/run_regression_set.sh
mkdir /root/sets/
cp -r sets/* /root/sets/
echo " === These are what is in the sets directory: "
ls /root/sets/
cp prepare_regression.sh /root/prepare_regression.sh
cp libs.sh /root/libs.sh
cd /root/
echo " == Should be the same "
ls sets/

#  2b Set kcc dependencies
export PATH=$hostspace/kcc_dependency_1:$hostspace/kcc_dependency_2:$hostspace/kcc_dependency_3/bin:$PATH
echo "New guest path: "$PATH

# Part 3 Install Libraries (apt install etc.)
bash libs.sh

# Part 4 Run Main Script
bash run_regression_set.sh sets/regression.ini
#bash tests/getty/test.sh
# Part 5 Copy test result xml back to host
ls
ls results/
cat results/regression.xml
echo "Copying results here: "
cp results/regression.xml $hostspace/results/