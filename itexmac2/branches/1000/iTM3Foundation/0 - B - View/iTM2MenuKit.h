/*
//
//  @version Subversion: $Id: iTM2MenuKit.h 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Sep 22 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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


@class NSString;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenu(iTeXMac2)

@interface NSMenu(iTeXMac2)
/*"Class methods"*/
+ (NSMenu *)hierarchicalMenuAtPath4iTM3:(NSString *)aFullPath action:(SEL)aSelector target:(id)aTarget;
/*"Setters and Getters"*/
- (id)deepItemWithTitle4iTM3:(NSString *)aTitle;
- (id)deepItemWithAction4iTM3:(SEL)aSelector;
- (id)deepItemWithRepresentedObject4iTM3:(id)anObject;
- (id)deepItemWithKeyEquivalent4iTM3:(NSString *)key modifierMask:(NSUInteger)mask;
- (BOOL)isRootMenu4iTM3;
- (NSMenu *)rootMenu4iTM3;
- (id)itemWithAction4iTM3:(SEL)aSelector;
- (id)itemWithRepresentedObject4iTM3:(id)anObject;
- (NSInteger)indexOfItemWithAction4iTM3:(SEL)aSelector;
- (NSInteger)indexOfItemWithTarget4iTM3:(id)aTarget;
- (void)Target4iTM3:(id)aTarget;
- (void)AutoenablesItems4iTM3:(BOOL)aFlag;
/*"Main methods"*/
- (void)cleanSeparators4iTM3;
- (void)deselectItemsWithAction4iTM3:(SEL)anAction;
- (void)removeItemsWithAction4iTM3:(SEL)anAction;
- (void)removeItemsWithRepresentedObject4iTM3:(id)anObject;
- (void)deepEnableItems4iTM3;
- (NSMenu *)deepCopy4iTM3;
- (void)deepMakeMenuItemTitlesSmall4iTM3;
/*"Overriden methods"*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenuItem(iTM2Representation)

@interface NSMenuItem(iTM2Representation)
- (NSComparisonResult)compareUsingTitle:(id)rhs;
- (NSString *)representedString;
- (NSDictionary *)representedDictionary;
/*"Overriden methods"*/
@end
@interface NSCell(iTM2Representation)
- (NSString *)representedString;
- (NSDictionary *)representedDictionary;
/*"Overriden methods"*/
@end
