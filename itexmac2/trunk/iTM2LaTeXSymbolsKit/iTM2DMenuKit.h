/*
//  iTM2DMenuKit.h
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

#import <Cocoa/Cocoa.h>


@interface iTM2GridMenuView : NSMenuView
{
@private
    float _CachedWidth;
    NSMutableArray * _CachedHeights;
    NSCellImagePosition _ImagePosition;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSCellImagePosition)imagePosition;
/*"Main methods"*/
/*"Overriden methods"*/
@end

@interface iTM2GridMenu : NSMenu
{
@private
    int _NOC;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (int)numberOfRows;
- (int)numberOfColumns;
- (void)setNumberOfColumns:(int)NOC;
- (NSMenuItem *)itemAtRow:(int)row column:(int)column;
- (int)rowForItemIndex:(int)index;
- (int)columnForItemIndex:(int)index;
- (int)itemIndexForRow:(int)row column:(int)column;
/*"Main methods"*/
/*"Overriden methods"*/
- (id)initWithTitle:(NSString *)aTitle;
- (NSMenuItem *)itemAtIndex:(int)index;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DMenuKit
