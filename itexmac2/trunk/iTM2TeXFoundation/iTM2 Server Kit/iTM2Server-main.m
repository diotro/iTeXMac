/*
//  iTM2_Server_main.m 
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jan 15 15:36:51 GMT 2005.
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

#import <Cocoa/Cocoa.h>

#include "iTM2ServerKeys.m"

BOOL LaunchiTeXMac2IfNeeded(int argc, const char *argv[]);
void iTeXMac2Usage(int argc, const char *argv[]);

@protocol iTM2Connection
- (oneway void)performProjectActionWithContext:(NSDictionary *)context;
@end

int main(int argc, const char *argv[])
{
    iTM2_INIT_POOL;
	NSProcessInfo * processInfo = [NSProcessInfo processInfo];
	NSArray * arguments = [processInfo arguments];
	NSDictionary * environment = [processInfo environment];
	NSDictionary * context = [NSDictionary dictionaryWithObjectsAndKeys:environment,iTM2ServerEnvironmentKey,arguments,iTM2ServerArgumentsKey,nil];
	NSString * connectionID = [environment objectForKey:@"iTM2ConnectionID"];
//NSLog(@"connectionID is: %@", connectionID);
	if(!connectionID)
	{
		NSEnumerator * E = [arguments objectEnumerator];
		while(connectionID = [E nextObject])
		{
			if([connectionID isEqualToString:iTM2ServerConnectionIDKey])
			{
				connectionID = [E nextObject];
				break;
			}
			else if([connectionID isEqualToString:@"-debug"])
			{
				NSLog(@"Build Test fullfilled");
				iTeXMac2Usage(argc, argv);
				iTM2_RELEASE_POOL;
				return 0;
			}
		}
	}
//NSLog(@"connectionID is: %@", connectionID);
	NSDistantObject <iTM2Connection>  *rootProxy = (NSDistantObject <iTM2Connection> *)[NSConnection rootProxyForConnectionWithRegisteredName:connectionID host:nil];
	if(rootProxy)
	{
//NSLog(@"rootProxy is: %@", rootProxy);
		[rootProxy setProtocolForProxy:@protocol(iTM2Connection)];
		[rootProxy performProjectActionWithContext:context];
		iTM2_RELEASE_POOL;
		return 0;
	}
	else if(![connectionID length] && LaunchiTeXMac2IfNeeded(argc, argv))
	{
//NSLog(@"Distributed notification is: %@", iTM2ServerPerformProjectActionWithContextNotification);
				[[NSDistributedNotificationCenter defaultCenter]
			postNotificationName: iTM2ServerPerformProjectActionWithContextNotification
				object: nil
					userInfo: context
						deliverImmediately: YES];
		iTM2_RELEASE_POOL;
		return 0;
	}
    iTeXMac2Usage(argc, argv);
    iTM2_RELEASE_POOL;
    return 1;
}

#warning *** FRAGILE design: iTeXMac2BundleIdentifier
#pragma mark *** FRAGILE design: iTeXMac2BundleIdentifier
NSString * const iTeXMac2BundleIdentifier = @"comp.text.tex.iTeXMac2";

BOOL LaunchiTeXMac2IfNeeded(int argc, const char *argv[])
{
    #if __TEST__
        return YES;
    #endif
    iTM2_INIT_POOL;
//NSLog(@"Launching iTeXMac2");
	NSString * iTM2_temporaryDirectory = [[[NSProcessInfo processInfo] environment] objectForKey:@"iTM2_TemporaryDirectory"];
//NSLog(@"iTM2_temporaryDirectory is: %@", iTM2_temporaryDirectory);
	if([iTM2_temporaryDirectory length])
	{
		// this program was launched by iTeXMac, either directly or through another script.
        if([[NSWorkspace sharedWorkspace] launchApplication:
				[[iTM2_temporaryDirectory stringByAppendingPathComponent:@"iTeXMac2.app"] stringByStandardizingPath]])
		{
//NSLog(@".....  Switching to iTeXMac2.");
			return YES;
		}
		else
		{
            NSLog(@"..........  ERROR: I could not open iTeXMac2, it has certainly moved.");
			return NO;
		}
	}
    NSEnumerator * E = [[[NSWorkspace sharedWorkspace] launchedApplications] objectEnumerator];
    NSDictionary * D;
    BOOL isRunning = NO;
	NSString * applicationPath = nil;
    while(D = [E nextObject])
	{
		applicationPath = [D objectForKey:@"NSApplicationPath"];
		NSBundle * applicationBundle = [NSBundle bundleWithPath:applicationPath];
//NSLog(@"applicationPath: %@", applicationPath);
//NSLog(@"bundleIdentifier: %@", [applicationBundle bundleIdentifier]);
        if([[applicationBundle bundleIdentifier] isEqualToString:iTeXMac2BundleIdentifier])
        {
            isRunning = YES;
            break;
        }
	}
    if(!isRunning)
    {
        NSLog(@"Trying to launch iTeXMac2...");
		applicationPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library"];
		applicationPath = [applicationPath stringByAppendingPathComponent: @"TeX"];
		applicationPath = [applicationPath stringByAppendingPathComponent: @"bin"];
		applicationPath = [applicationPath stringByAppendingPathComponent: @"iTeXMac2.app"];
		applicationPath = [applicationPath stringByStandardizingPath];
        NSLog(@"applicationPath: %@", applicationPath);
        if(isRunning = [[NSWorkspace sharedWorkspace] launchApplication:applicationPath])
        {
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
			NSLog(@"iTeXMac2 launched...");
        }
        else
        {
            NSBeep();
            NSLog(@"Sorry, I could not open iTeXMac2");
        }
    }
    iTM2_RELEASE_POOL;
    return isRunning;
}
void iTeXMac2Usage(int argc, const char *argv[])
{
    iTM2_INIT_POOL;
    NSLog(@"Using %s as server (as 06/21/2006)", argv[0]);
    NSLog(@"");
    NSLog(@"To let iTeXMac2 edit one particular file:");
    NSLog(@"========================================");
    NSLog(@"  %s -conversation conversationID edit -file fileName [-line lineNumber] [-column columnNumber] [-dont-order-front]", argv[0]);
    NSLog(@"  When not absolute, path are relative to the current directory.");
    NSLog(@"");
    NSLog(@"To let iTeXMac2 display one particular file:");
    NSLog(@"===========================================");
    NSLog(@"  %s -conversation conversationID display -file fileName [-source sourceName] [-line lineNumber] [-column columnNumber] [-dont-order-front]", argv[0]);
    NSLog(@"  When not absolute, fileName is relative to the current directory.");
    NSLog(@"  When not absolute, sourceName is relative to the directory of fileName.");
    NSLog(@"");
    NSLog(@"To let iTeXMac2 update one particular file:");
    NSLog(@"==========================================");
    NSLog(@"  %s -conversation conversationID update -file fileName", argv[0]);
    NSLog(@"  When not absolute, fileName is relative to the current directory.");
    NSLog(@"");
#if 0
    NSLog(@"To let iTeXMac2 update all its files:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID update -all", argv[0]);
    NSLog(@"");
    NSLog(@"To notify iTeXMac2 of a comment:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID notify -comment \"The comment\"", argv[0]);
    NSLog(@"");
    NSLog(@"To notify iTeXMac2 of a warning:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID notify -warning \"The warning message\"", argv[0]);
    NSLog(@"");
    NSLog(@"To notify iTeXMac2 of an error:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID notify -error \"The error message\"", argv[0]);
    NSLog(@"");
    NSLog(@"");
    NSLog(@"To ask iTeXMac2 to execute an applescript:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID applescript -source \"The applescript source\"", argv[0]);
#endif
    NSLog(@"In all the previous commands, the optional conversationID is given by the $iTM2_Conversation environment variable.");
    NSLog(@"This variable is set up by iTeXMac2 when launching tasks.");
    NSLog(@"This is suitable when more than one (recent) iTeXMac2 is running to know what should be the expected target.");
    NSLog(@"If you don't have a conversation number, simply don't use it.");
    iTM2_RELEASE_POOL;
    return;
}
