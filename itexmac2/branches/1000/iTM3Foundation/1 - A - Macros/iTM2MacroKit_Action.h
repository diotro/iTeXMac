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

#include "ICURegEx.h"

@interface iTM2StringController(MacroKit_Action)

/*!
	@method		rangeOfNextPlaceholderMarkAfterIndex:getType:ignoreComment:inString:
	@abstract	Abstract forthcoming.
	@discussion	Dicussion forthcoming.
	@param		index.
	@param		typeRef.
	@result		A range.
*/
- (NSRange)rangeOfNextPlaceholderMarkAfterIndex:(NSUInteger)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore inString:(NSString *)aString;

/*!
	@method		rangeOfPreviousPlaceholderMarkBeforeIndex:getType:ignoreComment:inString:
	@abstract	Abstract forthcoming.
	@discussion	Dicussion forthcoming.
	@param		index.
	@param		typeRef.
	@result		A range.
*/
- (NSRange)rangeOfPreviousPlaceholderMarkBeforeIndex:(NSUInteger)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore inString:(NSString *)aString;

/*!
	@method		rangeOfNextPlaceholderAfterIndex:cycle:ignoreComment:inString:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		An index.
	@param		A flag.
	@param		A string.
	@result		A range.
*/
- (NSRange)rangeOfNextPlaceholderAfterIndex:(NSUInteger)index cycle:(BOOL)cycle ignoreComment:(BOOL)ignore inString:(NSString *)aString;

/*!
	@method		rangeOfPreviousPlaceholderBeforeIndex:cycle:ignoreComment:inString:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		An index.
	@param		A flag.
	@param		A string.
	@result		A range.
*/
- (NSRange)rangeOfPreviousPlaceholderBeforeIndex:(NSUInteger)index cycle:(BOOL)cycle ignoreComment:(BOOL)ignore inString:(NSString *)aString;
- (NSRange)rangeOfNextPlaceholderAfterIndex:(NSUInteger)index cycle:(BOOL)cycle ignoreComment:(BOOL)ignore inString:(NSString *)aString;

- (NSMutableArray *)componentsOfMacroForInsertion:(NSString *)macro;
@end