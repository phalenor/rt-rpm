#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use Convert::Color::CMYK;

my $red = Convert::Color::CMYK->new( 0, 1, 1, 0 );

my $red_rgb = $red->convert_to("rgb");
is( $red_rgb->red,   1, 'red red' );
is( $red_rgb->green, 0, 'red green' );
is( $red_rgb->blue,  0, 'red blue' );

my $red_cmy = $red->convert_to("cmy");
is( $red_cmy->cyan,    0, 'red cyan' );
is( $red_cmy->magenta, 1, 'red magenta' );
is( $red_cmy->yellow,  1, 'red yellow' );

my $green = Convert::Color::CMYK->new( 1, 0, 1, 0 );

my $green_rgb = $green->convert_to("rgb");
is( $green_rgb->red,   0, 'green red' );
is( $green_rgb->green, 1, 'green green' );
is( $green_rgb->blue,  0, 'green blue' );

my $blue = Convert::Color::CMYK->new( 1, 1, 0, 0 );

my $blue_rgb = $blue->convert_to("rgb");
is( $blue_rgb->red,   0, 'blue red' );
is( $blue_rgb->green, 0, 'blue green' );
is( $blue_rgb->blue,  1, 'blue blue' );

my $white = Convert::Color::CMYK->new( 0, 0, 0, 0 );

my $white_rgb = $white->as_rgb;
is( $white_rgb->red,   1, 'white red' );
is( $white_rgb->green, 1, 'white green' );
is( $white_rgb->blue,  1, 'white blue' );

my $black = Convert::Color::CMYK->new( 0, 0, 0, 1 );

my $black_rgb = $black->as_rgb;
is( $black_rgb->red,   0, 'black red' );
is( $black_rgb->green, 0, 'black green' );
is( $black_rgb->blue,  0, 'black blue' );

my $black_cmy = $black->as_cmy;
is( $black_cmy->cyan,    1, 'black cyan' );
is( $black_cmy->magenta, 1, 'black magenta' );
is( $black_cmy->yellow,  1, 'black yellow' );

done_testing;
