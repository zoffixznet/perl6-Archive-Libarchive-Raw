#!/usr/bin/env perl6

use lib 'lib';
use Archive::Libarchive::Raw;
use Archive::Libarchive::Constants;

sub MAIN(:$file! where { .IO.f // die "file '$file' not found" })
{
  my $buffer = slurp $file, :bin;
  my archive $a = archive_read_new();
  archive_read_support_filter_gzip($a);
  archive_read_support_format_tar($a);
  archive_read_open_memory($a, $buffer, $file.IO.s) == ARCHIVE_OK or die 'Unable to open archive';
  my archive_entry $entry .= new;
  while archive_read_next_header($a, $entry) == ARCHIVE_OK {
    my $name = archive_entry_pathname($entry);
    say $name;
    archive_read_data_skip($a);
  }
  archive_read_free($a) == ARCHIVE_OK or die 'Unable to free internal data structure';
}
