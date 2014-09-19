SVG = summer-glau-schools-the-nsa.svg
PNG = $(SVG).png
JPEG = $(SVG).jpg

# WIDTH = 400
DPI = 300

all: $(PNG) $(JPEG)

$(PNG): $(SVG)
	# inkscape --export-png=$@ --export-width=400 $<
	inkscape --export-png=$@ --export-dpi=$(DPI) $<

$(JPEG): $(PNG)
	convert $(PNG) $(JPEG)

upload: all
	rsync --progress -v -a --inplace *.png $(SVG) *.jpg $(__HOMEPAGE_REMOTE_PATH)/summer-glau-schools-the-nsa/
