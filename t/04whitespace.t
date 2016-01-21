#! perl -w
use strict;

use Test::More tests => 3;
use Test::NoWarnings;

BEGIN { $V::NO_EXIT = $V::NO_EXIT = 1 }

require_ok('./V.pm');

{
    my $stdout;
    {
        local *STDOUT;
        open STDOUT, '>', \$stdout;
        V->import("\n   V");
    }
    note($stdout);
    like(
        $stdout,
        qr/$V::VERSION/,
        "No Warnings in output"
    );
}
