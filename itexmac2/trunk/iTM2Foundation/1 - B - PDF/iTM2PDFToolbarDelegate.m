/*
//  iTeXMac
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jan 06 2002.
//  Copyright © 2001 Laurens'Tribune. All rights reserved.
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

#import "iTM2PDFToolbarDelegate.h"
#import "iTM2PDFViewKit.h"
#import "iTM2HelpKit.h"
#import "iTM2ButtonKit.h"
#import "iTM2TextFieldKit.h"
#import "iTM2ViewKit.h"

NSString * const iTM2ToolbarNavigationFieldItemIdentifier = @"AtNavigation";
NSString * const iTM2ToolbarNavigationSetItemIdentifier = @"Navigation";
NSString * const iTM2ToolbarPreviousSetItemIdentifier = @"Previous";
NSString * const iTM2ToolbarNextSetItemIdentifier = @"Next";
NSString * const iTM2ToolbarPreviousMixedSetItemIdentifier = @"Previous Mixed";
NSString * const iTM2ToolbarNextMixedSetItemIdentifier = @"Next Mixed";
NSString * const iTM2ToolbarFirstButtonItemIdentifier = @"doGoToFirstPage:";
NSString * const iTM2ToolbarPreviousButtonItemIdentifier = @"doGoToPreviousPage:";
NSString * const iTM2ToolbarPreviousPreviousButtonItemIdentifier = @"doGoToPreviousPreviousPage:";
NSString * const iTM2ToolbarLastButtonItemIdentifier = @"doGoToLastPage:";
NSString * const iTM2ToolbarNextButtonItemIdentifier = @"doGoToNextPage:";
NSString * const iTM2ToolbarNextNextButtonItemIdentifier = @"doGoToNextNextPage:";
NSString * const iTM2ToolbarBackButtonItemIdentifier = @"doGoBack:";
NSString * const iTM2ToolbarForwardButtonItemIdentifier = @"doGoForward:";
NSString * const iTM2ToolbarHistorySetItemIdentifier = @"History";

@interface iTM2PDFToolbarDelegate(PRIVATE)
- (void)focusedPageNumberDidChangeNotified:(NSNotification *)aNotification;
@end

@implementation iTM2PDFToolbarDelegate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(self = [super init])
    {
        [self->__LastNavigationITII release];
        self->__LastNavigationITII = nil;
        [self setNavigationField:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                    name: iTM2LogicalPageNumberDidChangeNotification
                                object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector: @selector(logicalPageNumberDidChangeNotified:)
                name: iTM2LogicalPageNumberDidChangeNotification
                    object: nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                    name: iTM2FocusedPageNumberDidChangeNotification
                                object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector: @selector(focusedPageNumberDidChangeNotified:)
                name: iTM2FocusedPageNumberDidChangeNotification
                    object: nil];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  focusedPageNumberDidChangeNotified:
- (void)focusedPageNumberDidChangeNotified:(NSNotification *)aNotification;
/*"Description forthcoming. Just to update the field
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if([[[aNotification object] window] isEqual:[[self navigationField] window]])
    {
        NSNumber * newPage = [[aNotification userInfo] objectForKey:@"NewLogicalPage"];
        NSNumber * pageCount = [[aNotification userInfo] objectForKey:@"PageCount"];
        [[[self navigationField] formatter] setMaximum:(NSDecimalNumber *)[NSDecimalNumber numberWithInt:[pageCount intValue]]];
        [[self navigationField] setIntValue:[newPage intValue]];
        [[self navigationField] setEnabled:([[[[self navigationField] formatter] maximum] intValue] > 1)];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logicalPageNumberDidChangeNotified
- (void)logicalPageNumberDidChangeNotified:(NSNotification *)aNotification;
/*"Sends a #{focusedPageNumberDidChangeNotified} to the receiver, then updates the history menus.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if([[[aNotification object] window] isEqual:[[self navigationField] window]])
    {
        [self focusedPageNumberDidChangeNotified:aNotification];
        NSNumber * oldPage = [[aNotification userInfo] objectForKey:@"OldLogicalPage"];
        NSNumber * newPage = [[aNotification userInfo] objectForKey:@"NewLogicalPage"];
        NSNumber * pageCount = [[aNotification userInfo] objectForKey:@"PageCount"];

        int OP = [oldPage intValue];
        int NP = [newPage intValue];
        NP = MIN(NP, [pageCount intValue]);
        NSMenu * backMenu = [self backMenu];
        NSMenu * forwardMenu = [self forwardMenu];

        if(oldPage && (OP>=0) && (OP != NP))
        {
            int OPIndex;
            
            if((OPIndex = [forwardMenu indexOfItemWithTag:NP]) > -1)
            {
                // jump to the correct item in the forward menu
                [[backMenu insertItemWithTitle:[[NSNumber numberWithInt:OP] stringValue]
                    action: @selector(displayPageFromItem:) keyEquivalent: @"" atIndex: 0] setTag: OP];
                while(OPIndex>0)
                {
                    NSMenuItem * MI = [[[forwardMenu itemAtIndex:0] retain] autorelease];
                    [forwardMenu removeItemAtIndex:0];
                    // Do not insert successive menu items with the same tag
                    if([[backMenu itemAtIndex:0] tag]!=[MI tag])
                        [backMenu insertItem:MI atIndex:0];
                    --OPIndex;
                }
                [forwardMenu removeItemAtIndex:0];
            }
            else if((OPIndex = [backMenu indexOfItemWithTag:NP]) > -1)
            {
                [[forwardMenu insertItemWithTitle:[[NSNumber numberWithInt:OP] stringValue]
                    action: @selector(displayPageFromItem:) keyEquivalent: @"" atIndex: 0] setTag: OP];
                // jump to the correct item in the back menu
                while(OPIndex>0)
                {
                    NSMenuItem * MI = [[[backMenu itemAtIndex:0] retain] autorelease];
                    [backMenu removeItemAtIndex:0];
                    // Do not insert successive menu items with the same tag
                    if([forwardMenu numberOfItems] == 0 || ([[forwardMenu itemAtIndex:0] tag]!=[MI tag]))
                        [forwardMenu insertItem:MI atIndex:0];
                        --OPIndex;
                }
                [backMenu removeItemAtIndex:0];
            }
            else
            {
                // remove all forward items
                while([forwardMenu numberOfItems]>0)
                    [forwardMenu removeItemAtIndex:0];
                [[backMenu insertItemWithTitle:[[NSNumber numberWithInt:OP] stringValue]
                    action: @selector(displayPageFromItem:) keyEquivalent: @"" atIndex: 0] setTag: OP];
            }
        }
        int MP = [pageCount intValue];
        int index = [[self backMenu] numberOfItems];
        while(index-- > 0)
            if([[[self backMenu] itemAtIndex:index] tag] > MP)
                [[self backMenu] removeItemAtIndex:index];
        index = [[self forwardMenu] numberOfItems];
        while(index-- > 0)
            if([[[self forwardMenu] itemAtIndex:index] tag] > MP)
                [[self forwardMenu] removeItemAtIndex:index];
    }
//NSLog(@"THIS IS THE END");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)aToolbar;
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
                iTM2ToolbarNavigationSetItemIdentifier,
                NSToolbarFlexibleSpaceItemIdentifier,
                iTM2ToolbarMagnificationSetItemIdentifier,
                NSToolbarFlexibleSpaceItemIdentifier,
                iTM2ToolbarHistorySetItemIdentifier,
                NSToolbarFlexibleSpaceItemIdentifier,
                NSToolbarSeparatorItemIdentifier,
                iTM2ToolbarShowHelpItemIdentifier,
                    nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return [NSArray arrayWithObjects:
                NSToolbarPrintItemIdentifier,
                NSToolbarFlexibleSpaceItemIdentifier,
                NSToolbarSpaceItemIdentifier,
                NSToolbarSeparatorItemIdentifier,
                iTM2ToolbarShowHelpItemIdentifier,
                iTM2ToolbarPreviousSetItemIdentifier,
                iTM2ToolbarNextSetItemIdentifier,
                iTM2ToolbarPreviousMixedSetItemIdentifier,
                iTM2ToolbarNextMixedSetItemIdentifier,
                iTM2ToolbarMagnificationFieldItemIdentifier,
                iTM2ToolbarMagnificationSetItemIdentifier,
                iTM2ToolbarNavigationFieldItemIdentifier,
                iTM2ToolbarNavigationSetItemIdentifier,
                iTM2ToolbarBackButtonItemIdentifier,
                iTM2ToolbarForwardButtonItemIdentifier,
                iTM2ToolbarHistorySetItemIdentifier,
                iTM2ToolbarFirstButtonItemIdentifier,
                iTM2ToolbarLastButtonItemIdentifier,
                iTM2ToolbarPreviousButtonItemIdentifier,
                iTM2ToolbarNextButtonItemIdentifier,
                iTM2ToolbarPreviousPreviousButtonItemIdentifier,
                iTM2ToolbarNextNextButtonItemIdentifier,
                    nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSToolbarItem * result = nil;
    BOOL hasField = NO;
#define IFTHENFIELD(iTM2ItemIdentifier, forToolbar, forPalette)\
    if([anItemIdentifier isEqualToString:iTM2ItemIdentifier])\
    {\
        NSView * view;\
        if(aFlag)\
        {\
            view = [self forToolbar];\
            result = [[NSToolbarItem alloc] initWithItemIdentifier:iTM2ItemIdentifier];\
        }\
        else\
        {\
            view = [self forPalette];\
            result = [[NSToolbarItem alloc] initWithItemIdentifier:iTM2ItemIdentifier];\
        }\
        [result setView:view];\
        hasField = YES;\
    }
    IFTHENFIELD(iTM2ToolbarNavigationFieldItemIdentifier, navigationFieldForToolbar, navigationFieldForPalette)
    else IFTHENFIELD(iTM2ToolbarNavigationSetItemIdentifier, navigationSetForToolbar, navigationSetForPalette)
    #define IFTHEN(iTM2ItemIdentifier, set)\
    if([anItemIdentifier isEqualToString:iTM2ItemIdentifier])\
    {\
        NSView * view = [self set];\
        result = aFlag? [NSToolbarItem alloc]:[NSToolbarItem alloc];\
        result = [result initWithItemIdentifier:iTM2ItemIdentifier];\
        [result setView:view];\
    }
    else IFTHEN(iTM2ToolbarPreviousSetItemIdentifier, previousSet)
    else IFTHEN(iTM2ToolbarNextSetItemIdentifier, nextSet)
    else IFTHEN(iTM2ToolbarPreviousMixedSetItemIdentifier, previousMixedSet)
    else IFTHEN(iTM2ToolbarNextMixedSetItemIdentifier, nextMixedSet)
    else IFTHEN(iTM2ToolbarHistorySetItemIdentifier, historySet)
    else IFTHEN(iTM2ToolbarFirstButtonItemIdentifier, buttonFirst)
    else IFTHEN(iTM2ToolbarPreviousButtonItemIdentifier, buttonPrevious)
    else IFTHEN(iTM2ToolbarPreviousPreviousButtonItemIdentifier, buttonPreviousPrevious)
    else IFTHEN(iTM2ToolbarLastButtonItemIdentifier, buttonLast)
    else IFTHEN(iTM2ToolbarNextButtonItemIdentifier, buttonNext)
    else IFTHEN(iTM2ToolbarNextNextButtonItemIdentifier, buttonNextNext)
    else IFTHEN(iTM2ToolbarBackButtonItemIdentifier, buttonBack)
    else IFTHEN(iTM2ToolbarForwardButtonItemIdentifier, buttonForward)
    else if([anItemIdentifier isEqualToString:iTM2ToolbarShowHelpItemIdentifier])
        return [iTM2HelpManager helpToolbarItem];
    else
        return [super toolbar:aToolbar itemForItemIdentifier:anItemIdentifier willBeInsertedIntoToolbar:aFlag];
    [result setMinSize:[[result view] frame].size];
    [result setMaxSize:[[result view] frame].size];
    {
        NSString * identifier = [result itemIdentifier];
        [result setToolTip:NSLocalizedStringFromTableInBundle(identifier, @"ViewToolbarToolTip",
                                                        [NSBundle bundleForClass:[self class]], "")];
        [result setPaletteLabel:NSLocalizedStringFromTableInBundle(identifier, @"ViewToolbarPaletteLabel",
                                                        [NSBundle bundleForClass:[self class]], "")];
        [result setLabel:NSLocalizedStringFromTableInBundle(identifier, @"ViewToolbarLabel",
                                                        [NSBundle bundleForClass:[self class]], "")];
    }
    if(aFlag && hasField)
    {
        if((__LastNavigationITII!=nil)&&![__LastNavigationITII isEqualToString:anItemIdentifier])
        {
            BOOL removeFlag=NO;
            int index;
            for(index=0; index<[[aToolbar items] count]; ++index)
                if([[[[aToolbar items] objectAtIndex:index] itemIdentifier] isEqualToString:__LastNavigationITII])
                {
                    removeFlag=YES;
                    break;
                }
            if(removeFlag)
                [aToolbar removeItemAtIndex:index];
        }
        [__LastNavigationITII release];
        __LastNavigationITII = [anItemIdentifier copy];
    }
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= historySet
- (NSView *)historySet;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSView * B = [self buttonBack];
    NSView * F = [self buttonForward];
    NSRect frame = NSMakeRect(0,0, [B frame].size.width+[F frame].size.width, 32);
    NSView * result = [[NSView alloc] initWithFrame:frame];
    [result addSubview:B];
    [F setFrameOrigin:NSMakePoint([B frame].origin.x+[B frame].size.width, 0)];
    [result addSubview:F];
    return [result autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  navigationFieldForPalette
- (NSTextField *)navigationFieldForPalette;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSTextField * textField = [[NSTextField alloc] initWithFrame:[[self navigationField] frame]];
    [textField setStringValue:@"p..."];
    return [textField autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  navigationFieldForToolbar
- (NSTextField *)navigationFieldForToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    NSTextField * textField = [[self navigationField] retain];
    [self setNavigationField:nil];
    [[self navigationField] setIntValue:[textField intValue]];
    [textField release];
    textField = [[self navigationField] retain];
    if ([textField retainCount]<3)
    {
        return [textField autorelease];
    }
    else
    {
        NSLog(@"No item navigationView, retainCount: %d", [textField retainCount]);
        [textField release];
        return nil;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NAVIGATION_SET
#define NAVIGATION_SET(navigationSet, navigationField)\
- (NSView *)navigationSet;\
{\
    NSView * F = [self navigationField];\
    if(F != nil)\
    {\
        NSView * P = [self previousMixedSet];\
        NSView * N = [self nextMixedSet];\
        NSView * result = [[NSView alloc] initWithFrame:[P frame]];\
        [result addSubview:P];\
        [F setFrameOrigin:NSMakePoint([result frame].size.width+4, [F frame].origin.y)];\
        [result addSubview:F];\
        [result setFrame:NSUnionRect([result frame], NSInsetRect([F frame], -4, 0))];\
        [N setFrameOrigin:NSMakePoint([N frame].origin.x+[result frame].size.width, [N frame].origin.y)];\
        [result addSubview:N];\
        [result setFrame:NSUnionRect([result frame], [N frame])];\
        return [result autorelease];\
    }\
    else\
        return nil;\
}
NAVIGATION_SET(navigationSetForToolbar, navigationFieldForToolbar);
NAVIGATION_SET(navigationSetForPalette, navigationFieldForPalette);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SET
#define SET(getter, one, two, three)\
- (NSView *)getter;\
{\
    NSView * result = [[NSView alloc] initWithFrame:NSMakeRect(0,0,96,32)];\
    NSButton * button = [self one];\
    [result addSubview:button];\
    button = [self two];\
    [button setFrameOrigin:NSMakePoint(32,0)];\
    [result addSubview:button];\
    button = [self three];\
    [button setFrameOrigin:NSMakePoint(64,0)];\
    [result addSubview:button];\
    return [result autorelease];\
}
SET(nextSet, buttonNext, buttonNextNext, buttonLast);
SET(previousSet, buttonFirst, buttonPreviousPrevious, buttonPrevious);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  MIXEDSET
#define MIXEDSET(getter, one, two, three)\
- (NSView *)getter;\
{\
    NSButton * button = [self one];\
    id result = [[iTM2FlagsChangedView alloc] initWithFrame:[button frame]];\
    [result addSubview:button];\
    [button setTag:0];\
    button = [self two];\
    [result addSubview:button];\
    [button setTag:[result tagFromMask:NSShiftKeyMask]];\
    button = [self three];\
    [result addSubview:button];\
    [button setTag:[result tagFromMask:NSAlternateKeyMask]];\
    [result computeIndexFromTag];\
    return [result autorelease];\
}
MIXEDSET(previousMixedSet, buttonPrevious, buttonPreviousPrevious, buttonFirst);
MIXEDSET(nextMixedSet, buttonNext, buttonNextNext, buttonLast);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  BUTTON
#define BUTTON(getter, action);\
- (NSButton *)getter;\
{\
    id button = [NSButton getter];\
    [button setAction:@selector(action)];\
    [button setTarget:nil];\
    [button setContinuous:YES];\
    return button;\
}
BUTTON(buttonFirst, doGoToFirstPage:);
BUTTON(buttonPrevious, doGoToPreviousPage:);
BUTTON(buttonPreviousPrevious, doGoToPreviousPreviousPage:);
BUTTON(buttonLast, doGoToLastPage:);
BUTTON(buttonNext, doGoToNextPage:);
BUTTON(buttonNextNext, doGoToNextNextPage:);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NAVBUTTON
#define NAVBUTTON(getter, action, menu);\
- (NSButton *)getter;\
{\
    iTM2ButtonMixed * button = (iTM2ButtonMixed *)[NSButton getter];\
    [button setMixedEnabled:YES];\
    [button setAction:@selector(action)];\
    [button setTarget:nil];\
    [button setMenu:[self menu]];\
    return button;\
}
NAVBUTTON(buttonBack, doGoBack:, backMenu);
NAVBUTTON(buttonForward, doGoForward:, forwardMenu);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= navigationField
- (NSTextField *)navigationField;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(!_NavigationField)
    {
        iTM2NavigationFormatter * NF = [[iTM2NavigationFormatter alloc] init];
        _NavigationField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [_NavigationField setAction:@selector(takeLogicalPageFromField:)];
        [_NavigationField setTarget:nil];
        [_NavigationField setFormatter:NF];
        [_NavigationField setDelegate:NF];
        [_NavigationField setFrameOrigin:NSMakePoint(4,6)];
        [[_NavigationField cell] setSendsActionOnEndEditing:NO];
        {
            int maximum = 1000;
            [_NavigationField setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithInt:maximum]]
                            sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                    [[_NavigationField cell] font], NSFontAttributeName, nil]].width+8, 22)];
        }
        [NF release];
    }
    return _NavigationField;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setNavigationField:
- (void)setNavigationField:(NSTextField *)aTextField;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(![aTextField isEqual:_NavigationField])
    {
        [_NavigationField release];
        _NavigationField = [aTextField retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= MENUGETTERSETTER
#define MENUGETTERSETTER(source, getter, setter)\
- (id)getter;\
{\
    if(!source)\
    {\
        [self setter:[[[NSMenu alloc] initWithTitle:@""] autorelease]];\
    }\
    return source;\
}\
- (void)setter:(NSMenu *)argument;\
{\
    if(![source isEqual:argument])\
    {\
        if(argument && ![argument isKindOfClass:[NSMenu class]])\
            [NSException raise:NSInvalidArgumentException format:@"-[%@ %@] NSMenu argument expected:%@.",\
                [self class], NSStringFromSelector(_cmd), argument];\
        else\
        {\
            [source release];\
            source = [argument retain];\
        }\
    }\
    return;\
}
#warning Small menu is missing for the back and forward menus below
MENUGETTERSETTER(_BackMenu, backMenu, setBackMenu);
MENUGETTERSETTER(_ForwardMenu, forwardMenu, setForwardMenu);
@synthesize __LastNavigationITII;
@synthesize _NavigationField;
@synthesize _BackMenu;
@synthesize _ForwardMenu;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFToolbarDelegate

