#!/usr/bin/perl
  use strict;
  use Getopt::Std;
  use vars qw($opt_r);

  getopts('r:');

  # extract the value for the last day (my polling time is 10)
  my @values = `rrdtool fetch /usr/local/share/cacti/rra/metro_e_-_plsew01-mac_traffic_in_7318.rrd AVERAGE -s 1298908800 -e 1301587140`; 
 
  my $MAX_in = 0;
  my $AVG_in = 0;
  my $MAX_out = 0;
  my $AVG_out = 0;
  my $first_time = 0;
  my $last_time = 0;
  my $time_max_in = 0;
  my $time_max_out = 0;
  
  foreach my $value (@values)
  {
    my ($cur_time , $cur_AVG_in, $cur_AVG_out) = {0,0,0};
   
    ($cur_time , $cur_AVG_in, $cur_AVG_out) = split(" ", $value);
   
    $cur_time =~ s/://;
   
    if ( $cur_time <= 0 || $cur_AVG_in eq "nan" || $cur_AVG_out eq "nan" ) {
      print "value (value error) : $value\n\n";
      next;
    }
   
    if ( $first_time == 0) {
      $first_time = $cur_time;
      $last_time = $cur_time;
      next;
    }
  
    $AVG_in += $cur_AVG_in*8*($cur_time - $last_time);
    $AVG_out += $cur_AVG_out*8*($cur_time - $last_time);
   
    if ( $cur_AVG_in*8 > $MAX_in )
    {
      $MAX_in = $cur_AVG_in*8;
      $time_max_in = $cur_time;
    }
 
    if ( $cur_AVG_out*8 > $MAX_out )
    {
      $MAX_out = $cur_AVG_out*8;
      $time_max_out = $cur_time;
    }
   
    $last_time = $cur_time;
  }
 
 
  print "total in : $AVG_in\n";
  print "total out : $AVG_out\n";
  $AVG_in = $AVG_in / ( $last_time - $first_time );
  $AVG_out = $AVG_out / ( $last_time - $first_time );     
 
   
  print "result from $first_time to $last_time (".($last_time - $first_time).") \n";
  print "AVG_in = $AVG_in MAX_in = $MAX_in ($time_max_in)\n";
  print "AVG_out = $AVG_out MAX_out = $MAX_out ($time_max_out)\n";
