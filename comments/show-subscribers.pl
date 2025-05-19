use Email::MIME;
use Email::Simple;

require "./imap_login.pl";

my $imap = login();

$subs_folder = "INBOX.blog.subscribers";

$imap->select($subs_folder);

my $messages = $imap->search('ALL', 'DATE');

my @msgs = $imap->get_rfc822_body([@$messages]);

foreach my $data (@msgs) {

  foreach (@$data) {
    my $email = Email::MIME->new($$_);

    print $email->header('From'), "\n"
  }
}
