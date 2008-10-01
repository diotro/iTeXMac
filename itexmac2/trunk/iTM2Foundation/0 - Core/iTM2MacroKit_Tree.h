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
/*!
    @class			iTM2MacroTreeNode
    @superclass		iTM2TreeNode
    @abstract		The macro tree node
    @discussion		This is an abstract node class, the ancestor of all the macro tree nodes below.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroTreeNode:iTM2TreeNode
- (id)contextNode;
@end

/*!
    @class			iTM2MacroRootNode
    @superclass		iTM2MacroTreeNode
    @abstract		The macros root node
    @discussion		There is only one such root node.
					The children represent the various domains, they are instances of iTM2MacroDomainNode.
					This will also be used for key bindings because they are organized in a similar hierarchy.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroRootNode: iTM2MacroTreeNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
- (NSArray *)availableDomains;
@end

/*!
    @class			iTM2MacroDomainNode
    @superclass		iTM2MacroTreeNode
    @abstract		The macros domain node
    @discussion		There is one such node for each domain.
					The children represent the various categories, they are instances of iTM2MacroCategoryNode.
					This will also be used for key bindings because they are organized in a similar hierarchy.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroDomainNode: iTM2MacroTreeNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent domain:(NSString *)domain;
- (id)objectInChildrenWithCategory:(NSString *)category;
- (NSArray *)availableCategories;
@end

/*!
    @class			iTM2MacroCategoryNode
    @superclass		iTM2MacroTreeNode
    @abstract		The macros domain node
    @discussion		There is one such node for each category.
					The children represent the various contexts, they are instances of iTM2MacroContextNode.
					This will also be used for key bindings because they are organized in a similar hierarchy.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroCategoryNode: iTM2MacroTreeNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent category:(NSString *)category;
- (id)objectInChildrenWithContext:(NSString *)context;
- (NSArray *)availableContexts;
@end

/*!
    @class			iTM2MacroAbstractContextNode
    @superclass		iTM2MacroTreeNode
    @abstract		The macro abstract class
    @discussion		Each concrete subclass' instance represents a set of macro or key bindings.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroAbstractContextNode:iTM2MacroTreeNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent context:(NSString *)context;
- (void)addURLPromise:(NSURL *)url;
- (NSURL *)personalURL;
- (NSData *)personalDataForSaving;
+ (NSString *)pathExtension;
- (void)update;
@end

/*!
    @class			iTM2MacroContextNode
    @superclass		iTM2MacroAbstractContextNode
    @abstract		The macro node for some macro context
    @discussion		The macros are gathered in the dictionary for which keys are macro identifiers and values are macros.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroContextNode:iTM2MacroAbstractContextNode
- (NSMutableDictionary *)macros;
- (void)setMacros:(NSMutableDictionary *)macros;
@end

/*!
    @class			iTM2KeyBindingContextNode
    @superclass		iTM2MacroAbstractContextNode
    @abstract		The key bindings node for some key bindings context
    @discussion		The key bindings are gathered in a tree of iTM2KeyBindingNode instances.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2KeyBindingContextNode:iTM2MacroAbstractContextNode
- (iTM2KeyBindingNode *)keyBindings;
- (void)setKeyBindings:(iTM2KeyBindingNode *)keyBindings;
@end
