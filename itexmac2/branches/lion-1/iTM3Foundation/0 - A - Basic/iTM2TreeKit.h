/*
//
//  @version Subversion: $Id: iTM2TreeKit.h 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat May 24 2003.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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
//  Version history:(format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <Foundation/Foundation.h>

/*! 
	@class		iTM2TreeNode 
	@abstract	Leafs of a tree wrapping an ordered hierarchical dada structure. 
	@discussion	The purpose of iTM2TreeNode is first to model the simplest tree hierarchy.
				It is the direct data model for a NSTreeController.

				The hierarchy of Tree Items is meant to reflect some hierarchical data model.
				Each tree item may have a parent which it belongs to, and an array of child items.
				A Tree Item with no parent is the root of the tree,

				Of course, a Tree Item is meant to be a child item of its parent if any.
				The Parent retains its children but the child just points to its parent to avoid infinite retain loops.
				Another problem linked to Tree Models that must be avoided consists in circular reference.
				More precisely, if an item retains its parent ant the parent retains its children,
				a careless design can lead to never deallocated objects.

				Each Tree Item points to some leaf data in this hierarchy through its value instance variable
				and the child items reflect the structure of this data, namely an array.
*/
@protocol iTM2TreeNode <NSObject,NSCopying>

@required

@property (assign) __weak id <iTM2TreeNode> parent;

/*!
	@method		prepareChildren
	@abstract	Prepare the children of the node.
	@discussion	Entry point for lazy initialization of children.
				The default implementation does nothing.
	@result		None.
*/
- (void)prepareChildren;

/*!
	@property	children
	@abstract	The children of the node.
	@discussion	Read only array of the children of the node.
	@result		An array.
*/
@property (readonly) NSArray * children;
/*!
	@property	countOfChildren
	@abstract	The number of children of the node.
	@discussion	No access to the whole set of children. The -addObjectInChildren: and -removeChild: of the receiver must be used instead, they preserve the overall consistency.
                When setting the countOIfChildren, if there is a shrink, previously declared childen are lost.
                If there is an enlargement, [NSNull null] objects are added.
				If you access an object that has never been set before, [NSNull null] is returned.
*/
@property (assign) NSUInteger countOfChildren;

/*!
	@method addObjectInChildren:
	@abstract Designated method to add an object to the child items array.
	@discussion This methods preserves the front end hierarchy of objects and underlying data model,
	once an object (iTMNode's instance in general) is added, its parent is set to the receiver if possible,
	and the data model is inserted in the data underlying data hierarchy if not already there. The controller of the receiver is asked to preserve the underlying data model hierarchy.
	@result The object added. If a copy is really added to the array, this copy is returned.
	nil is returned when nothing has been added, either there was nothing to add or there was an error or the child item was already listed in the child items array.
*/
- (void)addObjectInChildren:(id <iTM2TreeNode>)anObject;

/*!
	@method insertObject:inChildrenAtIndex:
	@abstract Designated method to add an object to the child items array.
	@discussion This methods preserves the front end hierarchy of objects and underlying data model,
	once an object (iTMNode's instance in general) is added, its parent is set to the receiver if possible,
	and the data model is inserted in the data underlying data hierarchy if not already there. The controller of the receiver is asked to preserve the underlying data model hierarchy.
	@result The object added. If a copy is really added to the array, this copy is returned.
	nil is returned when nothing has been added, either there was nothing to add or there was an error or the child item was already listed in the child items array.
*/
- (void)insertObject:(id <iTM2TreeNode>)anObject inChildrenAtIndex:(NSUInteger)index;

/*!
	@method		replaceObjectInChildrenAtIndex:withObject:
	@abstract	Designated method to replace an object in the child items array.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (void)replaceObjectInChildrenAtIndex:(NSUInteger) index withObject:(id <iTM2TreeNode>) anObject;

/*!
	@method		removeObjectFromChildren:
	@abstract	Designated method to remove an object to the child items array.
	@discussion	This methods preserves the front end hierarchy of objects and the underlying data model.
				Once an object (iTMNode's instance in general) is removed, its parent is set to the nil if possible,
				and its data is removed from the data hierarchy.
				The overall consistency is preserved by asking the leaf of the receiver to do the real job through the message -removeOwnerChild:.
	@result		A flag indicating wheether the object has really been removed.
*/
- (void)removeObjectFromChildren:(id <iTM2TreeNode>)anObject;

/*!
	@method		removeObjectFromChildrenAtIndex:
	@abstract	Designated method to remove an object to the child items array.
	@discussion	This methods preserves the front end hierarchy of objects and the underlying data model.
				Once an object (iTMNode's instance in general) is removed, its parent is set to the nil if possible,
				and its data is removed from the data hierarchy.
				The overall consistency is preserved by asking the leaf of the receiver to do the real job through the message -removeOwnerChild:.
	@result		A flag indicating wheether the object has really been removed.
*/
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index;

/*!
	@method		indexOfObjectInChildren:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (NSUInteger)indexOfObjectInChildren:(id <iTM2TreeNode>)anObject;

/*!
	@method		objectInChildrenAtIndex:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (id)objectInChildrenAtIndex:(NSUInteger)index;

/*!
	@method		objectInChildrenWithValue:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (id)objectInChildrenWithValue:(id)anObject;

/*!
	@method		objectInChildrenWithNonretainedValue:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (id)objectInChildrenWithNonretainedValue:(id)anObject;

/*!
	@method		deepObjectInChildrenWithValue:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (id)deepObjectInChildrenWithValue:(id)anObject;

/*!
	@method		deepObjectInChildrenWithNonretainedValue:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		None.
*/
- (id)deepObjectInChildrenWithNonretainedValue:(id)anObject;

/*!
	@method		objectInChildrenWithValue:forKeyPath:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		a node.
*/
- (id <iTM2TreeNode>)objectInChildrenWithValue:(id)anObject forKeyPath:(NSString *)path;

/*!
	@method		deepObjectInChildrenWithValue:forKeyPath:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		a node.
*/
- (id <iTM2TreeNode>)deepObjectInChildrenWithValue:(id)anObject forKeyPath:(NSString *)path;

/*!
	@method		nextSibling
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		a node.
*/
@property (readonly) id <iTM2TreeNode> nextSibling;

/*!
	@method		nextParentSibling
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		a node.
*/
@property (readonly) id <iTM2TreeNode> nextParentSibling;

/*!
	@method		nextNode
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		a node.
*/
@property (readonly) id <iTM2TreeNode> nextNode;

/*!
	@method		indexPath
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@result		an index path instance.
*/
@property (readonly) NSIndexPath * indexPath;

@property (assign) id value;
@property (assign) __weak id nonretainedValue;
@property (assign) NSUInteger flags;

@end

@interface iTM2TreeNode: NSObject <iTM2TreeNode>
{
@private
	__weak   id <iTM2TreeNode> iVarParent4iTM3;
	__strong id iVarChildren4iTM3;
	__strong id iVarValue4iTM3;
	__weak   id iVarNonretainedValue4iTM3;
	NSUInteger	iVarFlags4iTM3;
}

@property (assign) __weak   id <iTM2TreeNode> parent;
@property (assign,readonly) __strong NSArray * children;

@property (assign) __strong id value;
@property (assign) __weak   id nonretainedValue;

/*!
	@method		initWithParent:
	@abstract	Initializer.
	@discussion	The default value is a mutable dictionary.
    @param      the parent node
	@result		An object.
*/
- (id <iTM2TreeNode>)initWithParent:(id <iTM2TreeNode>)aParent;

/*!
	@method		initWithParent:value:
	@abstract	Initializer.
	@discussion	Discussion forthcoming.
    @param      the parent node
    @param      the strong value
	@result		An object.
*/
- (id <iTM2TreeNode>)initWithParent:(id <iTM2TreeNode>)aParent value:(id)anObject;

