/*
//
//  @version Subversion: $Id: iTM2StringKit.m 750 2008-09-17 13:48:05Z jlaurens $ 
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

#import "ICURegEx.h"
#import "iTM2StringKit.h"
#import "iTM2ContextKit.h"
#import "iTM2InstallationKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSString(iTeXMac2)
+ (NSString*)stringWithUUID4iTM3
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString * string = (NSString*)CFMakeCollectable(CFUUIDCreateString(kCFAllocatorDefault, uuid));
    CFRelease(uuid);
    return [string autorelease];    
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getIntegerTrailer4iTM3:
- (BOOL)getIntegerTrailer4iTM3:(NSInteger *)intPtr;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:07:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static NSCharacterSet * nonDecimalDigitCharacterSet = nil;
    if (!nonDecimalDigitCharacterSet)
        nonDecimalDigitCharacterSet = [[[NSCharacterSet decimalDigitCharacterSet] invertedSet] retain];
    if (intPtr && self.length) {
        NSRange R = [self rangeOfCharacterFromSet:nonDecimalDigitCharacterSet options:NSBackwardsSearch];
        if (R.length) {
            R.location = iTM3MaxRange(R);
            if (R.location < self.length) {
                R.length = self.length - R.location;
                * intPtr = [[self substringWithRange:R] integerValue];
                return YES;
            }
        } else {
            * intPtr = self.integerValue;
            return YES;
        }
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForCommentedKey4iTM3:forRange:effectiveRange:inHeader:
- (NSString *)stringForCommentedKey4iTM3:(NSString *)aKey forRange:(NSRange)aRange effectiveRange:(NSRangePointer)aRangePtr inHeader:(BOOL)aFlag;
/*"Scans the string for "% !iTeXMac2(key): value" pairs. If the search takes place only in the header,
aRange is the whole string and the search will stop as soon as an uncommented line is scanned.
In the other case, the search is performed on the smallest set of lines containing aRange.
If aRangePtr is not nil, it will hold on return the range of the whole line corresponding to aKey,
including the termination characters if any.
Scanning the key is not case sensitive while scanning the (on return) value is case sensitive.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"<%@> stringForCommentedKey4iTM3: <%@>, %@", self, aKey, NSStringFromRange(aRange));
    if (!aKey.length)
    {
no_match:
		if (aRangePtr) * aRangePtr = iTM3MakeRange(NSNotFound, ZER0);
		return [NSString string];
	}
	NSRange r =  iTM3MakeRange(ZER0, self.length);
	aRange = aFlag? r: iTM3ProjectionRange(aRange, r);
	ICURegEx * RE = [ICURegEx regExForKey:@"%!iTeXMac2..." error:NULL];
	[RE setInputString:self range:aRange];
	if (![RE nextMatch] || [RE numberOfCaptureGroups]!=1) {
        RE.forget;
		goto no_match;
	}
	if (aRangePtr) * aRangePtr = [RE rangeOfCaptureGroupWithName:@"content"];
	return [RE substringOfCaptureGroupWithName:@"content"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine4iTM3:
- (NSRange)getRangeForLine4iTM3:(NSUInteger)aLine;
/*"Given a 1 based line number, it returns the line range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((aLine == NSNotFound)|| (!aLine))
        return iTM3MakeRange(NSNotFound, ZER0);
    NSUInteger end;
    NSUInteger top = self.length;
    NSRange range = iTM3MakeRange(ZER0, ZER0);
    typedef void (*GetLineStartIMP) (id, SEL, NSUInteger *, NSUInteger *, NSUInteger *, NSRange);
    GetLineStartIMP GLS = (GetLineStartIMP)
        [self methodForSelector:@selector(getLineStart:end:contentsEnd:forRange:)];
    while (YES) {
        GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &end, nil, range);
        if (--aLine == ZER0) {
            range.length=end-range.location;
            return range;
        }
        else if (end<top) {
            range.location = end;
            range.length = ZER0;
            continue;
        }
        return iTM3MakeRange(NSNotFound, ZER0);
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine4iTM3Range:
- (NSRange)getRangeForLine4iTM3Range:(NSRange)aLineRange;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger start;
    NSRange range = iTM3MakeRange(ZER0, ZER0);
    typedef void (*GetLineStartIMP) (id, SEL, NSUInteger *, NSUInteger *, NSUInteger *, NSRange);
    GetLineStartIMP GLS = (GetLineStartIMP)
        [self methodForSelector:@selector(getLineStart:end:contentsEnd:forRange:)];
    while (aLineRange.location-->ZER0)
    {
//NSLog(@"GLS");
        GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &range.location, nil, range);
    }
	GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), &start, nil, nil, range);
    while (--aLineRange.length>ZER0)
    {
//NSLog(@"GLS");
        GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &range.location, nil, range);
    }
    return iTM3MakeRange(start,range.location-start);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineIndexForLocation4iTM3:
- (NSUInteger)lineIndexForLocation4iTM3:(NSUInteger)index;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger result = ZER0;
    NSUInteger contentsEnd = ZER0;
    NSUInteger ceiling = MIN(index + 1, self.length);
    NSRange range = iTM3MakeRange(ZER0, ZER0);
    typedef void (*GetLineStartIMP) (id, SEL, NSUInteger *, NSUInteger *, NSUInteger *, NSRange);
    GetLineStartIMP GLS = (GetLineStartIMP)
        [self methodForSelector:@selector(getLineStart:end:contentsEnd:forRange:)];
    while (range.location < ceiling)
    {
        ++result;
//NSLog(@"GLS");
        GLS(self, @selector(getLineStart:end:contentsEnd:forRange:), nil, &range.location, &contentsEnd, range);
    }
    if ((index > contentsEnd) || (self.length == ZER0))
        ++result;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= numberOfLines4iTM3
- (NSUInteger)numberOfLines4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger index = self.length;
    NSUInteger result = [self lineIndexForLocation4iTM3:index];
//NSLog(@"%@: %d lines", self, result);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingTrailingWhites4iTM3
- (NSString *)stringByRemovingTrailingWhites4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger index = self.length;
    if (!index)
        return [NSString string];
    else
    {
        while((index>ZER0) && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:--index]]);
        return [self substringWithRange:iTM3MakeRange(ZER0, ++index)];
    }
}
//=-=-=-=-=-=  stringWithSubstring4iTM3:replacedByString:
- (NSString*)stringWithSubstring4iTM3:(NSString*)oldString replacedByString:(NSString*)newString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (oldString.length)
    {
        NSMutableString * result = [self.mutableCopy autorelease];
        NSRange searchRange = iTM3MakeRange(ZER0,self.length);
        if (!newString) newString = [NSString string];
        while(YES)
        {
            NSRange range = [result rangeOfString:oldString options:ZER0 range:searchRange];
            if (range.length)
            {
                [result replaceCharactersInRange:range withString:newString];
                range.location+=newString.length;//no recursive change
                range.length=searchRange.length=result.length;
                searchRange.location=ZER0;
                searchRange=iTM3IntersectionRange(range, searchRange);
            }
            else
                break;
        }
        return result;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeBySelectingParagraphIfNeededWithRange4iTM3:
- (NSRange)rangeBySelectingParagraphIfNeededWithRange4iTM3:(NSRange)range;
/*"Given a selected range, extends the range to paragraphs.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    range = iTM3ProjectionRange(iTM3MakeRange(ZER0, self.length),range);
	NSRange biggerRange = range;
	NSCharacterSet * set = [NSCharacterSet whitespaceCharacterSet];
	while(biggerRange.location && [set characterIsMember:[self characterAtIndex:biggerRange.location-1]])
	{
		--biggerRange.location;
		++biggerRange.length;
	}
	while((iTM3MaxRange(biggerRange)<self.length) && [set characterIsMember:[self characterAtIndex:iTM3MaxRange(biggerRange)]])
	{
		++biggerRange.length;
	}
    NSUInteger start;
    [self getLineStart:&start end:nil contentsEnd:nil forRange:biggerRange];
    if (start == biggerRange.location)
    {
        NSUInteger end, contentsEnd;
        [self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:biggerRange];
        if (contentsEnd == iTM3MaxRange(biggerRange))
            return iTM3MakeRange(start, end - start);
    }
    return range;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compareUsingLastPathComponent4iTM3:
- (NSComparisonResult)compareUsingLastPathComponent4iTM3:(NSString *)rhs;
	/*"Description forthcoming.
					  Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
	"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// assuming that they have windows as targets
    return [self.lastPathComponent compare:rhs.lastPathComponent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
- (NSRange)doubleClickAtIndex:(NSUInteger)index;
/*"Uses the NSAttributedString method. too bad.
Beware of ∞ loops because NSAttributedString uses methods above.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[[NSAttributedString alloc] initWithString:self attributes:nil] autorelease] doubleClickAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfWordAtIndex4iTM3:
- (NSRange)rangeOfWordAtIndex4iTM3:(NSUInteger)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (index<self.length)
	{
		NSCharacterSet * set = [NSCharacterSet alphanumericCharacterSet];
		NSRange result = iTM3MakeRange(index, ZER0);
		if ([set characterIsMember:[self characterAtIndex:index]])
		{
			++result.length;
			while((++index<self.length) && [set characterIsMember:[self characterAtIndex:index]])
				++result.length;
			index = result.location;
			while(index-- && [set characterIsMember:[self characterAtIndex:index]])
				++result.length, --result.location;
		}
		return result;
	}
	return iTM3MakeRange(NSNotFound, ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= wordRangeForRange4iTM3:
- (NSRange)wordRangeForRange4iTM3:(NSRange)wordRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (wordRange.length == 1)
	{
		NSCharacterSet * whiteSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		if ([whiteSet characterIsMember:[self characterAtIndex:wordRange.location]])
			return iTM3MakeRange(NSNotFound, ZER0);
		return wordRange;
	}
	NSRange result = wordRange;
	NSCharacterSet * set = [NSCharacterSet alphanumericCharacterSet];
	NSUInteger index = iTM3MaxRange(result);
	while((index<self.length) && [set characterIsMember:[self characterAtIndex:index++]])
		++result.length;
	index = result.location;
	while(index-- && [set characterIsMember:[self characterAtIndex:index]])
		++result.length, --result.location;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfWord:options:range:
- (NSRange)rangeOfWord:(NSString *)aWord options:(NSUInteger)mask range:(NSRange)searchRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: coder:20050530 
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange result;
	if (mask & NSAnchoredSearch)
	{
		result = [self rangeOfString:aWord options:mask range:searchRange];
		NSRange wordRange = [self wordRangeForRange4iTM3:result];
		if (wordRange.length == result.length)
			return result;
		else
			return iTM3MakeRange(NSNotFound, ZER0);
	}
	else if (mask & NSBackwardsSearch)
	{
		previous:
		result = [self rangeOfString:aWord options:mask range:searchRange];
		if (result.length)
		{
			NSRange wordRange = [self wordRangeForRange4iTM3:result];
			if (wordRange.length == result.length)
				return result;
			if (wordRange.location > searchRange.location)
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
		if (result.length)
		{
			NSRange wordRange = [self wordRangeForRange4iTM3:result];
			if (wordRange.length == result.length)
				return result;
			result.location = iTM3MaxRange(wordRange);// local variable
			if (result.location < iTM3MaxRange(searchRange))
			{
				searchRange.length = iTM3MaxRange(searchRange) - result.location;
				searchRange.location = result.location;
				goto next;
			}
		}
	}
    return iTM3MakeRange(NSNotFound, ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= componentsSeparatedByStrings4iTM3:
- (NSArray *)componentsSeparatedByStrings4iTM3:(NSString *)separator, ...;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * result = [NSMutableArray arrayWithObject:self];
	va_list ap;
	va_start(ap, separator);
	while ([separator isKindOfClass:[NSString class]]) {
		NSMutableArray * newResult = [NSMutableArray array];
		for (NSString * S in result)
			[newResult addObjectsFromArray:[S componentsSeparatedByString:separator]];
		[result setArray:newResult];
		separator = va_arg(ap, NSString *);
	}
	va_end(ap);
//END4iTM3;
	return [NSArray arrayWithArray:result];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= editDistanceToString4iTM3:
- (NSUInteger)editDistanceToString4iTM3:(NSString *)aString;
/*"Levenshtein distance.
from http://en.wikibooks.org/wiki/Algorithm_implementation/Strings/Levenshtein_distance#C.2B.2B
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	const NSUInteger cost_del = 1;
	const NSUInteger cost_ins = 1;
	const NSUInteger cost_sub = 1;

	NSUInteger smallP[30];
	NSUInteger smallQ[30];
	
	NSUInteger n1 = self.length;
	NSUInteger n2 = aString.length;
	if (!n1)
	{
		return n2;
	}
	if (!n2)
	{
		return n1;
	}
	NSString * S1;
	NSString * S2;
	NSUInteger j;
	if (n1<n2)
	{
		j = n2;
		n2 = n1;
		n1 = j;
		S1 = aString;
		S2 = self;
	}
	else
	{
		S1 = self;
		S2 = aString;
	}
	NSUInteger* p;
	NSUInteger* q;
	
	if (n2+1>30)
	{
		p = (NSUInteger*)malloc((n2+1)*sizeof(NSUInteger));
		q = (NSUInteger*)malloc((n2+1)*sizeof(NSUInteger));
	}
	else
	{
		p = smallP;
		q = smallQ;
	}
	if (!p || !q)
	{
		return UINT_MAX;
	}

	p[ZER0] = ZER0;
	
	for( j = 1; j <= n2; ++j )
		p[j] = p[j-1] + cost_ins;

	NSUInteger i;
	for( i = 1; i <= n1; ++i )
	{
		unichar uchar1 = [S1 characterAtIndex:i-1];
		q[ZER0] = p[ZER0] + cost_del;
		for( j = 1; j <= n2; ++j )
		{
			unichar uchar2 = [S2 characterAtIndex:j-1];
			NSUInteger d_del = p[j] + cost_del;
			NSUInteger d_ins = q[j-1] + cost_ins;
			NSUInteger d_sub = p[j-1] + ( uchar1 == uchar2 ? ZER0 : cost_sub );
			q[j] = MIN(MIN( d_del, d_ins ), d_sub );
		}
		NSUInteger* r = p;
		p = q;
		q = r;
	}

	NSUInteger result = p[n2];
	if (p!=smallP && p!=smallQ)
	{
		free(p);
		free(q);
	}
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lastCharacter4iTM3
- (unichar)lastCharacter4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 
 To Do List: ?
 "*/
{DIAGNOSTIC4iTM3;
    return self.length? [self characterAtIndex:self.length-1]:ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineComponents4iTM3
- (NSArray *)lineComponents4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 
 To Do List: ?
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSMutableArray * lines = [NSMutableArray array];
	NSRange R = iTM3MakeRange(ZER0,ZER0);
	NSUInteger contentsEnd = ZER0, end = ZER0;
	while(R.location < self.length)
	{
		R.length = ZER0;
		[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		R.length = end - R.location;
		NSString * S = [self substringWithRange:R];
		[lines addObject:S];
		R.location = end;
		R.length = ZER0;
	}
	if (contentsEnd<end)
	{
		// the last line is a return line
		[lines addObject:@""];
	}
	//END4iTM3;
	return lines;
}
#pragma mark =-=-=-=-=-  INDENTATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByEscapingPerlControlCharacters4iTM3
- (NSString *)stringByEscapingPerlControlCharacters4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 02/15/2006
 To Do List: ?
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSMutableString * result = [self.mutableCopy autorelease];
	NSRange searchRange = iTM3MakeRange(ZER0,result.length);
	[result replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:ZER0 range:searchRange];
	searchRange.length = result.length;
	[result replaceOccurrencesOfString:@"$" withString:@"\\$" options:ZER0 range:searchRange];
	searchRange.length = result.length;
	[result replaceOccurrencesOfString:@"@" withString:@"\\@" options:ZER0 range:searchRange];
	searchRange.length = result.length;
	[result replaceOccurrencesOfString:@"[" withString:@"\\[" options:ZER0 range:searchRange];
	//END4iTM3;
	return result;
}
@end

@implementation NSMutableString(iTM2StringKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prependString4iTM3:
- (void)prependString4iTM3:(NSString *)aString;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 11:24:34 UTC 2010
 To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
 "*/
{DIAGNOSTIC4iTM3;
	[self insertString:aString atIndex:ZER0];
}
@end

@implementation NSTextStorage(iTM2StringKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineIndexForLocation4iTM3:
- (NSUInteger)lineIndexForLocation4iTM3:(NSUInteger)index;
/*"Given a range, it returns the line number of the first char of the range.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	return [self.string lineIndexForLocation4iTM3:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= length
- (NSUInteger)length;
/*"Given a range, it returns the line number of the first char of the range.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    return self.string.length;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineStart:end:contentsEnd:forRange:
- (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range;
/*"Given a range, it returns the line number of the first char of the range.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSString * string = self.string;
	[string getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine4iTM3:
- (NSRange)getRangeForLine4iTM3:(NSUInteger)aLine;
/*"Given a 1 based line number, it returns the line range including the ending characters.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.3: 03/10/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSString * string = self.string;
	return [string getRangeForLine4iTM3:aLine];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine4iTM3Range:
- (NSRange)getRangeForLine4iTM3Range:(NSRange)aLineRange;
/*"Given a line range number, it returns the range including the ending characters.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSString * string = self.string;
	return [string getRangeForLine4iTM3Range:(NSRange)aLineRange];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)

