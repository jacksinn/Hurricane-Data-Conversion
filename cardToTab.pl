#!/usr/bin/perl
use Cwd;

sub trim($);

open INPUT,"tracks1851to2010_atl_2011rev.txt";
open PARENT, ">delim_data/storm_info.tab";
open DAYS, ">delim_data/day_data.tab";
open FINAL, ">delim_data/final_data.tab";
open R1, ">r/r1.R";

$max_days = 0;
$num_days = 0;
$parent_id = 0;

$dir = getcwd;

#PRINTING COLUMN HEADERS FOR R
print PARENT "seq_num\tmonth\tday\tyear\tstorm_num_days\tstorm_num_this_year\tstorm_num_cumul\tstorm_name\thit_us\tsss\tlast_storm_of_year\t\n";
print DAYS "seq_num\tparent_seq_num\tmonth\tday\tstorm_type_0000z\tlat_0000z\tlon_0000z\twind_0000z\tpressure_0000z\tstorm_type_0600z\tlat_0600z\tlon_0600z\twind_0600z\tpressure_0600z\tstorm_type_1200z\tlat_1200z\tlon_1200z\twind_1200z\tpressure_1200z\tstorm_type_1800z\tlat_1800z\tlon_1800z\twind_1800z\tpressure_1800z\t\n";
print FINAL "seq_num\tparent_seq_num\tmax_status\t\n";

print R1 'si <- read.csv("' . $dir . '/delim_data/storm_info.tab",sep="\t",head=TRUE)
names(si)
pdf("' . $dir . '/r/plots.pdf")
plot(si$storm_num_days,si$year,xlab="Number of days in Storm",ylab="Year")
plot(si$year,si$storm_num_this_year,xlab="Year",ylab="Number of Storms")
plot(si$sss,si$year,xlab="Severity of Storm",ylab="Year")
barplot(table(si$year)) #storms per year
barplot(table(si$month)) #storms per month
dev.off()
';

while($line = <INPUT>){
	chomp($line);
	$line =~ s/\x0D//g; #strips ^M characters
	
	#GRABBING THE MAIN LINE
	if($line =~ m/SSS=/){
		#GETTING DATA
		@parent_data = ();
		push(@parent_data, trim(substr $line, 0, 5));	#card sequence number
		push(@parent_data, trim(substr $line, 6, 2)); 	#month
		push(@parent_data, trim(substr $line, 9, 2));	#day
		push(@parent_data, trim(substr $line, 12, 4));	#year
		push(@parent_data, trim(substr $line, 19, 2)); 	#M
		push(@parent_data, trim(substr $line, 22, 2));	#storm number
		push(@parent_data, trim(substr $line, 30, 4));	#cumulative storm number
		push(@parent_data, trim(substr $line, 35, 12)); #storm name
		push(@parent_data, trim(substr $line, 52, 1));	#crossing
		push(@parent_data, trim(substr $line, 58, 1)); 	#SSS
		push(@parent_data, trim(substr $line, 79, 1));	#LAST STORM OF YEAR
		
		#OUT TO FILE
		foreach $pd (@parent_data){
			print PARENT $pd . "\t";
		}
		print PARENT "\n";
		##how many days of records follow
		$num_days = $max_days = $parent_data[4];
		$parent_id = $parent_data[0];
		#print $num_days . "::" . $max_days . "\n";
	}
	
	#DAY DATA
	if($num_days < $max_days && $num_days >= 0){
		#GETTING DATA
		@day_data = ();
		push(@day_data, trim(substr $line, 0, 5));	#card sequence number
		push(@day_data, $parent_id);				#parent_id
		push(@day_data, trim(substr $line, 6, 2));	#month
		push(@day_data, trim(substr $line, 9, 2));	#day
		push(@day_data, trim(substr $line, 11, 1));	#Storm Type at 0000Z
		push(@day_data, trim(substr $line, 12, 3));	#Latitude at 0000Z
		push(@day_data, trim(substr $line, 15, 4));	#Longitude at 0000Z
		push(@day_data, trim(substr $line, 20, 3));	#Wind at 0000Z
		push(@day_data, trim(substr $line, 24, 4));	#Central Pressure at 0000Z
		push(@day_data, trim(substr $line, 28, 1));	#Storm Type at 0600Z
		push(@day_data, trim(substr $line, 29, 3));	#Latitude at 0600Z
		push(@day_data, trim(substr $line, 32, 4));	#Longitude at 0600Z
		push(@day_data, trim(substr $line, 37, 3));	#Wind at 0600Z
		push(@day_data, trim(substr $line, 41, 4));	#Central Pressure at 0600Z
		push(@day_data, trim(substr $line, 45, 1));	#Storm Type at 1200Z
		push(@day_data, trim(substr $line, 46, 3));	#Latitude at 1200Z
		push(@day_data, trim(substr $line, 49, 4));	#Longitude at 1200Z
		push(@day_data, trim(substr $line, 54, 3));	#Wind at 1200Z
		push(@day_data, trim(substr $line, 58, 4));	#Central Pressure at 1200Z
		push(@day_data, trim(substr $line, 62, 1));	#Storm Type at 1800Z
		push(@day_data, trim(substr $line, 63, 3));	#Latitude at 1800Z
		push(@day_data, trim(substr $line, 66, 4));	#Longitude at 1800Z
		push(@day_data, trim(substr $line, 71, 3));	#Wind at 1800Z
		push(@day_data, trim(substr $line, 75, 4));	#Central Pressure at 1800Z
		
		#OUT TO FILE
		foreach $dd (@day_data){
			print DAYS $dd . "\t";
		}
		print DAYS "\n";
	}
	
	#FINAL DATA
	if($num_days == -1){
		#GETTING DATA
		@final_data = ();
		push(@final_data, trim(substr $line, 0, 5));	#card sequence number
		push(@final_data, $parent_id);				#parent_id
		push(@final_data, trim(substr $line, 6, 2));	#maximum status
		
		#OUT TO FILE
		foreach $fd (@final_data){
			print FINAL $fd . "\t";
		}
		print FINAL "\n";
	}
	
	$num_days--;
}
#print "TOTAL RECORDS: " . $count . "\n";

close INPUT;
close PARENT;
close DAYS;
close FINAL;
close R1;

# Perl trim function to remove whitespace from the start and end of the string
sub trim($){
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
