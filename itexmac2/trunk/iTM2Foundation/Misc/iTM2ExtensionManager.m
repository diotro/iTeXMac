/*
//  iTM2ExtensionManager.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Thu Jun 13 2002.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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


#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ExtensionManager.h>
#import <iTM2Foundation/iTM2AppleScriptKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>

#define TABLE @"TeX"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ExtensionManager
/*"This is a semi abstract class."*/
@implementation iTM2ExtensionManager
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  init
- (id) init;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    if(self = [super init])
    {
        [_ExtensionDictionary autorelease];
        _ExtensionDictionary = [[NSMutableDictionary dictionary] retain];
        [self setMenu: nil];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  extensionDictionary
- (id) extensionDictionary;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    return _ExtensionDictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  registerExtension:forKey:
- (void) registerExtension: (id) object forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    if(object && [aKey length])
    {
        [_ExtensionDictionary setObject: object forKey: aKey];
        NSLog(@"Assistant registered: %@", aKey);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  relativePath
- (NSString *) relativePath;
/*"Subclasses will override this.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    return @"Application Support/iTeXMac2/Extensions";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setMenu:
- (id) menu;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    if(!_Menu) [self loadTheExtension: self];
    return _Menu;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setMenu:
- (void) setMenu: (NSMenu *) argument;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    if(argument && ![argument isKindOfClass: [NSMenu class]])
        [NSException raise: NSInvalidArgumentException format: @"%@ NSMenu argument expected: %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if(argument != _Menu)
    {
        [_Menu autorelease];
        _Menu = [argument retain];
        [_Menu deepMakeCellSizeSmall];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  extensionMenuItemAtPath:
- (NSMenuItem *) extensionMenuItemAtPath: (NSString *) path;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    NSBundle * B = [NSBundle bundleWithPath: path];
    NSString * className = [[B infoDictionary] objectForKey: @"NSPrincipalClass"];
    if(NSClassFromString(className))
        NSLog(@"%@ Assistant at path %@ ignored (Duplicate class name)",
            NSStringFromClass([self class]), NSStringFromSelector(_cmd), path);
    else
    {
        Class C = [B principalClass];
        id O = [[[C alloc] init] autorelease];
        if([O respondsToSelector: @selector(menuItem)])
        {
            id MI = [O menuItem];
            if(MI)
            {
                [MI setRepresentedObject: path];
                [self registerExtension: O forKey: path];
                return MI;
            }
        }
        else
            NSLog(@"%@ Assistant at path %@ ignored (no menu item available)",
                NSStringFromClass([self class]), NSStringFromSelector(_cmd), path);
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  extensionMenuAtLibraryPath:
- (NSMenu *) extensionMenuAtLibraryPath: (NSString *) libraryPath;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    NSString * assistantsPath = [[libraryPath stringByAppendingPathComponent:
        [self relativePath]] stringByStandardizingPath];
    NSMenu * M = [[NSMenu alloc] initWithTitle: assistantsPath];
    NSEnumerator * E = [[DFM directoryContentsAtPath: assistantsPath] objectEnumerator];
    NSString * P;
    while(P = [E nextObject])
    {
        if(![P hasPrefix: @"."])
        {
            id MI = [self extensionMenuItemAtPath: [assistantsPath stringByAppendingPathComponent: P]];
            if(MI)
                [M addItem: MI];
        }
    }
    return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  loadTheExtension:
- (void) loadTheExtension: (id) irrelevant;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    NSMenu * networkMenu, * localMenu, * userMenu;
    // we begin by loading the assistants defined in the network area.
    {
        NSArray * Ps = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSNetworkDomainMask, YES);
        NSString * path = [Ps count]? [Ps objectAtIndex: 0]: @"";
        networkMenu = [self extensionMenuAtLibraryPath: path];
        [networkMenu setTitle: NSLocalizedStringFromTableInBundle (@"Network", TABLE,
                                            [self classBundle], "Menu Item Title")];
        [networkMenu setTitle: NSLocalizedStringFromTableInBundle (@"Network", TABLE,
                                            [self classBundle], "Menu Item Title")];
    }
    {
        NSArray * Ps = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSLocalDomainMask, YES);
        NSString * path = [Ps count]? [Ps objectAtIndex: 0]: @"";
        localMenu = [self extensionMenuAtLibraryPath: path];
        [localMenu setTitle: NSLocalizedStringFromTableInBundle (@"Local", TABLE,
                                            [self classBundle], "Menu Item Title")];
    }
    {
        NSArray * Ps = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [Ps count]? [Ps objectAtIndex: 0]: @"";
        userMenu = [self extensionMenuAtLibraryPath: path];
        [userMenu setTitle: NSLocalizedStringFromTableInBundle (@"User", TABLE,
                                            [self classBundle], "Menu Item Title")];
    }
    if([[userMenu itemArray] count])
    {
        if([[localMenu itemArray] count])
        {
            [userMenu addItemWithTitle: [localMenu title] action: NULL keyEquivalent: [NSString string]];
            [[[userMenu itemArray] lastObject] setSubmenu: localMenu];
        }
        if([[networkMenu itemArray] count])
        {
            [userMenu addItemWithTitle: [networkMenu title] action: NULL keyEquivalent: [NSString string]];
            [[[userMenu itemArray] lastObject] setSubmenu: networkMenu];
        }
        [self setMenu: userMenu];
    }
    else if([[localMenu itemArray] count])
    {
        if([[networkMenu itemArray] count])
        {
            [localMenu addItemWithTitle: [networkMenu title] action: NULL keyEquivalent: [NSString string]];
            [[[localMenu itemArray] lastObject] setSubmenu: networkMenu];
        }
        [self setMenu: localMenu];
    }
    else if([[networkMenu itemArray] count])
    {
        [self setMenu: networkMenu];
    }
    else
    {
        NSString * title = NSLocalizedStringFromTableInBundle (@"No Plug In", TABLE,
                [self classBundle], "Menu Item Title");
        id M = [[[NSMenu alloc] initWithTitle: title] autorelease];
        [M addItemWithTitle: title action: NULL keyEquivalent: @""];
        [self setMenu: M];
    }
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantManager
/*"Description forthcoming."*/
@implementation iTM2AssistantManager
static iTM2AssistantManager * _iTM2AssistantManager;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  sharedAssistantManager
+ (id) sharedAssistantManager;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    return _iTM2AssistantManager? _iTM2AssistantManager: (_iTM2AssistantManager = [[self alloc] init]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  relativePath
- (NSString *) relativePath;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    return @"Application Support/iTeXMac2/Assistants";
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantButton
/*"Description forthcoming."*/
@implementation iTM2AssistantButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void) awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    [super awakeFromNib];
    [self setMenu: [[iTM2AssistantManager sharedAssistantManager] menu]];
    [self setTarget: self];
    [self setAction: NULL];
    return;
}
@end

#import <iTM2Foundation/iTM2ContextKit.h>

@interface iTM2ScriptExtensionButton(PRIVATE)
- (int) menu: (NSMenu *) M insertItemsAtPath: (NSString *) path atIndex: (int) index;
@end
#warning THE FOLLOWING IS FOR editor mode only, better design needed
//#import <iTM2Foundation/iTM2MacrosController.h>
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ScriptExtensionButton
/*"Description forthcoming."*/
@implementation iTM2ScriptExtensionButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL) willPopUp;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    if([[self menu] numberOfItems] && !([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask))\
        return [super willPopUp];\
    [self setEnabled: YES];
    [self setImagePosition: NSImageOnly];
    NSMenu * M = [[[NSMenu alloc] initWithTitle: @""] autorelease];
    NSBundle * B = [NSBundle mainBundle];
    NSDocument * document = [[[self window] windowController] document];
    if(!document)
        document = [SDC currentDocument];
#warning ATTENTION, implementation missing
    NSString * mode = [document contextValueForKey: @"textEditorMode"];
    NSString * subPath = [@"Editor" stringByAppendingPathComponent: mode];
    NSString * path = [[B pathEnumeratorForSupportName: @"Scripts" ofType: nil inDirectory: subPath domains: NSUserDomainMask] nextObject];
    int before = MIN(1, [M numberOfItems]);
    int after = [self menu: M insertItemsAtPath: path atIndex: before];
    if(after==before)
    {
        [M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"No user defined scripts", @"iTM2Scripts", B, "DF")
                action: NULL keyEquivalent: @"" atIndex: after++];
    }
    BOOL separatorNeeded = NO;
    int here = [M numberOfItems];
    NSMenu * MM = [[[NSMenu alloc] initWithTitle: @""] autorelease];
    path = [[B pathEnumeratorForSupportName: @"Scripts" ofType: nil inDirectory: subPath domains: NSLocalDomainMask] nextObject];
