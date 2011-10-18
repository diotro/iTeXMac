/*
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

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2ContextKit.h"
#import "iTM2WindowKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2BundleKit.h"
#import "iTM2ImageKit.h"
#import "iTM2ViewKit.h"
#import "iTM2DocumentControllerKit.h"

#import "iTM2StringFormatKit.h"
#import "iTM2StringKit.h"
#import "iTM2TextKit.h"
#import "iTM2TextDocumentKit.h"

#define TABLE @"iTM2TextKit"
#define BUNDLE [iTM2TextDocument classBundle4iTM3]

NSString * const iTM2WildcardDocumentType = @"Wildcard.Document";// beware, this MUST appear in the target file...
NSString * const iTM3TextDocumentType = @"iTM3.text.document";// beware, this MUST appear in the target file...
NSString * const iTM2TextInspectorType = @"text";
NSString * const iTM3StringEncodingKey = @"com.apple.TextEncoding";
NSString * const iTM2TextViewsDontUseStandardFindPanelKey = @"iTM2TextViewsDontUseStandardFinePanel";
NSString * const iTM2TextViewsOverwriteKey = @"iTM2TextViewsOverwrite";

@implementation iTM2TextDocument
@synthesize focusRange = iVarFocusRange;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
    [iTM2TextInspector class];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TextInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayLine:column:length:withHint:orderFront:
- (BOOL)displayLine:(NSUInteger)line column:(NSUInteger)column length:(NSUInteger)length withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * documentString = [[self textStorage] string];
	if (!documentString)
	{
		documentString = self.stringRepresentation;
	}
	if (line && (line <= [documentString numberOfLines4iTM3]))
	{
		NSEnumerator * E = [[[NSApp windows]
			sortedArrayUsingSelector: @selector(compareUsingLevel4iTM3:)] objectEnumerator];
		NSWindow * W;
		iTM2TextInspector * WC;
		while((W = [E nextObject]))
		{
			iTM2TextInspector * WC = (iTM2TextInspector *)W.windowController;
			NSDocument * D = WC.document;
			if (D == self)
			{
				if (yorn && [WC isKindOfClass:[iTM2ExternalInspector class]])
				{
					[(iTM2ExternalInspector *)WC switchToExternalHelperWithEnvironment: [NSDictionary dictionaryWithObjectsAndKeys:
						self.fileURL.path, @"file",
						[NSNumber numberWithInteger:line], @"line",
						[NSNumber numberWithInteger:column], @"column", nil]];
				}
				else if ([[[WC class] inspectorType4iTM3] isEqualToString:[[D class] inspectorType4iTM3]]
					&& [WC respondsToSelector:@selector(highlightAndScrollToVisibleLine:column:length:)])
				{
					[WC highlightAndScrollToVisibleLine:line column:column length:length];
					if (yorn)
						[WC.window makeKeyAndOrderFront:self];
				}
				while((W = [E nextObject]))
				{
					iTM2TextInspector * WC = (iTM2TextInspector *)W.windowController;
					NSDocument * D = WC.document;
					if (D == self)
					{
						if (yorn && [WC isKindOfClass:[iTM2ExternalInspector class]])
						{
							[(iTM2ExternalInspector *)WC switchToExternalHelperWithEnvironment: [NSDictionary dictionaryWithObjectsAndKeys:
								self.fileURL.path, @"file",
								[NSNumber numberWithInteger:line], @"line",
								[NSNumber numberWithInteger:column], @"column", nil]];
						}
						else if ([[[WC class] inspectorType4iTM3] isEqualToString:[[D class] inspectorType4iTM3]]
							&& [WC respondsToSelector:@selector(highlightAndScrollToVisibleLine:column:length:)])
						{
							[WC highlightAndScrollToVisibleLine:line column:column length:length];
							if (yorn)
								[WC.window makeKeyAndOrderFront:self];
						}
					}
				}
				return YES;
			}
		}
		[self makeWindowControllers];
		E = [[self windowControllers] objectEnumerator];
		while((WC = [E nextObject]))
		{
			if ([WC isKindOfClass:[iTM2ExternalInspector class]])
			{
				[(iTM2ExternalInspector *)WC switchToExternalHelperWithEnvironment: [NSDictionary dictionaryWithObjectsAndKeys:
					self.fileURL.path, @"file",
					[NSNumber numberWithInteger:line], @"line",
					[NSNumber numberWithInteger:column], @"column", nil]];
			}
			else if ([WC respondsToSelector:@selector(highlightAndScrollToVisibleLine:column:length:)])
			{
				if (yorn)
				{
					[WC.window makeKeyAndOrderFront:self];
				}
				else
				{
					[WC showWindowBelowFront:self];
				}
				[WC highlightAndScrollToVisibleLine:line column:column length:length];
			}
		}
	//END4iTM3;
		return YES;
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:length:forHint:
- (NSUInteger)getLine:(NSUInteger *)lineRef column:(NSUInteger *)columnRef length:(NSUInteger *)lengthRef forSyncTeXHint:(NSDictionary *)hint;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [hint objectForKey:@"StrongerSynchronization"];
	if ([N boolValue]) {
		return UINT_MAX;
	}
	if (!lineRef) {
		return UINT_MAX;
	}
	if (lengthRef) {
		*lengthRef = 1;
	}
	NSTextStorage * TS = self.textStorage;
	NSString * S = TS.string?:self.stringRepresentation;
	if (!(N = [hint objectForKey:@"character index"])) {
		return UINT_MAX;
	}
	NSUInteger characterIndex = [N unsignedIntegerValue];
	NSString * pageString = [hint objectForKey:@"container"];
	if (characterIndex>=pageString.length) {
		return UINT_MAX;
	}
	NSRange hereR;
	hereR = [pageString rangeOfWordAtIndex4iTM3:characterIndex];
	if (!hereR.length) {
		hereR = [pageString rangeOfComposedCharacterSequenceAtIndex:characterIndex];
		if (!hereR.length) {
			return UINT_MAX;
		}
	}
	characterIndex -= hereR.location;// now characterIndex is an offset from the first character of the word!
	NSString * hereW = [pageString substringWithRange:hereR];
	// hereR is not yet free now, it is used later
	// hereWord is the word we clicked on
	// Can we find this word in the document string?
	// We try to find this word around the given line
	NSRange lineR = [TS getRangeForLine4iTM3:* lineRef];
	if (!lineR.length) {
		return UINT_MAX;
	}
	NSRange searchR = lineR;
	NSMutableArray * hereRanges = [NSMutableArray array];
	// We find all the occurrences of the here word in the given line.
	// if we find such words, this is satisfying
	// if we do not find such words, things will be more complicated
	NSRange foundR = [S rangeOfString:hereW options:ZER0 range:searchR];
	if (foundR.length) {
		do {
			[hereRanges addObject:[NSValue valueWithRange:foundR]];
			searchR.length = iTM3MaxRange(searchR);
			searchR.location = iTM3MaxRange(foundR);
			searchR.length -= searchR.location;
			foundR = [S rangeOfString:hereW options:ZER0 range:searchR];
		} while(foundR.length);
		// searchR is free
		if (hereRanges.count == 1) {
			// good, there is only one occurrence of the word
			// the line is good, but we must set up the column and length, if relevant
			foundR = [hereRanges.lastObject rangeValue];
we_found_it:
			if (columnRef) {
				* columnRef = foundR.location - lineR.location + characterIndex;
				if (lengthRef) {
					* lengthRef = 1;
				}
			}
			return foundR.location;
		}
#warning ADD HERE A FILTER: only word ranges!
		// there are many occurrences of the here word.
		// we try to find the best one by finding out appropriate words before and after
		// what is the word before hereW in the output page?
		NSUInteger index = hereR.location;
		NSRange otherR;
		NSString * otherW = nil;
		NSValue * V = nil;
before:
		if (index>1) {
			index -= 2;// we will find at least a 2 chars length word
			otherR = [pageString rangeOfWordAtIndex4iTM3:index];
			if (otherR.length) {
				otherW = [pageString substringWithRange:otherR];
				// otherR is free now
				foundR = [hereRanges.lastObject rangeValue];
				// start form the last occurence of hereW, try to find out otherW before
				// the try to find the hereW closest to otherW
				// set up a search range, with limited length 256
				if (foundR.location<256) {
					searchR = iTM3MakeRange(ZER0,foundR.location);
				} else {
					searchR = iTM3MakeRange(foundR.location-256,256);
				}
				otherR = [S rangeOfString:otherW options:NSBackwardsSearch range:searchR];
				if (otherR.length) {
					// we found it!
					// now we try the first hereW range after otherR
					for (V in hereRanges) {
						foundR = [V rangeValue];
						if (foundR.location>otherR.location) {
							goto we_found_it;
						}
					}
				}
			} else {
				goto before;
			}
		}
		// When we get here, we had no chance with a previous word
		// We do exactly the same at the right hand side
		index = iTM3MaxRange(hereR);
after:
		if (index<pageString.length)
		{
			otherR = [pageString rangeOfWordAtIndex4iTM3:index];
			if (otherR.length) {
				otherW = [pageString substringWithRange:otherR];
				// otherR is free now
				foundR = [[hereRanges objectAtIndex:ZER0] rangeValue];
				// start form the last occurence of hereW, try to find out otherW before
				// then try to find the hereW closest to otherW
				// set up a search range, with limited length 256
				if (iTM3MaxRange(foundR)+256>S.length) {
					searchR = iTM3MakeRange(iTM3MaxRange(foundR),S.length-iTM3MaxRange(foundR));
				} else {
					searchR = iTM3MakeRange(iTM3MaxRange(foundR),256);
				}
				otherR = [S rangeOfString:otherW options:ZER0 range:searchR];
				if (otherR.length) {
					// we found it!
					// now we try the first hereW range after otherR
					for (V in [hereRanges reverseObjectEnumerator]) {
						foundR = [V rangeValue];
						if (iTM3MaxRange(foundR)<=otherR.location) {
							goto we_found_it;
						}
					}
				}
			} else {
				++index;
				goto after;
			}
		}
		// failed, abort
		return UINT_MAX;
	} else /* there is no here word at the given line */ {
		// we try one line before and one line after
		// the recursivity is managed by the hint
		NSMutableDictionary * newHint;
		newHint = [NSMutableDictionary dictionaryWithDictionary:hint];
		NSInteger mode = [[hint objectForKey:@"mode"] integerValue];
		switch(mode) {
			case 0:
			case -1:
				if (*lineRef)
				{
					[newHint setObject:[NSNumber numberWithInteger:*lineRef-1] forKey:@"mode"];
					*lineRef -= 1;
					return [self getLine:lineRef column:columnRef length:lengthRef forSyncTeXHint:newHint];
				}
				break;
			case -2:
				if (*lineRef)
				{
					[newHint setObject:[NSNumber numberWithInteger:*lineRef-mode+1] forKey:@"mode"];
					*lineRef -= mode-1;
					return [self getLine:lineRef column:columnRef length:lengthRef forSyncTeXHint:newHint];
				}
				break;
			case 1:
				if (*lineRef)
				{
					[newHint setObject:[NSNumber numberWithInteger:*lineRef+1] forKey:@"mode"];
					*lineRef += 1;
					return [self getLine:lineRef column:columnRef length:lengthRef forSyncTeXHint:newHint];
				}
				break;
			default:
				break;
		}
	}
	return UINT_MAX;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:length:forHint:
