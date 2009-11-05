/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Dec 05 2001.
//  Copyright © 2001-2009 Laurens'Tribune. All rights reserved.
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

#import "iTM2LiteScanner.h"


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2LiteScanner
/*"This is quite a NSScanner, except that it retains its string while NSScanner makes a copy. Speed is acceptable.
It is not a subclass of NSScanner...
When a scan operation is performed, the scanner begins to skip the unwanted characters. Clients will have to keep track of the scan location if they need to save the value."*/
@implementation iTM2LiteScanner
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scannerWithString:
+ (id)scannerWithString:(NSString *)aString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self alloc] initWithString:aString] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        self.string = nil;
        [self setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithString:
- (id)initWithString:(NSString *)aString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
        self.string = aString;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.1: Thu Nov  5 08:13:48 UTC 2009
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    self.string = nil;
    [self setCharactersToBeSkipped:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setString
- (void)setString:(NSString *)aString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self->string autorelease];
    self->string = [aString retain];
    self.scanLocation = 0;
//    CAI = (iTM2CharacterAtIndexIMP) [aString methodForSelector:@selector(characterAtIndex:)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= charactersToBeSkipped
- (NSCharacterSet *)charactersToBeSkipped;
/*"Critical Description: if the set of charactersToBeSkipped is nil, it means that there is no character to be skipped.
In one word, no set is equivalent to a void one. It is the opposit for the charactersNotToBeSkipped!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return self->charactersToBeSkipped;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCharactersToBeSkipped:
- (void)setCharactersToBeSkipped:(NSCharacterSet *)set;
/*"Beware, both charactersNotToBeSkipped and charactersNotToBeSkipped are changed by this message.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self->charactersToBeSkipped autorelease];
    self->charactersToBeSkipped = [set retain];
    [self->charactersNotToBeSkipped autorelease];
    self->charactersNotToBeSkipped = [[set invertedSet] retain];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= charactersNotToBeSkipped
- (NSCharacterSet *)charactersNotToBeSkipped;
/*"Critical Description: if the set of charactersNotToBeSkipped is nil, it means that there is no character to be skipped.
In one word, no set is equivalent to a full one. It is the opposit for the charactersToBeSkipped!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return self->charactersNotToBeSkipped;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCharactersNotToBeSkipped:
- (void)setCharactersNotToBeSkipped:(NSCharacterSet *)set;
/*"Beware, both charactersNotToBeSkipped and charactersNotToBeSkipped are changed by this message.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self->charactersNotToBeSkipped autorelease];
    self->charactersNotToBeSkipped = [set retain];
    [self->charactersToBeSkipped autorelease];
    self->charactersToBeSkipped = [[set invertedSet] retain];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= caseSensitive
- (BOOL)caseSensitive;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return self->caseSensitive;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCaseSensitive
- (void)setCaseSensitive:(BOOL)flag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    self->caseSensitive = flag;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanString:intoString:
- (BOOL)scanString:(NSString *)aString intoString:(NSString **)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self scanString:aString intoString:value beforeIndex:[[self string] length]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanString:intoString:beforeIndex:
- (BOOL)scanString:(NSString *)aString intoString:(NSString **)value beforeIndex:(NSUInteger)stopIndex;
/*"First the scanners reads all the characters to be skipped, then it tries to find aString. All this must occur in the range between the current scanner location and stopIndex (stopIndex is excluded).
A 0 length string is never found...
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 07/11/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // map stopIndex to a consistent value
    stopIndex = MIN([self.string length], stopIndex);
    if((self.scanLocation < stopIndex) && [aString length])
    {
        // we are looking into a non void range
        NSRange searchRange = NSMakeRange(self.scanLocation, stopIndex - self.scanLocation);
        NSRange r;
        if(self->charactersNotToBeSkipped)
        {
            // characters to be skipped are explicitely defined.
            r = [self.string rangeOfCharacterFromSet:self->charactersNotToBeSkipped
                        options: NSLiteralSearch
                            range: searchRange];
            if(r.location < stopIndex)//(r.location != NSNotFound)
            {
                // r.location points to the first character not to be skipped
                [self setScanLocation:r.location];
                searchRange = NSMakeRange(r.location, stopIndex - r.location);
            }
            else
            {
                // all the characters must be skipped...
                [self setScanLocation:stopIndex];
                return NO;
            }
        }
        // now the search range is definitely fixed
        // make an anchored search of the string
        r = [self.string rangeOfString:aString
                options: (self->caseSensitive? NSLiteralSearch: NSCaseInsensitiveSearch) | NSAnchoredSearch
                    range: searchRange];
        if(r.length)
        {
            [self setScanLocation:NSMaxRange(r)];
            if(value) *value = [self.string substringWithRange:r];
            return YES;
        }
        else
            return NO;
    }
    else
    {
        // we are looking in a void range: nothing can be found
        return NO;
    }
}
#if 0
*	NSCaseInsensitiveSearch
*	NSLiteralSearch
*	NSBackwardsSearch
*	NSAnchoredSearch
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanCharactersFromSet:intoString:
- (BOOL)scanCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self scanCharactersFromSet:set intoString:value beforeIndex:[[self string] length]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanCharactersFromSet:intoString:beforeIndex:
- (BOOL)scanCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value beforeIndex:(NSUInteger)stopIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 07/11/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_START;
    stopIndex = MIN([self.string length], stopIndex);
    if(self.scanLocation < stopIndex)
    {
        NSRange searchRange = NSMakeRange(self.scanLocation, stopIndex - self.scanLocation);
        NSRange r;
        if(self->charactersNotToBeSkipped)
        {
            // characters to be skipped are explicitely defined
            r = [self.string rangeOfCharacterFromSet:self->charactersNotToBeSkipped
                        options: NSLiteralSearch
                            range: searchRange];
            if(r.location < stopIndex)//(r.location != NSNotFound)
            {
                // r.location points to the first character not to be skipped
                [self setScanLocation:r.location];
                searchRange = NSMakeRange(r.location, stopIndex - r.location);
            }
            else
            {
                [self setScanLocation:stopIndex];
                return NO;
            }
        }
        r = [self.string rangeOfCharacterFromSet:[set invertedSet]
                options: NSLiteralSearch
                    range: searchRange];
        if(r.location > searchRange.location)
        {
            r.location = MIN(r.location, stopIndex);
            {
                NSUInteger L = r.location - searchRange.location;
                if(value)
                    *value = [self.string substringWithRange:NSMakeRange(searchRange.location, L)];
                [self setScanLocation:r.location];
                return L != 0;
            }
        }
        else
            return NO;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanUpToString:intoString:
- (BOOL)scanUpToString:(NSString *)stopString intoString:(NSString **)value;
/*"If aString is not found, the whole remaining string is scanned into *value.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self scanUpToString:stopString intoString:value beforeIndex:[[self string] length]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanUpToString:intoString:beforeIndex:
- (BOOL)scanUpToString:(NSString *)stopString intoString:(NSString **)value beforeIndex:(NSUInteger)stopIndex;
/*" If stopString is void, nothing is done and NO is the answer.
If stopString is not found, the whole remaining string is scanned into *value.
If the scanner actually points to character passed the stopIndex, nothing will be found and scanned.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 07/11/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    stopIndex = MIN([self.string length], stopIndex);
//NSLog(@"scanUpToString:intoString:beforeIndex:\nstopString:\n<%@>\nin string:\n<%@>", stopString,
//        [self.string substringWithRange:NSMakeRange(self.scanLocation, stopIndex - self.scanLocation)]);
    if((self.scanLocation < stopIndex) && [stopString length])
    {
        NSRange searchRange = NSMakeRange(self.scanLocation, stopIndex - self.scanLocation);
        NSRange r;
        if(self->charactersNotToBeSkipped)
        {
            // characters to be skipped are explicitely defined
            r = [self.string rangeOfCharacterFromSet:self->charactersNotToBeSkipped
                        options: NSLiteralSearch
                            range: searchRange];
            if(r.location < stopIndex)//(r.location != NSNotFound)
            {
                // r.location points to the first character not to be skipped
                [self setScanLocation:r.location];
                searchRange = NSMakeRange(r.location, stopIndex - r.location);
            }
            else
            {
                [self setScanLocation:stopIndex];
                return NO;
            }
        }
        r = [self.string rangeOfString:stopString
                options: (self->caseSensitive? NSLiteralSearch: NSCaseInsensitiveSearch)
                    range: searchRange];
        r.location = MIN(r.location, stopIndex);
        // stopString was found: the MIN is r.location
        // stopString was not found: the MIN is stopIndex
        {
            NSUInteger L = r.location - self.scanLocation;
            if(value)
                *value = [self.string substringWithRange:NSMakeRange(self.scanLocation, L)];
            [self setScanLocation:r.location];
            return L != 0;
        }
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanUpToCharactersFromSet:intoString:
- (BOOL)scanUpToCharactersFromSet:(NSCharacterSet *)stopSet intoString:(NSString **)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self scanUpToCharactersFromSet:stopSet intoString:value beforeIndex:[[self string] length]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanUpToCharactersFromSet:intoString:
- (BOOL)scanUpToCharactersFromSet:(NSCharacterSet *)stopSet intoString:(NSString **)value beforeIndex:(NSUInteger)stopIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 07/11/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    stopIndex = MIN([self.string length], stopIndex);
    if(self.scanLocation < stopIndex)
    {
        NSRange searchRange = NSMakeRange(self.scanLocation, stopIndex - self.scanLocation);
        NSRange r;
        if(self->charactersNotToBeSkipped)
        {
            // characters to be skipped are explicitely defined
            r = [self.string rangeOfCharacterFromSet:self->charactersNotToBeSkipped
                        options: NSLiteralSearch
                            range: searchRange];
            if(r.location < stopIndex)//(r.location != NSNotFound)
            {
                // r.location points to the first character not to be skipped
                [self setScanLocation:r.location];
                searchRange = NSMakeRange(r.location, stopIndex - r.location);
            }
            else
            {
                // no need to continue...
                [self setScanLocation:stopIndex];
                return NO;
            }
        }
        r = [self.string rangeOfCharacterFromSet:stopSet
                options: NSLiteralSearch
                    range: searchRange];
        r.location = MIN(r.location, stopIndex);
        {
            NSUInteger L = r.location - searchRange.location;
            if(value)
                *value = [self.string substringWithRange:NSMakeRange(self.scanLocation, L)];
            [self setScanLocation:r.location];
            return L != 0;
        }
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanUpToEOLIntoString:
- (BOOL)scanUpToEOLIntoString:(NSString **)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Use characters to be skipped...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n\r"]
        intoString: value];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isAtEnd
- (BOOL)isAtEnd;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Use characters to be skipped...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return self.scanLocation >= [self.string length];
}
@synthesize scanLocation;
@synthesize string;
@end

@implementation iTM2LiteScanner (iTM2ExtendedScanner) 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanInt
- (BOOL)scanInt:(int *)value;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
    NSUInteger end;
    BOOL result;
    NSScanner * S;
    if([self.string length])
    {
		//NSLog(@"GLS");
        [self.string getLineStart:nil end:&end contentsEnd:nil forRange:NSMakeRange(self.scanLocation, 0)];
        S = [NSScanner scannerWithString:[self.string substringWithRange:
										  NSIntersectionRange(NSMakeRange(self.scanLocation, end - self.scanLocation),
															  NSMakeRange(0, [self.string length]))]];
        result = [S scanInt:value];
        self.scanLocation += [S scanLocation];
    }
    else
        result = NO;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanInteger:
- (BOOL)scanInteger:(NSInteger *)value;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.1: 23/10/2009
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
    NSUInteger end;
    BOOL result;
    NSScanner * S;
    if([self.string length])
    {
		//NSLog(@"GLS");
        [self.string getLineStart:nil end:&end contentsEnd:nil forRange:NSMakeRange(self.scanLocation, 0)];
        S = [NSScanner scannerWithString:[self.string substringWithRange:
										  NSIntersectionRange(NSMakeRange(self.scanLocation, end - self.scanLocation),
															  NSMakeRange(0, [self.string length]))]];
        result = [S scanInteger:value];
        self.scanLocation += [S scanLocation];
    }
    else
        result = NO;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanHexInt
- (BOOL)scanHexInt:(NSUInteger *)valueRef;		/* Optionally prefixed with "0x" or "0X" */
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSUInteger end;
    BOOL result;
    NSScanner * S;
    if([self.string length])
    {
//NSLog(@"GLS");
        [self.string getLineStart:nil end:&end contentsEnd:nil forRange:NSMakeRange(self.scanLocation, 0)];
        S = [NSScanner scannerWithString:[self.string substringWithRange:
            NSIntersectionRange(NSMakeRange(self.scanLocation, end - self.scanLocation),
                NSMakeRange(0, [self.string length]))]];
		unsigned value;
        result = [S scanHexInt:&value];
		if(valueRef)*valueRef=value;
        self.scanLocation += [S scanLocation];
    }
    else
        result = NO;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanLongLong
- (BOOL)scanLongLong:(long long *)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSUInteger end;
    BOOL result;
    NSScanner * S;
    if([self.string length])
    {
//NSLog(@"GLS");
        [self.string getLineStart:nil end:&end contentsEnd:nil forRange:NSMakeRange(self.scanLocation, 0)];
        S = [NSScanner scannerWithString:[self.string substringWithRange:
            NSIntersectionRange(NSMakeRange(self.scanLocation, end - self.scanLocation),
                NSMakeRange(0, [self.string length]))]];
        result = [S scanLongLong:value];
        self.scanLocation += [S scanLocation];
    }
    else
        result = NO;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanFloat
- (BOOL)scanFloat:(float *)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSUInteger end;
    BOOL result;
    NSScanner * S;
    if([self.string length])
    {
//NSLog(@"GLS");
        [self.string getLineStart:nil end:&end contentsEnd:nil forRange:NSMakeRange(self.scanLocation, 0)];
        S = [NSScanner scannerWithString:[self.string substringWithRange:
            NSIntersectionRange(NSMakeRange(self.scanLocation, end - self.scanLocation),
                NSMakeRange(0, [self.string length]))]];
        result = [S scanFloat:value];
        self.scanLocation += [S scanLocation];
    }
    else
        result = NO;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scanDouble:
- (BOOL)scanDouble:(double *)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSUInteger end;
    BOOL result;
    NSScanner * S;
    if([self.string length])
    {
//NSLog(@"GLS");
        [self.string getLineStart:nil end:&end contentsEnd:nil forRange:NSMakeRange(self.scanLocation, 0)];
        S = [NSScanner scannerWithString:[self.string substringWithRange:
            NSIntersectionRange(NSMakeRange(self.scanLocation, end - self.scanLocation),
                NSMakeRange(0, [self.string length]))]];
        result = [S scanDouble:value];
        self.scanLocation += [S scanLocation];
    }
    else
        result = NO;
    return result;
}
- (BOOL)scanCharacter:(unichar)value;
{
    if(![self isAtEnd] && ([self.string characterAtIndex:self.scanLocation] == value))
    {
        ++self.scanLocation;
        return YES;
    }
    return NO;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= message
- (void)message;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
#endif
@end

@implementation iTM2LiteScanner (String) 
- (BOOL)scanCommentSequence;
{
    return [self scanCharacter:'%'];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2LiteScanner


#if 0
- (BOOL)hasPrefix:(NSString *)aString;
- (BOOL)hasSuffix:(NSString *)aString;
- (NSRange)rangeOfString:(NSString *)aString options:(NSUInteger)mask range:(NSRange)searchRange;
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSUInteger)mask range:(NSRange)searchRange;
#endif

