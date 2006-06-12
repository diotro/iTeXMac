/*
//  iTM2RepToolbarDelegate.m
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
- (id) init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(self = [super init])
    {
        [self->__LastMagnificationITII release];
        self->__LastMagnificationITII = nil;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void) dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [__LastMagnificationITII release];
    __LastMagnificationITII = nil;
    [self setMagnificationField:nil];
    [self setMagStepper:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnification:
- (void) setMagnification: (NSDecimalNumber *) aMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if([aMagnification respondsToSelector:@selector(floatValue)])
        [[self magnificationField] setFloatValue:[aMagnification floatValue]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar*) aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
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
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar*) aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
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
- (NSToolbarItem *) toolbar: (NSToolbar *) aToolbar itemForItemIdentifier: (NSString *) anItemIdentifier willBeInsertedIntoToolbar: (BOOL) aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSToolbarItem * result;
    if([anItemIdentifier isEqualToString:iTM2ToolbarMagnificationFieldItemIdentifier])
    {
        result = [[NSToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];
        if(aFlag)
            [result setView:[self magnificationFieldForToolbar]];
        else
            [result setView:[self magnificationFieldForPalette]];
    }
    else if([anItemIdentifier isEqualToString:iTM2ToolbarMagnificationSetItemIdentifier])
    {
        result = [[NSToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];
        if(aFlag)
            [result setView:[self magnificationSetForToolbar]];
        else
            [result setView:[self magnificationSetForPalette]];
    }
    else
        return nil;
    [result setMinSize:[[result view] frame].size];
    [result setMaxSize:[[result view] frame].size];
    {
        NSString * identifier = [result itemIdentifier];
        [result setToolTip:NSLocalizedStringFromTableInBundle(identifier, @"BasicToolbarToolTip",
                                                        [NSBundle bundleForClass:[self class]], "")];
        [result setPaletteLabel:NSLocalizedStringFromTableInBundle(identifier, @"BasicToolbarPaletteLabel",
                                                        [NSBundle bundleForClass:[self class]], "")];
        [result setLabel:NSLocalizedStringFromTableInBundle(identifier, @"BasicToolbarLabel",
                                                        [NSBundle bundleForClass:[self class]], "")];
    }
    if(aFlag)
    {
        if((__LastMagnificationITII!=nil)&&![__LastMagnificationITII isEqualToString:anItemIdentifier])
        {
            BOOL removeFlag=NO;
            int index;
            for(index=0; index<[[aToolbar items] count]; ++index)
                if([[[[aToolbar items] objectAtIndex:index] itemIdentifier] isEqualToString:__LastMagnificationITII])
                {
                    removeFlag=YES;
                    break;
                }
            if(removeFlag)
                [aToolbar removeItemAtIndex:index];
        }
        [__LastMagnificationITII release];
        __LastMagnificationITII = [anItemIdentifier copy];
    }
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationFieldForPalette
- (NSView *) magnificationFieldForPalette;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    id result = [[NSView alloc] initWithFrame:NSMakeRect(0,0,60,32)];
    NSTextField * magnificationField = [[NSTextField alloc] initWithFrame:[[self magnificationField] frame]];
    [magnificationField setStringValue:@"100 %"];
    [magnificationField setFrameOrigin:NSMakePoint(3,6)];
    [result addSubview:magnificationField];
    [magnificationField release];
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationFieldForToolbar
- (NSView *) magnificationFieldForToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    id result = [[NSView alloc] initWithFrame:NSMakeRect(0,0,60,32)];
    NSTextField * magnificationField;
    magnificationField = [[self magnificationField] retain];
    [self setMagnificationField:nil];
    [[self magnificationField] setObjectValue:[magnificationField objectValue]];
    [magnificationField release];
    magnificationField = [[self magnificationField] retain];
    [magnificationField setFrameOrigin:NSMakePoint(3,6)];
    [result addSubview:magnificationField];
    [magnificationField release];
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationSetForPalette
- (NSView *) magnificationSetForPalette;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    id result = [[NSView alloc] initWithFrame:NSZeroRect];
    {
        NSStepper * stepper = [[NSStepper alloc] initWithFrame:[[self magStepper] frame]];
        [stepper setFrameOrigin:NSMakePoint(0,2)];
        [result addSubview:stepper];
        [result setFrameSize:NSUnionRect([stepper frame], [result frame]).size];
        [stepper release];
    }
    {
        NSTextField * magnificationField = [[NSTextField alloc] initWithFrame:[[self magnificationField] frame]];
        [magnificationField setStringValue:@"100 %"];
        [magnificationField setFrameOrigin:NSMakePoint([result frame].origin.x+[result frame].size.width+4,6)];
        [result addSubview:magnificationField];
        [magnificationField release];
        [result setFrameSize:NSUnionRect(NSInsetRect([magnificationField frame], -4, 0), [result frame]).size];
    }
    {
        iTM2ButtonMixed * button = [[iTM2ButtonMixed alloc] initWithFrame:NSMakeRect(0,0,16,26)];
        [button setTitle:[NSString string]];
        [button setContinuous:NO];
        [button setCenteredArrow:YES];
        [button setBordered:NO];
        [button setFrameOrigin:NSMakePoint([result frame].origin.x+[result frame].size.width,4)];
        [button setMenu:[[[NSMenu alloc] initWithTitle:@""] autorelease]];
        [[button menu] addItemWithTitle:@"Nothing" action:@selector(action:) keyEquivalent:[NSString string]];
        [result addSubview:button];
        [button release];
        [result setFrameSize:NSUnionRect([button frame], [result frame]).size];
    }
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationSetForToolbar
- (NSView *) magnificationSetForToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    id result = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];

    NSStepper * stepper = [[self magStepper] retain];
    [stepper setFrameOrigin:NSMakePoint(0,2)];
    [result addSubview:stepper];
    [result setFrameSize:NSUnionRect([stepper frame], [result frame]).size];
    [stepper release];

    NSTextField * oldMF = [[[self magnificationField] retain] autorelease];
    [self setMagnificationField:nil];
    NSTextField * newMF = [self magnificationField];
    [newMF setObjectValue:[oldMF objectValue]];
    [newMF setFrameOrigin:NSMakePoint([result frame].origin.x+[result frame].size.width+4,6)];
    [result addSubview:newMF];
    [result setFrameSize:NSUnionRect(NSInsetRect([newMF frame], -4, 0), [result frame]).size];

    iTM2ButtonMixed * button = [[[iTM2ButtonMixed alloc] initWithFrame:NSMakeRect(0,0,16,26)] autorelease];
    [button setTitle:[NSString string]];
    [button setContinuous:NO];
    [button setCenteredArrow:YES];
    [button setBordered:NO];

    NSMenu * menu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"Magnification"] autorelease];
    [menu setMenuRepresentation:[[[NSMenuView alloc] initWithFrame:NSZeroRect] autorelease]];
    [[menu menuRepresentation] setFont:[NSFont menuFontOfSize:[NSFont smallSystemFontSize]]];

    id menuItem = [[NSApp mainMenu] deepItemWithAction:@selector(displayAtMagnification:)];
    NSEnumerator * E = [[[menuItem menu] itemArray] objectEnumerator];
    while(menuItem=[E nextObject])
    {
        NSMenuItem * MI = [menuItem copy];
        [MI setRepresentedObject:[menuItem representedObject]];
        [menu addItem:MI];
        [MI release];
    }

    BOOL shouldInsertSeparatorItem = NO;
    int shouldInsertSeparatorIndex = [menu numberOfItems];
    #warning missing items!!!
    menuItem = [[NSApp mainMenu] deepItemWithAction:@selector(toggleStickToWidth:)];
    E = [[[menuItem menu] itemArray] objectEnumerator];
    id MI;
    while(MI = [E nextObject])
    {
        SEL action=[MI action];
        if( action == @selector(displayAtFixedSize:) ||
            action == @selector(displayFitToWidth:) ||
            action == @selector(displayFitToHeight:) ||
            action == @selector(displayFitToView:))
        {
            [menu addItem:[MI copyWithZone:[MI zone]]];
            shouldInsertSeparatorItem = YES;
        }
    }
    if(shouldInsertSeparatorItem)
        [menu insertItem:[NSMenuItem separatorItem] atIndex:shouldInsertSeparatorIndex];
    shouldInsertSeparatorItem = NO;
    shouldInsertSeparatorIndex = [menu numberOfItems];
    E = [[[menuItem menu] itemArray] objectEnumerator];
    while(MI = [E nextObject])
    {
        SEL action=[MI action];
        if( action == @selector(toggleStickToWindow:) ||
            action == @selector(toggleStickToWidth:) ||
            action == @selector(toggleStickToHeight:) ||
            action == @selector(toggleStickToView:))
        {
            [menu addItem:[MI copyWithZone:[MI zone]]];
            shouldInsertSeparatorItem = YES;
        }
    }
    if(shouldInsertSeparatorItem)
        [menu insertItem:[NSMenuItem separatorItem] atIndex:shouldInsertSeparatorIndex];

    [button setMenu:menu];
    [button setFrameOrigin:NSMakePoint([result frame].origin.x+[result frame].size.width,4)];

    [result addSubview:button];
    [result setFrameSize:NSUnionRect([button frame], [result frame]).size];

    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magnificationField
- (NSTextField *) magnificationField;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(!_MagnificationField)
    {
        _MagnificationField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [_MagnificationField setFormatter:[[[iTM2MagnificationFormatter alloc] init] autorelease]];
        [_MagnificationField setAction:@selector(takeMagnificationFromField:)];
        [_MagnificationField setAlignment:NSRightTextAlignment];
        [_MagnificationField setFrameSize:NSMakeSize([[[_MagnificationField formatter]
                stringForObjectValue: [NSDecimalNumber numberWithFloat:64.0]]
                #warning APPENDING % ?
                        sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                [[_MagnificationField cell] font], NSFontAttributeName, nil]].width+8, 22)];
////        [_MagnificationField setEnabled:([self representation] != nil)];
    }
    return _MagnificationField;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMagnificationField:
- (void) setMagnificationField: (NSTextField *) aTextField;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [_MagnificationField autorelease];
    _MagnificationField = [aTextField retain];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magStepper
- (NSStepper *) magStepper;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(!_MagStepper)
    {
        NSRect frame = NSMakeRect(0,0,19,32);
        _MagStepper = [NSStepper alloc];
        _MagStepper = [_MagStepper initWithFrame:frame];
        [_MagStepper setIncrement:1];
        [_MagStepper setMinValue:-1];
        [_MagStepper setMaxValue:1];
        [_MagStepper setIntValue:0];
        [_MagStepper setValueWraps:0];
        [_MagStepper setAction:@selector(takeMagnificationFromStepper:)];
        [_MagStepper setTarget:nil];
    }
    return _MagStepper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMagStepper:
- (void) setMagStepper: (NSStepper *) aStepper;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![aStepper isEqual:_MagStepper])
    {
        [_MagStepper release];
        _MagStepper = [aStepper retain];
    }
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2RepToolbarDelegate

