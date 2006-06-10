<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:param name="MAIN_HELP">iTeXMac2 Help</xsl:param>
    <xsl:param name="MAIN_HELP_REF">index.html</xsl:param>
    <xsl:param name="MAIN_INDEX">Index</xsl:param>
    <xsl:param name="MAIN_INDEX_REF">pgs/index.html</xsl:param>
    <xsl:param name="MAIN_BOOKID">iTeXMac2%20Help</xsl:param>
    <xsl:param name="MAIN_ICON">gfx/iTeXMac2.png</xsl:param>
    <xsl:param name="ALT_ICON">iTeXMac2 Icon</xsl:param>
    <xsl:param name="COPYRIGHT">Laurens'Tribune 2006</xsl:param>
    <xsl:param name="VERSION">2.0</xsl:param>
    <xsl:param name="LEARN_MORE">Learn more</xsl:param>
    <xsl:param name="SHOW_TOPIC">Show Topic</xsl:param>
    <xsl:param name="AppleTitle">iTeXMac2</xsl:param>
    <xsl:param name="AppleIcon">gfx/iTeXMac2.png</xsl:param>
    <!--+-+-+-+-+-+-+-+-+-+- / -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="/">
        <html>
            <xsl:call-template name="HEAD"/>
            <xsl:call-template name="BODY"/>
        </html>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- HEAD -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="HEAD">
        <head>
            <title>
                <xsl:value-of select="/*/@TITLE"/>
            </title>
            <link href="../sty/task_tbl_style.css" rel="stylesheet" media="all"/><!--         STYLESHEET CDATA "sty/iapp_styleh.css"
            -->
            <xsl:if test="string-length(/*/@KEYWORDS)&gt;0">
                <meta name="keywords">
                    <xsl:attribute name="content">
                        <xsl:value-of select="/*/@KEYWORDS"/>
                    </xsl:attribute>
                </meta>
            </xsl:if>
            <xsl:if test="string-length(/*/@DESCRIPTION)&gt;0">
                <meta name="description">
                    <xsl:attribute name="content">
                        <xsl:value-of select="/*/@DESCRIPTION"/>
                    </xsl:attribute>
                </meta>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="string-length(/*/@AppleIcon)&gt;0">
                    <meta name="AppleIcon">
                        <xsl:attribute name="content">
                            <xsl:value-of select="/*/@AppleIcon"/>
                        </xsl:attribute>
                    </meta>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length(AppleIcon)&gt;0">
                        <meta name="AppleIcon">
                            <xsl:attribute name="content">
                                <xsl:value-of select="AppleIcon"/>
                            </xsl:attribute>
                        </meta>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="string-length(/*/@AppleTitle)&gt;0">
                    <meta name="AppleTitle">
                        <xsl:attribute name="content">
                            <xsl:value-of select="/*/@AppleTitle"/>
                        </xsl:attribute>
                    </meta>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length($AppleTitle)&gt;0">
                        <meta name="$AppleTitle">
                            <xsl:attribute name="content">
                                <xsl:value-of select="$AppleTitle"/>
                            </xsl:attribute>
                        </meta>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="string-length($COPYRIGHT)&gt;0">
                <meta name="copyright">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$COPYRIGHT"/>
                    </xsl:attribute>
                </meta>
            </xsl:if>
            <meta name="robots" content="anchors"/>
        </head>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- BODY -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="BODY">
        <body leftmargin="12" topmargin="-10" bgcolor="#ffffff">
            <xsl:call-template name="NAVIGATION"/>
            <xsl:apply-templates select="MAIN"/>
            <xsl:if test="/TOPIC"><xsl:call-template name="TOPIC_CONTENT"/></xsl:if>
            <xsl:if test="/TOPIC_SET"><xsl:call-template name="TOS_CONTENT"/></xsl:if>
            <xsl:apply-templates select="/SECTION_TOC"/>
            <xsl:apply-templates select="/INDEX"/>
            <xsl:call-template name="BOTTOM"/>
        </body>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- NAVIGATION -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="NAVIGATION">
        <div id="bannerh">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" background="../gfx/gray.gif">
                <tr align="left" valign="middle" height="16">
                    <td class="navbar" align="left" valign="middle" height="16">
                        <p class="help-lft">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$MAIN_HELP_REF"/>
                                </xsl:attribute>
                                <font size="1" face="Lucida Grande,Arial, sans-serif">
                                    <span>
                                        <xsl:value-of select="$MAIN_HELP"/>
                                    </span>
                                </font>
                            </a>
                        </p>
                    </td>
                    <td class="navbar-rt" align="left" valign="middle" width="42" height="16">
                        <p class="index-rt">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$MAIN_INDEX_REF"/>
                                </xsl:attribute>
                                <font size="1" face="Lucida Grande,Arial, sans-serif">
                                    <xsl:value-of select="$MAIN_INDEX"/>
                                </font>
                            </a>
                        </p>
                    </td>
                    <td class="navbar" valign="middle" width="8" height="16">&#160;</td>
                </tr>
            </table>
        </div>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- BOTTOM -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="BOTTOM">
        <div id="bannerh">
            <table width="100%" border="0" cellspacing="0" cellpadding="0" background="../gfx/gray.gif">
                <tr align="left" valign="middle" height="16">
                    <td class="navbar" align="left" valign="middle" height="16">
                        <p class="help-lft">
                            <font size="1" face="Lucida Grande,Arial, sans-serif">
                                <span>
                                    <xsl:value-of select="$COPYRIGHT"/>
                                </span>
                            </font>
                        </p>
                    </td>
                    <td class="navbar-rt" align="left" valign="middle" width="42" height="16">
                        <p class="index-rt">
                            <font size="1" face="Lucida Grande,Arial, sans-serif">
                                <xsl:choose>
                                    <xsl:when test="string-length(@VERSION)&gt;0"><xsl:value-of select="@VERSION"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="$VERSION"/></xsl:otherwise>
                                </xsl:choose>
                            </font>
                        </p>
                    </td>
                    <td class="navbar" valign="middle" width="8" height="16">&#160;</td>
                </tr>
            </table>
        </div>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- CONTENT_TITLE -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="CONTENT_TITLE">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="middle" height="10">
                <td width="32" height="10"></td>
                <td width="8" height="10"></td>
                <td height="10"></td>
            </tr>
            <tr valign="middle">
                <td width="32">
                    <img height="32" width="32">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$MAIN_ICON"/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select="$ALT_ICON"/>
                        </xsl:attribute>
                    </img>
                </td>
                <td width="8">&#160;&#160;</td>
                <td>
                    <font size="4" face="Lucida Grande,Arial,sans-serif" id="topic">
                        <b>
                            <xsl:copy-of select="/*/TITLE/node()"/>
                        </b>
                    </font>
                </td>
            </tr>
        </table>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- TOPIC_CONTENT -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="TOPIC_CONTENT">
        <div id="mainbox" align="left">
            <a name="top"></a>
            <xsl:call-template name="CONTENT_TITLE"/>
            <!--+-+-+-+-+-+-+-+-+-+- END OF COMMON HEADER -+-+-+-+-+-+-+-+-+-+-->
            <xsl:apply-templates select="/*/INTRODUCTION"/>
            <xsl:apply-templates select="/*/DESCRIPTION"/>
            <xsl:apply-templates select="/*/CONCLUSION"/>
        </div>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- INTRODUCTION -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="INTRODUCTION">
        <table width="100%" border="0" cellspacing="0" cellpadding="3">
            <tr>
                <td>
                    <p>
                        <font face="Lucida Grande,Arial,sans-serif">
                            <xsl:value-of select="."/>
                        </font>
                    </p>
                </td>
            </tr>
        </table>
    </xsl:template> 
    <!--+-+-+-+-+-+-+-+-+-+- DESCRIPTION -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="DESCRIPTION">
        <div id="taskbox">
            <table width="100%" border="0" cellspacing="0" cellpadding="7" BGCOLOR="#e6edff">
                <tr valign="top" BGCOLOR="#e6edff">
                    <td bgcolor="#e6edff" width="98%">
                        <xsl:if test="string-length(TITLE)&gt;0">
                            <p>
                                <font face="Lucida Grande,Arial,sans-serif">
                                    <b>
                                        <xsl:value-of select="TITLE"/>
                                    </b>
                                    <br/>
                                </font>
                            </p>
                        </xsl:if>
                        <font face="Lucida Grande,Arial,sans-serif">
                            <xsl:choose>
                                <xsl:when test="count(TASK)&gt;1">
                                    <xsl:choose>
                                        <xsl:when test="@ORDERED='ORDERED'">
                                            <xsl:for-each select="TASK">
                                                <table border="0" cellspacing="0" cellpadding="4">
                                                    <tr valign="top">
                                                        <td width="16">
                                                            <font face="Lucida Grande,Arial,sans-serif">
                                                                <p>
                                                                    <xsl:number value="position()" format="1."/>
                                                                </p>
                                                            </font>
                                                        </td>
                                                        <td>
                                                            <font face="Lucida Grande,Arial,sans-serif">
                                                                <p>
                                                                    <xsl:copy-of select="node()"/>
                                                                </p>
                                                            </font>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="TASK">
                                                <table border="0" cellspacing="0" cellpadding="4">
                                                    <tr valign="top">
                                                        <td width="16">
                                                            <font face="Lucida Grande,Arial,sans-serif">
                                                                <p>&#149;</p>
                                                            </font>
                                                        </td>
                                                        <td>
                                                            <font face="Lucida Grande,Arial,sans-serif">
                                                                <p>
                                                                    <xsl:copy-of select="node()"/>
                                                                </p>
                                                            </font>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>
                                        <xsl:copy-of select="TASK/node()"/>
                                    </p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </font>
                    </td>
                </tr>
            </table>
        </div>
    </xsl:template> 
    <!--+-+-+-+-+-+-+-+-+-+- CONCLUSION -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="CONCLUSION">
        <xsl:if test="string-length(.)&gt;0">
            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                    <td>
                        <p>
                            <font face="Lucida Grande,Arial,sans-serif">
                                <xsl:value-of select="."/>
                            </font>
                        </p>
                    </td>
                </tr>
            </table>
        </xsl:if>
    </xsl:template> 
    <!--+-+-+-+-+-+-+-+-+-+- MAIN_CONTENT -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="MAIN">
        <div id="booktitle">		
            <div id="icon">
                <table width="100%" border="0" cellspacing="0" cellpadding="4">
                    <tr height="40">
                        <td align="center" valign="middle" nowrap="nowrap" bgcolor="white" width="45" height="40">&#160;<img alt="" height="32" width="32" border="0"><xsl:attribute name="src"><xsl:value-of select="$MAIN_ICON"/></xsl:attribute></img></td>
                        <td colspan="2" align="left" valign="middle" bgcolor="white" height="40">
                            <p>
                                <font size="5" face="Lucida Grande,Arial, sans-serif">
                                    <b>
                                        <span class="accesstitle">
                                    <span><xsl:copy-of select="TITLE/node()"/></span>
                                </span>
                                </b>
                                </font>
                            </p>
                        </td>
                    </tr>
                </table>		
            </div>
        </div>
         <div id="content">		
            <table width="100%" border="0" cellspacing="1" cellpadding="0">
                <tr>
                    <td nowrap="yes" width="12"></td>
                    <td class="outline" align="left" valign="top">
                        <xsl:apply-templates select="TOPIC_LIST"/>
                    </td>
                    <td bgcolor="white" width="16">
                        <p>&#160;</p>
                    </td>
                    <td align="left" valign="top" bgcolor="#e6edff" width="30%">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                            <tr height="10">
                                <td align="center" valign="top" width="14" height="10"></td>
                                <td align="left" valign="bottom" height="10"></td>
                                <td align="left" valign="top" width="5" height="10"></td>
                            </tr>
                            <tr>
                                <td align="center" valign="top" width="14"></td>
                                <td align="left" valign="bottom">
                                    <p>
                                        <font size="2" face="Lucida Grande,Arial, sans-serif">
                                            <b>
                                                <xsl:copy-of select="NEWBIE/node()"/>
                                                <br/>
                                            </b>
                                        </font>
                                    </p>
                                </td>
                                <td align="left" valign="top" width="5"></td>
                            </tr>
                            <xsl:apply-templates select="NEWBIE_LIST"/>
                            <xsl:apply-templates select="QUESTION_LIST"/>
                            <xsl:apply-templates select="WHATSNEW_LIST"/>
                        </table>
                        <br/>
                    </td>
                    <td align="left" valign="top" nowrap="yes" width="2"></td>
                </tr>
                <tr height="16">
                    <td width="12" height="16"></td>
                    <td align="left" valign="top" height="16"></td>
                    <td bgcolor="white" width="16" height="16"></td>
                    <td align="left" valign="top" width="30%" height="16"></td>
                    <td align="left" valign="top" width="2" height="16"></td>
                </tr>
                <tr>
                    <td width="12"></td>
                    <td class="outline" colspan="3" align="left" valign="top">
                        <xsl:apply-templates select="WEB_LIST"/>
                    </td>
                    <td align="left" valign="top" width="2"></td>
                </tr>
            </table>		
        </div>	
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- WEB LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="WEB_LIST">
        <table width="100%" border="1" cellspacing="0" cellpadding="0">
            <tr>
                <td class="border">
                    <table width="100%" border="0" cellspacing="1" cellpadding="6" bgcolor="white">
                        <tr>
                            <th colspan="7" align="left" valign="top" bgcolor="#e6edff">
                                <font size="2" face="Lucida Grande,Arial, sans-serif">
                                    <span class="subhead">
                                        <b>
                                            <xsl:value-of select="TITLE"/>
                                        </b>
                                    </span>
                                </font>
                            </th>
                        </tr>
                        <tr>
                            <xsl:variable name="numberOfWEB" select="count(TOPIC)"/>
                            <xsl:for-each select="TOPIC">
                                <td align="left" valign="top" bgcolor="white" width="28%">
                                    <p>
                                        <br/>
                                        <font size="1" face="Lucida Grande,Arial, sans-serif">
                                            <b>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:value-of select="@REF"/>
                                                    </xsl:attribute>
                                                    <xsl:copy-of select="TITLE/node()"/>
                                                    <br/>
                                                </a>
                                            </b>
                                            <br/>
                                            <xsl:copy-of select="DESCRIPTION/node()"/>
                                        </font>
                                    </p>
                                </td>
                                <xsl:if test="position() &lt; $numberOfWEB">
                                    <td align="left" valign="top" nowrap="yes" bgcolor="white" width="4">
                                        <p></p>
                                    </td>
                                </xsl:if>
                             </xsl:for-each>
                          </tr>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- TOP QUESTION LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="QUESTION_LIST">
        <xsl:call-template name="DO_QUESTION_LIST"/>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- TOP QUESTION LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="WHATSNEW_LIST">
        <xsl:call-template name="DO_QUESTION_LIST"/>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- DO QUESTION LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="DO_QUESTION_LIST">
            <tr>
            <td align="center" valign="top" width="14"></td>
            <td align="left" valign="top"><font size="1"><br/>
            </font>
                <font size="2" face="Lucida Grande,Arial,sans-serif">
                    <b>
                        <xsl:copy-of select="TITLE/node()"/>
                        <br/>
                    </b>
                </font>
            </td>
            <td align="left" valign="top" width="5"></td>
        </tr>
        <xsl:for-each select="NAMEDLINK">
            <tr>
                <td align="center" valign="top" width="14">
                    <p>
                        <font size="1">
                            &#160;
                            <img src="gfx/bullet.gif" alt="" height="6" width="4" align="bottom" border="0"/>
                        </font>
                    </p>
                </td>
                <td align="left" valign="top">
                    <p>
                        <font size="1" face="Lucida Grande,Arial, sans-serif">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="@REF"/>
                                </xsl:attribute>
                                <xsl:value-of select="."/>
                                <br/>
                            </a>
                        </font>
                    </p>
                </td>
                <td align="left" valign="top" width="5"></td>
            </tr>
        </xsl:for-each>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- NEWBIE LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="NEWBIE_LIST">
        <tr>
            <td align="center" valign="top" width="14"></td>
            <td align="left" valign="top"><font size="1"><br/>
            </font>
                <font size="2" face="Lucida Grande,Arial,sans-serif">
                    <b>
                        <xsl:copy-of select="/*/NEWBIE_LIST/TITLE/node()"/>
                        <br/>
                    </b>
                </font>
            </td>
            <td align="left" valign="top" width="5"></td>
        </tr>
        <xsl:for-each select="/*/NEWBIE_LIST/TOPIC">
            <td align="center" valign="top" width="14"></td>
            <td align="left" valign="top">
                <font size="1" face="Lucida Grande,Arial, sans-serif">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="@REF"/>
                        </xsl:attribute>
                        <b>
                            <xsl:value-of select="TITLE"/>
                            <br/>
                        </b>
                    </a>
                    <xsl:value-of select="SUMMARY"/>
                    <br/>
                </font>
            </td>
            <td align="left" valign="top" width="5"></td>
        </xsl:for-each>
        
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- TOPIC -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="TOPIC">
        <tr>
            <td align="center" valign="top" bgcolor="white">
                <h2>
                    <br/>
                    <img alt="" height="32" width="32" border="0">
                        <xsl:attribute name="src">
                            <xsl:value-of select="@IMG"/>
                        </xsl:attribute>
                    </img>
                </h2>
                <p>
                    <font size="2" face="Lucida Grande,Arial, sans-serif">
                    </font>
                </p>
            </td>
            <td align="left" valign="top" bgcolor="white">
                <p>
                    <font size="2">
                        <br/>
                        <b>
                            <font face="Lucida Grande,Arial, sans-serif">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@HREF"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="TITLE"/>
                                </a>
                            </font>
                            <br/>
                        </b>
                    </font>
                    <font size="2" face="Lucida Grande,Arial, sans-serif">
                        <xsl:apply-templates select="DESCRIPTION"/>
                    </font>
                </p>
            </td>
        </tr>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- TOPIC LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="TOPIC_LIST">
        <table width="100%" border="1" cellspacing="0" cellpadding="0" align="left" height="100%">
            <tr height="100%">
                <td class="border" align="left" valign="top" height="100%">
                    <table width="100%" border="0" cellspacing="1" cellpadding="6">
                        <tr>
                            <th colspan="2" align="left" valign="top" bgcolor="#e6edff">
                                <p>
                                    <font size="2" face="Lucida Grande,Arial, sans-serif">
                                        <b>
                                            <span class="subhead">
                                                <xsl:value-of select="TITLE"/>
                                            </span>
                                        </b>
                                    </font>
                                </p>
                            </th>
                        </tr>
                        <xsl:for-each select="TOPIC">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </table>
                </td>
            </tr>
        </table>
    </xsl:template> 
    <!--+-+-+-+-+-+-+-+-+-+- TOT_CONTENT -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="TOS_CONTENT">
        <div id="mainbox" align="left">
            <a name="top"></a>
            <xsl:call-template name="CONTENT_TITLE"/>
            <!--+-+-+-+-+-+-+-+-+-+- END OF COMMON HEADER -+-+-+-+-+-+-+-+-+-+-->
            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                    <td>
                        <p><font face="Lucida Grande,Arial, sans-serif"><br/>
                        </font></p>
                    </td>
                </tr>
            </table>
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td class="dots" align="left" valign="top" width="12">
                        <xsl:call-template name="TOPIC_SET"/>
                    </td>
                </tr>
            </table>
            <br/>
        </div>
    </xsl:template> 
    <!--+-+-+-+-+-+-+-+-+-+- TOPIC_SET -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="TOPIC_SET">
        <table width="100%" border="0" cellspacing="1" cellpadding="6">
            <xsl:for-each select="/*/TOPIC">
                <tr>
                    <td class="blue" align="left" valign="top" bgcolor="#e6edff" width="50%">
                        <p><font face="Lucida Grande,Arial, sans-serif"><b><xsl:value-of select="TITLE"/></b></font></p>
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top" width="50%">
                        <p><font face="Lucida Grande,Arial, sans-serif"><xsl:value-of select="DESCRIPTION"/></font></p>
                    </td>
                </tr>
                <tr>
                    <td align="left" valign="top" width="50%">
                        <p><font face="Lucida Grande,Arial, sans-serif">
                            <a><xsl:attribute name="href"><xsl:value-of select="@HREF"/></xsl:attribute><xsl:value-of select="$SHOW_TOPIC"/></a></font></p>
                    </td>
                </tr>
            </xsl:for-each>
        </table>
    </xsl:template> 
    <!--+-+-+-+-+-+-+-+-+-+- SECTION_TOC -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="SECTION_TOC">
        <div id="mainbox" align="left">
            <a name="top"></a>
            <xsl:call-template name="CONTENT_TITLE"/>
            <!--+-+-+-+-+-+-+-+-+-+- END OF COMMON CONTENT -+-+-+-+-+-+-+-+-+-+-->
            <table width="100%" border="0" cellspacing="0" cellpadding="3">
                <tr>
                    <td>
                        <p><font face="Lucida Grande,Arial, sans-serif"><br/>
                        </font></p>
                    </td>
                </tr>
            </table>
            <table width="100%" border="0" cellspacing="1" cellpadding="6">
                <table summary="One column table" width="94%" border="0" cellspacing="1" cellpadding="6">
                    <xsl:for-each select="/*/NAMEDLINK">
                        <tr>
                            <td align="left" valign="top" width="50%">
                                <font face="Lucida Grande,Arial, sans-serif">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="@HREF"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="."/>
                                    </a>
                                </font>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </table>
            <br/>
        </div>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- DO_INDEX -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template name="DO_INDEX">
        <xsl:param name="data"/>
        <table summary="One column table" width="94%" border="0" cellspacing="1" cellpadding="6">
            <xsl:for-each select="$data/_ENTRY">
                <xsl:sort select="SHORT"/>
                <xsl:if test="(string-length(SHORT)&gt;0) and (string-length(@HREF)&gt;0)">
                    <xsl:choose>
                        <xsl:when test="string-length(SEE)&gt;0">
                            <xsl:if test="string-length(@HREF)&gt;0">
                                <tr>
                                    <td class="rules" valign="top" width="140">
                                        <p>
                                            <font face="Lucida Grande,Arial, sans-serif">
                                                <xsl:copy-of select="SHORT/node()"/>
                                            </font>
                                        </p>
                                    </td>
                                    <td class="rules" valign="top" width="20"></td>
                                    <td class="rules" valign="top">
                                        <p>
                                            <font face="Lucida Grande,Arial, sans-serif">
                                                <a><xsl:attribute name="HREF"><xsl:value-of select="HREF"/></xsl:attribute><xsl:copy-of select="SEE/node()"/></a>
                                            </font>
                                        </p>
                                    </td>
                                </tr>
                            </xsl:if>	
                        </xsl:when>
                        <xsl:otherwise>
                            <tr>
                                <td class="rules" valign="top" width="140">
                                    <p>
                                        <font face="Lucida Grande,Arial, sans-serif">
                                            <a><xsl:attribute name="HREF"><xsl:value-of select="HREF"/></xsl:attribute><xsl:copy-of select="SHORT/node()"/></a>
                                        </font>
                                    </p>
                                </td>
                                <td class="rules" valign="top" width="20"></td>
                                <td class="rules" valign="top">
                                    <p/>
                                </td>
                            </tr>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </table>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- INDEX -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="INDEX">
        <div id="mainbox" align="left">
            <a name="top"></a>
            <xsl:call-template name="CONTENT_TITLE"/>
            <xsl:call-template name="DO_INDEX">
                <xsl:with-param name="data">
                    <xsl:for-each select="INCLUDE">
                        <xsl:variable name="HREF" select="@HREF"/>
                        <xsl:variable name="content" select="document(@HREF)"/>
                        <xsl:variable name="short" select="$content/TOPIC/SHORT/node()"/>
                        <xsl:if test="string-length($short)&gt;0">
                            <xsl:element name="_ENTRY">
                                <xsl:attribute name="HREF"><xsl:value-of select="$HREF"/></xsl:attribute>
                                <xsl:element name="SHORT"><xsl:copy-of select="$short"/></xsl:element>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="INDEX_ENTRY">
                        <xsl:if test="INCLUDE">
                            <xsl:variable name="HREF" select="INCLUDE"/>
                            <xsl:variable name="short" select="SHORT/node()"/>
                            <xsl:if test="string-length($short)&gt;0">
                                <xsl:element name="_ENTRY">
                                    <xsl:variable name="content" select="document($HREF)"/>
                                    <xsl:variable name="see" select="$content/TOPIC/SHORT/node()"/>
                                    <xsl:copy-of select="."/>
                                    <xsl:if test="string-length(see)&gt;0">
                                        <xsl:attribute name="HREF"><xsl:value-of select="$HREF"/></xsl:attribute>
                                        <xsl:element name="SHORT"><xsl:copy-of select="$short/node()"/></xsl:element>
                                        <xsl:element name="SEE"><xsl:copy-of select="$see/node()"/></xsl:element>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:with-param>
            </xsl:call-template>
        </div>
    </xsl:template>
</xsl:stylesheet>
