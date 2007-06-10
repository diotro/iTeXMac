/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Oct 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXStorageKit
/*!
    @header 	The iTeXMac2 TeX Storage Kit
    @abstract   Abstrac forthcoming.
    @discussion Discussion forthcoming. 
*/

#import <iTM2Foundation/iTM2TextStorageKit.h>

extern NSString * const iTM2TextAttributesSymbolsExtension;
extern NSString * const iTM2TextAttributesDraftSymbolsExtension;
extern NSString * const iTM2Text2ndSymbolColorAttributeName;
extern NSString * const iTM2TextAttributesCharacterAttributeName;
extern NSString * const iTM2TeXCommandSyntaxModeName;

enum
{
	kiTM2TeXNoErrorSyntaxStatus = kiTM2TextNoErrorSyntaxStatus,
	kiTM2TeXNoErrorIfNotLastSyntaxStatus = kiTM2TextNoErrorIfNotLastSyntaxStatus,
	kiTM2TeXWaitingSyntaxStatus = kiTM2TextWaitingSyntaxStatus,
	kiTM2TeXErrorSyntaxStatus = kiTM2TextErrorSyntaxStatus
};// all this is unused

enum
{
	kiTM2TeXErrorSyntaxMask = kiTM2TextErrorSyntaxMask,
	kiTM2TeXModifiersSyntaxMask = kiTM2TextModifiersSyntaxMask,
	kiTM2TeXFlagsSyntaxMask = kiTM2TextFlagsSyntaxMask,
	kiTM2TeXEndOfLineSyntaxMask = kiTM2TextEndOfLineSyntaxMask,//bit 16
	kiTM2TeXAtSyntaxMask = kiTM2TextAtSyntaxMask,
	kiTM2TeXSimpleGroupSyntaxMask = kiTM2TeXAtSyntaxMask << 1,
	kiTM2TeXCommandSyntaxMask = kiTM2TeXSimpleGroupSyntaxMask << 1,
	kiTM2TeXMathDisplaySyntaxMask = kiTM2TeXCommandSyntaxMask << 1,
	kiTM2TeXMathInlineSyntaxMask = kiTM2TeXMathDisplaySyntaxMask << 1,
	kiTM2TeXSubscriptSyntaxMask = kiTM2TeXMathInlineSyntaxMask << 1,
	kiTM2TeXSuperscriptSyntaxMask = kiTM2TeXSubscriptSyntaxMask << 1,//bit 23
	kiTM2TeXErrorFontSyntaxMask = 1 << 24,// 24, up to 31
	kiTM2TeXErrorSyntaxSyntaxMask = kiTM2TeXErrorFontSyntaxMask << 1
};

typedef enum _iTM2TeXInputMode 
{
    kiTM2TeXErrorSyntaxMode = kiTM2TextErrorSyntaxMode,
    kiTM2TeXWhitePrefixSyntaxMode = kiTM2TextWhitePrefixSyntaxMode,
    kiTM2TeXRegularSyntaxMode = kiTM2TextRegularSyntaxMode,
//	command related
//	work modes
    kiTM2TeXCommandStartSyntaxMode = 3,// unescaped '\', also used in running mode
    kiTM2TeXCommandEscapedCharacterSyntaxMode,// non letter following kiTM2TeXCommandStartSyntaxMode
    kiTM2TeXCommandContinueSyntaxMode,// letters following
//	named commands
    kiTM2TeXCommandInputSyntaxMode,// this is the only active TeX command supported
//	comment related
    kiTM2TeXCommentStartSyntaxMode,// the first unescaped '%'
    kiTM2TeXCommentContinueSyntaxMode,// everything that follows kiTM2TeXCommentStartSyntaxMode
    kiTM2TeXMarkSyntaxMode,// the '!' after an unescaped '%'
    kiTM2TeXMarkContinueSyntaxMode,// everything that follows kiTM2TeXMarkSyntaxMode
//	Delimiters, work mode, running mode can switch to math
    kiTM2TeXGroupOpenSyntaxMode,// unescaped '{'
    kiTM2TeXGroupCloseSyntaxMode,// unescaped '}'
    kiTM2TeXParenOpenSyntaxMode,// unescaped '('
    kiTM2TeXParenCloseSyntaxMode,// unescaped ')'
    kiTM2TeXBracketOpenSyntaxMode,// unescaped '['
    kiTM2TeXBracketCloseSyntaxMode,// unescaped ']'
//  Maths
//	work mode
    kiTM2TeXMathSwitchSyntaxMode,// first unescaped '$', also running mode
    kiTM2TeXMathSwithContinueSyntaxMode,// second unescaped '$'
//	running modes
	kiTM2TeXMathInlineBeginSyntaxMode,// '(' in "\("
	kiTM2TeXMathInlineEndSyntaxMode,// ')' in "\)"
	kiTM2TeXMathDisplayBeginSyntaxMode,// '[' in "\["
	kiTM2TeXMathDisplayEndSyntaxMode,// ']' in "\]"
//	Sub|Sub scripts
    kiTM2TeXSubStartSyntaxMode,// first unescaped '_'
    kiTM2TeXSubShortSyntaxMode,// "_?" with a non kiTM2TeXGroupOpenSyntaxMode
    kiTM2TeXSubscriptSyntaxMode,// to be defined precisely
    kiTM2TeXSuperStartSyntaxMode,// first unescaped '^'
    kiTM2TeXSuperContinueSyntaxMode,// next '^' after the kiTM2TeXSuperStartSyntaxMode ("^^")
    kiTM2TeXSuperShortSyntaxMode,// "^?" with a non kiTM2TeXGroupOpenSyntaxMode
    kiTM2TeXSuperscriptSyntaxMode,// to be defined precisely
//	Cells
    kiTM2TeXCellSeparatorSyntaxMode,// '&' alone
//	Placeholders
    kiTM2TeXPlaceholderDelimiterMode,// "@@@(" or ")@@@"
//  Everything else
	kiTM2TeXUnknownSyntaxMode = kiTM2TextUnknownSyntaxMode
} iTM2TeXInputMode;// don't change the order unless you know what you are doing

