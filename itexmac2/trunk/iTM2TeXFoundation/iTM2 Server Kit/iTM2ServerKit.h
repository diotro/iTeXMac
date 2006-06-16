/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Dec 03 2001.
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

@interface iTM2ServerKit: iTM2Object

/*!
    @method     acceptConversationWithID:
    @abstract   Whether the given conversationID concerns an object of the application
    @discussion This default implementation returns YES, and subclassers will certainly change this behaviour.
				In fact, I certainly know that one subclasser at least will do so because
				I am the so called subclasser and I designed this object to be subclassed lately by myself.
	@param      None
    @result     A name
*/
+(BOOL)acceptConversationWithID:(id)conversationID;
/*!
	@method			acceptNotificationWithEnvironment:
	@abstract		Abstract forthcoming.
	@discussion		If the environment temporary directory is not the same as the application one, NO.
					YES in all other situations. This filters out the distributed notifications sent
					by another instance of the application runnig concurrently.
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+(BOOL)acceptNotificationWithEnvironment:(id)environment;

+(void)sytemSignalSIGUSR1Notified:(NSNotification *)notification;
+(void)shouldEditFileNotified:(NSNotification *)notification;
+(void)shouldOpenFileNotified:(NSNotification *)notification;
+(void)shouldDisplayFileNotified:(NSNotification *)notification;
+(void)shouldUpdateFilesNotified:(NSNotification *)notification;
+(void)serverComwarnerNotified:(NSNotification *)notification;
+(void)serverAppleScriptNotified:(NSNotification *)notification;
@end

