/*
//
//  @version Subversion: $Id: iTM2ViewKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Jun 27 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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
//
//  Version history: jlaurens AT users DOT sourceforge DOT net(format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actual done)")
*/

#import "iTM2ViewKit.h"
#import "iTM2ResponderKit.h"
#import "iTM2BundleKit.h"
#import "iTM2Runtime.h"
#import "iTM2ImageKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSView(iTeXMac2)
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
@implementation NSView(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  grabKeyMask
+ (NSUInteger)grabKeyMask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSCommandKeyMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomInKeyMask
+ (NSUInteger)zoomInKeyMask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSShiftKeyMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomOutKeyMask
+ (NSUInteger)zoomOutKeyMask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSShiftKeyMask|NSAlternateKeyMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameCenter
- (NSPoint)frameCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSMakePoint(NSMidX(self.frame), NSMidY(self.frame));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setFrameCenter:
- (void)setFrameCenter:(NSPoint)aCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSSize size = self.frame.size;
    aCenter.x -= size.width/2;
    aCenter.y -= size.height/2;
    [self setFrameOrigin: aCenter];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= relativeFrameCenter
- (NSPoint)relativeFrameCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self absolutePointWithPoint:self.frameCenter];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= absolutePointWithPoint:
- (NSPoint)absolutePointWithPoint:(NSPoint)aPoint;
/*"Given aPoint in the receiver coordinate system, it returns a point in a normalized coordinate system, with the origin at the lower left corner, height and width equal 1. For example to top right corner has normalized coordinates (1, 1).
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    CGFloat width = self.bounds.size.width != 0? self.bounds.size.width:0.0001;
    CGFloat height = self.bounds.size.height != 0? self.bounds.size.height:0.0001;
    NSPoint result;
    result = NSMakePoint((aPoint.x-self.bounds.origin.x)/width, (aPoint.y-self.bounds.origin.y)/height);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pointWithAbsolutePoint:
- (NSPoint)pointWithAbsolutePoint:(NSPoint)aPoint;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSMakePoint(self.bounds.origin.x+aPoint.x*self.bounds.size.width,
                            self.bounds.origin.y+aPoint.y*self.bounds.size.height);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= absoluteSizeWithSize:
- (NSSize)absoluteSizeWithSize:(NSSize)aSize;
/*"Given aPoint in the receiver coordinate system, it returns a point in a normalized coordinate system, with the origin at the lower left corner, height and width equal 1. For example to top right corner has normalized coordinates (1, 1).
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 07/17/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    CGFloat width = self.bounds.size.width != 0? self.bounds.size.width:0.0001;
    CGFloat height = self.bounds.size.height != 0? self.bounds.size.height:0.0001;
    NSSize result;
    result = NSMakeSize(aSize.width/width, aSize.height/height);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sizeWithAbsoluteSize:
- (NSSize)sizeWithAbsoluteSize:(NSSize)aSize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 07/17/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSMakeSize(aSize.width*self.bounds.size.width, aSize.height*self.bounds.size.height);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= absoluteSizeWithSize:
- (NSRect)absoluteRectWithRect:(NSRect)aRect;
/*"Given aPoint in the receiver coordinate system, it returns a point in a normalized coordinate system, with the origin at the lower left corner, height and width equal 1. For example to top right corner has normalized coordinates (1, 1).
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 07/17/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    CGFloat width = self.bounds.size.width != 0? self.bounds.size.width:0.0001;
    CGFloat height = self.bounds.size.height != 0? self.bounds.size.height:0.0001;
    NSRect result;
    result = NSMakeRect((aRect.origin.x-self.bounds.origin.x)/width, (aRect.origin.y-self.bounds.origin.y)/height,
        aRect.size.width/width, aRect.size.height/height);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rectWithAbsoluteRect:
- (NSRect)rectWithAbsoluteRect:(NSRect)aRect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 07/17/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSMakeRect(self.bounds.origin.x+aRect.origin.x*self.bounds.size.width, self.bounds.origin.y+aRect.origin.y*self.bounds.size.height,
                            aRect.size.width*self.bounds.size.width, aRect.size.height*self.bounds.size.height);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= boundsCenter
- (NSPoint)boundsCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSMakePoint(NSMidX(self.bounds), NSMidY(self.bounds));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setBoundsCenter:
- (void)setBoundsCenter:(NSPoint)aCenter;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSSize size = self.bounds.size;
    aCenter.x -= size.width/2;
    aCenter.y -= size.height/2;
    [self setBoundsOrigin:aCenter];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= centerBoundsOrigin
- (void)centerBoundsOrigin;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setBoundsOrigin:self.boundsCenter];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= centerInSuperview
- (void)centerInSuperview;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(NSStringFromRect([self.superview bounds]));
	NSView * SV = self.superview;
    if (SV)
	{
		NSPoint center = [SV boundsCenter];
        [self setFrameCenter:center];
		[self resizeWithOldSuperviewSize:[SV bounds].size];
	}
//NSLog(NSStringFromRect(self.frame));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeSubviewsWithoutNeedingDisplay
- (void)removeSubviewsWithoutNeedingDisplay;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSEnumerator * E = [self.subviews objectEnumerator];
    NSView * V;
    while ((V = E.nextObject))
        [V removeFromSuperviewWithoutNeedingDisplay];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= visibleArea
- (CGFloat)visibleArea;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRect VR = self.visibleRect;
    return VR.size.width * VR.size.height;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= compareArea:
- (NSComparisonResult)compareArea:(NSView *)otherView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSAssert(!otherView || [otherView isKindOfClass:[NSView class]], @"Unexpected  rhs");
    CGFloat lhs = self.visibleArea;
    CGFloat rhs = [otherView visibleArea];
    if (lhs>rhs)
        return NSOrderedDescending;
    else if (lhs<rhs)
        return NSOrderedAscending;
    else 
        return NSOrderedSame;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  absoluteFocus
- (NSPoint)absoluteFocus;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSPoint absoluteFocus;
    NSEvent * CE = [self.window currentEvent];
    if ([CE modifierFlags] &
            (NSAlphaShiftKeyMask|NSShiftKeyMask|NSControlKeyMask|NSAlternateKeyMask|NSCommandKeyMask))
    {
        absoluteFocus = [self convertPoint:[CE locationInWindow] fromView:nil];
    }
    else
    {
        NSRect visibleRect = self.visibleRect;
        absoluteFocus = NSMakePoint(NSMidX(visibleRect), NSMidY(visibleRect));
    }
    absoluteFocus.x-=self.bounds.origin.x;
    absoluteFocus.y-=self.bounds.origin.y;
    {
        NSSize size = self.bounds.size;
        CGFloat width = size.width > 0? size.width: 0.000001;
        CGFloat height = size.height > 0? size.height: 0.000001;
        absoluteFocus.x/=width;
        absoluteFocus.y/=height;
    }
    return absoluteFocus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= controlWithAction:
- (NSControl *)controlWithAction:(SEL)action;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	for (NSView * V in self.subviews)
		if ((result = [V controlWithAction:action]))
			break;
    return result;
}
- (NSArray *)subviewsWhichClassInheritsFromClass:(Class) aClass;
{
	NSMutableArray * result = [NSMutableArray array];
	NSArray * subviews = self.subviews;
	NSView * subview = nil;
	for(subview in subviews)
	{
		if ([subview isKindOfClass:aClass])
		{
			[result addObject:subview];
		}
		else
		{
			[result addObjectsFromArray:[subview subviewsWhichClassInheritsFromClass:aClass]];
		}
	}
	return result;
}
- (NSView *)superviewMemberOfClass:(Class) aClass;
{
	NSView * superview = self;
	while ((superview = superview.superview)) {
		if ([superview isKindOfClass:aClass]) {
			return superview;
		}
	}
	return nil;
}
@end

@implementation NSControl(iTM2ViewKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= controlWithAction:
- (NSControl *)controlWithAction:(SEL)action;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.action == action? self:nil;
}
@end

@implementation NSView(iTeXMac2Scrolling)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollPageLeft:
- (void)scrollPageLeft:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = 2*VR.size.width/5;
	scrollPosition.x -= scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollPageRight:
- (void)scrollPageRight:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = 2*VR.size.width/5;
	scrollPosition.x += scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollPageUp:
- (void)scrollPageUp:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = 2*VR.size.height/5;
	scrollPosition.y -= self.isFlipped? scrollAmount:-scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollPageDown:
- (void)scrollPageDown:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = 2*VR.size.height/5;
	scrollPosition.y += self.isFlipped? scrollAmount:-scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollCharacterLeft:
- (void)scrollCharacterLeft:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = MAX(VR.size.width/50, 16);
	scrollPosition.x -= scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollCharacterRight:
- (void)scrollCharacterRight:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = MAX(VR.size.width/50, 16);
	scrollPosition.x += scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollLineUp:
- (void)scrollLineUp:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = MAX(VR.size.height/50, 16);
	scrollPosition.y -= self.isFlipped? scrollAmount:-scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= scrollLineDown:
- (void)scrollLineDown:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 2.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSScrollView * SV = self.enclosingScrollView;
	NSClipView * CV = SV.contentView;
	NSPoint scrollPosition = [CV  bounds].origin;
	scrollPosition = [self convertPoint:scrollPosition fromView:CV];
    NSRect VR = [SV documentVisibleRect];
	CGFloat scrollAmount = MAX(VR.size.height/50, 16);
	scrollPosition.y += self.isFlipped? scrollAmount:-scrollAmount;
	[self scrollPoint:scrollPosition];
//END4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSView(iTeXMac2)

@interface NSView(PRIVATE4iTM3)
- (NSSize)minFrameSize;
@end

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"

@implementation iTM2View
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)frame;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithFrame:frame]))
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)decoder;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithCoder:decoder]))
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
    return;
}
@synthesize _Implementation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CenteringView
/*"This view has only one centered subview! The centers of the two views is a.e. the same screen point.
Margins are added.
The bounds origin is at (0, 0), I don't know yet if this is flipped.
"*/
@implementation iTM2CenteringView
/*"This view has only one subview! The centers of the two views is a.e. the same screen point.
Margins are added.
The bounds origin is at (0, 0), I don't know yet if this is flipped.
"*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)aFrame;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithFrame:(NSRect) aFrame]))
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)decoder;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithCoder:(NSCoder *) decoder]))
    {
        [self initImplementation];
    }
    return self;
}
#pragma mark =-=-=-=-=-  CENTERED SUBVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  centeredSubview
- (id)centeredSubview;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Subview;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCenteredSubview:
- (void)setCenteredSubview:(NSView *)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument)
    {
        if (![argument isKindOfClass:[NSView class]])
            [NSException raise:NSInvalidArgumentException format:@"%@ NSView argument expected:got %@.",
                __iTM2_PRETTY_FUNCTION__, argument];
        else if (_Subview != argument)
        {
            [self willChangeCenteredSubview];
            [_Subview removeFromSuperviewWithoutNeedingDisplay];
            [argument removeFromSuperviewWithoutNeedingDisplay];
            [self addSubview:argument];
            _Subview = argument;
            [self didChangeCenteredSubview];
        }
    }
    else
    {
        [_Subview removeFromSuperviewWithoutNeedingDisplay];
        _Subview = nil;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willChangeCenteredSubview
- (void)willChangeCenteredSubview;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didChangeCenteredSubview
- (void)didChangeCenteredSubview;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willRemoveSubview:
- (void)willRemoveSubview:(NSView *)subview;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (subview == _Subview)
        _Subview = nil;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  centerSubview
- (void)centerSubview;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [_Subview centerInSuperview];
    [_Subview setFrame:NSIntegralRect(_Subview.frame)];
    return;
}
#pragma mark =-=-=-=-=-  IMPLEMENTATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
    return;
}
#pragma mark =-=-=-=-=-  SIZE MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  minFrameSize
- (NSSize)minFrameSize;
/*"Only one subview please.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSSize result;
    NSView * V = self.centeredSubview;
    if ([V respondsToSelector:_cmd])
        result = [V minFrameSize];
    else
        result = V? [V bounds].size:NSZeroSize;
    result.width += 2 * self.horizontalMargin;
    result.height += 2 * self.verticalMargin;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resizeSubviewsWithOldSize:
- (void)resizeSubviewsWithOldSize:(NSSize)oldSize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super resizeSubviewsWithOldSize:oldSize];
    [self.centeredSubview centerInSuperview];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  horizontalMargin
- (CGFloat)horizontalMargin;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  verticalMargin
- (CGFloat)verticalMargin;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Fri Jul 25 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.horizontalMargin;
}
@synthesize _Subview;
@synthesize _Implementation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CenteringView

#import "iTM2NotificationKit.h"
#import "iTM2EventKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2FlagsChangedView  =-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
@implementation iTM2FlagsChangedView
/*"This class implements the view changing with modifiers keys.
To use this class in Interface Builder, simply create a custom view, set its class
to iTM2FlagsChangedView and drag some subviews in it. Then set the tags of these subviews
according to those simple rules.

- all subview with tag not in [0-15] are not affected and remain at any time at their initial positions.

- all the subviews with tags in [0-15] are treated with the next rules

- for each acceptable tag value, only the last one in the array of subviews is considered,
the previous ones remains at any time at their initial position.

- if there is no view with tag i, the subview with index 0 will replace it

In tags from [0-15], bits correspond to shift, control, alternate, command keys. More precisely,
0 means no modifier keys, 1 means only shift key, 2 means only control key, 4 means only alternate key, and 8 means only command key. This is for macintosh like endian story only.

Message to change the subviews are sent by an instance of the
//iTM2FlagsChangedResponder class."*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-= autorelease
- (id)autorelease;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//NSLog(@"in awakeFromNib, iVarSubFrame4iTM3 isEqual to %#x", iVarSubFrame4iTM3);
    [super autorelease];
    return self;
} 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//NSLog(@"in awakeFromNib, iVarSubFrame4iTM3 isEqual to %#x", iVarSubFrame4iTM3);
    [super awakeFromNib];
    [self computeIndexFromTag4iTM3];
    return;
} 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-= computeIndexFromTag4iTM3
- (void)computeIndexFromTag4iTM3;
/*"Records the partial tags of subviews of the receiver and stores the index in the 
table %{iVarIndexFromTag4iTM3[]}. If two views have the same partial tag, only the last one is
taken into account. The tags accepted are those between 0 and 15 (included) which corresponds to 4 modifiers key flags. One view can have at most seven different tags like this each of them corresponds to a combination of modifier keys assuming that we cannot have more than 3 modifier key at a time. Those tags are part of the NSView tag code, more
precisely we have -NSView.tag -> tag_0+16*(tag_1+16*(...*(tag_7))), with some elementary rules.

Index for those tags are taken to be 0 by default. Last null partial tags tag_? are ignored except 0.

First we look for the first subview with tag 0, recording its index as the default index
for tags not associated with any views. If we don't find such a subview, we take 0 as default index (and the first subview will be displayed for any key combination not explicitly specified by the coder). Then we init table %{iVarIndexFromTag4iTM3[]} with the previously found index. Next,
we loop over all the subviews of the receiver to replace the default index with a real one, if an appropriate tagged subview is found. Final, we move away all subviews except the last one tagged 0, and the ones with tags not in [0-15].

If two view share the same partial tag, the second one overrides what was set according to the first one.
Quite nice, isn't it?
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [INC removeObserver:self
                name: iTM2FlagsDidChangeNotification
                            object: nil];
	NSView * subview;
    NSInteger tag, partialTag;
	// finding the first index of the view with a partial tag 0
    NSInteger idx = ZER0;
	if (idx < self.subviews.count) {
loop1:
		subview = [self.subviews objectAtIndex:idx];
		tag = subview.tag;
loop2:
		if (tag & 15) {
			if (tag /= 16) {
				goto loop2;
			} else if (++idx < self.subviews.count) {
				goto loop1;
			} else {
				for (partialTag=ZER0; partialTag<16; ++partialTag)
					iVarIndexFromTag4iTM3[partialTag] = ZER0;
			}
		} else {
			for (partialTag=ZER0; partialTag<16; ++partialTag)
				iVarIndexFromTag4iTM3[partialTag] = idx;
		}
	} else {
		return;
	}

    NSMutableArray * frames = [NSMutableArray array];
	idx = ZER0;
loop3:
	subview = [self.subviews objectAtIndex:idx];
	[frames addObject:[NSValue valueWithRect:subview.frame]];
	tag = subview.tag;
//NSLog(@"subview: %@, %d", [subview description], subview.tag);
	while (tag) {
		if ((partialTag = tag & 15))
			iVarIndexFromTag4iTM3[partialTag] = idx;
		tag /= 16;
	}
	if (++idx < self.subviews.count)
		goto loop3;

//NSLog(@"The current value of iVarSubFrame4iTM3 is %#x", iVarSubFrame4iTM3);
    [iVarSubFrame4iTM3 autorelease];
    iVarSubFrame4iTM3 = [frames copy];
//    iTM2DEBUGLog(5000,@"MOVING...");
	for (subview in self.subviews) {
		[subview setFrameOrigin: NSMakePoint(10000, 10000)];
    }
	[self moveCloserSubviewAtIndex:iVarIndexFromTag4iTM3[ZER0]];
	iVarVisibleSubviewIndex4iTM3 = iVarIndexFromTag4iTM3[ZER0];
	// observing the notification
    [INC addObserver:self
            selector: @selector(flagsDidChangeNotified:)
                    name: iTM2FlagsDidChangeNotification
                            object: nil];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self computeIndexFromTag4iTM3];
		[self moveAwaySubviewAtIndex:iVarVisibleSubviewIndex4iTM3];
		[aDecoder decodeValueOfObjCType:@encode(NSUInteger) at:&iVarVisibleSubviewIndex4iTM3];
		[self moveCloserSubviewAtIndex:iVarVisibleSubviewIndex4iTM3];
	}
//END4iTM3;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  encodeWithCoder:
- (void)encodeWithCoder:(NSCoder *)aCoder;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger idx;
	for(idx = ZER0; idx < self.subviews.count; ++idx)
		[self moveCloserSubviewAtIndex:idx];
	[super encodeWithCoder:aCoder];
	[aCoder encodeValueOfObjCType:@encode(NSUInteger) at:&iVarVisibleSubviewIndex4iTM3];
    [self computeIndexFromTag4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-= acceptsFirstResponder =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
- (BOOL)acceptsFirstResponder
/*"Overriden to always return  YES to allow event messages to go through the responder chain
down to the receiver. We only need one such view in the window, the receiver can play this role."*/
{DIAGNOSTIC4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-= flagsDidChangeNotified:... =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
- (void)flagsDidChangeNotified:(NSNotification *)aNotification;
/*" The subview which tag corresponds to the combination of modifier keys is moved to the origin while the subview that was previously there is moved away."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([[aNotification object] isEqual:self.window])
    {
		[self updateWithFlags:[[self.window currentEvent] modifierFlags]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateWithFlags:... =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
- (void)updateWithFlags:(NSUInteger)flags;
/*" The subview which tag corresponds to the combination of modifier keys is moved to the origin while the subview that was previously there is moved away."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger newVisibleSubviewIndex = iVarIndexFromTag4iTM3[[self tagFromMask:flags]];
	if (iVarVisibleSubviewIndex4iTM3 != newVisibleSubviewIndex) {
		[self moveAwaySubviewAtIndex:iVarVisibleSubviewIndex4iTM3];
		[self moveCloserSubviewAtIndex:newVisibleSubviewIndex];
		iVarVisibleSubviewIndex4iTM3 = newVisibleSubviewIndex;
		[self setNeedsDisplay:YES];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-= tagFromMask: =-=-=-=-=-=-=-=-=-=-=-=-
- (NSUInteger)tagFromMask:(NSUInteger)aMask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSUInteger result = ZER0;
    result += aMask & NSCommandKeyMask ? 1: ZER0;
    result <<=1;
    result += aMask & NSAlternateKeyMask ? 1: ZER0;
    result <<=1;
    result += aMask & NSControlKeyMask ? 1: ZER0;
    result <<=1;
    result += aMask & NSShiftKeyMask ? 1: ZER0;
//NSLog(@"tagFromMask: %d -> %d", aMask, result);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-= moveCloserSubviewAtIndex:... =-=-=-=-=-=-=-=-=-=-=-=-
- (void)moveAwaySubviewAtIndex:(NSUInteger)index
/*"Sets the origin of this subview at point (10000, 10000)."*/
{DIAGNOSTIC4iTM3;
    [[self.subviews objectAtIndex:index] setFrameOrigin:NSMakePoint(10000, 10000)];
}
//=-=-=-=-=-=-=-=-=-=-= moveCloserSubviewAtIndex:... =-=-=-=-=-=-=-=-=-=-=-=-
- (void)moveCloserSubviewAtIndex:(NSUInteger)index
/*"Sets the origin of this subview at point (0, 0)."*/
{DIAGNOSTIC4iTM3;
    if (index<iVarSubFrame4iTM3.count)
        [[self.subviews objectAtIndex:index] setFrame:[[iVarSubFrame4iTM3 objectAtIndex:index] rectValue]];
    else
        [[self.subviews objectAtIndex:index] setFrameOrigin:NSZeroPoint];
    return;
}
@synthesize subFrame4iTM3 = iVarSubFrame4iTM3;
@synthesize visibleSubviewIndex4iTM3 = iVarVisibleSubviewIndex4iTM3;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2FlagsChangedView  =-=-=-=-=-=-=-=-=-=-=-=-=-=

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Geometry
/*"Description forthcoming."*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PointConvertedToIntrinsic
NSPoint iTM2PointConvertedToIntrinsic(NSPoint point, NSRect rect)
/*"Given a frame and a point in the same absolute coordinate space, returns the coordinates of this point expressed relative to the frame intrinsic coordinate space.
The relative coordinates of the frame are NSMakeRect(0, 0, 1, 1).
The frame must have a non zero width and height, otherwise an exception is raised.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{
    if ((rect.size.width<=0) || (rect.size.height<=0))
        [NSException raise:NSInvalidArgumentException format:@"iTM2IntrinsicPointRelativeToFrame bad size:got %@.", NSStringFromRect(rect)];
    return NSMakePoint((point.x - rect.origin.x)/rect.size.width, (point.y - rect.origin.y)/rect.size.height);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PointConvertedToGlobal
NSPoint iTM2PointConvertedToGlobal(NSPoint point, NSRect rect)
/*"This is the convers operation of the above one.
Given a frame and a point in the frame intrinsic coordinate space, returns the coordinates of the point given relative to the frame in the global space coordinates.
The relative coordinates of the frame are NSMakeRect(0, 0, 1, 1).
The frame must have a non zero width and height, otherwise an exception is raised.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{
    if ((rect.size.width<=0) || (rect.size.height<=0))
        [NSException raise:NSInvalidArgumentException format:@"iTM2RelativePointIntrinsicToFrame bad size:got %@.", NSStringFromRect(rect)];
    return NSMakePoint(rect.origin.x+point.x*rect.size.width, rect.origin.y+point.y*rect.size.height);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CenterRect
NSRect iTM2CenterRect(NSRect rect, NSPoint newCenter)
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{
    return NSOffsetRect(rect, -NSMidX(rect) + newCenter.x, -NSMidY(rect) + newCenter.y);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Geometry

@implementation NSView(iTM2SplitKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosingSplitView
- (NSSplitView *)enclosingSplitView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [_superview isKindOfClass:[NSSplitView class]]? _superview:[_superview enclosingSplitView];
}
@end

@implementation NSWindowController(iTM2AutoSplitKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splittableEnclosingViewForView:vertical:
- (NSView *)splittableEnclosingViewForView:(NSView *)view vertical:(BOOL)yorn;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled>1000)// only for testing purpose!!!
	{
loop:
		if ([view isKindOfClass:[NSView class]])
		{
//START4iTM3;
			NSView * ESV = [view enclosingSplitView];
			if (ESV)
			{
				NSView * superview;
				NSView * result = view;
				while((superview = [result superview]) && (superview != ESV))
					result = superview;
				return result;
			}
			while((view = [view superview]) && ![view isKindOfClass:[NSScrollView class]])
				;
			return view;//view.enclosingScrollView;
		}
		id first = self.window.firstResponder;
		if (view == first)
			return nil;
		view = first;
		goto loop;
	}
	return nil;
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
	if (iTM2DebugEnabled>10000)
	{
		if (!view)
			view = (id)self.window.firstResponder;
		if ([view isKindOfClass:[NSView class]])
		{
	//END4iTM3;
			NSView * ESV = [view enclosingSplitView];
			if (ESV)
			{
				NSView * superview;
				while((superview = [view superview]) && (superview != ESV))
					view = superview;
				return view;
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
//END4iTM3;
	return iTM2DebugEnabled>10000? [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:view]]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unsplit:
- (void)unsplit:(NSView *)view;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSSplitView * ESV = [view enclosingSplitView];
	if (ESV)
	{
		NSView * superview = [view superview];
		while(![ESV isEqual:superview])
		{
			view = superview;
			superview = [view superview];
		}
		[view performSelector:@selector(class) withObject:nil afterDelay:5];// long autorelease
		NSUInteger idx = [[ESV subviews] indexOfObject:view];
		id FR = nil;
		if ([[ESV subviews] count] > 2)
		{
			[view removeFromSuperview];
			[self.window.contentView setNeedsDisplay:YES];
			[self didRemoveSplittingView:view];
			if ((self.window == self.window.firstResponder) || (nil == self.window.firstResponder))
			{
				FR = [[ESV subviews] objectAtIndex:(idx>ZER0? idx-1:idx)];
				if ([FR acceptsFirstResponder])
				{
					[self.window makeFirstResponder:FR];
				}
			}
		}
		else
		{
			[view removeFromSuperview];
			// there is only one remaining view
			view = [[ESV subviews] lastObject];
			[[ESV retain] autorelease];
			[[ESV superview] replaceSubview:ESV with:view];
			[view setFrame:ESV.frame];
			[self.window.contentView setNeedsDisplay:YES];
			[self didRemoveSplittingView:ESV];
			if ((self.window == self.window.firstResponder) || (nil == self.window.firstResponder))
			{
				FR = [[ESV subviews] objectAtIndex:(idx>ZER0? idx-1:idx)];
				if ([FR acceptsFirstResponder])
				{
					[self.window makeFirstResponder:FR];
				}
			}
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  split:vertical:createSplitView:
- (void)split:(NSView *)view vertical:(BOOL)vertical createSplitView:(BOOL)create;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSResponder * first = self.window.firstResponder;
	NSView * enclosing = [self splittableEnclosingViewForView:view vertical:vertical];
	NSSplitView * superview = (NSSplitView*)[enclosing superview];
	if ([superview isKindOfClass:[NSSplitView class]] &&
		(([superview isVertical] && vertical) || (![superview isVertical] && !vertical))
			&& !create)
	{
		NSSize size = enclosing.frame.size;
		if (vertical)
		{
			size.width -= [superview dividerThickness];
			size.width /= 2;
		}
		else
		{
			size.height -= [superview dividerThickness];
			size.height /= 2;
		}
		[enclosing setFrameSize: size];
		NSView * duplicateView = [self duplicateViewForSplitting:enclosing vertical:vertical];
		[duplicateView setFrameSize: size];
		[superview addSubview:duplicateView positioned:NSWindowAbove relativeTo:enclosing];
		// the scroll views are not properly set up
		[superview adjustSubviews];
		[self didAddSplittingView:duplicateView];
	}
	else if (superview)
	{
		NSSplitView * SV = [[[NSSplitView alloc] initWithFrame:enclosing.frame] autorelease];
		[SV setVertical:vertical];
		[SV setAutoresizingMask:[enclosing autoresizingMask]];
		NSSize size = enclosing.frame.size;
		if (vertical)
		{
			size.width -= [SV dividerThickness];
			size.width /= 2;
		}
		else
		{
			size.height -= [SV dividerThickness];
			size.height /= 2;
		}
		[enclosing setFrameSize: size];
		NSView * duplicateView = [self duplicateViewForSplitting:enclosing vertical:vertical];
		[duplicateView setFrameSize: size];
		[SV addSubview:duplicateView];
		[enclosing performSelector:@selector(class) withObject:nil afterDelay:0];
		[superview replaceSubview:enclosing with:SV];
		[SV addSubview:enclosing positioned:NSWindowAbove relativeTo:duplicateView];
		[SV adjustSubviews];
		[self didAddSplittingView:duplicateView];
	}
	else
		return;
	if ([first acceptsFirstResponder])
	{
		[self.window performSelector:@selector(makeFirstResponder:) withObject:first afterDelay:0.001];// does not work?
	}
	[self.window.contentView setNeedsDisplay:YES];
//END4iTM3;
	return;
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
	return;
//END4iTM3;
}
#pragma mark  =-=-=-=-=-  007
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitVertical:
- (IBAction)splitVertical:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	SEL selector = @selector(split:vertical:createSplitView:);
	NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
	invocation.target = self;
	[invocation setSelector:selector];
	NSView * view = [sender isKindOfClass:[NSView class]]? sender:nil;
	[invocation setArgument:&view atIndex:2];
	BOOL flag = YES;
	[invocation setArgument:&flag atIndex:3];
	flag = NO;
	[invocation setArgument:&flag atIndex:4];
	[NSTimer scheduledTimerWithTimeInterval:0 invocation:invocation repeats:NO];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitHorizontal:
- (IBAction)splitHorizontal:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	SEL selector = @selector(split:vertical:createSplitView:);
	NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
	invocation.target = self;
	[invocation setSelector:selector];
	NSView * view = [sender isKindOfClass:[NSView class]]? sender:nil;
	[invocation setArgument:&view atIndex:2];
	BOOL flag = NO;
	[invocation setArgument:&flag atIndex:3];
	flag = NO;
	[invocation setArgument:&flag atIndex:4];
	[NSTimer scheduledTimerWithTimeInterval:0 invocation:invocation repeats:NO];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitClose:
- (IBAction)splitClose:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self unsplit:[self unsplittableEnclosingViewForView:([sender isKindOfClass:[NSView class]]? sender:nil)]];
//END4iTM3;
	return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ScrollerToolbarKit

@interface iTM2ScrollerToolbar(PRIVATE)
- (void)setPosition4iTM3:(iTM2ScrollerToolbarPosition)position;
@end
@implementation iTM2ScrollerToolbar
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollerToolbarForPosition:
+ (id)scrollerToolbarForPosition:(iTM2ScrollerToolbarPosition)position;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ScrollerToolbar * result = [[self.alloc initWithFrame:NSMakeRect(0, 0, [NSScroller scrollerWidth], [NSScroller scrollerWidth])] autorelease];
	result.position4iTM3 = position;
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  encodeWithCoder:
- (void)encodeWithCoder:(NSCoder *)aCoder;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super encodeWithCoder:aCoder];
	NSUInteger position = self.position4iTM3;
	[aCoder encodeValueOfObjCType:@encode(NSUInteger) at:&position];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSUInteger position;
		[aDecoder decodeValueOfObjCType:@encode(NSUInteger) at:&position];
		self.position4iTM3 = position;
	}
//END4iTM3;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  position4iTM3
@synthesize position4iTM3 = _position4iTM3;
@end

@implementation NSScrollView(iTM2ViewKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ViewKit_tile
- (void)SWZ_iTM2ViewKit_tile;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jun 29 14:36:07 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self SWZ_iTM2ViewKit_tile];
	for (iTM2ScrollerToolbar * subview in self.subviews) {
		if ([subview isKindOfClass:[iTM2ScrollerToolbar class]]) {
			switch(subview.position4iTM3) {
				case iTM2ScrollerToolbarPositionTop:
				{
//LOG4iTM3(@"PLACING TOP");
					NSScroller * scroller = self.verticalScroller;
					NSRect scrollerFrame = scroller.frame;
					NSRect subviewFrame = subview.frame;
					//
					subviewFrame.origin.x = scrollerFrame.origin.x;
					subviewFrame.size.width = scrollerFrame.size.width;
					//
					subviewFrame.origin.y = NSMaxY(scrollerFrame) - subviewFrame.size.height;
					scrollerFrame.size.height -= subviewFrame.size.height;
					//
					[subview setFrame:subviewFrame];
					[scroller setFrame:scrollerFrame];
				}
				break;
				case iTM2ScrollerToolbarPositionBottom:
				{
//LOG4iTM3(@"PLACING BOTTOM");
					NSScroller * scroller = self.verticalScroller;
					NSRect scrollerFrame = scroller.frame;
					NSRect subviewFrame = subview.frame;
					//
					subviewFrame.origin.x = scrollerFrame.origin.x;
					subviewFrame.size.width = scrollerFrame.size.width;
					//
					subviewFrame.origin.y = scrollerFrame.origin.y;
					scrollerFrame.origin.y += subviewFrame.size.height;
					scrollerFrame.size.height -= subviewFrame.size.height;
					//
					[subview setFrame:subviewFrame];
					[scroller setFrame:scrollerFrame];
				}
				break;
				case iTM2ScrollerToolbarPositionLeft:
				{
//LOG4iTM3(@"PLACING LEFT");
					NSScroller * scroller = self.horizontalScroller;
					NSRect scrollerFrame = scroller.frame;
					NSRect subviewFrame = subview.frame;
					//
					subviewFrame.origin.x = scrollerFrame.origin.x;
					scrollerFrame.origin.x += subviewFrame.size.width;
					scrollerFrame.size.width -= subviewFrame.size.width;
					//
					subviewFrame.origin.y = scrollerFrame.origin.y;
					subviewFrame.size.height = scrollerFrame.size.height;
					//
					[subview setFrame:subviewFrame];
					[scroller setFrame:scrollerFrame];
				}
				break;
				case iTM2ScrollerToolbarPositionRight:
				{
//LOG4iTM3(@"PLACING RIGHT");
					NSScroller * scroller = self.horizontalScroller;
					NSRect scrollerFrame = scroller.frame;
					NSRect subviewFrame = subview.frame;
					//
					subviewFrame.origin.x = NSMaxX(scrollerFrame) - subviewFrame.size.width;
					scrollerFrame.size.width -= subviewFrame.size.width;
					//
					subviewFrame.origin.y = scrollerFrame.origin.y;
					subviewFrame.size.height = scrollerFrame.size.height;
					//
					[subview setFrame:subviewFrame];
					[scroller setFrame:scrollerFrame];
				}
				break;
				default:
				// do nothing, unsupported
				break;
			}
		}
    }
//END4iTM3;
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ScrollerToolbarKit

@implementation iTM2SmallToolbarBackgroundView
- (void)drawRect:(NSRect) aRect;
{
	NSImage * image = [NSImage cachedImageNamed4iTM3:@"iTM2SmallToolbarBackground"];
	// now draw the background
	NSRect fromRect = NSZeroRect;
	fromRect.size = [image size];	
	[image drawInRect:self.bounds fromRect:fromRect operation:NSCompositeCopy fraction:1];
	[super drawRect:aRect];
	return;
}
@end

@interface iTM2StackView()
@property (retain, readwrite) NSMutableArray * orderedSubviews4iTM3;
@end

@implementation iTM2StackView
- (id)initWithFrame:(NSRect)frameRect;
{
	if ((self = [super initWithFrame:(NSRect)frameRect])) {
		[self setPostsFrameChangedNotifications:YES];
		[self setAutoresizesSubviews:YES];
		[DNC addObserver:self
				selector:@selector(viewFrameDidChangeNotified:)
					name:NSViewFrameDidChangeNotification
						object:nil];
		self.orderedSubviews4iTM3 = [[NSMutableArray array] retain];
	}
	return self;
}
- (BOOL)isFlipped;
{
	return YES;
}
#define VERT_PADDING 2
- (void)stackAndFit;
{
	[DNC removeObserver:self name:NSViewFrameDidChangeNotification object:nil];
	NSEnumerator * E = [self.orderedSubviews4iTM3 objectEnumerator];
	NSView * V;
	NSRect bounds = self.bounds;
	NSPoint origin = bounds.origin;
	if ((V = [E nextObject]))
	{
		NSRect frame = V.frame;
		frame.origin = origin;
		frame.size.width = bounds.size.width;
		[V setFrame:frame];
		origin.y = NSMaxY(frame);
		while((V = [E nextObject]))
		{
			origin.y += VERT_PADDING;
			frame = V.frame;
			frame.origin = origin;
			frame.size.width = bounds.size.width;
			[V setFrame:frame];
			origin.y = NSMaxY(frame);
		}
		bounds.size.height = origin.y - bounds.origin.y;
		NSRect oldBounds = self.bounds;
		if (!NSEqualRects(bounds,oldBounds))
		{
			frame = [self convertRect:bounds toView:self.superview];
			[self setAutoresizesSubviews:NO];
			[self setFrame:frame];
			[self setAutoresizesSubviews:YES];
			[self setNeedsDisplayInRect:bounds];
		}
	}
	[DNC addObserver:self
			selector:@selector(viewFrameDidChangeNotified:)
				name:NSViewFrameDidChangeNotification
					object:nil];
	return;
}
- (void)viewFrameDidChangeNotified:(NSNotification *)notification;
{
	NSView * V = notification.object;
	if ([self isEqual:V.superview])
	{
		[self stackAndFit];
	}
	return;
}
- (void)addSubview:(NSView *)aView positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView;
{
	NSUInteger index = [self.orderedSubviews4iTM3 indexOfObject:aView];
	if (index == NSNotFound)
	{
		index = [self.orderedSubviews4iTM3 indexOfObject:otherView];
		if (index != NSNotFound)
		{
			if (place<0)
			{
				++index;
			}
			[self.orderedSubviews4iTM3 insertObject:aView atIndex:index];
			[super addSubview:(NSView *)aView positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView];
			[self stackAndFit];
			return;
		}
	}
	[super addSubview:(NSView *)aView positioned:(NSWindowOrderingMode)place relativeTo:(NSView *)otherView];
	return;
}
- (void)replaceSubview:(NSView *)oldView with:(NSView *)newView;
{
	NSUInteger index = [self.orderedSubviews4iTM3 indexOfObject:oldView];
	if (index != NSNotFound)
	{
		[self.orderedSubviews4iTM3 replaceObjectAtIndex:index withObject:newView];
		[super replaceSubview:oldView with:newView];
		[self stackAndFit];
		return;
	}
	[super replaceSubview:oldView with:newView];
	return;
}
- (void)didAddSubview:(NSView *)subview;
{
	NSUInteger index = [self.orderedSubviews4iTM3 indexOfObject:subview];
	if (index == NSNotFound)
	{
		index = [self.subviews indexOfObject:subview];
		NSLog(@"added at subviews index:%i",index);
		NSView * V;
		if (index == NSNotFound)
		{
			index = ZER0;
		}
		else if (index)
		{
			V = [self.subviews objectAtIndex:index-1];
			index = [self.orderedSubviews4iTM3 indexOfObject:V];
			if (index == NSNotFound)
			{
				NSLog(@"**** THIS IS AN ERROR, the stack view missed an added subview");
				index = self.orderedSubviews4iTM3.count;
			}
			else
			{
				++index;
			}
		}
		[self.orderedSubviews4iTM3 insertObject:subview atIndex:index];
		[super didAddSubview:subview];
		[self stackAndFit];
		return;
	}
	[super didAddSubview:subview];
	return;
}
- (void)willRemoveSubview:(NSView *)subview;
{
	[super willRemoveSubview:(NSView *)subview];
	[self.orderedSubviews4iTM3 removeObject:subview];
	[self stackAndFit];
	return;
}
- (void)resizeSubviewsWithOldSize:(NSSize)oldSize;
{
	[self stackAndFit];
	return;
}
#if 1
- (void)drawRect:(NSRect)aRect;
{
	NSLog(@"Stack view frame:%@",NSStringFromRect(self.frame));
	[super drawRect:aRect];
	NSRect R = self.bounds;
	NSPoint P1 = R.origin;
	NSPoint P2 = NSZeroPoint;
	P2.x = NSMaxX(R);
	P2.y = NSMaxY(R);
	[[NSColor magentaColor] set];
	[NSBezierPath strokeLineFromPoint:P1 toPoint:P2];
	P1.x = P2.x;
	P2.x = NSMinX(R);
	[NSBezierPath strokeLineFromPoint:P1 toPoint:P2];
	NSFrameRect(R);
}
#endif
@synthesize orderedSubviews4iTM3 = iVarOrderedSubviews4iTM3;
@end

@implementation iTM2MainInstaller(ViewKit)
+ (void)prepareViewKitCompleteInstallation4iTM3;
{
	if ([NSScrollView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ViewKit_tile) error:NULL]) {
		MILESTONE4iTM3((@"NSScrollView(iTM2ViewKit)"),(@"..........  ERROR: Bad configuration, no auto scroller toolbar..."));
	}
}
@end

//