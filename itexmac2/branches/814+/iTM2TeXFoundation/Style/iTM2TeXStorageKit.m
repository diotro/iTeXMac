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

NSString * const iTM2TextAttributesRegExComponent = @"regex";
NSString * const iTM2TextAttributesDraftSymbolsExtension = @"DraftSymbols";
NSString * const iTM2Text2ndSymbolColorAttributeName = @"iTM2Text2ndSymbolColorAttribute";
NSString * const iTM2TextAttributesCharacterAttributeName = @"iTM2Character";

#define _TextStorage (iTM2TextStorage *)iVarTS4iTM3

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
NSString * const iTM2TeXAccentSyntaxModeName = @"\\'{}";
NSString * const iTM2TeXPlaceholderDelimiterSyntaxModeName = @"__()__";

NSString * const iTM2TeXCommandInputSyntaxModeName = @"\\input";

#undef ATTRIBUTE_ASSERT4iTM3
#define ATTRIBUTE_ASSERT4iTM3(CONDITION,REASON) if(iTM2DebugEnabled>99&&!(CONDITION)) {ERROR=REASON;goto returnERROR;}

static NSArray * _iTM2TeXModeForModeArray = nil;

@implementation iTM2TeXParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"TeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModesAttributes
+ (NSDictionary *)defaultModesAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
        [NSColor colorWithCalibratedRed:0 green:0 blue:0.75 alpha:1], NSForegroundColorAttributeName,
		iTM2TeXAccentSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];
	attributes = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor colorWithCalibratedRed:0.95 green:0.15 blue:0.15 alpha:0.5], NSForegroundColorAttributeName,
		iTM2TeXPlaceholderDelimiterSyntaxModeName,iTM2TextModeAttributeName,
            nil];
	[MRA addObject:attributes];

    NSMutableDictionary * MD = [[[super defaultModesAttributes] mutableCopy] autorelease];
	for(attributes in MRA)
	{
		NSString * key = [attributes objectForKey:iTM2TextModeAttributeName];
		[MD setObject:attributes forKey:key];
	}
    return [NSDictionary dictionaryWithDictionary:MD];
}
#pragma mark iTM2TeXStorageAttributes.m without Symbols
#undef WITH_SYMBOLS4iTM3
#include "iTM2TeXStorageAttributes.m"
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink4iTM3:atIndex:
- (BOOL)didClickOnLink4iTM3:(id)link atIndex:(NSUInteger)charIndex;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTextStorage * TS = self.textStorage;
    iTM2StringController * SC = self.stringController4iTM3;
	NSRange R = [SC TeXAwareWordRangeInAttributedString:TS atIndex:charIndex];
	if (R.length>1) {
		NSString * S = [TS string];
		NSString * command = [S substringWithRange:R];
		if ([command isEqualToString:iTM2TeXCommandInputSyntaxModeName]) {
			NSUInteger start = iTM3MaxRange(R);
			if (start < S.length) {
				NSUInteger contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					iTM3MakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
				NSScanner * scanner = [NSScanner scannerWithString:string];
				[scanner scanString:@"{" intoString:nil];
				NSString * fileName;
				if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &fileName])
				{
					if(![fileName hasPrefix:@"/"])
					{
						fileName = [[[[[[[[[TS layoutManagers] lastObject] textContainers] lastObject] textView] window] windowController] document] fileName];
						fileName = fileName.stringByDeletingLastPathComponent;
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
							LOG4iTM3(@"INFO: could not open file <%@>", newFileName);
						}				
					}
				}
				else
				{
					LOG4iTM3(@"..........  TeX SYNTAX ERROR: nothing to input");
				}
			}
			return YES;
		}
	}
//END4iTM3;
	return [super didClickOnLink4iTM3:link atIndex:charIndex];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"TeX-Xtd";
}
#pragma mark iTM2TeXStorageAttributes.m with Symbols
#define WITH_SYMBOLS4iTM3
#include "iTM2TeXStorageAttributes.m"
@end

