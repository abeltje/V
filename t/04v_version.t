#! perl -w
use strict;
use Test::More;

BEGIN { $V::NO_EXIT = $V::NO_EXIT = 1 }
require_ok 'V';

use lib 't/lib';

my $version = V::get_version('V_Version');

is($version, "v1.2.3", "Got version: $version");

done_testing();
