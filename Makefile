# Copyright (C) 2014 by Swiss Library for the Blind, Visually Impaired and Print Disabled

# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.

INPUT := Daisy-Export/Daisy-Export.htm
SMILS := $(wildcard Daisy-Export/*.smil)
OUTPUT := $(patsubst %.wav,%.txt,$(notdir $(wildcard Daisy-Export/*.wav)))
WITHBOM := $(patsubst %.txt,%.bom.txt,$(OUTPUT))
ZIP := Daisy-Export.zip

XSLTPROC := xsltproc

all: $(ZIP)

# add span tags to all words
input_with_spans.xml: $(INPUT)
	$(XSLTPROC) --novalid add_word_spans.xsl $< > $@

# merge all smils into one for easier processing
merged_smils.xml: $(SMILS)
	echo "<markers>" > $@
	$(XSLTPROC) --novalid mergesmils.xsl $^ >> $@
	echo "</markers>" >> $@

# inline audio data
input_with_audio_data.xml: input_with_spans.xml merged_smils.xml
	$(XSLTPROC) --novalid inline_audio_data.xsl $< > $@

# partition the input by wav
partitioned.xml: input_with_audio_data.xml
	$(XSLTPROC) --novalid partition_html.xsl $< > $@

# create input files for annosoft
$(OUTPUT): partitioned.xml
	$(XSLTPROC) --novalid split_files.xsl $< > /dev/null

# bomify for winblows
%.bom.txt: %.txt
	uconv -f utf-8 -t utf-8 --add-signature $< > $@

$(WITHBOM): $(OUTPUT)

# pack it all up
$(ZIP): $(WITHBOM)
	zip --quiet $@ $^

.PHONY : clean all

clean:
	rm -rf input_with_spans.xml merged_smils.xml input_with_audio_data.xml partitioned.xml $(OUTPUT) $(WITHBOM) $(ZIP)

