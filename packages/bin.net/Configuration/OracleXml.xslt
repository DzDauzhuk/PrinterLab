<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  exclude-result-prefixes="msxsl">
  <xsl:template match="/labels">
    <!--Read original XML and create expandex XML-->
    <xsl:variable name="expandedXML">
      <xsl:for-each select="label">
        <!--Get label name-->
        <xsl:variable name='format'>
          <xsl:choose>
            <xsl:when test='@_FORMAT'>
              <xsl:value-of select='@_FORMAT'/>
            </xsl:when>
            <xsl:when test='preceding::*[@_FORMAT][1]/@_FORMAT'>
              <xsl:value-of select='preceding::*[@_FORMAT][1]/@_FORMAT'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='../@_FORMAT'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!--Get printer name-->
        <xsl:variable name='printer'>
          <xsl:choose>
            <xsl:when test='@_PRINTERNAME'>
              <xsl:value-of select='@_PRINTERNAME'/>
            </xsl:when>
            <xsl:when test='preceding::*[@_PRINTERNAME][1]/@_PRINTERNAME'>
              <xsl:value-of select='preceding::*[@_PRINTERNAME][1]/@_PRINTERNAME'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='../@_PRINTERNAME'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!--Get quantity name-->
        <xsl:variable name='quantity'>
          <xsl:choose>
            <xsl:when test='@_QUANTITY'>
              <xsl:value-of select='@_QUANTITY'/>
            </xsl:when>
            <xsl:when test='preceding::*[@_QUANTITY][1]/@_QUANTITY'>
              <xsl:value-of select='preceding::*[@_QUANTITY][1]/@_QUANTITY'/>
            </xsl:when>
            <xsl:when test='../@_QUANTITY'>
              <xsl:value-of select='../@_QUANTITY'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='1'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!--Get job name name-->
        <xsl:variable name='jobname'>
          <xsl:choose>
            <xsl:when test='@_JOBNAME'>
              <xsl:value-of select='@_JOBNAME'/>
            </xsl:when>
            <xsl:when test='preceding::*[@_JOBNAME][1]/@_JOBNAME'>
              <xsl:value-of select='preceding::*[@_JOBNAME][1]/@_JOBNAME'/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select='../@_JOBNAME'/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <print format="{$format}" printer="{$printer}" quantity="{$quantity}" jobname="{$jobname}">
          <xsl:for-each select="variable">
            <variable name="{@name}">
              <xsl:value-of select="."/>
            </variable>
          </xsl:for-each>
        </print>
      </xsl:for-each>
    </xsl:variable>

    <!--Parse expanded XML-->
    <nice_commands close="true">
      <xsl:for-each select="msxsl:node-set($expandedXML)//print">
        <xsl:if test="not(@format=preceding::print[1]/@format)">
          <xsl:if test="position()-1">
            <xsl:text disable-output-escaping="yes"><![CDATA[</session_print_job></label>]]></xsl:text>
          </xsl:if>
          <xsl:text disable-output-escaping="yes"><![CDATA[<label]]></xsl:text> name='<xsl:value-of select="@format"/>'<xsl:text disable-output-escaping="yes"><![CDATA[ close="true">]]></xsl:text>
        </xsl:if>        
        <xsl:if test="not(@printer=preceding::print[1]/@printer) or not(@format=preceding::print[1]/@format) or not(@jobname=preceding::print[1]/@jobname)">
          <xsl:if test="@format=preceding::print[1]/@format and position()-1">
            <xsl:text disable-output-escaping="yes"><![CDATA[</session_print_job>]]></xsl:text>
          </xsl:if>
          <xsl:text disable-output-escaping="yes"><![CDATA[<session_print_job]]></xsl:text>
          <xsl:if test="not(string(@printer) = '')"> printer='<xsl:value-of select="@printer"/>'</xsl:if>
          <xsl:if test="not(string(@jobname) = '')"> job_name='<xsl:value-of select="@jobname"/>'</xsl:if> clear_variable_values="true"<xsl:text disable-output-escaping="yes"><![CDATA[>]]></xsl:text>
        </xsl:if>        
        <session quantity="{@quantity}">
          <xsl:for-each select="variable">
            <variable name="{@name}">
              <xsl:value-of select="."/>
            </variable>
          </xsl:for-each>
        </session>
      </xsl:for-each>
      <xsl:if test="msxsl:node-set($expandedXML)//print">
        <xsl:text disable-output-escaping="yes"><![CDATA[</session_print_job></label>]]></xsl:text>
      </xsl:if>
    </nice_commands>
  </xsl:template>
</xsl:stylesheet>
