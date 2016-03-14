# This file is auto-generated by the Perl DateTime Suite time zone
# code generator (0.07) This code generator comes with the
# DateTime::TimeZone module distribution in the tools/ directory

#
# Generated from /tmp/Q713JNUf8G/asia.  Olson data version 2016a
#
# Do not edit this file directly.
#
package DateTime::TimeZone::Asia::Pontianak;
$DateTime::TimeZone::Asia::Pontianak::VERSION = '1.95';
use strict;

use Class::Singleton 1.03;
use DateTime::TimeZone;
use DateTime::TimeZone::OlsonDB;

@DateTime::TimeZone::Asia::Pontianak::ISA = ( 'Class::Singleton', 'DateTime::TimeZone' );

my $spans =
[
    [
DateTime::TimeZone::NEG_INFINITY, #    utc_start
60189496960, #      utc_end 1908-04-30 16:42:40 (Thu)
DateTime::TimeZone::NEG_INFINITY, #  local_start
60189523200, #    local_end 1908-05-01 00:00:00 (Fri)
26240,
0,
'LMT',
    ],
    [
60189496960, #    utc_start 1908-04-30 16:42:40 (Thu)
60962776960, #      utc_end 1932-10-31 16:42:40 (Mon)
60189523200, #  local_start 1908-05-01 00:00:00 (Fri)
60962803200, #    local_end 1932-11-01 00:00:00 (Tue)
26240,
0,
'PMT',
    ],
    [
60962776960, #    utc_start 1932-10-31 16:42:40 (Mon)
61254462600, #      utc_end 1942-01-28 16:30:00 (Wed)
60962803960, #  local_start 1932-11-01 00:12:40 (Tue)
61254489600, #    local_end 1942-01-29 00:00:00 (Thu)
27000,
0,
'WIB',
    ],
    [
61254462600, #    utc_start 1942-01-28 16:30:00 (Wed)
61369628400, #      utc_end 1945-09-22 15:00:00 (Sat)
61254495000, #  local_start 1942-01-29 01:30:00 (Thu)
61369660800, #    local_end 1945-09-23 00:00:00 (Sun)
32400,
0,
'JST',
    ],
    [
61369628400, #    utc_start 1945-09-22 15:00:00 (Sat)
61451800200, #      utc_end 1948-04-30 16:30:00 (Fri)
61369655400, #  local_start 1945-09-22 22:30:00 (Sat)
61451827200, #    local_end 1948-05-01 00:00:00 (Sat)
27000,
0,
'WIB',
    ],
    [
61451800200, #    utc_start 1948-04-30 16:30:00 (Fri)
61514870400, #      utc_end 1950-04-30 16:00:00 (Sun)
61451829000, #  local_start 1948-05-01 00:30:00 (Sat)
61514899200, #    local_end 1950-05-01 00:00:00 (Mon)
28800,
0,
'WIB',
    ],
    [
61514870400, #    utc_start 1950-04-30 16:00:00 (Sun)
61946267400, #      utc_end 1963-12-31 16:30:00 (Tue)
61514897400, #  local_start 1950-04-30 23:30:00 (Sun)
61946294400, #    local_end 1964-01-01 00:00:00 (Wed)
27000,
0,
'WIB',
    ],
    [
61946267400, #    utc_start 1963-12-31 16:30:00 (Tue)
62703648000, #      utc_end 1987-12-31 16:00:00 (Thu)
61946296200, #  local_start 1964-01-01 00:30:00 (Wed)
62703676800, #    local_end 1988-01-01 00:00:00 (Fri)
28800,
0,
'WITA',
    ],
    [
62703648000, #    utc_start 1987-12-31 16:00:00 (Thu)
DateTime::TimeZone::INFINITY, #      utc_end
62703673200, #  local_start 1987-12-31 23:00:00 (Thu)
DateTime::TimeZone::INFINITY, #    local_end
25200,
0,
'WIB',
    ],
];

sub olson_version {'2016a'}

sub has_dst_changes {0}

sub _max_year {2026}

sub _new_instance {
    return shift->_init( @_, spans => $spans );
}



1;

