/*
//  iTM2LaTeXSymbolsKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 24 2002.
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


#import "iTM2LaTeXSymbolsKit.h"

NSString * const kiTM2TrackerKey = @"kiTM2TrackerKey";

@implementation iTM2DSymbolView
- (void)setupWithName:(NSString *)aName bundle:(NSBundle *)aBundle;
{
	//START4iTM3;
	self.image = [[NSImage alloc] initWithContentsOfFile:[aBundle pathForImageResource:aName]];
	[self.image setFlipped:YES];
	NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:[aBundle pathForResource:aName ofType:@"dict"]];
	self.items = [D objectForKey:@"items"];
	id O = [D objectForKey:@"numberOfColumns"];
	self.numberOfColumns=[O respondsToSelector:@selector(integerValue)]? MAX(1, [O integerValue]):1;
	NSInteger NORs = MAX(1,self.items.count/self.numberOfColumns);
	self.numberOfRows = NORs * self.numberOfColumns < self.items.count? NORs + 1: NORs;
	NSRect aFrame = NSZeroRect;
	aFrame.size = self.image.size;
	aFrame.size.height /= 2.0;
	self.frame=aFrame;
	if (self.trackingAreas == nil)
	{
		NSTrackingAreaOptions trackingOptions = NSTrackingEnabledDuringMouseDrag |
		NSTrackingMouseEnteredAndExited |
		NSTrackingActiveInActiveApp |
		NSTrackingActiveAlways;
		self.trackingAreas = [NSMutableArray array];	// keep all tracking areas in an array
		NSInteger index = 0;
		NSInteger row = 0;
		NSInteger column = 0;
		NSRect frame = self.bounds;
		frame.size.width/=self.numberOfColumns;
		frame.size.height/=self.numberOfRows;
		for(row=0;row<self.numberOfRows;++row) {
			frame.origin.y = row*frame.size.height;
			for(column=0;column<self.numberOfColumns;++column) {
				if(index<self.items.count) {
					frame.origin.x = column*frame.size.width;
					NSDictionary* trackerData = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInteger: index], kiTM2TrackerKey, nil];
					NSTrackingArea* trackingArea = [[NSTrackingArea alloc]
													initWithRect: frame
													options: trackingOptions
													owner: self
													userInfo: trackerData];
					[self.trackingAreas addObject:trackingArea];	// keep track of this tracking area for later disposal
					[self addTrackingArea: trackingArea];	// add the tracking area to the view/window
					++index;
				} else {
					break;
				}
			}
		}
	}
	return;
}
- (BOOL)isFlipped;
{
	return YES;
}
- (NSInteger)getTrackerIndex
{
	NSPoint mousePoint = [self convertPoint: [self.window mouseLocationOutsideOfEventStream] fromView:nil];
	NSRect bounds = self.bounds;
	if(NSPointInRect(mousePoint, bounds)) {
		NSInteger row = (mousePoint.y - NSMinY(bounds))/bounds.size.height*self.numberOfRows;
		NSInteger column = (mousePoint.x - NSMinX(bounds))/bounds.size.width*self.numberOfColumns;
		NSInteger index = row * self.numberOfColumns + column;
		if(index<self.items.count) {
			NSString * item = [self.items objectAtIndex:index];
			if(item.length && ![item isEqual:@"noop:"]) {
				return index;
			}
		}
	}
	return NSNotFound;
}
-(void)drawRect:(NSRect)rect
{
	//fromRect.origin.y += self.bounds.size.height;
	[self.image drawInRect:rect fromRect:rect operation:NSCompositeSourceOver fraction:1];
	NSInteger index = self.getTrackerIndex;
	if(index != NSNotFound) {
		NSUInteger row = index/self.numberOfColumns;
		NSUInteger column = index%self.numberOfColumns;
		NSRect fromRect = self.bounds;
		fromRect.size.width/=self.numberOfColumns;
		fromRect.size.height/=self.numberOfRows;
		fromRect.origin.x = column*fromRect.size.width;
		fromRect.origin.y = row*fromRect.size.height;
		fromRect = NSIntersectionRect(fromRect, rect);
		rect=fromRect;
		[NSGraphicsContext saveGraphicsState];
		[[NSColor selectedMenuItemColor] set];
		NSRectFill(rect);//some kind of gradient would be welcome but the selectedMenuItemColor is not correct with NSGradient
		[NSGraphicsContext restoreGraphicsState];
		fromRect.origin.y+=NSHeight(self.bounds);
		[self.image drawInRect:rect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
	}
}
// -------------------------------------------------------------------------------
//	mouseEntered:event
//
//	Because we installed NSTrackingArea to our NSImageView, this method will be called.
// -------------------------------------------------------------------------------
- (void)mouseEntered:(NSEvent*)event
{
	[self setNeedsDisplay:YES];	// force update the currently tracked label back to its original color
}
- (void)mouseExited:(NSEvent*)event
{
	[self setNeedsDisplay:YES];	// force update the currently tracked label to a lighter color
}
// -------------------------------------------------------------------------------
//	mouseUp:event
// -------------------------------------------------------------------------------
- (void)mouseUp:(NSEvent*)event
{
	NSInteger index = self.getTrackerIndex;
	if(index!=NSNotFound) {
		// here you would respond to the particular label selection...
		NSLog(@"label %d was selected", index);
	}
	// on mouse up, we want to dismiss the menu being tracked
	NSMenu* menu = self.enclosingMenuItem.menu;
	[menu cancelTracking];
	[self setNeedsDisplay:YES];
}

@synthesize image=_Image;
@synthesize items=_Items;
@synthesize numberOfColumns=_NumberOfColumns;
@synthesize numberOfRows=_NumberOfRows;
@synthesize trackingAreas=_TrackingAreas;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SymbolMenu
/*"Description forthcoming."*/
@implementation iTM2DSymbolMenu
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
    [super awakeFromNib];
    while(self.numberOfItems>0)
        [self removeItemAtIndex:0];
	NSMenuItem * MI = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent: @""];
	[self addItem:MI];
	[MI release];
	iTM2DSymbolView * V = [[iTM2DSymbolView alloc] initWithName:NSStringFromClass(self.class)];
	MI.view = V;
	[V release];
    return;
}
@end

