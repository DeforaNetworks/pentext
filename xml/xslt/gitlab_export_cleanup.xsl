<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:output indent="yes" method="xml"/>

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- remove all spans; they are not used in pentext -->
    <xsl:template match="span">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- remove all divs; they are not used in findings -->
    <xsl:template match="div">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- convert <pre><code> to <pre> -->
    <xsl:template match="pre/code">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- remove @class from pre -->
    <xsl:template match="pre/@class"/>

    <!-- remove @class from a -->
    <xsl:template match="a/@class"/>

    <!-- remove h*, make bold paragraph -->
    <xsl:template match="h2 | h3 | h4 | h5">
        <p>
            <b>
                <xsl:apply-templates/>
            </b>
        </p>
    </xsl:template>

    <!-- add .. to <img src="/uploads/[long code]/file.png"/> -->
    <xsl:template match="img/@src">
        <xsl:if test="starts-with(., '/uploads/')">
            <xsl:attribute name="src" select="concat('..', .)"/>
        </xsl:if>
    </xsl:template>

    <!-- get rid of superfluous breaks before images or h3 tags -->
    <!-- (not perfect, ideally post-process result later to flatten img or h3 out of p -->
    <xsl:template
        match="br[following-sibling::img] | br[following-sibling::h3] | br[following-sibling::p]"> </xsl:template>

    <!-- insert default img width to nudge pentesters :) -->
    <xsl:template match="img[not(@height) and not(@width)]">
        <xsl:copy>
            <xsl:attribute name="width">17</xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!--if a description or an impact tag contains only a p, remove the p (unless it has element children).-->
    <xsl:template
        match="description/p[not(preceding-sibling::*)][not(following-sibling::*)][not(*)] | impact/p[not(preceding-sibling::*)][not(following-sibling::*)][not(*)]">
        <xsl:apply-templates/>
    </xsl:template>

<xsl:template match="p[child::img[not(preceding-sibling::*)][not(following-sibling::*)]]">
        <xsl:apply-templates select="@* | node()"/>
    </xsl:template>

</xsl:stylesheet>