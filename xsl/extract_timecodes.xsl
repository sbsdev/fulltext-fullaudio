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
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:param name="src-file" select="'dtbook.xml'"/>
  <xsl:param name="wav-file" select="'dtbook.wav'"/>

  <xsl:template match="/">
    <timecodes>
      <xsl:apply-templates select="//word"/>
    </timecodes>
  </xsl:template>

  <xsl:template match="word">
    <xsl:variable name="par">
      <xsl:number count="word" from="lipsync" level="any"/>
    </xsl:variable>
    <xsl:variable name="clip-begin" select="concat('npt=',
					    substring(@msStart,1,string-length(@msStart)-3),
					    '.',
					    substring(@msStart,string-length(@msStart)-2),
					    's')"/>
    <xsl:variable name="next-word" select="following-sibling::word[1]"/>
    <!-- Use the start of the next word an the end (if there is a next -->
    <!-- word). Otherwise the pauses will be dropped -->
    <xsl:variable name="end">
      <xsl:choose>
	<xsl:when test="$next-word"><xsl:value-of select="$next-word/@msStart"/></xsl:when>
	<xsl:otherwise><xsl:value-of select="@msEnd"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="clip-end" select="concat('npt=',
					  substring($end,1,string-length($end)-3),
					  '.',
					  substring($end,string-length($end)-2),
					  's')"/>
    <xsl:variable name="id" select="substring-before(substring-after(preceding-sibling::xmlmark[1],'{'),'}')"/>
    <par id="par{$par}" endsync="last">
      <text id="{$id}" src="{$src-file}#{$id}"/>
      <xsl:comment><xsl:value-of select="."/></xsl:comment>
      <audio src="{$wav-file}" clip-begin="{$clip-begin}" clip-end="{$clip-end}"/>
    </par>
  </xsl:template>

  <!-- Ignore the rest -->
  <xsl:template match="node()|@*"/>

</xsl:stylesheet>
