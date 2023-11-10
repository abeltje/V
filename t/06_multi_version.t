#! perl -I. -w
use t::Test::abeltje;

plan skip_all => "This perl is not >= 5.12.0" if $] < 5.012;

{
    require_ok('V');

    my $version = V::get_version("GH::Issue1");

    is($version, '1.3', "Find specific version");
}

abeltje_done_testing();
