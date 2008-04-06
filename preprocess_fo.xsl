<?xml version="1.0"?> 

<!--
 - Pre-process the spec before handing it over to standard DocBook. This allows
 - using convenient shorthands that DocBook does not provide. Currently these
 - shorthands are:
 -
 - <defterm>term</defterm> is converted to an <indexterm>, using "term" as
 - the primary, with "preferred" significance. This is used to create a short
 - index of "important terms" as an - appendix.
 -
 - <refterm>term</refterm> is converted to an <indexterm>, using "term" as
 - the primary, with "normal" significance. This is used to add list of
 - usage points to each "important terms" in the appendix.
-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"> 

  <!-- Generate the DOCBOOk DTD decleration. Can't copy it! -->
  <xsl:output
    method="xml" doctype-public="-//OASIS//DTD DocBook V4.2//EN"
    doctype-system="http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" />

  <!-- Convert uquote to userinput quote. -->
  <xsl:template match="uquote"
    ><quote
      ><userinput
        ><xsl:apply-templates select='*|text()'
      /></userinput
    ></quote
  ></xsl:template>

  <!-- Convert defterm to index entry definition. -->
  <xsl:template match="defterm"
    ><indexterm significance="preferred"
      ><primary><xsl:value-of select='@primary'/></primary
      ><xsl:if test="@secondary"
        ><secondary><xsl:value-of select='@secondary'/></secondary
      ></xsl:if
      ><xsl:if test="@tertiary"
        ><tertiary><xsl:value-of select='@tertiary'/></tertiary
      ></xsl:if
    ></indexterm
    ><firstterm
      ><xsl:apply-templates select='*|text()'
    /></firstterm
  ></xsl:template>

  <!-- Convert refterm to index entry definition. -->
  <xsl:template match="refterm"
    ><indexterm significance="normal"
      ><primary><xsl:value-of select='@primary'/></primary
      ><xsl:if test="@secondary"
        ><secondary><xsl:value-of select='@secondary'/></secondary
      ></xsl:if
      ><xsl:if test="@tertiary"
        ><tertiary><xsl:value-of select='@tertiary'/></tertiary
      ></xsl:if
    ></indexterm
    ><xsl:apply-templates select='*|text()'
  /></xsl:template>

  <!-- Convert seeterm to index entry definition. -->
  <xsl:template match="seeterm"
    ><indexterm
      ><primary><xsl:value-of select='@primary'/></primary
      ><secondary><xsl:value-of select='@secondary'/></secondary
      ><tertiary><xsl:value-of select='@tertiary'/></tertiary
      ><see><xsl:value-of select='@see' /></see
    ></indexterm
  ></xsl:template>

  <!-- Convert seealso to index entry definition. -->
  <xsl:template match="seealso"
    ><indexterm
      ><primary><xsl:value-of select='@primary'/></primary
      ><secondary><xsl:value-of select='@secondary'/></secondary
      ><tertiary><xsl:value-of select='@tertiary'/></tertiary
      ><seealso><xsl:value-of select='@see' /></seealso
    ></indexterm
  ></xsl:template>

  <!-- Convert screen -->
  <xsl:template match="screen"
    ><screen
      ><database
        ><xsl:apply-templates select='*|text()'
      /></database
    ></screen
  ></xsl:template>

  <!-- Convert programlisting -->
  <xsl:template match="programlisting"
    ><programlisting
      ><database
        ><xsl:apply-templates select='*|text()'
      /></database
    ></programlisting
  ></xsl:template>

  <!-- Ignore html only -->
  <xsl:template match="html"
  ></xsl:template>

  <!-- Enforce keep-together -->
  <xsl:template match="keep-together"
    ><informaltable frame="none"
      ><tgroup cols="1"
        ><colspec
        /><tbody
          ><row
            ><entry
              ><xsl:apply-templates select='*|text()'
            /></entry
          ></row
        ></tbody
      ></tgroup
    ></informaltable
  ></xsl:template>

  <!-- Handle line break in productions -->
  <xsl:template match="sbr"
    ><xsl:if test="not(ancestor-or-self::hl1)
               and not(ancestor-or-self::hl2)
               and not(ancestor-or-self::hl3)
               and not(ancestor-or-self::hl4)"
      ><sbr
      /><xsl:if test="ancestor-or-self::rhs"
        ><xsl:call-template name="nbsps"
          ><xsl:with-param name="number" select="string-length(../../lhs) + 4"
        /></xsl:call-template
      ></xsl:if
    ></xsl:if
  ></xsl:template>

  <!-- Emit a number of non-breaking spaces. -->
  <xsl:template name="nbsps"
    ><xsl:param name="number"
    /><xsl:if test="$number &gt; 0"
      ><xsl:text>&#160;</xsl:text
      ><xsl:call-template name="nbsps"
        ><xsl:with-param name="number" select="$number - 1"
      /></xsl:call-template
    ></xsl:if
  ></xsl:template>

  <!-- Slanted single quotes -->
  <xsl:template match="q">&#8217;</xsl:template>

  <!-- Copy everything else unchanged. -->
  <xsl:template match='*|@*'
    ><xsl:copy
      ><xsl:apply-templates select='node()|@*'
    /></xsl:copy
  ></xsl:template>

</xsl:stylesheet>  
