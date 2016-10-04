package WsLargeDataIO::WsLargeDataIOClient;

use JSON::RPC::Client;
use POSIX;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
my $get_time = sub { time, 0 };
eval {
    require Time::HiRes;
    $get_time = sub { Time::HiRes::gettimeofday() };
};

use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

WsLargeDataIO::WsLargeDataIOClient

=head1 DESCRIPTION


A KBase module: WsLargeDataIO


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => WsLargeDataIO::WsLargeDataIOClient::RpcClient->new,
	url => $url,
	headers => [],
    };

    chomp($self->{hostname} = `hostname`);
    $self->{hostname} ||= 'unknown-host';

    #
    # Set up for propagating KBRPC_TAG and KBRPC_METADATA environment variables through
    # to invoked services. If these values are not set, we create a new tag
    # and a metadata field with basic information about the invoking script.
    #
    if ($ENV{KBRPC_TAG})
    {
	$self->{kbrpc_tag} = $ENV{KBRPC_TAG};
    }
    else
    {
	my ($t, $us) = &$get_time();
	$us = sprintf("%06d", $us);
	my $ts = strftime("%Y-%m-%dT%H:%M:%S.${us}Z", gmtime $t);
	$self->{kbrpc_tag} = "C:$0:$self->{hostname}:$$:$ts";
    }
    push(@{$self->{headers}}, 'Kbrpc-Tag', $self->{kbrpc_tag});

    if ($ENV{KBRPC_METADATA})
    {
	$self->{kbrpc_metadata} = $ENV{KBRPC_METADATA};
	push(@{$self->{headers}}, 'Kbrpc-Metadata', $self->{kbrpc_metadata});
    }

    if ($ENV{KBRPC_ERROR_DEST})
    {
	$self->{kbrpc_error_dest} = $ENV{KBRPC_ERROR_DEST};
	push(@{$self->{headers}}, 'Kbrpc-Errordest', $self->{kbrpc_error_dest});
    }

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my $token = Bio::KBase::AuthToken->new(@args);
	
	if (!$token->error_message)
	{
	    $self->{token} = $token->token;
	    $self->{client}->{token} = $token->token;
	}
        else
        {
	    #
	    # All methods in this module require authentication. In this case, if we
	    # don't have a token, we can't continue.
	    #
	    die "Authentication failed: " . $token->error_message;
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




=head2 save_objects

  $info = $obj->save_objects($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a WsLargeDataIO.SaveObjectsParams
$info is a reference to a list where each element is a WsLargeDataIO.object_info
SaveObjectsParams is a reference to a hash where the following keys are defined:
	id has a value which is an int
	workspace has a value which is a string
	objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSaveData
ObjectSaveData is a reference to a hash where the following keys are defined:
	type has a value which is a string
	data_json_file has a value which is a string
	name has a value which is a string
	objid has a value which is an int
	meta has a value which is a reference to a hash where the key is a string and the value is a string
	hidden has a value which is a WsLargeDataIO.boolean
boolean is an int
object_info is a reference to a list containing 11 items:
	0: (objid) an int
	1: (name) a string
	2: (type) a string
	3: (save_date) a string
	4: (version) an int
	5: (saved_by) a string
	6: (wsid) an int
	7: (workspace) a string
	8: (chsum) a string
	9: (size) an int
	10: (meta) a reference to a hash where the key is a string and the value is a string

</pre>

=end html

=begin text

$params is a WsLargeDataIO.SaveObjectsParams
$info is a reference to a list where each element is a WsLargeDataIO.object_info
SaveObjectsParams is a reference to a hash where the following keys are defined:
	id has a value which is an int
	workspace has a value which is a string
	objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSaveData
ObjectSaveData is a reference to a hash where the following keys are defined:
	type has a value which is a string
	data_json_file has a value which is a string
	name has a value which is a string
	objid has a value which is an int
	meta has a value which is a reference to a hash where the key is a string and the value is a string
	hidden has a value which is a WsLargeDataIO.boolean
boolean is an int
object_info is a reference to a list containing 11 items:
	0: (objid) an int
	1: (name) a string
	2: (type) a string
	3: (save_date) a string
	4: (version) an int
	5: (saved_by) a string
	6: (wsid) an int
	7: (workspace) a string
	8: (chsum) a string
	9: (size) an int
	10: (meta) a reference to a hash where the key is a string and the value is a string


=end text

=item Description

Save objects to the workspace. Saving over a deleted object undeletes
it.

=back

=cut

 sub save_objects
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function save_objects (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to save_objects:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'save_objects');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "WsLargeDataIO.save_objects",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'save_objects',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method save_objects",
					    status_line => $self->{client}->status_line,
					    method_name => 'save_objects',
				       );
    }
}
 


