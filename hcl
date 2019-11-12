#!/usr/bin/env perl
use v5.14;
use Pod::Usage qw(pod2usage);
use Getopt::Long qw(GetOptions);
use List::Util qw(max);

my %opt;
GetOptions( \%opt, 'help|?', 'command', 'list' ) or pod2usage(2);
pod2usage( -sections => 'NAME|SYNOPSIS|DESCRIPTION|EXAMPLES', -verbose => 99 )
  if $opt{help};

my %handler = (

    charset => [
        'convert to Unicode UTF-8, ignoring non-convertable characters',
        sub {
            my ( $charset, $file ) = @_;
            die "unknown charset $charset\n"
              unless grep { $_ =~ qr{(.+)//$} && $1 eq $charset } split "\n",
              `iconv -l`;

            my @cmd = ( 'iconv', '-sc', '-f', $charset, '-t', 'UTF8//IGNORE' );
            return ( defined $file ? ( @cmd, $file ) : @cmd );
        }
    ],

    unzip => [
        'extract a file from a ZIP archive',
        sub {
        my ( $path, $file ) = @_;
        if ( defined $file ) {
            return 'unzip', '-p', $file, $path;
        }
        else {
            return 'bsdtar', '-xf-', $path;
        }
    }],

    line => [
        'extract line(s) of text',
        sub {
        my $lines = shift;
        die "invalid line(s): $lines\n"
          unless $lines =~ /^(\d+)(,(\d+))?$/ && $1;
        my @cmd = ( 'sed', '-n', $lines . 'p' );
        return @_ ? ( @cmd, @_ ) : ( @cmd, '-' );
    }]

      # TODO RFC 5147 style selection
      # text => sub {
      #    my $position = shift;
      #    die "invalid text position: $position\n" unless
      #        $position =~ /^line=(\d*)(,(\d*))/;
      #    my $from = ($1 ? $1 + 1 : 1);
      #    my $range = $3 ? "$from," . $3 + 1 : $from;
      #    requires Unicode normalization!
      # },

);

if ( $opt{list} ) {
    my $tab = max map { length } keys %handler;
    for (sort keys %handler) {
        printf "%-$tab"."s  %s\n", $_, $handler{$_}->[0];
    }
    exit;
}

pod2usage(2) unless @ARGV;

my $file = -f $ARGV[0] ? shift @ARGV : undef;

my ( $type, $locator ) = @ARGV;

die "missing locator value\n" if !@ARGV or $locator eq "";
my $format = $handler{$type} or die "unknown locator type: $type\n";

my @cmd = defined $file ? $format->[1]->( $locator, $file ) : $format->[1]->($locator);
if ( $opt{command} ) {
    say join ' ', @cmd;    # TODO: shell escape?
}
else {
    exec @cmd;
}

__END__

=head1 NAME

hcl - hypermedia content locator

=head1 SYNOPSIS

hcl [options] [file] <type> <locator>

=head2 OPTIONS

 --help     show documentation
 --command  print selector command instead of executing it
 --list     print list of known locator types

=head1 DESCRIPTION

This command line tool helps to retrieve document segments via content locators.

The source document is read from standard input or from an input file.

See L<https://jakobib.github.io/hypertext2019/> and the poster
L<https://doi.org/10.5281/zenodo.3339295> for theoretical background.

=head1 EXAMPLES

 hcl hyplus.zip unzip link04 | hcl charset CP437 | hcl line 4,8

=cut

