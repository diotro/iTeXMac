<?xml version="1.0"?>
<xsl:stylesheet
   version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"indent="no"/>
   
<xsl:template match="/products">
   <html>
      <head>
         <title>Cascading Style Sheet</title>
         <link rel="stylesheet" type="text/css" href="table.css" 
              title="Style"/>
      </head>
      <body>
        <table>
          <tr class="header">
             <td>Name</td>
             <td>Price</td>
             <td>Description</td>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
   </html>
</xsl:template>

<xsl:template match="product[position() mod 2 = 1]">
   <tr class="odd">
      <td><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="price"/></td>
      <td><xsl:value-of select="description"/></td>
   </tr>
</xsl:template>

<xsl:template match="product">
   <tr class="even">
      <td><xsl:value-of select="name"/></td>
      <td><xsl:value-of select="price"/></td>
      <td><xsl:value-of select="description"/></td>
   </tr>
</xsl:template>

</xsl:stylesheet>