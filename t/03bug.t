#! perl
use warnings;
use strict;

# $Id$
use Test::More tests => 2;

BEGIN { $V::NO_EXIT = $V::NO_EXIT = 1 }

require_ok 'V';

my @modules = map {
    s{/}{::}g; s{\.pm$}{};
    $_
} grep /\.pm$/ && ! /^Config\.pm$/ => keys %INC;


my $versions = eval {
    join ", ", map { "$_: " . V::get_version( $_ ) } qw/ Cwd /;
};

is $@, "", "readonly bug";

