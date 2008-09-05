/*
//
//  @version Subversion:$Id:iTM2TeXStringKit.m 111 2006-07-20 11:12:42Z jlaurens $ 
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
//  Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import <iTM2TeXFoundation/iTM2TeXStringKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>

#define ANCS [NSCharacterSet alphanumericCharacterSet]

@interface NSAttributedString(PRIVATE)
- (NSRange)originalDoubleClickAtIndex:(unsigned)index;
@end

@interface ICURegEx(TeXStringKit)
+ (ICURegEx *)the7bitsAccentsRegEx;
@end
@implementation ICURegEx(TeXStringKit)
+ (ICURegEx *)the7bitsAccentsRegEx;
{
	return [self regExWithSearchPattern:@"\\\\[`'\\^\"~=.uvHtcdb]\\{.\\}"];
}
@end

@implementation iTM2TeXStringController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfCharactersInSet:inAttributedString:atIndex:
+ (NSRange)rangeOfCharactersInSet:(NSCharacterSet *)theSet inAttributedString:(NSAttributedString *)theAttributedString atIndex:(unsigned)index;
/*"All the letters around the index
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * itsString = [theAttributedString string];
	unichar theChar = [itsString characterAtIndex:index];
	NSRange R = NSMakeRange(NSNotFound,0);
	if([theSet characterIsMember:theChar])
	{
		R.location = index;
		R.length = 1;
		unsigned loc = index;
left:
		if(--index)
		{
			theChar = [itsString characterAtIndex:index];
			if([theSet characterIsMember:theChar])
			{
				--R.location;
				++R.length;
				goto left;
			}
		}
		loc = index;
		unsigned length = [itsString length];
right:
		if(++index<length)
		{
			theChar = [itsString characterAtIndex:index];
			if([theSet characterIsMember:theChar])
			{
				++R.length;
				goto right;
			}
		}
	}
//iTM2_END;
	return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= TeXAwareWordRangeInString:atIndex:
+ (NSRange)TeXAwareWordRangeInString:(NSAttributedString *)theAttributedString atIndex:(unsigned)index;
/*"This takes TeX commands into account, and \- hyphenation too
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= TeXAwareWordRangeInAttributedString:atIndex:
+ (NSRange)TeXAwareWordRangeInAttributedString:(NSAttributedString *)theAttributedString atIndex:(unsigned)index;
/*"This takes TeX commands into account, and \- hyphenation too
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * itsString = [theAttributedString string];
	NSString * s;
	unsigned length = [itsString length];
	unichar theChar = [itsString characterAtIndex:index];
    NSRange R, r;
	unsigned loc;
	unsigned commandIndex = NSNotFound;
	BOOL escaped;
	if([ANCS characterIsMember:theChar])
	{
		R = [theAttributedString originalDoubleClickAtIndex:index];
		ICURegEx * RE = nil;
expandToTheLeftAsLetters:
		if(R.location)
		{
			theChar = [itsString characterAtIndex:R.location-1];
			if([ANCS characterIsMember:theChar])
			{
				r = [theAttributedString originalDoubleClickAtIndex:R.location-1];
				if(r.location
					&& [itsString isControlAtIndex:r.location-1 escaped:&escaped]
						&& !escaped)
				{
					goto expandToTheRightAsLetters;
				}
				R = NSUnionRange(R,r);
				goto expandToTheLeftAsLetters;
			}
			if((R.location>4)
				&& [itsString isControlAtIndex:R.location-5 escaped:&escaped]
					&& !escaped)
			{
				r = NSMakeRange(R.location-5,5);
				if(NSMaxRange(r)<=length)
				{
					s = [itsString substringWithRange:r];
					RE = [ICURegEx the7bitsAccentsRegEx];
					[RE setInputString:s];
					if([RE matchesAtIndex:0 extendToTheEnd:YES])
					{
						R.location -= 5;
						R.length += 5;
						commandIndex = R.location;
						goto expandToTheLeftAsLetters;
					}
				}
			}
			if((R.location>1)
				&& [itsString isControlAtIndex:R.location-2 escaped:&escaped]
					&& !escaped
						&& ((theChar=='-')||(theChar=='_')||(theChar=='@')||(theChar=='`')||(theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.')))
			{
				R.location -= 2;
				R.length += 2;
				commandIndex = R.location;
				goto expandToTheLeftAsLetters;
			}
			if((R.location>0)
				&& [itsString isControlAtIndex:R.location-1 escaped:&escaped]
					&& !escaped)
			{
				R.length += R.location;
				if(commandIndex != NSNotFound)
				{
					// it is not the correct range if there is already a command somewhere.
					R.location = commandIndex;
					R.length -= R.location;
					return R;
				}
				commandIndex = R.location-1;
				R.location = commandIndex;
				R.length -= R.location;
				// then expand everything to the right, as command, accept only letters and @
				loc = NSMaxRange(R);
				if(loc<[theAttributedString length])// this was missing
				{
					r = [self rangeOfCharactersInSet:[NSCharacterSet letterCharacterSet] inAttributedString:theAttributedString atIndex:loc];
					if(r.length)
					{
						R = NSUnionRange(R,r);
					}
				}
				return R;
			}
		}
		if(R.location>2)
		{
			// is it a 7bits accented letter?
			r = NSMakeRange(R.location-3,5);
			if(NSMaxRange(r)<=length)
			{
				s = [itsString substringWithRange:r];
				RE = [ICURegEx the7bitsAccentsRegEx];
				[RE setInputString:s];
				if([RE matchesAtIndex:0 extendToTheEnd:YES])
				{
					R = r;
					return R;
				}
			}
		}
expandToTheRightAsLetters:
		// just add \_, \-, \@ and all accented chars
		loc = NSMaxRange(R);
		if(loc>=length)
		{
			return R;
		}
		if(loc+4<length)
		{
			r = NSMakeRange(loc,5);
			s = [itsString substringWithRange:r];
			RE = [ICURegEx the7bitsAccentsRegEx];
			[RE setInputString:s];
			if([RE matchesAtIndex:0 extendToTheEnd:YES])
			{
				R.length += 5;
				goto expandToTheRightAsLetters;
			}
		}
		if((loc+1<length) &&
				[itsString isControlAtIndex:loc escaped:&escaped] &&
						!escaped)
		{
			theChar = [itsString characterAtIndex:loc+1];
			if((theChar=='_')||(theChar=='-')||(theChar=='@'))
			{
				R.length += 2;
				goto expandToTheRightAsLetters;
			}
			else if((theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.'))
			{
				R.length += 2;
				loc+=2;
				if(loc>=length)
				{
					return R;
				}
			}
		}
		theChar = [itsString characterAtIndex:loc];
		if([ANCS characterIsMember:theChar])
		{
			r = [theAttributedString originalDoubleClickAtIndex:loc];
			R = NSUnionRange(R,r);
			goto expandToTheRightAsLetters;
		}
		return R;
	}
	// this is not a letter character
	if([itsString isControlAtIndex:index escaped:&escaped] && !escaped)
	{
		if(index+1<length)
		{
			theChar = [itsString characterAtIndex:index+1];
			R = NSMakeRange(index,2);
			if((theChar=='`')||(theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.'))
			{
				if(index+2<length)
				{
					r = [itsString groupRangeAtIndex:index+2 beginDelimiter:'{' endDelimiter:'}'];
					if(r.location == index+2)
					{
						R = NSUnionRange(R,r);
					}
					else
					{
						theChar = [itsString characterAtIndex:index+2];
						if([ANCS characterIsMember:theChar])
						{
							r = [theAttributedString originalDoubleClickAtIndex:index+2];
							R = NSUnionRange(R,r);
						}
						else
						{
							// not a letter nor a '{', weird
							return R;
						}
					}
					goto expandToTheLeftAsLetters;
				}
			}
			else if(theChar=='-')
			{
				// hyphens are selected without the surrounding letters to allow deletion
				return R;
			}
			else if(theChar=='(')
			{
				//select the balancing stuff
				r = NSMakeRange(index+1,length-index-1);
				r = [itsString rangeOfString:@"\\)" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = NSMaxRange(r);
						r.location = index;
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			else if(theChar=='[')
			{
				//select the balancing stuff
				r = NSMakeRange(index+1,length-index-1);
				r = [itsString rangeOfString:@"\\]" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = NSMaxRange(r);
						r.location = index;
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			else if(theChar==')')
			{
				//select the balancing stuff
				r = NSMakeRange(0,index);
				r = [itsString rangeOfString:@"\\(" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = NSMaxRange(R);
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			else if(theChar==']')
			{
				//select the balancing stuff
				r = NSMakeRange(0,index);
				r = [itsString rangeOfString:@"\\[" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = NSMaxRange(R);
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			R = [theAttributedString originalDoubleClickAtIndex:index+1];
			--R.location;
			++R.length;
			return R;// maybe
		}
		else
		{
			return NSMakeRange(index,1);
		}
	}
	if(index)
	{
		if([itsString isControlAtIndex:index-1 escaped:&escaped] && !escaped)
		{
			R = NSMakeRange(index-1,2);
			if((theChar=='`')||(theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.'))
			{
				if(index+1<length)
				{
					r = [itsString groupRangeAtIndex:index+1 beginDelimiter:'{' endDelimiter:'}'];
					if(r.location == index+1)
					{
						R = NSUnionRange(R,r);
						goto expandToTheLeftAsLetters;
					}
					theChar = [itsString characterAtIndex:index+1];
					if([ANCS characterIsMember:theChar])
					{
						R = [theAttributedString originalDoubleClickAtIndex:index+1];
						R.location -= 2;
						R.length += 2;
						goto expandToTheLeftAsLetters;
					}
					goto expandToTheLeftAsLetters;
				}
			}
			else if(theChar=='(')
			{
				//select the balancing stuff
				r = NSMakeRange(index+1,length-index-1);
				r = [itsString rangeOfString:@"\\)" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = NSMaxRange(r);
						r.location = index-1;
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
			}
			else if(theChar=='[')
			{
				//select the balancing stuff
				r = NSMakeRange(index+1,length-index-1);
				r = [itsString rangeOfString:@"\\]" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = NSMaxRange(r);
						r.location = index-1;
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
			}
			else if(theChar==')')
			{
				//select the balancing stuff
				r = NSMakeRange(0,index);
				r = [itsString rangeOfString:@"\\(" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = index+1;
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
			}
			else if(theChar==']')
			{
				//select the balancing stuff
				r = NSMakeRange(0,index);
				r = [itsString rangeOfString:@"\\[" options:0 range:r];
				while(r.length)
				{
					if([itsString isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = index+1;
						r.length -= r.location;
						return r;
					}
					r.location = NSMaxRange(r);
					r.length = length - r.location;
				}
			}
			R = NSMakeRange(index-1,2);
			return R;// maybe
		}
		if(theChar == '@')
		{
			R = NSMakeRange(index,1);
			goto expandToTheLeftAsLetters;
		}
	}
	if(theChar == '@')
	{
		// is it a URL?
		R = NSMakeRange(index,1);
		goto expandToTheLeftAsLetters;
	}
	if((theChar == '{') || (theChar == '}'))
	{
		R = [itsString groupRangeAtIndex:index beginDelimiter:'{' endDelimiter:'}'];
		if(R.length)
		{
			return R;
		}
	}
	if((theChar == '[') || (theChar == ']'))
	{
		R = [itsString groupRangeAtIndex:index beginDelimiter:'[' endDelimiter:']'];
		if(R.length)
		{
			return R;
		}
	}
	if((theChar == '(') || (theChar == ')'))
	{
		R = [itsString groupRangeAtIndex:index beginDelimiter:'(' endDelimiter:')'];
		if(R.length)
		{
			return R;
		}
	}
	return NSMakeRange(index,1);
}
@end

@interface NSString(MY_OWN_PRIVACY)
- (NSRange)_nextLaTeXEnvironmentDelimiterRangeAfterIndex:(unsigned)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
- (NSRange)_previousLaTeXEnvironmentDelimiterRangeBeforeIndex:(unsigned)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
@end

@implementation NSString(iTM2TeXKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= backslashCharacter
+ (unichar)backslashCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self backslashString] characterAtIndex:0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= commentCharacter
+ (unichar)commentCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self commentString] characterAtIndex:0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bgroupCharacter
+ (unichar)bgroupCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self bgroupString] characterAtIndex:0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= egroupCharacter
+ (unichar)egroupCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self egroupString] characterAtIndex:0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= backslashString
+ (NSString *)backslashString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return @"\\";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= commentString
+ (NSString *)commentString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return @"%";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bgroupString
+ (NSString *)bgroupString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return @"{";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= egroupString
+ (NSString *)egroupString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return @"}";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isControlAtIndex:escaped:
- (BOOL)isControlAtIndex:(unsigned)index escaped:(BOOL *)aFlagPtr;
/*" Returns YES if there is a '\' at index index. For example "\\ " is a 3 length string.
For index = 0, 1 and 2, the aFlagPtr* is NO, YES, NO.
If there is no backslash, aFlagPtr will point to NO, if it is not nil.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unichar backslash = [NSString backslashCharacter];
    if(NSLocationInRange(index, NSMakeRange(0, [self length])) && [self characterAtIndex:index]==backslash)
    {
        if(aFlagPtr)
        {
            unsigned level = 0;
            while(index-->0)
                if([self characterAtIndex:index]==backslash)
                    ++level;
                else
                    break;
            * aFlagPtr = (level%2 > 0);
        }
        return YES;
    }
    else if(aFlagPtr)
        * aFlagPtr = NO;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineStart:end:contentsEnd:TeXComment:forIndex:
- (void)getLineStart:(unsigned *)startPtr end:(unsigned *)lineEndPtr contentsEnd:(unsigned *)contentsEndPtr TeXComment:(unsigned *)commentPtr forIndex:(unsigned) index;
/*" Description Forthcoming
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(commentPtr)
    {
        unsigned start, contentsEnd;
//NSLog(@"GLS");
        [self getLineStart:&start end:lineEndPtr contentsEnd:&contentsEnd forRange:NSMakeRange(index, 0)];
        if(startPtr) *startPtr = start;
        if(contentsEndPtr) *contentsEndPtr = contentsEnd;
        NSRange R = [self rangeOfString:@"%" options:0 range:NSMakeRange(start, contentsEnd-start)];
        BOOL escaped;
        if(R.length && ((R.location==start)||![self isControlAtIndex:R.location-1 escaped:&escaped]||escaped))
            *commentPtr = R.location;
        else
            *commentPtr = NSNotFound;
    }
    else
        [self getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:NSMakeRange(index, 0)];
//NSLog(@"GLS");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isTeXCommentAtIndex:
- (BOOL)isTeXCommentAtIndex:(unsigned)index;
/*" Description Forthcoming
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned int anchor;
//NSLog(@"GLS");
    [self getLineStart:&anchor end:nil contentsEnd:nil forRange:NSMakeRange(index, 0)];
    while(anchor<index)
    {
        NSRange R = [self rangeOfString:@"%" options:0 range:NSMakeRange(anchor, index-anchor)];
        if(R.length)
        {
            if(R.location>anchor)
            {
                BOOL escaped;
                if([self isControlAtIndex:R.location-1 escaped:&escaped] && !escaped)
                    anchor = NSMaxRange(R);
                else
                    return YES;
            }
            else
                return YES;
        }
        else
            break;
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= groupRangeAtIndex:
- (NSRange)groupRangeAtIndex:(unsigned)index;
/*"Returns the range of the smallest group in TeX sense, containing index. If index is out of the string range, the classical not found range is returned. If no group is found, returns a 1 length range at location index. Otherwise, the first character in the range is '{' and the last one is '}'. It is implemented TeX friendly.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self groupRangeAtIndex:index beginDelimiter:'{' endDelimiter:'}'];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= groupRangeAtIndex:beginDelimiter:endDelimiter:
- (NSRange)groupRangeAtIndex:(unsigned)index beginDelimiter:(unichar)bgroup endDelimiter:(unichar)egroup;
/*"Returns the range of the smallest group in TeX sense, containing index. If index is out of the string range, the classical not found range is returned. If no group is found, returns a 1 length range at location index. Otherwise, the first character in the range is '{' and the last one is '}'. It is implemented TeX friendly.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int scanLocation = index;
    int maxLocation = [self length];
    int groupLevel = 1;
    // speedy
    typedef unichar (* CharacterAtIndexIMP) (id, SEL, unsigned);
    CharacterAtIndexIMP CAI = (CharacterAtIndexIMP) [self methodForSelector:@selector(characterAtIndex:)];
    #define NextCharacter CAI(self, @selector(characterAtIndex:), scanLocation)
    BOOL escaped = YES;
    if(!scanLocation||![self isControlAtIndex:scanLocation-1 escaped:&escaped]||escaped)
    {
        unichar uchar = NextCharacter;
        if(uchar==bgroup)
        {
            while (++scanLocation < maxLocation)
            {
                if(escaped)
                    escaped = NO;
                else
                {
                    uchar = NextCharacter;
                    if(uchar==[NSString backslashCharacter])
                        escaped = YES;
                    else if (uchar==bgroup)
                        ++groupLevel;
                    else if (uchar==egroup)
                    {
                        --groupLevel;
                        if (groupLevel==0)
                            return NSMakeRange(index, scanLocation-index + 1);
                    }
                }
            }
        }
        else if(uchar==egroup)
        {
            while (scanLocation-- > 0)
            {
                uchar = NextCharacter;
                if (uchar==egroup)
                {
                    if(!scanLocation)
                        return NSMakeRange(NSNotFound, 0);
                    else if([self isControlAtIndex:scanLocation-1 escaped:&escaped])
                    {
                        if(escaped)
                        {
                            scanLocation -= 2;
                            ++groupLevel;                        
                        }
                        else
                            --scanLocation;
                    }
                    else
                        ++groupLevel;
                }
                else if (uchar==bgroup)
                {
                    if(!scanLocation)
                        --groupLevel;                        
                    else if([self isControlAtIndex:scanLocation-1 escaped:&escaped])
                    {
                        if(escaped)
                        {
                            --groupLevel;                        
                            scanLocation -= 2;
                        }
                        else
                            --scanLocation;
                    }
                    else
                        --groupLevel;
                    if (groupLevel==0)
                        return (scanLocation < index)?
                            NSMakeRange(scanLocation, index-scanLocation + 1):
                                NSMakeRange(NSNotFound, 0);
                }
            }
        }
        else
        {
            return [self groupRangeForRange:NSMakeRange(index, 0) beginDelimiter:bgroup endDelimiter:egroup];
        }
    }
    return  NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= groupRangeForRange:
- (NSRange)groupRangeForRange:(NSRange)range;
/*"Returns the range of the smallest group in TeX sense, containing range. If index is out of the string range, the classical not found range is returned. If no group is found, returns a 1 length range at location index. Otherwise, the first character in the range is '{' and the last one is '}'. It is implemented TeX friendly.
The delimiters of the outer teX group are not part of range.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self groupRangeForRange:range beginDelimiter:'{' endDelimiter:'}'];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= groupRangeForRange:beginDelimiter:endDelimiter:
- (NSRange)groupRangeForRange:(NSRange)range beginDelimiter:(unichar)bgroup endDelimiter:(unichar)egroup;
/*"Returns the range of the smallest group in TeX sense, containing range. If index is out of the string range, the classical not found range is returned. If no group is found, returns a 1 length range at location index. Otherwise, the first character in the range is '{' and the last one is '}'. It is implemented TeX friendly.
The delimiters of the outer teX group are not part of range.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // first we balance the delimiters
    typedef unichar (* CharacterAtIndexIMP) (id, SEL, unsigned);
    CharacterAtIndexIMP CAI = (CharacterAtIndexIMP) [self methodForSelector:@selector(characterAtIndex:)];
    #define PreviousCharacter CAI(self, @selector(characterAtIndex:), left)
    #undef NextCharacter
    #define NextCharacter CAI(self, @selector(characterAtIndex:), right)
    
    int left = range.location;
    int right = range.location;
    int top = [self length];
    int max = NSMaxRange(range);
    BOOL escaped;
    int groupLevel;
    kahuei:
    groupLevel = 1;
    while(left-->0)
    {
        unichar uchar = PreviousCharacter;
        if(uchar==egroup)
        {
            if(left==0)
                return NSMakeRange(NSNotFound, 0);
            unsigned previous = left-1;
            if([self isControlAtIndex:previous escaped:&escaped])
            {
                if(escaped)
                {
                    left -= 2;
                    ++groupLevel;                        
                }
                else
                    left = previous;
            }
            else
                ++groupLevel;                        
        }
        else if (uchar==bgroup)
        {
            if(!left||![self isControlAtIndex:left-1 escaped:&escaped]||escaped)
                --groupLevel;                        
            if(groupLevel==0)
            {
                // now expanding to the right
                groupLevel = 1;
                BOOL escaped = NO;
                while (right < top)
                {
                    if(escaped)
                        escaped = NO;
                    else
                    {
                        uchar = NextCharacter;
                        if(uchar==[NSString backslashCharacter])
                            escaped = YES;
                        else if (uchar==bgroup)
                            ++groupLevel;
                        else if (uchar==egroup)
                        {
                            --groupLevel;
                            if (groupLevel==0)
                            {
                                if(right>=max)
                                    return NSMakeRange(left, right-left+1);
                                // we must find an outer group
                                goto kahuei;
                            }
                        }
                    }
                    ++right;
                }
            }
        }
    }
    return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByStrippingTeXTagsInString:
+ (NSString *)stringByStrippingTeXTagsInString:(NSString *)string;
/*"Description forthcoming. No TeX comment is managed. This method is intended for a one line tex source with no comment.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"********  I have to wash:%@", string);
	// first stripe out the % comments
	NSString * S = [NSString commentString];
	NSArray * components = [string componentsSeparatedByString:S];
	NSEnumerator * E = [components objectEnumerator];
	NSMutableArray * MRA = [NSMutableArray array];
	while(string = [E nextObject])
	{
		unsigned length = [string length];
		if(length>0)
		{
			BOOL escaped;
			if([string isControlAtIndex:--length escaped:&escaped] && !escaped)
			{
				if(length>0)
				{
					S = [string substringWithRange:NSMakeRange(0, length)];
					[MRA addObject:S];
				}
			}
			else
			{
				[MRA addObject:string];
				break;
			}
		}
	}
//iTM2_LOG(@"********  Commented out:%@", MRA);
	E = [MRA objectEnumerator];
	MRA = [NSMutableArray array];
	while(string = [E nextObject])
	{
		NSMutableArray * mra = [NSMutableArray array];
		S = [NSString backslashString];
		components = [string componentsSeparatedByString:S];
		NSEnumerator * e = [components objectEnumerator];
		NSString * component;
		BOOL escaped = NO;// To deal with the \\ newline command
		while(component = [e nextObject])
		{
			if([component length])
			{
				if(escaped)
				{
					NSRange R = NSMakeRange(0, 0);
					iTM2LiteScanner * scanner = [NSScanner scannerWithString:component];
					if(([scanner scanString:@"begin" intoString:nil]
								||[scanner scanString:@"end" intoString:nil])// latex aware
						&& [scanner scanString:[NSString bgroupString] intoString:nil])
					{
						[scanner scanUpToString:[NSString egroupString] intoString:nil];
						R.location = [scanner scanLocation];
						if(R.location++<[component length]-1)
						{
							R.length = [component length]-R.location;
							// we replace all the { and } by spaces (they will not appear as is in the output
							// and they are not escaped
							S = [component substringWithRange:R];
							[mra addObject:[[S componentsSeparatedByStrings:
								[NSString bgroupString], [NSString egroupString], nil]
									componentsJoinedByString:@" "]];
						}
					}
					else
					{
						R = [component doubleClickAtIndex:0];
						if(R.length > 1)
						{
							// The beginning of this component is a 2 chars csname
							R.location = NSMaxRange(R);
							if(R.location<[component length])
							{
								R.length = [component length]-R.location;
								// we replace all the { and } by spaces (they will not appear as is in the output
								// and they are not escaped
								S = [component substringWithRange:R];
								[mra addObject:[[S componentsSeparatedByStrings:
									[NSString bgroupString], [NSString egroupString], nil]
										componentsJoinedByString:@" "]];
							}
						}
					}
				}
				else
				{
					[mra addObject:[[component componentsSeparatedByStrings:
						[NSString bgroupString], [NSString egroupString], nil]
							componentsJoinedByString:@" "]];
				}
				escaped = NO;
			}
			else
			{
				// there is a void string
				escaped = !escaped;
			}
		}
		// then we replace multiple space chars by only one
		e = [[[[[mra componentsJoinedByString:@" "] componentsSeparatedByString:@"~"]
			componentsJoinedByString:@" "] componentsSeparatedByString:@" "] objectEnumerator];
		mra = [NSMutableArray array];
		while(component = [e nextObject])
			if([component length])
				[mra addObject:component];
		[MRA addObject:[mra componentsJoinedByString:@" "]];
	}
//iTM2_END;
//iTM2_LOG(@"********  the cleaned result is:%@ (from %@)", [MRA componentsJoinedByString:@"%"], MRA);
	return [MRA componentsJoinedByString:@"%"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _iTM2_getWordBefore:here:after:atIndex:
- (unsigned int)_iTM2_getWordBefore:(NSString **)beforePtr here:(NSString **)herePtr after:(NSString **)afterPtr atIndex:(unsigned int)hitIndex;
/*"Description forthcoming. No TeX comment is managed. This method is intended for a one line tex source with no comment.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// we work on a portion of text surrounding the char index where the hit occurred
	// first we make a hit correction because the character might be part of a TeX comment
	// then we make another hit correction because the character might be part of a control sequence
	// all the control sequences are considered to be "transparent" and silently removed
	// of course this is not true because for example \begin end \end should gobble the following argument
	// and \arrow is a real character...
	if(beforePtr) * beforePtr = nil;
	if(herePtr) * herePtr = nil;
	if(afterPtr) * afterPtr = nil;
	unsigned int TeXCommentIndex, start, end, contentsEnd;
	unsigned afterAnchor = 0;// the after word is expected after this anchor
	BOOL inControl = NO,alreadyControl = NO,alreadyComment = NO;
startAgain:
	[self getLineStart:&start end:&end contentsEnd:&contentsEnd TeXComment:&TeXCommentIndex forIndex:hitIndex];
	if(TeXCommentIndex != NSNotFound)
	{
		// there is a % comment in this line
		if(hitIndex>=TeXCommentIndex)
		{
			if(!alreadyComment)
			{
				alreadyComment = YES;
				alreadyControl = YES;
			}
			if(!afterAnchor)
				afterAnchor = end;
			// we hit a % commented character:no hope to find it in the output
			if(TeXCommentIndex > start)
			{
				// There exists uncommented characters
				hitIndex = TeXCommentIndex-1;
			}
			else if(hitIndex >= [self length])
			{
				// No chance to do anything:the source is just one TeX comment or command!!!
				return 0;
			}
			else//if(TeXCommentIndex <= start) &&...
			{
				hitIndex = start;// the first character of the line
				if(hitIndex--)
					goto startAgain;
				else
					// no chance to find a word
					return 0;
			}
		}
	}
point1:;
	NSRange hereRange = [self rangeOfWordAtIndex:hitIndex];
	if(hereRange.length)
	{
		if(hereRange.location)
		{
			BOOL escaped = NO;
			if([self isControlAtIndex:hereRange.location-1 escaped:&escaped] && !escaped)
			{
				// this is a control sequence
				if(!alreadyControl)
				{
					inControl = YES;
					alreadyControl = YES;
				}
				if(hereRange.location>start+2)
				{
					hitIndex = hereRange.location-2;
					goto point1;
				}
				else if(start)
				{
					hitIndex = --start;
					goto startAgain;
				}
				else
					return 0;
			}
		}
	}
	else if(hitIndex)
	{
		--hitIndex;
		goto point1;
	}
	// now hitIndex does not point to any part of a control sequence nor a % comment
	// after is correctly set to the words after here 
	// what is before? (also as a list of words with no tex tags)
	// start no longer means the beginning of a line...
	NSRange R;
	[self getLineStart:&R.location end:nil contentsEnd:nil forRange:hereRange];
	NSString * before = [NSString stringByStrippingTeXTagsInString:
				[self substringWithRange:NSMakeRange(R.location, hereRange.location-R.location)]];
	unsigned int limit = 50;
	while([before length] < limit && R.location)
	{
		--R.location;
		R.length = 0;
		[self getLineStart:&R.location end:nil contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			before = [[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]
				stringByAppendingFormat:@" %@", before];
	}
	if(!afterAnchor)
		afterAnchor = NSMaxRange(hereRange);
	R.location = afterAnchor;
	R.length = 0;
	[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
	NSString * after = [NSString stringByStrippingTeXTagsInString:
				[self substringWithRange:NSMakeRange(afterAnchor, contentsEnd-afterAnchor)]];
mamita:
	if([after length] < limit && (end < [self length]))
	{
		R.location = end;
		R.length = 0;
		[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			after = [after stringByAppendingFormat:@" %@",
				[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]];
		if(contentsEnd < end)
			goto mamita;
	}
	NSString * afterWord = nil;
	if([after length] > 1)
	{
		unsigned int index = 1;
		NSString * afterWord0 = nil;// default value
		NSString * afterWord1 = nil;// first candidate
		NSString * afterWord2 = nil;// second candidate, the chosen one will be the longest
nextAfterWord:
		R = [after rangeOfWordAtIndex:index];
		if(R.length>1)
		{
			if(afterWord1)
			{
				afterWord2 = [after substringWithRange:R];
			}
			else
			{
				afterWord1 = [after substringWithRange:R];
				index = NSMaxRange(R) + 1;
				if(index < [after length])
					goto nextAfterWord;
			}
		}
		else
		{
			if(!afterWord0 && R.length)
				afterWord0 = [after substringWithRange:R];
			index = NSMaxRange(R) + 1;
			if(index < [after length])
				goto nextAfterWord;
		}
		if([afterWord0 length] > 2)
			afterWord = afterWord0;
		else if([afterWord1 length] > 2)
			afterWord = afterWord1;
		else if([afterWord2 length] > 2)
			afterWord = afterWord2;
		else
			afterWord = afterWord0;
	}
	NSString * beforeWord = nil;
	if([before length] > 1)
	{
		R = NSMakeRange([before length], 0);
		NSString * beforeWord0 = nil;
		NSString * beforeWord1 = nil;
		NSString * beforeWord2 = nil;
nextBeforeWord:
		R = [before rangeOfWordAtIndex:R.location-1];
		if(R.length>1)
		{
			if(beforeWord1)
			{
				beforeWord2 = [before substringWithRange:R];
			}
			else
			{
				beforeWord1 = [before substringWithRange:R];
				if(R.location>0)
					goto nextBeforeWord;
			}
		}
		else
		{
			if(!beforeWord0 && R.length)
				beforeWord0 = [before substringWithRange:R];
			if(R.location>0)
				goto nextBeforeWord;
		}
		if([beforeWord0 length] > 2)
			beforeWord = beforeWord0;
		else if([beforeWord1 length] > 2)
			beforeWord = beforeWord1;
		else if([beforeWord2 length] > 2)
			beforeWord = beforeWord2;
		else
			beforeWord = beforeWord0;
	}
	if(beforePtr) * beforePtr = beforeWord;
	if(herePtr)	  * herePtr   = [self substringWithRange:hereRange];
	if(afterPtr)  * afterPtr  = afterWord;
//iTM2_END;
	return inControl?NSNotFound:hitIndex-hereRange.location;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_getWordBefore:here:after:atIndex:mode:
- (unsigned int)iTM2_getWordBefore:(NSString **)beforePtr here:(NSString **)herePtr after:(NSString **)afterPtr atIndex:(unsigned int)hitIndex mode:(BOOL)isSyncTeX;
/*"Description forthcoming. No TeX comment is managed. This method is intended for a one line tex source with no comment.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(isSyncTeX)
	{
		;//return [self _iTM2_getWordBefore:beforePtr here:herePtr after:afterPtr atIndex:hitIndex];
	}
//iTM2_START;
	// we work on a portion of text surrounding the char index where the hit occurred
	// first we make a hit correction because the character might be part of a TeX comment
	// then we make another hit correction because the character might be part of a control sequence
	// all the control sequences are considered to be "transparent" and silently removed
	// of course this is not true because for example \begin end \end should gobble the following argument
	// and \arrow is a real character...
	if(beforePtr) * beforePtr = nil;
	if(herePtr) * herePtr = nil;
	if(afterPtr) * afterPtr = nil;
	unsigned int TeXCommentIndex, start, end, contentsEnd;
	unsigned afterAnchor = 0;// the after word is expected after this anchor
	BOOL inControl = NO,alreadyControl = NO,alreadyComment = NO;
startAgain:
	[self getLineStart:&start end:&end contentsEnd:&contentsEnd TeXComment:&TeXCommentIndex forIndex:hitIndex];
	if(TeXCommentIndex != NSNotFound)
	{
		// there is a % comment in this line
		if(hitIndex>=TeXCommentIndex)
		{
			if(!alreadyComment)
			{
				alreadyComment = YES;
				alreadyControl = YES;
			}
			if(!afterAnchor)
				afterAnchor = end;
			// we hit a % commented character:no hope to find it in the output
			if(TeXCommentIndex > start)
			{
				// There exists uncommented characters
				hitIndex = TeXCommentIndex-1;
			}
			else if(hitIndex >= [self length])
			{
				// No chance to do anything:the source is just one TeX comment or command!!!
				return 0;
			}
			else//if(TeXCommentIndex <= start) &&...
			{
				hitIndex = start;// the first character of the line
				if(hitIndex--)
					goto startAgain;
				else
					// no chance to find a word
					return 0;
			}
		}
	}
point1:;
	NSRange hereRange = [self rangeOfWordAtIndex:hitIndex];
	if(!hereRange.length)
	{
		hereRange = [self rangeOfComposedCharacterSequenceAtIndex:hitIndex];
		if(hereRange.length == 1)
		{
			if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:hitIndex]]
					&& (hitIndex>0))
			{
				return [self iTM2_getWordBefore:beforePtr here:herePtr after:afterPtr atIndex:hitIndex-1 mode:isSyncTeX];
			}
		}
		if(!hereRange.length)
		{
			if(hitIndex)
			{
				--hitIndex;
				goto point1;
			}
			return NSNotFound;
		}
	}
	if(hereRange.location)
	{
		BOOL escaped = NO;
		if([self isControlAtIndex:hereRange.location-1 escaped:&escaped] && !escaped)
		{
			// this is a control sequence
			if(!alreadyControl)
			{
				inControl = YES;
				alreadyControl = YES;
			}
			if(hereRange.location>start+2)
			{
				hitIndex = hereRange.location-2;
				goto point1;
			}
			else if(start)
			{
				hitIndex = --start;
				goto startAgain;
			}
			else
				return 0;
		}
	}
	// now hitIndex does not point to any part of a control sequence nor a % comment
	// after is correctly set to the words after here 
	// what is before? (also as a list of words with no tex tags)
	// start no longer means the beginning of a line...
	NSRange R;
	[self getLineStart:&R.location end:nil contentsEnd:nil forRange:hereRange];
	NSString * before = [NSString stringByStrippingTeXTagsInString:
				[self substringWithRange:NSMakeRange(R.location, hereRange.location-R.location)]];
	unsigned int limit = 50;
	while([before length] < limit && R.location)
	{
		--R.location;
		R.length = 0;
		[self getLineStart:&R.location end:nil contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			before = [[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]
				stringByAppendingFormat:@" %@", before];
	}
	if(!afterAnchor)
		afterAnchor = NSMaxRange(hereRange);
	R.location = afterAnchor;
	R.length = 0;
	[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
	NSString * after = [NSString stringByStrippingTeXTagsInString:
				[self substringWithRange:NSMakeRange(afterAnchor, contentsEnd-afterAnchor)]];
mamita:
	if([after length] < limit && (end < [self length]))
	{
		R.location = end;
		R.length = 0;
		[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			after = [after stringByAppendingFormat:@" %@",
				[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]];
		if(contentsEnd < end)
			goto mamita;
	}
	NSString * afterWord = nil;
	if([after length] > 1)
	{
		unsigned int index = 1;
		NSString * afterWord0 = nil;// default value
		NSString * afterWord1 = nil;// first candidate
		NSString * afterWord2 = nil;// second candidate, the chosen one was the longest
nextAfterWord:
		R = [after rangeOfWordAtIndex:index];
		if(!R.length)
		{
			R = [self rangeOfComposedCharacterSequenceAtIndex:index];
			if(R.length == 1)
			{
				index = NSMaxRange(R) + 1;
				if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:R.location]]
						&& (index < [after length]))
				{
					goto nextAfterWord;
				}
			}
		}
		if(R.length>1)
		{
			if(afterWord1)
			{
				afterWord2 = [after substringWithRange:R];
			}
			else
			{
				afterWord1 = [after substringWithRange:R];
				index = NSMaxRange(R) + 1;
				if(index < [after length])
					goto nextAfterWord;
			}
		}
		else
		{
			if(!afterWord0 && R.length)
				afterWord0 = [after substringWithRange:R];
			index = NSMaxRange(R) + 1;
			if(index < [after length])
				goto nextAfterWord;
		}
		if([afterWord2 length] > [afterWord1 length])
			afterWord = afterWord2;
		else if([afterWord1 length] > [afterWord0 length])
			afterWord = afterWord1;
		else
			afterWord = afterWord0;
	}
	NSString * beforeWord = nil;
	if([before length] > 1)
	{
		R = NSMakeRange([before length], 0);
		NSString * beforeWord0 = nil;
		NSString * beforeWord1 = nil;
		NSString * beforeWord2 = nil;
nextBeforeWord:
		R = [before rangeOfWordAtIndex:R.location-1];
		if(!R.length)
		{
			R = [self rangeOfComposedCharacterSequenceAtIndex:R.location-1];
			if(R.length == 1)
			{
				if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:R.location]]
						&& (R.location>0))
				{
					goto nextBeforeWord;
				}
			}
		}
		if(R.length>1)
		{
			if(beforeWord1)
			{
				beforeWord2 = [before substringWithRange:R];
			}
			else
			{
				beforeWord1 = [before substringWithRange:R];
				if(R.location>0)
					goto nextBeforeWord;
			}
		}
		else
		{
			if(!beforeWord0 && R.length)
				beforeWord0 = [before substringWithRange:R];
			if(R.location>0)
				goto nextBeforeWord;
		}
		if([beforeWord2 length] > [beforeWord1 length])
			beforeWord = beforeWord2;
		else if([beforeWord1 length] > [beforeWord0 length])
			beforeWord = beforeWord1;
		else
			beforeWord = beforeWord0;
	}
	if(beforePtr) * beforePtr = beforeWord;
	if(herePtr)	  * herePtr   = [self substringWithRange:hereRange];
	if(afterPtr)  * afterPtr  = afterWord;
//iTM2_END;
	return inControl?NSNotFound:hitIndex-hereRange.location;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2XAttributedString
/*"Description forthcoming."*/
@interface iTM2TeXAttributedString_0:NSAttributedString
@end

@implementation iTM2TeXAttributedString_0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation two
Version history:jlaurens AT users.sourceforge.net
- 2.0:02/15/2006
To Do List:implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2TeXAttributedString_0 poseAsClass:[NSAttributedString class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= originalDoubleClickAtIndex:
- (NSRange)originalDoubleClickAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history:jlaurens AT users.sourceforge.net
- 2.0:02/15/2006
To Do List:implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super doubleClickAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
- (NSRange)doubleClickAtIndex:(unsigned)index;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation too
Version history:jlaurens AT users.sourceforge.net
- 2.0:02/15/2006
To Do List:implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [iTM2TeXStringController TeXAwareWordRangeInAttributedString:self atIndex:index];
//iTM2_END;
    return R;
#if 0
		NSString * pattern = @".\\{.\\}";
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
		r = NSMakeRange(R.location-4,4);
		s = [S substringWithRange:r];
		if([predicate evaluateWithObject:s])
		{
			theChar = [S characterAtIndex:R.location-4];
			if((theChar=='`')||(theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.'))// hyphen and latex accents
			{
				R.location -= 2;
				R.length += 2;
				if(R.location)
				{
					theChar = [S characterAtIndex:R.location-1];
					if([ANCS characterIsMember:theChar])
					{
						NSRange r = [super doubleClickAtIndex:R.location-1];
						R = NSUnionRange(R,r);
						goto expandToTheLeft;
					}
				}
			}
		}
#endif
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2XAttributedString
