/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Dec 03 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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


#define INC [NSNotificationCenter iTeXMac2Center]

@interface NSNotificationCenter(iTeXMac2)
+(id)iTeXMac2Center;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StatusNotificationCenter

@interface iTM2StatusField: NSTextField
/*"Main methods"*/
-(void)statusNotified:(NSNotification *)aNotification;
@end

@interface NSObject(iTM2Status)
/*"Main methods"*/
+(void)postNotificationWithStatus:(NSString *)aStatus;
+(void)postNotificationWithToolTip:(NSString *)aStatus;
-(void)postNotificationWithStatus:(NSString *)aStatus;
-(void)postNotificationWithToolTip:(NSString *)aStatus;
+(void)postNotificationWithStatus:(NSString *)aStatus object:(id)object;
+(void)postNotificationWithToolTip:(NSString *)aStatus object:(id)object;
-(void)postNotificationWithStatus:(NSString *)aStatus object:(id)object;
-(void)postNotificationWithToolTip:(NSString *)aStatus object:(id)object;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2StatusNotificationCenter
