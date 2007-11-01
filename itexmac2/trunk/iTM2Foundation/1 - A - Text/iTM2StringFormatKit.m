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

#import <iTM2Foundation/iTM2StringFormatKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/ICURegEx.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2TextKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>

// This file must live with iTM2TextDocumentKit

#define TABLE @"Basic"
#define BUNDLE [iTM2StringFormatController classBundle]

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
- (void)getLineStart:(unsigned *)startPtr end:(unsigned *)lineEndPtr contentsEnd:(unsigned *)contentsEndPtr TeXComment:(unsigned *)commentPtr forIndex:(unsigned) index;
@end

@implementation NSString(iTM2StringFormatController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameOfStringEncoding:
+ (NSString *)nameOfStringEncoding:(NSStringEncoding)encoding;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	encoding = CFStringConvertNSStringEncodingToEncoding(encoding);
//iTM2_END;
	return (NSString *)CFStringConvertEncodingToIANACharSetName(encoding);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingWithName:
+ (NSStringEncoding)stringEncodingWithName:(NSString *)name;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	CFStringEncoding encoding = [iTM2StringFormatController coreFoundationStringEncodingWithName:name];
//iTM2_END;
	return CFStringConvertEncodingToNSStringEncoding(encoding);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localizedNameOfEOL:
+ (NSString *)localizedNameOfEOL:(iTM2EOL)LE;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringByUsingEOL:
- (NSString *)stringByUsingEOL:(iTM2EOL)EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * EOLString = [iTM2StringFormatController terminationStringForEOL:EOL];
    NSMutableString * MS = [NSMutableString string];
    NSRange r = NSMakeRange(0, 0);
    unsigned int end = 0, contentsEnd = 0, ceiling = [self length], nextStart = 0;
    unsigned int corrected = 0, total = 0;
//NSLog(@"GLS");
    while(end < ceiling)
    {
        [self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:r];
        if((end>contentsEnd) &&
            ![[self substringWithRange:NSMakeRange(contentsEnd, end - contentsEnd)] isEqualToString:EOLString])
        {
            [MS appendString:[self substringWithRange:NSMakeRange(nextStart, contentsEnd - nextStart)]];
            [MS appendString:EOLString];
            nextStart = end;
            ++corrected;
        }
        ++total;
        r.location = end;
    }
    NSLog(@"line endings corrected: %d of %d", corrected, total);
    if(!nextStart) // the original string used the good line endings
        return self;
    else if(nextStart < ceiling) // there is something left to be copied
        [MS appendString:[self substringWithRange:NSMakeRange(nextStart, ceiling - nextStart)]];
    return MS;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= EOLUsed
- (iTM2EOL)EOLUsed;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"GLS");
    if([self length])
    {
        unsigned contentsEnd, end;
        [self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:NSMakeRange(0, 0)];
        if(end > contentsEnd)
        {
            NSString * EOL = [self substringWithRange:NSMakeRange(contentsEnd, end - contentsEnd)];
            if([EOL isEqualToString:@"\r\n"])
                return iTM2WindowsEOL;
            else if([EOL isEqualToString:@"\r"])
                return iTM2MacintoshEOL;
            else if([EOL isEqualToString:@"\n"])
                return iTM2UNIXEOL;
#if 0
            else if([EOL length] == 1)
            {
                unichar theChar = [EOL characterAtIndex:0];
                if((theChar == 0x2028) || (theChar == 0x2029))
                    return iTM2UTF16EOL;
            }
#endif
            else
                return iTM2UnknownEOL;
        }
    }
    return iTM2UnchangedEOL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getHardCodedStringEncoding:range:
- (void)getHardCodedStringEncoding:(NSStringEncoding *)stringEncodingRef range:(NSRangePointer)rangeRef;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#define ARETABLE @"iTM2StringEncodingRegEx"
#warning QUALITY: test for the existence of the .strings file...
	NSRange R = NSMakeRange(NSNotFound, 0);
    NSString * headerStringEncodingString = [self stringForCommentedKey:iTM2StringEncodingHeaderKey forRange:NSMakeRange(0, 0) effectiveRange:nil inHeader:YES];
	ICURegEx * RE = nil;
//NSLog(@"headerStringEncodingString: %@", headerStringEncodingString);
    #if 1
    if(![headerStringEncodingString length])
    {
        NS_DURING
        RE = [[[ICURegEx allocWithZone:[self zone]] initWithSearchPattern:
                            NSLocalizedStringFromTableInBundle(@"inputenc", ARETABLE, BUNDLE, "") options:0 error:nil] autorelease];
//NSLog(@"ARE: %@", ARE);
		if([RE nextMatch] && [RE numberOfCaptureGroups])
		{
			R = [RE rangeOfCaptureGroupAtIndex:1];
			headerStringEncodingString = [self substringWithRange:R];
		}
//NSLog(@"headerStringEncodingString: %@", headerStringEncodingString);
        NS_HANDLER
//NSLog(@"EXCEPTION");
		iTM2_LOG(@"*** Exception catched (1): %@", [localException reason]);
        headerStringEncodingString = [self stringForCommentedKey:iTM2StringEncodingHeaderKey forRange:NSMakeRange(0, 0) effectiveRange:nil inHeader:YES];
        NS_ENDHANDLER
//NSLog(@"headerStringEncodingString: %@", headerStringEncodingString);
    }
    #endif
    #if 1
    if(![headerStringEncodingString length])
    {
        NS_DURING
        RE = [[[ICURegEx allocWithZone:[self zone]] initWithSearchPattern:
                            NSLocalizedStringFromTableInBundle(@"regime", ARETABLE, BUNDLE, "") options:0 error:nil] autorelease];
//NSLog(@"ARE: %@", ARE);
		if([RE nextMatch] && [RE numberOfCaptureGroups])
		{
			R = [RE rangeOfCaptureGroupAtIndex:1];
			headerStringEncodingString = [self substringWithRange:R];
		}
        NS_HANDLER
		iTM2_LOG(@"*** Exception catched (2): %@", [localException reason]);
        headerStringEncodingString = [self stringForCommentedKey:iTM2StringEncodingHeaderKey forRange:NSMakeRange(0, 0) effectiveRange:nil inHeader:YES];
        NS_ENDHANDLER
    }
    #endif
    #if 1
    if(![headerStringEncodingString length])
    {
        NS_DURING
        RE = [[[ICURegEx allocWithZone:[self zone]] initWithSearchPattern:
                            NSLocalizedStringFromTableInBundle(@"emacs", ARETABLE, BUNDLE, "") options:0 error:nil] autorelease];
//NSLog(@"ARE: %@", ARE);
		if([RE nextMatch] && [RE numberOfCaptureGroups])
		{
			R = [RE rangeOfCaptureGroupAtIndex:1];
			headerStringEncodingString = [self substringWithRange:R];
		}
        NS_HANDLER
		iTM2_LOG(@"*** Exception catched (3): %@", [localException reason]);
        headerStringEncodingString = [self stringForCommentedKey:iTM2StringEncodingHeaderKey forRange:NSMakeRange(0, 0) effectiveRange:nil inHeader:YES];
        NS_ENDHANDLER
    }
    #endif
    #if 1
    if(![headerStringEncodingString length])
    {
        NS_DURING
        RE = [[[ICURegEx allocWithZone:[self zone]] initWithSearchPattern:
                            NSLocalizedStringFromTableInBundle(@"texshop", ARETABLE, BUNDLE, "") options:0 error:nil] autorelease];
//NSLog(@"ARE: %@", ARE);
		if([RE nextMatch] && [RE numberOfCaptureGroups])
		{
			R = [RE rangeOfCaptureGroupAtIndex:1];
			headerStringEncodingString = [self substringWithRange:R];
		}
        NS_HANDLER
		iTM2_LOG(@"*** Exception catched (4): %@", [localException reason]);
        headerStringEncodingString = [self stringForCommentedKey:iTM2StringEncodingHeaderKey forRange:NSMakeRange(0, 0) effectiveRange:nil inHeader:YES];
        NS_ENDHANDLER
    }
    #endif
    if(![headerStringEncodingString length])
    {
        headerStringEncodingString = [self stringForCommentedKey:iTM2StringEncodingHeaderKey forRange:NSMakeRange(0, 0) effectiveRange:nil inHeader:YES];
    }
	if(stringEncodingRef)
	{
		* stringEncodingRef = [NSString stringEncodingWithName:headerStringEncodingString];
	}
	if(rangeRef)
		* rangeRef = R;
    return;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

@interface iTM2StringFormatController(LAZINESS)
- (NSStringEncoding)lazyStringEncoding;
- (unsigned int)lazyEOL;
+ (void)completeInitialization;
@end

@implementation iTM2MainInstaller(StringFormatter)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StringFormatControllerCompleteInstallation
+ (void)iTM2StringFormatControllerCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2StringFormatController completeInitialization];
//iTM2_END;
    return;
}
@end

@interface iTM2StringFormatController(PRIVATE)
+ (void)stringEncodingListDidChangeNotified:(NSNotification *)irrelevant;
@end

@implementation iTM2StringFormatController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2MileStone registerMileStone:@"No Localized menu items available for iTM2StringFormatController" forKey:@"iTM2StringFormatControllerLocalizedMenuItems"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeInitialization
+ (void)completeInitialization;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!iTM2StringEncodingMissingFormat)
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
					[NSNumber numberWithUnsignedInt:iTM2UNIXEOL], iTM2EOLPreferredKey,
					[NSNumber numberWithUnsignedInt:NSMacOSRomanStringEncoding], iTM2StringEncodingPreferredKey,
					[NSNumber numberWithUnsignedInt:NSMacOSRomanStringEncoding], iTM2StringEncodingOpenKey,
					[NSNumber numberWithUnsignedInt:NSMacOSRomanStringEncoding], TWSStringEncodingFileKey,
					[NSNumber numberWithBool:YES], iTM2StringEncodingIsAutoKey,
								nil]];
		BOOL OK = YES;
		NSMenuItem * MI;
		NSString * proposal;
		NSMenu * m;
		MI = [[NSApp mainMenu] deepItemWithAction:@selector(stringEncodingMissingLocale:)];
		proposal = [MI title];
		if(![proposal length] || ([[proposal componentsSeparatedByString:@"%"] count] != 2)
			|| ([[proposal componentsSeparatedByString:@"%@"] count] != 2))
		{
			proposal = @"StringEncoding: %@";
			iTM2_LOG(@"Localization BUG, the menu item with action stringEncodingMissingLocale: in the main menu must exist and contain one %%@,\nand no other formating directive");
			OK = NO;
		}
		[iTM2StringEncodingMissingFormat autorelease];
		iTM2StringEncodingMissingFormat = [proposal copy];
		m = [MI menu];
		[m removeItem:MI];
		[m cleanSeparators];
		MI = [[NSApp mainMenu] deepItemWithAction:@selector(stringEncodingDefault:)];
		proposal = [MI title];
		if(![proposal length]
			|| ([[proposal componentsSeparatedByString:@"%"] count] != 2)
				|| ([[proposal componentsSeparatedByString:@"%@"] count] != 2))
		{
			proposal = @"Default: %@";
			iTM2_LOG(@"Localization BUG, the menu item with action stringEncodingDefault: in the main menu must exist and contain one %%@,\nand no other formating directive");
			OK = NO;
		}
		[iTM2StringEncodingDefaultFormat autorelease];
		iTM2StringEncodingDefaultFormat = [proposal copy];
		m = [MI menu];
		[m removeItem:MI];
		[m cleanSeparators];
		MI = [[NSApp mainMenu] deepItemWithAction:@selector(EOLDefault:)];
		proposal = [MI title];
		if(![proposal length] || ([[proposal componentsSeparatedByString:@"%"] count] != 2) || ([[proposal componentsSeparatedByString:@"%@"] count] != 2))
		{
			proposal = @"Default: %@";
			iTM2_LOG(@"Localization BUG, the menu item with action EOLDefault: in the main menu must exist and contain one %%@,\nand no other formating directive");
			OK = NO;
		}
		if(OK)
			[iTM2MileStone putMileStoneForKey:@"iTM2StringFormatControllerLocalizedMenuItems"];
		[iTM2EOLDefaultFormat autorelease];
		iTM2EOLDefaultFormat = [proposal copy];
		m = [MI menu];
		[m removeItem:MI];
		[m cleanSeparators];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenuItem * stringEncodingMI = [[NSApp mainMenu] deepItemWithAction:@selector(stringEncodingEditList:)];
	[stringEncodingMI setTarget:nil];
	NSMenu * M = [stringEncodingMI menu];
	// removing all the menu items with the stringEncodingSelect:
	NSEnumerator * E = [[M itemArray] objectEnumerator];
	id MI;
	while(MI = [E nextObject])
		if([MI action] == @selector(takeStringEncodingFromTag:) && (![MI target]))
			[M removeItem:MI];
	// adding the string encoding menu items
	int index = [M indexOfItem:stringEncodingMI];
	[M insertItem:[NSMenuItem separatorItem] atIndex:index];
	E = [[[iTM2StringFormatController stringEncodingMenuWithAction:@selector(takeStringEncodingFromTag:) target:nil]
			itemArray] reverseObjectEnumerator];
	while(MI = [[[E nextObject] retain] autorelease])
	{
		[[MI menu] removeItem:MI];
		[M insertItem:MI atIndex:index];
	}
	[M insertItem:[NSMenuItem separatorItem] atIndex:index];
	[M cleanSeparators];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= terminationStringForEOL:
+ (NSString *)terminationStringForEOL:(iTM2EOL)EOL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!EOL)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    name = [name lowercaseString];
    if([name isEqualToString:@"unchanged"]) return 0;
    if([name isEqualToString:@"unix"]) return iTM2UNIXEOL;
    if([name isEqualToString:@"macintosh"]) return iTM2MacintoshEOL;
    if([name isEqualToString:@"mac"]) return iTM2MacintoshEOL;
    if([name isEqualToString:@"macOS"]) return iTM2MacintoshEOL;
    if([name isEqualToString:@"windows"]) return iTM2WindowsEOL;
    if([name isEqualToString:@"vista"]) return iTM2WindowsEOL;
    if([name isEqualToString:@"\r"]) return iTM2MacintoshEOL;
    if([name isEqualToString:@"\n"]) return iTM2UNIXEOL;
    if([name isEqualToString:@"\r\n"]) return iTM2WindowsEOL;
    return iTM2UnknownEOL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= encodingsDictionary
