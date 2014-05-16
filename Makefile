# Copyright (C) 2014 by Swiss Library for the Blind, Visually Impaired and Print Disabled

# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.

SRCDIR := Daisy-Export
ANNOSOFTOUTDIR := annosoft-out
ANNOSOFTINDIR := annosoft-in
BUILDDIR := build
TMPDIR := tmp

INPUT := $(SRCDIR)/Daisy-Export.htm
INPUT_NOTDIR := $(notdir $(INPUT))
SMILS := $(wildcard $(SRCDIR)/*.smil)
ANNOSOFT_OUTPUT := $(patsubst %.wav,$(ANNOSOFTOUTDIR)/%.txt,$(notdir $(wildcard $(SRCDIR)/*.wav)))
ANNOSOFT_WITHBOM := $(patsubst %.txt,%.bom.txt,$(ANNOSOFT_OUTPUT))
ANNOSOFT_ZIP := Daisy-Export.zip

WAVS := $(wildcard $(SRCDIR)/*.wav)
BUILD_WAVS := $(patsubst %,$(BUILDDIR)/%,$(notdir $(WAVS)))

ANNOSOFT_INPUT := $(wildcard $(ANNOSOFTINDIR)/*.xml)
TIMECODES := $(patsubst %.xml,%.time,$(ANNOSOFT_INPUT))

XSLTPROC := xsltproc

all: annosoft-input daisy-book

annosoft-input: $(TMPDIR) $(ANNOSOFTOUTDIR) $(ANNOSOFT_ZIP)
daisy-book: $(BUILDDIR) $(BUILD_WAVS)

# add span tags to all words
$(TMPDIR)/input_with_spans.xml: $(INPUT)
	$(XSLTPROC) --novalid add_word_spans.xsl $< > $@

# merge all smils into one for easier processing
$(TMPDIR)/merged_smils.xml: $(SMILS)
	echo "<markers>" > $@
	$(XSLTPROC) --novalid mergesmils.xsl $^ >> $@
	echo "</markers>" >> $@

# inline audio data
$(TMPDIR)/input_with_audio_data.xml: $(TMPDIR)/input_with_spans.xml $(TMPDIR)/merged_smils.xml
	$(XSLTPROC) --novalid --stringparam tmp-dir $(TMPDIR) inline_audio_data.xsl $< > $@

# partition the input by wav
$(TMPDIR)/partitioned.xml: $(TMPDIR)/input_with_audio_data.xml
	$(XSLTPROC) --novalid partition_html.xsl $< > $@

# create input files for annosoft
$(ANNOSOFT_OUTPUT): $(TMPDIR)/partitioned.xml
	$(XSLTPROC) --novalid --stringparam annosoft-dir $(ANNOSOFTOUTDIR) split_files.xsl $< > /dev/null

# bomify for winblows
%.bom.txt: %.txt
	uconv -f utf-8 -t utf-8 --add-signature $< > $@

$(ANNOSOFT_WITHBOM): $(ANNOSOFT_OUTPUT)

# pack it all up
$(ANNOSOFT_ZIP): $(ANNOSOFT_WITHBOM)
	zip --quiet $@ $^

# extract and calculate time codes
%.time: %.xml
	$(XSLTPROC) --novalid --stringparam src-file $(INPUT_NOTDIR) --stringparam wav-file $(addsuffix .wav, $(basename $(notdir $@))) extract_timecodes.xsl $< > $@

$(TIMECODES): $(ANNOSOFT_INPUT)

# put all the artifacts into the build dir
$(BUILDDIR)/%.wav: $(SRCDIR)/%.wav
	cp $< $@

$(BUILD_WAVS): $(WAVS)

# create all build dirs
$(ANNOSOFTOUTDIR) $(BUILDDIR) $(TMPDIR):
	mkdir $@

.PHONY : clean all annosoft-input daisy-book

clean:
	rm -rf $(TMPDIR) $(ANNOSOFT_ZIP) $(TIMECODES) $(BUILDDIR) $(ANNOSOFTOUTDIR)

