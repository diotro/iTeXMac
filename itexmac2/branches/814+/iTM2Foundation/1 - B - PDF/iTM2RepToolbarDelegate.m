/*
//  iTeXMac
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jan 06 2002.
//  Copyright © 2001-2005 Laurens'Tribune. All rights reserved.
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

#import "iTM2RepToolbarDelegate.h"
#import "iTM2BundleKit.h"
#import "iTM2HelpKit.h"
#import "iTM2ButtonKit.h"
#import "iTM2MenuKit.h"
#import "iTM2TextFieldKit.h"

NSString * const iTM2ToolbarMagnificationFieldItemIdentifier = @"takeMagnificationFromField:";
NSString * const iTM2ToolbarMagnificationSetItemIdentifier = @"Magnification";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2RepToolbarDelegate
/*"Description forthcoming."*/
@implementation iTM2RepToolbarDelegate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 21:52:55 UTC 2010
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    if (self = [super init]) {
        self.lastMagnificationITII = nil;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnification:
- (void)setMagnification:(NSDecimalNumber *)aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 21:53:34 UTC 2010
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    if ([aMagnification respondsToSelector:@selector(floatValue)]) {
        self.magnificationField.floatValue = aMagnification.floatValue;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 21:53:41 UTC 2010
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    return [NSArray arrayWithObjects:
                NSToolbarPrintItemIdentifier,
                NSToolbarSeparatorItemIdentifier,
                NSToolbarFlexibleSpaceItemIdentifier,
                iTM2ToolbarMagnificationFieldItemIdentifier,
                NSToolbarFlexibleSpaceItemIdentifier,
                NSToolbarSeparatorItemIdentifier,
                iTM2ToolbarShowHelpItemIdentifier,
                    nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 21:53:49 UTC 2010
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    return [NSArray arrayWithObjects:
                iTM2ToolbarMagnificationFieldItemIdentifier,
                iTM2ToolbarMagnificationSetItemIdentifier,
                iTM2ToolbarShowHelpItemIdentifier,
                NSToolbarPrintItemIdentifier,
                NSToolbarSeparatorItemIdentifier,
                NSToolbarFlexibleSpaceItemIdentifier,
                NSToolbarSpaceItemIdentifier,
                    nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 21:54:01 UTC 2010
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    NSToolbarItem * result = nil;
    if ([anItemIdentifier isEqualToString:iTM2ToolbarMagnificationFieldItemIdentifier]) {
        result = [[NSToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];
        result.view = aFlag?self.magnificationFieldForToolbar:self.magnificationFieldForPalette;
    } else if ([anItemIdentifier isEqualToString:iTM2ToolbarMagnificationSetItemIdentifier]) {
        result = [[NSToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];
        result.view = aFlag?self.magnificationSetForToolbar:self.magnificationSetForPalette;
    } else {
        return result;
    }
    result.minSize = result.maxSize = [[result view] frame].size;
    NSString * identifier = [result itemIdentifier];
    result.toolTip = NSLocalizedStringFromTableInBundle(identifier, @"BasicToolbarToolTip", myBUNDLE, "");
    result.paletteLabel = NSLocalizedStringFromTableInBundle(identifier, @"BasicToolbarPaletteLabel", myBUNDLE, "");
    result.label = NSLocalizedStringFromTableInBundle(identifier, @"BasicToolbarLabel", myBUNDLE, "");
    if (aFlag) {
        if ((self.lastMagnificationITII!=nil)&&![self.lastMagnificationITII isEqualToString:anItemIdentifier]) {
            BOOL removeFlag=NO;
            NSUInteger index;
            for(index=0; index<aToolbar.items.count; ++index) {
                if ([[[aToolbar.items objectAtIndex:index] itemIdentifier] isEqualToString:self.lastMagnificationITII]) {
                    removeFlag=YES;
                    break;
                }
            }
            if (removeFlag) {
                [aToolbar removeItemAtIndex:index];
            }
        }
        self.lastMagnificationITII = anItemIdentifier;
    }
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationFieldForPalette
- (NSView *)magnificationFieldForPalette;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    id result = [[NSView alloc] initWithFrame:NSMakeRect(0,0,60,32)];
    NSTextField * magnificationField = [[NSTextField alloc] initWithFrame:self.magnificationField.frame];
    magnificationField.stringValue = @"100 %";
    [magnificationField setFrameOrigin: NSMakePoint(3,6)];
    [result addSubview:magnificationField];
    [magnificationField release];
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationFieldForToolbar
- (NSView *)magnificationFieldForToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 11:02:54 UTC 2010
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    id result = [[NSView alloc] initWithFrame:NSMakeRect(0,0,60,32)];
    id O = [self.magnificationField objectValue]; // GC friendly
    self.magnificationField = nil; // clean
    [self.magnificationField setObjectValue:O];
    [self.magnificationField setFrameOrigin: NSMakePoint(3,6)];
    [result addSubview:self.magnificationField];// insert in view
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationSetForPalette
- (NSView *)magnificationSetForPalette;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 11:05:09 UTC 2010
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    NSView * result = [[NSView alloc] initWithFrame:NSZeroRect];
    NSStepper * stepper = [[NSStepper alloc] initWithFrame:self.magStepper.frame];
    [stepper setFrameOrigin: NSMakePoint(0,2)];
    [result addSubview:stepper];
    [result setFrameSize: NSUnionRect(stepper.frame, result.frame).size];

    NSTextField * magnificationField = [[NSTextField alloc] initWithFrame:self.magnificationField.frame];
    magnificationField.stringValue = @"100 %";
    [magnificationField setFrameOrigin: NSMakePoint(result.frame.origin.x+result.frame.size.width+4,6)];
    [result addSubview:magnificationField];
    
    [result setFrameSize:NSUnionRect(NSInsetRect(magnificationField.frame, -4, 0), result.frame).size];
    iTM2ButtonMixed * button = [[iTM2ButtonMixed alloc] initWithFrame:NSMakeRect(0,0,16,26)];
    [button setTitle:[NSString string]];
    [button setContinuous:NO];
    [button setCenteredArrow:YES];
    [button setBordered:YES];
    [button setFrameOrigin: NSMakePoint(result.frame.origin.x+result.frame.size.width,4)];
    [button setMenu:[[[NSMenu alloc] initWithTitle:@""] autorelease]];
    [button.menu addItemWithTitle:@"Nothing" action:@selector(action:) keyEquivalent:[NSString string]];
    [result addSubview:button];
    [result setFrameSize: NSUnionRect(button.frame, result.frame).size];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationSetForToolbar
- (NSView *)magnificationSetForToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    NSView * result = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];

    self.magStepper = nil;
    [result addSubview:self.magStepper];
    [self.magStepper setFrameOrigin: NSMakePoint(0,2)];
    [result setFrameSize: NSUnionRect(self.magStepper.frame, result.frame).size];
    
    id O = self.magnificationField.objectValue; // GC friendly
    self.magnificationField = nil;
    [self.magnificationField setObjectValue:O]; // lazy initializer
    [self.magnificationField setFrameOrigin: NSMakePoint(result.frame.origin.x+result.frame.size.width+4,6)];
    [result addSubview:self.magnificationField];
    [result setFrameSize:NSUnionRect(NSInsetRect(self.magnificationField.frame, -4, 0), result.frame).size];

    iTM2ButtonMixed * button = [[[iTM2ButtonMixed alloc] initWithFrame:NSMakeRect(0,0,16,26)] autorelease];
    [button setTitle:[NSString string]];
    [button setContinuous:NO];
    [button setCenteredArrow:YES];
    [button setBordered:NO];

#warning Small size menu view is missing
    NSMenu * menu = [[[NSMenu alloc] initWithTitle:@"Magnification"] autorelease];
	
    NSMenuItem * menuItem = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(displayAtMagnification:)];
    NSMenuItem * MI = nil;
    for (menuItem in menuItem.menu.itemArray) {
        MI = [menuItem copy];
        MI.representedObject = [menuItem representedObject];
        [menu addItem:MI];
        [MI release];
    }

    BOOL shouldInsertSeparatorItem = NO;
    NSInteger shouldInsertSeparatorIndex = [menu numberOfItems];
    menuItem = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(toggleStickToWidth:)];
    for (MI in menuItem.menu.itemArray) {
        SEL action=MI.action;
        if ( action == @selector(displayAtFixedSize:) ||
                action == @selector(displayFitToWidth:) ||
                action == @selector(displayFitToHeight:) ||
                action == @selector(displayFitToView:)) {
            [menu addItem:[[MI copy] autorelease]];
            shouldInsertSeparatorItem = YES;
        }
    }
    if (shouldInsertSeparatorItem) {
        [menu insertItem:[NSMenuItem separatorItem] atIndex:shouldInsertSeparatorIndex];
    }
    shouldInsertSeparatorItem = NO;
    shouldInsertSeparatorIndex = [menu numberOfItems];
    for (MI in menuItem.menu.itemArray) {
        SEL action=MI.action;
        if ( action == @selector(toggleStickToWindow:) ||
            action == @selector(toggleStickToWidth:) ||
            action == @selector(toggleStickToHeight:) ||
            action == @selector(toggleStickToView:))
        {
            [menu addItem:[[MI copy] autorelease]];
            shouldInsertSeparatorItem = YES;
        }
    }
    if (shouldInsertSeparatorItem) {
        [menu insertItem:[NSMenuItem separatorItem] atIndex:shouldInsertSeparatorIndex];
    }

    [button setMenu:menu];
    [button setFrameOrigin: NSMakePoint(result.frame.origin.x+result.frame.size.width,4)];

    [result addSubview:button];
    [result setFrameSize: NSUnionRect(button.frame, result.frame).size];

    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magnificationField
- (NSTextField *)magnificationField;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    if (!_MagnificationField) {
        _MagnificationField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [_MagnificationField setFormatter:[[[iTM2MagnificationFormatter alloc] init] autorelease]];
        _MagnificationField.action = @selector(takeMagnificationFromField:);
        [_MagnificationField setAlignment:NSRightTextAlignment];
        [_MagnificationField setFrameSize:NSMakeSize([[[_MagnificationField formatter]
                stringForObjectValue: [NSDecimalNumber numberWithFloat:64.0]]
                #warning APPENDING % ?
                        sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                [_MagnificationField.cell font], NSFontAttributeName, nil]].width+8, 22)];
////        [_MagnificationField setEnabled:(self.representation != nil)];
    }
    return _MagnificationField;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magStepper
- (NSStepper *)magStepper;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    if (!_MagStepper) {
        NSRect frame = NSMakeRect(0,0,19,32);
        _MagStepper = [NSStepper alloc];
        _MagStepper = [_MagStepper initWithFrame:frame];
        [_MagStepper setIncrement:1];
        [_MagStepper setMinValue:-1];
        [_MagStepper setMaxValue:1];
        [_MagStepper setIntegerValue:0];
        [_MagStepper setValueWraps:0];
        _MagStepper.action = @selector(takeMagnificationFromStepper:);
        _MagStepper.target = nil;
    }
    return _MagStepper;
}
@synthesize lastMagnificationITII = __LastMagnificationITII;
@synthesize magStepper = _MagStepper;
@synthesize magnificationField = _MagnificationField;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2RepToolbarDelegate