/*!
	@method		initWithParent:retainedValue:
	@abstract	Initializer.
	@discussion	Discussion forthcoming.
    @param      the parent node
    @param      the weak value
	@result		An object.
*/
- (id <iTM2TreeNode>)initWithParent:(id <iTM2TreeNode>)aParent nonretainedValue:(id)anObject;

/*!
	@method		longDescription
	@abstract	Long description.
	@discussion	Discussion forthcoming.
	@result		A string.
*/
- (NSString *)longDescription;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TreeNode

/*!
    @class       iTM2PatriciaController 
    @superclass  NSObject
    @abstract    The patricia tree controller
    @discussion  discussion forthcoming
*/
@interface iTM2PatriciaController : NSObject
{
@private
    id iVarImplementation4iTM3;
}

- (BOOL)addStrings:(NSArray *)stringList;

- (BOOL)addString:(NSString *)aString;

- (BOOL)removeString:(NSString *)aString;

- (NSArray *)stringListForPrefix:(NSString *)prefix;

- (NSArray *)stringList;

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)RORef;

- (BOOL)writeToURL:(NSURL *)url error:(NSError **)RORef;

@property (retain) id iVarImplementation4iTM3;
@end

/*! 
	@class		iTM2TreeNode 
	@abstract	Leafs of a tree wrapping an ordered hierarchical dada structure. 
	@discussion	The purpose of iTM2TreeNode is first to model the simplest tree hierarchy.
				It is the direct data model for a NSTreeController.

				The hierarchy of Tree Items is meant to reflect some hierarchical data model.
				Each tree item may have a parent which it belongs to, and an array of child items.
				A Tree Item with no parent is the root of the tree,

				Of course, a Tree Item is meant to be a child item of its parent if any.
				The Parent retains its children but the child just points to its parent to avoid infinite retain loops.
				Another problem linked to Tree Models that must be avoided consists in circular reference.
				More precisely, if an item retains its parent ant the parent retains its children,
				a careless design can lead to never deallocated objects.

				Each Tree Item points to some leaf data in this hierarchy through its value instance variable
				and the child items reflect the structure of this data, namely an array.
*/
@protocol iTM2LinkedNode <NSObject, NSCopying>
/*!
	@method		parent
	@abstract	The parent.
	@discussion	Not retained by the receiver.
	@result		A node.
*/
- (id <iTM2LinkedNode>) parent;
- (void)setParent:(id <iTM2LinkedNode>)aNode;

/*!
	@method		firstChild
	@abstract	The first child.
	@discussion	Owned by the receiver. The receiver is the parent of its first child and all of its siblings.
				The receiver does not own the siblings of its own child.
	@result		A node.
*/
- (id <iTM2LinkedNode>)firstChild;
- (void)setFirstChild:(id <iTM2LinkedNode>)aNode;

/*!
	@method		lastChild
	@abstract	The last child.
	@discussion	Not retained by the receiver, except as first child if relevant.
	@result		A node.
*/
- (id <iTM2LinkedNode>)lastChild;
- (void)setLastChild:(id <iTM2LinkedNode>)aNode;

/*!
	@method		countOfObjectsInChildNodes
	@abstract	The number of child nodes of the node.
	@discussion	No access to nodes by index. I counts all the nodes of the subtree which roots at the receiver, except the receiver itself.
				The children of the receiver are the first child and its siblings. The child nodes are its children, its children's children, and so on.
	@result		A count.
*/
- (NSUInteger)countOfObjectsInChildNodes;

/*!
	@method		updateCountOfObjectsInChildNodes
	@abstract	Update the number of child nodes of the receiver.
	@discussion	For each children.
	@result		A count.
*/
- (void)updateCountOfObjectsInChildNodes;

/*!
	@method		nextNode
	@abstract	Next node in the tree.
	@discussion	Allows to walk a tree.
	@result		a node.
*/
- (id <iTM2LinkedNode>)nextNode;
- (id <iTM2LinkedNode>)nextSibling;
- (void)setNextSibling:(id <iTM2LinkedNode>)aNode;

