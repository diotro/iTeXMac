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

NSString * const iTM2TextAttributesSymbolsExtension = @"iTM2-Symbols";
NSString * const iTM2TextAttributesDraftSymbolsExtension = @"DraftSymbols";
NSString * const iTM2Text2ndSymbolColorAttributeName = @"iTM2Text2ndSymbolColorAttribute";

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
    if([mode isEqualToString:@"command"])
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
        NSDictionary * commandAttributes = [self attributesForMode:@"command"];
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
        if([[p pathExtension] isEqualToString:iTM2TextAttributesSymbolsExtension])
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
        NSKeyedUnarchiver * KU = [[[NSKeyedUnarchiver alloc] initForReadingWithData:D] autorelease];
        return [KU decodeObjectForKey:@"iTM2:root"];
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
    NSMutableData * MD = [NSMutableData data];
    NSKeyedArchiver * KA = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:MD] autorelease];
    [KA setOutputFormat:NSPropertyListXMLFormat_v1_0];
    [KA encodeObject:dictionary forKey:@"iTM2:root"];
    [KA finishEncoding];
	BOOL result = [MD writeToFile:fileName atomically:YES];

	NSMutableDictionary * md = [NSMutableDictionary dictionary];
	NSEnumerator * E = [dictionary objectEnumerator];
	NSString * K;
	while(K = [E nextObject])
	{
		NSMutableData * MD = [NSMutableData data];
		NSKeyedArchiver * KA = [[[NSKeyedArchiver alloc] initForWritingWithMutableData:MD] autorelease];
		[KA setOutputFormat:NSPropertyListXMLFormat_v1_0];
		[KA encodeObject:dictionary forKey:@"iTM2:root"];
		[KA finishEncoding];
		[MRA addObject:MD];
	}
	if([MRA count])
	{
		NSString * newFileName = [fileName stringByAppendingString:@"-new"];
		if(![MRA writeToFile:newFileName atomically:YES])
		{
			iTM2_LOG(@"FAILED");
		}
	}
//iTM2_END;
    return result;
}
@end

static NSArray * _iTM2TeXModeForModeArray = nil;

#define _TextStorage (iTM2TextStorage *)_TS

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
//iTM2_START;
//iTM2_LOG(@"iTM2TeXParser");
    if(!_iTM2TeXModeForModeArray)
	{
        _iTM2TeXModeForModeArray = [[NSArray arrayWithObjects:
			iTM2TextErrorKey, iTM2TextWhitePrefixKey, iTM2TextDefaultKey,
			@"command", @"command", @"command", @"command",
			@"comment", @"comment",
			@"mark",
			@"math", @"math",
			@"group", @"group",
			@"delimiter", @"delimiter", @"delimiter",
			@"subscript", @"subscript", @"subscript", @"subscript",
			@"superscript", @"superscript", @"superscript",
			@"cellSeparator", @"input", nil] retain];
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
    NSDictionary * regular = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor blackColor], NSForegroundColorAttributeName,
        iTM2TextDefaultKey, iTM2TextModeAttributeName,
            nil];
    NSDictionary * error = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor redColor], NSForegroundColorAttributeName,
        iTM2TextErrorKey, iTM2TextModeAttributeName,
            nil];
    NSDictionary * command = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0 green:0 blue:0.75 alpha:1], NSForegroundColorAttributeName,
        @"command", iTM2TextModeAttributeName,
            nil];
    NSDictionary * comment = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0 green:0.75 blue:0 alpha:1], NSForegroundColorAttributeName,
        @"comment", iTM2TextModeAttributeName,
            nil];
    NSDictionary * mark = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0.5 green:0.25 blue:0 alpha:1], NSForegroundColorAttributeName,
        @"mark", iTM2TextModeAttributeName,
            nil];
    NSDictionary * math = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor orangeColor], NSForegroundColorAttributeName,
        @"math", iTM2TextModeAttributeName,
            nil];
    NSDictionary * group = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"group", iTM2TextModeAttributeName,
            nil];
    NSDictionary * delimiter = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"delimiter", iTM2TextModeAttributeName,
            nil];
    NSDictionary * sub = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"subscript", iTM2TextModeAttributeName,
            nil];
    NSDictionary * sup = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"superscript", iTM2TextModeAttributeName,
            nil];
    NSDictionary * cellSep = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor brownColor], NSForegroundColorAttributeName,
        @"cellSeparator", iTM2TextModeAttributeName,
            nil];
    NSMutableDictionary * input = [[command mutableCopy] autorelease];
	[input setObject:@"input" forKey:iTM2TextModeAttributeName];
	[input setObject:@"" forKey:NSLinkAttributeName];
    NSMutableDictionary * MD = [[[super defaultModesAttributes] mutableCopy] autorelease];
    [MD setObject:error forKey:[error objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:regular forKey:[regular objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:command forKey:[command objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:comment forKey:[comment objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:mark forKey:[mark objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:math forKey:[math objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:group forKey:[group objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:delimiter forKey:[delimiter objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:sub forKey:[sub objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:sup forKey:[sup objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:cellSep forKey:[cellSep objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:[[input copy] autorelease] forKey:[input objectForKey:iTM2TextModeAttributeName]];
    return [NSDictionary dictionaryWithDictionary:MD];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forCharacter:previousMode:
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forCharacter:(unichar)theChar previousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
	NSParameterAssert(newModeRef);
//iTM2_START;
//    if(previousMode != ( previousMode & ~kiTM2TeXErrorSyntaxMask))
//        NSLog(@"previousMode: 0X%x, mask: 0X%x, previousMode & ~mask: 0X%x",  previousMode, kiTM2TeXErrorSyntaxModeMask,  previousMode & ~kiTM2TeXErrorSyntaxMask);
//iTM2_LOG(@"C'est %.1S qui s'y colle", &theChar);
	unsigned previousError = previousMode & kiTM2TeXErrorSyntaxMask;
	if(previousMode & kiTM2TextEndOfLineSyntaxMask)
	{
		// this is the first character of the line
		if(theChar == ' ')
		{
			* newModeRef = kiTM2TeXWhitePrefixSyntaxMode | previousError;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
	}
	unsigned switcher = previousMode & ~kiTM2TextModifiersSyntaxMask;
	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
	unsigned status = kiTM2TeXNoErrorSyntaxStatus;
    if([set characterIsMember:theChar])
    {
		unsigned result;
        switch(switcher)
        {
            case kiTM2TeXRegularSyntaxMode:
            case kiTM2TeXCommandSyntaxMode:
            case kiTM2TeXInputCommandSyntaxMode:
                result = previousMode;
			break;
            case kiTM2TeXBeginCommandSyntaxMode:
                result = kiTM2TeXCommandSyntaxMode;
			break;
			case kiTM2TeXWhitePrefixSyntaxMode:
                result = kiTM2TeXRegularSyntaxMode;
			break;
            case kiTM2TeXCommentSyntaxMode:
                result = previousMode;
			break;
            case kiTM2TeXBeginCommentSyntaxMode:
                result = kiTM2TeXCommentSyntaxMode;
			break;
            case kiTM2TeXMarkSyntaxMode:
                result = previousMode;
			break;
            case kiTM2TeXBeginSubscriptSyntaxMode:
                result = kiTM2TeXShortSubscriptSyntaxMode;
			break;
            case kiTM2TeXBeginSuperscriptSyntaxMode:
                result = kiTM2TeXShortSuperscriptSyntaxMode;
			break;
            default:
                result = kiTM2TeXRegularSyntaxMode;
        }
		if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:[_iTM2TeXModeForModeArray objectAtIndex:result & ~kiTM2TeXErrorSyntaxMask]])
		{
			* newModeRef = result | previousError;
			return status;
		}
		else
		{
//iTM2_LOG(@"AN ERROR OCCURRED");
			* newModeRef = result | kiTM2TeXErrorFontSyntaxMask | previousError;
			return status;
		}
    }
    else
    {
        switch(theChar)
        {
            case ' ':
                switch(switcher)
                {
                    case kiTM2TeXErrorSyntaxMode:
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    case kiTM2TeXRegularSyntaxMode:
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                    case kiTM2TeXUnknownSyntaxMode:
						* newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
						* newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                     case kiTM2TeXBeginCommentSyntaxMode:
						* newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
                    default:
 						* newModeRef = kiTM2TeXRegularSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }
    
            case '\\':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                    case kiTM2TeXShortCommandSyntaxMode:
                    case kiTM2TeXCommandSyntaxMode:
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    case kiTM2TeXDollarSyntaxMode:
                    case kiTM2TeXDelimiterSyntaxMode:
                    case kiTM2TeXParenOpenSyntaxMode:
                    case kiTM2TeXParenCloseSyntaxMode:
                    case kiTM2TeXInputCommandSyntaxMode:
                    case kiTM2TeXErrorSyntaxMode:
                        * newModeRef = kiTM2TeXBeginCommandSyntaxMode | previousError;
						return kiTM2TeXWaitingSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXBeginCommandSyntaxMode | previousError;
						return kiTM2TeXWaitingSyntaxStatus;
                }
    
            case '{':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                    case kiTM2TeXInputCommandSyntaxMode:
                    case kiTM2TeXWhitePrefixSyntaxMode:
                        * newModeRef = kiTM2TeXBeginGroupSyntaxMode | previousError;
						return kiTM2TeXWaitingSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXBeginGroupSyntaxMode | previousError;
						return kiTM2TeXWaitingSyntaxStatus ;
                }

            case '}':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = kiTM2TeXEndGroupSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXEndGroupSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }
            case '(':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = kiTM2TeXParenOpenSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSuperscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSubscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXParenOpenSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
				}
            case ')':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = kiTM2TeXParenCloseSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSuperscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSubscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXParenCloseSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
				}
            case '[':
            case ']':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = kiTM2TeXDelimiterSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSuperscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSubscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXDelimiterSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
				}
            case '$':
                switch(switcher)
                  {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = kiTM2TeXDollarSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXDollarSyntaxMode:
                        * newModeRef = kiTM2TeXMoreDollarSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXDollarSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }
    
            case '%':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = kiTM2TeXBeginCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXBeginCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }
            
            case '&':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = kiTM2TeXCellSeparatorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXCellSeparatorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }
            
            case '!':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXMarkSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSuperscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        * newModeRef = kiTM2TeXShortSubscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        * newModeRef = kiTM2TeXRegularSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }
            case '^':
                switch(switcher)
                {
                    case kiTM2TeXBeginCommandSyntaxMode:
                        * newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        * newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        * newModeRef = previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXMoreSubscriptSyntaxMode:
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        * newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
 						* newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
 						* newModeRef = kiTM2TeXBeginSuperscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }

            case '_':
                switch(switcher)
                {
                    case kiTM2TeXBeginCommandSyntaxMode:
  						* newModeRef = kiTM2TeXShortCommandSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginCommentSyntaxMode:
 						* newModeRef = kiTM2TeXCommentSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
 						* newModeRef = previousMode;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                    case kiTM2TeXMoreSubscriptSyntaxMode:
 						* newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
 						* newModeRef = kiTM2TeXMoreSubscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                    case kiTM2TeXInputCommandSyntaxMode:
 						* newModeRef = kiTM2TeXErrorSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
 						* newModeRef = kiTM2TeXBeginSubscriptSyntaxMode | previousError;
						return kiTM2TeXNoErrorSyntaxStatus;
                }
            
            default:
            {
//NSLog(@"Non letter character: %@", [NSString stringWithCharacters: &theChar length:1]);
                unsigned result;
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        result = kiTM2TeXRegularSyntaxMode;
                    break;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        result = kiTM2TeXShortCommandSyntaxMode;
                    break;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        result = kiTM2TeXShortSuperscriptSyntaxMode;
                    break;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        result = kiTM2TeXShortSubscriptSyntaxMode;
                    break;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        result = previousMode;
                    break;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        result = kiTM2TeXCommentSyntaxMode;
                    break;
                    case kiTM2TeXInputCommandSyntaxMode:
                        result = kiTM2TeXRegularSyntaxMode;
                    break;
//                    case kiTM2TeXMoreDollarSyntaxMode:
//                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        result = kiTM2TeXRegularSyntaxMode;
                }
//NSLog(@"mode returned: %u", result);
				NSString * modeString = [_iTM2TeXModeForModeArray objectAtIndex:result & ~kiTM2TeXErrorSyntaxMask];
                if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:modeString])
				{
 					* newModeRef = result | previousError;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
                else
				{
//iTM2_LOG(@"AN ERROR OCCURRED");
 					* newModeRef = result | kiTM2TeXErrorSyntaxMask | previousError;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
            }
        }
    }
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(newModeRef);
    NSString * S = [_TextStorage string];
	NSString * s;
	NSRange r;
    NSParameterAssert(location<[S length]);
	unsigned status;
	unsigned switcher = previousMode & ~kiTM2TextModifiersSyntaxMask;
	unichar theChar;
	if(kiTM2TeXBeginCommandSyntaxMode == switcher)
	{
		NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
		theChar = [S characterAtIndex:location];
		if([set characterIsMember:theChar])
		{
			// is it a \input
			// scanning from location for the control sequence name
			unsigned start = location;
			unsigned end = start+1;
			while(end<[S length] && ((theChar = [S characterAtIndex:end]),[set characterIsMember:theChar]))
				++end;
			if(end == start+5)
			{
				r = NSMakeRange(start, end-start);
				s = [S substringWithRange:r];
				if([@"input" isEqualToString:s])
				{
					if(lengthRef)
						* lengthRef = end-start;
					if(nextModeRef && (end<[S length]))
					{
						theChar = [S characterAtIndex:end];
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:kiTM2TeXInputCommandSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					* newModeRef = kiTM2TeXInputCommandSyntaxMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
			if(end == start+4)
			{
				r = NSMakeRange(start, end-start);
				s = [S substringWithRange:r];
				if([@"ding" isEqualToString:s])
				{
					if(lengthRef)
						* lengthRef = end-start;
					if(nextModeRef && (end<[S length]))
					{
						theChar = [S characterAtIndex:end];
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:kiTM2TeXInputCommandSyntaxMode];
					}
					* newModeRef = kiTM2TeXDingCommandSyntaxMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
			if(lengthRef)
				* lengthRef = end-start;
			if(nextModeRef)
			{
				* nextModeRef = kiTM2TeXUnknownSyntaxMode;
			}
			* newModeRef = kiTM2TeXCommandSyntaxMode;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
		else
		{
			if(lengthRef)
				* lengthRef = 1;
			if(nextModeRef && (location+1<[S length]))
			{
				* nextModeRef = kiTM2TeXUnknownSyntaxMode;
			}
			* newModeRef = kiTM2TeXShortCommandSyntaxMode;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
	}
	else if(lengthRef) // && (switcher != kiTM2TeXBeginCommandSyntaxMode)
	{
		* lengthRef = 1;
		theChar = [S characterAtIndex:location];
		status = [self getSyntaxMode:newModeRef forCharacter:theChar previousMode:switcher];
		if(kiTM2TeXBeginCommandSyntaxMode != *newModeRef)
		{
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, switcher: %u", nextMode, switcher);
			beforeIndex = MIN(beforeIndex, [S length]);
			while(++location < beforeIndex)
			{
				switcher = *newModeRef;
				theChar = [S characterAtIndex:location];
				status = [self getSyntaxMode:newModeRef forCharacter:theChar previousMode:switcher];
//NSLog(@"2: nextMode: %u, switcher: %u", nextMode, switcher);
				if(*newModeRef == switcher)
					* lengthRef += 1;
				else
				{
					if(nextModeRef)
						* nextModeRef = *newModeRef;
					* newModeRef = switcher;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
		}
		if(nextModeRef)
			* nextModeRef = kiTM2TextUnknownSyntaxMode;
		return kiTM2TeXNoErrorSyntaxStatus;
	}
	else// if(!lengthRef) && (switcher != kiTM2TeXBeginCommandSyntaxMode)
	{
		if(nextModeRef)
			* nextModeRef = kiTM2TextUnknownSyntaxMode;
		theChar = [S characterAtIndex:location];
		status = [self getSyntaxMode:newModeRef forCharacter:theChar previousMode:switcher];
//NSLog(@"nextMode: %u, switcher: %u", nextMode, switcher);
		return status;
	}
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)getSyntaxMode:(unsigned *)nextModeRef forLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(nextModeRef);
    NSString * S = [_TextStorage string];
	unichar theChar;
    if(location<[S length])
    {
        if(lengthRef)
        {
            * lengthRef = 1;
			theChar = [S characterAtIndex:location];
            unsigned nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
            beforeIndex = MIN(beforeIndex, [S length]);
            while(++location < beforeIndex)
            {
                previousMode = nextMode;
				theChar = [S characterAtIndex:location];
                nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"2: nextMode: %u, previousMode: %u", nextMode, previousMode);
                if(nextMode == previousMode)
                    * lengthRef += 1;
                else
                {
                    if(nextModeRef)
                        * nextModeRef = nextMode;
                    return previousMode;
                }
            }
            if(nextModeRef)
                * nextModeRef = 0;
            return nextMode;
        }
        else
        {
            if(nextModeRef)
                * nextModeRef = 0;
			theChar = [S characterAtIndex:location];
            unsigned nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"nextMode: %u, previousMode: %u", nextMode, previousMode);
            return nextMode;
        }
    }
    else
    {
//iTM2_LOG(@"location: %i <=  [S length] %i", location, [S length]);
        if(lengthRef)
            * lengthRef = 0;
        return [self EOLModeForPreviousMode:previousMode];
    }
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLModeForPreviousMode:
- (unsigned)EOLModeForPreviousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Character: %@", [NSString stringWithCharacters: &argument length:1]);
//NSLog(@"previousMode: %u", previousMode);
//NSLog(@"result: %u", previousMode-1);
    return kiTM2TeXRegularSyntaxMode | kiTM2TeXEndOfLineSyntaxMask;// beware, you must use the kiTM2TextEndOfLineSyntaxMask
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned mode;
	//unsigned status = 
	[self getSyntaxMode:&mode atIndex:aLocation longestRange:aRangePtr];
	NSString * s;
	unsigned switcher = mode & ~kiTM2TeXModifiersSyntaxMask;
    switch(switcher)
    {
        case kiTM2TeXRegularSyntaxMode:
        case kiTM2TextWhitePrefixSyntaxMode:
        case kiTM2TeXCommandSyntaxMode:
        case kiTM2TeXCommentSyntaxMode:
        case kiTM2TeXMarkSyntaxMode:
        case kiTM2TeXDollarSyntaxMode:
        case kiTM2TeXMoreDollarSyntaxMode:
        case kiTM2TeXDelimiterSyntaxMode:
        case kiTM2TeXParenOpenSyntaxMode:
        case kiTM2TeXParenCloseSyntaxMode:
        case kiTM2TeXSubscriptSyntaxMode:
        case kiTM2TeXBeginGroupSyntaxMode:
        case kiTM2TeXEndGroupSyntaxMode:
        case kiTM2TeXBeginSubscriptSyntaxMode:
        case kiTM2TeXMoreSubscriptSyntaxMode:
        case kiTM2TeXShortSubscriptSyntaxMode:
        case kiTM2TeXSuperscriptSyntaxMode:
        case kiTM2TeXBeginSuperscriptSyntaxMode:
        case kiTM2TeXShortSuperscriptSyntaxMode:
        case kiTM2TeXInputCommandSyntaxMode:
        case kiTM2TeXDingCommandSyntaxMode:
        case kiTM2TeXShortCommandSyntaxMode:
        case kiTM2TeXBeginCommandSyntaxMode:
        case kiTM2TeXCellSeparatorSyntaxMode:
			if(aRangePtr)
			{
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr)-aLocation);
			}
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];
        case kiTM2TeXErrorSyntaxMode:
			if(aRangePtr)
			{
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr)-aLocation);
			}
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];
        case kiTM2TeXBeginCommentSyntaxMode:
        {
            unsigned lineIndex = [self lineIndexForLocation:aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
            unsigned endOffset = [ML startOffset]+[ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset-aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex:aLocation effectiveRange:nil];
            else
			{
				s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentSyntaxMode];
                return [_AS attributesForMode:s];
			}
        }
        default:
            iTM2_LOG(@"Someone is asking for mode: %u = %#x (%u = %#x)", mode, mode, switcher, switcher);
			if(aRangePtr)
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr)-aLocation);
			s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
            return [_AS attributesForMode:s];
    }
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxModeAtIndex:longestEffectiveRange:
- (unsigned)syntaxModeAtIndex:(unsigned)aLocation longestEffectiveRange:(NSRangePointer)aRangePtr;
/*"BUGGY
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Location: %u", aLocation);
    unsigned lineIndex = [self lineIndexForLocation:aLocation];
    iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
    unsigned mode;
	unsigned status = [modeLine getSyntaxMode:&mode atGlobalLocation:aLocation longestRange:aRangePtr];
	if(aRangePtr)
	{
		unsigned n = MIN([self badOffsetIndex], [self numberOfModeLines])-1;
meursault:
		aLocation = [modeLine endOffset];
		if(NSMaxRange(*aRangePtr) >= aLocation)
		{
			// there is a chance that the nextLine is involved
			if((++lineIndex<n) || (lineIndex = [self lineIndexForLocation:aLocation], lineIndex < [self numberOfModeLines]))
			{
				modeLine = [self modeLineAtIndex:lineIndex];
				NSRange nextRange;
				if((aLocation < [modeLine endOffset]) && ([modeLine getSyntaxMode:&mode atGlobalLocation:aLocation longestRange:&nextRange],mode))
				{
					aRangePtr -> length += nextRange.length;
					goto meursault;
				}
			}
		}
	}
	return mode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesAtIndex:longestEffectiveRange:inRange:
- (NSDictionary *)xattributesAtIndex:(unsigned)aLocation longestEffectiveRange:(NSRangePointer)aRangePtr inRange:(NSRange)aRangeLimit;
/*"Description forthcoming. BUGGY
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned mode = [self syntaxModeAtIndex:aLocation longestEffectiveRange:aRangePtr];
	unsigned switcher = mode & ~kiTM2TeXModifiersSyntaxMask;
	NSString * modeString;
    switch(switcher)
    {
        case kiTM2TeXRegularSyntaxMode:
        case kiTM2TextWhitePrefixSyntaxMode:
        case kiTM2TeXCommandSyntaxMode:
        case kiTM2TeXCommentSyntaxMode:
        case kiTM2TeXMarkSyntaxMode:
        case kiTM2TeXDollarSyntaxMode:
        case kiTM2TeXDelimiterSyntaxMode:
        case kiTM2TeXParenOpenSyntaxMode:
        case kiTM2TeXParenCloseSyntaxMode:
        case kiTM2TeXSubscriptSyntaxMode:
        case kiTM2TeXBeginGroupSyntaxMode:
        case kiTM2TeXEndGroupSyntaxMode:
        case kiTM2TeXBeginSubscriptSyntaxMode:
        case kiTM2TeXShortSubscriptSyntaxMode:
        case kiTM2TeXSuperscriptSyntaxMode:
        case kiTM2TeXBeginSuperscriptSyntaxMode:
        case kiTM2TeXShortSuperscriptSyntaxMode:
        case kiTM2TeXInputCommandSyntaxMode:
        case kiTM2TeXErrorSyntaxMode:
        case kiTM2TeXShortCommandSyntaxMode:
        case kiTM2TeXBeginCommandSyntaxMode:
        case kiTM2TeXCellSeparatorSyntaxMode:
			if(aRangePtr)
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr)-aLocation);
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        case kiTM2TeXBeginCommentSyntaxMode:
        {
            unsigned lineIndex = [self lineIndexForLocation:aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
            unsigned endOffset = [ML startOffset]+[ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset-aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex:aLocation effectiveRange:nil];
            else
			{
				modeString = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentSyntaxMode];
                return [_AS attributesForMode:modeString];
			}
        }
        default:
            iTM2_LOG(@"Someone is asking for mode: %u = %#x (%u = %#x)", mode, mode, switcher, switcher);
			if(aRangePtr)
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr)-aLocation);
			modeString = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
            return [_AS attributesForMode:modeString];
    }
}
#endif
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange r;
	unsigned mode;
    unsigned status = [self getSyntaxMode:&mode atIndex:aLocation longestRange:&r];
#if 0
    if(mode & kiTM2TeXErrorSyntaxModeSyntaxMask)
    {
        if(aRangePtr)
        {
            aRangePtr -> location = aLocation;
            aRangePtr -> length = 1;
        }
		s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
        return [_AS attributesForMode:s];
    }
#endif
    if(aRangePtr)
		*aRangePtr = r;
	unsigned int switcher = mode & ~kiTM2TeXModifiersSyntaxMask;
	NSString * S = [_TextStorage string];
    NSRange r1;
	NSString * s;
	NSDictionary * D;
	unsigned nextMode;
    switch(switcher)
    {
        case kiTM2TeXRegularSyntaxMode:
		{
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];
		}
        case kiTM2TeXBeginCommandSyntaxMode:
        {
            if(++aLocation < [_TextStorage length])
            {
				status = [self getSyntaxMode:&nextMode atIndex:aLocation longestRange:&r1];
				nextMode = nextMode & ~kiTM2TeXErrorSyntaxMask;
                if((kiTM2TeXCommandSyntaxMode == nextMode) || (kiTM2TeXShortCommandSyntaxMode == nextMode) || (kiTM2TeXInputCommandSyntaxMode == nextMode))
                {
					--r1.location;
					++r1.length;
                    if(aRangePtr)
						*aRangePtr = r1;
					s = [S substringWithRange:r1];
                    if(D = [_AS attributesForSymbol:s])
                        return D;
                }
                if(kiTM2TeXDingCommandSyntaxMode == nextMode)
                {
					--r1.location;
					++r1.length;
					r.location = NSMaxRange(r1);
					r.length = MIN([S length]-r.location,5);
					if(r.length && ([S characterAtIndex:r.location]=='{'))
					{
						r = [S rangeOfString:@"}" options:0 range:r];
						if(r.length)
						{
							r.length = NSMaxRange(r) - r1.location;
							r.location = r1.location;
							if(aRangePtr)
								*aRangePtr = r;
							s = [S substringWithRange:r];
							if(D = [_AS attributesForSymbol:s])
								return D;
						}
					}
					if(aRangePtr)
						*aRangePtr = r1;
					s = [S substringWithRange:r1];
                    if(D = [_AS attributesForSymbol:s])
                        return D;
                }
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommandSyntaxMode];
            return [_AS attributesForMode:s];
        }
        case kiTM2TextWhitePrefixSyntaxMode:
        case kiTM2TeXBeginGroupSyntaxMode:
        case kiTM2TeXEndGroupSyntaxMode:
        case kiTM2TeXCommentSyntaxMode:
        case kiTM2TeXMarkSyntaxMode:
        case kiTM2TeXDollarSyntaxMode:
        case kiTM2TeXMoreDollarSyntaxMode:
        case kiTM2TeXDelimiterSyntaxMode:
        case kiTM2TeXParenOpenSyntaxMode:
        case kiTM2TeXSuperscriptSyntaxMode:
        case kiTM2TeXSubscriptSyntaxMode:
        case kiTM2TeXCellSeparatorSyntaxMode:
        case kiTM2TeXInputCommandSyntaxMode:
        case kiTM2TeXErrorSyntaxMode:
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];

        case kiTM2TeXCommandSyntaxMode:
        {
            if(r.location)
            {
				--r.location;
				++r.length;
				aLocation = NSMaxRange(r);
				if(aLocation+2<[S length])
				{
					if(([S characterAtIndex:aLocation] == '{')
						&&([S characterAtIndex:aLocation+2] == '}'))
					{
						r1 = NSMakeRange(r.location, r.length+3);
						if(aRangePtr)
							*aRangePtr = r1;
						s = [S substringWithRange:r1];
						if(D = [_AS attributesForSymbol:s])
						{
							return D;
						}
					}
				}
				if(aRangePtr)
					*aRangePtr = r;
				s = [S substringWithRange:r];
				if(D = [_AS attributesForSymbol:s])
					return D;
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommandSyntaxMode];
            return [_AS attributesForMode:s];
        }
        case kiTM2TeXDingCommandSyntaxMode:
        {
            if(r.location)
            {
				--r.location;
				++r.length;
				aLocation = NSMaxRange(r);
				r1.location = NSMaxRange(r);
				r1.length = MIN([S length]-r1.location,5);
				if(r1.length && ([S characterAtIndex:r1.location]=='{'))
				{
					r1 = [S rangeOfString:@"}" options:0 range:r1];
					if(r1.length)
					{
						r1.length = NSMaxRange(r1) - r.location;
						r1.location = r.location;
						if(aRangePtr)
							*aRangePtr = r1;
						s = [S substringWithRange:r1];
						if(D = [_AS attributesForSymbol:s])
							return D;
					}
				}
				if(aRangePtr)
					*aRangePtr = r;
				s = [S substringWithRange:r];
				if(D = [_AS attributesForSymbol:s])
					return D;
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXDingCommandSyntaxMode];
            return [_AS attributesForMode:s];
        }
        case kiTM2TeXShortCommandSyntaxMode:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                NSRange r = NSMakeRange(aLocation-1, 2);// this is the whole short command including the leading backslash
				++aLocation;//aLocation now points to the next character after the short command
				// now we are looking for stuff like \^{o}
				if(aLocation+2<[_TextStorage length])
				{
					if(([S characterAtIndex:aLocation] == '{')
						&&([S characterAtIndex:aLocation+2] == '}'))
					{
						r1 = NSMakeRange(r.location, r.length+3);
						if(aRangePtr)
							*aRangePtr = r1;
						s = [S substringWithRange:r1];
						if(D = [_AS attributesForSymbol:s])
						{
							return D;
						}
					}
				}
                if(aRangePtr)
					*aRangePtr = r;
				s = [S substringWithRange:r];
                if(D = [_AS attributesForSymbol:s])
				{
//iTM2_LOG(@"There is a symbol in range: %@", NSStringFromRange(r));
                    return D;
				}
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommandSyntaxMode];
            return [_AS attributesForMode:s];
        }
        case kiTM2TeXShortSuperscriptSyntaxMode:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                r = NSMakeRange(aLocation-1, 2);
                if(aRangePtr)
					*aRangePtr = r;
				s = [S substringWithRange:r];
                if(D = [_AS attributesForSymbol:s])
                    return D;
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:mode];
            return [_AS attributesForMode:s];
        }
        case kiTM2TeXBeginSuperscriptSyntaxMode:
        {
            if(++aLocation < [_TextStorage length])
            {
				status = [self getSyntaxMode:&nextMode atIndex:aLocation longestRange:&r1];
				nextMode = nextMode & ~kiTM2TeXErrorSyntaxMask;
                if(kiTM2TeXShortSuperscriptSyntaxMode == nextMode)
                {
                    --r1.location;
                    ++r1.length;
                    if(aRangePtr)
                         *aRangePtr = r1;
					s = [S substringWithRange:r1];
                    if(D = [_AS attributesForSymbol:s])
                        return D;
                }
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];
        }
        case kiTM2TeXShortSubscriptSyntaxMode:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                NSRange r = NSMakeRange(aLocation-1, 2);
				if(aRangePtr)
					*aRangePtr = r;
				s = [S substringWithRange:r];
                if(D = [_AS attributesForSymbol:s])
				{
                    return D;
				}
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];
        }
        case kiTM2TeXParenCloseSyntaxMode:
        {
			if(aLocation+2 < [_TextStorage length])
			{
				r1.location = aLocation;
				r1.length = 3;
				s = [S substringWithRange:r1];
				if(D = [_AS attributesForSymbol:s])
				{
					if(aRangePtr)
						 *aRangePtr = r1;
					return D;
				}
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];
		}
        case kiTM2TeXMoreSubscriptSyntaxMode:
			if(!aLocation)
			{
				s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
				return [_AS attributesForMode:s];
			}
			--aLocation;
			switcher = kiTM2TeXBeginSubscriptSyntaxMode;
        case kiTM2TeXBeginSubscriptSyntaxMode:
        {
			if(aLocation+8 < [_TextStorage length])
			{
				r1.location = aLocation;
				r1.length = 9;
				s = [S substringWithRange:r1];
				if(D = [_AS attributesForSymbol:s])
				{
					if(aRangePtr)
						 *aRangePtr = r1;
					return D;
				}
            }
			if(aLocation+2 < [_TextStorage length])
			{
				r1.location = aLocation;
				r1.length = 3;
				s = [S substringWithRange:r1];
				if(D = [_AS attributesForSymbol:s])
				{
					if(aRangePtr)
						 *aRangePtr = r1;
					return D;
				}
            }
			if(++aLocation < [_TextStorage length])
            {
				status = [self getSyntaxMode:&nextMode atIndex:aLocation longestRange: &r1];
                if((kiTM2TeXShortSubscriptSyntaxMode == nextMode)
					|| (kiTM2TeXMoreSubscriptSyntaxMode == nextMode))
                {
                    --r1.location;
                    ++r1.length;
					if(aRangePtr)
						 *aRangePtr = r1;
					s = [S substringWithRange:r1];
                    if(D = [_AS attributesForSymbol:s])
					{
                        return D;
					}
                }
            }
			s = [_iTM2TeXModeForModeArray objectAtIndex:switcher];
            return [_AS attributesForMode:s];
        }
        case kiTM2TeXBeginCommentSyntaxMode:
        {
            unsigned lineIndex = [self lineIndexForLocation:aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
            unsigned endOffset = [ML startOffset]+[ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset-aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex:aLocation effectiveRange:nil];
            else
			{
				s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentSyntaxMode];
                return [_AS attributesForMode:s];
			}
        }
        case kiTM2TeXUnknownSyntaxMode:
			s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXRegularSyntaxMode];
            return [_AS attributesForMode:s];

        default:
		{
            iTM2_LOG(@"Someone is asking for mode: %u = %#x (%u = %#x)", mode, mode, switcher, switcher);
status = [self getSyntaxMode:&mode atIndex:aLocation longestRange:&r];
			s = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
            return [_AS attributesForMode:s];
		}
    }
}
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
//iTM2_START;
    if(!_iTM2TeXPTeXLetterCharacterSet)
    {
        id set = [[[NSCharacterSet characterSetWithRange:NSMakeRange('a', 26)] mutableCopy] autorelease];
        [set addCharactersInRange:NSMakeRange('A', 26)];
        [set addCharactersInString:@"@"];
        _iTM2TeXPTeXLetterCharacterSet = [set copy];
    }
    if(!_iTM2TeXPTeXFileNameLetterCharacterSet)
    {
        id set = [[[NSCharacterSet letterCharacterSet] mutableCopy] autorelease];
        [set addCharactersInString:@"_$^0123456789.-+*()[]/"];
        _iTM2TeXPTeXFileNameLetterCharacterSet = [set copy];
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXStorageKit
