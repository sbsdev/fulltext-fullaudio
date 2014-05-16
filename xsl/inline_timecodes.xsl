<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:param name="path"/>
  <xsl:variable name="filename"	select="concat($path,'/',substring-before(//audio[1]/@src,'.'),'.time')"/>

  <xsl:template match="seq">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:copy-of select="document($filename)/timecodes/par"/>
    </xsl:copy>
 </xsl:template>

  <!-- Copy all other elements and attributes -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
