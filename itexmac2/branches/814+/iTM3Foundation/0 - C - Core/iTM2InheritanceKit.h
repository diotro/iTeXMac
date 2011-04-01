/*
//
//  @version Subversion: $Id: iTM2InheritanceKit.h 401 2007-02-13 11:27:27Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Mar 26 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2InheritanceKit

/*! 
    @category	iTM2InheritanceKit
    @abstract	Inheritance management.
    @discussion	The <code>inheritedValueForKey:</code> is <code>valueForKey:</code> except for the object that have a natural relationship.
				If a responder has no answer for the <code>valueForKey:</code> message, the next responder is asked for its <code>valueForKey:</code>.
				A view will ask its superview, or its window i it is the top most one.
				A window will ask its delegate or its window controller.
				A window controller will ask its docment.
				A text storage will ask its layout manager.
				A layout manager will ask its text view.
				All his assumes that the client does expect a non void value as result.
*/

@interface NSObject(iTM2InheritanceKit)

/*! 
    @method		inheritedValueForKey:
    @abstract	The inherited value for the given key...
    @discussion	See the class description above. The default implementation just returns the current context manager.
                If no value is found in the receiver's context dictionary, the request is forwarded to the context manager.
    @param		Key should work with <code>-valueForKey:</code>
    @result		property
*/
- (id)inheritedValueForKey:(NSString *)aKey;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2InheritanceKit
