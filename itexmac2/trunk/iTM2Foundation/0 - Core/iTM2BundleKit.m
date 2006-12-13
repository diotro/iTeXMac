/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Apr 28 2002.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import <sys/stat.h>
#import <AppKit/AppKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
//#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

NSString * const iTeXMac2 = @"iTeXMac2";
NSString * const iTM2LocalizedExtension = @"localized";
NSString * const iTM2SupportGeneralComponent = @"General.localized";
NSString * const iTM2BPrivate = @"Private";
NSString * const iTM2ApplicationSupport = @"Application Support";
NSString * const iTM2SupportPluginsComponent = @"PlugIns.localized";

NSString * const iTM2SupportTextComponent = @"Text Editor.localized";

NSString * const iTeXMac2BundleIdentifier = @"comp.text.tex.iTeXMac2";
NSString * const iTM2FoundationBundleIdentifier = @"comp.text.tex.iTM2Foundation";
NSString * const iTM2TeXFoundationBundleIdentifier = @"comp.text.tex.iTM2TeXFoundation";

NSString * const iTM2BundleDidLoadNotification = @"iTM2BundleDidLoad";

NSString * const iTM2BundleContentsComponent = @"Contents";

#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
@interface NSBundle_iTeXMac2: NSBundle
@end

@implementation NSBundle_iTeXMac2
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSBundle_iTeXMac2 poseAsClass:[NSBundle class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
- (BOOL)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self isLoaded])
	{
		if([super load])
		{
			[iTM2RuntimeBrowser cleanCache];
			[INC postNotificationName:iTM2BundleDidLoadNotification object:self];
			return YES;
		}
		else
			return NO;
	}
	else
		return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  loadNibNamed:owner:
+ (BOOL)loadNibNamed:(NSString *)aNibName owner:(id)owner;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([super loadNibNamed:aNibName owner:owner])
		return YES;
	Class class = [owner class];
	Class superclass;
	while((superclass = [class superclass]) && (superclass != class))
	{
		NSBundle * B = [NSBundle bundleForClass:superclass];
		NSString * fileName = [B pathForResource:aNibName ofType:@"nib"];
//iTM2_LOG(@"fileName is: %@", fileName);
		if([fileName length]
			&& [B loadNibFile:fileName
				externalNameTable: [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"]
					withZone: [owner zone]])
			return YES;
		class = superclass;
	}
//iTM2_END;
	return NO;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  loadNibFile:externalNameTable:withZone:
+ (BOOL)loadNibFile:(NSString *)fileName externalNameTable:(NSDictionary *)context withZone:(NSZone *)zone;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"context is: %@", context);
//iTM2_END;
	return [super loadNibFile:fileName externalNameTable:context withZone:zone];
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  loadNibFile:externalNameTable:withZone:
- (NSString *)pathForAuxiliaryExecutable:(NSString *)executableName;
/*"Overriden pethod to add support of frameworks.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = [super pathForAuxiliaryExecutable:executableName];
	if([result length])
		return result;
	else if([[NSBundle allFrameworks] containsObject:self])
	{
		result = [[self bundlePath] stringByAppendingPathComponent:executableName];
		if(![DFM isExecutableFileAtPath:result])
			result = nil;
	}
//iTM2_END;
	return result;
}
@end

#import <sys/sysctl.h>
#import <mach/machine.h>

@implementation NSBundle(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isI386
+ (BOOL)isI386;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int cpu_type;
	size_t length = sizeof(cpu_type);
	sysctlbyname("hw.cputype", &cpu_type, &length, NULL, 0);
//iTM2_END;
	return cpu_type == CPU_TYPE_I386;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  plugInPathExtension
+ (NSString *)plugInPathExtension;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2FoundationBundle
+ (NSBundle *)iTM2FoundationBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSBundle bundleWithIdentifier:iTM2FoundationBundleIdentifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTeXMac2Bundle
+ (NSBundle *)iTeXMac2Bundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSBundle bundleWithIdentifier:iTeXMac2BundleIdentifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  searchPathsForSupportInDomains:withName:
+ (NSArray *)searchPathsForSupportInDomains:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName;
/*"Description forthcoming. Does not check for existence.
Returns a subarray of
~/Library/Application\ Support/iTeXMac2
/Library/Application\ Support/iTeXMac2
/Network/Library/Application\ Support/iTeXMac2
IGNORED: /System/Library/Application\ Support/iTeXMac2
according to the flags given in argument
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [NSMutableArray array];
    NSString * suffix = [iTM2ApplicationSupport stringByAppendingPathComponent:appName];
    #define ADD_OBJECT(DOMAIN)\
    if(domainMask&DOMAIN)\
        [MRA addObject:[[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, DOMAIN, YES) lastObject]\
            stringByAppendingPathComponent: suffix] stringByResolvingSymlinksAndFinderAliasesInPath]];
    ADD_OBJECT(NSUserDomainMask);
    ADD_OBJECT(NSLocalDomainMask);
    ADD_OBJECT(NSNetworkDomainMask);
//    ADD_OBJECT(NSSystemDomainMask);
    return [[MRA copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pathForSupportDirectory:inDomain:withName:create:
+ (NSString *)pathForSupportDirectory:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName create:(BOOL)create;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![appName length])
		return [NSString string];
    if(!subpath)
        subpath = [NSString string];
    NSString * path = [[self searchPathsForSupportInDomains:domainMask withName:appName] lastObject];
    path = [path stringByAppendingPathComponent:subpath];
    path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	if([DFM fileExistsAtPath:path])
	{
		return path;
	}
	NSError * localError = nil;
	if([DFM pathContentOfSymbolicLinkAtPath:path]
		&& ![DFM removeFileAtPath:path handler:NULL])
	{
		localError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
						userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
							[NSString stringWithFormat:@"Could not remove\n%@", path], NSLocalizedDescriptionKey,
							path, @"iTM2BundleKit",
								nil]];
		[NSApp presentError:localError];
	}
	if(create && [DFM createDeepDirectoryAtPath:path attributes:nil error:&localError])
	{
		return path;
	}
	if(localError)
	{
		[NSApp presentError:localError];
	}
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pathForSupportDirectory:inDomain:create:
- (NSString *)pathForSupportDirectory:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask create:(BOOL)create;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [isa pathForSupportDirectory:subpath inDomain:domainMask withName:[self bundleName] create:create];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  bundleName
- (NSString *)bundleName;
/*"Description forthcoming. Does not check for existence.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [[self infoDictionary] objectForKey:(NSString *) kCFBundleNameKey];
    return result? result: (self == [NSBundle mainBundle]? [[[self bundlePath] lastPathComponent] stringByDeletingPathExtension]:[self bundleIdentifier]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  temporaryDirectory
+ (NSString *)temporaryDirectory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * path = nil;
	if(!path)
	{
		path = [NSTemporaryDirectory() stringByAppendingPathComponent:[self uniqueApplicationIdentifier]];
		NSError * localError = nil;
		if([DFM createDeepDirectoryAtPath:path attributes:nil error:&localError])
			[path retain];
		else
		{
			iTM2_LOG(@"..........  ERROR: Directory expected at %@... returning %@ instead (error: %@)", path, NSTemporaryDirectory(), localError);
			path = [NSTemporaryDirectory() copy];
		}
	}
//iTM2_END;
	return path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  temporaryBinaryDirectory
+ (NSString *)temporaryBinaryDirectory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * path = nil;
	if(!path)
	{
		path = [[self temporaryDirectory] stringByAppendingPathComponent:@"bin"];
		NSError * localError = nil;
		if([DFM createDeepDirectoryAtPath:path attributes:nil error:&localError])
			[path retain];
		else
		{
			iTM2_LOG(@"..........  ERROR: Directory expected at %@... returning %@ instead (error: %@)", path, NSTemporaryDirectory(), localError);
			path = [NSTemporaryDirectory() copy];
		}
	}
//iTM2_END;
	return path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  createSymbolicLinkWithExecutableContent:error:
+ (BOOL)createSymbolicLinkWithExecutableContent:(NSString *)executable error:(NSError **)errorRef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * binaryDirectory = [self temporaryBinaryDirectory];
	NSString * link = [binaryDirectory stringByAppendingPathComponent:[executable lastPathComponent]];// no stringByStandardizingPath please
	if(([DFM fileExistsAtPath:link] || [DFM pathContentOfSymbolicLinkAtPath:link])
			&& (![DFM isDeletableFileAtPath:link] || ![DFM removeFileAtPath:link handler:nil]))
	{
		if(errorRef)
		{
			* errorRef = [NSError errorWithDomain:iTM2FoundationErrorDomain code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					NSLocalizedStringFromTableInBundle(@"Setup failure", iTM2LocalizedExtension, [self classBundle], ""), NSLocalizedDescriptionKey,
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"I CANNOT remove existing file at %@", iTM2LocalizedExtension, [self classBundle], ""), link], NSLocalizedFailureReasonErrorKey,
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Remove file at %@", iTM2LocalizedExtension, [self classBundle], ""), link], NSLocalizedRecoverySuggestionErrorKey,
						nil]];
		}
	}
	else if([DFM createSymbolicLinkAtPath:link pathContent:executable])
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"INFO: new soft link from\n%@\nto %@...", link, executable);
		}
		return YES;
	}
	else
	{
		if(errorRef)
		{
			* errorRef = [NSError errorWithDomain:iTM2FoundationErrorDomain code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					NSLocalizedStringFromTableInBundle(@"Setup failure", iTM2LocalizedExtension, [self classBundle], ""), NSLocalizedDescriptionKey,
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"I CANNOT make a soft link to\n%@\nfrom\n%@", iTM2LocalizedExtension, [NSBundle bundleForClass:self], ""), link, executable], NSLocalizedFailureReasonErrorKey,
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Please make a soft link to\n%@\nfrom\n%@", iTM2LocalizedExtension, [NSBundle bundleForClass:self], ""), link, executable], NSLocalizedRecoverySuggestionErrorKey,
						nil]];
		}
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  temporaryUniqueDirectory
+ (NSString *)temporaryUniqueDirectory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * directory = [[self temporaryDirectory] stringByAppendingPathComponent:@"Unique"];
	NSString * path;
	unsigned int i = 0;
	do
	{
		NSString * component = [NSString stringWithFormat:@"%u", i++];
		path = [directory stringByAppendingPathComponent:component];
	}
	while([DFM fileExistsAtPath:path] || [DFM pathContentOfSymbolicLinkAtPath:path]);
	
	if([DFM createDeepDirectoryAtPath:path attributes:nil error:nil])
	{
		return path;
	}
	else
	{
		return NSTemporaryDirectory();
	}
//iTM2_END;
	return path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  defaultWritableFolderPath
+ (NSString *)defaultWritableFolderPath;
/*"Description forthcoming. Does not check for existence.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * path = [self temporaryDirectory];
    path = [path stringByAppendingPathComponent:@"default"];
	BOOL isDirectory = NO;
    if([DFM fileExistsAtPath:path isDirectory:&isDirectory])
	{
		if(isDirectory)
		{
			return path;
		}
	}
	else if((![DFM pathContentOfSymbolicLinkAtPath:path]
			|| [DFM removeFileAtPath:path handler:NULL])
				&& [DFM createDirectoryAtPath:path attributes:nil])
	{
		return path;
	}
    iTM2_LOG(@"Directory expected at %@... returning %@ instead", path, [self temporaryDirectory]);
	return [self temporaryDirectory];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  uniqueApplicationIdentifier
+ (NSString *)uniqueApplicationIdentifier;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sat Jul 23 00:54:14 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * S;
	if(!S)
		S = [[[NSProcessInfo processInfo] globallyUniqueString] copy];
//iTM2_END;
	return S;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadPlugIns
+ (void)loadPlugIns;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_LOG(@"INFO: Loading the plug-ins of %@...START", self);
	NSMutableArray * paths = [NSMutableArray arrayWithArray:[self availablePlugInPathsOfType:[self plugInPathExtension]]];
	int newCount = [paths count];
	int oldCount;
	do
	{
		oldCount = newCount;
		NSEnumerator * E = [[[paths copy] autorelease] objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
//iTM2_LOG(@"Starting to load plug-in at path: %@", path);
			NSBundle * B = [NSBundle bundleWithPath:path];
			if(B && ![B isLoaded])
			{
				NSString * principalClassName = [[[[B infoDictionary] objectForKey:@"NSPrincipalClass"] retain] autorelease];
//iTM2_LOG(@"NSPrincipalClass is: %@", principalClassName);
				if([principalClassName length])
				{
					if(NSClassFromString(principalClassName))
					{
						iTM2_LOG(@"Plug-in ignored at path:\n%@\nPrincipal class conflict (%@)\nThis can be expected behaviour...", path, principalClassName);
						[paths removeObject:path];
					}
					else
					{
						NSString * K = [NSString stringWithFormat:@"iTM2IgnorePlugin_%@", [[path lastPathComponent] stringByDeletingPathExtension]];
						if([SUD boolForKey:K])
						{
							iTM2_LOG(@"Plug-in at path\n%@ temporarily disabled, you can activate is from the terminal\nterminal% defaults delete comp.text.TeX.iTeXMac2 '%@'", path, K);
						}
						else
						{
							NSArray * requiredClasses = [[B infoDictionary] objectForKey:@"iTM2RequiredClasses"];
							NSEnumerator * ee = [requiredClasses isKindOfClass:[NSArray class]]?
													[requiredClasses objectEnumerator]:nil;
							NSString * requiredClassName;
							BOOL canLoad = YES;
							while(requiredClassName = [ee nextObject])
								if(!NSClassFromString(requiredClassName))
								{
									canLoad = NO;
									iTM2_LOG(@"Plug-in: unable to load %@\nRequired class missing: %@ (bundle: %@)", B, requiredClassName, [NSBundle allBundles]);
									break;
								}
							if(canLoad)
							{
								if([B load])
								{
									iTM2_LOG(@"Plug-in: loaded %@\nPrincipal class: %@\nIf this plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
									[[B principalClass] class];// sends a +load message as expected side effect
								}
								else
								{
									iTM2_LOG(@"Plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								}
								[paths removeObject:path];
							}
							else
							{
								NS_DURING
								if([B load])
								{
									iTM2_LOG(@"Plug-in: loaded %@\nPrincipal class: %@\nIf this plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
									[[B principalClass] class];
								}
								else
								{
									iTM2_LOG(@"Plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								}
								NS_HANDLER
								iTM2_LOG(@"Plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								NS_ENDHANDLER
								[paths removeObject:path];
							}
						}
					}
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"No principal class in bundle: %@", B);
					[paths removeObject:path];
				}
			}
			else
				[paths removeObject:path];
		}
		newCount = [paths count];
	}
	while(newCount < oldCount);
//iTM2_LOG(@"INFO: Plug-ins loaded.");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= availablePlugInPathsOfType:
+ (NSArray *)availablePlugInPathsOfType:(NSString *)aType;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * paths = [NSMutableArray array];
	// all the plug ins
	NSBundle * B = [NSBundle mainBundle];
	[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
		[B pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO]
				ofType: aType]];
	[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
		[B pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
				ofType: aType]];
	[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
		[B pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
				ofType: aType]];
	[paths addObjectsFromArray:[self availablePlugInPathsAtPath:[B builtInPlugInsPath] ofType:aType]];
	// the frameworks
	NSEnumerator * E = [[NSBundle allFrameworks] objectEnumerator];
	while(B = [E nextObject])
	{
		if(![B isEqual:[NSBundle mainBundle]])
		{
			[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
				[B pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO]
						ofType: aType]];
			[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
				[B pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
						ofType: aType]];
			[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
				[B pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
						ofType: aType]];
//iTM2_LOG(@"[B builtInPlugInsPath]:%@, B:%@", [B builtInPlugInsPath], B);
			[paths addObjectsFromArray:[self availablePlugInPathsAtPath:[B builtInPlugInsPath] ofType:aType]];
		}
	}
//iTM2_END;
    return paths;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= availablePlugInPathsOfType:
- (NSArray *)availablePlugInPathsOfType:(NSString *)aType;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * paths = [NSMutableArray array];
	[paths addObjectsFromArray:[[self class] availablePlugInPathsAtPath:
		[self pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:YES]
				ofType: aType]];
	[paths addObjectsFromArray:[[self class] availablePlugInPathsAtPath:
		[self pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
				ofType: aType]];
	[paths addObjectsFromArray:[[self class] availablePlugInPathsAtPath:
		[self pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
				ofType: aType]];
	[paths addObjectsFromArray:[[self class] availablePlugInPathsAtPath:[self builtInPlugInsPath] ofType:aType]];
//iTM2_END;
    return paths;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= availablePlugInPathsAtPath:ofType:
+ (NSArray *)availablePlugInPathsAtPath:(NSString *)path ofType:(NSString *)aType;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"path is: %@", path);
	NSMutableArray * result = [NSMutableArray array];
	if([path length])
		path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	else
		return result;
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:path];
	NSString * component;
	while(component = [DE nextObject])
	{
		if([[component pathExtension] pathIsEqual:aType])
		{
			component = [[path stringByAppendingPathComponent:component] stringByResolvingSymlinksAndFinderAliasesInPath];
			[result addObject:component];
			if(![[NSBundle bundleWithPath:component] bundleIsWrapper])
				[DE skipDescendents];// be shalow
		}
	}
//iTM2_LOG(@"Available plug-ins loaded at path: %@ are %@", path, result);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleForResourceAtPath:
+ (NSBundle *)bundleForResourceAtPath:(NSString *)aPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	while([aPath length]>4)// beware:it must contain regex characters "/.+\..+"
	{
		if([aPath isEqual:[[NSBundle mainBundle] bundlePath]])
			return [NSBundle mainBundle];
		NSString * extension = [aPath pathExtension];
		if([extension pathIsEqual:[self plugInPathExtension]] || [extension isEqualToString:@"framework"])
			return [NSBundle bundleWithPath:aPath];
		NSBundle * B = [NSBundle bundleWithPath:aPath];
		if([[B infoDictionary] count])
			return B;
		aPath = [aPath stringByDeletingLastPathComponent];
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pathsForResource:ofType:inDirectory:domains:
- (NSArray *)pathsForResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath domains:(NSSearchPathDomainMask)domainMask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [NSMutableArray array];
	
	NSEnumerator * E;
	NSString * path;
	
	NSString * plugInsDirectoryPath;
	NSString * bundlePath;

	if(domainMask & NSNetworkDomainMask)
	{
		plugInsDirectoryPath = [self pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO];
		E = [[NSBundle availablePlugInPathsAtPath:plugInsDirectoryPath ofType:[[self class] plugInPathExtension]] objectEnumerator];
		while(bundlePath = [E nextObject])
		{
			path = [[NSBundle bundleWithPath:bundlePath] pathForResource:name ofType:type inDirectory:subpath];
			if([path length])
				[result addObject:path];
		}
	}

	if(domainMask & NSLocalDomainMask)
	{
		plugInsDirectoryPath = [self pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO];
		E = [[NSBundle availablePlugInPathsAtPath:plugInsDirectoryPath ofType:[[self class] plugInPathExtension]] objectEnumerator];
		while(bundlePath = [E nextObject])
		{
			path = [[NSBundle bundleWithPath:bundlePath] pathForResource:name ofType:type inDirectory:subpath];
			if([path length])
				[result addObject:path];
		}
	}

	if(domainMask & NSUserDomainMask)
	{
		plugInsDirectoryPath = [self pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO];
		E = [[NSBundle availablePlugInPathsAtPath:plugInsDirectoryPath ofType:[[self class] plugInPathExtension]] objectEnumerator];
		while(bundlePath = [E nextObject])
		{
			path = [[NSBundle bundleWithPath:bundlePath] pathForResource:name ofType:type inDirectory:subpath];
			if([path length])
				[result addObject:path];
		}
	}

    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleIsWrapper
- (BOOL)bundleIsWrapper;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self infoDictionary] objectForKey:@"iTM2BundleIsWrapper"] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleHFSTypeCode
- (OSType)bundleHFSTypeCode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return *(const unsigned long *)[[[[self infoDictionary] objectForKey:@"CFBundlePackageType"] stringByPaddingToLength:4 withString:@"\0" startingAtIndex:0] cStringUsingEncoding:NSUTF8StringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleHFSCreatorCode
- (OSType)bundleHFSCreatorCode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return *(const unsigned long *)[[[[self infoDictionary] objectForKey:@"CFBundleSignature"] stringByPaddingToLength:4 withString:@"\0" startingAtIndex:0] cStringUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allBundlesAtPath:
+ (NSArray *)allBundlesAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![path length])
		return [NSArray array];
	NSMutableArray * result = [NSMutableArray array];
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:path];
	NSString * component;
	while(component = [DE nextObject])
	{
		NSBundle * B = [NSBundle bundleWithPath:[path stringByAppendingPathComponent:component]];
		if([[B infoDictionary] count])// this is a real bundle
		{
			[DE skipDescendents];// be shalow
			[result addObject:B];
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  supportBundlesInDomain:
- (NSArray *)supportBundlesInDomain:(NSSearchPathDomainMask) domainMask;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [NSBundle allBundlesAtPath:[self pathForSupportDirectory:@"" inDomain:domainMask create:NO]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= embeddedBundles
- (NSArray *)embeddedBundles;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [NSMutableArray array];
	[result addObjectsFromArray:[NSBundle allBundlesAtPath:[self privateFrameworksPath]]];
	[result addObjectsFromArray:[NSBundle allBundlesAtPath:[self sharedFrameworksPath]]];
	[result addObjectsFromArray:[NSBundle allBundlesAtPath:[self builtInPlugInsPath]]];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pathsForBuiltInResource:ofType:inDirectory:
- (NSArray *)pathsForBuiltInResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [NSMutableArray array];
	NSEnumerator * E = [[self embeddedBundles] objectEnumerator];
	NSBundle * B;
	while(B = [E nextObject])
	{
		[result addObjectsFromArray:[B pathsForBuiltInResource:name ofType:type inDirectory:subpath]];
	}
	if(![type length])
	{
		type = [name pathExtension];
		name = [name stringByDeletingPathExtension];
	}
	NSString * path = [self pathForResource:name ofType:type inDirectory:subpath];
	if([path length])
		[result addObject:path];

//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pathsForSupportResource:ofType:inDirectory:
- (NSArray *)pathsForSupportResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![type length])
	{
		type = [name pathExtension];
		name = [name stringByDeletingPathExtension];
	}
	NSMutableArray * result = [NSMutableArray array];
	NSEnumerator * E = [[self embeddedBundles] objectEnumerator];
	NSBundle * B;
	while(B = [E nextObject])
	{
		[result addObjectsFromArray:[B pathsForSupportResource:name ofType:type inDirectory:subpath]];
	}
	E = [[self supportBundlesInDomain:NSNetworkDomainMask] objectEnumerator];
	while(B = [E nextObject])
	{
		[result addObjectsFromArray:[B pathsForSupportResource:name ofType:type inDirectory:subpath]];
	}
	E = [[self supportBundlesInDomain:NSLocalDomainMask] objectEnumerator];
	while(B = [E nextObject])
	{
		[result addObjectsFromArray:[B pathsForSupportResource:name ofType:type inDirectory:subpath]];
	}
	if([type isEqualToString:iTM2LocalizedExtension])
	{
		// from preview 13 to 14, folders in the application support directory now are localizable
		// if I am looking for a .localized folder and I just find a not localized one,
		// turn the old into the new...
		E = [[self supportBundlesInDomain:NSUserDomainMask] objectEnumerator];
		NSMutableArray * paths = [NSMutableArray array];
		while(B = [E nextObject])
		{
			[paths addObjectsFromArray:[B pathsForSupportResource:name ofType:@"" inDirectory:subpath domains:NSUserDomainMask]];
		}
		E = [paths objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
			NSString * newPath = [path stringByAppendingPathExtension:iTM2LocalizedExtension];
			if([DFM fileExistsAtPath:newPath] || [DFM pathContentOfSymbolicLinkAtPath:path])
			{
				iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Recycle file at:\n%@", path]), nil);
				if(![SWS performFileOperation:NSWorkspaceRecycleOperation source:[path stringByDeletingLastPathComponent] destination:@"" files:[NSArray arrayWithObject:[path lastPathComponent]] tag:nil])
				{
					iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Failed to recycle file at:\n%@\nWould you do it for me?", path]), nil);
				}
			}
			else if(![DFM movePath:path toPath:newPath handler:NULL])
			{
				iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Failed to move:\n%@\nto\n%@\nWould you do it for me?", path, newPath]), nil);
			}
		}
	}
	E = [[self supportBundlesInDomain:NSUserDomainMask] objectEnumerator];
	while(B = [E nextObject])
	{
		[result addObjectsFromArray:[B pathsForSupportResource:name ofType:type inDirectory:subpath]];
	}
	// resource in the Application Support, not in any bundle
	[result addObjectsFromArray:[self pathsForSupportResource:name ofType:type inDirectory:subpath
		domains: NSAllDomainsMask]];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pathsForSupportResource:ofType:inDirectory:domains:
- (NSArray *)pathsForSupportResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath domains:(NSSearchPathDomainMask)domainMask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	domainMask = domainMask & (NSUserDomainMask|NSLocalDomainMask|NSNetworkDomainMask);
	unsigned mask;
	NSString * path = nil;
	NSString * lastComponent = nil;
	NSString * lastName = nil;
	NSString * pathExtension = nil;
	NSEnumerator * DE = nil;
	NSMutableArray * result = [NSMutableArray array];
	if(name)
	{
		name = [name lowercaseString];
		if(type)
		{
			type = [type lowercaseString];
			if(mask = domainMask & NSNetworkDomainMask)
			{
				path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
					while(lastComponent = [DE nextObject])
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName pathIsEqual:name] && [pathExtension pathIsEqual:type])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSLocalDomainMask)
			{
				path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
					while(lastComponent = [DE nextObject])
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName pathIsEqual:name] && [pathExtension pathIsEqual:type])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSUserDomainMask)
			{
				path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
					while(lastComponent = [DE nextObject])
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName pathIsEqual:name] && [pathExtension pathIsEqual:type])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
		}
		else// no type given
		{
			if(mask = domainMask & NSNetworkDomainMask)
			{
				path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
					while(lastComponent = [DE nextObject])
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName pathIsEqual:name])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSLocalDomainMask)
			{
				path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
					while(lastComponent = [DE nextObject])
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName pathIsEqual:name])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSUserDomainMask)
			{
				path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
					while(lastComponent = [DE nextObject])
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName pathIsEqual:name])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
		}
	}
	else if(type)
	{
		type = [type lowercaseString];
		name = type;
		if(mask = domainMask & NSNetworkDomainMask)
		{
			path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
			if([path length])
			{
				DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
				while(lastComponent = [DE nextObject])
				{
					lastName = [lastComponent lowercaseString];
					lastName = [lastName pathExtension];
					if([lastName pathIsEqual:name])
					{
						lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
					}
				}
			}
		}// if(mask = domainMask & ...)
		if(mask = domainMask & NSLocalDomainMask)
		{
			path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
			if([path length])
			{
				NSEnumerator * DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
				while(lastComponent = [DE nextObject])
				{
					lastName = [lastComponent lowercaseString];
					lastName = [lastName pathExtension];
					if([lastName pathIsEqual:name])
					{
						lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
					}
				}
			}
		}// if(mask = domainMask & ...)
		if(mask = domainMask & NSUserDomainMask)
		{
			path = [self pathForSupportDirectory:subpath inDomain:mask create:NO];
			if([path length])
			{
				NSEnumerator * DE = [[DFM directoryContentsAtPath:path] objectEnumerator];
				while(lastComponent = [DE nextObject])
				{
					lastName = [lastComponent lowercaseString];
					lastName = [lastName pathExtension];
					if([lastName pathIsEqual:name])
					{
						lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
					}
				}
			}
		}// if(mask = domainMask & ...)
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allPathsForResource:ofType:inDirectory:
- (NSArray *)allPathsForResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![type length])
	{
		type = [name pathExtension];
		name = [name stringByDeletingPathExtension];
	}
	NSMutableArray * result = [NSMutableArray array];
	[result addObjectsFromArray:[self pathsForSupportResource:name ofType:type inDirectory:subpath]];
	[result addObjectsFromArray:[self pathsForBuiltInResource:name ofType:type inDirectory:subpath]];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allPathsForResource:ofType:
- (NSArray *)allPathsForResource:(NSString *)component ofType:(NSString *)type;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self allPathsForResource:component ofType:type inDirectory:@""];
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleForClass:localizedStringForKey:value:table:
+ (NSString *)bundleForClass:(Class)aClass localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSBundle * bundle = [NSBundle bundleForClass:aClass];
	NSString * candidate = [bundle localizedStringForKey:key value:@"___" table:tableName];
	if([candidate isEqualToString:@"___"])
	{
		Class superclass = [aClass superclass];
		if(aClass == superclass)
		{
			return value;
		}
		return [self bundleForClass:superclass localizedStringForKey:key value:value table:tableName];
	}
//iTM2_END;
	return candidate;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeObject:performSelector:withOrderedBundlePathsForComponent:
+ (void)makeObject:(id)anObject performSelector:(SEL)aSelector withOrderedBundlePathsForComponent:(NSString *)component;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSParameterAssert([anObject respondsToSelector:aSelector]);
	iTM2_INIT_POOL;
//iTM2_START;
	// read the built in stuff
	// inside frameworks then bundles.
	NSArray * frameworks = [NSBundle allFrameworks];
	NSMutableArray * plugins = [NSMutableArray arrayWithArray:[NSBundle allBundles]];
	[plugins removeObjectsInArray:frameworks];// plugins are bundles
	NSBundle * mainBundle = [NSBundle mainBundle];
	[plugins removeObject:mainBundle];// plugins are bundles, except the main one
	// sorting the frameworks and plugins
	// separating them according to their domain
	NSString * networkPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSNetworkDomainMask create:NO];
	networkPrefix = [networkPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * localPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSLocalDomainMask create:NO];
	localPrefix = [localPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * userPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSUserDomainMask create:NO];
	userPrefix = [userPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	
	NSMutableArray * networkFrameworks = [NSMutableArray array];
	NSMutableArray * localFrameworks = [NSMutableArray array];
	NSMutableArray * userFrameworks = [NSMutableArray array];
	NSMutableArray * otherFrameworks = [NSMutableArray array];
	NSString * P = nil;
	NSEnumerator * E = [frameworks objectEnumerator];
	NSBundle * B = nil;
	while(B = [E nextObject])
	{
		P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userFrameworks addObject:B];
		else if([P hasPrefix:localPrefix])
			[localFrameworks addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkFrameworks addObject:B];
		else
			[otherFrameworks addObject:B];
	}
	NSMutableArray * networkPlugIns = [NSMutableArray array];
	NSMutableArray * localPlugIns = [NSMutableArray array];
	NSMutableArray * userPlugIns = [NSMutableArray array];
	NSMutableArray * otherPlugIns = [NSMutableArray array];
	E = [frameworks objectEnumerator];
	while(B = [E nextObject])
	{
		P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userPlugIns addObject:B];
		else if([P hasPrefix:localPrefix])
			[localPlugIns addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkPlugIns addObject:B];
		else
			[otherPlugIns addObject:B];
	}
	// reload
	#define RELOAD(ARRAY)\
	E = [ARRAY objectEnumerator];\
	while(B = [E nextObject])\
	{\
		P = [B pathForResource:component ofType:nil];\
		[anObject performSelector:aSelector withObject:P];\
	}
	RELOAD(otherFrameworks);
	RELOAD(otherPlugIns);
	P = [mainBundle pathForResource:component ofType:nil];
	[anObject performSelector:aSelector withObject:P];
	RELOAD(networkFrameworks);
	RELOAD(networkPlugIns);
	P = [mainBundle pathForSupportDirectory:component inDomain:NSNetworkDomainMask create:NO];
	[anObject performSelector:aSelector withObject:P];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	P = [mainBundle pathForSupportDirectory:component inDomain:NSLocalDomainMask create:NO];
	[anObject performSelector:aSelector withObject:P];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	P = [mainBundle pathForSupportDirectory:component inDomain:NSUserDomainMask create:YES];
	[anObject performSelector:aSelector withObject:P];
	#undef RELOAD
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
@end

@interface NSApplication_iTM2BundleKit: NSApplication
@end

@implementation NSApplication(iTM2BundleKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(run) replacement:@selector(swizzle_iTM2BundleKit_run) forClass:[NSApplication class]])
	{
		iTM2_LOG(@"..........  ERROR: Bad configuration, things won't work as expected...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzle_iTM2BundleKit_run
- (void)swizzle_iTM2BundleKit_run;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	// this must occur very early, the stuff in the bundles will be correctly coded
//iTM2_LOG(@".....     START: LOAD THE BUNDLES");
	[NSBundle loadPlugIns];
//iTM2_LOG(@".....     END:   LOAD THE BUNDLES");
	if(iTM2DebugEnabled)
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], @"NSShowNonLocalizedStrings", nil]];
	}
	iTM2_RELEASE_POOL;
	[self swizzle_iTM2BundleKit_run];
	// Don't add code below, it won't ever be reached...
//iTM2_END;
    return;
}
@end

@implementation NSObject(iTM2BundleKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classBundle
+ (NSBundle *)classBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSBundle bundleForClass:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classBundle
- (NSBundle *)classBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [isa classBundle];
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSBundle(iTeXMac2)

@implementation NSAutoreleasePool(ddff)
+ (id)infoDictionary;
{iTM2_DIAGNOSTIC;
	return nil;
}
@end
#if 0
#pragma mark -

int
     sysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp,
         size_t newlen);

static int sysctlbyname_with_pid (const char *name, pid_t pid, 
                            void *oldp, size_t *oldlenp, 
                            void *newp, size_t newlen)
{
    if (pid == 0) {
        if (sysctlbyname(name, oldp, oldlenp, newp, newlen) == -1)  {
            fprintf(stderr, "sysctlbyname_with_pid(0): sysctlbyname  failed:"
                     "%s\n", strerror(errno));
            return -1;
        }
    } else {
        int mib[CTL_MAXNAME];
        size_t len = CTL_MAXNAME;
        if (sysctlnametomib(name, mib, &len) == -1) {
            fprintf(stderr, "sysctlbyname_with_pid: sysctlnametomib  failed:"
                     "%s\n", strerror(errno));
            return -1;
        }
        mib[len] = pid;
        len++;
        if (sysctl(mib, len, oldp, oldlenp, newp, newlen) == -1)  {
            fprintf(stderr, "sysctlbyname_with_pid: sysctl  failed:"
                    "%s\n", strerror(errno));
            return -1;
        }
    }
    return 0;
}
int is_pid_native (pid_t pid)
{
    int ret = 0;
    size_t sz = sizeof(ret);
 
    if (sysctlbyname_with_pid("sysctl.proc_native", pid, 
                &ret, &sz, NULL, 0) == -1) {
         if (errno == ENOENT) {
            // sysctl doesn't exist, which means that this version of Mac OS 
            // pre-dates Rosetta, so the application must be native.
            return 1;
        }
        fprintf(stderr, "is_pid_native: sysctlbyname_with_pid  failed:" 
                "%s\n", strerror(errno));
        return -1;
    }
    return ret;
}
#endif