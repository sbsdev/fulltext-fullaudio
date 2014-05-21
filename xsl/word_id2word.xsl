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
		exclude-result-prefixes="xhtml">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:template match="@word_id">
    <xsl:attribute name="id">
      <xsl:value-of select="."/>
    </xsl:attribute>
 </xsl:template>

  <!-- Copy all other elements and attributes -->
  <xsl:template match="node()|@*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
