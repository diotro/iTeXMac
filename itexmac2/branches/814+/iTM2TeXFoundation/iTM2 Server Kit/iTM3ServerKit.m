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

#import "iTM3ServerKit.h"
#import <iTM2TeXFoundation/iTM3ServerKeys.h>
#import <iTM2TeXFoundation/iTM2TeXProjectCommandKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectTaskKit.h>

NSString * const iTM3ServerAllKey = @"-all";
NSString * const iTM3ServerFileKey = @"-file";
NSString * const iTM3ServerFilesKey = @"-files";
NSString * const iTM3ServerColumnKey = @"-column";
NSString * const iTM3ServerLineKey = @"-line";
NSString * const iTM3ServerSourceKey = @"-source";
NSString * const iTM3ServerProjectKey = @"-project";
NSString * const iTM3ServerActionKey = @"-action";
NSString * const iTM3ServerMasterKey = @"-master";
NSString * const iTM3ServerEngineKey = @"-engine";
NSString * const iTM3ServerDontOrderFrontKey = @"-dont-order-front";
NSString * const iTM3ServerReasonKey = @"-reason";
NSString * const iTM3ServerIdlingKey = @"-idling";

NSString * const iTM2ProcessInfoEnvironmentKey = @"iTM2ProcessInfoEnvironment";

NSString * const iTM3ServerComwarnerNotification = @"iTM3ServerComwarner";
NSString * const iTM3ServerConversationIDKey = @"ConversationID";
NSString * const iTM3ServerCommentsKey = @"Comments";
NSString * const iTM3ServerWarningsKey = @"Warnings";
NSString * const iTM3ServerErrorsKey = @"Errors";

NSString * const iTM3ServerAppleScriptNotification = @"iTM3ServerAppleScript";

NSString * const iTM3ServerShouldInsertTextNotification = @"iTM3ServerShouldInsertTextNotification";

NSString * const iTM3ServerConversationIdentifierKey = @"conversation";
NSString * const iTM3ServerScriptFileNameKey = @"script_file_name";
NSString * const iTM3ServerInputTextKey = @"input_text";
NSString * const iTM3ServerInputSelectedLocationKey = @"input_selected_location";
NSString * const iTM3ServerInputSelectedLengthKey = @"input_selected_length";
NSString * const iTM3ServerOutputTextKey = @"output_text";
NSString * const iTM3ServerOutputSelectedLocationKey = @"output_selected_location";
NSString * const iTM3ServerOutputSelectedLengthKey = @"output_selected_length";
NSString * const iTM3ServerOutputInsertionLocationKey = @"output_insertion_location";
NSString * const iTM3ServerOutputInsertionLengthKey = @"output_insertion_length";

#import <iTM2Foundation/iTM2BundleKit.h>

//#import <iTM2Foundation/iTM2SystemSignalKit.h>
//#import <iTM2Foundation/iTM2DocumentControllerKit.h>
//#import <iTM2Foundation/iTM2InstallationKit.h>
//#import <iTM2Foundation/iTM2Implementation.h>

@interface iTM3ServerKit(PRIVATE)
+ (void)completeServerInstallation;
+ (NSString *)getVerbFromContext:(NSDictionary *)context;
+ (NSString *)getProjectNameFromContext:(NSDictionary *)context;
+ (NSString *)getFileNameFromContext:(NSDictionary *)context;
+ (NSArray *)getFileNamesFromContext:(NSDictionary *)context;
+ (NSString *)getSourceNameFromContext:(NSDictionary *)context;
+ (NSUInteger)getLineFromContext:(NSDictionary *)context;
+ (NSUInteger)getColumnFromContext:(NSDictionary *)context;
+ (BOOL)getDontOrderFrontFromContext:(NSDictionary *)context;
+ (NSString *)getReasonFromContext:(NSDictionary *)context;
+ (BOOL)getIdlingFromContext:(NSDictionary *)context;
+ (void)actionWithName:(NSString *)name performedWithContext:(NSDictionary *)context;
@end

@implementation iTM2MainInstaller(ServerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM3ServerKitCompleteInstallation4iTM3
+ (void)iTM3ServerKitCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM3ServerKit completeServerInstallation];
//END4iTM3;
	return;
}
@end

#warning ATTENTION COCO
NSString * const iTM3ServerSetupRelativePath = @"bin/iTeXMac2 Server Setup";
NSString * const iTM3ServerRelativePath = @"bin/iTeXMac2 Server";
NSString * const iTM3ServerPathKey = @"SERVER_PATH_4iTM3";
NSString * const iTM3ServerBundlePathKey = @"BUNDLE_PATH_4iTM3";
NSString * const iTM3ServerBundleNameKey = @"BUNDLE_NAME_4iTM3";
NSString * const iTM3ServerDebugEnabledKey = @"DEBUG_ENABLED_4iTM3";
NSString * const iTM3ServerHomeKey = @"HOME_4iTM3";
NSString * const iTM3ServerTemporaryDirectoryKey = @"TEMPORARY_DIRECTORY_4iTM3";


@implementation iTM3ServerKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= completeServerInstallation
+ (void)completeServerInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
        selector: @selector(performProjectActionWithContextNotified:)
            name: iTM3ServerPerformProjectActionWithContextNotification
                object: nil
                    suspensionBehavior:NSNotificationSuspensionBehaviorDeliverImmediately];
#warning THIS SHOULD ONLY OCCUR WITH USER DEFAULT SETTINGS
    [[iTM2SystemSignalNotificationCenter defaultCenter] addObserver: self
        selector: @selector(sytemSignalSIGUSR1Notified:)
            name: iTM2SystemSignalSIGUSR1Notification
                object: nil];
    NSTask * T = [[[NSTask alloc] init] autorelease];
	NSURL * auxiliaryServerSetupURL = [myBUNDLE URLForAuxiliaryExecutable:iTM3ServerSetupRelativePath];
	NSAssert1(auxiliaryServerSetupURL, @"***  ERROR: Missing \"%@\"", iTM3ServerSetupRelativePath);
    NSMutableDictionary * environment = [[[[NSProcessInfo processInfo] environment] mutableCopy] autorelease];
    NSURL * serverURL = [myBUNDLE URLForAuxiliaryExecutable:iTM3ServerRelativePath];
    if (serverURL.isFileURL) {
        [environment setObject:serverURL.path forKey:iTM3ServerPathKey];
    } else {
        LOG4iTM3(@"ERROR: things won't certainly work as expected... no server available");
    }
    NSBundle * MB = NSBundle.mainBundle;
    [environment setObject:MB.bundlePath forKey:iTM3ServerBundlePathKey];
    [environment setObject:MB.bundlePath.lastPathComponent.stringByDeletingPathExtension forKey:iTM3ServerBundleNameKey];
    [environment setObject:[NSString stringWithFormat:@"%li", iTM2DebugEnabled] forKey:iTM3ServerDebugEnabledKey];
    [environment setObject:NSHomeDirectory() forKey:iTM3ServerHomeKey];
    [environment setObject:MB.temporaryDirectoryURL4iTM3.path forKey:iTM3ServerTemporaryDirectoryKey];
    [T setEnvironment:environment];
    [T setLaunchPath:auxiliaryServerSetupURL.path];
    [T setStandardError:[NSPipe pipe]];
    [T setStandardOutput:[NSPipe pipe]];
    [T setStandardInput:[NSPipe pipe]];
    [DNC addObserver: self selector: @selector(setupTaskDidTerminateNotified:)
        name: NSTaskDidTerminateNotification object: T];
    [iTM2MileStone registerMileStone:@"iTeXMac2 Server is not properly setup" forKey:iTM3ServerSetupRelativePath];
    [[T retain] launch];// it will be reseased when termination is notified
	RELEASE_POOL4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setupTaskDidTerminateNotified:
+ (void)setupTaskDidTerminateNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Mar 29 06:40:59 UTC 2010
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM2MileStone putMileStoneForKey:iTM3ServerSetupRelativePath];
	NSTask * T = [notification.object autorelease];// the object was the task launched
	LOG4iTM3(@"The Server Setup task did terminate with status %i and termination %li:",
        T.terminationStatus, T.terminationReason);
	[DNC removeObserver:self name:notification.name object:T];
	NSMutableString * MS = [NSMutableString stringWithString:@"Output:\n"];
	NSData * D;
	NSFileHandle * FH = [T.standardOutput fileHandleForReading];
	while ((D = FH.availableData), D.length)
		[MS appendString:[[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease]];
	FH = [T.standardError fileHandleForReading];
	if ((D = FH.availableData), D.length) {
		[MS appendString:@"Error:\n"];
		do {
			[MS appendString:[[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease]];
		} while ((D = FH.availableData), D.length);
	}
	LOG4iTM3(@"Resulting log:\n%@",MS);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sytemSignalSIGUSR1Notified:
+ (void)sytemSignalSIGUSR1Notified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"name: %@", [notification name]);
#else
    DEBUGLOG4iTM3(1000,@"name: %@", [notification name]);
    [[SDC documents] makeObjectsPerformSelector:@selector(revertToSaved:) withObject:nil];
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= acceptConversationWithID:
+ (BOOL)acceptConversationWithID:(id)conversationID;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= acceptNotificationWithEnvironment:
+ (BOOL)acceptNotificationWithEnvironment:(id)environment;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([environment isKindOfClass:[NSDictionary class]]) {
		NSString * temporaryDirectory4iTM3 = [environment objectForKey:iTM3ServerTemporaryDirectoryKey];
		if ([temporaryDirectory4iTM3 isKindOfClass:[NSString class]]) {
//END4iTM3;
			return [temporaryDirectory4iTM3 pathIsEqual4iTM3:NSBundle.mainBundle.temporaryDirectoryURL4iTM3.path] || !temporaryDirectory4iTM3.length;
		}
//END4iTM3;
		return !temporaryDirectory4iTM3;
	}
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= performProjectActionWithContextNotified:
+ (void)performProjectActionWithContextNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * context = [notification userInfo];
	[self performSelectorOnMainThread:@selector(doPerformProjectActionWithContext:) withObject:context waitUntilDone:NO];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getVerbFromContext:
+ (NSString *)getVerbFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Mar 29 07:06:48 UTC 2010
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while ((argument = E.nextObject)) {
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerConversationIDKey]) {
			argument = E.nextObject;
		} else if([argument isEqual:iTM3ServerConnectionIDKey]) {
			argument = E.nextObject;
		} else {
//END4iTM3;
			return argument;
		}
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doPerformProjectActionWithContext:
+ (void)doPerformProjectActionWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"context is: %@", context);
	NSDictionary * environment = [context objectForKey:iTM3ServerEnvironmentKey];
	NSString * ID = [environment objectForKey:iTM3ServerConversationIDKey];
	if(![self acceptConversationWithID:ID]) {
//END4iTM3;
		return;
	}
	if(![self acceptNotificationWithEnvironment:environment]) {
//END4iTM3;
		return;
	}
	NSString * verb = [self getVerbFromContext:context];
	NSString * S = [verb stringByAppendingString:@"PerformedWithContext:"];
	SEL cmd = NSSelectorFromString(S);
	if([self respondsToSelector:cmd]) {
		[self performSelector:cmd withObject:context];
	} else {
		LOG4iTM3(@"ERROR: %@ verb is not recognized by iTeXMac2 server, missing a %@ method.", verb, S);
	}
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  Getters
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getProjectNameFromContext:
+ (NSString *)getProjectNameFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerProjectKey])
		{
			argument = E.nextObject;// the project name is absolute
//END4iTM3;
			return argument;
		}
	}
	NSDictionary * environment = [context objectForKey:iTM3ServerEnvironmentKey];
	argument = [environment objectForKey:TWSShellEnvironmentProjectKey];
//END4iTM3;
    return argument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getFileNameFromContext:
+ (NSString *)getFileNameFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 12:17:10 UTC 2010
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * projectName  = [self getProjectNameFromContext:context];
	NSURL * sourceURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[NSURL fileURLWithPath:projectName] error:NULL];
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while (argument = E.nextObject) {
		argument = argument.lowercaseString;
		if ([argument isEqual:iTM3ServerFileKey]) {
			argument = E.nextObject;
			argument = [[NSURL URLWithPath4iTM3:argument relativeToURL:sourceURL] path];
//END4iTM3;
			return argument;
		}
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getFileNamesFromContext:
+ (NSArray *)getFileNamesFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 12:17:16 UTC 2010
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * projectName  = [self getProjectNameFromContext:context];
	NSURL * sourceURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[NSURL fileURLWithPath:projectName] error:NULL];
	NSMutableArray * RA = [NSMutableArray array];
	NSString * argument = [self getFileNameFromContext:context];
	if (argument.length) {
		[RA addObject:argument];
	}
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    argument = E.nextObject;// ignore $0
	while (argument = E.nextObject) {
		argument = argument.lowercaseString;
		if ([argument isEqual:iTM3ServerFilesKey]) {
			while (argument = E.nextObject) {
				if([argument hasPrefix:@"-"]) {
//END4iTM3;
					return RA;
				} else {
					argument = E.nextObject;
					argument = [[NSURL URLWithPath4iTM3:argument relativeToURL:sourceURL] path];
					[RA addObject:argument];
				}
			}
		}
	}
//END4iTM3;
    return RA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getSourceNameFromContext:
+ (NSString *)getSourceNameFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 12:17:22 UTC 2010
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * projectName  = [self getProjectNameFromContext:context];
    NSURL * sourceURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[NSURL fileURLWithPath:projectName] error:NULL];
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while (argument = E.nextObject) {
		argument = [argument lowercaseString];
		if ([argument isEqual:iTM3ServerSourceKey]) {
			argument = E.nextObject;
			argument = [[NSURL URLWithPath4iTM3:argument relativeToURL:sourceURL] path];
//END4iTM3;
			return argument;
		}
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineFromContext:
+ (NSUInteger)getLineFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerLineKey])
		{
			argument = E.nextObject;
//END4iTM3;
			return argument>ZER0?[argument integerValue]-1:NSNotFound;
		}
	}
//END4iTM3;
    return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getColumnFromContext:
+ (NSUInteger)getColumnFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerColumnKey])
		{
			argument = E.nextObject;
//END4iTM3;
			return argument>ZER0?[argument integerValue]-1:NSNotFound;
		}
	}
//END4iTM3;
    return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getDontOrderFrontFromContext:
+ (BOOL)getDontOrderFrontFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerDontOrderFrontKey])
		{
//END4iTM3;
			return YES;
		}
	}
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getReasonFromContext:
+ (NSString *)getReasonFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerReasonKey])
		{
			argument = E.nextObject;
//END4iTM3;
			return argument;
		}
	}
//END4iTM3;
    return @"Unknown";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getIdlingFromContext:
+ (BOOL)getIdlingFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerIdlingKey])
		{
			argument = E.nextObject;
			argument = [argument lowercaseString];
//END4iTM3;
			return ![argument isEqual:@"no"];
		}
	}
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getMasterNameFromContext:
+ (NSString *)getMasterNameFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerMasterKey])
		{
//END4iTM3;
			return E.nextObject;
		}
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getActionFromContext:
+ (NSString *)getActionFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerActionKey])
		{
//END4iTM3;
			return E.nextObject;
		}
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getEngineFromContext:
+ (NSString *)getEngineFromContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	while(argument = E.nextObject)
	{
		argument = [argument lowercaseString];
		if([argument isEqual:iTM3ServerEngineKey])
		{
//END4iTM3;
			return E.nextObject;
		}
	}
//END4iTM3;
    return nil;
}
#pragma mark =-=-=-=-=-  typesetting responders
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= compilePerformedWithContext:
+ (void)compilePerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self actionWithName:@"Compile" performedWithContext:context];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= typesetPerformedWithContext:
+ (void)typesetPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self actionWithName:@"Typeset" performedWithContext:context];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bibliographyPerformedWithContext:
+ (void)bibliographyPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self actionWithName:@"Bibliography" performedWithContext:context];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexPerformedWithContext:
+ (void)indexPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self actionWithName:@"Index" performedWithContext:context];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= glossaryPerformedWithContext:
+ (void)glossaryPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self actionWithName:@"Glossary" performedWithContext:context];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= specialPerformedWithContext:
+ (void)specialPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self actionWithName:@"Special" performedWithContext:context];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cleanPerformedWithContext:
+ (void)cleanPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self actionWithName:@"Clean" performedWithContext:context];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= actionWithName:performedWithContext:
+ (void)actionWithName:(NSString *)name performedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * fileName = [self getFileNameFromContext:context];
    NSError * ROR = nil;
	id PD = [SPC projectForSource:fileName error:&ROR];
	if(!PD)
	{
		NSString * projectName = [self getProjectNameFromContext:context];
		PD = [SPC projectForSource:projectName error:&ROR];
		if(!PD)
		{
			NSURL * url = nil;
			if(projectName.length)
			{
				url = [NSURL fileURLWithPath:projectName];
				PD = [SDC openDocumentWithContentsOfURL:url display:YES error:&ROR];
				[PD createNewFileKeyForURL:[NSURL fileURLWithPath:fileName] save:YES error:&ROR];
			}
			else
			{
				url = [NSURL fileURLWithPath:fileName];
				PD = [SPC freshProjectForURLRef:&url display:YES error:nil];
			}
		}
	}
	if(PD)
	{
		Class performer = [iTM2TeXPCommandManager commandPerformerForName:name];
		[performer performCommandForProject:PD];
	}
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"arguments: %@", arguments);
#endif
	NSString * sourceName = [self getSourceNameFromContext:context];
    NSAppleScript * AS = [[[NSAppleScript alloc] initWithSource:sourceName] autorelease];
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
            LOG4iTM3(@"%@",MS);
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPerformedWithContext:
+ (void)displayPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by main as server tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"arguments: %@", arguments);
#else
    NSError * ROR = nil;
    NSString * fileName = [self getFileNameFromContext:context];
	NSURL * fileURL = [NSURL fileURLWithPath:fileName];
	id doc = [SDC documentForURL:fileURL];
	if(!doc)
	{
		iTM2ProjectDocument * PD = [SPC projectForURL:fileURL error:&ROR];
		NSError * ROR = nil;
		if(!PD)
		{
			NSString * projectName = [self getProjectNameFromContext:context];
			if(projectName.length)
			{
				NSURL * projectURL = [NSURL fileURLWithPath:projectName];
				PD = [SPC projectForURL:projectURL error:&ROR];
				if(!PD)
				{
					PD = [SDC openDocumentWithContentsOfURL:projectURL display:NO error:&ROR];
					if(ROR)
					{
						[SDC presentError:ROR];
//END4iTM3;
						return;
					}
					[PD createNewFileKeyForURL:fileURL save:YES error:&ROR];
					[PD makeDefaultInspector];
					[PD showWindowsBelowFront:self];
				}
			}
		}
		doc = [SDC openDocumentWithContentsOfURL:fileURL display:YES error:&ROR];
	}
	BOOL dontOrderFront = [self getDontOrderFrontFromContext:context];
	NSUInteger line = [self getLineFromContext:context];
	NSUInteger column = [self getColumnFromContext:context];
    NSString * sourceName = [self getSourceNameFromContext:context];
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSDictionary * hints = [NSMutableDictionary dictionary];
	NSEnumerator * E = arguments.objectEnumerator;
	NSString * key = nil;
	NSString * value = nil;
nextKey:
	if(key = E.nextObject)
	{
		if([key hasPrefix:@"-"])
		{
nextValue:
			if(value = E.nextObject)
			{
				if([value hasPrefix:@"-"])
				{
					[hints setValue:@"YES" forKey:key];
					key = value;
					goto nextValue;
				}
				else
				{
					[hints setValue:value forKey:key];
					goto nextKey;
				}
			}
			else
			{
				[hints setValue:@"YES" forKey:key];
			}
		}
		else
		{
			goto nextKey;
		}
	}
	[doc displayPageForLine:line column:column source:[NSURL fileURLWithPath:sourceName]
					withHint:hints orderFront:!dontOrderFront force:YES];// or NO? a SUD here?
	if(dontOrderFront)
	{
		[doc showWindowsBelowFront:self];
	}
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= editPerformedWithContext:
+ (void)editPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"context: %@", context);
#else
    NSString * fileName = [self getFileNameFromContext:context];
	if(!fileName.length) {
		REPORTERRORINMAINTHREAD4iTM3 (1,@"Error in iTeXMac2 server invocation: the \"edit\" verb requires a \"-file foo\".",nil);
	}
	NSURL * fileURL = [NSURL fileURLWithPath:fileName];
	NSUInteger line = [self getLineFromContext:context];
	NSUInteger column = [self getColumnFromContext:context];
	BOOL dontOrderFront = [self getDontOrderFrontFromContext:context];
	id doc = [SDC documentForURL:fileURL];
    NSError * ROR = nil;
	if(doc) {
		[doc updateIfNeeded4iTM3Error:&ROR];
        REPORTERRORINMAINTHREAD4iTM3(1,@"",ROR);
	} else {
		NSString * projectName = [self getProjectNameFromContext:context];
		if(projectName.length)
		{
			NSURL * projectURL = [NSURL fileURLWithPath:projectName];
			id projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:YES error:&ROR];
            REPORTERRORINMAINTHREAD4iTM3(2,@"",ROR);
			[projectDocument createNewFileKeyForURL:fileURL save:YES error:&ROR];
            REPORTERRORINMAINTHREAD4iTM3(3,@"",ROR);
		}
		doc = [SDC openDocumentWithContentsOfURL:fileURL display:YES error:&ROR];
        REPORTERRORINMAINTHREAD4iTM3(4,@"",ROR);
	}
	[doc displayLine:(line?--line:line) column:(column?--column:column) length:-1 withHint:nil orderFront:!dontOrderFront];
	if (dontOrderFront) {
		[doc showWindowsBelowFront:self];
	}
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= errorPerformedWithContext:
+ (void)errorPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"context: %@", context);
#else
    NSString * reason = [self getReasonFromContext:context];
	REPORTERRORINMAINTHREAD4iTM3(1,reason,nil);
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= helpPerformedWithContext:
+ (void)helpPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"context: %@", context);
#else
    LOG4iTM3(@"context: %@", context);
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= insertPerformedWithContext:
+ (void)insertPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"context: %@", context);
#else
    LOG4iTM3(@"context: %@", context);
	
#warning NYI: -all not supported
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= markerrorPerformedWithContext:
+ (void)markerrorPerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"arguments: %@", arguments);
#else
#warning NYI
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= notifyPerformedWithContext:
+ (void)notifyPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List: None
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * projectName = [self getProjectNameFromContext:context];
    NSError * ROR = nil;
	iTM2TeXProjectDocument * PD = [SPC projectForSource:projectName error:&ROR];
	if (!PD) {
//END4iTM3;
        REPORTERRORINMAINTHREAD4iTM3(1,@"",ROR);
        return;
	}
	NSArray * arguments = [context objectForKey:iTM3ServerArgumentsKey];
	NSEnumerator * E = arguments.objectEnumerator;
    NSString * argument = E.nextObject;// ignore $0
	argument = E.nextObject;// ignore "notify"
	argument = E.nextObject;// next verb
	argument = [argument lowercaseString];
	if([argument isEqual:@"start"])
	{
		argument = E.nextObject;// next verb
		argument = [argument lowercaseString];
		if([argument isEqual:@"comment"] || [argument isEqual:@"warning"] || [argument isEqual:@"error"] || [argument isEqual:@"applescript"])
		{
			argument = [NSString stringWithFormat:@"<%@>",argument];
		}
		else
		{
//END4iTM3;
			return;
		}
	}
	else if([argument isEqual:@"stop"])
	{
		argument = E.nextObject;// next verb
		argument = [argument lowercaseString];
		if([argument isEqual:@"comment"] || [argument isEqual:@"warning"] || [argument isEqual:@"error"] || [argument isEqual:@"applescript"])
		{
			argument = [NSString stringWithFormat:@"</%@>\n",argument];
		}
		else
		{
//END4iTM3;
			return;
		}
	}
	else if([argument isEqual:@"echo"])
	{
		argument = [NSString stringWithFormat:@"%@\n",E.nextObject];
	}
	else if([argument isEqual:@"comment"] || [argument isEqual:@"warning"] || [argument isEqual:@"error"] || [argument isEqual:@"applescript"])
	{
		argument = [NSString stringWithFormat:@"<%@>%@</%@>\n",argument,E.nextObject,argument];
	}
	else
	{
//END4iTM3;
		return;
	}
	iTM2TaskController * TC = [PD taskController];
	[TC logCustom:argument];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= openPerformedWithContext:
+ (void)openPerformedWithContext:(NSDictionary *)context;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-05 18:36:57 +0100
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"context: %@", context);
#else
    NSString * projectName = [self getProjectNameFromContext:context];
    NSString * fileName = [self getFileNameFromContext:context];
	NSURL * fileURL = nil;
    NSError * ROR = nil;
	if (projectName.length) {
		NSURL * projectURL = [NSURL fileURLWithPath:projectName];
		id projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:YES error:&ROR];
		if (fileName.length) {
			fileURL = [NSURL fileURLWithPath:fileName];
			[projectDocument createNewFileKeyForURL:fileURL save:YES error:&ROR];
			[SDC openDocumentWithContentsOfURL:fileURL display:YES error:&ROR];
            REPORTERRORINMAINTHREAD4iTM3(1,@"",ROR);
			return;
		}
	} else if (fileName.length) {
		fileURL = [NSURL fileURLWithPath:fileName];
		[SDC openDocumentWithContentsOfURL:fileURL display:YES error:&ROR];
	}
#endif
    REPORTERRORINMAINTHREAD4iTM3(2,@"",ROR);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updatePerformedWithContext:
+ (void)updatePerformedWithContext:(NSDictionary *)context;
/*"This is the answer to the notification sent by the "iTeXMac2_Update" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"arguments: %@", arguments);
#else
    NSString * projectName = [self getProjectNameFromContext:context];
    NSArray * fileNames = [self getFileNamesFromContext:context];
	NSString * fileName = nil;
	NSURL * fileURL = nil;
	NSURL * projectURL = nil;
	NSDocument * document = nil;
	iTM2ProjectDocument * PD = nil;
    NSError * ROR = nil;
	if([self getDontOrderFrontFromContext:context]) {
		// just register the document for the project,
		// update the contents if the document is on screen
		for (fileName in fileNames) {
			fileURL = [NSURL fileURLWithPath:fileName];
			if(document = [SDC documentForURL:fileURL]) {
				[document updateIfNeeded4iTM3Error:&ROR];
                REPORTERRORINMAINTHREAD4iTM3(1,@"",ROR);
			} else if(!(PD = [SPC projectForURL:fileURL error:&ROR])) {
                REPORTERRORINMAINTHREAD4iTM3(2,@"",ROR);
				projectURL = [NSURL fileURLWithPath:projectName];
				if(!(PD = [SPC projectForURL:projectURL error:&ROR])) {
                    REPORTERRORINMAINTHREAD4iTM3(3,@"",ROR);
					PD = [SDC openDocumentWithContentsOfURL:projectURL display:YES error:&ROR];
					REPORTERRORINMAINTHREAD4iTM3(4,@"",ROR);
                }
				[PD createNewFileKeyForURL:fileURL save:YES error:&ROR];
                REPORTERRORINMAINTHREAD4iTM3(5,@"",ROR);
			}
		}
//END4iTM3;
		return;
	}
	for (fileName in fileNames) {
		fileURL = [NSURL fileURLWithPath:fileName];
		if(document = [SDC documentForURL:fileURL]) {
			[document updateIfNeeded4iTM3Error:&ROR];
            REPORTERRORINMAINTHREAD4iTM3(6,@"",ROR);
			[document showWindowsBelowFront:self];
		} else {
			if(!(PD = [SPC projectForURL:fileURL error:&ROR])) {
				projectURL = [NSURL fileURLWithPath:projectName];
				if(!(PD = [SPC projectForURL:projectURL error:&ROR])) {
					PD = [SDC openDocumentWithContentsOfURL:projectURL display:YES error:&ROR];
                    REPORTERRORINMAINTHREAD4iTM3(7,@"",ROR);
				}
				[PD createNewFileKeyForURL:fileURL save:YES error:&ROR];
                REPORTERRORINMAINTHREAD4iTM3(8,@"",ROR);
			}
			document = [SDC openDocumentWithContentsOfURL:fileURL display:YES error:&ROR];
            REPORTERRORINMAINTHREAD4iTM3(9,@"",ROR);
			//document = [SDC documentForURL:url];
		}
	}
#warning NYI: -all not supported
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= touchPerformedWithContext:
+ (void)touchPerformedWithContext:(NSDictionary *)context;
/*"This is like updatePerformedWithContext above, except that it does not add the file to the project.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"arguments: %@", arguments);
#else
    NSString * projectName = [self getProjectNameFromContext:context];
    NSArray * fileNames = [self getFileNamesFromContext:context];
	NSError * ROR = nil;
	NSString * fileName = nil;
	NSURL * fileURL = nil;
	NSDocument * document = nil;
	iTM2ProjectDocument * PD = nil;
	if ([self getDontOrderFrontFromContext:context]) {
		// just register the document for the project,
		// update the contents if the document is on screen
		for (fileName in fileNames) {
			fileURL = [NSURL fileURLWithPath:fileName];
			if ((document = [SDC documentForURL:fileURL])) {
				[document updateIfNeeded4iTM3Error:&ROR];
                REPORTERRORINMAINTHREAD4iTM3(1,@"",ROR);
			}
		}
//END4iTM3;
		return;
	}
	for (fileName in fileNames) {
		fileURL = [NSURL fileURLWithPath:fileName];
		if(document = [SDC documentForURL:fileURL]) {
			[document updateIfNeeded4iTM3Error:&ROR];
            REPORTERRORINMAINTHREAD4iTM3(2,@"",ROR);
			[document showWindowsBelowFront:self];
		} else {
			if(!(PD = [SPC projectForURL:fileURL error:&ROR])) {
                REPORTERRORINMAINTHREAD4iTM3(3,@"",ROR);
				NSURL * projectURL = [NSURL fileURLWithPath:projectName];
				if(!(PD = [SPC projectForURL:projectURL error:&ROR])) {
                    REPORTERRORINMAINTHREAD4iTM3(4,@"",ROR);
					PD = [SDC openDocumentWithContentsOfURL:projectURL display:YES error:&ROR];
                    REPORTERRORINMAINTHREAD4iTM3(5,@"",ROR);
				}
			}
			if ((document == [PD subdocumentForURL:fileURL error:&ROR])) {
                [document updateIfNeeded4iTM3Error:&ROR];
                REPORTERRORINMAINTHREAD4iTM3(6,@"",ROR);
            }
		}
	}
#warning NYI: -all not supported
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= buildPerformedWithContext:
+ (void)buildPerformedWithContext:(NSDictionary *)context;
/*"This is like updatePerformedWithContext above, except that it does not add the file to the project.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_Server_Test__
    LOG4iTM3(@"arguments: %@", arguments);
#else
    NSString * projectName = [self getProjectNameFromContext:context];
	NSString * masterName = [self getMasterNameFromContext:context];
	NSString * engine = [self getEngineFromContext:context];
	NSString * action = [self getActionFromContext:context];
#warning FAILED UNSTABLE manage the missing arguments here.
	[iTM2TeXPCommandPerformer launchAction:action withEngine:engine forMaster:masterName ofProject:projectName];
#warning NYI: -all not supported
#endif
//END4iTM3;
    return;
}
@end

@implementation iTM2ConnectionRoot(iTM3ServerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performProjectActionWithContext:
- (oneway void)performProjectActionWithContext:(id)context;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM3ServerKit performSelectorOnMainThread:@selector(doPerformProjectActionWithContext:) withObject:context waitUntilDone:NO];
	return;
//END4iTM3;
}
@end

@interface iTM2URLHandlerCommand: NSScriptCommand
@end
@implementation iTM2URLHandlerCommand
- (id)performDefaultImplementation
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString *urlString = self.directParameter;
	NSURL * url = [NSURL URLWithString:urlString];
    NSString * action = [url host];
	NSString * query = [url query];
	NSArray * components = [query componentsSeparatedByString:@"&"];
	NSMutableArray * arguments = [NSMutableArray array];
	NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
	NSString * S;
	for(S in components)
	{
		NSArray * RA = [S componentsSeparatedByString:@"="];
		if(RA.count>1)
		{
			NSString * key = [RA objectAtIndex:ZER0];
			key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSString * value = [RA objectAtIndex:1];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			[attributes setObject:value forKey:key];
		}
		else if(RA.count)
		{
			NSString * value = [RA objectAtIndex:ZER0];
			value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			[arguments addObject:value];
		}
	}
	[[[NSApp keyWindow] firstResponder] performAction:action withArguments:arguments attributes:attributes]
		|| [[[NSApp mainWindow] firstResponder] performAction:action withArguments:arguments attributes:attributes];
//END4iTM3;
    return nil;
}
@end
