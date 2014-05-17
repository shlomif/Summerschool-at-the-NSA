#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

use XML::LibXML;
use XML::LibXML::XPathContext;

use CGI qw(escapeHTML);
use JSON::MaybeXS qw(encode_json);

use Getopt::Long qw(GetOptions);

my $xhtml_ns = "http://www.w3.org/1999/xhtml";

sub _get_xpc
{
    my ($node) = @_;
    my $xpc = XML::LibXML::XPathContext->new($node);
    $xpc->registerNs("xhtml", $xhtml_ns);

    return $xpc;
}

my $out_fn;

GetOptions(
    "output|o=s" => \$out_fn,
);

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

my $target_dir = './for-epub-xhtmls/';

# Prepare the objects.
my $xml = XML::LibXML->new;
my $root_node = $xml->parse_file($filename);
{
    my $scenes_list = _get_xpc($root_node)->findnodes(
        q{//xhtml:div[@class='screenplay']/xhtml:div[@class='scene']/xhtml:div[@class='scene' and xhtml:h2]}
    )
        or die "Cannot find top-level scenes list.";

    my $idx = 0;
    $scenes_list->foreach(sub
    {
        my ($orig_scene) = @_;

        # Commented out traces. No longer needed.
        # print "\n\n[$idx]<<<<< " . $orig_scene->toString() . ">>>>\n\n";
        # print "Foo ==" , (scalar($orig_scene->toString()) =~ /h3/g), "\n";

        my $scene = $orig_scene->cloneNode(1);

        {
            my $scene_xpc = _get_xpc($scene);
            foreach my $h_idx (2 .. 6)
            {
                foreach my $h_tag ($scene_xpc->findnodes(qq{descendant::xhtml:h$h_idx}))
                {
                    my $copy = $h_tag->cloneNode(1);
                    $copy->setNodeName('h' . ($h_idx-1));

                    my $parent = $h_tag->parentNode;
                    $parent->replaceChild($copy, $h_tag);
                }
            }
        }

        {
            my $scene_xpc = _get_xpc($scene);

            my $title = $scene_xpc->findnodes('descendant::xhtml:h1')->[0]->textContent();
            my $esc_title = escapeHTML($title);

            my $scene_string = $scene->toString();
            my $xmlns = q# xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"#;
            $scene_string =~ s{(<\w+)\Q$xmlns\E( )}{$1$2}g;

            io->file($target_dir . "/scene-" . sprintf("%.4d", ($idx+1)) . ".xhtml")->utf8->print(<<"EOF");
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>$esc_title</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="style.css" />
</head>
<body>
$scene_string
</body>
</html>
EOF
        }
        $idx++;
    });
}

my $gfx = 'Green-d10-dice.png';
io->file('../graphics/' . $gfx) > io->file($target_dir . "/images/$gfx");

foreach my $basename ('style.css')
{
    io->file( "$target_dir/$basename" )->utf8->print(<<'EOF');
body
{
    direction: ltr;
    text-align: left;
    font-family: sans-serif;
    background-color: white;
    color: black;
}
EOF
}

my $epub_basename = 'Summerschool-at-the-NSA';
my $json_filename = "$epub_basename.json";
io->file($target_dir . '/' . $json_filename)->utf8->print(
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

my $orig_dir = io->curdir->absolute . '';

my $epub_fn = $epub_basename . ".epub";

{
    chdir ($target_dir);

    my @cmd = ("ebookmaker", "-f", "epub", "-o", $epub_fn, $json_filename);
    print join(' ', @cmd), "\n";
    system (@cmd)
        and die "cannot run ebookmaker - $!";

    chdir ($orig_dir);
}

io->file("$target_dir/$epub_fn") > io->file($out_fn);
