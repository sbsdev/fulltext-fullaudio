<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" encoding="utf-8" indent="yes" />

  <xsl:param name="src-file" select="'dtbook.xml'"/>

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
    <xsl:variable name="clip-end" select="concat('npt=',
					  substring(@msEnd,1,string-length(@msEnd)-3),
					  '.',
					  substring(@msEnd,string-length(@msEnd)-2),
					  's')"/>
    <xsl:variable name="id" select="substring-before(substring-after(preceding-sibling::xmlmark[1],'{'),'}')"/>
    <par id="par{$par}" endsync="last">
      <text id="{$id}" src="{$src-file}#{$id}"/>
      <xsl:comment><xsl:value-of select="."/></xsl:comment>
      <audio src="" clip-begin="{$clip-begin}" clip-end="{$clip-end}"/>
    </par>
  </xsl:template>

  <!-- Ignore the rest -->
  <xsl:template match="node()|@*"/>

</xsl:stylesheet>
