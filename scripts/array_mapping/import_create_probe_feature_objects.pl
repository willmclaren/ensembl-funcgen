#!/usr/bin/env perl

use strict;
use Data::Dumper;
use Getopt::Long;

=head1

perl scripts/array_mapping/import_create_probe_feature_objects.pl \
  --parsed_data /nfs/nobackup/ensembl/mnuhn/array_mapping/temp/homo_sapiens/probe_chunks/probe_chunk_2.fasta_genomic.exonerate_parsed.txt \
  --promiscuous_hits /nfs/nobackup/ensembl/mnuhn/array_mapping/temp/homo_sapiens/probe_chunks/probe_chunk_2.fasta_genomic.promiscuous_hits.txt \
  --accepted_hits /nfs/nobackup/ensembl/mnuhn/array_mapping/temp/homo_sapiens/probe_chunks/probe_chunk_2.fasta_genomic.accepted_hits.txt \
  --max_allowed_hits_per_probe 100

=cut

my $parsed_data;
my $output_file;
my $max_allowed_hits_per_probe;
my $promiscuous_hits;
my $accepted_hits;

GetOptions (
   'parsed_data=s'                => \$parsed_data,
   'promiscuous_hits=s'           => \$promiscuous_hits,
   'accepted_hits=s'              => \$accepted_hits,
   'max_allowed_hits_per_probe=s' => \$max_allowed_hits_per_probe,
);

open my $promiscuous_hits_fh, '>', $promiscuous_hits;
open my $accepted_hits_fh,    '>', $accepted_hits;

my $process_probe_data = sub {

  my $probe_hit_list = shift;
  
  if (@$probe_hit_list > $max_allowed_hits_per_probe) {
    $promiscuous_hits_fh->print(Dumper($probe_hit_list));
    return;
  }
  
  foreach my $current_probe_hit (@$probe_hit_list) {
    $accepted_hits_fh->print(Dumper($current_probe_hit));
  }
};

use Bio::EnsEMBL::Funcgen::Parsers::DataDumper;
my $parser = Bio::EnsEMBL::Funcgen::Parsers::DataDumper->new;

$parser->parse({
  data_dumper_file => $parsed_data,
  call_back        => $process_probe_data,
});