/*
//
//  @version Subversion: $Id: iTM2MacroKit.m 490 2007-05-04 09:05:15Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

#import "iTM2Runtime.h"
#import "iTM2InstallationKit.h"
#import "iTM2StringKit.h"
#import "iTM2EventKit.h"
#import "ICURegEx.h"

#import "iTM2MacroKit_String.h"

NSString * const iTM2RegExpMKEscapeKey = @"\\";
NSString * const iTM2RegExpMKEOLKey = @"EOL";
NSString * const iTM2RegExpMKSELKey = @"SEL";
NSString * const iTM2RegExpMKTypeKey = @"TYPE";
NSString * const iTM2RegExpMKSELPlaceholderKey = @"__(SEL...)__";
NSString * const iTM2RegExpMKSELOrEOLKey = @"__(SEL...)__|EOL";
NSString * const iTM2RegExpMKPlaceholderMarkKey = @"__(|)__";
NSString * const iTM2RegExpMKStartPlaceholderMarkKey = @"__(";
NSString * const iTM2RegExpMKStopPlaceholderMarkKey = @")__";
NSString * const iTM2RegExpMKSELOrTypeKey = @"SEL|TYPE...";
NSString * const iTM2RegExpMKPlaceholderKey = @"__(SEL|TYPE...)__";
NSString * const iTM2RegExpMKPlaceholderOrEOLKey = @"__(SEL|TYPE...)__|EOL";
NSString * const iTM2RegExpMKSelectorArgumentKey = @"SEL...";
NSString * const iTM2RegExpMKEOLName = @"EOL";
NSString * const iTM2RegExpMKEndName = @"end";
NSString * const iTM2RegExpMKIndexFromEndName = @"-index";
NSString * const iTM2RegExpMKIndexName = @"index";
NSString * const iTM2RegExpMKTypeName = @"TYPE";
NSString * const iTM2RegExpMKSELName = @"SEL";
NSString * const iTM2RegExpMKDefaultName = @"Default";
NSString * const iTM2RegExpMKCommentName = @"Comment";

@implementation ICURegEx(iTM2MacroKit)
- (NSString *) macroDefaultString4iTM3;
{
    NSMutableString * MS = [[[self substringOfCaptureGroupWithName:iTM2RegExpMKDefaultName] mutableCopy] autorelease];
    ICURegEx * RE = [ICURegEx regExForKey:@"%" error:NULL];
    [MS replaceOccurrencesOfICURegEx:RE error:NULL];
    return [MS.copy autorelease];
}
- (NSString *) macroCommentString4iTM3;
{
    NSMutableString * MS = [[[self substringOfCaptureGroupWithName:iTM2RegExpMKCommentName] mutableCopy] autorelease];
    ICURegEx * RE = [ICURegEx regExForKey:@"%" error:NULL];
    [MS replaceOccurrencesOfICURegEx:RE error:NULL];
    return [MS.copy autorelease];
}
- (NSString *) macroTypeName4iTM3;
{
    NSMutableString * MS = [[[self substringOfCaptureGroupWithName:iTM2RegExpMKTypeName] mutableCopy] autorelease];
    ICURegEx * RE = [ICURegEx regExForKey:@"%" error:NULL];
    [MS replaceOccurrencesOfICURegEx:RE error:NULL];
    return [MS.copy autorelease];
}
@end

@implementation iTM2StringController(MacroKit)
- (ICURegEx *)escapeICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKEscapeKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (ICURegEx *)EOLICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKEOLKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (ICURegEx *)SELOrEOLICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKSELOrEOLKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (ICURegEx *)placeholderICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKPlaceholderKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (ICURegEx *)placeholderMarkICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKPlaceholderMarkKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (ICURegEx *)stopPlaceholderMarkICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKStopPlaceholderMarkKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (ICURegEx *)startPlaceholderMarkICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKStartPlaceholderMarkKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (ICURegEx *)placeholderOrEOLICURegEx;
{
    return [ICURegEx regExForKey:iTM2RegExpMKPlaceholderOrEOLKey inBundle:[NSBundle bundleForClass:self.class] error:NULL];
}
- (NSRange) rangeOfPlaceholderMarkAtGlobalLocation:(NSUInteger)aGlobalLocation inString:(NSString *)aString inRange:(NSRange)aRange;
{
    ICURegEx * RE = self.placeholderMarkICURegEx;
    [RE setInputString:aString range:aRange];
    while (RE.nextMatch) {
        if (NSLocationInRange(aGlobalLocation, RE.rangeOfMatch)) {
            return RE.rangeOfMatch;
        }
    }
    return iTM3MakeRange(aGlobalLocation,ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfMacroTypeAtIndex:inString:
- (NSRange)rangeOfMacroTypeAtIndex:(NSUInteger)index inString:(NSString *)aString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (index<aString.length) {// not __(SEL[end-1]:...)__
        ICURegEx * RE = [ICURegEx regExForKey:iTM2RegExpMKTypeKey error:NULL];
        [RE setInputString:aString range:iTM3MakeRange(index,aString.length-index)];
        if ([RE nextMatch]) {
            NSRange R = [RE rangeOfMatch];
            RE.forget;
            return R;
        }
	}
	return iTM3MakeRange(NSNotFound, ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderMarkAfterIndex:getType:ignoreComment:inString:
- (NSRange)rangeOfNextPlaceholderMarkAfterIndex:(NSUInteger)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore inString:(NSString *)aString;
/*"Description forthcoming. The returned range correspondes to a placeholder mark,
either '__(TYPE:? or ')__'.
If the placeholder is __(TYPE)__, TYPE belongs to the start placeholder mark
TYPE length is one word.
For the pattern ")__(", the leading ")__" is considered the valid placeholder mark. The trailing "(" has no special meaning.
the character index of the first '_' for an opening mark and the ')' for a closing mark is greater than index.
The leading character must not be escaped
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	const NSUInteger length = aString.length;
	if (index>=length)
	{
		return iTM3MakeRange(NSNotFound,ZER0);
	}
	NSRange searchRange,markRange,wordRange;
	searchRange.location = index;
	searchRange.length = length - searchRange.location;
	markRange = [aString rangeOfString:@"__" options:ZER0 range:searchRange];
	if (!markRange.length)
	{
		return iTM3MakeRange(NSNotFound,ZER0);
	}
	// There might be a problem if the "__" found belongs to a bigger ")__..."
	// for which the placeholder mark starts strictly before the found index
	if (markRange.location == searchRange.location)
	{
		if (markRange.location>1)
		{
			unichar theChar = [self standaloneCharacterAtIndex:markRange.location-2 inString:aString];
			if (theChar == ')')
			{
				theChar = [self standaloneCharacterAtIndex:markRange.location-1 inString:aString];
				if (theChar == '_')
				{
                    // this is not the right stuff, there is a ')__' combination starting at markRange.location-2
                    searchRange.location = markRange.location+1;
nextMark:
                    searchRange.length = length - searchRange.location;
                    markRange = [aString rangeOfString:@"__" options:ZER0 range:searchRange];
                    if (!markRange.length)
                    {
                        return iTM3MakeRange(NSNotFound,ZER0);
                    }
noProblemo:
                    if (markRange.location)
                    {
                        theChar = [self standaloneCharacterAtIndex:markRange.location-1 inString:aString];
                        if (theChar == ')')
                        {
                            --markRange.location;
                            ++markRange.length;
                            if (typeRef)
                            {
                                *typeRef = nil;// closing placeholder mark
                            }
                            return markRange;
                        }
                    }
nextChar:		
                    searchRange.location = iTM3MaxRange(markRange);
                    if (searchRange.location<length)
                    {
                        theChar = [self standaloneCharacterAtIndex:searchRange.location inString:aString];
                        if (theChar == '(')
                        {
                            ++markRange.length;
                            index = iTM3MaxRange(markRange);
                            NSString * type = @"";
                            if (index<length)
                            {
                                wordRange = [self rangeOfMacroTypeAtIndex:index inString:aString];
                                if (wordRange.length)
                                {
                                    type = [aString substringWithRange:wordRange];
                                    if ([self.macroTypes containsObject:type])
                                    {
                                        markRange.length += wordRange.length;
                                        index = iTM3MaxRange(markRange);
                                        if ((index<length) && ([self standaloneCharacterAtIndex:index inString:aString] != ')'))
                                        {
                                            ++markRange.length;
                                        }
                                    }
                                    else
                                    {
                                        type = @"";
                                    }
                                }
                            }
                            if (typeRef)
                            {
                                *typeRef = [type uppercaseString];// opening placeholder mark, no nil returned
                            }
                            return markRange;
                        }
                        if (theChar == '_')
                        {
                            ++markRange.location;
                            goto nextChar;
                        }
                        goto nextMark;
                    }
                    // else we reached the end of the string: no room for a supplemental '(' character
                    return iTM3MakeRange(NSNotFound,ZER0);
                }
                else if (theChar == ')')
				{
					searchRange.location = markRange.location+2;
					goto nextMark;
				}
oneCharBefore:
                theChar = [self standaloneCharacterAtIndex:markRange.location-1 inString:aString];
				if (theChar == ')')
				{
					searchRange.location = markRange.location+2;
					goto nextMark;
				}
				// this is not a stop placeholder mark
				goto nextChar;
			}
		}
		if (markRange.location)
		{
			goto oneCharBefore;
		}
	}
	goto noProblemo;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderMarkBeforeIndex:getType:ignoreComment:inString:
- (NSRange)rangeOfPreviousPlaceholderMarkBeforeIndex:(NSUInteger)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore inString:(NSString *)aString;
/*"Description forthcoming. The location of the returned range is before index, when the range is not void
This will catch a marker starting before index
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// the placeholder start marker is "__(word"
	// there can be a problem if the substring "(word" contains index
	// we make too much test but it leads to simpler code
	// the only weird situation is for ')__' when ')' is exactly at index, and unescaped... but this is another story
	NSUInteger length = aString.length;
	if (length<4)
	{
		return iTM3MakeRange(NSNotFound,ZER0);
	}
	unichar theChar = 0;
	NSRange markRange;
	if (index<UINT_MAX-3 && index+3<length)
	{
		theChar = [self standaloneCharacterAtIndex:index inString:aString];
		if (theChar == ')')
		{
			theChar = [self standaloneCharacterAtIndex:index+1 inString:aString];
			if (theChar == '@')
			{
				theChar = [self standaloneCharacterAtIndex:index+2 inString:aString];
				if (theChar == '@')
				{
					theChar = [self standaloneCharacterAtIndex:index+3 inString:aString];
					if (theChar == '@')
					{
						markRange = iTM3MakeRange(index,4);
						if (typeRef)
						{
							*typeRef = nil;
						}
						return markRange;
					}
				}
			}
		}
	}
	NSString * type = nil;
	NSUInteger end,start;
	index = MIN(index,UINT_MAX-2);
	end = MIN(length-1,index+2);
previousEnd:
	theChar = [self standaloneCharacterAtIndex:end inString:aString];
	if (theChar=='@')
	{
		NSRange wordRange;
		start = end;
previousStart:
		if (start)
		{
			theChar = [self standaloneCharacterAtIndex:start-1 inString:aString];
			if (theChar=='@')
			{
				--start;
				goto previousStart;
			}
			else if (theChar==')')
			{
				if (end>start+4)
				{
					if (end+1<length)
					{
						// there is room for a start placeholder mark after the stop mark
						theChar = [self standaloneCharacterAtIndex:++end inString:aString];
						if (theChar == '(')
						{
							// this is a start placeholder delimiter
							start = end - 3;
							type = @"";
							if (++end<length)
							{
								wordRange = [self rangeOfMacroTypeAtIndex:end inString:aString];
								if (wordRange.length)
								{
									type = [aString substringWithRange:wordRange];
									if ([self.macroTypes containsObject:type])
									{
										end += wordRange.length;
										if ((end<length) && ([self standaloneCharacterAtIndex:end inString:aString] != ')'))
										{
											++end;
										}
									}
								}
							}
							if (typeRef)
							{
								*typeRef = [type uppercaseString];
							}
							markRange.location = start;
							markRange.length = end - markRange.location;
							return markRange;
						}
					}
				}
				if (end>start+1)
				{
					markRange = iTM3MakeRange(start-1,4);
					if (typeRef)
					{
						*typeRef = nil;
					}
					return markRange;
				}
				// no placeholder mark
				if (start>4)
				{
					end = start-1;
					goto previousEnd;
				}
			}
			else if (end>start+1)
			{
				if (end+1<length)
				{
					// there is room for a start placeholder mark after the stop mark
					theChar = [self standaloneCharacterAtIndex:++end inString:aString];
					if (theChar == '(')
					{
						// this is a start placeholder delimiter, there is no conflict with a start placeholder
						start = end - 3;
						type = @"";
						if (++end<length)
						{
							wordRange = [self rangeOfMacroTypeAtIndex:end inString:aString];
							if (wordRange.length)
							{
								type = [aString substringWithRange:wordRange];
								if ([self.macroTypes containsObject:type])
								{
									end += wordRange.length;
									if ((end<length) && ([self standaloneCharacterAtIndex:end inString:aString] != ')'))
									{
										++end;
									}
								}
							}
						}
						if (typeRef)
						{
							*typeRef = [type uppercaseString];
						}
						markRange.location = start;
						markRange.length = end - markRange.location;
						return markRange;
					}
					else if (start>2)
					{
						end = start;
					}
				}
			}
		}
	}
	if (end--)
	{
		goto previousEnd;
	}
//END4iTM3;
	return iTM3MakeRange(NSNotFound,ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:getType:ignoreComment:inString:
- (NSRange)rangeOfPlaceholderAtIndex:(NSUInteger)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore inString:(NSString *)aString;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/02/2007
To Do List: implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange startRange, stopRange;
	NSUInteger depth;
	NSUInteger idx = MAX(index,3)-3;
	NSString * type = nil;
	stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore inString:aString];
	if (stopRange.length)
	{
		if (type)
		{
			if (stopRange.location<=index)
			{
				// this is in fact a start mark containing index
				// we have to find a balancing stop mark to the right
				startRange = stopRange;
				depth = 1;
otherNextStop:
				idx = iTM3MaxRange(stopRange);
				stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore inString:aString];
				if (stopRange.length)
				{
					if (type)
					{
						++depth;
						goto otherNextStop;
					}
					else if (--depth)
					{
						goto otherNextStop;
					}
					else
					{
						startRange.length = iTM3MaxRange(stopRange)-startRange.location;
						if (typeRef)
						{
							*typeRef = [type uppercaseString];
						}
						return startRange;
					}
				}
				return iTM3MakeRange(NSNotFound,ZER0);
			}
			else
			{
				// this is a start to the right
				depth = 1;
otherNextStopAfter:
				idx = iTM3MaxRange(stopRange);
				stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore inString:aString];
				if (stopRange.length)
				{
					if (type)
					{
						++depth;
						goto otherNextStopAfter;
					}
					else if (--depth)
					{
						goto otherNextStopAfter;
					}
					else
					{
						// find the balancing start
previousStart:
						startRange.location = MAX(index,3)-3;
						depth = 1;
otherPreviousStart:
						startRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:startRange.location getType:&type ignoreComment:ignore inString:aString];
						if (startRange.length)
						{
							if (!type)
							{
								++depth;
								if (startRange.location)
								{
									--startRange.location;
									goto otherPreviousStart;
								}
							}
							else if (--depth)
							{
								if (startRange.location)
								{
									--startRange.location;
									goto otherPreviousStart;
								}
							}
							else
							{
								startRange.length=iTM3MaxRange(stopRange)-startRange.location;
								if (typeRef)
								{
									*typeRef = [type uppercaseString];
								}
								return startRange;
							}
						}
						// no balancing mark available
						return iTM3MakeRange(NSNotFound,ZER0);
					}
				}
				// no balancing mark available
				return iTM3MakeRange(NSNotFound,ZER0);
			}
		}
		else
		{
			goto previousStart;
		}
	}
//END4iTM3;
	return iTM3MakeRange(NSNotFound, ZER0);
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderAfterIndex:cycle:ignoreComment:inString:
- (NSRange)rangeOfNextPlaceholderAfterIndex:(NSUInteger)index cycle:(BOOL)cycle ignoreComment:(BOOL)ignore inString:(NSString *)aString;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange markRange = [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil ignoreComment:YES inString:aString];
	NSRange range;
	NSRange smallerRange;
	NSUInteger idx = ZER0;
	if (markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES inString:aString];
		if (range.length)
		{
nextRange1:
			idx = iTM3MaxRange(markRange);
			markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil ignoreComment:YES inString:aString];
			if (markRange.length)
			{
				if (iTM3MaxRange(markRange)<iTM3MaxRange(range))
				{
					smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES inString:aString];
					if (smallerRange.length)
					{
						range = smallerRange;
						goto nextRange1;
					}
				}
			}
			return range;
		}
	}
	if (cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:ZER0 getType:nil ignoreComment:YES inString:aString];
		if (markRange.length)
		{
			if (iTM3MaxRange(markRange)<=index)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES inString:aString];
				if (range.length)
				{
nextRange2:
					idx = iTM3MaxRange(markRange);
					markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil ignoreComment:YES inString:aString];
					if (markRange.length)
					{
						if (iTM3MaxRange(markRange)<iTM3MaxRange(range))
						{
							smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES inString:aString];
							if (smallerRange.length)
							{
								range = smallerRange;
								goto nextRange2;
							}
						}
					}
					return range;
				}
			}
		}
	}
	// placeholder markers only
	markRange= [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil ignoreComment:YES inString:aString];
	if (markRange.length)
	{
		return markRange;
	}
	if (cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:ZER0 getType:nil ignoreComment:YES inString:aString];
		if (markRange.length)
		{
			if (iTM3MaxRange(markRange)<=index)
			{
				return markRange;
			}
		}
	}
	// self.tabAnchor only
	if (self.tabAnchor.length)
	{
		NSUInteger length = aString.length;
		NSRange searchRange = iTM3MakeRange(index, length - index);
		range = [aString rangeOfString:self.tabAnchor options:ZER0 range:searchRange];
		if (range.length)
		{
			return range;
		}
		if (cycle)
		{
			searchRange = iTM3MakeRange(ZER0,MIN(length,index+self.tabAnchor.length-1));
			range = [aString rangeOfString:self.tabAnchor options:ZER0 range:searchRange];
			if (range.length)
			{
				return range;
			}
		}
	}
	return iTM3MakeRange(NSNotFound,ZER0);
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderAfterIndex:cycle:inString:
- (NSRange)rangeOfNextPlaceholderAfterIndex:(NSUInteger)index cycle:(BOOL)cycle inString:(NSString *)aString;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange markRange = [aString rangeOfNextPlaceholderMarkAfterIndex:index getType:nil];
	NSRange range;
	NSRange smallerRange;
	NSUInteger idx = ZER0;
	if (markRange.length)
	{
		range = [aString rangeOfPlaceholderAtIndex:markRange.location getType:nil];
		if (range.length)
		{
nextRange1:
			idx = iTM3MaxRange(markRange);
			markRange = [aString rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil];
			if (markRange.length)
			{
				if (iTM3MaxRange(markRange)<iTM3MaxRange(range))
				{
					smallerRange = [aString rangeOfPlaceholderAtIndex:markRange.location getType:nil];
					if (smallerRange.length)
					{
						range = smallerRange;
						goto nextRange1;
					}
				}
			}
			return range;
		}
	}
	if (cycle)
	{
		markRange = [aString rangeOfNextPlaceholderMarkAfterIndex:ZER0 getType:nil];
		if (markRange.length)
		{
			if (iTM3MaxRange(markRange)<=index)
			{
				range = [aString rangeOfPlaceholderAtIndex:markRange.location getType:nil];
				if (range.length)
				{
nextRange2:
					idx = iTM3MaxRange(markRange);
					markRange = [aString rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil];
					if (markRange.length)
					{
						if (iTM3MaxRange(markRange)<iTM3MaxRange(range))
						{
							smallerRange = [aString rangeOfPlaceholderAtIndex:markRange.location getType:nil];
							if (smallerRange.length)
							{
								range = smallerRange;
								goto nextRange2;
							}
						}
					}
					return range;
				}
			}
		}
	}
	// placeholder markers only
	markRange= [aString rangeOfNextPlaceholderMarkAfterIndex:index getType:nil];
	if (markRange.length)
	{
		return markRange;
	}
	if (cycle)
	{
		markRange = [aString rangeOfNextPlaceholderMarkAfterIndex:ZER0 getType:nil];
		if (markRange.length)
		{
			if (iTM3MaxRange(markRange)<=index)
			{
				return markRange;
			}
		}
	}
	// self.tabAnchor only
	if (self.tabAnchor.length)
	{
		NSUInteger length = aString.length;
		NSRange searchRange = iTM3MakeRange(index, length - index);
		range = [aString rangeOfString:self.tabAnchor options:nil range:searchRange];
		if (range.length)
		{
			return range;
		}
		if (cycle)
		{
			searchRange = iTM3MakeRange(ZER0,MIN(length,index+self.tabAnchor.length-1));
			range = [aString rangeOfString:self.tabAnchor options:nil range:searchRange];
			if (range.length)
			{
				return range;
			}
		}
	}
	return iTM3MakeRange(NSNotFound,ZER0);
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderBeforeIndex:cycle:ignoreComment:inString:
- (NSRange)rangeOfPreviousPlaceholderBeforeIndex:(NSUInteger)index cycle:(BOOL)cycle ignoreComment:(BOOL)ignore inString:(NSString *)aString;
/*"Placeholder delimiters are ')__' and '__(\word?'. 
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement NSBackwardsSearch
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range;
	NSRange markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil ignoreComment:ignore inString:aString];
	if (markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:ignore inString:aString];
		if (range.length)
		{
			return range;
		}
	}
	NSUInteger length = aString.length;
	if (cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil ignoreComment:ignore inString:aString];
		if (markRange.length)
		{
			if (index<=markRange.location)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:ignore inString:aString];
				if (range.length)
				{
					return range;
				}
			}
		}
	}
	// placeholder markers only
	markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil ignoreComment:ignore inString:aString];
	if (markRange.length)
	{
		return markRange;
	}
	if (cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil ignoreComment:ignore inString:aString];
		if (markRange.length)
		{
			if (index<=markRange.location)
			{
				return markRange;
			}
		}
	}
	// self.tabAnchor only
	if (self.tabAnchor.length)
	{
		NSRange searchRange = iTM3MakeRange(ZER0, index);
		range = [aString rangeOfString:self.tabAnchor options:NSBackwardsSearch range:searchRange];
		if (range.length)
		{
			return range;
		}
		if (cycle)
		{
			searchRange = iTM3MakeRange(index,length-index);
			range = [aString rangeOfString:self.tabAnchor options:NSBackwardsSearch range:searchRange];
			if (range.length)
			{
				return range;
			}
		}
	}
	return iTM3MakeRange(NSNotFound,ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceholderMarksInString:
- (NSString *)stringByRemovingPlaceholderMarksInString:(NSString *)aString;
/*"Just remove any placeholder mark, do not make any kind of change.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * MRA = [NSMutableArray array];
	NSRange R = iTM3MakeRange(ZER0,ZER0);
    ICURegEx * RE = self.placeholderICURegEx;
    RE.inputString = aString;
    while (RE.nextMatch) {
        if (R.length = RE.rangeOfMatch.location - R.location) {
            [MRA addObject:[aString substringWithRange:R]];
        }
        [MRA addObject:RE.macroDefaultString4iTM3];
        R.location = iTM3MaxRange(RE.rangeOfMatch);
    }
    RE.forget;
    if (R.length = aString.length - R.location) {
        [MRA addObject:[aString substringWithRange:R]];
    }
	return [MRA componentsJoinedByString:@""];
}
@end


@implementation NSAttributedString(iTM2TextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2Text_doubleClickAtIndex:
- (NSRange)SWZ_iTM2Text_doubleClickAtIndex:(NSUInteger)idx;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation two
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 02/15/2006
 To Do List: implement some kind of balance range for range
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//	[[NSApp currentEvent] clickCount] is always 2
	NSRange wordRange = [self SWZ_iTM2Text_doubleClickAtIndex:idx];
	if ([iTM2EventObserver isAlternateKeyDown]) {
		return wordRange;
	}
	if (wordRange.length==1) {
        ICURegEx * placeholder = self.stringController4iTM3.placeholderICURegEx;
        placeholder.inputString = self.string;
        if ([placeholder matchesAtIndex:idx extendToTheEnd:NO]) {
            NSRange R = placeholder.rangeOfMatch;
            placeholder.forget;
            return R;
        }
        placeholder.forget;
	}
	//END4iTM3;
	return wordRange;
}
@end

@implementation iTM2MainInstaller(MacroKit_String)
+ (void)prepareMacroKitStringCompleteInstallation4iTM3;
{
	if ([NSAttributedString swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Text_doubleClickAtIndex:) error:NULL])
	{
		MILESTONE4iTM3((@"NSAttributedString(iTM2MacroKit_String)"),(@"The cutomized doubleClickAtIndex: is not available..."));
	}
}
@end

//