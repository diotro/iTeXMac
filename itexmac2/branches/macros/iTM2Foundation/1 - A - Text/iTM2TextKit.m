/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Dec 08 2001.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2TextKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2EventKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>

NSString * const iTM2StartPlaceholder = @"__(";
NSString * const iTM2StopPlaceholder = @")__";
NSString * const iTM2TextInsertionAnchorKey = @"__(INS)__";
NSString * const iTM2TextSelectionAnchorKey = @"__(SEL)__";// out of use with perl support
NSString * const iTM2TextTabAnchorKey = @"__(TAB)__";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextKit
/*"Description forthcoming."*/
@implementation NSText(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSelectionQuickly:
-(void)openSelectionQuickly:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THIS IS BUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGY!!!!!!!!!!!!! MAKE IT A SEPARATE RESPONDER
    NSString * S = [[self string] substringWithRange:[self selectedRange]];
	if([S hasPrefix:@"/"])
	{
    NSURL * url = [NSURL fileURLWithPath:S];
		if(![SDC openDocumentWithContentsOfURL:url display:YES] 
            && ![[NSWorkspace sharedWorkspace] openURL:url])
		{
			iTM2_LOG(@"WARNING: Don't know how to open %@", S);
		}
		return;
	}
    //creating an URL?
    NSURL * baseURL = [NSURL fileURLWithPath:[[[[[self window] windowController] document] fileName] stringByDeletingLastPathComponent]];
    NSURL * url = [NSURL URLWithString:S relativeToURL:baseURL];
    if(![SDC openDocumentWithContentsOfURL:url display:YES] 
            && ![[NSWorkspace sharedWorkspace] openURL:url])
	{
		iTM2_LOG(@"WARNING: Don't know how to open %@ relative to %@", S, [[[[[self window] windowController] document] fileName] stringByDeletingLastPathComponent]);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  breakTypingFlow
-(void)breakTypingFlow;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // find what is the name of the current environment...
#warning ************  breakUndoCoalescing
    NSUndoManager * UM = [self undoManager];
    if(UM && ![UM isUndoing] && ![UM isRedoing])
    {
        NSRange selectedRange = [self selectedRange];
        NSRange R = selectedRange;
        if(R.location)
        {
            --R.location;
            R.length = 1;
            NSString * replacementString = [[self string] substringWithRange:R];
            BOOL wasUndoRegistrationEnabled = [UM isUndoRegistrationEnabled];
            [UM disableUndoRegistration];
            [self setSelectedRange:R];
            [self insertText:replacementString];
            [self setSelectedRange:selectedRange];
            if(wasUndoRegistrationEnabled)
                [UM enableUndoRegistration];
        }
    }
    return;
}
@end

@implementation NSText(iTM2TextKit_Highlight)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLine:
-(void)highlightAndScrollToVisibleLine:(unsigned int)aLine column:(unsigned int)column;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [[self string] rangeForLine:aLine nextLine:nil];
	if(R.location != NSNotFound)
	{
		if((column != NSNotFound ) && (column < R.length + 1))
		{
			R.location += column;
			R.length = 1;
		}
		[self highlightAndScrollToVisibleRange:R];
	}
	else
	{
		iTM2_LOG(@"Line %i out of bounds", aLine);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLine:
-(void)highlightAndScrollToVisibleLine:(unsigned int)aLine;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange R = [[self string] rangeForLine:aLine nextLine:nil];
    if(R.location != NSNotFound)
        [self highlightAndScrollToVisibleRange:R];
	else
	{
		iTM2_LOG(@"Line %i out of bounds", aLine);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLineRange:
-(void)highlightAndScrollToVisibleLineRange:(NSRange)aLineRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self highlightAndScrollToVisibleRange:[[self string] rangeForLineRange:aLineRange nextLine:nil]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleRange:
-(void)highlightAndScrollToVisibleRange:(NSRange)aRange;
/*"Description forthcoming. The receiver is the first responder as side effect.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [self string];
    aRange = NSIntersectionRange(aRange, NSMakeRange(0, [S length]));
    [self scrollRangeToVisible:aRange];
    [self highlightRange:aRange cleanBefore:YES];
	[self setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightRange:cleanBefore:
-(void)highlightRange:(NSRange)aRange cleanBefore:(BOOL)aFlag;
/*"Does nothing. Subclasses will do the job.
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  secondaryHighlightAtIndices:lengths:
-(void)secondaryHighlightAtIndices:(NSArray * )indices lengths:(NSArray *)lengths;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
@end

@interface NSTextView_iTM2TextKit_Highlight: NSTextView
@end
@implementation NSTextView_iTM2TextKit_Highlight
+(void)load;
{
	[self poseAsClass:[NSTextView class]];
	return;
}
-(void)didChangeText;
{
	[self highlightRange:NSMakeRange(0, 0) cleanBefore:YES];
	[super didChangeText];
	return;
}
@end

@implementation NSTextView(iTM2TextKit_Highlight)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertStringArray:
-(void)insertStringArray:(NSArray *)textArray;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"textArray is: %@", textArray);
	NSMutableArray * rangeArray = [NSMutableArray array];
	NSEnumerator * E = [textArray objectEnumerator];
	NSString * S;// not always an NSString but...
mainLoop:
	if(S = [E nextObject])
	{
		if([S isKindOfClass:[NSString class]])
		{
			if([S isEqualToString:iTM2TextInsertionAnchorKey])
			{
				NSRange R = [self selectedRange];
subLoop:
				if(S = [E nextObject])
				{
					if([S isKindOfClass:[NSString class]])
					{
						if([S isEqualToString:iTM2TextInsertionAnchorKey])
						{
							R.length = [self selectedRange].location - R.location;
							[rangeArray addObject:[NSValue valueWithRange:R]];
							goto mainLoop;
						}
						else
						{
							[self insertText:S];
						}
						goto subLoop;
					}
					else
					{
						iTM2_LOG(@"Ignored object: %@", S);
					}
				}
				R.length = 0;
				[rangeArray addObject:[NSValue valueWithRange:R]];
			}
			else
			{
				[self insertText:S];
			}
			goto mainLoop;
		}
		else
		{
			iTM2_LOG(@"Ignored object: %@", S);
		}
	}
//iTM2_LOG(@"rangeArray is: %@", rangeArray);
	if([rangeArray count])
		[self setSelectedRanges:rangeArray];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendSelectionWithRange:
-(void)extendSelectionWithRange:(NSRange)range;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setSelectedRanges:[[self selectedRanges] arrayByAddingObject:[NSValue valueWithRange:range]]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  breakTypingFlow
-(void)breakTypingFlow;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // find what is the name of the current environment...
#warning ************  breakUndoCoalescing
	if([self respondsToSelector:@selector(breakUndoCoalescing)])
		[self breakUndoCoalescing];
	else
		[super breakTypingFlow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= visibleRange
-(NSRange)visibleRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRect rect = [self visibleRect];
    unsigned topLeftIndex = [self characterIndexForPoint:
        [[self window] convertBaseToScreen:
            [self convertPoint:NSMakePoint(NSMinX(rect), NSMinY(rect))
                toView: nil]]];
    unsigned botRightIndex = [self characterIndexForPoint:
        [[self window] convertBaseToScreen:
            [self convertPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect))
                toView: nil]]];
    if(topLeftIndex>botRightIndex)
        [NSException raise:NSGenericException format:@"%@ view not flipped", __PRETTY_FUNCTION__];
    return NSMakeRange(topLeftIndex, botRightIndex - topLeftIndex);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightRange:cleanBefore:
-(void)highlightRange:(NSRange)aRange cleanBefore:(BOOL)aFlag;
/*"Does nothing. Subclasses will do the job.
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSLayoutManager * LM = [self layoutManager];
    NSString * S = [self string];
    NSRange R = NSMakeRange(0, [S length]);
    aRange = NSIntersectionRange(aRange, R);
    [LM removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:R];
	if(aRange.length)
		[LM addTemporaryAttributes:
			[NSDictionary dictionaryWithObject:[NSColor textRangeHighlightColor]
				forKey: NSBackgroundColorAttributeName]
					forCharacterRange: aRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  secondaryHighlightAtIndices:lengths:
-(void)secondaryHighlightAtIndices:(NSArray * )indices lengths:(NSArray *)lengths;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E1 = [[[[self layoutManager] textStorage] layoutManagers] objectEnumerator];
    NSLayoutManager * LM;
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSColor secondarySelectedControlColor], NSBackgroundColorAttributeName, nil];
	NSRange R = NSMakeRange(0, 0);
    while (LM = [E1 nextObject])
    {
		R.length = [[[self layoutManager] textStorage] length];
		[LM removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:R];
		R.length = 1;
        id O;
        NSEnumerator * E2 = [indices objectEnumerator];
        while(O = [E2 nextObject])
        {
            R.location = [O intValue];
            [LM addTemporaryAttributes:attributes forCharacterRange:R];
        }
        E2 = [lengths objectEnumerator];
        while(O = [E2 nextObject])
        {
            [LM addTemporaryAttributes:attributes forCharacterRange:[O rangeValue]];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomIn:
-(void)doZoomIn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float f = [self contextFloatForKey:@"iTM2ZoomFactor"]>0?:1.259921049895;
 	if(f>0)
		[self setScaleFactor:f * [self scaleFactor]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
-(void)doZoomOut:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float f = [self contextFloatForKey:@"iTM2ZoomFactor"]>0?:1.259921049895;
	if(f>0)
		[self setScaleFactor:[self scaleFactor] / f];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  actualSize:
-(IBAction)actualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setScaleFactor:1.0];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateActualSize:
-(BOOL)validateActualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self scaleFactor] != 1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scaleFactor
-(float)scaleFactor;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float frameWidth = [self frame].size.width;
	float boundsWidth = [self bounds].size.width;
    return boundsWidth>0? frameWidth / boundsWidth: 0.00001;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScaleFactor:
-(void)setScaleFactor:(float)aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(aMagnification>0);
	if(aMagnification != [self scaleFactor])
	{
		NSSize oldSize = [self frame].size;
		NSSize newSize = oldSize;
		newSize.width /= aMagnification;
		newSize.height /= aMagnification;
		[self setBoundsSize:newSize];
		newSize = oldSize;
		newSize.width += 1;
		newSize.height += 1;
		[self setFrameSize:newSize];
		[self setFrameSize:oldSize];
		[[self enclosingScrollView]setNeedsDisplay:YES];
	}
	[self takeContextFloat:aMagnification forKey:@"iTM2TextScaleFactor"];
    return;
}
@end

@implementation NSColor(iTM2TextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textRangeHighlightColor
+(NSColor *)textRangeHighlightColor;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSColor * color;
    return color? color: (color = [[NSColor colorWithCalibratedRed:1 green:0.75 blue:0.80 alpha:0.85] retain]);
}
@end

@implementation NSTextView(Placeholder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextPlaceholder:
-(IBAction)selectNextPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * selectedString = [S substringWithRange:selectedRange];
	NSString * tabAnchor = [self tabAnchor];
	NSArray * components = [selectedString componentsSeparatedByString:iTM2StartPlaceholder];
	if(([components count] == 2)
		&& ![[components objectAtIndex:0] length])
	{
		components = [[components objectAtIndex:1] componentsSeparatedByString:iTM2StopPlaceholder];
		if(([components count] == 2)
			&& ![[components objectAtIndex:1] length])
		{
			// This is exactly a place holder, we erase it
			[self insertText:@""];
			selectedRange.length = 0;
		}
	}
	else if([selectedString isEqual:tabAnchor])
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	unsigned top = [TS length];
	unsigned int anchor = NSMaxRange(selectedRange);
	NSRange searchRange, R1, R2, R3;
	if(anchor < top)
	{
		searchRange = NSMakeRange(anchor, top - anchor);
		R1 = [S rangeOfString:iTM2StartPlaceholder options:0L range:searchRange];
		if(R1.length)
		{
			searchRange = NSMakeRange(anchor, R1.location - anchor);
			R3 = [S rangeOfString:tabAnchor options:0L range:searchRange];
			if(R3.length)
			{
				[self setSelectedRange:R3];
				[self scrollRangeToVisible:[self selectedRange]];
				return;
			}
			unsigned int nextAnchor = NSMaxRange(R1);
			if(nextAnchor < top)
			{
				searchRange = NSMakeRange(nextAnchor, top - nextAnchor);
				R2 = [S rangeOfString:iTM2StopPlaceholder options:0L range:searchRange];
				if(R2.length)
				{
					[self setSelectedRange:NSMakeRange(R1.location, NSMaxRange(R2) - R1.location)];
					[self scrollRangeToVisible:[self selectedRange]];
					return;
				}
				else
				{
					searchRange = NSMakeRange(anchor, top - anchor);
					R3 = [S rangeOfString:tabAnchor options:0L range:searchRange];
					if(R3.length)
					{
						[self setSelectedRange:R3];
						[self scrollRangeToVisible:[self selectedRange]];
						return;
					}
				}
			}
		}
		R3 = [S rangeOfString:tabAnchor options:0L range:searchRange];
		if(R3.length)
		{
			[self setSelectedRange:R3];
			[self scrollRangeToVisible:[self selectedRange]];
			return;
		}
		searchRange = NSMakeRange(0, anchor+1);
	}
	else
	{
		searchRange = NSMakeRange(0, anchor);
	}
	R1 = [S rangeOfString:iTM2StartPlaceholder options:0L range:searchRange];
	if(R1.length)
	{
		searchRange = NSMakeRange(0, R1.location);
		R3 = [S rangeOfString:tabAnchor options:0L range:searchRange];
		if(R3.length)
		{
			[self setSelectedRange:R3];
			[self scrollRangeToVisible:[self selectedRange]];
			return;
		}
		unsigned int nextAnchor = NSMaxRange(R1);
		if(nextAnchor < top)
		{
			searchRange = NSMakeRange(nextAnchor, top - nextAnchor);
			R2 = [S rangeOfString:iTM2StopPlaceholder options:0L range:searchRange];
			if(R2.length)
			{
				[self setSelectedRange:NSMakeRange(R1.location, NSMaxRange(R2) - R1.location)];
				[self scrollRangeToVisible:[self selectedRange]];
				return;
			}
			else
			{
				searchRange = NSMakeRange(0, anchor+1);
			}
		}
	}
	R3 = [S rangeOfString:tabAnchor options:0L range:searchRange];
	if(R3.length)
	{
		[self setSelectedRange:R3];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousPlaceholder:
-(IBAction)selectPreviousPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * tabAnchor = [self tabAnchor];
	NSString * selectedString = [S substringWithRange:selectedRange];
	NSArray * components = [selectedString componentsSeparatedByString:iTM2StartPlaceholder];
	if(([components count] == 2)
		&& ![[components objectAtIndex:0] length])
	{
		components = [[components objectAtIndex:1] componentsSeparatedByString:iTM2StopPlaceholder];
		if(([components count] == 2)
			&& ![[components objectAtIndex:1] length])
		{
			// This is exactly a place holder, we erase it
			[self insertText:@""];
			selectedRange.length = 0;
		}
	}
	else if([selectedString isEqual:tabAnchor])
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	unsigned top = [TS length];
	unsigned int anchor = selectedRange.location;
	NSRange searchRange, R1, R2, R3;
	if(anchor)
	{
		searchRange = NSMakeRange(0, anchor);
		R2 = [S rangeOfString:iTM2StopPlaceholder options:NSBackwardsSearch range:searchRange];
		if(R2.length)
		{
			searchRange.location = NSMaxRange(R2);
			searchRange.length = anchor - searchRange.location;
			R3 = [S rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
			if(R3.length)
			{
				[self setSelectedRange:R3];
				[self scrollRangeToVisible:[self selectedRange]];
				return;
			}
			else if(R2.location > 1)
			{
				searchRange = NSMakeRange(0, R2.location - 2);
				R1 = [S rangeOfString:iTM2StartPlaceholder options:NSBackwardsSearch range:searchRange];
				if(R1.length)
				{
					[self setSelectedRange:NSMakeRange(R1.location, NSMaxRange(R2) - R1.location)];
					[self scrollRangeToVisible:[self selectedRange]];
					return;
				}
			}
		}
		else
		{
			R3 = [S rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
			if(R3.length)
			{
				[self setSelectedRange:R3];
				[self scrollRangeToVisible:[self selectedRange]];
				return;
			}
		}
		searchRange = NSMakeRange(--anchor, top - anchor);
	}
	else
		searchRange = NSMakeRange(anchor, top - anchor);
	R2 = [S rangeOfString:iTM2StopPlaceholder options:NSBackwardsSearch range:searchRange];
	if(R2.length)
	{
		searchRange.location = NSMaxRange(R2);
		searchRange.length = top - searchRange.location;
		R3 = [S rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(R3.length)
		{
			[self setSelectedRange:R3];
			[self scrollRangeToVisible:[self selectedRange]];
			return;
		}
		else if(R2.location > 1)
		{
			searchRange = NSMakeRange(0, R2.location - 2);
			R1 = [S rangeOfString:iTM2StartPlaceholder options:NSBackwardsSearch range:searchRange];
			if(R1.length)
			{
				[self setSelectedRange:NSMakeRange(R1.location, NSMaxRange(R2) - R1.location)];
				[self scrollRangeToVisible:[self selectedRange]];
				return;
			}
		}
	}
	else
	{
		R3 = [S rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(R3.length)
		{
			[self setSelectedRange:R3];
			[self scrollRangeToVisible:[self selectedRange]];
			return;
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchorKey
+(NSString *)tabAnchorKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2UDTabAnchorStringKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
-(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [SUD stringForKey:[[self class] tabAnchorKey]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextTabAnchor:
-(void)selectNextTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [self string];
    int anchor = NSMaxRange([self selectedRange]);
    NSString * anchorString = [self tabAnchor];
    NSRange foundRange = [S rangeOfString:anchorString options:0 range:NSMakeRange(anchor, [S length] - anchor)];
    if(!foundRange.length)
        foundRange = [S rangeOfString:anchorString options:0
                            range: NSMakeRange(0, MIN([S length], anchor + [anchorString length] - 1))];
    if(!foundRange.length)
    {
        foundRange = NSMakeRange(NSMaxRange([self selectedRange]), 0);
        [self postNotificationWithToolTip:
            [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"No %@ tab anchor found.",
                @"TeX", [NSBundle bundleForClass:[self class]],
                    @"Status displayed when navigating within tab anchors."), anchorString]];
        iTM2Beep();
        [self setSelectedRange:NSMakeRange(anchor, 0)];
    }
    else
        [self setSelectedRange:foundRange];
    [self scrollRangeToVisible:foundRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextTabAnchorAndDelete:
-(void)selectNextTabAnchorAndDelete:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/21/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self selectNextTabAnchor:sender];
    if([self selectedRange].length) [self deleteBackward:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousTabAnchorAndDelete:
-(void)selectPreviousTabAnchorAndDelete:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/21/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self selectPreviousTabAnchor:sender];
    if([self selectedRange].length) [self deleteBackward:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousTabAnchor:
-(void)selectPreviousTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [self string];
    int anchor = [self selectedRange].location;
    NSString * anchorString = [self tabAnchor];
    NSRange foundRange = [S rangeOfString:anchorString options:NSBackwardsSearch
                                range: NSMakeRange(0, anchor)];
    if(!foundRange.length)
    {
        anchor = (anchor < [iTM2TextTabAnchorKey length])? 0:anchor - [anchorString length] + 1;
        foundRange = [S rangeOfString:anchorString options:NSBackwardsSearch
                            range: NSMakeRange(anchor, [S length] - anchor)];
    }
    if(!foundRange.length)
    {
        foundRange = NSMakeRange([self selectedRange].location, 0);
        [self postNotificationWithToolTip:
            [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"No %@ tab anchor found.",
                @"TeX", [NSBundle bundleForClass:[self class]],
                    @"Status displayed when navigating within tab anchors."), anchorString]];
        iTM2Beep();
    }
    [self setSelectedRange:foundRange];
    [self scrollRangeToVisible:foundRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cachedSelection
-(NSString *)cachedSelection;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self string] substringWithRange:[self selectedRange]];
}
@end

@implementation NSString(iTM2Placeholder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:
-(NSRange)rangeOfPlaceholderAtIndex:(unsigned)index;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation two
Version history: jlaurens@users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(index < [self length])
	{
		NSRange searchRange;
		searchRange.location = index >= [iTM2StopPlaceholder length] - 1?
									index - [iTM2StopPlaceholder length] - 1:index;
		searchRange.length = [self length] - searchRange.location;
		NSRange stopR = [self rangeOfString:iTM2StopPlaceholder options:0L range:searchRange];
		if(stopR.location == NSNotFound)
			return stopR;
		searchRange = NSMakeRange(0, stopR.location);
		NSRange startR = [self rangeOfString:iTM2StartPlaceholder options:NSBackwardsSearch range:searchRange];
		if(startR.location == NSNotFound)
			return startR;
		if((startR.location <= index) && (index < NSMaxRange(stopR)))
			return NSMakeRange(startR.location, NSMaxRange(stopR) - startR.location);
	}
//iTM2_END;
	return NSMakeRange(NSNotFound, 0);
}
@end

@interface iTM2AttributedString_0: NSAttributedString
@end
@implementation iTM2AttributedString_0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+(void)load;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation two
Version history: jlaurens@users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2AttributedString_0 poseAsClass:[NSAttributedString class]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
-(NSRange)doubleClickAtIndex:(unsigned)index;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation two
Version history: jlaurens@users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"[super doubleClickAtIndex:%i]:%@", index, NSStringFromRange(R));
	if([iTM2EventObserver isAlternateKeyDown])
		return [super doubleClickAtIndex:index];
	NSRange otherRange = [[self string] rangeOfPlaceholderAtIndex:index];
//iTM2_END;
	return otherRange.length? otherRange: [super doubleClickAtIndex:index];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextKit

