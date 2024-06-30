#! /usr/bin/perl -w
eval 'exec perl -S $0 ${1+"$@"}'
    if 0; #$running_under_some_shell

# ======================================================================
# changeinitialcomments.pl
# Copyright (c) Markus Kohm, 2005-2009
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
# changeinitialcomments.pl
# Copyright (c) Markus Kohm, 2005-2009
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
# This perl script changes all initial copyright notes of all files to
# the one of this script (without changing the known name of the file).
#
# Usage: changeinitialcomments.pl <basedir>
# ----------------------------------------------------------------------
# Dieses Perl-Script aendert alle Rechte-Hinweise aller Dateien in den
# dieser Datei (ohne jedoch den Dateinamen im Rechte-Hinweis).
#
# Verwendung: changeinitialcomments.pl <Basisverzeichnis>
# ======================================================================


use strict;
use File::Find();
use File::Basename();
use File::Copy();


sub readpreamble($);

my @gmtime=gmtime();
my $thisyear=$gmtime[5] + 1900;
my $prgname=$0;
my $prgbasename=File::Basename::basename($prgname);
my $basedir=shift or die "Usage: changeinitialcomments.pl <basedir>\n";
my $preamble = readpreamble($0) or
    die "Fatal internal error!\n";

File::Find::find({wanted => \&wanted}, $basedir);

exit;

sub filetypebyline($) {
    local $_=shift;

    if ( /^#\s*!\s*(\/usr)?\/bin\/(perl|sh)/ ) {
	return 1;
    } elsif ( /^%/ ) {
	return 2;
    } elsif ( $_ =~ /^#\s?=+\s*\z/ ) {
	return 1; # NOTE: Dangerous!
    }

    return undef;
}

sub preamblestartorend($$) {
    my $filetype = shift;
    local $_ = shift;
    if ( $filetype == 1 ) {
	# script preamble
	if ( $_ =~ /^#\s?=+\s*\z/ ) {
	    return 1;
	}
    } elsif ( $filetype == 2 ) {
	# TeX file preamble
	if ( $_ =~ /^%%?\s?=+\s*\z/ ) {
	    return 1;
	}
    }
    return 0;
}

sub readpreamble($) {
    my $file=shift;
    my $read=0;
    my $filetype;
    my $preamble;

    # 1: file type by file name
    if ( $file =~ /\.(tex|dtx|ins)$/ ) {
	$filetype = 2; # TeX file
    }

    open IN,"<",$file or
	die "Cannot read $file!\n";

    while (<IN>) {
	if ( $read == 0 ) {
	    if ( ! $filetype ) {
		$filetype = filetypebyline($_);
	    }
	    if ( $filetype ) {
		$read = preamblestartorend($filetype,$_);
		$preamble = $_ if ( $read );
	    }
	} else {
	    $preamble .= $_;
	    $read = !preamblestartorend($filetype,$_);
	    if ( ! $read ) {
		close IN;
		return $preamble;
	    }
	}
    }

    close IN;

    if ( $read == 0 ) {
        print STDERR "Warning: No preamble found at \"$file\"!\n";
    } else {
	print STDERR "Warning: Nothing but preamble found at \"$file\"!\n";
    }
    return $preamble;
}

sub wanted {
    my $name=$_;
    my $data="";

    return if ( ! -T 
		|| -S
		|| ( $name eq $prgbasename )
		|| ( $File::Find::name =~ /\.svn/ )
		|| ( $File::Find::name =~ /\/auto\// )
		|| ( $_ =~ /^changelog/i )
		|| ( $_ =~ /^\./ )
		|| ( $_ =~ /^readme/i )
		|| ( $_ =~ /^#/ || $_ =~ /~\z/ )
		|| ( $_ =~ /\.(pdf|ind|md5|chn|ilg|bbl|aux|blg|lot|toc|mpx|out|idx|glo|log|xref|tmp|drv|mps)\z/ )
	);

    if ( open IN,"<","$name" ) {
	my $read=0;
	my $filetype;
	my $copyright;

	# 1: file type by file name
	if ( $name =~ /\.(tex|dtx|ins)$/ ) {
	    $filetype = 2; # TeX file
	}
	
	while (<IN>) {
	    if ( $read == 0 ) {
		if ( ! $filetype ) {
		    $filetype = filetypebyline($_);
		}
		if ( $filetype ) {
		    $read = preamblestartorend($filetype,$_);
		}
		if ( ! $read ) {
		    $data .= $_;
		}
	    } elsif ( $read == 1 ) {
		$read += preamblestartorend($filetype,$_);
		if ( $read == 2 ) {
		    my $newpreamble = $preamble;
		    $newpreamble =~ s/$prgbasename/$name/g;
		    if ( $copyright ) {
			$newpreamble =~ s/^#\s+Copyright\s+.*$/$copyright/mg;
		    }
		    if ( $filetype == 2 ) {
			$newpreamble =~ s/^#/%/mg;
		    }
		    $data .= $newpreamble;
		} elsif ( ! $copyright ) {
		    if ( /Copyright\s[^0-9]*(((199[0-9]|20[0-9][0-9])-+)?(199[0-9]|20[0-9][0-9]))/ ) {
			if ( $3 ) {
			    s/(((199[0-9]|20[0-9][0-9])-+)?(199[0-9]|20[0-9][0-9]))/$3-$thisyear/;
			} else {
			    if ( $1 == $thisyear ) {
				s/$1/$thisyear/;
			    } else {
				s/($1)/$1-$thisyear/;
			    }
			}
			$copyright=$_;
			chomp $copyright;
		    }
		}
	    } else {
		$data .= $_;
	    }
	}
	
	print STDERR "Warning: No preamble found at \"$File::Find::name\"!\n"
	    if ( $read == 0 );

	print STDERR "Warning: Nothing after preamble at \"$File::Find::name\"!\n"
	    if ( $read == 1 );

	close IN;

	if ( $read == 2 ) {
	    if ( File::Copy::copy($name,"$name.bak") ) {
		if ( ! ( open OUT,">","$name" ) or ! ( print OUT $data ) or
		     ! ( close OUT ) ) {
		    print STDERR "Error: Cannot write new \"$name\": $!!\n";
		    File::Copy::move("$name.bak","$name") or
			print STDERR "Error: Cannot copy \"$name.bak\" back: $!!\n";
		} else {
		    unlink "$name.bak";
		}
	    } else {
		print STDERR "Error: Leave unbackupable file \"$name\" unchanged: $!!\n";
	    }
	} else {
#	    print STDERR "\t Leaving \"$File::Find::name\" unchanged!\n";
	}
    } else {
	print STDERR "Error: Cannot read \"$File::Find::name\"!\n";
    }
}
