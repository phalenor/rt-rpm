#
# RT was configured with:
#
#   $ ./configure --with-db-type=SQLite --enable-layout=relative --with-web-handler=standalone
#

package RT;

#############################  WARNING  #############################
#                                                                   #
#                     NEVER EDIT RT_Config.pm !                     #
#                                                                   #
#         Instead, copy any sections you want to change to          #
#         RT_SiteConfig.pm and edit them there.  Otherwise,         #
#         your changes will be lost when you upgrade RT.            #
#                                                                   #
#############################  WARNING  #############################

=head1 NAME

RT::Config

=head1 Base configuration

=over 4

=item C<$rtname>

C<$rtname> is the string that RT will look for in mail messages to
figure out what ticket a new piece of mail belongs to.

Your domain name is recommended, so as not to pollute the namespace.
Once you start using a given tag, you should probably never change it;
otherwise, mail for existing tickets won't get put in the right place.

=cut

Set($rtname, "example.com");

=item C<$Organization>

You should set this to your organization's DNS domain. For example,
I<fsck.com> or I<asylum.arkham.ma.us>. It is used by the linking
interface to guarantee that ticket URIs are unique and easy to
construct.  Changing it after you have created tickets in the system
will B<break> all existing ticket links!

=cut

Set($Organization, "example.com");

=item C<$CorrespondAddress>, C<$CommentAddress>

RT is designed such that any mail which already has a ticket-id
associated with it will get to the right place automatically.

C<$CorrespondAddress> and C<$CommentAddress> are the default addresses
that will be listed in From: and Reply-To: headers of correspondence
and comment mail tracked by RT, unless overridden by a queue-specific
address.  They should be set to email addresses which have been
configured as aliases for F<rt-mailgate>.

=cut

Set($CorrespondAddress, '');

Set($CommentAddress, '');

=item C<$WebDomain>

Domain name of the RT server, e.g. 'www.example.com'. It should not
contain anything except the server name.

=cut

Set($WebDomain, "localhost");

=item C<$WebPort>

If we're running as a superuser, run on port 80.  Otherwise, pick a
high port for this user.

443 is default port for https protocol.

=cut

Set($WebPort, 80);

=item C<$WebPath>

If you're putting the web UI somewhere other than at the root of your
server, you should set C<$WebPath> to the path you'll be serving RT
at.

C<$WebPath> requires a leading / but no trailing /, or it can be
blank.

In most cases, you should leave C<$WebPath> set to "" (an empty
value).

=cut

Set($WebPath, "");

=item C<$Timezone>

C<$Timezone> is the default timezone, used to convert times entered by
users into GMT, as they are stored in the database, and back again;
users can override this.  It should be set to a timezone recognized by
your server.

=cut

Set($Timezone, "US/Eastern");

=item C<@Plugins>

Once a plugin has been downloaded and installed, use C<Plugin()> to add
to the enabled C<@Plugins> list:

    Plugin( "RT::Extension::JSGantt" );

RT will also accept the distribution name (i.e. C<RT-Extension-JSGantt>)
instead of the package name (C<RT::Extension::JSGantt>).

=cut

Set(@Plugins, ());

=item C<@StaticRoots>

Set C<@StaticRoots> to serve extra paths with a static handler.  The
contents of each hashref should be the the same arguments as
L<Plack::Middleware::Static> takes.  These paths will be checked before
any plugin or core static paths.

Example:

    Set( @StaticRoots,
        {
            path => qr{^/static/},
            root => '/local/path/to/static/parent',
        },
    );

=cut

Set( @StaticRoots, () );

=back




=head1 Database connection

=over 4

=item C<$DatabaseType>

Database driver being used; case matters.  Valid types are "mysql",
"Oracle", and "Pg".  "SQLite" is also available for non-production use.

=cut

Set($DatabaseType, "SQLite");

=item C<$DatabaseHost>, C<$DatabaseRTHost>

The domain name of your database server.  If you're running MySQL and
on localhost, leave it blank for enhanced performance.

C<DatabaseRTHost> is the fully-qualified hostname of your RT server,
for use in granting ACL rights on MySQL.

=cut

Set($DatabaseHost,   "localhost");
Set($DatabaseRTHost, "localhost");

=item C<$DatabasePort>

The port that your database server is running on.  Ignored unless it's
a positive integer. It's usually safe to leave this blank; RT will
choose the correct default.

=cut

Set($DatabasePort, "");

=item C<$DatabaseUser>

The name of the user to connect to the database as.

=cut

Set($DatabaseUser, "rt_user");

=item C<$DatabasePassword>

The password the C<$DatabaseUser> should use to access the database.

=cut

Set($DatabasePassword, q{rt_pass});

=item C<$DatabaseName>

The name of the RT database on your database server. For Oracle, the
SID and database objects are created in C<$DatabaseUser>'s schema.

=cut

Set($DatabaseName, q{rt4});

=item C<%DatabaseExtraDSN>

Allows additional properties to be passed to the database connection
step.  Possible properties are specific to the database-type; see
https://metacpan.org/pod/DBI#connect

For PostgreSQL, for instance, the following enables SSL (but does no
certificate checking, providing data hiding but no MITM protection):

   # See https://metacpan.org/pod/DBD::Pg#connect
   # and http://www.postgresql.org/docs/8.4/static/libpq-ssl.html
   Set( %DatabaseExtraDSN, sslmode => 'require' );

For MySQL, the following acts similarly if the server has enabled SSL.
Otherwise, it provides no protection; MySQL provides no way to I<force>
SSL connections:

   # See https://metacpan.org/pod/DBD::mysql#connect
   # and http://dev.mysql.com/doc/refman/5.1/en/ssl-options.html
   Set( %DatabaseExtraDSN, mysql_ssl => 1 );

=cut

Set(%DatabaseExtraDSN, ());

=item C<$DatabaseAdmin>

The name of the database administrator to connect to the database as
during upgrades.

=cut

Set($DatabaseAdmin, "root");

=back




=head1 Logging

The default is to log anything except debugging information to syslog.
Check the L<Log::Dispatch> POD for information about how to get things
by syslog, mail or anything else, get debugging info in the log, etc.

It might generally make sense to send error and higher by email to
some administrator.  If you do this, be careful that this email isn't
sent to this RT instance.  Mail loops will generate a critical log
message.

=over 4

=item C<$LogToSyslog>, C<$LogToSTDERR>

The minimum level error that will be logged to the specific device.
From lowest to highest priority, the levels are:

    debug info notice warning error critical alert emergency

Many syslogds are configured to discard or file debug messages away, so
if you're attempting to debug RT you may need to reconfigure your
syslogd or use one of the other logging options.

Logging to your screen affects scripts run from the command line as well
as the STDERR sent to your webserver (so these logs will usually show up
in your web server's error logs).

=cut

Set($LogToSyslog, "info");
Set($LogToSTDERR, "info");

=item C<$LogToFile>, C<$LogDir>, C<$LogToFileNamed>

Logging to a standalone file is also possible. The file needs to both
exist and be writable by all direct users of the RT API. This generally
includes the web server and whoever rt-crontool runs as. Note that
rt-mailgate and the RT CLI go through the webserver, so their users do
not need to have write permissions to this file. If you expect to have
multiple users of the direct API, Best Practical recommends using syslog
instead of direct file logging.

You should set C<$LogToFile> to one of the levels documented above.

=cut

Set($LogToFile, undef);
Set($LogDir, q{var/log});
Set($LogToFileNamed, "rt.log");    #log to rt.log

=item C<$LogStackTraces>

If set to a log level then logging will include stack traces for
messages with level equal to or greater than specified.

NOTICE: Stack traces include parameters supplied to functions or
methods. It is possible for stack trace logging to reveal sensitive
information such as passwords or ticket content in your logs.

=cut

Set($LogStackTraces, "");

=item C<@LogToSyslogConf>

Additional options to pass to L<Log::Dispatch::Syslog>; the most
interesting flags include C<facility>, C<logopt>, and possibly C<ident>.
See the L<Log::Dispatch::Syslog> documentation for more information.

=cut

Set(@LogToSyslogConf, ());

=back



=head1 Incoming mail gateway

=over 4

=item C<$EmailSubjectTagRegex>

This regexp controls what subject tags RT recognizes as its own.  If
you're not dealing with historical C<$rtname> values, or historical
queue-specific subject tags, you'll likely never have to change this
configuration.

Be B<very careful> with it. Note that it overrides C<$rtname> for
subject token matching.

The setting below would make RT behave exactly as it does without the
setting enabled.

=cut

# Set($EmailSubjectTagRegex, qr/\Q$rtname\E/i );

=item C<$OwnerEmail>

C<$OwnerEmail> is the address of a human who manages RT. RT will send
errors generated by the mail gateway to this address; it will also be
displayed as the contact person on the RT's login page.  Because RT
sends errors to this address, it should I<not> be an address that's
managed by your RT instance, to avoid mail loops.

=cut

Set($OwnerEmail, 'root');

=item C<$LoopsToRTOwner>

If C<$LoopsToRTOwner> is defined, RT will send mail that it believes
might be a loop to C<$OwnerEmail>.

=cut

Set($LoopsToRTOwner, 1);

=item C<$StoreLoops>

If C<$StoreLoops> is defined, RT will record messages that it believes
to be part of mail loops.  As it does this, it will try to be careful
not to send mail to the sender of these messages.

=cut

Set($StoreLoops, undef);

=item C<$MaxAttachmentSize>

C<$MaxAttachmentSize> sets the maximum size (in bytes) of attachments
stored in the database.  This setting is irrelevant unless one of
$TruncateLongAttachments or $DropLongAttachments (below) are set, B<OR>
the database is stored in Oracle.  On Oracle, attachments larger than
this can be fully stored, but will be truncated to this length when
read.

=cut

Set($MaxAttachmentSize, 10*1024*1024);  # 10MiB

=item C<$TruncateLongAttachments>

If this is set to a non-undef value, RT will truncate attachments
longer than C<$MaxAttachmentSize>.

=cut

Set($TruncateLongAttachments, undef);

=item C<$DropLongAttachments>

If this is set to a non-undef value, RT will silently drop attachments
longer than C<MaxAttachmentSize>.  C<$TruncateLongAttachments>, above,
takes priority over this.

=cut

Set($DropLongAttachments, undef);

=item C<$RTAddressRegexp>

C<$RTAddressRegexp> is used to make sure RT doesn't add itself as a
ticket CC if C<$ParseNewMessageForTicketCcs>, above, is enabled.  It
is important that you set this to a regular expression that matches
all addresses used by your RT.  This lets RT avoid sending mail to
itself.  It will also hide RT addresses from the list of "One-time Cc"
and Bcc lists on ticket reply.

If you have a number of addresses configured in your RT database
already, you can generate a naive first pass regexp by using:

    perl etc/upgrade/generate-rtaddressregexp

If left blank, RT will compare each address to your configured
C<$CorrespondAddress> and C<$CommentAddress> before searching for a
Queue configured with a matching "Reply Address" or "Comment Address"
on the Queue Admin page.

=cut

Set($RTAddressRegexp, undef);

=item C<$CanonicalizeEmailAddressMatch>, C<$CanonicalizeEmailAddressReplace>

RT provides functionality which allows the system to rewrite incoming
email addresses, using L<RT::User/CanonicalizeEmailAddress>.  The
default implementation replaces all occurrences of the regular
expression in C<CanonicalizeEmailAddressMatch> with
C<CanonicalizeEmailAddressReplace>, via C<s/$Match/$Replace/gi>.  The
most common use of this is to replace C<@something.example.com> with
C<@example.com>.  If more complex noramlization is required,
L<RT::User/CanonicalizeEmailAddress> can be overridden to provide it.

=cut

# Set($CanonicalizeEmailAddressMatch, '@subdomain\.example\.com$');
# Set($CanonicalizeEmailAddressReplace, '@example.com');

=item C<$ValidateUserEmailAddresses>

By default C<$ValidateUserEmailAddresses> is 1, and RT will refuse to create
users with an invalid email address (as specified in RFC 2822) or with
an email address made of multiple email addresses.

Set this to 0 to skip any email address validation.  Doing so may open up
vulnerabilities.

=cut

Set($ValidateUserEmailAddresses, 1);

=item C<@MailPlugins>

C<@MailPlugins> is a list of authentication plugins for
L<RT::Interface::Email> to use; see L<rt-mailgate>

=cut

=item C<$ExtractSubjectTagMatch>, C<$ExtractSubjectTagNoMatch>

The default "extract remote tracking tags" scrip settings; these
detect when your RT is talking to another RT, and adjust the subject
accordingly.

=cut

Set($ExtractSubjectTagMatch, qr/\[[^\]]+? #\d+\]/);
Set($ExtractSubjectTagNoMatch, ( ${RT::EmailSubjectTagRegex}
       ? qr/\[(?:${RT::EmailSubjectTagRegex}) #\d+\]/
       : qr/\[\Q$RT::rtname\E #\d+\]/));

=item C<$CheckMoreMSMailHeaders>

Some email clients create a plain text version of HTML-formatted
email to help other clients that read only plain text.
Unfortunately, the plain text parts sometimes end up with
doubled newlines and these can then end up in RT. This
is most often seen in MS Outlook.

Enable this option to have RT check for additional mail headers
and attempt to identify email from MS Outlook. When detected,
RT will then clean up double newlines. Note that it may
clean up intentional double newlines as well.

=cut

Set( $CheckMoreMSMailHeaders, 0);

=back



=head1 Outgoing mail

=over 4

=item C<$MailCommand>

C<$MailCommand> defines which method RT will use to try to send mail.
We know that 'sendmailpipe' works fairly well.  If 'sendmailpipe'
doesn't work well for you, try 'sendmail'.  'qmail' is also a supported
value.

For testing purposes, or to simply disable sending mail out into the
world, you can set C<$MailCommand> to 'mbox' which logs all mail, in
mbox format, to files in F</opt/rt4/var/> based in the process start
time.  The 'testfile' option is similar, but the files that it creates
(under /tmp) are temporary, and removed upon process completion; the
format is also not mbox-compatable.

=cut

Set($MailCommand, "sendmailpipe");

=item C<$SetOutgoingMailFrom>

C<$SetOutgoingMailFrom> tells RT to set the sender envelope to the
Correspond mail address of the ticket's queue.

Warning: If you use this setting, bounced mails will appear to be
incoming mail to the system, thus creating new tickets.

If the value contains an C<@>, it is assumed to be an email address and used as
a global envelope sender.  Expected usage in this case is to simply set the
same envelope sender on all mail from RT, without defining
C<$OverrideOutgoingMailFrom>.  If you do define C<$OverrideOutgoingMailFrom>,
anything specified there overrides the global value (including Default).

This option only works if C<$MailCommand> is set to 'sendmailpipe'.

=cut

Set($SetOutgoingMailFrom, 0);

=item C<$OverrideOutgoingMailFrom>

C<$OverrideOutgoingMailFrom> is used for overwriting the Correspond
address of the queue as it is handed to sendmail -f. This helps force
the From_ header away from www-data or other email addresses that show
up in the "Sent by" line in Outlook.

The option is a hash reference of queue id/name to email address. If
there is no ticket involved, then the value of the C<Default> key will
be used.

This option only works if C<$SetOutgoingMailFrom> is enabled and
C<$MailCommand> is set to 'sendmailpipe'.

=cut

Set($OverrideOutgoingMailFrom, {
#    'Default' => 'admin@rt.example.com',
#    'General' => 'general@rt.example.com',
});

=item C<$DefaultMailPrecedence>

C<$DefaultMailPrecedence> is used to control the default Precedence
level of outgoing mail where none is specified.  By default it is
C<bulk>, but if you only send mail to your staff, you may wish to
change it.

Note that you can set the precedence of individual templates by
including an explicit Precedence header.

If you set this value to C<undef> then we do not set a default
Precedence header to outgoing mail. However, if there already is a
Precedence header, it will be preserved.

=cut

Set($DefaultMailPrecedence, "bulk");

=item C<$DefaultErrorMailPrecedence>

C<$DefaultErrorMailPrecedence> is used to control the default
Precedence level of outgoing mail that indicates some kind of error
condition. By default it is C<bulk>, but if you only send mail to your
staff, you may wish to change it.

If you set this value to C<undef> then we do not add a Precedence
header to error mail.

=cut

Set($DefaultErrorMailPrecedence, "bulk");

=item C<$UseOriginatorHeader>

C<$UseOriginatorHeader> is used to control the insertion of an
RT-Originator Header in every outgoing mail, containing the mail
address of the transaction creator.

=cut

Set($UseOriginatorHeader, 1);

=item C<$UseFriendlyFromLine>

By default, RT sets the outgoing mail's "From:" header to "SenderName
via RT".  Setting C<$UseFriendlyFromLine> to 0 disables it.

=cut

Set($UseFriendlyFromLine, 1);

=item C<$FriendlyFromLineFormat>

C<sprintf()> format of the friendly 'From:' header; its arguments are
SenderName and SenderEmailAddress.

=cut

Set($FriendlyFromLineFormat, "\"%s via RT\" <%s>");

=item C<$UseFriendlyToLine>

RT can optionally set a "Friendly" 'To:' header when sending messages
to Ccs or AdminCcs (rather than having a blank 'To:' header.

This feature DOES NOT WORK WITH SENDMAIL[tm] BRAND SENDMAIL.  If you
are using sendmail, rather than postfix, qmail, exim or some other
MTA, you _must_ disable this option.

=cut

Set($UseFriendlyToLine, 0);

=item C<$FriendlyToLineFormat>

C<sprintf()> format of the friendly 'To:' header; its arguments are
WatcherType and TicketId.

=cut

Set($FriendlyToLineFormat, "\"%s of ". RT->Config->Get('rtname') ." Ticket #%s\":;");

=item C<$NotifyActor>

By default, RT doesn't notify the person who performs an update, as
they already know what they've done. If you'd like to change this
behavior, Set C<$NotifyActor> to 1

=cut

Set($NotifyActor, 0);

=item C<$RecordOutgoingEmail>

By default, RT records each message it sends out to its own internal
database.  To change this behavior, set C<$RecordOutgoingEmail> to 0

If this is disabled, users' digest mail delivery preferences
(i.e. EmailFrequency) will also be ignored.

=cut

Set($RecordOutgoingEmail, 1);

=item C<$VERPPrefix>, C<$VERPDomain>

Setting these options enables VERP support
L<http://cr.yp.to/proto/verp.txt>.

Uncomment the following two directives to generate envelope senders
of the form C<${VERPPrefix}${originaladdress}@${VERPDomain}>
(i.e. rt-jesse=fsck.com@rt.example.com ).

This currently only works with sendmail and sendmailpipe.

=cut

# Set($VERPPrefix, "rt-");
# Set($VERPDomain, $RT::Organization);


=item C<$ForwardFromUser>

By default, RT forwards a message using queue's address and adds RT's
tag into subject of the outgoing message, so recipients' replies go
into RT as correspondents.

To change this behavior, set C<$ForwardFromUser> to 1 and RT
will use the address of the current user and remove RT's subject tag.

=cut

Set($ForwardFromUser, 0);

=item C<$HTMLFormatter>

RT's default pure-perl formatter may fail to successfully convert even
on some relatively simple HTML; this will result in blank C<text/plain>
parts, which is particuarly unfortunate if HTML templates are not in
use.

If the optional dependency L<HTML::FormatExternal> is installed, RT will
use external programs to render HTML to plain text.  The default is to
try, in order, C<w3m>, C<elinks>, C<html2text>, C<links>, C<lynx>, and
then fall back to the C<core> pure-perl formatter if none are installed.

Set C<$HTMLFormatter> to one of the above programs (or the full path to
such) to use a different program than the above would choose by default.
Setting this requires that L<HTML::FormatExternal> be installed.

If the chosen formatter is not in the webserver's $PATH, you may set
this option the full path to one of the aforementioned executables.

=cut

Set($HTMLFormatter, undef);

=back

=head2 Email dashboards

=over 4

=item C<$DashboardAddress>

The email address from which RT will send dashboards. If none is set,
then C<$OwnerEmail> will be used.

=cut

Set($DashboardAddress, '');

=item C<$DashboardSubject>

Lets you set the subject of dashboards. Arguments are the frequency (Daily,
Weekly, Monthly) of the dashboard and the dashboard's name.

=cut

Set($DashboardSubject, "%s Dashboard: %s");

=item C<@EmailDashboardRemove>

A list of regular expressions that will be used to remove content from
mailed dashboards.

=cut

Set(@EmailDashboardRemove, ());

=back



=head2 Sendmail configuration

These options only take effect if C<$MailCommand> is 'sendmail' or
'sendmailpipe'

=over 4

=item C<$SendmailArguments>

C<$SendmailArguments> defines what flags to pass to C<$SendmailPath>
These options are good for most sendmail wrappers and work-a-likes.

These arguments are good for sendmail brand sendmail 8 and newer:
C<Set($SendmailArguments,"-oi -ODeliveryMode=b -OErrorMode=m");>

=cut

Set($SendmailArguments, "-oi");


=item C<$SendmailBounceArguments>

C<$SendmailBounceArguments> defines what flags to pass to C<$Sendmail>
assuming RT needs to send an error (i.e. bounce).

=cut

Set($SendmailBounceArguments, '-f "<>"');

=item C<$SendmailPath>

If you selected 'sendmailpipe' above, you MUST specify the path to
your sendmail binary in C<$SendmailPath>.

=cut

Set($SendmailPath, "/usr/sbin/sendmail");


=back

=head2 Other mailers

=over 4

=item C<@MailParams>

C<@MailParams> defines a list of options passed to $MailCommand if it
is not 'sendmailpipe' or 'sendmail';

=cut

Set(@MailParams, ());

=back


=head1 Web interface

=over 4

=item C<$WebDefaultStylesheet>

This determines the default stylesheet the RT web interface will use.
RT ships with several themes by default:

  rudder          The default theme for RT 4.2
  aileron         The default layout for RT 4.0
  web2            The default layout for RT 3.8
  ballard         Theme which doesn't rely on JavaScript for menuing

This value actually specifies a directory in F<share/static/css/>
from which RT will try to load the file main.css (which should @import
any other files the stylesheet needs).  This allows you to easily and
cleanly create your own stylesheets to apply to RT.  This option can
be overridden by users in their preferences.

=cut

Set($WebDefaultStylesheet, "rudder");

=item C<$DefaultQueue>

Use this to select the default queue name that will be used for
creating new tickets. You may use either the queue's name or its
ID. This only affects the queue selection boxes on the web interface.

=cut

# Set($DefaultQueue, "General");

=item C<$RememberDefaultQueue>

When a queue is selected in the new ticket dropdown, make it the new
default for the new ticket dropdown.

=cut

# Set($RememberDefaultQueue, 1);

=item C<$EnableReminders>

Hide all links and portlets related to Reminders by setting this to 0

=cut

Set($EnableReminders, 1);

=item C<@CustomFieldValuesSources>

Set C<@CustomFieldValuesSources> to a list of class names which extend
L<RT::CustomFieldValues::External>.  This can be used to pull lists of
custom field values from external sources at runtime.

=cut

Set(@CustomFieldValuesSources, ());

=item C<%CustomFieldGroupings>

This option affects the display of ticket and user custom fields in the
web interface. It does not address the sorting of custom fields within
the groupings; which is controlled by the Ticket Custom Fields tab in
Queue Configuration in the Admin UI.

A nested datastructure defines how to group together custom fields
under a mix of built-in and arbitrary headings ("groupings").

Set C<%CustomFieldGroupings> to a nested structure similar to the following:

    Set(%CustomFieldGroupings,
        'RT::Ticket' => [
            'Grouping Name'     => ['CF Name', 'Another CF'],
            'Another Grouping'  => ['Some CF'],
            'Dates'             => ['Shipped date'],
        ],
        'RT::User' => [
            'Phones' => ['Fax number'],
        ],
    );

The first level keys are record types for which CFs may be used, and the
values are either hashrefs or arrayrefs -- if arrayrefs, then the
ordering is preserved during display, otherwise groupings are displayed
alphabetically.  The second level keys are the grouping names and the
values are array refs containing a list of CF names.

There are several special built-in groupings which RT displays in
specific places (usually the collapsible box of the same title).  The
ordering of these standard groupings cannot be modified.  You may also
only append Custom Fields to the list in these boxes, not reorder or
remove core fields.

For C<RT::Ticket>, these groupings are: C<Basics>, C<Dates>, C<Links>, C<People>

For C<RT::User>: C<Identity>, C<Access control>, C<Location>, C<Phones>

Extensions may also add their own built-in groupings, refer to the individual
extension documentation for those.

=item C<$CanonicalizeRedirectURLs>

Set C<$CanonicalizeRedirectURLs> to 1 to use C<$WebURL> when
redirecting rather than the one we get from C<%ENV>.

Apache's UseCanonicalName directive changes the hostname that RT
finds in C<%ENV>.  You can read more about what turning it On or Off
means in the documentation for your version of Apache.

If you use RT behind a reverse proxy, you almost certainly want to
enable this option.

=cut

Set($CanonicalizeRedirectURLs, 0);

=item C<$CanonicalizeURLsInFeeds>

Set C<$CanonicalizeURLsInFeeds> to 1 to use C<$WebURL> in feeds
rather than the one we get from request.

If you use RT behind a reverse proxy, you almost certainly want to
enable this option.

=cut

Set($CanonicalizeURLsInFeeds, 0);

=item C<@JSFiles>

A list of additional JavaScript files to be included in head.

=cut

Set(@JSFiles, qw//);

=item C<@CSSFiles>

A list of additional CSS files to be included in head.

If you're a plugin author, refer to RT->AddStyleSheets.

=cut

Set(@CSSFiles, qw//);

=item C<$UsernameFormat>

This determines how user info is displayed. 'concise' will show the
first of RealName, Name or EmailAddress that has a value. 'verbose' will
show EmailAddress, and the first of RealName or Name which is defined.
The default, 'role', uses 'verbose' for unprivileged users, and the Name
followed by the RealName for privileged users.

=cut

Set($UsernameFormat, "role");

=item C<$UserSearchResultFormat>

This controls the display of lists of users returned from the User
Summary Search. The display of users in the Admin interface is
controlled by C<%AdminSearchResultFormat>.

=cut

Set($UserSearchResultFormat,
         q{ '<a href="__WebPath__/User/Summary.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/User/Summary.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,__RealName__, __EmailAddress__}
);

=item C<@UserSummaryPortlets>

A list of portlets to be displayed on the User Summary page.
By default, we show all of the available portlets.
Extensions may provide their own portlets for this page.

=cut

Set(@UserSummaryPortlets, (qw/ExtraInfo CreateTicket ActiveTickets InactiveTickets UserAssets /));

=item C<$UserSummaryExtraInfo>

This controls what information is displayed on the User Summary
portal. By default the user's Real Name, Email Address and Username
are displayed. You can remove these or add more as needed. This
expects a Format string of user attributes. Please note that not all
the attributes are supported in this display because we're not
building a table.

=cut

Set($UserSummaryExtraInfo, "RealName, EmailAddress, Name");

=item C<$UserSummaryTicketListFormat>

Control the appearance of the Active and Inactive ticket lists in the
User Summary.

=cut

Set($UserSummaryTicketListFormat, q{
       '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__id__</a></B>/TITLE:#',
       '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__Subject__</a></B>/TITLE:Subject',
       Status,
       QueueName,
       Owner,
       Priority,
       '__NEWLINE__',
       '',
       '<small>__Requestors__</small>',
       '<small>__CreatedRelative__</small>',
       '<small>__ToldRelative__</small>',
       '<small>__LastUpdatedRelative__</small>',
       '<small>__TimeLeft__</small>'
});

=item C<$WebBaseURL>, C<$WebURL>

Usually you don't want to set these options. The only obvious reason
is if RT is accessible via https protocol on a non standard port, e.g.
'https://rt.example.com:9999'. In all other cases these options are
computed using C<$WebDomain>, C<$WebPort> and C<$WebPath>.

C<$WebBaseURL> is the scheme, server and port
(e.g. 'http://rt.example.com') for constructing URLs to the web
UI. C<$WebBaseURL> doesn't need a trailing /.

C<$WebURL> is the C<$WebBaseURL>, C<$WebPath> and trailing /, for
example: 'http://www.example.com/rt/'.

=cut

my $port = RT->Config->Get('WebPort');
Set($WebBaseURL,
    ($port == 443? 'https': 'http') .'://'
    . RT->Config->Get('WebDomain')
    . ($port != 80 && $port != 443? ":$port" : '')
);

Set($WebURL, RT->Config->Get('WebBaseURL') . RT->Config->Get('WebPath') . "/");

=item C<$WebImagesURL>

C<$WebImagesURL> points to the base URL where RT can find its images.
Define the directory name to be used for images in RT web documents.

=cut

Set($WebImagesURL, RT->Config->Get('WebPath') . "/static/images/");

=item C<$LogoURL>

C<$LogoURL> points to the URL of the RT logo displayed in the web UI.
This can also be configured via the web UI.

=cut

Set($LogoURL, RT->Config->Get('WebImagesURL') . "bpslogo.png");

=item C<$LogoLinkURL>

C<$LogoLinkURL> is the URL that the RT logo hyperlinks to.

=cut

Set($LogoLinkURL, "http://bestpractical.com");

=item C<$LogoAltText>

C<$LogoAltText> is a string of text for the alt-text of the logo. It
will be passed through C<loc> for localization.

=cut

Set($LogoAltText, "Best Practical Solutions, LLC corporate logo");

=item C<$WebNoAuthRegex>

What portion of RT's URL space should not require authentication.  The
default is almost certainly correct, and should only be changed if you
are extending RT.

=cut

Set($WebNoAuthRegex, qr{^ (?:/+NoAuth/ | /+REST/\d+\.\d+/NoAuth/) }x );

=item C<$SelfServiceRegex>

What portion of RT's URLspace should be accessible to Unprivileged
users This does not override the redirect from F</Ticket/Display.html>
to F</SelfService/Display.html> when Unprivileged users attempt to
access ticked displays.

=cut

Set($SelfServiceRegex, qr!^(?:/+SelfService/)!x );

=item C<$WebFlushDbCacheEveryRequest>

By default, RT clears its database cache after every page view.  This
ensures that you've always got the most current information when
working in a multi-process (mod_perl or FastCGI) Environment.  Setting
C<$WebFlushDbCacheEveryRequest> to 0 will turn this off, which will
speed RT up a bit, at the expense of a tiny bit of data accuracy.

=cut

Set($WebFlushDbCacheEveryRequest, 1);

=item C<%ChartFont>

The L<GD> module (which RT uses for graphs) ships with a built-in font
that doesn't have full Unicode support. You can use a given TrueType
font for a specific language by setting %ChartFont to (language =E<gt>
the absolute path of a font) pairs. Your GD library must have support
for TrueType fonts to use this option. If there is no entry for a
language in the hash then font with 'others' key is used.

RT comes with two TrueType fonts covering most available languages.

=cut

Set(
    %ChartFont,
    'zh-cn'  => "$RT::FontPath/DroidSansFallback.ttf",
    'zh-tw'  => "$RT::FontPath/DroidSansFallback.ttf",
    'ja'     => "$RT::FontPath/DroidSansFallback.ttf",
    'others' => "$RT::FontPath/DroidSans.ttf",
);

=item C<$ChartsTimezonesInDB>

RT stores dates using the UTC timezone in the DB, so charts grouped by
dates and time are not representative. Set C<$ChartsTimezonesInDB> to 1
to enable timezone conversions using your DB's capabilities. You may
need to do some work on the DB side to use this feature, read more in
F<docs/customizing/timezones_in_charts.pod>.

At this time, this feature only applies to MySQL and PostgreSQL.

=cut

Set($ChartsTimezonesInDB, 0);

=item C<@ChartColors>

An array of 6-digit hexadecimal RGB color values used for chart series.  By
default there are 12 distinct colors.

=cut

Set(@ChartColors, qw(
    66cc66 ff6666 ffcc66 663399
    3333cc 339933 993333 996633
    33cc33 cc3333 cc9933 6633cc
));

=back



=head2 Home page

=over 4

=item C<$DefaultSummaryRows>

C<$DefaultSummaryRows> is default number of rows displayed in for
search results on the front page.

=cut

Set($DefaultSummaryRows, 10);

=item C<$HomePageRefreshInterval>

C<$HomePageRefreshInterval> is default number of seconds to refresh
the RT home page. Choose from [0, 120, 300, 600, 1200, 3600, 7200].

=cut

Set($HomePageRefreshInterval, 0);

=item C<$HomepageComponents>

C<$HomepageComponents> is an arrayref of allowed components on a
user's customized homepage ("RT at a glance").

=cut

Set(
    $HomepageComponents,
    [
        qw(QuickCreate QueueList MyAdminQueues MySupportQueues MyReminders RefreshHomepage Dashboards SavedSearches FindUser MyAssets FindAsset) # loc_qw
    ]
);

=back




=head2 Ticket search

=over 4

=item C<$UseSQLForACLChecks>

Historically, ACLs were checked on display, which could lead to empty
search pages and wrong ticket counts.  Set C<$UseSQLForACLChecks> to 0
to go back to this method; this will reduce the complexity of the
generated SQL statements, at the cost of the aforementioned bugs.

=cut

Set($UseSQLForACLChecks, 1);

=item C<$TicketsItemMapSize>

On the display page of a ticket from search results, RT provides links
to the first, next, previous and last ticket from the results.  In
order to build these links, RT needs to fetch the full result set from
the database, which can be resource-intensive.

Set C<$TicketsItemMapSize> to number of tickets you want RT to examine
to build these links. If the full result set is larger than this
number, RT will omit the "last" link in the menu.  Set this to zero to
always examine all results.

=cut

Set($TicketsItemMapSize, 1000);

=item C<$SearchResultsRefreshInterval>

C<$SearchResultsRefreshInterval> is default number of seconds to
refresh search results in RT. Choose from [0, 120, 300, 600, 1200,
3600, 7200].

=cut

Set($SearchResultsRefreshInterval, 0);

=item C<$DefaultSearchResultFormat>

C<$DefaultSearchResultFormat> is the default format for RT search
results

=cut

Set ($DefaultSearchResultFormat, qq{
   '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__id__</a></B>/TITLE:#',
   '<B><A HREF="__WebPath__/Ticket/Display.html?id=__id__">__Subject__</a></B>/TITLE:Subject',
   Status,
   QueueName,
   Owner,
   Priority,
   '__NEWLINE__',
   '__NBSP__',
   '<small>__Requestors__</small>',
   '<small>__CreatedRelative__</small>',
   '<small>__ToldRelative__</small>',
   '<small>__LastUpdatedRelative__</small>',
   '<small>__TimeLeft__</small>'});

=item C<$DefaultSearchResultOrderBy>

What Tickets column should we order by for RT Ticket search results.

=cut

Set($DefaultSearchResultOrderBy, 'id');

=item C<$DefaultSearchResultOrder>

When ordering RT Ticket search results by C<$DefaultSearchResultOrderBy>,
should the sort be ascending (ASC) or descending (DESC).

=cut

Set($DefaultSearchResultOrder, 'ASC');

=item C<$DefaultSelfServiceSearchResultFormat>

C<$DefaultSelfServiceSearchResultFormat> is the default format of
searches displayed in the SelfService interface.

=cut

Set($DefaultSelfServiceSearchResultFormat, qq{
   '<B><A HREF="__WebPath__/SelfService/Display.html?id=__id__">__id__</a></B>/TITLE:#',
   '<B><A HREF="__WebPath__/SelfService/Display.html?id=__id__">__Subject__</a></B>/TITLE:Subject',
   Status,
   Requestors,
   Owner});

=item C<%FullTextSearch>

Full text search (FTS) without database indexing is a very slow
operation, and is thus disabled by default.

Before setting C<Indexed> to 1, read F<docs/full_text_indexing.pod> for
the full details of FTS on your particular database.

It is possible to enable FTS without database indexing support, simply
by setting the C<Enable> key to 1, while leaving C<Indexed> set to 0.
This is not generally suggested, as unindexed full-text searching can
cause severe performance problems.

=cut

Set(%FullTextSearch,
    Enable  => 0,
    Indexed => 0,
);

=item C<$DontSearchFileAttachments>

If C<$DontSearchFileAttachments> is set to 1, then uploaded files
(attachments with file names) are not searched during content
search.

Note that if you use indexed FTS then named attachments are still
indexed by default regardless of this option.

=cut

Set($DontSearchFileAttachments, undef);

=item C<$OnlySearchActiveTicketsInSimpleSearch>

When query in simple search doesn't have status info, use this to only
search active ones.

=cut

Set($OnlySearchActiveTicketsInSimpleSearch, 1);

=item C<$SearchResultsAutoRedirect>

When only one ticket is found in search, use this to redirect to the
ticket display page automatically.

=cut

Set($SearchResultsAutoRedirect, 0);

=back



=head2 Ticket display

=over 4

=item C<$ShowMoreAboutPrivilegedUsers>

This determines if the 'More about requestor' box on
Ticket/Display.html is shown for Privileged Users.

=cut

Set($ShowMoreAboutPrivilegedUsers, 0);

=item C<$MoreAboutRequestorTicketList>

This can be set to Active, Inactive, All or None.  It controls what
ticket list will be displayed in the 'More about requestor' box on
Ticket/Display.html.  This option can be controlled by users also.

=cut

Set($MoreAboutRequestorTicketList, "Active");

=item C<$MoreAboutRequestorTicketListFormat>

Control the appearance of the ticket lists in the 'More About Requestors' box.

=cut

Set($MoreAboutRequestorTicketListFormat, q{
       '<a href="__WebPath__/Ticket/Display.html?id=__id__">__id__</a>',
       '__Owner__',
       '<a href="__WebPath__/Ticket/Display.html?id=__id__">__Subject__</a>',
       '__Status__',
});


=item C<$MoreAboutRequestorExtraInfo>

By default, the 'More about requestor' box on Ticket/Display.html
shows the Requestor's name and ticket list.  If you would like to see
extra information about the user, this expects a Format string of user
attributes.  Please note that not all the attributes are supported in
this display because we're not building a table.

Example:
C<Set($MoreAboutRequestorExtraInfo,"Organization, Address1")>

=cut

Set($MoreAboutRequestorExtraInfo, "");

=item C<$MoreAboutRequestorGroupsLimit>

By default, the 'More about requestor' box on Ticket/Display.html
shows all the groups of the Requestor.  Use this to limit the number
of groups; a value of undef removes the group display entirely.

=cut

Set($MoreAboutRequestorGroupsLimit, 0);

=item C<$UseSideBySideLayout>

Should the ticket create and update forms use a more space efficient
two column layout.  This layout may not work in narrow browsers if you
set a MessageBoxWidth (below).

=cut

Set($UseSideBySideLayout, 1);

=item C<$EditCustomFieldsSingleColumn>

When displaying a list of Ticket Custom Fields for editing, RT
defaults to a 2 column list.  If you set this to 1, it will instead
display the Custom Fields in a single column.

=cut

Set($EditCustomFieldsSingleColumn, 0);

=item C<$ShowUnreadMessageNotifications>

If set to 1, RT will prompt users when there are new,
unread messages on tickets they are viewing.

=cut

Set($ShowUnreadMessageNotifications, 0);

=item C<$AutocompleteOwners>

If set to 1, the owner drop-downs for ticket update/modify and the query
builder are replaced by text fields that autocomplete.  This can
alleviate the sometimes huge owner list for installations where many
users have the OwnTicket right.

Autocompleter is automatically turned on if list contains more than
50 users, but penalty of executing potentially slow query is still paid.

Drop down doesn't show unprivileged users. If your setup allows unprivileged
to own ticket then you have to enable autocompleting.

=cut

Set($AutocompleteOwners, 0);

=item C<$AutocompleteOwnersForSearch>

If set to 1, the owner drop-downs for the query builder are always
replaced by text field that autocomplete and C<$AutocompleteOwners>
is ignored. Helpful when owners list is huge in the query builder.

=cut

Set($AutocompleteOwnersForSearch, 0);

=item C<$UserSearchFields>

Used by the User Autocompleter as well as the User Search.

Specifies which fields of L<RT::User> to match against and how to match
each field when autocompleting users.  Valid match methods are LIKE,
STARTSWITH, ENDSWITH, =, and !=.  Valid search fields are the core User
fields, as well as custom fields, which are specified as "CF.1234" or
"CF.Name"

=cut

Set($UserSearchFields, {
    EmailAddress => 'STARTSWITH',
    Name         => 'STARTSWITH',
    RealName     => 'LIKE',
});

=item C<$AllowUserAutocompleteForUnprivileged>

Should unprivileged users (users of SelfService) be allowed to
autocomplete users. Setting this option to 1 means unprivileged users
will be able to search all your users.

=cut

Set($AllowUserAutocompleteForUnprivileged, 0);

=item C<$TicketAutocompleteFields>

Specifies which fields of L<RT::Ticket> to match against and how to match each
field when autocompleting users.  Valid match methods are LIKE, STARTSWITH,
ENDSWITH, C<=>, and C<!=>.

Not all Ticket fields are publically accessible and hence won't work for
autocomplete unless you override their accessibility using a local overlay or a
plugin.  Out of the box the following fields are public: id, Subject.

=cut

Set( $TicketAutocompleteFields, {
    id      => 'STARTSWITH',
    Subject => 'LIKE',
});

=item C<$DisplayTicketAfterQuickCreate>

Enable this to redirect to the created ticket display page
automatically when using QuickCreate.

=cut

Set($DisplayTicketAfterQuickCreate, 0);

=item C<$WikiImplicitLinks>

Support implicit links in WikiText custom fields?  Setting this to 1
causes InterCapped or ALLCAPS words in WikiText fields to automatically
become links to searches for those words.  If used on Articles, it links
to the Article with that name.

=cut

Set($WikiImplicitLinks, 0);

=item C<$PreviewScripMessages>

Set C<$PreviewScripMessages> to 1 if the scrips preview on the ticket
reply page should include the content of the messages to be sent.

=cut

Set($PreviewScripMessages, 0);

=item C<$SimplifiedRecipients>

If C<$SimplifiedRecipients> is set, a simple list of who will receive
B<any> kind of mail will be shown on the ticket reply page, instead of a
detailed breakdown by scrip.

=cut

Set($SimplifiedRecipients, 0);

=item C<$SquelchedRecipients>

If C<$SquelchedRecipients> is set, the checkbox list of who will receive
B<any> kind of mail on the ticket reply page are displayed initially as
B<un>checked - which means nobody in that list would get any mail. It
does not affect correspondence done via email yet.

=cut

Set($SquelchedRecipients, 0);

=item C<$HideResolveActionsWithDependencies>

If set to 1, this option will skip ticket menu actions which can't be
completed successfully because of outstanding active Depends On tickets.

By default, all ticket actions are displayed in the menu even if some of
them can't be successful until all Depends On links are resolved or
transitioned to another inactive status.

=cut

Set($HideResolveActionsWithDependencies, 0);

=item C<$HideUnsetFieldsOnDisplay>

This determines if we should hide unset fields on ticket display page.
Set this to 1 to hide unset fields.

=cut

Set($HideUnsetFieldsOnDisplay, 0);

=back


=head2 Articles

=over 4

=item C<$ArticleOnTicketCreate>

Set this to 1 to display the Articles interface on the Ticket Create
page in addition to the Reply/Comment page.

=cut

Set($ArticleOnTicketCreate, 0);

=item C<$HideArticleSearchOnReplyCreate>

Set this to 1 to hide the search and include boxes from the Article
UI.  This assumes you have enabled Article Hotlist feature, otherwise
you will have no access to Articles.

=cut

Set($HideArticleSearchOnReplyCreate, 0);

=back

=head1 Assets

=over 4

=item C<@AssetQueues>

This should be a list of names of queues whose tickets should always
display the "Assets" box.  This is useful for queues which deal
primarily with assets, as it provides a ready box to link an asset to
the ticket, even when the ticket has no related assets yet.

=cut

# Set(@AssetQueues, ());

=item C<$DefaultCatalog>

This provides the default catalog after a user initially logs in.
However, the default catalog is "sticky," and so will remember the
last-selected catalog thereafter.

=cut

# Set($DefaultCatalog, 'General assets');

=item C<$AssetSearchFields>

Specifies which fields of L<RT::Asset> to match against and how to match
each field when performing a quick search on assets.  Valid match
methods are LIKE, STARTSWITH, ENDSWITH, =, and !=.  Valid search fields
are id, Name, Description, or custom fields, which are specified as
"CF.1234" or "CF.Name"

=cut

Set($AssetSearchFields, {
    id          => '=',
    Name        => 'LIKE',
    Description => 'LIKE',
}) unless $AssetSearchFields;

=item C<$AssetSearchFormat>

The format that results of the asset search are displayed with.  This is
either a string, which will be used for all catalogs, or a hash
reference, keyed by catalog's name/id.  If a hashref and neither name or
id is found therein, falls back to the key ''.

If you wish to use the multiple catalog format, your configuration would look
something like:

    Set($AssetSearchFormat, {
        'General assets' => q[Format String for the General Assets Catalog],
        8                => q[Format String for Catalog 8],
        ''               => q[Format String for any catalogs not listed explicitly],
    });

=cut

# loc('Related tickets')
Set($AssetSearchFormat, q[
    '<a href="__WebHomePath__/Asset/Display.html?id=__id__">__Name__</a>/TITLE:Name',
    Description,
    '__Status__ (__Catalog__)/TITLE:Status',
    Owner,
    HeldBy,
    Contacts,
    '__ActiveTickets__ __InactiveTickets__/TITLE:Related tickets',
]) unless $AssetSearchFormat;

=item C<$AssetSummaryFormat>

The information that is displayed on ticket display pages about assets
related to the ticket.  This is displayed in a table beneath the asset
name.

=cut

Set($AssetSummaryFormat, q[
    '<a href="__WebHomePath__/Asset/Display.html?id=__id__">__Name__</a>/TITLE:Name',
    Description,
    '__Status__ (__Catalog__)/TITLE:Status',
    Owner,
    HeldBy,
    Contacts,
    '__ActiveTickets__ __InactiveTickets__/TITLE:Related tickets',
]) unless $AssetSummaryFormat;

=item C<$AssetSummaryRelatedTicketsFormat>

The information that is displayed on ticket display pages about tickets
related to assets related to the ticket.  This is displayed as a list of
tickets underneath the asset properties.

=cut

Set($AssetSummaryRelatedTicketsFormat, q[
    '<a href="__WebPath__/Ticket/Display.html?id=__id__">__id__</a>',
    '(__OwnerName__)',
    '<a href="__WebPath__/Ticket/Display.html?id=__id__">__Subject__</a>',
    QueueName,
    Status,
]) unless $AssetSummaryRelatedTicketsFormat;

=item C<$AssetBasicCustomFieldsOnCreate>

Specify a list of Asset custom fields to show in "Basics" widget on create.

e.g.

Set( $AssetBasicCustomFieldsOnCreate, [ 'foo', 'bar' ] );

=cut

# Set($AssetBasicCustomFieldsOnCreate, undef );

=back

=head2 Message box properties

=over 4

=item C<$MessageBoxWidth>, C<$MessageBoxHeight>

For message boxes, set the entry box width, height and what type of
wrapping to use.  These options can be overridden by users in their
preferences.

When the width is set to undef, no column count is specified and the
message box will take up 100% of the available width.  Combining this
with HARD messagebox wrapping (below) is not recommended, as it will
lead to inconsistent width in transactions between browsers.

These settings only apply to the non-RichText message box.  See below
for Rich Text settings.

=cut

Set($MessageBoxWidth, undef);
Set($MessageBoxHeight, 15);

=item C<$MessageBoxRichText>

Should "rich text" editing be enabled? This option lets your users
send HTML email messages from the web interface.

=cut

Set($MessageBoxRichText, 1);

=item C<$MessageBoxRichTextHeight>

Height of rich text JavaScript enabled editing boxes (in pixels)

=cut

Set($MessageBoxRichTextHeight, 200);

=item C<$MessageBoxIncludeSignature>

Should your users' signatures (from their Preferences page) be
included in Comments and Replies.

=cut

Set($MessageBoxIncludeSignature, 1);

=item C<$MessageBoxIncludeSignatureOnComment>

Should your users' signatures (from their Preferences page) be
included in Comments. Setting this to 0 overrides
C<$MessageBoxIncludeSignature>.

=cut

Set($MessageBoxIncludeSignatureOnComment, 1);

=back


=head2 Transaction display

=over 4

=item C<$OldestTransactionsFirst>

By default, RT shows newest transactions at the bottom of the ticket
history page, if you want see them at the top set this to 0.  This
option can be overridden by users in their preferences.

=cut

Set($OldestTransactionsFirst, 1);

=item C<$ShowHistory>

This option controls how history is shown on the ticket display page.  It
accepts one of three possible modes and is overrideable on a per-user
preference level.  If you regularly deal with long tickets and don't care much
about the history, you may wish to change this option to C<click>.

=over

=item C<delay> (the default)

When set to C<delay>, history is loaded via javascript after the rest of the
page has been loaded.  This speeds up apparent page load times and generally
provides a smoother experience.  You may notice slight delays before the ticket
history appears on very long tickets.

=item C<click>

When set to C<click>, history is loaded on demand when a placeholder link is
clicked.  This speeds up ticket display page loads and history is never loaded
if not requested.

=item C<always>

When set to C<always>, history is loaded before showing the page.  This ensures
history is always available immediately, but at the expense of longer page load
times.  This behaviour was the default in RT 4.0.

=back

=cut

Set($ShowHistory, 'delay');

=item C<$ShowBccHeader>

By default, RT hides from the web UI information about blind copies
user sent on reply or comment.

=cut

Set($ShowBccHeader, 0);

=item C<$TrustHTMLAttachments>

If C<TrustHTMLAttachments> is not defined, we will display them as
text. This prevents malicious HTML and JavaScript from being sent in a
request (although there is probably more to it than that)

=cut

Set($TrustHTMLAttachments, undef);

=item C<$AlwaysDownloadAttachments>

Always download attachments, regardless of content type. If set, this
overrides C<TrustHTMLAttachments>.

=cut

Set($AlwaysDownloadAttachments, undef);

=item C<$PreferRichText>

By default, RT shows rich text (HTML) messages if possible.  If
C<$PreferRichText> is set to 0, RT will show plain text messages in
preference to any rich text alternatives.

As a security precaution, RT limits the HTML that is displayed to a
known-good subset -- as allowing arbitrary HTML to be displayed exposes
multiple vectors for XSS and phishing attacks.  If
L</$TrustHTMLAttachments> is enabled, the original HTML is available for
viewing via the "Download" link.

If the optional L<HTML::Gumbo> dependency is installed, RT will leverage
this to allow a broader set of HTML through, including tables.

=cut

Set($PreferRichText, 1);

=item C<$MaxInlineBody>

C<$MaxInlineBody> is the maximum textual attachment size that we want to
see inline when viewing a transaction.  RT will inline any text if the
value is undefined or 0.  This option can be overridden by users in
their preferences.  The default is 25k.

=cut

Set($MaxInlineBody, 25 * 1024);

=item C<$ShowTransactionImages>

By default, RT shows images attached to incoming (and outgoing) ticket
updates inline. Set this variable to 0 if you'd like to disable that
behavior.

=cut

Set($ShowTransactionImages, 1);

=item C<$ShowRemoteImages>

By default, RT doesn't show remote images attached to incoming (and outgoing)
ticket updates inline.  Set this variable to 1 if you'd like to enable remote
image display.  Showing remote images may allow spammers and other senders to
track when messages are viewed and see referer information.

Note that this setting is independent of L</$ShowTransactionImages> above.

=cut

Set($ShowRemoteImages, 0);

=item C<$PlainTextMono>

Normally plaintext attachments are displayed as HTML with line breaks
preserved.  This causes space- and tab-based formatting not to be
displayed correctly.  Set C<$PlainTextMono> to 1 to use a monospaced
font and preserve formatting.

=cut

Set($PlainTextMono, 0);

=item C<$SuppressInlineTextFiles>

If C<$SuppressInlineTextFiles> is set to 1, then uploaded text files
(text-type attachments with file names) are prevented from being
displayed in-line when viewing a ticket's history.

=cut

Set($SuppressInlineTextFiles, undef);


=item C<@Active_MakeClicky>

MakeClicky detects various formats of data in headers and email
messages, and extends them with supporting links.  By default, RT
provides two formats:

* 'httpurl': detects http:// and https:// URLs and adds '[Open URL]'
  link after the URL.

* 'httpurl_overwrite': also detects URLs as 'httpurl' format, but
  replaces the URL with a link.  Enabled by default.

See F<share/html/Elements/MakeClicky> for documentation on how to add
your own styles of link detection.

=cut

Set(@Active_MakeClicky, qw(httpurl_overwrite));

=item C<$QuoteFolding>

Quote folding is the hiding of old replies in transaction history.
It defaults to on.  Set this to 0 to disable it.

=cut

Set($QuoteFolding, 1);

=back


=head1 Application logic

=over 4

=item C<$ParseNewMessageForTicketCcs>

If C<$ParseNewMessageForTicketCcs> is set to 1, RT will attempt to
divine Ticket 'Cc' watchers from the To and Cc lines of incoming
messages that create new Tickets. This option does not apply to replies
or comments on existing Tickets. Be forewarned that if you have I<any>
addresses which forward mail to RT automatically and you enable this
option without modifying C<$RTAddressRegexp> below, you will get
yourself into a heap of trouble.

=cut

Set($ParseNewMessageForTicketCcs, undef);

=item C<$UseTransactionBatch>

Set C<$UseTransactionBatch> to 1 to execute transactions in batches,
such that a resolve and comment (for example) would happen
simultaneously, instead of as two transactions, unaware of each
others' existence.

=cut

Set($UseTransactionBatch, 1);

=item C<$StrictLinkACL>

When this feature is enabled a user needs I<ModifyTicket> rights on
both tickets to link them together; otherwise, I<ModifyTicket> rights
on either of them is sufficient.

=cut

Set($StrictLinkACL, 1);

=item C<$RedistributeAutoGeneratedMessages>

Should RT redistribute correspondence that it identifies as machine
generated?  A 1 will do so; setting this to 0 will cause no
such messages to be redistributed.  You can also use 'privileged' (the
default), which will redistribute only to privileged users. This helps
to protect against malformed bounces and loops caused by auto-created
requestors with bogus addresses.

=cut

Set($RedistributeAutoGeneratedMessages, "privileged");

=item C<$ApprovalRejectionNotes>

Should rejection notes from approvals be sent to the requestors?

=cut

Set($ApprovalRejectionNotes, 1);

=item C<$ForceApprovalsView>

Should approval tickets only be viewed and modified through the standard
approval interface?  With this setting enabled (by default), any attempt to use
the normal ticket display and modify page for approval tickets will be
redirected.

For example, with this option set to 1 and an approval ticket #123:

    /Ticket/Display.html?id=123

is redirected to

    /Approval/Display.html?id=123

With this option set to 0, the redirect won't happen.

=back

=cut

Set($ForceApprovalsView, 1);

=head1 Extra security

This is a list of extra security measures to enable that help keep your RT
safe.  If you don't know what these mean, you should almost certainly leave the
defaults alone.

=over 4

=item C<$DisallowExecuteCode>

If set to 1, the C<ExecuteCode> right will be removed from
all users, B<including> the superuser.  This is intended for when RT is
installed into a shared environment where even the superuser should not
be allowed to run arbitrary Perl code on the server via scrips.

=cut

Set($DisallowExecuteCode, 0);

=item C<$Framebusting>

If set to 0, framekiller javascript will be disabled and the
X-Frame-Options: DENY header will be suppressed from all responses.
This disables RT's clickjacking protection.

=cut

Set($Framebusting, 1);

=item C<$RestrictReferrer>

If set to 0, the HTTP C<Referer> (sic) header will not be
checked to ensure that requests come from RT's own domain.  As RT allows
for GET requests to alter state, disabling this opens RT up to
cross-site request forgery (CSRF) attacks.

=cut

Set($RestrictReferrer, 1);

=item C<$RestrictLoginReferrer>

If set to 0, RT will allow the user to log in from any link
or request, merely by passing in C<user> and C<pass> parameters; setting
it to 1 forces all logins to come from the login box, so the
user is aware that they are being logged in.  The default is off, for
backwards compatability.

=cut

Set($RestrictLoginReferrer, 0);

=item C<@ReferrerWhitelist>

This is a list of hostname:port combinations that RT will treat as being
part of RT's domain. This is particularly useful if you access RT as
multiple hostnames or have an external auth system that needs to
redirect back to RT once authentication is complete.

 Set(@ReferrerWhitelist, qw(www.example.com:443  www3.example.com:80));

If the "RT has detected a possible cross-site request forgery" error is triggered
by a host:port sent by your browser that you believe should be valid, you can copy
the host:port from the error message into this list.

Simple wildcards, similar to SSL certificates, are allowed.  For example:

    *.example.com:80    # matches foo.example.com
                        # but not example.com
                        #      or foo.bar.example.com

    www*.example.com:80 # matches www3.example.com
                        #     and www-test.example.com
                        #     and www.example.com

=cut

Set(@ReferrerWhitelist, qw());

=item C<%ReferrerComponents>

C<%ReferrerComponents> is the hash to customize referrer checking behavior when
C<$RestrictReferrer> is enabled, where you can whitelist or blacklist the
components along with their query args. e.g.

    Set( %ReferrerComponents,
        ( '/Foo.html' => 1, '/Bar.html' => 0, '/Baz.html' => [ 'id', 'results' ] )
    );

With this, '/Foo.html' will be whitelisted, and '/Bar.html' will be blacklisted.
'/Baz.html' with id/results query arguments will be whitelisted but blacklisted
if there are other query arguments.

=cut

Set( %ReferrerComponents );

=item C<$BcryptCost>

This sets the default cost parameter used for the C<bcrypt> key
derivation function.  Valid values range from 4 to 31, inclusive, with
higher numbers denoting greater effort.

=cut

Set($BcryptCost, 11);

=back



=head1 Authorization and user configuration

=over 4

=item C<$WebRemoteUserAuth>

If C<$WebRemoteUserAuth> is defined, RT will defer to the environment's
REMOTE_USER variable, which should be set by the webserver's
authentication layer.

=cut

Set($WebRemoteUserAuth, undef);

=item C<$WebRemoteUserContinuous>

If C<$WebRemoteUserContinuous> is defined, RT will check for the
REMOTE_USER on each access.  If you would prefer this to only happen
once (at initial login) set this to 0.  The default
setting will help ensure that if your webserver's authentication layer
deauthenticates a user, RT notices as soon as possible.

=cut

Set($WebRemoteUserContinuous, 1);

=item C<$WebFallbackToRTLogin>

If C<$WebFallbackToRTLogin> is defined, the user is allowed a
chance of fallback to the login screen, even if REMOTE_USER failed.

=cut

Set($WebFallbackToRTLogin, undef);

=item C<$WebRemoteUserGecos>

C<$WebRemoteUserGecos> means to match 'gecos' field as the user
identity; useful with C<mod_auth_external>.

=cut

Set($WebRemoteUserGecos, undef);

=item C<$WebRemoteUserAutocreate>

C<$WebRemoteUserAutocreate> will create users under the same name as
REMOTE_USER upon login, if they are missing from the Users table.

=cut

Set($WebRemoteUserAutocreate, undef);

=item C<$UserAutocreateDefaultsOnLogin>

If C<$WebRemoteUserAutocreate> is set to 1, C<$UserAutocreateDefaultsOnLogin>
will be passed to L<RT::User/Create>.  Use it to set defaults, such as
creating unprivileged users with C<<{ Privileged => 0 }>>.  This must be
a hashref.

=cut

Set($UserAutocreateDefaultsOnLogin, undef);

=item C<$WebSessionClass>

C<$WebSessionClass> is the class you wish to use for storing sessions.  On
MySQL, Pg, and Oracle it defaults to using your database, in other cases
sessions are stored in files using L<Apache::Session::File>. Other installed
Apache::Session::* modules can be used to store sessions.

    Set($WebSessionClass, "Apache::Session::File");

=cut

Set($WebSessionClass, undef);

=item C<%WebSessionProperties>

C<%WebSessionProperties> is the hash to configure class L</$WebSessionClass>
in case custom class is used. By default it's empty and values are picked
depending on the class. Make sure that it's empty if you're using DB as session
backend.

=cut

Set( %WebSessionProperties );

=item C<$AutoLogoff>

By default, RT's user sessions persist until a user closes his or her
browser. With the C<$AutoLogoff> option you can setup session lifetime
in minutes. A user will be logged out if he or she doesn't send any
requests to RT for the defined time.

=cut

Set($AutoLogoff, 0);

=item C<$LogoutRefresh>

The number of seconds to wait after logout before sending the user to
the login page. By default, 1 second, though you may want to increase
this if you display additional information on the logout page.

=cut

Set($LogoutRefresh, 1);

=item C<$WebSecureCookies>

By default, RT's session cookie isn't marked as "secure". Some web
browsers will treat secure cookies more carefully than non-secure
ones, being careful not to write them to disk, only sending them over
an SSL secured connection, and so on. To enable this behavior, set
C<$WebSecureCookies> to 1.  NOTE: You probably don't want to turn this
on I<unless> users are only connecting via SSL encrypted HTTPS
connections.

=cut

Set($WebSecureCookies, 0);

=item C<$WebHttpOnlyCookies>

Default RT's session cookie to not being directly accessible to
javascript.  The content is still sent during regular and AJAX requests,
and other cookies are unaffected, but the session-id is less
programmatically accessible to javascript.  Turning this off should only
be necessary in situations with odd client-side authentication
requirements.

=cut

Set($WebHttpOnlyCookies, 1);

=item C<$MinimumPasswordLength>

C<$MinimumPasswordLength> defines the minimum length for user
passwords. Setting it to 0 disables this check.

=cut

Set($MinimumPasswordLength, 5);

=back


=head1 Internationalization

=over 4

=item C<@LexiconLanguages>

An array that contains languages supported by RT's
internationalization interface.  Defaults to all *.po lexicons;
setting it to C<qw(en ja)> will make RT bilingual instead of
multilingual, but will save some memory.

=cut

Set(@LexiconLanguages, qw(*));

=item C<@EmailInputEncodings>

An array that contains default encodings used to guess which charset
an attachment uses, if it does not specify one explicitly.  All
options must be recognized by L<Encode::Guess>.  The first element may
also be '*', which enables encoding detection using
L<Encode::Detect::Detector>, if installed.

=cut

Set(@EmailInputEncodings, qw(utf-8 iso-8859-1 us-ascii));

=item C<$EmailOutputEncoding>

The charset for localized email.  Must be recognized by Encode.

=cut

Set($EmailOutputEncoding, "utf-8");

=back







=head1 Date and time handling

=over 4

=item C<$DateTimeFormat>

You can choose date and time format.  See the "Output formatters"
section in perldoc F<lib/RT/Date.pm> for more options.  This option
can be overridden by users in their preferences.

Some examples:

C<Set($DateTimeFormat, "LocalizedDateTime");>
C<Set($DateTimeFormat, { Format => "ISO", Seconds => 0 });>
C<Set($DateTimeFormat, "RFC2822");>
C<Set($DateTimeFormat, { Format => "RFC2822", Seconds => 0, DayOfWeek => 0 });>

=cut

Set($DateTimeFormat, "DefaultFormat");

# Next two options are for Time::ParseDate

=item C<$DateDayBeforeMonth>

Set this to 1 if your local date convention looks like "dd/mm/yy"
instead of "mm/dd/yy". Used only for parsing, not for displaying
dates.

=cut

Set($DateDayBeforeMonth, 1);

=item C<$AmbiguousDayInPast>, C<$AmbiguousDayInFuture>

Should an unspecified day or year in a date refer to a future or a
past value? For example, should a date of "Tuesday" default to mean
the date for next Tuesday or last Tuesday? Should the date "March 1"
default to the date for next March or last March?

Set C<$AmbiguousDayInPast> for the last date, or
C<$AmbiguousDayInFuture> for the next date; the default is usually
correct.  If both are set, C<$AmbiguousDayInPast> takes precedence.

=cut

Set($AmbiguousDayInPast, 0);
Set($AmbiguousDayInFuture, 0);

=item C<$DefaultTimeUnitsToHours>

Use this to set the default units for time entry to hours instead of
minutes.  Note that this only effects entry, not display.

=cut

Set($DefaultTimeUnitsToHours, 0);

=item C<$TimeInICal>

By default, events in the iCal feed on the ticket search page
contain only dates, making them all day calendar events. Set
C<$TimeInICal> if you have start or due dates on tickets that
have significant time values and you want those times to be
included in the events in the iCal feed.

This option can also be set as an individual user preference.

=cut

Set($TimeInICal, 0);

=item C<$PreferDateTimeFormatNatural>

By default, RT parses an unknown date first with L<Time::ParseDate>, and if
this fails with L<DateTime::Format::Natural>.
C<$PreferDateTimeFormatNatural> changes this behavior to first parse with
L<DateTime::Format::Natural>, and if this fails with L<Time::ParseDate>.
This gives you the possibility to use the more advanced features of
L<DateTime::Format::Natural>.
For example with L<Time::ParseDate> it isn't possible to get the
'first day of the last month', where L<DateTime::Format::Natural> supports
this with 'last month'.

Be aware that L<Time::ParseDate> and L<DateTime::Format::Natural> have
different definitions for the relative date and time syntax.
L<Time::ParseDate> returns for 'last month' this DayOfMonth from the last month.
L<DateTime::Format::Natural> returns for 'last month' the first day of the last
month. So changing this config option maybe changes the results of your saved
searches.

=cut

Set($PreferDateTimeFormatNatural, 0);

=back

=head1 Cryptography

A complete description of RT's cryptography capabilities can be found in
L<RT::Crypt>. At this moment, GnuPG (PGP) and SMIME security protocols are
supported.

=over 4

=item C<%Crypt>

The following options apply to all cryptography protocols.

By default, all enabled security protocols will analyze each incoming
email. You may set C<Incoming> to a subset of this list, if some enabled
protocols do not apply to incoming mail; however, this is usually
unnecessary.

For outgoing emails, the first security protocol from the above list is
used. Use the C<Outgoing> option to set a security protocol that should
be used in outgoing emails.  At this moment, only one protocol can be
used to protect outgoing emails.

Set C<RejectOnMissingPrivateKey> to 0 if you don't want to reject
emails encrypted for key RT doesn't have and can not decrypt.

Set C<RejectOnBadData> to 0 if you don't want to reject letters
with incorrect data.

If you want to allow people to encrypt attachments inside the DB then
set C<AllowEncryptDataInDB> to 1.

Set C<Dashboards> to a hash with Encrypt and Sign keys to control
whether dashboards should be encrypted and/or signed correspondingly.
By default they are not encrypted or signed.

=back

=cut

Set( %Crypt,
    Incoming                  => undef, # ['GnuPG', 'SMIME']
    Outgoing                  => undef, # 'SMIME'

    RejectOnMissingPrivateKey => 1,
    RejectOnBadData           => 1,

    AllowEncryptDataInDB      => 0,

    Dashboards => {
        Encrypt => 0,
        Sign    => 0,
    },
);

=head2 SMIME configuration

A full description of the SMIME integration can be found in
L<RT::Crypt::SMIME>.

=over 4

=item C<%SMIME>

Set C<Enable> to 0 or 1 to disable or enable SMIME for
encrypting and signing messages.

Set C<OpenSSL> to path to F<openssl> executable.

Set C<Keyring> to directory with key files.  Key and certificates should
be stored in a PEM file in this directory named named, e.g.,
F<email.address@example.com.pem>.

Set C<CAPath> to either a PEM-formatted certificate of a single signing
certificate authority, or a directory of such (including hash symlinks
as created by the openssl tool C<c_rehash>).  Only SMIME certificates
signed by these certificate authorities will be treated as valid
signatures.  If left unset (and C<AcceptUntrustedCAs> is unset, as it is
by default), no signatures will be marked as valid!

Set C<AcceptUntrustedCAs> to allow arbitrary SMIME certificates, no
matter their signing entities.  Such mails will be marked as untrusted,
but signed; C<CAPath> will be used to mark which mails are signed by
trusted certificate authorities.  This configuration is generally
insecure, as it allows the possibility of accepting forged mail signed
by an untrusted certificate authority.

Setting C<AcceptUntrustedCAs> also allows encryption to users with
certificates created by untrusted CAs.

Set C<Passphrase> to a scalar (to use for all keys), an anonymous
function, or a hash (to look up by address).  If the hash is used, the
'' key is used as a default.

See L<RT::Crypt::SMIME> for details.

=back

=cut

Set( %SMIME,
    Enable => 0,
    OpenSSL => 'openssl',
    Keyring => q{var/data/smime},
    CAPath => undef,
    AcceptUntrustedCAs => undef,
    Passphrase => undef,
);

=head2 GnuPG configuration

A full description of the (somewhat extensive) GnuPG integration can
be found by running the command `perldoc L<RT::Crypt::GnuPG>` (or
`perldoc lib/RT/Crypt/GnuPG.pm` from your RT install directory).

=over 4

=item C<%GnuPG>

Set C<Enable> to 0 or 1 to disable or enable GnuPG interfaces
for encrypting and signing outgoing messages.

Set C<GnuPG> to the name or path of the gpg binary to use.

Set C<Passphrase> to a scalar (to use for all keys), an anonymous
function, or a hash (to look up by address).  If the hash is used, the
'' key is used as a default.

Set C<OutgoingMessagesFormat> to 'inline' to use inline encryption and
signatures instead of 'RFC' (GPG/MIME: RFC3156 and RFC1847) format.

=cut

Set(%GnuPG,
    Enable                 => 0,
    GnuPG                  => 'gpg',
    Passphrase             => undef,
    OutgoingMessagesFormat => "RFC", # Inline
);

=item C<%GnuPGOptions>

Options to pass to the GnuPG program.

If you override this in your RT_SiteConfig, you should be sure to
include a homedir setting.

Note that options with '-' character MUST be quoted.

=cut

Set(%GnuPGOptions,
    homedir => q{var/data/gpg},

# URL of a keyserver
#    keyserver => 'hkp://subkeys.pgp.net',

# enables the automatic retrieving of keys when verifying signatures
#    'keyserver-options' => 'auto-key-retrieve',
);

=back

=head1 External storage

By default, RT stores attachments in the database.  ExternalStorage moves
all attachments that RT does not need efficient access to (which include
textual content and images) to outside of the database.  This may either
be on local disk, or to a cloud storage solution.  This decreases the
size of RT's database, in turn decreasing the burden of backing up RT's
database, at the cost of adding additional locations which must be
configured or backed up.  Attachment storage paths are calculated based
on file contents; this provides de-duplication.

A full description of external storage can be found by running the command
`perldoc L<RT::ExternalStorage>` (or `perldoc lib/RT/ExternalStorage.pm`
from your RT install directory).

Note that simply configuring L<RT::ExternalStorage> is insufficient; there
are additional steps required (including setup of a regularly-scheduled
upload job) to enable RT to make use of external storage.

=over 4

=item C<%ExternalStorage>

This selects which storage engine is used, as well as options for
configuring that specific storage engine. RT ships with the following
storage engines:

L<RT::ExternalStorage::Disk>, which stores files on directly onto disk.

L<RT::ExternalStorage::AmazonS3>, which stores files on Amazon's S3 service.

L<RT::ExternalStorage::Dropbox>, which stores files in Dropbox.

See each storage engine's documentation for the configuration it requires
and accepts.

    Set(%ExternalStorage,
        Type => 'Disk',
        Path => '/opt/rt4/var/attachments',
    );

=cut

Set(%ExternalStorage, ());

=item C<$ExternalStorageCutoffSize>

Certain object types, like values for Binary (aka file upload) custom
fields, are always put into external storage. However, for other
object types, like images and text, there is a line in the sand where
you want small objects in the database but large objects in external
storage. By default, objects larger than 10 MiB will be put into external
storage. C<$ExternalStorageCutoffSize> adjusts that line in the sand.

Note that changing this setting does not affect existing attachments, only
the new ones that C<sbin/rt-externalize-attachments> hasn't seen yet.

=cut

Set($ExternalStorageCutoffSize, 10*1024*1024);

=item C<$ExternalStorageDirectLink>

Certain ExternalStorage backends can serve files over HTTP.  For such
backends, RT can link directly to those files in external storage.  This
cuts down download time and relieves resource pressure because RT's web
server is no longer involved in retrieving and then immediately serving
each attachment.

Of the storage engines that RT ships, only
L<RT::ExternalStorage::AmazonS3> supports this feature, and you must
manually configure it to allow direct linking.

Set this to 1 to link directly to files in external storage.

=cut

Set($ExternalStorageDirectLink, 0);

=back

=head1 Lifecycles

=head2 Lifecycle definitions

Each lifecycle is a list of possible statuses split into three logic
sets: B<initial>, B<active> and B<inactive>. Each status in a
lifecycle must be unique. (Statuses may not be repeated across sets.)
Each set may have any number of statuses.

For example:

    default => {
        initial  => ['new'],
        active   => ['open', 'stalled'],
        inactive => ['resolved', 'rejected', 'deleted'],
        ...
    },

Status names can be from 1 to 64 ASCII characters.  Statuses are
localized using RT's standard internationalization and localization
system.

=over 4

=item initial

You can define multiple B<initial> statuses for tickets in a given
lifecycle.

RT will automatically set its B<Started> date when you change a
ticket's status from an B<initial> state to an B<active> or
B<inactive> status.

=item active

B<Active> tickets are "currently in play" - they're things that are
being worked on and not yet complete.

=item inactive

B<Inactive> tickets are typically in their "final resting state".

While you're free to implement a workflow that ignores that
description, typically once a ticket enters an inactive state, it will
never again enter an active state.

RT will automatically set the B<Resolved> date when a ticket's status
is changed from an B<Initial> or B<Active> status to an B<Inactive>
status.

B<deleted> is still a special status and protected by the
B<DeleteTicket> right, unless you re-defined rights (read below). If
you don't want to allow ticket deletion at any time simply don't
include it in your lifecycle.

=back

Statuses in each set are ordered and listed in the UI in the defined
order.

Changes between statuses are constrained by transition rules, as
described below.

=head2 Default values

In some cases a default value is used to display in UI or in API when
value is not provided. You can configure defaults using the following
syntax:

    default => {
        ...
        defaults => {
            on_create => 'new',
            on_resolve => 'resolved',
            ...
        },
    },

The following defaults are used.

=over 4

=item on_create

If you (or your code) doesn't specify a status when creating a ticket,
RT will use the this status. See also L</Statuses available during
ticket creation>.

=item approved

When an approval is accepted, the status of depending tickets will
be changed to this value.

=item denied

When an approval is denied, the status of depending tickets will
be changed to this value.

=item reminder_on_open

When a reminder is opened, the status will be changed to this value.

=item reminder_on_resolve

When a reminder is resolved, the status will be changed to this value.

=back

=head2 Transitions between statuses and UI actions

A B<Transition> is a change of status from A to B. You should define
all possible transitions in each lifecycle using the following format:

    default => {
        ...
        transitions => {
            ''       => [qw(new open resolved)],
            new      => [qw(open resolved rejected deleted)],
            open     => [qw(stalled resolved rejected deleted)],
            stalled  => [qw(open)],
            resolved => [qw(open)],
            rejected => [qw(open)],
            deleted  => [qw(open)],
        },
        ...
    },

The order of items in the listing for each transition line affects
the order they appear in the drop-down. If you change the config
for 'open' state listing to:

    open     => [qw(stalled rejected deleted resolved)],

then the 'resolved' status will appear as the last item in the drop-down.

=head3 Statuses available during ticket creation

By default users can create tickets with a status of new,
open, or resolved, but cannot create tickets with a status of
rejected, stalled, or deleted. If you want to change the statuses
available during creation, update the transition from '' (empty
string), like in the example above.

=head3 Protecting status changes with rights

A transition or group of transitions can be protected by a specific
right.  Additionally, you can name new right names, which will be added
to the system to control that transition.  For example, if you wished to
create a lesser right than ModifyTicket for rejecting tickets, you could
write:

    default => {
        ...
        rights => {
            '* -> deleted'  => 'DeleteTicket',
            '* -> rejected' => 'RejectTicket',
            '* -> *'        => 'ModifyTicket',
        },
        ...
    },

This would create a new C<RejectTicket> right in the system which you
could assign to whatever groups you choose.

On the left hand side you can have the following variants:

    '<from> -> <to>'
    '* -> <to>'
    '<from> -> *'
    '* -> *'

Valid transitions are listed in order of priority. If a user attempts
to change a ticket's status from B<new> to B<open> then the lifecycle
is checked for presence of an exact match, then for 'any to B<open>',
'B<new> to any' and finally 'any to any'.

If you don't define any rights, or there is no match for a transition,
RT will use the B<DeleteTicket> or B<ModifyTicket> as appropriate.

=head3 Labeling and defining actions

For each transition you can define an action that will be shown in the
UI; each action annotated with a label and an update type.

Each action may provide a default update type, which can be
B<Comment>, B<Respond>, or absent. For example, you may want your
staff to write a reply to the end user when they change status from
B<new> to B<open>, and thus set the update to B<Respond>.  Neither
B<Comment> nor B<Respond> are mandatory, and user may leave the
message empty, regardless of the update type.

This configuration can be used to accomplish what
$ResolveDefaultUpdateType was used for in RT 3.8.

Use the following format to define labels and actions of transitions:

    default => {
        ...
        actions => [
            'new -> open'     => { label => 'Open it', update => 'Respond' },
            'new -> resolved' => { label => 'Resolve', update => 'Comment' },
            'new -> rejected' => { label => 'Reject',  update => 'Respond' },
            'new -> deleted'  => { label => 'Delete' },

            'open -> stalled'  => { label => 'Stall',   update => 'Comment' },
            'open -> resolved' => { label => 'Resolve', update => 'Comment' },
            'open -> rejected' => { label => 'Reject',  update => 'Respond' },

            'stalled -> open'  => { label => 'Open it' },
            'resolved -> open' => { label => 'Re-open', update => 'Comment' },
            'rejected -> open' => { label => 'Re-open', update => 'Comment' },
            'deleted -> open'  => { label => 'Undelete' },
        ],
        ...
    },

In addition, you may define multiple actions for the same transition.
Alternately, you may use '* -> x' to match more than one transition.
For example:

    default => {
        ...
        actions => [
            ...
            'new -> rejected' => { label => 'Reject', update => 'Respond' },
            'new -> rejected' => { label => 'Quick Reject' },
            ...
            '* -> deleted' => { label => 'Delete' },
            ...
        ],
        ...
    },

=head2 Moving tickets between queues with different lifecycles

Unless there is an explicit mapping between statuses in two different
lifecycles, you can not move tickets between queues with these
lifecycles -- even if both use the exact same set of statuses.
Such a mapping is defined as follows:

    __maps__ => {
        'from lifecycle -> to lifecycle' => {
            'status in left lifecycle' => 'status in right lifecycle',
            ...
        },
        ...
    },

=cut

Set(%Lifecycles,
    default => {
        initial         => [qw(new)], # loc_qw
        active          => [qw(open stalled)], # loc_qw
        inactive        => [qw(resolved rejected deleted)], # loc_qw

        defaults => {
            on_create => 'new',
            approved  => 'open',
            denied    => 'rejected',
            reminder_on_open     => 'open',
            reminder_on_resolve  => 'resolved',
        },

        transitions => {
            ""       => [qw(new open resolved)],

            # from   => [ to list ],
            new      => [qw(    open stalled resolved rejected deleted)],
            open     => [qw(new      stalled resolved rejected deleted)],
            stalled  => [qw(new open         rejected resolved deleted)],
            resolved => [qw(new open stalled          rejected deleted)],
            rejected => [qw(new open stalled resolved          deleted)],
            deleted  => [qw(new open stalled rejected resolved        )],
        },
        rights => {
            '* -> deleted'  => 'DeleteTicket',
            '* -> *'        => 'ModifyTicket',
        },
        actions => [
            'new -> open'      => { label  => 'Open It', update => 'Respond' }, # loc{label}
            'new -> resolved'  => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'new -> rejected'  => { label  => 'Reject',  update => 'Respond' }, # loc{label}
            'new -> deleted'   => { label  => 'Delete',                      }, # loc{label}
            'open -> stalled'  => { label  => 'Stall',   update => 'Comment' }, # loc{label}
            'open -> resolved' => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'open -> rejected' => { label  => 'Reject',  update => 'Respond' }, # loc{label}
            'stalled -> open'  => { label  => 'Open It',                     }, # loc{label}
            'resolved -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'rejected -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'deleted -> open'  => { label  => 'Undelete',                    }, # loc{label}
        ],
    },
    assets => {
        type     => "asset",
        initial  => [ 
            'new' # loc
        ],
        active   => [ 
            'allocated', # loc
            'in-use' # loc
        ],
        inactive => [ 
            'recycled', # loc
            'stolen', # loc
            'deleted' # loc
        ],

        defaults => {
            on_create => 'new',
        },

        transitions => {
            ''        => [qw(new allocated in-use)],
            new       => [qw(allocated in-use stolen deleted)],
            allocated => [qw(in-use recycled stolen deleted)],
            "in-use"  => [qw(allocated recycled stolen deleted)],
            recycled  => [qw(allocated)],
            stolen    => [qw(allocated)],
            deleted   => [qw(allocated)],
        },
        rights => {
            '* -> *'        => 'ModifyAsset',
        },
        actions => {
            '* -> allocated' => { 
                label => "Allocate" # loc
            },
            '* -> in-use'    => { 
                label => "Now in-use" # loc
            },
            '* -> recycled'  => { 
                label => "Recycle" # loc
            },
            '* -> stolen'    => { 
                label => "Report stolen" # loc
            },
        },
    },
# don't change lifecyle of the approvals, they are not capable to deal with
# custom statuses
    approvals => {
        initial         => [ 'new' ],
        active          => [ 'open', 'stalled' ],
        inactive        => [ 'resolved', 'rejected', 'deleted' ],

        defaults => {
            on_create => 'new',
            reminder_on_open     => 'open',
            reminder_on_resolve  => 'resolved',
        },

        transitions => {
            ''       => [qw(new open resolved)],

            # from   => [ to list ],
            new      => [qw(open stalled resolved rejected deleted)],
            open     => [qw(new stalled resolved rejected deleted)],
            stalled  => [qw(new open rejected resolved deleted)],
            resolved => [qw(new open stalled rejected deleted)],
            rejected => [qw(new open stalled resolved deleted)],
            deleted  => [qw(new open stalled rejected resolved)],
        },
        rights => {
            '* -> deleted'  => 'DeleteTicket',
            '* -> rejected' => 'ModifyTicket',
            '* -> *'        => 'ModifyTicket',
        },
        actions => [
            'new -> open'      => { label  => 'Open It', update => 'Respond' }, # loc{label}
            'new -> resolved'  => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'new -> rejected'  => { label  => 'Reject',  update => 'Respond' }, # loc{label}
            'new -> deleted'   => { label  => 'Delete',                      }, # loc{label}
            'open -> stalled'  => { label  => 'Stall',   update => 'Comment' }, # loc{label}
            'open -> resolved' => { label  => 'Resolve', update => 'Comment' }, # loc{label}
            'open -> rejected' => { label  => 'Reject',  update => 'Respond' }, # loc{label}
            'stalled -> open'  => { label  => 'Open It',                     }, # loc{label}
            'resolved -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'rejected -> open' => { label  => 'Re-open', update => 'Comment' }, # loc{label}
            'deleted -> open'  => { label  => 'Undelete',                    }, # loc{label}
        ],
    },
);

=head1 SLA

=over 4

=item C<%ServiceAgreements>

    Set( %ServiceAgreements, (
        Default => '4h',
        QueueDefault => {
            'Incident' => '2h',
        },
        Levels => {
            '2h' => { Resolve => { RealMinutes => 60*2 } },
            '4h' => { Resolve => { RealMinutes => 60*4 } },
        },
    ));

In this example I<Incident> is the name of the queue, and I<2h> is the name of
the SLA which will be applied to this queue by default.

Each service level can be described using several options:
L<Starts|/"Starts (interval, first business minute)">,
L<Resolve|/"Resolve and Response (interval, no defaults)">,
L<Response|/"Resolve and Response (interval, no defaults)">,
L<KeepInLoop|/"Keep in loop (interval, no defaults)">,
L<OutOfHours|/"OutOfHours (struct, no default)">
and L<ServiceBusinessHours|/"Configuring business hours">.

=over 4

=item Starts (interval, first business minute)

By default when a ticket is created Starts date is set to
first business minute after time of creation. In other
words if a ticket is created during business hours then
Starts will be equal to Created time, otherwise Starts will
be beginning of the next business day.

However, if you provide 24/7 support then you most
probably would be interested in Starts to be always equal
to Created time.

Starts option can be used to adjust behaviour. Format
of the option is the same as format for deadlines which
described later in details. RealMinutes, BusinessMinutes
options and OutOfHours modifiers can be used here like
for any other deadline. For example:

    'standard' => {
        # give people 15 minutes
        Starts   => { BusinessMinutes => 15  },
    },

You can still use old option StartImmediately to set
Starts date equal to Created date.

Example:

    '24/7' => {
        StartImmediately => 1,
        Response => { RealMinutes => 30 },
    },

But it's the same as:

    '24/7' => {
        Starts => { RealMinutes => 0 },
        Response => { RealMinutes => 30 },
    },

=item Resolve and Response (interval, no defaults)

These two options define deadlines for resolve of a ticket
and reply to customer(requestors) questions accordingly.

You can define them using real time, business or both. Read more
about the latter L<below|/"Using both Resolve and Response in the same level">.

The Due date field is used to store calculated deadlines.

=over 4

=item Resolve

Defines deadline when a ticket should be resolved. This option is
quite simple and straightforward when used without L</Response>.

Example:

    # 8 business hours
    'simple' => { Resolve => 60*8 },
    ...
    # one real week
    'hard' => { Resolve => { RealMinutes => 60*24*7 } },

=item Response

In many companies providing support service(s) resolve time of a ticket
is less important than time of response to requestors from staff
members.

You can use Response option to define such deadlines.  The Due date is
set when a ticket is created, unset when a worker replies, and re-set
when the requestor replies again -- until the ticket is closed, when the
ticket's Due date is unset.

B<NOTE> that this behaviour changes when Resolve and Response options
are combined; see L</"Using both Resolve and Response in the same
level">.

Note that by default, only the requestors on the ticket are considered
"outside actors" and thus require a Response due date; all other email
addresses are treated as workers of the ticket, and thus count as
meeting the SLA.  If you'd like to invert this logic, so that the Owner
and AdminCcs are the only worker email addresses, and all others are
external, see the L</AssumeOutsideActor> configuration.

The owner is never treated as an outside actor; if they are also the
requestor of the ticket, it will have no SLA.

If an outside actor replies multiple times, their later replies are
ignored; the deadline is always calculated from the oldest
correspondence from the outside actor.


=item Using both Resolve and Response in the same level

Resolve and Response can be combined. In such case due date is set
according to the earliest of two deadlines and never is dropped to
'not set'.

If a ticket met its Resolve deadline then due date stops "flipping",
is freezed and the ticket becomes overdue. Before that moment when
an inside actor replies to a ticket, due date is changed to Resolve
deadline instead of 'Not Set', as well this happens when a ticket
is closed. So all the time due date is defined.

Example:

    'standard delivery' => {
        Response => { RealMinutes => 60*1  }, # one hour
        Resolve  => { RealMinutes => 60*24 }, # 24 real hours
    },

A client orders goods and due date of the order is set to the next one
hour, you have this hour to process the order and write a reply.
As soon as goods are delivered you resolve tickets and usually meet
Resolve deadline, but if you don't resolve or user replies then most
probably there are problems with delivery of the goods. And if after
a week you keep replying to the client and always meeting one hour
response deadline that doesn't mean the ticket is not over due.
Due date was frozen 24 hours after creation of the order.

=item Using business and real time in one option

It's quite rare situation when people need it, but we've decided
that business is applied first and then real time when deadline
described using both types of time. For example:

    'delivery' => {
        Resolve => { BusinessMinutes => 0, RealMinutes => 60*8 },
    },
    'fast delivery' {
        StartImmediately => 1,
        Resolve => { RealMinutes => 60*8 },
    },

For delivery requests which come into the system during business
hours these levels define the same deadlines, otherwise the first
level set deadline to 8 real hours starting from the next business
day, when tickets with the second level should be resolved in the
next 8 hours after creation.

=back

=item Keep in loop (interval, no defaults)

If response deadline is used then Due date is changed to repsonse
deadline or to "Not Set" when staff replies to a ticket. In some
cases you want to keep requestors in loop and keed them up to date
every few hours. KeepInLoop option can be used to achieve this.

    'incident' => {
        Response   => { RealMinutes => 60*1  }, # one hour
        KeepInLoop => { RealMinutes => 60*2 }, # two hours
        Resolve    => { RealMinutes => 60*24 }, # 24 real hours
    },

In the above example Due is set to one hour after creation, reply
of a inside actor moves Due date two hours forward, outside actors'
replies move Due date to one hour and resolve deadine is 24 hours.

=item Modifying Agreements

=over 4

=item OutOfHours (struct, no default)

Out of hours modifier. Adds more real or business minutes to resolve
and/or reply options if event happens out of business hours, read also
</"Configuring business hours"> below.

Example:

    'level x' => {
        OutOfHours => { Resolve => { RealMinutes => +60*24 } },
        Resolve    => { RealMinutes => 60*24 },
    },

If a request comes into the system during night then supporters have two
hours, otherwise only one.

    'level x' => {
        OutOfHours => { Response => { BusinessMinutes => +60*2 } },
        Resolve    => { BusinessMinutes => 60 },
    },

Supporters have two additional hours in the morning to deal with bunch
of requests that came into the system during the last night.

=item IgnoreOnStatuses (array, no default)

Allows you to ignore a deadline when ticket has certain status. Example:

    'level x' => {
        KeepInLoop => { BusinessMinutes => 60, IgnoreOnStatuses => ['stalled'] },
    },

In above example KeepInLoop deadline is ignored if ticket is stalled.

B<NOTE>: When a ticket goes from an ignored status to a normal status, the new
Due date is calculated from the last action (reply, SLA change, etc) which fits
the SLA type (Response, Starts, KeepInLoop, etc).  This means if a ticket in
the above example flips from stalled to open without a reply, the ticket will
probably be overdue.  In most cases this shouldn't be a problem since moving
out of stalled-like statuses is often the result of RT's auto-open on reply
scrip, therefore ensuring there's a new reply to calculate Due from.  The
overall effect is that ignored statuses don't let the Due date drift
arbitrarily, which could wreak havoc on your SLA performance.
C<ExcludeTimeOnIgnoredStatuses> option could get around the "probably be
overdue" issue by excluding the time spent on ignored statuses, e.g.

    'level x' => {
        KeepInLoop => {
            BusinessMinutes => 60,
            ExcludeTimeOnIgnoredStatuses => 1,
            IgnoreOnStatuses => ['stalled'],
        },
    },

=back

=item Defining service levels per queue

In the config you can set per queue defaults, using:

    Set( %ServiceAgreements, (
        Default => 'global default level of service',
        QueueDefault => {
            'queue name' => 'default value for this queue',
            ...
        },
        ...
    ));

=item AssumeOutsideActor

When using a L<Response|/"Resolve and Response (interval, no defaults)">
configuration, the due date is unset when anyone who is not a requestor
replies.  If it is common for non-requestors to reply to tickets, and
this should I<not> satisfy the SLA, you may wish to set
C<AssumeOutsideActor>.  This causes the extension to assume that the
Response SLA has only been met when the owner or AdminCc reply.

    Set ( %ServiceAgreements = (
        AssumeOutsideActor => 1,
        ...
    ));

=back

=cut

Set( %ServiceAgreements, );

=item C<%ServiceBusinessHours>

In the config you can set one or more work schedules, e.g.

    Set( %ServiceBusinessHours, (
        'Default' => {
            ... description ...
        },
        'Support' => {
            ... description ...
        },
        'Sales' => {
            ... description ...
        },
    ));

Read more about how to describe a schedule in L<Business::Hours>.

=over 4

=item Defining different business hours for service levels

Each level supports BusinessHours option to specify your own business
hours.

    'level x' => {
        BusinessHours => 'work just in Monday',
        Resolve    => { BusinessMinutes => 60 },
    },

then L<%ServiceBusinessHours> should have the corresponding definition:

    Set( %ServiceBusinessHours, (
        'work just in Monday' => {
            1 => { Name => 'Monday', Start => '9:00', End => '18:00' },
        },
    ));

Default Business Hours setting is in $ServiceBusinessHours{'Default'}.

=back

=cut

Set( %ServiceBusinessHours, );

=back

=head1 Administrative interface

=over 4

=item C<$ShowRTPortal>

RT can show administrators a feed of recent RT releases and other
related announcements and information from Best Practical on the top
level Admin page.  This feature helps you stay up to date on
RT security announcements and version updates.

RT provides this feature using an "iframe" on C</Admin/index.html>
which asks the administrator's browser to show an inline page from
Best Practical's website.

If you'd rather not make this feature available to your
administrators, set C<$ShowRTPortal> to 0.

=cut

Set($ShowRTPortal, 1);

=item C<%AdminSearchResultFormat>

In the admin interface, format strings similar to tickets result
formats are used. Use C<%AdminSearchResultFormat> to define the format
strings used in the admin interface on a per-RT-class basis.

=cut

Set(%AdminSearchResultFormat,
    Queues =>
        q{'<a href="__WebPath__/Admin/Queues/Modify.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/Queues/Modify.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,__Description__,__Address__,__Priority__,__DefaultDueIn__,__Lifecycle__,__SubjectTag__,__Disabled__,__SortOrder__},

    Groups =>
        q{'<a href="__WebPath__/Admin/Groups/Modify.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/Groups/Modify.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,'__Description__',__Disabled__},

    Users =>
        q{'<a href="__WebPath__/Admin/Users/Modify.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/Users/Modify.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,__RealName__, __EmailAddress__,__Disabled__},

    CustomFields =>
        q{'<a href="__WebPath__/Admin/CustomFields/Modify.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/CustomFields/Modify.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,__AddedTo__, __EntryHint__, __FriendlyPattern__,__Disabled__},

    CustomRoles =>
        q{'<a href="__WebPath__/Admin/CustomRoles/Modify.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/CustomRoles/Modify.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,__Description__,__MaxValues__,__Disabled__},

    Scrips =>
        q{'<a href="__WebPath__/Admin/Scrips/Modify.html?id=__id____From__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/Scrips/Modify.html?id=__id____From__">__Description__</a>/TITLE:Description'}
        .q{,__Condition__, __Action__, __Template__, __Disabled__},

    Templates =>
        q{'<a href="__WebPath__/__WebRequestPathDir__/Template.html?Queue=__QueueId__&Template=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/__WebRequestPathDir__/Template.html?Queue=__QueueId__&Template=__id__">__Name__</a>/TITLE:Name'}
        .q{,'__Description__','__UsedBy__','__IsEmpty__'},
    Classes =>
        q{ '<a href="__WebPath__/Admin/Articles/Classes/Modify.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/Articles/Classes/Modify.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,__Description__,__Disabled__},

    Catalogs =>
        q{'<a href="__WebPath__/Admin/Assets/Catalogs/Modify.html?id=__id__">__id__</a>/TITLE:#'}
        .q{,'<a href="__WebPath__/Admin/Assets/Catalogs/Modify.html?id=__id__">__Name__</a>/TITLE:Name'}
        .q{,__Description__,__Lifecycle__,__Disabled__},
);

=item C<%AdminSearchResultRows>

Use C<%AdminSearchResultRows> to define the search result rows in the admin
interface on a per-RT-class basis.

=cut

Set(%AdminSearchResultRows,
    Queues       => 50,
    Groups       => 50,
    Users        => 50,
    CustomFields => 50,
    CustomRoles  => 50,
    Scrips       => 50,
    Templates    => 50,
    Classes      => 50,
    Catalogs     => 50,
    Assets       => 50,
);

=back




=head1 Development options

=over 4

=item C<$DevelMode>

RT comes with a "Development mode" setting.  This setting, as a
convenience for developers, turns on several of development options
that you most likely don't want in production:

=over 4

=item *

Disables CSS and JS minification and concatenation.  Both CSS and JS
will be instead be served as a number of individual smaller files,
unchanged from how they are stored on disk.

=item *

Uses L<Module::Refresh> to reload changed Perl modules on each
request.

=item *

Turns off Mason's C<static_source> directive; this causes Mason to
reload template files which have been modified on disk.

=item *

Turns on Mason's HTML C<error_format>; this renders compilation errors
to the browser, along with a full stack trace.  It is possible for
stack traces to reveal sensitive information such as passwords or
ticket content.

=item *

Turns off caching of callbacks; this enables additional callbacks to
be added while the server is running.

=back

=cut

Set($DevelMode, 0);


=item C<$RecordBaseClass>

What abstract base class should RT use for its records. You should
probably never change this.

Valid values are C<DBIx::SearchBuilder::Record> or
C<DBIx::SearchBuilder::Record::Cachable>

=cut

Set($RecordBaseClass, "DBIx::SearchBuilder::Record::Cachable");


=item C<@MasonParameters>

C<@MasonParameters> is the list of parameters for the constructor of
HTML::Mason's Apache or CGI Handler.  This is normally only useful for
debugging, e.g. profiling individual components with:

    use MasonX::Profiler; # available on CPAN
    Set(@MasonParameters, (preamble => 'my $p = MasonX::Profiler->new($m, $r);'));

=cut

Set(@MasonParameters, ());

=item C<$StatementLog>

RT has rudimentary SQL statement logging support; simply set
C<$StatementLog> to be the level that you wish SQL statements to be
logged at.

Enabling this option will also expose the SQL Queries page in the
Admin -> Tools menu for SuperUsers.

=cut

Set($StatementLog, undef);

=back

=cut

1;
