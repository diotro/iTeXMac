/*
//
//  @version Subversion: $Id: iTM2MacroKit.h 54 2006-06-25 12:38:05Z jlaurens $ 
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

/*!
	@header			iTM2MacroPrefPane
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroServer

#import "iTM2Implementation.h"

/*!
    @class       iTM2MacroController
    @superclass  iTM2Object
    @abstract    The macros manager
    @discussion  (comprehensive description)
*/
@interface iTM2MacroController: iTM2Object
/*!
    @method     sharedMacroController
    @abstract   (brief description)
    @discussion (comprehensive description)
    @result     (description)
*/
+ (id)sharedMacroController;

#if 0
/*!
    @method     storageTree
    @abstract   The macro storage tree
    @discussion Lazy initializer.
    @result     The macro storage tree
*/
- (id)storageTree;

/*!
    @method     setStorageTree:
    @abstract   Set the macro storage tree
    @discussion Designated setter.
				Cleans the running and source trees. They will be constructed from the new storage tree on demand.
    @param      aTree
    @result     None
*/
- (void)setStorageTree:(id)aTree;
#endif

/*!
    @method     runningTree
    @abstract   The macro running tree
    @discussion Lazy initializer.
    @result     The macro running tree
*/
- (id)runningTree;

/*!
    @method     setRunningTree:
    @abstract   Set the macro running tree
    @discussion Designated setter.
    @param      aTree
    @result     None
*/
- (void)setRunningTree:(id)aTree;

/*!
    @method     sourceTree
    @abstract   The macro source tree
    @discussion Lazy initializer.
    @result     The macro source tree
*/
- (id)sourceTree;

/*!
    @method     setSourceTree:
    @abstract   Set the macro source tree
    @discussion Designated setter.
    @param      aTree
    @result     None
*/
- (void)setSourceTree:(id)aTree;

@end

