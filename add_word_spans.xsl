<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str"
  		exclude-result-prefixes="xhtml">

  <xsl:output method="xml" encoding="utf-8" indent="yes" 
	      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

  <xsl:template match="*[@id]">
    <xsl:copy>
      <xsl:apply-templates select="@*|*[not(text())]"/>
      <xsl:apply-templates select="text()" mode="tokenize"/>
    </xsl:copy>
 </xsl:template>

  <xsl:template match="text()" mode="tokenize">
    <xsl:variable name="parent" select="ancestor::*[@id]"/>
    <xsl:variable name="id" select="$parent/@id"/>
    <xsl:variable name="pos">
      <xsl:number count="text()" from="*[@id]" level="any"/>
    </xsl:variable>
    <xsl:for-each select="str:tokenize(string(), ' ')">
      <xsl:element name="span" namespace="http://www.w3.org/1999/xhtml">
	<xsl:attribute name="id">
	  <xsl:value-of select="concat($id, '_', $pos, '_', position())"/>
	</xsl:attribute> 
	<xsl:value-of select="string()"/>
      </xsl:element>
    </xsl:for-each>
  </xsl:template>

  <!-- Copy all other elements and attributes -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
