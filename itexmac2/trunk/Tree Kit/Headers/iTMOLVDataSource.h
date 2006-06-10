/*
//  iTMOLVDataSource.h
//  New projects 1.3
//
//  Created by jlaurens@users.sourceforge.net on Sun Jan 12 2003.
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

#import <Foundation/NSObject.h>

@class iTMNode, NSTableColumn, NSOutlineView;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMOLVDataSource

/*! 
@class iTMOLVDataSource 
@abstract Leafs of a tree wrapping a hierarchical dada structure. 
@discussion The purpose of iTMNode is first to model the tree hierarchy. Each tree item may have a parent and an array of child items. A Tree Item with no parent is the root of the tree, it will certainly be the data source of the outline view but it is not necessary. Of course, a Tree Item is meant to be a child item of its parent if any.
The hierarchy of Tree Items is meant to reflect some hierarchical data model. Each Tree Item points to some data in this hierarchy through its data controller and the child items reflect the structure of this data, namely an array or a dictionary (I don't think of anything else but things should not be limited to those two cases). The main problem is to keep the data model and the Tree Item in synchronization, this will be achieved by the Data Controller through various means. Different Tree Items will have different Data Controllers. Data Controllers are a mean to expand an object somehow like delegation.
Another problem linked to Tree Models must be avoided consists in circular reference. More precisely, if an item retains its parent ant the parent retains its children, a careless design can lead to never deallocated objects.
Each tree item has a key identifier or an index.
*/

@interface iTMOLVDataSource : NSObject
{
@private
    id _Root;
    BOOL _IsRootVisible;
}

/*! 
@method initWithRoot: 
@abstract The root object.
@discussion Description Forthcoming.
@result It returns an iTMNode instance.
*/
- (id) initWithRoot: (id) root;

/*! 
@method root 
@abstract The root object.
@discussion Description Forthcoming.
@result It returns an iTMNode instance.
*/
- (id) root;

/*! 
@method isRootVisible 
@abstract Whether the root is visible or not.
@discussion If the root is visible, it will be the first level object in the outline view and will be selectable.
If the root is not visible, it won't ever be visible in the outline view and so won't be selectable and editable that way.
@result A flag.
*/
- (BOOL) isRootVisible;

/*! 
@method setRootVisible: 
@abstract Sets whether the root is visible or not.
@discussion If the root is visible, it will be the first level object in the outline view and will be selectable.
If the root is not visible, it won't ever be visible in the outline view and so won't be selectable and editable that way.
@param A flag.
*/
- (void) setRootVisible: (BOOL) yorn;

/*! 
@method setRoot: 
@abstract The setter.
@discussion The receiver delegates this responsibility to the model loader. If the model loader is not iTMRModelLoader alike, an NSInternalInconsistency exception is raised.
@param an iTMNode is expected but no exception is raised.
*/
- (void) setRoot: (iTMNode *) argument;

/*! 
@method outlineView:child:ofItem: 
@abstract Standard data source method.
@discussion Asks the item for the information.
@param outlineView: the outline view...
@param index, the integer index.
@param item, the iTMNode.
@result the child item: an ITMNode instance.
*/
- (id) outlineView: (NSOutlineView *) outlineView child: (int) index ofItem: (iTMNode *) item;

/*! 
@method outlineView:isItemExpandable: 
@abstract Standard data source method.
@discussion Asks the item for the information.
@param outlineView: the outline view...
@param item, the iTMNode.
@result a BOOL flag indicating whether the item is expandable.
*/
- (BOOL) outlineView: (NSOutlineView *) outlineView isItemExpandable: (iTMNode *) item;

/*! 
@method outlineView:numberOfChildrenOfItem: 
@abstract Standard data source method.
@discussion Asks the item for the information.
@param outlineView: the outline view...
@param item, the iTMNode.
@result the number of child items item has.
*/
- (int) outlineView: (NSOutlineView *) outlineView numberOfChildrenOfItem: (iTMNode *) item;

/*! 
@method outlineView:objectValueForTableColumn:byItem: 
@abstract Standard data source method.
@discussion Asks the item for the information using the identifier of the column and KVC.
If the identifier is 'FOO', we ask the model displayer of the item for a method named FOOForItem:.
We simply return the result of this method.
@param outlineView: the outline view...
@param tableColumn: the table column...
@param item, the iTMNode.
@result an object.
*/
- (id) outlineView: (NSOutlineView *) outlineView objectValueForTableColumn: (NSTableColumn *) tableColumn byItem: (iTMNode *) item;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMOLVDataSource


#if 0
@interface NSObject(NSOutlineViewDataSource)
// optional
- (void) outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
- (id)outlineView:(NSOutlineView *)outlineView itemForPersistentObject:(id)object;
- (id)outlineView:(NSOutlineView *)outlineView persistentObjectForItem:(id)item;

// optional - drag and drop support
- (BOOL)outlineView:(NSOutlineView *)olv writeItems:(NSArray*)items toPasteboard:(NSPasteboard*)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the outline view once this call returns with YES.  The items array is the list of items that will be participating in the drag.

- (NSDragOperation)outlineView:(NSOutlineView*)olv validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(int)index;
    // This method is used by NSOutlineView to determine a valid drop target.  Based on the mouse position, the outline view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropItem:dropChildIndex: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)outlineView:(NSOutlineView*)olv acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(int)index;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.

@end
#endif
