#!/usr/bin/perl
# Copyright (c) Markus Kohm, 2011
# helper script to list all commands and environments defined by all dtx files
# ----------------------------------------------------------------------------

my @commands;
my @environments;

while (<*.dtx>) {
    local $file=$_;
    local @contents;
    local @test;
    open(FILE, "<$file") || die "Cannot open $file for reading";
    @contents=(<FILE>);
    close(FILE);
    @commands=(@commands,grep(s/^%[[:space:]]*\\begin\{macro\}\{(\\[[:alpha:]]*)\}.*[[:space:]]*$/$1/,@contents));
    @environments=(@environments,grep(s/^%[[:space:]]*\\begin\{environment\}\{(.*)\}.*[[:space:]]*$/$1/,@contents));
}

my $last;
foreach (sort @commands) {
    print "$_\n" if ! ( $_ eq $last );
    $last=$_;
}
$last="";
foreach (sort @environments) {
    print "\\begin{$_}…\\end{$_}\n" if ! ( $_ eq $last );
    $last=$_;
}
