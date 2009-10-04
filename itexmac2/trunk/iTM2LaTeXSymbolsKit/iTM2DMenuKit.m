/*
//  iTM2DMenuKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Sep 03 2003.
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

#import "iTM2DMenuKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2GridMenuView
/*"Description forthcoming."*/
@implementation iTM2GridMenuView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)frame;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    self = [super initWithFrame:frame];
    [_CachedHeights release];
    _CachedHeights = nil;
//NSLog(@"<%@ initWithFrame:...%@>", self, ([self isFlipped]? @"Y": @"N"));
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_CachedHeights release];
    _CachedHeights = nil;
    [super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sizeToFit
- (void)sizeToFit;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id M = [self menu];
    int numberOfColumns = [M numberOfColumns];
    int numberOfRows = [M numberOfRows];
    int numberOfItems = [M numberOfItems];
    int colIndex, rowIndex, itemIndex;
    float totalWidth = 0, totalHeight = 0;
    
//NSLog(@"<%@ sizeToFit: %d>", self, [[self menu] numberOfColumns]);

    [self setNeedsSizing:NO];

    _CachedWidth = 0;
    [_CachedHeights release];
    _CachedHeights = [[NSMutableArray alloc] initWithCapacity:numberOfRows];
    
//NSLog(@"1");

    for(rowIndex = 0, itemIndex = 0; ((itemIndex<numberOfItems) && (rowIndex<numberOfRows)); ++rowIndex)
    {
        float rowHeight = 0;
//NSLog(@"rowIndex = %d", rowIndex);
        for (colIndex = 0; ((itemIndex<numberOfItems) && (colIndex<numberOfColumns)); ++colIndex, ++itemIndex)
        {
            NSMenuItemCell * MIC = [self menuItemCellForItemAtIndex:itemIndex];
            NSSize S;
//NSLog(@"itemIndex = %d, %@", itemIndex, [MIC title]);
            [MIC setImagePosition:NSImageLeft];
            [MIC calcSize];
            S = [MIC cellSize];
//NSLog(@"cellSize vs title size: %f ?= %f", S.width, [MIC titleWidth]);
            if([self imagePosition] == NSNoImage)
                _CachedWidth = MAX(_CachedWidth, [MIC titleWidth]);
            else if([self imagePosition] == NSImageOnly)
                _CachedWidth = MAX(_CachedWidth, [MIC imageWidth]);
            else
                _CachedWidth = MAX(_CachedWidth, S.width);
            rowHeight = MAX(rowHeight, S.height);
        }
        [_CachedHeights addObject:[NSNumber numberWithFloat:rowHeight]];
        totalHeight += rowHeight;
    }
//NSLog(@"2");
    _CachedWidth += 2 * [self horizontalEdgePadding];
    totalWidth = _CachedWidth * [(iTM2GridMenu *)[self menu] numberOfColumns];
    [self setFrame:NSMakeRect(0, 0, totalWidth, totalHeight + 10)];
//NSLog(@"</iTM2GridMenuView sizeToFit: totalWidth = %f>", totalWidth);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rectOfItemAtIndex:
- (NSRect)rectOfItemAtIndex:(int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRect R = NSZeroRect;
    if([self needsSizing])
        [self sizeToFit];
    // fixing the height
    {
        NSMenuItemCell * MIC = [self menuItemCellForItemAtIndex:index];
        R.size.height = [MIC cellSize].height;
    }
    // fixing the x origin and the width
    R.origin.x += [(iTM2GridMenu *)[self menu] columnForItemIndex:index] * _CachedWidth;
    R.size.width = _CachedWidth;
    // fixing the y origin
    {
        int rowIndex = [(iTM2GridMenu *)[self menu] rowForItemIndex:index];
        int row;
        #if 0
        // Good for 10.1.5
        if([self isFlipped])
        {
            for(row = 0; row<rowIndex; ++row)
                R.origin.y += [[_CachedHeights objectAtIndex:row] floatValue];
        }
        else
        {
            for(row = [[self menu] numberOfRows]-1; row>rowIndex; --row)
                R.origin.y += [[_CachedHeights objectAtIndex:row] floatValue];
        }
        #elif 1
        // Good for 10.1.2
        for(row = 0; row<rowIndex; ++row)
                R.origin.y += [[_CachedHeights objectAtIndex:row] floatValue];
        #else
        // Good for 10.1.?
        for(row = 0; row<rowIndex; ++row)
                R.origin.y += [[_CachedHeights objectAtIndex:row] floatValue];
        #endif
        // vertical offset
        R.origin.y += 5;
    }
//NSLog(@"rectOfItemAtIndex: %d\n%@\n%@", index, NSStringFromRect(R), NSStringFromRect([self frame]));
//iTM2_END;
    return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stateImageOffset
- (float)stateImageOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stateImageWidth
- (float)stateImageWidth;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imageAndTitleOffset
- (float)imageAndTitleOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self horizontalEdgePadding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imageAndTitleWidth
- (float)imageAndTitleWidth;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self needsSizing])
        [self sizeToFit];
//iTM2_END;
    return _CachedWidth;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEquivalentOffset
- (float)keyEquivalentOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEquivalentWidth
- (float)keyEquivalentWidth;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imagePosition
- (NSCellImagePosition)imagePosition;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ImagePosition;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImagePosition:
- (void)setImagePosition:(NSCellImagePosition)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _ImagePosition = argument;
//iTM2_END;
	return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawRect:
- (void)drawRect:(NSRect)aRect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self imagePosition] == NSImageOnly)
    {
        [super drawRect:aRect];
//NSLog(@"drawRect: %@", NSStringFromRect(aRect));
    }
    else
        [super drawRect:aRect];
//iTM2_END;
    return;
}
#endif
@synthesize _CachedWidth;
@synthesize _CachedHeights;
@synthesize _ImagePosition;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2GridMenu
/*"The grid menu is meant to be used with the iTM2GridMenuView as representation.
The menu items are stored in the inherited item array, in rows.
No facility is given to deal with rows and columns: inserting a menu item will probably break some alignment.
Only row/column based accessors are provided. Row and column numbering are 0 based"*/
@implementation iTM2GridMenu
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithTitle: 
- (id)initWithTitle:(NSString *)aTitle;
/*"Designated initializer. The menu representation is created here (forced) as an iTM2GridMenuView instance.
The number of columns is set to 1.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithTitle:aTitle])
	{
		iTM2GridMenuView * MR = [[[iTM2GridMenuView alloc] initWithFrame:NSZeroRect] autorelease];
		[self setMenuRepresentation:MR];
		_NOC = 1;
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder: 
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Designated initializer. The menu representation is created here (forced) as an iTM2GridMenuView instance.
The number of columns is set to 1.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithCoder:aDecoder])
	{
		iTM2GridMenuView * MR = [[[iTM2GridMenuView alloc] initWithFrame:NSZeroRect] autorelease];
		[self setMenuRepresentation:MR];
		_NOC = 1;
	}
//NSLog(@"COUCOUROUCOUCOU");
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRows
- (int)numberOfRows;
/*"Computed from the total number of items and the number of columns. The total number of items need not be a multiple of the declared number of columns.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int result = MAX(1,[self numberOfItems]/[self numberOfColumns]);
//iTM2_END;
    return result * [self numberOfColumns] < [self numberOfItems]? result + 1: result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfColumns
- (int)numberOfColumns;
/*"At least 1 is returned.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return MAX(_NOC, 1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNumberOfColumns: 
- (void)setNumberOfColumns:(int)NOC;
/*"Only positive NOC are acceptable. Nothing happens for a nonpositive argument.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if((NOC>=1) && (NOC<=[self numberOfItems]) && (NOC != _NOC)) 
    {
        _NOC = NOC;
        // the geometry has changed: inform the associated menu view
        [[self menuRepresentation] setNeedsSizing:YES];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  itemAtIndex:
- (NSMenuItem *)itemAtIndex:(int)index;
/*"Returns nil to fill the (eventually) missing items to terminate the grid rectangle.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Raise an exception.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return ((index>=0) && (index<[self numberOfItems]))? [super itemAtIndex:index]: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  itemAtRow:column:
- (NSMenuItem *)itemAtRow:(int)row column:(int)column;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Raise an exception.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return ((row>=0) && (column>=0) && (column<[self numberOfColumns]))?
        [self itemAtIndex:row + [self numberOfColumns] * column]: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  itemIndexForRow:column:
- (int)itemIndexForRow:(int)row column:(int)column;
/*"Returns -1 if row or column is not consistent.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return ((row>=0) && (column>=0) && (column<[self numberOfColumns]))?
        row + [self numberOfColumns] * column: -1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rowForItemIndex:
- (int)rowForItemIndex:(int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return index / [self numberOfColumns];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  columnForItemIndex:
- (int)columnForItemIndex:(int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return index % [self numberOfColumns];
}
@synthesize _NOC;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DMenuKit

