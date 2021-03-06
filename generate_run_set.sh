#!/bin/bash

# Get a list of all projects
allfile="sets/_generated_all.ini"
rm $allfile
touch $allfile
for x in tests/*/test.sh
do
    test_name=$(basename $(dirname $x))
    echo $test_name >> $allfile
done

# Find untracked match projects
untrackedfile="sets/_generated_untracked.ini"
temp1="sets/.temp1.ini"
temp2="sets/.temp2.ini"
rm $untrackedfile
comm -23 <(sort $allfile) <(sort sets/acceptance.ini) > $temp1
comm -23 <(sort $temp1) <(sort sets/regression.ini) > $temp2
comm -23 <(sort $temp2) <(sort sets/regression_extended.ini) > $temp1
comm -23 <(sort $temp1) <(sort sets/acceptance_extended.ini) > $temp2
comm -23 <(sort $temp2) <(sort sets/gcc_only.ini) > $untrackedfile
rm $temp1
rm $temp2

# Find untracked predict projects
p_untrackedfile="sets/_generated_p_untracked.ini"
rm $p_untrackedfile
comm -23 <(sort $allfile) <(sort sets/predict_regression.ini) > $temp1
comm -23 <(sort $temp1) <(sort sets/predict_acceptance.ini) > $temp2
comm -23 <(sort $temp2) <(sort sets/predict_acceptance_extended.ini) > $temp1
comm -23 <(sort $temp1) <(sort sets/gcc_only.ini) > $p_untrackedfile
rm $temp1
rm $temp2
p_trackedfile="sets/_generated_p_tracked.ini"
comm -23 <(sort $allfile) <(sort $p_untrackedfile) > $p_trackedfile

rm sets/sort-by-project.txt
for x in tests/*/test.sh
do
    test_name=$(basename $(dirname $x))
    append="$test_name"$'\t\t'" "
    append="$append$(sed '/^_/d' <(grep -oP '(?<=sets/).*?(?=.ini)' <(grep -r "$test_name" ./sets/)))"
    echo $append >> sets/sort-by-project.txt
done
