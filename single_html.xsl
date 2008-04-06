<?xml version="1.0"?> 

<!--
 - Customize the generation of HTML from the DocBook sources for the YAML spec.
-->

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"> 

  <!-- Invoke the DocBook -> HTML conversion stylesheet -->
  <xsl:import href="docbook_xslt/xhtml/docbook.xsl" /> 

  <xsl:output method="xml" encoding="ISO-8859-1" indent="yes"
    doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
    doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />

  <!--
   - Tweak the generation of a table of contents:
  -->

  <!-- Use a CSS stylesheet to customize the HTML file. -->
  <xsl:param name="html.stylesheet" select="'single_html.css'"></xsl:param>

  <!-- Supress including all abstracts in the META tag. -->
  <xsl:param name="generate.meta.abstract" select="0"></xsl:param>

  <!-- Generate "more valid" HTML. -->
  <xsl:param name="make.valid.html" select="0"></xsl:param>

  <!-- Disable EBNF table border (leave it to the CSS). -->
  <xsl:param name="ebnf.table.border" select="0"></xsl:param>

  <!-- Disable EBNF table color (leave it to the CSS). -->
  <xsl:param name="ebnf.table.bgcolor" select="''"></xsl:param>

  <!-- Auto-number sections. The default doesn't. -->
  <xsl:param name="section.autolabel" select="1" />

  <!-- Include chapter number in section number (1.2 instead of 2). -->
  <xsl:param name="section.label.includes.component.label" select="1" />

  <!-- Include sect4 elements in TOC (the default is just sect2) -->
  <xsl:param name="toc.section.depth">4</xsl:param>

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

  <!-- Ignore fo only -->
  <xsl:template match="fo"
  ></xsl:template>

  <!-- Ignore a <pagebreak/> command -->
  <xsl:template match="pagebreak"/>

  <!-- Horrible hack for making preferred index entries a different class. -->
  <xsl:template match="indexterm" mode="reference">
    <xsl:param name="scope" select="."/>
    <xsl:param name="separator" select="', '"/>

    <xsl:value-of select="$separator"/>
    <xsl:choose>
      <xsl:when test="@zone and string(@zone)">
        <xsl:call-template name="reference">
          <xsl:with-param name="zones" select="normalize-space(@zone)"/>
            <xsl:with-param name="scope" select="$scope"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:variable name="title">
            <xsl:apply-templates select="(ancestor-or-self::set
                                         |ancestor-or-self::book
                                         |ancestor-or-self::part
                                         |ancestor-or-self::reference
                                         |ancestor-or-self::partintro
                                         |ancestor-or-self::chapter
                                         |ancestor-or-self::appendix
                                         |ancestor-or-self::preface
                                         |ancestor-or-self::article
                                         |ancestor-or-self::section
                                         |ancestor-or-self::sect1
                                         |ancestor-or-self::sect2
                                         |ancestor-or-self::sect3
                                         |ancestor-or-self::sect4
                                         |ancestor-or-self::sect5
                                         |ancestor-or-self::refentry
                                         |ancestor-or-self::refsect1
                                         |ancestor-or-self::refsect2
                                         |ancestor-or-self::refsect3
                                         |ancestor-or-self::simplesect
                                         |ancestor-or-self::bibliography
                                         |ancestor-or-self::glossary
                                         |ancestor-or-self::index
                                         |ancestor-or-self::webpage)[last()]"
                                  mode="title.markup"/>
          </xsl:variable>

          <!-- Added from here -->
          <xsl:if test="@significance='preferred'">
            <xsl:attribute name="class">preferred</xsl:attribute>
          </xsl:if>
          <!-- Added to here -->

          <xsl:attribute name="href">
            <xsl:call-template name="href.target">
              <xsl:with-param name="object"
                              select="(ancestor-or-self::set
                                      |ancestor-or-self::book
                                      |ancestor-or-self::part
                                      |ancestor-or-self::reference
                                      |ancestor-or-self::partintro
                                      |ancestor-or-self::chapter
                                      |ancestor-or-self::appendix
                                      |ancestor-or-self::preface
                                      |ancestor-or-self::article
                                      |ancestor-or-self::section
                                      |ancestor-or-self::sect1
                                      |ancestor-or-self::sect2
                                      |ancestor-or-self::sect3
                                      |ancestor-or-self::sect4
                                      |ancestor-or-self::sect5
                                      |ancestor-or-self::refentry
                                      |ancestor-or-self::refsect1
                                      |ancestor-or-self::refsect2
                                      |ancestor-or-self::refsect3
                                      |ancestor-or-self::simplesect
                                      |ancestor-or-self::bibliography
                                      |ancestor-or-self::glossary
                                      |ancestor-or-self::index
                                      |ancestor-or-self::webpage)[last()]"/>
            </xsl:call-template>
          </xsl:attribute>

          <xsl:value-of select="$title"/> <!-- text only -->
        </a>

        <xsl:if test="key('endofrange', @id)
                [count(ancestor::node()|$scope) = count(ancestor::node())]">
          <xsl:apply-templates select="key('endofrange', @id)
            [count(ancestor::node()|$scope) = count(ancestor::node())][last()]"
                               mode="reference">
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="separator" select="'-'"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Horrid hack for making primary index entries anchored. -->
  <xsl:template match="indexterm" mode="index-primary">
    <xsl:param name="scope" select="."/>
    <xsl:variable name="key"
      select="normalize-space(concat(primary/@sortas, primary[not(@sortas)]))"/>
    <xsl:variable name="refs"
                  select="key('primary', $key)[count(ancestor::node()|$scope)
                                             = count(ancestor::node())]"/>
    <dt>
      <!-- Added from here -->
      <a><xsl:attribute name="id"
        >index-entry-<xsl:value-of select="primary"
      /></xsl:attribute></a>
      <!-- Added to here -->
      <xsl:value-of select="primary"/>
      <xsl:for-each
        select="$refs[generate-id()
                    = generate-id(
                        key('primary-section',
                            concat($key, &#34; &#34;,
                                   generate-id((ancestor-or-self::set
                                               |ancestor-or-self::book
                                               |ancestor-or-self::part
                                               |ancestor-or-self::reference
                                               |ancestor-or-self::partintro
                                               |ancestor-or-self::chapter
                                               |ancestor-or-self::appendix
                                               |ancestor-or-self::preface
                                               |ancestor-or-self::article
                                               |ancestor-or-self::section
                                               |ancestor-or-self::sect1
                                               |ancestor-or-self::sect2
                                               |ancestor-or-self::sect3
                                               |ancestor-or-self::sect4
                                               |ancestor-or-self::sect5
                                               |ancestor-or-self::refentry
                                               |ancestor-or-self::refsect1
                                               |ancestor-or-self::refsect2
                                               |ancestor-or-self::refsect3
                                               |ancestor-or-self::simplesect
                                               |ancestor-or-self::bibliography
                                               |ancestor-or-self::glossary
                                               |ancestor-or-self::index
                                               |ancestor-or-self::webpage)
                                               [last()]
                                     )
                            )
                        )[count(ancestor::node()|$scope)
                        = count(ancestor::node())][1])]">
        <xsl:apply-templates select="." mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
        </xsl:apply-templates>
      </xsl:for-each>
      <xsl:if test="$refs[not(secondary)]/*[self::see]">
        <xsl:apply-templates
          select="$refs[generate-id()
                      = generate-id(
                          key('see',
                              concat(
                                normalize-space(
                                  concat(primary/@sortas,
                                         primary[not(@sortas)]
                                  )
                                ), &#34; &#34;, &#34; &#34;, &#34; &#34;, see
                              )
                          )[count(ancestor::node()|$scope)
                          = count(ancestor::node())][1])]"
          mode="index-see">
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:sort select="translate(see, 'abcdefghijklmnopqrstuvwxyz',
                                             'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:apply-templates>
      </xsl:if>
    </dt>
    <xsl:if test="$refs/secondary or $refs[not(secondary)]/*[self::seealso]">
      <dd>
        <dl>
          <xsl:apply-templates
            select="$refs[generate-id()
                        = generate-id(
                            key('see-also',
                                concat(
                                  normalize-space(
                                    concat(primary/@sortas,
                                           primary[not(@sortas)]
                                    )
                                  ), &#34; &#34;, &#34; &#34;, &#34; &#34;,
                                  seealso
                                )
                            )[count(ancestor::node()|$scope)
                            = count(ancestor::node())][1])]"
            mode="index-seealso">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:sort select="translate(seealso,
                                          'abcdefghijklmnopqrstuvwxyz',
                                          'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
          </xsl:apply-templates>
          <xsl:apply-templates
            select="$refs[secondary
                      and count(
                            .|key('secondary',
                                  concat($key, &#34; &#34;,
                                         normalize-space(
                                           concat(secondary/@sortas,
                                                  secondary[not(@sortas)])
                                         )
                                   )
                            )[count(ancestor::node()|$scope)
                            = count(ancestor::node())][1]) = 1]"
            mode="index-secondary">
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:sort
              select="translate(
                        normalize-space(
                          concat(secondary/@sortas,
                                 secondary[not(@sortas)])
                        ),
                        'abcdefghijklmnopqrstuvwxyz',
                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
          </xsl:apply-templates>
        </dl>
      </dd>
    </xsl:if>
  </xsl:template>

  <!-- Disgusting hack for making secondary index entries anchored. -->
  <xsl:template match="QQQindexterm" mode="index-secondary">
    <xsl:param name="scope" select="."/>
    <xsl:variable name="key"
      select="concat(
        normalize-space(
          concat(primary/@sortas, primary[not(@sortas)])),
        &#34; &#34;,
        normalize-space(
          concat(secondary/@sortas, secondary[not(@sortas)])))"/>
      <xsl:variable name="refs"
        select="key('secondary', $key)[count(ancestor::node()|$scope)
                                     = count(ancestor::node())]"/>
      <dt>
        <!-- Added from here -->
        <a><xsl:attribute name="id"
          >index-entry-<xsl:value-of select="primary"
          />/<xsl:value-of select="secondary"
        /></xsl:attribute></a>
        <!-- Added to here -->
        <xsl:value-of select="secondary"/>
        <xsl:for-each
          select="$refs[generate-id()
                      = generate-id(
                          key('secondary-section',
                              concat($key, &#34; &#34;,
                                     generate-id((ancestor-or-self::set
                                                 |ancestor-or-self::book
                                                 |ancestor-or-self::part
                                                 |ancestor-or-self::reference
                                                 |ancestor-or-self::partintro
                                                 |ancestor-or-self::chapter
                                                 |ancestor-or-self::appendix
                                                 |ancestor-or-self::preface
                                                 |ancestor-or-self::article
                                                 |ancestor-or-self::section
                                                 |ancestor-or-self::sect1
                                                 |ancestor-or-self::sect2
                                                 |ancestor-or-self::sect3
                                                 |ancestor-or-self::sect4
                                                 |ancestor-or-self::sect5
                                                 |ancestor-or-self::refentry
                                                 |ancestor-or-self::refsect1
                                                 |ancestor-or-self::refsect2
                                                 |ancestor-or-self::refsect3
                                                 |ancestor-or-self::simplesect
                                                 |ancestor-or-self::bibliography
                                                 |ancestor-or-self::glossary
                                                 |ancestor-or-self::index
                                                 |ancestor-or-self::webpage)
                                                 [last()]
                                     )
                              )
                          )[count(ancestor::node()|$scope)
                          = count(ancestor::node())][1])]">
          <xsl:apply-templates select="." mode="reference">
            <xsl:with-param name="scope" select="$scope"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:if test="$refs[not(tertiary)]/*[self::see]">
        <xsl:apply-templates
          select="$refs[generate-id()
                      = generate-id(
                          key('see',
                              concat(
                                normalize-space(
                                  concat(primary/@sortas,
                                         primary[not(@sortas)])
                                ), &#34; &#34;,
                                normalize-space(
                                  concat(secondary/@sortas,
                                         secondary[not(@sortas)])
                                ), &#34; &#34;, &#34; &#34;, see
                              )
                          )[count(ancestor::node()|$scope)
                          = count(ancestor::node())][1])]" mode="index-see">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:sort select="translate(see, 'abcdefghijklmnopqrstuvwxyz',
                                           'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
        </xsl:apply-templates>
      </xsl:if>
    </dt>
    <xsl:if test="$refs/tertiary or $refs[not(tertiary)]/*[self::seealso]">
      <dd>
        <dl>
          <xsl:apply-templates
            select="$refs[generate-id()
                        = generate-id(
                            key('see-also',
                                concat(
                                  normalize-space(
                                    concat(primary/@sortas,
                                           primary[not(@sortas)])
                                  ), &#34; &#34;,
                                  normalize-space(
                                    concat(secondary/@sortas,
                                           secondary[not(@sortas)])
                                  ), &#34; &#34;, &#34; &#34;, seealso)
                            )[count(ancestor::node()|$scope)
                            = count(ancestor::node())][1])]"
            mode="index-seealso">
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:sort
              select="translate(seealso, 'abcdefghijklmnopqrstuvwxyz',
                                         'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
          </xsl:apply-templates>
          <xsl:apply-templates
            select="$refs[tertiary
                      and count(
                            .|key('tertiary',
                                  concat($key, &#34; &#34;,
                                         normalize-space(
                                           concat(tertiary/@sortas,
                                                  tertiary[not(@sortas)])
                                         )
                                  )
                            )[count(ancestor::node()|$scope)
                            = count(ancestor::node())][1]) = 1]"
            mode="index-tertiary">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:sort
                select="translate(
                          normalize-space(
                            concat(tertiary/@sortas, tertiary[not(@sortas)])
                          ), 'abcdefghijklmnopqrstuvwxyz',
                             'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
          </xsl:apply-templates>
        </dl>
      </dd>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>  
