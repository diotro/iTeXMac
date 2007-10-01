/*
//  iTM2MorePasteboard.h
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Tue Mar 18 2003.
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


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSPasteboard(iTeXMac2)

@interface NSPasteboard(iTeXMac2)

/*!
@method morePasteboardWithIndex:
@abstract The private iTeXMac2 paste board.
@discussion Description Forthcoming.
@param the index. nil is returned if the index is not in the requested range, no exception yet.
*/
+ (NSPasteboard *) morePasteboardWithIndex: (int) index;

/*!
@method morePasteboardCount
@abstract The number of supplementary paste boards.
@discussion Description Forthcoming.
*/
+ (int) morePasteboardCount;

/*"Class methods"*/
/*"Setters and Getters"*/
/*"Main methods"*/
/*"Overriden methods"*/
@end

/*!
@category iTM2PasteBoard
@abstract The private iTeXMac2 paste board.
@discussion The tag of the sender is used to decide which paste board should be used.
*/

@interface NSTextView(iTM2PasteBoard)

/*!
@method moreCopy:
@abstract The private iTeXMac2 paste board.
@discussion Description Forthcoming.
@param irrelevant sender
*/
- (IBAction) moreCopy: (id) sender;

/*!
@method moreCut:
@abstract The private iTeXMac2 paste board.
@discussion Description Forthcoming.
@param irrelevant sender
*/
- (IBAction) moreCut: (id) sender;

/*!
@method morePaste:
@abstract The private iTeXMac2 paste board.
@discussion Description Forthcoming.
@param irrelevant sender
*/
- (IBAction) morePaste: (id) sender;

@end

@interface iTM2MorePboardMenu: NSMenu
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PasteBoardController
