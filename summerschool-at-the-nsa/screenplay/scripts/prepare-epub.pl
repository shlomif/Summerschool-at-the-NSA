#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Shlomif::Screenplays::EPUB;

my $obj = Shlomif::Screenplays::EPUB->new;
$obj->run;

my $gfx = $obj->gfx;
my $out_fn = $obj->out_fn;
my $target_dir = $obj->target_dir;

{
    my $epub_basename = 'Summerschool-at-the-NSA';
    $obj->epub_basename($epub_basename);

    $obj->output_json(
        {
            data =>
            {
                filename => $epub_basename,
                title => q/Summerschool at the NSA/,
                authors =>
                [
                    {
                        name => "Shlomi Fish",
                        sort => "Fish, Shlomi",
                    },
                ],
                contributors =>
                [
                    {
                        name => "Shlomi Fish",
                        role => "oth",
                    },
                ],
                cover => "images/$gfx",
                rights => "Creative Commons Attribution Unported (CC-by-3.0)",
                publisher => 'http://www.shlomifish.org/',
                language => 'en-GB',
                subjects => [ 'FICTION/Humorous', 'FICTION/Mashups', 'Buffy', 'xkcd', ],
                identifier =>
                {
                    scheme => 'URL',
                    value => 'http://www.shlomifish.org/humour/Summerschool-at-the-NSA/',
                },
            },
        },
    );
}
