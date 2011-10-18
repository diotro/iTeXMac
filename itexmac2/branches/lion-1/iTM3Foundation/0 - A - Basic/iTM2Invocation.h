/*
//
//  iTM2Invocation.h
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 16 2009.
//  Copyright © 2001-2009 Laurens'Tribune. All rights reserved.
//
//  Based on previous work by Matt Gallagher on 19/03/07.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
*/
#import <Cocoa/Cocoa.h>

@interface NSInvocation(iTeXMac2)
+ (id)getInvocation4iTM3:(NSInvocation **)invocationRef withTarget:(id)target;// GC version
+ (id)getInvocation4iTM3:(NSInvocation **)invocationRef withTarget:(id)target retainArguments:(BOOL)retain;
- (void)invokeWithSelector4iTM3:(SEL)selector;
- (void)invokeWithSelectors4iTM3:(NSPointerArray *)selectors;
@end

