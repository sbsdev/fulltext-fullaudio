# Copyright (C) 2014 by Swiss Library for the Blind, Visually Impaired and Print Disabled

# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.

INPUT := Daisy-Export/Daisy-Export.htm
SMILS := $(wildcard Daisy-Export/*.smil)

XSLTPROC = xsltproc

all: annosoft_input.txt partitioned.xml

# add span tags to all words
input_with_spans.xml: $(INPUT)
	$(XSLTPROC) --novalid add_word_spans.xsl $< > $@

# merge all smils into one for easier processing
audio.xml: $(SMILS)
	echo "<markers>" > $@
	$(XSLTPROC) --novalid mergesmils.xsl $^ >> $@
	echo "</markers>" >> $@

# inline audio data
input_with_audio_data.xml: input_with_spans.xml
	$(XSLTPROC) --novalid inline_audio_data.xsl $^ > $@


# create input file for annosoft
annosoft_input.txt: input_with_spans.xml audio.xml
	$(XSLTPROC) --novalid dtbook2annosoft.xsl $< > $@


.PHONY : clean all

clean:
	rm -rf input_with_spans.xml audio.xml annosoft_input.txt