- (NSUInteger)getLine:(NSUInteger *)lineRef column:(NSUInteger *)columnRef length:(NSUInteger *)lengthRef forHint:(NSDictionary *)hint;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([hint isKindOfClass:[NSDictionary class]]) {
		if ([[hint valueForKey:@"SyncTeX"] boolValue]) {
			if (![[hint valueForKey:@"StrongerSynchronization"] boolValue]) {
				NSUInteger result = [self getLine:lineRef column:columnRef length:lengthRef forSyncTeXHint:hint];
				if (result < UINT_MAX) {
					return result;
				}
			} else {
				return UINT_MAX;
			}
		}
		if (lengthRef) {
			*lengthRef = 1;
		}
		NSTextStorage * TS = self.textStorage;
		NSString * documentString = TS.string?:self.stringRepresentation;
		NSNumber * N = [hint objectForKey:@"character index"];
		if (N) {
			NSRange R;
			NSUInteger characterIndex = [N unsignedIntegerValue];
			NSString * pageString = [hint objectForKey:@"container"];
			if (characterIndex<pageString.length) {
				NSMutableDictionary * matches = [NSMutableDictionary dictionary];
goThree:;// I will come here if the first attempt does not work
				NSRange hereR = [pageString rangeOfWordAtIndex4iTM3:characterIndex];
				// hereR is the range of the word where the click occurred
				if (hereR.length) {
					characterIndex -= hereR.location;// now characterIndex is an offset from the first character of the word!
					NSString * hereWord = [pageString substringWithRange:hereR];
					// hereWord is the word we clicked on
					NSString * prevW1 = nil;
					NSString * prevW2 = nil;
					NSString * prevW3 = nil;
					NSUInteger index = hereR.location;
					// looking for the previous word
					NSRange wordRange;
					if (index > 2) {
						index -= 2;
placard:;
						wordRange = [pageString rangeOfWordAtIndex4iTM3:index];
						if (wordRange.length) {
							prevW1 = [pageString substringWithRange:wordRange];
							index = wordRange.location;
							if (index > 2) {
								index -= 2;
dracalp:
								wordRange = [pageString rangeOfWordAtIndex4iTM3:index];
								if (wordRange.length) {
									prevW2 = [pageString substringWithRange:wordRange];
									index = wordRange.location;
									if (index > 2) {
										index -= 2;
cardalp:
										wordRange = [pageString rangeOfWordAtIndex4iTM3:index];
										if (wordRange.length) {
											prevW3 = [pageString substringWithRange:wordRange];
										} else if (index) {
											--index;
											goto cardalp;
										}
									}
								} else if (index) {
									--index;
									goto dracalp;
								}
							}
						} else if (index) {
							--index;
							goto placard;
						}
					}
					// now looking for the next words
					NSString * nextW1 = nil;
					NSString * nextW2 = nil;
					NSString * nextW3 = nil;
					index = iTM3MaxRange(hereR);
					if (index+2 < pageString.length) {
						index += 2;
tolebib:;
						wordRange = [pageString rangeOfWordAtIndex4iTM3:index];
						if (wordRange.length) {
							nextW1 = [pageString substringWithRange:wordRange];
							index = iTM3MaxRange(wordRange);
							if (index+2 < pageString.length) {
								index += 2;
bibelot:
								wordRange = [pageString rangeOfWordAtIndex4iTM3:index];
								if (wordRange.length) {
									nextW2 = [pageString substringWithRange:wordRange];
									index = iTM3MaxRange(wordRange);
									if (index+2 < pageString.length) {
										index += 2;
bolbite:
										wordRange = [pageString rangeOfWordAtIndex4iTM3:index];
										if (wordRange.length) {
											nextW3 = [pageString substringWithRange:wordRange];
										} else if (index+1 < pageString.length) {
											++index;
											goto bolbite;
										}
									}
								} else if (index+1 < pageString.length) {
									++index;
									goto bibelot;
								}
							}
						} else if (index+1 < pageString.length) {
							++index;
							goto tolebib;
						}
					}
//LOG4iTM3(@"Search words: %@+%@+%@+%@+%@", prevW2, prevW1, hereWord, nextW1, nextW2);
					NSRange charRange = [TS getRangeForLine4iTM3:(lineRef? * lineRef:ZER0)];
					if (!charRange.length)
						charRange = iTM3MakeRange(ZER0, documentString.length);
					NSUInteger charAnchor = charRange.location + charRange.length / 2;
					NSRange searchR = charRange;
					if (searchR.location > pageString.length) {
						searchR.length += pageString.length;
						searchR.location -= pageString.length;
					} else {
						searchR.length += searchR.location;
						searchR.location = ZER0;
					}
					#if 0
                    if (iTM3MaxRange(searchR) + 20*pageString.length < documentString.length)
					{
						searchR.length += 20*pageString.length;
					}
					else
					#endif
					{
						searchR.length = documentString.length - searchR.location;
					}
					// we are now looking for matches of the words above
					// this is a weak match
					// first we try to match the prevprevious, previous, here, next and nextNext word
					// if we find only one match, that's okay
					// if we find different matches, we will use the other words to choose
					// if we find no match we will have to make another kind of guess
					// objects are arrays of ranges of the here word
					// keys are the weight of the ranges
					NSUInteger topSearchRange = iTM3MaxRange(searchR);
					if (prevW2.length) {
						NSRange prevR2 = [documentString rangeOfWord:prevW2 options:ZER0 range:searchR];
						if (prevR2.length) {
							if (prevW1.length) {
								searchR.location = iTM3MaxRange(prevR2);
								searchR.length = topSearchRange - searchR.location;
								if (searchR.length >= prevW1.length) {
									NSRange prevR1 = [documentString rangeOfWord:prevW1 options:ZER0 range:searchR];
									if (prevR1.length) {
										if (hereWord.length) {
											searchR.location = iTM3MaxRange(prevR1);
											searchR.length = topSearchRange - searchR.location;
											if (searchR.length >= hereWord.length) {
												NSRange hereR = [documentString rangeOfWord:hereWord options:ZER0 range:searchR];
												if (hereR.length) {
													if (nextW1.length) {
														searchR.location = iTM3MaxRange(hereR);
														searchR.length = topSearchRange - searchR.location;
														if (searchR.length >= nextW1.length) {
															NSRange nextR1 = [documentString rangeOfWord:nextW1 options:ZER0 range:searchR];
															if (nextR1.length) {
																if (nextW2.length) {
																	searchR.location = iTM3MaxRange(nextR1);
																	searchR.length = topSearchRange - searchR.location;
																	if (searchR.length >= nextW2.length) {
																		NSRange nextR2 = [documentString rangeOfWord:nextW2 options:ZER0 range:searchR];
																		if (nextR2.length) {
match12345:
	// backwards search
	searchR.location = iTM3MaxRange(nextR1);
	if (searchR.location < nextR2.location) {
		searchR.length = nextR2.location - searchR.location;
		R = [documentString rangeOfWord:nextW1 options:NSBackwardsSearch range:searchR];
		if (R.length)
			nextR1 = R;
	}
	searchR.location = iTM3MaxRange(hereR);
	if (searchR.location < nextR1.location) {
		searchR.length = nextR1.location - searchR.location;
		R = [documentString rangeOfWord:hereWord options:NSBackwardsSearch range:searchR];
		if (R.length)
			hereR = R;
	}
	searchR.location = iTM3MaxRange(prevR1);
	if (searchR.location < hereR.location) {
		searchR.length = hereR.location - searchR.location;
		R = [documentString rangeOfWord:prevW1 options:NSBackwardsSearch range:searchR];
		if (R.length)
			prevR1 = R;
	}
	searchR.location = iTM3MaxRange(prevR2);
	if (searchR.location < prevR1.location) {
		searchR.length = prevR1.location - searchR.location;
		R = [documentString rangeOfWord:prevW2 options:NSBackwardsSearch range:searchR];
		if (R.length)
			prevR2 = R;
	}
	N = [NSNumber numberWithUnsignedInteger:iTM3MaxRange(nextR2) - prevR2.location];
	NSArray * RA = [matches objectForKey:N];
	if (!RA) {
		RA = [NSArray arrayWithObjects:
				[NSMutableDictionary dictionary],
				[NSMutableDictionary dictionary],
					nil];
		[matches setObject:RA forKey:N];
	}
	NSUInteger hereAnchor = hereR.location + hereR.length / 2;
	if (hereAnchor < charAnchor) {
		NSMutableDictionary * afterMatches = [RA objectAtIndex:1];
		N = [NSNumber numberWithUnsignedInteger:((lineRef? * lineRef:ZER0)? charAnchor - hereAnchor:ZER0)];
		NSMutableArray * mra = [afterMatches objectForKey:N];
		if (!mra) {
			mra = [NSMutableArray array];
			[afterMatches setObject:mra forKey:N];
		}
		[mra addObject:[NSValue valueWithRange:hereR]];
	} else {
		NSMutableDictionary * beforeMatches = [RA objectAtIndex:ZER0];
		N = [NSNumber numberWithUnsignedInteger:((lineRef? * lineRef:ZER0)? hereAnchor - charAnchor:ZER0)];
		NSMutableArray * mra = [beforeMatches objectForKey:N];
		if (!mra) {
			mra = [NSMutableArray array];
			[beforeMatches setObject:mra forKey:N];//N is free
		}
		[mra addObject:[NSValue valueWithRange:hereR]];
	}
	// then I try to find all the other beforeMatches alike
	searchR.location = iTM3MaxRange(nextR2);
	if (searchR.location < topSearchRange) {
		searchR.length = topSearchRange - searchR.location;
		// finding all the other stuff...
		prevR2 = [documentString rangeOfWord:prevW2 options:ZER0 range:searchR];
		if (prevR2.length) {
			searchR.location = iTM3MaxRange(prevR2);
			searchR.length = topSearchRange - searchR.location;
			if (searchR.length) {
				prevR1 = [documentString rangeOfWord:prevW1 options:ZER0 range:searchR];
				if (prevR1.length) {
					searchR.location = iTM3MaxRange(prevR1);
					searchR.length = topSearchRange - searchR.location;
					if (searchR.length) {
						hereR = [documentString rangeOfWord:hereWord options:ZER0 range:searchR];
						if (hereR.length) {
							searchR.location = iTM3MaxRange(hereR);
							searchR.length = topSearchRange - searchR.location;
							if (searchR.length) {
								nextR1 = [documentString rangeOfWord:nextW1 options:ZER0 range:searchR];
								if (nextR1.length) {
									searchR.location = iTM3MaxRange(nextR1);
									searchR.length = topSearchRange - searchR.location;
									if (searchR.length) {
										nextR2 = [documentString rangeOfWord:nextW2 options:ZER0 range:searchR];
										if (nextR2.length) {
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
	if (!matches.count)
		return UINT_MAX;
	NSEnumerator * E = matches.keyEnumerator;
	NSUInteger top = [[E nextObject] unsignedIntegerValue];
	while((N = [E nextObject])) {
		NSUInteger newTop = [N unsignedIntegerValue];
		if (newTop < top) {
			top = newTop;
		}
	}
	top += 5;
	NSMutableDictionary * beforeMatches = [NSMutableDictionary dictionary];
	NSMutableDictionary * afterMatches = [NSMutableDictionary dictionary];
	E = matches.keyEnumerator;
	while((N = [E nextObject])) {
		if ([N unsignedIntegerValue] < top) {
			RA = [matches objectForKey:N];
			NSMutableDictionary * MD = [RA objectAtIndex:ZER0];
			[MD addEntriesFromDictionary:beforeMatches];
			beforeMatches = MD;
			MD = [RA objectAtIndex:1];
			[MD addEntriesFromDictionary:afterMatches];
			afterMatches = MD;
		}
	}
	if (beforeMatches.count) {
		N = [[[beforeMatches allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:ZER0];
		hereR = [[[beforeMatches objectForKey:N] objectAtIndex:ZER0] rangeValue];
		if (lineRef) {
			* lineRef = [TS lineIndexForLocation4iTM3:hereR.location];
			charRange = [TS getRangeForLine4iTM3:* lineRef];
			if (columnRef)
				* columnRef = hereR.location + characterIndex - charRange.location;
		} else if (columnRef)
			* columnRef = NSNotFound;
		return [N unsignedIntegerValue] + top - 5;
	} else if (afterMatches.count) {
		N = [[[afterMatches allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:ZER0];
		hereR = [[[afterMatches objectForKey:N] objectAtIndex:ZER0] rangeValue];
		if (lineRef) {
			* lineRef = [TS lineIndexForLocation4iTM3:hereR.location];
			charRange = [TS getRangeForLine4iTM3:* lineRef];
			if (columnRef)
				* columnRef = hereR.location + characterIndex - charRange.location;
		} else if (columnRef)
			* columnRef = NSNotFound;
		return [N unsignedIntegerValue] + top - 5;
		#warning PROBLEM WITH SYNC, USE THE PREVIOUS PAGE PLEASE
	}
																		} else {
																			// no matches for the whole 5 words: matching 1234 only
																		}
																	} else {
																		// no room for next next word to match: 1234
																	}
																} else {
																	// no next next word given
																	
																}
															} else {
																// no matches for the whole 5 words: matching 1235
															}
														} else {
															// no next word
														}
													} else {
														// no matches for the whole 5 words: matching 123
													}
												} else {
													// no matches for the whole 5 words: matching 1245
												}
											} else {
												// no here word to match with
											}
										} else {
											// no here word given
										}
									} else {
										// matching 1345 only
									}
								} else {
									// NO room for prev word...
								}
							} else {
								// NO prev word given...
							}
						} else {
							// no matches for the whole 5 words: matching 2345
						}
					} else {
						// no prev prev word given
					}
	//			return;
				} else if (characterIndex + 1 < pageString.length) {
					++characterIndex;
					goto goThree;
				}
			}// pageString
		}// character index
	}
	return UINT_MAX;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canAutoSave
- (BOOL)canAutoSave;
/*"Returns YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 05/04/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.fileURL.isFileURL && [DFM isWritableFileAtPath:self.fileURL.path];
}
#pragma mark =-=-=-=-=-=-=-=  MODEL
@synthesize stringRepresentation = iVarStringRepresentation4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage
- (id)textStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  The text storage may change from one window controller to the next
    id result = [[self.frontWindow windowController] textStorage];
	if (result) {
		return result;
	}
	[self makeWindowControllers];
    [self synchronizeWindowControllers4iTM3Error:self.RORef4iTM3];
    return [self.windowControllers.lastObject textStorage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringRepresentationCompleteDidSave4iTM3Error:
- (BOOL)stringRepresentationCompleteDidSave4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.stringRepresentation = nil;
//END4iTM3;
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=  PRINTING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWindowControllers4iTM3Error:
- (BOOL)synchronizeWindowControllers4iTM3Error:(NSError **)RORef;
/*"This prevents the inherited methods to automatically load the data.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([super synchronizeWindowControllers4iTM3Error:RORef]) {
        for (NSWindowController * WC in self.windowControllers) {
            if ([WC isKindOfClass:iTM2TextInspector.class]) {
                self.stringRepresentation = nil;
            }
        }
		return YES;
	}
//END4iTM3;
    return NO;
}
#pragma mark =-=-=-=-=-=-=-=  PRINTING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= printDocument:
- (void)printDocument:(id)aSender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (07/17/2001)
- 2 : Wed Oct 01 2003
To Do List: ...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([[[NSApp mainWindow] windowController] document] == self) {
        NSPrintInfo * PI = [self printInfo];
		NSView * view = [[[NSApp mainWindow] windowController] textView];
        NSPrintOperation * PO = [NSPrintOperation printOperationWithView:view printInfo:PI];
        [PI setHorizontalPagination:NSFitPagination];
        [PI setVerticallyCentered:NO];
        [PO setShowsPrintPanel:YES];
        [PO setShowsProgressPanel:YES];
	/* Do the print operation, with panels that are document-modal to a specific window.  didRunSelector should have the following signature:
- (void)printOperationDidRun:(NSPrintOperation *)printOperation success:(BOOL)success contextInfo:(void *)contextInfo;
*/
		[PO runOperationModalForWindow:view.window delegate:self didRunSelector:@selector(iTM2TextPrintOperationDidRun:success:contextInfo:) contextInfo:nil];
    }
    else
    {
        [super printDocument:aSender];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TextPrintOperationDidRun:success:contextInfo:
- (void)iTM2TextPrintOperationDidRun:(NSPrintOperation *)printOperation success:(BOOL)success contextInfo:(void *)irrelevant;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (07/17/2001)
- 2 : Wed Oct 01 2003
To Do List: ...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateChangeCount:
- (void)updateChangeCount:(NSDocumentChangeType)change;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (07/17/2001)
- 2 : Wed Oct 01 2003
To Do List: ...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super updateChangeCount:change];
    if (![self isDocumentEdited] && ![self.undoManager isUndoing] && ![self.undoManager isRedoing])
        [[self windowControllers] makeObjectsPerformSelector:@selector(breakTypingFlow)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validatePrintDocument:
- (BOOL)validatePrintDocument:(id)sender;
/*"Replaces old stuff which had absolutely no cocoa flavour.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- < 1.1: 03/10/2002
To Do List: implement other actions
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[[[self frontWindow] windowController] textView] string] length]>ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateRevertDocumentToSaved:
- (BOOL)validateRevertDocumentToSaved:(id)sender;
/*"Replaces old stuff which had absolutely no cocoa flavour.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- < 1.1: 03/10/2002
To Do List: implement other actions
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self isDocumentEdited] && self.fileURL.isFileURL && [DFM isReadableFileAtPath:self.fileURL.path];
}
#pragma mark =-=-=-=-=-  CODESET (Encoding) & EOL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringFormatter4iTM3
- (id)stringFormatter4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarStringFormatter4iTM3?:(iVarStringFormatter4iTM3 = self.lazyStringFormatter);
}
@synthesize stringFormatter4iTM3 = iVarStringFormatter4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyStringFormatter
- (id)lazyStringFormatter;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[iTM2StringFormatController alloc] initWithDocument:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOL
- (NSUInteger)EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.stringFormatter4iTM3.EOL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOL:
- (void)setEOL:(NSUInteger)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger old = self.EOL;
    if (self.stringFormatter4iTM3 && (argument != old))
    {
        [[self.undoManager prepareWithInvocationTarget:self] setEOL:old];
        self.stringFormatter4iTM3.EOL=argument;
        [self.undoManager setActionName:
            NSLocalizedStringFromTableInBundle(@"Change line endings", TABLE, BUNDLE, "Undo manager action name")];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncoding
- (NSStringEncoding)stringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.stringFormatter4iTM3 stringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncoding:
- (void)setStringEncoding:(NSStringEncoding)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
//  Révisé par itexmac2: To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning FAILED: -setStringEncoding: IS NEVER CALLED
    NSUInteger old = self.stringEncoding;
    if (argument != old)
    {
        [[self.undoManager prepareWithInvocationTarget:self] setStringEncoding:old];
        [self.stringFormatter4iTM3 setStringEncoding:argument];
        [self.undoManager setActionName:([self.undoManager isUndoing]?
            NSLocalizedStringFromTableInBundle(@"Revert string encoding", TABLE, BUNDLE, "Undo manager action name"):
            NSLocalizedStringFromTableInBundle(@"Change string encoding", TABLE, BUNDLE, "Undo manager action name"))];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isStringEncodingHardCoded
- (BOOL)isStringEncodingHardCoded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.stringFormatter4iTM3 isStringEncodingHardCoded];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncodingHardCoded:
- (void)setStringEncodingHardCoded:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.stringFormatter4iTM3 setStringEncodingHardCoded:(BOOL)yorn];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	DEBUGLOG4iTM3(0,@"iTM2TextDocument fileURL: %@", absoluteURL);
	DEBUGLOG4iTM3(0,@"iTM2TextDocument type: %@", typeName);
    return [super readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataCompleteReadFromURL4iTM3:ofType:error:
- (BOOL)dataCompleteReadFromURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)RORef;
/*"Now using direct NSString methods to manage the encoding properly.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{
    return [self.stringFormatter4iTM3 readFromURL:absoluteURL error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataCompleteWriteToURL4iTM3:ofType:error:
- (BOOL)dataCompleteWriteToURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) typeName error:(NSError **) RORef;
/*"Now using direct NSString methods to manage the encoding properly.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-11-22 22:48:12 +0100
To Do List:
"*/
{
    if (![typeName conformsToUTType4iTM3:(NSString *)kUTTypePlainText]) {
        return NO;
    }
	NSStringEncoding saveEncoding = self.stringEncoding;
	NSString * S = self.stringRepresentation;
    if ([S writeToURL:absoluteURL atomically:YES encoding:saveEncoding error:RORef]) {
		LOG4iTM3(@"Data saved with encoding: %@", [NSString localizedNameOfStringEncoding:saveEncoding]);
		return YES;
	}
	NSUInteger result = ZER0;
    if (!S) {
        OUTERROR4iTM3(1,@"Nothing to save, it might be a bug.",NULL);
        return NO;
    }
    result = NSRunCriticalAlertPanel(
NSLocalizedStringFromTableInBundle(@"Saving.", TABLE, BUNDLE, "Critical Alert Panel Title"),
NSLocalizedStringFromTableInBundle(@"Information may be lost while saving with encoding %@.", TABLE, BUNDLE, "unsaved"),
NSLocalizedStringFromTableInBundle(@"Ignore", TABLE, BUNDLE, "Ignore"),
nil,
NSLocalizedStringFromTableInBundle(@"Show problems", TABLE, BUNDLE, "Show pbms"),
 [NSString localizedNameOfStringEncoding:saveEncoding]);
	if (NSAlertDefaultReturn == result) {
		return NO;// abort
	} else if (NSAlertOtherReturn == result) {
		NSMutableArray * MRA = [NSMutableArray array];
		NSUInteger idx = ZER0, top = S.length;
		NSUInteger length = ZER0;
		NSRange R;
		NSUInteger firewall = 256;
		NSAutoreleasePool * RP = [[NSAutoreleasePool alloc] init];
		while (idx < top) {
			if (--firewall == ZER0) {
				[RP drain];
				RP = [[NSAutoreleasePool alloc] init];
				firewall = 256;
			}
			R = [S rangeOfComposedCharacterSequenceAtIndex:idx];
			if ([[S substringWithRange:R] canBeConvertedToEncoding:saveEncoding]) {
				// the current character has no problem of encoding
				if (length) {
					// there were problems before
					if (idx>=length) {
						[MRA addObject:[NSValue valueWithRange:iTM3MakeRange(idx-length, length)]];
					} else {
						LOG4iTM3(@"Warning: Character problem 1");
					}
				}
				// no more pending problems
				length = ZER0;
			} else {
				// this character is problematic
				LOG4iTM3(@"Warning: Character problem 3");
				length += R.length;
			}
			idx = iTM3MaxRange(R);
		}
		[RP drain];
		RP = nil;
		// clean the pending stuff
		if (length) {
			if (idx>=length) {
				[MRA addObject:[NSValue valueWithRange:iTM3MakeRange(idx-length, length)]];
			} else {
				LOG4iTM3(@"WARNING: Character problem 4");
			}
		}
		if (MRA.count) {
			for (iTM2TextInspector * WC in self.windowControllers) {
				if ([WC isKindOfClass:[iTM2TextInspector class]]) {
					NSTextView * TV = WC.textView;
					[TV secondaryHighlightInRanges:MRA];
					[TV scrollRangeToVisible:[[MRA objectAtIndex:ZER0] rangeValue]];
				}
			}
		}
		[self postNotificationWithStatus4iTM3:
			[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"The highlighted characters can not be properly encoded using %@.", TABLE, BUNDLE, ""), [NSString localizedNameOfStringEncoding:saveEncoding]]
				object: self.frontWindow];
		return NO;
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _revertDocumentToSavedWithStringEncoding:error:
- (BOOL)_revertDocumentToSavedWithStringEncoding:(NSStringEncoding)encoding error:(NSError **)RORef;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list: ASK!!!
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.stringFormatter4iTM3 setStringEncoding:encoding];
	if ([self dataCompleteReadFromURL4iTM3:self.fileURL ofType:self.fileType error:RORef]) {
        BOOL result = YES;
        for (NSWindowController * WC in self.windowControllers) {
            result = [WC synchronizeWithDocument4iTM3Error:RORef] && result;
        }
		return result;
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revertDocumentToSavedWithStringEncoding:error:
- (BOOL)revertDocumentToSavedWithStringEncoding:(NSStringEncoding)encoding error:(NSError **)RORef;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list: ASK!!!
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self.stringEncoding != encoding)
    {
        if ([self isDocumentEdited])
        {
            NSWindow * docWindow = [NSApp mainWindow];
			BOOL success = NO;
            if (self != [docWindow.windowController document])
                docWindow = nil;
            NSDictionary * D = [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithUnsignedInteger:encoding],iTM3StringEncodingKey,
					[NSValue valueWithPointer:RORef],@"RORef",
					[NSValue valueWithPointer:&success],@"successPtr",
						nil];
            [D performSelector:@selector(retain)]; // D will be released below, trick for the logic analysis
            NSBeginAlertSheet(
                [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Reverting to %@ string encoding.", TABLE, BUNDLE, "Sheet title"),
					[NSString localizedNameOfStringEncoding:encoding]],
                NSLocalizedStringFromTableInBundle(@"Revert", TABLE, BUNDLE, "Button title"),
                NSLocalizedStringFromTableInBundle(@"Cancel", TABLE, BUNDLE, ""),
                nil,
                docWindow,
                self,
                NULL,
                @selector(revertWithStringEncodingSheetDidDismiss:returnCode:contextInfo:),
                D,
                NSLocalizedStringFromTableInBundle(@"\"%@\" has been edited.  Are you sure you want to revert to saved?", TABLE, BUNDLE, ""),
                self.fileURL);
			return success;
        }
        else
            return [self _revertDocumentToSavedWithStringEncoding:encoding error:RORef];
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revertWithStringEncodingSheetDidDismiss:returnCode:contextInfo:
- (void)revertWithStringEncodingSheetDidDismiss:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(NSDictionary *)contextInfo;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list: ASK!!!
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [contextInfo autorelease];// was retained before
	NSError ** RORef = [(NSValue *)[contextInfo objectForKey:@"RORef"] pointerValue];
	BOOL * successPtr = [(NSValue *)[contextInfo objectForKey:@"successPtr"] pointerValue];
	NSUInteger encoding = [(NSNumber *)[contextInfo objectForKey:iTM3StringEncodingKey] unsignedIntegerValue];
    if (returnCode == NSAlertDefaultReturn)
	{
		BOOL success = [self _revertDocumentToSavedWithStringEncoding:encoding error:RORef];
        if (successPtr)
		{
			*successPtr = success;
		}
	}
	else
	{
        if (successPtr)
		{
			*successPtr = NO;
		}
        if (RORef)
		{
			*RORef = nil;// no need to put an out error because the user cancelled the action...
		}
	}
    return;
}
@end

@interface iTM2TextInspector(PRIVATE)
- (void)recordCurrentContext;
@end

@implementation iTM2ExternalInspector(Text)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage
- (id)textStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return nil;
}
@end

//#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"

@implementation iTM2TextInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TextInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2DefaultInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupTextEditorsForView:
- (void)setupTextEditorsForView:(id)view;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-11-22 23:18:09 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([view isKindOfClass:[NSTextView class]])
	{
		NSString * representedFilename = [self.window representedFilename];
		if (representedFilename.length || ((representedFilename = [self.document fileName]), representedFilename.length))
		{
			[view setEditable:[DFM isWritableFileAtPath:representedFilename]];
		}
		else
		{
			[view setEditable:YES];
		}
		if ([view conformsToProtocol:@protocol(iTM2TextEditor)])
		{
			if (![self.textEditors containsObject:view])
			{
				[self.textEditors addObject:view];
				[[view layoutManager] replaceTextStorage:self.textStorage];
				[view setUsesFindPanel:![SUD boolForKey:iTM2TextViewsDontUseStandardFindPanelKey]];
				[view awakeFromContext4iTM3];
			}
		}
		return;
	}
	for (view in [[view subviews] copy])
		[self setupTextEditorsForView:view];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupTextEditorScrollers
- (void)setupTextEditorScrollers;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// sort the text editors gathering the ones with the same enclosing split view
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSView * TE;
	NSValue * V;
	NSValue * VV;
	for (TE in self.textEditors) {
		V = [NSValue valueWithPointer:TE];
		VV = [NSValue valueWithPointer:[TE enclosingSplitView]];
		[MD setObject:VV forKey:V];
	}
	for (V in MD.objectEnumerator) {
		// V is a value wrapping a pointer to a split view or nil
		NSArray * allKeys = [MD allKeysForObject:V];
		if ([V pointerValue] && (allKeys.count > 1)) {
			NSEnumerator * EE = allKeys.objectEnumerator;
			while((TE = (id)[[EE nextObject] pointerValue])) {
				NSScrollView * ESV = TE.enclosingScrollView;
				if (ESV) {
					iTM2ScrollerToolbar * scrollerToolbar;
					for (scrollerToolbar in ESV.subviews.copy) {
						if ([scrollerToolbar isKindOfClass:[iTM2ScrollerToolbar class]]
								&& (scrollerToolbar.position4iTM3 == iTM2ScrollerToolbarPositionBottom)) {
							[scrollerToolbar performSelector:@selector(class) withObject:nil afterDelay:1];
							[scrollerToolbar removeFromSuperview];
						}
					}
					NSRect R = NSZeroRect;
					R.size.height = [NSScroller scrollerWidth];
					R.size.width = [NSScroller scrollerWidth];
					iTM2FlagsChangedView * FCV = [[[iTM2FlagsChangedView alloc] initWithFrame:R] autorelease];
					NSButton * B = [[[NSButton alloc] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitClose4iTM3]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitClose:)];
					scrollerToolbar = [iTM2ScrollerToolbar scrollerToolbarForPosition:iTM2ScrollerToolbarPositionBottom];
					[scrollerToolbar addSubview:B];
					[scrollerToolbar setFrame:R];
					R.origin = NSZeroPoint;
					B = [[[NSButton alloc] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitHorizontal4iTM3]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitHorizontal:)];
					B.tag = ZER0;
					[FCV addSubview:B];
					B = [[[NSButton alloc] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitVertical4iTM3]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitVertical:)];
					[B setTag:[FCV tagFromMask:NSAlternateKeyMask]];
					[FCV addSubview:B];
					[scrollerToolbar addSubview:FCV];
					[FCV computeIndexFromTag4iTM3];
					R.origin.y = NSMaxY(R);
					[FCV setFrame:R];
					R.origin = NSZeroPoint;
					R = NSUnionRect(R, FCV.frame);
					[scrollerToolbar setFrame:R];
					[scrollerToolbar setBounds:R];
					[ESV addSubview:scrollerToolbar];
					[ESV tile];// was not necessary according to the doc, but it does not work well without that...
					[ESV setNeedsDisplay:YES];
				}
			}
		} else {
			NSEnumerator * EE = [[MD allKeysForObject:V] objectEnumerator];
			while((TE = (id)[[EE nextObject] pointerValue])) {
				NSScrollView * ESV = TE.enclosingScrollView;
				if (ESV)
				{
					iTM2ScrollerToolbar * scrollerToolbar;
					for (scrollerToolbar in ESV.subviews.copy) {
						if ([scrollerToolbar isKindOfClass:[iTM2ScrollerToolbar class]]
								&& (scrollerToolbar.position4iTM3 == iTM2ScrollerToolbarPositionBottom)) {
							[scrollerToolbar performSelector:@selector(class) withObject:nil afterDelay:1];
							[scrollerToolbar removeFromSuperview];
						}
					}
					scrollerToolbar = [iTM2ScrollerToolbar scrollerToolbarForPosition:iTM2ScrollerToolbarPositionBottom];
					NSRect R = NSZeroRect;
					R.size.height = [NSScroller scrollerWidth];
					R.size.width = [NSScroller scrollerWidth];
					iTM2FlagsChangedView * FCV = [[[iTM2FlagsChangedView alloc] initWithFrame:R] autorelease];
					NSButton * B = [[[NSButton alloc] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitHorizontal4iTM3]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitHorizontal:)];
					B.tag = ZER0;
					[FCV addSubview:B];
					B = [[[NSButton alloc] initWithFrame:R] autorelease];
					[B setImage:[NSImage imageSplitVertical4iTM3]];
					[B setImagePosition:NSImageOnly];
					[B setAutoresizingMask:NSViewMaxXMargin];
					[B setBezelStyle:NSShadowlessSquareBezelStyle];
					[B setButtonType:NSMomentaryPushInButton];
					[B setAction:@selector(splitVertical:)];
					[B setTag:[FCV tagFromMask:NSAlternateKeyMask]];
					[FCV addSubview:B];
					[scrollerToolbar addSubview:FCV];
					[FCV computeIndexFromTag4iTM3];
					[scrollerToolbar setFrame:R];
					[scrollerToolbar setBounds:R];
					[ESV addSubview:scrollerToolbar];
					[ESV tile];// was not necessary according to the doc, but it does not work well without that...
					[ESV setNeedsDisplay:YES];
				}
			}
		}
		
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// retrieving the iTM2TextEditor instance to connect the text storage
	[self setupTextEditorsForView:self.window.contentView];
	[self setupTextEditorScrollers];
    [super windowDidLoad];
	#if 0
    BOOL flag = [self context4iTM3BoolForKey:@"iTM2TextKeyWindow" domain:iTM2ContextAllDomainsMask];
//LOG4iTM3(@"flag is: %@", (flag? @"Y": @"N"));
//LOG4iTM3(@"NSApp is: %@", NSApp);
//LOG4iTM3(@"[NSApp keyWindow] is:%@", [NSApp keyWindow]);
    NS_DURING
	NSWindow * W = self.window;
    if ([self context4iTM3BoolForKey:@"iTM2TextKeyWindow" domain:iTM2ContextAllDomainsMask])
	{
        [W makeKeyAndOrderFront:self];
	}
    else
	{
        [W orderBelowFront4iTM3:self];
	}
    NS_HANDLER
    LOG4iTM3(@"*** Exception catched: %@", [localException reason]);
    NS_ENDHANDLER
	#endif
//LOG4iTM3(@"My text storage is: %@", [self textStorage]);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowFrameIdentifier4iTM3
- (NSString *)windowFrameIdentifier4iTM3;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Text Window";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeDocument4iTM3Error:
- (BOOL)synchronizeDocument4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.document setStringRepresentation:[self.textStorage string]];
    return [super synchronizeDocument4iTM3Error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithDocument4iTM3Error:
- (BOOL)synchronizeWithDocument4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * argument = [self.document stringRepresentation];
    if (!argument) argument = [NSString string];
    NSTextStorage * TS = self.textStorage;
	[TS beginEditing];
//LOG4iTM3(@"**** **** ****  ALL THE CHARACTERS ARE REPLACED");
	[TS replaceCharactersInRange:iTM3MakeRange(ZER0, TS.length) withString:argument];
	[TS endEditing];
    return [super synchronizeWithDocument4iTM3Error:RORef];
}
#pragma mark =-=-=-=-=-=-=-= SETTERS/GETTERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyTextStorage
- (id)lazyTextStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[NSTextStorage alloc] init] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage
- (id)textStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!iVarTextStorage4iTM3) {
        self.textStorage = self.lazyTextStorage;
        ASSERT_INCONSISTENCY4iTM3(iVarTextStorage4iTM3);
    }
    return iVarTextStorage4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextStorage:
- (void)setTextStorage:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iVarTextStorage4iTM3 != argument) {
        if (iVarTextStorage4iTM3 = argument) {
			for (NSTextView * TV in self.textEditors) {
				[TV.layoutManager replaceTextStorage:argument];
			}
		}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringRepresentation:
- (void)setStringRepresentation:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"argument: %@", argument);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textEditors
- (id)textEditors;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarTextEditors4iTM3?:(iVarTextEditors4iTM3 = [NSMutableArray array]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView
- (NSTextView *)textView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id firstResponder = self.window.firstResponder;
	if ([self.textEditors containsObject:firstResponder])
	{
		// make the active text view the last one in the stack
		id result = self.textEditors.lastObject;
		if (firstResponder != result) {
			[self.textEditors removeObject:firstResponder];
			[self.textEditors addObject:firstResponder];
			return firstResponder;
		}
	}
//END4iTM3;
    return self.textEditors.lastObject;
}
#pragma mark =-=-=-=-=-  CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textInspectorCompleteLoadContext4iTM3:
- (void)textInspectorCompleteLoadContext4iTM3:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NS_DURING;
	[self.textView awakeFromContext4iTM3];
    NS_HANDLER
    LOG4iTM3(@"*** Exception catched: %@", [localException reason]);
    NS_ENDHANDLER
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textInspectorCompleteSaveContext4iTM3Error:
- (void)textInspectorCompleteSaveContext4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:self.window.isKeyWindow forKey:@"iTM2TextKeyWindow" domain:iTM2ContextAllDomainsMask];// buggy?
    [self takeContext4iTM3Value:NSStringFromRange(self.textView.selectedRange) forKey:@"iTM2TextSelectedRange" domain:iTM2ContextAllDomainsMask error:RORef];
    NS_DURING
    NSRect visibleRect = self.textView.visibleRect;
    NSLayoutManager * LM = [self.textView layoutManager];
    NSEnumerator * E = [[LM textContainers] objectEnumerator];
    NSTextContainer * container = [E nextObject];
    NSRange glyphRange = [LM glyphRangeForBoundingRectWithoutAdditionalLayout:visibleRect inTextContainer:container];
    while((container = [E nextObject]))
    {
		glyphRange = iTM3UnionRange(glyphRange,
			[LM glyphRangeForBoundingRectWithoutAdditionalLayout:visibleRect inTextContainer:container]);
    }
    NSRange characterRange = [LM characterRangeForGlyphRange:glyphRange actualGlyphRange:nil];
    [self takeContext4iTM3Value:NSStringFromRange(characterRange) forKey:@"iTM2TextVisibleRange" domain:iTM2ContextAllDomainsMask error:RORef];
    NS_HANDLER
    LOG4iTM3(@"*** Exception catched: %@", [localException reason]);
    [self takeContext4iTM3Value:NSStringFromRange([self.textView selectedRange]) forKey:@"iTM2TextVisibleRange" domain:iTM2ContextAllDomainsMask error:RORef];
    NS_ENDHANDLER
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  MISC
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  breakTypingFlow
- (void)breakTypingFlow;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.textView breakTypingFlow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLine:column:length:
- (void)highlightAndScrollToVisibleLine:(NSUInteger)line column:(NSUInteger)column length:(NSUInteger)length;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.textView highlightAndScrollToVisibleLine:line column:column length:length];
    return;
}
#pragma mark =-=-=-=-=-  CODESET
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOL
- (NSUInteger)EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.document EOL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOL:
- (void)setEOL:(NSUInteger)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.document setEOL:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncoding
- (NSStringEncoding)stringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.document stringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncoding:
- (void)setStringEncoding:(NSStringEncoding)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (argument == CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingInvalidId))
	{
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"New Encoding.", TABLE, BUNDLE, "Alert Panel Title"), // NSString *title,
			NSLocalizedStringFromTableInBundle(@"Ok", TABLE, BUNDLE, "Ok"), // NSString *defaultButton
			nil, // NSString *alternateButton,
			nil, // NSString *otherButton
			self.window, // NSWindow *docWindow
			nil, // id modalDelegate,
			NULL, // SEL didEndSelector,
			NULL, // SEL didDismissSelector,
			nil, // void *contextInfo, will be remleased below
			NSLocalizedStringFromTableInBundle(@"Unknown encoding, Did you make an typo?", TABLE, BUNDLE, "") // NSString *msg,
				);
		return;
	}
    NSUInteger old = [self.document stringEncoding];
    if (argument != old)
    {
        NSNumber * N = [NSNumber numberWithUnsignedInteger:argument];
        [N performSelector:@selector(retain)]; // void *contextInfo, will be released below, trick for the logic analyzer
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"New Encoding.", TABLE, BUNDLE, "Alert Panel Title"), // NSString *title,
			NSLocalizedStringFromTableInBundle(@"Yes", TABLE, BUNDLE, "Yes"), // NSString *defaultButton
			nil, // NSString *alternateButton,
			NSLocalizedStringFromTableInBundle(@"No", TABLE, BUNDLE, "No"), // NSString *otherButton
			self.window, // NSWindow *docWindow
			self, // id modalDelegate,
			NULL, // SEL didEndSelector,
			@selector(newStringEncodingSheetDidDismiss:returnCode:contextInfo:), // SEL didDismissSelector,
			N,
			NSLocalizedStringFromTableInBundle(@"Reread the file with encoding %@.", TABLE, BUNDLE, "unsaved"), // NSString *msg,
			[NSString localizedNameOfStringEncoding:argument] // ...
				);
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isStringEncodingHardCoded
- (BOOL)isStringEncodingHardCoded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.document isStringEncodingHardCoded];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newStringEncodingSheetDidDismiss:returnCode:contextInfo:
- (void)newStringEncodingSheetDidDismiss:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(NSNumber *)stringEncodingInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[stringEncodingInfo autorelease];// was retained above
	NSUInteger encoding = [stringEncodingInfo unsignedIntegerValue];
	if (NSAlertDefaultReturn == returnCode) {
		iTM2TextDocument * doc = self.document;
		[doc writeContext4iTM3ToURL:doc.fileURL ofType:doc.fileType ROR4iTM3];// any change to the context will be preserved
        PRESENT_ROR4iTM3;
		if (![doc revertDocumentToSavedWithStringEncoding:encoding ROR4iTM3]) {
			PRESENT_ROR4iTM3;
		}
		return;
	}
    if ([[self.textStorage string] canBeConvertedToEncoding:encoding]) {
		[self.textView secondaryHighlightInRanges:nil];// clean
		[self.document setStringEncoding:encoding];
		return;
	}
	NSBeginAlertSheet(
		NSLocalizedStringFromTableInBundle(@"Conversion problem.", TABLE, BUNDLE, "Critical Alert Panel Title"),
		NSLocalizedStringFromTableInBundle(@"Abort", TABLE, BUNDLE, "Abort"),
		nil, // NSString *alternateButton,
		NSLocalizedStringFromTableInBundle(@"Show problems", TABLE, BUNDLE, "Show pbms"),
		self.window, // NSWindow *docWindow
		self, // id modalDelegate,
		NULL, // SEL didEndSelector,
		@selector(newStringEncodingProblemSheetDidDismiss:returnCode:contextInfo:), // SEL didDismissSelector,
		stringEncodingInfo,
		NSLocalizedStringFromTableInBundle(@"Information will be lost while converting to encoding %@.", TABLE, BUNDLE, "unsaved"),
		[NSString localizedNameOfStringEncoding:encoding] // ...
			);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newStringEncodingProblemSheetDidDismiss:returnCode:contextInfo:
