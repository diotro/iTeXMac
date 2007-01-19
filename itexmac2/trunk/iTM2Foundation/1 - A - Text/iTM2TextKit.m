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
//  Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA.
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
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import "limits.h"

NSString * const iTM2TextMarkPlaceholder = @"__";
NSString * const iTM2TextStartPlaceholder = @"__(";
NSString * const iTM2TextStopPlaceholder = @")__";
NSString * const iTM2TextStartARGPlaceholder = @"__(ARG:";
NSString * const iTM2TextStartOPTPlaceholder = @"__(OPT:";
NSString * const iTM2TextStartTEXTPlaceholder = @"__(TEXT:";
NSString * const iTM2TextStartFILEPlaceholder = @"__(FILE:";
NSString * const iTM2TextStartTIPPlaceholder = @"__(TIP:";
NSString * const iTM2TextINSPlaceholder = @"__(INS)__";
NSString * const iTM2TextSELPlaceholder = @"__(SEL)__";// out of use with perl support
NSString * const iTM2TextTABPlaceholder = @"__(TAB)__";

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextKit
/*"Description forthcoming."*/
@implementation NSText(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSelectionQuickly:
- (void)openSelectionQuickly:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THIS IS BUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGY!!!!!!!!!!!!! MAKE IT A SEPARATE RESPONDER
    NSString * S = [[self string] substringWithRange:[self selectedRange]];
	if([S hasPrefix:iTM2PathComponentsSeparator])
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
- (void)breakTypingFlow;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // find what is the name of the current environment...
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLine:column:length:
- (void)highlightAndScrollToVisibleLine:(unsigned int)aLine column:(unsigned int)column length:(unsigned int)length;
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
			R.length = MIN(R.length,length);
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
- (void)highlightAndScrollToVisibleLine:(unsigned int)aLine;
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
- (void)highlightAndScrollToVisibleLineRange:(NSRange)aLineRange;
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
- (void)highlightAndScrollToVisibleRange:(NSRange)aRange;
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
- (void)highlightRange:(NSRange)aRange cleanBefore:(BOOL)aFlag;
/*"Does nothing. Subclasses will do the job.
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  secondaryHighlightAtIndices:lengths:
- (void)secondaryHighlightAtIndices:(NSArray * )indices lengths:(NSArray *)lengths;
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

NSString * const iTM2TextIndentationStringKey= @"iTM2TextIndentationString";
NSString * const iTM2TextNumberOfSpacesPerTabKey= @"iTM2TextNumberOfSpacesPerTab";

@interface NSTextView_iTM2TextKit_Highlight: NSTextView
@end
@implementation NSTextView_iTM2TextKit_Highlight
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
{
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
	[self poseAsClass:[NSTextView class]];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString bullet], iTM2TextTabAnchorStringKey,
            @"   ", iTM2TextIndentationStringKey,
            [NSNumber numberWithUnsignedInt:4], iTM2TextNumberOfSpacesPerTabKey,
                nil]];
	iTM2_RELEASE_POOL;
	return;
}
- (void)didChangeText;
{
	[self highlightRange:NSMakeRange(0, 0) cleanBefore:YES];
	[super didChangeText];
	return;
}
@end

@implementation NSTextView(iTM2TextKit_Highlight)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertStringArray:
- (void)insertStringArray:(NSArray *)textArray;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"textArray is: %@", textArray);
    [self breakTypingFlow];
	NSMutableArray * rangeArray = [NSMutableArray array];
	NSEnumerator * E = [textArray objectEnumerator];
	NSString * S;// not always an NSString but...
mainLoop:
	if(S = [E nextObject])
	{
		if([S isKindOfClass:[NSString class]])
		{
			if([S isEqualToString:iTM2TextINSPlaceholder])
			{
				NSRange R = [self selectedRange];
subLoop:
				if(S = [E nextObject])
				{
					if([S isKindOfClass:[NSString class]])
					{
						if([S isEqualToString:iTM2TextINSPlaceholder])
						{
							R.length = [self selectedRange].location-R.location;
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
    [self breakTypingFlow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendSelectionWithRange:
- (void)extendSelectionWithRange:(NSRange)range;
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
- (void)breakTypingFlow;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self respondsToSelector:@selector(breakUndoCoalescing)])
		[self breakUndoCoalescing];
	else
		[super breakTypingFlow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= visibleRange
- (NSRange)visibleRange;
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
    return NSMakeRange(topLeftIndex, botRightIndex-topLeftIndex);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightRange:cleanBefore:
- (void)highlightRange:(NSRange)aRange cleanBefore:(BOOL)aFlag;
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
- (void)secondaryHighlightAtIndices:(NSArray * )indices lengths:(NSArray *)lengths;
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
- (void)doZoomIn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float f = [self contextFloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895;
 	if(f>0)
		[self setScaleFactor:f * [self scaleFactor]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
- (void)doZoomOut:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float f = [self contextFloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895;
	if(f>0)
		[self setScaleFactor:[self scaleFactor] / f];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  actualSize:
- (IBAction)actualSize:(id)sender;
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
- (BOOL)validateActualSize:(id)sender;
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
- (float)scaleFactor;
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
- (void)setScaleFactor:(float)aMagnification;
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
	[self takeContextFloat:aMagnification forKey:@"iTM2TextScaleFactor" domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willChangeSelectedRanges
- (void)willChangeSelectedRanges;
/*"Register the actual selected ranges for an eventual undo action.
Wen undoing a will action becomes a did acion and conversely.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
iTM2_START;
	NSArray * actualSelectedRange = [self selectedRanges];
	NSUndoManager * UM = [self undoManager];
	[UM registerUndoWithTarget:self selector:@selector(setSelectedRanges:) object:actualSelectedRange];
	[UM registerUndoWithTarget:self selector:@selector(didChangeSelectedRanges) object:nil];
iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didChangeSelectedRanges
- (void)didChangeSelectedRanges;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
iTM2_START;
	NSUndoManager * UM = [self undoManager];
	[UM registerUndoWithTarget:self selector:@selector(willChangeSelectedRanges) object:nil];
iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indentationString
- (NSString *)indentationString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [SUD contextStringForKey:iTM2TextIndentationStringKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indentSelection:
- (void)indentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0:
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * indentationString = [self indentationString];
	unsigned int numberOfSpaces = ([indentationString length] > 1)?
			[indentationString length]:
				[self contextIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
	NSString * affectedString;
	NSRange affectedRange;
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSString * replacementString;
	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSMutableDictionary * replacementStringsHash = [NSMutableDictionary dictionary];
	NSString * S = [self string];
	NSMutableArray * selectedRanges = [[[self selectedRanges] mutableCopy] autorelease];
	NSRange selectedRange;
	NSCharacterSet * blackCharacterSet = [NSCharacterSet whitespaceCharacterSet];
	blackCharacterSet = [blackCharacterSet invertedSet];
	NSMutableArray * newSelectedRanges = [NSMutableArray array];
	// 1-Prepare the affected ranges and replacement strings
	NSEnumerator * E = [selectedRanges objectEnumerator];
	NSValue * V;
	while(V = [E nextObject])
	{
		selectedRange = [V rangeValue];
		unsigned int nextStart,contentsEnd,top;
		top = NSMaxRange(selectedRange);
		selectedRange.length = 0;
		[S getLineStart:&selectedRange.location end:&nextStart contentsEnd:&contentsEnd forRange:selectedRange];
		affectedRange.location = selectedRange.location;
nextLine:
		affectedRange.length = nextStart-affectedRange.location;// search range
		NSRange R = [S rangeOfCharacterFromSet:blackCharacterSet options:nil range:affectedRange];
		affectedRange.length = (R.length>0?R.location:contentsEnd)-affectedRange.location;
		V = [NSValue valueWithRange:affectedRange];
		if(![affectedRanges containsObject:V])
		{
			[affectedRanges addObject:V];
			if(affectedRange.length>0)
			{
				// this line was already indented
				// parse the previous indentation then add our own.
				affectedString = [S substringWithRange:affectedRange];
				id components = [affectedString componentsSeparatedByString:indentationString];
				unsigned count = [components count];
				// if the line header was consistent, the actual number of tabs would be one less than the number of objects in components
				// and all the object of components would be 0 lengthed
				NSEnumerator * EE = [components objectEnumerator];
				NSString * component = nil;
				while(component = [EE nextObject])
				{
					count += [component length]/numberOfSpaces;
				}
				components = [NSMutableArray arrayWithCapacity:count];
				while(count--)
				{
					[components addObject:indentationString];
				}
				replacementString = [components componentsJoinedByString:@""];
			}
			else
			{
				// this line was not indented, just add our own indentation
				replacementString = indentationString;
			}
			[replacementStringsHash setObject:replacementString forKey:V];
		}
		if(nextStart<top)
		{
			affectedRange.location = nextStart;// what about the next line
			affectedRange.length = 0;// search range
			[S getLineStart:nil end:&nextStart contentsEnd:&contentsEnd forRange:affectedRange];
			goto nextLine;
		}
		selectedRange.length = nextStart-selectedRange.location;
		V = [NSValue valueWithRange:selectedRange];
		[newSelectedRanges addObject:V];
	}
	if(![affectedRanges count])
	{
		return;
	}
	// 2-Order the affected ranges
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"locationValueOfRangeValue" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	[affectedRanges sortUsingDescriptors:sortDescriptors];
	// 3-Order the replacement string
	replacementStrings = [NSMutableArray arrayWithCapacity:[affectedRanges count]];
	E = [affectedRanges objectEnumerator];
	while(V = [E nextObject])
	{
		if(replacementString = [replacementStringsHash objectForKey:V])
		{
			[replacementStrings addObject:replacementString];
		}
		else
		{
			[replacementStrings addObject:@""];
			iTM2_LOG(@"**** There is an awful BUG, some value has disappeared in a dictionary, using a void string instead...");
		}
	}
	// 4-Alter the new selected ranges
	NSEnumerator * EE;
	E = [affectedRanges reverseObjectEnumerator];
	while(V = [E nextObject])
	{
		if(replacementString = [replacementStringsHash objectForKey:V])
		{
			affectedRange = [V rangeValue];
			EE = [newSelectedRanges objectEnumerator];
			newSelectedRanges = [NSMutableArray arrayWithArray:newSelectedRanges];
			while(V = [EE nextObject])
			{
				selectedRange = [V rangeValue];
				if(NSMaxRange(selectedRange)<=affectedRange.location)
				{
					// no influence
				}
				else if(affectedRange.location<selectedRange.location)
				{
					[newSelectedRanges removeObject:V];
					selectedRange.location += [replacementString length]-affectedRange.length;
					V = [NSValue valueWithRange:selectedRange];
					[newSelectedRanges addObject:V];
				}
				else
				{
					[newSelectedRanges removeObject:V];
					selectedRange.length += [replacementString length]-affectedRange.length;
					V = [NSValue valueWithRange:selectedRange];
					[newSelectedRanges addObject:V];
				}
			}
		}
	}
	// 5-Process
	[self willChangeSelectedRanges];
	if([self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		E = [affectedRanges reverseObjectEnumerator];
		EE = [replacementStrings reverseObjectEnumerator];
		while(V = [E nextObject])
		{
			if(replacementString = [EE nextObject])
			{
				affectedRange = [V rangeValue];
				[self replaceCharactersInRange:affectedRange withString:replacementString];
			}
			else
			{
				iTM2_LOG(@"**** There is an awful BUG, affectedRanges and replacementStrings are not consistent...");
			}
		}
		[self didChangeText];
		[self setSelectedRanges:newSelectedRanges];
	}
	[self didChangeSelectedRanges];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unindentSelection:
- (void)unindentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * indentationString = [self indentationString];
	unsigned int numberOfSpaces = ([indentationString length] > 1)?
			[indentationString length]:
				[self contextIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
	NSString * affectedString;
	NSRange affectedRange;
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSString * replacementString;
	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSMutableDictionary * replacementStringsHash = [NSMutableDictionary dictionary];
	NSString * S = [self string];
	NSMutableArray * selectedRanges = [[[self selectedRanges] mutableCopy] autorelease];
	NSRange selectedRange;
	NSCharacterSet * blackCharacterSet = [NSCharacterSet whitespaceCharacterSet];
	blackCharacterSet = [blackCharacterSet invertedSet];
	NSMutableArray * newSelectedRanges = [NSMutableArray array];
	// 1-Prepare the affected ranges and replacement strings
	NSEnumerator * E = [selectedRanges objectEnumerator];
	NSValue * V;
	while(V = [E nextObject])
	{
		selectedRange = [V rangeValue];
		unsigned int nextStart,contentsEnd,top;
		top = NSMaxRange(selectedRange);
		selectedRange.length = 0;
		[S getLineStart:&selectedRange.location end:&nextStart contentsEnd:&contentsEnd forRange:selectedRange];
		affectedRange.location = selectedRange.location;
nextLine:
		affectedRange.length = nextStart-affectedRange.location;// search range
		NSRange R = [S rangeOfCharacterFromSet:blackCharacterSet options:nil range:affectedRange];
		affectedRange.length = (R.length>0?R.location:contentsEnd)-affectedRange.location;
		if(affectedRange.length>0)
		{
			V = [NSValue valueWithRange:affectedRange];
			if(![affectedRanges containsObject:V])
			{
				[affectedRanges addObject:V];
				// this line was already indented
				// parse the previous indentation then remove our own.
				affectedString = [S substringWithRange:affectedRange];
				id components = [affectedString componentsSeparatedByString:indentationString];
				unsigned count = [components count];
				// if the line header was consistent, the actual number of tabs would be one less than the number of objects in components
				// and all the object of components would be 0 lengthed
				NSEnumerator * EE = [components objectEnumerator];
				NSString * component = nil;
				while(component = [EE nextObject])
				{
					count += [component length]/numberOfSpaces;
				}
				components = [NSMutableArray arrayWithCapacity:count];
				while(count--)
				{
					[components addObject:indentationString];
				}
				[components removeLastObject];
				[components removeLastObject];
				replacementString = [components componentsJoinedByString:@""];
				[replacementStringsHash setObject:replacementString forKey:V];
			}
		}
		if(nextStart<top)
		{
			affectedRange.location = nextStart;// what about the next line
			affectedRange.length = 0;// search range
			[S getLineStart:nil end:&nextStart contentsEnd:&contentsEnd forRange:affectedRange];
			goto nextLine;
		}
		selectedRange.length = nextStart-selectedRange.location;
		V = [NSValue valueWithRange:selectedRange];
		[newSelectedRanges addObject:V];
	}
	if(![affectedRanges count])
	{
		return;
	}
	// 2-Order the affected ranges
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"locationValueOfRangeValue" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	[affectedRanges sortUsingDescriptors:sortDescriptors];
	// 3-Order the replacement string
	replacementStrings = [NSMutableArray arrayWithCapacity:[affectedRanges count]];
	E = [affectedRanges objectEnumerator];
	while(V = [E nextObject])
	{
		if(replacementString = [replacementStringsHash objectForKey:V])
		{
			[replacementStrings addObject:replacementString];
		}
		else
		{
			[replacementStrings addObject:@""];
			iTM2_LOG(@"**** There is an awful BUG, some value has disappeared in a dictionary, using a void string instead...");
		}
	}
	// 4-Alter the new selected ranges
	NSEnumerator * EE;
	E = [affectedRanges reverseObjectEnumerator];
	while(V = [E nextObject])
	{
		if(replacementString = [replacementStringsHash objectForKey:V])
		{
			affectedRange = [V rangeValue];
			EE = [newSelectedRanges objectEnumerator];
			newSelectedRanges = [NSMutableArray arrayWithArray:newSelectedRanges];
			while(V = [EE nextObject])
			{
				selectedRange = [V rangeValue];
				if(NSMaxRange(selectedRange)<=affectedRange.location)
				{
					// no influence
				}
				else if(affectedRange.location<selectedRange.location)
				{
					[newSelectedRanges removeObject:V];
					selectedRange.location += [replacementString length]-affectedRange.length;
					V = [NSValue valueWithRange:selectedRange];
					[newSelectedRanges addObject:V];
				}
				else
				{
					[newSelectedRanges removeObject:V];
					selectedRange.length += [replacementString length]-affectedRange.length;
					V = [NSValue valueWithRange:selectedRange];
					[newSelectedRanges addObject:V];
				}
			}
		}
	}
	// 5-Process
	[self willChangeSelectedRanges];
	if([self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		E = [affectedRanges reverseObjectEnumerator];
		EE = [replacementStrings reverseObjectEnumerator];
		while(V = [E nextObject])
		{
			if(replacementString = [EE nextObject])
			{
				affectedRange = [V rangeValue];
				[self replaceCharactersInRange:affectedRange withString:replacementString];
			}
			else
			{
				iTM2_LOG(@"**** There is an awful BUG, affectedRanges and replacementStrings are not consistent...");
			}
		}
		[self didChangeText];
		[self setSelectedRanges:newSelectedRanges];
	}
	[self didChangeSelectedRanges];
//iTM2_END;
    return;
}
@end

@implementation NSValue(iTM2Location)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= locationValueOfRangeValue
- (NSNumber *)locationValueOfRangeValue; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self rangeValue];
//iTM2_END;
	return [NSNumber numberWithInt:range.location];
}
@end

@implementation NSLayoutManager(iTM2TextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lineFragmentCharacterRangeForCharacterRange:withoutAdditionalLayout:
- (NSRange)lineFragmentCharacterRangeForCharacterRange:(NSRange)range withoutAdditionalLayout:(BOOL)yorn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	range = [self glyphRangeForCharacterRange:range actualCharacterRange:nil];
	unsigned int index = NSMaxRange(range)-1;
	if(index>range.location)
	{
		[self lineFragmentUsedRectForGlyphAtIndex:range.location effectiveRange:&range withoutAdditionalLayout:yorn];
		NSRange range1;
		[self lineFragmentUsedRectForGlyphAtIndex:index effectiveRange:&range1 withoutAdditionalLayout:yorn];
//iTM2_END;
		return NSUnionRange(range,range1);
	}
	else
	{
		[self lineFragmentUsedRectForGlyphAtIndex:range.location effectiveRange:&range withoutAdditionalLayout:yorn];
//iTM2_END;
		return range;
	}
}
@end

@implementation NSColor(iTM2TextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textRangeHighlightColor
+ (NSColor *)textRangeHighlightColor;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectFirstPlaceholder:
- (IBAction)selectFirstPlaceholder:(id)sender;
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
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	markRange = [S rangeOfPlaceholderFromIndex:0 cycle:NO tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextPlaceholder:
- (IBAction)selectNextPlaceholder:(id)sender;
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
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousPlaceholder:
- (IBAction)selectPreviousPlaceholder:(id)sender;
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
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	markRange = [S rangeOfPlaceholderToIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchorKey
+ (NSString *)tabAnchorKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextTabAnchorStringKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
- (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextStringForKey:[[self class] tabAnchorKey] domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfSpacesPerTab
- (unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextTabAnchor:
- (void)selectNextTabAnchor:(id)sender;
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
    NSRange foundRange = [S rangeOfString:anchorString options:0 range:NSMakeRange(anchor, [S length]-anchor)];
    if(!foundRange.length)
        foundRange = [S rangeOfString:anchorString options:0
                            range: NSMakeRange(0, MIN([S length], anchor + [anchorString length]-1))];
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
- (void)selectNextTabAnchorAndDelete:(id)sender;
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
- (void)selectPreviousTabAnchorAndDelete:(id)sender;
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
- (void)selectPreviousTabAnchor:(id)sender;
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
        anchor = (anchor < [iTM2TextTABPlaceholder length])? 0:anchor-[anchorString length] + 1;
        foundRange = [S rangeOfString:anchorString options:NSBackwardsSearch
                            range: NSMakeRange(anchor, [S length]-anchor)];
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
- (NSString *)cachedSelection;
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

@implementation NSString(iTM2TextPlaceholder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingTipPlaceHolders
- (NSString *)stringByRemovingTipPlaceHolders;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [self rangeOfString:iTM2TextStartTIPPlaceholder];
	if(R.length)
	{
		R = [self rangeOfPlaceholderAtIndex:R.location];
		NSRange r;
		r.location = NSMaxRange(R);
		r.length = [self length] - r.location;
		NSString * avant = [self substringWithRange:r];
		r = NSMakeRange(0,R.location);
		NSString * apres = [self substringWithRange:r];
		avant = [avant length]? ([apres length]?[avant stringByAppendingString:apres]:avant):apres;
		return [avant stringByRemovingTipPlaceHolders];
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceHolderMarks
- (NSString *)stringByRemovingPlaceHolderMarks;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [[[self stringByRemovingTipPlaceHolders] mutableCopy] autorelease];
	[result replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartARGPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartOPTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartTEXTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartFILEPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStopPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceHolderMarksWithSelection:
- (NSString *)stringByRemovingPlaceHolderMarksWithSelection:(NSString *)selection;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [[[self stringByRemovingTipPlaceHolders] mutableCopy] autorelease];
	[result replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartARGPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartOPTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartTEXTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartFILEPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:(selection?selection:@"") options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStopPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringWithSelection:tabAnchor:indentationLevel:getSelectedRanges:
- (NSString *)stringWithSelection:(NSString *)selection tabAnchor:(NSString *)tabAnchor indentationLevel:(unsigned)level getSelectedRanges:(NSArray **)selectedRangesPtr;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[selection setIndentationLevel:0];
	NSMutableString * result = [[[self stringByRemovingTipPlaceHolders] mutableCopy] autorelease];
	[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:(selection?selection:@"") options:0 range:NSMakeRange(0,[result length])];
	[result setIndentationLevel:level];
	if(selectedRangesPtr)
	{
		*selectedRangesPtr = [NSMutableArray array];
		id components = [result componentsSeparatedByString:iTM2TextINSPlaceholder];
		// all the components represent selected ranges:
		// odd components are not selected
		// even components are selected
		NSEnumerator * E = [components objectEnumerator];
		NSString * component;
		NSRange R;
		NSValue * V;
		result = [NSMutableString string];
		if(component = [E nextObject])
		{
			// unselected component
			R.location = [component length];
			[result appendString:component];
			R.length = 0;
			if(component = [E nextObject])
			{
				// selected component
				R.length = [component length];
				[result appendString:component];
				V = [NSValue valueWithRange:R];
				[(NSMutableArray *)(*selectedRangesPtr) addObject:V];
				while(component = [E nextObject])
				{
					R.location = [component length];
					[result appendString:component];
					R.length = 0;
					if(component = [E nextObject])
					{
						R.length = [component length];
						[result appendString:component];\
						V = [NSValue valueWithRange:R];
						[(NSMutableArray *)(*selectedRangesPtr) addObject:V];
					}
				}
			}
			else if(![result hasSuffix:iTM2TextTABPlaceholder])
			{
				// nothing is selected, select the first placeholder
				R = [self rangeOfPlaceholderFromIndex:0 cycle:NO tabAnchor:tabAnchor];
				if(R.length)
				{
					if(NSMaxRange(R) < [self length])
					{
						[result appendString:iTM2TextTABPlaceholder];
					}
				}
				else
				{
					R = NSMakeRange(0,[self length]);
				}
				V = [NSValue valueWithRange:R];
				[(NSMutableArray *)(*selectedRangesPtr) addObject:V];
			}
		}
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	if(index>=length)
	{
		return NSMakeRange(NSNotFound,0);
	}
	NSRange stopR;
	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];

	unsigned idx;
	unsigned depth = 1;
	unsigned top = UINT_MAX;
	
	NSRange searchRange = NSMakeRange(0,0);
	searchRange.location = MAX(index,1)-1;
	
	NSRange markR;
nextMark:
	searchRange.length = length-searchRange.location;
	markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
	if(markR.length)
	{
		if(markR.location<top)
		{
			top = markR.location;
		}
		// is it a start?
		idx = NSMaxRange(markR);
		if(idx<length)
		{
			if([self characterAtIndex:idx] == startChar)
			{
				// it is a start place holder
				++depth;
				searchRange.location = NSMaxRange(markR);
				goto nextMark;
			}
		}
		if(markR.location)
		{
			if([self characterAtIndex:markR.location-1] == stopChar)
			{
				if(--depth)
				{
					// not yet
					searchRange.location = NSMaxRange(markR);
					goto nextMark;
				}
				else
				{
					searchRange.location = 0;
					searchRange.length = top-searchRange.location;
					stopR = markR;
					depth = 1;
previousMark:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);
						if((idx<length) && ([self characterAtIndex:idx] == startChar))
						{
							if(--depth)
							{
								// not yet
								searchRange.length = markR.location;
								goto nextMark;
							}
							else
							{
								return NSMakeRange(markR.location,NSMaxRange(stopR)-markR.location);
							}
						}
						if((markR.location) && ([self characterAtIndex:markR.location-1] == stopChar))
						{
							// it is a start place holder
							++depth;
						}
						searchRange.length = markR.location;
						goto previousMark;
					}
				}
			}
		}
		searchRange.location = NSMaxRange(markR);
		goto nextMark;
	}
	else
	{
		return NSMakeRange(NSNotFound, 0);
	}
//iTM2_END;
	return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderFromIndex:cycle:tabAnchor:
- (NSRange)rangeOfPlaceholderFromIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// next stop placeholder
	// preceding start placeholder
	// if the index is in an apropriate range, it's okay
	// start from the beginning if necessary
	NSRange stopR = NSMakeRange(NSNotFound,0);
	unsigned length = [self length];
	if(index>length)
	{
		return stopR;
	}
	NSRange searchRange = NSMakeRange(0,0);
	NSRange markR;
	// a TAB anchor?
	if([tabAnchor length])
	{
		searchRange.location = index;
		searchRange.length = length-searchRange.location;
		markR = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}

	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];

	unsigned idx;
	unsigned floor = 0;

	searchRange.location = MAX(index,2)-2;	
	searchRange.length = length-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		searchRange.location = floor;
		searchRange.length = stopR.location-searchRange.location;
previousMark:
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			// is it a start?
			idx = NSMaxRange(markR);// we do have idx < length!
			if([self characterAtIndex:idx]==startChar)
			{
				// it is a start place holder
				return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
			}
			// the first time, it can be a stop
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
nextStop:
				floor = NSMaxRange(stopR);
				searchRange.location = floor;
				searchRange.length = length-searchRange.location;
				stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
				if(stopR.length)
				{
					searchRange.location = floor;
					searchRange.length = stopR.location-searchRange.location;
morePreviousMark:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);// we do have idx < length!
						if([self characterAtIndex:idx]==startChar)
						{
							// it is a start place holder
							return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.length = markR.location-searchRange.location;
						goto morePreviousMark;
					}
					goto nextStop;
				}
				goto below;
			}
			searchRange.length = markR.location-searchRange.location;
			goto previousMark;
		}
		floor = NSMaxRange(stopR);
		searchRange.location = floor;
		goto nextStop;
	}
below:
	searchRange.length = length-searchRange.location;
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = 0;
	searchRange.length = index-searchRange.location;
	// a TAB anchor?
	if([tabAnchor length])
	{
		markR = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	searchRange.length = index-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		searchRange.length = stopR.location-searchRange.location;
previousMarkBefore:
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			// is it a start?
			idx = NSMaxRange(markR);
			if([self characterAtIndex:idx]==startChar)
			{
				// it is a start place holder
				return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
			}
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
nextStopBefore:
				searchRange.length = index-searchRange.location;
				stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
				if(stopR.length)
				{
					searchRange.length = stopR.location-searchRange.location;
morePreviousMarkBefore:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);
						if([self characterAtIndex:idx]==startChar)
						{
							// it is a start place holder
							return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.length = markR.location-searchRange.location;
						goto morePreviousMarkBefore;
					}
					searchRange.location = NSMaxRange(stopR);
					goto nextStopBefore;
				}
				goto final;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.length = markR.location-searchRange.location;
			goto previousMarkBefore;
		}
		searchRange.location = NSMaxRange(stopR);
		goto nextStopBefore;
	}
final:
	// If I reach this point, it means that I have not found any atomic placeholder
	// select the start and stop markers
	searchRange.location = MIN(length,MAX(index,2)-2);
	searchRange.length = length-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	NSRange startR = NSMakeRange(NSNotFound,0);
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:nil range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = 0;
	searchRange.length = index-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:nil range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderToIndex:cycle:tabAnchor:
- (NSRange)rangeOfPlaceholderToIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement NSBackwardsSearch
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// next stop placeholder
	// preceding start placeholder
	// if the index is in an apropriate range, it's okay
	// start from the beginning if necessary
	NSRange startR = NSMakeRange(NSNotFound,0);
	unsigned length = [self length];
	if(index>length)
	{
		index = length;
	}
	NSRange searchRange = NSMakeRange(0,index);
	NSRange markR;
	// a TAB anchor?
	if([tabAnchor length])
	{
		markR = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	
	unichar stopChar  = [iTM2TextStopPlaceholder characterAtIndex:0];
	unichar startChar = [iTM2TextStopPlaceholder characterAtIndex:[iTM2TextStopPlaceholder length]-1];

	unsigned top = length;

	unsigned idx;
	
	searchRange.location = 0;
	searchRange.length = MIN(index,MAX(length,2)-2)+2;
	
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		searchRange.location = NSMaxRange(startR);
nextMark:
		searchRange.length = top-searchRange.location;
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
		if(markR.length)
		{
			// is it a stop?
			if([self characterAtIndex:markR.location-1]==stopChar)
			{
				// it is a stop place holder
				return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
			}
			// is it a start?
			idx = NSMaxRange(markR);
			if((idx < length) && ([self characterAtIndex:markR.location]==startChar))
			{
				searchRange.location = 0;
				top = startR.location;
				searchRange.length = top;
previousStart:
				startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
				if(startR.length)
				{
					searchRange.location = NSMaxRange(startR);
moreNextMark:
					searchRange.length = top-searchRange.location;
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
					if(markR.length)
					{
						// is it a stop?
						if([self characterAtIndex:markR.location-1]==stopChar)
						{
							// it is a stop place holder
							return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.location = NSMaxRange(markR);
						goto moreNextMark;
					}
					top = startR.location;
					searchRange.location = 0;
					searchRange.length = top;
					goto previousStart;
				}
				goto below;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.location = NSMaxRange(markR);
			goto nextMark;
		}
		top = startR.location;
		searchRange.location = 0;
		searchRange.length = top;
		goto previousStart;
	}
below:
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	// a TAB anchor?
	if([tabAnchor length])
	{
		searchRange.location = index;
		searchRange.length = length-index;
		markR = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	top = length;
	unsigned floor = MAX(index,2)-2;
	searchRange.location = floor;
	searchRange.length = top-searchRange.location;
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		searchRange.location = NSMaxRange(startR);
nextMarkAfter:
		searchRange.length = top-searchRange.location;// we do not want a stop after a different start
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
		if(markR.length)
		{
			// is it a stop?
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
				// it is a stop place holder
				return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
			}
			// is is a start
			idx = NSMaxRange(markR);
			if((idx < length) && ([self characterAtIndex:idx]==startChar))
			{
				searchRange.location = floor;
previousStartAfter:
				searchRange.length = top-searchRange.location;
				startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
				if(startR.length)
				{
					searchRange.location = NSMaxRange(startR);
moreNextMarkAfter:
					searchRange.length = top-searchRange.location;// we do not want a stop after a different start
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
					if(markR.length)
					{
						// is it a stop?
						if([self characterAtIndex:markR.location-1]==stopChar)
						{
							// it is a stop place holder
							return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.location = NSMaxRange(markR);
						goto moreNextMarkAfter;
					}
					top = startR.location;
					searchRange.location = floor;
					goto previousStartAfter;
				}
				goto final;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.location = NSMaxRange(markR);
			goto nextMarkAfter;
		}
		top = startR.location;
		searchRange.location = floor;
		goto previousStartAfter;
	}
final:
	// If I reach this point, it means that I have not found any atomic placeholder
	// select the start and stop markers
	searchRange.location = 0;	
	searchRange.length = floor;	
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	NSRange stopR = NSMakeRange(NSNotFound,0);
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:NSBackwardsSearch range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = floor;
	searchRange.length = length-searchRange.location;
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:NSBackwardsSearch range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indentationLevelWithNumberOfSpacesPerTab:
- (unsigned)indentationLevelWithNumberOfSpacesPerTab:(unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!numberOfSpacesPerTab)
	{
		numberOfSpacesPerTab = 4;
	}
	unsigned idx = 0;
	unsigned top = [self length];
	unsigned result = 0;
	unsigned currentLength = 0;
	while(idx<top)
	{
		unichar theChar = [self characterAtIndex:idx++];
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
@end

@interface iTM2AttributedString_0: NSAttributedString
@end
@implementation iTM2AttributedString_0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation too
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2AttributedString_0 poseAsClass:[NSAttributedString class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
- (NSRange)doubleClickAtIndex:(unsigned)index;
/*"Description forthcoming. This takes TeX commands into account, and \- hyphenation two
Version history: jlaurens AT users.sourceforge.net
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

