/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Nov 10 2001.
//  Copyright © 2001-2005 Laurens'Tribune. All rights reserved.
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

#import "iTM2BundleKit.h"
#import "iTM2ContextKit.h"
#import "ICURegEx.h"
#import "iTM2NotificationKit.h"
#import "iTM2StringKit.h"
#import "iTM2MenuKit.h"
#import "iTM2TextKit.h"
#import "iTM2TextDocumentKit.h"
#import "iTM2StringFormatKit.h"

// This file must live with iTM2TextDocumentKit

#define TABLE @"Basic"
#define BUNDLE [iTM2StringFormatController classBundle4iTM3]

NSString * const iTM2EOLPreferredKey = @"iTM2EOLPreferred";
NSString * const iTM2StringEncodingIsAutoKey = @"iTM2StringEncodingIsAuto";
NSString * const iTM2StringEncodingIsHardCodedKey = @"iTM2StringEncodingIsHardCoded";
NSString * const iTM2StringEncodingPreferredKey = @"iTM2StringEncodingPreferred";
NSString * const iTM2StringEncodingOpenKey = @"iTM2StringEncodingOpen";

NSString * const iTM2StringEncodingHeaderKey = @"charset";
NSString * const iTM2CharacterStringEncodingKey = @"CharacterEncoding";// COCOA STUFF

NSString * const TWSStringEncodingFileKey = @"codeset";
NSString * const TWSEOLFileKey = @"eol";

NSString * const iTM2StringEncodingListDidChangeNotification = @"iTM2StringEncodingListDidChange";
NSString * const iTM2StringEncodingsPListName = @"StringEncodings";
NSString * const iTM2StringEncodingsTypeName = @"String Encodings";

NSString * iTM2StringEncodingMissingFormat = nil;
NSString * iTM2StringEncodingDefaultFormat = nil;
NSString * iTM2EOLDefaultFormat = nil;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringFormatController
/*"To control and manage the file encoding and the line endings."*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTM2StringFormatController)
/*"Description forthcoming."*/

@interface NSString(PRIVATE_DE_CHEZ_PRIVATE)
- (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr TeXComment:(NSUInteger *)commentPtr forIndex:(NSUInteger) index;
@end

@implementation NSString(iTM2StringFormatController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameOfStringEncoding4iTM3:
+ (NSString *)nameOfStringEncoding4iTM3:(NSStringEncoding)encoding;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	encoding = CFStringConvertNSStringEncodingToEncoding(encoding);
//END4iTM3;
	return (NSString *)CFStringConvertEncodingToIANACharSetName(encoding);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingWithName4iTM3:
+ (NSStringEncoding)stringEncodingWithName4iTM3:(NSString *)name;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	CFStringEncoding encoding = [iTM2StringFormatController coreFoundationStringEncodingWithName:name];
//END4iTM3;
	return CFStringConvertEncodingToNSStringEncoding(encoding);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localizedNameOfEOL4iTM3:
+ (NSString *)localizedNameOfEOL4iTM3:(iTM2EOL)LE;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch(LE)
    {
        case 0: return @"None";
        case iTM2UNIXEOL: return NSLocalizedStringFromTableInBundle(@"Use UNIX Line Endings (LF)", TABLE,
            BUNDLE, "Title of line endings menu item");
        case iTM2MacintoshEOL: return NSLocalizedStringFromTableInBundle(@"Use Mac Line Endings (CR)", TABLE,
            BUNDLE, "Title of line endings menu item");
        case iTM2WindowsEOL: return NSLocalizedStringFromTableInBundle(@"Use Windows Line Endings (CR+LF)", TABLE,
            BUNDLE, "Title of line endings menu item");
        default: return NSLocalizedStringFromTableInBundle(@"Unknown Line Endings Used", TABLE,
            BUNDLE, "Title of line endings menu item");
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringByUsingEOL4iTM3:
- (NSString *)stringByUsingEOL4iTM3:(iTM2EOL)EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * EOLString = [iTM2StringFormatController terminationStringForEOL:EOL];
    NSMutableString * MS = [NSMutableString string];
    NSRange r = iTM3MakeRange(ZER0,ZER0);
    NSUInteger end = ZER0, contentsEnd = ZER0, ceiling = self.length, nextStart = ZER0;
    NSUInteger corrected = ZER0, total = ZER0;
//NSLog(@"GLS");
    while(end < ceiling)
    {
        [self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:r];
        if ((end>contentsEnd) &&
            ![[self substringWithRange:iTM3MakeRange(contentsEnd, end - contentsEnd)] isEqualToString:EOLString])
        {
            [MS appendString:[self substringWithRange:iTM3MakeRange(nextStart, contentsEnd - nextStart)]];
            [MS appendString:EOLString];
            nextStart = end;
            ++corrected;
        }
        ++total;
        r.location = end;
    }
    NSLog(@"line endings corrected: %d of %d", corrected, total);
    if (!nextStart) // the original string used the good line endings
        return self;
    else if (nextStart < ceiling) // there is something left to be copied
        [MS appendString:[self substringWithRange:iTM3MakeRange(nextStart, ceiling - nextStart)]];
    return MS;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= EOLUsed4iTM3
- (iTM2EOL)EOLUsed4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"GLS");
    if (self.length)
    {
        NSUInteger contentsEnd, end;
        [self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:iTM3MakeRange(ZER0,ZER0)];
        if (end > contentsEnd)
        {
            NSString * EOL = [self substringWithRange:iTM3MakeRange(contentsEnd, end - contentsEnd)];
            if ([EOL isEqualToString:@"\r\n"])
                return iTM2WindowsEOL;
            else if ([EOL isEqualToString:@"\r"])
                return iTM2MacintoshEOL;
            else if ([EOL isEqualToString:@"\n"])
                return iTM2UNIXEOL;
#if 0
            else if (EOL.length == 1)
            {
                unichar theChar = [EOL characterAtIndex:ZER0];
                if ((theChar == 0x2028) || (theChar == 0x2029))
                    return iTM2UTF16EOL;
            }
#endif
            else
                return iTM2UnknownEOL;
        }
    }
    return iTM2UnchangedEOL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getHardCodedStringEncoding4iTM3:range:
- (void)getHardCodedStringEncoding4iTM3:(NSStringEncoding *)stringEncodingRef range:(NSRangePointer)rangeRef;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange R = iTM3NotFoundRange;
    NSString * headerStringEncodingName = @"";
	ICURegEx * RE = nil;
//NSLog(@"headerStringEncodingName: %@", headerStringEncodingName);
    NS_DURING
    RE = [ICURegEx regExForKey:@"encoding" inBundle:BUNDLE error:NULL];
    [RE setInputString:self];
//NSLog(@"ARE: %@", ARE);
    if ([RE matchString:self] && ([RE numberOfCaptureGroups] > ZER0)) {
        R = [RE rangeOfCaptureGroupAtIndex:1];
        headerStringEncodingName = [RE substringOfCaptureGroupWithName:@"encoding"];
    }
//NSLog(@"headerStringEncodingName: %@", headerStringEncodingName);
    NS_HANDLER
//NSLog(@"EXCEPTION");
    LOG4iTM3(@"*** Exception catched (1): %@", [localException reason]);
    headerStringEncodingName = @"";
    NS_ENDHANDLER
//NSLog(@"headerStringEncodingName: %@", headerStringEncodingName);
	if (stringEncodingRef) {
		* stringEncodingRef = [NSString stringEncodingWithName4iTM3:headerStringEncodingName];
	}
	if (rangeRef)
		* rangeRef = R;
    return;
}
@end

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"

@interface iTM2StringFormatController(LAZINESS)
- (NSStringEncoding)lazyStringEncoding;
- (NSUInteger)lazyEOL;
+ (void)completeInitialization;
@end

@implementation iTM2MainInstaller(StringFormatter)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StringFormatControllerCompleteInstallation4iTM3
+ (void)iTM2StringFormatControllerCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [iTM2StringFormatController completeInitialization];
//END4iTM3;
    return;
}
@end

@interface iTM2StringFormatController(PRIVATE)
+ (void)stringEncodingListDidChangeNotified:(NSNotification *)irrelevant;
@end

