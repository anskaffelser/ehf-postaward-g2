<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:schold="http://www.ascc.net/xml/schematron"
    xmlns:iso="http://purl.oclc.org/dsdl/schematron"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" version="2.0">
    <!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. 	
	Oppdatert 02.10.2013 GuS-->

    <axsl:param name="archiveDirParameter" tunnel="no"/>
    <axsl:param name="archiveNameParameter" tunnel="no"/>
    <axsl:param name="fileNameParameter" tunnel="no"/>
    <axsl:param name="fileDirParameter" tunnel="no"/>

    <!--PHASES-->


    <!--PROLOG-->

    <axsl:output xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no"
        standalone="yes" indent="yes" encoding="UTF-8"/>

    <!--XSD TYPES-->


    <!--KEYS AND FUCNTIONS-->


    <!--DEFAULT RULES-->


    <!--MODE: SCHEMATRON-FULL-PATH-->
    <!--This mode can be used to generate an ugly though full XPath for locators-->

    <axsl:template match="*" mode="schematron-get-full-path">
        <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
        <axsl:text>/</axsl:text>
        <axsl:choose>
            <axsl:when test="namespace-uri()=''">
                <axsl:value-of select="name()"/>
            </axsl:when>
            <axsl:otherwise>
                <axsl:text>*:</axsl:text>
                <axsl:value-of select="local-name()"/>
                <axsl:text>[namespace-uri()='</axsl:text>
                <axsl:value-of select="namespace-uri()"/>
                <axsl:text>']</axsl:text>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:variable name="preceding"
            select="count(preceding-sibling::*[local-name()=local-name(current())                                   and namespace-uri() = namespace-uri(current())])"/>
        <axsl:text>[</axsl:text>
        <axsl:value-of select="1+ $preceding"/>
        <axsl:text>]</axsl:text>
    </axsl:template>
    <axsl:template match="@*" mode="schematron-get-full-path">
        <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
        <axsl:text>/</axsl:text>
        <axsl:choose>
            <axsl:when test="namespace-uri()=''">@<axsl:value-of select="name()"/></axsl:when>
            <axsl:otherwise>
                <axsl:text>@*[local-name()='</axsl:text>
                <axsl:value-of select="local-name()"/>
                <axsl:text>' and namespace-uri()='</axsl:text>
                <axsl:value-of select="namespace-uri()"/>
                <axsl:text>']</axsl:text>
            </axsl:otherwise>
        </axsl:choose>
    </axsl:template>

    <!--MODE: SCHEMATRON-FULL-PATH-2-->
    <!--This mode can be used to generate prefixed XPath for humans-->

    <axsl:template match="node() | @*" mode="schematron-get-full-path-2">
        <axsl:for-each select="ancestor-or-self::*">
            <axsl:text>/</axsl:text>
            <axsl:value-of select="name(.)"/>
            <axsl:if test="preceding-sibling::*[name(.)=name(current())]">
                <axsl:text>[</axsl:text>
                <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
                <axsl:text>]</axsl:text>
            </axsl:if>
        </axsl:for-each>
        <axsl:if test="not(self::*)">
            <axsl:text/>/@<axsl:value-of select="name(.)"/></axsl:if>
    </axsl:template>
    <!--MODE: SCHEMATRON-FULL-PATH-3-->
    <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

    <axsl:template match="node() | @*" mode="schematron-get-full-path-3">
        <axsl:for-each select="ancestor-or-self::*">
            <axsl:text>/</axsl:text>
            <axsl:value-of select="name(.)"/>
            <axsl:if test="parent::*">
                <axsl:text>[</axsl:text>
                <axsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
                <axsl:text>]</axsl:text>
            </axsl:if>
        </axsl:for-each>
        <axsl:if test="not(self::*)">
            <axsl:text/>/@<axsl:value-of select="name(.)"/></axsl:if>
    </axsl:template>

    <!--MODE: GENERATE-ID-FROM-PATH -->

    <axsl:template match="/" mode="generate-id-from-path"/>
    <axsl:template match="text()" mode="generate-id-from-path">
        <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
        <axsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
    </axsl:template>
    <axsl:template match="comment()" mode="generate-id-from-path">
        <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
        <axsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
    </axsl:template>
    <axsl:template match="processing-instruction()" mode="generate-id-from-path">
        <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
        <axsl:value-of
            select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"
        />
    </axsl:template>
    <axsl:template match="@*" mode="generate-id-from-path">
        <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
        <axsl:value-of select="concat('.@', name())"/>
    </axsl:template>
    <axsl:template match="*" mode="generate-id-from-path" priority="-0.5">
        <axsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
        <axsl:text>.</axsl:text>
        <axsl:value-of
            select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"
        />
    </axsl:template>

    <!--MODE: GENERATE-ID-2 -->

    <axsl:template match="/" mode="generate-id-2">U</axsl:template>
    <axsl:template match="*" mode="generate-id-2" priority="2">
        <axsl:text>U</axsl:text>
        <axsl:number level="multiple" count="*"/>
    </axsl:template>
    <axsl:template match="node()" mode="generate-id-2">
        <axsl:text>U.</axsl:text>
        <axsl:number level="multiple" count="*"/>
        <axsl:text>n</axsl:text>
        <axsl:number count="node()"/>
    </axsl:template>
    <axsl:template match="@*" mode="generate-id-2">
        <axsl:text>U.</axsl:text>
        <axsl:number level="multiple" count="*"/>
        <axsl:text>_</axsl:text>
        <axsl:value-of select="string-length(local-name(.))"/>
        <axsl:text>_</axsl:text>
        <axsl:value-of select="translate(name(),':','.')"/>
    </axsl:template>
    <!--Strip characters-->
    <axsl:template match="text()" priority="-1"/>

    <!--SCHEMA METADATA-->

    <axsl:template match="/">
        <svrl:schematron-output xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
            title="BIIRULES  T19 bound to UBL" schemaVersion="">
            <axsl:comment>
                <axsl:value-of select="$archiveDirParameter"/>
                <axsl:value-of select="$archiveNameParameter"/>
                <axsl:value-of select="$fileNameParameter"/>
                <axsl:value-of select="$fileDirParameter"/>
            </axsl:comment>
            <svrl:ns-prefix-in-attribute-values
                uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                prefix="cbc"/>
            <svrl:ns-prefix-in-attribute-values
                uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                prefix="cac"/>
            <svrl:ns-prefix-in-attribute-values
                uri="urn:oasis:names:specification:ubl:schema:xsd:Catalogue-2" prefix="ubl"/>
            <svrl:active-pattern>
                <axsl:attribute name="id">EHF-T19</axsl:attribute>
                <axsl:attribute name="name">EHF-T19</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M6"/>
            <svrl:active-pattern>
                <axsl:attribute name="id">EHFProfiles_T19</axsl:attribute>
                <axsl:attribute name="name">EHFProfiles_T19</axsl:attribute>
                <axsl:apply-templates/>
            </svrl:active-pattern>
            <axsl:apply-templates select="/" mode="M7"/>
        </svrl:schematron-output>
    </axsl:template>

    <!--SCHEMATRON PATTERNS-->

    <svrl:text xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Norwegian rules for EHF Catalogue</svrl:text>

    <!--PATTERN UBL-T19-->


    <!--RULE -->

    <axsl:template match="/ubl:Catalogue" priority="1010" mode="M6">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/ubl:Catalogue"/>

  
        <!-- ASSERT -->

        <axsl:choose>
            <axsl:when test="string-length(cbc:ActionCode) &gt;0"> </axsl:when>
            <axsl:when test="not(cac:CatalogueLine[cbc:ActionCode =''])"> </axsl:when>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                    test="cbc:ActionCode ='' and cac:CatalogueLine[cbc:Actioncode !='']">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T19-R001]- A Catalogue must contain ActionCode on either Header or Line level</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>

     
        <!-- ASSERT -->

        <axsl:choose>
            <axsl:when
                test="number(translate(substring-before(string(current-date()),'+'),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-',''))"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                    test="number(translate(substring-before(string(current-date()),'+'),'-','')) &lt;= number(translate(string(//cac:ValidityPeriod/cbc:EndDate),'-',''))">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T19-R002]- A Catalogue must have a validity period enddate grater or equal to the current date</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        
        <!--ASSERT -->
        <axsl:choose>
            <axsl:when test="(cbc:UBLVersionID != '')"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(cbc:UBLVersionID)">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T19-R007]-A catalogue MUST have a syntax identifier.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        
        
        <!--ASSERT -->
        <axsl:choose>
            <axsl:when test="cac:ValidityPeriod"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cac:ValidityPeriod">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T01-R008]-An order MUST have a validity period.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        
        <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
        

    
    <!--RULE -->
    
    <axsl:template match="cac:ValidityPeriod" priority="1010" mode="M6">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:ValidityPeriod"/>
        
        
        <!--ASSERT -->
        <axsl:choose>
            <axsl:when test="cbc:StartDate"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:StartDate">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T01-R009]-An order MUST have a validity start date.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        
        <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
    
    <!--RULE -->
    
    <axsl:template match="cac:ReceiverParty" priority="1010" mode="M6">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:ReceiverParty"/>
        
        
        <!--ASSERT -->
        <axsl:choose>
            <axsl:when test="cbc:EndpointID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:EndpointID">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T01-R010]-An order MUST have an endpoint ID for receiver.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        
        <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
    
    
    <!--RULE -->
    <axsl:template match="//cac:TaxScheme" priority="1012" mode="M6">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cac:TaxScheme"/>
        <!--ASSERT -->
        <axsl:choose>
            <axsl:when test="cbc:ID"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="cbc:ID">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T19-R011]-Every tax scheme MUST be defined through an identifier.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
    
    <!--RULE -->
    
    <axsl:template match="cac:CatalogueLine" priority="1010" mode="M6">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:CatalogueLine"/>
        
        
        <!-- ASSERT -->
        
        <axsl:choose>
            <axsl:when test="cbc:OrderableIndicator"/> 
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                    test="cbc:OrderableIndicator">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T19-R003]- A Catalogue line MUST have an orderable indicator</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
      
    <!-- ASSERT -->
    
    <axsl:choose>
        <axsl:when test="cac:Item"/> 
        <axsl:otherwise>
            <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                test="cac:Item">
                <axsl:attribute name="flag">fatal</axsl:attribute>
                <axsl:attribute name="location">
                    <axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
                </axsl:attribute>
                <svrl:text>[NOGOV-T19-R004]- A Catalogue line MUST have item/article information</svrl:text>
            </svrl:failed-assert>
        </axsl:otherwise>
    </axsl:choose>
    <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
    
    
    <!--RULE-->
    <axsl:template match="cac:CatalogueLine/cac:Item" priority="1010" mode="M6">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="cac:CatalogueLine/cac:Item"/>
        
        
        <!-- ASSERT -->
        
        <axsl:choose>
            <axsl:when test="cbc:Name"/> 
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                    test="cbc:Name">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T19-R005]- A Catalogue item MUST have a name</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
    
    <!--RULE -->
    
    <axsl:template match="//*[contains(name(),'Date')]" priority="1000" mode="M6">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//*[contains(name(),'Date')]"/>
        
        <!--ASSERT -->
        <axsl:choose>
            <axsl:when test="(string(.) castable as xs:date) and (string-length(.) = 10)"/>
            
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(string(.) castable as xs:date) and (string-length(.) = 10)">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path"/>
                    </axsl:attribute>
                    <svrl:text>[NOGOV-T19-R006]- A date must be formatted YYYY-MM-DD.</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        
        <axsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
    
    
    <axsl:template match="text()" priority="-1" mode="M6"/>
    <axsl:template match="@*|node()" priority="-2" mode="M6">
        <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M6"/>
    </axsl:template>
    
    <!--RULE -->
    
    <axsl:template match="//cbc:ProfileID" priority="1001" mode="M7">
        <svrl:fired-rule xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="//cbc:ProfileID"/>
        
        <!--ASSERT -->
        
        <axsl:choose>
            <axsl:when test=". = 'urn:www.cenbii.eu:profile:bii01:ver2.0'"/>
            <axsl:otherwise>
                <svrl:failed-assert xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                    test=". = 'urn:www.cenbii.eu:profile:bii01:ver2.0'">
                    <axsl:attribute name="flag">fatal</axsl:attribute>
                    <axsl:attribute name="location">
                        <axsl:apply-templates select="." mode="schematron-get-full-path-3"/>
                    </axsl:attribute>
                    <svrl:text>[EHFPROFILE-T19-R001]-A catalogue must only be used in profile 1</svrl:text>
                </svrl:failed-assert>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
    </axsl:template>
    
    <axsl:template match="text()" priority="-1" mode="M7"/>
    <axsl:template match="@*|node()" priority="-2" mode="M7">
        <axsl:apply-templates select="*|comment()|processing-instruction()" mode="M7"/>
    </axsl:template>

</axsl:stylesheet>
