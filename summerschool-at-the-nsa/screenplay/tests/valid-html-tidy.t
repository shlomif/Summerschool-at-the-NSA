#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Test::HTML::Tidy::Recursive::Strict ();

Test::HTML::Tidy::Recursive::Strict->new(
    {
        targets => [ '.', ],
    }
)->run;
