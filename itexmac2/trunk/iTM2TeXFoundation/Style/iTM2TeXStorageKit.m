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
            #warning DEBUG
            if(iTM2DebugEnabled > 999999 && !symbolColor)
            {
                iTM2_LOG(@"no 2nd color for symbol: %@", symbol);
            }
            NSColor * replacementColor = symbolColor && [symbolColor alphaComponent]>0?
                [[symbolColor colorWithAlphaComponent:1] blendedColorWithFraction:1 - [symbolColor alphaComponent]
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
//iTM2_END;
    return [MD writeToFile:fileName atomically:YES];
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
			iTM2TextErrorKey, iTM2TextWhitePrefixKey, iTM2TextDefaultKey, @"command", @"command", @"command", @"comment", @"comment", @"mark", @"math", @"group", @"group", @"delimiter", @"subscript", @"subscript", @"subscript", @"superscript", @"superscript", @"superscript", @"input", @"cellSeparator", nil] retain];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForCharacter:previousMode:
- (unsigned)syntaxModeForCharacter:(unichar)theChar previousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
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
			return kiTM2TeXWhitePrefixSyntaxMode | previousError;
		}
	}
	unsigned switcher = previousMode & ~kiTM2TeXErrorSyntaxMask;
    if([[NSCharacterSet TeXLetterCharacterSet] characterIsMember:theChar])
    {
		unsigned result;
        switch(switcher)
        {
            case kiTM2TeXRegularSyntaxMode:
            case kiTM2TeXCommandSyntaxMode:
            case kiTM2TeXInputSyntaxMode:
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
			return result | previousError;
		else
		{
//iTM2_LOG(@"AN ERROR OCCURRED");
			return result | kiTM2TeXErrorFontSyntaxMask | previousError;
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
                        return previousMode;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    default:
                        return kiTM2TeXRegularSyntaxMode | previousError;
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
                    case kiTM2TeXInputSyntaxMode:
                    case kiTM2TeXErrorSyntaxMode:
                        return kiTM2TeXBeginCommandSyntaxMode | previousError;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    default:
                        return kiTM2TeXBeginCommandSyntaxMode | previousError;
                }
    
            case '{':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                    case kiTM2TeXInputSyntaxMode:
                    case kiTM2TeXWhitePrefixSyntaxMode:
                        return kiTM2TeXBeginGroupSyntaxMode | previousError;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    default:
                        return kiTM2TeXBeginGroupSyntaxMode | previousError;
                }

            case '}':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        return kiTM2TeXEndGroupSyntaxMode | previousError;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXEndGroupSyntaxMode | previousError;
                }

            case '(':
            case ')':
            case '[':
            case ']':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        return kiTM2TeXDelimiterSyntaxMode | previousError;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXDelimiterSyntaxMode | previousError;
                }
    
            case '$':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        return kiTM2TeXDollarSyntaxMode | previousError;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXDollarSyntaxMode | previousError;
                }
    
            case '%':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        return kiTM2TeXBeginCommentSyntaxMode | previousError;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXBeginCommentSyntaxMode | previousError;
                }
            
            case '&':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        return kiTM2TeXCellSeparatorSyntaxMode | previousError;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXCellSeparatorSyntaxMode | previousError;
                }
            
            case '!':
                switch(switcher)
                {
                    case kiTM2TeXRegularSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXMarkSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXRegularSyntaxMode | previousError;
                }
            
            case '^':
                switch(switcher)
                {
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXBeginSuperscriptSyntaxMode | previousError;
                }

            case '_':
                switch(switcher)
                {
                    case kiTM2TeXBeginCommandSyntaxMode:
                        return kiTM2TeXShortCommandSyntaxMode | previousError;
                    case kiTM2TeXBeginCommentSyntaxMode:
                        return kiTM2TeXCommentSyntaxMode | previousError;
                    case kiTM2TeXCommentSyntaxMode:
                    case kiTM2TeXMarkSyntaxMode:
                        return previousMode;
                    case kiTM2TeXBeginSuperscriptSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXBeginSubscriptSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXInputSyntaxMode:
                        return kiTM2TeXErrorSyntaxMode | previousError;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        return kiTM2TeXBeginSubscriptSyntaxMode | previousError;
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
                    case kiTM2TeXInputSyntaxMode:
                        result = kiTM2TeXRegularSyntaxMode;
                    break;
                    case kiTM2TeXWhitePrefixSyntaxMode:
                    default:
                        result = kiTM2TeXRegularSyntaxMode;
                }
