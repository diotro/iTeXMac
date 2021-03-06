/*
//  iTM2TeXStorageKit.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Tue Oct 16 2001.
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
+ (void) iTM2TeXStorageCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
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
- (id) initWithVariant: (NSString *) variant;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    variant = [variant lowercaseString];
    if(self = [super initWithVariant: variant])
    {
        [_SymbolsAttributes autorelease];
        _SymbolsAttributes = [[NSMutableDictionary dictionary] retain];
        [_CachedSymbolsAttributes autorelease];
        _CachedSymbolsAttributes = [[NSMutableDictionary dictionary] retain];
        [self loadSymbolsAttributesWithVariant: variant];
    }
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void) dealloc;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
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
- (void) setAttributes: (NSDictionary *) dictionary forMode: (NSString *) mode;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setAttributes: (NSDictionary *) dictionary forMode: (NSString *) mode];
    if([mode isEqual: @"command"])
    {
        [_CachedSymbolsAttributes release];
        _CachedSymbolsAttributes = [[NSMutableDictionary dictionary] retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesDidChange
- (void) attributesDidChange;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
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
    [self loadSymbolsAttributesWithVariant: [self syntaxParserVariant]];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  SYMBOLS ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesForSymbol:
- (NSDictionary *) attributesForSymbol: (NSString *) symbol;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!symbol)
		return nil;
    NSDictionary * symbolAttributes = [_CachedSymbolsAttributes objectForKey: symbol];
    if(symbolAttributes)
        return symbolAttributes;
    symbolAttributes = [_SymbolsAttributes objectForKey: symbol];
    if(symbolAttributes)
    {
        NSDictionary * commandAttributes = [self attributesForMode: @"command"];
        NSColor * commandColor = [commandAttributes objectForKey: NSForegroundColorAttributeName];
        if(commandColor)
        {
            NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary: commandAttributes];// If the command attributes are good...
            [MD addEntriesFromDictionary: symbolAttributes];
            NSColor * symbolColor = [symbolAttributes objectForKey: iTM2Text2ndSymbolColorAttributeName];
            #warning DEBUG
            if(iTM2DebugEnabled > 999999 && !symbolColor)
            {
                iTM2_LOG(@"no 2nd color for symbol: %@", symbol);
            }
            NSColor * replacementColor = symbolColor && [symbolColor alphaComponent]>0?
                [[symbolColor colorWithAlphaComponent: 1] blendedColorWithFraction: 1 - [symbolColor alphaComponent]
                                    ofColor: commandColor]:
                    commandColor;
            [MD setObject: replacementColor forKey: NSForegroundColorAttributeName];
            [_CachedSymbolsAttributes setObject: [NSDictionary dictionaryWithDictionary: MD] forKey: symbol];
            return [_CachedSymbolsAttributes objectForKey: symbol];
        }
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadSymbolsAttributesWithVariant:
- (void) loadSymbolsAttributesWithVariant: (NSString *) variant;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"variant is: %@", variant);
	NSString * variantComponent = [iTM2TextDefaultVariant stringByAppendingPathExtension: iTM2TextVariantExtension];
	NSString * stylePath;
	NSEnumerator * E = [[[self class] builtInStylePaths] objectEnumerator];
	while(stylePath = [E nextObject])
	{
		stylePath = [[stylePath stringByAppendingPathComponent: variantComponent] iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
		BOOL isDir = NO;
		if([DFM fileExistsAtPath: stylePath isDirectory: &isDir] && isDir)
		{
			[self loadSymbolsAttributesAtPath: stylePath];
		}
	}
    variant = [variant lowercaseString];
	variantComponent = [variant stringByAppendingPathExtension: iTM2TextVariantExtension];
    if(![iTM2TextDefaultVariant isEqualToString: variant])
	{
		E = [[[self class] builtInStylePaths] objectEnumerator];
		while(stylePath = [E nextObject])
		{
			stylePath = [[stylePath stringByAppendingPathComponent: variantComponent] iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
			BOOL isDir = NO;
			if([DFM fileExistsAtPath: stylePath isDirectory: &isDir] && isDir)
				[self loadSymbolsAttributesAtPath: stylePath];
		}
	}
	E = [[[self class] otherStylePaths] objectEnumerator];
	while(stylePath = [E nextObject])
	{
		stylePath = [[stylePath stringByAppendingPathComponent: variantComponent] iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
		BOOL isDir = NO;
		if([DFM fileExistsAtPath: stylePath isDirectory: &isDir] && isDir)
			[self loadSymbolsAttributesAtPath: stylePath];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadSymbolsAttributesAtPath:
- (void) loadSymbolsAttributesAtPath: (NSString *) stylePath;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"stylePath: %@", stylePath);
    for(NSString * p in [DFM contentsOfDirectoryAtPath: stylePath error:NULL])
        if([[p pathExtension] isEqualToString: iTM2TextAttributesSymbolsExtension])
        {
            [_CachedSymbolsAttributes autorelease];
            _CachedSymbolsAttributes = [[NSMutableDictionary dictionary] retain];
            NSString * symbolAttributesPath = [stylePath stringByAppendingPathComponent: p];
            NSDictionary * symbolAttributes = [[self class] symbolsAttributesWithContentsOfFile: symbolAttributesPath];
            if(iTM2DebugEnabled > 1000)
            {
                iTM2_LOG(@"We have loaded symbols attributes at path: %@", symbolAttributesPath);
                NSMutableSet * set1 = [NSMutableSet setWithArray: [_SymbolsAttributes allKeys]];
                NSSet * set2 = [NSSet setWithArray: [symbolAttributes allKeys]];
                [set1 intersectSet: set2];
                 iTM2_LOG(@"The overriden keys are: %@", set1);
            }
            [_SymbolsAttributes addEntriesFromDictionary: symbolAttributes];
        }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadDraftSymbolsAttributesAtPath:
- (void) loadDraftSymbolsAttributesAtPath: (NSString *) stylePath;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"stylePath: %@", stylePath);
    for(NSString * p in [DFM contentsOfDirectoryAtPath: stylePath error:NULL])
        if([[p pathExtension] isEqualToString: iTM2TextAttributesDraftSymbolsExtension])
        {
            [_SymbolsAttributes addEntriesFromDictionary:
                [[self class] symbolsAttributesWithContentsOfFile: [stylePath stringByAppendingPathComponent: p]]];
        }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  symbolsAttributesWithContentsOfFile:
+ (NSDictionary *) symbolsAttributesWithContentsOfFile: (NSString *) fileName;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"fileName is: %@", fileName);
    NSData * D = [NSData dataWithContentsOfFile: fileName];
    if([D length])
    {
        NSKeyedUnarchiver * KU = [[[NSKeyedUnarchiver alloc] initForReadingWithData: D] autorelease];
        return [KU decodeObjectForKey: @"iTM2:root"];
    }
    return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSymbolsAttributes:toFile:
+ (BOOL) writeSymbolsAttributes: (NSDictionary *) dictionary toFile: (NSString *) fileName;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableData * MD = [NSMutableData data];
    NSKeyedArchiver * KA = [[[NSKeyedArchiver alloc] initForWritingWithMutableData: MD] autorelease];
    [KA setOutputFormat: NSPropertyListXMLFormat_v1_0];
    [KA encodeObject: dictionary forKey: @"iTM2:root"];
    [KA finishEncoding];
//iTM2_END;
    return [MD writeToFile: fileName atomically: YES];
}
@end

static NSArray * _iTM2TeXModeForModeArray = nil;

#define _TextStorage (iTM2TextStorage *)_TS

@implementation iTM2TeXParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void) load;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
//iTM2_LOG(@"iTM2TeXParser");
    if(!_iTM2TeXModeForModeArray)
        _iTM2TeXModeForModeArray = [[NSArray arrayWithObjects: iTM2TextErrorKey, iTM2TextDefaultKey, @"command", @"command", @"command", @"comment", @"comment", @"mark", @"math", @"group", @"group", @"delimiter", @"subscript", @"subscript", @"subscript", @"superscript", @"superscript", @"superscript", @"input", nil] retain];
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *) syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens@users.sourceforge.net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"TeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModesAttributes
+ (NSDictionary *) defaultModesAttributes;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSDictionary * regular = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor blackColor], NSForegroundColorAttributeName,
        iTM2TextDefaultKey, iTM2TextModeAttributeName,
            nil];
    NSDictionary * error = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor redColor], NSForegroundColorAttributeName,
        iTM2TextErrorKey, iTM2TextModeAttributeName,
            nil];
    NSDictionary * command = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed: 0 green: 0 blue: 0.75 alpha: 1], NSForegroundColorAttributeName,
        @"command", iTM2TextModeAttributeName,
            nil];
    NSDictionary * comment = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed: 0 green: 0.75 blue: 0 alpha: 1], NSForegroundColorAttributeName,
        @"comment", iTM2TextModeAttributeName,
            nil];
    NSDictionary * mark = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed: 0.5 green: 0.25 blue: 0 alpha: 1], NSForegroundColorAttributeName,
        @"mark", iTM2TextModeAttributeName,
            nil];
    NSDictionary * math = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor orangeColor], NSForegroundColorAttributeName,
        @"math", iTM2TextModeAttributeName,
            nil];
    NSDictionary * group = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"group", iTM2TextModeAttributeName,
            nil];
    NSDictionary * delimiter = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"delimiter", iTM2TextModeAttributeName,
            nil];
    NSDictionary * sub = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"subscript", iTM2TextModeAttributeName,
            nil];
    NSDictionary * sup = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize: [NSFont systemFontSize]], NSFontAttributeName,
        [NSColor purpleColor], NSForegroundColorAttributeName,
        @"superscript", iTM2TextModeAttributeName,
            nil];
    NSMutableDictionary * input = [[command mutableCopy] autorelease];
	[input setObject: @"input" forKey: iTM2TextModeAttributeName];
	[input setObject: @"" forKey: NSLinkAttributeName];
    NSMutableDictionary * MD = [[[super defaultModesAttributes] mutableCopy] autorelease];
    [MD setObject: error forKey: [error objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: regular forKey: [regular objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: command forKey: [command objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: comment forKey: [comment objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: mark forKey: [mark objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: math forKey: [math objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: group forKey: [group objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: delimiter forKey: [delimiter objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: sub forKey: [sub objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: sup forKey: [sup objectForKey: iTM2TextModeAttributeName]];
    [MD setObject: [[input copy] autorelease] forKey: [input objectForKey: iTM2TextModeAttributeName]];
    return [NSDictionary dictionaryWithDictionary: MD];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForCharacter:previousMode:
- (NSUInteger) syntaxModeForCharacter: (unichar) theChar previousMode: (NSUInteger) previousMode;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    if(previousMode != ( previousMode & ~kiTM2TeXErrorsMask))
//        NSLog(@"previousMode: 0X%x, mask: 0X%x, previousMode & ~mask: 0X%x",  previousMode, kiTM2TeXErrorInputMask,  previousMode & ~kiTM2TeXErrorsMask);
//iTM2_LOG(@"C'est %.1S qui s'y colle", &theChar);
	NSUInteger switcher = previousMode & ~kiTM2TeXErrorsMask;
    if([[NSCharacterSet iTM2_TeXLetterCharacterSet] characterIsMember: theChar])
    {
		NSUInteger result;
        switch(switcher)
        {
            case kiTM2TeXRegularInput:
            case kiTM2TeXCommandInput:
            case kiTM2TeXInputInput:
                result = previousMode;
			break;
            case kiTM2TeXBeginCommandInput:
                result = kiTM2TeXCommandInput;
			break;
            case kiTM2TeXCommentInput:
                result = previousMode;
			break;
            case kiTM2TeXBeginCommentInput:
                result = kiTM2TeXCommentInput;
			break;
            case kiTM2TeXMarkInput:
                result = previousMode;
			break;
            case kiTM2TeXBeginSubscriptInput:
                result = kiTM2TeXShortSubscriptInput;
			break;
            case kiTM2TeXBeginSuperscriptInput:
                result = kiTM2TeXShortSuperscriptInput;
			break;
            default:
                result = kiTM2TeXRegularInput;
        }
		if([_AS character: theChar isMemberOfCoveredCharacterSetForMode: [_iTM2TeXModeForModeArray objectAtIndex: result & ~kiTM2TeXErrorsMask]])
			return result | (previousMode & kiTM2TeXErrorsMask);
		else
		{
//iTM2_LOG(@"AN ERROR OCCURRED");
			return result | kiTM2TeXErrorFontMask | (previousMode & kiTM2TeXErrorsMask);
		}
    }
    else
    {
        switch(theChar)
        {
            case '\\':
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                    case kiTM2TeXShortCommandInput:
                    case kiTM2TeXCommandInput:
                    case kiTM2TeXDollarInput:
                    case kiTM2TeXDelimiterInput:
                    case kiTM2TeXInputInput:
                    case kiTM2TeXErrorInput:
                        return kiTM2TeXBeginCommandInput;
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    default:
                        return kiTM2TeXBeginCommandInput;
                }
    
            case '{':
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                    case kiTM2TeXInputInput:
                        return kiTM2TeXBeginGroupInput;
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    default:
                        return kiTM2TeXBeginGroupInput;
                }

            case '}':
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                        return kiTM2TeXEndGroupInput;
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    case kiTM2TeXInputInput:
                        return kiTM2TeXErrorInput;
                    default:
                        return kiTM2TeXEndGroupInput;
                }

            case '(':
            case ')':
            case '[':
            case ']':
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                        return kiTM2TeXDelimiterInput;
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    case kiTM2TeXInputInput:
                        return kiTM2TeXErrorInput;
                    default:
                        return kiTM2TeXDelimiterInput;
                }
    
            case '$':
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                        return kiTM2TeXDollarInput;
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    case kiTM2TeXInputInput:
                        return kiTM2TeXErrorInput;
                    default:
                        return kiTM2TeXDollarInput;
                }
    
            case '%':
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                        return kiTM2TeXBeginCommentInput;
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    case kiTM2TeXInputInput:
                        return kiTM2TeXErrorInput;
                    default:
                        return kiTM2TeXBeginCommentInput;
                }
            
            case '!':
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                        return previousMode;
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXMarkInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXInputInput:
                        return kiTM2TeXErrorInput;
                    default:
                        return kiTM2TeXRegularInput;
                }
            
            case '^':
                switch(switcher)
                {
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginSuperscriptInput:
                        return kiTM2TeXErrorInput;
                    case kiTM2TeXBeginSubscriptInput:
                        return kiTM2TeXErrorInput;
                    case kiTM2TeXInputInput:
                        return kiTM2TeXErrorInput;
                    default:
                        return kiTM2TeXBeginSuperscriptInput;
                }

            case '_':
                switch(switcher)
                {
                    case kiTM2TeXBeginCommandInput:
                        return kiTM2TeXShortCommandInput;
                    case kiTM2TeXBeginCommentInput:
                        return kiTM2TeXCommentInput;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        return previousMode;
                    case kiTM2TeXBeginSuperscriptInput:
                        return kiTM2TeXErrorInput;
                    case kiTM2TeXBeginSubscriptInput:
                        return kiTM2TeXErrorInput;
                    case kiTM2TeXInputInput:
                        return kiTM2TeXErrorInput;
                    default:
                        return kiTM2TeXBeginSubscriptInput;
                }
            
            default:
            {
//NSLog(@"Non letter character: %@", [NSString stringWithCharacters: &theChar length: 1]);
                NSUInteger result;
                switch(switcher)
                {
                    case kiTM2TeXRegularInput:
                        result = kiTM2TeXRegularInput;
                    break;
                    case kiTM2TeXBeginCommandInput:
                        result = kiTM2TeXShortCommandInput;
                    break;
                    case kiTM2TeXBeginSuperscriptInput:
                        result = kiTM2TeXShortSuperscriptInput;
                    break;
                    case kiTM2TeXBeginSubscriptInput:
                        result = kiTM2TeXShortSubscriptInput;
                    break;
                    case kiTM2TeXCommentInput:
                    case kiTM2TeXMarkInput:
                        result = previousMode;
                    break;
                    case kiTM2TeXBeginCommentInput:
                        result = kiTM2TeXCommentInput;
                    break;
                    case kiTM2TeXInputInput:
                        result = kiTM2TeXErrorInput;
                    break;
                    default:
                        result = kiTM2TeXRegularInput;
                }
//NSLog(@"mode returned: %u", result);
                if([_AS character: theChar isMemberOfCoveredCharacterSetForMode: [_iTM2TeXModeForModeArray objectAtIndex: result & ~kiTM2TeXErrorsMask]])
                    return result | (previousMode & kiTM2TeXErrorsMask);
                else
				{
//iTM2_LOG(@"AN ERROR OCCURRED");
                    return result | kiTM2TeXErrorInputMask;
				}
            }
        }
    }
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForLocation:previousMode:effectiveLength:nextModeIn:before:
- (NSUInteger) syntaxModeForLocation: (NSUInteger) location previousMode: (NSUInteger) previousMode effectiveLength: (NSUInteger *) lengthRef nextModeIn: (NSUInteger *) nextModeRef before: (NSUInteger) beforeIndex;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [_TextStorage string];
    if(location<[S length])
    {
		if(previousMode == kiTM2TeXBeginCommandInput)
		{
			NSUInteger start = location;
			NSUInteger end = start;
			while(end<[S length] && [[NSCharacterSet iTM2_TeXLetterCharacterSet] characterIsMember: [S characterAtIndex: end]])
				++end;
			if(end == start+5)
			{
				if([@"input" isEqual: [S substringWithRange: NSMakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<[S length]))
					{
						* nextModeRef = [self syntaxModeForCharacter: [S characterAtIndex: end] previousMode: kiTM2TeXInputInput];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector: @selector(invalidateCursorRects) withObject: nil afterDelay: 0.01];
					return kiTM2TeXInputInput;
				}
			}
			if(lengthRef)
				* lengthRef = end - start;
			if(nextModeRef && (end<[S length]))
			{
				* nextModeRef = [self syntaxModeForCharacter: [S characterAtIndex: end] previousMode: kiTM2TeXCommandInput];
			}
			return kiTM2TeXCommandInput;
		}
		else if(lengthRef)
		{
			* lengthRef = 1;
			NSUInteger nextMode = [self syntaxModeForCharacter: [S characterAtIndex: location] previousMode: previousMode];
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length: 1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
			beforeIndex = MIN(beforeIndex, [S length]);
			while(++location < beforeIndex)
			{
				previousMode = nextMode;
				nextMode = [self syntaxModeForCharacter: [S characterAtIndex: location] previousMode: previousMode];
//NSLog(@"2: nextMode: %u, previousMode: %u", nextMode, previousMode);
				if(nextMode == previousMode)
					* lengthRef += 1;
				else if(previousMode == kiTM2TeXBeginCommandInput)
				{
					if(nextModeRef)
					{
						NSUInteger start = location;
						NSUInteger end = start;
						while(end<[S length] && [[NSCharacterSet iTM2_TeXLetterCharacterSet] characterIsMember: [S characterAtIndex: end]])
							++end;
						if((end == start+5) && ([@"input" isEqual: [S substringWithRange: NSMakeRange(start, end - start)]]))
							* nextModeRef = kiTM2TeXInputInput;
						else
							* nextModeRef = nextMode;
					}
					return previousMode;
				}
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
			NSUInteger nextMode = [self syntaxModeForCharacter: [S characterAtIndex: location] previousMode: previousMode];
//NSLog(@"nextMode: %u, previousMode: %u", nextMode, previousMode);
			return nextMode;
		}
    }
    else
    {
//iTM2_LOG(@"location: %i <=  [S length] %i", location, [S length]);
        if(lengthRef)
            * lengthRef = 0;
        return [self EOLModeForPreviousMode: previousMode];
    }
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForLocation:previousMode:effectiveLength:nextModeIn:before:
- (NSUInteger) syntaxModeForLocation: (NSUInteger) location previousMode: (NSUInteger) previousMode effectiveLength: (NSUInteger *) lengthRef nextModeIn: (NSUInteger *) nextModeRef before: (NSUInteger) beforeIndex;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
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
            NSUInteger nextMode = [self syntaxModeForCharacter: [S characterAtIndex: location] previousMode: previousMode];
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length: 1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
            beforeIndex = MIN(beforeIndex, [S length]);
            while(++location < beforeIndex)
            {
                previousMode = nextMode;
                nextMode = [self syntaxModeForCharacter: [S characterAtIndex: location] previousMode: previousMode];
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
            NSUInteger nextMode = [self syntaxModeForCharacter: [[_TextStorage string] characterAtIndex: location] previousMode: previousMode];
//NSLog(@"nextMode: %u, previousMode: %u", nextMode, previousMode);
            return nextMode;
        }
    }
    else
    {
//iTM2_LOG(@"location: %i <=  [S length] %i", location, [S length]);
        if(lengthRef)
            * lengthRef = 0;
        return [self EOLModeForPreviousMode: previousMode];
    }
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLModeForPreviousMode:
- (NSUInteger) EOLModeForPreviousMode: (NSUInteger) previousMode;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Character: %@", [NSString stringWithCharacters: &argument length: 1]);
//NSLog(@"previousMode: %u", previousMode);
//NSLog(@"result: %u", previousMode-1);
    return 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *) attributesAtIndex: (NSUInteger) aLocation effectiveRange: (NSRangePointer) aRangePtr;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSUInteger mode = [self syntaxModeAtIndex: aLocation longestRange: aRangePtr];
	NSUInteger switcher = mode & ~kiTM2TeXErrorsMask;
    switch(switcher)
    {
        case kiTM2TeXRegularInput:
        case kiTM2TeXCommandInput:
        case kiTM2TeXCommentInput:
        case kiTM2TeXMarkInput:
        case kiTM2TeXDollarInput:
        case kiTM2TeXDelimiterInput:
        case kiTM2TeXSubscriptInput:
        case kiTM2TeXBeginGroupInput:
        case kiTM2TeXEndGroupInput:
        case kiTM2TeXBeginSubscriptInput:
        case kiTM2TeXShortSubscriptInput:
        case kiTM2TeXSuperscriptInput:
        case kiTM2TeXBeginSuperscriptInput:
        case kiTM2TeXShortSuperscriptInput:
        case kiTM2TeXInputInput:
        case kiTM2TeXErrorInput:
        case kiTM2TeXShortCommandInput:
        case kiTM2TeXBeginCommandInput:
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: switcher]];
        case kiTM2TeXBeginCommentInput:
        {
            NSUInteger lineIndex = [self lineIndexForLocation: aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex: lineIndex];
            NSUInteger endOffset = [ML startOffset] + [ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset - aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex: aLocation effectiveRange: nil];
            else
                return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXCommentInput]];
        }
        default:
            iTM2_LOG(@"Someone is asking for mode: %u (%u)", mode, switcher);
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXErrorInput]];
    }
}
@end

@implementation iTM2XtdTeXParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *) syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens@users.sourceforge.net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"TeX-Xtd";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *) attributesAtIndex: (NSUInteger) aLocation effectiveRange: (NSRangePointer) aRangePtr;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange r;
    NSUInteger mode = [self syntaxModeAtIndex: aLocation longestRange: &r];
#if 0
    if(mode & kiTM2TeXErrorInputMask)
    {
        if(aRangePtr)
        {
            aRangePtr -> location = aLocation;
            aRangePtr -> length = 1;
        }
        return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXErrorInput]];
    }
#endif
    if(aRangePtr)
            *aRangePtr = r;
	NSUInteger switcher = mode & ~kiTM2TeXErrorsMask;
    switch(switcher)
    {
        case kiTM2TeXRegularInput:
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: switcher]];
        case kiTM2TeXBeginCommandInput:
        {
            if(++aLocation < [_TextStorage length])
            {
                NSRange r1;
                int nextMode = [self syntaxModeAtIndex: aLocation longestRange: &r1] & ~kiTM2TeXErrorsMask;
                if((kiTM2TeXCommandInput == nextMode) || (kiTM2TeXShortCommandInput == nextMode) || (kiTM2TeXInputInput == nextMode))
                {
					--r1.location;
					++r1.length;
					NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r1]];
                    if(aRangePtr)
						*aRangePtr = r1;
                    if(D)
                        return D;
                }
            }
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXCommandInput]];
        }
        case kiTM2TeXBeginGroupInput:
        case kiTM2TeXEndGroupInput:
        case kiTM2TeXCommentInput:
        case kiTM2TeXMarkInput:
        case kiTM2TeXDollarInput:
        case kiTM2TeXDelimiterInput:
        case kiTM2TeXSuperscriptInput:
        case kiTM2TeXSubscriptInput:
        case kiTM2TeXInputInput:
        case kiTM2TeXErrorInput:
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: switcher]];
        case kiTM2TeXCommandInput:
        {
            if(r.location)
            {
				--r.location;
				++r.length;
				aLocation = NSMaxRange(r);
				if(aLocation+2<[_TextStorage length])
				{
					if(([[_TextStorage string] characterAtIndex: aLocation] == '{')
						&&([[_TextStorage string] characterAtIndex: aLocation+2] == '}'))
					{
						NSRange r1 = NSMakeRange(r.location, r.length + 3);
						NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r1]];
						if(D)
						{
							if(aRangePtr)
								*aRangePtr = r1;
							return D;
						}
					}
				}
				NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r]];
				if(aRangePtr)
					*aRangePtr = r;
				if(D)
					return D;
            }
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXCommandInput]];
        }
        case kiTM2TeXShortCommandInput:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                NSRange r = NSMakeRange(aLocation-1, 2);
				++aLocation;
				if(aLocation+2<[_TextStorage length])
				{
					if(([[_TextStorage string] characterAtIndex: aLocation] == '{')
						&&([[_TextStorage string] characterAtIndex: aLocation+2] == '}'))
					{
						NSRange r1 = NSMakeRange(r.location, r.length + 3);
						NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r1]];
						if(D)
						{
							if(aRangePtr)
								*aRangePtr = r1;
							return D;
						}
					}
				}
                NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r]];
                if(aRangePtr)
					*aRangePtr = r;
                if(D)
                    return D;
            }
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXCommandInput]];
        }
        case kiTM2TeXShortSuperscriptInput:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                NSRange r = NSMakeRange(aLocation - 1, 2);
                NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r]];
                if(aRangePtr)
					*aRangePtr = r;
                if(D)
                    return D;
            }
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: mode]];
        }
        case kiTM2TeXBeginSuperscriptInput:
        {
            if(++aLocation < [_TextStorage length])
            {
                NSRange r1;
                int nextMode = [self syntaxModeAtIndex: aLocation longestRange: &r1] & ~kiTM2TeXErrorsMask;
                if(kiTM2TeXShortSuperscriptInput == nextMode)
                {
                    --r1.location;
                    ++r1.length;
                    NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r1]];
                    if(aRangePtr)
                         *aRangePtr = r1;
                    if(D)
                        return D;
                }
            }
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: switcher]];
        }
        case kiTM2TeXShortSubscriptInput:
        {
            if(aLocation && aLocation < [_TextStorage length])
            {
                NSRange r = NSMakeRange(aLocation - 1, 2);
                NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r]];
                if(aRangePtr)
					*aRangePtr = r;
                if(D)
                    return D;
            }
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: switcher]];
        }
        case kiTM2TeXBeginSubscriptInput:
        {
            if(++aLocation < [_TextStorage length])
            {
                NSRange r1;
                if(kiTM2TeXShortSubscriptInput == [self syntaxModeAtIndex: aLocation longestRange: &r1])
                {
                    --r1.location;
                    ++r1.length;
                    NSDictionary * D = [_AS attributesForSymbol: [[_TextStorage string] substringWithRange: r1]];
                    if(aRangePtr)
                         *aRangePtr = r1;
                    if(D)
                        return D;
                }
            }
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: switcher]];
        }
        case kiTM2TeXBeginCommentInput:
        {
            NSUInteger lineIndex = [self lineIndexForLocation: aLocation];
            iTM2ModeLine * ML = [self modeLineAtIndex: lineIndex];
            NSUInteger endOffset = [ML startOffset] + [ML contentsLength];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, endOffset - aLocation);
            if(++aLocation < endOffset)
                return [self attributesAtIndex: aLocation effectiveRange: nil];
            else
                return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXCommentInput]];
        }
        default:
            iTM2_LOG(@"Someone is asking for mode: %u", switcher);
            return [_AS attributesForMode: [_iTM2TeXModeForModeArray objectAtIndex: kiTM2TeXErrorInput]];
    }
}
@end

@implementation NSCharacterSet(iTM2TeXStorageKit)
static id _iTM2TextPTeXLetterCharacterSet = nil;
static id _iTM2TextPTeXFileNameLetterCharacterSet = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void) load;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
    if(!_iTM2TextPTeXLetterCharacterSet)
    {
        id set = [[[NSCharacterSet characterSetWithRange: NSMakeRange('a', 26)] mutableCopy] autorelease];
        [set addCharactersInRange: NSMakeRange('A', 26)];
        [set addCharactersInString: @"@"];
        _iTM2TextPTeXLetterCharacterSet = [set copy];
    }
    if(!_iTM2TextPTeXFileNameLetterCharacterSet)
    {
        id set = [[_iTM2TextPTeXLetterCharacterSet mutableCopy] autorelease];
        [set addCharactersInRange: NSMakeRange('A', 26)];
        [set addCharactersInString: @"_$^0123456789.-+*()[]/"];
        _iTM2TextPTeXFileNameLetterCharacterSet = [set copy];
    }
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2_TeXLetterCharacterSet;
+ (NSCharacterSet *) iTM2_TeXLetterCharacterSet;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2TextPTeXLetterCharacterSet;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2_TeXFileNameLetterCharacterSet;
+ (NSCharacterSet *) iTM2_TeXFileNameLetterCharacterSet;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2TextPTeXFileNameLetterCharacterSet;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextAttributesKit
