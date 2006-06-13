/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Oct 25 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2UserDefaultsKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>

NSString * const iTM2UserDefaultsDidChangeFontOrColorNotification = @"iTM2UserDefaultsDidChangeFontOrColorNotification";
NSString * const iTM2UserDefaultsDidChangeNotification = @"iTM2UserDefaultsDidChangeNotification";
NSString * const iTM2NavLastRootDirectory = @"NSNavLastRootDirectory";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSUserDefaults(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSUserDefaults(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= notifyChangeNow
- (void) notifyChangeNow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    [INC postNotificationName:iTM2UserDefaultsDidChangeNotification object:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= notifyFontOrColorChangeNow
- (void) notifyFontOrColorChangeNow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    [INC postNotificationName:iTM2UserDefaultsDidChangeFontOrColorNotification object:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fontForKey:
- (NSFont *) fontForKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return [NSFont fontWithNameSizeDictionary:[self objectForKey:aKey]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setFont:forKey:
- (void) setFont: (NSFont *) aFont forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSAssert(aKey != nil, @"Unexpected nil key");
    [self setObject:[aFont nameSizeDictionary] forKey:aKey];
    [self notifyFontOrColorChangeNow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerFont:forKey:
- (void) registerFont: (NSFont *) aFont forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSAssert(aKey != nil, @"Unexpected nil key");
    [self registerDefaults:[NSDictionary dictionaryWithObject:[aFont nameSizeDictionary] forKey:aKey]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= colorForKey:
- (NSColor *) colorForKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSAssert(aKey != nil, @"Unexpected nil key");
    return [NSColor colorWithRGBADictionary:[self objectForKey:aKey]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setColor:forKey:
- (void) setColor: (NSColor *) aColor forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSAssert(aKey != nil, @"Unexpected nil key");
    [self setObject:[aColor RGBADictionary] forKey:aKey];
    [self notifyFontOrColorChangeNow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerColor:forKey:
- (void) registerColor: (NSColor *) aColor forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSAssert(aKey != nil, @"Unexpected nil key");
    [self registerDefaults:[NSDictionary dictionaryWithObject:[aColor RGBADictionary] forKey:aKey]];
    return;
}
@end

@implementation NSFont(iTM2UserDefaults)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fontWithNameSizeDictionary:
+ (NSFont *) fontWithNameSizeDictionary: (NSDictionary *) aDictionary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//NSLog(@"aDictionary: %@", aDictionary);
    if([aDictionary isKindOfClass:[NSDictionary class]])
    {
        NSString * fontName = [aDictionary objectForKey:@"Name"];
        NSNumber * fontSize = [aDictionary objectForKey:@"Size"];
//NSLog(@"fontName; %@, [fontSize floatValue]:%f", fontName, [fontSize floatValue]);
        if([fontName isKindOfClass:[NSString class]] && [fontSize respondsToSelector:@selector(floatValue)])
        {
            NSFont * result = [NSFont fontWithName:fontName size:[fontSize floatValue]];
            if(result) return result;
        }
        else
            NSLog(@"NO 1");
    }
    return [NSFont userFontOfSize:12];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameSizeDictionary
- (NSDictionary *) nameSizeDictionary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                        [self fontName], @"Name", [NSNumber numberWithFloat:[self pointSize]], @"Size", nil];
}
@end

@implementation NSColor(iTM2UserDefaults)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= colorWithRGBADictionary:
+ (NSColor *) colorWithRGBADictionary: (NSDictionary *) aDictionary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//NSLog(@"aDictionary: %@", aDictionary);
    NSColor * result = [NSColor blackColor];
    NS_DURING
    if([aDictionary isKindOfClass:[NSDictionary class]])
        result = [NSColor colorWithCalibratedRed:[[aDictionary objectForKey:@"R"] floatValue]
                            green: [[aDictionary objectForKey:@"G"] floatValue]
                                blue:[[aDictionary objectForKey:@"B"] floatValue]
                                    alpha: [[aDictionary objectForKey:@"A"] floatValue]];
    NS_HANDLER
	iTM2_LOG(@"***  FORWARDED EXCEPTION: %@", localException);
    [NSApp reportException:localException];
    NS_ENDHANDLER
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  RGBADictionary
- (NSDictionary *) RGBADictionary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSColor * color = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    NSDictionary * result = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithFloat:[color redComponent]], @"R",
                        [NSNumber numberWithFloat:[color greenComponent]], @"G",
                        [NSNumber numberWithFloat:[color blueComponent]], @"B",
                        [NSNumber numberWithFloat:[color alphaComponent]], @"A",
                            nil];
    return result;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSUserDefaults(iTeXMac2)

