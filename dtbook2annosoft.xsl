<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str">
  
  <xsl:output method="text" encoding="utf-8" indent="no" />

  <xsl:template match="*[@id]">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="begin" select="document('audio.xml')/markers/audio[@id=$id]/@clip-begin"/>
    <xsl:variable name="wav" select="document('audio.xml')/markers/audio[@id=$id]/@src"/>
    <xsl:variable name="ms" select="translate(str:tokenize($begin,'=')[2],'.s','')"/>
    <xsl:if test="$ms=0000">
      <xsl:value-of select="concat('&lt;audio src=&quot;', $wav, '&quot;&gt; &#10;    ')"/>
    </xsl:if>
    <xsl:value-of select="concat('&lt;cut ms=&quot;', $ms, '&quot;&gt; ')"/>
    <xsl:for-each select="str:tokenize(string(), ' ')">
      <xsl:value-of select="concat('{', $id, '_', position(),'}', string(), ' ')"/>
    </xsl:for-each>
 </xsl:template>

</xsl:stylesheet>
