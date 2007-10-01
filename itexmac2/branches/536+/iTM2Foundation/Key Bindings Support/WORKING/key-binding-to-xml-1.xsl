<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0">
	<xsl:template match="/">
		<LIST>
		<xsl:apply-templates/>
		</LIST>
	</xsl:template >
	<xsl:template match="key" >
		<ulli><xsl:copy-of select="text()" /></ulli>
	</xsl:template >
	<xsl:template match="string" >
		<selector><xsl:copy-of select="text()" /></selector>
	</xsl:template >
	<xsl:template match="array" >
		<commandList><xsl:copy-of select="text()" /></commandList>
	</xsl:template >
</xsl:stylesheet>