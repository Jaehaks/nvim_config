add_cus_dep('aux', 'bbl', 0, 'run_bibtex_for_chapter');

sub run_bibtex_for_chapter {
    my ($base_name) = @_;
    my $cmd = "bibtex $base_name";
    print "Running: $cmd\n";
    system($cmd);
}
