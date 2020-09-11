use v6;

unit module System::Stats::DISKUsage;

sub DISK_Usage ( ) is export {

	# https://www.kernel.org/doc/Documentation/iostats.txt

	fail 'Linux Kernel not supported, must be 2.6+' unless supported_linux_kernel();

	my @drives;

	# Getting block drives (hard disks) in @drives array
	for (dir '/sys/block') {
			@drives.push($_.basename) unless $_.basename ~~ /loop\d+/;
	}

	# Getting stats for each drive with shot_linux() function in %shot1 hash.
	# Wait 1 second and getting again the same stats in %shot2 hash.
	my %shot1 = shot_linux( @drives );
	sleep 1;
	my %shot2 = shot_linux( @drives );

	my %ret;

	# Getting the difference between the two shots stats for each drive.
	# Writes bytes read per second and bytes written per second in %ret hash for each drive.
	for @drives -> $drive {

		my %s1 = %shot1<<$drive>>.kv;
		my %s2 = %shot2<<$drive>>.kv;

		%ret<<$drive>> = {
			bytesreadpersec    => %s2<bytesread> - %s1<bytesread>,
			byteswrittenpersec => %s2<byteswritten> - %s1<byteswritten>
		}	
	}

	return %ret;
}

sub shot_linux( @drives ) {	

	# https://github.com/torvalds/linux/blob/6f0d349d922ba44e4348a17a78ea51b7135965b1/include/linux/types.h#L125
	my $blocksize = 512;

	my $sourcefile = '/proc/diskstats';

	my %ret;

	# Reading disktats line by line and extracts the stats for each drive.
	# Get the sectors read (field 5) and sectors written (field 9)
	# The sectors must be multiplied by $blocksize (512) to produce bytes.
	# Writes bytes reads and bytes written in %ret hash for each drive.
	for $sourcefile.IO.open.lines -> $line {	

		for @drives -> $drive {		
			
			if $line ~~ /$drive\s/ { 				

				%ret<<$drive>> = {
					bytesread    => $line.words[5].Int * $blocksize,
					byteswritten => $line.words[9].Int * $blocksize
				}
			}
	  }
	}	

	return %ret;
	
}

sub supported_linux_kernel ( ) {

	# Checks the minimum Kernel version supported (2.6+)
	
	my $rel = $*KERNEL.release ~~ /^$<ver>=\d+\.\d+/ or fail 'Cannot parse current Kernel release';

        return True if $rel<ver>.Int >= 2.6;
	return False;

}

