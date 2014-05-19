# Copyright (C) 2014 by Swiss Library for the Blind, Visually Impaired and Print Disabled

# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.

SRCDIR := Daisy-Export
ANNOSOFT_INPUT_DIR := to-annosoft
ANNOSOFT_OUTPUT_DIR := from-annosoft
BUILDDIR := build
TMPDIR := tmp

INPUT := $(SRCDIR)/Daisy-Export.htm
INPUT_NOTDIR := $(notdir $(INPUT))
SMILS := $(wildcard $(SRCDIR)/*.smil)
ANNOSOFT_INPUT := $(patsubst %.wav,$(ANNOSOFT_INPUT_DIR)/%.txt,$(notdir $(wildcard $(SRCDIR)/*.wav)))
ANNOSOFT_WITHBOM := $(patsubst %.txt,%.bom.txt,$(ANNOSOFT_INPUT))
ANNOSOFT_ZIP := Daisy-Export.zip

WAVS := $(wildcard $(SRCDIR)/*.wav)
OUTPUT_WAVS := $(patsubst %,$(BUILDDIR)/%,$(notdir $(WAVS)))
OUTPUT_HTML := $(BUILDDIR)/Daisy-Export.htm
OUTPUT_NCC := $(BUILDDIR)/ncc.html
OUTPUT_SMILS := $(patsubst %,$(BUILDDIR)/%,$(notdir $(SMILS)))

ANNOSOFT_OUTPUT := $(wildcard $(ANNOSOFT_OUTPUT_DIR)/*.xml)
TIMECODES := $(patsubst %.xml,%.time,$(ANNOSOFT_OUTPUT))

XSLTPROC := xsltproc
SAXON := java -jar /usr/share/java/Saxon-HE-9.4.0.7.jar

all: annosoft-input daisy-book

annosoft-input: $(TMPDIR) $(ANNOSOFT_INPUT_DIR) $(ANNOSOFT_ZIP)

# add span tags to all words
$(TMPDIR)/input_with_spans.xml: $(INPUT)
	$(SAXON) -xsl:xsl/add_word_spans.xsl -s:$< -o:$@

# merge all smils into one for easier processing
$(TMPDIR)/merged_smils.xml: $(SMILS)
	echo "<markers>" > $@
	$(XSLTPROC) --novalid xsl/mergesmils.xsl $^ >> $@
	echo "</markers>" >> $@

# inline audio data
$(TMPDIR)/input_with_audio_data.xml: $(TMPDIR)/input_with_spans.xml $(TMPDIR)/merged_smils.xml
	$(XSLTPROC) --novalid --stringparam tmp-dir $(abspath $(TMPDIR)) xsl/inline_audio_data.xsl $< > $@

# partition the input by wav
$(TMPDIR)/partitioned.xml: $(TMPDIR)/input_with_audio_data.xml
	$(XSLTPROC) --novalid xsl/partition_html.xsl $< > $@

# create input files for annosoft
$(ANNOSOFT_INPUT): $(TMPDIR)/partitioned.xml
	$(XSLTPROC) --novalid --stringparam annosoft-dir $(ANNOSOFT_INPUT_DIR) xsl/split_files.xsl $< > /dev/null

# bomify for winblows
%.bom.txt: %.txt
	uconv -f utf-8 -t utf-8 --add-signature $< > $@

$(ANNOSOFT_WITHBOM): $(ANNOSOFT_INPUT)

# pack it all up
$(ANNOSOFT_ZIP): $(ANNOSOFT_WITHBOM)
	zip --quiet $@ $^

daisy-book: $(BUILDDIR) $(OUTPUT_HTML) $(OUTPUT_WAVS) $(OUTPUT_SMILS) $(OUTPUT_NCC)

# extract and calculate time codes
%.time: %.xml
	$(XSLTPROC) --novalid --stringparam src-file $(INPUT_NOTDIR) --stringparam wav-file $(addsuffix .wav, $(basename $(notdir $@))) xsl/extract_timecodes.xsl $< > $@

$(TIMECODES): $(ANNOSOFT_OUTPUT)

# put all the artifacts into the build dir
$(BUILDDIR)/%.wav: $(SRCDIR)/%.wav
	cp $< $@

$(OUTPUT_WAVS): $(WAVS)

# copy the original html and inline the spans
$(OUTPUT_HTML): $(INPUT)
	$(SAXON) -s:$< -xsl:xsl/add_word_spans.xsl | $(XSLTPROC) --novalid xsl/word_id2word.xsl - > $@

# copy and enrich the smils
$(BUILDDIR)/master.smil: $(SRCDIR)/master.smil
	cp $< $@

$(BUILDDIR)/s%.smil: $(SRCDIR)/s%.smil $(TIMECODES)
	$(XSLTPROC) --novalid --stringparam path $(abspath $(ANNOSOFT_OUTPUT_DIR)) xsl/inline_timecodes.xsl $< > $@

# copy and fix the ncc
$(BUILDDIR)/ncc.html: $(SRCDIR)/ncc.html
	$(XSLTPROC) --novalid xsl/fix_ncc.xsl $< > $@

# create all build dirs
$(ANNOSOFT_INPUT_DIR) $(BUILDDIR) $(TMPDIR):
	mkdir $@

.PHONY : clean all annosoft-input daisy-book

clean:
	rm -rf $(TMPDIR) $(ANNOSOFT_ZIP) $(TIMECODES) $(BUILDDIR) $(ANNOSOFT_INPUT_DIR)

