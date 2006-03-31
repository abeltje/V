#!/usr/bin/perl -w
use strict;

# $Id$

BEGIN {
        chdir 't' if -d 't';
        @INC = '../lib';
        require './test.pl';
}
plan tests => 3;

require_ok( 'V' );

ok( $V::VERSION, '$V::VERSION is there' );

my $out = runperl( switches => ['-MV'] );
my( $version ) = $out =~ /^.+?([\d._]+)$/m;

is( $version, $V::VERSION, "Version ok ($version)" );
