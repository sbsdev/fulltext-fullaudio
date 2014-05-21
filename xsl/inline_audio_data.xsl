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
		xmlns:exsl="http://exslt.org/common"
		extension-element-prefixes="str exsl"
		exclude-result-prefixes="exsl xhtml dtb">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:param name="tmp-dir" select="'tmp'"/>

  <xsl:template match="*[@id]">
    <xsl:variable name="id" select="@id"/>
    <xsl:variable name="filename" select="concat($tmp-dir, '/merged_smils.xml')"/>

    <xsl:variable name="begin" select="document($filename)/markers/audio[@id=$id]/@clip-begin"/>
    <xsl:variable name="wav" select="document($filename)/markers/audio[@id=$id]/@src"/>
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
