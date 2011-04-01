/*
//
//  @version Subversion: $Id: iTM2DistributedObjectKit.m 124 2006-09-05 16:21:11Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 12 19:38:42 GMT 2006.
//  Copyright ©  2001 Laurens'Tribune. All rights reserved.
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

#import "iTM2BundleKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2DistributedObjectKit.h"

NSString * const iTM2ConnectionIdentifierKey = @"iTM2ConnectionID";

@implementation NSConnection(iTM2DistributedObjectKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTeXMac2ConnectionIdentifier
+ (NSString *)iTeXMac2ConnectionIdentifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return NSBundle.mainBundle.uniqueApplicationIdentifier4iTM3;
}
@end

@implementation NSApplication(iTM2DistributedObjectKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DistributedObjectKit_CompleteDidFinishLaunching4iTM3
- (void)iTM2DistributedObjectKit_CompleteDidFinishLaunching4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSConnection * theConnection = [[NSConnection new] autorelease];
	[theConnection setRootObject:[iTM2ConnectionRoot sharedConnectionRoot]];
	NSString * identifier = [NSConnection iTeXMac2ConnectionIdentifier];
	if ([theConnection registerName:identifier])
	{
		LOG4iTM3(@"The DO connection is available with identifier: <%@>", identifier);
	}
	else
	{
		LOG4iTM3(@"****  ERROR: The DO connection is NOT available... iTeXMac2 won't work as expected.");
	}
//END4iTM3;
	return;
}
@end

@implementation iTM2ConnectionRoot
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedConnectionRoot
+ (id)sharedConnectionRoot;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static id O = nil;
	return O?:(O=[[iTM2ConnectionRoot alloc] init]);
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedApplication
- (id)sharedApplication;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [NSApplication sharedApplication];
//END4iTM3;
}
@end