@implementation iTM2StringFormatController
@synthesize document = iVarDocument4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInitialization
+ (void)completeInitialization;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!iTM2StringEncodingMissingFormat)
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInteger:iTM2UNIXEOL], iTM2EOLPreferredKey,
					[NSNumber numberWithUnsignedInteger:NSMacOSRomanStringEncoding], iTM2StringEncodingPreferredKey,
					[NSNumber numberWithUnsignedInteger:NSMacOSRomanStringEncoding], iTM2StringEncodingOpenKey,
					[NSNumber numberWithUnsignedInteger:NSMacOSRomanStringEncoding], TWSStringEncodingFileKey,
					[NSNumber numberWithBool:YES], iTM2StringEncodingIsAutoKey,
								nil]];
		BOOL OK = YES;
		NSMenuItem * MI;
		NSString * proposal;
		NSMenu * m;
		MI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(stringEncodingMissingLocale:)];
		proposal = MI.title;
		if (!proposal.length || ([[proposal componentsSeparatedByString:@"%"] count] != 2)
			|| ([[proposal componentsSeparatedByString:@"%@"] count] != 2))
		{
			proposal = @"StringEncoding: %@";
			LOG4iTM3(@"Localization BUG, the menu item with action stringEncodingMissingLocale: in the main menu must exist and contain one %%@,\nand no other formating directive");
			OK = NO;
		}
		[iTM2StringEncodingMissingFormat autorelease];
		iTM2StringEncodingMissingFormat = [proposal copy];
		m = MI.menu;
		[m removeItem:MI];
		[m cleanSeparators4iTM3];
		MI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(stringEncodingDefault:)];
		proposal = MI.title;
		if (!proposal.length
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 2)
				|| ([[proposal componentsSeparatedByString:@"%@"] count] != 2))
		{
			proposal = @"Default: %@";
			LOG4iTM3(@"Localization BUG, the menu item with action stringEncodingDefault: in the main menu must exist and contain one %%@,\nand no other formating directive");
			OK = NO;
		}
		[iTM2StringEncodingDefaultFormat autorelease];
		iTM2StringEncodingDefaultFormat = [proposal copy];
		m = MI.menu;
		[m removeItem:MI];
		[m cleanSeparators4iTM3];
		MI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(EOLDefault:)];
		proposal = MI.title;
		if (!proposal.length || ([[proposal componentsSeparatedByString:@"%"] count] != 2) || ([[proposal componentsSeparatedByString:@"%@"] count] != 2))
		{
			proposal = @"Default: %@";
			LOG4iTM3(@"Localization BUG, the menu item with action EOLDefault: in the main menu must exist and contain one %%@,\nand no other formating directive");
			OK = NO;
		}
		if (OK)
		{
			MILESTONE4iTM3((@"iTM2StringFormatControllerLocalizedMenuItems"),(@"No Localized menu items available for iTM2StringFormatController"));
		}
		[iTM2EOLDefaultFormat autorelease];
		iTM2EOLDefaultFormat = [proposal copy];
		m = MI.menu;
		[m removeItem:MI];
		[m cleanSeparators4iTM3];
		[DDNC removeObserver:self];
		[DDNC addObserver:self
			selector:@selector(stringEncodingListDidChangeNotified:)
				name:iTM2StringEncodingListDidChangeNotification object:nil];
		[self stringEncodingListDidChangeNotified:nil];
	}		
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingListDidChangeNotified:
+ (void)stringEncodingListDidChangeNotified:(NSNotification *)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenuItem * stringEncodingMI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(stringEncodingEditList:)];
	stringEncodingMI.target = nil;
	NSMenu * M = stringEncodingMI.menu;
	// removing all the menu items with the stringEncodingSelect:
	NSEnumerator * E = [M.itemArray objectEnumerator];
	NSMenuItem * MI = nil;
	while(MI = [E nextObject])
		if (MI.action == @selector(takeStringEncodingFromTag:) && (!MI.target))
			[M removeItem:MI];
	// adding the string encoding menu items
	NSInteger index = [M indexOfItem:stringEncodingMI];
	[M insertItem:[NSMenuItem separatorItem] atIndex:index];
	E = [[[iTM2StringFormatController stringEncodingMenuWithAction:@selector(takeStringEncodingFromTag:) target:nil]
			itemArray] reverseObjectEnumerator];
	while(MI = [[[E nextObject] retain] autorelease])
	{
		[MI.menu removeItem:MI];
		[M insertItem:MI atIndex:index];
	}
	[M insertItem:[NSMenuItem separatorItem] atIndex:index];
	[M cleanSeparators4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= terminationStringForEOL:
+ (NSString *)terminationStringForEOL:(iTM2EOL)EOL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!EOL)
        EOL = [SUD integerForKey:iTM2EOLPreferredKey];
    switch(EOL)
    {
        case iTM2MacintoshEOL:	return @"\r";
        case iTM2WindowsEOL:	return @"\r\n";
        case iTM2UNIXEOL:
        default: 			return @"\n";
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOLForName:
+ (iTM2EOL)EOLForName:(NSString *)name;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    name = [name lowercaseString];
    if ([name isEqualToString:@"unchanged"]) return ZER0;
    if ([name isEqualToString:@"unix"]) return iTM2UNIXEOL;
    if ([name isEqualToString:@"macintosh"]) return iTM2MacintoshEOL;
    if ([name isEqualToString:@"mac"]) return iTM2MacintoshEOL;
    if ([name isEqualToString:@"macOS"]) return iTM2MacintoshEOL;
    if ([name isEqualToString:@"windows"]) return iTM2WindowsEOL;
    if ([name isEqualToString:@"vista"]) return iTM2WindowsEOL;
    if ([name isEqualToString:@"\r"]) return iTM2MacintoshEOL;
    if ([name isEqualToString:@"\n"]) return iTM2UNIXEOL;
    if ([name isEqualToString:@"\r\n"]) return iTM2WindowsEOL;
    return iTM2UnknownEOL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= encodingsDictionary
+ (NSDictionary *)encodingsDictionary;
/*"Read in iTM2Encodings.plist. Contains the correspondance emacs or regime name -> mac os x encoding.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithContentsOfFile:
                [myBUNDLE pathForResource:@"iTM2StringEncodings" ofType:@"plist"]];

}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= coreFoundationStringEncodingWithName:
+ (CFStringEncoding)coreFoundationStringEncodingWithName:(NSString *)argument;
/*"Yellow box string encoding returned. Core Foundation string encodings constants used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![argument isKindOfClass:[NSString class]])
	{
		if ([argument respondsToSelector:@selector(integerValue)])
		{
			return [argument integerValue];
		}
		return kCFStringEncodingInvalidId;
	}
	if (!argument.length)
	{
		return kCFStringEncodingInvalidId;
	}
	argument = [NSString stringWithFormat:@" %@ ",argument];
	argument = [argument stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	CFStringEncoding result = CFStringConvertIANACharSetNameToEncoding((CFStringRef)argument);
    if (result != kCFStringEncodingInvalidId)
	{
		return result;
	}
    NSScanner * S = [NSScanner scannerWithString:argument];
    [S setCaseSensitive:NO];
	CFStringEncoding CFSE;
    // a Core Foundation number
    int what = 0; // keep as int
    if ([S scanInt:&what]) {
        result = what;
        if (!CFStringIsEncodingAvailable(result))
            result = kCFStringEncodingInvalidId;
    }
    else if ([S scanString:@"non" intoString:nil])
    {
        if ([S scanString:@"lossy" intoString:nil] && [S scanString:@"ascii" intoString:nil])
        {
            result = kCFStringEncodingNonLossyASCII;
        }
    }
    else if ([S scanString:@"nextstep" intoString:nil] && [S scanString:@"latin" intoString:nil]
		||[S scanString:@"next" intoString:nil])
    {
        result = kCFStringEncodingNextStepLatin;
    }
    else if ([S scanString:@"ascii" intoString:nil])
    {
        result = kCFStringEncodingASCII;
    }
    else if ([S scanString:@"applemac" intoString:nil])
    {
        result = kCFStringEncodingMacRoman;
    }
    else if ([S scanString:@"unicode" intoString:nil])
    {
        result = kCFStringEncodingUnicode;
    }
    else if ([S scanString:@"utf" intoString:nil])
	{
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
		if ([S scanString:@"8" intoString:nil])
		{
			result = kCFStringEncodingUTF8;
		}
		else if ([S scanString:@"16" intoString:nil])
		{
			if ([S scanString:@"b" intoString:nil])
			{
				result = kCFStringEncodingUTF16BE;
			}
			else if ([S scanString:@"l" intoString:nil])
			{
				result = kCFStringEncodingUTF16LE;
			}
			else
			{
				result = kCFStringEncodingUTF16;
			}
		}
		else if ([S scanString:@"32" intoString:nil])
		{
			if ([S scanString:@"b" intoString:nil])
			{
				result = kCFStringEncodingUTF32BE;
			}
			else if ([S scanString:@"l" intoString:nil])
			{
				result = kCFStringEncodingUTF32LE;
			}
			else
			{
				result = kCFStringEncodingUTF32;
			}
		}
		else
		{
			result = kCFStringEncodingUTF8;
		}
	}
    else if ([S scanString:@"mac" intoString:nil])
    {
        if ([S scanString:@"roman" intoString:nil])
            result = kCFStringEncodingMacRoman;
        else if ([S scanString:@"japanese" intoString:nil])
            result = kCFStringEncodingMacJapanese;
        else if ([S scanString:@"korean" intoString:nil])
            result = kCFStringEncodingMacKorean;
        else if ([S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingMacArabic;
        else if ([S scanString:@"hebrew" intoString:nil])
            result = kCFStringEncodingMacHebrew;
        else if ([S scanString:@"greek" intoString:nil])
            result = kCFStringEncodingMacGreek;
        else if ([S scanString:@"cyrillic" intoString:nil])
            result = kCFStringEncodingMacCyrillic;
        else if ([S scanString:@"devanagari" intoString:nil])
            result = kCFStringEncodingMacDevanagari;
        else if ([S scanString:@"gurmukhi" intoString:nil])
            result = kCFStringEncodingMacGurmukhi;
        else if ([S scanString:@"gujarati" intoString:nil])
            result = kCFStringEncodingMacGujarati;
        else if ([S scanString:@"oriya" intoString:nil])
            result = kCFStringEncodingMacOriya;
        else if ([S scanString:@"bengali" intoString:nil])
            result = kCFStringEncodingMacBengali;
        else if ([S scanString:@"tamil" intoString:nil])
            result = kCFStringEncodingMacTamil;
        else if ([S scanString:@"telugu" intoString:nil])
            result = kCFStringEncodingMacTelugu;
        else if ([S scanString:@"kannada" intoString:nil])
            result = kCFStringEncodingMacKannada;
        else if ([S scanString:@"malayalam" intoString:nil])
            result = kCFStringEncodingMacMalayalam;
        else if ([S scanString:@"sinhalese" intoString:nil])
            result = kCFStringEncodingMacSinhalese;
        else if ([S scanString:@"burmese" intoString:nil])
            result = kCFStringEncodingMacBurmese;
        else if ([S scanString:@"khmer" intoString:nil])
            result = kCFStringEncodingMacKhmer;
        else if ([S scanString:@"thai" intoString:nil])
            result = kCFStringEncodingMacThai;
        else if ([S scanString:@"laotian" intoString:nil])
            result = kCFStringEncodingMacLaotian;
        else if ([S scanString:@"georgian" intoString:nil])
            result = kCFStringEncodingMacGeorgian;
        else if ([S scanString:@"armenian" intoString:nil])
            result = kCFStringEncodingMacArmenian;
        else if ([S scanString:@"chinese" intoString:nil] && [S scanString:@"traditional" intoString:nil])
            result = kCFStringEncodingMacChineseTrad;
        else if ([S scanString:@"chinese" intoString:nil] && [S scanString:@"simplified" intoString:nil])
            result = kCFStringEncodingMacChineseSimp;
        else if ([S scanString:@"tibetan" intoString:nil])
            result = kCFStringEncodingMacTibetan;
        else if ([S scanString:@"mongolian" intoString:nil])
            result = kCFStringEncodingMacMongolian;
        else if ([S scanString:@"ethiopic" intoString:nil])
            result = kCFStringEncodingMacEthiopic;
        else if ([S scanString:@"central" intoString:nil] &&	
                    [S scanString:@"european" intoString:nil] &&
                        [S scanString:@"roman" intoString:nil])
            result = kCFStringEncodingMacCentralEurRoman;
        else if ([S scanString:@"vietnamese" intoString:nil])
            result = kCFStringEncodingMacVietnamese;
        else if ([S scanString:@"extended" intoString:nil] && [S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingMacExtArabic;
        else if ([S scanString:@"symbol" intoString:nil])
            result = kCFStringEncodingMacSymbol;
        else if ([S scanString:@"dingbats" intoString:nil])
            result = kCFStringEncodingMacDingbats;
        else if ([S scanString:@"turkish" intoString:nil])
            result = kCFStringEncodingMacTurkish;
        else if ([S scanString:@"croatian" intoString:nil])
            result = kCFStringEncodingMacCroatian;
        else if ([S scanString:@"icelandic" intoString:nil])
            result = kCFStringEncodingMacIcelandic;
        else if ([S scanString:@"romanian" intoString:nil])
            result = kCFStringEncodingMacRomanian;
        else if ([S scanString:@"celtic" intoString:nil])
            result = kCFStringEncodingMacCeltic;
        else if ([S scanString:@"gaelic" intoString:nil])
            result = kCFStringEncodingMacGaelic;
        else if ([S scanString:@"farsi" intoString:nil])
            result = kCFStringEncodingMacFarsi;
        else if ([S scanString:@"ukrainian" intoString:nil])
            result = kCFStringEncodingMacUkrainian;
        else if ([S scanString:@"inuit" intoString:nil])
            result = kCFStringEncodingMacInuit;
        else if ([S scanString:@"vt100" intoString:nil])
            result = kCFStringEncodingMacVT100;
        else if ([S scanString:@"cyr" intoString:nil])//context
            result = kCFStringEncodingMacVT100;
        else if ([S scanString:@"ukr" intoString:nil])//context
            result = kCFStringEncodingMacVT100;
        else
            result = kCFStringEncodingMacRoman;
    } else if ([S scanString:@"iso" intoString:nil]) {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        if ([S scanString:@"8859" intoString:nil]) {
            [S scanInt:&what];
            switch (CFSE = what) {
                case  1: result = kCFStringEncodingISOLatin1;		break;
                case  2: result = kCFStringEncodingISOLatin2;		break;
                case  3: result = kCFStringEncodingISOLatin3;		break;
                case  4: result = kCFStringEncodingISOLatin4;		break;
                case  5: result = kCFStringEncodingISOLatinCyrillic;	break;
                case  6: result = kCFStringEncodingISOLatinArabic;	break;
                case  7: result = kCFStringEncodingISOLatinGreek;	break;
                case  8: result = kCFStringEncodingISOLatinHebrew;	break;
                case  9: result = kCFStringEncodingISOLatin5;		break;
                case 10: result = kCFStringEncodingISOLatin6;		break;
                case 11: result = kCFStringEncodingISOLatinThai;	break;
//                case 12: result = ?;
                case 13: result = kCFStringEncodingISOLatin7;		break;
                case 14: result = kCFStringEncodingISOLatin8;		break;
                case 15: result = kCFStringEncodingISOLatin9;		break;
            }
        }
        else if ([S scanString:@"latin" intoString:nil])
        {
            [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
            if ([S scanInt:&what])
                switch(CFSE = what)
                {
                    case 1: result = kCFStringEncodingISOLatin1;	break;
                    case 2: result = kCFStringEncodingISOLatin2;	break;
                    case 3: result = kCFStringEncodingISOLatin3;	break;
                    case 4: result = kCFStringEncodingISOLatin4;	break;
                    case 5: result = kCFStringEncodingISOLatin5;	break;
                    case 6: result = kCFStringEncodingISOLatin6;	break;
                    case 7: result = kCFStringEncodingISOLatin7;	break;
                    case 8: result = kCFStringEncodingISOLatin8;	break;
                    case 9: result = kCFStringEncodingISOLatin9;	break;
#if 0
#warning THIS IS A BUG IN CFStringEncodingExt.h, iso latin 10, before panther?
                    case 10: result = 0x0210;	break;
#else
                    case 10: result = kCFStringEncodingISOLatin10;	break;
#endif
                }
            else if ([S scanString:@"cyrillic" intoString:nil])
                result = kCFStringEncodingISOLatinCyrillic;
            else if ([S scanString:@"arabic" intoString:nil])
                result = kCFStringEncodingISOLatinArabic;
            else if ([S scanString:@"greek" intoString:nil])
                result = kCFStringEncodingISOLatinGreek;
            else if ([S scanString:@"hebrew" intoString:nil])
                result = kCFStringEncodingISOLatinHebrew;
            else if ([S scanString:@"thai" intoString:nil])
                result = kCFStringEncodingISOLatinThai;
        }
    }
    else if ([S scanString:@"dos" intoString:nil])
    {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        if ([S scanString:@"latin" intoString:nil] && [S scanString:@"us" intoString:nil])
            result = kCFStringEncodingDOSLatinUS;
        else if ([S scanString:@"greek" intoString:nil])
            result = kCFStringEncodingDOSGreek;
        else if ([S scanString:@"baltic" intoString:nil] && [S scanString:@"rim" intoString:nil])
            result = kCFStringEncodingDOSBalticRim;
        else if ([S scanString:@"cyrillic" intoString:nil])
            result = kCFStringEncodingDOSCyrillic;
        else if ([S scanString:@"turkish" intoString:nil])
            result = kCFStringEncodingDOSTurkish;
        else if ([S scanString:@"potuguese" intoString:nil])
            result = kCFStringEncodingDOSPortuguese;
        else if ([S scanString:@"icelandic" intoString:nil])
            result = kCFStringEncodingDOSIcelandic;
        else if ([S scanString:@"hebrew" intoString:nil])
            result = kCFStringEncodingDOSHebrew;
        else if ([S scanString:@"canadian" intoString:nil] && [S scanString:@"french" intoString:nil])
            result = kCFStringEncodingDOSCanadianFrench;
        else if ([S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingDOSArabic;
        else if ([S scanString:@"nordic" intoString:nil])
            result = kCFStringEncodingDOSNordic;
        else if ([S scanString:@"russian" intoString:nil])
            result = kCFStringEncodingDOSRussian;
        else if ([S scanString:@"thai" intoString:nil])
            result = kCFStringEncodingDOSThai;
        else if ([S scanString:@"japanese" intoString:nil])
            result = kCFStringEncodingDOSJapanese;
        else if ([S scanString:@"chinese" intoString:nil] && [S scanString:@"simplified" intoString:nil])
            result = kCFStringEncodingDOSChineseSimplif;
        else if ([S scanString:@"korean" intoString:nil])
            result = kCFStringEncodingDOSKorean;
        else if ([S scanString:@"chinese" intoString:nil] && [S scanString:@"traditional" intoString:nil])
            result = kCFStringEncodingDOSChineseTrad;
        else if ([S scanString:@"latin" intoString:nil])
        {
            [S scanInt:&what];
            switch(CFSE = what)
            {
                case 1: result = kCFStringEncodingDOSLatin1; break;
                case 2: result = kCFStringEncodingDOSLatin2; break;
            }
        }
        else if ([S scanString:@"greek" intoString:nil])
        {
            [S scanInt:&what];
            switch(CFSE = what)
            {
                case 1: result = kCFStringEncodingDOSGreek1; break;
                case 2: result = kCFStringEncodingDOSGreek2; break;
            }
        }
    }
    else if ([S scanString:@"windows" intoString:nil])
    {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        if ([S scanString:@"nt" intoString:nil])
        {
            if ([S scanString:@"korean" intoString:nil] && [S scanString:@"johab" intoString:nil])
                result = kCFStringEncodingWindowsKoreanJohab;
        }
        else if ([S scanString:@"baltic" intoString:nil] && [S scanString:@"rim" intoString:nil])
            result = kCFStringEncodingWindowsBalticRim;
        else if ([S scanString:@"thai" intoString:nil])
            result = kCFStringEncodingDOSThai;
        else if ([S scanString:@"japanese" intoString:nil])
            result = kCFStringEncodingDOSJapanese;
        else if ([S scanString:@"chinese" intoString:nil] && [S scanString:@"simplified" intoString:nil])
            result = kCFStringEncodingDOSChineseSimplif;
        else if ([S scanString:@"chinese" intoString:nil] && [S scanString:@"traditional" intoString:nil])
            result = kCFStringEncodingDOSChineseTrad;
        else if ([S scanString:@"korean" intoString:nil])
            result = kCFStringEncodingDOSKorean;
        else if ([S scanString:@"cyrillic" intoString:nil])
            result = kCFStringEncodingWindowsCyrillic;
        else if ([S scanString:@"greek" intoString:nil])
            result = kCFStringEncodingWindowsGreek;
        else if ([S scanString:@"hebrew" intoString:nil])
            result = kCFStringEncodingWindowsHebrew;
        else if ([S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingWindowsArabic;
        else if ([S scanString:@"vietnamese" intoString:nil])
            result = kCFStringEncodingWindowsVietnamese;
        else if ([S scanString:@"latin" intoString:nil])
        {
            [S scanInt:&what];
            switch(CFSE = what)
            {
                case 1: result = kCFStringEncodingWindowsLatin1; break;
                case 2: result = kCFStringEncodingWindowsLatin2; break;
                case 5: result = kCFStringEncodingWindowsLatin5; break;
            }
        }
    }
    else if (([S scanString:@"code" intoString:nil] && [S scanString:@"page" intoString:nil]) ||
                        ([S scanString:@"cp" intoString:nil]))
    {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        [S scanInt:&what];
        switch(CFSE = what)
        {
            case   37: result = kCFStringEncodingEBCDIC_CP037;		break;
            case  437: result = kCFStringEncodingDOSLatinUS;		break;
            case  737: result = kCFStringEncodingDOSGreek;		break;
            case  775: result = kCFStringEncodingDOSBalticRim;		break;
            case  850: result = kCFStringEncodingDOSLatin1;		break;
            case  851: result = kCFStringEncodingDOSGreek1;		break;
            case  852: result = kCFStringEncodingDOSLatin2;		break;
            case  855: result = kCFStringEncodingDOSCyrillic;		break;
            case  857: result = kCFStringEncodingDOSTurkish;		break;
            case  860: result = kCFStringEncodingDOSPortuguese;		break;
            case  861: result = kCFStringEncodingDOSIcelandic;		break;
            case  862: result = kCFStringEncodingDOSHebrew;		break;
            case  863: result = kCFStringEncodingDOSCanadianFrench;	break;
            case  864: result = kCFStringEncodingDOSArabic;		break;
            case  865: result = kCFStringEncodingDOSNordic;		break;
            case  866: result = kCFStringEncodingDOSRussian;		break;
            case  869: result = kCFStringEncodingDOSGreek2;		break;
            case  874: result = kCFStringEncodingDOSThai;		break;
            case  932: result = kCFStringEncodingDOSJapanese;		break;
            case  936: result = kCFStringEncodingDOSChineseSimplif;	break;
            case  949: result = kCFStringEncodingDOSKorean;		break;
            case  950: result = kCFStringEncodingDOSChineseTrad;	break;
            case 1250: result = kCFStringEncodingWindowsLatin2;		break;
            case 1251: result = kCFStringEncodingWindowsCyrillic;	break;
            case 1252: result = kCFStringEncodingWindowsLatin1;		break;
            case 1253: result = kCFStringEncodingWindowsGreek;		break;
            case 1254: result = kCFStringEncodingWindowsLatin5;		break;
            case 1255: result = kCFStringEncodingWindowsHebrew;		break;
            case 1256: result = kCFStringEncodingWindowsArabic;		break;
            case 1257: result = kCFStringEncodingWindowsBalticRim;	break;
            case 1361: result = kCFStringEncodingWindowsKoreanJohab;	break;
            case 1258: result = kCFStringEncodingWindowsVietnamese;	break;
        }
    }
    else if ([S scanString:@"il1" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingISOLatin1;
    }
    else if ([S scanString:@"il9" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingISOLatin9;
    }
    else if ([S scanString:@"win" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingWindowsLatin1;
    }
    else if ([S scanString:@"mac" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingMacRoman;
    }
    else if ([S scanString:@"ibm" intoString:nil])//ConTeXt support IBM PC DOS	western european languages
    {
        result = kCFStringEncodingEBCDIC_CP037;
    }
    else if ([S scanString:@"grk" intoString:nil])
    {
        result = kCFStringEncodingISOLatinGreek;
    }
    else if ([S scanString:@"koi8-r" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingKOI8_R;
    }
    else if ([S scanString:@"koi8-u" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingKOI8_U;
    }
    else if ([S scanString:@"latin" intoString:nil] || [S scanString:@"il" intoString:nil])
	{
		CFStringEncoding CFSE;
		[S scanInt:&what];
		switch(CFSE = what)
		{
			case 1: result = kCFStringEncodingISOLatin1; break;
			case 2: result = kCFStringEncodingISOLatin2; break;
			case 3: result = kCFStringEncodingISOLatin3; break;
			case 4: result = kCFStringEncodingISOLatin4; break;
			case 5: result = kCFStringEncodingISOLatin5; break;
			case 6: result = kCFStringEncodingISOLatin6; break;
			case 7: result = kCFStringEncodingISOLatin7; break;
			case 8: result = kCFStringEncodingISOLatin8; break;
			case 9: result = kCFStringEncodingISOLatin9; break;
			case 10: result = kCFStringEncodingISOLatin10; break;
		}
	}
	if (result == kCFStringEncodingInvalidId)
        NSLog(@"Unrecognized encoding string name: <%@>", argument);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= nameOfCoreFoundationStringEncoding:
+ (NSString *)nameOfCoreFoundationStringEncoding:(CFStringEncoding)encoding;
/*"Yellow box string encoding returned. Core Foundation string encodings constants used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * result = (NSString *)CFStringConvertEncodingToIANACharSetName(encoding);
	if (result.length)
	{
		return result;
	}
    switch(encoding)
    {
        case kCFStringEncodingMacRoman:
        return @"mac roman";
        case kCFStringEncodingUnicode:
        //case kCFStringEncodingUTF16:
        return @"utf-16";
        case kCFStringEncodingUTF16BE:
        return @"utf-16BE";
        case kCFStringEncodingUTF16LE:
        return @"utf-16LE";
        case kCFStringEncodingUTF32:
        return @"utf-32";
        case kCFStringEncodingUTF32BE:
        return @"utf-32BE";
        case kCFStringEncodingUTF32LE:
        return @"utf-32LE";
        case kCFStringEncodingUTF8:
        return @"utf-8";
        case kCFStringEncodingMacJapanese:
        return @"Mac Japanese";
        case kCFStringEncodingMacChineseTrad:
        return @"Mac Chinese Traditional";
        case kCFStringEncodingMacKorean:
        return @"Mac Korean";
        case kCFStringEncodingMacArabic:
        return @"Mac Arabic";
        case kCFStringEncodingMacHebrew:
        return @"Mac Hebrew";
        case kCFStringEncodingMacGreek:
        return @"Mac Greek";
        case kCFStringEncodingMacCyrillic:
        return @"Mac Cyrillic";
        case kCFStringEncodingMacDevanagari:
        return @"Mac Devanagari";
        case kCFStringEncodingMacGurmukhi:
        return @"Mac Gurmukhi";
        case kCFStringEncodingMacGujarati:
        return @"Mac Gujarati";
        case kCFStringEncodingMacOriya:
        return @"Mac Oriya";
        case kCFStringEncodingMacBengali:
        return @"Mac Bengali";
        case kCFStringEncodingMacTamil:
        return @"Mac Tamil";
        case kCFStringEncodingMacTelugu:
        return @"Mac Telugu";
        case kCFStringEncodingMacKannada:
        return @"Mac Kannada";
        case kCFStringEncodingMacMalayalam:
        return @"Mac Malayalam";
        case kCFStringEncodingMacSinhalese:
        return @"Mac Sinhalese";
        case kCFStringEncodingMacBurmese:
        return @"Mac Burmese";
        case kCFStringEncodingMacKhmer:
        return @"Mac Khmer";
        case kCFStringEncodingMacThai:
        return @"Mac Thai";
        case kCFStringEncodingMacLaotian:
        return @"Mac Laotian";
        case kCFStringEncodingMacGeorgian:
        return @"Mac Georgian";
        case kCFStringEncodingMacArmenian:
        return @"Mac Armenian";
        case kCFStringEncodingMacChineseSimp:
        return @"Mac Chinese Simplified";
        case kCFStringEncodingMacTibetan:
        return @"Mac Tibetan";
        case kCFStringEncodingMacMongolian:
        return @"Mac Mongolian";
        case kCFStringEncodingMacEthiopic:
        return @"Mac Ethiopic";
        case kCFStringEncodingMacCentralEurRoman:
        return @"Mac Central European Roman";
        case kCFStringEncodingMacVietnamese:
        return @"Mac Vietnamese";
        case kCFStringEncodingMacExtArabic:
        return @"Mac Extended Arabic";
        case kCFStringEncodingMacSymbol:
        return @"Mac Symbol";
        case kCFStringEncodingMacDingbats:
        return @"Mac Dingbats";
        case kCFStringEncodingMacTurkish:
        return @"Mac Turkish";
        case kCFStringEncodingMacCroatian:
        return @"Mac Croatian";
        case kCFStringEncodingMacIcelandic:
        return @"Mac Icelandic";
        case kCFStringEncodingMacRomanian:
        return @"Mac Romanian";
        case kCFStringEncodingMacCeltic:
        return @"Mac Celtic";
        case kCFStringEncodingMacGaelic:
        return @"Mac Gaelic";
        /*Thefollowingusescriptcode4,smArabic*/
        case kCFStringEncodingMacFarsi:
        return @"Mac Farsi";
        /*Thefollowingusescriptcode7,smCyrillic*/
        case kCFStringEncodingMacUkrainian:
        return @"Mac Ukrainian";
        /*Thefollowingusescriptcode32,smUnimplemented*/
        case kCFStringEncodingMacInuit:
        return @"Mac Inuit";
        case kCFStringEncodingMacVT100:
        return @"Mac VT100";
        /*SpecialMacOSencodings*/
        case kCFStringEncodingMacHFS:
        return @"Mac HFS";
        case kCFStringEncodingISOLatin1:
        return @"ISO Latin 1";
        case kCFStringEncodingISOLatin2:
        return @"ISO Latin 2";
        case kCFStringEncodingISOLatin3:
        return @"ISO Latin 3";
        case kCFStringEncodingISOLatin4:
        return @"ISO Latin 4";
        case kCFStringEncodingISOLatinCyrillic:
        return @"ISO Latin Cyrillic";
        case kCFStringEncodingISOLatinArabic:
        return @"ISO Latin Arabic";
        case kCFStringEncodingISOLatinGreek:
        return @"ISO Latin Greek";
        case kCFStringEncodingISOLatinHebrew:
        return @"ISO Latin Hebrew";
        case kCFStringEncodingISOLatin5:
        return @"ISO Latin 5";
        case kCFStringEncodingISOLatin6:
        return @"ISO Latin 6";
        case kCFStringEncodingISOLatinThai:
        return @"ISO Latin Thai";
        case kCFStringEncodingISOLatin7:
        return @"ISO Latin 7";
        case kCFStringEncodingISOLatin8:
        return @"ISO Latin 8";
        case kCFStringEncodingISOLatin9:
        return @"ISO Latin 9";
        case kCFStringEncodingDOSLatinUS:
        return @"DOS Latin US";
        case kCFStringEncodingDOSGreek:
        return @"DOS Greek";
        case kCFStringEncodingDOSBalticRim:
        return @"DOS Baltic Rim";
        case kCFStringEncodingDOSLatin1:
        return @"DOS Latin 1";
        case kCFStringEncodingDOSGreek1:
        return @"DOS Greek 1";
        case kCFStringEncodingDOSLatin2:
        return @"DOS Latin 2";
        case kCFStringEncodingDOSCyrillic:
        return @"DOS Cyrillic";
        case kCFStringEncodingDOSTurkish:
        return @"DOS Turkish";
        case kCFStringEncodingDOSPortuguese:
        return @"DOS Portuguese";
        case kCFStringEncodingDOSIcelandic:
        return @"DOS Icelandic";
        case kCFStringEncodingDOSHebrew:
        return @"DOS Hebrew";
        case kCFStringEncodingDOSCanadianFrench:
        return @"DOS Canadian French";
        case kCFStringEncodingDOSArabic:
        return @"DOS Arabic";
        case kCFStringEncodingDOSNordic:
        return @"DOS Nordic";
        case kCFStringEncodingDOSRussian:
        return @"DOS Russian";
        case kCFStringEncodingDOSGreek2:
        return @"DOS Greek 2";
        case kCFStringEncodingDOSThai:
        return @"DOS Thai";
        case kCFStringEncodingDOSJapanese:
        return @"DOS Japanese";
        case kCFStringEncodingDOSChineseSimplif:
        return @"DOS Chinese Simplified";
        case kCFStringEncodingDOSKorean:
        return @"DOS Korean";
        case kCFStringEncodingDOSChineseTrad:
        return @"DOS Chinese Traditional";
        case kCFStringEncodingWindowsLatin1:
        return @"Windows Latin 1";
        case kCFStringEncodingWindowsLatin2:
        return @"Windows Latin 2";
        case kCFStringEncodingWindowsCyrillic:
        return @"Windows Cyrillic";
        case kCFStringEncodingWindowsGreek:
        return @"Windows Greek";
        case kCFStringEncodingWindowsLatin5:
        return @"Windows Latin5";
        case kCFStringEncodingWindowsHebrew:
        return @"Windows Hebrew";
        case kCFStringEncodingWindowsArabic:
        return @"Windows Arabic";
        case kCFStringEncodingWindowsBalticRim:
        return @"Windows BalticRim";
        case kCFStringEncodingWindowsKoreanJohab:
        return @"Windows KoreanJohab";
        case kCFStringEncodingWindowsVietnamese:
        return @"Windows Vietnamese";
        case kCFStringEncodingASCII:
        return @"ASCII";
        case kCFStringEncodingJIS_X0201_76:
        return @"JIS X0201 76";
        case kCFStringEncodingJIS_X0208_83:
        return @"JIS X0208 83";
        case kCFStringEncodingJIS_X0208_90:
        return @"JIS X0208 90";
        case kCFStringEncodingJIS_X0212_90:
        return @"JIS X0212 90";
        case kCFStringEncodingJIS_C6226_78:
        return @"JIS C6226 78";
        case kCFStringEncodingShiftJIS_X0213_00:
        return @"Shift JIS X0213 00";
        case kCFStringEncodingGB_2312_80:
        return @"GB 2312 80";
        case kCFStringEncodingGBK_95:
        return @"GBK 95";
        case kCFStringEncodingGB_18030_2000:
        return @"GB 18030 2000";
        case kCFStringEncodingKSC_5601_87:
        return @"KSC 5601 87";
        case kCFStringEncodingKSC_5601_92_Johab:
        return @"KSC 5601 92 Johab";
        case kCFStringEncodingCNS_11643_92_P1:
        return @"CNS 11643 92 P1";
        case kCFStringEncodingCNS_11643_92_P2:
        return @"CNS 11643 92 P2";
        case kCFStringEncodingCNS_11643_92_P3:
        return @"CNS 11643 92 P3";
        case kCFStringEncodingISO_2022_JP:
        return @"ISO 2022 JP";
        case kCFStringEncodingISO_2022_JP_2:
        return @"ISO 2022 JP 2";
        case kCFStringEncodingISO_2022_JP_1:
        return @"ISO 2022 JP 1";
        case kCFStringEncodingISO_2022_JP_3:
        return @"ISO 2022 JP 3";
        case kCFStringEncodingISO_2022_CN:
        return @"ISO 2022 CN";
        case kCFStringEncodingISO_2022_CN_EXT:
        return @"ISO 2022 CN EXT";
        case kCFStringEncodingISO_2022_KR:
        return @"ISO 2022 KR";
        case kCFStringEncodingEUC_JP:
        return @"EUC JP";
        case kCFStringEncodingEUC_CN:
        return @"EUC CN";
        case kCFStringEncodingEUC_TW:
        return @"EUC TW";
        case kCFStringEncodingEUC_KR:
        return @"EUC KR";
        case kCFStringEncodingShiftJIS:
        return @"Shift JIS";
        case kCFStringEncodingKOI8_R:
        return @"KOI8 R";
        case kCFStringEncodingBig5:
        return @"Big5";
        case kCFStringEncodingMacRomanLatin1:
        return @"Mac Roman Latin 1";
        case kCFStringEncodingHZ_GB_2312:
        return @"HZ GB 2312";
        case kCFStringEncodingBig5_HKSCS_1999:
        return @"Big5 HKSCS 1999";
        case kCFStringEncodingNextStepLatin:
        return @"NextStep Latin";
        case kCFStringEncodingEBCDIC_US:
        return @"EBCDIC US";
        case kCFStringEncodingEBCDIC_CP037:
        return @"EBCDIC CP037";
#if 0
#warning THIS IS A BUG IN CFStringEncodingExt.h
        case 0x0210:
        return @"ISO Latin 10";
#endif
        case kCFStringEncodingISOLatin10:
        return @"ISO Latin 10";
        case 0x0A08:
        return @"KOI8 U";
        case kCFStringEncodingNonLossyASCII:
        default:
        return @"non lossy ascii";
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameOfEOL:
+ (NSString *)nameOfEOL:(iTM2EOL)LE;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch(LE)
    {
        case 0: return @"Unchanged";// Don't change these names!
        case iTM2UNIXEOL: return @"UNIX";
        case iTM2MacintoshEOL: return @"Macintosh";
        case iTM2WindowsEOL: return @"Windows";
        default: return @"Unknow";
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= availableStringEncodings
+ (NSArray *)availableStringEncodings;
/*"Yellow box string encoding returned. UInt32 used!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static NSArray * g_iTM2AvailableStringEncodings = nil;
    if (!g_iTM2AvailableStringEncodings)
    {
        NSLock * L = [[[NSLock alloc] init] autorelease];
        [L lock];
        const CFStringEncoding * CFSGLOAEs = CFStringGetListOfAvailableEncodings();
        NSUInteger count = ZER0;
        while (CFSGLOAEs[count] != kCFStringEncodingInvalidId)
            count++;
        NSMutableArray * MRA = [NSMutableArray array];
        NSUInteger index = ZER0;
        for (index = ZER0; index < count; index++) {
            NSStringEncoding NSSE = CFStringConvertEncodingToNSStringEncoding(CFSGLOAEs[index]);
            if (NSSE && [NSString localizedNameOfStringEncoding:NSSE])
                [MRA addObject:[NSNumber numberWithUnsignedInteger:NSSE]];
        }
        g_iTM2AvailableStringEncodings = [[MRA sortedArrayUsingSelector:@selector(_iTM2CompareStringEncoding:)] retain];
        [L unlock];
    }
    return g_iTM2AvailableStringEncodings;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithDocument:
- (id)initWithDocument:(id)document;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ((self = [super init]))  {
		self.document=document;
	}
//END4iTM3;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataWithString:allowLossyConversion:
- (NSData *)dataWithString:(NSString *)argument allowLossyConversion:(BOOL)lossy;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [argument dataUsingEncoding:self.stringEncoding allowLossyConversion:lossy];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canConvertString:
- (BOOL)canConvertString:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return !argument.length || [argument canBeConvertedToEncoding:self.stringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringWithData:
- (NSString *)stringWithData:(NSData *)docData;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * string = @"";
	if (!docData.length) {
		return string;
	}
    NSStringEncoding usedEncoding = ZER0;
    BOOL canStringEncoding = NO;
    NSString * hardStringEncodingName = @"";
    // testing for UTF32, UTF16 and UTF8 encodings, see http://unicode.org/faq/utf_bom.html#22
    char byteOrder [8] = {'0','0','0','0','0','0','0','0'};
    if (docData.length>=8)
        memmove(byteOrder, [docData bytes], 8);
    else if (docData.length>=6)
        memmove(byteOrder, [docData bytes], 6);
    else if (docData.length>=4)
        memmove(byteOrder, [docData bytes], 4);
    if (!strncmp(byteOrder, "\0\0\0\0FEFF", 8)) {
        usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32BE);
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
    } else if (!strncmp(byteOrder, "FFFE\0\0\0\0", 4)) {
        usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32LE);
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
    } else if (!strncmp(byteOrder, "FFFE", 4)) {
        usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16LE);
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
    } else if (!strncmp(byteOrder, "FEFF", 4)) {
        usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16BE);
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
    } else if (!strncmp(byteOrder, "EFBBBF", 6)) {
        usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
    } else if ([self context4iTM3BoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask]) {
		// guess the string from the file contents
        NSStringEncoding preferredStringEncoding = self.stringEncoding;
        if (![[NSString localizedNameOfStringEncoding:preferredStringEncoding] length]) {
            preferredStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
            [SUD setInteger:preferredStringEncoding forKey:iTM2StringEncodingPreferredKey];
        }
		#define HEADER_LIMIT 8*125
		NSRange range = iTM3MakeRange(ZER0,MIN(HEADER_LIMIT,docData.length));
		NSData * headerData = [docData subdataWithRange:range];
        string = [[[NSString alloc] initWithData:headerData encoding:preferredStringEncoding] autorelease];
        NSStringEncoding hardCodedStringEncoding;
		NSRange hardCodedRange;
		[string getHardCodedStringEncoding4iTM3:&hardCodedStringEncoding range:&hardCodedRange];
        canStringEncoding = (hardCodedStringEncoding == ZER0 || hardCodedRange.length == ZER0);
        if (hardCodedStringEncoding && [[NSString localizedNameOfStringEncoding:hardCodedStringEncoding] length] &&
                (hardCodedStringEncoding != preferredStringEncoding)) {
            usedEncoding = hardCodedStringEncoding;
            string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
        } else {
            usedEncoding = preferredStringEncoding;
			if (docData.length>HEADER_LIMIT) {
				string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
			}
        }
    } else if (usedEncoding = self.stringEncoding) {
        if (![[NSString localizedNameOfStringEncoding:usedEncoding] length]) {
            usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
        } else {
			LOG4iTM3(@"Reading data with encoding: %@", [NSString localizedNameOfStringEncoding:usedEncoding]);
		}
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
		if (!string) {
            usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
			string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
			if (!string) {
				usedEncoding = NSASCIIStringEncoding;
				string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
			}
		}
        canStringEncoding = YES;
    } else {
        usedEncoding = [SUD integerForKey:iTM2StringEncodingPreferredKey];
        if (![[NSString localizedNameOfStringEncoding:usedEncoding] length]) {
            usedEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
            [SUD setInteger:usedEncoding forKey:iTM2StringEncodingPreferredKey];
        }
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
        NSStringEncoding hardCodedStringEncoding;
		NSRange hardCodedRange = iTM3MakeRange(ZER0,ZER0);
		[string getHardCodedStringEncoding4iTM3:&hardCodedStringEncoding range:&hardCodedRange];
		if (hardCodedRange.length > ZER0)
			hardStringEncodingName = [string substringWithRange:hardCodedRange];
		else
			hardStringEncodingName = @"";
        canStringEncoding = NO;
    }
	if (docData.length && !string.length) {
		LOG4iTM3(@"Problem with the stringEncoding, report BUG 0213");
		usedEncoding = NSMacOSRomanStringEncoding;
        string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
		if (!string)
		{
            usedEncoding = NSASCIIStringEncoding;
			string = [[[NSString alloc] initWithData:docData encoding:usedEncoding] autorelease];
		}
        canStringEncoding = YES;
		[self takeContext4iTM3Bool:NO forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
	}
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"usedEncoding: %@", [NSString localizedNameOfStringEncoding:usedEncoding]);
	}
	self.stringEncoding = usedEncoding;
	self.isStringEncodingHardCoded = !canStringEncoding;
	[self setHardStringEncodingName:hardStringEncodingName];
	if (self.document) {
		NSString * defaultStringEncodingName = [self.document context4iTM3ValueForKey:TWSStringEncodingFileKey domain:iTM2ContextStandardLocalMask ROR4iTM3];// we are expecting something
		NSAssert(defaultStringEncodingName,(@"The defaults string encoding has not been registered, some code is broken in the iTM2StringFormatterKit"));
	}
//START4iTM3;
    return string;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL error:(NSError **)RORef;
//  Révisé par itexmac2: 2010-11-05 15:44:45 +0100
{
	NSString * S = nil;
    NSStringEncoding usedEncoding; 
    BOOL canStringEncoding = YES;
    NSString * hardStringEncodingName = @"";
    BOOL result = YES;
    if (S = [NSString stringWithContentsOfURL:absoluteURL usedEncoding:&usedEncoding error:RORef]) {
        NSStringEncoding hardCodedStringEncoding;
        NSStringEncoding preferredStringEncoding;
        NSRange hardCodedRange;
        NSString * SS = nil;
        if ([self context4iTM3BoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask]) {
            [S getHardCodedStringEncoding4iTM3:&hardCodedStringEncoding range:&hardCodedRange];
            if ((hardCodedRange.length > ZER0) && (hardCodedStringEncoding > ZER0)) {
                // there was an hard coded string encoding
                hardStringEncodingName = [S substringWithRange:hardCodedRange];
                canStringEncoding = NO;
                if (hardCodedStringEncoding == usedEncoding) {
                    // everything is alright
terminate:
                    self.stringEncoding = usedEncoding;
                    self.isStringEncodingHardCoded = !canStringEncoding;
                    self.hardStringEncodingName = hardStringEncodingName;
                    [self.document setStringRepresentation:S];
                    DEBUGLOG4iTM3(0,@"usedEncoding: %@", [NSString localizedNameOfStringEncoding:usedEncoding]);
                    return result;
                }
                // the system did not guess the correct encoding
                // reread with the correct encoding
                if (SS = [NSString stringWithContentsOfURL:absoluteURL encoding:hardCodedStringEncoding error:RORef]) {
                    usedEncoding = hardCodedStringEncoding;
                    S = SS;
                    goto terminate;
                }
                result = NO;
                canStringEncoding = YES;
                LOG4iTM3(@"The hard coded string encoding %@ could not be honoured:%@, using %@ instead",
                    hardStringEncodingName,
                    [NSString localizedNameOfStringEncoding:hardCodedStringEncoding],
                    [NSString localizedNameOfStringEncoding:usedEncoding],
                    absoluteURL);
try_another_encoding:
                preferredStringEncoding = self.stringEncoding;
                if (preferredStringEncoding == usedEncoding) {
                    goto terminate;
                }
                if ((ZER0 == preferredStringEncoding)
                        || (ZER0 == [[NSString localizedNameOfStringEncoding:preferredStringEncoding] length])) {
                    preferredStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
                    [SUD setInteger:preferredStringEncoding forKey:iTM2StringEncodingPreferredKey];
                    if (preferredStringEncoding == usedEncoding) {
                        goto terminate;
                    }
                } else {
                    if ((SS = [NSString stringWithContentsOfURL:absoluteURL encoding:preferredStringEncoding error:RORef])) {
                        usedEncoding = preferredStringEncoding;
                        S = SS;
                        goto terminate;
                    }
                    preferredStringEncoding = [SUD integerForKey:iTM2StringEncodingPreferredKey];
                    if (preferredStringEncoding == usedEncoding) {
                        goto terminate;
                    }
                    if ((ZER0 == preferredStringEncoding)
                            || (ZER0 == [[NSString localizedNameOfStringEncoding:preferredStringEncoding] length])) {
                        preferredStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
                        [SUD setInteger:preferredStringEncoding forKey:iTM2StringEncodingPreferredKey];
                        if (preferredStringEncoding == usedEncoding) {
                            goto terminate;
                        }
                    }
                }
                if ((SS = [NSString stringWithContentsOfURL:absoluteURL encoding:preferredStringEncoding error:RORef])) {
                    usedEncoding = preferredStringEncoding;
                    S = SS;
                }
                goto terminate;
            }
            // there is no hard coded string encoding
        }
    }
    goto try_another_encoding;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyEOL
- (NSUInteger)lazyEOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-11-05 14:10:12 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3IntegerForKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOL
- (NSUInteger)EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [iVarEOL4iTM3?:(iVarEOL4iTM3 = [NSNumber numberWithUnsignedInteger:self.lazyEOL]) unsignedIntegerValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOL:
- (void)setEOL:(NSUInteger)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iVarEOL4iTM3 = [NSNumber numberWithUnsignedInteger:argument];
	[self takeContext4iTM3Value:iVarEOL4iTM3 forKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask&~iTM2ContextProjectMask ROR4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyStringEncoding
- (NSStringEncoding)lazyStringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3IntegerForKey:TWSStringEncodingFileKey domain:iTM2ContextStandardLocalMask|iTM2ContextProjectMask]?:
		([self context4iTM3IntegerForKey:iTM2StringEncodingOpenKey domain:iTM2ContextAllDomainsMask]?:[self context4iTM3IntegerForKey:iTM2StringEncodingPreferredKey domain:iTM2ContextAllDomainsMask]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncoding
- (NSStringEncoding)stringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [iVarStringEncoding4iTM3?:(iVarStringEncoding4iTM3 = [NSNumber numberWithUnsignedInteger:self.lazyStringEncoding]) unsignedIntegerValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncoding:
- (void)setStringEncoding:(NSStringEncoding)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iVarStringEncoding4iTM3 = [NSNumber numberWithUnsignedInteger:argument];
	[self takeContext4iTM3Value:iVarStringEncoding4iTM3 forKey:TWSStringEncodingFileKey domain:iTM2ContextAllDomainsMask&~iTM2ContextProjectMask ROR4iTM3];
    return;
}
@synthesize hardStringEncodingName = iVarHardStringEncodingName4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncodingHardCoded:
- (void)setStringEncodingHardCoded:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self takeContext4iTM3Bool:(iVarStringEncodingIsHardCoded4iTM3 = yorn) forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextStandardLocalMask];
	return;
}
@synthesize isStringEncodingHardCoded = iVarStringEncodingIsHardCoded4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOLMenuWithAction:target:
+ (NSMenu *)EOLMenuWithAction:(SEL)anAction target:(id)aTarget;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * menu = [[[[[NSApp mainMenu] deepItemWithAction4iTM3:@selector(takeEOLFromTag:)] menu] copy] autorelease];
	if (menu) {
		NSInteger index = ZER0;
		while(index < [menu numberOfItems])
		{
			NSMenuItem * MI = [menu itemAtIndex:index];
			if ([MI isSeparatorItem] || (MI.action != @selector(takeEOLFromTag:)))
				[menu removeItemAtIndex:index];
			else {
				MI.action = anAction;
				MI.target = aTarget;
				++index;
			}
		}
	} else {
		menu = [[[NSMenu alloc] initWithTitle:@"Line Ending Menu"] autorelease];
		NSMenuItem * MI = [menu addItemWithTitle:[self nameOfEOL:iTM2MacintoshEOL]
				action: anAction keyEquivalent: [NSString string]];
		
		MI.tag = iTM2MacintoshEOL;
		MI.target = aTarget;
	
		MI = [menu addItemWithTitle:[self nameOfEOL:iTM2UNIXEOL]
					action: anAction keyEquivalent: [NSString string]];
		MI.tag = iTM2UNIXEOL;
		MI.target = aTarget;
	
		MI = [menu addItemWithTitle:[self nameOfEOL:iTM2WindowsEOL]
					action: anAction keyEquivalent: [NSString string]];
		MI.tag = iTM2WindowsEOL;
		MI.target = aTarget;
	
		MI = [menu addItemWithTitle:[self nameOfEOL:iTM2UnknownEOL]
					action: anAction keyEquivalent: [NSString string]];
		MI.tag = iTM2UnknownEOL;
		MI.target = aTarget;
	}
//END4iTM3;
    return menu;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingMenuWithAction:target:
+ (NSMenu *)stringEncodingMenuWithAction:(SEL)anAction target:(id)aTarget;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMenu * menu = [[[NSMenu alloc] initWithTitle:
        NSLocalizedStringFromTableInBundle(@"Text Encoding", TABLE, BUNDLE, "Title of string encodings menu")] autorelease];
    BOOL canInsertSeparatorItem = NO;
    for (NSNumber * number in self.supportedStringEncodings) {
        if ([number respondsToSelector:@selector(unsignedIntegerValue)]) {
            NSStringEncoding encoding = [number unsignedIntegerValue];
            NSString * title = [NSString localizedNameOfStringEncoding:encoding];
            if (!title.length)
                title = [NSString stringWithFormat:@"StringEncoding:%d", encoding];
			NSMenuItem * MI = [menu addItemWithTitle:title action:anAction keyEquivalent:[NSString string]];
			MI.tag = encoding;
			MI.target = aTarget;
			canInsertSeparatorItem = YES;
//            NSLog(@"encoding %@ for %u", MI.title, MI.tag);
        } else if (canInsertSeparatorItem) {
            [menu addItem:[NSMenuItem separatorItem]];
            canInsertSeparatorItem = NO;
        }
    }
    return menu;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  supportedStringEncodings
+ (NSArray *)supportedStringEncodings;
/*"StringEncodings.plist file contains an array of integers.
StringEncodings constants in the StringEncodings.plist are meant in core foundation sense, not in yellow box sense.
However, they are in yellow box sense in the returned array.
If the file ~/Library/Application Support/iTeXMac2/General/StringEncoding.plist does not exist,
such a file is seeked for in the main bundle. If nothing has been found, a default array is returned.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001)
To do list: External stringEncodings are not supported now.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if 1
    NSArray * encodingStringsFromFile = nil;
    for (NSURL * url in [[NSBundle mainBundle] allURLsForResource4iTM3:@"StringEncodings" withExtension:@"plist"]) {
        if (encodingStringsFromFile = [NSArray arrayWithContentsOfURL:url]) {
			if (iTM2DebugEnabled) {
				LOG4iTM3(@"url is: %@", url);
			}
            goto abacab;
		}
    }
    LOG4iTM3(@"WARNING: Missing a  a StringEncodings.plist, please reinstall");
	return [NSArray array];
abacab:;
//LOG4iTM3(@"encodingStringsFromFile is: %@", encodingStringsFromFile);
 	NSMutableArray * result = [NSMutableArray array];
	BOOL canInsertNull = NO;
	for(NSString * O in encodingStringsFromFile) {
		if ([O isKindOfClass:[NSString class]])
		{
			if (O.length) {
				NSUInteger encoding = [self coreFoundationStringEncodingWithName:O];
                encoding = encoding == kCFStringEncodingInvalidId?[O integerValue]:CFStringConvertEncodingToNSStringEncoding(encoding);
				[result addObject:[NSNumber numberWithUnsignedInteger:encoding]];
				canInsertNull = YES;
			} else if (canInsertNull) {
				[result addObject:[NSString string]];
				canInsertNull = NO;
			}
		} else if ([O respondsToSelector:@selector(unsignedIntegerValue)]) {
			[result addObject:[NSNumber numberWithUnsignedInteger:[(NSNumber*)O unsignedIntegerValue]]];
			canInsertNull = YES;
		} else if (iTM2DebugEnabled) {
			LOG4iTM3(@"Ignored O is: <%@>", O);
		}
    }
	if (result.count) {
		return result;
    }
	LOG4iTM3(@"Hard coded stringEncoding list...");
#endif
    return [NSArray arrayWithObjects:
                    [NSNumber numberWithUnsignedInteger:NSMacOSRomanStringEncoding],
                    [NSNumber numberWithUnsignedInteger:NSWindowsCP1252StringEncoding],
                    [NSNumber numberWithUnsignedInteger:NSISOLatin1StringEncoding],
                    [NSNumber numberWithUnsignedInteger:
                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacCentralEurRoman)],
                    [NSNumber numberWithUnsignedInteger:
                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsLatin2)],
                    [NSNumber numberWithUnsignedInteger:
                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin2)],
                    [NSNumber numberWithUnsignedInteger:NSNEXTSTEPStringEncoding],
                    [NSNumber numberWithUnsignedInteger:NSASCIIStringEncoding],
                    [NSString string],//stands for separatorItem
                    [NSNumber numberWithUnsignedInteger:NSUnicodeStringEncoding],
                    [NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding],
                    [NSNumber numberWithUnsignedInteger:NSNonLossyASCIIStringEncoding],
                                nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.document;
}
@end

@implementation NSObject(iTM2StringFormatKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _iTM2CompareStringEncoding:
- (NSComparisonResult)_iTM2CompareStringEncoding:(NSNumber *)rhs;
/*"Yellow box string encoding returned. Core Foundation string encodings constants used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    if ([self respondsToSelector:@selector(unsignedIntegerValue)])
    {
        if ([rhs respondsToSelector:@selector(unsignedIntegerValue)])
        {
            return [[NSString localizedNameOfStringEncoding:[(NSNumber *)self unsignedIntegerValue]]
                        compare: [NSString localizedNameOfStringEncoding:[rhs unsignedIntegerValue]]];
        }
        else
            return NSOrderedAscending;
    }
    else
        return NSOrderedDescending;
}

@end

@implementation NSDocument(iTM2StringFormatController)
- (id)stringFormatter4iTM3;
{DIAGNOSTIC4iTM3;
	return nil;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringFormatKit

extern NSString * const iTM2DraggingStringEncodingPboardType;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2EncodingDocument

@interface iTM2StringEncodingFormatter: NSFormatter
@end

NSString * const iTM2DraggingStringEncodingPboardType = @"iTM2DraggingStringEncodingList";

#import "iTM2ValidationKit.h"

@implementation iTM2StringEncodingDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self = [super init])
	{
		[_ActualStringEncodings autorelease];
		_ActualStringEncodings = [[iTM2StringFormatController supportedStringEncodings] mutableCopy];
	}
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
- (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSStringFromClass(self.class);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument4iTM3Error:
- (id)newRecentDocument4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (IBAction)saveDocument:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self writeToURL:self.fileURL ofType:self.fileType error:nil])
	{
		[INC postNotificationName:iTM2StringEncodingListDidChangeNotification object:nil];
		[self updateChangeCount:NSChangeCleared];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocument:
- (BOOL)validateSaveDocument:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.isDocumentEdited;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentAs:
- (IBAction)saveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentAs:
- (BOOL)validateSaveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentTo:
- (IBAction)saveDocumentTo:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentTo:
- (BOOL)validateSaveDocumentTo:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [_ActualStringEncodings writeToURL:absoluteURL atomically:YES];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
//- (BOOL) readFromFile: (NSString *) fileName ofType: (NSString *) irrelevantType;
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = YES;
	_ActualStringEncodings = [NSMutableArray arrayWithContentsOfURL:absoluteURL];
	if (!_ActualStringEncodings)
	{
		result = NO;
		_ActualStringEncodings = [NSMutableArray array];
	}
	[_ActualStringEncodings retain];
    [actualTableView reloadData];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delete:
- (IBAction)delete:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
	NSIndexSet * IS = [actualTableView selectedRowIndexes];
	NSInteger row = [IS firstIndex];
	while(row != NSNotFound) {
        [_ActualStringEncodings replaceObjectAtIndex:row withObject:@"REMOVE"];
		row = [IS indexGreaterThanIndex:row];
	}
    NSInteger index = ZER0;
    row = -1;
    while(index<_ActualStringEncodings.count)
        if ([[_ActualStringEncodings objectAtIndex:index] isEqual:@"REMOVE"])
        {
            [_ActualStringEncodings removeObjectAtIndex:index];
            if (row<ZER0)
                row = index;
        }
        else
            ++index;
    [actualTableView reloadData];
    if (row<[actualTableView numberOfRows])
        [actualTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
    else
        [actualTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:([actualTableView numberOfRows] - 1)] byExtendingSelection:NO];
	if ([actualTableView acceptsFirstResponder])
	{
		[actualTableView.window makeFirstResponder:actualTableView];
	}
    [self updateChangeCount:NSChangeDone];
    self.validateWindowsContents4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDelete:
- (BOOL)validateDelete:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ([actualTableView numberOfSelectedRows]>ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSelection:
- (IBAction)addSelection:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//STARTNSTableView4iTM3
    id O = [[availableTableView dataSource]
                    tableView: availableTableView
                        objectValueForTableColumn: nil
                            row: [availableTableView selectedRow]];
    if (O) {
        NSInteger targetRow = [actualTableView selectedRow];
        if (targetRow<ZER0)
            targetRow = [actualTableView numberOfRows];
        else if (targetRow<[actualTableView numberOfRows])
            ++targetRow;
        [_ActualStringEncodings insertObject:O atIndex:targetRow];
        [actualTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:targetRow] byExtendingSelection:NO];
        [self updateChangeCount:NSChangeDone];
        [actualTableView reloadData];
        self.validateWindowsContents4iTM3;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSeparator:
- (IBAction)addSeparator:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//STARTNSTableView4iTM3
    NSInteger SR = [actualTableView selectedRow];
    if (SR<ZER0)
        SR = _ActualStringEncodings.count;
    else if (SR < _ActualStringEncodings.count)
        ++SR;
    [_ActualStringEncodings insertObject:[NSString string] atIndex:SR];
    [actualTableView reloadData];
    [actualTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:SR] byExtendingSelection:NO];
 	if ([actualTableView acceptsFirstResponder])
	{
		[actualTableView.window makeFirstResponder:actualTableView];
	}
    [self updateChangeCount:NSChangeDone];
    self.validateWindowsContents4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerDidLoadNib:
- (void)windowControllerDidLoadNib:(NSWindowController *)windowController;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowControllerDidLoadNib:windowController];
    if (!_ActualStringEncodings)
    {
        [_ActualStringEncodings autorelease];
        _ActualStringEncodings = [[NSMutableArray array] retain];
    }
    [[[[availableTableView tableColumns] lastObject] dataCell] setFormatter:[[[iTM2StringEncodingFormatter alloc] init] autorelease]];
    [[[[actualTableView tableColumns] lastObject] dataCell] setFormatter:[[[iTM2StringEncodingFormatter alloc] init] autorelease]];
    [actualTableView registerForDraggedTypes:[NSArray arrayWithObject:iTM2DraggingStringEncodingPboardType]];
    availableTableView.doubleAction = @selector(addSelection:);
    [actualTableView reloadData];
    self.validateWindowsContents4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [tableView isEqual:actualTableView]? _ActualStringEncodings.count:[[iTM2StringFormatController availableStringEncodings] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([tableView isEqual:actualTableView])
    {
        if ((row>=ZER0) && (row < _ActualStringEncodings.count))
            return [_ActualStringEncodings objectAtIndex:row];
    }
    else
    {
        if ((row>=ZER0) && (row < [[iTM2StringFormatController availableStringEncodings] count]))
            return [[iTM2StringFormatController availableStringEncodings] objectAtIndex:row];
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:writeRowsWithIndexes:toPasteboard:
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (rowIndexes.count)
    {
		NSData * D = [NSArchiver archivedDataWithRootObject:rowIndexes];
        return ([pboard changeCount] !=
            [pboard declareTypes:[NSArray arrayWithObject:iTM2DraggingStringEncodingPboardType] owner:nil])
		&& [pboard setData:D forType:iTM2DraggingStringEncodingPboardType];
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:validateDrop:proposedRow:proposedDropOperation:
- (NSDragOperation)tableView:(NSTableView *)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([tv isEqual:actualTableView])
    {
//NSLog(@"Move or copy %x = %x = %x", tv, actualTableView, [info draggingSource]);
        if ((ZER0<=row) && (row < [tv numberOfRows]))
            [tv setDropRow:row dropOperation:NSTableViewDropAbove];
        else
            [tv setDropRow:[tv numberOfRows] dropOperation:NSTableViewDropAbove];
        return [[info draggingSource] isEqual:tv]? NSDragOperationMove:NSDragOperationCopy;
    }
    return NSDragOperationNone;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:acceptDrop:row:dropOperation:
- (BOOL)tableView:(NSTableView *)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([tv isEqual:actualTableView])
    {
        if ([tv isEqual:[info draggingSource]])
        {
            //move operation:
 			NSIndexSet * anIS = [NSUnarchiver unarchiveObjectWithData:[[info draggingPasteboard] dataForType:iTM2DraggingStringEncodingPboardType]];
            NSInteger index = [anIS firstIndex];
			NSMutableArray * MRA = [NSMutableArray array];
            id draggingS = [info draggingSource];
            id dataS = [draggingS dataSource];
            while(index != NSNotFound)
            {
                id O = [dataS tableView:draggingS objectValueForTableColumn:nil row:index];
                if (O)
                {
                    [MRA addObject:O];
                    [_ActualStringEncodings replaceObjectAtIndex:index withObject:@"REPLACE"];
                }
				index = [anIS indexGreaterThanIndex:index];
            }
            for(NSNumber * N in [MRA reverseObjectEnumerator])
                [_ActualStringEncodings insertObject:N atIndex:row];
            index = ZER0;
            while(index<_ActualStringEncodings.count)
            {
                if ([[_ActualStringEncodings objectAtIndex:index] isEqual:@"REPLACE"])
                {
                    if (index<row)
                        --row;
                    [_ActualStringEncodings removeObjectAtIndex:index];
                }
                else
                    ++index;
            }
            [tv reloadData];
            NSMutableIndexSet * IS = [NSMutableIndexSet indexSet];
			[IS addIndexesInRange:iTM3MakeRange(row,MRA.count)];
			[tv selectRowIndexes:IS byExtendingSelection:NO];
			if ([tv acceptsFirstResponder])
			{
				[tv.window makeFirstResponder:tv];
			}
			[self updateChangeCount:NSChangeDone];
            self.validateWindowsContents4iTM3;
            return YES;
        }
        else
        {
			NSIndexSet * anIS = [NSUnarchiver unarchiveObjectWithData:[[info draggingPasteboard] dataForType:iTM2DraggingStringEncodingPboardType]];
            NSInteger idx = [anIS lastIndex];
            NSInteger length = ZER0;
            id draggingS = [info draggingSource];
            id dataS = [draggingS dataSource];
            while(idx != NSNotFound)
            {
                id O = [dataS tableView:draggingS objectValueForTableColumn:nil row:idx];
                if (O)
                {
                    [_ActualStringEncodings insertObject:O atIndex:idx];
                    ++length;
                }
				idx = [anIS indexLessThanIndex:idx];
            }
            [tv reloadData];
			NSMutableIndexSet * IS = [NSMutableIndexSet indexSet];
			[IS addIndexesInRange:iTM3MakeRange(row,length)];
			[tv selectRowIndexes:IS byExtendingSelection:NO];
            [self updateChangeCount:NSChangeDone];
            self.validateWindowsContents4iTM3;
            return YES;
        }
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.validateWindowsContents4iTM3;
    return;
}
#if 0
// optional @implementation MyOutlineView 

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
    if (isLocal) return NSDragOperationEvery;
    else return NSDragOperationCopy;
}

@end
registerForDragged
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;

// optional - drag and drop support
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the table view once this call returns with YES.  The rows array is the list of row numbers that will be participating in the drag.

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op;
    // This method is used by NSTableView to determine a valid drop target.  Based on the mouse position, the table view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropRow:dropOperation: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.
#endif
@synthesize _ActualStringEncodings;
@synthesize availableTableView;
@synthesize actualTableView;
@end

@implementation iTM2StringEncodingFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringForObjectValue:
- (NSString *)stringForObjectValue:(id)obj;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * result = [NSString string];
    if ([obj respondsToSelector:@selector(unsignedIntegerValue)])
    {
        result = [NSString localizedNameOfStringEncoding:[(NSNumber *)obj unsignedIntegerValue]];
    }
    else if ([obj isKindOfClass:[NSString class]] && [(NSString *)obj length])
    {
		NSUInteger encoding = [NSString stringEncodingWithName4iTM3:obj];
		result = [NSString localizedNameOfStringEncoding:encoding];
    }
    if (!result.length)
	{
        result = @"\xE2\x80\x95 ";//[NSString stringWithUTF8String:"―"];
	}
    return result;
}
@end

#import "iTM2TextDocumentKit.h"

@implementation iTM2TextInspector(StringFormatter)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setStringEncoding:sender.tag];
	self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingToggleAuto:
- (IBAction)stringEncodingToggleAuto:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool:!old forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextStandardLocalMask];
	if (!old)
	{
		NSTextStorage * TS = self.textStorage;
		NSString * S = [TS mutableString];
		NSStringEncoding encoding;
		NSRange R;
		[S getHardCodedStringEncoding4iTM3:&encoding range:&R];
		if (R.length)
		{
			[self setStringEncoding:encoding];
		}
	}
	self.validateWindowContent4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStringEncodingToggleAuto:
- (BOOL)validateStringEncodingToggleAuto:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isAuto = [self context4iTM3BoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
    sender.state = (isAuto? NSOnState:NSOffState);
	// now validating all the menu items
	BOOL enabled = !isAuto;
	NSInteger tag = [self context4iTM3IntegerForKey:TWSStringEncodingFileKey domain:iTM2ContextAllDomainsMask];
	BOOL stringEncodingNotAvailable = YES;
	NSMenu * menu = sender.menu;
	for (sender in menu.itemArray) {
		if (sender.action == @selector(takeStringEncodingFromTag:)) {
			[sender setEnabled:enabled];
			if (sender.tag == tag) {
				sender.state = NSOnState;
				stringEncodingNotAvailable = NO;
			} else if ([[sender attributedTitle] length]) {
				[menu removeItem:sender];// the menu item was added because the encoding was missing in the menu
			} else {
				sender.state = NSOffState;
			}
		}
	}
	if (stringEncodingNotAvailable) {
		LOG4iTM3(@"StringEncoding %i is not available", tag);
		NSString * title = [NSString localizedNameOfStringEncoding:tag];
		if (!title.length) {
			title = [NSString stringWithFormat:@"StringEncoding:%u", tag];
        }
		sender = [[[NSMenuItem alloc]
			initWithTitle:title action:@selector(takeStringEncodingFromTag:) keyEquivalent:@""]
				autorelease];
		NSFont * F = [NSFont menuFontOfSize:[NSFont systemFontSize]*1.1];
		F = [SFM convertFont:F toFamily:@"Helvetica"];
		F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:F, NSFontAttributeName, nil];
		[sender setAttributedTitle:[[[NSAttributedString alloc]
			initWithString:title attributes:attributes]
				autorelease]];
		[sender setEnabled:NO];
//		sender.target = self; NO!
		sender.tag = tag;
		sender.state = NSOnState;
		[menu insertItem:sender atIndex:ZER0];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.document setEOL:sender.tag];
	self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeEOLFromTag:
- (BOOL)validateTakeEOLFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger tag = [self.document EOL];
	sender.state = (sender.tag == tag? NSOnState:NSOffState);
	return YES;
}
@end

#import "iTM2PathUtilities.h"

@implementation NSApplication(iTM2StringFormat)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setInteger:sender.tag forKey:iTM2StringEncodingPreferredKey];
    return;
}
#if 0
The job is done by the validateStringEncodingToggleAuto: below
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeStringEncodingFromTag:
- (BOOL)validateTakeStringEncodingFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger expectedTag = [SUD context4iTM3IntegerForKey:iTM2StringEncodingPreferredKey domain:iTM2ContextAllDomainsMask];
    sender.state = (expectedTag == sender.tag? NSOnState:NSOffState);
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingToggleAuto:
- (IBAction)stringEncodingToggleAuto:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [SUD context4iTM3BoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
	[SUD takeContext4iTM3Bool:!old forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStringEncodingToggleAuto:
- (BOOL)validateStringEncodingToggleAuto:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isAuto = [SUD context4iTM3BoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
    sender.state = (isAuto? NSOnState:NSOffState);
	BOOL enabled = !isAuto;
	NSInteger tag = [SUD context4iTM3IntegerForKey:TWSStringEncodingFileKey domain:iTM2ContextAllDomainsMask];
	BOOL stringEncodingNotAvailable = YES;
	NSMenu * menu = sender.menu;
	for (sender in menu.itemArray) {
		if (sender.action == @selector(takeStringEncodingFromTag:)) {
//			sender.target = self; NO !
			[sender setEnabled:enabled];
			if (sender.tag == tag) {
				sender.state = NSOnState;
				stringEncodingNotAvailable = NO;
			} else if ([[sender attributedTitle] length]) {
				[menu removeItem:sender];// the menu item was added because the encoding was missing in the menu
			} else {
				sender.state = NSOffState;
			}
		}
	}
	if (stringEncodingNotAvailable) {
		LOG4iTM3(@"StringEncoding %i is not available", tag);
		NSString * title = [NSString localizedNameOfStringEncoding:tag];
		if (!title.length) {
			title = [NSString stringWithFormat:@"StringEncoding:%u", tag];
        }
		sender = [[[NSMenuItem alloc] initWithTitle:title action:@selector(takeStringEncodingFromTag:) keyEquivalent:@""] autorelease];
		NSFont * F = [NSFont menuFontOfSize:[NSFont systemFontSize]*1.1];
		F = [SFM convertFont:F toFamily:@"Helvetica"];
		F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		[sender setAttributedTitle:[[[NSAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:F, NSFontAttributeName, nil]] autorelease]];
		[sender setEnabled:NO];
//		sender.target = self; NO !
		sender.tag = tag;
		sender.state = NSOnState;
		[menu insertItem:sender atIndex:ZER0];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingEditList:
- (IBAction)stringEncodingEditList:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * subURL = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:iTM2SupportTextComponent inDomain:NSUserDomainMask create:YES];
	NSURL * URL = [[subURL URLByAppendingPathComponent:iTM2StringEncodingsPListName] URLByAppendingPathExtension:@"plist"];
//LOG4iTM3(@"path is: %@", path);
	id D = [SDC documentForURL:URL];
	if (D) {
		[D makeWindowControllers];
		[D showWindows];
		return;
	}
	if (URL.isFileURL && [DFM fileExistsAtPath:URL.path]) {
		D = [[[iTM2StringEncodingDocument alloc]
				initWithContentsOfURL:URL ofType:iTM2StringEncodingsTypeName error:nil] autorelease];
		[SDC addDocument:D];
		[D makeWindowControllers];
		[D showWindows];
		return;
	}
	D = [[[iTM2StringEncodingDocument alloc] init] autorelease];
	[D setFileURL:URL];
	[D setFileType:iTM2StringEncodingsTypeName];
	[SDC addDocument:D];
	[D makeWindowControllers];
	[D showWindows];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self takeContext4iTM3Integer:sender.tag forKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeEOLFromTag:
- (BOOL)validateTakeEOLFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger tag = [self context4iTM3IntegerForKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask];
	sender.state = (sender.tag == tag? NSOnState:NSOffState);
	return YES;
}
@end

@implementation iTM2MainInstaller(StringFormatKit)
+ (void)prepareStringFormatKitCompleteInstallation4iTM3;
{
	[iTM2StringFormatController completeInitialization];
}
@end

//