<?xml version="1.0" encoding="iso-8859-1"?>
<!-- Edited by XMLSpy® -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="DocumentTestRun">
    <html>
      <body>
        <h2>Test Results</h2>
        <Table>
          <tr>
            <td>Test Run Time:</td>
            <td>
              <xsl:value-of select="TestStartFormatted"/>
            </td>
          </tr>
          <tr>
            <td>Total TestCases:</td>
            <td>
              <xsl:value-of select="TotalTestCases"/>
            </td>
          </tr>
          <tr>
            <td>Passed:</td>
            <td>
              <xsl:value-of select="PassCount"/>
            </td>
          </tr>
          <tr>
            <td>Failed:</td>
            <td>
              <xsl:value-of select="FailCount"/>
            </td>
          </tr>
          <tr>
            <td>Total Time(Minutes):</td>
            <td>
              <xsl:value-of select="TotalTestTime"/>
            </td>
          </tr>
          <tr>
            <td>Output Folder:</td>
            <td>
              <xsl:variable name="Link" select="CurrentFolder"/>
              <a href="{$Link}">
                <xsl:value-of select="OutputFolder"/>
              </a>
            </td>
          </tr>
        
        </Table>
        <table style="width:100%" border="1">
          <tr>
            <td  colspan="8" style="text-align:center;height:40px">Input</td>
            <td colspan="4" style="text-align:center;height:40px">Output</td>
          </tr>
          <tr bgcolor="#9acd32">
            <!--<td>
              ProductBrandID
            </td>-->
            <td>
              Test Case#
            </td>
            <td>
              ChannelID
            </td>
            <td>
              ProductName
            </td>

            <!--<td>
              UtilityID
            </td>-->
            <td>
              UtilityCode
            </td>
            <!--<td>
              MarketID
            </td>-->
            <td>
              MarketCode
            </td>
            <!--<td>
              AccountTypeID
            </td>-->
            <td>
              AccountType
            </td>
            <td>
              Language
            </td>
            <td>
              Price ID
            </td>
            <td>
              Test Result
            </td>
            <td>
              ErrorMessage
            </td>
            <td>
              FileName
            </td>
            <td>
              Time Taken(Seconds)
            </td>
        </tr>
          <xsl:for-each select="Iterations/TestIteration">
            <tr>
              <td>
                <xsl:value-of select="Input/IterationID"/>
              </td>
              <!--<td>
                <xsl:value-of select="ProductBrandID"/>
              </td>-->
              <td>
                <xsl:value-of select="Input/ChannelID"/>
              </td>
              <td>
                <xsl:value-of select="Input/ProductName"/>
              </td>

              <!--<td>
                <xsl:value-of select="UtilityID"/>
              </td>-->
              <td>
                <xsl:value-of select="Input/UtilityCode"/>
              </td>
              <!--<td>
                <xsl:value-of select="MarketID"/>
              </td>-->
              <td>
                <xsl:value-of select="Input/MarketCode"/>
              </td>
              <!--<td>
                <xsl:value-of select="AccountTypeID"/>
              </td>-->
              <td>
                <xsl:value-of select="Input/AccountType"/>
              </td>
              <td>
                <xsl:value-of select="Input/Language"/>
              </td>
              <td>
                <xsl:value-of select="Input/PriceIdToUse"/>
              </td>
              <td>
                <xsl:value-of select="Output/ActualTestResult"/>
              </td>
              <td>
                <xsl:value-of select="Output/ErrorMessage"/>
              </td>
              <td>
                <xsl:variable name="FileName" select="Output/FileName"/>
                <a href="{$FileName}">
                  <xsl:value-of select="Output/FileName"/>
                </a>
              </td>
              <td>
                <xsl:value-of select="TotalIterationTime"/>
              </td>
            </tr>
          </xsl:for-each>
        </table>
      
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>