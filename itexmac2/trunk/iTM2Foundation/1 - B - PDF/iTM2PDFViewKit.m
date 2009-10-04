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


#import <iTM2Foundation/iTM2PDFViewKit.h>
#import <iTM2Foundation/iTM2ViewKit.h>
#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2UserDefaultsKit.h>
#import <iTM2Foundation/iTM2CursorKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>

NSString * const iTM2PDFSheetBackgroundColorKey = @"iTM2PDFSheetBackgroundColor";
NSString * const iTM2PDFUseSheetBackgroundColorKey = @"iTM2PDFUseSheetBackgroundColor";

@interface NSView(iTM2_PRIVATE)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithFrame:frameRect])
    {
        _AbsoluteFocusPoint = NSMakePoint(1e7, 1e7);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_Representation)
        return _Representation;
    NSView * V = [self superview];
    while(V && ![V respondsToSelector:@selector(imageRepresentation)])
        V = [V superview];
    id result = [V imageRepresentation];
    return [result isKindOfClass:[NSPDFImageRep class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImageRepresentation:
- (void)setImageRepresentation:(NSPDFImageRep *)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Representation = value;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawingBounds
- (NSRect)drawingBounds;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRect R = NSZeroRect;
    id IR = [self imageRepresentation];
    int old = [IR currentPage];
    [IR setCurrentPage:[self tag]-1];
    R.size = [IR size];
    [IR setCurrentPage:old];
    NSRect localFrame = [self convertRect:[self frame] fromView:[self superview]];
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
{iTM2_DIAGNOSTIC;
#if 0
//iTM2_START;
//iTM2_LOG(NSStringFromRect(rect));
    NSRect R = [self drawingBounds];
    if(_DrawsBoundary)
    {
        NSRect r = R;
        [[NSGraphicsContext currentContext] saveGraphicsState];
        [NSBezierPath setDefaultLineJoinStyle:NSRoundLineJoinStyle];
        float lineWidth = [self convertSize:NSMakeSize(0.9, 0) fromView:nil].width;
        [NSBezierPath setDefaultLineWidth:lineWidth];
        if([self state]==NSOnState)
        {
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
        }
        else
        {
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
    }
    if(_BackgroundColor)
    {
        [_BackgroundColor set];
    }
    else if([self contextBoolForKey:iTM2PDFUseSheetBackgroundColorKey domain:iTM2ContextAllDomainsMask])
    {
        [[NSColor colorWithRGBADictionary:[self contextValueForKey:iTM2PDFSheetBackgroundColorKey domain:iTM2ContextAllDomainsMask]] set];
    }
    else
    {
        [[NSColor whiteColor] set];
    }
    [NSBezierPath fillRect:R];
//    if([self inLiveResize])
//        [self setNeedsDisplayInRect:[self bounds]];
//    else
    id IR = [self imageRepresentation];
    int old = [IR currentPage];
    [IR setCurrentPage:[self tag]-1];
        [IR drawAtPoint:R.origin];
    [IR setCurrentPage:old];
//    [[NSString stringWithFormat:@"%i", [self tag]] drawAtPoint:R.origin withAttributes:[NSDictionary dictionaryWithObject:[NSFont systemFontOfSize:50] forKey:NSFontAttributeName]];
    
    return;
#else
//iTM2_LOG(NSStringFromRect(rect));
    if(NSIsEmptyRect(NSIntersectionRect(rect, [self visibleRect])))
        return;
//iTM2_LOG(@"DRAWING...");
    id IR = [[[self imageRepresentation] retain] autorelease];
    int old = [IR currentPage];
    [IR setCurrentPage:[self tag]-1];
    NSRect R = [self drawingBounds];
    NSRect r = R;
    [[NSGraphicsContext currentContext] saveGraphicsState];
    [NSBezierPath setDefaultLineJoinStyle:NSRoundLineJoinStyle];
    float lineWidth = [self convertSize:NSMakeSize(0.9, 0) fromView:nil].width;
    [NSBezierPath setDefaultLineWidth:lineWidth];
    if([self state]==NSOnState)
    {
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
    }
    else
    {
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
    if(_BackgroundColor)
    {
        [_BackgroundColor set];
    }
    else if([self contextBoolForKey:iTM2PDFUseSheetBackgroundColorKey domain:iTM2ContextAllDomainsMask])
    {
        [[NSColor colorWithRGBADictionary:[self contextValueForKey:iTM2PDFSheetBackgroundColorKey domain:iTM2ContextAllDomainsMask]] set];
    }
    else
    {
        [[NSColor whiteColor] set];
    }
    [NSBezierPath fillRect:R];
//    if([self inLiveResize])
//        [self setNeedsDisplayInRect:[self bounds]];
//    else
        [(NSImageRep *)IR drawAtPoint:R.origin];// EXC_BAD_ACCESS HERE
#if 1
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    [I setArgument:&rect atIndex:2];
	NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"CompleteDrawRect:" signature:sig0 inherited:YES] objectEnumerator];
    SEL selector;
    while(selector = (SEL)[[E nextObject] pointerValue])
    {
//iTM2_LOG(NSStringFromSelector(selector));
        [I setSelector:selector];
        [I invoke];
    }
#endif
    [IR setCurrentPage:old];
//    [[NSString stringWithFormat:@"%i", [self tag]] drawAtPoint:R.origin withAttributes:[NSDictionary dictionaryWithObject:[NSFont systemFontOfSize:50] forKey:NSFontAttributeName]];
    return;
#endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  minFrameSize
- (NSSize)minFrameSize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id IR = [self imageRepresentation];
    int old = [IR currentPage];
    [IR setCurrentPage:[self tag]-1];
    NSSize result = [IR size];
    [IR setCurrentPage:old];
    NSSize inset = [self inset];
//iTM2_LOG(@"result: %@", NSStringFromSize(result));
    result.width += 2 * inset.width;
    result.height += 2 * inset.height;
//iTM2_LOG(@"result: %@", NSStringFromSize(result));
    [self setFrameSize:result];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inset
- (NSSize)inset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSMakeSize(10, 10);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tag
- (int)tag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Tag;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTag:
- (void)setTag:(int)anInt;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Tag = anInt;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  state
- (int)state;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _State;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setState:
- (void)setState:(int)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _State = value;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawsBoundary
- (BOOL)drawsBoundary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _DrawsBoundary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDrawsBoundary:
- (void)setDrawsBoundary:(BOOL)flag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _DrawsBoundary = flag;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager
- (id)contextManager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ContextManager? _ContextManager: [super contextManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextManager:
- (void)setContextManager:(id)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _ContextManager = value;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  acceptsFirstResponder
- (BOOL)acceptsFirstResponder;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resetCursorRects
- (void)resetCursorRects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self contextBoolForKey:[NSString stringWithFormat:@"%#x", [self window]] domain:iTM2ContextAllDomainsMask])
    {
        if([[NSApp currentEvent] modifierFlags] & [[self class] grabKeyMask])
            [self addCursorRect:[self visibleRect] cursor:[NSCursor arrowCursor]];
        else
            [self addCursorRect:[self visibleRect] cursor:[NSCursor crossHairCursor]];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self pointWithAbsolutePoint:_AbsoluteFocusPoint];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFocusPoint:
- (void)setFocusPoint:(NSPoint)value;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _AbsoluteFocusPoint = [self absolutePointWithPoint:value];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizationPoint
- (NSPoint)synchronizationPoint;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _SynchronizationPoint;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSynchronizationPoint:
- (void)setSynchronizationPoint:(NSPoint)P;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(NSStringFromPoint(P));
    _SynchronizationPoint = P;
    [self setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFImageRepViewCompleteLoadContext:
- (void)PDFImageRepViewCompleteLoadContext:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_AbsoluteFocusPoint = NSPointFromString([self contextValueForKey:@"iTM2PDFAbsoluteFocusPoint" domain:iTM2ContextAllDomainsMask]);
	[(iTM2PDFView *)[self superview] placeFocusPointInVisibleArea];// scroll to the page as side effect should be a wrapper for stuff below
 	[self scrollRectToVisible:NSRectFromString([self contextValueForKey:@"iTM2PDFImageRepViewVisibleRect" domain:iTM2ContextAllDomainsMask])];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFImageRepViewCompleteSaveContext:
- (void)PDFImageRepViewCompleteSaveContext:(id)irrelevant;
/*"YES."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeContextValue:NSStringFromPoint(_AbsoluteFocusPoint) forKey:@"iTM2PDFAbsoluteFocusPoint" domain:iTM2ContextAllDomainsMask];
	[self takeContextValue:NSStringFromRect([self visibleRect]) forKey:@"iTM2PDFImageRepViewVisibleRect" domain:iTM2ContextAllDomainsMask];
    return;
}
@synthesize _Tag;
@synthesize _State;
@synthesize _DrawsBoundary;
@synthesize _BackgroundColor;
@synthesize _Representation;
@synthesize _ContextManager;
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

#import <iTM2Foundation/iTM2NotificationKit.h>

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
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], iTM2PDFUseViewerBackgroundColorKey,
            [[NSColor lightGrayColor] RGBADictionary], iTM2PDFViewerBackgroundColorKey,
            [NSNumber numberWithBool:NO], iTM2PDFSlidesLandscapeModeKey,
            [NSNumber numberWithInt:iTM2TopCenter], iTM2PDFNewPageModeKey,
            [NSNumber numberWithInt:iTM2PDFOneColumnLayout], iTM2PDFPageLayoutModeKey,
                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithFrame:
- (id)initWithFrame:(NSRect)rect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"%@ %#x %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self, NSStringFromRect(rect));
    if(self = [super initWithFrame:rect])
    {
        [self setPageLayout:[SUD integerForKey:iTM2PDFPageLayoutModeKey]];// preferred? last
		_NewPage = YES;
        _CurrentLogicalPage = 0;// improbable: this will force initialization
//        [self setCurrentPhysicalPage:0];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:nil name:nil object:self];
    [DNC removeObserver:self];
    [self setImageRepresentation:nil];
    [self recache];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  drawRect:
- (void)drawRect:(NSRect)rect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG(NSStringFromRect(rect));
    [[self backgroundColor] set];
    [[NSBezierPath bezierPathWithRect:rect] fill];
    _NewPage = NO;
    [self updateFocusInformation];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSubview:
- (void)addSubview:(NSView *)aView;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2_LOG(@"BEWARE: THIS METHOD OVERRIDES THE NORMAL BEHAVIOR AND DOES NOTHING");
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEvent * CE = [NSApp currentEvent];
    if([CE type] != NSLeftMouseDown)
    {
        // finding the view with the greatest visible rectangle
        id V = [[[self subviews] sortedArrayUsingSelector:@selector(compareArea:)] lastObject];
    //NSLog(@"%i", [V tag]);
        id FV = [self focusView];
        if(!FV || ([FV compareArea:V] == NSOrderedAscending))
        {
            int tag = [V tag];
            [INC postNotificationName:iTM2FocusedPageNumberDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:_CurrentLogicalPage], @"OldLogicalPage",
                        [NSNumber numberWithInt:tag], @"NewLogicalPage",
                        [NSNumber numberWithInt:[[self imageRepresentation] pageCount]], @"PageCount", nil]];
            _CurrentLogicalPage = tag;
        }
        else
        {
            V = FV;
            int tag = [V tag];
            [INC postNotificationName:iTM2FocusedPageNumberDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:_CurrentLogicalPage], @"OldLogicalPage",
                        [NSNumber numberWithInt:tag], @"NewLogicalPage",
                        [NSNumber numberWithInt:[[self imageRepresentation] pageCount]], @"PageCount", nil]];
            _CurrentLogicalPage = tag;
//NSLog(@"V: %@", V);
//NSLog(@"[V tag]:%i", tag);
        }
        NSRect VR = [self visibleRect];
        [V setFocusPoint:[self convertPoint:NSMakePoint(NSMidX(VR), NSMidY(VR)) toView:V]];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(NSStringFromPoint(P));
    NSEnumerator * E = [[self subviews] objectEnumerator];
    id V;
    while(V = [E nextObject])
    {
        if([self mouse:P inRect:[V frame]])
        {
            int tag = [V tag];
            [INC postNotificationName:iTM2FocusedPageNumberDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithInt:_CurrentLogicalPage], @"OldLogicalPage",
                        [NSNumber numberWithInt:tag], @"NewLogicalPage",
                        [NSNumber numberWithInt:[[self imageRepresentation] pageCount]], @"PageCount", nil]];
            _CurrentLogicalPage = tag;
            [self selectViewWithTag:tag];
            [V setFocusPoint:[V convertPoint:P fromView:self]];
            _NewPage = NO;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self updateFocusInformationWithPoint:[self convertPoint:P fromView:[self superview]]];
    return [super hitTest:P];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  focusView
- (id)focusView;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self viewWithTag:[self currentLogicalPage]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedView
- (id)selectedView;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self subviews] objectEnumerator];
    id V;
    while(V = [E nextObject])
        if([V state] == NSOnState)
            return V;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  viewWithTag:
- (id)viewWithTag:(int)tag;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [super viewWithTag:tag];
	if(!result)
	{
		iTM2_LOG(@"No view with tag: %i", tag);
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectViewWithTag
- (void)selectViewWithTag:(int)tag;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self subviews] objectEnumerator];
    id V;
    BOOL shouldDisplay = NO;
    while(V = [E nextObject])
    {
        int old = [V state];
        if([V tag] == tag)
        {
            if(old == NSOffState)
            {
                [V setState:NSOnState];
//            	[V setNeedsDisplay:YES];
                shouldDisplay = YES;
            }
        }
        else
        {
            if(old == NSOnState)
            {
                [V setState:NSOffState];
//            	[V setNeedsDisplay:YES];
                shouldDisplay = YES;
            }
        }
    }
    if(shouldDisplay)
        [self setNeedsDisplay:YES];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id V = [self focusView];
    if(!V)
        return;
    NSRect R = [V frame];// it is a subview...
    if((R.size.width>0) && (R.size.height>0))
    {
		NSPoint focusPoint = [V focusPoint];
		if(!NSPointInRect(focusPoint, [V bounds]))
		{
			NSRect DB = [V drawingBounds];
			switch([self contextIntegerForKey:iTM2PDFNewPageModeKey domain:iTM2ContextAllDomainsMask])
			{
				case iTM2TopLeft:
					focusPoint = NSMakePoint(NSMinX(DB), NSMaxY(DB));
				case iTM2TopCenter:
					focusPoint = NSMakePoint(NSMidX(DB), NSMaxY(DB));
				case iTM2TopRight:
					focusPoint = NSMakePoint(NSMaxX(DB), NSMaxY(DB));
	//            case iTM2Center:
				default:
					focusPoint = NSMakePoint(NSMidX(DB), NSMidY(DB));
			}
		}
		focusPoint = [self convertPoint:focusPoint fromView:V];
        NSEvent * CE = [NSApp currentEvent];
        if([CE type] == NSLeftMouseDown)
        {
            NSRect r = [self visibleRect];
            NSPoint mouseLocation = [self convertPoint:[CE locationInWindow] fromView:nil];
            r.origin.x -= mouseLocation.x;
            r.origin.x += focusPoint.x;
            r.origin.y -= mouseLocation.y;
            r.origin.y += focusPoint.y;
            [self scrollRectToVisible:r];
        }
        else
        {
            NSRect r = NSZeroRect;
            r.origin = focusPoint;
            NSRect vr = [self visibleRect];
            r = NSInsetRect(r, -vr.size.width/2, -vr.size.height/2);
            if(NSMinX(r)<NSMinX(R))
                r.origin.x = R.origin.x;
            if(NSMinY(r)<NSMinY(R))
                r.origin.y = R.origin.y;
            [self scrollRectToVisible:r];
        }
    }
    else
    {
		iTM2_LOG(@"Should not get here, please report BUG: iTM2 0213, %@, %@", V, NSStringFromRect([V frame]));
        return;
    }

    return;
}
#pragma mark =-=-=-=-=-  PAGE MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= softCurrentPhysicalPage
- (int)softCurrentPhysicalPage;
/*"Description forthcoming.
Safe: the return value lies inside the cells index range.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return MAX(0, MIN([self currentPhysicalPage], [[self subviews] count]));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (int)currentPhysicalPage;
/*"Description forthcoming.
Safe: the return value lies inside the cells index range.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self currentLogicalPage] - 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentPhysicalPage:
- (void)setCurrentPhysicalPage:(int)aCurrentPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"argument: %i", aCurrentPhysicalPage);
//NSLog(@"[self currentPhysicalPage]:%i", [self currentPhysicalPage]);
    [self setCurrentLogicalPage:aCurrentPhysicalPage + 1];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentLogicalPage
- (int)currentLogicalPage;
/*"Starting at 1, in general the number printed at the bottom of the page.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_CurrentLogicalPage<1)
        _CurrentLogicalPage = 1;
    else if(_CurrentLogicalPage> [[self subviews] count])
        _CurrentLogicalPage = [[self subviews] count];
    return _CurrentLogicalPage;//MAX(1, MIN(_CurrentLogicalPage, [[self cells] count]));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentLogicalPage:
- (void)setCurrentLogicalPage:(int)aCurrentLogicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"argument: %i", aCurrentLogicalPage);
    if(_CurrentLogicalPage != aCurrentLogicalPage)
    {
        [INC postNotificationName:iTM2LogicalPageNumberDidChangeNotification
            object: self
                userInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:_CurrentLogicalPage], @"OldLogicalPage",
                    [NSNumber numberWithInt:aCurrentLogicalPage], @"NewLogicalPage",
                    [NSNumber numberWithInt:[[self imageRepresentation] pageCount]], @"PageCount", nil]];
        _CurrentLogicalPage = MIN(MAX(1, aCurrentLogicalPage), [[self subviews] count]);
        [self currentPageDidChange];
        _NewPage = YES;
        [[self superview] setNeedsDisplay:YES];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSPoint origin = NSZeroPoint;
    if([self pageLayout] == iTM2PDFSinglePageLayout)
    {
        NSView * V = [self viewWithTag:[self currentLogicalPage]];
        if(V)
            origin = [V frame].origin;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextBoolForKey:iTM2PDFUseViewerBackgroundColorKey domain:iTM2ContextAllDomainsMask]?
        [NSColor colorWithRGBADictionary:[self contextValueForKey:iTM2PDFViewerBackgroundColorKey domain:iTM2ContextAllDomainsMask]]:
            [NSColor windowBackgroundColor];
}
#pragma mark =-=-=-=-=-  IMAGE REPRESENTATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representation
- (id)imageRepresentation;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ImageRepresentation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImageRepresentation:
- (void)setImageRepresentation:(id)aImageRepresentation;
/*"Sends a #{representationDidChange} to the receiver.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![aImageRepresentation isEqual:_ImageRepresentation])
    {
        [_ImageRepresentation release];
        _ImageRepresentation = [aImageRepresentation retain];
        [self imageRepresentationDidChange];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // here we are creating all the subviews
    NSPDFImageRep * IR = [self imageRepresentation];
    int PC = [IR pageCount];
    // adding the missing subviews
    int logicalPage = [[self subviews] count];
    while(logicalPage < PC)
    {
        iTM2PDFImageRepView * IRV = [[[iTM2PDFImageRepView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
        [super addSubview:IRV];// BEWARE ATTENTION DANGER
        ++logicalPage;
        [IRV setTag:logicalPage];
    }
    // removing the missing subviews
    logicalPage = [[self subviews] count];
    while(logicalPage>PC)
    {
        id V = [self viewWithTag:logicalPage];
        NSAssert2(V, @"%@ %#x inconsistency: tags are mixed up(1)", __iTM2_PRETTY_FUNCTION__, self);
        [V removeFromSuperviewWithoutNeedingDisplay];
        --logicalPage;
    }
    NSAssert2(([[self subviews] count] == PC), @"%@ %#x inconsistency:tags are mixed up(2)",
		__iTM2_PRETTY_FUNCTION__, self);
    if(![self selectedView])
        [self selectViewWithTag:PC];
    // the page layout must be set too:
    [self pageLayoutDidChange];// maybe the number of rows | columns should change
    [self setNeedsUpdateGeometry:YES];
    [[self superview] setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recache
- (void)recache;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_CachedImageRepresentation release];
    _CachedImageRepresentation = nil;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cachedImageRepresentation
- (id)cachedImageRepresentation;
/*"Lazy initializer.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_CachedImageRepresentation)
    {
        if(_ImageRepresentation)
        {
//            NSSize S = [self convertSize:[self bounds].size toView:nil];
//            _Image = [[NSImage alloc] initWithSize:S];
            NSImage * image = [[[NSImage alloc] initWithSize:[self bounds].size] autorelease];
            [image addRepresentation:_ImageRepresentation];
            [image setBackgroundColor:[NSColor whiteColor]];
            [image lockFocus];
            [image unlockFocus];
            _CachedImageRepresentation = [[image bestRepresentationForDevice:nil] retain];
        }
    }
    return _CachedImageRepresentation;
}
#pragma mark =-=-=-=-=-  MAGNIFICATION MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magnification
- (float)magnification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"magnification: %@", _Magnification);
    return _Magnification;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnification:
- (void)setMagnification:(float)aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_Magnification != aMagnification)
    {
        _Magnification = aMagnification>0? aMagnification: 1;
        [self magnificationDidChange];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setNeedsUpdateGeometry:YES];
    [[self superview] setNeedsDisplay:YES];
    return;
}
#pragma mark =-=-=-=-=-  GEOMETRY
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  needsToUpdateGeometry
- (BOOL)needsToUpdateGeometry;
/*"Description forthcoming. Only when the magnification has changed.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return _NeedsUpdateGeometry;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setNeedsUpdateGeometry:
- (void)setNeedsUpdateGeometry:(BOOL)flag;
/*"Description forthcoming. Only when the magnification has changed.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    _NeedsUpdateGeometry = flag;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  updateGeometry
- (void)updateGeometry;
/*"Description forthcoming. Only when the magnification, the page layout, the orientation have changed.
The purpose is to place the correct views at the right location, and set the size of the receiver
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // ?
    [self setNeedsUpdateGeometry:NO];// still usefull?
    // 1 determine the optimal size for the subviews
    NSEnumerator * E = [[self subviews] objectEnumerator];
    iTM2PDFImageRepView * IRV;
    float maxSubviewHeight = 0, maxSubviewWidth = 0;
    while(IRV = [E nextObject])
    {
        NSSize S = [IRV minFrameSize];
        maxSubviewHeight = MAX(maxSubviewHeight, S.height);
        maxSubviewWidth  = MAX(maxSubviewWidth,  S.width);
    }
    // 2 forcing the subviews to all have the same frame size
    maxSubviewHeight = nearbyint(maxSubviewHeight);
    maxSubviewWidth = nearbyint(maxSubviewWidth);
    E = [[self subviews] objectEnumerator];
    NSSize S = NSMakeSize(maxSubviewHeight, maxSubviewWidth);
    while(IRV = [E nextObject])
        [IRV setFrameSize:S];// its subview is automatically centered!!
    // 3 setting general geometrical parameters
    int virtualPageCount = [[self imageRepresentation] pageCount];
    int numberOfColumns;
    switch([self pageLayout])
    {
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
    int numberOfRows = virtualPageCount / numberOfColumns;
    if(virtualPageCount > numberOfColumns * numberOfRows)
        ++numberOfRows;
    // 3 placing the subviews
    int logicalPage = ([self pageLayout] == iTM2PDFTwoColumnRightLayout)? 0:1;
    int columnIndex, rowIndex;
    for(rowIndex = 0; rowIndex < numberOfRows; ++rowIndex)
    {
        NSPoint origin = NSMakePoint(0, rowIndex * maxSubviewHeight);
        for(columnIndex = 0; columnIndex < numberOfColumns; ++columnIndex)
        {
            IRV = [self viewWithTag:logicalPage];
            origin.x = columnIndex * maxSubviewWidth;
            [IRV setFrameOrigin:origin];
            [IRV setFrameSize:NSMakeSize(maxSubviewWidth, maxSubviewHeight)];
            [IRV setBoundsOrigin:NSZeroPoint];
            [IRV setBoundsSize:NSMakeSize(maxSubviewWidth, maxSubviewHeight)];
            ++logicalPage;
//NSLog(@"%@, %@", NSStringFromRect([CV frame]), NSStringFromRect([IRV bounds]));
        }
    }
    // 4 setting the bounds
    switch([self pageLayout])
    {
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
    [self setFrameOrigin:NSZeroPoint];
    float scale = [self magnification];
    [self setFrameSize:NSMakeSize(nearbyint(maxSubviewWidth * scale), nearbyint(maxSubviewHeight * scale))];
    [self setBoundsSize:NSMakeSize(maxSubviewWidth, maxSubviewHeight)];
    [self currentPageDidChange];
    [[self superview] setNeedsDisplay:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pageFrameSizeWithMagnification:
- (NSSize)pageFrameSizeWithMagnification:(float)aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(aMagnification<=0)
        return NSZeroSize;
    else
    {
        NSSize result = [self bounds].size;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pageLayout
- (unsigned)pageLayout;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _PageLayout;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setPageLayout:
- (void)setPageLayout:(unsigned)PL;
/*"Initializer. MUST be called at initialization time.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 10/16/02
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_PageLayout != PL)
    {
        _PageLayout = PL;
        [self pageLayoutDidChange];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self updateGeometry];
    [[self superview] setNeedsDisplay:YES];
    // the matrix size
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBoundsRotation:
- (void)setBoundsRotation:(float)angle;
/*"Catching the message: changes in fact the orientation.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/11/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int i = angle / 90;
    [self setPDFOrientation:i];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFOrientation
- (int)PDFOrientation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _OrientationMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPDFOrientation:
- (void)setPDFOrientation:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    argument %= 3;
    if(argument == 3) argument = -1;
    if(argument != _OrientationMode)
    {
        _OrientationMode = argument;
        [self updateGeometry];
    }
    return;
}
#pragma mark =-=-=-=-=-  UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  acceptsFirstResponder  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
- (BOOL)acceptsFirstResponder;
/*"YES."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  acceptsFirstMouse  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent;
/*"YES."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewCompleteLoadContext:
- (void)PDFViewCompleteLoadContext:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self focusView] loadContext:irrelevant];
	[self placeFocusPointInVisibleArea];// scroll to the page as side effect should be a wrapper for stuff below
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewCompleteSaveContext:
- (void)PDFViewCompleteSaveContext:(id)irrelevant;
/*"YES."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self focusView] saveContext:irrelevant];
    return;
}
@synthesize _ImageRepresentation;
@synthesize _CachedImageRepresentation;
@synthesize _Magnification;
@synthesize _PageLayout;
@synthesize _CurrentLogicalPage;
@synthesize _OrientationMode;
@synthesize _NewPage;
@synthesize _NeedsUpdateGeometry;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFView

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintView  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
@implementation iTM2PDFPrintView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithRepresentation:slidesLandscape:scale:
- (id)initWithRepresentation:(id)aRepresentation slidesLandscape:(BOOL)flag scale:(float)scale;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRect B;
    if([aRepresentation respondsToSelector:@selector(bounds)])
        B = [aRepresentation bounds];
    else if([aRepresentation respondsToSelector:@selector(boundingBox)])
        B = [aRepresentation boundingBox];
    else
        B = NSMakeRect(0.0, 0.0, [aRepresentation size].width, [aRepresentation size].height);
    if(self = [super initWithFrame:B])
    {
        [self setScale:(scale>0? scale:1.0)];
        B.size.width *= [self scale];
        B.size.height *= [self scale];
        [self setFrameSize:B.size];
        [self setImageRepresentation:aRepresentation];
        [self setSlidesLandscape:flag];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSAssert1(NO, @"-[iTM2PDFPrintView initWithFrame:] out of purpose:report bug for object %@", [self description]);
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect:
- (void)drawRect:(NSRect)aRect;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self slidesLandscape])
    {
        [self rotateByAngle:90];
        [(NSImageRep *)[self imageRepresentation] drawAtPoint:NSMakePoint(0, -[[self imageRepresentation] size].height)];
        [self rotateByAngle:-90];
    }
    else
    {
        [NSGraphicsContext saveGraphicsState];
        NSAffineTransform * AT = [NSAffineTransform transform];
        [AT scaleXBy:[self scale] yBy:[self scale]];
        [AT concat];
        [(NSImageRep *)[self imageRepresentation] drawAtPoint:NSZeroPoint];
        [NSGraphicsContext restoreGraphicsState];
    }
//        [(NSImageRep *)[self imageRepresentation] drawInRect:[self bounds]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pageCount
- (int)pageCount;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self imageRepresentation] respondsToSelector:@selector(pageCount)])
        return [[self imageRepresentation] pageCount];
    else
        return 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= knowsPageRange:
- (BOOL)knowsPageRange:(NSRangePointer)range;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    range->location = 1;
    range->length = [self pageCount];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isVerticallyCentered
- (BOOL)isVerticallyCentered;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isHorizontallyCentered
- (BOOL)isHorizontallyCentered;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rectForPage:
- (NSRect)rectForPage:(int)pageNumber;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    pageNumber = MAX(pageNumber, 1);
    pageNumber = MIN(pageNumber, [self pageCount]);
    if([[self imageRepresentation] respondsToSelector:@selector(setCurrentPage:)])
        [[self imageRepresentation] setCurrentPage:pageNumber - 1];
    return [self frame];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= imageRepresentation
- (id)imageRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setImageRepresentation:
- (void)setImageRepresentation:(id)anImageRep;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![anImageRep isEqual:metaGETTER])
    {
        metaSETTER(anImageRep);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scale
- (float)scale;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [metaGETTER floatValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setScale:
- (void)setScale:(float)scale;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER([NSNumber numberWithFloat:scale]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= slidesLandscape
- (BOOL)slidesLandscape;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setImageRepresentation:
- (void)setSlidesLandscape:(BOOL)yorn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER([NSNumber numberWithBool:yorn]);
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintView  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

