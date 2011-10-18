/*
//  iTM2ConTeXtSupport.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
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

extern NSString * const iTM2ConTeXtInspectorMode;
extern NSString * const iTM2ConTeXtToolbarIdentifier;
extern NSString * const iTM2ConTeXtManuals;
extern NSString * const iTM2ConTeXtManualsTable;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ConTeXtInspector

@interface iTM2ConTeXtInspector: iTM2TeXInspector
+ (NSURL *)ConTeXtPragmaADEURL;
+ (NSURL *)ConTeXtGardenPageURLWithRef:(NSString *)ref;
+ (NSURL *)ConTeXtGardenMainPageURL;
@end

@interface iTM2ConTeXtEditor: iTM2TeXEditor
@end

@interface iTM2ConTeXtWindow: iTM2TeXWindow
@end

@interface iTM2ConTeXtResponder: iTM2AutoInstallResponder
@end

@interface iTM2ConTeXtSectionButton: NSPopUpButton
@end

@interface iTM2ConTeXtLabelButton: NSPopUpButton
@end

@interface iTM2ConTeXtParserAttributesServer: iTM2TeXParserAttributesServer
@end

@interface iTM2XtdConTeXtParserAttributesServer: iTM2XtdTeXParserAttributesServer
@end

typedef enum _iTM2ConTeXtInputMode 
{
    kiTM2ConTeXtIncludeSyntaxMode = 1000,
    kiTM2ConTeXtIncludegraphicsSyntaxMode = 1001,
    kiTM2ConTeXtURLSyntaxMode = 1002,
	kiTM2ConTeXtUnknownSyntaxMode = kiTM2TeXUnknownSyntaxMode
} iTM2ConTeXtInputMode;

@interface iTM2ConTeXtParser: iTM2TeXParser
@end

@interface NSTextStorage(iTM2ConTeXt)
- (NSMenu *)ConTeXtSectionMenu;
- (void)getConTeXtLabelMenu:(NSMenu **)labelMenuRef refMenu:(NSMenu **)refMenuRef;
@end

@interface iTM2XtdConTeXtParser: iTM2XtdTeXParser
@end

/*!
	@class			iTM2ConTeXtParserAttributesDocument
	@superclass		iTM2TeXParserAttributesDocument
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2ConTeXtParserAttributesDocument: iTM2TeXParserAttributesDocument
@end

/*!
	@class			iTM2ConTeXtParserAttributesInspector
	@superclass		iTM2TeXParserAttributesInspector
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2ConTeXtParserAttributesInspector: iTM2TeXParserAttributesInspector
@end

/*!
	@class			iTM2XtdConTeXtParserAttributesDocument
	@superclass		iTM2XtdTeXParserAttributesDocument
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdConTeXtParserAttributesDocument: iTM2XtdTeXParserAttributesDocument
@end

/*!
	@class			iTM2XtdConTeXtParserAttributesInspector
	@superclass		iTM2XtdTeXParserAttributesInspector
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdConTeXtParserAttributesInspector: iTM2XtdTeXParserAttributesInspector
@end

/*!
	@class			iTM2XtdConTeXtParserSymbolsInspector
	@superclass		iTM2XtdTeXParserSymbolsInspector
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdConTeXtParserSymbolsInspector: iTM2XtdTeXParserSymbolsInspector
@end

extern NSString * const iTM2ToolbarConTeXtLabelItemIdentifier;
extern NSString * const iTM2ToolbarConTeXtSectionItemIdentifier;

@interface NSToolbarItem(iTM2ConTeXt)
+ (NSToolbarItem *)ConTeXtSectionToolbarItem;
+ (NSToolbarItem *)ConTeXtLabelToolbarItem;
+ (NSToolbarItem *)ConTeXtAtGardenToolbarItem;
+ (NSToolbarItem *)ConTeXtAtPragmaADEToolbarItem;
+ (NSToolbarItem *)ConTeXtManualsToolbarItem;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ConTeXtSupport  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

