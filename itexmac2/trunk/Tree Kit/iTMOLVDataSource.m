/*
  iTMOLVDataSource.m
  New projects 1.3

  Created by jlaurens@users.sourceforge.net on Sun Jan 12 2003.
  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.

  This program is free software; you can redistribute it and/or modify it under the terms
  of the GNU General Public License as published by the Free Software Foundation; either
  version 2 of the License, or any later version, modified by the addendum below.
  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU General Public License for more details. You should have received a copy
  of the GNU General Public License along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
  improve efficiency in both code execution and code reading or writing should be addressed
  to the actual developper team.

  Version history: (format "- date:contribution(contributor)") 
  To Do List: (format "- proposition(percentage actually done)")
*/

#import <Cocoa/Cocoa.h>
#import "iTMOLVDataSource.h"
#import "iTMTreeKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMOLVDataSource

@implementation iTMOLVDataSource
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithRoot
- (id) initWithRoot: (id) root;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(self = [[super init] autorelease])
    {
        [self setRoot: root];
    }
    return [self retain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void) dealloc;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [self setRoot: nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  root
- (id) root;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _Root;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setRoot:
- (void) setRoot: (id) argument;
/*"Description forthcoming. Lowest level. May raise an exception.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x 0x%x", [self class], NSStringFromSelector(_cmd), self, argument);
//NSLog(@"self: %@", self);
//NSLog(@"argument: %@", argument);
    if(argument && ![argument isKindOfClass: [iTMNode class]])
        [NSException raise: NSInvalidArgumentException format: @"-[%@ %@] removeChild: responder expected: got %@.",
            [self class], NSStringFromSelector(_cmd), argument];
    else if(argument != _Root)
    {
#warning recursivity should be tested...
        [_Root autorelease];
        _Root = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isRootVisible
- (BOOL) isRootVisible;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    return _IsRootVisible;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setRootVisible:
- (void) setRootVisible: (BOOL) yorn;
/*"Description forthcoming. Lowest level. May raise an exception.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    _IsRootVisible = yorn;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:child:ofItem:
- (id) outlineView: (NSOutlineView *) outlineView child: (int) index ofItem: (iTMNode *) item;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self);
//NSLog(@"index: %i", index);
//NSLog(@"item: %@", item);
    if(!item)
    {
        if(_IsRootVisible)
            return (index == 0)? [self root]: nil;
        item = [self root];
    }
//NSLog(@"result: %@", result);
    return [item childAtIndex: index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:isItemExpandable:
- (BOOL) outlineView: (NSOutlineView *) outlineView isItemExpandable: (iTMNode *) item;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    if(!item)
    {
        if(_IsRootVisible)
            return YES;
        item = [self root];
    }
    return [item isExpandable];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:numberOfChildrenOfItem:
- (int) outlineView: (NSOutlineView *) outlineView numberOfChildrenOfItem: (iTMNode *) item;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x item: %@", [self class], NSStringFromSelector(_cmd), self, item);
    if(!item)
    {
        if(_IsRootVisible)
            return 1;
        item = [self root];
    }
    return [item numberOfChildren];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:objectValueForTableColumn:byItem:
- (id) outlineView: (NSOutlineView *) outlineView objectValueForTableColumn: (NSTableColumn *) tableColumn byItem: (iTMNode *) item;
/*"Description Forthcoming. The tableColumn identifier is meant to be a string for KVC.
Version history: jlaurens@users.sourceforge.net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
//NSLog(@"[tableColumn identifier]: %@", [tableColumn identifier]);
//NSLog(@"item: 0x%x", item);
//NSLog(@"item: %@", item);
    id K = [tableColumn identifier];
    if(!item) item = [self root];
//NSLog(@"item: %@", item);
//NSLog(@"editor: %@", editor);
    id result = [K isKindOfClass: [NSString class]]? [[item editor] valueForKey: K]: nil;
//NSLog(@"result: <%@>", result);
    return result;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMOLVDataSource


#if 0
@interface NSObject(NSOutlineViewDataSource)
 optional
- (void) outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
- (id)outlineView:(NSOutlineView *)outlineView itemForPersistentObject:(id)object;
- (id)outlineView:(NSOutlineView *)outlineView persistentObjectForItem:(id)item;

 optional - drag and drop support
- (BOOL)outlineView:(NSOutlineView *)olv writeItems:(NSArray*)items toPasteboard:(NSPasteboard*)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the outline view once this call returns with YES.  The items array is the list of items that will be participating in the drag.

- (NSDragOperation)outlineView:(NSOutlineView*)olv validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(int)index;
    // This method is used by NSOutlineView to determine a valid drop target.  Based on the mouse position, the outline view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropItem:dropChildIndex: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)outlineView:(NSOutlineView*)olv acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(int)index;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.

@end
#endif
