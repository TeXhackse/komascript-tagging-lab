$pdf_mode=4;
$force_mode=1;
$go_mode=1;

$lualatex= 'internal autobuild %O %S';

@default_files=(
	"part",
	"chapter",
	"section",
	"subsection",
	"subsubsection",
	"paragraph",
	"subparagraph",
	"part-star",
	"chapter-star",
	"section-star"
);

sub add_extensions {
    my ($rule, @new_exts) = @_;
    foreach my $ext (@new_exts) {
        $input_extensions{$rule}{$ext} = 1;
    }
}

# Add new extensions to 'rule1'
add_extensions ('pdflatex', 'lvt', 'pvt');
add_extensions ('lualatex', 'lvt', 'pvt');
add_extensions ('xelatex', 'lvt', 'pvt');


sub autobuild {
	$out_file = pop @_;
     if (index($out_file, "star") != -1) {
		my $wrapper="wrapper-star.tex";
	 } else {
		my $wrapper="wrapper.tex";
	 }
	# Maybe also create PDF 1.7 ?!
	#$return = system("lualatex-dev -jobname=$pac_out_file @_ 'wrapper17.tex'");
	$return = system("lualatex-dev -jobname=$out_file @_ '$wrapper'");
    return $return;
}
