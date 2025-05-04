my $filename = $ARGV[0];

open(my $fh, "<", $filename) || die "Can't open file: $!"; # Open the file in read mode

while (<$fh>) {
  if (m/<h2 class="chapter">\d+ (.*)<\/h2>/) {
    close $fh;

    open(my $fht,'>', $filename . ".title") or die $!;

    print $fht $1;

    exit;
  }
}

close $fh;
die "Could not fild the chapter title for \"$filename\"";
