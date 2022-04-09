SVG = summer-glau-schools-the-nsa.svg
PNG = $(SVG).png
JPEG = $(SVG).jpg
WEBP = $(SVG).webp

# WIDTH = 400
DPI = 300

all: $(PNG) $(JPEG) $(WEBP)

$(PNG): $(SVG)
	# inkscape --export-png=$@ --export-width=400 $<
	inkscape --export-filename=$@ --export-dpi=$(DPI) $<

$(JPEG): $(PNG)
	gm convert $< $@

$(WEBP): $(PNG)
	gm convert $< $@

upload: all
	rsync --progress -v -a --inplace *.png $(SVG) *.jpg $(__HOMEPAGE_REMOTE_PATH)/summer-glau-schools-the-nsa/
