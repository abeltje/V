package V;
use strict;
# use warnings FATAL => 'all';
# sort of emulation for backward compatibility
$^W = 1; local $SIG{__WARN__} = sub { die $_[0] };

use vars qw( $VERSION $NO_EXIT );
$VERSION  = 0.06;
$NO_EXIT = 0; # prevent import() from exit()ing and fall of the edge

=head1 NAME

V - Print version of the specified module(s).

=head1 SYNOPSIS

    $ perl -MV=V

or if you want more than one

    $ perl -MV=CPAN,V

=head1 DESCRIPTION

This module uses stolen code from C<Module::Info> to find the location 
and version of the specified module(s). It prints them and exit()s.

It defines C<import()> and is based on an idea from Michael Schwern
on the perl5-porters list. See the discussion:

   http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2002-01/msg00760.html

=head1 AUTHOR

20020116 Abe Timmerman <abeltje@cpan.org>

=cut

sub report_pkg($@) {
    my $pkg = shift;

    print "$pkg\n";
    @_ or print "\tNot found\n";
    for my $module ( @_ ) {
        printf "\t%s: %s\n", $module->file, $module->version || '?';
    }
}

sub import {
    shift;
    @_ or push @_, 'V';
 
   for my $pkg ( @_ ) {
        my @modules = V::Module::Info->all_installed( $pkg );
        report_pkg $pkg, @modules;
    }
    exit() unless $NO_EXIT;
}

caller or V->import( @ARGV );

1;

# Okay I did the AUTOLOAD() bit, but this is a Copy 'n Paste job.
# Thank you Michael Schwern for Module::Info! This one is mostly that!

package V::Module::Info;

require File::Spec;

sub new_from_file {
    my($proto, $file) = @_;
    my($class) = ref $proto || $proto;

    return unless -r $file;

    my $self = {};
    $self->{file} = File::Spec->rel2abs($file);
    $self->{dir}  = '';
    $self->{name} = '';

    return bless $self, $class;
}

sub all_installed {
    my($proto, $name, @inc) = @_;
    my($class) = ref $proto || $proto;

    @inc = @INC unless @inc;
    my $file = File::Spec->catfile(split /::/, $name) . '.pm';
    
    my @modules = ();
    foreach my $dir (@inc) {
        # Skip the new code ref in @INC feature.
        next if ref $dir;

        my $filename = File::Spec->catfile($dir, $file);
        if( -r $filename ) {
            my $module = $class->new_from_file($filename);
            $module->{dir} = File::Spec->rel2abs($dir);
            $module->{name} = $name;
            push @modules, $module;
        }
    }
              
    return @modules;
}

# Thieved from ExtUtils::MM_Unix 1.12603
sub version {
    my($self) = shift;

    my $parsefile = $self->file;

    open(MOD, $parsefile) or die $!;

    my $inpod = 0;
    my $result;
    while (<MOD>) {
        $inpod = /^=(?!cut)/ ? 1 : /^=cut/ ? 0 : $inpod;
        next if $inpod || /^\s*#/;

        chomp;
        next unless /([\$*])(([\w\:\']*)\bVERSION)\b.*\=/;
        my $eval = qq{
                      package V::Module::Info::_version;
                      no strict;

                      local $1$2;
                      \$$2=undef; do {
                          $_
                      }; \$$2
        };
        local $^W = 0;
        $result = eval($eval);
        warn "Could not eval '$eval' in $parsefile: $@" if $@;
        $result = "undef" unless defined $result;
        last;
    }
    close MOD;
    return $result;
}

sub accessor {
    my $self = shift;
    my $field = shift;

    $self->{ $field } = $_[0] if @_;
    return $self->{ $field };
}

sub AUTOLOAD {
    my( $self ) = @_;

    use vars qw( $AUTOLOAD );
    my( $method ) = $AUTOLOAD =~ m|.+::(.+)$|;

    if ( exists $self->{ $method } ) {
        splice @_, 1, 0, $method;
        goto &accessor;
    }
}

__END__
