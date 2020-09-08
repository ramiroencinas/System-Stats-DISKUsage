use v6;
use lib 'lib';
use Test;

plan 3;

use System::Stats::DISKUsage;

my %diskUsage = DISK_Usage();

for %diskUsage.sort(*.key)>>.kv -> ($drive, $usage) {

	ok ( $drive ~~ /\w+/ ), "Drive name exists.";
	ok ( $usage<bytesreadpersec> >= 0 ), "Bytes read per second >= 0";
	ok ( $usage<byteswrittenpersec> >= 0 ), "Bytes written per second >= 0";

	last;
}



