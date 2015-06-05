use strict;
exit;
my $INFO = "Library/REAPER_FRAMEWORK/REVISION.h";
exit if ! (-x "/usr/bin/svnversion");
my $REV = `svnversion -n ./`;
my $version = $REV;
# (Match the last group of digits and optional letter M/S)
($version =~ m/\d+[MS]*$/) && ($version = $&);

die "$0: No Subversion revision found" unless $version;

if( -e "$INFO" )
{
	open(FH, "$INFO") or die "$0: $INFO: $!";
	my $file = join("", <FH>);
	close(FH);

	if( $file =~ m/$version/ )
	{
		print "Already annotated with correct version\n";
		exit;
	}
}

my $info = "#define REAPER_VERSION   \"svn rev $version\"\n";

open(FH, ">$INFO") or die "$0: $INFO: $!";
print FH $info;
close(FH);
