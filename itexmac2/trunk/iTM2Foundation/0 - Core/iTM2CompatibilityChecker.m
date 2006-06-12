/*
//  iTM2CompatibilityChecker.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb  3 22:06:26 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2CompatibilityChecker.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
//#import <iTM2Foundation/iTM2Implementation.h>
//#import <stdlib.h>

#define iTM2NSAppKitVersionNumber10_0 577
#define iTM2NSAppKitVersionNumber10_1 620
#define iTM2NSAppKitVersionNumber10_2 663
#define iTM2NSAppKitVersionNumber10_3 743

@implementation iTM2MainInstaller(CompatibilityChecker)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  JAGUARCompleteInstallation
+ (void) JAGUARCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if (floor(NSAppKitVersionNumber) < iTM2NSAppKitVersionNumber10_2)
	{
		NSRunCriticalAlertPanel(@"Bad configuration...", @"iTeXMac2 needs at least Mac OS X version 10.2", @"Quit", nil, nil);
		exit(1);
	}
#ifdef __iTM2_JAGUAR_SUPPORT_OFF__
#warning NO JAGUAR support, remove the __iTM2_JAGUAR_SUPPORT_OFF__ preprocessor macro
#else
	if (floor(NSAppKitVersionNumber) < iTM2NSAppKitVersionNumber10_3)
	{
		NSString * path = [[self classBundle] pathForResource:@"iTM2JAGUARSupportKit" ofType:[NSBundle plugInPathExtension]];
		if([path length])
		{
			[[[[NSBundle alloc] initWithPath:path] autorelease] load];
			if(![NSMenuItem instancesRespondToSelector:@selector(setAttributedTitle:)])
			{
				NSRunCriticalAlertPanel(@"Bad configuration...", @"iTeXMac2's built in compatibility private plugin is broken (2)", @"Quit", nil, nil);
				exit(1);
			}
		}
		else
		{
			NSRunCriticalAlertPanel(@"Bad configuration...", @"iTeXMac2 misses a built in compatibility private plugin (2)", @"Quit", nil, nil);
			exit(1);
		}
	}
#endif
//iTM2_END;
	return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2CompatibilityChecker

