#! usr/bin/perl -w
use strict;

# $Id$

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'V',
    VERSION_FROM       => 'V.pm',
    PREREQ_PM          => { 'Test::More' => 0  },

    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
        (ABSTRACT_FROM => 'V.pm',
         AUTHOR        => 'Abe Timmerman <abeltje@cpan.org>') : ()
    ),
);
