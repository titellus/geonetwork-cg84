<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gml="http://www.opengis.net/gml" xmlns:gmi="http://www.isotc211.org/2005/gmi"
  xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="fra gmi" xmlns:srv="http://www.isotc211.org/2005/srv">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
  
  <xsl:param name="prefix" select="'http://catalogue5.cg84.fr/catalogue/srv/fre/resources.get'"/>
  
  <!-- root element  -->
  <xsl:template match="gmd:MD_Metadata">
    <gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"
      xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi"
      xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gts="http://www.isotc211.org/2005/gts"
      xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <xsl:apply-templates select="*"/>
    </gmd:MD_Metadata>
  </xsl:template>
  
  
  <xsl:template match="gmd:language[gco:CharacterString]" priority="10">
    <gmd:language>
      <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre" />
    </gmd:language>
  </xsl:template>
  
  
  <xsl:template match="gmd:CI_Citation[gmd:title/gco:CharacterString = 'external.theme.gemet']">
    <gmd:CI_Citation>
      <gmd:title>
        <gco:CharacterString>GEMET - Concepts, version 2.4</gco:CharacterString>
      </gmd:title>
      <gmd:date>
        <gmd:CI_Date>
          <gmd:date>
            <gco:Date>2010-01-13</gco:Date>
          </gmd:date>
          <gmd:dateType>
            <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
              codeListValue="publication"/>
          </gmd:dateType>
        </gmd:CI_Date>
      </gmd:date>
      <gmd:identifier>
        <gmd:MD_Identifier>
          <gmd:code>
            <gco:CharacterString>geonetwork.thesaurus.external.theme.gemet</gco:CharacterString>
          </gmd:code>
        </gmd:MD_Identifier>
      </gmd:identifier>
    </gmd:CI_Citation>
  </xsl:template>
  
  <xsl:template match="gmd:CI_Citation[gmd:title/gco:CharacterString = 'external.theme.inspire']">
    <gmd:CI_Citation>
      <gmd:title>
        <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
      </gmd:title>
      <gmd:date>
        <gmd:CI_Date>
          <gmd:date>
            <gco:Date>2008-06-01</gco:Date>
          </gmd:date>
          <gmd:dateType>
            <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
              codeListValue="publication"/>
          </gmd:dateType>
        </gmd:CI_Date>
      </gmd:date>
      <gmd:identifier>
        <gmd:MD_Identifier>
          <gmd:code>
            <gco:CharacterString>geonetwork.thesaurus.external.theme.inspire-theme</gco:CharacterString>
          </gmd:code>
        </gmd:MD_Identifier>
      </gmd:identifier>
    </gmd:CI_Citation>
  </xsl:template>
  
  <xsl:template match="gmd:CI_Citation[gmd:title/gco:CharacterString = 'external.place.DepartementFR']">
    <gmd:CI_Citation>
      <gmd:title>
        <gco:CharacterString>Départements de France</gco:CharacterString>
      </gmd:title>
      <gmd:date>
        <gmd:CI_Date>
          <gmd:date>
            <gco:Date>2006-09-22</gco:Date>
          </gmd:date>
          <gmd:dateType>
            <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/Codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
              codeListValue="publication"/>
          </gmd:dateType>
        </gmd:CI_Date>
      </gmd:date>
      <gmd:identifier>
        <gmd:MD_Identifier>
          <gmd:code>
            <gco:CharacterString>geonetwork.thesaurus.external.place.DepartementFR</gco:CharacterString>
          </gmd:code>
        </gmd:MD_Identifier>
      </gmd:identifier>
    </gmd:CI_Citation>
  </xsl:template>
  
  
  <!-- Copy all -->
  <xsl:template match="@*|node()" priority="-10">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  
  <!-- Remap schema element -->
  <xsl:template match="*[@gco:isoType]" priority="100">
    <xsl:element name="{@gco:isoType}">
      <xsl:apply-templates select="*"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="gmd:metadataStandardName">
    <gmd:metadataStandardName>
      <gco:CharacterString>ISO 19115:2003/19139</gco:CharacterString>
    </gmd:metadataStandardName>
  </xsl:template>
  
  <xsl:template match="gmd:metadataStandardVersion">
    <gmd:metadataStandardVersion>
      <gco:CharacterString>1.0</gco:CharacterString>
    </gmd:metadataStandardVersion>
  </xsl:template>
  
  <!-- handle FRA_DataIdentification-->
  <xsl:template match="fra:FRA_DataIdentification|gmd:MD_DataIdentification" priority="2000">
    <gmd:MD_DataIdentification>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="gmd:citation"/>
      <xsl:apply-templates select="gmd:abstract"/>
      <xsl:apply-templates select="gmd:purpose"/>
      <xsl:apply-templates select="gmd:credit"/>
      <xsl:apply-templates select="gmd:status"/>
      <xsl:apply-templates select="gmd:pointOfContact"/>
      <xsl:apply-templates select="gmd:resourceMaintenance"/>
      
      <xsl:for-each select="gmd:graphicOverview">
        <xsl:copy>
          <gmd:MD_BrowseGraphic>
            <xsl:variable name="fileName" select="gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString"/>
            <xsl:variable name="fileType" select="gmd:MD_BrowseGraphic/gmd:fileType/gco:CharacterString"/>
            <xsl:choose>
              <xsl:when test="not(starts-with($fileName, 'http://'))">
                <xsl:variable name="identifer" select="/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString"/>
                <xsl:message>#<xsl:value-of select="$identifer"/> </xsl:message>
                
                <gmd:fileName>
                  <gco:CharacterString>
                    <xsl:value-of
                      select="concat($prefix, '?uuid=',
                      $identifer, '&amp;fname=', $fileName)"/>
                  </gco:CharacterString>
                </gmd:fileName>
              </xsl:when>
              <xsl:otherwise>
                <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileName"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileDescription"/>
            <xsl:copy-of select="gmd:MD_BrowseGraphic/gmd:fileType"/>
          </gmd:MD_BrowseGraphic>
        </xsl:copy>
      </xsl:for-each>
      
      <xsl:apply-templates select="gmd:resourceFormat"/>
      <xsl:apply-templates select="gmd:descriptiveKeywords"/>
      <xsl:apply-templates select="gmd:resourceSpecificUsage"/>
      <xsl:apply-templates select="gmd:resourceConstraints"/>
      <xsl:apply-templates select="gmd:aggregationInfo"/>
      <xsl:apply-templates select="gmd:spatialRepresentationType"/>
      <xsl:apply-templates select="gmd:spatialResolution"/>
      <xsl:apply-templates select="gmd:language"/>
      <xsl:apply-templates select="gmd:characterSet"/>
      <xsl:apply-templates select="gmd:topicCategory"/>
      <xsl:apply-templates select="gmd:environmentDescription"/>
      <xsl:apply-templates select="gmd:extent"/>
      <xsl:apply-templates select="gmd:supplementalInformation"/>
      
    </gmd:MD_DataIdentification>
  </xsl:template>
  
  <!-- handle FRA_Constraints-->
  <xsl:template match="fra:FRA_Constraints">
    <gmd:MD_Constraints>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_Constraints>
  </xsl:template>
  
  <xsl:template match="fra:FRA_LegalConstraints">
    <gmd:MD_LegalConstraints>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_LegalConstraints>
  </xsl:template>
  
  <xsl:template match="fra:FRA_SecurityConstraints">
    <gmd:MD_SecurityConstraints>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_SecurityConstraints>
  </xsl:template>
  
  <!--handle CRS-->
  <xsl:template match="fra:FRA_IndirectReferenceSystem">
    <gmd:MD_ReferenceSystem>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_ReferenceSystem>
  </xsl:template>
  <xsl:template match="fra:FRA_DirectReferenceSystem">
    <gmd:MD_ReferenceSystem>
      <xsl:apply-templates select="@*|node()"/>
    </gmd:MD_ReferenceSystem>
  </xsl:template>
  
  <!--Removed Citation added for DataIdentification, Constraints -->
  <xsl:template match="fra:relatedCitation">
  </xsl:template>
  
  <xsl:template match="fra:FRA_Constraints/fra:citation">
  </xsl:template>
  
  <xsl:template match="fra:FRA_LegalConstraints/fra:citation">
  </xsl:template>
  
  <xsl:template match="fra:FRA_SecurityConstraints/fra:citation">
  </xsl:template>
  
  <!-- Removed Validity values and UseBy for dates-->
  <xsl:template match="gmd:date[CI_Date/dateType/CI_DateTypeCode/@codeListValue='validity']">
  </xsl:template>
  
  <xsl:template match="gmd:date[CI_Date/dateType/CI_DateTypeCode/@codeListValue='useBy']">
  </xsl:template>
  
  <!-- QEUsability element removed -->
  <xsl:template match="gmi:QE_Usability"/>
  
  <!-- Remove geonet:* elements. -->
  <xsl:template match="geonet:*|gmd:graphicOverview" priority="2"/>
  
</xsl:stylesheet>