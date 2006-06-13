/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb  3 22:06:26 GMT 2005.
//  Copyright © 205 Laurens'Tribune. All rights reserved.
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
    @class 		iTM2CompatibilityChecker
    @abstract	Test for a system compatibility.
    @discussion	You can add any +blahFixInstallation method to test for your own environment requirements.
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CompatibilityChecker

@interface iTM2CompatibilityChecker: NSObject

@end

@interface NSMenuItem(iTM2CompatibilityKit)

/*!
    @method		attributedTitle
    @abstract	Abstract forthcoming.
    @discussion	Test for the attributed string length, instead of tha attributed string object.
    @param		None.
    @result		nil
*/
- (NSAttributedString*) attributedTitle;

/*!
    @method		setAttributedTitle:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		string.
    @result		None.
*/
- (void) setAttributedTitle: (NSAttributedString*) string;

/*!
    @method		setIndentationLevel:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		level.
    @result		None.
*/
- (void) setIndentationLevel: (int) level;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CompatibilityChecker
