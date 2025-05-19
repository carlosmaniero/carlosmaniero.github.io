use Email::Simple;
use Email::MIME;
use Net::IMAP::Client;

require "./imap_login.pl";

my $imap = login();

sub move_to {
  my $folder = $_[0];
  my $messages = $_[1];

  $imap->create_folder($folder);
  $imap->copy(\@$messages, $folder);

  $imap->delete_message(\@$messages, '\\Deleted');
  $imap->expunge();
}

sub subscribe {
  $imap->select('INBOX');

  print "REGISTERING SUBSCRIPTIONS\n";

  $subs_folder = "INBOX.blog.subscribers";

  my $messages = $imap->search({SUBJECT => 'blog: subscribe'}, 'DATE');

  move_to($subs_folder, $messages);
}

sub unsubscribe {
  $imap->select('INBOX');
  print "REGISTERING UNSUBSCRIPTIONS\n";

  my $messages = $imap->search({SUBJECT => 'blog: unsubscribe'}, 'DATE');

  my @msgs = $imap->get_rfc822_body([@$messages]);

  $unsubs_folder = "INBOX.blog.unsubscribers";

  move_to($unsubs_folder, $messages);

  foreach my $data (@msgs) {

    foreach (@$data) {
      my $email = Email::MIME->new($$_);

      $from = $email->header('From'), "\n";

      if($from =~ m/(.+<)?(.*?)(>?)$/) {
        $imap->select($subs_folder);

        my $messages = $imap->search({FROM => $2}, 'DATE');

        move_to($unsubs_folder, $messages);
      }
    }
  }
}

subscribe();
unsubscribe();