//NSLog(@"mode returned: %u", result);
                if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:[_iTM2TeXModeForModeArray objectAtIndex:result & ~kiTM2TeXErrorSyntaxMask]])
                    return result | previousError;
                else
				{
//iTM2_LOG(@"AN ERROR OCCURRED");
                    return result | kiTM2TeXErrorSyntaxMask | previousError;
				}
            }
        }
    }
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)syntaxModeForLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [_TextStorage string];
    NSParameterAssert(location<[S length]);
	unsigned switcher = previousMode & ~kiTM2TeXErrorSyntaxMask;
	if(kiTM2TeXBeginCommandSyntaxMode == switcher)
	{
		if([[NSCharacterSet TeXLetterCharacterSet] characterIsMember:[S characterAtIndex:location]])
		{
			// is it a \input
			// scanning from location for the control sequence name
			unsigned start = location;
			unsigned end = start + 1;
			while(end<[S length] && [[NSCharacterSet TeXLetterCharacterSet] characterIsMember:[S characterAtIndex:end]])
				++end;
			if(end == start+5)
			{
				if([@"input" isEqualToString:[S substringWithRange:NSMakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<[S length]))
					{
						* nextModeRef = [self syntaxModeForCharacter:[S characterAtIndex:end] previousMode:kiTM2TeXInputSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					return kiTM2TeXInputSyntaxMode;
				}
			}
			if(lengthRef)
				* lengthRef = end - start;
			if(nextModeRef)
			{
				* nextModeRef = kiTM2TeXUnknownSyntaxMode;
			}
			return kiTM2TeXCommandSyntaxMode;
		}
		else
		{
			if(lengthRef)
				* lengthRef = 1;
			if(nextModeRef && (location + 1<[S length]))
			{
				* nextModeRef = kiTM2TeXUnknownSyntaxMode;
			}
			return kiTM2TeXShortCommandSyntaxMode;
		}
	}
	else if(lengthRef) // && (switcher != kiTM2TeXBeginCommandSyntaxMode)
	{
		* lengthRef = 1;
		unsigned nextMode = [self syntaxModeForCharacter:[S characterAtIndex:location] previousMode:switcher];
		if(kiTM2TeXBeginCommandSyntaxMode != nextMode)
		{
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, switcher: %u", nextMode, switcher);
			beforeIndex = MIN(beforeIndex, [S length]);
			while(++location < beforeIndex)
			{
				switcher = nextMode;
				nextMode = [self syntaxModeForCharacter:[S characterAtIndex:location] previousMode:switcher];
//NSLog(@"2: nextMode: %u, switcher: %u", nextMode, switcher);
				if(nextMode == switcher)
					* lengthRef += 1;
				else
				{
					if(nextModeRef)
						* nextModeRef = nextMode;
					return switcher;
				}
			}
		}
		if(nextModeRef)
			* nextModeRef = kiTM2TextUnknownSyntaxMode;
		return nextMode;
	}
	else// if(!lengthRef) && (switcher != kiTM2TeXBeginCommandSyntaxMode)
	{
		if(nextModeRef)
			* nextModeRef = kiTM2TextUnknownSyntaxMode;
		unsigned nextMode = [self syntaxModeForCharacter:[S characterAtIndex:location] previousMode:switcher];
//NSLog(@"nextMode: %u, switcher: %u", nextMode, switcher);
		return nextMode;
	}
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)syntaxModeForLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [_TextStorage string];
    if(location<[S length])
    {
        if(lengthRef)
        {
            * lengthRef = 1;
            unsigned nextMode = [self syntaxModeForCharacter:[S characterAtIndex:location] previousMode:previousMode];
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
            beforeIndex = MIN(beforeIndex, [S length]);
            while(++location < beforeIndex)
            {
                previousMode = nextMode;
                nextMode = [self syntaxModeForCharacter:[S characterAtIndex:location] previousMode:previousMode];
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
            unsigned nextMode = [self syntaxModeForCharacter:[[_TextStorage string] characterAtIndex:location] previousMode:previousMode];
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
    unsigned mode = [self syntaxModeAtIndex:aLocation longestRange:aRangePtr];
	unsigned switcher = mode & ~kiTM2TeXModifiersSyntaxMask;
    switch(switcher)
    {
        case kiTM2TeXRegularSyntaxMode:
        case kiTM2TextWhitePrefixSyntaxMode:
        case kiTM2TeXCommandSyntaxMode:
        case kiTM2TeXCommentSyntaxMode:
        case kiTM2TeXMarkSyntaxMode:
        case kiTM2TeXDollarSyntaxMode:
        case kiTM2TeXDelimiterSyntaxMode:
        case kiTM2TeXSubscriptSyntaxMode:
        case kiTM2TeXBeginGroupSyntaxMode:
        case kiTM2TeXEndGroupSyntaxMode:
        case kiTM2TeXBeginSubscriptSyntaxMode:
        case kiTM2TeXShortSubscriptSyntaxMode:
        case kiTM2TeXSuperscriptSyntaxMode:
        case kiTM2TeXBeginSuperscriptSyntaxMode:
        case kiTM2TeXShortSuperscriptSyntaxMode:
        case kiTM2TeXInputSyntaxMode:
        case kiTM2TeXErrorSyntaxMode:
        case kiTM2TeXShortCommandSyntaxMode:
        case kiTM2TeXBeginCommandSyntaxMode:
        case kiTM2TeXCellSeparatorSyntaxMode:
			if(aRangePtr)
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr) - aLocation);
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        case kiTM2TeXBeginCommentSyntaxMode:
        {
            unsigned lineIndex = [self lineIndexForLocation:aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
            unsigned endOffset = [ML startOffset] + [ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset - aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex:aLocation effectiveRange:nil];
            else
                return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentSyntaxMode]];
        }
        default:
            iTM2_LOG(@"Someone is asking for mode: %u = %#x (%u = %#x)", mode, mode, switcher, switcher);
			if(aRangePtr)
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr) - aLocation);
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode]];
    }
}
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
    unsigned mode = [modeLine syntaxModeAtGlobalLocation:aLocation longestRange:aRangePtr];
	if(aRangePtr)
	{
		unsigned n = MIN([self badOffsetIndex], [self numberOfModeLines]) - 1;
meursault:
		aLocation = [modeLine endOffset];
		if(NSMaxRange(*aRangePtr) >= aLocation)
		{
			// there is a chance that the nextLine is involved
			if((++lineIndex<n) || (lineIndex = [self lineIndexForLocation:aLocation], lineIndex < [self numberOfModeLines]))
			{
				modeLine = [self modeLineAtIndex:lineIndex];
				NSRange nextRange;
				if((aLocation < [modeLine endOffset]) && (mode == [modeLine syntaxModeAtGlobalLocation:aLocation longestRange: &nextRange]))
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
    switch(switcher)
    {
        case kiTM2TeXRegularSyntaxMode:
        case kiTM2TextWhitePrefixSyntaxMode:
        case kiTM2TeXCommandSyntaxMode:
        case kiTM2TeXCommentSyntaxMode:
        case kiTM2TeXMarkSyntaxMode:
        case kiTM2TeXDollarSyntaxMode:
        case kiTM2TeXDelimiterSyntaxMode:
        case kiTM2TeXSubscriptSyntaxMode:
        case kiTM2TeXBeginGroupSyntaxMode:
        case kiTM2TeXEndGroupSyntaxMode:
        case kiTM2TeXBeginSubscriptSyntaxMode:
        case kiTM2TeXShortSubscriptSyntaxMode:
        case kiTM2TeXSuperscriptSyntaxMode:
        case kiTM2TeXBeginSuperscriptSyntaxMode:
        case kiTM2TeXShortSuperscriptSyntaxMode:
        case kiTM2TeXInputSyntaxMode:
        case kiTM2TeXErrorSyntaxMode:
        case kiTM2TeXShortCommandSyntaxMode:
        case kiTM2TeXBeginCommandSyntaxMode:
        case kiTM2TeXCellSeparatorSyntaxMode:
			if(aRangePtr)
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr) - aLocation);
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        case kiTM2TeXBeginCommentSyntaxMode:
        {
            unsigned lineIndex = [self lineIndexForLocation:aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
            unsigned endOffset = [ML startOffset] + [ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset - aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex:aLocation effectiveRange:nil];
            else
                return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentSyntaxMode]];
        }
        default:
            iTM2_LOG(@"Someone is asking for mode: %u = %#x (%u = %#x)", mode, mode, switcher, switcher);
			if(aRangePtr)
				* aRangePtr = NSMakeRange(aLocation, NSMaxRange(* aRangePtr) - aLocation);
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode]];
    }
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
    unsigned mode = [self syntaxModeAtIndex:aLocation longestRange: &r];
#if 0
    if(mode & kiTM2TeXErrorSyntaxModeSyntaxMask)
    {
        if(aRangePtr)
        {
            aRangePtr -> location = aLocation;
            aRangePtr -> length = 1;
        }
        return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode]];
    }
#endif
    if(aRangePtr)
            *aRangePtr = r;
	unsigned int switcher = mode & ~kiTM2TeXModifiersSyntaxMask;
    switch(switcher)
    {
        case kiTM2TeXRegularSyntaxMode:
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        case kiTM2TeXBeginCommandSyntaxMode:
        {
            if(++aLocation < [_TextStorage length])
            {
                NSRange r1;
                int nextMode = [self syntaxModeAtIndex:aLocation longestRange: &r1] & ~kiTM2TeXErrorSyntaxMask;
                if((kiTM2TeXCommandSyntaxMode == nextMode) || (kiTM2TeXShortCommandSyntaxMode == nextMode) || (kiTM2TeXInputSyntaxMode == nextMode))
                {
					--r1.location;
					++r1.length;
					NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r1]];
                    if(aRangePtr)
						*aRangePtr = r1;
                    if(D)
                        return D;
                }
            }
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommandSyntaxMode]];
        }
        case kiTM2TextWhitePrefixSyntaxMode:
        case kiTM2TeXBeginGroupSyntaxMode:
        case kiTM2TeXEndGroupSyntaxMode:
        case kiTM2TeXCommentSyntaxMode:
        case kiTM2TeXMarkSyntaxMode:
        case kiTM2TeXDollarSyntaxMode:
        case kiTM2TeXDelimiterSyntaxMode:
        case kiTM2TeXSuperscriptSyntaxMode:
        case kiTM2TeXSubscriptSyntaxMode:
        case kiTM2TeXCellSeparatorSyntaxMode:
        case kiTM2TeXInputSyntaxMode:
        case kiTM2TeXErrorSyntaxMode:
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        case kiTM2TeXCommandSyntaxMode:
        {
            if(r.location)
            {
				--r.location;
				++r.length;
				aLocation = NSMaxRange(r);
				if(aLocation+2<[_TextStorage length])
				{
					if(([[_TextStorage string] characterAtIndex:aLocation] == '{')
						&&([[_TextStorage string] characterAtIndex:aLocation+2] == '}'))
					{
						NSRange r1 = NSMakeRange(r.location, r.length + 3);
						NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r1]];
						if(D)
						{
							if(aRangePtr)
								*aRangePtr = r1;
							return D;
						}
					}
				}
				NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r]];
				if(aRangePtr)
					*aRangePtr = r;
				if(D)
					return D;
            }
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommandSyntaxMode]];
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
					if(([[_TextStorage string] characterAtIndex:aLocation] == '{')
						&&([[_TextStorage string] characterAtIndex:aLocation+2] == '}'))
					{
						NSRange r1 = NSMakeRange(r.location, r.length + 3);
						NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r1]];
						if(D)
						{
							if(aRangePtr)
								*aRangePtr = r1;
							return D;
						}
					}
				}
                NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r]];
                if(aRangePtr)
					*aRangePtr = r;
                if(D)
				{
//iTM2_LOG(@"There is a symbol in range: %@", NSStringFromRange(r));
                    return D;
				}
            }
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommandSyntaxMode]];
        }
        case kiTM2TeXShortSuperscriptSyntaxMode:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                NSRange r = NSMakeRange(aLocation - 1, 2);
                NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r]];
                if(aRangePtr)
					*aRangePtr = r;
                if(D)
                    return D;
            }
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:mode]];
        }
        case kiTM2TeXBeginSuperscriptSyntaxMode:
        {
            if(++aLocation < [_TextStorage length])
            {
                NSRange r1;
                int nextMode = [self syntaxModeAtIndex:aLocation longestRange: &r1] & ~kiTM2TeXErrorSyntaxMask;
                if(kiTM2TeXShortSuperscriptSyntaxMode == nextMode)
                {
                    --r1.location;
                    ++r1.length;
                    NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r1]];
                    if(aRangePtr)
                         *aRangePtr = r1;
                    if(D)
                        return D;
                }
            }
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        }
        case kiTM2TeXShortSubscriptSyntaxMode:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                NSRange r = NSMakeRange(aLocation - 1, 2);
                NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r]];
                if(aRangePtr)
					*aRangePtr = r;
                if(D)
                    return D;
            }
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        }
        case kiTM2TeXBeginSubscriptSyntaxMode:
        {
            if(++aLocation < [_TextStorage length])
            {
                NSRange r1;
                if(kiTM2TeXShortSubscriptSyntaxMode == [self syntaxModeAtIndex:aLocation longestRange: &r1])
                {
                    --r1.location;
                    ++r1.length;
                    NSDictionary * D = [_AS attributesForSymbol:[[_TextStorage string] substringWithRange:r1]];
                    if(aRangePtr)
                         *aRangePtr = r1;
                    if(D)
                        return D;
                }
            }
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:switcher]];
        }
        case kiTM2TeXBeginCommentSyntaxMode:
        {
            unsigned lineIndex = [self lineIndexForLocation:aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
            unsigned endOffset = [ML startOffset] + [ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset - aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex:aLocation effectiveRange:nil];
            else
                return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentSyntaxMode]];
        }
        default:
            iTM2_LOG(@"Someone is asking for mode: %u = %#x (%u = %#x)", mode, mode, switcher, switcher);
            return [_AS attributesForMode:[_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode]];
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
        id set = [[_iTM2TeXPTeXLetterCharacterSet mutableCopy] autorelease];
        [set addCharactersInRange:NSMakeRange('A', 26)];
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextAttributesKit
