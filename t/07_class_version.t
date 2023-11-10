#! perl -I. -w
use t::Test::abeltje;

{
    require_ok('V');

    my $version = V::get_version("GH::ClassIssue1");

    is($version, '0.42', "Class also works");
}

abeltje_done_testing();
