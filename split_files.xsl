<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"  
		xmlns:exsl="http://exslt.org/common"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str exsl"
		exclude-result-prefixes="xhtml dtb">

  <xsl:output method="text" encoding="utf-8" omit-xml-declaration="yes" indent="no" />

  <xsl:template match="wav">
    <xsl:variable name="filename" select="substring-before(@wav,'.wav')"/>
    <exsl:document href="{$filename}.txt" 
		   omit-xml-declaration="yes" method="text" encoding="utf-8" indent="no">    
      <xsl:apply-templates/>
    </exsl:document>
  </xsl:template>

  <xsl:template match="*[@ms]">
    <xsl:value-of select="concat('&lt;cut ms=&quot;', @ms, '&quot;&gt; ')"/>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
 </xsl:template>

  <xsl:template match="xhtml:span[@word_id]">
    <xsl:value-of select="concat('{', @word_id,'}', string())"/>
 </xsl:template>

</xsl:stylesheet>
