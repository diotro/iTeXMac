/*
//
//  @version Subversion: $Id: iTM2DistributedObjectKit.h 49 2006-06-23 13:12:37Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 12 19:38:42 GMT 2006.
//  Copyright ©  2001 Laurens'Tribune. All rights reserved.
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
//  Version history: (format "- date:contribution (contributor) ")  
//  To Do List: (format "- proposition (percentage actually done) ") 
*/

extern NSString * const iTM2ConnectionIdentifierKey;

@interface NSConnection(iTM2DistributedObjectKit)

/*! 
    @method     iTeXMac2ConnectionIdentifier
    @abstract   The iTeXMac2 conection identifier.
    @discussion Description Forthcoming.
    @param      None.
    @result     the output
*/
+ (NSString *)iTeXMac2ConnectionIdentifier;

@end

@interface iTM2ConnectionRoot: NSObject

/*! 
    @method     sharedConnectionRoot
    @abstract   The shared connection controller.
    @discussion Description Forthcoming.
    @param      None.
    @result     the output
*/
+ (id)sharedConnectionRoot;

/*! 
    @method     sharedApplication
    @abstract   The iTeXMac2 application object.
    @discussion Description Forthcoming.
    @param      None.
    @result     the output
*/
- (id)sharedApplication;

@end