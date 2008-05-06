package FreeBSD::Src;

use warnings;
use strict;

=head1 NAME

FreeBSD::Src - A object oriented interface to building FreeBSD from source.

=head1 VERSION

Version 1.0.0

=cut

our $VERSION = '1.0.0';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use FreeBSD::Src;

	#creates a new FreeBSD::Src object and build stuff in /tm[/obj and a kernel config
	#named whatever.
    my $src=FreeBSD::Src->new({obj=>"/tmp/obj", kernel=>"whatever"});
    
    #builds and installs the kernel and world
    $src->makeBuildKernel;
    $src->makeInstallKernel;
    $src->makeBuildWorld;
    $src->makeInstallWorld;

=head1 FUNCTIONS

=head2 new

This creates the object that will be used. It takes arguement, which is a hash
that contains various options that will be used.

=head3 src

This key contains the path to which contains the FreeBSD source. This this does
not exist, it results in a permanent error.

The default is '/usr/src' if it is not defined.

=head3 obj

This contains the path to the directory that will contain objects created by the compilation.

The default is '/usr/obj' if it is not defined.

=head3 kernel

This is the kernel config that will be build.

The default is 'GENERIC' unless it is defined.

=head3 makeconf

This is the make.conf file to use for the build.

=cut

sub new{
	my %args= %{$_[1]};

	#create the object that will be passed around
	my $self = {conf=>{}, error=>undef, returnedInt=>undef,
				returned=>undef, permanentError=>undef};
	bless $self;

	if(!defined($args{src})){
		$self->{conf}{src}="/usr/src";
	}else{
		$self->{conf}{src}=$args{src};
	};

	#figures out what to use for obj dir prefix
	if(!defined($args{obj})){
		$self->{conf}{obj}="/usr/obj";
	}else{
		$self->{conf}{obj}=$args{obj};
	};
	#sets the obj dir prefix
	$ENV{MAKEOBJDIRPREFIX}=$self->{conf}{obj};

	if(!defined($args{kernel})){
		$self->{conf}{kernel}="GERNERIC";
	}else{
		$self->{conf}{kernel}=$args{kernel};
	};

	#sets the make.conf
	if(!defined($args{makeconf})){
		$self->{conf}{makeconf}="/etc/make.conf";
	}else{
		$self->{conf}{makeconf}=$args{makeconf};
	};

	if(!-e $self->{conf}{src}){
		warn('FreeBSD::Src error:0: The directory source directory, '.$self->{conf}{src}.', does not exist.');
		$self->{permanentError}="0";
	};

	return $self;
};

=head2 makeBuildWorld

Builds the world.

The return is a perl boolean value.

The returned integer from make can be reached in $obj->{returnedInt}.

The output from make can be found in $obj->{returned}.

=cut

sub makeBuildWorld{
	my ($self)= @_;

	if(defined($self->{permanentError})){
		$self->{error}=$self->{permanentError};
		return undef;
	};

	$self->errorBlank();

	chdir($self->{conf}{src});

	$self->{returned}=`make buildworld __MAKE_CONF=$self->{conf}{makeconf}`;
	$self->{returnedInt}=$?;
	if (!$self->{returnedInt} == 0){
		$self->{error}=1;
		return undef;
	};
};

=head2 makeInstallWorld

Installs the world.

The return is a perl boolean value.

The returned integer from make can be reached in $obj->{returnedInt}.

The output from make can be found in $obj->{returned}.

=cut

sub makeInstallWorld{
	my ($self)= @_;

	if(defined($self->{permanentError})){
		$self->{error}=$self->{permanentError};
		return undef;
	};

	$self->errorBlank();

	chdir($self->{conf}{src});

	$self->{returned}=`make installworld __MAKE_CONF=$self->{conf}{makeconf}`;
	$self->{returnedInt}=$?;
	if (!$self->{returnedInt} == 0){
		$self->{error}=2;
		return undef;
	};
};

=head2 makeBuildKernel

Builds the kernel

The return is a perl boolean value.

The returned integer from make can be reached in $obj->{returnedInt}.

The output from make can be found in $obj->{returned}.

=cut

sub makeBuildKernel{
	my ($self)= @_;

	if(defined($self->{permanentError})){
		$self->{error}=$self->{permanentError};
		return undef;
	};

	$self->errorBlank();

	chdir($self->{conf}{src});

	$self->{returned}=`make buildkernel __MAKE_CONF=$self->{conf}{makeconf} KERNCONF=$self->{conf}{kernel}`;
	$self->{returnedInt}=$?;
	if (!$self->{returnedInt} == 0){
		$self->{error}=3;
		return undef;
	};
};

=head2 makeInstallKernel

Install the kernel.

The return is a perl boolean value.

The returned integer from make can be reached in $obj->{returnedInt}.

The output from make can be found in $obj->{returned}.

=cut

sub makeInstallKernel{
	my ($self)= @_;

	if(defined($self->{permanentError})){
		$self->{error}=$self->{permanentError};
		return undef;
	};

	$self->errorBlank();

	chdir($self->{conf}{src});

	$self->{returned}=`make buildkernel __MAKE_CONF=$self->{conf}{makeconf} KERNCONF=$self->{conf}{kernel}`;
	$self->{returnedInt}=$?;
	if (!$self->{returnedInt} == 0){
		$self->{error}=4;
		return undef;
	};
};


=head2 errorBlank 

This is a internal function and should not be called.

=cut

#blanks the error flags
sub errorBlank{
        my $self=$_[0];

        $self->{error}=undef;
        $self->{returnedInt}=undef;

        return 1;
};

=head1 ERROR CODES

=head2 0

The source directory does not exist.

=head2 1

'make buildworld' failed.

=head2 2

'make installdworld' failed.

=head2 3

'make buildkernel KERNCONF=<kernel>' failed.

=head2 4

'make installkernel KERNCONF=<kernel>' failed.

=head1 AUTHOR

Zane C. Bowers, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-freebsd-src at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=FreeBSD-Src>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc FreeBSD::Src


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=FreeBSD-Src>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/FreeBSD-Src>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/FreeBSD-Src>

=item * Search CPAN

L<http://search.cpan.org/dist/FreeBSD-Src>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Zane C. Bowers, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of FreeBSD::Src
