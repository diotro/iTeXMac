/*
//  iTM2TextDocumentKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2TextDocumentKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2StringFormatKit.h>
#import <iTM2Foundation/iTM2WindowKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2TextKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2KeyBindingsKit.h>
#import <iTM2Foundation/iTM2ImageKit.h>
#import <iTM2Foundation/iTM2ViewKit.h>

#define TABLE @"iTM2TextKit"
#define BUNDLE [iTM2TextDocument classBundle]

NSString * const iTM2WildcardDocumentType = @"Wildcard Document";// beware, this MUST appear in the target file...
NSString * const iTM2TextDocumentType = @"Text Document";// beware, this MUST appear in the target file...
NSString * const iTM2TextInspectorType = @"text";
NSString * const iTM2StringEncodingKey = @"StringEncoding";
NSString * const iTM2TextViewsDontUseStandardFindPanelKey = @"iTM2TextViewsDontUseStandardFinePanel";

@implementation iTM2TextDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void) initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    [iTM2TextInspector class];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *) inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayLine:column:withHint:orderFront:
- (BOOL) displayLine: (unsigned int) line column: (unsigned int) column withHint: (NSDictionary *) hint orderFront: (BOOL) yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * documentString = [[self textStorage] string];
	if(line && (line < [documentString numberOfLines]))
	{
		NSEnumerator * E = [[[NSApp windows]
			sortedArrayUsingSelector: @selector(compareUsingLevel:)] objectEnumerator];
		NSWindow * W;
		while(W = [E nextObject])
		{
			iTM2TextInspector * WC = (iTM2TextInspector *)[W windowController];
			NSDocument * D = [WC document];
			if((D == self)
				&& [[[WC class] inspectorType] isEqual:[[D class] inspectorType]]
					&& [WC respondsToSelector:@selector(highlightAndScrollToVisibleLine:column:)])
			{
				[WC highlightAndScrollToVisibleLine:line column:column];
				if(yorn)
					[[WC window] makeKeyAndOrderFront:self];
			}
		}
	//iTM2_END;
		return YES;
	}
	return NO;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:forHint:
- (unsigned int) getLine: (unsigned int *) lineRef column: (unsigned int *) columnRef forHint: (NSDictionary *) hint;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * documentString = [[self textStorage] string];
	if([hint isKindOfClass:[NSDictionary class]])
	{
		NSMutableDictionary * matches = [NSMutableDictionary dictionary];
		NSNumber * N = [hint objectForKey:@"character index"];
		if(N)
		{
			unsigned int characterIndex = [N unsignedIntValue];
			NSString * pageString = [hint objectForKey:@"container"];
			if(characterIndex<[pageString length])
			{
goThree:;// I will come here if the first attempt does not work
				NSRange hereR = [pageString rangeOfWordAtIndex:characterIndex];
				// hereR is the range of the word when the click occurred
				if(hereR.length)
				{
					characterIndex -= hereR.location;// now characterIndex is an offset from the first character of the word!
					NSString * hereWord = [pageString substringWithRange:hereR];
					// hereWord is the word we clicked on
					NSString * prevW1 = nil;
					NSString * prevW2 = nil;
					NSString * prevW3 = nil;
					unsigned int index = hereR.location;
					// looking for the previous word
					if(index > 2)
					{
						index -= 2;
placard:;
						NSRange wordRange = [pageString rangeOfWordAtIndex:index];
						if(wordRange.length)
						{
							prevW1 = [pageString substringWithRange:wordRange];
							index = wordRange.location;
							if(index > 2)
							{
								index -= 2;
dracalp:
								wordRange = [pageString rangeOfWordAtIndex:index];
								if(wordRange.length)
								{
									prevW2 = [pageString substringWithRange:wordRange];
									index = wordRange.location;
									if(index > 2)
									{
										index -= 2;
cardalp:
										wordRange = [pageString rangeOfWordAtIndex:index];
										if(wordRange.length)
										{
											prevW3 = [pageString substringWithRange:wordRange];
										}
										else if(index)
										{
											--index;
											goto cardalp;
										}
									}
								}
								else if(index)
								{
									--index;
									goto dracalp;
								}
							}
						}
						else if(index)
						{
							--index;
							goto placard;
						}
					}
					// now looking for the next words
					NSString * nextW1 = nil;
					NSString * nextW2 = nil;
					NSString * nextW3 = nil;
					index = NSMaxRange(hereR);
					if(index+2 < [pageString length])
					{
						index += 2;
tolebib:;
						NSRange wordRange = [pageString rangeOfWordAtIndex:index];
						if(wordRange.length)
						{
							nextW1 = [pageString substringWithRange:wordRange];
							index = NSMaxRange(wordRange);
							if(index+2 < [pageString length])
							{
								index += 2;
bibelot:
								wordRange = [pageString rangeOfWordAtIndex:index];
								if(wordRange.length)
								{
									nextW2 = [pageString substringWithRange:wordRange];
									index = NSMaxRange(wordRange);
									if(index+2 < [pageString length])
									{
										index += 2;
bolbite:
										wordRange = [pageString rangeOfWordAtIndex:index];
										if(wordRange.length)
										{
											nextW3 = [pageString substringWithRange:wordRange];
										}
										else if(index+1 < [pageString length])
										{
											++index;
											goto bolbite;
										}
									}
								}
								else if(index+1 < [pageString length])
								{
									++index;
									goto bibelot;
								}
							}
						}
						else if(index+1 < [pageString length])
						{
							++index;
							goto tolebib;
						}
					}
//iTM2_LOG(@"Search words: %@+%@+%@+%@+%@", prevW2, prevW1, hereWord, nextW1, nextW2);
					NSRange charRange = [documentString rangeForLine:(lineRef? * lineRef:0) nextLine:nil];
					if(!charRange.length)
						charRange = NSMakeRange(0, [documentString length]);
					unsigned charAnchor = charRange.location + charRange.length / 2;
					NSRange searchR = charRange;
					if(searchR.location > [pageString length])
					{
						searchR.length += [pageString length];
						searchR.location -= [pageString length];
					}
					else
					{
						searchR.length += searchR.location;
						searchR.location = 0;
					}
					if(NSMaxRange(searchR) + [pageString length] < [documentString length])
					{
						searchR.length += [pageString length];
					}
					else
					{
						searchR.length = [documentString length] - searchR.location;
					}
					// we are now looking for matches of the words above
					// this is a weak match
					// first we try to match the prevprevious, previous, here, next and nextNext word
					// if we find only one match, that's okay
					// if we find different matches, we will use the other words to choose
					// if we find no match we will have to make another kind of guess
					// objects are arrays of ranges of the here word
					// keys are the weight of the ranges
					unsigned int topSearchRange = NSMaxRange(searchR);
					unsigned penalty = 1;
					unsigned ytlanep = 1;
					unsigned talpyne = 2;
					hereR = NSMakeRange(NSNotFound, 0);
					NSRange prevR3 = hereR;
					NSRange prevR2 = hereR;
					NSRange prevR1 = hereR;
					NSRange nextR1 = hereR;
					NSRange nextR2 = hereR;
					NSRange nextR3 = hereR;
					#undef MATCH(WORD, RANGE, LEVEL)\
					if([WORD length])\
						RANGE = [documentString rangeOfWord:WORD options:0L range:searchR];\
					else\
						ytlanep *= LEVEL * talpyne;\
					if(RANGE.length)\
					{\
						searchR.location = NSMaxRange(RANGE);\
						searchR.length = topSearchRange - searchR.location;\
					}\
					else\
						penalty *= LEVEL * talpyne;
					MATCH(prevW3, prevR3, 1);
					MATCH(prevW2, prevR2, 2);
					MATCH(prevW1, prevR1, 3);
					hereR = [documentString rangeOfWord:hereWord options:0L range:searchR];
					if(hereR.length)
					{
						searchR.location = NSMaxRange(hereR);
						searchR.length = topSearchRange - searchR.location;
					}
					else
						penalty *= 6 * talpyne;
					MATCH(nextW1, nextR1, 3);
					MATCH(nextW2, nextR2, 2);
					MATCH(nextW3, nextR3, 1);
match12345:
// backwards search
					unsigned top = MIN(topSearchRange, nextR3.location);
					
					searchR.location = NSMaxRange(nextR1);
					if(searchR.location < nextR2.location)
					{
					searchR.length = nextR2.location - searchR.location;
					NSRange R = [documentString rangeOfWord:nextW1 options:NSBackwardsSearch range:searchR];
					if(R.length)
					nextR1 = R;
					}
					searchR.location = NSMaxRange(hereR);
					if(searchR.location < nextR1.location)
					{
					searchR.length = nextR1.location - searchR.location;
					NSRange R = [documentString rangeOfWord:hereWord options:NSBackwardsSearch range:searchR];
					if(R.length)
					hereR = R;
					}
					searchR.location = NSMaxRange(prevR1);
					if(searchR.location < hereR.location)
					{
					searchR.length = hereR.location - searchR.location;
					NSRange R = [documentString rangeOfWord:prevW1 options:NSBackwardsSearch range:searchR];
					if(R.length)
					prevR1 = R;
					}
					searchR.location = NSMaxRange(prevR2);
					if(searchR.location < prevR1.location)
					{
					searchR.length = prevR1.location - searchR.location;
					NSRange R = [documentString rangeOfWord:prevW2 options:NSBackwardsSearch range:searchR];
					if(R.length)
					prevR2 = R;
					}
					N = [NSNumber numberWithUnsignedInt:NSMaxRange(nextR2) - prevR2.location];
					NSArray * RA = [matches objectForKey:N];
					if(!RA)
					{
					RA = [NSArray arrayWithObjects:
					[NSMutableDictionary dictionary],
					[NSMutableDictionary dictionary],
					nil];
					[matches setObject:RA forKey:N];//N is free now
					}
					unsigned int hereAnchor = hereR.location + hereR.length / 2;
					if(hereAnchor < charAnchor)
					{
					NSMutableDictionary * afterMatches = [RA objectAtIndex:1];
					N = [NSNumber numberWithUnsignedInt:((lineRef? * lineRef:0)? hereAnchor - charAnchor:0)];
					NSMutableArray * mra = [afterMatches objectForKey:N];
					if(!mra)
					{
					mra = [NSMutableArray array];
					[afterMatches setObject:mra forKey:N];//N is free
					}
					[mra addObject:[NSValue valueWithRange:hereR]];
					}
					else
					{
					NSMutableDictionary * beforeMatches = [RA objectAtIndex:0];
					N = [NSNumber numberWithUnsignedInt:((lineRef? * lineRef:0)? hereAnchor - charAnchor:0)];
					NSMutableArray * mra = [beforeMatches objectForKey:N];
					if(!mra)
					{
					mra = [NSMutableArray array];
					[beforeMatches setObject:mra forKey:N];//N is free
					}
					[mra addObject:[NSValue valueWithRange:hereR]];
					}
					// then I try to find all the other beforeMatches alike
					searchR.location = NSMaxRange(nextR2);
					if(searchR.location < topSearchRange)
					{
					searchR.length = topSearchRange - searchR.location;
					// finding all the other stuff...
					prevR2 = [documentString rangeOfWord:prevW2 options:0L range:searchR];
					if(prevR2.length)
					{
					searchR.location = NSMaxRange(prevR2);
					searchR.length = topSearchRange - searchR.location;
					if(searchR.length)
					{
					prevR1 = [documentString rangeOfWord:prevW1 options:0L range:searchR];
					if(prevR1.length)
					{
					searchR.location = NSMaxRange(prevR1);
					searchR.length = topSearchRange - searchR.location;
					if(searchR.length)
					{
					hereR = [documentString rangeOfWord:hereWord options:0L range:searchR];
					if(hereR.length)
					{
					searchR.location = NSMaxRange(hereR);
					searchR.length = topSearchRange - searchR.location;
					if(searchR.length)
					{
						nextR1 = [documentString rangeOfWord:nextW1 options:0L range:searchR];
						if(nextR1.length)
						{
							searchR.location = NSMaxRange(nextR1);
							searchR.length = topSearchRange - searchR.location;
							if(searchR.length)
							{
								nextR2 = [documentString rangeOfWord:nextW2 options:0L range:searchR];
								if(nextR2.length)
								{
									goto match12345;
								}
							}
						}
					}
					}
					}
					}
					}
					}											
					}
					// no more matches available:
					// do the job
					if(![matches count])
					return UINT_MAX;
					NSEnumerator * E = [matches keyEnumerator];
					unsigned int top = [[E nextObject] unsignedIntValue];
					while(N = [E nextObject])
					{
					unsigned int newTop = [N unsignedIntValue];
					if(newTop < top)
					{
					top = newTop;
					}
					}
					top += 5;
					NSMutableDictionary * beforeMatches = [NSMutableDictionary dictionary];
					NSMutableDictionary * afterMatches = [NSMutableDictionary dictionary];
					E = [matches keyEnumerator];
					while(N = [E nextObject])
					{
					if([N unsignedIntValue] < top)
					{
					NSMutableDictionary * MD = [RA objectAtIndex:0];
					[MD addEntriesFromDictionary:beforeMatches];
					beforeMatches = MD;
					MD = [RA objectAtIndex:1];
					[MD addEntriesFromDictionary:afterMatches];
					afterMatches = MD;
					}
					}
					if([beforeMatches count])
					{
					N = [[[beforeMatches allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
					hereR = [[[beforeMatches objectForKey:N] objectAtIndex:0] rangeValue];
					if(lineRef)
					{
					* lineRef = [documentString lineForRange:hereR];
					charRange = [documentString rangeForLine:* lineRef nextLine:nil];
					if(columnRef)
					* columnRef = hereR.location + characterIndex - charRange.location;
					}
					else if(columnRef)
					* columnRef = NSNotFound;
					return [N unsignedIntValue];
					}
					else if([afterMatches count])
					{
						N = [[[afterMatches allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
						hereR = [[[afterMatches objectForKey:N] objectAtIndex:0] rangeValue];
						if(lineRef)
						{
							* lineRef = [documentString lineForRange:hereR];
							charRange = [documentString rangeForLine:* lineRef nextLine:nil];
							if(columnRef)
								* columnRef = hereR.location + characterIndex - charRange.location;
						}
						else if(columnRef)
							* columnRef = NSNotFound;
						return [N unsignedIntValue];
						#warning PROBLEM WITH SYNC, USE THE PREVIOUS PAGE PLEASE
					}
				}
				else if(characterIndex + 1 < [pageString length])
				{
					++characterIndex;
					goto goThree;
				}
			}// pageString
		}// character index
	}
	return UINT_MAX;
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:forHint:
- (unsigned int) getLine: (unsigned int *) lineRef column: (unsigned int *) columnRef forHint: (NSDictionary *) hint;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * documentString = [[self textStorage] string];
	if([hint isKindOfClass:[NSDictionary class]])
	{
		NSMutableDictionary * matches = [NSMutableDictionary dictionary];
		NSNumber * N = [hint objectForKey:@"character index"];
		if(N)
		{
			unsigned int characterIndex = [N unsignedIntValue];
			NSString * pageString = [hint objectForKey:@"container"];
			if(characterIndex<[pageString length])
			{
goThree:;// I will come here if the first attempt does not work
				NSRange hereR = [pageString rangeOfWordAtIndex:characterIndex];
				// hereR is the range of the word when the click occurred
				if(hereR.length)
				{
					characterIndex -= hereR.location;// now characterIndex is an offset from the first character of the word!
					NSString * hereWord = [pageString substringWithRange:hereR];
					// hereWord is the word we clicked on
					unsigned penalty = 1;
					unsigned ytlanep = 1;
					NSString * prevW1 = nil;
					NSString * prevW2 = nil;
					NSString * prevW3 = nil;
					unsigned int index = hereR.location;
					// looking for the previous word
					if(index > 2)
					{
						index -= 2;
placard:;
						NSRange wordRange = [pageString rangeOfWordAtIndex:index];
						if(wordRange.length)
						{
							prevW1 = [pageString substringWithRange:wordRange];
							index = wordRange.location;
							if(index > 2)
							{
								index -= 2;
dracalp:
								wordRange = [pageString rangeOfWordAtIndex:index];
								if(wordRange.length)
								{
									prevW2 = [pageString substringWithRange:wordRange];
									index = wordRange.location;
									if(index > 2)
									{
										index -= 2;
cardalp:
										wordRange = [pageString rangeOfWordAtIndex:index];
										if(wordRange.length)
										{
											prevW3 = [pageString substringWithRange:wordRange];
										}
										else if(index)
										{
											--index;
											goto cardalp;
										}
									}
								}
								else if(index)
								{
									--index;
									goto dracalp;
								}
							}
						}
						else if(index)
						{
							--index;
							goto placard;
						}
					}
					// now looking for the next words
					NSString * nextW1 = nil;
					NSString * nextW2 = nil;
					NSString * nextW3 = nil;
					index = NSMaxRange(hereR);
					if(index+2 < [pageString length])
					{
						index += 2;
tolebib:;
						NSRange wordRange = [pageString rangeOfWordAtIndex:index];
						if(wordRange.length)
						{
							nextW1 = [pageString substringWithRange:wordRange];
							index = NSMaxRange(wordRange);
							if(index+2 < [pageString length])
							{
								index += 2;
bibelot:
								wordRange = [pageString rangeOfWordAtIndex:index];
								if(wordRange.length)
								{
									nextW2 = [pageString substringWithRange:wordRange];
									index = NSMaxRange(wordRange);
									if(index+2 < [pageString length])
									{
										index += 2;
bolbite:
										wordRange = [pageString rangeOfWordAtIndex:index];
										if(wordRange.length)
										{
											nextW3 = [pageString substringWithRange:wordRange];
										}
										else if(index+1 < [pageString length])
										{
											++index;
											goto bolbite;
										}
									}
								}
								else if(index+1 < [pageString length])
								{
									++index;
									goto bibelot;
								}
							}
						}
						else if(index+1 < [pageString length])
						{
							++index;
							goto tolebib;
						}
					}
//iTM2_LOG(@"Search words: %@+%@+%@+%@+%@", prevW2, prevW1, hereWord, nextW1, nextW2);
					NSRange charRange = [documentString rangeForLine:(lineRef? * lineRef:0) nextLine:nil];
					if(!charRange.length)
						charRange = NSMakeRange(0, [documentString length]);
					unsigned charAnchor = charRange.location + charRange.length / 2;
					NSRange searchR = charRange;
					if(searchR.location > [pageString length])
					{
						searchR.length += [pageString length];
						searchR.location -= [pageString length];
					}
					else
					{
						searchR.length += searchR.location;
						searchR.location = 0;
					}
					if(NSMaxRange(searchR) + [pageString length] < [documentString length])
					{
						searchR.length += [pageString length];
					}
					else
					{
						searchR.length = [documentString length] - searchR.location;
					}
					// we are now looking for matches of the words above
					// this is a weak match
					// first we try to match the prevprevious, previous, here, next and nextNext word
					// if we find only one match, that's okay
					// if we find different matches, we will use the other words to choose
					// if we find no match we will have to make another kind of guess
					// objects are arrays of ranges of the here word
					// keys are the weight of the ranges
					unsigned int topSearchRange = NSMaxRange(searchR);
					if([prevW2 length])
					{
						NSRange prevR2 = [documentString rangeOfWord:prevW2 options:0L range:searchR];
						if(prevR2.length)
						{
							if([prevW1 length])
							{
								searchR.location = NSMaxRange(prevR2);
								searchR.length = topSearchRange - searchR.location;
								if(searchR.length >= [prevW1 length])
								{
									NSRange prevR1 = [documentString rangeOfWord:prevW1 options:0L range:searchR];
									if(prevR1.length)
									{
										if([hereWord length])
										{
											searchR.location = NSMaxRange(prevR1);
											searchR.length = topSearchRange - searchR.location;
											if(searchR.length >= [hereWord length])
											{
												NSRange hereR = [documentString rangeOfWord:hereWord options:0L range:searchR];
												if(hereR.length)
												{
													if([nextW1 length])
													{
														searchR.location = NSMaxRange(hereR);
														searchR.length = topSearchRange - searchR.location;
														if(searchR.length >= [nextW1 length])
														{
															NSRange nextR1 = [documentString rangeOfWord:nextW1 options:0L range:searchR];
															if(nextR1.length)
															{
																if([nextW2 length])
																{
																	searchR.location = NSMaxRange(nextR1);
																	searchR.length = topSearchRange - searchR.location;
																	if(searchR.length >= [nextW2 length])
																	{
																		NSRange nextR2 = [documentString rangeOfWord:nextW2 options:0L range:searchR];
																		if(nextR2.length)
																		{
match12345:
	// backwards search
	searchR.location = NSMaxRange(nextR1);
	if(searchR.location < nextR2.location)
	{
		searchR.length = nextR2.location - searchR.location;
		NSRange R = [documentString rangeOfWord:nextW1 options:NSBackwardsSearch range:searchR];
		if(R.length)
			nextR1 = R;
	}
	searchR.location = NSMaxRange(hereR);
	if(searchR.location < nextR1.location)
	{
		searchR.length = nextR1.location - searchR.location;
		NSRange R = [documentString rangeOfWord:hereWord options:NSBackwardsSearch range:searchR];
		if(R.length)
			hereR = R;
	}
	searchR.location = NSMaxRange(prevR1);
	if(searchR.location < hereR.location)
	{
		searchR.length = hereR.location - searchR.location;
		NSRange R = [documentString rangeOfWord:prevW1 options:NSBackwardsSearch range:searchR];
		if(R.length)
			prevR1 = R;
	}
	searchR.location = NSMaxRange(prevR2);
	if(searchR.location < prevR1.location)
	{
		searchR.length = prevR1.location - searchR.location;
		NSRange R = [documentString rangeOfWord:prevW2 options:NSBackwardsSearch range:searchR];
		if(R.length)
			prevR2 = R;
	}
	N = [NSNumber numberWithUnsignedInt:NSMaxRange(nextR2) - prevR2.location];
	NSArray * RA = [matches objectForKey:N];
	if(!RA)
	{
		RA = [NSArray arrayWithObjects:
				[NSMutableDictionary dictionary],
				[NSMutableDictionary dictionary],
					nil];
		[matches setObject:RA forKey:N];
	}
	unsigned int hereAnchor = hereR.location + hereR.length / 2;
	if(hereAnchor < charAnchor)
	{
		NSMutableDictionary * afterMatches = [RA objectAtIndex:1];
		N = [NSNumber numberWithUnsignedInt:((lineRef? * lineRef:0)? charAnchor - hereAnchor:0)];
		NSMutableArray * mra = [afterMatches objectForKey:N];
		if(!mra)
		{
			mra = [NSMutableArray array];
			[afterMatches setObject:mra forKey:N];
		}
		[mra addObject:[NSValue valueWithRange:hereR]];
	}
	else
	{
		NSMutableDictionary * beforeMatches = [RA objectAtIndex:0];
		N = [NSNumber numberWithUnsignedInt:((lineRef? * lineRef:0)? hereAnchor - charAnchor:0)];
		NSMutableArray * mra = [beforeMatches objectForKey:N];
		if(!mra)
		{
			mra = [NSMutableArray array];
			[beforeMatches setObject:mra forKey:N];//N is free
		}
		[mra addObject:[NSValue valueWithRange:hereR]];
	}
	// then I try to find all the other beforeMatches alike
	searchR.location = NSMaxRange(nextR2);
	if(searchR.location < topSearchRange)
	{
		searchR.length = topSearchRange - searchR.location;
		// finding all the other stuff...
		prevR2 = [documentString rangeOfWord:prevW2 options:0L range:searchR];
		if(prevR2.length)
		{
			searchR.location = NSMaxRange(prevR2);
			searchR.length = topSearchRange - searchR.location;
			if(searchR.length)
			{
				prevR1 = [documentString rangeOfWord:prevW1 options:0L range:searchR];
				if(prevR1.length)
				{
					searchR.location = NSMaxRange(prevR1);
					searchR.length = topSearchRange - searchR.location;
					if(searchR.length)
					{
						hereR = [documentString rangeOfWord:hereWord options:0L range:searchR];
						if(hereR.length)
						{
							searchR.location = NSMaxRange(hereR);
							searchR.length = topSearchRange - searchR.location;
							if(searchR.length)
							{
								nextR1 = [documentString rangeOfWord:nextW1 options:0L range:searchR];
								if(nextR1.length)
								{
									searchR.location = NSMaxRange(nextR1);
									searchR.length = topSearchRange - searchR.location;
									if(searchR.length)
									{
										nextR2 = [documentString rangeOfWord:nextW2 options:0L range:searchR];
										if(nextR2.length)
										{
											goto match12345;
										}
									}
								}
							}
						}
					}
				}
			}
		}											
	}
	// no more matches available:
	// do the job
	if(![matches count])
		return UINT_MAX;
	NSEnumerator * E = [matches keyEnumerator];
	unsigned int top = [[E nextObject] unsignedIntValue];
	while(N = [E nextObject])
	{
		unsigned int newTop = [N unsignedIntValue];
		if(newTop < top)
		{
			top = newTop;
		}
	}
	top += 5;
	NSMutableDictionary * beforeMatches = [NSMutableDictionary dictionary];
	NSMutableDictionary * afterMatches = [NSMutableDictionary dictionary];
	E = [matches keyEnumerator];
	while(N = [E nextObject])
	{
		if([N unsignedIntValue] < top)
		{
			RA = [matches objectForKey:N];
			NSMutableDictionary * MD = [RA objectAtIndex:0];
			[MD addEntriesFromDictionary:beforeMatches];
			beforeMatches = MD;
			MD = [RA objectAtIndex:1];
			[MD addEntriesFromDictionary:afterMatches];
			afterMatches = MD;
		}
	}
	if([beforeMatches count])
	{
		N = [[[beforeMatches allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
		hereR = [[[beforeMatches objectForKey:N] objectAtIndex:0] rangeValue];
		if(lineRef)
		{
			* lineRef = [documentString lineForRange:hereR];
			charRange = [documentString rangeForLine:* lineRef nextLine:nil];
			if(columnRef)
				* columnRef = hereR.location + characterIndex - charRange.location;
		}
		else if(columnRef)
			* columnRef = NSNotFound;
		return [N unsignedIntValue] + top - 5;
	}
	else if([afterMatches count])
	{
		N = [[[afterMatches allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
		hereR = [[[afterMatches objectForKey:N] objectAtIndex:0] rangeValue];
		if(lineRef)
		{
			* lineRef = [documentString lineForRange:hereR];
			charRange = [documentString rangeForLine:* lineRef nextLine:nil];
			if(columnRef)
				* columnRef = hereR.location + characterIndex - charRange.location;
		}
		else if(columnRef)
			* columnRef = NSNotFound;
		return [N unsignedIntValue] + top - 5;
		#warning PROBLEM WITH SYNC, USE THE PREVIOUS PAGE PLEASE
	}
																		}
																		else
																		{
																			// no matches for the whole 5 words: matching 1234 only
																		}
																	}
																	else
																	{
																		// no room for next next word to match: 1234
																	}
																}
																else
																{
																	// no next next word given
																	
																}
															}
															else
															{
																// no matches for the whole 5 words: matching 1235
															}
														}
														else
														{
															// no next word
														}
													}
													else
													{
														// no matches for the whole 5 words: matching 123
													}
												}
												else
												{
													// no matches for the whole 5 words: matching 1245
												}
											}
											else
											{
												// no here word to match with
											}
										}
										else
										{
											// no here word given
										}
									}
									else
									{
										// matching 1345 only
									}
								}
								else
								{
									// NO room for prev word...
								}
							}
							else
							{
								// NO prev word given...
							}
						}
						else
						{
							// no matches for the whole 5 words: matching 2345
						}
					}
					else
					{
						// no prev prev word given
					}
	//			return;
				}
				else if(characterIndex + 1 < [pageString length])
				{
					++characterIndex;
					goto goThree;
				}
			}// pageString
		}// character index
	}
	return UINT_MAX;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canAutoSave
- (BOOL) canAutoSave;
/*"Returns YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 05/04/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [DFM isWritableFileAtPath:[self fileName]];
}
#pragma mark =-=-=-=-=-=-=-=  MODEL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringRepresentation
- (NSString *) stringRepresentation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self stringFormatter] stringWithData:[self dataRepresentation]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringRepresentation:
- (void) setStringRepresentation: (NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSData * D = [[self stringFormatter] dataWithString:argument allowLossyConversion:NO];
	if(D)
	{
		[self loadDataRepresentation:D ofType:[self modelType]];
		return;
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"loading the data representation of length %i, type: %@", [D length], [self modelType]);
	}
	NSStringEncoding saveEncoding = [self stringEncoding];
	unsigned result = NSRunCriticalAlertPanel(
NSLocalizedStringFromTableInBundle(@"Saving.", TABLE, BUNDLE, "Critical Alert Panel Title"),
NSLocalizedStringFromTableInBundle(@"Information may be lost while saving with encoding %@.", TABLE, BUNDLE, "unsaved"),
NSLocalizedStringFromTableInBundle(@"Abort", TABLE, BUNDLE, "Abort"),
NSLocalizedStringFromTableInBundle(@"Force", TABLE, BUNDLE, "Force"),
NSLocalizedStringFromTableInBundle(@"Show problems", TABLE, BUNDLE, "Show pbms"),
[NSString localizedNameOfStringEncoding:saveEncoding]);
	if(NSAlertDefaultReturn == result)
	{
		return;// abort
	}
	else if(NSAlertErrorReturn == result)
	{
		[self loadDataRepresentation:[[self stringFormatter] dataWithString:argument allowLossyConversion:NO] ofType:[self fileType]];
		return;// error
	}
	else if(NSAlertOtherReturn == result)
	{
		NSMutableArray * MRAidx = [NSMutableArray array];
		NSMutableArray * MRArng = [NSMutableArray array];
		int idx = 0, top = [argument length];
		int length = 0;
		while (idx < top)
		{
			unichar c = [argument characterAtIndex:idx];
//NSLog(@"character %@ at %i", [NSString stringWithCharacters:&c length:1], idx);
			id D = [[NSString stringWithCharacters:&c length:1] dataUsingEncoding:saveEncoding allowLossyConversion:NO];
			if([(NSString *)D length])
			{
				if(length>1)
				{
					if(idx>=length)
						[MRArng addObject:[NSValue valueWithRange:NSMakeRange(idx-length, length)]];
					else
					{
						iTM2_LOG(@"Warning: Character problem 1");
					}
				}
				else if(length == 1)
				{
					if(idx>=length)
						[MRAidx addObject:[NSNumber numberWithInt:idx-length]];
					else
					{
						iTM2_LOG(@"Warning: Character problem 2");
					}
				}
				length = 0;
			}
			else
			{
				iTM2_LOG(@"Warning: Character problem 3");
				++length;
			}
			++idx;
		}
		// clean the pending stuff
		if(length>1)
		{
			if(idx>=length)
				[MRArng addObject:[NSValue valueWithRange:NSMakeRange(idx-length, length)]];
			else
				NSLog(@"%@ %#x, problem 3", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self);
		}
		else if(length == 1)
		{
			if(idx>=length)
				[MRAidx addObject:[NSNumber numberWithInt:idx-length]];
			else
			{
				iTM2_LOG(@"WARNING: Character problem 4");
			}
		}
		NSEnumerator * E = [[self windowControllers] objectEnumerator];
		id WC;
		while(WC = [E nextObject])
			if([WC isKindOfClass:[iTM2TextInspector class]])
				[[WC textView] secondaryHighlightAtIndices:MRAidx lengths:MRArng];
		[self postNotificationWithStatus:
			[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"The highlighted characters can not be properly encoded using %@.", TABLE, BUNDLE, ""), [NSString localizedNameOfStringEncoding:saveEncoding]]
				object: [self frontWindow]];
		return;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage
- (id) textStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self frontWindow] windowController] textStorage];
}
#pragma mark =-=-=-=-=-=-=-=  PRINTING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= printDocument:
- (void) printDocument: (id) aSender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (07/17/2001)
- 2 : Wed Oct 01 2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[[NSApp mainWindow] windowController] document] == self)
    {
        NSPrintInfo * PI = [self printInfo];
        NSPrintOperation * PO = [NSPrintOperation
                printOperationWithView: [[[NSApp mainWindow] windowController] textView] printInfo:PI];
        [PI setHorizontalPagination:NSFitPagination];
        [PI setVerticallyCentered:NO];
        [PO setShowPanels:YES];
        [PO runOperation];
    }
    else
    {
    #warning sheet for typesetting!!!
        [super printDocument:aSender];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateChangeCount:
- (void) updateChangeCount: (NSDocumentChangeType) change;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (07/17/2001)
- 2 : Wed Oct 01 2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super updateChangeCount:change];
    if(![self isDocumentEdited] && ![[self undoManager] isUndoing] && ![[self undoManager] isRedoing])
        [[self windowControllers] makeObjectsPerformSelector:@selector(breakTypingFlow)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validatePrintDocument:
- (BOOL) validatePrintDocument: (id) sender;
/*"Replaces old stuff which had absolutely no cocoa flavour.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- < 1.1: 03/10/2002
To Do List: implement other actions
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[[[self frontWindow] windowController] textView] string] length]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateRevertDocumentToSaved:
- (BOOL) validateRevertDocumentToSaved: (id) sender;
/*"Replaces old stuff which had absolutely no cocoa flavour.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- < 1.1: 03/10/2002
To Do List: implement other actions
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self isDocumentEdited] && [DFM isReadableFileAtPath:[self fileName]];
}
#pragma mark =-=-=-=-=-  CODESET & EOL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringFormatter
- (id) stringFormatter;
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
        metaSETTER([[[iTM2StringFormatController allocWithZone:[self zone]] initWithDocument:self] autorelease]);
        result = metaGETTER;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringFormatter:
- (void) setStringFormatter: (id) argument;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOL
- (unsigned int) EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self stringFormatter] EOL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOL:
- (void) setEOL: (unsigned int) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned int old = [self EOL];
    if([self stringFormatter] && (argument != old))
    {
        [[[self undoManager] prepareWithInvocationTarget:self] setEOL:old];
        [[self stringFormatter] setEOL:argument];
        [[self undoManager] setActionName:
            NSLocalizedStringFromTableInBundle(@"Change line endings", TABLE, BUNDLE, "Undo manager action name")];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncoding
- (NSStringEncoding) stringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self stringFormatter] stringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncoding:
- (void) setStringEncoding: (NSStringEncoding) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned int old = [self stringEncoding];
    if(argument != old)
    {
        [[[self undoManager] prepareWithInvocationTarget:self] setStringEncoding:old];
        [[self stringFormatter] setStringEncoding:argument];
        [[self undoManager] setActionName:([[self undoManager] isUndoing]?
            NSLocalizedStringFromTableInBundle(@"Revert string encoding", TABLE, BUNDLE, "Undo manager action name"):
            NSLocalizedStringFromTableInBundle(@"Change string encoding", TABLE, BUNDLE, "Undo manager action name"))];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isStringEncodingHardCoded
- (BOOL) isStringEncodingHardCoded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self stringFormatter] isStringEncodingHardCoded];
}
#warning THE STRING ENCODING MUST BE REVISITED WITH LATEST CODE...
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _revertDocumentToSavedWithStringEncoding:
- (void) _revertDocumentToSavedWithStringEncoding: (NSStringEncoding) stringEncoding;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list: ASK!!!
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self stringFormatter] setStringEncoding:stringEncoding];
    [self revertToSavedFromFile:[self fileName] ofType:[self fileType]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revertDocumentToSavedWithStringEncoding:
- (void) revertDocumentToSavedWithStringEncoding: (NSStringEncoding) stringEncoding;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list: ASK!!!
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self stringEncoding] != stringEncoding)
    {
        if([self isDocumentEdited])
        {
            NSWindow * docWindow = [NSApp mainWindow];
            if(self != [[docWindow windowController] document])
                docWindow = nil;
            NSBeginAlertSheet(
                [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Reverting to %@ string encoding.", TABLE, BUNDLE, "Sheet title"), [NSString localizedNameOfStringEncoding:stringEncoding]],
                NSLocalizedStringFromTableInBundle(@"Revert", TABLE, BUNDLE, "Button title"),
                NSLocalizedStringFromTableInBundle(@"Cancel", TABLE, BUNDLE, ""),
                nil,
                docWindow,
                self,
                NULL,
                @selector(revertWithStringEncodingSheetDidDismiss:returnCode:contextInfo:),
                [[NSDictionary dictionaryWithObject:
                    [NSNumber numberWithUnsignedInt:stringEncoding] forKey:iTM2StringEncodingKey] retain],// will be released below
                NSLocalizedStringFromTableInBundle(@"\"%@\" has been edited.  Are you sure you want to revert to saved?", TABLE, BUNDLE, ""),
                [self fileName]);
        }
        else
            [self _revertDocumentToSavedWithStringEncoding:stringEncoding];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revertWithStringEncodingSheetDidDismiss:returnCode:contextInfo:
- (void) revertWithStringEncodingSheetDidDismiss: (NSWindow *) sheet returnCode: (int) returnCode contextInfo: (NSDictionary *) contextInfo;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list: ASK!!!
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [contextInfo autorelease];// was retained before
    if(returnCode == NSAlertDefaultReturn)
        [self _revertDocumentToSavedWithStringEncoding:[(NSNumber *)[contextInfo objectForKey:iTM2StringEncodingKey] unsignedIntValue]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"iTM2TextDocument fileURL: %@", absoluteURL);
		iTM2_LOG(@"iTM2TextDocument type: %@", typeName);
	}
    return [super readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError];
}
@end

@interface iTM2TextInspector(PRIVATE)
- (void) recordCurrentContext;
@end

#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"

@implementation iTM2TextInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *) inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *) inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2DefaultInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void) dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:self];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupTextEditorsForView:
- (void) setupTextEditorsForView: (id) view;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([view isKindOfClass:[NSTextView class]])
	{
		if([view conformsToProtocol:@protocol(iTM2TextEditor)])
		{
			if(![[self textEditors] containsObject:view])
			{
				[[self textEditors] addObject:view];
				[[view layoutManager] replaceTextStorage:[self textStorage]];
				[view setUsesFindPanel:![SUD boolForKey:iTM2TextViewsDontUseStandardFindPanelKey]];
				[view awakeFromContext];
			}
		}
		return;
	}
	NSEnumerator * E = [[view subviews] objectEnumerator];
	while(view = [E nextObject])
		[self setupTextEditorsForView:view];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupTextEditorScrollers
- (void) setupTextEditorScrollers;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// sort the text editors gathering the ones with the same enclosing split view
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSEnumerator * E = [[self textEditors] objectEnumerator];
	id TE;
	while(TE = [E nextObject])
		[MD setObject:[NSValue valueWithPointer:[TE enclosingSplitView]] forKey:[NSValue valueWithPointer:TE]];
	E = [MD objectEnumerator];
	NSValue * V;
	while(V = [E nextObject])
	{
		// V is a value wrapping a pointer to a split view or nil
		NSArray * allKeys = [MD allKeysForObject:V];
		if([V pointerValue] && ([allKeys count] > 1))
		{
			NSEnumerator * EE = [allKeys objectEnumerator];
			while(TE = (id)[[EE nextObject] pointerValue])
			{
				NSScrollView * ESV = [TE enclosingScrollView];
				if(ESV)
				{
					NSEnumerator * E = [[ESV subviews] objectEnumerator];
					iTM2ScrollerToolbar * scrollerToolbar;
					while(scrollerToolbar = [E nextObject])
					{
						if([scrollerToolbar isKindOfClass:[iTM2ScrollerToolbar class]]
								&& ([scrollerToolbar position] == iTM2ScrollerToolbarPositionBottom))
						{
							[scrollerToolbar performSelector:@selector(class) withObject:nil afterDelay:1];
							[scrollerToolbar removeFromSuperview];
						}
					}
					scrollerToolbar = [iTM2ScrollerToolbar scrollerToolbarForPosition:iTM2ScrollerToolbarPositionBottom];
					NSRect R = NSZeroRect;
					R.size.height = [NSScroller scrollerWidth];
					R.size.width = [NSScroller scrollerWidth];
					iTM2FlagsChangedView * FCV = [[[iTM2FlagsChangedView allocWithZone:[ESV zone]] initWithFrame:R] autorelease];
					NSButton * B = [[[NSButton allocWithZone:[ESV zone]] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitClose]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitClose:)];
					scrollerToolbar = [iTM2ScrollerToolbar scrollerToolbarForPosition:iTM2ScrollerToolbarPositionBottom];
					[scrollerToolbar addSubview:B];
					[scrollerToolbar setFrame:R];
					R.origin = NSZeroPoint;
					B = [[[NSButton allocWithZone:[ESV zone]] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitHorizontal]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitHorizontal:)];
					[B setTag:0];
					[FCV addSubview:B];
					B = [[[NSButton allocWithZone:[ESV zone]] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitVertical]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitVertical:)];
					[B setTag:[FCV tagFromMask:NSAlternateKeyMask]];
					[FCV addSubview:B];
					[scrollerToolbar addSubview:FCV];
					[FCV computeIndexFromTag];
					R.origin.y = NSMaxY(R);
					[FCV setFrame:R];
					R.origin = NSZeroPoint;
					R = NSUnionRect(R, [FCV frame]);
					[scrollerToolbar setFrame:R];
					[scrollerToolbar setBounds:R];
					[ESV addSubview:scrollerToolbar];
					[ESV tile];// was not necessary according to the doc, but it does not work well without that...
					[ESV setNeedsDisplay:YES];
				}
			}
		}
		else
		{
			NSEnumerator * EE = [[MD allKeysForObject:V] objectEnumerator];
			while(TE = (id)[[EE nextObject] pointerValue])
			{
				NSScrollView * ESV = [TE enclosingScrollView];
				if(ESV)
				{
					NSEnumerator * E = [[ESV subviews] objectEnumerator];
					iTM2ScrollerToolbar * scrollerToolbar;
					while(scrollerToolbar = [E nextObject])
					{
						if([scrollerToolbar isKindOfClass:[iTM2ScrollerToolbar class]]
								&& ([scrollerToolbar position] == iTM2ScrollerToolbarPositionBottom))
						{
							[scrollerToolbar performSelector:@selector(class) withObject:nil afterDelay:1];
							[scrollerToolbar removeFromSuperview];
						}
					}
					scrollerToolbar = [iTM2ScrollerToolbar scrollerToolbarForPosition:iTM2ScrollerToolbarPositionBottom];
					NSRect R = NSZeroRect;
					R.size.height = [NSScroller scrollerWidth];
					R.size.width = [NSScroller scrollerWidth];
					iTM2FlagsChangedView * FCV = [[[iTM2FlagsChangedView allocWithZone:[ESV zone]] initWithFrame:R] autorelease];
					NSButton * B = [[[NSButton allocWithZone:[ESV zone]] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitHorizontal]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitHorizontal:)];
					[B setTag:0];
					[FCV addSubview:B];
					B = [[[NSButton allocWithZone:[ESV zone]] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitVertical]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitVertical:)];
					[B setTag:[FCV tagFromMask:NSAlternateKeyMask]];
					[FCV addSubview:B];
					[scrollerToolbar addSubview:FCV];
					[FCV computeIndexFromTag];
					[scrollerToolbar setFrame:R];
					[scrollerToolbar setBounds:R];
					[ESV addSubview:scrollerToolbar];
					[ESV tile];// was not necessary according to the doc, but it does not work well without that...
					[ESV setNeedsDisplay:YES];
				}
			}
		}
		
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void) windowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// retrieving the iTM2TextEditor instance to connect the text storage
	[self setupTextEditorsForView:[[self window] contentView]];
	[self setupTextEditorScrollers];
    [super windowDidLoad];
	#if 0
	BOOL flag = [self contextBoolForKey:@"iTM2TextKeyWindow"];
//iTM2_LOG(@"flag is: %@", (flag? @"Y": @"N"));
//iTM2_LOG(@"NSApp is: %@", NSApp);
//iTM2_LOG(@"[NSApp keyWindow] is:%@", [NSApp keyWindow]);
    NS_DURING
    if([self contextBoolForKey:@"iTM2TextKeyWindow"])
        [[self window] makeKeyAndOrderFront:self];
    else
        [[self window] orderWindow:NSWindowBelow relativeTo:[[NSApp keyWindow] windowNumber]];
    NS_HANDLER
    iTM2_LOG(@"*** Exception catched: %@", [localException reason]);
    NS_ENDHANDLER
	#endif
//iTM2_LOG(@"My text storage is: %@", [self textStorage]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowFrameIdentifier
- (NSString *) windowFrameIdentifier;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"Text Window";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL) windowPositionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeDocument
- (void) synchronizeDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self document] setStringRepresentation:[[self textStorage] string]];
    [super synchronizeDocument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithDocument
- (void) synchronizeWithDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * argument = [[self document] stringRepresentation];
    if(!argument)
        argument = [NSString string];
    NSTextStorage * TS = [self textStorage];
	[TS beginEditing];
//iTM2_LOG(@"**** **** ****  ALL THE CHARACTERS ARE REPLACED");
	[TS replaceCharactersInRange:NSMakeRange(0, [TS length]) withString:argument];
	[TS endEditing];
	[self loadContext:nil];
    return;
}
#pragma mark =-=-=-=-=-=-=-= SETTERS/GETTERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyTextStorage
- (id) lazyTextStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[NSTextStorage allocWithZone:[self zone]] init] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage
- (id) textStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TS = metaGETTER;
    if(!TS)
    {
        [self setTextStorage:[self lazyTextStorage]];
        TS = metaGETTER;
        NSAssert1(TS, @"%@ non void text storage expected.", __PRETTY_FUNCTION__);
    }
    return TS;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextStorage:
- (void) setTextStorage: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(metaGETTER != argument)
    {
        metaSETTER(argument);
        if(argument)
            [[[self textView] layoutManager] replaceTextStorage:argument];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringRepresentation:
- (void) setStringRepresentation: (NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"argument: %@", argument);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textEditors
- (id) textEditors;
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
        metaSETTER([NSMutableArray array]);
		result = metaGETTER;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView
- (id) textView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id firstResponder = [[self window] firstResponder];
	if([[self textEditors] containsObject:firstResponder])
	{
		// make the active text view the last one in the stack
		id result = [[self textEditors] lastObject];
		if(firstResponder != result)
		{
			[[firstResponder retain] autorelease];
			[[self textEditors] removeObject:firstResponder];
			[[self textEditors] addObject:firstResponder];
			return firstResponder;
		}
	}
//iTM2_END;
    return [[self textEditors] lastObject];
}
#pragma mark =-=-=-=-=-  CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textInspectorCompleteLoadContext:
- (void) textInspectorCompleteLoadContext: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NS_DURING;
	[[self textView] awakeFromContext];
    NS_HANDLER
    iTM2_LOG(@"*** Exception catched: %@", [localException reason]);
    NS_ENDHANDLER
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textInspectorCompleteSaveContext:
- (void) textInspectorCompleteSaveContext: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:[[self window] isKeyWindow] forKey:@"iTM2TextKeyWindow"];// buggy?
    [self takeContextValue:NSStringFromRange([[self textView] selectedRange]) forKey:@"iTM2TextSelectedRange"];
    NS_DURING
    NSRect visibleRect = [[self textView] visibleRect];
    NSLayoutManager * LM = [[self textView] layoutManager];
    NSEnumerator * E = [[LM textContainers] objectEnumerator];
    NSTextContainer * container = [E nextObject];
    NSRange glyphRange = [LM glyphRangeForBoundingRectWithoutAdditionalLayout:visibleRect inTextContainer:container];
    while(container = [E nextObject])
    {
		glyphRange = NSUnionRange(glyphRange,
			[LM glyphRangeForBoundingRectWithoutAdditionalLayout:visibleRect inTextContainer:container]);
    }
    NSRange characterRange = [LM characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
    [self takeContextValue:NSStringFromRange(characterRange) forKey:@"iTM2TextVisibleRange"];
    NS_HANDLER
    iTM2_LOG(@"*** Exception catched: %@", [localException reason]);
    [self takeContextValue:NSStringFromRange([[self textView] selectedRange]) forKey:@"iTM2TextVisibleRange"];
    NS_ENDHANDLER
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  MISC
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  breakTypingFlow
- (void) breakTypingFlow;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self textView] breakTypingFlow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLine:column:
- (void) highlightAndScrollToVisibleLine: (unsigned int) line column: (unsigned int) column;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self textView] highlightAndScrollToVisibleLine:line column:column];
    return;
}
#pragma mark =-=-=-=-=-  CODESET
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOL
- (unsigned int) EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self document] EOL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOL:
- (void) setEOL: (unsigned int) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self document] setEOL:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncoding
- (NSStringEncoding) stringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self document] stringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncoding:
- (void) setStringEncoding: (NSStringEncoding) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned int old = [[self document] stringEncoding];
    if(argument != old)
    {
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"New Encoding.", TABLE, BUNDLE, "Alert Panel Title"), // NSString *title,
			NSLocalizedStringFromTableInBundle(@"Yes", TABLE, BUNDLE, "Yes"), // NSString *defaultButton
			nil, // NSString *alternateButton,
			NSLocalizedStringFromTableInBundle(@"No", TABLE, BUNDLE, "No"), // NSString *otherButton
			[self window], // NSWindow *docWindow
			self, // id modalDelegate,
			NULL, // SEL didEndSelector,
			@selector(newStringEncodingSheetDidDismiss:returnCode:contextInfo:), // SEL didDismissSelector,
			[[NSNumber numberWithUnsignedInt:argument] retain], // void *contextInfo, will be remleased below
			NSLocalizedStringFromTableInBundle(@"Reread the file with encoding %@.", TABLE, BUNDLE, "unsaved"), // NSString *msg,
			[NSString localizedNameOfStringEncoding:argument] // ...
				);
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isStringEncodingHardCoded
- (BOOL) isStringEncodingHardCoded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self document] isStringEncodingHardCoded];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newStringEncodingSheetDidDismiss:returnCode:contextInfo:
- (void) newStringEncodingSheetDidDismiss: (NSWindow *) sheet returnCode:  (int) returnCode contextInfo: (NSNumber *) stringEncodingInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[stringEncodingInfo autorelease];// was retained above
	unsigned int encoding = [stringEncodingInfo unsignedIntValue];
	if(NSAlertDefaultReturn == returnCode)
	{
		[[self document] revertDocumentToSavedWithStringEncoding:encoding];
		return;
	}
    if([[[self textStorage] string] canBeConvertedToEncoding:encoding])
	{
		[[self textView] secondaryHighlightAtIndices:nil lengths:nil];// clean
		[[self document] setStringEncoding:encoding];
		return;
	}
	NSBeginAlertSheet(
		NSLocalizedStringFromTableInBundle(@"Conversion problem.", TABLE, BUNDLE, "Critical Alert Panel Title"),
		NSLocalizedStringFromTableInBundle(@"Abort", TABLE, BUNDLE, "Abort"),
		nil, // NSString *alternateButton,
		NSLocalizedStringFromTableInBundle(@"Show problems", TABLE, BUNDLE, "Show pbms"),
		[self window], // NSWindow *docWindow
		self, // id modalDelegate,
		NULL, // SEL didEndSelector,
		@selector(newStringEncodingProblemSheetDidDismiss:returnCode:contextInfo:), // SEL didDismissSelector,
		[stringEncodingInfo retain], // void *contextInfo, will be released below
		NSLocalizedStringFromTableInBundle(@"Information will be lost while converting to encoding %@.", TABLE, BUNDLE, "unsaved"),
		[NSString localizedNameOfStringEncoding:encoding] // ...
			);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newStringEncodingProblemSheetDidDismiss:returnCode:contextInfo:
- (void) newStringEncodingProblemSheetDidDismiss: (NSWindow *) sheet returnCode: (int) returnCode contextInfo: (NSNumber *) stringEncodingInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[stringEncodingInfo autorelease];// was retained above
	if(NSAlertDefaultReturn == returnCode)
	{
		[[self textView] secondaryHighlightAtIndices:nil lengths:nil];
		return;
	}
	NSMutableArray * MRAidx = [NSMutableArray array];
	NSMutableArray * MRArng = [NSMutableArray array];
	NSString * _StringRepresentation = [[self textStorage] string];
	unsigned int encoding = [stringEncodingInfo unsignedIntValue];
	int idx = 0, top = [_StringRepresentation length];
	int length = 0;
	while (idx < top)
	{
		unichar c = [_StringRepresentation characterAtIndex:idx];
//NSLog(@"character %@ at %i", [NSString stringWithCharacters:&c length:1], idx);
		id D = [[NSString stringWithCharacters:&c length:1] dataUsingEncoding:encoding allowLossyConversion:NO];
		if([(NSString *)D length])
		{
			if(length>1)
			{
				if(idx>=length)
					[MRArng addObject:[NSValue valueWithRange:NSMakeRange(idx-length, length)]];
				else
				{
					iTM2_LOG(@"Warning: Character problem 1");
				}
			}
			else if(length == 1)
			{
				if(idx>=length)
					[MRAidx addObject:[NSNumber numberWithInt:idx-length]];
				else
				{
					iTM2_LOG(@"Warning: Character problem 2");
				}
			}
			length = 0;
		}
		else
		{
			iTM2_LOG(@"Warning: Character problem 3");
			++length;
		}
		++idx;
	}
	// clean the pending stuff
	if(length>1)
	{
		if(idx>=length)
			[MRArng addObject:[NSValue valueWithRange:NSMakeRange(idx-length, length)]];
		else
		{
			iTM2_LOG(@"WARNING: Character problem 3 bis");
		}
	}
	else if(length == 1)
	{
		if(idx>=length)
			[MRAidx addObject:[NSNumber numberWithInt:idx-length]];
		else
		{
			iTM2_LOG(@"WARNING: Character problem 4");
		}
	}
	[[self textView] secondaryHighlightAtIndices:MRAidx lengths:MRArng];
	[self postNotificationWithStatus:
		[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"The highlighted characters can not be properly encoded using %@.", TABLE, BUNDLE, ""),
		[NSString localizedNameOfStringEncoding:encoding]]
			object: [self window]];
	return;
}
#pragma mark =-=-=-=-=-  KEY BINDINGS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *) keyBindingsManagerIdentifier;
/*"Just to autorelease the window controller of the window.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextKeyBindingsIdentifier;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings
- (BOOL) handlesKeyBindings;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL) handlesKeyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  AUTO SPLIT VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splittableEnclosingViewForView:vertical:
- (NSView *) splittableEnclosingViewForView: (NSView *) view vertical: (BOOL) yorn;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!view)
		view = (id)[[self window] firstResponder];
	if([view isKindOfClass:[NSView class]])
	{
		// all the splittable view are the text views...
		NSEnumerator * E = [[self textEditors] objectEnumerator];
		NSTextView * TV;
		while(TV = [E nextObject])
		{
			id ESV = [TV enclosingScrollView];
			if([view isDescendantOf:ESV])
			{
				return ESV;
			}
		}
	}
	return [super splittableEnclosingViewForView:view vertical:yorn];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unsplittableEnclosingViewForView:
- (NSView *) unsplittableEnclosingViewForView: (NSView *) view;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!view)
		view = (id)[[self window] firstResponder];
	if([view isKindOfClass:[NSView class]])
	{
//iTM2_END;
		NSEnumerator * E = [[self textEditors] objectEnumerator];
		NSTextView * TV;
		while(TV = [E nextObject])
		{
			id ESV = [TV enclosingScrollView];
			if([view isDescendantOf:ESV])
			{
				return ESV;
			}
		}
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  duplicateViewForSplitting:vertical:
- (NSView *) duplicateViewForSplitting: (NSView *) view vertical: (BOOL) yorn;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[view saveContext:self];
	iTM2TextInspector * inspector = [[[isa allocWithZone:[self zone]] initWithWindowNibName:NSStringFromClass([self class])] autorelease];
	[inspector window];
	id result = [[[[inspector textView] enclosingScrollView] retain] autorelease];
	[result removeFromSuperviewWithoutNeedingDisplay];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didAddSplittingView:
- (void) didAddSplittingView: (NSView *) view;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[view awakeFromContext];
	[super didAddSplittingView:view];
	[self setupTextEditorsForView:[view enclosingSplitView]];
	[self setupTextEditorScrollers];
	return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didRemoveSplittingView:
- (void) didRemoveSplittingView: (NSView *) view;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first we clean all the text views that no longer belong to the view hierarchy
	NSEnumerator * E = [[self textEditors] objectEnumerator];
	NSTextView * V;
	while(V = [E nextObject])
		if([V isDescendantOf:[[self window] contentView]])
		{
			[V performSelector:@selector(class) withObject:nil afterDelay:1];// retain during this event loop...
			[[self textEditors] removeObject:V];
			[[V layoutManager] replaceTextStorage:[[[NSTextStorage alloc] init] autorelease]];
		}
	[super didRemoveSplittingView:view];
	[self setupTextEditorsForView:[[self window] contentView]];
	[self setupTextEditorScrollers];
	return;
//iTM2_END;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2TeXDocument(Scripting)
/*"Description forthcoming."*/
@implementation iTM2TextDocument(Scripting)
#warning IS THIS SOMETHING I CAN REMOVE? SCRIPTING IS ALSO LIVING SOMEWHERE ELSE ISN T IT?
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textViewDidChangeSelection:
- (void) textViewDidChangeSelection: (NSNotification *) argument;
/*"The focus selection is like the selection but it is meant to be used by Apple Scripts only.
It is useful because the document may have many text views for just on etext storage.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = [argument object];
    if((id)[TV textStorage] == [self textStorage])
    {
        [IMPLEMENTATION takeMetaValue:[NSValue valueWithRange:[TV selectedRange]] forKey:@"_FocusRange"];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  handleInsertScriptCommand:
- (id) handleInsertScriptCommand: (NSScriptCommand *) command;
/*"The focus selection is like the selection but it is meant to be used by Apple Scripts only.
It is useful because the document may have many text views for just one text storage.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSDictionary * D = [command evaluatedArguments];
    id text = [D objectForKey:@"text"];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"TeXDocument.handleInsertScriptCommand: %@", command);
	}
    if([text isKindOfClass:[NSAttributedString class]])
        text = [text string];
    if([text isKindOfClass:[NSString class]])
    {
        id locId = [D objectForKey:@"location"];
        if(locId)
            // the script gave us an index
            [self replaceCharactersInRange:
                NSMakeRange([locId intValue] - 1, [[D objectForKey:@"length"] intValue])
                    withString: text];
        else
		{
            // the script gave us an index
			NSRange _FocusRange = [[IMPLEMENTATION metaValueForKey:@"_FocusRange"] rangeValue];
            [self replaceCharactersInRange:_FocusRange withString:text];
		}
    }
    else
        [NSException raise:NSInvalidArgumentException format:@"%@ bad argument class:%@.\nDon't know what to do.",\
            __PRETTY_FUNCTION__, text];\
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  replaceCharactersInRange:withString:
- (void) replaceCharactersInRange: (NSRange) range withString: (NSString *) string;
/*"Soft exception is raised (logged message...) when the operation could not complete.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSTextView * TV = [[[self frontWindow] windowController] textView];
    if(TV)
    {
        if([TV shouldChangeTextInRange:range replacementString:string])
        {
            [TV replaceCharactersInRange:range withString:string];
            [TV didChangeText];
        }
        else
            NSLog(@"%@ %@ won't let me change its text.", __PRETTY_FUNCTION__, TV);
    }
    else
    {
        [[self textStorage] replaceCharactersInRange:range withString:string];
		NSRange _FocusRange = [[IMPLEMENTATION metaValueForKey:@"_FocusRange"] rangeValue];
        [IMPLEMENTATION takeMetaValue:[NSValue valueWithRange:NSMakeRange(_FocusRange.location + [string length], 0)] forKey:@"_FocusRange"];
    }
    return;
}
@end

@implementation iTM2TextWindow
@end

@implementation iTM2TextEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromContext
- (void) awakeFromContext;
/*Description Forthcomping.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super awakeFromContext];
	float scale = [self contextFloatForKey:@"iTM2TextScaleFactor"];
	[self setScaleFactor:(scale>0? scale:1)];
    NSRange R = NSMakeRange(0, [[self string] length]);
    NSRange r = NSRangeFromString([self contextValueForKey:@"iTM2TextSelectedRange"]);
    [self setSelectedRange:NSIntersectionRange(R, r)];
    r = NSRangeFromString([self contextValueForKey:@"iTM2TextVisibleRange"]);
    [self scrollRangeToVisible:NSIntersectionRange(R, r)];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollTaggedToVisible:
- (void) scrollTaggedToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [[self textStorage] string];
	unsigned location = [sender tag];
	if(location < [S length])
	{
		unsigned begin, end;
		[S getLineStart:&begin end:&end contentsEnd:nil forRange:NSMakeRange(location, 0)];
		[self highlightAndScrollToVisibleRange:NSMakeRange(begin, end-begin)];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollTaggedAndRepresentedStringToVisible:
- (void) scrollTaggedAndRepresentedStringToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [[self textStorage] string];
	unsigned location = [sender tag];
	if(location < [S length])
	{
		unsigned begin, end;
		[S getLineStart:&begin end:&end contentsEnd:nil forRange:NSMakeRange(location, 0)];
		NSRange searchRange = NSMakeRange(begin, end-begin);
		NSRange range = [S rangeOfString:[sender representedObject] options:0L range:searchRange];
		if(!range.length)
			range = searchRange;
		[self highlightAndScrollToVisibleRange:range];
	}
//iTM2_END;
    return;
}
@end

