/*
//  iTM2JAGUARSupportKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan 18 22:21:11 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

//#if 0
#if MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_3
@interface NSMenuItem(iTM2JAGUARSupportKit)

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

@interface NSTextView(iTM2JAGUARSupportKit)
- (void)setUsesFindPanel:(BOOL)yorn;
- (BOOL)usesFindPanel;
@end

@interface NSDocumentController(iTM2JAGUARSupportKit)
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError;
@end

#endif
