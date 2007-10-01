/*
//  iTM2ToolbarKit.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Thu Jul 12 2001.
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
//
//  Version history:
//  * initial content on Thu Jul 12 2001
//      +frameIdentifier
//      +initialize

*/

#import <iTM2Foundation/iTM2ToolbarKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindowController (iTeXMac2) 
@implementation iTM2ToolbarServer
@end

#import <objc/objc-class.h>

@implementation NSToolbar(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  window
- (NSWindow *) window;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{
    void * window;
    object_getInstanceVariable(self, "_window", &window);
    return (NSWindow *)window;
}
@end

@interface NSDocument_iTM2ToolbarKit: NSDocument
@end
@implementation NSDocument_iTM2ToolbarKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void) load;
/*"Toggles the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens@users.sourceforge.net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{
    iTM2_INIT_POOL;
//iTM2_START;
    iTM2NamedClassPoseAs("NSDocument_iTM2ToolbarKit", "NSDocument");
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToolbarItem:
- (BOOL) validateToolbarItem: (id) sender;
/*" Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    SEL action = [sender action];
    if(action == @selector(printDocument:))
        return [[[sender toolbar] window] isEqual: [NSApp mainWindow]];
    else
        return [super validateToolbarItem: sender];
}
@end

#if 0
#import <iTM2Foundation/iTM2DocumentKit.h>

@implementation NSWindowController (iTM2ToolbarKit) 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowToolbarIdentifier
+ (NSString *) windowToolbarIdentifier;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
#if 1
    return [[self inspectorType] stringByAppendingPathComponent: [self inspectorMode]];
#else
    static id WTIs = [NSMutableDictionary dictionary];
    NSString * key = NSStringFromClass(self);
    NSString * result = [WTIs valueForKey: key];
    if(![result length])
    {
        result = [[self inspectorType] stringByAppendingPathComponent: [self inspectorMode]];
        [WTIs takeValue: result forKey: key]
    }
    return result;
#endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  installWindowToolbar
- (void) installWindowToolbar;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    id toolbar = [[[NSToolbar alloc] initWithIdentifier: [[self class] windowToolbarIdentifier]] autorelease];
    [toolbar setDelegate: self];
    [toolbar setAllowsUserCustomization: [self allowsUserWindowToolbarCustomization]];
    [toolbar setAutosavesConfiguration: [self autosavesWindowToolbarConfiguration]];
    [toolbar setDisplayMode: [self windowToolbarDisplayMode]];
    [[self window] setToolbar: toolbar];
//NSLog (@"The toolbar has been installed for identifier: %@", anIdentifier) ;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allowsUserWindowToolbarCustomization
- (BOOL) allowsUserWindowToolbarCustomization;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowToolbarDisplayMode
- (NSToolbarDisplayMode) windowToolbarDisplayMode;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return NSToolbarDisplayModeDefault;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autosavesWindowToolbarConfiguration
- (BOOL) autosavesWindowToolbarConfiguration;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autosavesWindowToolbarConfiguration
+ (NSToolbarItem *) toolbar: (NSToolbar *) toolbar itemForItemIdentifier: (NSString *) itemIdentifier willBeInsertedIntoToolbar: (BOOL) flag;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *) toolbar: (NSToolbar *) toolbar itemForItemIdentifier: (NSString *) itemIdentifier willBeInsertedIntoToolbar: (BOOL) flag;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [isa toolbar: toolbar itemForItemIdentifier: itemIdentifier willBeInsertedIntoToolbar: flag];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
+ (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar*) toolbar;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar*) toolbar;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [isa toolbarDefaultItemIdentifiers: toolbar];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autosavesWindowToolbarConfiguration
+ (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar*) toolbar;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autosavesWindowToolbarConfiguration
- (NSArray *) toolbarAllowedItemIdentifiers: (NSToolbar*) toolbar;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [isa toolbarAllowedItemIdentifiers: toolbar];
}
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarSelectableItemIdentifiers:
+ (NSArray *) toolbarSelectableItemIdentifiers: (NSToolbar *) toolbar;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarSelectableItemIdentifiers:
- (NSArray *) toolbarSelectableItemIdentifiers: (NSToolbar *) toolbar;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [isa toolbarSelectableItemIdentifiers: toolbar];
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarWillAddItem:
+ (void) toolbarWillAddItem: (NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarWillAddItem:
- (void) toolbarWillAddItem: (NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    [isa toolbarWillAddItem: notification];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDidRemoveItem:
+ (void) toolbarDidRemoveItem: (NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDidRemoveItem:
- (void) toolbarDidRemoveItem: (NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    [isa toolbarDidRemoveItem: notification];
    return;
}
@end
#endif
