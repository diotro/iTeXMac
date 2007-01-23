/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
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

/*!
	@header			iTM2PerlKitServer
	@abstract		Abstract forthcoming.
	@discussion		Consider this technology as experimental (to be improved and possibly deprecated in a near future), do not use it.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/

@interface NSApplication(iTM2PerlKit)
- (Class)vendedClassForName:(NSString *)name;
- (NSMethodSignature *)vendedClassForName:(NSString *)name methodSignatureForSelector:(SEL)aSelector;
- (void)vendedClassForName:(NSString *)name forwardInvocation:(NSInvocation *)invocation;
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector;
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector withObject:(id)object1;
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PerlKitServer
