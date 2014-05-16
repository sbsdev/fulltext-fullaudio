<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str"
		exclude-result-prefixes="xhtml dtb">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <!-- The idea behind this code is from XSLT Cookbook, 2nd Edition,
       Chapter 6.8 "Deepening an XML Hierarchy" -->

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@wav]" priority="10">
    <!-- All nodes following this element -->
    <xsl:variable name="nodes1" select="following::*[@id][not(@wav)]"/>
    <!-- All nodes following the next element that contains a @wav attribute -->
    <xsl:variable name="nodes2" select="following::*[@wav]/following::*[@id]"/>
    <xsl:element name="wav">
      <xsl:attribute name="wav">
	<xsl:value-of select="@wav"/>
      </xsl:attribute> 
      <xsl:copy-of select="."/>
      <xsl:copy-of select="$nodes1[count(. | $nodes2) != count($nodes2)]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@id]"/>

</xsl:stylesheet>
