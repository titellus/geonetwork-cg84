<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl-multilingual.xsl"/>

  <xsl:template name="get-iso19139.fra-extents-as-json">[
    <xsl:for-each select="//gmd:geographicElement/gmd:EX_GeographicBoundingBox">
      <xsl:variable name="format" select="'##.0000'"></xsl:variable>

      <xsl:if test="number(gmd:westBoundLongitude/gco:Decimal)
            and number(gmd:southBoundLatitude/gco:Decimal)
            and number(gmd:eastBoundLongitude/gco:Decimal)
            and number(gmd:northBoundLatitude/gco:Decimal)
            ">
        [
          <xsl:value-of select="format-number(gmd:westBoundLongitude/gco:Decimal, $format)"/>,
          <xsl:value-of select="format-number(gmd:southBoundLatitude/gco:Decimal, $format)"/>,
          <xsl:value-of select="format-number(gmd:eastBoundLongitude/gco:Decimal, $format)"/>,
          <xsl:value-of select="format-number(gmd:northBoundLatitude/gco:Decimal, $format)"/>
        ]
        <xsl:if test="position() != last()">,</xsl:if>
      </xsl:if>
    </xsl:for-each>
    ]
  </xsl:template>

  <xsl:template name="get-iso19139.fra-online-source-config">
    <xsl:param name="pattern"/>
    <xsl:call-template name="get-iso19139-online-source-config">
        <xsl:with-param name="pattern" select="$pattern"/>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>

