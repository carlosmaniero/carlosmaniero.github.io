use Net::IMAP::Client;

sub login{
  my $imap = Net::IMAP::Client->new(
      server => 'imap.hostinger.com',
      user   => 'carlos@maniero.me',
      pass   => $ENV{EMAIL_PASS},
      ssl    => 1,
      ssl_verify_peer => 1,
      port   => 993
  ) or die "Could not connect to IMAP server";

  $imap->login or die('Login failed: ' . $imap->last_error);

  $imap
}

1;
