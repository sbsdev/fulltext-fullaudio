<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" 
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		exclude-result-prefixes="xhtml">
  
  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:template match="xhtml:a">
    <xsl:copy>
      <xsl:attribute name="href">
	<xsl:value-of select="concat(@href,'_0_1')"/>
      </xsl:attribute>
      <xsl:copy-of select="*"/>
    </xsl:copy>
 </xsl:template>

  <!-- Copy all other elements and attributes -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
