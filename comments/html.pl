use Email::Simple;
use Net::IMAP::Client;
use Data::Dumper;
use HTML::Entities;

sub trim {
   return $_[0] =~ s/\A\s+|\s+\z//urg;
}

require "./imap_login.pl";

my $imap = login();

my @global_tree;

sub add_reply {
  my @tree = @{$_[0]};
  my $reply = $_[1];

  foreach my $node (@tree) {
    if ($node->{'email'}->header("Message-Id") eq $reply->header("In-Reply-To")) {
      push(@{$node->{'replies'}}, {email => $reply, replies => qw()});
      return 1;
    }

    if (add_reply(\@{$node->{'replies'}}, $reply)) {
      return 1;
    }
  }
  return 0;
}

sub add_to_tree {
  my $email = $_[0];

  if (!$email->header("In-Reply-To") or !add_reply(\@global_tree, $email)) {
    push(@global_tree, {email => $email, replies => qw()});
  }
}

sub save_mbox {
  my $mid = $_[0];
  my $data = $_[1];

  $mid =~ s/[<>]//g;

  my $filename = "../output/mbox/" . $mid;

  open(FH, '>', $filename) or die $!;
  print FH $data;

  close(FH);

}

my $post = @ARGV[0];

my $folder = $post;
$folder =~ s/ /-/g;
$folder =~ s/[^a-zA-Z0-9-]//g;
$folder = "INBOX.blogpost." . $folder;

$imap->select($folder);

my $messages = $imap->search('ALL', 'DATE');

my @msgs = $imap->get_rfc822_body([@$messages]);

foreach my $data (@msgs) {

  foreach (@$data) {
    my $email = Email::Simple->new($$_);

    save_mbox($email->header('Message-Id'), $$_);
    add_to_tree($email);
  }
}

sub print_header {
  my $email = $_[0];
  my $key = $_[1];
  my $data = $email->header($key);

  if ($data) {
    print "<div><strong>$key: </strong>", HTML::Entities::encode_entities($data), "</div>\n";
  }
}

sub reply_instructions {
  my $email = $_[0];
  my $mid = $email->header('Message-Id');
  $mid =~ s/[<>]//g;
  my $mbox = "mbox/$mid";

  print '<details><summary>Reply this comment.</summary>';

  print '<div class="reply-instruction">';
  print '<p>You may reply <strong>publicly</strong> to this message via <strong>plain-text</strong> email using the following method:</p>';

  print '<p>Save the following mbox file, import it into your mail client, and reply-to-all from there: ';
  print '<a target="_blank" href="./' .  $mbox . '">mbox</a>';
  print '</p>';

  print '<p>Avoid top-posting and favor <a target="_blank" href="https://en.wikipedia.org/wiki/Posting_style#Interleaved_style">interleaved quoting</a>.</p>';
  print '</div>';

  print '</details>';
}

sub is_unecessary_quoting {
  my $line = $_[0];

  if ($line =~ m/- Original Message -/) {
    return 1;
  }

  if ($line =~ m/(At|On).*wrote:/) {
    return 1;
  }

  return 0;
}

sub print_body {
  my $email = $_[0];
  my $body = $email->body;

  my @lines = split(/\n/, $body);

  print "<div>";

  my $quoting = 0;

  print "<pre>";

  foreach my $line (@lines) {
    $line = trim($line);

    if (is_unecessary_quoting($line)) {
      $quoting = 1;
      print "</pre><blockquote><details><summary>...</summary><pre>";
    }

    print HTML::Entities::encode_entities("$line\n");
  }

  print "</pre>";

  if ($quoting) {
    print "</details></blockquote>";
  }

  print "</div>";

}

sub dump_html {

  my @tree = @{$_[0]};

  if (@tree[0] == undef) {
    return;
  }

  print "<ol>";
  foreach my $node (@tree) {

    print "<li>";


    $email = $node->{'email'};

    print_header($email, 'From');
    print_header($email, 'Date');

    print "<br/>";

    print_body($email);

    reply_instructions($email);


    if (@{$node->{'replies'}}[0] != undef) {
      print "<br>";
      dump_html(\@{$node->{'replies'}});
    }

    print "</li>";
  }
  print "</ol>";
}

sub print_comment_instructions {
  my $url = 'mailto:carlos@maniero.me?subject=blogpost: ' . $post;

  print '<div class="comment-instruction">';

  print '<p>Send a <b>plaintext</b> email to <b>carlos@maniero.me</b> to comment in this post.';
  print ' The email should contain the subject <b>"blogpost: ' . $post . '"</b> (without quotes).</p>';

  print '<p>Or use this <a href="' . $url .'">link</a> if your browser/OS supports <b>mailto</b>.</p>';

  print '<p>The email will appear here after a couple of minutes.</p>';

  print '</div>';
}

print '<hr />';

print '<section id="comments">';

print '<h3>Commments:</h3>';

print_comment_instructions();

@global_tree = reverse @global_tree;

dump_html(\@global_tree);

print "</section>";
