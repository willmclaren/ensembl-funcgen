#
# Ensembl module for Bio::EnsEMBL::DBSQL::Funcgen::SetAdaptor
#

=head1 LICENSE

  Copyright (c) 1999-2013 The European Bioinformatics Institute and
  Genome Research Limited.  All rights reserved.

  This software is distributed under a modified Apache license.
  For license details, please see

    http://www.ensembl.org/info/about/code_licence.html

=head1 CONTACT

  Please email comments or questions to the public Ensembl
  developers list at <ensembl-dev@ebi.ac.uk>.

  Questions may also be sent to the Ensembl help desk at
  <helpdesk@ensembl.org>.

=head1 NAME

Bio::EnsEMBL::DBSQL::Funcgen::SetAdaptor - A base adaptor for Input/Result/FeatureSetAdaptors

=head1 SYNOPSIS




=head1 DESCRIPTION

This base SetAdaptor provides generic methods applicable to Input/Result/FeatureSetAdaptors

=head1 SEE ALSO

Bio::EnsEMBL::Funcgen::DBSQL::BaseAdaptor

=cut

package Bio::EnsEMBL::Funcgen::DBSQL::SetAdaptor;

use strict;

require Exporter;
use Bio::EnsEMBL::Utils::Exception qw( throw );
use Bio::EnsEMBL::Funcgen::DBSQL::BaseAdaptor;
use vars qw(@ISA @EXPORT);
@ISA = qw(Bio::EnsEMBL::Funcgen::DBSQL::BaseAdaptor Exporter);
@EXPORT = (@{$DBI::EXPORT_TAGS{'sql_types'}});


=head2 fetch_all_by_FeatureType

  Arg [1]    : Bio::EnsEMBL::Funcgen::FeatureType
  Arg [2]    : String  (optional) - status e.g. 'DISPLAYABLE'
  Example    : 
  Description: Retrieves a list of features on a given slice that are created
               by probes from the specified type of array.
  Returntype : Listref of Bio::EnsEMBL::Set objects
  Exceptions : Throws if no valid FeatureType type is provided
  Caller     : General
  Status     : At Risk

=cut

sub fetch_all_by_FeatureType {
  my ($self, $ftype, $status) = @_; 
  my $params = {constraints => {feature_types => [$ftype]}};
  $params->{constraints}{states} = [$status] if defined $status; 
  my $results = $self->generic_fetch($self->compose_constraint_query($params));
  $self->reset_true_tables;  #As we may have added status
  return $results;  
}

=head2 fetch_all_by_CellType

  Arg [1]    : Bio::EnsEMBL::Funcgen::CellType
  Arg [2]    : String  (optional) - status e.g. 'DISPLAYABLE'
  Example    : 
  Description: 
  Returntype : Arrayref of Bio::EnsEMBL::Funcgen::InputSet objects
  Exceptions : Throws if no CellType is provided
  Caller     : General
  Status     : At Risk

=cut

sub fetch_all_by_CellType {
  my ($self, $ctype, $status) = @_;
  my $params = {constraints => {cell_types => [$ctype]}};
  $params->{constraints}{states} = [$status] if defined $status; 
  my $results = $self->generic_fetch($self->compose_constraint_query($params));
  $self->reset_true_tables; #As we may have added status
  return $results;  
} 


=head2 fetch_all_by_FeatureType_Analysis

  Arg [1]    : Bio::EnsEMBL::Funcgen::FeatureType
  Arg [2]    : Bio::EnsEMBL::Analysis
  Arg [3]    : (optional) Bio::EnsEMBL::Funcgen::CellType
  Example    : my @fsets = $fs_adaptopr->fetch_all_by_FeatureType_Analysis($ftype, $anal, $ctype);
  Description: Retrieves FeatureSet objects from the database based on FeatureType, Analysis and 
               CellType if defined.
  Returntype : Listref of Bio::EnsEMBL::Funcgen::FeatureSet objects
  Exceptions : Throws if args 1 and 2 are not valid or stored
  Caller     : General
  Status     : At Risk

=cut

sub fetch_all_by_FeatureType_Analysis {
  my ($self, $ftype, $anal, $ctype) = @_;
  my $params = {constraints => 
                {
                 feature_types => [$ftype],
                 analyses     => [$anal],
                }
               };

  $params->{constraints}{cell_types} = [$ctype] if $ctype;
  return $self->generic_fetch($self->compose_constraint_query($params));    
}



# can't have fetch_by_name as this name is not unique for ResultSets

### GENERIC CONSTRAIN METHODS ###

#All these _constrain methods must return a valid constraint string, and a hashref of any other constraint config

#Need to bind param any of these which come from URL parameters and are not tested

#These type constraints are generic to all sets (apart from DataSet)
#and so could go in a SetAdaptor (doesn't exist yet)
#currently have

sub _constrain_cell_types {
  my ($self, $cts) = @_;

  my $constraint = $self->_table_syn.'.cell_type_id IN ('.
        join(', ', @{$self->db->are_stored_and_valid('Bio::EnsEMBL::Funcgen::CellType', $cts, 'dbID')}
        ).')';
  
  #{} = no futher contraint config
  return ($constraint, {});
}


sub _constrain_feature_types {
  my ($self, $fts) = @_;
 
  #Don't need to bind param this as we validate
  my $constraint = $self->_table_syn.'.feature_type_id IN ('.
		join(', ', @{$self->db->are_stored_and_valid('Bio::EnsEMBL::Funcgen::FeatureType', $fts, 'dbID')}).')';  
  
  #{} = no futher constraint conf
  return ($constraint, {});
}


sub _constrain_analyses {
  my ($self, $anals) = @_;
  
  #Don't need to bind param this as we validate
  my $constraint = $self->_table_syn.'.analysis_id IN ('.
    join(', ', @{$self->db->are_stored_and_valid('Bio::EnsEMBL::Analysis', $anals, 'dbID')}).')';
  
  return ($constraint, {});   #{} = no futher constraint conf
}

1;
