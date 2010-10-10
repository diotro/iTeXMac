/*
//  iTM2ListMenu.m
//  List Menu Server
//
//  Created by jlaurens@users.sourceforge.net on Wed Apr 04 2001.
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


#import "iTM2MenuKit"
#import <iTM2Foundation/iTM2ListMenu.h>
#import <iTM2Foundation/iTM2SmallMenuItemCell.h>
#import <iTM2Foundation/iTM2FilePathFilter.h>
#import <iTM2Foundation/iTM2EventObserver.h>
#import "NSString_iTeXMac2.h"
#import <iTM2Foundation/iTM2PathUtilities.h>

NSString * const iTM2ListMenuSmallSizeKey = @"iTM2SmallListMenuSize";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ListMenu
/*"Description forthcoming."*/
@implementation iTM2ListMenu
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"It registers a default value for the user defaults keyed #{smallMenuSizeKey}. "YES" is this default."*/
{
//START4iTM3;
	[super initialize];
    [SUD registerDefaults:
                [NSDictionary dictionaryWithObject: @"YES" forKey: iTM2ListMenuSmallSizeKey]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithTitle:target:action:
- (id) initWithTitle: (NSString*) aTitle target: (id) aTarget action: (SEL) aSelector;
/*"#{-initWithTitle:target:controller:} with no controller."*/
{
//START4iTM3;
    return [self initWithTitle: aTitle controller: nil target: aTarget action: aSelector];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithTitle:controller:target:action:
- (id) initWithTitle: (NSString*) aTitle controller: (id) aController target: (id) aTarget action: (SEL) aSelector;
/*"The receiver uses super #{initWithTitle:}, sets the controller and #{-_Prepare:}. If aTitle does not point to a valid directory, nil is returned. If aTitle points to a symbolic link, it is once resolved and if the target is a directory, the path is taken as source path, otherwise nil is returned once more. Only one level of indirection is managed.
This is the designated initializer."*/
{
//START4iTM3;
    if([DFM fileExistsAtPath: aTitle])
    {
        NSFileWrapper * FW = [[[NSFileWrapper alloc] initWithPath: aTitle] autorelease];
        if([FW isSymbolicLink])
        {
            aTitle = [FW symbolicLinkDestination];
            FW = [[[NSFileWrapper alloc] initWithPath: aTitle] autorelease];
        }
        if([FW isDirectory])
        {
            self = [super initWithTitle: aTitle];
            self.action = aSelector;
            [self setController: aController];
            self.target = aTarget;
            [self setAcceptsAlternate: NO];
            self._Prepare;
            return self;
        }
    }
    self.autorelease;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _Prepare
- (void) _Prepare;
/*"Asks the controller for #{-prepareMenu:} and send the message if appropriate. Otherwise sends a #{-prepare} message to the receiver."*/
{
//START4iTM3;
    SEL selector = @selector(prepareMenu:);
    if([self.controller respondsToSelector: selector])
        [self.controller performSelector: selector withObject: self];
    else
        self.prepare;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prepare
- (void) prepare;
/*"This default implementation is meant be to be overriden by controllers and subclasses that will implement a #{±prepareMenu:}.
Just prepare the menu view size using iTM2ListMenuSmallSizeKey keyed BOOL in the user default database. Send the #{-prepareMenu:} message to the controller, if it responds to."*/
{
//START4iTM3;
#warning small menu font size not working...
#if 0
    [self setMenuRepresentation: [[[NSMenuView alloc] initWithFrame: NSZeroRect] autorelease]];
    if([[NSUserDefaults standardUserDefaults] boolForKey: iTM2ListMenuSmallSizeKey])
        [self.menuRepresentation setFont: [NSFont menuFontOfSize: [NSFont smallSystemFontSize]]];
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateMenu:
- (void) updateMenu: (iTM2ListMenu *) aMenu;
/*"If the menu has no items, fills it using #{insertItemsAtIndex:}."*/
{
//START4iTM3;
    if(([aMenu numberOfItems]<1))
        [aMenu insertItemsAtIndex: 0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= update
- (void) update;
/*"Asks the controller to update the receiver, then calls the inherited method. More precisely, if the receiver is not a root menu (has a supermenu), performs various tests to ensure that the menu font size is the same in both menus. If it is not, it removes all the items of the receiver to make a clean update. If the receiver is a root menu, its menu font size is set according to the standard user defaults database. In both cases, an #{-updateMenu:} message is sent to the controller if it responds to, which allows to make further customizations."*/
{
//START4iTM3;
    if(![self.menuRepresentation.window isVisible])
    {
        if(self.supermenu!=nil)
        {
            int pointSize = [[[self.supermenu menuRepresentation] font] pointSize];
            if([[self.menuRepresentation font] pointSize] != pointSize)
            {
                self.removeAllItems;
                if(pointSize == [NSFont systemFontSize])
                    [self.menuRepresentation setFont: [NSFont menuFontOfSize: [NSFont systemFontSize]]];
                else
                    [self.menuRepresentation setFont: [NSFont menuFontOfSize: [NSFont smallSystemFontSize]]];
            }
            if([self.supermenu respondsToSelector: @selector(acceptsAlternate)])
            {
                [self setAcceptsAlternate: [(id)self.supermenu acceptsAlternate]];
                if([self.supermenu respondsToSelector: @selector(isAlternate)])
                {
                    BOOL isAlternateKeyDown = [(id)self.supermenu isAlternate];
                    if(isAlternateKeyDown != self.isAlternate)
                    {
                        [self setAlternate: isAlternateKeyDown];
                        self.removeAllItems;
                    }
                }
            }
            else
                [self setAcceptsAlternate: NO];
        }
        else
        {
            BOOL hasSmallMenuSize = [[NSUserDefaults standardUserDefaults] boolForKey: iTM2ListMenuSmallSizeKey];
            int pointSize = hasSmallMenuSize? [NSFont smallSystemFontSize]: [NSFont systemFontSize];
            if([[self.menuRepresentation font] pointSize] != pointSize)
            {
                self.removeAllItems;
                if(hasSmallMenuSize)
                    [self.menuRepresentation setFont: [NSFont menuFontOfSize: [NSFont smallSystemFontSize]]];
                else
                    [self.menuRepresentation setFont: [NSFont menuFontOfSize: [NSFont systemFontSize]]];
            }
            {
                BOOL isAlternateKeyDown = (([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask) > 0);//[iTM2EventObserver isAlternateKeyDown];
                if(isAlternateKeyDown != self.isAlternate)
                {
                    [self setAlternate: isAlternateKeyDown];
                    self.removeAllItems;
                }
            }
        }
        {
            SEL selector = @selector(updateMenu:);
            if([self.controller respondsToSelector: selector])
                [self.controller performSelector: selector withObject: self];
            else
                [self updateMenu: self];
        }
    }
    [super update];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= description
- (NSString *) description;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if(self.controller)
        return [NSString stringWithFormat: @"<%@\nController: %@>",
                            [super description], [self.controller description]];
    else
        return [super description];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= INSERTING  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertItem:atIndex:
- (void) insertItem: (NSMenuItem *) aMenuItem atIndex: (NSInteger) anIndex;
/*"It inserts the item at the specified location. There is some preliminary treatment of the index to avoid range checking. Send #{insertItem:atIndex:} to super after testing the menuItem existence. Then sets the menu item cell to display the appropriate size. Uses iTM2ListMenuSmallSizeKey, could be avoided, needs some more thinking. The target of the menu item is set to the target already declared for the receiver (nil if no target hads been set for the receiver yet). Similarly, the action of the menu item is the one of the receiver, unless it has none: in that case the default action selector is #{listMenuItemAction:}."*/
{
//START4iTM3;
    if(aMenuItem)
    {
        anIndex = MIN(MAX(anIndex, 0),self.numberOfItems);
        [super insertItem: aMenuItem atIndex: anIndex];
        if([[self.menuRepresentation font] pointSize] != [NSFont systemFontSize])
        {
            NSMenuView * menuView = self.menuRepresentation;
            iTM2SmallMenuItemCell * mic = [[[iTM2SmallMenuItemCell alloc] init] autorelease];
            [mic setFont: [menuView font]];
            [menuView setMenuItemCell: mic forItemAtIndex: anIndex];
        }
        if(![aMenuItem isEqual: [NSMenuItem separatorItem]] && (aMenuItem.action == NULL))
        {
            if(self.action != NULL)
                aMenuItem.action = self.action;
            else
                aMenuItem.action = @selector(listMenuItemAction:);
            aMenuItem.target = self.target;
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertSeparatorAtIndex:
- (NSInteger) insertSeparatorItemAtIndex: (NSInteger) itemIndex;
/*"It adds a separator item at the itemIndex location of the receiver, except if the receiver already
has such an item there.
The controller can implement the method #{±insertSeparatorItemInMenu:atIndex:}, it will take precedence
over the present method. But if a subclass implements #{-insertSeparatorItemInMenu:atIndex:},
it will take precedence over all others.

The return value is the number of items of the sender, once a separator item has been eventually added.
"*/
{
//START4iTM3;
    if(self.numberOfItems)
        if(itemIndex>=self.numberOfItems)
        {
            if(![[self.itemArray lastObject] isSeparatorItem])
                [self addItem: [NSMenuItem separatorItem]];
        }
        else if(itemIndex > 0)
        {
            if(![[self itemAtIndex: itemIndex] isSeparatorItem] && ![[self itemAtIndex: itemIndex-1] isSeparatorItem])
                [self insertItem: [NSMenuItem separatorItem] atIndex: itemIndex];
        }
    return self.numberOfItems;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeAllItems
- (void) removeAllItems;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    [self.menuRepresentation detachSubmenu];
    while(self.numberOfItems>0)
        [self removeItemAtIndex: 0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertItemsAtIndex:
- (NSInteger) insertItemsAtIndex: (NSInteger) itemIndex;
/*"Tries to insert a PList. If it fails, inserts files then folders."*/
{
//START4iTM3;
    int numberOfItems = self.numberOfItems;
    if(([self insertPListItemsAtIndex: itemIndex]==numberOfItems))
    {
        int separatorIndex = [self insertRegularItemsAtIndex: itemIndex filtered: YES];
        if([self insertDirectoryItemsAtIndex: separatorIndex filtered: YES]>separatorIndex)
            [self insertSeparatorItemAtIndex: separatorIndex];
    }
    return self.numberOfItems;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertPListItemsAtIndex:
- (NSInteger) insertPListItemsAtIndex: (NSInteger) itemIndex;
/*"Simply lists the content of (List Menu).plist" file given by iTM2FilePathFilter's method #{+listMenuArrayAtPath}. Does nothing if this file is void. If the controller responds to #{-filePathFilter} the answer is used instead of iTM2FilePathFilter."*/
{
//START4iTM3;
    SEL filePathFilter = @selector(filePathFilter);
    NSEnumerator * enumerator = [self.controller respondsToSelector: filePathFilter]?
            [[[self.controller performSelector: filePathFilter] listMenuArrayAtPath: self.title] objectEnumerator]:
            [[iTM2FilePathFilter listMenuArrayAtPath: self.title] objectEnumerator];
    if(enumerator != nil)
    {
        int itemIndex = self.numberOfItems;
        NSString *lastPathComponent;
        BOOL canInsertSeparatorItem = ![[self.itemArray lastObject] isEqual: [NSMenuItem separatorItem]];
        while(lastPathComponent = enumerator.nextObject)
        {
            if(lastPathComponent.length)
            {
                NSString * file = [[self.title stringByAppendingPathComponent: lastPathComponent] stringByStandardizingPath];
                NSString * fileType = [[DFM
                                            fileAttributesAtPath: file traverseLink: YES] fileType];
                if([fileType isEqualToString: NSFileTypeRegular] &&
                        ![file isFinderAliasTraverseLink: NO isDirectory: nil])
                {
                    NSMenuItem * menuItem = [[[NSMenuItem alloc]	
                            initWithTitle: lastPathComponent
                                    action: NULL keyEquivalent: @""] autorelease];
                    [self insertItem: menuItem atIndex: itemIndex++];
                    canInsertSeparatorItem = YES;
                }
                else if([fileType isEqualToString: NSFileTypeDirectory])
                {
                    NSMenuItem * menuItem = [[[NSMenuItem alloc]
                            initWithTitle: file.lastPathComponent
                                    action: @selector(_SubmenuAction:) keyEquivalent: @""] autorelease];
                    menuItem.target = self;
                    [self insertItem: menuItem atIndex: itemIndex++];
                    canInsertSeparatorItem = YES;
                }
                else
                    NSLog(@"-[iTM2ListMenu insertPListItemsAtIndex:] refused path: %@, fileType: %@", lastPathComponent, fileType);
            }
            else if(canInsertSeparatorItem)
            {
                [self insertItem: [NSMenuItem separatorItem] atIndex: itemIndex++];
                canInsertSeparatorItem = NO;
            }
            else
                NSLog(@"-[iTM2ListMenu insertPListItemsAtIndex:] illegal separator item.");
        }// while
        if(!canInsertSeparatorItem)
            [self removeItemAtIndex: --itemIndex];
    }// enumerator != nil
    return self.numberOfItems;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertRegularItemsAtIndex:filtered:
- (NSInteger) insertRegularItemsAtIndex: (NSInteger) itemIndex filtered: (BOOL) aFlag;
/*"Inserts all the file items at path the title of the receiver. If aFlag is YES the files are filtered by a iTM2FilePathFilter instance. If the controller responds to #{-filePathFilter}, the answer is used instead of iTM2FilePathFilter."*/
{
//START4iTM3;
    NSString * path = [self.title stringByStandardizingPath];
    SEL filePathFilter = @selector(filePathFilter);
    id filter = aFlag?([self.controller respondsToSelector: filePathFilter]?
            [[self.controller performSelector: filePathFilter] filterAtPath: path]:
            [iTM2FilePathFilter filterAtPath: path]): nil;
    NSFileWrapper * FW = [[[NSFileWrapper alloc] initWithPath: path] autorelease];
    if([FW isDirectory])
    {
        NSDictionary * fileWrappers = [FW fileWrappers];
        NSEnumerator * enumerator = fileWrappers.keyEnumerator;
        while(FW = [fileWrappers objectForKey: enumerator.nextObject])
        {
            if([FW isSymbolicLink])
                FW = [[[NSFileWrapper alloc] initWithPath: [FW symbolicLinkDestination]] autorelease];
            if([FW isRegularFile])
            {
                NSString * filename = [FW filename];
                if(!aFlag || ([filter isValidFileName: filename]))
                {
                    NSMenuItem * menuItem = [[[NSMenuItem alloc]
                            initWithTitle: filename
                                    action: NULL keyEquivalent: @""] autorelease];
                    [self insertItem: menuItem atIndex: itemIndex++];
                }
            }
        }
    }
#if 0
    NSDirectoryEnumerator * enumerator =
                    [DFM enumeratorAtPath: [self.title stringByStandardizingPath]];
    NSString *file;
    while (file = enumerator.nextObject)
    {
        NSString * lastPathComponent = file.lastPathComponent;
        if((!aFlag || ([filter isValidFileName: lastPathComponent] &&
                                    ![file isFinderAliasTraverseLink: NO isDirectory: nil])) &&
                        [[[enumerator fileAttributes] fileType] isEqualToString: NSFileTypeRegular])
        {
            NSMenuItem * menuItem = [[[NSMenuItem alloc] initWithTitle: lastPathComponent
                            action: NULL keyEquivalent: @""] autorelease];
            [self insertItem: menuItem atIndex: itemIndex++];
        }
//        else if([[[enumerator fileAttributes] fileType] isEqualToString: NSFileTypeDirectory])
        [enumerator skipDescendants];
    }
#endif
    return itemIndex;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertDirectoryItemsAtIndex:filtered:
- (NSInteger) insertDirectoryItemsAtIndex: (NSInteger) itemIndex filtered: (BOOL) aFlag;
/*"See #{-insertRegularItemsAtIndex:withTarget:filtered:}. Here the target is the receiver. The items inserted in the menu only concern folders, but no submenus are set, instead their action is #{-_submenuAction}. When the menu will be sent an #{-update} message just before it is displayed on screen, it validates all its items. Then if the controller, which is the target of all menu items with a #{_SubmenuAction} action, does implement the #{-_submenuAction}, it will update the content of the submenu in its #{validateMenuItem} method, just before the menu is displayed on screen."*/
{
//START4iTM3;
    NSString * path = [self.title stringByStandardizingPath];
    SEL filePathFilter = @selector(filePathFilter);
    id filter = aFlag?([self.controller respondsToSelector: filePathFilter]?
            [[self.controller performSelector: filePathFilter] filterAtPath: path]:
            [iTM2FilePathFilter filterAtPath: path]): nil;
    NSFileWrapper * FW = [[[NSFileWrapper alloc] initWithPath: path] autorelease];
    if([FW isDirectory])
    {
        NSDictionary * fileWrappers = [FW fileWrappers];
        NSEnumerator * enumerator = fileWrappers.keyEnumerator;
        while(FW = [fileWrappers objectForKey: enumerator.nextObject])
        {
            if([FW isSymbolicLink])
                FW = [[[NSFileWrapper alloc] initWithPath: [FW symbolicLinkDestination]] autorelease];
            if([FW isDirectory])
            {
                NSString * filename = [FW filename];
                if(!aFlag || ([filter isValidFileName: filename]))
                {
                    NSMenuItem * menuItem = [[[NSMenuItem alloc]
                            initWithTitle: filename
                                    action: @selector(_SubmenuAction:) keyEquivalent: @""] autorelease];
                    menuItem.target = self;
                    [self insertItem: menuItem atIndex: itemIndex++];
                }
            }
        }
    }
#if 0
    NSDirectoryEnumerator * enumerator =
                    [DFM enumeratorAtPath: [self.title stringByStandardizingPath]];
    NSString *file;
    while (file = enumerator.nextObject)
    {
        NSString * lastPathComponent = file.lastPathComponent;
        if((!aFlag || ([filter isValidFileName: lastPathComponent] &&
                                    ![file isFinderAliasTraverseLink: NO isDirectory: nil])) &&
                        [[[enumerator fileAttributes] fileType] isEqualToString: NSFileTypeDirectory])
        {
            NSMenuItem * menuItem = [[[NSMenuItem alloc]
                    initWithTitle: lastPathComponent
                            action: @selector(_SubmenuAction:) keyEquivalent: @""] autorelease];
            menuItem.target = self;
            [self insertItem: menuItem atIndex: itemIndex++];
        }
        #if 0
        else if ([[[enumerator fileAttributes] fileType] isEqualToString: NSFileTypeRegular] &&
                        ![file isFinderAliasTraverseLink: YES isDirectory: nil])
        #endif
        [enumerator skipDescendants];
    }
#endif
    return itemIndex;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= action
- (SEL) action;
/*"Description forthcoming."*/
{
//START4iTM3;
    return _Action;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setAction:
- (void) setAction: (SEL) aSelector;
/*"Description forthcoming."*/
{
//START4iTM3;
    _Action = aSelector;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= target
- (id) target;
/*"Description forthcoming."*/
{
//START4iTM3;
    return _Target;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setTarget:
- (void) setTarget: (id) aTarget;
/*"Description forthcoming."*/
{
//START4iTM3;
    if(![aTarget isEqual: _Target])
    {
        NSAssert2(!aTarget || [aTarget respondsToSelector: self.action],
                                @"-iTM2ListMenu.target =  %@ does not respond to %@",
                                    [aTarget description], NSStringFromSelector(self.action));
        [_Target autorelease];
        _Target = [aTarget retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _SubmenuAction:
- (void) _SubmenuAction: (id) aMenuItem;
/*"Description Forthcoming.*/
{
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateMenuItem:
- (BOOL) validateMenuItem: (id) aMenuItem;
/*"Description forthcoming."*/
{
//START4iTM3;
    if(@selector(_SubmenuAction:)==aMenuItem.action)
    {
        id menu = aMenuItem.menu;
        Class myClass = [menu isKindOfClass: [iTM2ListMenu class]]? [menu class]: [iTM2ListMenu class];
        id submenu = [[[myClass alloc]
                initWithTitle: [menu.title stringByAppendingPathComponent: aMenuItem.title]
                        controller: [menu controller] target: menu.target action: menu.action] autorelease];
        [aMenuItem setSubmenu: submenu];
//NSLog(@"How does it work ? %@; %@", [submenu description], NSStringFromSelector(aMenuItem.action));
        return YES;
    }
    else
        return NO;// Necessary ?
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didUpdateListMenu
- (BOOL) didUpdateListMenu;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if(self.acceptsAlternate)
        return _iTM2LMFlags.isAlternate>0;
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setDidUpdateListMenu:
- (void) setDidUpdateListMenu: (BOOL) aFlag;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if(self.isAlternate != (aFlag != NO))
    {
        _iTM2LMFlags.isAlternate = aFlag ? 1: 0;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isAlternate
- (BOOL) isAlternate;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if(self.acceptsAlternate)
        return _iTM2LMFlags.isAlternate>0;
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setIsAlternateListMenu:
- (void) setAlternate: (BOOL) aFlag;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if(self.isAlternate != (aFlag != NO))
    {
        _iTM2LMFlags.isAlternate = aFlag ? 1: 0;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= acceptsAlternate
- (BOOL) acceptsAlternate;
/*"Default is NO."*/
{
//START4iTM3;
    return _iTM2LMFlags.acceptsAlternate>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setAcceptsAlternate:
- (void) setAcceptsAlternate: (BOOL) aFlag;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if(self.acceptsAlternate != (aFlag != NO))
    {
        _iTM2LMFlags.acceptsAlternate = aFlag ? 1: 0;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Controlling  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= controller
- (id) controller;
/*"Description forthcoming."*/
{
//START4iTM3;
    return _Controller;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setController:
- (void) setController: (id) aController;
/*"Description Forthcoming. So I found a shortcut for Description forthcoming. Nice.
I should ask for copyright ar maybe a patent."*/
{
//START4iTM3;
    if(![aController isEqual: _Controller] && ([self isValidController: aController]))
    {
        [_Controller autorelease];
        _Controller = [aController retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isValidController:
- (BOOL) isValidController: (id) aController;
/*"Returns YES if a controller responds to all messages listed in #{-requiredStringSelectors}."*/
{
//START4iTM3;
    BOOL result = YES;
    for (NString * stringSelector in self.requiredStringSelectors) {
        result = [aController respondsToSelector: NSSelectorFromString(stringSelector)];
        NSAssert2(result, @"Bad controller: %@ does not respond to %@.", [aController description], stringSelector);
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= requiredStringSelectors
- (NSArray *) requiredStringSelectors;
/*"While overriding this method, subclasses will not forget to mention the inherited list of required string selectors. This root implementation simply declares no required method."*/
{
//START4iTM3;
    return nil;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ListMenu
