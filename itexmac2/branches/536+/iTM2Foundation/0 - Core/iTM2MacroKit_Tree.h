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

#import <iTM2Foundation/iTM2MacroKit.h>

#import <iTM2Foundation/iTM2TreeKit.h>
#import <iTM2Foundation/ICURegEx.h>

// all the nodes used in macro management are descendants of this class
// this will allow to change the ancestor only once
@interface iTM2MacroTreeNode:iTM2TreeNode
- (id)contextNode;
@end

@interface iTM2MacroRootNode: iTM2MacroTreeNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
- (NSArray *)availableDomains;
@end

@interface iTM2MacroDomainNode: iTM2MacroTreeNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent domain:(NSString *)domain;
- (id)objectInChildrenWithCategory:(NSString *)category;
- (NSArray *)availableCategories;
@end

@interface iTM2MacroCategoryNode: iTM2MacroTreeNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent category:(NSString *)category;
- (id)objectInChildrenWithContext:(NSString *)context;
- (NSArray *)availableContexts;
@end

@interface iTM2MacroAbstractContextNode:iTM2MacroTreeNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent context:(NSString *)context;
- (void)addURLPromise:(NSURL *)url;
- (NSURL *)personalURL;
- (NSData *)personalDataForSaving;
+ (NSString *)pathExtension;
@end

@interface iTM2MacroContextNode:iTM2MacroAbstractContextNode
- (NSMutableDictionary *)macros;
- (void)setMacros:(NSMutableDictionary *)macros;
@end

@interface iTM2KeyBindingContextNode:iTM2MacroAbstractContextNode
- (iTM2KeyBindingNode *)keyBindings;
- (void)setKeyBindings:(iTM2KeyBindingNode *)keyBindings;
@end
