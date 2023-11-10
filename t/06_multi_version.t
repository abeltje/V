#! perl -I. -w
use t::Test::abeltje;

plan skip_all => "This perl is not >= 5.12.0" if $] < 5.012;

use Cwd 'abs_path';
use File::Spec::Functions;

require_ok('V');

{
    my $version = V::get_version("GH::Issue1");

    is($version, '1.3', "Find specific version");

}

{
    my $stdout;
    {
        no warnings 'once';
        local *STDOUT;
        open(*STDOUT, '>>', \$stdout);
        local $V::NO_EXIT = 1;
        local @INC = 't/lib';
        V->import('GH::Issue1');
    }

    is($stdout, <<"EOT", "All packages in output") or diag("STDOUT: $stdout");
GH::Issue1
\t@{[canonpath(catfile(abs_path('.'), qw<t lib GH Issue1.pm>))]}:
\t    main: 1.1
\t    Foo: 1.2
\t    GH::Issue1: 1.3
EOT
}

abeltje_done_testing();