#define IMPL(arg) @implementation arg @end
IMPL(iTM2LaTeXArrowsMenu)
IMPL(iTM2LaTeXRelationsMenu)
IMPL(iTM2LaTeXRelationsNotMenu)
IMPL(iTM2LaTeXBinaryMenu)
IMPL(iTM2LaTeXMiscMenu)
IMPL(iTM2LaTeXCalMenu)
IMPL(iTM2LaTeXVariableMenu)
IMPL(iTM2LaTeXForeignMenu)
IMPL(iTM2LaTeXAccentMenu)
IMPL(iTM2LaTeXSymbolMenu)
IMPL(iTM2LaTeXGreekMenu)
IMPL(iTM2LaTeXGreekCapsMenu)
IMPL(iTM2AMSArrowsMenu)
IMPL(iTM2AMSBinaryMenu)
IMPL(iTM2AMSMiscMenu)
IMPL(iTM2AMSOrdinaryMenu)
IMPL(iTM2AMSRelationCurlMenu)
IMPL(iTM2AMSRelationMenu)
IMPL(iTM2AMSRelationSetMenu)
IMPL(iTM2AMSRelationSimMenu)
IMPL(iTM2AMSRelationTriangleMenu)
IMPL(iTM2AMSMathfrakMenu)
IMPL(iTM2AMSMathbbMenu)
IMPL(iTM2AMSMathfrakCapsMenu)
IMPL(iTM2MathbbMenu)
IMPL(iTM2MathbbCapsMenu)
IMPL(iTM2MathbbNumMenu)
IMPL(iTM2MathbbGreekMenu)
IMPL(iTM2MathrsfsMenu)
IMPL(iTM2MVSArrowsMenu)
IMPL(iTM2MVSMiscMenu)
IMPL(iTM2MVSDeskMenu)
IMPL(iTM2MVSZodiacMenu)
IMPL(iTM2MVSNumbersMenu)
IMPL(iTM2WSBoxMenu)
IMPL(iTM2WSMathMenu)
IMPL(iTM2WSMiscMenu)
IMPL(iTM2WSMhoMenu)
IMPL(iTM2WSZodiacMenu)
IMPL(iTM2PiFontMisc1Menu)
IMPL(iTM2PiFontMisc2Menu)
IMPL(iTM2PiFontDigitsMenu)
IMPL(iTM2PiFontArrowsMenu)
IMPL(iTM2PiFontStarsMenu)

NSString * const iTM2SymbolMenuBugKey = @"iTM2SymbolMenuBug";

