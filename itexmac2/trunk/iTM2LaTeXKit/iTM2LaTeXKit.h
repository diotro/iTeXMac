/*
//  iTM2LaTeXKit.h
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

extern NSString * const iTM2LaTeXInspectorMode;
extern NSString * const iTM2LaTeXToolbarIdentifier;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2LaTeXInspector

@interface iTM2LaTeXInspector: iTM2TeXInspector
@end

@interface iTM2LaTeXEditor: iTM2TeXEditor
@end

@interface iTM2LaTeXWindow: iTM2TeXWindow
@end

@interface iTM2LaTeXResponder: iTM2AutoInstallResponder
@end

@interface iTM2LaTeXSectionButton: NSPopUpButton
@end

@interface iTM2LaTeXLabelButton: NSPopUpButton
@end

@interface NSString(iTM2LaTeXKit)
/*!
    @method     lossyLaTeXEnvironmentNameAtIndex:
    @abstract   (brief description)
    @discussion (comprehensive description)
    @param		the character at index lies inside the latex environment to be found
    @result     (description)
*/
- (NSString *)lossyLaTeXEnvironmentNameAtIndex:(unsigned)index;

- (NSString *)LaTeXEnvironmentNameForRange:(NSRange)range effectiveRange:(NSRangePointer)rangePtr;

@end

@interface NSTextView(iTeXMac2)
- (void)completeLaTeXEnvironment:(id)sender;
- (void)findLaTeXEnvironment:(id)sender;
@end

@interface iTM2LaTeXScriptDocumentButton: iTM2GenericScriptButton
@end

@interface iTM2LaTeXScriptTextButton: iTM2GenericScriptButton
@end

@interface iTM2LaTeXScriptMathButton: iTM2GenericScriptButton
@end

@interface iTM2LaTeXScriptMiscellaneousButton: iTM2GenericScriptButton
@end

@interface iTM2LaTeXScriptGraphicsButton: iTM2GenericScriptButton
@end

@interface iTM2LaTeXScriptUserButton: iTM2GenericScriptButton
@end

@interface iTM2LaTeXScriptRecentButton: iTM2GenericScriptButton
@end

@interface iTM2LaTeXParserAttributesServer: iTM2TeXParserAttributesServer
@end

@interface iTM2XtdLaTeXParserAttributesServer: iTM2XtdTeXParserAttributesServer
@end

typedef enum _iTM2LaTeXInputMode 
{
    kiTM2LaTeXFirstSyntaxMode = 1000,
    kiTM2LaTeXIncludeSyntaxMode = kiTM2LaTeXFirstSyntaxMode,
    kiTM2LaTeXIncludegraphicsSyntaxMode,
    kiTM2LaTeXIncludegraphixSyntaxMode,
    kiTM2LaTeXURLSyntaxMode,
    kiTM2LaTeXPartSyntaxMode,// keep that order
    kiTM2LaTeXChapterSyntaxMode,
    kiTM2LaTeXSectionSyntaxMode,
    kiTM2LaTeXSubsectionSyntaxMode,
    kiTM2LaTeXSubsubsectionSyntaxMode,
    kiTM2LaTeXParagraphSyntaxMode,
    kiTM2LaTeXSubparagraphSyntaxMode,
    kiTM2LaTeXSubsubparagraphSyntaxMode,
    kiTM2LaTeXSubsubsubparagraphSyntaxMode,
	kiTM2LaTeXUnknownSyntaxMode = kiTM2TeXUnknownSyntaxMode
} iTM2LaTeXInputMode;

@interface iTM2LaTeXParser: iTM2TeXParser
@end

@interface NSTextStorage(iTM2LaTeX)
- (NSMenu *)LaTeXSectionMenu;
- (void)getLaTeXLabelMenu:(NSMenu **)labelMenuRef refMenu:(NSMenu **)refMenuRef;
@end

@interface iTM2XtdLaTeXParser: iTM2XtdTeXParser
@end

/*!
	@class			iTM2LaTeXParserAttributesDocument
	@superclass		iTM2TeXParserAttributesDocument
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2LaTeXParserAttributesDocument: iTM2TeXParserAttributesDocument
@end

/*!
	@class			iTM2LaTeXParserAttributesInspector
	@superclass		iTM2TeXParserAttributesInspector
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2LaTeXParserAttributesInspector: iTM2TeXParserAttributesInspector
@end

/*!
	@class			iTM2XtdLaTeXParserAttributesDocument
	@superclass		iTM2XtdTeXParserAttributesDocument
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdLaTeXParserAttributesDocument: iTM2XtdTeXParserAttributesDocument
@end

/*!
	@class			iTM2XtdLaTeXParserAttributesInspector
	@superclass		iTM2XtdTeXParserAttributesInspector
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdLaTeXParserAttributesInspector: iTM2XtdTeXParserAttributesInspector
@end

/*!
	@class			iTM2XtdLaTeXParserSymbolsInspector
	@superclass		iTM2XtdTeXParserSymbolsInspector
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdLaTeXParserSymbolsInspector: iTM2XtdTeXParserSymbolsInspector
@end

extern NSString * const iTM2ToolbarLaTeXLabelItemIdentifier;
extern NSString * const iTM2ToolbarLaTeXSectionItemIdentifier;

@interface NSToolbarItem(iTM2LaTeX)
+ (NSToolbarItem *)LaTeXSectionToolbarItem;
+ (NSToolbarItem *)LaTeXLabelToolbarItem;
@end

@interface NSTextView(iTM2LaTeX)
- (IBAction)useLaTeXPackage:(id)sender;
@end

@interface iTM2LaTeXLogParser: iTM2TeXLogParser
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2LaTeXKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

