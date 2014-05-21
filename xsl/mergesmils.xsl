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
