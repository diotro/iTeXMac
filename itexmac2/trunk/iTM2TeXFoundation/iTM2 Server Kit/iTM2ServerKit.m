/*
//  iTM2ServerKit.m
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jan 15 15:36:51 GMT 2005.
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

#import "iTM2ServerKit.h"
#import "iTM2ServerKeys.h"

#import <iTM2Foundation/iTM2JAGUARSupportKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>

//#import <iTM2Foundation/iTM2SystemSignalKit.h>
//#import <iTM2Foundation/iTM2DocumentControllerKit.h>
//#import <iTM2Foundation/iTM2InstallationKit.h>
//#import <iTM2Foundation/iTM2Implementation.h>

@interface iTM2ServerKit(PRIVATE)
+ (void) completeServerInstallation;
@end

@implementation iTM2MainInstaller(ServerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ServerKitCompleteInstallation
+ (void) iTM2ServerKitCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2ServerKit completeServerInstallation];
//iTM2_END;
	return;
}
@end

#warning ATTENTION COCO
@implementation iTM2ServerKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= completeServerInstallation
+ (void) completeServerInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(shouldOpenFileNotified:)
            name: iTM2ServerShouldOpenFileNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(shouldEditFileNotified:)
            name: iTM2ServerShouldEditFileNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(shouldDisplayFileNotified:)
            name: iTM2ServerShouldDisplayFileNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(shouldUpdateFilesNotified:)
            name: iTM2ServerShouldUpdateFilesNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(serverComwarnerNotified:)
            name: iTM2ServerComwarnerNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(serverAppleScriptNotified:)
            name: iTM2ServerAppleScriptNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(shouldInsertTextNotified:)
            name: iTM2ServerShouldInsertTextNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
	#warning THIS SHOULD ONLY OCCUR WITH USER DEFAULT SETTINGS
    [[iTM2SystemSignalNotificationCenter defaultCenter] addObserver: self
        selector: @selector(sytemSignalSIGUSR1Notified:)
            name: iTM2SystemSignalSIGUSR1Notification
                object: nil];
    NSTask * T = [[[NSTask allocWithZone: [self zone]] init] autorelease];
	NSString * auxiliaryServerSetupPath = @"bin/iTeXMac2 Server Setup";
    NSString * path = [[self classBundle] pathForAuxiliaryExecutable: auxiliaryServerSetupPath];
	NSAssert1([path length], @"***  ERROR: Missing \"%@\"", auxiliaryServerSetupPath);
    if([path length])
    {
		NSMutableDictionary * environment = [[[[NSProcessInfo processInfo] environment] mutableCopy] autorelease];
		NSString * P;
		NSString * k;
		P = [[self classBundle] pathForAuxiliaryExecutable: @"bin/iTeXMac2 Server"];
		k = @"iTM2_SERVER_PATH";
		if([P length])
			[environment setObject: P forKey: k];
		else
		{
			iTM2_LOG(@"ERROR: things won't certainly work as expected... no server available");
		}
		P = [[NSBundle mainBundle] bundlePath];
		k = @"iTM2_APPLICATION_BUNDLE_PATH";
		if([P length])
			[environment setObject: P forKey: k];
		P = [P lastPathComponent];
		k = @"iTM2_APPLICATION_BUNDLE_NAME";
		if([P length])
			[environment setObject: P forKey: k];
		P = @"iTeXMac2";//[[NSBundle mainBundle] bundleName];
		k = @"iTM2_APPLICATION_NAME";
		if([P length])
			[environment setObject: P forKey: k];
		k = @"iTM2DebugEnabled";
		[environment setObject: [NSString stringWithFormat: @"%i", iTM2DebugEnabled] forKey: k];
		P = NSHomeDirectory();
		k = @"iTM2_HOME";
		if([P length])
			[environment setObject: P forKey: k];
		P = [NSBundle temporaryDirectory];
		k = @"iTM2_TemporaryDirectory";
		if([P length])
			[environment setObject: P forKey: k];
		[T setEnvironment: environment];
        [T setLaunchPath: path];
		[T setStandardError: [NSPipe pipe]];
		[T setStandardOutput: [NSPipe pipe]];
		[T setStandardInput: [NSPipe pipe]];
		[DNC addObserver: self selector: @selector(setupTaskDidTerminateNotified:)
			name: NSTaskDidTerminateNotification object: T];
		[iTM2MileStone registerMileStone: @"iTeXMac2 Server is not properly setup" forKey: @"iTeXMac2 Server Setup"];
        [[T retain] launch];// it will be reseased when termination is notified
    }
    else
    {
        iTM2_LOG(@"***  Could not find an \"%@\" script", auxiliaryServerSetupPath);
    }
	iTM2_RELEASE_POOL;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= acceptConversationWithID:
+ (BOOL) acceptConversationWithID: (id) conversationID;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= acceptNotificationWithEnvironment:
+ (BOOL) acceptNotificationWithEnvironment: (id) environment;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([environment isKindOfClass: [NSDictionary class]])
	{
		NSString * temporaryDirectory = [environment objectForKey: @"iTM2_TemporaryDirectory"];
		if([temporaryDirectory isKindOfClass: [NSString class]])
		{
			return [temporaryDirectory isEqual: [NSBundle temporaryDirectory]] || ![temporaryDirectory length];
		}
		return !temporaryDirectory;
	}
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setupTaskDidTerminateNotified:
+ (void) setupTaskDidTerminateNotified: (NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2MileStone putMileStoneForKey: @"iTeXMac2 Server Setup"];
	iTM2_LOG(@"Server Setup complete:");
	NSTask * T = [[notification object] autorelease];// the object was the task launched
	[DNC removeObserver: self name: [notification name] object: T];
	NSMutableString * MS = [NSMutableString stringWithString: @"Output:\n"];
	NSData * D;
	NSFileHandle * FH = [[T standardOutput] fileHandleForReading];
	while((D = [FH availableData]), [D length])
		[MS appendString: [[[NSString alloc] initWithData: D encoding: NSUTF8StringEncoding] autorelease]];
	FH = [[T standardError] fileHandleForReading];
	if((D = [FH availableData]), [D length])
	{
		[MS appendString: @"Error:\n"];
		do
		{
			[MS appendString: [[[NSString alloc] initWithData: D encoding: NSUTF8StringEncoding] autorelease]];
		}
		while((D = [FH availableData]), [D length]);
	}
	NSLog(MS);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sytemSignalSIGUSR1Notified:
+ (void) sytemSignalSIGUSR1Notified: (NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"name: %@", [notification name]);
#else
    if(iTM2DebugEnabled>1000)
    {
        iTM2_LOG(@"name: %@", [notification name]);
    }
    [[SDC documents] makeObjectsPerformSelector: @selector(revertToSaved:) withObject: nil];
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldEditFileNotified:
+ (void) shouldEditFileNotified: (NSNotification *) notification;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
#else
    NSDictionary * D = [notification userInfo];
	if(![self acceptConversationWithID: [D objectForKey: iTM2ServerConversationIDKey]])
		return;
	if(![self acceptNotificationWithEnvironment: [D objectForKey: iTM2ProcessInfoEnvironmentKey]])
		return;
    NSString * projectName = [D objectForKey: iTM2ServerProjectKey];
    NSString * fileName = [D objectForKey: iTM2ServerFileKey];
    NSString * lineNumber = [D objectForKey: iTM2ServerLineKey];
    NSString * columnNumber = [D objectForKey: iTM2ServerColumnKey];
	id doc = [SDC documentForFileName: fileName];
	BOOL orderFront = ![[D objectForKey: iTM2ServerDontOrderFrontKey] boolValue];
	if(doc)
	{
		[doc updateIfNeeded];
		[doc displayLine: [lineNumber intValue]
			column: (columnNumber? [columnNumber intValue]: -1)
				withHint: nil
					orderFront: orderFront];
		if(!orderFront)
			[[[[doc windowControllers] lastObject] window] orderWindow: NSWindowBelow relativeTo: [[NSApp mainWindow] windowNumber]];
	}
	else
	{
		iTM2ProjectDocument * PD = [SPC projectForFileName: fileName];
		if(!PD)
		{
			PD = [SPC projectForFileName: projectName];
			[PD newKeyForFileName: fileName];
		}
		doc = [SDC openDocumentWithContentsOfURL: [NSURL fileURLWithPath: fileName] display: NO error: nil];
		[doc displayLine: [lineNumber intValue]
                column: (columnNumber? [columnNumber intValue]: -1)
					withHint: nil
						orderFront: orderFront];
		if(!orderFront)
			[[[[doc windowControllers] lastObject] window] orderWindow: NSWindowBelow relativeTo: [[NSApp mainWindow] windowNumber]];
	}
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldOpenFileNotified:
+ (void) shouldOpenFileNotified: (NSNotification *) notification;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
#else
    NSDictionary * D = [notification userInfo];
	if(![self acceptConversationWithID: [D objectForKey: iTM2ServerConversationIDKey]])
		return;
	if(![self acceptNotificationWithEnvironment: [D objectForKey: iTM2ProcessInfoEnvironmentKey]])
		return;
    NSString * projectName = [D objectForKey: iTM2ServerProjectKey];
    NSString * fileName = [D objectForKey: iTM2ServerFileKey];
	id document = [SDC documentForFileName: fileName];
	BOOL dontOrderFront = [[D objectForKey: iTM2ServerDontOrderFrontKey] boolValue];
	if(document)
	{
		[document updateIfNeeded];
		if(!dontOrderFront && [SDC shouldCreateUI])
		{
			[document makeWindowControllers];
			[document showWindows];
		}
	}
	else
	{
		iTM2ProjectDocument * PD = [SPC projectForFileName: fileName];
		if(!PD)
		{
			PD = [SPC projectForFileName: projectName];
			[PD newKeyForFileName: fileName];
		}
		[SDC openDocumentWithContentsOfURL: [NSURL fileURLWithPath: fileName] display: YES error: nil];
	}
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldDisplayFileNotified:
+ (void) shouldDisplayFileNotified: (NSNotification *) notification;
/*"This is the answer to the notification sent by main as server tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
#else
    NSDictionary * D = [notification userInfo];
	if(![self acceptConversationWithID: [D objectForKey: iTM2ServerConversationIDKey]])
		return;
	if(![self acceptNotificationWithEnvironment: [D objectForKey: iTM2ProcessInfoEnvironmentKey]])
		return;
    NSString * projectName = [D objectForKey: iTM2ServerProjectKey];
    NSString * fileName = [D objectForKey: iTM2ServerFileKey];
    NSString * sourceName = [D objectForKey: iTM2ServerSourceKey];
    NSString * lineNumber = [D objectForKey: iTM2ServerLineKey];
    NSString * columnNumber = [D objectForKey: iTM2ServerColumnKey];
	BOOL orderFront = ![[D objectForKey: iTM2ServerDontOrderFrontKey] boolValue];
	iTM2ProjectDocument * PD = [SPC projectForFileName: fileName];
	if(!PD)
	{
		PD = [SPC projectForFileName: projectName];
		[PD newKeyForFileName: fileName save:YES];
	}
	id doc = [SDC openDocumentWithContentsOfURL: [NSURL fileURLWithPath: fileName] display: NO error: nil];
	[doc displayPageForLine: [lineNumber intValue]
			column: (columnNumber? [columnNumber intValue]: -1)
				source: sourceName
					withHint: D
						orderFront: orderFront
							force: YES];// or NO? a SUD here?
	if(!orderFront)
		[[[[doc windowControllers] lastObject] window] orderWindow: NSWindowBelow relativeTo: [[NSApp mainWindow] windowNumber]];
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldUpdateFilesNotified:
+ (void) shouldUpdateFilesNotified: (NSNotification *) notification;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
#else
    NSDictionary * D = [notification userInfo];
	if(![self acceptConversationWithID: [D objectForKey: iTM2ServerConversationIDKey]])
		return;
	if(![self acceptNotificationWithEnvironment: [D objectForKey: iTM2ProcessInfoEnvironmentKey]])
		return;
    NSString * projectName = [D objectForKey: iTM2ServerProjectKey];
    NSArray * fileNames = [D objectForKey: iTM2ServerFilesKey];
    if([fileNames isKindOfClass: [NSArray class]])
    {
		NSString * fileName;
		NSEnumerator * E = [fileNames objectEnumerator];
		while(fileName = [E nextObject])
			if([fileName isKindOfClass: [NSString class]])
			{
				NSDocument * document = [SDC documentForFileName: fileName];
				if(document)
				{
					[document updateIfNeeded];
					NSWindow * W = [[[document windowControllers] lastObject] window];
					[W orderWindow: NSWindowBelow relativeTo: [[NSApp mainWindow] windowNumber]];
					[W displayIfNeeded];
				}
				else
				{
					iTM2ProjectDocument * PD = [SPC projectForFileName: fileName];
					if(!PD)
					{
						PD = [SPC projectForFileName: projectName];
						[PD newKeyForFileName: fileName];
					}
					if([DFM fileExistsAtPath:fileName])
					{
						NSURL * fileURL = [NSURL fileURLWithPath: fileName];
						NSError * localError = nil;
						if(document = [PD openSubdocumentWithContentsOfURL:fileURL context:nil display:NO error:&localError])
						{
							[document makeWindowControllers];
							NSWindow * W = [[[document windowControllers] lastObject] window];
							[document updateIfNeeded];
							[W orderWindow: NSWindowBelow relativeTo: [[NSApp mainWindow] windowNumber]];
							[W displayIfNeeded];
						}
						else if(localError)
						{
							iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Could not update document: %@", fileName]),(localError));
						}
					}
					else
					{
						iTM2_LOG(@"No file to update at: %@", fileName);
					}
				}
			}
			else
			{
				iTM2_LOG(@"A file name was expected instead of: %@", fileName);
			}
    }
    else
    {
        iTM2_LOG(@"An array of file names was expected in: %@", [notification userInfo]);
    }
#warning NYI: -all not supported
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldInsertTextNotified:
+ (void) shouldInsertTextNotified: (NSNotification *) notification;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
#else
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
	
#warning NYI: -all not supported
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  serverComwarnerNotified:
+ (void) serverComwarnerNotified: (NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
#else
    NSDictionary * D = (NSDictionary *)[notification userInfo];
    iTM2_LOG(@"userInfo: %@", D);
#endif
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  serverAppleScriptNotified:
+ (void) serverAppleScriptNotified: (NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"userInfo: %@", [notification userInfo]);
#endif
    NSDictionary * D = (NSDictionary *)[notification userInfo];
	if(![self acceptConversationWithID: [D objectForKey: iTM2ServerConversationIDKey]])
		return;
	if(![self acceptNotificationWithEnvironment: [D objectForKey: iTM2ProcessInfoEnvironmentKey]])
		return;
    NSAppleScript * AS = [[[NSAppleScript allocWithZone: [self zone]] initWithSource: [D objectForKey: iTM2ServerSourceKey]] autorelease];
    if(AS)
    {
        NSDictionary * errorInfo = nil;
        [AS executeAndReturnError: &errorInfo];
        if(errorInfo)
        {
            NSMutableString * MS = [NSMutableString stringWithString: @"\n! AppleScript execution error:\n"];
            NSString * message;
            if(message = [errorInfo objectForKey: NSAppleScriptErrorAppName])
                [MS appendFormat: @"! Application: %@\n", message];
            if(message = [errorInfo objectForKey: NSAppleScriptErrorMessage])
                [MS appendFormat: @"! Reason: %@\n", message];
            if(message = [errorInfo objectForKey: NSAppleScriptErrorNumber])
                [MS appendFormat: @"! Error number: %@\n", message];
            if(message = [errorInfo objectForKey: NSAppleScriptErrorBriefMessage])
                [MS appendFormat: @"! Brief reason: %@\n", message];
            if(message = [errorInfo objectForKey: NSAppleScriptErrorRange])
                [MS appendFormat: @"! Error range: %@\n", message];
            iTM2_LOG(MS);
        }
    }
    return;
}
@end