- (void)newStringEncodingProblemSheetDidDismiss:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(NSNumber *)stringEncodingInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (NSAlertDefaultReturn == returnCode) {
		[self.textView secondaryHighlightInRanges:nil];
		return;
	}
	NSMutableArray * MRA = [NSMutableArray array];
	NSString * S = [self.textStorage string];
	NSUInteger encoding = [stringEncodingInfo unsignedIntegerValue];
	NSUInteger idx = ZER0, top = S.length;
	NSRange R;
	NSUInteger length = ZER0;
	NSUInteger firewall = 256;
	while (idx < top)
	{
		if (--firewall == ZER0) {
			[[NSGarbageCollector defaultCollector] collectIfNeeded];
			firewall = 256;
		}
		R = [S rangeOfComposedCharacterSequenceAtIndex:idx];
		if ([[S substringWithRange:R] canBeConvertedToEncoding:encoding]) {
			// the current character has no problem of encoding
			if (length) {
				// there was problems before
				if (idx>=length) {
					[MRA addObject:[NSValue valueWithRange:iTM3MakeRange(idx-length, length)]];
				} else {
					LOG4iTM3(@"Warning: Character problem 1");
				}
			}
			// no more pending problems
			length = ZER0;
		} else {
			// this character is problematic
			LOG4iTM3(@"Warning: Character problem 3");
			length += R.length;
		}
		idx = iTM3MaxRange(R);
	}
	// clean the pending stuff
	if (length) {
		if (idx>=length)
			[MRA addObject:[NSValue valueWithRange:iTM3MakeRange(idx-length, length)]];
		else {
			LOG4iTM3(@"WARNING: Character problem 4");
		}
	}
	NSTextView * TV = self.textView;
	if (MRA.count) {
		[TV secondaryHighlightInRanges:MRA];
		[TV scrollRangeToVisible:[[MRA objectAtIndex:ZER0] rangeValue]];
	} else {
		[TV secondaryHighlightInRanges:nil];
	}
	[self postNotificationWithStatus4iTM3:
		[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"The highlighted characters can not be properly encoded using %@.", TABLE, BUNDLE, ""),
		[NSString localizedNameOfStringEncoding:encoding]]
			object: self.window];
	return;
}
#pragma mark =-=-=-=-=-  KEY BINDINGS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
#pragma mark =-=-=-=-=-  AUTO SPLIT VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splittableEnclosingViewForView:vertical:
- (NSView *)splittableEnclosingViewForView:(NSView *)view vertical:(BOOL)yorn;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!view)
		view = (id)self.window.firstResponder;
	if ([view isKindOfClass:[NSView class]]) {
		// all the splittable view are the text views...
		for (NSTextView * TV in self.textEditors) {
			NSView * ESV = TV.enclosingScrollView;
			if ([view isDescendantOf:ESV]) {
				return ESV;
			}
		}
	}
	return [super splittableEnclosingViewForView:view vertical:yorn];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unsplittableEnclosingViewForView:
