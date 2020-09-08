use v6;
use lib 'lib';
use Test;

plan 2;

use System::Stats::DISKUsage;
ok 1, "use System::Stats::DISKUsage worked!";
use-ok 'System::Stats::DISKUsage';