#! /usr/bin/perl -w
eval 'exec perl -S $0 ${1+"$@"}'
    if 0; #$running_under_some_shell

# ======================================================================
# genchangelog.pl
# Copyright (c) Markus Kohm, 2002-2012
#
# This file is part of the LaTeX2e KOMA-Script bundle.
#
# This work may be distributed and/or modified under the conditions of
# the LaTeX Project Public License, version 1.3c of the license.
# The latest version of this license is in
#   http://www.latex-project.org/lppl.txt
# and version 1.3c or later is part of all distributions of LaTeX 
# version 2005/12/01 or later and of this work.
#
# This work has the LPPL maintenance status "author-maintained".
#
# The Current Maintainer and author of this work is Markus Kohm.
#
# This work consists of all files listed in manifest.txt.
# ----------------------------------------------------------------------
# genchangelog.pl
# Copyright (c) Markus Kohm, 2002-2012
#
# Dieses Werk darf nach den Bedingungen der LaTeX Project Public Lizenz,
# Version 1.3c, verteilt und/oder veraendert werden.
# Die neuste Version dieser Lizenz ist
#   http://www.latex-project.org/lppl.txt
# und Version 1.3c ist Teil aller Verteilungen von LaTeX
# Version 2005/12/01 oder spaeter und dieses Werks.
#
# Dieses Werk hat den LPPL-Verwaltungs-Status "author-maintained"
# (allein durch den Autor verwaltet).
#
# Der Aktuelle Verwalter und Autor dieses Werkes ist Markus Kohm.
# 
# Dieses Werk besteht aus den in manifest.txt aufgefuehrten Dateien.
# ======================================================================
# This perl scripts generates a ChangeLog.svn using `svn log'.
#
# Usage: genchangelog.pl <basedir>
# ----------------------------------------------------------------------
# Dieses perl-Script erzeugt mit Hilfe von `svn log' ein ChangeLog.svn.
#
# Verwendung: genchangelog.pl <basedir>
# ======================================================================

use strict;
use IO::Handle;
use File::Find();
use File::Spec;
use File::Copy;
use POSIX qw(strftime);

my $opt_ignoretestsuite=1;
my $opt_ignoredeveloper=1;
my $opt_verbose=1;
my $linelengthlimit=78;
my $revrangeopt="";
my @allinfo;
my $basedir=shift or
    die 'Error: missing parameter <basedir>';
$basedir =~ s/\/$//;

my $ChangeLogFile=File::Spec->rel2abs(File::Spec->catfile($basedir,
							  "doc",
							  "ChangeLog.svn"));
my $NewChangeLogFile=File::Spec->rel2abs(File::Spec->catfile($basedir,
							     "doc",
							     "ChangeLog.tmp"));
my $firstrev=0;

sub printtext($);

checkchangelog();

File::Find::find({wanted => \&wanted, no_chdir => 1}, $basedir) 
    if defined $revrangeopt;

@allinfo = sort {
    $b->[0] <=> $a->[0]
} @allinfo;

open NCH,">$NewChangeLogFile"
    or die "Cannot create $NewChangeLogFile";

my $lastrev=0;
my $text;
my $linelength;

map {
    my @info = @$_;
    if ( $info[4] ne "" ) {
	if ( $lastrev != $info[0] ) {
	    $lastrev=$info[0];
	    printtext(*NCH);
	    $text=$info[5];
	    print NCH "r$info[0] $info[2] $info[1]:\n\n";
	    print NCH "\t* $info[4]";
	    $linelength = 10 + length($info[4]);
	} else {
	    if ( $linelength + 2 + length($info[4]) > $linelengthlimit - 2 ) {
		print NCH ",\n";
		print NCH "\t$info[4]";
		$linelength = 8 + length($info[4]);
	    } else {
		print NCH ", $info[4]";
		$linelength += 2 + length($info[4]);
	    }
	}
    }
} @allinfo;
printtext(*NCH);

flush NCH;

if (-e $ChangeLogFile) {
    copy($ChangeLogFile,\*NCH) or
        die "Cannot append $ChangeLogFile to $NewChangeLogFile";
}

close NCH;

exit;

sub printtext($) {
    my $out=shift;
    if ( $text ) {
	my @pars;
	print $out ":";
	$linelength += 1;
	map {
	    my $line = $_;
	    chomp($line);
	    if ( $linelength == 0 ) {
		print $out "\t  ";
		$linelength = 10;
	    }
	    if ( $linelength + length($line) + 1 <= $linelengthlimit ) {
		print $out " $line\n";
		$linelength = 0;
	    } else {
		my $indent;
		$line =~ /^( *)(.*)\z/;
		$indent=$1;
		$line=$2;
		if ( $indent ne "" ) {
		    print $out "\n";
		    $linelength=0;
		}
		map {
		    $linelength += length($_) + 1;
		    if ( $linelength <= $linelengthlimit ) {
			print $out " $_";
		    } else {
			$linelength = length($_) + length($indent) + 10;
			print $out "\n\t  $indent$_";
		    }
		} split / /,$line;
		print $out "\n";
	    }
	} split /\n/,$text;
	print $out "\n";
    }
}

sub checkchangelog {
    if ( open IN,'<',$ChangeLogFile ) {
	my $stop = 0;
	while ( $stop == 0 ) {
	    $_ = <IN>;
	    $stop = ! defined( $_ ) || ! /^\s*\z/;
	};
	if ( defined( $_ ) and 
	     /^r([0-9]+)\s+([12][0-9][0-9][0-9]-[012][0-9]-[0123][0-9]\s[012][0-9]:[012345][0-9]:[012345][0-9]\s\+[012][0-9][012345][0-9])/ ) {
	    my $startrev=$1;
	    $startrev += 1;
	    $revrangeopt="-r'$startrev:HEAD'";

	    $_ = `svn log $revrangeopt . 2>&1`;
	    if ( $_ = /^svn: No such revision/ ) {
		print STDERR "ChangeLog already up to date.\n" 
		    if $opt_verbose;
		undef $revrangeopt;
	    }

	} else {
	    print STDERR "Warning: Syntax error at $ChangeLogFile!\n";
	}
	close IN;
    } else {
	print STDERR "Warning: Cannot read $ChangeLogFile.\n";
    }
}

sub wanted {
    my ($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($_);
    my $output;
    my $newrev = 0;
    my $data;
    my @info;
    my $text = "";
    
    # changes of some files should not be part of the ChangeLog or are never
    # part of the SVN repository
    if ( $File::Find::name =~ /\/(auto|\.svn)(\/|\z)/ or
	 $File::Find::name =~ /\/test/ or
	 $File::Find::name =~ /\/(diff|letter-)/ or
	 $File::Find::name =~ /(\.(svn|gz|zip|pdf|dvi|mp|sty|clo|lco|tmp|log|aux|toc[0-9]*|lof|lot|ind|idx|ilg|glo|chn|out|bbl|blg)|~)\z/ ) {
	if ( ( $File::Find::name =~ /\/testsuite\// ) ||
	     ( $File::Find::name =~ /\/testsuite$/ ) ||
	     ( $File::Find::name =~ /^testsuite\// ) ) {
	    return if $opt_ignoretestsuite;
	} else {
	    return;
	}
    }
    if ( $opt_ignoredeveloper &&
	 ( ( $File::Find::name =~ /\/developer\// ) ||
	   ( $File::Find::name =~ /\/developer$/ ) ||
	   ( $File::Find::name =~ /^developer\// ) ) ) {
	return;
    }

    print "process: svn log $revrangeopt $File::Find::name\n" 
	if $opt_verbose;

    $output=`svn log $revrangeopt $File::Find::name`;

    open IN,'<',\$output
	or die "Cannot read output for $File::Find::name!\n";
    while ( $data = <IN> ) {
	chomp $data;
	if ( $data =~ /^\-+\z/ ) {
	    $newrev=1;
	    if ( @info ) {
		push @info,"$text\n";
		$text="";
		push @allinfo,[@info];
		@info = ();
	    }
	} elsif ( $newrev == 1 ) {
	    @info=split /\s*\|\s*/,$data;
	    $info[0] =~ s/^r//;
	    $info[2] =~ s/\s\(.*//;
	    my $name=$File::Find::name;
	    if ( length($name) > length($basedir) ) {
		$name=substr($name,length($basedir)+1);
		$name .= '/' if ( -d "$basedir/$name" );
	    } else {
		$name="";
	    }
	    push @info,$name;
	    $newrev=2;
	} elsif ( $newrev == 2 ) {
	    $newrev=3;
	} elsif ( $newrev == 3 ) {
	    if ( $data =~ /^\s+/ or $data eq "" ) {
		$text .= "\n$data";
	    } else {
		if ( $text eq "" ) {
		    $text = $data;
		} else {
		    $text .= " $data";
		}
	    }
	}
    }
#   This will never happen:
#    if ( @info ) {
#	print @info;
#	push @allinfo,\@info;
#    }
    close IN;
}

# end of file
