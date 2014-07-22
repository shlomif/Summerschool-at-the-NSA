#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use JSON::MaybeXS qw(encode_json);

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
    io->file($target_dir . '/' . $obj->json_filename)->utf8->print(
        encode_json(
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
                rights => "Creative Commons Attribution ShareAlike Unported (CC-by-3.0)",
                publisher => 'http://www.shlomifish.org/',
                language => 'en-GB',
                subjects => [ 'FICTION/Humorous', 'FICTION/Mashups', 'Buffy', 'xkcd', ],
                identifier =>
                {
                    scheme => 'URL',
                    value => 'http://www.shlomifish.org/humour/Summerschool-at-the-NSA/',
                },
                contents =>
                [
                    {
                        "type" => "toc",
                        "source" => "toc.html"
                    },
                    {
                        type => 'text',
                        source => "scene-*.xhtml",
                    },
                ],
                toc  => {
                    "depth" => 2,
                    "parse" => [ "text", ],
                    "generate" => {
                        "title" => "Index"
                    },
                },
                guide => [
                    {
                        type => "toc",
                        title => "Index",
                        href => "toc.html",
                    },
                ],
            },
        ),
    );

    $obj->output_json;
}