/*!
    @class	iTM2TeXParser
    @abstract	The parser with color.
    @discussion	The iTM2TeXInputMode's from 0 to 999 are reserved for this parser. See other parsers for reserved modes.
*/
@interface iTM2TeXParser: iTM2TextSyntaxParser
@end

@interface iTM2TeXParserAttributesServer: iTM2TextSyntaxParserAttributesServer
@end

@interface iTM2XtdTeXParser: iTM2TeXParser
@end

@interface iTM2XtdTeXParserAttributesServer: iTM2TextSyntaxParserAttributesServer
{
@protected
    id _SymbolsAttributes;
    id _CachedSymbolsAttributes;
}

/*!
    @method	attributesDidChange
    @abstract	Inform the receiver that the attributes did change.
    @discussion	The symbol management is appended to the inherited method.
    @param	None
    @result	None
*/
- (void)attributesDidChange;

/*!
    @method	loadSymbolsAttributesWithVariant:
    @abstract	The receiver loads the symbols attributes with the given variant.
    @discussion	It loads the built in default attributes,
                then it loads the built in attributes if they are different,
                and finally it loads the other customized attributes from the various domains.
    @param	an NSString variant identifier
    @result	None
*/
- (void)loadSymbolsAttributesWithVariant:(NSString *)variant;

/*!
    @method	loadSymbolsAttributesAtPath:
    @abstract	Load the symbols attributes at the given path.
    @discussion	Reads all the files named path/file.symbols
    @param	the path is a style path which path extension is iTM2-Style.
    @result	None.
*/
- (void)loadSymbolsAttributesAtPath:(NSString *)stylePath;

/*!
    @method	loadDraftSymbolsAttributesAtPath:
    @abstract	Load the draft symbols attributes at the given path.
    @discussion	Reads all the files named path/file.draftSymbols
    @param	the path is a style path which path extension is iTM2-Style.
    @result	None.
*/
- (void)loadDraftSymbolsAttributesAtPath:(NSString *)stylePath;

/*!
    @method	symbolsAttributesWithContentsOfFile:
    @abstract	the symbols attributes from the file at the given path.
    @discussion	Description forthcoming
    @param	fileName is the path.
    @result	None.
*/
+ (NSDictionary *)symbolsAttributesWithContentsOfFile:(NSString *)fileName;

/*!
    @method	writeSymbolsAttributes:toFile:
    @abstract	Write the given symbols attributes at the given path.
    @discussion	Description forthcoming
    @param	dictionary is the set of attributes.
    @param	fileName is the path.
    @result	None.
*/
+ (BOOL)writeSymbolsAttributes:(NSDictionary *)dictionary toFile:(NSString *)fileName;

/*!
    @method	attributesForSymbol:
    @abstract	Abstarct forthcoming.
    @discussion	Description forthcoming
    @param	symbol.
    @result	Attributes.
*/
- (NSDictionary *)attributesForSymbol:(NSString *)symbol;

@end

/*!
	@category		NSCharacterSet(iTM2TeXStorageKit)
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface NSCharacterSet(iTM2TeXStorageKit)

/*!
	@method			TeXLetterCharacterSet
	@abstract		The TeX letters character set.
	@discussion		a-z, A-Z and @.
	@result			A character set
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSCharacterSet *)TeXLetterCharacterSet;

/*!
	@method			TeXFileNameLetterCharacterSet
	@abstract		TeX file name letters character set.
	@discussion		TeX letter character set plus _$^0123456789.-+*()[]/.
	@result			A character set
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSCharacterSet *)TeXFileNameLetterCharacterSet;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextSyntaxAttributesKit
