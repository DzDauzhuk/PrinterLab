<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  exclude-result-prefixes="msxsl">
  <xsl:template match="/Command">
    <!--Read original XML and create expandex XML-->
    <xsl:variable name="expandedXML">
      <xsl:for-each select="WriteTagData">
        <xsl:for-each select="Item">
          <xsl:for-each select="FieldList">
            <!--Get label name-->
            <xsl:variable name='format'>
              <xsl:choose>
                <xsl:when test='@format'>
                  <xsl:value-of select='@format'/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select='preceding::*[@format][1]/@format'/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!--Get printer name-->
            <xsl:variable name='printerName'>
              <xsl:choose>
                <xsl:when test='@printerName'>
                  <xsl:value-of select='@printerName'/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select='preceding::*[@printerName][1]/@printerName'/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!--Get quantity-->
            <xsl:variable name='quantity'>
              <xsl:choose>
                <xsl:when test='@quantity'>
                  <xsl:value-of select='@quantity'/>
                </xsl:when>
                <xsl:when test='preceding::*[@quantity][1]/@quantity'>
                  <xsl:value-of select='preceding::*[@quantity][1]/@quantity'/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select='1'/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!--Get job name-->
            <xsl:variable name='jobname'>
              <xsl:choose>
                <xsl:when test='@jobName'>
                  <xsl:value-of select='@jobName'/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select='preceding::*[@jobName][1]/@jobName'/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <print format="{$format}" printerName="{$printerName}" quantity="{$quantity}" jobname="{$jobname}">
              <xsl:for-each select="Field">
                <variable name="{@name}">
                  <xsl:value-of select="."/>
                </variable>
              </xsl:for-each>
            </print>
          </xsl:for-each>
        </xsl:for-each>
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
        <xsl:if test="not(@printerName=preceding::print[1]/@printerName) or not(@format=preceding::print[1]/@format) or not(@jobname=preceding::print[1]/@jobname)">
          <xsl:if test="@format=preceding::print[1]/@format and position()-1">
            <xsl:text disable-output-escaping="yes"><![CDATA[</session_print_job>]]></xsl:text>
          </xsl:if>
          <xsl:text disable-output-escaping="yes"><![CDATA[<session_print_job]]></xsl:text>
          <xsl:if test="not(string(@printerName) = '')"> printer_name='<xsl:value-of select="@printerName"/>'</xsl:if>
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
