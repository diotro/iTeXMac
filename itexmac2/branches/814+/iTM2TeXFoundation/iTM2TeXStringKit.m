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

#ifdef __EMBEDDED_TEST_SETUP__
    if (iTM2DebugEnabled<10000) {
        iTM2DebugEnabled = 10000;
    }
#endif

@interface NSAttributedString(PRIVATE)
- (NSRange)SWZ_iTM2_doubleClickAtIndex:(NSUInteger)index;
@end

static ICURegEx * iTM2StringController_TeX_RE = nil;

@implementation iTM2StringController(TeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfCharactersInSet:inAttributedString:atIndex:
- (NSRange)rangeOfCharactersInSet:(NSCharacterSet *)theSet inAttributedString:(NSAttributedString *)theAttributedString atIndex:(NSUInteger)index;
/*"All the letters around the index
Version history:jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2011-01-18 22:28:05 +0100
To Do List:implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange R = iTM3NotFoundRange;
	NSString * S = [theAttributedString string];
    if (S.length) {
        unichar theChar = [S characterAtIndex:index];
        if ([theSet characterIsMember:theChar]) {
            R.location = index;
            R.length = 1;
            NSRange r = iTM3NotFoundRange;
            
            NSUInteger loc = index;
left:
            if (--index) {
                theChar = [S characterAtIndex:index];
                if([theSet characterIsMember:theChar]) {
                    --R.location;
                    ++R.length;
                    goto left;
                }
            }
            loc = index;
            NSUInteger length = S.length;
right:
            if (++index<length) {
                theChar = [S characterAtIndex:index];
                if ([theSet characterIsMember:theChar]) {
                    ++R.length;
                    goto right;
                }
            }
        }
    }
//END4iTM3;
    ReachCode4iTM3(@"rangeOfCharactersInSet...");
#   ifdef __EMBEDDED_TEST__
    NSAttributedString * AS = [[NSAttributedString alloc] initWithString:@"X"];
    iTM2StringController * SC = iTM2StringController.defaultController;
    NSRange R = [SC rangeOfCharactersInSet:[NSCharacterSet letterCharacterSet] inAttributedString:AS atIndex:0];
    STAssertTrue(NSEqualRanges(R,iTM3MakeRange(0,1)),@"MISSED",NULL);
#   endif
	return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingTeXEscapeSequencesInString:
- (NSString *) stringByRemovingTeXEscapeSequencesInString:(NSString *)aString;
/*"This takes TeX commands into account, and \- hyphenation too
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSError * ROR = nil;
    ICURegEx * RE = [ICURegEx regExForKey:@"\\.→." inBundle:myBUNDLE error:&ROR];
    if (ROR) {
        LOG4iTM3(@"There is an error:%@",ROR);
        return aString;
    }
    NSMutableString * MS = [NSMutableString stringWithString:aString];
    [MS replaceOccurrencesOfICURegEx:RE error:&ROR];
    RE.forget;
    if (ROR) {
        LOG4iTM3(@"There is another error:%@",ROR);
        return aString;
    }
//END4iTM3;
	return MS;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= TeXAwareWordRangeInString:atIndex:
- (NSRange)TeXAwareWordRangeInString:(NSAttributedString *)theAttributedString atIndex:(NSUInteger)index;
/*"This takes TeX commands into account, and \- hyphenation too
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return iTM3MakeRange(NSNotFound,ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= TeXAwareWordRangeInAttributedString:atIndex:
- (NSRange)TeXAwareWordRangeInAttributedString:(NSAttributedString *)theAttributedString atIndex:(NSUInteger)index;
/*"This takes TeX commands into account, and \- hyphenation too
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * S = [theAttributedString string];
	NSString * s;
	NSUInteger length = S.length;
	unichar theChar = [S characterAtIndex:index];
    NSRange R, r;
	NSUInteger loc;
	NSUInteger commandIndex = NSNotFound;
	BOOL escaped;
	if([ANCS characterIsMember:theChar])
	{
		R = [theAttributedString SWZ_iTM2_doubleClickAtIndex:index];
expandToTheLeftAsLetters:
		if(R.location)
		{
			theChar = [S characterAtIndex:R.location-1];
			if([ANCS characterIsMember:theChar])
			{
				r = [theAttributedString SWZ_iTM2_doubleClickAtIndex:R.location-1];
				if(r.location
					&& [S isControlAtIndex:r.location-1 escaped:&escaped]
						&& !escaped)
				{
					goto expandToTheRightAsLetters;
				}
				R = iTM3UnionRange(R,r);
				goto expandToTheLeftAsLetters;
			}
			if((R.location>4)
				&& [S isControlAtIndex:R.location-5 escaped:&escaped]
					&& !escaped)
			{
				r = iTM3MakeRange(R.location-5,5);
				if(iTM3MaxRange(r)<=length)
				{
					s = [S substringWithRange:r];
					[iTM2StringController_TeX_RE setInputString:s];
					if([iTM2StringController_TeX_RE matchesAtIndex:ZER0 extendToTheEnd:YES])
					{
						R.location -= 5;
						R.length += 5;
						commandIndex = R.location;
						goto expandToTheLeftAsLetters;
					}
				}
			}
			if((R.location>1)
				&& [S isControlAtIndex:R.location-2 escaped:&escaped]
					&& !escaped
						&& ((theChar=='-')||(theChar=='_')||(theChar=='@')||(theChar=='`')||(theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.')))
			{
				R.location -= 2;
				R.length += 2;
				commandIndex = R.location;
				goto expandToTheLeftAsLetters;
			}
			if((R.location>ZER0)
				&& [S isControlAtIndex:R.location-1 escaped:&escaped]
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
				loc = iTM3MaxRange(R);
				r = [self rangeOfCharactersInSet:[NSCharacterSet letterCharacterSet] inAttributedString:theAttributedString atIndex:loc];
				if(r.length)
				{
					R = iTM3UnionRange(R,r);
				}
				return R;
			}
		}
		if(R.location>2)
		{
			// is it a 7bits accented letter?
			r = iTM3MakeRange(R.location-3,5);
			if(iTM3MaxRange(r)<=length)
			{
				s = [S substringWithRange:r];
				[iTM2StringController_TeX_RE setInputString:s];
				if([iTM2StringController_TeX_RE matchesAtIndex:ZER0 extendToTheEnd:YES])
				{
					R = r;
					return R;
				}
			}
		}
expandToTheRightAsLetters:
		// just add \_, \-, \@ and all accented chars
		loc = iTM3MaxRange(R);
		if(loc>=length)
		{
			return R;
		}
		if(loc+4<length)
		{
			r = iTM3MakeRange(loc,5);
			s = [S substringWithRange:r];
			[iTM2StringController_TeX_RE setInputString:s];
			if([iTM2StringController_TeX_RE matchesAtIndex:ZER0 extendToTheEnd:YES])
			{
				R.length += 5;
				goto expandToTheRightAsLetters;
			}
		}
		if((loc+1<length) &&
				[S isControlAtIndex:loc escaped:&escaped] &&
						!escaped)
		{
			theChar = [S characterAtIndex:loc+1];
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
		theChar = [S characterAtIndex:loc];
		if([ANCS characterIsMember:theChar])
		{
			r = [theAttributedString SWZ_iTM2_doubleClickAtIndex:loc];
			R = iTM3UnionRange(R,r);
			goto expandToTheRightAsLetters;
		}
		return R;
	}
	// this is not a letter character
	if([S isControlAtIndex:index escaped:&escaped] && !escaped)
	{
		if(index+1<length)
		{
			theChar = [S characterAtIndex:index+1];
			R = iTM3MakeRange(index,2);
			if((theChar=='`')||(theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.'))
			{
				if(index+2<length)
				{
					r = [S groupRangeAtIndex:index+2 beginDelimiter:'{' endDelimiter:'}'];
					if(r.location == index+2)
					{
						R = iTM3UnionRange(R,r);
					}
					else
					{
						theChar = [S characterAtIndex:index+2];
						if([ANCS characterIsMember:theChar])
						{
							r = [theAttributedString SWZ_iTM2_doubleClickAtIndex:index+2];
							R = iTM3UnionRange(R,r);
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
				r = iTM3MakeRange(index+1,length-index-1);
				r = [S rangeOfString:@"\\)" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = iTM3MaxRange(r);
						r.location = index;
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			else if(theChar=='[')
			{
				//select the balancing stuff
				r = iTM3MakeRange(index+1,length-index-1);
				r = [S rangeOfString:@"\\]" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = iTM3MaxRange(r);
						r.location = index;
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			else if(theChar==')')
			{
				//select the balancing stuff
				r = iTM3MakeRange(ZER0,index);
				r = [S rangeOfString:@"\\(" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = iTM3MaxRange(R);
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			else if(theChar==']')
			{
				//select the balancing stuff
				r = iTM3MakeRange(ZER0,index);
				r = [S rangeOfString:@"\\[" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = iTM3MaxRange(R);
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
				return R;
			}
			R = [theAttributedString SWZ_iTM2_doubleClickAtIndex:index+1];
			--R.location;
			++R.length;
			return R;// maybe
		}
		else
		{
			return iTM3MakeRange(index,1);
		}
	}
	if(index)
	{
		if([S isControlAtIndex:index-1 escaped:&escaped] && !escaped)
		{
			R = iTM3MakeRange(index-1,2);
			if((theChar=='`')||(theChar=='\'')||(theChar=='^')||(theChar=='"')||(theChar=='~')||(theChar=='=')||(theChar=='.'))
			{
				if(index+1<length)
				{
					r = [S groupRangeAtIndex:index+1 beginDelimiter:'{' endDelimiter:'}'];
					if(r.location == index+1)
					{
						R = iTM3UnionRange(R,r);
						goto expandToTheLeftAsLetters;
					}
					theChar = [S characterAtIndex:index+1];
					if([ANCS characterIsMember:theChar])
					{
						R = [theAttributedString SWZ_iTM2_doubleClickAtIndex:index+1];
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
				r = iTM3MakeRange(index+1,length-index-1);
				r = [S rangeOfString:@"\\)" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = iTM3MaxRange(r);
						r.location = index-1;
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
			}
			else if(theChar=='[')
			{
				//select the balancing stuff
				r = iTM3MakeRange(index+1,length-index-1);
				r = [S rangeOfString:@"\\]" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = iTM3MaxRange(r);
						r.location = index-1;
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
			}
			else if(theChar==')')
			{
				//select the balancing stuff
				r = iTM3MakeRange(ZER0,index);
				r = [S rangeOfString:@"\\(" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = index+1;
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
			}
			else if(theChar==']')
			{
				//select the balancing stuff
				r = iTM3MakeRange(ZER0,index);
				r = [S rangeOfString:@"\\[" options:ZER0 range:r];
				while(r.length)
				{
					if([S isControlAtIndex:r.location escaped:&escaped]&&!escaped)
					{
						r.length = index+1;
						r.length -= r.location;
						return r;
					}
					r.location = iTM3MaxRange(r);
					r.length = length - r.location;
				}
			}
			R = iTM3MakeRange(index-1,2);
			return R;// maybe
		}
		if(theChar == '@')
		{
			R = iTM3MakeRange(index,1);
			goto expandToTheLeftAsLetters;
		}
	}
	if(theChar == '@')
	{
		// is it a URL?
		R = iTM3MakeRange(index,1);
		goto expandToTheLeftAsLetters;
	}
	if((theChar == '{') || (theChar == '}'))
	{
		R = [S groupRangeAtIndex:index beginDelimiter:'{' endDelimiter:'}'];
		if(R.length)
		{
			return R;
		}
	}
	if((theChar == '[') || (theChar == ']'))
	{
		R = [S groupRangeAtIndex:index beginDelimiter:'[' endDelimiter:']'];
		if(R.length)
		{
			return R;
		}
	}
	if((theChar == '(') || (theChar == ')'))
	{
		R = [S groupRangeAtIndex:index beginDelimiter:'(' endDelimiter:')'];
		if(R.length)
		{
			return R;
		}
	}
	return iTM3MakeRange(index,1);
}
@end

@interface NSString(MY_OWN_PRIVACY)
- (NSRange)_nextLaTeXEnvironmentDelimiterRangeAfterIndex:(NSUInteger)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
- (NSRange)_previousLaTeXEnvironmentDelimiterRangeBeforeIndex:(NSUInteger)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
@end

@implementation NSString(iTM2TeXStringKit)

#warning this need to be rewritten with a controller
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= backslashString
+ (NSString *)backslashString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return @"\\";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= backslashCharacter
+ (unichar)backslashCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.backslashString characterAtIndex:ZER0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= commentString
+ (NSString *)commentString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return @"%";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= commentCharacter
+ (unichar)commentCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.commentString characterAtIndex:ZER0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bgroupCharacter
+ (unichar)bgroupCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.bgroupString characterAtIndex:ZER0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= egroupCharacter
+ (unichar)egroupCharacter;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.egroupString characterAtIndex:ZER0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bgroupString
+ (NSString *)bgroupString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return @"{";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= egroupString
+ (NSString *)egroupString;
/*" Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return @"}";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isControlAtIndex:escaped:
- (BOOL)isControlAtIndex:(NSUInteger)index escaped:(BOOL *)aFlagPtr;
/*" Returns YES if there is a '\' at index index. For example "\\ " is a 3 length string.
For index = ZER0, 1 and 2, the aFlagPtr* is NO, YES, NO.
If there is no backslash, aFlagPtr will point to NO, if it is not nil.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	unichar backslash = [NSString backslashCharacter];
    if(iTM3LocationInRange(index, iTM3MakeRange(ZER0, self.length)) && [self characterAtIndex:index]==backslash)
    {
        if(aFlagPtr)
        {
            NSUInteger level = ZER0;
            while(index-->ZER0)
                if([self characterAtIndex:index]==backslash)
                    ++level;
                else
                    break;
            * aFlagPtr = (level%2 > ZER0);
        }
        return YES;
    }
    else if(aFlagPtr)
        * aFlagPtr = NO;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineStart:end:contentsEnd:TeXComment:forIndex:
- (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr TeXComment:(NSUInteger *)commentPtr forIndex:(NSUInteger) index;
/*" Description Forthcoming
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(commentPtr)
    {
        NSUInteger start, contentsEnd;
//NSLog(@"GLS");
        [self getLineStart:&start end:lineEndPtr contentsEnd:&contentsEnd forRange:iTM3MakeRange(index, ZER0)];
        if(startPtr) *startPtr = start;
        if(contentsEndPtr) *contentsEndPtr = contentsEnd;
        NSRange R = [self rangeOfString:@"%" options:ZER0 range:iTM3MakeRange(start, contentsEnd-start)];
        BOOL escaped;
        if(R.length && ((R.location==start)||![self isControlAtIndex:R.location-1 escaped:&escaped]||escaped))
            *commentPtr = R.location;
        else
            *commentPtr = NSNotFound;
    }
    else
        [self getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:iTM3MakeRange(index, ZER0)];
//NSLog(@"GLS");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isTeXCommentAtIndex:
- (BOOL)isTeXCommentAtIndex:(NSUInteger)index;
/*" Description Forthcoming
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger anchor;
//NSLog(@"GLS");
    [self getLineStart:&anchor end:nil contentsEnd:nil forRange:iTM3MakeRange(index, ZER0)];
    while(anchor<index)
    {
        NSRange R = [self rangeOfString:@"%" options:ZER0 range:iTM3MakeRange(anchor, index-anchor)];
        if(R.length)
        {
            if(R.location>anchor)
            {
                BOOL escaped;
                if([self isControlAtIndex:R.location-1 escaped:&escaped] && !escaped)
                    anchor = iTM3MaxRange(R);
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
- (NSRange)groupRangeAtIndex:(NSUInteger)index;
/*"Returns the range of the smallest group in TeX sense, containing index. If index is out of the string range, the classical not found range is returned. If no group is found, returns a 1 length range at location index. Otherwise, the first character in the range is '{' and the last one is '}'. It is implemented TeX friendly.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self groupRangeAtIndex:index beginDelimiter:'{' endDelimiter:'}'];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= groupRangeAtIndex:beginDelimiter:endDelimiter:
- (NSRange)groupRangeAtIndex:(NSUInteger)index beginDelimiter:(unichar)bgroup endDelimiter:(unichar)egroup;
/*"Returns the range of the smallest group in TeX sense, containing index. If index is out of the string range, the classical not found range is returned. If no group is found, returns a 1 length range at location index. Otherwise, the first character in the range is '{' and the last one is '}'. It is implemented TeX friendly.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger scanLocation = index;
    NSInteger maxLocation = self.length;
    NSInteger groupLevel = 1;
    // speedy
    typedef unichar (* CharacterAtIndexIMP) (id, SEL, NSUInteger);
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
                        if (groupLevel==ZER0)
                            return iTM3MakeRange(index, scanLocation-index + 1);
                    }
                }
            }
        }
        else if(uchar==egroup)
        {
            while (scanLocation-- > ZER0)
            {
                uchar = NextCharacter;
                if (uchar==egroup)
                {
                    if(!scanLocation)
                        return iTM3MakeRange(NSNotFound, ZER0);
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
                    if (groupLevel==ZER0)
                        return (scanLocation < index)?
                            iTM3MakeRange(scanLocation, index-scanLocation + 1):
                                iTM3MakeRange(NSNotFound, ZER0);
                }
            }
        }
        else
        {
            return [self groupRangeForRange:iTM3MakeRange(index, ZER0) beginDelimiter:bgroup endDelimiter:egroup];
        }
    }
    return  iTM3MakeRange(NSNotFound, ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= groupRangeForRange:
- (NSRange)groupRangeForRange:(NSRange)range;
/*"Returns the range of the smallest group in TeX sense, containing range. If index is out of the string range, the classical not found range is returned. If no group is found, returns a 1 length range at location index. Otherwise, the first character in the range is '{' and the last one is '}'. It is implemented TeX friendly.
The delimiters of the outer teX group are not part of range.
Version history:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // first we balance the delimiters
    typedef unichar (* CharacterAtIndexIMP) (id, SEL, NSUInteger);
    CharacterAtIndexIMP CAI = (CharacterAtIndexIMP) [self methodForSelector:@selector(characterAtIndex:)];
    #define PreviousCharacter CAI(self, @selector(characterAtIndex:), left)
    #undef NextCharacter
    #define NextCharacter CAI(self, @selector(characterAtIndex:), right)
    
    NSUInteger left = range.location;
    NSUInteger right = range.location;
    NSUInteger top = self.length;
    NSUInteger max = iTM3MaxRange(range);
    BOOL escaped;
    NSInteger groupLevel;
    kahuei:
    groupLevel = 1;
    while(left-->ZER0)
    {
        unichar uchar = PreviousCharacter;
        if(uchar==egroup)
        {
            if(left==ZER0)
                return iTM3MakeRange(NSNotFound, ZER0);
            NSUInteger previous = left-1;
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
            if(groupLevel==ZER0)
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
                            if (groupLevel==ZER0)
                            {
                                if(right>=max)
                                    return iTM3MakeRange(left, right-left+1);
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
    return iTM3MakeRange(NSNotFound, ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByStrippingTeXTagsInString:
+ (NSString *)stringByStrippingTeXTagsInString:(NSString *)string;
/*"Description forthcoming. No TeX comment is managed. This method is intended for a one line tex source with no comment.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"********  I have to wash:%@", string);
	// first stripe out the % comments
	NSString * S = [NSString commentString];
	NSArray * components = [string componentsSeparatedByString:S];
	NSMutableArray * MRA = [NSMutableArray array];
	for(string in components)
	{
		NSUInteger length = string.length;
		if(length>ZER0)
		{
			BOOL escaped;
			if([string isControlAtIndex:--length escaped:&escaped] && !escaped)
			{
				if(length>ZER0)
				{
					S = [string substringWithRange:iTM3MakeRange(ZER0, length)];
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
//LOG4iTM3(@"********  Commented out:%@", MRA);
	NSEnumerator * E = MRA.objectEnumerator;
	MRA = [NSMutableArray array];
	while(string = E.nextObject)
	{
		NSMutableArray * mra = [NSMutableArray array];
		S = [NSString backslashString];
		components = [string componentsSeparatedByString:S];
		NSString * component;
		BOOL escaped = NO;// To deal with the \\ newline command
		for(component in components)
		{
			if(component.length)
			{
				if(escaped)
				{
					NSRange R = iTM3MakeRange(ZER0, ZER0);
					iTM2LiteScanner * scanner = [iTM2LiteScanner scannerWithString:component charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
					if(([scanner scanString:@"begin" intoString:nil]
								||[scanner scanString:@"end" intoString:nil])// latex aware
						&& [scanner scanString:[NSString bgroupString] intoString:nil])
					{
						[scanner scanUpToString:[NSString egroupString] intoString:nil];
						R.location = [scanner scanLocation];
						if(R.location++<component.length-1)
						{
							R.length = component.length-R.location;
							// we replace all the { and } by spaces (they will not appear as is in the output
							// and they are not escaped
							S = [component substringWithRange:R];
							[mra addObject:[[S componentsSeparatedByStrings4iTM3:
								[NSString bgroupString], [NSString egroupString], nil]
									componentsJoinedByString:@" "]];
						}
					}
					else
					{
						R = [component doubleClickAtIndex:ZER0];
						if(R.length > 1)
						{
							// The beginning of this component is a 2 chars csname
							R.location = iTM3MaxRange(R);
							if(R.location<component.length)
							{
								R.length = component.length-R.location;
								// we replace all the { and } by spaces (they will not appear as is in the output
								// and they are not escaped
								S = [component substringWithRange:R];
								[mra addObject:[[S componentsSeparatedByStrings4iTM3:
									[NSString bgroupString], [NSString egroupString], nil]
										componentsJoinedByString:@" "]];
							}
						}
					}
				}
				else
				{
					[mra addObject:[[component componentsSeparatedByStrings4iTM3:
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
		mra = [NSMutableArray array];
		for(component in [[[[mra componentsJoinedByString:@" "] componentsSeparatedByString:@"~"]
			componentsJoinedByString:@" "] componentsSeparatedByString:@" "])
			if(component.length)
				[mra addObject:component];
		[MRA addObject:[mra componentsJoinedByString:@" "]];
	}
//END4iTM3;
//LOG4iTM3(@"********  the cleaned result is:%@ (from %@)", [MRA componentsJoinedByString:@"%"], MRA);
	return [MRA componentsJoinedByString:@"%"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _iTM2_getWordBefore:here:after:atIndex:
- (NSUInteger)_iTM2_getWordBefore:(NSString **)beforePtr here:(NSString **)herePtr after:(NSString **)afterPtr atIndex:(NSUInteger)hitIndex;
/*"Description forthcoming. No TeX comment is managed. This method is intended for a one line tex source with no comment.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// we work on a portion of text surrounding the char index where the hit occurred
	// first we make a hit correction because the character might be part of a TeX comment
	// then we make another hit correction because the character might be part of a control sequence
	// all the control sequences are considered to be "transparent" and silently removed
	// of course this is not true because for example \begin end \end should gobble the following argument
	// and \arrow is a real character...
	if(beforePtr) * beforePtr = nil;
	if(herePtr) * herePtr = nil;
	if(afterPtr) * afterPtr = nil;
	NSUInteger TeXCommentIndex, start, end, contentsEnd;
	NSUInteger afterAnchor = ZER0;// the after word is expected after this anchor
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
			else if(hitIndex >= self.length)
			{
				// No chance to do anything:the source is just one TeX comment or command!!!
				return ZER0;
			}
			else//if(TeXCommentIndex <= start) &&...
			{
				hitIndex = start;// the first character of the line
				if(hitIndex--)
					goto startAgain;
				else
					// no chance to find a word
					return ZER0;
			}
		}
	}
point1:;
	NSRange hereRange = [self rangeOfWordAtIndex4iTM3:hitIndex];
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
					return ZER0;
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
				[self substringWithRange:iTM3MakeRange(R.location, hereRange.location-R.location)]];
	NSUInteger limit = 50;
	while(before.length < limit && R.location)
	{
		--R.location;
		R.length = ZER0;
		[self getLineStart:&R.location end:nil contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			before = [[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]
				stringByAppendingFormat:@" %@", before];
	}
	if(!afterAnchor)
		afterAnchor = iTM3MaxRange(hereRange);
	R.location = afterAnchor;
	R.length = ZER0;
	[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
	NSString * after = [NSString stringByStrippingTeXTagsInString:
				[self substringWithRange:iTM3MakeRange(afterAnchor, contentsEnd-afterAnchor)]];
mamita:
	if(after.length < limit && (end < self.length))
	{
		R.location = end;
		R.length = ZER0;
		[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			after = [after stringByAppendingFormat:@" %@",
				[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]];
		if(contentsEnd < end)
			goto mamita;
	}
	NSString * afterWord = nil;
	if(after.length > 1)
	{
		NSUInteger index = 1;
		NSString * afterWord0 = nil;// default value
		NSString * afterWord1 = nil;// first candidate
		NSString * afterWord2 = nil;// second candidate, the chosen one will be the longest
nextAfterWord:
		R = [after rangeOfWordAtIndex4iTM3:index];
		if(R.length>1)
		{
			if(afterWord1)
			{
				afterWord2 = [after substringWithRange:R];
			}
			else
			{
				afterWord1 = [after substringWithRange:R];
				index = iTM3MaxRange(R) + 1;
				if(index < after.length)
					goto nextAfterWord;
			}
		}
		else
		{
			if(!afterWord0 && R.length)
				afterWord0 = [after substringWithRange:R];
			index = iTM3MaxRange(R) + 1;
			if(index < after.length)
				goto nextAfterWord;
		}
		if(afterWord0.length > 2)
			afterWord = afterWord0;
		else if(afterWord1.length > 2)
			afterWord = afterWord1;
		else if(afterWord2.length > 2)
			afterWord = afterWord2;
		else
			afterWord = afterWord0;
	}
	NSString * beforeWord = nil;
	if(before.length > 1)
	{
		R = iTM3MakeRange(before.length, ZER0);
		NSString * beforeWord0 = nil;
		NSString * beforeWord1 = nil;
		NSString * beforeWord2 = nil;
nextBeforeWord:
		R = [before rangeOfWordAtIndex4iTM3:R.location-1];
		if(R.length>1)
		{
			if(beforeWord1)
			{
				beforeWord2 = [before substringWithRange:R];
			}
			else
			{
				beforeWord1 = [before substringWithRange:R];
				if(R.location>ZER0)
					goto nextBeforeWord;
			}
		}
		else
		{
			if(!beforeWord0 && R.length)
				beforeWord0 = [before substringWithRange:R];
			if(R.location>ZER0)
				goto nextBeforeWord;
		}
		if(beforeWord0.length > 2)
			beforeWord = beforeWord0;
		else if(beforeWord1.length > 2)
			beforeWord = beforeWord1;
		else if(beforeWord2.length > 2)
			beforeWord = beforeWord2;
		else
			beforeWord = beforeWord0;
	}
	if(beforePtr) * beforePtr = beforeWord;
	if(herePtr)	  * herePtr   = [self substringWithRange:hereRange];
	if(afterPtr)  * afterPtr  = afterWord;
//END4iTM3;
	return inControl?NSNotFound:hitIndex-hereRange.location;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getWordBefore4iTM3:here:after:atIndex:mode:
- (NSUInteger)getWordBefore4iTM3:(NSString **)beforePtr here:(NSString **)herePtr after:(NSString **)afterPtr atIndex:(NSUInteger)hitIndex mode:(BOOL)isSyncTeX;
/*"Description forthcoming. No TeX comment is managed. This method is intended for a one line tex source with no comment.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	if(isSyncTeX)
	{
		;//return [self _iTM2_getWordBefore:beforePtr here:herePtr after:afterPtr atIndex:hitIndex];
	}
//START4iTM3;
	// we work on a portion of text surrounding the char index where the hit occurred
	// first we make a hit correction because the character might be part of a TeX comment
	// then we make another hit correction because the character might be part of a control sequence
	// all the control sequences are considered to be "transparent" and silently removed
	// of course this is not true because for example \begin end \end should gobble the following argument
	// and \arrow is a real character...
	if(beforePtr) * beforePtr = nil;
	if(herePtr) * herePtr = nil;
	if(afterPtr) * afterPtr = nil;
	NSUInteger TeXCommentIndex, start, end, contentsEnd;
	NSUInteger afterAnchor = ZER0;// the after word is expected after this anchor
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
			else if(hitIndex >= self.length)
			{
				// No chance to do anything:the source is just one TeX comment or command!!!
				return ZER0;
			}
			else//if(TeXCommentIndex <= start) &&...
			{
				hitIndex = start;// the first character of the line
				if(hitIndex--)
					goto startAgain;
				else
					// no chance to find a word
					return ZER0;
			}
		}
	}
point1:;
	NSRange hereRange = [self rangeOfWordAtIndex4iTM3:hitIndex];
	if(!hereRange.length)
	{
		hereRange = [self rangeOfComposedCharacterSequenceAtIndex:hitIndex];
		if(hereRange.length == 1)
		{
			if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:hitIndex]]
					&& (hitIndex>ZER0))
			{
				return [self getWordBefore4iTM3:beforePtr here:herePtr after:afterPtr atIndex:hitIndex-1 mode:isSyncTeX];
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
				return ZER0;
		}
	}
	// now hitIndex does not point to any part of a control sequence nor a % comment
	// after is correctly set to the words after here 
	// what is before? (also as a list of words with no tex tags)
	// start no longer means the beginning of a line...
	NSRange R;
	[self getLineStart:&R.location end:nil contentsEnd:nil forRange:hereRange];
	NSString * before = [NSString stringByStrippingTeXTagsInString:
				[self substringWithRange:iTM3MakeRange(R.location, hereRange.location-R.location)]];
	NSUInteger limit = 50;
	while(before.length < limit && R.location)
	{
		--R.location;
		R.length = ZER0;
		[self getLineStart:&R.location end:nil contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			before = [[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]
				stringByAppendingFormat:@" %@", before];
	}
	if(!afterAnchor)
		afterAnchor = iTM3MaxRange(hereRange);
	R.location = afterAnchor;
	R.length = ZER0;
	[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
	NSString * after = [NSString stringByStrippingTeXTagsInString:
				[self substringWithRange:iTM3MakeRange(afterAnchor, contentsEnd-afterAnchor)]];
mamita:
	if(after.length < limit && (end < self.length))
	{
		R.location = end;
		R.length = ZER0;
		[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		if(R.length = contentsEnd-R.location)
			after = [after stringByAppendingFormat:@" %@",
				[NSString stringByStrippingTeXTagsInString:[self substringWithRange:R]]];
		if(contentsEnd < end)
			goto mamita;
	}
	NSString * afterWord = nil;
	if(after.length > 1)
	{
		NSUInteger index = 1;
		NSString * afterWord0 = nil;// default value
		NSString * afterWord1 = nil;// first candidate
		NSString * afterWord2 = nil;// second candidate, the chosen one was the longest
nextAfterWord:
		R = [after rangeOfWordAtIndex4iTM3:index];
		if(!R.length)
		{
			R = [self rangeOfComposedCharacterSequenceAtIndex:index];
			if(R.length == 1)
			{
				index = iTM3MaxRange(R) + 1;
				if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:R.location]]
						&& (index < after.length))
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
				index = iTM3MaxRange(R) + 1;
				if(index < after.length)
					goto nextAfterWord;
			}
		}
		else
		{
			if(!afterWord0 && R.length)
				afterWord0 = [after substringWithRange:R];
			index = iTM3MaxRange(R) + 1;
			if(index < after.length)
				goto nextAfterWord;
		}
		if(afterWord2.length > afterWord1.length)
			afterWord = afterWord2;
		else if(afterWord1.length > afterWord0.length)
			afterWord = afterWord1;
		else
			afterWord = afterWord0;
	}
	NSString * beforeWord = nil;
	if(before.length > 1)
	{
		R = iTM3MakeRange(before.length, ZER0);
		NSString * beforeWord0 = nil;
		NSString * beforeWord1 = nil;
		NSString * beforeWord2 = nil;
nextBeforeWord:
		R = [before rangeOfWordAtIndex4iTM3:R.location-1];
		if(!R.length)
		{
            if (R.location) {
                R = [self rangeOfComposedCharacterSequenceAtIndex:R.location-1];
                if(R.length == 1)
                {
                    if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[self characterAtIndex:R.location]]
                            && (R.location>ZER0))
                    {
                        goto nextBeforeWord;
                    }
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
				if(R.location>ZER0)
					goto nextBeforeWord;
			}
		}
		else
		{
			if(!beforeWord0 && R.length)
				beforeWord0 = [before substringWithRange:R];
			if(R.location>ZER0)
				goto nextBeforeWord;
		}
		if(beforeWord2.length > beforeWord1.length)
			beforeWord = beforeWord2;
		else if(beforeWord1.length > beforeWord0.length)
			beforeWord = beforeWord1;
		else
			beforeWord = beforeWord0;
	}
	if(beforePtr) * beforePtr = beforeWord;
	if(herePtr)	  * herePtr   = [self substringWithRange:hereRange];
	if(afterPtr)  * afterPtr  = afterWord;
//END4iTM3;
	return inControl?NSNotFound:hitIndex-hereRange.location;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2XAttributedString
/*"Description forthcoming."*/

@implementation iTM2MainInstaller(TeXStringKit)
+ (void)prepareTeXStringKitCompleteInstallation4iTM3;
{
	if ([NSAttributedString swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_doubleClickAtIndex:) error:NULL]) {
		MILESTONE4iTM3((@"NSAttributedString(TeX4iTM3)"),(@"The doubleClickAtIndex: is not patched to take TeX commands intou account."));
	}
	if(!iTM2StringController_TeX_RE) {
		NSError * ROR = nil;
//		iTM2StringController_TeX_RE = [[ICURegEx alloc] initWithSearchPattern:@"(?!\\(?:\\{2})*)\\[`'\\^\"~=.]\\{.\\}" options:nil error:&ROR];
		iTM2StringController_TeX_RE = [[ICURegEx alloc] initWithSearchPattern:@"\\\\[`'\\^\"~=.]\\{.\\}" options:ZER0 error:&ROR];
		if (!iTM2StringController_TeX_RE) {
			LOG4iTM3(@"RE unavailable");
			if (ROR) {
				LOG4iTM3(@"ROR:%@",ROR);
            } else {
				LOG4iTM3(@"ROR unavailable");
			}
		}
	}
}
@end

@implementation NSAttributedString(TeX4iTM3)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2_doubleClickAtIndex:
- (NSRange)SWZ_iTM2_doubleClickAtIndex:(NSUInteger)index;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation too
Version history:jlaurens AT users.sourceforge.net
- 2.0:02/15/2006
To Do List:implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange R = [self.stringController4iTM3 TeXAwareWordRangeInAttributedString:self atIndex:index];
//END4iTM3;
    return R;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2XAttributedString