/*!
	@method		previousNode
	@abstract	Previous node in the tree.
	@discussion	Allows to walk the tree.
	@result		a node.
*/
- (id <iTM2LinkedNode>)previousNode;
- (id <iTM2LinkedNode>)previousSibling;
- (void)setPreviousSibling:(id <iTM2LinkedNode>)aNode;

/*!
	@method		firstSibling
	@abstract	The first sibling.
	@discussion	The first sibling can be the receiver.
	@result		a node.
*/
- (id <iTM2LinkedNode>)firstSibling;

/*!
	@method		lastSibling
	@abstract	The last sibling.
	@discussion	The last sibling can be the receiver.
	@result		a node.
*/
- (id <iTM2LinkedNode>)lastSibling;

/*!
	@method		root
	@abstract	The root of the tree containing the receiver.
	@discussion	Discussion forthcoming.
	@result		a node.
*/
- (id <iTM2LinkedNode>)root;

/*!
	@method		deepestFirstChild
	@abstract	The deepest first child.
	@discussion	The first child's first child's first child's...
	@result		a node.
*/
- (id <iTM2LinkedNode>)deepestFirstChild;

/*!
	@method		deepestLastChild
	@abstract	The deepest last child.
	@discussion	The last child's last child's last child's...
	@result		a node.
*/
- (id <iTM2LinkedNode>)deepestLastChild;

/*!
	@method		insertSibling:
	@abstract	Insert the given sibling after the receiver.
	@discussion	The sibling to be inserted is first detached.
				The siblings of the receiver, if any, will be moved after the last sibling of the inserted node.
	@result		None.
*/
- (void)insertSibling:(id <iTM2LinkedNode>)node;

/*!
	@method		insertFirstChild:
	@abstract	Insert the given sibling below the receiver.
	@discussion	The sibling to be inserted is first detached.
				The first child of the receiver, if any, will be moved after the last sibling of the inserted node.
	@result		None.
*/
- (void)insertFirstChild:(id <iTM2LinkedNode>)node;

/*!
	@method		removeSiblings
	@abstract	Remove the siblings.
	@discussion	Remove all the siblings of the receiver, with their children.
	@result		None.
*/
- (void)removeSiblings;

/*!
	@method		detach
	@abstract	Detach the receiver.
	@discussion	Detach the receiver and its child nodes from their enclosing tree. Does nothing if the receiver does not belong to a tree,
				which occurs when the receiver has no previous sibling nor parent.
				If the receiver is owned by its parent, in other words, is the first child of its parent,
				its next sibling, if any, becomes the first child of its parent.
				If the receiver is own by its preceding sibling,
				it is removed from the sibling chain and its next sibling will become the next sibling and property of the former owner.
	@result		None.
*/
- (void)detach;

/*!
	@method		removeChildren
	@abstract	Remove the children.
	@discussion	The first child of the receiver is removed, with all its siblings and children.
	@result		None.
*/
- (void)removeChildren;

@end

@interface iTM2LinkedNode: NSObject <iTM2LinkedNode>
{
@private
	id __weak iVarParent4iTM3;
	id iVarFirstChild4iTM3;
	id __weak iVarLastChild4iTM3;
	id  iVarNextSibling4iTM3;
	id __weak iVarPreviousSibling4iTM3;
	NSUInteger iVarCountOfObjectsInChildNodes4iTM3;
	NSString * iVarValue4iTM3;
}

@property (assign) id <iTM2LinkedNode> __weak parent;
@property (retain) id <iTM2LinkedNode> firstChild;
@property (assign) id <iTM2LinkedNode> __weak lastChild;
@property (retain) id <iTM2LinkedNode> nextSibling;
@property (assign) id <iTM2LinkedNode> __weak previousSibling;
@property (assign) NSUInteger countOfObjectsInChildNodes;
@property (retain) NSString * value;

- (id <iTM2LinkedNode>)initWithValue:(id)value;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TreeNode
