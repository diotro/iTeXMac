/*
//
//  @version Subversion: $Id: iTM2ApplicationDelegate.h 794 2009-10-04 12:33:28Z jlaurens $ 
//
//  Created by dirk on Tue Jan 23 2001.
//  Modified by jlaurens AT users DOT sourceforge DOT net on Tue Jun 26 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
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

/*!
    @header		iTM2ApplicationDelegate
    @abstract   CONSIDER THIS HEADER AS PRIVATE
    @discussion CONSIDER THIS HEADER AS PRIVATE
*/

extern NSString * const iTM2MakeEmptyDocumentKey;

@interface iTM2ApplicationDelegate: NSResponder 
{
@private
    NSMenu * _ADM;
}
- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication;
- (void)setApplicationDockMenu:(NSMenu *)argument;
@property (retain) NSMenu * _ADM;
@end
