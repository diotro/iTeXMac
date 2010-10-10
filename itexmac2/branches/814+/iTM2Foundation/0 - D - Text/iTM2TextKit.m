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

#import "iTM2NotificationKit.h"
#import "iTM2ContextKit.h"
#import "iTM2EventKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2BundleKit.h"
#import "iTM2InstallationKit.h"
#import "limits.h"
#import "iTM2StringKit.h"
#import "iTM2StringControllerKit.h"
#import "iTM2TextKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextKit
/*"Description forthcoming."*/
@implementation NSText(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSelectionQuickly:
- (IBAction)openSelectionQuickly:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning THIS IS BUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGY!!!!!!!!!!!!! MAKE IT A SEPARATE RESPONDER
    NSString * S = [self.string substringWithRange:self.selectedRange];
	if ([S hasPrefix:iTM2PathComponentsSeparator])
	{
		NSURL * url = [NSURL fileURLWithPath:S];
		if (![SDC openDocumentWithContentsOfURL:url display:YES] 
            && ![[NSWorkspace sharedWorkspace] openURL:url])
		{
			LOG4iTM3(@"WARNING: Don't know how to open %@", S);
		}
		return;
	}
    //creating an URL?
    NSURL * baseURL = [NSURL fileURLWithPath:[[[self.window.windowController document] fileName] stringByDeletingLastPathComponent]];
    NSURL * url = [NSURL URLWithPath4iTM3:S relativeToURL:baseURL];
    if (![SDC openDocumentWithContentsOfURL:url display:YES] 
            && ![[NSWorkspace sharedWorkspace] openURL:url]) {
		LOG4iTM3(@"WARNING: Don't know how to open %@ relative to %@", S, [[[self.window.windowController document] fileName] stringByDeletingLastPathComponent]);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // find what is the name of the current environment...
    NSUndoManager * UM = self.undoManager;
    if (UM && ![UM isUndoing] && ![UM isRedoing])
    {
        NSRange selectedRange = self.selectedRange;
        NSRange R = selectedRange;
        if (R.location)
        {
            --R.location;
            R.length = 1;
            NSString * replacementString = [self.string substringWithRange:R];
            BOOL wasUndoRegistrationEnabled = [UM isUndoRegistrationEnabled];
            [UM disableUndoRegistration];
            [self setSelectedRange:R];
            [self insertText:replacementString];
            [self setSelectedRange:selectedRange];
            if (wasUndoRegistrationEnabled)
                [UM enableUndoRegistration];
        }
    }
    return;
}
@end

@implementation NSTextView(iTM2TextKit_Highlight)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLine:column:length:
- (void)highlightAndScrollToVisibleLine:(NSUInteger)aLine column:(NSUInteger)column length:(NSUInteger)length;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTextStorage * TS = self.textStorage;
	NSRange R = [TS getRangeForLine4iTM3:aLine];
	if (R.location != NSNotFound)
	{
		if ((column != NSNotFound ) && (column < R.length + 1))
		{
			R.location += column;
			R.length = MIN(R.length,length);
		}
		[self highlightAndScrollToVisibleRange:R];
	}
	else
	{
		LOG4iTM3(@"Line %i out of bounds", aLine);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLine:
- (void)highlightAndScrollToVisibleLine:(NSUInteger)aLine;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTextStorage * TS = self.textStorage;
    NSRange R = [TS getRangeForLine4iTM3:aLine];
    if (R.location != NSNotFound)
        [self highlightAndScrollToVisibleRange:R];
	else
	{
		LOG4iTM3(@"Line %i out of bounds", aLine);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleRange:
- (void)highlightAndScrollToVisibleRange:(NSRange)aRange;
/*"Description forthcoming. The receiver is the first responder as side effect.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * S = self.string;
    aRange = iTM3IntersectionRange(aRange, iTM3MakeRange(0, S.length));
    [self scrollRangeToVisible:aRange];
    [self highlightRange:aRange cleanBefore:YES];
	[self setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleLineRange:
- (void)highlightAndScrollToVisibleLineRange:(NSRange)aLineRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTextStorage * TS = self.textStorage;
	NSRange range = [TS getRangeForLine4iTM3Range:aLineRange];
    [self highlightAndScrollToVisibleRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  secondaryHighlightInRanges:
- (void)secondaryHighlightInRanges:(NSArray *)ranges;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTextStorage * TS = self.textStorage;
    NSEnumerator * E1 = [[TS layoutManagers] objectEnumerator];
    NSLayoutManager * LM;
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:
            [NSColor secondarySelectedControlColor], NSBackgroundColorAttributeName, nil];
	NSRange R = iTM3MakeRange(0, TS.length);
    while (LM = [E1 nextObject])
    {
		[LM removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:R];
        id V;
        NSEnumerator * E2 = ranges.objectEnumerator;
        while(V = [E2 nextObject])
        {
             [LM addTemporaryAttributes:attributes forCharacterRange:[V rangeValue]];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= visibleRange
- (NSRange)visibleRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRect rect = self.visibleRect;
    NSUInteger topLeftIndex = [self characterIndexForPoint:
        [self.window convertBaseToScreen:
            [self convertPoint:NSMakePoint(NSMinX(rect), NSMinY(rect))
                toView: nil]]];
    NSUInteger botRightIndex = [self characterIndexForPoint:
        [self.window convertBaseToScreen:
            [self convertPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect))
                toView: nil]]];
    if (topLeftIndex>botRightIndex)
	{
        [NSException raise:NSGenericException format:@"%@ view not flipped", __iTM2_PRETTY_FUNCTION__];
	}
    return iTM3MakeRange(topLeftIndex, botRightIndex-topLeftIndex);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightRange:cleanBefore:
- (void)highlightRange:(NSRange)aRange cleanBefore:(BOOL)aFlag;
/*"Does nothing. Subclasses will do the job.
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSLayoutManager * LM = self.layoutManager;
    NSString * S = self.string;
	NSUInteger length = S.length;
    NSRange effectiveRange = iTM3MakeRange(0,length);
    aRange = iTM3IntersectionRange(aRange,effectiveRange);
	NSUInteger index = 0;
	NSDictionary * attributes;
	if (aFlag && index<length)
	{
next:
		attributes = [LM temporaryAttributesAtCharacterIndex:index effectiveRange:&effectiveRange];
		if (effectiveRange.length)
		{
			if ([attributes objectForKey:NSBackgroundColorAttributeName])
			{
				[LM removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:effectiveRange];
			}
			index = iTM3MaxRange(effectiveRange);
			if (index<length)
			{
				goto next;
			}
		}
	}
	if (aRange.length)
	{
		NSColor * C = [NSColor textRangeHighlightColor];
		attributes = [NSDictionary dictionaryWithObject:C forKey: NSBackgroundColorAttributeName];
		[LM addTemporaryAttributes:attributes forCharacterRange: aRange];
	}
    return;
}
@end

#import "iTM2Runtime.h"

@implementation NSTextView(iTM2TextKitHighlight)
- (void)SWZ_iTM2TextKitHighlight_didChangeText;
{
	[self highlightRange:iTM3MakeRange(0, 0) cleanBefore:YES];
	[self SWZ_iTM2TextKitHighlight_didChangeText];
	return;
}
@end

@implementation NSTextView(iTM2TextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendSelectionWithRange:
- (void)extendSelectionWithRange:(NSRange)range;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setSelectedRanges:[self.selectedRanges arrayByAddingObject:[NSValue valueWithRange:range]]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  breakTypingFlow
- (void)breakTypingFlow;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self respondsToSelector:@selector(breakUndoCoalescing)])
		self.breakUndoCoalescing;
	else
		[super breakTypingFlow];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomIn:
- (IBAction)doZoomIn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float f = [self contextFloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895;
 	if (f>0)
		[self setScaleFactor:f * self.scaleFactor];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
- (void)doZoomOut:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    float f = [self contextFloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895;
	if (f>0)
		[self setScaleFactor:self.scaleFactor / f];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  actualSize:
- (IBAction)actualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setScaleFactor:1.0];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateActualSize:
- (BOOL)validateActualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.scaleFactor != 1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scaleFactor
- (float)scaleFactor;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	float frameWidth = self.frame.size.width;
	float boundsWidth = self.bounds.size.width;
    return boundsWidth>0? frameWidth / boundsWidth: 0.00001;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScaleFactor:
- (void)setScaleFactor:(float)aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(aMagnification>0);
	if (aMagnification != self.scaleFactor) {
		NSSize oldSize = self.frame.size;
		NSSize newSize = oldSize;
		newSize.width /= aMagnification;
		newSize.height /= aMagnification;
		[self setBoundsSize:newSize];
		newSize = oldSize;
		newSize.width += 1;
		newSize.height += 1;
		[self setFrameSize: newSize];
		[self setFrameSize: oldSize];
		[self.enclosingScrollView setNeedsDisplay:YES];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * actualSelectedRange = self.selectedRanges;
	NSUndoManager * UM = self.undoManager;
	[UM registerUndoWithTarget:self selector:@selector(setSelectedRanges:) object:actualSelectedRange];
	[UM registerUndoWithTarget:self selector:@selector(didChangeSelectedRanges) object:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didChangeSelectedRanges
- (void)didChangeSelectedRanges;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUndoManager * UM = self.undoManager;
	[UM registerUndoWithTarget:self selector:@selector(willChangeSelectedRanges) object:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openQuickly:
- (void) openQuickly: (id) sender;
/*"Desription Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * S = [self.string substringWithRange: self.selectedRange];
    //creating an URL?
	NSString * path = [[self.window.windowController document] fileName];
    NSURL * baseURL = [NSURL fileURLWithPath:path];
    NSURL * url = [NSURL URLWithPath4iTM3:S relativeToURL:baseURL];
    if (![SDC openDocumentWithContentsOfURL: url display: YES] && ![[NSWorkspace sharedWorkspace] openURL: url]) {
		NSBeep();
	}
    return;
}
@end

@implementation NSValue(iTM2Location)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= locationValueOfRangeValue4iTM3
- (NSNumber *)locationValueOfRangeValue4iTM3; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = self.rangeValue;
//END4iTM3;
	return [NSNumber numberWithInteger:range.location];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	range = [self glyphRangeForCharacterRange:range actualCharacterRange:nil];
	NSUInteger index = iTM3MaxRange(range)-1;
	if (index>range.location) {
		[self lineFragmentUsedRectForGlyphAtIndex:range.location effectiveRange:&range withoutAdditionalLayout:yorn];
		NSRange range1;
		[self lineFragmentUsedRectForGlyphAtIndex:index effectiveRange:&range1 withoutAdditionalLayout:yorn];
//END4iTM3;
		return iTM3UnionRange(range,range1);
	} else {
		[self lineFragmentUsedRectForGlyphAtIndex:range.location effectiveRange:&range withoutAdditionalLayout:yorn];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSColor * color;
    return color? color: (color = [[NSColor colorWithCalibratedRed:1 green:0.75 blue:0.80 alpha:0.85] retain]);
}
@end

@implementation NSTextStorage(iTM2TextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidateCursorRects
- (void)invalidateCursorRects;
/*"Default implementation does nothing.
 The focus range is the range used to insert some text in the text storage when there is no UI.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	for (NSLayoutManager * LM in self.layoutManagers) {
		for (NSTextContainer * TC in LM.textContainers) {
			[TC.textView.window invalidateCursorRectsForView:TC.textView];
		}
	}
	//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink4iTM3:atIndex:
- (BOOL)didClickOnLink4iTM3:(id)link atIndex:(NSUInteger)charIndex;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	return NO;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextKit

@implementation iTM2MainInstaller(TextKit)
+ (void)prepareTextKitCompleteInstallation4iTM3;
{
	if ([NSTextView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2TextKitHighlight_didChangeText) error:NULL]) {
		MILESTONE4iTM3((@"NSTextView(iTM2TextKitHighlight)"),(@"The custom didChangeText is not available, maybe there is a problem with colors"));
	}
}
@end
