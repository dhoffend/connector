# Connector::Proxy::YAML
#
# Proxy class for reading YAML configuration
#
# Written by Scott Hardin and Martin Bartosch for the OpenXPKI project 2012
#
package Connector::Proxy::YAML;

use strict;
use warnings;
use English;
use YAML;
use Data::Dumper;

use Moose;
extends 'Connector::Proxy';

sub _build_config {
    my $self = shift;

    my $config = YAML::LoadFile( $self->LOCATION() );
    $self->_config($config);
}

sub _get_node {
    
    my $self = shift;
    my @path = $self->_build_path_with_prefix( shift );

    my $ptr = $self->_config();

    while ( scalar @path > 1 ) {
        my $entry = shift @path;
        if ( exists $ptr->{$entry} ) {
            if ( ref $ptr->{$entry} eq 'HASH' ) {
                $ptr = $ptr->{$entry};
            }
            else {
                return $self->_node_not_exists( ref $ptr->{$entry} );
            }
        } else {
            return $self->_node_not_exists($entry);
        }
    }
    
    return $ptr->{ shift @path };
    
}

sub get {
    
    my $self = shift;    
    my $value = $self->_get_node( shift );
    
    return undef unless (defined $value);
    
    if (ref $value ne '') {
        die "requested value is not a scalar"
    }
    
    return $value;
    
}

sub get_size {
    
    my $self = shift;    
    my $node = $self->_get_node( shift );
    
    return undef unless(defined $node);
    
    if ( ref $node ne 'ARRAY' ) {
        die "requested value is not a list"
    }
    
    return scalar @{$node};    
}


sub get_list {
    
    my $self = shift;    
    my $node = $self->_get_node( shift );
    
    return undef unless(defined $node);
    
    if ( ref $node ne 'ARRAY' ) {
        die "requested value is not a list"
    }
    
    return @{$node};   
}

sub get_keys {
    
    my $self = shift;    
    my $node = $self->_get_node( shift );
    
    return undef unless(defined $node);
    
    if ( ref $node ne 'HASH' ) {
        die "requested value is not a hash"
    }
    
    return keys %{$node};   
}

sub get_hash {
    
    my $self = shift;    
    my $node = $self->_get_node( shift );
    
    return undef unless(defined $node);
    
    if ( ref $node ne 'HASH' ) {
        die "requested value is not a hash"
    }
    
    return $node;   
} 

no Moose;
__PACKAGE__->meta->make_immutable;

1;
__END__

=head 1 Name

Connector::Proxy::YAML

=head 1 Description

