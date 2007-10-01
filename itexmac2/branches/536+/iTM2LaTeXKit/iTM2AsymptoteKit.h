/*
//  iTM2AsymptoteKit.h
//  iTeXMac2
//
//  @version Subversion: $Id: iTM2AsymptoteKit.h 106 2006-07-20 02:14:23Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jun 24 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

extern NSString * const iTM2AsymptoteInspectorMode;
extern NSString * const iTM2AsymptoteToolbarIdentifier;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2AsymptoteInspector

@interface iTM2AsymptoteInspector: iTM2TextInspector
@end

@interface iTM2AsymptoteEditor: iTM2TextEditor
@end

@interface iTM2AsymptoteWindow: iTM2TextWindow
@end

@interface iTM2AsymptoteParserAttributesServer: iTM2TextSyntaxParserAttributesServer
@end

typedef enum _iTM2AsymptoteInputMode 
{
	iTM2DefaultMode = 0
} iTM2AsymptoteInputMode;

@interface iTM2AsymptoteParser: iTM2TextSyntaxParser
@end

/*!
	@class			iTM2AsymptoteParserAttributesDocument
	@superclass		iTM2TeXParserAttributesDocument
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2AsymptoteParserAttributesDocument: iTM2TextSyntaxParserAttributesDocument
@end

/*!
	@class			iTM2AsymptoteParserAttributesInspector
	@superclass		iTM2TeXParserAttributesInspector
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2AsymptoteParserAttributesInspector: iTM2TextSyntaxParserAttributesInspector
@end

extern NSString * const iTM2ToolbarAsymptoteLabelItemIdentifier;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2AsymptoteKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

