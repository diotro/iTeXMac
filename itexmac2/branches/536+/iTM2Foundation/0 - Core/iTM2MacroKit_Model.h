/*
//
//  @version Subversion: $Id: iTM2MacroKit.h 494 2007-05-11 06:22:21Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
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

#import "iTM2MacroKit_Tree.h"

@interface iTM2MacroTreeNode(Model)
@end

@interface iTM2MacroAbstractContextNode(Model)
@end

@interface iTM2MacroAbstractModelNode(Model)
- (NSXMLElement *)XMLElement;
- (NSXMLElement *)mutableXMLElement;
- (NSMutableArray *)XMLElements;
- (NSMutableArray *)mutableXMLElements;
- (void)addMutableXMLElement:(NSXMLElement *)element;
- (void)addXMLElement:(NSXMLElement *)element;
- (BOOL)isMutable;
- (BOOL)beMutable;
- (void)removeLastMutableXMLElement;
- (NSXMLElement *)templateXMLChildElement;
@end

@interface iTM2MacroAbstractModelNode(Properties)
- (NSArray *)IDs;
- (NSString *)ID;
- (void)setID:(NSString *)newID;
- (BOOL)validateID:(NSString **)newIDRef error:(NSError **)outErrorPtr;
@end

@interface iTM2MacroContextNode:iTM2MacroAbstractContextNode
@end

@interface iTM2MacroList:iTM2MacroAbstractModelNode
- (id)objectInChildrenWithID:(NSString *)ID;
- (NSArray *)availableIDs;
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index;
- (id)objectInAvailableMacrosWithID:(NSString *)ID;
- (id)objectInAvailableMacrosAtIndex:(int)index;
@end

@interface iTM2MacroNode(Model)
- (NSString *)name;
- (NSString *)tooltip;
- (SEL)action;
- (NSString *)concreteArgument;
@end

@interface iTM2KeyBindingContextNode:iTM2MacroAbstractContextNode
@end

@interface iTM2KeyBindingNode:iTM2MacroAbstractModelNode
- (NSArray *)availableKeys;
- (id)objectInAvailableKeyBindingsWithKey:(NSString *)key;
- (BOOL)validateKey:(NSString **)newKeyRef error:(NSError **)outErrorPtr;
- (unsigned int)indexOfObjectInAvailableKeyBindings:(id)object;
- (void)removeObjectFromAvailableKeyBindingsAtIndex:(int)index;
@end

@interface iTM2KeyBindingList:iTM2KeyBindingNode
@end

