<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns="http://purl.oclc.org/dsdl/schematron"
                exclude-result-prefixes="svrl">

    <xsl:output omit-xml-declaration="yes" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="//xsl:stylesheet">
        <schema schemaVersion="iso" queryBinding="xslt2">
            <xsl:for-each select="//svrl:schematron-output">
                <title><xsl:value-of select="@title" /></title>
            </xsl:for-each>
            <xsl:for-each select="//svrl:ns-prefix-in-attribute-values">
                <ns uri="{@uri}" prefix="{@prefix}" />
            </xsl:for-each>
            <pattern>
                <xsl:for-each select="xsl:template">
                    <xsl:if test="starts-with(@priority, '1') and starts-with(@mode, 'M')">
                        <rule context="{@match}">
                            <xsl:for-each select="xsl:choose">
                                <xsl:variable name="assert" select="replace(replace(replace(replace(xsl:when/@test, '    ', ' '), '   ', ' '), '  ', ' '), '  ', ' ')" />
                                <xsl:variable name="identifier" select="substring-after(substring-before(xsl:otherwise/svrl:failed-assert/svrl:text,']-'),'[')" />
                                <xsl:variable name="message" select="substring-after(xsl:otherwise/svrl:failed-assert/svrl:text,']-')" />
                                <xsl:variable name="flag" select="xsl:otherwise/svrl:failed-assert/xsl:attribute[@name = 'flag']" />

                                <assert id="{$identifier}" test="{$assert}" flag="{$flag}"><xsl:value-of select="$message" /></assert>
                            </xsl:for-each>
                        </rule>
                    </xsl:if>
                </xsl:for-each>
            </pattern>
        </schema>
    </xsl:template>

</xsl:stylesheet>
