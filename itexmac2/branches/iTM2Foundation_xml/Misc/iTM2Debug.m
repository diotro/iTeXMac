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
@interface NSMenu_iTM2Debug: NSMenu
@end
@implementation NSMenu_iTM2Debug
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void) load;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: 07/26/2003
To Do List:
"*/
{
	iTM2_INIT_POOL;
//iTM2_START;
    [NSObject fixInstallationOf: self];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DebugFixInstallation
+ (void) iTM2DebugFixInstallation;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: 07/26/2003
To Do List:
"*/
{
//iTM2_START;
    if([SUD boolForKey: @"iTM2_DEBUG_NSMenu"])
		iTM2NamedClassPoseAs("NSMenu_iTM2Debug", "NSMenu");
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _recursiveEnableItems
- (void) _recursiveEnableItems;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: 07/26/2003
To Do List:
"*/
{
//iTM2_START;
    if(iTM2_DEBUG>1000)
    {
        if([self respondsToSelector: @selector(recursiveEnableCheck)])
            [self performSelector: @selector(recursiveEnableCheck) withObject: nil];
    }
//iTM2_LOG(@"[self title] is: %@", [self title]);
    [super _recursiveEnableItems];
//iTM2_END;
	return;
}
@end
