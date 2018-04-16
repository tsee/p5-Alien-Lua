package Alien::Lua;
# ABSTRACT: Alien module for asserting a liblua is available

our $VERSION = 'v5.3.4.1';

use strict;
use warnings;

use base 'Alien::Base';
use Class::Load qw( try_load_class );

our $CanUseLuaJIT;
BEGIN {
    $CanUseLuaJIT = try_load_class('Alien::LuaJIT') ? 1 : 0;
}

sub new {
    my ($class, %opt) = @_;

    my $luajit = delete $opt{luajit};
    my $self = $class->SUPER::new(%opt);

    bless $self, __PACKAGE__;

    if ($luajit && $CanUseLuaJIT) {
        $self->{alien_luajit} = Alien::LuaJIT->new(%opt);
    }

    return $self;
}

sub luajit { return $_[0]->{alien_luajit} }

sub cflags {
    my $self = shift;

    if (not ref $self or not $self->luajit) {
        return $self->SUPER::cflags(@_);
    }

    return $self->luajit->cflags(@_);
}

sub libs {
    my $self = shift;

    if (not ref $self or not $self->luajit) {
        return $self->SUPER::libs(@_);
    }

    return $self->luajit->libs(@_);
}

sub exe {
    my $self = shift;

    if (not ref $self or not $self->luajit) {
        return $self->runtime_prop->{command};
    }

    return $self->luajit->exe;
}

sub alien_helper {
    my $exe = shift->exe;
    return +{ lua => sub { $exe } };
}

1;

__END__

=encoding UTF-8

=head1 NAME

Alien::Lua - Alien module for asserting a liblua is available

=head1 SYNOPSIS

    use Alien::Lua;
    use Env qw( @PATH );

    unshift @ENV, Alien::Lua->bin_dir;
    my $executable = Alien::Lua->exe;

=head1 DESCRIPTION

See the documentation of Alien::Base for details on the API of this module.

This module builds looks for a copy of Lua installed in your system, or
builds the latest one downloading it from L<https://www.lua.org/ftp/>.
It exposes the location of the installed headers and shared objects via a simple API to use by downstream dependent modules.

=head1 METHODS

=over 4

=item B<exe>

    my $lua = Alien::Lua->exe;

Returns the name of the Lua executable.

When using the executable compiled by this distribution, you
will need to make sure that the directories returned by C<bin_dir> are added
to your C<PATH> environment variable. For more info, check the documentation
of L<Alien::Build>.

=back

=head1 HELPERS

=over 4

=item B<lua>

The C<%{lua}> string will be interpolated by Alien::Build into the name
of the executable (as returned by B<exe>);

=back

=head1 SEE ALSO

=over 4

=item * http://www.lua.org

=item * http://www.luajit.org

=item * Alien::LuaJIT

=item * Alien::Build

=back

=head1 AUTHOR

Steffen Mueller <smueller@cpan.org>

=head1 Contributors

José Joaquín Atria <jjatria@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2013-2018 by Steffen Mueller

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself, either Perl version 5.8.1 or, at your option, any later version of Perl 5 you may have available.

=cut
