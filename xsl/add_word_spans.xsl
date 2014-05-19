<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  		exclude-result-prefixes="xhtml">

  <xsl:output method="xml" encoding="utf-8" indent="no" 
	      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

  <xsl:template match="*[@id]//text()">
    <xsl:variable name="parent" select="ancestor::*[@id]"/>
    <xsl:variable name="id" select="$parent/@id"/>
    <xsl:variable name="pos">
      <xsl:number from="*[@id]" level="any"/>
    </xsl:variable>
    <xsl:for-each select="tokenize(string(), ' ')">
      <xsl:element name="span" namespace="http://www.w3.org/1999/xhtml">
	<xsl:attribute name="word_id">
	  <xsl:value-of select="concat($id, '_', $pos, '_', position())"/>
	</xsl:attribute> 
	<xsl:value-of select="string()"/>
      </xsl:element>
      <xsl:if test="position()!=last()">
	<xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- Copy all other elements and attributes -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