- (NSView *)unsplittableEnclosingViewForView:(NSView *)view;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!view)
		view = (id)self.window.firstResponder;
	if ([view isKindOfClass:[NSView class]]) {
//END4iTM3;
		for (NSTextView * TV in self.textEditors) {
			NSView * ESV = TV.enclosingScrollView;
			if ([view isDescendantOf:ESV]) {
				return ESV;
			}
		}
	}
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  duplicateViewForSplitting:vertical:
- (NSView *)duplicateViewForSplitting:(NSView *)view vertical:(BOOL)yorn;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [view saveContext4iTM3Error:self.RORef4iTM3];
    iTM2TextInspector * inspector = [[[self.class alloc] initWithWindowNibName:NSStringFromClass(self.class)] autorelease];
	NSDocument * document = self.document;
	[document addWindowController:inspector];
	[inspector window];
	id result = [[inspector.textView.enclosingScrollView retain] autorelease];
	[document removeWindowController:inspector];
	[result removeFromSuperviewWithoutNeedingDisplay];
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didAddSplittingView:
- (void)didAddSplittingView:(NSView *)view;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[view awakeFromContext4iTM3];
	[super didAddSplittingView:view];
	[self setupTextEditorsForView:[view enclosingSplitView]];
	[self setupTextEditorScrollers];
	return;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didRemoveSplittingView:
- (void)didRemoveSplittingView:(NSView *)view;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// first we clean all the text views that no longer belong to the view hierarchy
	for (NSTextView * TV in self.textEditors.copy) {
		if ([TV isDescendantOf:self.window.contentView]) {
			NSLayoutManager * LM = TV.layoutManager;
			[LM replaceTextStorage:[[[NSTextStorage alloc] init] autorelease]];
			[self.textEditors removeObject:TV];
		}
	}
	[super didRemoveSplittingView:view];
	[self setupTextEditorsForView:self.window.contentView];
	[self setupTextEditorScrollers];
	return;
//END4iTM3;
}
@end

@implementation NSTextView(iTM2Macro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroDomain
- (NSString *)defaultMacroDomain;
{
    return @"Text";
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2TeXDocument(Scripting)
/*"Description forthcoming."*/
@implementation iTM2TextDocument(Scripting)
#warning IS THIS SOMETHING I CAN REMOVE? SCRIPTING IS ALSO LIVING SOMEWHERE ELSE ISN T IT?
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textViewDidChangeSelection:
- (void)textViewDidChangeSelection:(NSNotification *)argument;
/*"The focus selection is like the selection but it is meant to be used by Apple Scripts only.
It is useful because the document may have many text views for just on etext storage.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = argument.object;
    if ((id)TV.textStorage == self.textStorage) {
        self.focusRange = TV.selectedRange;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  handleInsertScriptCommand:
- (id)handleInsertScriptCommand:(NSScriptCommand *)command;
/*"The focus selection is like the selection but it is meant to be used by Apple Scripts only.
It is useful because the document may have many text views for just one text storage.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSDictionary * D = [command evaluatedArguments];
    id text = [D objectForKey:@"text"];
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"TeXDocument.handleInsertScriptCommand: %@", command);
	}
    if ([text isKindOfClass:[NSAttributedString class]])
        text = [text string];
    if ([text isKindOfClass:[NSString class]]) {
        id locId = [D objectForKey:@"location"];
        if (locId)
            // the script gave us an index
            [self replaceCharactersInRange:
                iTM3MakeRange([locId integerValue] - 1, [[D objectForKey:@"length"] integerValue])
                    withString: text];
        else {
            // the script gave us an index
            [self replaceCharactersInRange:self.focusRange withString:text];
		}
    }
    else
        [NSException raise:NSInvalidArgumentException format:@"%@ bad argument class:%@.\nDon't know what to do.",\
            __iTM2_PRETTY_FUNCTION__, text];\
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  replaceCharactersInRange:withString:
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string;
/*"Soft exception is raised (logged message...) when the operation could not complete.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSTextView * TV = [[self.frontWindow windowController] textView];
    if (TV) {
        if ([TV shouldChangeTextInRange:range replacementString:string]) {
            [TV replaceCharactersInRange:range withString:string];
            [TV didChangeText];
        } else {
            LOG4iTM3(@"%@ won't let me change its text.", TV);
		}
    } else {
        [self.textStorage replaceCharactersInRange:range withString:string];
		self.focusRange = iTM3MakeRange(self.focusRange.location + string.length,ZER0);
    }
    return;
}
@end

@implementation iTM2TextWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
+ (NSString *)macroDomain;
{
    return @"Text";
}
@end

#import "iTM2ResponderKit.h"

@implementation iTM2SharedResponder(TeXDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOverwrite:
- (IBAction)toggleOverwrite:(NSMenuItem *)sender;
/*"Discussion forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2TextViewsOverwriteKey domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool:!old forKey:iTM2TextViewsOverwriteKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOverwrite:
- (BOOL)validateToggleOverwrite:(NSMenuItem *)sender;
/*"Discussion forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2TextViewsOverwriteKey domain:iTM2ContextAllDomainsMask];
	sender.state = old?NSOnState:NSOffState;
    return YES;
}
@end

@interface iTM2TextEditor()
@property (readwrite,retain) id implementation;
@end

@implementation iTM2TextEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOverwrite:
- (IBAction)toggleOverwrite:(id)sender;
/*"Discussion forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2TextViewsOverwriteKey domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool:!old forKey:iTM2TextViewsOverwriteKey domain:iTM2ContextPrivateMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOverwrite:
- (BOOL)validateToggleOverwrite:(NSMenuItem *)sender;
/*"Discussion forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2TextViewsOverwriteKey domain:iTM2ContextAllDomainsMask];
	sender.state = old?NSOnState:NSOffState;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertText:
- (void) insertText:(NSString *)aString; // instead of keyDown: aString can be NSString or NSAttributedString
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.selectedRanges.count > 1) {
//END4iTM3;
		[super insertText:aString];
		return;
	}
	NSRange selectedRange = self.selectedRange;
	if (selectedRange.length||![self context4iTM3BoolForKey:iTM2TextViewsOverwriteKey domain:iTM2ContextAllDomainsMask]) {
//END4iTM3;
		[super insertText:aString];
		return;
	}
	selectedRange.length = aString.length;
	if (iTM3MaxRange(selectedRange)>self.string.length) {
//END4iTM3;
		[super insertText:aString];
		return;
	}
	self.selectedRange = selectedRange;
//END4iTM3;
	[super insertText:aString];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  deleteForward:
- (void)deleteForward:(id)sender;
/*"We do not paste attributes. There is a problem concerning attributes here.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSRange R = self.selectedRange;
	if (R.length == ZER0) {
		NSTextStorage * TS = self.textStorage;
		NSString * S = TS.string;
		if (R.location<S.length) {
			NSRange attrRange;
			NSDictionary * attrs = [TS attributesAtIndex:R.location effectiveRange:&attrRange];
			if ([attrs objectForKey:NSGlyphInfoAttributeName]) {
				self.selectedRange = attrRange;
			}
		}
	}
	[super deleteForward:sender];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  deleteBackward:
- (void)deleteBackward:(id)sender;
/*"We do not paste attributes. There is a problem concerning attributes here.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSRange R = self.selectedRange;
	if (R.length == ZER0) {
		NSTextStorage * TS = self.textStorage;
		if (R.location > ZER0) {
			NSRange attrRange;
			NSDictionary * attrs = [TS attributesAtIndex:R.location-1 effectiveRange:&attrRange];
			if ([attrs objectForKey:NSGlyphInfoAttributeName]) {
				self.selectedRange = attrRange;
			}
		}
	}
	[super deleteBackward:sender];
	return;
}
#if 0
- (void)deleteWordForward:(id)sender;
- (void)deleteWordBackward:(id)sender;
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  paste:
- (IBAction)paste:(id)sender;
/*"We do not paste attributes. There is a problem concerning attributes here.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
 	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:NSStringPboardType];
	NSString * availableType = [GP availableTypeFromArray:types];
	if (!availableType) {
		return;
	}
	NSString * text = [GP stringForType:availableType];
	text = [text precomposedStringWithCompatibilityMapping];// this could be tuned to fit different encodings
	[self insertText:text];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePaste:
- (BOOL)validatePaste:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
 	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:NSStringPboardType];
	NSString * availableType = [GP availableTypeFromArray:types];
	return availableType!=nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)frameRect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ((self = [super initWithFrame:frameRect])) {
		[self initImplementation];
	}
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ((self = [super initWithCoder:aDecoder])) {
		[self initImplementation];
	}
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromContext4iTM3
- (void)awakeFromContext4iTM3;
/*Description Forthcomping.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromContext4iTM3];
	CGFloat scale = [self context4iTM3FloatForKey:@"iTM2TextScaleFactor" domain:iTM2ContextAllDomainsMask];
	[self setScaleFactor:(scale>0? scale:1)];
    NSRange R = iTM3MakeRange(ZER0,self.string.length);
    NSRange r = NSRangeFromString([self context4iTM3ValueForKey:@"iTM2TextSelectedRange" domain:iTM2ContextAllDomainsMask ROR4iTM3]);
    [self setSelectedRange:iTM3ProjectionRange(R, r)];
    r = NSRangeFromString([self context4iTM3ValueForKey:@"iTM2TextVisibleRange" domain:iTM2ContextAllDomainsMask ROR4iTM3]);
    [self scrollRangeToVisible:iTM3ProjectionRange(R, r)];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollTaggedToVisible:
- (void)scrollTaggedToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * S = [[self textStorage] string];
	NSUInteger location = sender.tag;
	if (location < S.length) {
		NSUInteger begin, end;
		[S getLineStart:&begin end:&end contentsEnd:nil forRange:iTM3MakeRange(location,ZER0)];
		[self highlightAndScrollToVisibleRange:iTM3MakeRange(begin, end-begin)];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollTaggedAndRepresentedStringToVisible:
- (void)scrollTaggedAndRepresentedStringToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * S = self.textStorage.string;
	NSUInteger location = sender.tag;
	if (location < S.length) {
		NSUInteger begin, end;
		[S getLineStart:&begin end:&end contentsEnd:nil forRange:iTM3MakeRange(location,ZER0)];
		NSRange searchRange = iTM3MakeRange(begin, end-begin);
		NSRange range = [S rangeOfString:sender.representedObject options:ZER0 range:searchRange];
		if (!range.length) {
			range = searchRange;
        }
		[self highlightAndScrollToVisibleRange:range];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedRanges:affinity:stillSelecting:
- (void)setSelectedRanges:(NSArray *)ranges affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning Not yet fully implemented, when still selecting and other minor problems
	if (YES || stillSelectingFlag) {
		[super setSelectedRanges:ranges affinity:affinity stillSelecting:stillSelectingFlag];
		return;
	}
	NSTextStorage * TS = self.textStorage;
	NSRange R;
	NSDictionary * attrs = nil;
	NSRange attrsRange;
	if (ranges.count == 1) {
		R = [ranges.lastObject rangeValue];
		if (R.length == ZER0) {
			NSEvent * E = self.window.currentEvent;
			NSUInteger type = [E type];
			if (type == NSLeftMouseUp && R.location<self.string.length) {
				// select the edge closest to the hit point
				attrs = [TS attributesAtIndex:R.location longestEffectiveRange:&attrsRange inRange:iTM3MakeRange(ZER0,self.string.length)];
				if ([attrs objectForKey:NSGlyphInfoAttributeName]) {
					R.location=R.location<=attrsRange.location + attrsRange.length/2?
						attrsRange.location:iTM3MaxRange(attrsRange);
					[super setSelectedRanges:[NSArray arrayWithObject:[NSValue valueWithRange:R]] affinity:affinity stillSelecting:stillSelectingFlag];
					return;
				}
			} else if (type == NSKeyDown) {
				NSString * K = [E charactersIgnoringModifiers];
				if (K.length) {
					switch([K characterAtIndex:ZER0])
					{
						case NSUpArrowFunctionKey:
						case NSDownArrowFunctionKey:
						case NSLeftArrowFunctionKey:
						case NSRightArrowFunctionKey:
						{
							NSRange oldR = [self.selectedRanges.lastObject rangeValue];
							if (R.location < oldR.location) {
								// we assume we are selecting up stream
								if (R.location<TS.length)
								{
									attrs = [TS attributesAtIndex:R.location longestEffectiveRange:&attrsRange inRange:iTM3MakeRange(ZER0,self.string.length)];
									if ([attrs objectForKey:NSGlyphInfoAttributeName]) {
										R.location = attrsRange.location;
										[super setSelectedRanges:[NSArray arrayWithObject:[NSValue valueWithRange:R]] affinity:affinity stillSelecting:stillSelectingFlag];
										return;
									}
								}
							} else {
								// we assume we are selecting down stream
								if (R.location) {
									if (R.location<=TS.length) {
										attrs = [TS attributesAtIndex:R.location-1 longestEffectiveRange:&attrsRange inRange:iTM3MakeRange(ZER0,self.string.length)];
										if ([attrs objectForKey:NSGlyphInfoAttributeName]) {
											R.location = iTM3MaxRange(attrsRange);
											[super setSelectedRanges:[NSArray arrayWithObject:[NSValue valueWithRange:R]] affinity:affinity stillSelecting:stillSelectingFlag];
											return;
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
#warning Selection scheme should be revisited
	NSMutableArray * modifiedRanges = [NSMutableArray array];
	for (NSValue * V in ranges) {
		NSRange R = [V rangeValue];
		if (R.length)
		{
			attrs = [TS attributesAtIndex:R.location longestEffectiveRange:&attrsRange inRange:iTM3MakeRange(ZER0,self.string.length)];
			if ([attrs objectForKey:NSGlyphInfoAttributeName])
			{
				R = iTM3UnionRange(R,attrsRange);
			}
			attrs = [TS attributesAtIndex:iTM3MaxRange(R)-1 longestEffectiveRange:&attrsRange inRange:iTM3MakeRange(ZER0,self.string.length)];
			if ([attrs objectForKey:NSGlyphInfoAttributeName])
			{
				R = iTM3UnionRange(R,attrsRange);
			}
            V = [NSValue valueWithRange:R];
            [modifiedRanges addObject:V];
		}
	}
	[super setSelectedRanges:modifiedRanges affinity:affinity stillSelecting:stillSelectingFlag];
//END4iTM3;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectionRangeForProposedRange:granularity:
- (NSRange)selectionRangeForProposedRange:(NSRange)proposedSelRange granularity:(NSSelectionGranularity)granularity;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange itsProposedSelRange = [super selectionRangeForProposedRange:proposedSelRange granularity:granularity];
	NSEvent * E = [self.window currentEvent];
	NSRange myProposedSelRange = itsProposedSelRange;
	if ([E type] == NSLeftMouseUp)
	{
		myProposedSelRange = [self selectedRange];
	}
	else if ([E type] == NSLeftMouseDown)
	{
		NSUInteger clickCount = E.clickCount;
		if (clickCount > 2)
		{
			clickCount -= 2;
//LOG4iTM3(@"ZER0 itsProposedSelRange:%@",NSStringFromRange(itsProposedSelRange));
			if (granularity>NSSelectByWord)
			{
				NSTextStorage * TS = [self textStorage];
				myProposedSelRange = [super selectionRangeForProposedRange:proposedSelRange granularity:NSSelectByWord];
				NSRange placeholderRange;
				do
				{
					if (myProposedSelRange.location>itsProposedSelRange.location)
					{
						doubleClickRange = [S rangeOfPlaceholderAtIndex:myProposedSelRange.location-1 getType:nil];
						myProposedSelRange = iTM3UnionRange(doubleClickRange,myProposedSelRange);
					}
					else if (iTM3MaxRange(proposedSelRange)<iTM3MaxRange(itsProposedSelRange))
					{
						doubleClickRange = [TS doubleClickAtIndex:iTM3MaxRange(myProposedSelRange)];
						myProposedSelRange = iTM3UnionRange(doubleClickRange,myProposedSelRange);
					}
				}
				while(--clickCount);
			}
		}
	}
	else
	{
		return itsProposedSelRange;
	}
	if ((itsProposedSelRange.location <= myProposedSelRange.location)
		&& (iTM3MaxRange(myProposedSelRange)<=iTM3MaxRange(itsProposedSelRange)))
	{
//LOG4iTM3(@"ZER0 myProposedSelRange:%@",NSStringFromRange(myProposedSelRange));
		return myProposedSelRange;
	}
//END4iTM3;
    return itsProposedSelRange;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= clickedOnLink:atIndex:
- (void)clickedOnLink:(id)link atIndex:(NSUInteger)charIndex;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![self.textStorage didClickOnLink4iTM3:(id)link atIndex:(NSUInteger)charIndex]) {
		[super clickedOnLink:link atIndex:charIndex];
	}
//END4iTM3;
    return;
}
@synthesize implementation = _Implementation;
@end