static id _iTM2TeXPTeXLetterCharacterSet = nil;
static id _iTM2TeXPTeXFileNameLetterCharacterSet = nil;

@implementation NSCharacterSet(iTM2TeXStorageKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  TeXLetterCharacterSet4iTM3;
+ (NSCharacterSet *)TeXLetterCharacterSet4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTM2TeXPTeXLetterCharacterSet;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  TeXFileNameLetterCharacterSet4iTM3;
+ (NSCharacterSet *)TeXFileNameLetterCharacterSet4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    variant = [variant lowercaseString];
    if(self = [super initWithVariant:variant])
    {
        self.symbolsAttributes = [NSMutableDictionary dictionary];
        self.regExAttributes = [NSMutableDictionary dictionary];
        self.cachedSymbolsAttributes = [NSMutableDictionary dictionary];
        [self loadSymbolsAttributesWithVariant:variant];
    }
//END4iTM3;
    return self;
}
#pragma mark =-=-=-=-=-  ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAttributes:forMode:
- (void)setAttributes:(NSDictionary *)dictionary forMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super setAttributes: (NSDictionary *) dictionary forMode: (NSString *) mode];
    if([mode isEqualToString:iTM2TeXCommandSyntaxModeName])
    {
        self.cachedSymbolsAttributes = [NSMutableDictionary dictionary];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super attributesDidChange];
    // built in attributes are not expected to change!!!
    // just load ther other attributes
    self.symbolsAttributes = [NSMutableDictionary dictionary];
    self.cachedSymbolsAttributes = [NSMutableDictionary dictionary];
    [self loadSymbolsAttributesWithVariant:self.syntaxParserVariant];
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  SYMBOLS ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesForSymbol:mode:
- (NSDictionary *)attributesForSymbol:(NSString *)symbol mode:(NSString *)modeName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(!symbol.length)
		return nil;
    NSDictionary * symbolAttributes = [self.cachedSymbolsAttributes objectForKey:symbol];
    if(symbolAttributes)
        return [symbolAttributes isKindOfClass:[NSDictionary class]]?symbolAttributes:nil;
    symbolAttributes = [self.symbolsAttributes objectForKey:symbol];
    if(symbolAttributes)
    {
        id attributes = nil;
		if(modeName.length)
		{
			attributes = [self attributesForMode:modeName];
		}
		if(!attributes)
		{
			attributes = [self attributesForMode:iTM2TeXCommandSyntaxModeName];
		}
        NSColor * commandColor = [attributes objectForKey:NSForegroundColorAttributeName];
		attributes = [NSMutableDictionary dictionaryWithDictionary:attributes];// If the command attributes are good...
		[attributes addEntriesFromDictionary:symbolAttributes];
        if(commandColor)
        {
            NSColor * symbolColor = [symbolAttributes objectForKey:iTM2Text2ndSymbolColorAttributeName];
            if(iTM2DebugEnabled > 999999 && !symbolColor)
            {
                LOG4iTM3(@"no 2nd color for symbol: %@", symbol);
            }
            NSColor * replacementColor = symbolColor && [symbolColor alphaComponent]>0?
                [[symbolColor colorWithAlphaComponent:1] blendedColorWithFraction:1-[symbolColor alphaComponent]
                                    ofColor: commandColor]:
                    commandColor;
            [attributes setObject:replacementColor forKey:NSForegroundColorAttributeName];
        }
		[self.cachedSymbolsAttributes setObject:[NSDictionary dictionaryWithDictionary:attributes] forKey:symbol];
		return [self.cachedSymbolsAttributes objectForKey:symbol];
    }
	[self.cachedSymbolsAttributes setObject:[NSNull null] forKey:symbol];
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadSymbolsAttributesWithVariant:
- (void)loadSymbolsAttributesWithVariant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"variant is: %@", variant);
	NSString * variantComponent = [iTM2TextDefaultVariant stringByAppendingPathExtension:iTM2TextVariantExtension];
	NSURL * url;
    BOOL isDir = NO;
	for (url in [self.class builtInStyleURLs]) {
		url = [[url URLByAppendingPathComponent:variantComponent] URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
		if(url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory: &isDir] && isDir) {
			[self loadSymbolsAttributesAtURL:url];
		}
	}
    variant = [variant lowercaseString];
	variantComponent = [variant stringByAppendingPathExtension:iTM2TextVariantExtension];
    if(![iTM2TextDefaultVariant isEqualToString:variant])
	{
		for(url in [self.class builtInStyleURLs]) {
            url = [[url URLByAppendingPathComponent:variantComponent] URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
            if(url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory: &isDir] && isDir) {
                [self loadSymbolsAttributesAtURL:url];
            }
        }
	}
	for(url in [self.class otherStyleURLs]) {
		url = [[url URLByAppendingPathComponent:variantComponent] URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
		if(url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory: &isDir] && isDir) {
			[self loadSymbolsAttributesAtURL:url];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  regexAttributesWithContentsOfURL:
+ (NSDictionary *)regexAttributesWithContentsOfURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"fileName is: %@", fileName);
	// is it a regex file I am reading?
	NSString * coreBaseName = fileURL.lastPathComponent.stringByDeletingPathExtension;
	if(![coreBaseName isEqual:iTM2TextAttributesRegExComponent]) {
		return [NSDictionary dictionary];
	}
    NSData * D = [NSData dataWithContentsOfURL:fileURL];
    if(D.length) {
		NSError * error = nil;
		NSTextStorage * TS = [[[NSTextStorage alloc] initWithData:D options:nil documentAttributes:nil error:&error] autorelease];
		if(error) {
			NSLog(@"%@",error);
		}
		NSLayoutManager * LM = [[[NSLayoutManager alloc] init] autorelease];
		[TS addLayoutManager:LM]; 
		NSMutableDictionary * result = [NSMutableDictionary dictionary];
		NSString * S = [TS string];
		NSUInteger start = ZER0, contentsEnd;
		NSRange R = iTM3MakeRange(ZER0,ZER0);
		while (start<S.length) {
			[S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
			if((contentsEnd-start>2) && ([S characterAtIndex:start+1]=='=')) {
				NSMutableDictionary * attributes = [[[TS attributesAtIndex:start effectiveRange:nil] mutableCopy] autorelease];
				NSFont * font = [attributes objectForKey:NSFontAttributeName];
				if(font)
				{
					NSString * command = [S substringWithRange:iTM3MakeRange(start+2, contentsEnd-start-2)];
					NSString * character = [S substringWithRange:iTM3MakeRange(start,1)];
					[attributes setObject:character forKey:iTM2TextAttributesCharacterAttributeName];
					NSRange charRange = iTM3MakeRange(start,1);
					NSRange glyphRange = [LM glyphRangeForCharacterRange:charRange actualCharacterRange:nil];
					NSGlyph glyph = [LM glyphAtIndex:glyphRange.location];
					NSGlyphInfo * GI = [NSGlyphInfo glyphInfoWithGlyph:glyph forFont:font baseString:command];
					[attributes setObject:GI forKey:NSGlyphInfoAttributeName];
					ICURegEx * RE = [ICURegEx regExWithSearchPattern:command error:NULL];
					if(RE) {
						command = (id)RE;
					}
					[result setObject:attributes forKey:command];
				}
			}
			start = R.location;
		}
		return result;
    }
    return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  symbolsAttributesWithContentsOfURL:
+ (NSDictionary *)symbolsAttributesWithContentsOfURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"fileName is: %@", fileName);
	NSString * coreBaseName = fileURL.lastPathComponent.stringByDeletingPathExtension;
	if([coreBaseName isEqual:iTM2TextAttributesModesComponent]) {
		return nil;
	}
    NSData * D = [NSData dataWithContentsOfURL:fileURL];
    if(D.length) {
		NSError * error = nil;
		NSTextStorage * TS = [[[NSTextStorage alloc] initWithData:D options:nil documentAttributes:nil error:&error] autorelease];
		if(error) {
			NSLog(@"%@",error);
		}
		NSLayoutManager * LM = [[[NSLayoutManager alloc] init] autorelease];
		[TS addLayoutManager:LM]; 
		NSMutableDictionary * result = [NSMutableDictionary dictionary];
		NSString * S = [TS string];
		NSUInteger start = ZER0, contentsEnd;
		NSRange R = iTM3MakeRange(ZER0,ZER0);
		while (start<S.length) {
			[S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
			if ((contentsEnd-start>2) && ([S characterAtIndex:start+1]=='=')) {
				NSMutableDictionary * attributes = [[[TS attributesAtIndex:start effectiveRange:nil] mutableCopy] autorelease];
				NSFont * font = [attributes objectForKey:NSFontAttributeName];
				if(font) {
					NSString * command = [S substringWithRange:iTM3MakeRange(start+2, contentsEnd-start-2)];
					NSString * character = [S substringWithRange:iTM3MakeRange(start,1)];
					[attributes setObject:character forKey:iTM2TextAttributesCharacterAttributeName];
					NSRange charRange = iTM3MakeRange(start,1);
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadSymbolsAttributesAtURL:
- (void)loadSymbolsAttributesAtURL:(NSURL *)styleURL;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List: NYI
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"stylePath: %@", stylePath);
    NSParameterAssert(styleURL);
    for(NSURL * url in [DFM contentsOfDirectoryAtURL:styleURL includingPropertiesForKeys:[NSArray array] options:ZER0 error:NULL]) {
        if([url.pathExtension isEqualToFileName4iTM3:iTM2TextAttributesPathExtension]) {
            NSDictionary * attributes = nil;
			if([url.lastPathComponent isEqualToFileName4iTM3:[iTM2TextAttributesModesComponent stringByAppendingPathExtension:iTM2TextAttributesPathExtension]]) {
				// do nothing, this is the modes.rtf
			} else if ([url.lastPathComponent isEqual:[iTM2TextAttributesRegExComponent stringByAppendingPathExtension:iTM2TextAttributesPathExtension]]) {
				self.cachedSymbolsAttributes = [NSMutableDictionary dictionary];
				attributes = [self.class regexAttributesWithContentsOfURL:url];
				if(iTM2DebugEnabled > 1000) {
					LOG4iTM3(@"We have loaded regex attributes at: %@", url);
					NSMutableSet * set1 = [NSMutableSet setWithArray:[self.regExAttributes allKeys]];
					NSSet * set2 = [NSSet setWithArray:[attributes allKeys]];
					[set1 intersectSet:set2];
                    LOG4iTM3(@"The overriden keys are: %@", set1);
				}
				[self.regExAttributes addEntriesFromDictionary:attributes];
			} else {
				self.cachedSymbolsAttributes = [NSMutableDictionary dictionary];
				if(attributes = [self.class symbolsAttributesWithContentsOfURL:url]) {
					if(iTM2DebugEnabled > 1000) {
						LOG4iTM3(@"We have loaded symbols attributes at url: %@", url);
						NSMutableSet * set1 = [NSMutableSet setWithArray:[self.symbolsAttributes allKeys]];
						NSSet * set2 = [NSSet setWithArray:[attributes allKeys]];
						[set1 intersectSet:set2];
						 LOG4iTM3(@"The overriden keys are: %@", set1);
					}
					[self.symbolsAttributes addEntriesFromDictionary:attributes];
				}
			}
		}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSymbolsAttributes:toURL:
+ (BOOL)writeSymbolsAttributes:(NSDictionary *)dictionary toURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableAttributedString * MAS =
		[[[NSMutableAttributedString alloc] initWithString:@"% iTeXMac2 style symbols file\n% each line is 'c=\\command'\n"] autorelease];
	for (NSString * command in dictionary.keyEnumerator) {
		NSMutableDictionary * attributes = [[[dictionary objectForKey:command] mutableCopy] autorelease];
		NSString * S = [attributes objectForKey:iTM2TextAttributesCharacterAttributeName];
		NSAttributedString * AS = [[[NSAttributedString alloc] initWithString:S attributes:attributes] autorelease];
		[MAS appendAttributedString:AS];
		S = [NSString stringWithFormat:@"=%@\n",command];
		AS = [[[NSAttributedString alloc] initWithString:S] autorelease];
		[MAS appendAttributedString:AS];
	}
	NSData * data = [MAS dataFromRange:iTM3MakeRange(ZER0,MAS.length) documentAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
		NSRTFTextDocumentType, NSDocumentTypeDocumentAttribute, nil] error:nil];
//END4iTM3;
	return [data writeToURL:fileURL options:NSAtomicWrite error:nil];
}
@synthesize symbolsAttributes=_SymbolsAttributes;
@synthesize regExAttributes=_RegExAttributes;
@synthesize cachedSymbolsAttributes=_CachedSymbolsAttributes;
@end

@implementation iTM2MainInstaller(TeXStorageKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXStorageCompleteInstallation4iTM3
+ (void)iTM2TeXStorageCompleteInstallation4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2: Mon Jun  7 21:48:56 GMT 2004
 To Do List: Nothing
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[iTM2TeXParser class];
	[iTM2XtdTeXParser class];
    if(!_iTM2TeXPTeXLetterCharacterSet)
    {
        id set = [[[NSCharacterSet characterSetWithRange:iTM3MakeRange('a', 26)] mutableCopy] autorelease];
        [set addCharactersInRange:iTM3MakeRange('A', 26)];
		//        [set addCharactersInString:@"@"];
        _iTM2TeXPTeXLetterCharacterSet = [set copy];
    }
    if(!_iTM2TeXPTeXFileNameLetterCharacterSet)
    {
        _iTM2TeXPTeXFileNameLetterCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@".,;\\+-*[]=_/:0123456789"];
		[_iTM2TeXPTeXFileNameLetterCharacterSet formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
		_iTM2TeXPTeXFileNameLetterCharacterSet = [_iTM2TeXPTeXFileNameLetterCharacterSet copy];
    }
    if(!_iTM2TeXModeForModeArray)
	{
        _iTM2TeXModeForModeArray = [NSArray arrayWithObjects:
									iTM2TextErrorSyntaxModeName, iTM2TextWhitePrefixSyntaxModeName, iTM2TextDefaultSyntaxModeName,// +3
									iTM2TeXCommandSyntaxModeName,iTM2TeXCommandSyntaxModeName,iTM2TeXCommandSyntaxModeName,iTM2TeXCommandSyntaxModeName, // +4
									iTM2TeXCommentSyntaxModeName,iTM2TeXCommentSyntaxModeName,iTM2TeXMarkSyntaxModeName,iTM2TeXMarkSyntaxModeName,// +4
									iTM2TeXGroupSyntaxModeName, iTM2TeXGroupSyntaxModeName, iTM2TeXParenSyntaxModeName, iTM2TeXParenSyntaxModeName, iTM2TeXBracketSyntaxModeName, iTM2TeXBracketSyntaxModeName, // +6
									iTM2TeXMathToggleSyntaxModeName,iTM2TeXMathDisplayToggleSyntaxModeName,iTM2TeXMathInlineSwitchSyntaxModeName,iTM2TeXMathInlineSwitchSyntaxModeName,iTM2TeXMathDisplaySwitchSyntaxModeName,iTM2TeXMathDisplaySwitchSyntaxModeName,// +6
									iTM2TeXSubSyntaxModeName, iTM2TeXSubShortSyntaxModeName, iTM2TeXSubLongSyntaxModeName,// +3
									iTM2TeXSuperSyntaxModeName, iTM2TeXSuperContinueSyntaxModeName, iTM2TeXSuperShortSyntaxModeName, iTM2TeXSuperLongSyntaxModeName,// +4
									iTM2TeXAmpersandSyntaxModeName,// +1
									iTM2TeXAccentSyntaxModeName,// +1
									iTM2TeXPlaceholderDelimiterSyntaxModeName,// +1
									nil];
	}
	//END4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXStorageKit
