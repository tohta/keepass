#!/usr/bin/env perl
use strict;
use warnings;
use File::KeePass;
use Term::ReadKey;
use XML::Parser;

my $file = shift || die "$!: File not provided.";
my $master_pass = &show_passwd_prompt || die "$!: password error.";

my $k = File::KeePass->new;
if (! eval { $k->load_db($file, $master_pass) }) {
  die "Couldn't load the file $file: $@";
}

$k->unlock;

my $keys = $k->groups;
for my $entry (@{ $keys }) {
  for my $val (@{ $entry->{'entries'} }) {
    # last unless $val->{'icon'} > 0;
    print "title: "     . $val->{'title'    } . "\n";
    print "comment: "   . $val->{'comment'  } . "\n";
    print "username: "  . $val->{'username' } . "\n";
    print "password: "  . $val->{'password' } . "\n";
    print "+" x 25 . "\n";
  }
}

$k->clear;

sub show_passwd_prompt {
  print "Password?";
  ReadMode "noecho";
  chomp (my $password = ReadLine 0);
  ReadMode "restore";
  return $password;
}
