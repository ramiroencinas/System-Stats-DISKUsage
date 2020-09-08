# System::Stats::DISKUsage
[![Build Status](https://travis-ci.com/ramiroencinas/System-Stats-DISKUsage.svg?branch=master)](https://travis-ci.com/github/ramiroencinas/System-Stats-DISKUsage)

Raku module - Provides Disk Usage Stats.

## OS Supported: ##
* GNU/Linux (Kernel 2.6+) by /proc/diskstats

## Installing the module ##

    zef update
    zef install System::Stats::DISKUsage

## Example Usage: ##

```raku 
use v6;
use System::Stats::DISKUsage;

my %diskUsage = DISK_Usage();

say "\nDisk Usage per second:\n";
say "Drive BytesRead BytesWritten\n";

for %diskUsage.sort(*.key)>>.kv -> ($drive, $usage) {

	printf "%-5s %-9d %-d\n", $drive, $usage<bytesreadpersec>, $usage<byteswrittenpersec>;	

}
```

## TODO: ##
* Win32 version.