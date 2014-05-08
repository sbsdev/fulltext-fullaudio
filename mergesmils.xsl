<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str xsl">
  
  <xsl:output method="xml" encoding="utf-8" indent="no" omit-xml-declaration="yes"/>

  <xsl:template match="par">
    <xsl:element name="audio">
      <xsl:attribute name="id">
	<xsl:value-of select="text/@id"/>
      </xsl:attribute>
      <xsl:attribute name="src">
	<xsl:value-of select="audio/@src"/>
      </xsl:attribute>
      <xsl:attribute name="clip-begin">
	<xsl:value-of select="audio/@clip-begin"/>
      </xsl:attribute>
      <xsl:attribute name="clip-end">
	<xsl:value-of select="audio/@clip-end"/>
      </xsl:attribute>
    </xsl:element>
 </xsl:template>

</xsl:stylesheet>
