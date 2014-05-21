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
		xmlns:exsl="http://exslt.org/common"
		xmlns:str="http://exslt.org/strings"
		extension-element-prefixes="str exsl"
		exclude-result-prefixes="xhtml dtb">

  <xsl:output method="text" encoding="utf-8" omit-xml-declaration="yes" indent="no" />

  <xsl:param name="dir" select="'annosoft-out'"/>

  <xsl:template match="wav">
    <xsl:variable name="filename" select="substring-before(@wav,'.wav')"/>
    <exsl:document href="{$dir}/{$filename}.txt"
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
