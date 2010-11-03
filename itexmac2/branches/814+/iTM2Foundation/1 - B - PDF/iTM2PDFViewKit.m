/*
//  TBR Tutorial
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Jun 27 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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


#import "iTeXMac2.h"
#import "iTM2PDFViewKit.h"
#import "iTM2ViewKit.h"
#import "iTM2ResponderKit.h"
#import "iTM2UserDefaultsKit.h"
#import "iTM2CursorKit.h"
#import "iTM2ContextKit.h"
#import "iTM2BundleKit.h"
#import "iTM2Runtime.h"
#import "iTM2ValidationKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2Invocation.h"

NSString * const iTM2PDFSheetBackgroundColorKey = @"iTM2PDFSheetBackgroundColor";
NSString * const iTM2PDFUseSheetBackgroundColorKey = @"iTM2PDFUseSheetBackgroundColor";

@interface NSView(PRIVATE4iTM3)
- (id)imageRepresentation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFImageRepView
/*"This class does not own any of the objects given by set methods!!!.
"*/
@implementation iTM2PDFImageRepView
/*""*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)frameRect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithFrame:frameRect]) {
        iVarAbsoluteFocusPoint = NSMakePoint(1e7, 1e7);
        [self setDrawsBoundary:YES];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imageRepresentation
- (NSPDFImageRep *)imageRepresentation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iVarRepresentation) {
        return iVarRepresentation;
    }
    iTM2PDFImageRepView * V = (iTM2PDFImageRepView *)self.superview;
    while(V && ![V respondsToSelector:@selector(imageRepresentation)]) {
        V = (iTM2PDFImageRepView *)V.superview;
    }
    NSPDFImageRep * result = [V imageRepresentation];
    return [result isKindOfClass:[NSPDFImageRep class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawingBounds
- (NSRect)drawingBounds;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRect R = NSZeroRect;
    NSPDFImageRep * IR = self.imageRepresentation;
    NSInteger old = IR.currentPage;
    IR.currentPage = self.tag-1;
    R.size = [IR size];
    IR.currentPage = old;
    NSRect localFrame = [self convertRect:self.frame fromView:self.superview];
    R.origin.x = NSMidX(localFrame) - R.size.width /2;
    R.origin.y = NSMidY(localFrame) - R.size.height/2;
    return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  drawRect:
- (void)drawRect:(NSRect)rect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3(NSStringFromRect(rect));
    if (NSIsEmptyRect(NSIntersectionRect(rect, self.visibleRect))) {
        return;
    }
//LOG4iTM3(@"DRAWING...");
    NSPDFImageRep * IR = [[self.imageRepresentation retain] autorelease];
    IR.currentPage = self.tag-1;
    NSRect R = self.drawingBounds;
    NSRect r = R;
    [[NSGraphicsContext currentContext] saveGraphicsState];
    [NSBezierPath setDefaultLineJoinStyle:NSRoundLineJoinStyle];
    CGFloat lineWidth = [self convertSize:NSMakeSize(0.9, 0) fromView:nil].width;
    [NSBezierPath setDefaultLineWidth:lineWidth];
    if (self.state==NSOnState) {
        [[[NSColor blackColor] colorWithAlphaComponent:0.8] set];
        [NSBezierPath strokeRect:r];
        r.origin.x -= 0.8*lineWidth;
        r.origin.y -= lineWidth;
        r.size.width += 1.8*lineWidth;
        r.size.height += 1.8*lineWidth;
        [[[NSColor blackColor] colorWithAlphaComponent:0.65] set];
        [NSBezierPath strokeRect:r];
        r.origin.x -= 0.8*lineWidth;
        r.origin.y -= lineWidth;
        r.size.width += 1.8*lineWidth;
        r.size.height += 1.8*lineWidth;
        [[[NSColor blackColor] colorWithAlphaComponent:0.5] set];
        [NSBezierPath strokeRect:r];
        r.origin.x -= 0.8*lineWidth;
        r.origin.y -= lineWidth;
        r.size.width += 1.8*lineWidth;
        r.size.height += 1.8*lineWidth;
        [[[NSColor blackColor] colorWithAlphaComponent:0.3] set];
        [NSBezierPath strokeRect:r];
        r.origin.x -= 0.8*lineWidth;
        r.origin.y -= lineWidth;
        r.size.width += 1.8*lineWidth;
        r.size.height += 1.8*lineWidth;
        [[[NSColor blackColor] colorWithAlphaComponent:0.2] set];
        [NSBezierPath strokeRect:r];
        r.origin.x -= 0.8*lineWidth;
        r.origin.y -= lineWidth;
        r.size.width += 1.8*lineWidth;
        r.size.height += 1.8*lineWidth;
        [[[NSColor blackColor] colorWithAlphaComponent:0.1] set];
        [NSBezierPath strokeRect:r];
    } else {
        [[[NSColor blackColor] colorWithAlphaComponent:0.4] set];
        [NSBezierPath strokeRect:r];
        r.origin.x -= 0.8*lineWidth;
        r.origin.y -= lineWidth;
        r.size.width += 1.8*lineWidth;
        r.size.height += 1.8*lineWidth;
        [[[NSColor blackColor] colorWithAlphaComponent:0.2] set];
        [NSBezierPath strokeRect:r];
        r.origin.x -= 0.8*lineWidth;
        r.origin.y -= lineWidth;
        r.size.width += 1.8*lineWidth;
        r.size.height += 1.8*lineWidth;
        [[[NSColor blackColor] colorWithAlphaComponent:0.1] set];
        [NSBezierPath strokeRect:r];
    }
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    if (self.backgroundColor) {
        [self.backgroundColor set];
    } else if ([self context4iTM3BoolForKey:iTM2PDFUseSheetBackgroundColorKey domain:iTM2ContextAllDomainsMask]) {
        [[NSColor colorWithRGBADictionary:[self contextValueForKey:iTM2PDFSheetBackgroundColorKey domain:iTM2ContextAllDomainsMask]] set];
    } else {
        [[NSColor whiteColor] set];
    }
    [NSBezierPath fillRect:R];
//    if (self.inLiveResize)
//        [self setNeedsDisplayInRect:self.bounds];
//    else
        [IR drawAtPoint:R.origin];// EXC_BAD_ACCESS HERE

    NSInvocation * I = nil;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] drawRect:rect];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteDrawRect4iTM3:" signature:[I methodSignature] inherited:YES]];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  minFrameSize
- (NSSize)minFrameSize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSPDFImageRep * IR = self.imageRepresentation;
    NSInteger old = IR.currentPage;
    IR.currentPage = self.tag-1;
    NSSize result = [IR size];
    IR.currentPage = old;
    NSSize inset = self.inset;
//LOG4iTM3(@"result: %@", NSStringFromSize(result));
    result.width += 2 * inset.width;
    result.height += 2 * inset.height;
//LOG4iTM3(@"result: %@", NSStringFromSize(result));
    [self setFrameSize: result];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inset
- (NSSize)inset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSMakeSize(10, 10);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Manager
- (id)context4iTM3Manager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarContext4iTM3Manager?: [super context4iTM3Manager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  acceptsFirstResponder
- (BOOL)acceptsFirstResponder;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resetCursorRects
- (void)resetCursorRects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([self context4iTM3BoolForKey:[NSString stringWithFormat:@"%#x", self.window] domain:iTM2ContextAllDomainsMask])
    {
        if ([[NSApp currentEvent] modifierFlags] & [self.class grabKeyMask])
            [self addCursorRect:self.visibleRect cursor:[NSCursor arrowCursor]];
        else
            [self addCursorRect:self.visibleRect cursor:[NSCursor crossHairCursor]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  focusPoint
- (NSPoint)focusPoint;
/*"In bounds coordinates.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self pointWithAbsolutePoint: iVarAbsoluteFocusPoint];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFocusPoint:
- (void)setFocusPoint:(NSPoint)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iVarAbsoluteFocusPoint = [self absolutePointWithPoint:value];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSynchronizationPoint:
- (void)setSynchronizationPoint:(NSPoint)P;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(NSStringFromPoint(P));
    iVarSynchronizationPoint = P;
    [self setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFImageRepViewCompleteLoadContext4iTM3:
- (void)PDFImageRepViewCompleteLoadContext4iTM3:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iVarAbsoluteFocusPoint = NSPointFromString([self contextValueForKey:@"iTM2PDFAbsoluteFocusPoint" domain:iTM2ContextAllDomainsMask]);
	[(iTM2PDFView *)self.superview placeFocusPointInVisibleArea];// scroll to the page as side effect should be a wrapper for stuff below
 	[self scrollRectToVisible:NSRectFromString([self contextValueForKey:@"iTM2PDFImageRepViewVisibleRect" domain:iTM2ContextAllDomainsMask])];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFImageRepViewCompleteSaveContext4iTM3:
- (void)PDFImageRepViewCompleteSaveContext4iTM3:(id)irrelevant;
/*"YES."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self takeContextValue:NSStringFromPoint(iVarAbsoluteFocusPoint) forKey:@"iTM2PDFAbsoluteFocusPoint" domain:iTM2ContextAllDomainsMask];
	[self takeContextValue:NSStringFromRect(self.visibleRect) forKey:@"iTM2PDFImageRepViewVisibleRect" domain:iTM2ContextAllDomainsMask];
    return;
}
@synthesize tag = iVarTag;
@synthesize state = iVarState;
@synthesize drawsBoundary = iVarDrawsBoundary;
@synthesize backgroundColor = iVarBackgroundColor;
@synthesize imageRepresentation = iVarRepresentation;
@synthesize context4iTM3Manager = iVarContext4iTM3Manager;
@synthesize synchronizationPoint = iVarSynchronizationPoint;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFImageRepView

#define dPDFMaximumMagnification 8.0

NSString * const iTM2PDFViewerBackgroundColorKey = @"iTM2PDFViewerBackgroundColor";
NSString * const iTM2PDFUseViewerBackgroundColorKey = @"iTM2PDFUseViewerBackgroundColor";

NSString * const iTM2PDFNewPageModeKey = @"iTM2PDFNewPageMode";
NSString * const iTM2PDFPageLayoutModeKey = @"iTM2PDFPageLayoutMode";
NSString * const iTM2PDFSlidesLandscapeModeKey = @"iTM2PDFSlidesLandscapeMode";

NSString * const iTM2LogicalPageNumberDidChangeNotification = @"iTM2LogicalPageNumberDidChange";
NSString * const iTM2FocusedPageNumberDidChangeNotification = @"iTM2FocusedPageNumberDidChange";

@interface NSView(PRIVATE)
- (NSRect)focusFrame;
@end

#import "iTM2NotificationKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFView
/*"Description forthcoming."*/
@interface iTM2PDFView()
@property (readwrite) BOOL newPage;
@property (readwrite,retain) NSPDFImageRep * cachedImageRepresentation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFView
/*"Description forthcoming."*/
@implementation iTM2PDFView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], iTM2PDFUseViewerBackgroundColorKey,
            [[NSColor lightGrayColor] RGBADictionary], iTM2PDFViewerBackgroundColorKey,
            [NSNumber numberWithBool:NO], iTM2PDFSlidesLandscapeModeKey,
            [NSNumber numberWithInteger:iTM2TopCenter], iTM2PDFNewPageModeKey,
            [NSNumber numberWithInteger:iTM2PDFOneColumnLayout], iTM2PDFPageLayoutModeKey,
                nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithFrame:
- (id)initWithFrame:(NSRect)rect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"%@ %#x %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd), self, NSStringFromRect(rect));
    if (self = [super initWithFrame:rect]) {
        self.pageLayout = [SUD integerForKey:iTM2PDFPageLayoutModeKey];// preferred? last
		self.newPage = YES;
        iVarCurrentLogicalPage = ZER0;// improbable: this will force initialization
//        [self setCurrentPhysicalPage:ZER0];
        iVarAbsoluteFocus = NSMakePoint(0,0);
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  drawRect:
- (void)drawRect:(NSRect)rect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3(NSStringFromRect(rect));
    [self.backgroundColor set];
    [[NSBezierPath bezierPathWithRect:rect] fill];
    self.newPage = NO;
    self.updateFocusInformation;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSubview:
- (void)addSubview:(NSView *)aView;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    LOG4iTM3(@"BEWARE: THIS METHOD OVERRIDES THE NORMAL BEHAVIOR AND DOES NOTHING");
    return;
}
#pragma mark =-=-=-=-=-  FOCUS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateFocusInformation
- (void)updateFocusInformation;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSEvent * CE = [NSApp currentEvent];
    if ([CE type] != NSLeftMouseDown) {
        // finding the view with the greatest visible rectangle
        NSView * V = [[self.subviews sortedArrayUsingSelector:@selector(compareArea:)] lastObject];
    //NSLog(@"%i", V.tag);
        iTM2PDFImageRepView * FV = self.focusView;
        if (!FV || ([FV compareArea:V] == NSOrderedAscending)) {
            NSInteger tag = V.tag;
            [INC postNotificationName:iTM2FocusedPageNumberDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInteger:self.currentLogicalPage], @"OldLogicalPage",
                        [NSNumber numberWithInteger:tag], @"NewLogicalPage",
                        [NSNumber numberWithInteger:[self.imageRepresentation pageCount]], @"PageCount", nil]];
            self.currentLogicalPage = tag;
            FV = [V respondsToSelector:@selector(setFocusPoint:)]?(iTM2PDFImageRepView *)V:nil;
        } else {
            NSInteger tag = FV.tag;
            [INC postNotificationName:iTM2FocusedPageNumberDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInteger:self.currentLogicalPage], @"OldLogicalPage",
                        [NSNumber numberWithInteger:tag], @"NewLogicalPage",
                        [NSNumber numberWithInteger:[self.imageRepresentation pageCount]], @"PageCount", nil]];
            self.currentLogicalPage = tag;
//NSLog(@"V: %@", V);
//NSLog(@"V.tag:%i", tag);
        }
        NSRect VR = self.visibleRect;
        [FV setFocusPoint:[self convertPoint:NSMakePoint(NSMidX(VR), NSMidY(VR)) toView:V]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateFocusInformationWithPoint:
- (void)updateFocusInformationWithPoint:(NSPoint)P;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(NSStringFromPoint(P));
    for (iTM2PDFImageRepView * V in self.subviews) {
        if ([self mouse:P inRect:V.frame]) {
            NSInteger tag = V.tag;
            [INC postNotificationName:iTM2FocusedPageNumberDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInteger:self.currentLogicalPage], @"OldLogicalPage",
                        [NSNumber numberWithInteger:tag], @"NewLogicalPage",
                        [NSNumber numberWithInteger:[self.imageRepresentation pageCount]], @"PageCount", nil]];
            self.currentLogicalPage = tag;
            [self selectViewWithTag:tag];
            [V setFocusPoint:[V convertPoint:P fromView:self]];
            self.newPage = NO;
            break;
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hitTest:
- (NSView *)hitTest:(NSPoint)P;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self updateFocusInformationWithPoint:[self convertPoint:P fromView:self.superview]];
    return [super hitTest:P];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  focusView