=head2 get_objects

  $results = $obj->get_objects($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a WsLargeDataIO.GetObjectsParams
$results is a WsLargeDataIO.GetObjectsResults
GetObjectsParams is a reference to a hash where the following keys are defined:
	objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSpecification
	ignore_errors has a value which is a WsLargeDataIO.boolean
ObjectSpecification is a reference to a hash where the following keys are defined:
	workspace has a value which is a string
	wsid has a value which is an int
	name has a value which is a string
	objid has a value which is an int
	ver has a value which is an int
	ref has a value which is a string
	obj_ref_path has a value which is a reference to a list where each element is a string
	included has a value which is a reference to a list where each element is a string
	strict_maps has a value which is a WsLargeDataIO.boolean
	strict_arrays has a value which is a WsLargeDataIO.boolean
boolean is an int
GetObjectsResults is a reference to a hash where the following keys are defined:
	data has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectData
ObjectData is a reference to a hash where the following keys are defined:
	data_json_file has a value which is a string
	info has a value which is a WsLargeDataIO.object_info
object_info is a reference to a list containing 11 items:
	0: (objid) an int
	1: (name) a string
	2: (type) a string
	3: (save_date) a string
	4: (version) an int
	5: (saved_by) a string
	6: (wsid) an int
	7: (workspace) a string
	8: (chsum) a string
	9: (size) an int
	10: (meta) a reference to a hash where the key is a string and the value is a string

</pre>

=end html

=begin text

$params is a WsLargeDataIO.GetObjectsParams
$results is a WsLargeDataIO.GetObjectsResults
GetObjectsParams is a reference to a hash where the following keys are defined:
	objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSpecification
	ignore_errors has a value which is a WsLargeDataIO.boolean
ObjectSpecification is a reference to a hash where the following keys are defined:
	workspace has a value which is a string
	wsid has a value which is an int
	name has a value which is a string
	objid has a value which is an int
	ver has a value which is an int
	ref has a value which is a string
	obj_ref_path has a value which is a reference to a list where each element is a string
	included has a value which is a reference to a list where each element is a string
	strict_maps has a value which is a WsLargeDataIO.boolean
	strict_arrays has a value which is a WsLargeDataIO.boolean
boolean is an int
GetObjectsResults is a reference to a hash where the following keys are defined:
	data has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectData
ObjectData is a reference to a hash where the following keys are defined:
	data_json_file has a value which is a string
	info has a value which is a WsLargeDataIO.object_info
object_info is a reference to a list containing 11 items:
	0: (objid) an int
	1: (name) a string
	2: (type) a string
	3: (save_date) a string
	4: (version) an int
	5: (saved_by) a string
	6: (wsid) an int
	7: (workspace) a string
	8: (chsum) a string
	9: (size) an int
	10: (meta) a reference to a hash where the key is a string and the value is a string


=end text

=item Description

Get objects from the workspace.

=back

=cut

 sub get_objects
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function get_objects (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to get_objects:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'get_objects');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "WsLargeDataIO.get_objects",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'get_objects',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method get_objects",
					    status_line => $self->{client}->status_line,
					    method_name => 'get_objects',
				       );
    }
}
 
  
sub status
{
    my($self, @args) = @_;
    if ((my $n = @args) != 0) {
        Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
                                   "Invalid argument count for function status (received $n, expecting 0)");
    }
    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
        method => "WsLargeDataIO.status",
        params => \@args,
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
                           code => $result->content->{error}->{code},
                           method_name => 'status',
                           data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
                          );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method status",
                        status_line => $self->{client}->status_line,
                        method_name => 'status',
                       );
    }
}
   

sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
        method => "WsLargeDataIO.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'get_objects',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method get_objects",
            status_line => $self->{client}->status_line,
            method_name => 'get_objects',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for WsLargeDataIO::WsLargeDataIOClient\n";
    }
    if ($sMajor == 0) {
        warn "WsLargeDataIO::WsLargeDataIOClient version is $svr_version. API subject to change.\n";
    }
}

=head1 TYPES



=head2 boolean

=over 4



=item Description

A boolean - 0 for false, 1 for true.
@range (0, 1)


=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 object_info

=over 4



=item Description

Information about an object, including user provided metadata.

    objid - the numerical id of the object.
    name - the name of the object.
    type - the type of the object.
    save_date - the save date of the object.
    ver - the version of the object.
    saved_by - the user that saved or copied the object.
    wsid - the id of the workspace containing the object.
    workspace - the name of the workspace containing the object.
    chsum - the md5 checksum of the object.
    size - the size of the object in bytes.
    meta - arbitrary user-supplied metadata about
        the object.


=item Definition

=begin html

<pre>
a reference to a list containing 11 items:
0: (objid) an int
1: (name) a string
2: (type) a string
3: (save_date) a string
4: (version) an int
5: (saved_by) a string
6: (wsid) an int
7: (workspace) a string
8: (chsum) a string
9: (size) an int
10: (meta) a reference to a hash where the key is a string and the value is a string

</pre>

=end html

=begin text

a reference to a list containing 11 items:
0: (objid) an int
1: (name) a string
2: (type) a string
3: (save_date) a string
4: (version) an int
5: (saved_by) a string
6: (wsid) an int
7: (workspace) a string
8: (chsum) a string
9: (size) an int
10: (meta) a reference to a hash where the key is a string and the value is a string


=end text

=back



=head2 ObjectSaveData

=over 4



=item Description

An object and associated data required for saving.

    Required parameters:
    type - the workspace type string for the object. Omit the version
        information to use the latest version.
    data_json_file - the path to a JSON file containing the object data.
    
    Optional parameters:
    One of an object name or id. If no name or id is provided the name
        will be set to 'auto' with the object id appended as a string,
        possibly with -\d+ appended if that object id already exists as a
        name.
    name - the name of the object.
    objid - the id of the object to save over.
    meta - arbitrary user-supplied metadata for the object,
        not to exceed 16kb; if the object type specifies automatic
        metadata extraction with the 'meta ws' annotation, and your
        metadata name conflicts, then your metadata will be silently
        overwritten.
    hidden - true if this object should not be listed when listing
        workspace objects.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
type has a value which is a string
data_json_file has a value which is a string
name has a value which is a string
objid has a value which is an int
meta has a value which is a reference to a hash where the key is a string and the value is a string
hidden has a value which is a WsLargeDataIO.boolean

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
type has a value which is a string
data_json_file has a value which is a string
name has a value which is a string
objid has a value which is an int
meta has a value which is a reference to a hash where the key is a string and the value is a string
hidden has a value which is a WsLargeDataIO.boolean


=end text

=back



=head2 SaveObjectsParams

=over 4



=item Description

Input parameters for the "save_objects" function.

    Required parameters:
    id - the numerical ID of the workspace.
    workspace - optional workspace name alternative to id.
    objects - the objects to save.
    
    The object provenance is automatically pulled from the SDK runner.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
id has a value which is an int
workspace has a value which is a string
objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSaveData

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
id has a value which is an int
workspace has a value which is a string
objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSaveData


=end text

=back



=head2 ObjectSpecification

=over 4



=item Description

An Object Specification (OS). Inherits from ObjectIdentity.
Specifies which object, and which parts of that object, to retrieve
from the Workspace Service.

The fields wsid, workspace, objid, name, ver, and ref are identical to
the ObjectIdentity fields.

REFERENCE FOLLOWING:

Reference following guarantees that a user that has access to an
object can always see a) objects that are referenced inside the object
and b) objects that are referenced in the object's provenance. This
ensures that the user has visibility into the entire provenance of the
object and the object's object dependencies (e.g. references).

The user must have at least read access to the object specified in this
SO, but need not have access to any further objects in the reference
chain, and those objects may be deleted.

Optional reference following fields:
list<string> obj_ref_path - a path to the desired object from the object
    specified in this OS. In other words, the object specified in this
    OS is assumed to be accessible to the user, and the objects in
    the object path represent a chain of references to the desired
    object at the end of the object path. If the references are all
    valid, the desired object will be returned.

OBJECT SUBSETS:

When selecting a subset of an array in an object, the returned
array is compressed to the size of the subset, but the ordering of
the array is maintained. For example, if the array stored at the
'feature' key of a Genome object has 4000 entries, and the object paths
provided are:
    /feature/7
    /feature/3015
    /feature/700
The returned feature array will be of length three and the entries will
consist, in order, of the 7th, 700th, and 3015th entries of the
original array.

Optional object subset fields:
list<string> included - the portions of the object to include
        in the object subset.
boolean strict_maps - if true, throw an exception if the subset
    specification traverses a non-existant map key (default false)
boolean strict_arrays - if true, throw an exception if the subset
    specification exceeds the size of an array (default true)


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace has a value which is a string
wsid has a value which is an int
name has a value which is a string
objid has a value which is an int
ver has a value which is an int
ref has a value which is a string
obj_ref_path has a value which is a reference to a list where each element is a string
included has a value which is a reference to a list where each element is a string
strict_maps has a value which is a WsLargeDataIO.boolean
strict_arrays has a value which is a WsLargeDataIO.boolean

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace has a value which is a string
wsid has a value which is an int
name has a value which is a string
objid has a value which is an int
ver has a value which is an int
ref has a value which is a string
obj_ref_path has a value which is a reference to a list where each element is a string
included has a value which is a reference to a list where each element is a string
strict_maps has a value which is a WsLargeDataIO.boolean
strict_arrays has a value which is a WsLargeDataIO.boolean


=end text

=back



=head2 GetObjectsParams

=over 4



=item Description

Input parameters for the "get_objects" function.

    Required parameters:
    object_refs - a list of object references in the form X/Y/Z, where X is
        the workspace name or id, Y is the object name or id, and Z is the
        (optional) object version. In general, always use ids rather than
        names if possible to avoid race conditions.
    
    Optional parameters:
    ignore_errors - ignore any errors that occur when fetching an object
        and instead insert a null into the returned list.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSpecification
ignore_errors has a value which is a WsLargeDataIO.boolean

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
objects has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectSpecification
ignore_errors has a value which is a WsLargeDataIO.boolean


=end text

=back



=head2 ObjectData

=over 4



=item Description

The data and supplemental info for an object.

    UnspecifiedObject data - the object's data or subset data.
    object_info info - information about the object.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
data_json_file has a value which is a string
info has a value which is a WsLargeDataIO.object_info

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
data_json_file has a value which is a string
info has a value which is a WsLargeDataIO.object_info


=end text

=back



=head2 GetObjectsResults

=over 4



=item Description

Results from the get_objects function.

    list<ObjectData> data - the returned objects.


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
data has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectData

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
data has a value which is a reference to a list where each element is a WsLargeDataIO.ObjectData


=end text

=back



=cut

package WsLargeDataIO::WsLargeDataIOClient::RpcClient;
use base 'JSON::RPC::Client';
use POSIX;
use strict;

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $headers, $obj) = @_;
    my $result;


    {
	if ($uri =~ /\?/) {
	    $result = $self->_get($uri);
	}
	else {
	    Carp::croak "not hashref." unless (ref $obj eq 'HASH');
	    $result = $self->_post($uri, $headers, $obj);
	}

    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $headers, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	@$headers,
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
