<?xml version="1.0" encoding="utf-8"?>

<!-- Copyright (C) 2014 Swiss Library for the Blind, Visually Impaired and Print Disabled -->

<!-- This file is part of fulltext-fullaudio. -->

<!-- fulltext-fullaudio is free software: you can redistribute it -->
<!-- and/or modify it under the terms of the GNU General Public -->
<!-- License as published by the Free Software Foundation, either -->
<!-- version 3 of the License, or (at your option) any later version. -->

<!-- This program is distributed in the hope that it will be useful, -->
<!-- but WITHOUT ANY WARRANTY; without even the implied warranty of -->
<!-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU -->
<!-- General Public License for more details. -->

<!-- You should have received a copy of the GNU General Public -->
<!-- License along with this program. If not, see -->
<!-- <http://www.gnu.org/licenses/>. -->

<xsl:stylesheet version="2.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  		exclude-result-prefixes="xhtml">

  <xsl:output method="xml" encoding="utf-8" indent="no" 
	      doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
              doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

  <xsl:template match="xhtml:a/@href">
    <!-- Fix the smil refs to the new ids -->
    <xsl:attribute name="href">
      <xsl:value-of select="if (matches(., '\.smil#')) then concat(.,'_1_1') else ."/>
    </xsl:attribute>
  </xsl:template>

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
