// iTM2AREFinderOptionsInspector.h
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jan 09 2003.
//  From source code of Mike Ferris's MOKit at http://mokit.sourcefoge.net
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

/*!
@header iTM2AREFinderOptionsInspector_Private
@discussion Defines the private API of the iTM2AREFinderOptionsInspector class.
*/

#import <iTM2Foundation/iTM2AREFinderInspectorKit.h>

@interface iTM2AREFinderOptionsInspector(PRIVATE)

/*!
@method validateUserInterfaceItems
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
*/
- (BOOL)validateUserInterfaceItems;

/*!
@method validateToggleExpanded:
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
@param: sender is the widget to be validated.
*/
- (BOOL)validateToggleExpanded:(id)sender;

/*!
@method validateToggleIgnoreSubexpressions:
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
@param: sender is the widget to be validated.
*/
- (BOOL)validateToggleIgnoreSubexpressions:(id)sender;

/*!
@method validateToggleNewlineAnchor:
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
@param: sender is the widget to be validated.
*/
- (BOOL)validateToggleNewlineAnchor:(id)sender;

/*!
@method validateToggleNewlineStop:
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
@param: sender is the widget to be validated.
*/
- (BOOL)validateToggleNewlineStop:(id)sender;

/*!
@method validateToggleQuote:
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
@param: sender is the widget to be validated.
*/
- (BOOL)validateToggleQuote:(id)sender;

/*!
@method validateToggleNewlineSensitive:
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
@param: sender is the widget to be validated.
*/
- (BOOL)validateToggleNewlineSensitive:(id)sender;

/*!
@method validateToggleType:
@abstract Validates the user interface items.
@discussion See the NSControl iTeXMac2 category.
@param: sender is the widget to be validated.
*/
- (BOOL)validateToggleType:(id)sender;

@end
