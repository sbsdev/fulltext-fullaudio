<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str"
		exclude-result-prefixes="xhtml dtb">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:variable name="num-nodes" select="count(//*[@id])"/>
  
  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@wav]" priority="10">
    <xsl:variable name="pos" select="$num-nodes -
				     count(following::*[@wav]/following::*[@id])"/>
    <xsl:element name="wav">
      <xsl:attribute name="wav">
	<xsl:value-of select="@wav"/>
      </xsl:attribute> 
      <xsl:copy-of select="."/>
      <xsl:copy-of select="following::*[@id and position() &lt;= $pos]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@id]"/>

</xsl:stylesheet>
