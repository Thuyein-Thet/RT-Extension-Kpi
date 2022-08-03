use strict;
use warnings;
package RT::Extension::Kpi;


use Exporter qw( import );
@EXPORT_OK = qw( RelevantTxns );

our $VERSION = '0.01';

RT->AddStyleSheets('activity-reports.css');

=head1 NAME

RT-Extension-Kpi - [One line description of module's purpose here]

=head1 DESCRIPTION

[Why would someone install this extension? What does it do? What problem
does it solve?]

=head1 RT VERSION

Works with RT [What versions of RT is this known to work with?]

[Make sure to use requires_rt and rt_too_new in Makefile.PL]

=head1 INSTALLATION

=over

=item C<perl Makefile.PL>

=item C<make>

=item C<make install>

May need root permissions

=item Edit your F</opt/rt4/etc/RT_SiteConfig.pm>

Add this line:

    Plugin('RT::Extension::Kpi');

=item Clear your mason cache

    rm -rf /opt/rt4/var/mason_data/obj

=item Restart your webserver

=back

=head1 AUTHOR

Best Practical Solutions, LLC E<lt>modules@bestpractical.comE<gt>

=for html <p>All bugs should be reported via email to <a
href="mailto:bug-RT-Extension-Kpi@rt.cpan.org">bug-RT-Extension-Kpi@rt.cpan.org</a>
or via the web at <a
href="http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-Kpi">rt.cpan.org</a>.</p>

=for text
    All bugs should be reported via email to
        bug-RT-Extension-Kpi@rt.cpan.org
    or via the web at
        http://rt.cpan.org/Public/Dist/Display.html?Name=RT-Extension-Kpi

=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by tyt

This is free software, licensed under:

  The GNU General Public License, Version 2, June 1991

=cut

sub RelevantTxns {
    my( $ticket, %args ) = @_;

    my $txns = $ticket->Transactions;
    $txns->Limit(FIELD => 'Created', OPERATOR => '>=', VALUE => $args{start});
    $txns->Limit(FIELD => 'Created', OPERATOR => '<=', VALUE => $args{end});
    if( $args{timed} ) {
	# Limit to transactions with positive time taken.
        $txns->Limit(FIELD => 'TimeTaken', OPERATOR => '>=', VALUE => 1); 
    } else {
	# Include status changes and ticket creations.
	$txns->Limit(FIELD => 'Type', VALUE => 'Status', ENTRYAGGREGATOR => 'OR');
	$txns->Limit(FIELD => 'Type', VALUE => 'Create', ENTRYAGGREGATOR => 'OR');
    }
    # Comment/correspond type transactions are always relevant.
    $txns->Limit(FIELD => 'Type', VALUE => 'Comment', ENTRYAGGREGATOR => 'OR');
    $txns->Limit(FIELD => 'Type', VALUE => 'Correspond');

    return $txns;
}

1;
