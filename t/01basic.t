#!/usr/bin/perl -w
use strict;

BEGIN { -d 't' and chdir 't'; }

# t/lib should contain Test::More although you
# probably already have it for Module::Info
use lib 'lib';

use Test::More tests => 3;

require_ok( 'V' );

ok( $V::VERSION, '$V::VERSION is there' );

SKIP: {
    local *PIPE;
    skip( "Could not fork: $!", 1 ) 
        unless open PIPE, "$^X -Mblib -MV |";

    my $out = do { local $/; <PIPE> };
    
    skip( "Error in pipe: $! [$?]", 1 )
        unless close PIPE;

    my( $version ) = $out =~ /^.+?([\d._]+)$/m;

    is( $version, $V::VERSION, "Version ok ($version)" );
}

__END__
