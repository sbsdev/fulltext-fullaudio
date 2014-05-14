# Copyright (C) 2014 by Swiss Library for the Blind, Visually Impaired and Print Disabled

# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.

INPUT := Daisy-Export/Daisy-Export.htm
SMILS := $(wildcard Daisy-Export/*.smil)
OUTPUT := $(patsubst %.wav,%.txt,$(notdir $(wildcard Daisy-Export/*.wav)))
ZIP := Daisy-Export.zip

XSLTPROC = xsltproc

all: $(ZIP)

# add span tags to all words
input_with_spans.xml: $(INPUT)
	$(XSLTPROC) --novalid add_word_spans.xsl $< > $@

# merge all smils into one for easier processing
audio.xml: $(SMILS)
	echo "<markers>" > $@
	$(XSLTPROC) --novalid mergesmils.xsl $^ >> $@
	echo "</markers>" >> $@

# inline audio data
input_with_audio_data.xml: input_with_spans.xml audio.xml
	$(XSLTPROC) --novalid inline_audio_data.xsl $< > $@

# partition the input by wav
partitioned.xml: input_with_audio_data.xml
	$(XSLTPROC) --novalid partition_html.xsl $< > $@

# create input files for annosoft
$(OUTPUT): partitioned.xml
	$(XSLTPROC) --novalid split_files.xsl $< > /dev/null

$(ZIP): $(OUTPUT)
	zip --quiet $(ZIP) $(OUTPUT)

.PHONY : clean all

clean:
	rm -rf input_with_spans.xml audio.xml input_with_audio_data.xml partitioned.xml $(OUTPUT) $(ZIP)