//NSLog(@"path: %@", path);
    if([self menu: MM insertItemsAtPath: path atIndex: 0])
    {
        separatorNeeded = YES;
        [[M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Local", TABLE, B, "DF")
                action: NULL keyEquivalent: @"" atIndex: after++] setSubmenu: MM];
        MM = [[[NSMenu alloc] initWithTitle: @""] autorelease];
    }
    path = [[B pathEnumeratorForSupportName: @"Scripts" ofType: nil inDirectory: subPath domains: NSNetworkDomainMask] nextObject];
//NSLog(@"path: %@", path);
    if([self menu: MM insertItemsAtPath: path atIndex: 0])
    {
        separatorNeeded = YES;
        [[M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Network", TABLE, B, "DF")
                action: NULL keyEquivalent: @"" atIndex: after++] setSubmenu: MM];
        MM = [[[NSMenu alloc] initWithTitle: @""] autorelease];
    }
    path = [[self classBundle] pathForResource: mode ofType: nil inDirectory: subPath];
//NSLog(@"path: %@", path);
    if([self menu: MM insertItemsAtPath: path atIndex: 0])
    {
        separatorNeeded = YES;
        [[M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Built in", TABLE, B, "DF")
                action: NULL keyEquivalent: @"" atIndex: after++] setSubmenu: MM];
        MM = [[[NSMenu alloc] initWithTitle: @""] autorelease];
    }
    if(separatorNeeded)
        [M insertItem: [NSMenuItem separatorItem] atIndex: here];
    [M deepMakeCellSizeSmall];
    [self setMenu: M];
    return [super willPopUp];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menu:insertItemsAtPath:atIndex:
- (int) menu: (NSMenu *) M insertItemsAtPath: (NSString *) path atIndex: (int) index;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- 1.3: 03/10/2002
To Do List: ...
"*/
{
//iTM2_START;
//NSLog(@"path: %@", path);
    NSMenu * templateMenu = [[M copy] autorelease];
    while([templateMenu numberOfItems])
        [templateMenu removeItemAtIndex: 0];
//    NSFileManager * DFM = DFM;
    NSEnumerator * E = [[DFM directoryContentsAtPath: path] objectEnumerator];
    NSMutableArray * dirMenus = [NSMutableArray array];
    NSString * subpath;
    while(subpath = [E nextObject])
    {
        if(![subpath hasPrefix: @"."] && ![subpath hasPrefix: [NSString bullet]] && ![subpath isEqual: @"CVS"])
        {
            BOOL isDirectory = NO;
            NSString * RO = [[path stringByAppendingPathComponent: subpath] iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
    //NSLog(@"\n\nRO: %@\n\n", RO);
            if([DFM fileExistsAtPath: RO isDirectory: &isDirectory])
            {
                if(isDirectory)
                {
                    NSMenu * menu = [[templateMenu copy] autorelease];
                    [menu setTitle: [subpath stringByDeletingPathExtension]];
                    if([self menu: menu insertItemsAtPath: RO atIndex: 0])
                        [dirMenus addObject: menu];
                }
                else
                {
                    NSMenuItem * MI = [M insertItemWithTitle: subpath
                        action: @selector(_action:) keyEquivalent: @"" atIndex: index];
                    [MI setRepresentedObject: RO];
                    [MI setTarget: self];
                    ++index;
                }
            }
        }
    }
    E = [dirMenus objectEnumerator];
    NSMenu * menu;
    while(menu = [E nextObject])
        [[M insertItemWithTitle: [menu title] action: NULL keyEquivalent: @"" atIndex: index++] setSubmenu: menu];
    return index;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _action:
- (void) _action: (id) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- 1.3: 03/10/2002
To Do List: ...
"*/
{
//iTM2_START;
    [iTM2AppleScriptLauncher
        performSelector: @selector(executeAppleScriptAtPath:)
            withObject: [sender representedString]
                afterDelay: 0];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantManager

