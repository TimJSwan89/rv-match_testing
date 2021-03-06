#! /usr/bin/env perl

# Obtained from Chris Hathhorn
# March 28 2018
#   categorize.sh
#   fetch.sh
#   juliet.pl
# > runner.pl

use strict;
use Time::HiRes qw(gettimeofday tv_interval);
use File::Basename;
use feature qw(say);

my $_timer = [gettimeofday];
my $pid = 0;

# good
#bench("juliet/one_test");
#bench("juliet/filtered_tests");

#jtesting2/juliet$ mkdir good_c_files
#jtesting2/juliet$ find good -name \*.c -exec cp {} good_c_files \;
#bench("juliet/good_c_files");
bench("juliet/allc");
# bench("testcases/CWE121_Stack_Based_Buffer_Overflow");
# bench("testcases/CWE122_Heap_Based_Buffer_Overflow");
# bench("testcases/CWE124_Buffer_Underwrite");
# bench("testcases/CWE126_Buffer_Overread");
# bench("testcases/CWE127_Buffer_Underread");
# bench("testcases/CWE131_Incorrect_Calculation_Of_Buffer_Size");
# bench("testcases/CWE170_Improper_Null_Termination");
# bench("testcases/CWE193_Off_by_One_Error");
# bench("testcases/CWE369_Divide_By_Zero");
# bench("testcases/CWE562_Return_Of_Stack_Variable_Address");
# bench("testcases/CWE590_Free_Of_Invalid_Pointer_Not_On_The_Heap");
# bench("testcases/CWE665_Improper_Initialization");
# bench("testcases/CWE680_Integer_Overflow_To_Buffer_Overflow");
# bench("testcases/CWE685_Function_Call_With_Incorrect_Number_Of_Arguments");
# bench("testcases/CWE688_Function_Call_With_Incorrect_Variable_Or_Reference_As_Argument");
# bench("testcases/CWE761_Free_Pointer_Not_At_Start_Of_Buffer");
# bench("testcases/CWE457_Use_of_Uninitialized_Variable");
# bench("testcases/CWE469_Use_Of_Pointer_Subtraction_To_Determine_Size");
# bench("testcases/CWE758_Undefined_Behavior");

# not catching memcpy bugs
# bench("testcases/CWE475_Undefined_Behavior_For_Input_to_API");

# weird
# bench("testcases/CWE369_Divide_By_Zero"); # their rand has overflow :/

my %seenFilenames = ();

sub bench {
      my ($dir) = (@_);
      opendir (DIR, $dir) or die $!;
      unlink "nono.txt" or warn "Could not unlink nono: $!";
      unlink "noyes.txt" or warn "Could not unlink noyes: $!";
      unlink "yesno.txt" or warn "Could not unlink yesno: $!";
      unlink "yesyes.txt" or warn "Could not unlink yesyes: $!";
      unlink "timeout.txt" or warn "Could not unlink timeout: $!";
      unlink "strange.txt" or warn "Could not unlink strange: $!";
      open(my $fd_nono, ">>nono.txt");
      open(my $fd_noyes, ">>noyes.txt");
      open(my $fd_yesno, ">>yesno.txt");
      open(my $fd_yesyes, ">>yesyes.txt");
      open(my $fd_timeout, ">>timeout.txt");
      open(my $fd_strange, ">>strange.txt");
      my $counter = 0;
      while (my $file = readdir(DIR)) {
            next if !($file =~ m/\.c$/);
            my ($baseFilename, $dirname, $suffix) = fileparse($file, ".c");
            # print "$baseFilename\n";
            if ($baseFilename =~ /^(.*)[a-z]$/) {
                  my $rootFilename = $1;
                  # print "root filename = $rootFilename\n";
                  if ($seenFilenames{$rootFilename}) { next; }
                  # print "root file name unseen\n";
                  $seenFilenames{$rootFilename} = 1;
                  $file = "$rootFilename*.c";
            }
            my $filename = "$dir/$file";
            $counter++;
            print "$file\n";
            $_timer = [gettimeofday];
            print "Commencing test of $filename...\n";
#            print "Testing GOOD:\n";
            my ($g, $gr) = test($file, $filename, '-DOMITBAD');
            $_timer = [gettimeofday];
#            print "Testing  BAD:\n";
            my ($b, $br) = test($file, $filename, '-DOMITGOOD');
            if (index("$br$gr", 'TIMEOUT') != -1) {
#                printf("-> timedout\n");
                print $fd_timeout "$file {Good: $gr, Bad: $br}\n" or warn "Can't print to timeout: $!";
            } elsif ($br == "1" || $gr == "1" || $br == "2" || $gr == "2") {
#                printf("-> Strange: [$gr] [$br]\n");
                print $fd_strange "$file {Good: $gr, Bad: $br}\n" or warn "Can't print to strange: $!";
            } else {
            if ($g) {
#                printf("-> good no\n");
                if ($b) {
#                    printf("-> bad no\n");
                    # kcc didn't find UB
                    print $fd_nono "$file {Good: $gr, Bad: $br}\n" or warn "Can't print to nono: $!";
                } else {
#                    printf("-> bad yes: %-10s\n", $br);
                    # Happens in the normal case
                    print $fd_noyes "$file {Good: $gr, Bad: $br}\n" or warn "Can't print to noyes: $!";
                }
            } else {
#                printf("-> good yes: %-10s\n", $gr);
                if ($b) {
#                    printf("-> bad no\n");
                    # Very strange case, UB only found in "good" version
                    print $fd_yesno "$file {Good: $gr, Bad: $br}\n" or warn "Can't print to yesno: $!";
                } else {
#                    printf("-> bad yes: %-10s\n", $br);
                    # kcc also found error in test code
                    print $fd_yesyes "$file {Good: $gr, Bad: $br}\n" or warn "Can't print to yesyes: $!";
                }
            }
            }
            system("/bin/bash summary.sh");
      }
      print "total projects: $counter";
      closedir(DIR);
}

sub test {
      my ($testname, $filename, $flag) = (@_);
      my $tool = 'kcc';
      #print "Using \"$tool\"\n";

      my ($signal, $retval, $output, $stderr) = run("./juliet.pl $tool $flag \"$filename\"");

      if ($signal) {
            return report($testname, $tool, '256', "Failed to run normally: signal $signal");
      }
      if ($retval) {
            return report($testname, $tool, $output, "Failed to detect error: retval $retval");
      }
      return report($testname, $tool, $output);

}

sub report {
      my ($test, $name, $result, $msg) = (@_);
      my $elapsed = tv_interval($_timer, [gettimeofday]);
      printf("%-74s\t%-10s\t%.3f\t%s\n", $test, $result, $elapsed, $msg);
      return ($result eq "(no errors)", $result)
}

sub run {
      my ($theircommand) = (@_);

      my $command = "$theircommand 1>stdout.txt 2>stderr.txt";
#      print " --------- running $command\n";
      my $pid = open(my $pipe, "$command |") or die "Error running \"$command\"!\n";
#      print " -------- closing\n";
      unless (close($pipe)) {
           ;
#          print "ERROR: Cannot close pipe to iostat process: $! $?\n" if $! != 0 || $? != 9;
      }
#      print " -------- closed!\n";
      # my $retval = $? >> 8;
      my $retval = 0;
      if ($? == -1) {
            # print "failed to execute: $!\n";
            $retval = -1;
      } else {
            # printf "child exited with value %d\n", $? >> 8;
            $retval = $? >> 8;
      }
      my $signal = ($? & 127);

      open FILE, "stdout.txt" or die "Couldn't open file: $!"; 
      my $stdout = join("", <FILE>); 
      close FILE;
      open FILE, "stderr.txt" or die "Couldn't open file: $!"; 
      my $stderr = join("", <FILE>); 
      close FILE;
      kill('SIGTERM', $pid);
      $pid = 0;
      return ($signal, $retval, $stdout, $stderr);
}
