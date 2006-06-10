<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:template match="/MAIN">
         <html>
            <head>
                <meta http-equiv="content-type" content="text/html;charset=UTF-8"/>
                <title>
                    <xsl:value-of select="WINDOW_TITLE"/>
                </title>
                <xsl:if test="@STYLESHEET">
                    <link rel="stylesheet" media="all">
                        <xsl:attribute name="href">
                            <xsl:value-of select="STYLESHEET"/>
                        </xsl:attribute>
                    </link>
                </xsl:if>
                <meta name="robots" content="anchors"/>
                <meta name="AppleTitle">
                    <xsl:attribute name="content">
                        <xsl:value-of select="AppleTitle"/>
                    </xsl:attribute>
                </meta>
                <meta name="AppleIcon">
                    <xsl:attribute name="content">
                        <xsl:value-of select="AppleIcon"/>
                    </xsl:attribute>
                </meta>
                <script type="text/javascript">
                    function doSize() {
                    // check to see if the window is already big enough
                    if ((window.innerWidth @lt; 620) &amp;&amp; (window.innerHeight &lt; 640))
                    // if not, resize it to the minimum
                    window.resizeTo(620,640);
                    
                    }
                </script>
            </head>
            
            <body link="blue" marginheight="0" leftmargin="0" topmargin="-10" onload="doSize();">
                <xsl:if test="@ANCHOR">
                    <a>
                        <xsl:attribute name="name">
                            <xsl:value-of select="@ANCHOR"/>
                        </xsl:attribute>
                    </a>
                </xsl:if>
                <!-- top navigation, topmargin of -10 is for jaguar browsers -->
                <div id="bannerh">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0" background="gfx/gray.gif">
                        <tr valign="middle" height="18">
                            <td class="navbar" valign="middle" width="14" height="18">
                                <p>&#160;</p>
                            </td>
                            <td class="navbar" align="left" valign="middle" height="18">
                                <p class="help-lft">
                                    <font size="1" face="Lucida Grande,Arial, sans-serif">
                                        <span>&#160;</span>
                                    </font>
                                </p>
                            </td>
                            <td class="navbar-rt" align="left" valign="middle" width="42" height="16">
                                <p class="index-rt">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="@REF"/>
                                        </xsl:attribute>
                                        <font size="1" face="Lucida Grande,Arial, sans-serif">
                                            <xsl:value-of select="MAIN_INDEX"/>
                                        </font>
                                    </a>
                                </p>
                            </td>
                            <td class="navbar" valign="middle" width="3" height="18">&#160;</td>
                        </tr>
                    </table>
                </div>
                
                <!-- icon and page title -->
                
                <div id="booktitle">		
                    <div id="icon">
                        <table width="100%" border="0" cellspacing="0" cellpadding="4">
                            <tr height="40">
                                <td align="center" valign="middle" nowrap="yes" bgcolor="white" width="45" height="40">
                                    &#160;
                                    <img alt="" height="32" width="32" border="0">
                                        <xsl:attribute name="src">
                                            <xsl:value-of select="BOOK_TITLE/@IMG"/>
                                        </xsl:attribute>
                                    </img>
                                </td>
                                <td colspan="2" align="left" valign="middle" bgcolor="white" height="40">
                                    <p>
                                        <font size="5" face="Lucida Grande,Arial, sans-serif">
                                            <b>
                                                <span class="accesstitle">
                                                    <span>
                                                        <xsl:value-of select="BOOK_TITLE"/>
                                                    </span>
                                                </span>
                                            </b>
                                        </font>
                                    </p>
                                </td>
                            </tr>
                        </table>		
                    </div>
                </div>
                
                <!-- end icon and page title -->
                <!-- begin content area -->
                <div id="content">		
                    <table width="100%" border="0" cellspacing="1" cellpadding="0">
                        <tr>
                            <td nowrap="yes" width="12"></td>
                            <td class="outline" align="left" valign="top">
                                <table width="100%" border="1" cellspacing="0" cellpadding="0" align="left" height="100%">
                                    <tr height="100%">
                                        <td class="border" align="left" valign="top" height="100%">
                                            <xsl:apply-templates select="TOPIC_LIST"/>
                                        </td>
                                    </tr>
                                </table>
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
                                                        <xsl:value-of select="NEWBIE"/>
                                                        <br/>
                                                    </b>
                                                </font>
                                            </p>
                                        </td>
                                        <td align="left" valign="top" width="5"></td>
                                    </tr>
                                    <tr>
                                        <xsl:apply-templates select="NEWBIE_TOPIC"/>
                                    </tr>
                                    <xsl:apply-templates select="TOP_QUESTION_LIST"/>
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
                <br/>
                    <!-- end content area -->
                    
            </body>
            
         </html>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- WEB -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="WEB">
        <td align="left" valign="top" bgcolor="white" width="28%">
            <p>
                <br/>
                <font size="1" face="Lucida Grande,Arial, sans-serif">
                    <b>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="@REF"/>
                            </xsl:attribute>
                            <xsl:value-of select="WEB_TITLE"/>
                            <br/>
                        </a>
                    </b>
                    <br/>
                    <xsl:value-of select="WEB_DESCRIPTION"/>
                </font>
            </p>
        </td>
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
                                            <xsl:value-of select="WEB_LIST_TITLE"/>
                                        </b>
                                    </span>
                                </font>
                            </th>
                        </tr>
                        <tr>
                            <xsl:variable name="numberOfWEB" select="count(WEB)"/>
                            <xsl:for-each select="WEB">
                                <xsl:apply-templates select="."/>
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
    <!--+-+-+-+-+-+-+-+-+-+- TOP QUESTION -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="TOP_QUESTION">
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
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- TOP QUESTION LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="TOP_QUESTION_LIST">
        <tr>
            <td align="center" valign="top" width="14"></td>
            <td align="left" valign="top"><font size="1"><br/>
            </font>
                <font size="2" face="Lucida Grande,Arial,sans-serif">
                <b>
                    <xsl:value-of select="TOP_QUESTION_TITLE"/>
                    <br/>
                </b>
                </font>
            </td>
            <td align="left" valign="top" width="5"></td>
        </tr>
        <xsl:for-each select="TOP_QUESTION">
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- NEWBIE TOPIC -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="NEWBIE_TOPIC">
        <td align="center" valign="top" width="14"></td>
        <td align="left" valign="top">
            <font size="1" face="Lucida Grande,Arial, sans-serif">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@REF"/>
                    </xsl:attribute>
                    <b>
                        <xsl:value-of select="NEWBIE_TOPIC_TITLE"/>
                        <br/>
                    </b>
                </a>
                <xsl:value-of select="NEWBIE_TOPIC_DESCRIPTION"/>
                <br/>
            </font>
        </td>
        <td align="left" valign="top" width="5"></td>
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
                                    <xsl:apply-templates select="TOPIC_TITLE"/>
                                </a>
                            </font>
                            <br/>
                        </b>
                    </font>
                    <font size="2" face="Lucida Grande,Arial, sans-serif">
                        <xsl:apply-templates select="TOPIC_DESCRIPTION"/>
                    </font>
                </p>
            </td>
        </tr>
    </xsl:template>
    <!--+-+-+-+-+-+-+-+-+-+- TOPIC LIST -+-+-+-+-+-+-+-+-+-+-->
    <xsl:template match="TOPIC_LIST">
        <table width="100%" border="0" cellspacing="1" cellpadding="6">
            <tr>
                <th colspan="2" align="left" valign="top" bgcolor="#e6edff">
                    <p>
                        <font size="2" face="Lucida Grande,Arial, sans-serif">
                            <b>
                                <span class="subhead">
                                    <xsl:value-of select="TOPIC_LIST_TITLE"/>
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
   </xsl:template> 
   <xsl:template match="TASK">
        <font><xsl:attribute name="face">Lucida Grande,Arial, sans-serif</xsl:attribute>
        <xsl:if test="@SELECTED">
            <xsl:attribute name="color">#ff4500</xsl:attribute>
        </xsl:if>
         <a><xsl:attribute name="HREF"><xsl:value-of select="@HREF" /></xsl:attribute><xsl:value-of select="."/></a>
        </font>
    </xsl:template> 
    <xsl:template match="SUBTASK_LIST">
        <td colspan="3">
            <xsl:for-each select="SUBTASK">
                <p>
                    <xsl:apply-templates select="."/>
                </p>
            </xsl:for-each>
        </td>
    </xsl:template> 
    <xsl:template match="SUBTASK">
        <font face="Lucida Grande,Arial, sans-serif"><a><xsl:attribute name="HREF"><xsl:value-of select="@HREF" /></xsl:attribute><xsl:value-of select="."/></a></font>
    </xsl:template> 
</xsl:stylesheet>
