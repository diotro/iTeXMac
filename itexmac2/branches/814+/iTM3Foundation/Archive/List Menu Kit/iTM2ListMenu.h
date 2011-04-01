/*
//  iTM2ListMenu.h
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


#import <Cocoa/Cocoa.h>


extern NSString * const iTM2ListMenuSmallSizeKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ListMenu

@interface iTM2ListMenu : NSMenu
{
@private
    id _Controller;
    id _Target;
    SEL _Action;
    struct __iTM2LMFlags
    {
        NSUInteger acceptsAlternate: 1;
        NSUInteger isAlternate: 1;
        NSUInteger didUpdateListMenu: 1;
        NSUInteger isMenuPanelObserver: 1;
        NSUInteger RESERVED: 28;
    } _iTM2LMFlags;
}
/*"Class methods."*/
+ (void) initialize;
/*"Setters and getters."*/
- (id) controller;
- (void) setController: (id) aController;
- (id) target;
- (void) setTarget: (id) aTarget;
- (SEL) action;
- (void) setAction: (SEL) aSelector;
- (BOOL) didUpdateListMenu;
- (void) setDidUpdateListMenu: (BOOL) aFlag;
- (BOOL) isAlternate;
- (void) setAlternate: (BOOL) aFlag;
- (BOOL) acceptsAlternate;
- (void) setAcceptsAlternate: (BOOL) aFlag;
/*"Main methods."*/
- (id) initWithTitle: (NSString*) aTitle target: (id) aTarget action: (SEL) aSelector;
- (id) initWithTitle: (NSString*) aTitle controller: (id) aController target: (id) aTarget action: (SEL) aSelector;
- (NSInteger) insertSeparatorItemAtIndex: (NSInteger) itemIndex;
- (void) insertItem: (NSMenuItem *) menuItem atIndex: (NSInteger) itemIndex;
- (NSInteger) insertItemsAtIndex: (NSInteger) itemIndex;
- (NSInteger) insertPListItemsAtIndex: (NSInteger) itemIndex;
- (NSInteger) insertRegularItemsAtIndex: (NSInteger) itemIndex filtered: (BOOL) aFlag;
- (NSInteger) insertDirectoryItemsAtIndex: (NSInteger) itemIndex filtered: (BOOL) aFlag;
- (void) removeAllItems;
- (void) _Prepare;
- (void) prepare;
- (BOOL) isValidController: (id) aController;
- (NSArray *) requiredStringSelectors;
- (void) _SubmenuAction: (id) aMenuItem;
- (BOOL) validateMenuItem: (id) aMenuItem;
/*"Overriden methods."*/
- (void) dealloc;
- (NSString *) description;
- (void) update;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ListMenu
