<?xml version="1.0"?> 

<!--
 - Customize the generation of FO from the DocBook sources for the YAML spec.
-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="1.0"> 

  <!-- Invoke the DocBook -> FO conversion stylesheet -->
  <xsl:import href="docbook_xslt/fo/docbook.xsl" />

  <!-- Override the EBNF formatting -->
  <xsl:import href="ebnf_fo.xsl" />

  <!-- Using XEP extensions, lucky us! -->
  <xsl:param name="xep.extensions" select="1" />

  <!-- Force index to be in two columns -->
  <xsl:param name="column.count.index" select="2" />

  <!-- Output control. No need to worry about document type. -->
  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes" />

  <!-- Pass fo only -->
  <xsl:template match="fo"
    ><xsl:apply-templates select='*|text()'
  /></xsl:template>

  <!-- Border for examples -->
  <xsl:template match="database"
    ><fo:block
        border-style="solid" border-color="black" border-width="thin"
        ><xsl:apply-templates mode="highlight" select='*|text()'
    /></fo:block
  ></xsl:template>

  <!-- Convert HL -->
  <xsl:template match="HL"
    ><xsl:apply-templates mode="highlight" select='*|text()'
  /></xsl:template>

  <!-- Convert normal hl1 -->
  <xsl:template match="hl1"
    ><fo:inline
      border-style="solid" border-color="black" border-width="thin"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Convert HL/hl1 -->
  <xsl:template mode="highlight" match="hl1"
    ><fo:inline
      line-height="150%" padding="4px"
      border-style="solid" border-color="black" border-width="thin"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Convert normal hl2 -->
  <xsl:template match="hl2"
    ><fo:inline
      border-style="dotted" border-color="black" border-width="thin"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Convert HL/hl2 -->
  <xsl:template mode="highlight" match="hl2"
    ><fo:inline
      line-height="150%" padding="4px"
      border-style="dotted" border-color="black" border-width="thin"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Convert normal hl3 -->
  <xsl:template match="hl3"
    ><fo:inline
      border-style="dashed" border-color="black" border-width="thin"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Convert HL/hl3 -->
  <xsl:template mode="highlight" match="hl3"
    ><fo:inline
      line-height="150%" padding="4px"
      border-style="dashed" border-color="black" border-width="thin"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Convert normal hl4 -->
  <xsl:template match="hl4"
    ><fo:inline
      border-style="dotted" border-color="black" border-width="0.499pt"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Convert HL/hl4 -->
  <xsl:template mode="highlight" match="hl4"
    ><fo:inline
      line-height="150%" padding="4px"
      border-style="dotted" border-color="black" border-width="0.499pt"
      ><xsl:apply-templates select='*|text()'
    /></fo:inline
  ></xsl:template>

  <!-- Add a <pagebreak/> command -->
  <xsl:template match="pagebreak"
    ><fo:block break-before="page"
  /></xsl:template>

  <!-- Steal the margins for some pesky productions -->
  <xsl:param name="page.margin.inner">0.4in</xsl:param>
  <xsl:param name="page.margin.outer">0.4in</xsl:param>
  <xsl:param name="page.margin.top">0.4in</xsl:param>
  <xsl:param name="page.margin.bottom">0.4in</xsl:param>

  <!-- The common page area for US Letter and A4 -->
  <xsl:param name="page.width">8.3in</xsl:param>
  <xsl:param name="page.height">11in</xsl:param>

  <!-- Reduce the width of terms in definition lists (to half). -->
  <xsl:param name="variablelist.max.termlength">12</xsl:param>

  <!-- Auto-number sections. The default doesn't. -->
  <xsl:param name="section.autolabel" select="1" />

  <!-- Include chapter number in section number (1.2 instead of 2). -->
  <xsl:param name="section.label.includes.component.label" select="1" />

  <!-- Include sect4 elements in TOC (the default is just sect2). -->
  <xsl:param name="toc.section.depth">4</xsl:param>

  <!-- Use less indentation in TOC (since we nest deep). -->
  <xsl:param name="toc.indent.width">12</xsl:param>

  <!-- Supress everything except a single top-level table of contents. -->
  <xsl:param name="generate.toc">
    set       toc,title
    book      toc,title,index
    article   title
    part      nop
    chapter   nop
    preface   nop
    qandadiv  nop
    qandaset  nop
    reference nop
    sect1     nop
    sect2     nop
    sect3     nop
    sect4     nop
    sect5     nop
    section   nop
    appendix  nop
  </xsl:param>
</xsl:stylesheet>  
