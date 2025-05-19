Automatically generated

_______________________ 0
$imap->select('INBOX');

foreach my $post (@ARGV) {
  my $folder = $post;
  $folder =~ s/ /-/g;
  $folder =~ s/[^a-zA-Z0-9-]//g;
  $folder = "INBOX.blogpost." . $folder;

  my $messages = $imap->search({SUBJECT => 'blogpost: ' . $post}, 'DATE');

  $imap->create_folder($folder);
  $imap->copy(\@$messages, $folder);

  $imap->delete_message(\@$messages, '\\Deleted');
  $imap->expunge();
}
_______________________ 0
