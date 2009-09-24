/*
//
//  @version Subversion: $Id: iTM2MacroKit.m 490 2007-05-04 09:05:15Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright ¬© 2006 Laurens'Tribune. All rights reserved.
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

#import "iTM2MacroKit_String.h"

static NSArray * _iTM2MacroTypes = nil;

@implementation NSString(iTM2MacroKit_String)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bullet
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(!_iTM2MacroTypes)
	{
		_iTM2MacroTypes = [[NSArray arrayWithObjects:
			@"ACTION",@"PATH",@"COMMAND",@"COPY",@"MATH",// documented???
			@"INPUT_PATH",@"INPUT_ALL",@"INPUT_SELECTION",@"INPUT_LINE",//unused?
			@"PERL_INPUT_ALL",@"PERL_INPUT_SELECTION",@"PERL_INPUT_LINE",
			@"PERL_REPLACE_SELECTION",@"PERL_REPLACE_LINE",@"PERL_REPLACE_ALL",
			@"RUBY_INPUT_ALL",@"RUBY_INPUT_SELECTION",@"RUBY_INPUT_LINE",
			@"RUBY_REPLACE_SELECTION",@"RUBY_REPLACE_LINE",@"RUBY_REPLACE_ALL",
			@"PREPEND_SELECTION",@"SELECTION",@"REPLACE_SELECTION",@"APPEND_SELECTION",
			@"PREPEND_LINE",@"REPLACE_LINE",@"LINE",@"APPEND_LINE",
			@"PREPEND_ALL",@"REPLACE_ALL",@"ALL",@"APPEND_ALL",nil] retain];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bullet
+ (NSString *)bullet;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return @"\xE2\x80\xA2 ";//"•"
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfMacroTypeAtIndex:
- (NSRange)rangeOfMacroTypeAtIndex:(unsigned int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(index<[self length])
	{
		NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineComponents
- (NSArray *)lineComponents;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * lines = [NSMutableArray array];
	NSRange R = NSMakeRange(0,0);
	unsigned contentsEnd = 0, end = 0;
	while(R.location < [self length])
	{
		R.length = 0;
		[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		R.length = end - R.location;
		NSString * S = [self substringWithRange:R];
		[lines addObject:S];
		R.location = end;
		R.length = 0;
	}
	if(contentsEnd<end)
	{
		// the last line is a return line
		[lines addObject:@""];
	}
//iTM2_END;
	return lines;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceholderMarks
- (NSString *)stringByRemovingPlaceholderMarks;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	NSMutableString * result = [NSMutableString stringWithCapacity:length];
	NSRange markRange;
	NSRange copyRange = NSMakeRange(0,0);
	NSString * S;
next:
	markRange = [self rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:nil ignoreComment:YES];
	if(markRange.length)
	{
		copyRange.length = markRange.location - copyRange.location;
		S = [self substringWithRange:copyRange];
		[result appendString:S];
		copyRange.location = NSMaxRange(markRange);
		if(copyRange.location<length)
		{
			goto next;
		}
	}
	copyRange.length = length - copyRange.location;
	S = [self substringWithRange:copyRange];
	[result appendString:S];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderMarkAfterIndex:getType:ignoreComment:
- (NSRange)rangeOfNextPlaceholderMarkAfterIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;
/*"Description forthcoming. The returned range correspondes to a placeholder mark,
either '@@@(TYPE/? or ')@@@'.
If the placeholder is @@@(TYPE)@@@, TYPE belongs to the start placeholder mark
TYPE length is one word.
For ")@@@@(", the leading ")@@@" is considered the valid placeholder mark. The trailing "@(" has no special meaning.
the character index of the fist '@' for an opening mark and the ')' for a closing mark is greater than index.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	if(index>=length)
	{
		return NSMakeRange(NSNotFound,0);
	}
	NSRange searchRange,markRange,wordRange;
	searchRange.location = index;
	searchRange.length = length - searchRange.location;
	markRange = [self rangeOfString:@"@@@" options:0L range:searchRange];
	if(!markRange.length)
	{
		return NSMakeRange(NSNotFound,0);
	}
	// There might be a problem if the "@@@" found belongs to a bigger ")@@@@..."
	// for which the placeholder mark starts strictly before index
	unichar theChar;
	if(markRange.location == searchRange.location)
	{
		if(markRange.location>2)
		{
			theChar = [self characterAtIndex:markRange.location-3];
			if(theChar == ')')
			{
				theChar = [self characterAtIndex:markRange.location-2];
				if(theChar == '@')
				{
					theChar = [self characterAtIndex:markRange.location-1];
					if(theChar == '@')
					{
						// this is not the right stuff
						searchRange.location = markRange.location+1;
nextMark:
						searchRange.length = length - searchRange.location;
						markRange = [self rangeOfString:@"@@@" options:0L range:searchRange];
						if(!markRange.length)
						{
							return NSMakeRange(NSNotFound,0);
						}
noProblemo:
						if(markRange.location)
						{
							theChar = [self characterAtIndex:markRange.location-1];
							if(theChar == ')')
							{
								--markRange.location;
								++markRange.length;
								if(typeRef)
								{
									*typeRef = nil;
								}
								return markRange;
							}
						}
nextChar:		
						searchRange.location = NSMaxRange(markRange);
						if(searchRange.location<length)
						{
							theChar = [self characterAtIndex:searchRange.location];
							if(theChar == '(')
							{
								++markRange.length;
								index = NSMaxRange(markRange);
								NSString * type = @"";
								if(index<length)
								{
									wordRange = [self rangeOfMacroTypeAtIndex:index];
									type = [self substringWithRange:wordRange];
									if([_iTM2MacroTypes containsObject:type])
									{
										markRange.length += wordRange.length;
										index = NSMaxRange(markRange);
										if((index<length) && ([self characterAtIndex:index] != ')'))
										{
											++markRange.length;
										}
									}
									else
									{
										type = @"";
									}
								}
								if(typeRef)
								{
									*typeRef = [type uppercaseString];
								}
								return markRange;
							}
							if(theChar == '@')
							{
								++markRange.location;
								goto nextChar;
							}
							goto nextMark;
						}
						// else we reached the end of the string: no room for a '(' character
						return NSMakeRange(NSNotFound,0);
					}
					else if(theChar == ')')
					{
						// this is a stop placeholder starting just before
						searchRange.location = markRange.location+3;
						goto nextMark;
					}
					else
					{
						// this is not a stop placeholder mark
						goto nextChar;
					}
					// unreachable point
twoCharsBefore:
					theChar = [self characterAtIndex:markRange.location-2];
				}
				if(theChar == ')')
				{
					theChar = [self characterAtIndex:markRange.location-1];
					if(theChar == '@')
					{
						// this is not the right stuff
						searchRange.location = markRange.location+2;
						goto nextMark;
					}
				}
				else
				{
oneCharBefore:
					theChar = [self characterAtIndex:markRange.location-1];
				}
				if(theChar == ')')
				{
					searchRange.location = markRange.location+3;
					goto nextMark;
				}
				// this is not a stop placeholder mark
				goto nextChar;
			}
			goto twoCharsBefore;
		}
		if(markRange.location>1)
		{
			goto twoCharsBefore;
		}
		if(markRange.location)
		{
			goto oneCharBefore;
		}
	}
	goto noProblemo;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderMarkBeforeIndex:getType:ignoreComment:
- (NSRange)rangeOfPreviousPlaceholderMarkBeforeIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;
/*"Description forthcoming. The location of the returned range is before index, when the range is not void
This will catch a marker starting before index
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// the placeholder start marker is "@@@(word"
	// there can be a problem if "(word" contains index
	// we make too much test but it leads to simpler code
	// the only weird situation is for ')@@@' when ')' is exactly at index, and unescaped... but this is another story
	unsigned length = [self length];
	if(length<4)
	{
		return NSMakeRange(NSNotFound,0);
	}
	unichar theChar = 0;
	NSRange markRange;
	if(index<UINT_MAX-3 && index+3<length)
	{
		theChar = [self characterAtIndex:index];
		if(theChar == ')')
		{
			theChar = [self characterAtIndex:index+1];
			if(theChar == '@')
			{
				theChar = [self characterAtIndex:index+2];
				if(theChar == '@')
				{
					theChar = [self characterAtIndex:index+3];
					if(theChar == '@')
					{
						markRange = NSMakeRange(index,4);
						if(typeRef)
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
	unsigned end,start;
	index = MIN(index,UINT_MAX-2);
	end = MIN(length-1,index+2);
previousEnd:
	theChar = [self characterAtIndex:end];
	if(theChar=='@')
	{
		NSRange wordRange;
		start = end;
previousStart:
		if(start)
		{
			theChar = [self characterAtIndex:start-1];
			if(theChar=='@')
			{
				--start;
				goto previousStart;
			}
			else if(theChar==')')
			{
				if(end>start+4)
				{
					if(end+1<length)
					{
						// there is room for a start placeholder mark after the stop mark
						theChar = [self characterAtIndex:++end];
						if(theChar == '(')
						{
							// this is a start placeholder delimiter
							start = end - 3;
							type = @"";
							if(++end<length)
							{
								wordRange = [self rangeOfMacroTypeAtIndex:end];
								if(wordRange.length)
								{
									type = [self substringWithRange:wordRange];
									if([_iTM2MacroTypes containsObject:type])
									{
										end += wordRange.length;
										if((end<length) && ([self characterAtIndex:end] != ')'))
										{
											++end;
										}
									}
								}
							}
							if(typeRef)
							{
								*typeRef = [type uppercaseString];
							}
							markRange.location = start;
							markRange.length = end - markRange.location;
							return markRange;
						}
					}
				}
				if(end>start+1)
				{
					markRange = NSMakeRange(start-1,4);
					if(typeRef)
					{
						*typeRef = nil;
					}
					return markRange;
				}
				// no placeholder mark
				if(start>4)
				{
					end = start-1;
					goto previousEnd;
				}
			}
			else if(end>start+1)
			{
				if(end+1<length)
				{
					// there is room for a start placeholder mark after the stop mark
					theChar = [self characterAtIndex:++end];
					if(theChar == '(')
					{
						// this is a start placeholder delimiter, there is no conflict with a start placeholder
						start = end - 3;
						type = @"";
						if(++end<length)
						{
							wordRange = [self rangeOfMacroTypeAtIndex:end];
							if(wordRange.length)
							{
								type = [self substringWithRange:wordRange];
								if([_iTM2MacroTypes containsObject:type])
								{
									end += wordRange.length;
									if((end<length) && ([self characterAtIndex:end] != ')'))
									{
										++end;
									}
								}
							}
						}
						if(typeRef)
						{
							*typeRef = [type uppercaseString];
						}
						markRange.location = start;
						markRange.length = end - markRange.location;
						return markRange;
					}
					else if(start>2)
					{
						end = start;
					}
				}
			}
		}
	}
	if(end--)
	{
		goto previousEnd;
	}
//iTM2_END;
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:getType:ignoreComment:
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/02/2007
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange startRange, stopRange;
	unsigned depth;
	unsigned idx = MAX(index,3)-3;
	NSString * type = nil;
	stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore];
	if(stopRange.length)
	{
		if(type)
		{
			if(stopRange.location<=index)
			{
				// this is in fact a start mark containing index
				// we have to find a balancing stop mark to the right
				startRange = stopRange;
				depth = 1;
otherNextStop:
				idx = NSMaxRange(stopRange);
				stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore];
				if(stopRange.length)
				{
					if(type)
					{
						++depth;
						goto otherNextStop;
					}
					else if(--depth)
					{
						goto otherNextStop;
					}
					else
					{
						startRange.length = NSMaxRange(stopRange)-startRange.location;
						if(typeRef)
						{
							*typeRef = [type uppercaseString];
						}
						return startRange;
					}
				}
				return NSMakeRange(NSNotFound,0);
			}
			else
			{
				// this is a start to the right
				depth = 1;
otherNextStopAfter:
				idx = NSMaxRange(stopRange);
				stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore];
				if(stopRange.length)
				{
					if(type)
					{
						++depth;
						goto otherNextStopAfter;
					}
					else if(--depth)
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
						startRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:startRange.location getType:&type ignoreComment:ignore];
						if(startRange.length)
						{
							if(!type)
							{
								++depth;
								if(startRange.location)
								{
									--startRange.location;
									goto otherPreviousStart;
								}
							}
							else if(--depth)
							{
								if(startRange.location)
								{
									--startRange.location;
									goto otherPreviousStart;
								}
							}
							else
							{
								startRange.length=NSMaxRange(stopRange)-startRange.location;
								if(typeRef)
								{
									*typeRef = [type uppercaseString];
								}
								return startRange;
							}
						}
						// no balancing mark available
						return NSMakeRange(NSNotFound,0);
					}
				}
				// no balancing mark available
				return NSMakeRange(NSNotFound,0);
			}
		}
		else
		{
			goto previousStart;
		}
	}
//iTM2_END;
	return NSMakeRange(NSNotFound, 0);
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderAfterIndex:cycle:tabAnchor:ignoreComment:
- (NSRange)rangeOfNextPlaceholderAfterIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor ignoreComment:(BOOL)ignore;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange markRange = [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil ignoreComment:YES];
	NSRange range;
	NSRange smallerRange;
	unsigned idx = 0;
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
		if(range.length)
		{
nextRange1:
			idx = NSMaxRange(markRange);
			markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil ignoreComment:YES];
			if(markRange.length)
			{
				if(NSMaxRange(markRange)<NSMaxRange(range))
				{
					smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
					if(smallerRange.length)
					{
						range = smallerRange;
						goto nextRange1;
					}
				}
			}
			return range;
		}
	}
	if(cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil ignoreComment:YES];
		if(markRange.length)
		{
			if(NSMaxRange(markRange)<=index)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
				if(range.length)
				{
nextRange2:
					idx = NSMaxRange(markRange);
					markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil ignoreComment:YES];
					if(markRange.length)
					{
						if(NSMaxRange(markRange)<NSMaxRange(range))
						{
							smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
							if(smallerRange.length)
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
	markRange= [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil ignoreComment:YES];
	if(markRange.length)
	{
		return markRange;
	}
	if(cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil ignoreComment:YES];
		if(markRange.length)
		{
			if(NSMaxRange(markRange)<=index)
			{
				return markRange;
			}
		}
	}
	// tabAnchor only
	if([tabAnchor length])
	{
		unsigned length = [self length];
		NSRange searchRange = NSMakeRange(index, length - index);
		range = [self rangeOfString:tabAnchor options:0L range:searchRange];
		if(range.length)
		{
			return range;
		}
		if(cycle)
		{
			searchRange = NSMakeRange(0,MIN(length,index+[tabAnchor length]-1));
			range = [self rangeOfString:tabAnchor options:0L range:searchRange];
			if(range.length)
			{
				return range;
			}
		}
	}
	return NSMakeRange(NSNotFound,0);
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderAfterIndex:cycle:tabAnchor:
- (NSRange)rangeOfNextPlaceholderAfterIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange markRange = [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil];
	NSRange range;
	NSRange smallerRange;
	unsigned idx = 0;
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
		if(range.length)
		{
nextRange1:
			idx = NSMaxRange(markRange);
			markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil];
			if(markRange.length)
			{
				if(NSMaxRange(markRange)<NSMaxRange(range))
				{
					smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
					if(smallerRange.length)
					{
						range = smallerRange;
						goto nextRange1;
					}
				}
			}
			return range;
		}
	}
	if(cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil];
		if(markRange.length)
		{
			if(NSMaxRange(markRange)<=index)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
				if(range.length)
				{
nextRange2:
					idx = NSMaxRange(markRange);
					markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil];
					if(markRange.length)
					{
						if(NSMaxRange(markRange)<NSMaxRange(range))
						{
							smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
							if(smallerRange.length)
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
	markRange= [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil];
	if(markRange.length)
	{
		return markRange;
	}
	if(cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil];
		if(markRange.length)
		{
			if(NSMaxRange(markRange)<=index)
			{
				return markRange;
			}
		}
	}
	// tabAnchor only
	if([tabAnchor length])
	{
		unsigned length = [self length];
		NSRange searchRange = NSMakeRange(index, length - index);
		range = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(range.length)
		{
			return range;
		}
		if(cycle)
		{
			searchRange = NSMakeRange(0,MIN(length,index+[tabAnchor length]-1));
			range = [self rangeOfString:tabAnchor options:nil range:searchRange];
			if(range.length)
			{
				return range;
			}
		}
	}
	return NSMakeRange(NSNotFound,0);
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderBeforeIndex:cycle:tabAnchor:ignoreComment:
- (NSRange)rangeOfPreviousPlaceholderBeforeIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor ignoreComment:(BOOL)ignore;
/*"Placeholder delimiters are ')@@@' and '@@@(\word?'. 
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement NSBackwardsSearch
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range;
	NSRange markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil ignoreComment:ignore];
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:ignore];
		if(range.length)
		{
			return range;
		}
	}
	unsigned length = [self length];
	if(cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil ignoreComment:ignore];
		if(markRange.length)
		{
			if(index<=markRange.location)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:ignore];
				if(range.length)
				{
					return range;
				}
			}
		}
	}
	// placeholder markers only
	markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil ignoreComment:ignore];
	if(markRange.length)
	{
		return markRange;
	}
	if(cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil ignoreComment:ignore];
		if(markRange.length)
		{
			if(index<=markRange.location)
			{
				return markRange;
			}
		}
	}
	// tabAnchor only
	if([tabAnchor length])
	{
		NSRange searchRange = NSMakeRange(0, index);
		range = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(range.length)
		{
			return range;
		}
		if(cycle)
		{
			searchRange = NSMakeRange(index,length-index);
			range = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
			if(range.length)
			{
				return range;
			}
		}
	}
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroPlaceholderReplacement
- (NSString *)macroPlaceholderReplacement;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self length]>8)
	{
		unichar theChar = [self characterAtIndex:3];
		if(theChar == '{')
		{
			;
		}
	}
//iTM2_END;
	return @"";
}
#pragma mark =-=-=-=-=-  INDENTATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByNormalizingIndentationWithNumberOfSpacesPerTab:
- (NSString *)stringByNormalizingIndentationWithNumberOfSpacesPerTab:(int)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * _Tab = nil;
	int idx = numberOfSpacesPerTab;
	if(idx<=0)
	{
		_Tab = @"\t";
	}
	else
	{
		NSMutableString * MS = [NSMutableString string];
		while(idx--)
		{
			[MS appendString:@" "];
		}
		_Tab = [MS copy];
	}
	if(numberOfSpacesPerTab<0)
	{
		numberOfSpacesPerTab = -numberOfSpacesPerTab;
	}
	else if(numberOfSpacesPerTab==0)
	{
		numberOfSpacesPerTab = 4;
	}

	NSArray * lineComponents = [self lineComponents];
	NSMutableString * normalized = [NSMutableString string];
	NSEnumerator * E = [lineComponents objectEnumerator];
	NSString * line;
	while(line = [E nextObject])
	{
		unsigned lineIndentation = 0;
		unsigned currentLength = 0;
		unsigned charIndex = 0;
		while(charIndex<[line length])
		{
			unichar theChar = [self characterAtIndex:charIndex];
			if(theChar == ' ')
			{
				++currentLength;
			}
			else if(theChar == '\t')
			{
				++lineIndentation;
				lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
				currentLength = 0;
			}
			else
			{
				break;
			}
			++charIndex;
		}
		lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
		while(lineIndentation--)
		{
			[normalized appendString:_Tab];
		}
		NSString * tail = [line substringFromIndex:charIndex];
		[normalized appendString:tail];
	}
//iTM2_END;
	return normalized;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringWithIndentationLevel:atIndex:withNumberOfSpacesPerTab:
- (NSString *)stringWithIndentationLevel:(unsigned)indentation atIndex:(unsigned)index withNumberOfSpacesPerTab:(int)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [NSMutableString string];
	NSRange lineRange = NSMakeRange(index,0);
	lineRange = [self lineRangeForRange:lineRange];// the line range containing the given index
	NSString * string = [self substringToIndex:lineRange.location];// everything before the line
	[result appendString:string];// copied as is
	// now append the expected indentation for the line containing index
	NSString * tabString = nil;
	int idx = numberOfSpacesPerTab;
	if(idx<=0)
	{
		tabString = @"\t";
	}
	else
	{
		NSMutableString * MS = [NSMutableString string];
		while(idx--)
		{
			[MS appendString:@" "];
		}
		tabString = [MS copy];
	}
	while(indentation--)
	{
		[result appendString:tabString];
	}
	// now copying the line without its white prefix
	unsigned top = NSMaxRange(lineRange);
	NSCharacterSet * whiteSet = [NSCharacterSet whitespaceCharacterSet];
	while(lineRange.location<top)
	{
		unichar theChar = [self characterAtIndex:lineRange.location];
		if(![whiteSet characterIsMember:theChar])
		{
			break;
		}
		++lineRange.location;
	}
	lineRange.length = top - lineRange.location;
	string = [self substringWithRange:lineRange];
	[result appendString:string];
	// finally copy the rest of the receiver as is
	string = [self substringFromIndex:top];
	[result appendString:string];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indentationLevelAtIndex:withNumberOfSpacesPerTab:
- (unsigned)indentationLevelAtIndex:(unsigned)index withNumberOfSpacesPerTab:(unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(numberOfSpacesPerTab<0)
	{
		numberOfSpacesPerTab = -numberOfSpacesPerTab;
	}
	else if(!numberOfSpacesPerTab)
	{
		numberOfSpacesPerTab = 4;
	}
	NSRange R;
	R.location = index;
	R.length = 0;
	unsigned top;
	[self getLineStart:&index end:nil contentsEnd:&top forRange:R];
	unsigned result = 0;
	unsigned currentLength = 0;
	while(index<top)
	{
		unichar theChar = [self characterAtIndex:index++];
		if(theChar == ' ')
		{
			++currentLength;
		}
		else if(theChar == '\t')
		{
			++result;
			result += (2*currentLength)/numberOfSpacesPerTab;
			currentLength = 0;
		}
		else
		{
			break;
		}
	}
	result += (2*currentLength)/numberOfSpacesPerTab;
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByEscapingPerlControlCharacters
- (NSString *)stringByEscapingPerlControlCharacters;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [[self mutableCopy] autorelease];
	NSRange searchRange = NSMakeRange(0,[result length]);
	[result replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:searchRange];
	searchRange.length = [result length];
	[result replaceOccurrencesOfString:@"$" withString:@"\\$" options:0 range:searchRange];
	searchRange.length = [result length];
	[result replaceOccurrencesOfString:@"@" withString:@"\\@" options:0 range:searchRange];
	searchRange.length = [result length];
	[result replaceOccurrencesOfString:@"[" withString:@"\\[" options:0 range:searchRange];
//iTM2_END;
	return result;
}
@end
