FILES = Makefile $(DOCS_SCREENPLAY_XHTML) \
		$(DOCS_SCREENPLAY_TEXT) \
		style.css style-heb.css \
		README.html

# The-Enemy-English.xhtml \

DOCS_BASE = Humanity-Movie Humanity-Movie-hebrew

DOCS_SCREENPLAY_TEXT = $(patsubst %,%.screenplay-text.txt,$(DOCS_BASE))
DOCS_SCREENPLAY_XML = $(patsubst %,%.screenplay-xml.xml,$(DOCS_BASE))
DOCS_SCREENPLAY_XHTML = $(patsubst %,%.screenplay-text.xhtml,$(DOCS_BASE))
DOCS_SCREENPLAY_XHTML_AS_HTML = $(patsubst %,%.final.html,$(DOCS_BASE))
DOCS_SCREENPLAY_FO = $(patsubst %,%.screenplay-text.fo,$(DOCS_BASE))
DOCS_SCREENPLAY_RTF = $(patsubst %,%.screenplay-text.rtf,$(DOCS_BASE))

DOCBOOK5_XSL_STYLESHEETS_PATH := $(HOME)/Download/unpack/file/docbook/docbook-xsl-ns-snapshot

HOMEPAGE := $(HOME)/Docs/homepage/homepage/trunk
DOCBOOK5_XSL_STYLESHEETS_XHTML_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/xhtml
DOCBOOK5_XSL_STYLESHEETS_FO_PATH := $(DOCBOOK5_XSL_STYLESHEETS_PATH)/fo
DOCBOOK5_XSL_CUSTOM_XSLT_STYLESHEET := $(HOMEPAGE)/lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-xhtml-onechunk.xsl
DOCBOOK5_XSL_CUSTOM_FO_XSLT_STYLESHEET := $(HOMEPAGE)/lib/sgml/shlomif-docbook/xsl-5-stylesheets/shlomif-essays-5-fo.xsl

SELINA_UPLOAD_TEMP_DEST = temp-selina-mandrake-P9n7ybv3wq2t

all: $(DOCS_SCREENPLAY_XHTML) $(ENG_EPUB) $(ENG_XHTML) $(ENG_HTML_FOR_OOO)

upload:
	rsync -v --progress -a $(FILES) $${HOMEPAGE_SSH_PATH}/$(SELINA_UPLOAD_TEMP_DEST)/

$(DOCS_SCREENPLAY_XML): %.screenplay-xml.xml: %.screenplay-text.txt
	perl -MXML::Grammar::Screenplay::App::FromProto -e 'run()' -- \
	-o $@ $<

$(DOCS_SCREENPLAY_XHTML): %.screenplay-text.xhtml: %.screenplay-xml.xml
	perl -MXML::Grammar::Screenplay::App::ToHTML -e 'run()' -- \
		-o $@ $<

$(DOCS_SCREENPLAY_XHTML_AS_HTML): $(DOCS_SCREENPLAY_XHTML)
	cp -f $< $@

$(DOCS_SCREENPLAY_FO): %.screenplay-text.fo : %.db5.xml
	xsltproc --stringparam root.filename $@ \
		--stringparam html.stylesheet "style.css" \
		--path $(DOCBOOK5_XSL_STYLESHEETS_FO_PATH) \
		-o $@ \
		$(DOCBOOK5_XSL_CUSTOM_FO_XSLT_STYLESHEET) $<

$(DOCS_SCREENPLAY_RTF): %.rtf: %.fo
	fop -fo $< -rtf $@

rtf: $(DOCS_SCREENPLAY_RTF)

# DOCBOOK_RNG = http://www.docbook.org/xml/5.0/rng/docbook.rng

DOCBOOK_RNG = ./rng/docbook.rng

# XSL_SNAPSHOT_HOME = $(HOME)/Download/unpack/file/docbook/docbook-xsl-ns-snapshot
XSL_SNAPSHOT_HOME = $(HOME)/Download/unpack/file/docbook/docbook-xsl-snapshot/

EPUB_SCRIPT = $(XSL_SNAPSHOT_HOME)/epub/bin/dbtoepub

$(ENG_HTML_FOR_OOO): $(ENG_XHTML)
	cat $< | perl -lne 'print unless m{\A<\?xml}' > $@

$(HEB_HTML_FOR_OOO): $(DOCS_SCREENPLAY_XHTML)
	cat $< | perl -lne 's{(</title>)}{$${1}<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />}; print unless m{\A<\?xml}' > $@

oohtml: $(ENG_HTML_FOR_OOO) $(HEB_HTML_FOR_OOO)

openoffice: oohtml
	ooffice3.2 $(ENG_HTML_FOR_OOO)

.PHONY: epub_ff

epub: $(ENG_EPUB)

epub_ff: epub
	firefox $(ENG_EPUB)

clean:
	rm -f $(DOCS_SCREENPLAY_XHTML) $(DOCS_SCREENPLAY_XML)

%.show:
	@echo "$* = $($*)"

linview: $(DOCS_SCREENPLAY_XHTML_AS_HTML)
	xdg-open $<
