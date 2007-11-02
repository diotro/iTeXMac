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
//  Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import <iTM2TeXFoundation/iTM2TeXStorageKit.h>
#import <iTM2TeXFoundation/iTM2TeXStringKit.h>

NSString * const iTM2TextAttributesSymbolsExtension = @"rtf";
NSString * const iTM2TextAttributesDraftSymbolsExtension = @"DraftSymbols";
NSString * const iTM2Text2ndSymbolColorAttributeName = @"iTM2Text2ndSymbolColorAttribute";
NSString * const iTM2TextAttributesCharacterAttributeName = @"iTM2Character";

@implementation iTM2MainInstaller(TeXStorageKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXStorageCompleteInstallation
+ (void)iTM2TeXStorageCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2TeXParser class];
	[iTM2XtdTeXParser class];
//iTM2_END;
    return;
}
@end

static NSArray * _iTM2TeXModeForModeArray = nil;

#define _TextStorage (iTM2TextStorage *)_TS

NSString * const iTM2TeXCommandSyntaxModeName = @"\\.*";
NSString * const iTM2TeXGroupSyntaxModeName = @"{}";
NSString * const iTM2TeXParenSyntaxModeName = @"()";
NSString * const iTM2TeXBracketSyntaxModeName = @"[]";
NSString * const iTM2TeXCommentSyntaxModeName = @"%";
NSString * const iTM2TeXMarkSyntaxModeName = @"%!";
NSString * const iTM2TeXMathToggleSyntaxModeName = @"$";
NSString * const iTM2TeXMathDisplayToggleSyntaxModeName = @"$$";
NSString * const iTM2TeXMathInlineSwitchSyntaxModeName = @"\\(\\)";
NSString * const iTM2TeXMathDisplaySwitchSyntaxModeName = @"\\[\\]";
NSString * const iTM2TeXSubSyntaxModeName = @"_";
NSString * const iTM2TeXSubContinueSyntaxModeName = @"__.";
NSString * const iTM2TeXSubShortSyntaxModeName = @"_.";
NSString * const iTM2TeXSubLongSyntaxModeName = @"_{}";
NSString * const iTM2TeXSuperSyntaxModeName = @"^";
NSString * const iTM2TeXSuperContinueSyntaxModeName = @"^^.";
NSString * const iTM2TeXSuperShortSyntaxModeName = @"^.";
NSString * const iTM2TeXSuperLongSyntaxModeName = @"^{}";
NSString * const iTM2TeXAmpersandSyntaxModeName = @"&";
NSString * const iTM2TeXPlaceholderDelimiterSyntaxModeName = @"@@@()@@@";

NSString * const iTM2TeXCommandInputSyntaxModeName = @"\\input";

#undef iTM2_ATTRIBUTE_ASSERT
#define iTM2_ATTRIBUTE_ASSERT(CONDITION,REASON) if(iTM2DebugEnabled>99&&!(CONDITION)) {ERROR=REASON;goto returnERROR;}

@implementation iTM2TeXParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
//iTM2_LOG(@"iTM2TeXParser");
    if(!_iTM2TeXModeForModeArray)
	{
        _iTM2TeXModeForModeArray = [[NSArray arrayWithObjects:
			iTM2TextErrorSyntaxModeName, iTM2TextWhitePrefixSyntaxModeName, iTM2TextDefaultSyntaxModeName,// +3
			iTM2TeXCommandSyntaxModeName,iTM2TeXCommandSyntaxModeName,iTM2TeXCommandSyntaxModeName,iTM2TeXCommandSyntaxModeName, // +4
			iTM2TeXCommentSyntaxModeName,iTM2TeXCommentSyntaxModeName,iTM2TeXMarkSyntaxModeName,iTM2TeXMarkSyntaxModeName,// +4
			iTM2TeXGroupSyntaxModeName, iTM2TeXGroupSyntaxModeName, iTM2TeXParenSyntaxModeName, iTM2TeXParenSyntaxModeName, iTM2TeXBracketSyntaxModeName, iTM2TeXBracketSyntaxModeName, // +6
			iTM2TeXMathToggleSyntaxModeName,iTM2TeXMathDisplayToggleSyntaxModeName,iTM2TeXMathInlineSwitchSyntaxModeName,iTM2TeXMathInlineSwitchSyntaxModeName,iTM2TeXMathDisplaySwitchSyntaxModeName,iTM2TeXMathDisplaySwitchSyntaxModeName,// +6
			iTM2TeXSubSyntaxModeName, iTM2TeXSubShortSyntaxModeName, iTM2TeXSubLongSyntaxModeName,// +3
			iTM2TeXSuperSyntaxModeName, iTM2TeXSuperContinueSyntaxModeName, iTM2TeXSuperShortSyntaxModeName, iTM2TeXSuperLongSyntaxModeName,// +4
			iTM2TeXAmpersandSyntaxModeName,// +1
			iTM2TeXPlaceholderDelimiterSyntaxModeName,// +1
				nil] retain];
	}
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"TeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModesAttributes
+ (NSDictionary *)defaultModesAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * MRA = [NSMutableArray array];
	NSDictionary * attributes;
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor blackColor], NSForegroundColorAttributeName,
        iTM2TextDefaultSyntaxModeName, iTM2TextModeAttributeName,nil];
	[MRA addObject:attributes];
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor redColor], NSForegroundColorAttributeName,
        iTM2TextErrorSyntaxModeName, iTM2TextModeAttributeName,nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0 green:0 blue:0.75 alpha:1], NSForegroundColorAttributeName,
		iTM2TeXCommandSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];

    NSMutableDictionary * input = [[attributes mutableCopy] autorelease];
	[input setObject:iTM2TeXCommandInputSyntaxModeName forKey:iTM2TextModeAttributeName];
	[input setObject:@"" forKey:NSLinkAttributeName];
	[MRA addObject:input];

    attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        iTM2TeXGroupSyntaxModeName, iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXParenSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXBracketSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0 green:0.75 blue:0 alpha:1], NSForegroundColorAttributeName,
		iTM2TeXCommentSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0.5 green:0.25 blue:0 alpha:1], NSForegroundColorAttributeName,
		iTM2TeXMarkSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor orangeColor], NSForegroundColorAttributeName,
		iTM2TeXMathToggleSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor orangeColor], NSForegroundColorAttributeName,
		iTM2TeXMathDisplayToggleSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor orangeColor], NSForegroundColorAttributeName,
		iTM2TeXMathInlineSwitchSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor orangeColor], NSForegroundColorAttributeName,
		iTM2TeXMathDisplaySwitchSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSubSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSubContinueSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSubShortSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSubLongSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSuperSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSuperContinueSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSuperShortSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
		iTM2TeXSuperLongSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor brownColor], NSForegroundColorAttributeName,
        iTM2TeXAmpersandSyntaxModeName, iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0.95 green:0.15 blue:0.15 alpha:0.5], NSForegroundColorAttributeName,
		iTM2TeXPlaceholderDelimiterSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];

	NSEnumerator * E = [MRA objectEnumerator];
    NSMutableDictionary * MD = [[[super defaultModesAttributes] mutableCopy] autorelease];
	while(attributes = [E nextObject])
	{
		NSString * key = [attributes objectForKey:iTM2TextModeAttributeName];
		[MD setObject:attributes forKey:key];
	}
    return [NSDictionary dictionaryWithDictionary:MD];
}
#undef iTM2_WITH_SYMBOLS
#include "iTM2TeXStorageAttributes.m"
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink:atIndex:
- (BOOL)didClickOnLink:(id)link atIndex:(unsigned)charIndex;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTextStorage * TS = [self textStorage];
	NSRange R = [iTM2TeXStringController TeXAwareWordRangeInAttributedString:TS atIndex:charIndex];
	if(R.length>1)
	{
		NSString * S = [TS string];
		NSString * command = [S substringWithRange:R];
		if([command isEqualToString:iTM2TeXCommandInputSyntaxModeName])
		{
			unsigned start = NSMaxRange(R);
			if(start < [S length])
			{
				unsigned contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
				NSScanner * scanner = [NSScanner scannerWithString:string];
				[scanner scanString:@"{" intoString:nil];
				NSString * fileName;
				if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &fileName])
				{
					if(![fileName hasPrefix:@"/"])
					{
						fileName = [[[[[[[[[TS layoutManagers] lastObject] textContainers] lastObject] textView] window] windowController] document] fileName];
						fileName = [fileName stringByDeletingLastPathComponent];
						fileName = [fileName stringByAppendingPathComponent:fileName];
					}
					NSURL * URL = [NSURL fileURLWithPath:fileName];
					if(![SDC openDocumentWithContentsOfURL:URL display:YES error:nil])
					{
						NSString * newFileName = [fileName stringByAppendingPathExtension:@"tex"];
						URL = [NSURL fileURLWithPath:newFileName];
						if(![SDC openDocumentWithContentsOfURL:URL display:YES error:nil]
							&& ![SWS openFile:fileName]
								&& ![SWS openFile:newFileName])
						{
							iTM2_LOG(@"INFO: could not open file <%@>", newFileName);
						}				
					}
				}
				else
				{
					iTM2_LOG(@"..........  TeX SYNTAX ERROR: nothing to input");
				}
			}
			return YES;
		}
	}
//iTM2_END;
	return [super didClickOnLink:link atIndex:charIndex];
}
@end

@implementation iTM2XtdTeXParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"TeX-Xtd";
}
#define iTM2_WITH_SYMBOLS
#include "iTM2TeXStorageAttributes.m"
@end

@implementation NSCharacterSet(iTM2TeXStorageKit)
static id _iTM2TeXPTeXLetterCharacterSet = nil;
static id _iTM2TeXPTeXFileNameLetterCharacterSet = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    if(!_iTM2TeXPTeXLetterCharacterSet)
    {
        id set = [[[NSCharacterSet characterSetWithRange:NSMakeRange('a', 26)] mutableCopy] autorelease];
        [set addCharactersInRange:NSMakeRange('A', 26)];
//        [set addCharactersInString:@"@"];
        _iTM2TeXPTeXLetterCharacterSet = [set copy];
    }
    if(!_iTM2TeXPTeXFileNameLetterCharacterSet)
    {
        _iTM2TeXPTeXFileNameLetterCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@".,;\\+-*[]=_/:"];
		[_iTM2TeXPTeXFileNameLetterCharacterSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
		_iTM2TeXPTeXFileNameLetterCharacterSet = [_iTM2TeXPTeXFileNameLetterCharacterSet copy];
    }
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  TeXLetterCharacterSet;
+ (NSCharacterSet *)TeXLetterCharacterSet;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2TeXPTeXLetterCharacterSet;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  TeXFileNameLetterCharacterSet;
+ (NSCharacterSet *)TeXFileNameLetterCharacterSet;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2TeXPTeXFileNameLetterCharacterSet;
}
@end

@implementation iTM2TeXParserAttributesServer
@end

@implementation iTM2XtdTeXParserAttributesServer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithVariant:
- (id)initWithVariant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    variant = [variant lowercaseString];
    if(self = [super initWithVariant:variant])
    {
        [_SymbolsAttributes autorelease];
        _SymbolsAttributes = [[NSMutableDictionary dictionary] retain];
        [_CachedSymbolsAttributes autorelease];
        _CachedSymbolsAttributes = [[NSMutableDictionary dictionary] retain];
        [self loadSymbolsAttributesWithVariant:variant];
    }
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_SymbolsAttributes autorelease];
    _SymbolsAttributes = nil;
    [_CachedSymbolsAttributes autorelease];
    _CachedSymbolsAttributes = nil;
    [super dealloc];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAttributes:forMode:
- (void)setAttributes:(NSDictionary *)dictionary forMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setAttributes: (NSDictionary *) dictionary forMode: (NSString *) mode];
    if([mode isEqualToString:iTM2TeXCommandSyntaxModeName])
    {
        [_CachedSymbolsAttributes release];
        _CachedSymbolsAttributes = [[NSMutableDictionary dictionary] retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesDidChange
- (void)attributesDidChange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super attributesDidChange];
    // built in attributes are not expected to change!!!
    // just load ther other attributes
    [_SymbolsAttributes autorelease];
    _SymbolsAttributes = [[NSMutableDictionary dictionary] retain];
    [_CachedSymbolsAttributes autorelease];
    _CachedSymbolsAttributes = [[NSMutableDictionary dictionary] retain];
    [self loadSymbolsAttributesWithVariant:[self syntaxParserVariant]];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  SYMBOLS ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesForSymbol:
- (NSDictionary *)attributesForSymbol:(NSString *)symbol;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!symbol)
		return nil;
    NSDictionary * symbolAttributes = [_CachedSymbolsAttributes objectForKey:symbol];
    if(symbolAttributes)
        return symbolAttributes;
    symbolAttributes = [_SymbolsAttributes objectForKey:symbol];
    if(symbolAttributes)
    {
        NSDictionary * commandAttributes = [self attributesForMode:iTM2TeXCommandSyntaxModeName];
        NSColor * commandColor = [commandAttributes objectForKey:NSForegroundColorAttributeName];
        if(commandColor)
        {
            NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:commandAttributes];// If the command attributes are good...
            [MD addEntriesFromDictionary:symbolAttributes];
            NSColor * symbolColor = [symbolAttributes objectForKey:iTM2Text2ndSymbolColorAttributeName];
            if(iTM2DebugEnabled > 999999 && !symbolColor)
            {
                iTM2_LOG(@"no 2nd color for symbol: %@", symbol);
            }
            NSColor * replacementColor = symbolColor && [symbolColor alphaComponent]>0?
                [[symbolColor colorWithAlphaComponent:1] blendedColorWithFraction:1-[symbolColor alphaComponent]
                                    ofColor: commandColor]:
                    commandColor;
            [MD setObject:replacementColor forKey:NSForegroundColorAttributeName];
            [_CachedSymbolsAttributes setObject:[NSDictionary dictionaryWithDictionary:MD] forKey:symbol];
            return [_CachedSymbolsAttributes objectForKey:symbol];
        }
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadSymbolsAttributesWithVariant:
- (void)loadSymbolsAttributesWithVariant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"variant is: %@", variant);
	NSString * variantComponent = [iTM2TextDefaultVariant stringByAppendingPathExtension:iTM2TextVariantExtension];
	NSString * stylePath;
	NSEnumerator * E = [[[self class] builtInStylePaths] objectEnumerator];
	while(stylePath = [E nextObject])
	{
		stylePath = [[stylePath stringByAppendingPathComponent:variantComponent] stringByResolvingSymlinksAndFinderAliasesInPath];
		BOOL isDir = NO;
		if([DFM fileExistsAtPath:stylePath isDirectory: &isDir] && isDir)
		{
			[self loadSymbolsAttributesAtPath:stylePath];
		}
	}
    variant = [variant lowercaseString];
	variantComponent = [variant stringByAppendingPathExtension:iTM2TextVariantExtension];
    if(![iTM2TextDefaultVariant isEqualToString:variant])
	{
		E = [[[self class] builtInStylePaths] objectEnumerator];
		while(stylePath = [E nextObject])
		{
			stylePath = [[stylePath stringByAppendingPathComponent:variantComponent] stringByResolvingSymlinksAndFinderAliasesInPath];
			BOOL isDir = NO;
			if([DFM fileExistsAtPath:stylePath isDirectory: &isDir] && isDir)
				[self loadSymbolsAttributesAtPath:stylePath];
		}
	}
	E = [[[self class] otherStylePaths] objectEnumerator];
	while(stylePath = [E nextObject])
	{
		stylePath = [[stylePath stringByAppendingPathComponent:variantComponent] stringByResolvingSymlinksAndFinderAliasesInPath];
		BOOL isDir = NO;
		if([DFM fileExistsAtPath:stylePath isDirectory: &isDir] && isDir)
			[self loadSymbolsAttributesAtPath:stylePath];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadSymbolsAttributesAtPath:
- (void)loadSymbolsAttributesAtPath:(NSString *)stylePath;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"stylePath: %@", stylePath);
    NSEnumerator * e = [[DFM directoryContentsAtPath:stylePath] objectEnumerator];
    NSString * p;
    while(p = [e nextObject])
        if([[p pathExtension] isEqual:iTM2TextAttributesSymbolsExtension]
			&& ![p isEqual:iTM2TextAttributesModesComponent])
        {
            [_CachedSymbolsAttributes autorelease];
            _CachedSymbolsAttributes = [[NSMutableDictionary dictionary] retain];
            NSString * symbolAttributesPath = [stylePath stringByAppendingPathComponent:p];
            NSDictionary * symbolAttributes = [[self class] symbolsAttributesWithContentsOfFile:symbolAttributesPath];
            if(iTM2DebugEnabled > 1000)
            {
                iTM2_LOG(@"We have loaded symbols attributes at path: %@", symbolAttributesPath);
                NSMutableSet * set1 = [NSMutableSet setWithArray:[_SymbolsAttributes allKeys]];
                NSSet * set2 = [NSSet setWithArray:[symbolAttributes allKeys]];
                [set1 intersectSet:set2];
                 iTM2_LOG(@"The overriden keys are: %@", set1);
            }
            [_SymbolsAttributes addEntriesFromDictionary:symbolAttributes];
        }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadDraftSymbolsAttributesAtPath:
- (void)loadDraftSymbolsAttributesAtPath:(NSString *)stylePath;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"stylePath: %@", stylePath);
    NSEnumerator * e = [[DFM directoryContentsAtPath:stylePath] objectEnumerator];
    NSString * p;
    while(p = [e nextObject])
        if([[p pathExtension] isEqualToString:iTM2TextAttributesDraftSymbolsExtension])
        {
            [_SymbolsAttributes addEntriesFromDictionary:
                [[self class] symbolsAttributesWithContentsOfFile:[stylePath stringByAppendingPathComponent:p]]];
        }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  symbolsAttributesWithContentsOfFile:
+ (NSDictionary *)symbolsAttributesWithContentsOfFile:(NSString *)fileName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"fileName is: %@", fileName);
    NSData * D = [NSData dataWithContentsOfFile:fileName];
    if([D length])
    {
		NSError * error = nil;
		NSTextStorage * TS = [[[NSTextStorage alloc] initWithData:D options:nil documentAttributes:nil error:&error] autorelease];
		if(error)
		{
			NSLog(@"%@",error);
		}
		NSLayoutManager * LM = [[[NSLayoutManager alloc] init] autorelease];
		[TS addLayoutManager:LM]; 
		NSMutableDictionary * result = [NSMutableDictionary dictionary];
		NSString * S = [TS string];
		unsigned start = 0, contentsEnd;
		NSRange R = NSMakeRange(0,0);
		while(start<[S length])
		{
			[S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
			if((contentsEnd-start>2) && ([S characterAtIndex:start+1]=='='))
			{
				NSMutableDictionary * attributes = [[[TS attributesAtIndex:start effectiveRange:nil] mutableCopy] autorelease];
				NSFont * font = [attributes objectForKey:NSFontAttributeName];
				if(font)
				{
					NSString * command = [S substringWithRange:NSMakeRange(start+2, contentsEnd-start-2)];
					NSString * character = [S substringWithRange:NSMakeRange(start,1)];
					[attributes setObject:character forKey:iTM2TextAttributesCharacterAttributeName];
					NSRange charRange = NSMakeRange(start,1);
					NSRange glyphRange = [LM glyphRangeForCharacterRange:charRange actualCharacterRange:nil];
					NSGlyph glyph = [LM glyphAtIndex:glyphRange.location];
					NSGlyphInfo * GI = [NSGlyphInfo glyphInfoWithGlyph:glyph forFont:font baseString:command];
					[attributes setObject:GI forKey:NSGlyphInfoAttributeName];
					[result setObject:attributes forKey:command];
				}
			}
			start = R.location;
		}
		return result;
    }
    return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSymbolsAttributes:toFile:
+ (BOOL)writeSymbolsAttributes:(NSDictionary *)dictionary toFile:(NSString *)fileName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [dictionary keyEnumerator];
	NSString * command;
	NSMutableAttributedString * MAS =
		[[[NSMutableAttributedString alloc] initWithString:@"% iTeXMac2 style symbols file\n% each line is 'c=\\command'\n"] autorelease];
	while(command = [E nextObject])
	{
		NSMutableDictionary * attributes = [[[dictionary objectForKey:command] mutableCopy] autorelease];
		NSString * S = [attributes objectForKey:iTM2TextAttributesCharacterAttributeName];
		NSAttributedString * AS = [[[NSAttributedString alloc] initWithString:S attributes:attributes] autorelease];
		[MAS appendAttributedString:AS];
		S = [NSString stringWithFormat:@"=%@\n",command];
		AS = [[[NSAttributedString alloc] initWithString:S] autorelease];
		[MAS appendAttributedString:AS];
	}
	NSData * data = [MAS dataFromRange:NSMakeRange(0,[MAS length]) documentAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
		NSRTFTextDocumentType, NSDocumentTypeDocumentAttribute, nil] error:nil];
//iTM2_END;
	return [data writeToFile:fileName options:NSAtomicWrite error:nil];
}
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXStorageKit
