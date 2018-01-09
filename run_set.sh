#!/bin/bash
currentscript="run_set.sh"
exportfile="report"
flagsfortests=""
while getopts ":rsa" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        flagsfortests=" -r"
      ;;
    s ) echo $currentscript" status option selected."
        echo "Nothing implemented."
      ;;
    a ) echo $currentscript" acceptance option selected."
        exportfile="acceptance"
        flagsfortests=" -a"
      ;;
    \? ) echo $currentscript" usage: cmd [-r] [-s] [-a]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
      ;;
  esac
done

filepath=$1
if [ ! -e filepath ] ; then
    filepath=$2
fi
file=$(basename $filepath)
setfolder=$(basename $(dirname $filepath))"/"
echo "filepath is: "$filepath
echo "file is    : "$file
echo "folder is  : "$setfolder
allpath=$setfolder"_generated_all.ini"
blacklist_indicator="BLACKLIST"
filename=${file%.*}
blacklist_check=$(head -n 1 $filepath)
echo "First line of file: "$blacklist_check
echo "Name without extension: "$filename
echo "=============="
whitelistpath=$filepath
if [ $blacklist_check == $blacklist_indicator ]; then
    bash generate_run_set.sh
    whitelistpath=$setfolder"_generated_"$filename"_whitelist.ini"
    touch $whitelistpath
    grep -f $filepath -v -F -x $allpath > $whitelistpath
fi
mkdir results/
ls
full_report=$(pwd)"/results/$exportfile.xml"
echo "full report:"$full_report
echo '<?xml version="1.0" encoding="UTF-8"?>
<testsuites>
<testsuite name="ReportScriptReport" package="ReportPackage">
<properties/>' > $full_report
while read line; do
  if [ -e /mnt/jenkins/tests/$line/test.sh ] ; then
    # Branch is meant to run iff there is containerization.
    mkdir -p tests/$line/
    cp /mnt/jenkins/tests/$line/test.sh tests/$line/test.sh
  fi
  echo ==== $line started at $(date)
  bash "tests/$line/test.sh$flagsfortests"
  cat "tests/$line/$exportfile.xml" >> $full_report
  echo ==== $line finished at $(date)
done < $whitelistpath
echo '</testsuite>
</testsuites>
' >> $full_report


echo "DEBUG run_set.sh"
cat $full_report
echo "END DEBUG run_set.sh"

bash status.sh $filepath
