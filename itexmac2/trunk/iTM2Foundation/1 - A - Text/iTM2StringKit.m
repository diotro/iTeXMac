/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#include <Carbon/Carbon.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2LiteScanner.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2ARegularExpressionKit.h>
#import <iTM2Foundation/iTM2StringFormatKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSString(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getIntegerTrailer:
- (BOOL)getIntegerTrailer:(int *)intPtr;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCharacterSet * nonDecimalDigitCharacterSet = nil;
    if(!nonDecimalDigitCharacterSet)
        nonDecimalDigitCharacterSet = [[[NSCharacterSet decimalDigitCharacterSet] invertedSet] retain];
    if(intPtr && [self length])
    {
        NSRange R = [self rangeOfCharacterFromSet:nonDecimalDigitCharacterSet options:NSBackwardsSearch];
        if(R.length)
        {
            R.location = NSMaxRange(R);
            if(R.location < [self length])
            {
                R.length = [self length] - R.location;
                * intPtr = [[self substringWithRange:R] intValue];
                return YES;
            }
        }
        else
        {
            * intPtr = [self intValue];
            return YES;
        }
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForCommentedKey:forRange:effectiveRange:inHeader:
- (NSString *)stringForCommentedKey:(NSString *)aKey forRange:(NSRange)aRange effectiveRange:(NSRangePointer)aRangePtr inHeader:(BOOL)aFlag;
/*"Scans the string for "% !iTeXMac2(key): value" pairs. If the search takes place only in the header, aRange is the whole string and the search will stop as soon as an uncommented line is scanned. In the other case, the search is performed on the smallest set of lines containing aRange. If aRangePtr is not nil, it will hold on return the range of the whole line corresponding to aKey, including the termination characters if any.
Scanning the key is not case sensitive while scanning the (on return) value is case sensitive.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"<%@> stringForCommentedKey: <%@>, %@", self, aKey, NSStringFromRange(aRange));
    NSRange r =  NSMakeRange(0, [self length]);
    aRange = aFlag? r: NSIntersectionRange(aRange, r);
    if([aKey length])
    {
        unsigned ceiling = NSMaxRange(aRange);
        unsigned start;
        iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:self];
        NSCharacterSet * CRLF = [NSCharacterSet characterSetWithCharactersInString:@"\n\r"];
//NSLog(@"GLS");
        [self getLineStart:&start end:nil contentsEnd:nil forRange:aRange];
        [S setScanLocation:start];
        while(([S scanLocation] < ceiling) && ![S isAtEnd])
        {
            [S setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//NSLog(@"<%@>", [S string]);
            if([S scanString:@"%" intoString:nil])
            {
                unsigned location = [S scanLocation];
                [S setCaseSensitive:NO];
                [S setCharactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
//NSLog(@"1");
                if([S scanString:@"!" intoString:nil] &&
                    ([S scanString:@"itexmac" intoString:nil]) &&
                        [S scanString:@"("//)
                                    intoString: nil] &&
                            [S scanString:aKey intoString:nil] &&
                                [S scanString://(
                                    @")" intoString : nil] &&
                                    [S scanString:@":" intoString :nil])
                {
                    NSString * result;
                    [S setCaseSensitive:YES];
                    if(![S scanUpToCharactersFromSet:CRLF intoString:&result])
                        result = [NSString string];
                    if(aRangePtr)
                    {
                        [S scanCharactersFromSet:CRLF intoString:nil];
                        * aRangePtr = NSMakeRange(location, [S scanLocation] - location);
                    }
                    return [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
            }
            else if(![S isAtEnd] && aFlag)
                break;
            [S setCharactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
            [S scanUpToCharactersFromSet:CRLF intoString:nil];
        }
    }
    if(aRangePtr) * aRangePtr = NSMakeRange(NSNotFound, 0);
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine:
- (NSRange)getRangeForLine:(unsigned int)aLine;
/*"Given a 1 based line number, it returns the line range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if((aLine == NSNotFound)|| (!aLine))
        return NSMakeRange(NSNotFound, 0);
    unsigned int end;
    unsigned int top = [self length];
    NSRange range = NSMakeRange(0, 0);
    typedef void (*GetLineStartIMP) (id, SEL, unsigned *, unsigned *, unsigned *, NSRange);
    GetLineStartIMP GLS = (GetLineStartIMP)
        [self methodForSelector:@selector(getLineStart:end:contentsEnd:forRange:)];
next:
    GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &range.location, nil, range);
    if(--aLine == 0)
    {
		range.length=end-range.location;
        return range;
    }
    else if(end<top)
    {
        goto next;
    }
    else
    {
        return NSMakeRange(NSNotFound, 0);
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLineRange:
- (NSRange)getRangeForLineRange:(NSRange)aLineRange;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned int start;
    NSRange range = NSMakeRange(0, 0);
    typedef void (*GetLineStartIMP) (id, SEL, unsigned *, unsigned *, unsigned *, NSRange);
    GetLineStartIMP GLS = (GetLineStartIMP)
        [self methodForSelector:@selector(getLineStart:end:contentsEnd:forRange:)];
    while (aLineRange.location-->0)
    {
//NSLog(@"GLS");
        GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &range.location, nil, range);
    }
	GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), &start, nil, nil, range);
    while (--aLineRange.length>0)
    {
//NSLog(@"GLS");
        GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &range.location, nil, range);
    }
    return NSMakeRange(start,range.location-start);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineNumberAtIndex:
- (unsigned)lineNumberAtIndex:(unsigned)index;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int result = 0;
    unsigned contentsEnd = 0;
    int ceiling = MIN(index + 1, [self length]);
    NSRange range = NSMakeRange(0, 0);
    typedef void (*GetLineStartIMP) (id, SEL, unsigned *, unsigned *, unsigned *, NSRange);
    GetLineStartIMP GLS = (GetLineStartIMP)
        [self methodForSelector:@selector(getLineStart:end:contentsEnd:forRange:)];
    while (range.location < ceiling)
    {
        ++result;
//NSLog(@"GLS");
        GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &range.location, &contentsEnd, range);
    }
    if((index > contentsEnd) || ([self length] == 0))
        ++result;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= numberOfLines
- (unsigned)numberOfLines;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned index = [self length];
    unsigned result = [self lineNumberAtIndex:index];
//NSLog(@"%@: %d lines", self, result);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingTrailingWhites
- (NSString *)stringByRemovingTrailingWhites;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned index = [self length];
    if(!index)
        return [NSString string];
    else
    {
        while((index>0) && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:--index]]);
        return [self substringWithRange:NSMakeRange(0, ++index)];
    }
}
//=-=-=-=-=-=  stringWithSubstring:replacedByString:
- (NSString*)stringWithSubstring:(NSString*)oldString replacedByString:(NSString*)newString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([oldString length])
    {
        NSMutableString * result = [[self mutableCopy] autorelease];
        NSRange searchRange = NSMakeRange(0,[self length]);
        if(!newString) newString = [NSString string];
        while(YES)
        {
            NSRange range = [result rangeOfString:oldString options:0 range:searchRange];
            if (range.length)
            {
                [result replaceCharactersInRange:range withString:newString];
                range.location+=[newString length];//no recursive change
                range.length=searchRange.length=[result length];
                searchRange.location=0;
                searchRange=NSIntersectionRange(range, searchRange);
            }
            else
                break;
        }
        return result;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeBySelectingParagraphIfNeededWithRange:
- (NSRange)rangeBySelectingParagraphIfNeededWithRange:(NSRange)range;
/*"Given a selected range, extends the range to paragraphs.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    range = NSIntersectionRange(range, NSMakeRange(0, [self length]));
	NSRange biggerRange = range;
	NSCharacterSet * set = [NSCharacterSet whitespaceCharacterSet];
	while(biggerRange.location && [set characterIsMember:[self characterAtIndex:biggerRange.location-1]])
	{
		--biggerRange.location;
		++biggerRange.length;
	}
	while((NSMaxRange(biggerRange)<[self length]) && [set characterIsMember:[self characterAtIndex:NSMaxRange(biggerRange)]])
	{
		++biggerRange.length;
	}
    unsigned start;
    [self getLineStart:&start end:nil contentsEnd:nil forRange:biggerRange];
    if(start == biggerRange.location)
    {
        unsigned end, contentsEnd;
        [self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:biggerRange];
        if(contentsEnd == NSMaxRange(biggerRange))
            return NSMakeRange(start, end - start);
    }
    return range;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compareUsingLastPathComponent:
- (int)compareUsingLastPathComponent:(NSString *)rhs;
	/*"Description forthcoming.
					  Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
	"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// assuming that they have windows as targets
    return [[self lastPathComponent] compare:[rhs lastPathComponent]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
- (NSRange)doubleClickAtIndex:(unsigned)index;
/*"Uses the NSAttributedString method. too bad.
Beware of ∞ loops because NSAttributedString uses methods above.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[[NSAttributedString alloc] initWithString:self attributes:nil] autorelease] doubleClickAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfWordAtIndex:
- (NSRange)rangeOfWordAtIndex:(unsigned int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(index<[self length])
	{
		NSCharacterSet * set = [NSCharacterSet alphanumericCharacterSet];
		NSRange result = NSMakeRange(index, 0);
		if([set characterIsMember:[self characterAtIndex:index]])
		{
			++result.length;
			while((++index<[self length]) && [set characterIsMember:[self characterAtIndex:index]])
				++result.length;
			index = result.location;
			while(index-- && [set characterIsMember:[self characterAtIndex:index]])
				++result.length, --result.location;
		}
		return result;
	}
	return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= wordRangeForRange:
- (NSRange)wordRangeForRange:(NSRange)wordRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(wordRange.length == 1)
	{
		NSCharacterSet * whiteSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		if([whiteSet characterIsMember:[self characterAtIndex:wordRange.location]])
			return NSMakeRange(NSNotFound, 0);
		return wordRange;
	}
	NSRange result = wordRange;
	NSCharacterSet * set = [NSCharacterSet alphanumericCharacterSet];
	unsigned int index = NSMaxRange(result);
	while((index<[self length]) && [set characterIsMember:[self characterAtIndex:index++]])
		++result.length;
	index = result.location;
	while(index-- && [set characterIsMember:[self characterAtIndex:index]])
		++result.length, --result.location;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfWord:options:range:
- (NSRange)rangeOfWord:(NSString *)aWord options:(unsigned)mask range:(NSRange)searchRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: coder:20050530 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange result;
	if(mask & NSAnchoredSearch)
	{
		result = [self rangeOfString:aWord options:mask range:searchRange];
		NSRange wordRange = [self wordRangeForRange:result];
		if(wordRange.length == result.length)
			return result;
		else
			return NSMakeRange(NSNotFound, 0);
	}
	else if(mask & NSBackwardsSearch)
	{
		previous:
		result = [self rangeOfString:aWord options:mask range:searchRange];
		if(result.length)
		{
			NSRange wordRange = [self wordRangeForRange:result];
			if(wordRange.length == result.length)
				return result;
			if(wordRange.location > searchRange.location)
			{
				searchRange.length = wordRange.location - searchRange.location;
				goto previous;
			}
		}
	}
	else
	{
		next:
		result = [self rangeOfString:aWord options:mask range:searchRange];
		if(result.length)
		{
			NSRange wordRange = [self wordRangeForRange:result];
			if(wordRange.length == result.length)
				return result;
			result.location = NSMaxRange(wordRange);// local variable
			if(result.location < NSMaxRange(searchRange))
			{
				searchRange.length = NSMaxRange(searchRange) - result.location;
				searchRange.location = result.location;
				goto next;
			}
		}
	}
    return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= componentsSeparatedByStrings:
- (NSArray *)componentsSeparatedByStrings:(NSString *)separator, ...;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [NSMutableArray arrayWithObject:self];
	va_list ap;
	va_start(ap, separator);
	while([separator isKindOfClass:[NSString class]])
	{
		NSMutableArray * newResult = [NSMutableArray array];
		NSEnumerator * E = [result objectEnumerator];
		NSString * S;
		while(S = [E nextObject])
			[newResult addObjectsFromArray:[S componentsSeparatedByString:separator]];
		[result setArray:newResult];
		separator = va_arg(ap, NSString *);
	}
	va_end(ap);
//iTM2_END;
	return [NSArray arrayWithArray:result];
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)

