/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 10 2002.
//  Copyright (c) 2001 Laurens'Tribune. All rights reserved.
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


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AppleScriptLauncher

@interface iTM2AppleScriptLauncher : NSObject
/*"Class methods"*/
+ (IBAction)executeAppleScriptAtPath:(id)sender;
+ (IBAction)executeAppleScript:(id)sender;
/*"Setters and Getters"*/
/*"Main methods"*/
/*"Overriden methods"*/
@end

/*!
	@protocol		NSScriptSuiteRegistry(iTeXMac2)
	@abstract		Extension of the apple script design.
	@discussion		The standard applescrip design does not allow bundles to add a category to a script class.
					This is a workaround to fix this.
					The idea is to read the applescript dictionary and interpret supplemental keys to change the class hierarchy.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface NSScriptSuiteRegistry(iTeXMac2)
- (void)loadSuiteWithDictionary:(NSDictionary *)dictionary fromBundle:(NSBundle *)bundle;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AppleScriptLauncher

#import "iTM2TextDocumentKit.h"

@interface iTM2TextDocument(AppleScripting)
/*!
	@method			endOfLine
	@abstract		The end of line used.
	@discussion		Due to a limitation in design, unprintable characters are (?) not allowed in AppleScript.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSUInteger)endOfLine;
- (void)setEndOfLine:(NSUInteger)argument;
@end