+ (NSDictionary *)encodingsDictionary;
/*"Read in iTM2Encodings.plist. Contains the correspondance emacs or regime name -> mac os x encoding.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![argument isKindOfClass:[NSString class]])
	{
		if([argument respondsToSelector:@selector(intValue)])
		{
			return [argument intValue];
		}
		return kCFStringEncodingInvalidId;
	}
	if(![argument length])
	{
		return kCFStringEncodingInvalidId;
	}
	argument = [NSString stringWithFormat:@" %@ ",argument];
	argument = [argument stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	CFStringEncoding result = CFStringConvertIANACharSetNameToEncoding((CFStringRef)argument);
    if(result != kCFStringEncodingInvalidId)
	{
		return result;
	}
    NSScanner * S = [NSScanner scannerWithString:argument];
    [S setCaseSensitive:NO];
	CFStringEncoding CFSE;
    // a Core Foundation number
    if([S scanInt:(int*)&result])
    {
        if(!CFStringIsEncodingAvailable(result))
            result = kCFStringEncodingInvalidId;
    }
    else if([S scanString:@"non" intoString:nil])
    {
        if([S scanString:@"lossy" intoString:nil] && [S scanString:@"ascii" intoString:nil])
        {
            result = kCFStringEncodingNonLossyASCII;
        }
    }
    else if([S scanString:@"nextstep" intoString:nil] && [S scanString:@"latin" intoString:nil]
		||[S scanString:@"next" intoString:nil])
    {
        result = kCFStringEncodingNextStepLatin;
    }
    else if([S scanString:@"ascii" intoString:nil])
    {
        result = kCFStringEncodingASCII;
    }
    else if([S scanString:@"applemac" intoString:nil])
    {
        result = kCFStringEncodingMacRoman;
    }
    else if([S scanString:@"unicode" intoString:nil])
    {
        result = kCFStringEncodingUnicode;
    }
    else if([S scanString:@"utf" intoString:nil])
	{
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
		if([S scanString:@"8" intoString:nil])
		{
			result = kCFStringEncodingUTF8;
		}
		else if([S scanString:@"16" intoString:nil])
		{
			if([S scanString:@"b" intoString:nil])
			{
				result = kCFStringEncodingUTF16BE;
			}
			else if([S scanString:@"l" intoString:nil])
			{
				result = kCFStringEncodingUTF16LE;
			}
			else
			{
				result = kCFStringEncodingUTF16;
			}
		}
		else if([S scanString:@"32" intoString:nil])
		{
			if([S scanString:@"b" intoString:nil])
			{
				result = kCFStringEncodingUTF32BE;
			}
			else if([S scanString:@"l" intoString:nil])
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
    else if([S scanString:@"mac" intoString:nil])
    {
        if([S scanString:@"roman" intoString:nil])
            result = kCFStringEncodingMacRoman;
        else if([S scanString:@"japanese" intoString:nil])
            result = kCFStringEncodingMacJapanese;
        else if([S scanString:@"korean" intoString:nil])
            result = kCFStringEncodingMacKorean;
        else if([S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingMacArabic;
        else if([S scanString:@"hebrew" intoString:nil])
            result = kCFStringEncodingMacHebrew;
        else if([S scanString:@"greek" intoString:nil])
            result = kCFStringEncodingMacGreek;
        else if([S scanString:@"cyrillic" intoString:nil])
            result = kCFStringEncodingMacCyrillic;
        else if([S scanString:@"devanagari" intoString:nil])
            result = kCFStringEncodingMacDevanagari;
        else if([S scanString:@"gurmukhi" intoString:nil])
            result = kCFStringEncodingMacGurmukhi;
        else if([S scanString:@"gujarati" intoString:nil])
            result = kCFStringEncodingMacGujarati;
        else if([S scanString:@"oriya" intoString:nil])
            result = kCFStringEncodingMacOriya;
        else if([S scanString:@"bengali" intoString:nil])
            result = kCFStringEncodingMacBengali;
        else if([S scanString:@"tamil" intoString:nil])
            result = kCFStringEncodingMacTamil;
        else if([S scanString:@"telugu" intoString:nil])
            result = kCFStringEncodingMacTelugu;
        else if([S scanString:@"kannada" intoString:nil])
            result = kCFStringEncodingMacKannada;
        else if([S scanString:@"malayalam" intoString:nil])
            result = kCFStringEncodingMacMalayalam;
        else if([S scanString:@"sinhalese" intoString:nil])
            result = kCFStringEncodingMacSinhalese;
        else if([S scanString:@"burmese" intoString:nil])
            result = kCFStringEncodingMacBurmese;
        else if([S scanString:@"khmer" intoString:nil])
            result = kCFStringEncodingMacKhmer;
        else if([S scanString:@"thai" intoString:nil])
            result = kCFStringEncodingMacThai;
        else if([S scanString:@"laotian" intoString:nil])
            result = kCFStringEncodingMacLaotian;
        else if([S scanString:@"georgian" intoString:nil])
            result = kCFStringEncodingMacGeorgian;
        else if([S scanString:@"armenian" intoString:nil])
            result = kCFStringEncodingMacArmenian;
        else if([S scanString:@"chinese" intoString:nil] && [S scanString:@"traditional" intoString:nil])
            result = kCFStringEncodingMacChineseTrad;
        else if([S scanString:@"chinese" intoString:nil] && [S scanString:@"simplified" intoString:nil])
            result = kCFStringEncodingMacChineseSimp;
        else if([S scanString:@"tibetan" intoString:nil])
            result = kCFStringEncodingMacTibetan;
        else if([S scanString:@"mongolian" intoString:nil])
            result = kCFStringEncodingMacMongolian;
        else if([S scanString:@"ethiopic" intoString:nil])
            result = kCFStringEncodingMacEthiopic;
        else if([S scanString:@"central" intoString:nil] &&	
                    [S scanString:@"european" intoString:nil] &&
                        [S scanString:@"roman" intoString:nil])
            result = kCFStringEncodingMacCentralEurRoman;
        else if([S scanString:@"vietnamese" intoString:nil])
            result = kCFStringEncodingMacVietnamese;
        else if([S scanString:@"extended" intoString:nil] && [S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingMacExtArabic;
        else if([S scanString:@"symbol" intoString:nil])
            result = kCFStringEncodingMacSymbol;
        else if([S scanString:@"dingbats" intoString:nil])
            result = kCFStringEncodingMacDingbats;
        else if([S scanString:@"turkish" intoString:nil])
            result = kCFStringEncodingMacTurkish;
        else if([S scanString:@"croatian" intoString:nil])
            result = kCFStringEncodingMacCroatian;
        else if([S scanString:@"icelandic" intoString:nil])
            result = kCFStringEncodingMacIcelandic;
        else if([S scanString:@"romanian" intoString:nil])
            result = kCFStringEncodingMacRomanian;
        else if([S scanString:@"celtic" intoString:nil])
            result = kCFStringEncodingMacCeltic;
        else if([S scanString:@"gaelic" intoString:nil])
            result = kCFStringEncodingMacGaelic;
        else if([S scanString:@"farsi" intoString:nil])
            result = kCFStringEncodingMacFarsi;
        else if([S scanString:@"ukrainian" intoString:nil])
            result = kCFStringEncodingMacUkrainian;
        else if([S scanString:@"inuit" intoString:nil])
            result = kCFStringEncodingMacInuit;
        else if([S scanString:@"vt100" intoString:nil])
            result = kCFStringEncodingMacVT100;
        else if([S scanString:@"cyr" intoString:nil])//context
            result = kCFStringEncodingMacVT100;
        else if([S scanString:@"ukr" intoString:nil])//context
            result = kCFStringEncodingMacVT100;
        else
            result = kCFStringEncodingMacRoman;
    }
    else if([S scanString:@"iso" intoString:nil])
    {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        if([S scanString:@"8859" intoString:nil])
        {
            [S scanInt:(int*)&CFSE];
            switch(CFSE)
            {
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
        else if([S scanString:@"latin" intoString:nil])
        {
            [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
            if([S scanInt:(int*)&CFSE])
                switch(CFSE)
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
            else if([S scanString:@"cyrillic" intoString:nil])
                result = kCFStringEncodingISOLatinCyrillic;
            else if([S scanString:@"arabic" intoString:nil])
                result = kCFStringEncodingISOLatinArabic;
            else if([S scanString:@"greek" intoString:nil])
                result = kCFStringEncodingISOLatinGreek;
            else if([S scanString:@"hebrew" intoString:nil])
                result = kCFStringEncodingISOLatinHebrew;
            else if([S scanString:@"thai" intoString:nil])
                result = kCFStringEncodingISOLatinThai;
        }
    }
    else if([S scanString:@"dos" intoString:nil])
    {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        if([S scanString:@"latin" intoString:nil] && [S scanString:@"us" intoString:nil])
            result = kCFStringEncodingDOSLatinUS;
        else if([S scanString:@"greek" intoString:nil])
            result = kCFStringEncodingDOSGreek;
        else if([S scanString:@"baltic" intoString:nil] && [S scanString:@"rim" intoString:nil])
            result = kCFStringEncodingDOSBalticRim;
        else if([S scanString:@"cyrillic" intoString:nil])
            result = kCFStringEncodingDOSCyrillic;
        else if([S scanString:@"turkish" intoString:nil])
            result = kCFStringEncodingDOSTurkish;
        else if([S scanString:@"potuguese" intoString:nil])
            result = kCFStringEncodingDOSPortuguese;
        else if([S scanString:@"icelandic" intoString:nil])
            result = kCFStringEncodingDOSIcelandic;
        else if([S scanString:@"hebrew" intoString:nil])
            result = kCFStringEncodingDOSHebrew;
        else if([S scanString:@"canadian" intoString:nil] && [S scanString:@"french" intoString:nil])
            result = kCFStringEncodingDOSCanadianFrench;
        else if([S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingDOSArabic;
        else if([S scanString:@"nordic" intoString:nil])
            result = kCFStringEncodingDOSNordic;
        else if([S scanString:@"russian" intoString:nil])
            result = kCFStringEncodingDOSRussian;
        else if([S scanString:@"thai" intoString:nil])
            result = kCFStringEncodingDOSThai;
        else if([S scanString:@"japanese" intoString:nil])
            result = kCFStringEncodingDOSJapanese;
        else if([S scanString:@"chinese" intoString:nil] && [S scanString:@"simplified" intoString:nil])
            result = kCFStringEncodingDOSChineseSimplif;
        else if([S scanString:@"korean" intoString:nil])
            result = kCFStringEncodingDOSKorean;
        else if([S scanString:@"chinese" intoString:nil] && [S scanString:@"traditional" intoString:nil])
            result = kCFStringEncodingDOSChineseTrad;
        else if([S scanString:@"latin" intoString:nil])
        {
            [S scanInt:(int*)&CFSE];
            switch(CFSE)
            {
                case 1: result = kCFStringEncodingDOSLatin1; break;
                case 2: result = kCFStringEncodingDOSLatin2; break;
            }
        }
        else if([S scanString:@"greek" intoString:nil])
        {
            [S scanInt:(int*)&CFSE];
            switch(CFSE)
            {
                case 1: result = kCFStringEncodingDOSGreek1; break;
                case 2: result = kCFStringEncodingDOSGreek2; break;
            }
        }
    }
    else if([S scanString:@"windows" intoString:nil])
    {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        if([S scanString:@"nt" intoString:nil])
        {
            if([S scanString:@"korean" intoString:nil] && [S scanString:@"johab" intoString:nil])
                result = kCFStringEncodingWindowsKoreanJohab;
        }
        else if([S scanString:@"baltic" intoString:nil] && [S scanString:@"rim" intoString:nil])
            result = kCFStringEncodingWindowsBalticRim;
        else if([S scanString:@"thai" intoString:nil])
            result = kCFStringEncodingDOSThai;
        else if([S scanString:@"japanese" intoString:nil])
            result = kCFStringEncodingDOSJapanese;
        else if([S scanString:@"chinese" intoString:nil] && [S scanString:@"simplified" intoString:nil])
            result = kCFStringEncodingDOSChineseSimplif;
        else if([S scanString:@"chinese" intoString:nil] && [S scanString:@"traditional" intoString:nil])
            result = kCFStringEncodingDOSChineseTrad;
        else if([S scanString:@"korean" intoString:nil])
            result = kCFStringEncodingDOSKorean;
        else if([S scanString:@"cyrillic" intoString:nil])
            result = kCFStringEncodingWindowsCyrillic;
        else if([S scanString:@"greek" intoString:nil])
            result = kCFStringEncodingWindowsGreek;
        else if([S scanString:@"hebrew" intoString:nil])
            result = kCFStringEncodingWindowsHebrew;
        else if([S scanString:@"arabic" intoString:nil])
            result = kCFStringEncodingWindowsArabic;
        else if([S scanString:@"vietnamese" intoString:nil])
            result = kCFStringEncodingWindowsVietnamese;
        else if([S scanString:@"latin" intoString:nil])
        {
            [S scanInt:(int*)&CFSE];
            switch(CFSE)
            {
                case 1: result = kCFStringEncodingWindowsLatin1; break;
                case 2: result = kCFStringEncodingWindowsLatin2; break;
                case 5: result = kCFStringEncodingWindowsLatin5; break;
            }
        }
    }
    else if(([S scanString:@"code" intoString:nil] && [S scanString:@"page" intoString:nil]) ||
                        ([S scanString:@"cp" intoString:nil]))
    {
        [S setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@" -\t"]];
        [S scanInt:(int*)&CFSE];
        switch(CFSE)
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
    else if([S scanString:@"il1" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingISOLatin1;
    }
    else if([S scanString:@"il9" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingISOLatin9;
    }
    else if([S scanString:@"win" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingWindowsLatin1;
    }
    else if([S scanString:@"mac" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingMacRoman;
    }
    else if([S scanString:@"ibm" intoString:nil])//ConTeXt support IBM PC DOS	western european languages
    {
        result = kCFStringEncodingEBCDIC_CP037;
    }
    else if([S scanString:@"grk" intoString:nil])
    {
        result = kCFStringEncodingISOLatinGreek;
    }
    else if([S scanString:@"koi8-r" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingKOI8_R;
    }
    else if([S scanString:@"koi8-u" intoString:nil])//ConTeXt support
    {
        result = kCFStringEncodingKOI8_U;
    }
    else if([S scanString:@"latin" intoString:nil] || [S scanString:@"il" intoString:nil])
	{
		CFStringEncoding CFSE;
		[S scanInt:(int*)&CFSE];
		switch(CFSE)
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
	if(result == kCFStringEncodingInvalidId)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = (NSString *)CFStringConvertEncodingToIANACharSetName(encoding);
	if([result length])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSArray * g_iTM2AvailableStringEncodings = nil;
    if (!g_iTM2AvailableStringEncodings)
    {
        NSLock * L = [[[NSLock allocWithZone:[self zone]] init] autorelease];
        [L lock];
        const CFStringEncoding * CFSGLOAEs = CFStringGetListOfAvailableEncodings();
        int count = 0;
        while (CFSGLOAEs[count] != kCFStringEncodingInvalidId)
            count++;
        NSMutableArray * MRA = [NSMutableArray array];
        int index = 0;
        for (index = 0; index < count; index++)
        {
            NSStringEncoding NSSE = CFStringConvertEncodingToNSStringEncoding(CFSGLOAEs[index]);
            if (NSSE && [NSString localizedNameOfStringEncoding:NSSE])
                [MRA addObject:[NSNumber numberWithUnsignedInt:NSSE]];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super init])
	{
		[self setDocument:document];
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataWithString:allowLossyConversion:
- (NSData *)dataWithString:(NSString *)argument allowLossyConversion:(BOOL)lossy;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [argument dataUsingEncoding:[self stringEncoding] allowLossyConversion:lossy];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canConvertString:
- (BOOL)canConvertString:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ![argument length] || [argument canBeConvertedToEncoding:[self stringEncoding]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nextUnconvertibleCharacterIndexOfString:startingAt:
- (unsigned int)nextUnconvertibleCharacterIndexOfString:(NSString *)argument startingAt:(unsigned int)index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(index<0)
        return NSNotFound;
    noumea:
    if(index<[argument length])
    {
        unichar c = [argument characterAtIndex:index];
        NSString * S = [[[NSString allocWithZone:[self zone]]
                            initWithCharactersNoCopy: &c length: 1 freeWhenDone: NO] autorelease];
        BOOL canBeConverted = [S canBeConvertedToEncoding:[self stringEncoding]];
        if(canBeConverted)
        {
            ++index;
            goto noumea;
        }
        else
            return index;
    }
    else
        return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringWithData:
- (NSString *)stringWithData:(NSData *)docData;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * string = @"";
	if(![docData length])
	{
		return string;
	}
    NSStringEncoding usedStringEncoding = 0;
    BOOL canStringEncoding = NO;
    NSString * hardStringEncodingString = @"";
    // testing for UTF32, UTF16 and UTF8 encodings, see http://unicode.org/faq/utf_bom.html#22
    char byteOrder [8] = {'0','0','0','0','0','0','0','0'};
    if([docData length]>=8)
        memmove(byteOrder, [docData bytes], 8);
    else if([docData length]>=6)
        memmove(byteOrder, [docData bytes], 6);
    else if([docData length]>=4)
        memmove(byteOrder, [docData bytes], 4);
    if(!strncmp(byteOrder, "\0\0\0\0FEFF", 8))
    {
        usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32BE);
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
    }
    else if(!strncmp(byteOrder, "FFFE\0\0\0\0", 4))
    {
        usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF32LE);
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
    }
    else if(!strncmp(byteOrder, "FFFE", 4))
    {
        usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16LE);
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
    }
    else if(!strncmp(byteOrder, "FEFF", 4))
    {
        usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16BE);
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
    }
    else if(!strncmp(byteOrder, "EFBBBF", 6))
    {
        usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
    }
    else if([self contextBoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask])
    {
		// guess the string from the file contents
        NSStringEncoding preferredStringEncoding = [self stringEncoding];
        if(![[NSString localizedNameOfStringEncoding:preferredStringEncoding] length])
        {
            preferredStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
            [SUD setInteger:preferredStringEncoding forKey:iTM2StringEncodingPreferredKey];
        }
		#define HEADER_LIMIT 8*125
		NSRange range = NSMakeRange(0,MIN(HEADER_LIMIT,[docData length]));
		NSData * headerData = [docData subdataWithRange:range];
        string = [[[NSString allocWithZone:[self zone]] initWithData:headerData encoding:preferredStringEncoding] autorelease];
        NSStringEncoding hardCodedStringEncoding;
		NSRange hardCodedRange;
		[string getHardCodedStringEncoding:&hardCodedStringEncoding range:&hardCodedRange];
        canStringEncoding = (hardCodedStringEncoding == 0);
        if(hardCodedStringEncoding && ![[NSString localizedNameOfStringEncoding:hardCodedStringEncoding] length])
		{
			iTM2_REPORTERROR(1,(@"Unknown encoding, Did you make a typo?"),nil);
		}
        if(hardCodedStringEncoding && [[NSString localizedNameOfStringEncoding:hardCodedStringEncoding] length] &&
            (hardCodedStringEncoding != preferredStringEncoding))
        {
            usedStringEncoding = hardCodedStringEncoding;
            string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
        }
        else
        {
            usedStringEncoding = preferredStringEncoding;
			if([docData length]>HEADER_LIMIT)
			{
				string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
			}
        }
    }
    else if(usedStringEncoding = [self stringEncoding])
    {
        if(![[NSString localizedNameOfStringEncoding:usedStringEncoding] length])
        {
            usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
        }
		else
		{
			iTM2_LOG(@"Reading data with encoding: %@", [NSString localizedNameOfStringEncoding:usedStringEncoding]);
		}
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
		if(!string)
		{
            usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
			string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
			if(!string)
			{
				usedStringEncoding = NSASCIIStringEncoding;
				string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
			}
		}
        canStringEncoding = YES;
    }
    else
    {
        usedStringEncoding = [SUD integerForKey:iTM2StringEncodingPreferredKey];
        if(![[NSString localizedNameOfStringEncoding:usedStringEncoding] length])
        {
            usedStringEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacRoman);
            [SUD setInteger:usedStringEncoding forKey:iTM2StringEncodingPreferredKey];
        }
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
        NSStringEncoding hardCodedStringEncoding;
		NSRange hardCodedRange;
		[string getHardCodedStringEncoding:&hardCodedStringEncoding range:&hardCodedRange];
		if(hardCodedRange.length > 0)
			hardStringEncodingString = [string substringWithRange:hardCodedRange];
		else
			hardStringEncodingString = @"";
        canStringEncoding = NO;
    }
	if([docData length] && ![string length])
	{
		iTM2_LOG(@"Problem with the stringEncoding, report BUG 0213");
		usedStringEncoding = NSMacOSRomanStringEncoding;
        string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
		if(!string)
		{
            usedStringEncoding = NSASCIIStringEncoding;
			string = [[[NSString allocWithZone:[self zone]] initWithData:docData encoding:usedStringEncoding] autorelease];
		}
        canStringEncoding = YES;
		[self takeContextBool:NO forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"usedStringEncoding: %@", [NSString localizedNameOfStringEncoding:usedStringEncoding]);
	}
	[self setStringEncoding:usedStringEncoding];
	[self setStringEncodingHardCoded:!canStringEncoding];
	[self setHardStringEncodingString:hardStringEncodingString];
	id doc = [self document];
	if(doc)
	{
		NSString * defaultStringEncodingName = [doc contextValueForKey:TWSStringEncodingFileKey domain:iTM2ContextStandardLocalMask];// we are expecting something
		NSAssert(defaultStringEncodingName,(@"The defaults string encoding has not been registered, some code is broken in the iTM2StringFormatterKit"));
	}
//iTM2_START;
    return string;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOL
- (unsigned int)EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(!result)
	{
		[self setEOL:[self lazyEOL]];
		return [metaGETTER unsignedIntValue];
	}
    return [result unsignedIntValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyEOL
- (unsigned int)lazyEOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOL:
- (void)setEOL:(unsigned int)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [NSNumber numberWithUnsignedInt:argument];
    metaSETTER(N);
	[self takeContextValue:N forKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask&~iTM2ContextProjectMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncoding
- (NSStringEncoding)stringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSStringEncoding result = [metaGETTER unsignedIntValue];
	if(!result)
	{
		[self setStringEncoding:[self lazyStringEncoding]];
		result = [metaGETTER unsignedIntValue];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyStringEncoding
- (NSStringEncoding)lazyStringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:TWSStringEncodingFileKey domain:iTM2ContextStandardLocalMask|iTM2ContextProjectMask]?:
		([self contextIntegerForKey:iTM2StringEncodingOpenKey domain:iTM2ContextAllDomainsMask]?:[self contextIntegerForKey:iTM2StringEncodingPreferredKey domain:iTM2ContextAllDomainsMask]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncoding:
- (void)setStringEncoding:(NSStringEncoding)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [NSNumber numberWithUnsignedInt:argument];
    metaSETTER(N);
	[self takeContextValue:N forKey:TWSStringEncodingFileKey domain:iTM2ContextAllDomainsMask&~iTM2ContextProjectMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hardStringEncodingString
- (NSString *)hardStringEncodingString;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setHardStringEncodingString:
- (void)setHardStringEncodingString:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER(argument);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isStringEncodingHardCoded
- (BOOL)isStringEncodingHardCoded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    return [[[self implementation] metaValueForKey:@"isStringEncodingHardCoded"] boolValue];
    return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncodingHardCoded:
- (void)setStringEncodingHardCoded:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithBool:yorn]);
//	[[self implementation] takeMetaValue:[NSNumber numberWithBool:yorn] forKey:@"isStringEncodingHardCoded"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  document
- (id)document;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[metaGETTER nonretainedObjectValue] retain] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocument:
- (void)setDocument:(id)document;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER([NSValue valueWithNonretainedObject:document]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOLMenuWithAction:target:
+ (NSMenu *)EOLMenuWithAction:(SEL)anAction target:(id)aTarget;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * menu = [[[[[NSApp mainMenu] deepItemWithAction:@selector(takeEOLFromTag:)] menu] copy] autorelease];
	if(menu)
	{
		int index = 0;
		while(index < [menu numberOfItems])
		{
			NSMenuItem * MI = [menu itemAtIndex:index];
			if([MI isSeparatorItem] || ([MI action] != @selector(takeEOLFromTag:)))
				[menu removeItemAtIndex:index];
			else
			{
				[MI setAction:anAction];
				[MI setTarget:aTarget];
				++index;
			}
		}
	}
	else
	{
		menu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"Line Ending Menu"] autorelease];
		id MI = [menu addItemWithTitle:[self nameOfEOL:iTM2MacintoshEOL]
				action: anAction keyEquivalent: [NSString string]];
		
		[MI setTag:iTM2MacintoshEOL];
		[MI setTarget:aTarget];
	
		MI = [menu addItemWithTitle:[self nameOfEOL:iTM2UNIXEOL]
					action: anAction keyEquivalent: [NSString string]];
		[MI setTag:iTM2UNIXEOL];
		[MI setTarget:aTarget];
	
		MI = [menu addItemWithTitle:[self nameOfEOL:iTM2WindowsEOL]
					action: anAction keyEquivalent: [NSString string]];
		[MI setTag:iTM2WindowsEOL];
		[MI setTarget:aTarget];
	
		MI = [menu addItemWithTitle:[self nameOfEOL:iTM2UnknownEOL]
					action: anAction keyEquivalent: [NSString string]];
		[MI setTag:iTM2UnknownEOL];
		[MI setTarget:aTarget];
	}
//iTM2_END;
    return menu;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingMenuWithAction:target:
+ (NSMenu *)stringEncodingMenuWithAction:(SEL)anAction target:(id)aTarget;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenu * menu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:
        NSLocalizedStringFromTableInBundle(@"Text Encoding", TABLE, BUNDLE, "Title of string encodings menu")] autorelease];
    NSArray * stringEncodings = [self supportedStringEncodings];
    NSEnumerator * enumerator = [stringEncodings objectEnumerator];
    NSNumber * number;
    BOOL canInsertSeparatorItem = NO;
    while(number = [enumerator nextObject])
    {
        if([number respondsToSelector:@selector(unsignedIntValue)])
        {
            NSStringEncoding encoding = [number unsignedIntValue];
            NSString * title = [NSString localizedNameOfStringEncoding:encoding];
            if(![title length])
                title = [NSString stringWithFormat:@"StringEncoding:%d", encoding];
			NSMenuItem * MI = [menu addItemWithTitle:title action:anAction keyEquivalent:[NSString string]];
			[MI setTag:encoding];
			[MI setTarget:aTarget];
			canInsertSeparatorItem = YES;
//            NSLog(@"encoding %@ for %u", [MI title], [MI tag]);
        }
        else if(canInsertSeparatorItem)
        {
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    #if 1
    NSString * path = nil;
    NSArray * encodingStringsFromFile = nil;
    NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:iTM2StringEncodingsPListName ofType:@"plist" inDirectory:iTM2SupportTextComponent] objectEnumerator];
    while(path = [E nextObject])
    {
        if(encodingStringsFromFile = [NSArray arrayWithContentsOfFile:path])
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"path is: %@", path);
			}
            goto abacab;
		}
    }
    iTM2_LOG(@"WARNING: Missing a  a StringEncodings.plist, please reinstall");
	return [NSArray array];
abacab:;
//iTM2_LOG(@"encodingStringsFromFile is: %@", encodingStringsFromFile);
 	NSMutableArray * result = [NSMutableArray array];
	NSEnumerator * enumerator = [encodingStringsFromFile objectEnumerator];
	id O;
	BOOL canInsertNull = NO;
	while(O = [enumerator nextObject])
		if([O isKindOfClass:[NSString class]])
		{
			if([(NSString *)O length])
			{
				unsigned encoding = [self coreFoundationStringEncodingWithName:O];
				if(encoding == kCFStringEncodingInvalidId)
					encoding = [O intValue];
				else
					encoding = CFStringConvertEncodingToNSStringEncoding(encoding);
				[result addObject:[NSNumber numberWithUnsignedInt:encoding]];
				canInsertNull = YES;
			}
			else if(canInsertNull)
			{
				[result addObject:[NSString string]];
				canInsertNull = NO;
			}
		}
		else if([O respondsToSelector:@selector(unsignedIntValue)])
		{
			[result addObject:[NSNumber numberWithUnsignedInt:[O unsignedIntValue]]];
			canInsertNull = YES;
		}
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Ignored O is: <%@>", O);
		}
	if([result count])
		return result;
	iTM2_LOG(@"Hard coded stringEncoding list...");
    #endif
    return [NSArray arrayWithObjects:
                    [NSNumber numberWithUnsignedInt:NSMacOSRomanStringEncoding],
                    [NSNumber numberWithUnsignedInt:NSWindowsCP1252StringEncoding],
                    [NSNumber numberWithUnsignedInt:NSISOLatin1StringEncoding],
                    [NSNumber numberWithUnsignedInt:
                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacCentralEurRoman)],
                    [NSNumber numberWithUnsignedInt:
                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingWindowsLatin2)],
                    [NSNumber numberWithUnsignedInt:
                            CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin2)],
                    [NSNumber numberWithUnsignedInt:NSNEXTSTEPStringEncoding],
                    [NSNumber numberWithUnsignedInt:NSASCIIStringEncoding],
                    [NSString string],//stands for separatorItem
                    [NSNumber numberWithUnsignedInt:NSUnicodeStringEncoding],
                    [NSNumber numberWithUnsignedInt:NSUTF8StringEncoding],
                    [NSNumber numberWithUnsignedInt:NSNonLossyASCIIStringEncoding],
                                nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self document];
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
{iTM2_DIAGNOSTIC;
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if([self respondsToSelector:@selector(unsignedIntValue)])
    {
        if([rhs respondsToSelector:@selector(unsignedIntValue)])
        {
            return [[NSString localizedNameOfStringEncoding:[(NSNumber *)self unsignedIntValue]]
                        compare: [NSString localizedNameOfStringEncoding:[rhs unsignedIntValue]]];
        }
        else
            return NSOrderedAscending;
    }
    else
        return NSOrderedDescending;
}

@end

@implementation NSDocument(iTM2StringFormatController)
- (id)stringFormatter;
{iTM2_DIAGNOSTIC;
	return nil;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringFormatKit

#if 0
typedef enum {
    kCFStringEncodingInvalidId = 0xffffffffU,
    kCFStringEncodingMacRoman = 0,
    kCFStringEncodingWindowsLatin1 = 0x0500, /* ANSI codepage 1252 */
    kCFStringEncodingISOLatin1 = 0x0201, /* ISO 8859-1 */
    kCFStringEncodingNextStepLatin = 0x0B01, /* NextStep encoding*/
    kCFStringEncodingASCII = 0x0600, /* 0..127 (in creating CFString, values greater than 0x7F are treated as corresponding Unicode value) */
    kCFStringEncodingUnicode = 0x0100, /* kTextEncodingUnicodeDefault  + kTextEncodingDefaultFormat (aka kUnicode16BitFormat) */
    kCFStringEncodingUTF8 = 0x08000100, /* kTextEncodingUnicodeDefault + kUnicodeUTF8Format */
    kCFStringEncodingNonLossyASCII = 0x0BFF /* 7bit Unicode variants used by YellowBox & Java */
} CFStringBuiltInEncodings;
typedef enum {
/*  kCFStringEncodingMacRoman = 0L, defined in CoreFoundation/CFString.h */
    kCFStringEncodingMacJapanese = 1,
    kCFStringEncodingMacChineseTrad = 2,
    kCFStringEncodingMacKorean = 3,
    kCFStringEncodingMacArabic = 4,
    kCFStringEncodingMacHebrew = 5,
    kCFStringEncodingMacGreek = 6,
    kCFStringEncodingMacCyrillic = 7,
    kCFStringEncodingMacDevanagari = 9,
    kCFStringEncodingMacGurmukhi = 10,
    kCFStringEncodingMacGujarati = 11,
    kCFStringEncodingMacOriya = 12,
    kCFStringEncodingMacBengali = 13,
    kCFStringEncodingMacTamil = 14,
    kCFStringEncodingMacTelugu = 15,
    kCFStringEncodingMacKannada = 16,
    kCFStringEncodingMacMalayalam = 17,
    kCFStringEncodingMacSinhalese = 18,
    kCFStringEncodingMacBurmese = 19,
    kCFStringEncodingMacKhmer = 20,
    kCFStringEncodingMacThai = 21,
    kCFStringEncodingMacLaotian = 22,
    kCFStringEncodingMacGeorgian = 23,
    kCFStringEncodingMacArmenian = 24,
    kCFStringEncodingMacChineseSimp = 25,
    kCFStringEncodingMacTibetan = 26,
    kCFStringEncodingMacMongolian = 27,
    kCFStringEncodingMacEthiopic = 28,
    kCFStringEncodingMacCentralEurRoman = 29,
    kCFStringEncodingMacVietnamese = 30,
    kCFStringEncodingMacExtArabic = 31,
    /* The following use script code 0, smRoman */
    kCFStringEncodingMacSymbol = 33,
    kCFStringEncodingMacDingbats = 34,
    kCFStringEncodingMacTurkish = 35,
    kCFStringEncodingMacCroatian = 36,
    kCFStringEncodingMacIcelandic = 37,
    kCFStringEncodingMacRomanian = 38,
    kCFStringEncodingMacCeltic = 39,
    kCFStringEncodingMacGaelic = 40,
    /* The following use script code 4, smArabic */
    kCFStringEncodingMacFarsi = 0x8C,	/* Like MacArabic but uses Farsi digits */
    /* The following use script code 7, smCyrillic */
    kCFStringEncodingMacUkrainian = 0x98,
    /* The following use script code 32, smUnimplemented */
    kCFStringEncodingMacInuit = 0xEC,
    kCFStringEncodingMacVT100 = 0xFC,	/* VT100/102 font from Comm Toolbox: Latin-1 repertoire + box drawing etc */
    /* Special Mac OS encodings*/
    kCFStringEncodingMacHFS = 0xFF,	/* Meta-value, should never appear in a table */

    /* Unicode & ISO UCS encodings begin at 0x100 */
    /* We don't use Unicode variations defined in TextEncoding; use the ones in CFString.h, instead. */

    /* ISO 8-bit and 7-bit encodings begin at 0x200 */
/*  kCFStringEncodingISOLatin1 = 0x0201, defined in CoreFoundation/CFString.h */
    kCFStringEncodingISOLatin2 = 0x0202,	/* ISO 8859-2 */
    kCFStringEncodingISOLatin3 = 0x0203,	/* ISO 8859-3 */
    kCFStringEncodingISOLatin4 = 0x0204,	/* ISO 8859-4 */
    kCFStringEncodingISOLatinCyrillic = 0x0205,	/* ISO 8859-5 */
    kCFStringEncodingISOLatinArabic = 0x0206,	/* ISO 8859-6, =ASMO 708, =DOS CP 708 */
    kCFStringEncodingISOLatinGreek = 0x0207,	/* ISO 8859-7 */
    kCFStringEncodingISOLatinHebrew = 0x0208,	/* ISO 8859-8 */
    kCFStringEncodingISOLatin5 = 0x0209,	/* ISO 8859-9 */
    kCFStringEncodingISOLatin6 = 0x020A,	/* ISO 8859-10 */
    kCFStringEncodingISOLatinThai = 0x020B,	/* ISO 8859-11 */
    kCFStringEncodingISOLatin7 = 0x020D,	/* ISO 8859-13 */
    kCFStringEncodingISOLatin8 = 0x020E,	/* ISO 8859-14 */
    kCFStringEncodingISOLatin9 = 0x020F,	/* ISO 8859-15 */

    /* MS-DOS & Windows encodings begin at 0x400 */
    kCFStringEncodingDOSLatinUS = 0x0400,	/* code page 437 */
    kCFStringEncodingDOSGreek = 0x0405,		/* code page 737 (formerly code page 437G) */
    kCFStringEncodingDOSBalticRim = 0x0406,	/* code page 775 */
    kCFStringEncodingDOSLatin1 = 0x0410,	/* code page 850, "Multilingual" */
    kCFStringEncodingDOSGreek1 = 0x0411,	/* code page 851 */
    kCFStringEncodingDOSLatin2 = 0x0412,	/* code page 852, Slavic */
    kCFStringEncodingDOSCyrillic = 0x0413,	/* code page 855, IBM Cyrillic */
    kCFStringEncodingDOSTurkish = 0x0414,	/* code page 857, IBM Turkish */
    kCFStringEncodingDOSPortuguese = 0x0415,	/* code page 860 */
    kCFStringEncodingDOSIcelandic = 0x0416,	/* code page 861 */
    kCFStringEncodingDOSHebrew = 0x0417,	/* code page 862 */
    kCFStringEncodingDOSCanadianFrench = 0x0418, /* code page 863 */
    kCFStringEncodingDOSArabic = 0x0419,	/* code page 864 */
    kCFStringEncodingDOSNordic = 0x041A,	/* code page 865 */
    kCFStringEncodingDOSRussian = 0x041B,	/* code page 866 */
    kCFStringEncodingDOSGreek2 = 0x041C,	/* code page 869, IBM Modern Greek */
    kCFStringEncodingDOSThai = 0x041D,		/* code page 874, also for Windows */
    kCFStringEncodingDOSJapanese = 0x0420,	/* code page 932, also for Windows */
    kCFStringEncodingDOSChineseSimplif = 0x0421, /* code page 936, also for Windows */
    kCFStringEncodingDOSKorean = 0x0422,	/* code page 949, also for Windows; Unified Hangul Code */
    kCFStringEncodingDOSChineseTrad = 0x0423,	/* code page 950, also for Windows */
/*  kCFStringEncodingWindowsLatin1 = 0x0500, defined in CoreFoundation/CFString.h */
    kCFStringEncodingWindowsLatin2 = 0x0501,	/* code page 1250, Central Europe */
    kCFStringEncodingWindowsCyrillic = 0x0502,	/* code page 1251, Slavic Cyrillic */
    kCFStringEncodingWindowsGreek = 0x0503,	/* code page 1253 */
    kCFStringEncodingWindowsLatin5 = 0x0504,	/* code page 1254, Turkish */
    kCFStringEncodingWindowsHebrew = 0x0505,	/* code page 1255 */
    kCFStringEncodingWindowsArabic = 0x0506,	/* code page 1256 */
    kCFStringEncodingWindowsBalticRim = 0x0507,	/* code page 1257 */
    kCFStringEncodingWindowsKoreanJohab = 0x0510, /* code page 1361, for Windows NT */
    kCFStringEncodingWindowsVietnamese = 0x0508, /* code page 1258 */

    /* Various national standards begin at 0x600 */
/*  kCFStringEncodingASCII = 0x0600, defined in CoreFoundation/CFString.h */
    kCFStringEncodingJIS_X0201_76 = 0x0620,
    kCFStringEncodingJIS_X0208_83 = 0x0621,
    kCFStringEncodingJIS_X0208_90 = 0x0622,
    kCFStringEncodingJIS_X0212_90 = 0x0623,
    kCFStringEncodingJIS_C6226_78 = 0x0624,
    kCFStringEncodingGB_2312_80 = 0x0630,
    kCFStringEncodingGBK_95 = 0x0631,		/* annex to GB 13000-93; for Windows 95 */
    kCFStringEncodingKSC_5601_87 = 0x0640,	/* same as KSC 5601-92 without Johab annex */
    kCFStringEncodingKSC_5601_92_Johab = 0x0641, /* KSC 5601-92 Johab annex */
    kCFStringEncodingCNS_11643_92_P1 = 0x0651,	/* CNS 11643-1992 plane 1 */
    kCFStringEncodingCNS_11643_92_P2 = 0x0652,	/* CNS 11643-1992 plane 2 */
    kCFStringEncodingCNS_11643_92_P3 = 0x0653,	/* CNS 11643-1992 plane 3 (was plane 14 in 1986 version) */

    /* ISO 2022 collections begin at 0x800 */
    kCFStringEncodingISO_2022_JP = 0x0820,
    kCFStringEncodingISO_2022_JP_2 = 0x0821,
    kCFStringEncodingISO_2022_CN = 0x0830,
    kCFStringEncodingISO_2022_CN_EXT = 0x0831,
    kCFStringEncodingISO_2022_KR = 0x0840,

    /* EUC collections begin at 0x900 */
    kCFStringEncodingEUC_JP = 0x0920,		/* ISO 646, 1-byte katakana, JIS 208, JIS 212 */
    kCFStringEncodingEUC_CN = 0x0930,		/* ISO 646, GB 2312-80 */
    kCFStringEncodingEUC_TW = 0x0931,		/* ISO 646, CNS 11643-1992 Planes 1-16 */
    kCFStringEncodingEUC_KR = 0x0940,		/* ISO 646, KS C 5601-1987 */

    /* Misc standards begin at 0xA00 */
    kCFStringEncodingShiftJIS = 0x0A01,		/* plain Shift-JIS */
    kCFStringEncodingKOI8_R = 0x0A02,		/* Russian internet standard */
    kCFStringEncodingBig5 = 0x0A03,		/* Big-5 (has variants) */
    kCFStringEncodingMacRomanLatin1 = 0x0A04,	/* Mac OS Roman permuted to align with ISO Latin-1 */
    kCFStringEncodingHZ_GB_2312 = 0x0A05,	/* HZ (RFC 1842, for Chinese mail & news) */

    /* Other platform encodings*/
/*  kCFStringEncodingNextStepLatin = 0x0B01, defined in CoreFoundation/CFString.h */

    /* EBCDIC & IBM host encodings begin at 0xC00 */
    kCFStringEncodingEBCDIC_US = 0x0C01,	/* basic EBCDIC-US */
    kCFStringEncodingEBCDIC_CP037 = 0x0C02	/* code page 037, extended EBCDIC (Latin-1 set) for US,Canada... */
} CFStringEncoding;
#endif

extern NSString * const iTM2DraggingStringEncodingPboardType;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2EncodingDocument

@interface iTM2StringEncodingFormatter: NSFormatter
@end

NSString * const iTM2DraggingStringEncodingPboardType = @"iTM2DraggingStringEncodingList";

#import <iTM2Foundation/iTM2ValidationKit.h>

@implementation iTM2StringEncodingDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super init])
	{
		[_ActualStringEncodings autorelease];
		_ActualStringEncodings = [[iTM2StringFormatController supportedStringEncodings] mutableCopy];
	}
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_ActualStringEncodings autorelease];
    _ActualStringEncodings = nil;
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
- (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSStringFromClass([self class]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (IBAction)saveDocument:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self writeToURL:[self fileURL] ofType:[self fileType] error:nil])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self isDocumentEdited];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentAs:
- (IBAction)saveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentAs:
- (BOOL)validateSaveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentTo:
- (IBAction)saveDocumentTo:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentTo:
- (BOOL)validateSaveDocumentTo:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outErrorPtr)
	{
		*outErrorPtr = nil;
	}
//iTM2_END;
    return [_ActualStringEncodings writeToURL:absoluteURL atomically:YES];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
//- (BOOL) readFromFile: (NSString *) fileName ofType: (NSString *) irrelevantType;
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = YES;
	_ActualStringEncodings = [NSMutableArray arrayWithContentsOfURL:absoluteURL];
	if(!_ActualStringEncodings)
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
{iTM2_DIAGNOSTIC;
//iTM2_STARTNSTableView
    NSEnumerator * E = [actualTableView selectedRowEnumerator];
    NSNumber * N;
    while(N = [E nextObject])
        [_ActualStringEncodings replaceObjectAtIndex:[N intValue] withObject:@"REMOVE"];
    int index = 0;
    int row = -1;
    while(index<[_ActualStringEncodings count])
        if([[_ActualStringEncodings objectAtIndex:index] isEqual:@"REMOVE"])
        {
            [_ActualStringEncodings removeObjectAtIndex:index];
            if(row<0)
                row = index;
        }
        else
            ++index;
    [actualTableView reloadData];
    if(row<[actualTableView numberOfRows])
        [actualTableView selectRow:row byExtendingSelection:NO];
    else
        [actualTableView selectRow:([actualTableView numberOfRows] - 1) byExtendingSelection:NO];
    [[actualTableView window] makeFirstResponder:actualTableView];
    [self updateChangeCount:NSChangeDone];
    [self validateWindowsContents];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDelete:
- (BOOL)validateDelete:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([actualTableView numberOfSelectedRows]>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSelection:
- (IBAction)addSelection:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_STARTNSTableView
    id O = [[availableTableView dataSource]
                    tableView: availableTableView
                        objectValueForTableColumn: nil
                            row: [availableTableView selectedRow]];
    if(O)
    {
        int targetRow = [actualTableView selectedRow];
        if(targetRow<0)
            targetRow = [actualTableView numberOfRows];
        else if(targetRow<[actualTableView numberOfRows])
            ++targetRow;
        [_ActualStringEncodings insertObject:O atIndex:targetRow];
        [actualTableView selectRow:targetRow byExtendingSelection:NO];
        [self updateChangeCount:NSChangeDone];
        [actualTableView reloadData];
        [self validateWindowsContents];
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
{iTM2_DIAGNOSTIC;
//iTM2_STARTNSTableView
    int SR = [actualTableView selectedRow];
    if(SR<0)
        SR = [_ActualStringEncodings count];
    else if(SR < [_ActualStringEncodings count])
        ++SR;
    [_ActualStringEncodings insertObject:[NSString string] atIndex:SR];
    [actualTableView reloadData];
    [actualTableView selectRow:SR byExtendingSelection:NO];
    [[actualTableView window] makeFirstResponder:actualTableView];
    [self updateChangeCount:NSChangeDone];
    [self validateWindowsContents];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerDidLoadNib:
- (void)windowControllerDidLoadNib:(NSWindowController *)windowController;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowControllerDidLoadNib:windowController];
    if(!_ActualStringEncodings)
    {
        [_ActualStringEncodings autorelease];
        _ActualStringEncodings = [[NSMutableArray array] retain];
    }
    [[[[availableTableView tableColumns] lastObject] dataCell] setFormatter:[[[iTM2StringEncodingFormatter allocWithZone:[self zone]] init] autorelease]];
    [[[[actualTableView tableColumns] lastObject] dataCell] setFormatter:[[[iTM2StringEncodingFormatter allocWithZone:[self zone]] init] autorelease]];
    [actualTableView registerForDraggedTypes:[NSArray arrayWithObject:iTM2DraggingStringEncodingPboardType]];
    [availableTableView setDoubleAction:@selector(addSelection:)];
    [actualTableView reloadData];
    [self validateWindowsContents];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [tableView isEqual:actualTableView]? [_ActualStringEncodings count]:[[iTM2StringFormatController availableStringEncodings] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([tableView isEqual:actualTableView])
    {
        if((row>=0) && (row < [_ActualStringEncodings count]))
            return [_ActualStringEncodings objectAtIndex:row];
    }
    else
    {
        if((row>=0) && (row < [[iTM2StringFormatController availableStringEncodings] count]))
            return [[iTM2StringFormatController availableStringEncodings] objectAtIndex:row];
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:writeRows:toPasteboard:
- (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray*)rows toPasteboard:(NSPasteboard*)pboard;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([rows count])
    {
        return ([pboard changeCount] !=
            [pboard declareTypes:[NSArray arrayWithObject:iTM2DraggingStringEncodingPboardType] owner:nil])
                && [pboard setPropertyList:[[rows copy] autorelease] forType:iTM2DraggingStringEncodingPboardType];
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:validateDrop:proposedRow:proposedDropOperation:
- (NSDragOperation)tableView:(NSTableView *)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([tv isEqual:actualTableView])
    {
//NSLog(@"Move or copy %x = %x = %x", tv, actualTableView, [info draggingSource]);
        if((0<=row) && (row < [tv numberOfRows]))
            [tv setDropRow:row dropOperation:NSTableViewDropAbove];
        else
            [tv setDropRow:[tv numberOfRows] dropOperation:NSTableViewDropAbove];
        return [[info draggingSource] isEqual:tv]? NSDragOperationMove:NSDragOperationCopy;
    }
    return NSDragOperationNone;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:acceptDrop:row:dropOperation:
- (BOOL)tableView:(NSTableView *)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)op;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([tv isEqual:actualTableView])
    {
        if([tv isEqual:[info draggingSource]])
        {
            //move operation:
            NSEnumerator * E = [[[info draggingPasteboard] propertyListForType:iTM2DraggingStringEncodingPboardType] objectEnumerator];
            NSNumber * N;
            NSMutableArray * MRA = [NSMutableArray array];
            id draggingS = [info draggingSource];
            id dataS = [draggingS dataSource];
            while(N = [E nextObject])
            {
                int index = [N intValue];
                id O = [dataS tableView:draggingS objectValueForTableColumn:nil row:index];
                if(O)
                {
                    [MRA addObject:O];
                    [_ActualStringEncodings replaceObjectAtIndex:index withObject:@"REPLACE"];
                }
            }
            E = [MRA reverseObjectEnumerator];
            while(N = [E nextObject])
                [_ActualStringEncodings insertObject:N atIndex:row];
            E = [_ActualStringEncodings reverseObjectEnumerator];
            int index = 0;
            while(index<[_ActualStringEncodings count])
            {
                if([[_ActualStringEncodings objectAtIndex:index] isEqual:@"REPLACE"])
                {
                    if(index<row)
                        --row;
                    [_ActualStringEncodings removeObjectAtIndex:index];
                }
                else
                    ++index;
            }
            [tv reloadData];
            int length = [MRA count];
            if(length)
                [tv selectRow:row byExtendingSelection:NO];
            while(--length>0)
                [tv selectRow:++row byExtendingSelection:YES];
            [[tv window] makeFirstResponder:tv];
            [self updateChangeCount:NSChangeDone];
            [self validateWindowsContents];
            return YES;
        }
        else
        {
            NSEnumerator * E = [[[info draggingPasteboard] propertyListForType:iTM2DraggingStringEncodingPboardType] reverseObjectEnumerator];
            NSNumber * N;
            int length = 0;
            id draggingS = [info draggingSource];
            id dataS = [draggingS dataSource];
            while(N = [E nextObject])
            {
                id O = [dataS tableView:draggingS objectValueForTableColumn:nil row:[N intValue]];
                if(O)
                {
                    [_ActualStringEncodings insertObject:O atIndex:row];
                    ++length;
                }
            }
            [tv reloadData];
            if(length)
                [tv selectRow:row byExtendingSelection:NO];
            while(--length>0)
                [tv selectRow:++row byExtendingSelection:YES];
            [[tv window] makeFirstResponder:tv];
            [self updateChangeCount:NSChangeDone];
            [self validateWindowsContents];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateWindowsContents];
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
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row;

// optional - drag and drop support
- (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray*)rows toPasteboard:(NSPasteboard*)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the table view once this call returns with YES.  The rows array is the list of row numbers that will be participating in the drag.

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
    // This method is used by NSTableView to determine a valid drop target.  Based on the mouse position, the table view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropRow:dropOperation: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)op;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.
#endif
@end

@implementation iTM2StringEncodingFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringForObjectValue:
- (NSString *)stringForObjectValue:(id)obj;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Sat May 31 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * result = [NSString string];
    if([obj respondsToSelector:@selector(unsignedIntValue)])
    {
        result = [NSString localizedNameOfStringEncoding:[(NSNumber *)obj unsignedIntValue]];
    }
    else if([obj isKindOfClass:[NSString class]] && [(NSString *)obj length])
    {
		unsigned encoding = [NSString stringEncodingWithName:obj];
		result = [NSString localizedNameOfStringEncoding:encoding];
    }
    if(![result length])
	{
        result = [NSString stringWithUTF8String:"―"];
	}
    return result;
}
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

@implementation iTM2TextInspector(StringFormatter)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setStringEncoding:[sender tag]];
	[self validateWindowContent];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int expectedTag = [self stringEncoding];
    [sender setState:(expectedTag == [sender tag]? NSOnState:NSOffState)];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
	if(!old)
	{
		NSTextStorage * TS = [self textStorage];
		NSString * S = [TS mutableString];
		NSStringEncoding encoding;
		NSRange R;
		[S getHardCodedStringEncoding:&encoding range:&R];
		if(R.length)
		{
			[self setStringEncoding:encoding];
		}
	}
	[self takeContextBool:!old forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextStandardLocalMask];
iTM2_LOG(@"new:%@",([self contextBoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextStandardLocalMask]?@"Y":@"N"));
iTM2_LOG(@"new:%@",[self contextValueForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask]);
	[self validateWindowContent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStringEncodingToggleAuto:
- (BOOL)validateStringEncodingToggleAuto:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isAuto = [self contextBoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
    [sender setState:(isAuto? NSOnState:NSOffState)];
	// now validating all the menu items
	BOOL enabled = !isAuto;
	int tag = [self contextIntegerForKey:TWSStringEncodingFileKey domain:iTM2ContextAllDomainsMask];
	BOOL stringEncodingNotAvailable = YES;
	NSMenu * menu = [sender menu];
	NSEnumerator * E = [[menu itemArray] objectEnumerator];
	while(sender = [E nextObject])
	{
		if([sender action] == @selector(takeStringEncodingFromTag:))
		{
			[sender setEnabled:enabled];
			if([sender tag] == tag)
			{
				[sender setState:NSOnState];
				stringEncodingNotAvailable = NO;
			}
			else if([[sender attributedTitle] length])
			{
				[menu removeItem:sender];// the menu item was added because the encoding was missing in the menu
			}
			else
			{
				[sender setState:NSOffState];
			}
		}
	}
	if(stringEncodingNotAvailable)
	{
		iTM2_LOG(@"StringEncoding %i is not available", tag);
		NSString * title = [NSString localizedNameOfStringEncoding:tag];
		if(![title length])
		{
			title = [NSString stringWithFormat:@"StringEncoding:%u", tag];
			}
		sender = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle:title action:@selector(takeStringEncodingFromTag:) keyEquivalent:@""]
				autorelease];
		NSFont * F = [NSFont menuFontOfSize:[NSFont systemFontSize]*1.1];
		F = [SFM convertFont:F toFamily:@"Helvetica"];
		F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:F, NSFontAttributeName, nil];
		[sender setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]]
			initWithString:title attributes:attributes]
				autorelease]];
		[sender setEnabled:NO];
		[sender setTarget:self];
		[sender setTag:tag];
		[sender setState:NSOnState];
		[menu insertItem:sender atIndex:0];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self document] setEOL:[sender tag]];
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeEOLFromTag:
- (BOOL)validateTakeEOLFromTag:(id)sender;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int tag = [[self document] EOL];
	[sender setState:([sender tag] == tag? NSOnState:NSOffState)];
	return YES;
}
@end

#import <iTM2Foundation/iTM2PathUtilities.h>

@implementation NSApplication(iTM2StringFormat)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setInteger:[sender tag] forKey:iTM2StringEncodingPreferredKey];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int expectedTag = [SUD contextIntegerForKey:iTM2StringEncodingPreferredKey domain:iTM2ContextAllDomainsMask];
    [sender setState:(expectedTag == [sender tag]? NSOnState:NSOffState)];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [SUD contextBoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
	[SUD takeContextBool:!old forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextStandardLocalMask];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStringEncodingToggleAuto:
- (BOOL)validateStringEncodingToggleAuto:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isAuto = [SUD contextBoolForKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextAllDomainsMask];
    [sender setState:(isAuto? NSOnState:NSOffState)];
	BOOL enabled = !isAuto;
	int tag = [SUD contextIntegerForKey:TWSStringEncodingFileKey domain:iTM2ContextAllDomainsMask];
	BOOL stringEncodingNotAvailable = YES;
	NSMenu * menu = [sender menu];
	NSEnumerator * E = [[menu itemArray] objectEnumerator];
	while(sender = [E nextObject])
	{
		if([sender action] == @selector(takeStringEncodingFromTag:))
		{
			[sender setTarget:self];
			[sender setEnabled:enabled];
			if([sender tag] == tag)
			{
				[sender setState:NSOnState];
				stringEncodingNotAvailable = NO;
			}
			else if([[sender attributedTitle] length])
			{
				[menu removeItem:sender];// the menu item was added because the encoding was missing in the menu
			}
			else
			{
				[sender setState:NSOffState];
			}
		}
	}
	if(stringEncodingNotAvailable)
	{
		iTM2_LOG(@"StringEncoding %i is not available", tag);
		NSString * title = [NSString localizedNameOfStringEncoding:tag];
		if(![title length])
			title = [NSString stringWithFormat:@"StringEncoding:%u", tag];
		sender = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:@selector(takeStringEncodingFromTag:) keyEquivalent:@""] autorelease];
		NSFont * F = [NSFont menuFontOfSize:[NSFont systemFontSize]*1.1];
		F = [SFM convertFont:F toFamily:@"Helvetica"];
		F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		[sender setAttributedTitle:[[[NSAttributedString allocWithZone:[NSMenu menuZone]] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:F, NSFontAttributeName, nil]] autorelease]];
		[sender setEnabled:NO];
		[sender setTarget:self];
		[sender setTag:tag];
		[sender setState:NSOnState];
		[menu insertItem:sender atIndex:0];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * subpath = [[NSBundle mainBundle] pathForSupportDirectory:iTM2SupportTextComponent inDomain:NSUserDomainMask create:YES];
	NSString * path = [[subpath stringByAppendingPathComponent:iTM2StringEncodingsPListName] stringByAppendingPathExtension:@"plist"];
