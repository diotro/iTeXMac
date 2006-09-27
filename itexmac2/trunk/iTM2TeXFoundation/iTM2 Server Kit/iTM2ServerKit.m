/*
//
//  @version Subversion: $Id$ 
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
#import <iTM2TeXFoundation/iTM2ServerKeys.h>
#import <iTM2TeXFoundation/iTM2TeXProjectCommandKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectTaskKit.h>

NSString * const iTM2ServerAllKey = @"-all";
NSString * const iTM2ServerFileKey = @"-file";
NSString * const iTM2ServerFilesKey = @"-files";
NSString * const iTM2ServerColumnKey = @"-column";
NSString * const iTM2ServerLineKey = @"-line";
NSString * const iTM2ServerSourceKey = @"-source";
NSString * const iTM2ServerProjectKey = @"-project";
NSString * const iTM2ServerDontOrderFrontKey = @"-dontorderfront";

NSString * const iTM2ProcessInfoEnvironmentKey = @"iTM2ProcessInfoEnvironment";

NSString * const iTM2ServerComwarnerNotification = @"iTM2ServerComwarner";
NSString * const iTM2ServerConversationIDKey = @"ConversationID";
NSString * const iTM2ServerCommentsKey = @"Comments";
NSString * const iTM2ServerWarningsKey = @"Warnings";
NSString * const iTM2ServerErrorsKey = @"Errors";

NSString * const iTM2ServerAppleScriptNotification = @"iTM2ServerAppleScript";

NSString * const iTM2ServerShouldInsertTextNotification = @"iTM2ServerShouldInsertTextNotification";

NSString * const iTM2ServerConversationIdentifierKey = @"conversation";
NSString * const iTM2ServerScriptFileNameKey = @"script_file_name";
NSString * const iTM2ServerInputTextKey = @"input_text";
NSString * const iTM2ServerInputSelectedLocationKey = @"input_selected_location";
NSString * const iTM2ServerInputSelectedLengthKey = @"input_selected_length";
NSString * const iTM2ServerOutputTextKey = @"output_text";
NSString * const iTM2ServerOutputSelectedLocationKey = @"output_selected_location";
NSString * const iTM2ServerOutputSelectedLengthKey = @"output_selected_length";
NSString * const iTM2ServerOutputInsertionLocationKey = @"output_insertion_location";
NSString * const iTM2ServerOutputInsertionLengthKey = @"output_insertion_length";

#import <iTM2Foundation/iTM2JAGUARSupportKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>

//#import <iTM2Foundation/iTM2SystemSignalKit.h>
//#import <iTM2Foundation/iTM2DocumentControllerKit.h>
//#import <iTM2Foundation/iTM2InstallationKit.h>
//#import <iTM2Foundation/iTM2Implementation.h>

@interface iTM2ServerKit(PRIVATE)
+ (void)completeServerInstallation;
+ (NSString *)getVerbFromContext:(NSDictionary *)context;
+ (NSString *)getProjectNameFromContext:(NSDictionary *)context;
+ (NSString *)getFileNameFromContext:(NSDictionary *)context;
+ (NSArray *)getFileNamesFromContext:(NSDictionary *)context;
+ (NSString *)getSourceNameFromContext:(NSDictionary *)context;
+ (unsigned int)getLineFromContext:(NSDictionary *)context;
+ (unsigned int)getColumnFromContext:(NSDictionary *)context;
+ (BOOL)getDontOrderFrontFromContext:(NSDictionary *)context;
+ (void)actionWithName:(NSString *)name performedWithContext:(NSDictionary *)context;
@end

@implementation iTM2MainInstaller(ServerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ServerKitCompleteInstallation
+ (void)iTM2ServerKitCompleteInstallation;
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
+ (void)completeServerInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(performProjectActionWithContextNotified:)
            name: iTM2ServerPerformProjectActionWithContextNotification
                object: nil
                    suspensionBehavior: NSNotificationSuspensionBehaviorDeliverImmediately];
	#warning THIS SHOULD ONLY OCCUR WITH USER DEFAULT SETTINGS
    [[iTM2SystemSignalNotificationCenter defaultCenter] addObserver: self
        selector: @selector(sytemSignalSIGUSR1Notified:)
            name: iTM2SystemSignalSIGUSR1Notification
                object: nil];
    NSTask * T = [[[NSTask allocWithZone:[self zone]] init] autorelease];
	NSString * auxiliaryServerSetupPath = @"bin/iTeXMac2 Server Setup";
    NSString * path = [[self classBundle] pathForAuxiliaryExecutable:auxiliaryServerSetupPath];
	NSAssert1([path length], @"***  ERROR: Missing \"%@\"", auxiliaryServerSetupPath);
    if([path length])
    {
		NSMutableDictionary * environment = [[[[NSProcessInfo processInfo] environment] mutableCopy] autorelease];
		NSString * P;
		NSString * k;
		P = [[self classBundle] pathForAuxiliaryExecutable:@"bin/iTeXMac2 Server"];
		k = @"iTM2_SERVER_PATH";
		if([P length])
			[environment setObject:P forKey:k];
		else
		{
			iTM2_LOG(@"ERROR: things won't certainly work as expected... no server available");
		}
		P = [[NSBundle mainBundle] bundlePath];
		k = @"iTM2_APPLICATION_BUNDLE_PATH";
		if([P length])
			[environment setObject:P forKey:k];
		P = [P lastPathComponent];
		k = @"iTM2_APPLICATION_BUNDLE_NAME";
		if([P length])
			[environment setObject:P forKey:k];
		P = iTeXMac2;//[[NSBundle mainBundle] bundleName];
		k = @"iTM2_APPLICATION_NAME";
		if([P length])
			[environment setObject:P forKey:k];
		k = @"iTM2DebugEnabled";
		[environment setObject:[NSString stringWithFormat:@"%i", iTM2DebugEnabled] forKey:k];
		P = NSHomeDirectory();
		k = @"iTM2_HOME";
		if([P length])
			[environment setObject:P forKey:k];
		P = [NSBundle temporaryDirectory];
		k = @"iTM2_TemporaryDirectory";
		if([P length])
			[environment setObject:P forKey:k];
		[T setEnvironment:environment];
        [T setLaunchPath:path];
		[T setStandardError:[NSPipe pipe]];
		[T setStandardOutput:[NSPipe pipe]];
		[T setStandardInput:[NSPipe pipe]];
		[DNC addObserver: self selector: @selector(setupTaskDidTerminateNotified:)
			name: NSTaskDidTerminateNotification object: T];
		[iTM2MileStone registerMileStone:@"iTeXMac2 Server is not properly setup" forKey:@"iTeXMac2 Server Setup"];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setupTaskDidTerminateNotified:
+ (void)setupTaskDidTerminateNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2MileStone putMileStoneForKey:@"iTeXMac2 Server Setup"];
	iTM2_LOG(@"Server Setup complete:");
	NSTask * T = [[notification object] autorelease];// the object was the task launched
	[DNC removeObserver:self name:[notification name] object:T];
	NSMutableString * MS = [NSMutableString stringWithString:@"Output:\n"];
	NSData * D;
	NSFileHandle * FH = [[T standardOutput] fileHandleForReading];
	while((D = [FH availableData]), [D length])
		[MS appendString:[[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease]];
	FH = [[T standardError] fileHandleForReading];
	if((D = [FH availableData]), [D length])
	{
		[MS appendString:@"Error:\n"];
		do
		{
			[MS appendString:[[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease]];
		}
		while((D = [FH availableData]), [D length]);
	}
	NSLog(MS);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sytemSignalSIGUSR1Notified:
+ (void)sytemSignalSIGUSR1Notified:(NSNotification *)notification;
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
    [[SDC documents] makeObjectsPerformSelector:@selector(revertToSaved:) withObject:nil];
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= acceptConversationWithID:
+ (BOOL)acceptConversationWithID:(id)conversationID;
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
+ (BOOL)acceptNotificationWithEnvironment:(id)environment;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([environment isKindOfClass:[NSDictionary class]])
	{
		NSString * temporaryDirectory = [environment objectForKey:@"iTM2_TemporaryDirectory"];
		if([temporaryDirectory isKindOfClass:[NSString class]])
		{
//iTM2_END;
			return [temporaryDirectory pathIsEqual:[NSBundle temporaryDirectory]] || ![temporaryDirectory length];
		}
//iTM2_END;
		return !temporaryDirectory;
	}
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= performProjectActionWithContextNotified:
+ (void)performProjectActionWithContextNotified:(NSNotification *)notification;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * context = [notification userInfo];
	[self performSelectorOnMainThread:@selector(doPerformProjectActionWithContext:) withObject:context waitUntilDone:NO];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getVerbFromContext:
+ (NSString *)getVerbFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerConversationIDKey])
		{
			argument = [E nextObject];
		}
		else if([argument isEqualToString:iTM2ServerConnectionIDKey])
		{
			argument = [E nextObject];
		}
		else
		{
//iTM2_END;
			return argument;
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doPerformProjectActionWithContext:
+ (void)doPerformProjectActionWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
iTM2_LOG(@"context is: %@", context);
	NSDictionary * environment = [context objectForKey:iTM2ServerEnvironmentKey];
	if(![self acceptConversationWithID:[environment objectForKey:iTM2ServerConversationIDKey]])
	{
//iTM2_END;
		return;
	}
	if(![self acceptNotificationWithEnvironment:environment])
	{
//iTM2_END;
		return;
	}
	NSString * verb = [self getVerbFromContext:context];
	NSString * S = [verb stringByAppendingString:@"PerformedWithContext:"];
	SEL cmd = NSSelectorFromString(S);
	if([self respondsToSelector:cmd])
	{
		[self performSelector:cmd withObject:context];
	}
	else
	{
		iTM2_LOG(@"ERROR: %@ verb is not recognized by iTeXMac2 server, missing a %@ method.", verb, S);
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  Getters
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getProjectNameFromContext:
+ (NSString *)getProjectNameFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerProjectKey])
		{
			argument = [E nextObject];// the project name is absolute
//iTM2_END;
			return argument;
		}
	}
	NSDictionary * environment = [context objectForKey:iTM2ServerEnvironmentKey];
	argument = [environment objectForKey:TWSShellEnvironmentProjectKey];
//iTM2_END;
    return argument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getFileNameFromContext:
+ (NSString *)getFileNameFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * environment = [context objectForKey:iTM2ServerEnvironmentKey];
	NSString * masterDirectory = [environment objectForKey:TWSShellEnvironmentMasterKey];
	masterDirectory = [masterDirectory stringByDeletingLastPathComponent];
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerFileKey])
		{
			argument = [E nextObject];
			argument = [NSString absolutePathWithPath:argument base:masterDirectory];
//iTM2_END;
			return argument;
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getFileNamesFromContext:
+ (NSArray *)getFileNamesFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * environment = [context objectForKey:iTM2ServerEnvironmentKey];
	NSString * masterDirectory = [environment objectForKey:TWSShellEnvironmentMasterKey];
	masterDirectory = [masterDirectory stringByDeletingLastPathComponent];
	NSMutableArray * RA = [NSMutableArray array];
	NSString * argument = [self getFileNameFromContext:context];
	if([argument length])
	{
		[RA addObject:argument];
	}
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerFilesKey])
		{
			while(argument = [E nextObject])
			{
				if([argument hasPrefix:@"-"])
				{
//iTM2_END;
					return RA;
				}
				else
				{
					argument = [E nextObject];
					argument = [NSString absolutePathWithPath:argument base:masterDirectory];
					[RA addObject:argument];
				}
			}
		}
	}
//iTM2_END;
    return RA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getSourceNameFromContext:
+ (NSString *)getSourceNameFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * environment = [context objectForKey:iTM2ServerEnvironmentKey];
	NSString * masterDirectory = [environment objectForKey:TWSShellEnvironmentMasterKey];
	masterDirectory = [masterDirectory stringByDeletingLastPathComponent];
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerSourceKey])
		{
			argument = [E nextObject];
			argument = [NSString absolutePathWithPath:argument base:masterDirectory];
//iTM2_END;
			return argument;
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineFromContext:
+ (unsigned int)getLineFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerLineKey])
		{
			argument = [E nextObject];
//iTM2_END;
			return argument?[argument intValue]:NSNotFound;
		}
	}
//iTM2_END;
    return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getColumnFromContext:
+ (unsigned int)getColumnFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerColumnKey])
		{
			argument = [E nextObject];
//iTM2_END;
			return argument?[argument intValue]:NSNotFound;
		}
	}
//iTM2_END;
    return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getDontOrderFrontFromContext:
+ (BOOL)getDontOrderFrontFromContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	while(argument = [E nextObject])
	{
		if([argument isEqualToString:iTM2ServerDontOrderFrontKey])
		{
//iTM2_END;
			return YES;
		}
	}
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  typesetting responders
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= compilePerformedWithContext:
+ (void)compilePerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self actionWithName:@"Compile" performedWithContext:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= typesetPerformedWithContext:
+ (void)typesetPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self actionWithName:@"Typeset" performedWithContext:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bibliographyPerformedWithContext:
+ (void)bibliographyPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self actionWithName:@"Bibliography" performedWithContext:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexPerformedWithContext:
+ (void)indexPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self actionWithName:@"Index" performedWithContext:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= glossaryPerformedWithContext:
+ (void)glossaryPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self actionWithName:@"Glossary" performedWithContext:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= specialPerformedWithContext:
+ (void)specialPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self actionWithName:@"Special" performedWithContext:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cleanPerformedWithContext:
+ (void)cleanPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self actionWithName:@"Clean" performedWithContext:context];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= actionWithName:performedWithContext:
+ (void)actionWithName:(NSString *)name performedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * fileName = [self getFileNameFromContext:context];
	id PD = [SPC projectForFileName:fileName];
	if(!PD)
	{
		NSURL * url = nil;
		NSError * localError = nil;
		NSString * projectName = [self getProjectNameFromContext:context];
		PD = [SPC projectForFileName:projectName];
		if(!PD)
		{
			if([projectName length])
			{
				url = [NSURL fileURLWithPath:projectName];
				PD = [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
				[PD newKeyForFileName:fileName];
			}
			else
			{
				PD = [SPC newProjectForFileNameRef:&fileName display:YES error:nil];
			}
		}
	}
	if(PD)
	{
		id performer = [iTM2TeXPCommandManager commandPerformerForName:name];
		[performer performCommandForProject:PD];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  verb responders
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= applescriptPerformedWithContext:
+ (void)applescriptPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"arguments: %@", arguments);
#endif
	NSString * sourceName = [self getSourceNameFromContext:context];
    NSAppleScript * AS = [[[NSAppleScript allocWithZone:[self zone]] initWithSource:sourceName] autorelease];
    if(AS)
    {
        NSDictionary * errorInfo = nil;
        [AS executeAndReturnError: &errorInfo];
        if(errorInfo)
        {
            NSMutableString * MS = [NSMutableString stringWithString:@"\n! AppleScript execution error:\n"];
            NSString * message;
            if(message = [errorInfo objectForKey:NSAppleScriptErrorAppName])
                [MS appendFormat:@"! Application: %@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorMessage])
                [MS appendFormat:@"! Reason: %@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorNumber])
                [MS appendFormat:@"! Error number: %@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorBriefMessage])
                [MS appendFormat:@"! Brief reason: %@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorRange])
                [MS appendFormat:@"! Error range: %@\n", message];
            iTM2_LOG(MS);
        }
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPerformedWithContext:
+ (void)displayPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by main as server tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"arguments: %@", arguments);
#else
    NSString * fileName = [self getFileNameFromContext:context];
	NSURL * fileURL = [NSURL fileURLWithPath:fileName];
	id doc = [SDC documentForURL:fileURL];
	if(!doc)
	{
		iTM2ProjectDocument * PD = [SPC projectForFileName:fileName];
		NSError * localError = nil;
		if(!PD)
		{
			NSString * projectName = [self getProjectNameFromContext:context];
			if([projectName length])
			{
				PD = [SPC projectForFileName:projectName];
				if(!PD)
				{
					NSURL * url = [NSURL fileURLWithPath:projectName];
					PD = [SDC openDocumentWithContentsOfURL:url display:NO error:&localError];
					if(localError)
					{
						[SDC presentError:localError];
//iTM2_END;
						return;
					}
					[PD newKeyForFileName:fileName save:YES];
					[PD makeDefaultInspector];
					[PD showWindowsBelowFront:self];
				}
			}
		}
		doc = [SDC openDocumentWithContentsOfURL:fileURL display:YES error:nil];
	}
	BOOL dontOrderFront = [self getDontOrderFrontFromContext:context];
	unsigned int line = [self getLineFromContext:context];
	unsigned int column = [self getColumnFromContext:context];
    NSString * sourceName = [self getSourceNameFromContext:context];
	NSDictionary * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	[doc displayPageForLine:line column:column source:sourceName
					withHint:arguments orderFront:!dontOrderFront force:YES];// or NO? a SUD here?
	if(dontOrderFront)
	{
		[doc showWindowsBelowFront:self];
	}
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= editPerformedWithContext:
+ (void)editPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"context: %@", context);
#else
    NSString * fileName = [self getFileNameFromContext:context];
	if(![fileName length])
	{
		iTM2_REPORTERROR(1,@"Error in iTeXMac2 server invocation: the \"edit\" verb requires a \"-file foo\".",nil);
	}
	NSURL * url = [NSURL fileURLWithPath:fileName];
	NSError * localError = nil;
	unsigned int line = [self getLineFromContext:context];
	unsigned int column = [self getColumnFromContext:context];
	BOOL dontOrderFront = [self getDontOrderFrontFromContext:context];
	id doc = [SDC documentForURL:url];
	if(doc)
	{
		[doc updateIfNeeded];
	}
	else
	{
		NSString * projectName = [self getProjectNameFromContext:context];
		if([projectName length])
		{
			url = [NSURL fileURLWithPath:projectName];
			id projectDocument = [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
			if(localError)
			{
				[SDC presentError:localError];
//iTM2_END;
				return;
			}
			[projectDocument newKeyForFileName:fileName save:YES];
		}
		doc = [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
		if(localError)
		{
			[SDC presentError:localError];
//iTM2_END;
			return;
		}
	}
	[doc displayLine:line column:column length:-1 withHint:nil orderFront:!dontOrderFront];
	if(dontOrderFront)
	{
		[doc showWindowsBelowFront:self];
	}
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= helpPerformedWithContext:
+ (void)helpPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"context: %@", context);
#else
    iTM2_LOG(@"context: %@", context);
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertPerformedWithContext:
+ (void)insertPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"context: %@", context);
#else
    iTM2_LOG(@"context: %@", context);
	
#warning NYI: -all not supported
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= markerrorPerformedWithContext:
+ (void)markerrorPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"arguments: %@", arguments);
#else
#warning NYI
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= notifyPerformedWithContext:
+ (void)notifyPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List: None
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * projectName = [self getProjectNameFromContext:context];
	iTM2TeXProjectDocument * PD = [SPC projectForFileName:projectName];
	if(!PD)
	{
//iTM2_END;
		return;
	}
	NSArray * arguments = [context objectForKey:iTM2ServerArgumentsKey];
	NSEnumerator * E = [arguments objectEnumerator];
    NSString * argument = [E nextObject];// ignore $0
	argument = [E nextObject];// ignore "notify"
	argument = [E nextObject];// next verb
	if([argument isEqualToString:@"start"])
	{
		if([argument isEqualToString:@"comment"] || [argument isEqualToString:@"warning"] || [argument isEqualToString:@"error"] || [argument isEqualToString:@"applescript"])
		{
			argument = [NSString stringWithFormat:@"<%@>",argument];
		}
		else
		{
//iTM2_END;
			return;
		}
	}
	else if([argument isEqualToString:@"stop"])
	{
		if([argument isEqualToString:@"comment"] || [argument isEqualToString:@"warning"] || [argument isEqualToString:@"error"] || [argument isEqualToString:@"applescript"])
		{
			argument = [NSString stringWithFormat:@"</%@>\n",argument];
		}
		else
		{
//iTM2_END;
			return;
		}
	}
	else if([argument isEqualToString:@"echo"])
	{
		argument = [NSString stringWithFormat:@"%@\n",[E nextObject]];
	}
	else if([argument isEqualToString:@"comment"] || [argument isEqualToString:@"warning"] || [argument isEqualToString:@"error"] || [argument isEqualToString:@"applescript"])
	{
		argument = [NSString stringWithFormat:@"<%@>%@</%@>\n",argument,[E nextObject],argument];
	}
	else
	{
//iTM2_END;
		return;
	}
	iTM2TaskController * TC = [PD taskController];
	[TC logCustom:argument];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= openPerformedWithContext:
+ (void)openPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the former "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"context: %@", context);
#else
    NSString * projectName = [self getProjectNameFromContext:context];
    NSString * fileName = [self getFileNameFromContext:context];
	NSURL * url = nil;
	NSError * localError = nil;
	if([projectName length])
	{
		url = [NSURL fileURLWithPath:projectName];
		id projectDocument = [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
		if(localError)
		{
			[SDC presentError:localError];
//iTM2_END;
			return;
		}
		if([fileName length])
		{
			[projectDocument newKeyForFileName:fileName save:YES];
			url = [NSURL fileURLWithPath:fileName];
			[SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
			if(localError)
			{
				[SDC presentError:localError];
//iTM2_END;
				return;
			}
//iTM2_END;
			return;
		}
	}
	else
	{
		url = [NSURL fileURLWithPath:fileName];
		[SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
		if(localError)
		{
			[SDC presentError:localError];
//iTM2_END;
			return;
		}
	}
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updatePerformedWithContext:
+ (void)updatePerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_Server_Test__
    iTM2_LOG(@"arguments: %@", arguments);
#else
    NSString * projectName = [self getProjectNameFromContext:context];
    NSArray * fileNames = [self getFileNamesFromContext:context];
	NSError * localError = nil;
	NSString * fileName;
	NSEnumerator * E = [fileNames objectEnumerator];
	if([self getDontOrderFrontFromContext:context])
	{
		// just register the document for the project
		// update the contents if the document is on screen
		while(fileName = [E nextObject])
		{
			NSURL * url = [NSURL fileURLWithPath:fileName];
			NSDocument * document = [SDC documentForURL:url];
			if(document)
			{
				[document updateIfNeeded];
			}
			else
			{
				iTM2ProjectDocument * PD = [SPC projectForFileName:fileName];
				if(!PD)
				{
					PD = [SPC projectForFileName:projectName];
					if(!PD)
					{
						NSURL * url = [NSURL fileURLWithPath:projectName];
						PD = [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
						if(localError)
						{
							[SDC presentError:localError];
//iTM2_END;
							return;
						}
					}
					[PD newKeyForFileName:fileName];
				}
			}
		}
//iTM2_END;
		return;
	}
	while(fileName = [E nextObject])
	{
		NSURL * url = [NSURL fileURLWithPath:fileName];
		NSDocument * document = [SDC documentForURL:url];
		if(document)
		{
			[document updateIfNeeded];
			[document showWindowsBelowFront:self];
		}
		else
		{
			iTM2ProjectDocument * PD = [SPC projectForFileName:fileName];
			if(!PD)
			{
				PD = [SPC projectForFileName:projectName];
				if(!PD)
				{
					NSURL * url = [NSURL fileURLWithPath:projectName];
					PD = [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
					if(localError)
					{
						[SDC presentError:localError];
//iTM2_END;
						return;
					}
				}
				[PD newKeyForFileName:fileName];
			}
			document = [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
			if(localError)
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Could not update document at:\n%@", fileName]),(localError));
			}
			document = [SDC documentForURL:url];
		}
	}
#warning NYI: -all not supported
#endif
//iTM2_END;
    return;
}
@end

@implementation iTM2ConnectionRoot(iTM2ServerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performProjectActionWithContext:
- (oneway void)performProjectActionWithContext:(id)context;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2ServerKit performSelectorOnMainThread:@selector(doPerformProjectActionWithContext:) withObject:context waitUntilDone:NO];
	return;
//iTM2_END;
}
@end

@interface iTM2URLHandlerCommand: NSScriptCommand
@end
@implementation iTM2URLHandlerCommand
- (id)performDefaultImplementation
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString *urlString = [self directParameter];
    NSLog(@"url = %@", urlString);
//iTM2_END;
    return nil;
}
@end
