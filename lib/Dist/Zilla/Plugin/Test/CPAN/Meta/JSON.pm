package Dist::Zilla::Plugin::Test::CPAN::Meta::JSON;
use strict;
use warnings;
# ABSTRACT: release tests for your META.json
# VERSION

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with 'Dist::Zilla::Role::FilePruner';
with 'Dist::Zilla::Role::PrereqSource';

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::CPAN::Meta::JSON]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file if F<META.json> is in your dist:

    xt/release/meta-json.t - a standard Test::CPAN::Meta::JSON test

See L<Test::CPAN::Meta::JSON> for what this test does.

=cut

sub prune_files {
    my $self = shift;

    # Bail if we find META.json
    my $METAjson = 'META.json';
    foreach my $file (@{ $self->zilla->files }) {
        return if $file->name eq $METAjson;
    }

    # If META.json wasn't found, then prune out the test
    my $test_filename = 'xt/release/meta-json.t';
    foreach my $file (@{ $self->zilla->files }) {
        next unless $file->name eq $test_filename;

        $self->zilla->prune_file($file);
        $self->log_debug([ '%s not found; pruning %s', $METAjson, $file->name ]);
    }
    return;
}

# Register the release test prereq as a "develop requires"
# so it will be listed in "dzil listdeps --author"
sub register_prereqs {
  my ($self) = @_;

  $self->zilla->register_prereqs(
    {
      type  => 'requires',
      phase => 'develop',
    },
    'Test::CPAN::Meta::JSON' => '0.16',
  );
}


__PACKAGE__->meta->make_immutable;
no Moose;

1;

=for Pod::Coverage prune_files register_prereqs

=for test_synopsis
1;
__END__

=cut

__DATA__
__[ xt/release/meta-json.t ]__
#!perl

use Test::CPAN::Meta::JSON;
meta_json_ok();