//iTM2_LOG(@"path is: %@", path);
	NSURL * URL = [NSURL fileURLWithPath:path];
	id D = [SDC documentForURL:URL];
	if(D)
	{
		if([SDC shouldCreateUI])
		{
			[D makeWindowControllers];
			[D showWindows];
		}
		return;
	}
	if([DFM fileExistsAtPath:path])
	{
		D = [[[iTM2StringEncodingDocument allocWithZone:[self zone]]
				initWithContentsOfURL:URL ofType:iTM2StringEncodingsTypeName error:nil] autorelease];
		[SDC addDocument:D];
		if([SDC shouldCreateUI])
		{
			[D makeWindowControllers];
			[D showWindows];
		}
		return;
	}
	D = [[[iTM2StringEncodingDocument allocWithZone:[self zone]] init] autorelease];
	[D setFileURL:URL];
	[D setFileType:iTM2StringEncodingsTypeName];
	[SDC addDocument:D];
	if([SDC shouldCreateUI])
	{
		[D makeWindowControllers];
		[D showWindows];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeContextInteger:[sender tag] forKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeEOLFromTag:
- (BOOL)validateTakeEOLFromTag:(id)sender;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int tag = [self contextIntegerForKey:TWSEOLFileKey domain:iTM2ContextAllDomainsMask];
	[sender setState:([sender tag] == tag? NSOnState:NSOffState)];
	return YES;
}
@end
