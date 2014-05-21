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

<xsl:stylesheet version="1.0"
		xmlns:xhtml="http://www.w3.org/1999/xhtml"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dtb="http://www.daisy.org/z3986/2005/dtbook/"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str"
		exclude-result-prefixes="xhtml dtb">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <!-- The idea behind this code is from XSLT Cookbook, 2nd Edition,
       Chapter 6.8 "Deepening an XML Hierarchy" -->

  <xsl:template match="/">
    <xsl:element name="html">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@wav]" priority="10">
    <!-- All nodes following this element -->
    <xsl:variable name="nodes1" select="following::*[@id][not(@wav)]"/>
    <!-- All nodes following the next element that contains a @wav attribute -->
    <xsl:variable name="nodes2" select="following::*[@wav]/following::*[@id]"/>
    <xsl:element name="wav">
      <xsl:attribute name="wav">
	<xsl:value-of select="@wav"/>
      </xsl:attribute>
      <xsl:copy-of select="."/>
      <xsl:copy-of select="$nodes1[count(. | $nodes2) != count($nodes2)]"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*[@id]"/>

</xsl:stylesheet>