- (id)focusView;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self viewWithTag:self.currentLogicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedView
- (id)selectedView;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    for (iTM2PDFImageRepView * V in self.subviews) {
        if ([V state] == NSOnState) {
            return V;
        }
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  viewWithTag:
- (id)viewWithTag:(NSInteger)tag;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [super viewWithTag:tag];
	if (!result) {
		LOG4iTM3(@"No view with tag: %i", tag);
	}
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectViewWithTag
- (void)selectViewWithTag:(NSInteger)tag;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL shouldDisplay = NO;
    for (iTM2PDFImageRepView * V in self.subviews) {
        NSInteger old = [V state];
        if (V.tag == tag) {
            if (old == NSOffState) {
                V.state = NSOnState;
                shouldDisplay = YES;
            }
        } else {
            if (old == NSOnState) {
                V.state = NSOffState;
                shouldDisplay = YES;
            }
        }
    }
    if (shouldDisplay) {
        [self setNeedsDisplay:YES];
    }
    // there should be the possibility not to display the view and let the system do it...
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  placeFocusPointInVisibleArea
- (void)placeFocusPointInVisibleArea;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2PDFImageRepView * V = self.focusView;
    if (!V) {
        return;
    }
    NSRect R = V.frame;// it is a subview...
    if ((R.size.width>0) && (R.size.height>0)) {
		NSPoint focusPoint = [V focusPoint];
		if (!NSPointInRect(focusPoint, [V bounds])) {
			NSRect DB = [V drawingBounds];
			switch([self context4iTM3IntegerForKey:iTM2PDFNewPageModeKey domain:iTM2ContextAllDomainsMask]) {
				case iTM2TopLeft:
					focusPoint = NSMakePoint(NSMinX(DB), NSMaxY(DB));
                    break;
				case iTM2TopCenter:
					focusPoint = NSMakePoint(NSMidX(DB), NSMaxY(DB));
                    break;
				case iTM2TopRight:
					focusPoint = NSMakePoint(NSMaxX(DB), NSMaxY(DB));
                    break;
	//            case iTM2Center:
				default:
					focusPoint = NSMakePoint(NSMidX(DB), NSMidY(DB));
			}
		}
		focusPoint = [self convertPoint:focusPoint fromView:V];
        NSEvent * CE = [NSApp currentEvent];
        if ([CE type] == NSLeftMouseDown) {
            NSRect r = self.visibleRect;
            NSPoint mouseLocation = [self convertPoint:[CE locationInWindow] fromView:nil];
            r.origin.x -= mouseLocation.x;
            r.origin.x += focusPoint.x;
            r.origin.y -= mouseLocation.y;
            r.origin.y += focusPoint.y;
            [self scrollRectToVisible:r];
        } else {
            NSRect r = NSZeroRect;
            r.origin = focusPoint;
            NSRect vr = self.visibleRect;
            r = NSInsetRect(r, -vr.size.width/2, -vr.size.height/2);
            if (NSMinX(r)<NSMinX(R))
                r.origin.x = R.origin.x;
            if (NSMinY(r)<NSMinY(R))
                r.origin.y = R.origin.y;
            [self scrollRectToVisible:r];
        }
    } else {
		LOG4iTM3(@"Should not get here, please report BUG: iTM2 0213, %@, %@", V, NSStringFromRect(V.frame));
        return;
    }

    return;
}
#pragma mark =-=-=-=-=-  PAGE MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= softCurrentPhysicalPage
- (NSInteger)softCurrentPhysicalPage;
/*"Description forthcoming.
Safe: the return value lies inside the cells index range.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return MAX(ZER0, MIN(self.currentPhysicalPage, self.subviews.count));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (NSInteger)currentPhysicalPage;
/*"Description forthcoming.
Safe: the return value lies inside the cells index range.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.currentLogicalPage - 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentPhysicalPage:
- (void)setCurrentPhysicalPage:(NSInteger)aCurrentPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"argument: %i", aCurrentPhysicalPage);
//NSLog(@"self.currentPhysicalPage:%i", self.currentPhysicalPage);
    self.currentLogicalPage = aCurrentPhysicalPage + 1;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentLogicalPage
- (NSInteger)currentLogicalPage;
/*"Starting at 1, in general the number printed at the bottom of the page.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iVarCurrentLogicalPage<1) {
        iVarCurrentLogicalPage = 1;
    } else if (iVarCurrentLogicalPage > self.subviews.count) {
        iVarCurrentLogicalPage = self.subviews.count;
    }
    return iVarCurrentLogicalPage;//MAX(1, MIN(iVarCurrentLogicalPage, self.cells.count));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentLogicalPage:
- (void)setCurrentLogicalPage:(NSInteger)aCurrentLogicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"argument: %i", aCurrentLogicalPage);
    if (iVarCurrentLogicalPage != aCurrentLogicalPage)
    {
        [INC postNotificationName:iTM2LogicalPageNumberDidChangeNotification
            object: self
                userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInteger:iVarCurrentLogicalPage], @"OldLogicalPage",
                    [NSNumber numberWithInteger:aCurrentLogicalPage], @"NewLogicalPage",
                    [NSNumber numberWithInteger:[self.imageRepresentation pageCount]], @"PageCount", nil]];
        iVarCurrentLogicalPage = MIN(MAX(1, aCurrentLogicalPage), self.subviews.count);
        self.currentPageDidChange;
        self.newPage = YES;
        [self.superview setNeedsDisplay:YES];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPageDidChange
- (void)currentPageDidChange;
/*"Sends an #{updateGeometry} message to the receiver, after fixing the number of columns and rows
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 07/25/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSPoint origin = NSZeroPoint;
    if (self.pageLayout == iTM2PDFSinglePageLayout) {
        NSView * V = [self viewWithTag:self.currentLogicalPage];
        if (V) {
            origin = V.frame.origin;
        }
    }
    [self setBoundsOrigin:origin];
    return;
}
#pragma mark =-=-=-=-=-  BACKGROUND
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backgroundColor
- (NSColor *)backgroundColor;
/*"Description Fortcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3BoolForKey:iTM2PDFUseViewerBackgroundColorKey domain:iTM2ContextAllDomainsMask]?
        [NSColor colorWithRGBADictionary:[self contextValueForKey:iTM2PDFViewerBackgroundColorKey domain:iTM2ContextAllDomainsMask]]:
            [NSColor windowBackgroundColor];
}
#pragma mark =-=-=-=-=-  IMAGE REPRESENTATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImageRepresentation:
- (void)setImageRepresentation:(id)aImageRepresentation;
/*"Sends a #{representationDidChange} to the receiver.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![aImageRepresentation isEqual:iVarImageRepresentation])
    {
        [iVarImageRepresentation release];
        iVarImageRepresentation = [aImageRepresentation retain];
        self.imageRepresentationDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imageRepresentationDidChange
- (void)imageRepresentationDidChange;
/*"Cleans the cells, forwards the message to super.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // here we are creating all the subviews
    NSPDFImageRep * IR = self.imageRepresentation;
    NSInteger PC = IR.pageCount;
    // adding the missing subviews
    NSInteger logicalPage = self.subviews.count;
    while(logicalPage < PC) {
        iTM2PDFImageRepView * IRV = [[[iTM2PDFImageRepView alloc] initWithFrame:NSZeroRect] autorelease];
        [super addSubview:IRV];// BEWARE ATTENTION DANGER
        ++logicalPage;
        IRV.tag = logicalPage;
    }
    // removing the missing subviews
    logicalPage = self.subviews.count;
    while(logicalPage>PC) {
        id V = [self viewWithTag:logicalPage];
        ASSERT_INCONSISTENCY4iTM3(V);
        [V removeFromSuperviewWithoutNeedingDisplay];
        --logicalPage;
    }
    ASSERT_INCONSISTENCY4iTM3((self.subviews.count == PC));
    if (!self.selectedView) {
        [self selectViewWithTag:PC];
    }
    // the page layout must be set too:
    self.pageLayoutDidChange;// maybe the number of rows | columns should change
    self.needsUpdateGeometry = YES;
    [self.superview setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recache
- (void)recache;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.cachedImageRepresentation = nil;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cachedImageRepresentation
- (id)cachedImageRepresentation;
/*"Lazy initializer.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!iVarCachedImageRepresentation) {
        if (self.imageRepresentation) {
//            NSSize S = [self convertSize:self.bounds.size toView:nil];
//            _Image = [[NSImage alloc] initWithSize:S];
            NSImage * image = [[[NSImage alloc] initWithSize:self.bounds.size] autorelease];
            [image addRepresentation:self.imageRepresentation];
            [image setBackgroundColor:[NSColor whiteColor]];
            [image lockFocus];
            [image unlockFocus];
            iVarCachedImageRepresentation = [[image bestRepresentationForRect:self.bounds context:[NSGraphicsContext currentContext] hints:nil] retain];
        }
    }
    return iVarCachedImageRepresentation;
}
#pragma mark =-=-=-=-=-  MAGNIFICATION MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnification:
- (void)setMagnification:(CGFloat)aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iVarMagnification != aMagnification) {
        iVarMagnification = aMagnification>0? aMagnification: 1;
        self.magnificationDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magnificationDidChange
- (void)magnificationDidChange;
/*"Cleans the cells, forwards the message to super.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.needsUpdateGeometry = YES;
    [self.superview setNeedsDisplay:YES];
    return;
}
#pragma mark =-=-=-=-=-  GEOMETRY
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  updateGeometry
- (void)updateGeometry;
/*"Description forthcoming. Only when the magnification, the page layout, the orientation have changed.
The purpose is to place the correct views at the right location, and set the size of the receiver
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // ?
    self.needsUpdateGeometry = NO;// still usefull?
    // 1 determine the optimal size for the subviews
    iTM2PDFImageRepView * IRV;
    CGFloat maxSubviewHeight = 0, maxSubviewWidth = 0;
    for (IRV in self.subviews) {
        NSSize S = [IRV minFrameSize];
        maxSubviewHeight = MAX(maxSubviewHeight, S.height);
        maxSubviewWidth  = MAX(maxSubviewWidth,  S.width);
    }
    // 2 forcing the subviews to all have the same frame size
    maxSubviewHeight = nearbyint(maxSubviewHeight);
    maxSubviewWidth = nearbyint(maxSubviewWidth);
    NSSize S = NSMakeSize(maxSubviewHeight, maxSubviewWidth);
    for (IRV in self.subviews) {
        [IRV setFrameSize: S];// its subview is automatically centered!!
    }
    // 3 setting general geometrical parameters
    NSInteger virtualPageCount = [self.imageRepresentation pageCount];
    NSInteger numberOfColumns;
    switch(self.pageLayout) {
        case iTM2PDFTwoColumnRightLayout:
            ++virtualPageCount;
        case iTM2PDFTwoColumnLeftLayout:
            numberOfColumns = 2;
        break;
//        case iTM2PDFSinglePageLayout:
//        case iTM2PDFOneColumnLayout:
        default:
            numberOfColumns = 1;
        break;
    }
    NSInteger numberOfRows = virtualPageCount / numberOfColumns;
    if (virtualPageCount > numberOfColumns * numberOfRows) {
        ++numberOfRows;
    }
    // 3 placing the subviews
    NSInteger logicalPage = (self.pageLayout == iTM2PDFTwoColumnRightLayout)? ZER0:1;
    NSInteger columnIndex, rowIndex;
    for(rowIndex = ZER0; rowIndex < numberOfRows; ++rowIndex) {
        NSPoint origin = NSMakePoint(0, rowIndex * maxSubviewHeight);
        for(columnIndex = 0; columnIndex < numberOfColumns; ++columnIndex) {
            IRV = [self viewWithTag:logicalPage];
            origin.x = columnIndex * maxSubviewWidth;
            [IRV setFrameOrigin: origin];
            [IRV setFrameSize: NSMakeSize(maxSubviewWidth, maxSubviewHeight)];
            [IRV setBoundsOrigin:NSZeroPoint];
            [IRV setBoundsSize:NSMakeSize(maxSubviewWidth, maxSubviewHeight)];
            ++logicalPage;
//NSLog(@"%@, %@", NSStringFromRect(CV.frame), NSStringFromRect([IRV bounds]));
        }
    }
    // 4 setting the bounds
    switch(self.pageLayout) {
        case iTM2PDFTwoColumnRightLayout:
        case iTM2PDFTwoColumnLeftLayout:
        case iTM2PDFOneColumnLayout:
            maxSubviewWidth *= numberOfColumns;
            maxSubviewHeight *= numberOfRows;
        break;
        default:
        break;
    }
    // 5 setting the frame
    [self setFrameOrigin: NSZeroPoint];
    CGFloat scale = self.magnification;
    [self setFrameSize: NSMakeSize(nearbyint(maxSubviewWidth * scale), nearbyint(maxSubviewHeight * scale))];
    [self setBoundsSize:NSMakeSize(maxSubviewWidth, maxSubviewHeight)];
    self.currentPageDidChange;
    [self.superview setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pageFrameSizeWithMagnification:
- (NSSize)pageFrameSizeWithMagnification:(CGFloat)aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (aMagnification<=0) {
        return NSZeroSize;
    } else {
        NSSize result = self.bounds.size;
        result.width *= aMagnification;
        result.height *= aMagnification;
        return result;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isFlipped
- (BOOL)isFlipped
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setPageLayout:
- (void)setPageLayout:(NSUInteger)PL;
/*"Initializer. MUST be called at initialization time.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iVarPageLayout != PL) {
        iVarPageLayout = PL;
        self.pageLayoutDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pageLayoutDidChange
- (void)pageLayoutDidChange;
/*"Sends an #{updateGeometry} message to the receiver, after fixing the number of columns and rows
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 07/25/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.updateGeometry;
    [self.superview setNeedsDisplay:YES];
    // the matrix size
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBoundsRotation:
- (void)setBoundsRotation:(CGFloat)angle;
/*"Catching the message: changes in fact the orientation.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/11/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger i = angle / 90;
    [self setPDFOrientation:i];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPDFOrientation:
- (void)setPDFOrientation:(NSInteger)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    argument %= 3;
    if (argument == 3) argument = -1;
    if (argument != iVarOrientationMode) {
        iVarOrientationMode = argument;
        self.updateGeometry;
    }
    return;
}
#pragma mark =-=-=-=-=-  UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  acceptsFirstResponder  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
- (BOOL)acceptsFirstResponder;
/*"YES."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  acceptsFirstMouse  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent;
/*"YES."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewCompleteLoadContext4iTM3:
- (void)PDFViewCompleteLoadContext4iTM3:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.focusView loadContext4iTM3:irrelevant];
	self.placeFocusPointInVisibleArea;// scroll to the page as side effect should be a wrapper for stuff below
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewCompleteSaveContext4iTM3:
- (void)PDFViewCompleteSaveContext4iTM3:(id)irrelevant;
/*"YES."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.focusView saveContext4iTM3:irrelevant];
    return;
}
@synthesize imageRepresentation = iVarImageRepresentation;
@synthesize cachedImageRepresentation = iVarCachedImageRepresentation;
@synthesize magnification = iVarMagnification;
@synthesize pageLayout = iVarPageLayout;
@synthesize currentLogicalPage = iVarCurrentLogicalPage;
@synthesize PDFOrientation = iVarOrientationMode;
@synthesize newPage = iVarNewPage;
@synthesize needsUpdateGeometry = iVarNeedsUpdateGeometry;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFView

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintView  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
@implementation iTM2PDFPrintView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithRepresentation:slidesLandscape:scale:
- (id)initWithRepresentation:(id)aRepresentation slidesLandscape:(BOOL)flag scale:(CGFloat)scale;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRect B;
    if ([aRepresentation respondsToSelector:@selector(bounds)])
        B = [aRepresentation bounds];
    else if ([aRepresentation respondsToSelector:@selector(boundingBox)])
        B = [aRepresentation boundingBox];
    else
        B = NSMakeRect(0.0, 0.0, [aRepresentation size].width, [aRepresentation size].height);
    if (self = [super initWithFrame:B]) {
        self.scale = (scale>0? scale:1.0);
        B.size.width *= self.scale;
        B.size.height *= self.scale;
        [self setFrameSize: B.size];
        self.imageRepresentation = aRepresentation;
        self.slidesLandscape = flag;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id)initWithFrame:(NSRect)aRect;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSAssert1(NO, @"-[iTM2PDFPrintView initWithFrame:] out of purpose:report bug for object %@", self.description);
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect:
- (void)drawRect:(NSRect)aRect;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self.slidesLandscape) {
        [self rotateByAngle:90];
        [self.imageRepresentation drawAtPoint:NSMakePoint(0, -self.imageRepresentation.size.height)];
        [self rotateByAngle:-90];
    } else {
        [NSGraphicsContext saveGraphicsState];
        NSAffineTransform * AT = [NSAffineTransform transform];
        [AT scaleXBy:self.scale yBy:self.scale];
        [AT concat];
        [self.imageRepresentation drawAtPoint:NSZeroPoint];
        [NSGraphicsContext restoreGraphicsState];
    }
//        [(NSImageRep *)self.imageRepresentation drawInRect:self.bounds];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pageCount
- (NSInteger)pageCount;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.imageRepresentation.pageCount;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= knowsPageRange:
- (BOOL)knowsPageRange:(NSRangePointer)range;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    range->location = 1;
    range->length = self.pageCount;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isVerticallyCentered
- (BOOL)isVerticallyCentered;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isHorizontallyCentered
- (BOOL)isHorizontallyCentered;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rectForPage:
- (NSRect)rectForPage:(NSInteger)pageNumber;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    pageNumber = MAX(pageNumber, 1);
    pageNumber = MIN(pageNumber, self.pageCount);
    if ([self.imageRepresentation respondsToSelector:@selector(setCurrentPage:)])
        self.imageRepresentation.currentPage = pageNumber - 1;
    return self.frame;
}
@synthesize imageRepresentation = iVarImageRepresentation;
@synthesize scale = iVarScale;
@synthesize slidesLandscape = iVarSlidesLandscape;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintView  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

