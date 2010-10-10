/*
//
//  @version Subversion: $Id: iTM2HelpKit.h 49 2006-06-23 13:12:37Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Sep 24 2001.
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

#import "iTM2ResponderKit.h"

/*!
    @const      iTM2ToolbarShowHelpItemIdentifier
    @abstract   The identifier of the show help toolbar item
    @discussion Description Forthcoming
*/
extern NSString * const iTM2ToolbarShowHelpItemIdentifier;

/*!
    @const      iTeXMac2HelpBookName
    @abstract   The iTeXMac2 help book name
    @discussion Description Forthcoming
*/
extern NSString * const iTeXMac2HelpBookName;

@class 	iTM2ButtonHelp;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2HelpManager

@interface iTM2HelpManager: NSObject
/*"Class methods"*/
+ (iTM2ButtonHelp *)buttonHelp;
+ (id)helpToolbarItem;
/*"Main methods"*/
+ (void)showHelp:(id)sender;
+ (void)showHelp:(id)object anchor:(NSString *)aKey;
@end

@interface iTM2HelpResponder: iTM2AutoInstallResponder
@end

@interface iTM2ButtonHelp : NSButton
/*"Class methods"*/
/*"Setters and Getters"*/
/*"Main methods"*/
- (void)showHelp:(id)sender;
- (NSString *)description;
- (void)awakeFromNib;
/*"Overriden methods"*/
- (id)initWithFrame:(NSRect)irrelevant;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2HelpKit
