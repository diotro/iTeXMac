/*
//  iTM2Debug.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Thu Jan  6 08:34:54 GMT 2005.
//  Copyright © 2001 Laurens'Tribune. All rights reserved.
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


#import <iTM2Foundation/iTM2Debug.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Debug
/*"iTM2Debug."*/

#pragma mark MENU
@interface NSMenu(PRIVATE)
- (void) _recursiveEnableItems;
@end
#import <objc/objc-runtime.h>
#import <objc/objc-class.h>
@implementation NSMenu(iTM2Debug)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2__recursiveEnableItems
- (void) SWZ_iTM2__recursiveEnableItems;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: 07/26/2003
To Do List:
"*/
{
//START4iTM3;
    if(DEBUG4iTM3>1000)
    {
        if([self respondsToSelector: @selector(recursiveEnableCheck)])
            [self performSelector: @selector(recursiveEnableCheck) withObject: nil];
    }
//LOG4iTM3(@"self.title is: %@", self.title);
    [self SWZ_iTM2__recursiveEnableItems];
//END4iTM3;
	return;
}
@end
#warning MIGRATION: iTM2NamedClassPoseAs
@implementation iTM2MainInstaller(Debug)
+ (void)prepareNSMenuDebugCompleteInstallation4iTM3;
{
	if([self swizzleInstanceMethodSelector4iTM3:@selector() error:NULL])
	{
		MILESTONE4iTM3((@"NSMenu(iTM2Debug)"),(@"The menu might scheck recursively its items"));
	}
}
@end