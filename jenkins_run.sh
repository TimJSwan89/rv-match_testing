#!/bin/bash
exportfile="report"
currentscript="jenkins_run.sh"
containerscriptflags=" -"
while getopts ":rsatdg" opt; do
  case ${opt} in
    r ) echo $currentscript" regression option selected."
        exportfile="regression"
        containerscriptflags=$containerscriptflags"r"
      ;;
    s ) echo $currentscript" status option selected."
        exportfile="status"
        containerscriptflags=$containerscriptflags"s"
      ;;
    a ) echo $currentscript" acceptance option selected."
        exportfile="acceptance"
        containerscriptflags=$containerscriptflags"a"
      ;;
    t ) echo $currentscript" unittest option selected."
        containerscriptflags=$containerscriptflags"t"
      ;;
    d ) echo $currentscript" git development checkout option selected."
        containerscriptflags=$containerscriptflags"d"
      ;;
    g ) echo $currentscript" gcc option selected."
        containerscriptflags=$containerscriptflags"g"
      ;;
    \? ) echo "Usage: cmd [-r] [-s] [-a] [-t] [-d] [-g]"
         echo " -r regression"
         echo " -s status"
         echo " -a acceptance"
         echo " -t unit tests"
         echo " -d container uses development"
         echo " -g gcc only"
      ;;
  esac
done
if [ $containerscriptflags == " -" ] ; then
    containerscriptflags=""
fi

back_dir="$(pwd)" ; cd rv-match/k/ ; mvn package ; cd "$backdir"

#bash copy_kcc_from_rv-match-master_to_jenkins_workspace.sh
if [ ! -f results/$exportfile.xml ] ; then
    touch results/$exportfile.xml
fi
chmod a+rw results/$exportfile.xml
#ls -la results/
bash container_run.sh$containerscriptflags
