/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Nov 27 2001.
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

#import <iTM2Foundation/iTM2ResponderKit.h>

/*!
	@class		iTM2StringFormatControllerResponder
	@abstract	The string formatter responder...
	@discussion A unique instance of this responder is automatically installed in the responder chain
				after the NSApp object (see the iTM2ResponderKit for details about this operation).
				The purpose is to manage the string encoding and the line endings.
				The string encoding menu is automatically populated with a list of available encodings.
				Each menu with an item with action editStringEncodingMenu: is a string encoding menu.
				The list of available encodings will be inserted just before this menu item,
				and wrapped between separators.
*/
@interface iTM2StringFormatControllerResponder: iTM2AutoInstallResponder

/*!
	@method		takeStringEncodingFromTag:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		A sender with a tag
	@result		None
*/
- (IBAction) takeStringEncodingFromTag: (id) sender;

/*!
	@method		stringEncodingToggleAuto:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		None
	@result		None
*/
- (IBAction) stringEncodingToggleAuto: (id) sender;

/*!
	@method		stringEncodingEditList:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		None
	@result		None
*/
- (IBAction) stringEncodingEditList: (id) sender;

/*!
	@method		takeEOLFromTag:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		None
	@result		None
*/
- (IBAction) takeEOLFromTag: (id) sender;

@end