#ifdef __iTeXMac2__

/*"Description forthcoming."*/
@implementation NSTextView(iTM2LaTeXSymbolsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeSymbolsInstruction:
- (void)executeSymbolsInstruction:(id)instruction;
/*"Description forthcoming.
 If the event is a 1 char key down, it will ask the current key binding for instruction.
 The key and its modifiers are 
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{
	[self performSelector:@selector(executeSymbolsInstruction4iTM3:) withObject:instruction afterDelay:0.01];
	//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeSymbolsInstruction4iTM3:
- (void)executeSymbolsInstruction4iTM3:(id)instruction;
/*"Description forthcoming.
 If the event is a 1 char key down, it will ask the current key binding for instruction.
 The key and its modifiers are 
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{
    if ([instruction isKindOfClass:[NSArray class]]) {
        for (instruction in instruction) {
            [self executeSymbolsInstruction4iTM3:instruction];
        }
    } else if([instruction isKindOfClass:[NSDictionary class]]) {
        NSString * toolTip = [instruction objectForKey:@"toolTip"];
        NSString * stringSel = [instruction objectForKey:@"selector"];
        if(toolTip.length)
            [self postNotificationWithStatus4iTM3: ([toolTip isKindOfClass:[NSString class]]? toolTip:nil)];
        if([stringSel isKindOfClass:[NSString class]])
            [self tryToPerform:NSSelectorFromString(stringSel) with:[instruction objectForKey:@"argument"]];
        else
            LOG4iTM3(@"unrecognized object: %@", stringSel);
    } else if([instruction isKindOfClass:[NSString class]]) {
        if (!([self tryToPerform:NSSelectorFromString(instruction) with:nil]) && [(NSString *)instruction length]) {
            [self tryToPerform:@selector(insertMacro:) with:instruction];
        } else {
            [self insertText:instruction];
        }
    }
    return;
}
@end

@implementation iTM2LaTeXSymbolsPanelController
@end

@implementation iTM2LaTeXSymbolsPanel
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  sharedPanel
+ (id)sharedPanel;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    static NSWindowController * WC;
	if (!WC) {
		WC = [[iTM2LaTeXSymbolsPanelController alloc] initWithWindowNibName:NSStringFromClass(self)];
	}
    return WC.window;
}
///=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  canBecomeKeyWindow
- (BOOL)canBecomeKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  positionShouldBeObserved4iTM3
- (BOOL)positionShouldBeObserved4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  frameIdentifier4iTM3
- (NSString *)frameIdentifier4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    return @"LaTeX Symbols";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  orderOut:
- (void)orderOut:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
	[self takeContext4iTM3Bool:NO forKey:@"iTM2OrderFrontLaTeXSymbolsPanel" domain:iTM2ContextAllDomainsMask];
	[super orderOut:sender];
    return;
}
@end

@implementation iTM2MainInstaller(iTM2LaTeXSymbolsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2LaTeXSymbolsKitCompleteInstallation4iTM3
+ (void)iTM2LaTeXSymbolsKitCompleteInstallation4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
	if ([self context4iTM3BoolForKey:@"iTM2OrderFrontLaTeXSymbolsPanel" domain:iTM2ContextAllDomainsMask]) {
		[[iTM2LaTeXSymbolsPanel sharedPanel] makeKeyAndOrderFront:nil];
	}
    return;
}
@end

@implementation iTM2SharedResponder(iTM2LaTeXSymbolsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  orderFrontLaTeXSymbolsPanel:
- (IBAction)orderFrontLaTeXSymbolsPanel:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    [[iTM2LaTeXSymbolsPanel sharedPanel] makeKeyAndOrderFront:sender];
	[self takeContext4iTM3Bool:YES forKey:@"iTM2OrderFrontLaTeXSymbolsPanel" domain:iTM2ContextAllDomainsMask];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOrderFrontLaTeXSymbolsPanel:
- (BOOL)validateOrderFrontLaTeXSymbolsPanel:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{
	if (!sender.image) {
		NSString * name = @"symbolPalette";
		NSImage * I = [NSImage cachedImageNamed4iTM3:name];
		if ([I isNotNullImage4iTM3]) {
			sender.image = I;
		}
	}
//END4iTM3;
    return YES;
}
@end
#endif

#include "../build/Milestones/iTM2LaTeXSymbolsKit.m"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2LaTeXSymbolsKit

