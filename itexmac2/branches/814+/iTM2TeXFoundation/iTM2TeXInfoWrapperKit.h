/*
//
//  @version Subversion: $Id: iTM2TeXInfoWrapperKit.h 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A pARTICULAR pURPOSE.
//  See the GNU General public License for more details. You should have received a copy
//  of the GNU General public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>

@interface iTM2TeXProjectDocument(Infos)

/*! 
    @method     commandInfos
    @abstract   The command info document.
    @discussion It is an alias for the inherited frontendInfo (for a better name).
    @param      None
    @result     an Info document
*/
- (id)commandInfos;

/*! 
    @method     masterFileKey
    @abstract   The main key is the one for the main file.
    @discussion If this key is not present, one should be asked for.
				Do not assume that the key stored in the info property list is still valid.
				By default, this key should be ...iTM2FrontDocument, and will be dynamically
				replaced by the key of the project front most document.
    @param      None
    @result     a NSString
*/
- (NSString *)masterFileKey;
- (NSString *)realMasterFileKey;

/*! 
    @method     setMasterFileKey:
    @abstract   Set the main key.
    @discussion Description forthcoming.
    @param      key is the new key
    @result     None
*/
- (void)setMasterFileKey:(NSString *)key;


@end
