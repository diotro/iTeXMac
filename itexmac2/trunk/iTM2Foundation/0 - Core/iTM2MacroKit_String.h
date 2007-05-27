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

@interface NSString(iTM2MacroKit_)

- (NSString *)stringByEscapingPerlControlCharacters;

+ (NSString *)bullet;

/*!
	@method		rangeOfNextPlaceholderMarkAfterIndex:getType:ignoreComment:
	@abstract	Abstract forthcoming.
	@discussion	Dicussion forthcoming.
	@param		index.
	@param		typeRef.
	@result		A range.
*/
- (NSRange)rangeOfNextPlaceholderMarkAfterIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;

/*!
	@method		rangeOfPreviousPlaceholderMarkBeforeIndex:getType:ignoreComment:
	@abstract	Abstract forthcoming.
	@discussion	Dicussion forthcoming.
	@param		index.
	@param		typeRef.
	@result		A range.
*/
- (NSRange)rangeOfPreviousPlaceholderMarkBeforeIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;

/*!
	@method		rangeOfNextPlaceholderAfterIndex:cycle:tabAnchor:ignoreComment:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		An index.
	@param		A flag.
	@param		A string.
	@result		A range.
*/
- (NSRange)rangeOfNextPlaceholderAfterIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor ignoreComment:(BOOL)ignore;

/*!
	@method		rangeOfPreviousPlaceholderBeforeIndex:cycle:tabAnchor:ignoreComment:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		An index.
	@param		A flag.
	@param		A string.
	@result		A range.
*/
- (NSRange)rangeOfPreviousPlaceholderBeforeIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor ignoreComment:(BOOL)ignore;


/*!
	@method		lineComponents
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		None.
    @result     NSArray, receiver split into lines
*/
- (NSArray *)lineComponents;

@end

