<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:str="http://exslt.org/strings"
		xmlns:exsl="http://exslt.org/common"
		extension-element-prefixes="str exsl"
		exclude-result-prefixes="exsl xhtml dtb">
  
  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:template match="*[@id]">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="begin" select="document('merged_smils.xml')/markers/audio[@id=$id]/@clip-begin"/>
    <xsl:variable name="wav" select="document('merged_smils.xml')/markers/audio[@id=$id]/@src"/>
    <xsl:variable name="ms" select="translate(str:tokenize($begin,'=')[2],'.s','')"/>
    <xsl:copy>
      <xsl:attribute name="ms">
	<xsl:value-of select="$ms"/>
      </xsl:attribute>
      <xsl:if test="$ms=0000">
	<xsl:attribute name="wav">
	  <xsl:value-of select="$wav"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
 </xsl:template>

  <!-- Copy all other elements and attributes -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
