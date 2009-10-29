/*
//
//  @version Subversion: $Id: iTM2BundleKit.m 799 2009-10-13 16:46:39Z jlaurens $ 
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
#import <stdio.h>
#import <AppKit/AppKit.h>
#import "iTM2PathUtilities.h"
#import "iTM2FileManagerKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2BundleKit.h"

NSString * const iTeXMac2 = @"iTeXMac2";
NSString * const iTM2LocalizedExtension = @"localized";
NSString * const iTM2SupportGeneralComponent = @"General.localized";
NSString * const iTM2BPrivate = @"Private";
NSString * const iTM2ApplicationSupport = @"Application Support";
NSString * const iTM2SupportPluginsComponent = @"PlugIns.localized";
NSString * const iTM2SupportScriptsComponent = @"Scripts.localized";
NSString * const iTM2SupportBinaryComponent = @"bin";

NSString * const iTM2SupportTextComponent = @"Text Editor.localized";

NSString * const iTeXMac2BundleIdentifier = @"comp.text.tex.iTeXMac2";
NSString * const iTM2FoundationBundleIdentifier = @"comp.text.tex.iTM2Foundation";
NSString * const iTM2TeXFoundationBundleIdentifier = @"comp.text.tex.iTM2TeXFoundation";

NSString * const iTM2BundleDidLoadNotification = @"iTM2BundleDidLoad";

NSString * const iTM2BundleContentsComponent = @"Contents";

#import "iTM2NotificationKit.h"
#import "iTM2Runtime.h"
#import <sys/sysctl.h>
#import <mach/machine.h>

NSString * _iTM2_NSLogOutputPath = nil;
@implementation NSBundle(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Bndl_load
- (BOOL)SWZ_iTM2Bndl_load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self isLoaded])
		return YES;
	if([self SWZ_iTM2Bndl_load])
	{
		[iTM2Runtime flushCache];
		[INC postNotificationName:iTM2BundleDidLoadNotification object:self];
		return YES;
	}
	else
		return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Bndl_loadNibNamed:owner:
+ (BOOL)SWZ_iTM2Bndl_loadNibNamed:(NSString *)aNibName owner:(id)owner;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self SWZ_iTM2Bndl_loadNibNamed:aNibName owner:owner])
	{
		return YES;
	}
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Bndl_pathForAuxiliaryExecutable:
- (NSString *)SWZ_iTM2Bndl_pathForAuxiliaryExecutable:(NSString *)executableName;
/*"Overriden pethod to add support of frameworks.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = [self SWZ_iTM2Bndl_pathForAuxiliaryExecutable:executableName];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  allPathsForSupportExecutables
- (NSArray *)allPathsForSupportExecutables;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSMapTable * cache = nil;
	if(!cache)
	{
		cache = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsZeroingWeakMemory|NSPointerFunctionsOpaquePersonality valueOptions:NSPointerFunctionsStrongMemory];
	}
	NSMutableArray * result = [cache objectForKey:self];
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	[cache setObject:result forKey:self];
	NSArray * subpaths;
	NSString * component;
	NSString * path = [self iTM2_pathForSupportDirectory:iTM2SupportBinaryComponent inDomain:NSNetworkDomainMask create:NO];
	if([DFM iTM2_pushDirectory:path])
	{
		subpaths = [DFM subpathsAtPath:path];
		for(component in subpaths)
		{
			if([DFM isExecutableFileAtPath:path])
			{
				component = [path stringByAppendingPathComponent:component];
				[result addObject:component];
			}
		}
		if(![DFM iTM2_popDirectory])
		{
			return result;
		}
	}
	path = [self iTM2_pathForSupportDirectory:iTM2SupportBinaryComponent inDomain:NSLocalDomainMask create:NO];
	if([DFM iTM2_pushDirectory:path])
	{
		subpaths = [DFM subpathsAtPath:path];
		for(component in subpaths)
		{
			if([DFM isExecutableFileAtPath:path])
			{
				component = [path stringByAppendingPathComponent:component];
				[result addObject:component];
			}
		}
		if(![DFM iTM2_popDirectory])
		{
			return result;
		}
	}
	path = [self iTM2_pathForSupportDirectory:iTM2SupportBinaryComponent inDomain:NSUserDomainMask create:YES];
	if([DFM iTM2_pushDirectory:path])
	{
		subpaths = [DFM subpathsAtPath:path];
		for(component in subpaths)
		{
			if([DFM isExecutableFileAtPath:path])
			{
				component = [path stringByAppendingPathComponent:component];
				[result addObject:component];
			}
		}
		if(![DFM iTM2_popDirectory])
		{
			return result;
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  allPathsForSupportScripts
- (NSArray *)allPathsForSupportScripts;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 0
	static NSMutableDictionary * cache = nil;
	if(!cache)
	{
		cache = [[NSMutableDictionary dictionary] retain];
	}
	NSValue * key = [NSValue valueWithNonretainedObject:self];
	NSMutableArray * result = [cache objectForKey:key];
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	[cache setObject:result forKey:key];
#else
	NSMutableArray * result = [NSMutableArray array];
#endif
	NSArray * subpaths;
	NSString * component;
	NSString * path = [self iTM2_pathForSupportDirectory:iTM2SupportScriptsComponent inDomain:NSNetworkDomainMask create:NO];
	if([DFM iTM2_pushDirectory:path])
	{
		subpaths = [DFM subpathsAtPath:path];
		for(component in subpaths)
		{
			if([DFM iTM2_isVisibleFileAtPath:path])
			{
				component = [path stringByAppendingPathComponent:component];
				[result addObject:component];
			}
		}
		if(![DFM iTM2_popDirectory])
		{
			return result;
		}
	}
	path = [self iTM2_pathForSupportDirectory:iTM2SupportScriptsComponent inDomain:NSLocalDomainMask create:NO];
	if([DFM iTM2_pushDirectory:path])
	{
		subpaths = [DFM subpathsAtPath:path];
		for(component in subpaths)
		{
			if([DFM iTM2_isVisibleFileAtPath:path])
			{
				component = [path stringByAppendingPathComponent:component];
				[result addObject:component];
			}
		}
		if(![DFM iTM2_popDirectory])
		{
			return result;
		}
	}
	path = [self iTM2_pathForSupportDirectory:iTM2SupportScriptsComponent inDomain:NSUserDomainMask create:YES];
	if([DFM iTM2_pushDirectory:path])
	{
		subpaths = [DFM subpathsAtPath:path];
		for(component in subpaths)
		{
			if([DFM iTM2_isVisibleFileAtPath:path])
			{
				component = [path stringByAppendingPathComponent:component];
				[result addObject:component];
			}
		}
		if(![DFM iTM2_popDirectory])
		{
			return result;
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2_temporaryDirectory
+ (NSString *)iTM2_temporaryDirectory;
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
		if([DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&localError])
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
		path = [[self iTM2_temporaryDirectory] stringByAppendingPathComponent:@"bin"];
		NSError * localError = nil;
		if([DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&localError])
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
	if(([DFM fileExistsAtPath:link] || [DFM destinationOfSymbolicLinkAtPath:link error:NULL])
			&& (![DFM isDeletableFileAtPath:link] || ![DFM removeItemAtPath:link error:NULL]))
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
	else if([DFM createSymbolicLinkAtPath:link withDestinationPath:executable error:NULL])
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
	NSString * directory = [[self iTM2_temporaryDirectory] stringByAppendingPathComponent:@"Unique"];
	NSString * path;
	NSUInteger i = 0;
	do
	{
		NSString * component = [NSString stringWithFormat:@"%u", i++];
		path = [directory stringByAppendingPathComponent:component];
	}
	while([DFM fileExistsAtPath:path] || [DFM destinationOfSymbolicLinkAtPath:path error:NULL]);
	
	if([DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
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
    NSString * path = [self iTM2_temporaryDirectory];
    path = [path stringByAppendingPathComponent:@"default"];
	BOOL isDirectory = NO;
    if([DFM fileExistsAtPath:path isDirectory:&isDirectory])
	{
		if(isDirectory)
		{
			return path;
		}
	}
	else if((![DFM destinationOfSymbolicLinkAtPath:path error:NULL]
			|| [DFM removeItemAtPath:path error:NULL])
				&& [DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL])
	{
		return path;
	}
    iTM2_LOG(@"Directory expected at %@... returning %@ instead", path, [self iTM2_temporaryDirectory]);
	return [self iTM2_temporaryDirectory];
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
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"INFO: Loading the plug-ins of %@...START", self);
	}
	NSString * type = [self plugInPathExtension];
	NSArray * available = [self availablePlugInPathsOfType:type];
	NSMutableArray * paths = [NSMutableArray arrayWithArray:available];
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
									if(iTM2DebugEnabled)
									{
										iTM2_LOG(@"Plug-in: unable to load %@\nRequired class missing: %@ (bundle: %@)", B, requiredClassName, [NSBundle allBundles]);
									}
									break;
								}
							if(canLoad)
							{
								if([B load])
								{
									if(iTM2DebugEnabled)
									{
										iTM2_LOG(@"Plug-in: loaded %@\nPrincipal class: %@\nIf this plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
									}
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
		[B iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO]
				ofType:aType]];
	[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
		[B iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
				ofType:aType]];
	[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
		[B iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
				ofType:aType]];
	[paths addObjectsFromArray:[self availablePlugInPathsAtPath:[B builtInPlugInsPath] ofType:aType]];
	// the frameworks
	NSEnumerator * E = [[NSBundle allFrameworks] objectEnumerator];
	while(B = [E nextObject])
	{
		if(![B isEqual:[NSBundle mainBundle]])
		{
			[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
				[B iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO]
						ofType:aType]];
			[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
				[B iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
						ofType:aType]];
			[paths addObjectsFromArray:[self availablePlugInPathsAtPath:
				[B iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
						ofType:aType]];
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
		[self iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:YES]
				ofType:aType]];
	[paths addObjectsFromArray:[[self class] availablePlugInPathsAtPath:
		[self iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
				ofType:aType]];
	[paths addObjectsFromArray:[[self class] availablePlugInPathsAtPath:
		[self iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
				ofType:aType]];
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
		path = [path iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
	else
		return result;
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:path];
	NSString * component;
	while(component = [DE nextObject])
	{
		if([[component pathExtension] iTM2_pathIsEqual:aType])
		{
			component = [[path stringByAppendingPathComponent:component] iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
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
		if([extension iTM2_pathIsEqual:[self plugInPathExtension]] || [extension isEqualToString:@"framework"])
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
		plugInsDirectoryPath = [self iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO];
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
		plugInsDirectoryPath = [self iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO];
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
		plugInsDirectoryPath = [self iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO];
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
    return *(OSType *)[[[[self infoDictionary] objectForKey:@"CFBundlePackageType"] stringByPaddingToLength:4 withString:@"\0" startingAtIndex:0] cStringUsingEncoding:NSUTF8StringEncoding];
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
    return *(OSType *)[[[[self infoDictionary] objectForKey:@"CFBundleSignature"] stringByPaddingToLength:4 withString:@"\0" startingAtIndex:0] cStringUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addBundlesAtPath:inMutableArray:
+ (void)addBundlesAtPath:(NSString *)path inMutableArray:(NSMutableArray *)mutableArray;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 1
	NSArray * directoryContents = [DFM contentsOfDirectoryAtPath:path error:NULL];
	NSString * component = nil;
	for(component in directoryContents)
	{
		if([component isEqual:@"Contents"] || [component isEqual:@"Resources"])// Application or Frameworks
		{
			path = [path stringByAppendingPathComponent:component];
			directoryContents = [DFM contentsOfDirectoryAtPath:path error:NULL];
			for(component in directoryContents)
			{
				if([component isEqual:@"Info.plist"])
				{
					path = [path stringByDeletingLastPathComponent];
					NSBundle * B = [NSBundle bundleWithPath:path];
					NSDictionary * ID = [B infoDictionary];
					NSString * identifier = [ID objectForKey:(NSString *)kCFBundleIdentifierKey];
					if([identifier length])
					{
						[mutableArray addObject:B];
					}
					return;
				}
			}
			return;
		}
	}
	directoryContents = [DFM contentsOfDirectoryAtPath:path error:NULL];
	for(component in directoryContents)
	{
		component = [path stringByAppendingPathComponent:component];
		[self addBundlesAtPath:component inMutableArray:mutableArray];
	}
#else
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:path];
	NSString * component;
	while(component = [DE nextObject])
	{
		component = [path stringByAppendingPathComponent:component];
		NSBundle * B = [NSBundle bundleWithPath:component];
		NSDictionary * ID = [B infoDictionary];
		NSString * identifier = [ID objectForKey:(NSString *)kCFBundleIdentifierKey];
		if([identifier length])
		{
			[DE skipDescendents];// be shalow if there is an identifier
			[mutableArray addObject:B];
		}
	}
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addBundlesAtPath:inMutableArray:
+ (void)addBundlesAtPath_2:(NSString *)path inMutableArray:(NSMutableArray *)mutableArray;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:path];
	NSString * component;
	while(component = [DE nextObject])
	{
		component = [path stringByAppendingPathComponent:component];
		NSBundle * B = [NSBundle bundleWithPath:component];
		NSDictionary * ID = [B infoDictionary];
		NSString * identifier = [ID objectForKey:(NSString *)kCFBundleIdentifierKey];
		if([identifier length])
		{
			[DE skipDescendents];// be shalow if there is an identifier
			[mutableArray addObject:B];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allBundlesAtPath:
+ (NSArray *)allBundlesAtPath:(NSString *)path;
/*"Description forthcoming. startup fraction 0,25561067801
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![path length])
	{
		return [NSArray array];
	}
	static NSMutableDictionary * bundlesForPath = nil;
	if(!bundlesForPath)
	{
		bundlesForPath = [[NSMutableDictionary dictionary] retain];
	}
	NSMutableArray * result = [bundlesForPath objectForKey:path];
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	[self addBundlesAtPath:path inMutableArray:result];
	[bundlesForPath setObject:result forKey:path];
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
	NSString * path = [self iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:domainMask create:NO];// do not put anything recursive in the plugins folder
    return [NSBundle allBundlesAtPath:path];
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
	NSString * path = [self privateFrameworksPath];
	NSArray * RA = [NSBundle allBundlesAtPath:path];
	[result addObjectsFromArray:RA];
	path = [self sharedFrameworksPath];
	RA = [NSBundle allBundlesAtPath:path];
	[result addObjectsFromArray:RA];
	path = [self builtInPlugInsPath];
	RA = [NSBundle allBundlesAtPath:path];
	[result addObjectsFromArray:RA];
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
		NSArray * paths = [B pathsForBuiltInResource:name ofType:type inDirectory:subpath];
		[result addObjectsFromArray:paths];
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
	NSArray * where = [self embeddedBundles];
	NSArray * RA;
	NSBundle * B;
	for(B in where)
	{
		RA = [B pathsForSupportResource:name ofType:type inDirectory:subpath];
		[result addObjectsFromArray:RA];
	}
	NSString * path;
	where = [self supportBundlesInDomain:NSNetworkDomainMask];
	for(B in where)
	{
		RA = [B pathsForSupportResource:name ofType:type inDirectory:subpath];
		[result addObjectsFromArray:RA];
		path = [B pathForResource:name ofType:type inDirectory:subpath];
		if(path = [B pathForResource:name ofType:type inDirectory:subpath])
		{
			[result addObject:path];
		}
	}
	where = [self supportBundlesInDomain:NSLocalDomainMask];
	for(B in where)
	{
		RA = [B pathsForSupportResource:name ofType:type inDirectory:subpath];
		[result addObjectsFromArray:RA];
		path = [B pathForResource:name ofType:type inDirectory:subpath];
		if(path = [B pathForResource:name ofType:type inDirectory:subpath])
		{
			[result addObject:path];
		}
	}
	if([type isEqualToString:iTM2LocalizedExtension])
	{
		// from preview 13 to 14, folders in the application support directory now are localizable
		// if I am looking for a .localized folder and I just find a not localized one,
		// turn the old into the new...
		where = [self supportBundlesInDomain:NSUserDomainMask];
		NSMutableArray * paths = [NSMutableArray array];
		for(B in where)
		{
			RA = [B pathsForSupportResource:name ofType:@"" inDirectory:subpath domains:NSUserDomainMask];
			[paths addObjectsFromArray:RA];
		}
		for(path in paths)
		{
			NSString * newPath = [path stringByAppendingPathExtension:iTM2LocalizedExtension];
			if([DFM fileExistsAtPath:newPath] || [DFM destinationOfSymbolicLinkAtPath:path error:NULL])
			{
				iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Recycle file at:\n%@", path]), nil);
				if(![SWS performFileOperation:NSWorkspaceRecycleOperation source:[path stringByDeletingLastPathComponent] destination:@"" files:[NSArray arrayWithObject:[path lastPathComponent]] tag:nil])
				{
					iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Failed to recycle file at:\n%@\nWould you do it for me?", path]), nil);
				}
			}
			else if(![DFM moveItemAtPath:path toPath:newPath error:NULL])
			{
				iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Failed to move:\n%@\nto\n%@\nWould you do it for me?", path, newPath]), nil);
			}
		}
	}
	where = [self supportBundlesInDomain:NSUserDomainMask];
	for(B in where)
	{
		RA = [B pathsForSupportResource:name ofType:type inDirectory:subpath];
		[result addObjectsFromArray:RA];
		if(path = [B pathForResource:name ofType:type inDirectory:subpath])
		{
			[result addObject:path];
		}
	}
	// resource in the Application Support, not in any bundle
	RA = [self pathsForSupportResource:name ofType:type inDirectory:subpath domains: NSAllDomainsMask];
	[result addObjectsFromArray:RA];
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
	NSUInteger mask;
	NSString * path = nil;
	NSString * lastComponent = nil;
	NSString * lastName = nil;
	NSString * pathExtension = nil;
	NSMutableArray * result = [NSMutableArray array];
	NSArray * RA = nil;
	if(name)
	{
		name = [name lowercaseString];
		if(type)
		{
			type = [type lowercaseString];
			if(mask = domainMask & NSNetworkDomainMask)
			{
				path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
					for(lastComponent in RA)
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName iTM2_pathIsEqual:name] && [pathExtension iTM2_pathIsEqual:type])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
							[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSLocalDomainMask)
			{
				path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
					for(lastComponent in RA)
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName iTM2_pathIsEqual:name] && [pathExtension iTM2_pathIsEqual:type])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
							[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSUserDomainMask)
			{
				path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
					for(lastComponent in RA)
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName iTM2_pathIsEqual:name] && [pathExtension iTM2_pathIsEqual:type])
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
				path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
					for(lastComponent in RA)
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName iTM2_pathIsEqual:name])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
							[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSLocalDomainMask)
			{
				path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
					for(lastComponent in RA)
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName iTM2_pathIsEqual:name])
						{
							lastName = [path stringByAppendingPathComponent:lastComponent];
							[result addObject:lastName];
						}
					}
				}
			}// if(mask = domainMask & ...)
			if(mask = domainMask & NSUserDomainMask)
			{
				path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
				if([path length])
				{
					RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
					for(lastComponent in RA)
					{
						pathExtension = [lastComponent pathExtension];
						pathExtension = [pathExtension lowercaseString];
						lastName = [lastComponent stringByDeletingPathExtension];
						lastName = [lastName lowercaseString];
						if([lastName iTM2_pathIsEqual:name])
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
			path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
			if([path length])
			{
				RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
				for(lastComponent in RA)
				{
					lastName = [lastComponent lowercaseString];
					lastName = [lastName pathExtension];
					if([lastName iTM2_pathIsEqual:name])
					{
						lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
					}
				}
			}
		}// if(mask = domainMask & ...)
		if(mask = domainMask & NSLocalDomainMask)
		{
			path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
			if([path length])
			{
				RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
				for(lastComponent in RA)
				{
					lastName = [lastComponent lowercaseString];
					lastName = [lastName pathExtension];
					if([lastName iTM2_pathIsEqual:name])
					{
						lastName = [path stringByAppendingPathComponent:lastComponent];
						[result addObject:lastName];
					}
				}
			}
		}// if(mask = domainMask & ...)
		if(mask = domainMask & NSUserDomainMask)
		{
			path = [self iTM2_pathForSupportDirectory:subpath inDomain:mask create:NO];
			if([path length])
			{
				RA = [DFM contentsOfDirectoryAtPath:path error:NULL];
				for(lastComponent in RA)
				{
					lastName = [lastComponent lowercaseString];
					lastName = [lastName pathExtension];
					if([lastName iTM2_pathIsEqual:name])
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
	NSArray * RA = [self pathsForSupportResource:name ofType:type inDirectory:subpath];
	[result addObjectsFromArray:RA];
	RA = [self pathsForBuiltInResource:name ofType:type inDirectory:subpath];
	[result addObjectsFromArray:RA];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allPathsForImageResource:
- (NSArray *)allPathsForImageResource:(NSString *)name;
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
		NSArray * RA = [B allPathsForImageResource:name];
		[result addObjectsFromArray:RA];
	}
	NSString * path = [self pathForImageResource:name];
	if([path length])
	{
		[result addObject:path];
	}
//iTM2_END;
    return result;
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
	NSString * networkPrefix = [mainBundle iTM2_pathForSupportDirectory:@"" inDomain:NSNetworkDomainMask create:NO];
	networkPrefix = [networkPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * localPrefix = [mainBundle iTM2_pathForSupportDirectory:@"" inDomain:NSLocalDomainMask create:NO];
	localPrefix = [localPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * userPrefix = [mainBundle iTM2_pathForSupportDirectory:@"" inDomain:NSUserDomainMask create:NO];
	userPrefix = [userPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	
	NSMutableArray * networkFrameworks = [NSMutableArray array];
	NSMutableArray * localFrameworks = [NSMutableArray array];
	NSMutableArray * userFrameworks = [NSMutableArray array];
	NSMutableArray * otherFrameworks = [NSMutableArray array];
	NSString * P = nil;
	NSEnumerator * E = [frameworks objectEnumerator];
	NSBundle * B = nil;
	for(B in frameworks)
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
	for(B in frameworks)
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
	P = [mainBundle iTM2_pathForSupportDirectory:component inDomain:NSNetworkDomainMask create:NO];
	[anObject performSelector:aSelector withObject:P];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	P = [mainBundle iTM2_pathForSupportDirectory:component inDomain:NSLocalDomainMask create:NO];
	[anObject performSelector:aSelector withObject:P];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	P = [mainBundle iTM2_pathForSupportDirectory:component inDomain:NSUserDomainMask create:YES];
	[anObject performSelector:aSelector withObject:P];
	#undef RELOAD
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
#pragma mark -
#pragma mark ======  Crash Reporter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSLogOutputPath
+ (NSString *)NSLogOutputPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([DFM fileExistsAtPath:_iTM2_NSLogOutputPath])
	{
		return _iTM2_NSLogOutputPath;
	}
	NSArray * libraries = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSLocalDomainMask,NO);
	NSString * library = [libraries lastObject];
	NSNumber * N = [NSNumber numberWithUnsignedInt:getuid()];
	NSString * path = [N description];
	path = [path stringByAppendingPathComponent:@"console"];
	path = [path stringByAppendingPathExtension:@"log"];
	path = [@"Console" stringByAppendingPathComponent:path];
	path = [@"Logs" stringByAppendingPathComponent:path];
	path = [library stringByAppendingPathComponent:path];
    return path;
}
@end

@interface NSApplication_iTM2BundleKit: NSApplication
@end

@implementation NSApplication(iTM2BundleKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2BundleKit_run
- (void)SWZ_iTM2BundleKit_run;
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
	[self SWZ_iTM2BundleKit_run];
	// Don't add code below, it won't ever be reached...
//iTM2_END;
    return;
}
@end

#import <Foundation/NSDebug.h>

void iTM2RedirectNSLogOutput()
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	if(_iTM2_NSLogOutputPath)
	{
		return;
	}
	_iTM2_NSLogOutputPath = @"";
	iTM2_INIT_POOL;
	NSArray * libraries = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	if(![libraries count])
	{
		iTM2_RELEASE_POOL;
		return;
	}
	NSMutableString * logOutput = [NSMutableString string];
#if 0
	This cannot be used because it causes the main application object to be initialized as side effect
	thus preventing the proper document controller to be used
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSString * version = [mainBundle objectForInfoDictionaryKey:@"iTM2SourceVersion"];
	NSString * executable = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleExecutableKey];
#elif 1
	NSProcessInfo * PI = [NSProcessInfo processInfo];
	id components = [PI arguments];
	NSString * bundlePath = [components objectAtIndex:0];
	components = [[[bundlePath pathComponents] mutableCopy] autorelease];
	while(![[components lastObject] isEqual:@"Contents"])
	{
		[components removeLastObject];
	}
	[components removeLastObject];
	[components addObject:@""];
	bundlePath = [NSString iTM2_pathWithComponents:components];
	NSBundle * mainBundle = [NSBundle bundleWithPath:bundlePath];
	NSString * version = [mainBundle objectForInfoDictionaryKey:@"iTM2SourceVersion"];
	NSString * executable = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleExecutableKey];
#else
	NSProcessInfo * PI = [NSProcessInfo processInfo];
	NSArray * arguments = [PI arguments];
	NSString * infoPListPath = [arguments objectAtIndex:0];
	infoPListPath = [infoPListPath stringByDeletingLastPathComponent];
	infoPListPath = [infoPListPath stringByDeletingLastPathComponent];
	infoPListPath = [infoPListPath stringByAppendingPathComponent:@"Info"];
	infoPListPath = [infoPListPath stringByAppendingPathExtension:@"plist"];
	NSDictionary * infoPList = [NSDictionary dictionaryWithContentsOfFile:infoPListPath];
	NSString * version = [infoPList objectForKey:@"iTM2SourceVersion"];
	NSString * executable = [infoPList objectForKey:(NSString *)kCFBundleExecutableKey];
#endif
	if(!version || [version isEqual:@"97531"])
	{
		goto end;
	}
	NSString * logPath = [libraries lastObject];
	logPath = [logPath stringByAppendingPathComponent:@"Logs"];
	logPath = [logPath stringByAppendingPathComponent:executable];
	[DFM createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
	if([DFM iTM2_pushDirectory:logPath])
	{
		NSArray * availableLogs = [DFM contentsOfDirectoryAtPath:logPath error:NULL];
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH[c] 'log'"];
		availableLogs = [availableLogs filteredArrayUsingPredicate:predicate];
		NSMutableArray * MRA = [NSMutableArray array];
		NSString * component;
		NSMutableDictionary * attributes = nil;
		for(component in availableLogs)
		{
			attributes = [[[DFM attributesOfItemAtPath:component error:NULL] mutableCopy] autorelease];
			[attributes setObject:component forKey:@"file name"];
			[MRA addObject:attributes];
		}
		NSSortDescriptor * descriptor  = [[[NSSortDescriptor alloc] initWithKey:NSFileModificationDate ascending:NO] autorelease];
		NSArray * descriptors = [NSArray arrayWithObject:descriptor];
		[MRA sortUsingDescriptors:descriptors];
		NSMutableArray * recycles = [NSMutableArray array];
		while([MRA count]>10)
		{
			attributes = [MRA lastObject];
			[recycles addObject:attributes];
			[MRA removeLastObject];
		}
		for(attributes in recycles)
		{
			NSNumber * N = [attributes objectForKey:NSFileBusy];
			if(![N boolValue])
			{
				component = [attributes objectForKey:@"file name"];
				if(![DFM removeItemAtPath:component error:NULL])
				{
					[logOutput appendFormat:@"could not remove %@/%@\n",logPath,component];
				}
			}
		}
		NSUInteger index = 0;
		do
		{
			component = [NSString stringWithFormat:@"%u",index++];
			component = [component stringByAppendingPathExtension:@"log"];
		}
		while([DFM fileExistsAtPath:component]);
		logPath = [logPath stringByAppendingPathComponent:component];
		const char * file = [logPath fileSystemRepresentation];
		if(freopen(file, "a", stderr))
		{
			_iTM2_NSLogOutputPath = [logPath copy];
		}
		else
		{
			[logOutput appendString:@"No file?\n"];
		}
		[DFM iTM2_popDirectory];
	}
end:
    NSLog(@"Welcome to %@ version %@", executable, version);
	NSString * identifier = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    if(iTM2DebugEnabled)
    {
		NSLog(@"RUNNING IN DEBUG LEVEL %i: more comments are available, at the cost of a performance degradation", iTM2DebugEnabled);
        NSLog(@"Please, set the iTM2DebugEnabled defaults value to '0' if you want to come back to the normal behaviour use one of");
        NSLog(@"terminal%% defaults write %@ iTM2DebugEnabled '0'",identifier);
        NSLog(@"terminal%% defaults delete %@ iTM2DebugEnabled",identifier);
		NSLog(@"Cocoa debug flags: NSDebugEnabled: %@, NSZombieEnabled: %@, NSHangOnUncaughtException: %@",
			(NSDebugEnabled? @"Y": @"N"), (NSZombieEnabled? @"Y": @"N"), (NSHangOnUncaughtException? @"Y": @"N"));
	}
#if 0
	else
    {
		NSLog(@"RUNNING IN 0 DEBUG LEVEL. To have more comments available for debugging purpose");
        NSLog(@"Please, set the iTM2DebugEnabled defaults value to some positive (the higher the more precise):");
        NSLog(@"terminal%% defaults write %@ iTM2DebugEnabled '10000'",identifier);
	}
#endif
	NSLog(@"%@",logOutput);
	iTM2_RELEASE_POOL;
//iTM2_START;
    return;
}

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
    return [[self class] classBundle];
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

@implementation iTM2MainInstaller(BundleKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  runtimeObserveCompleteInstallation
+ (void)runtimeObserveCompleteInstallation;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	//iTM2_START;
	[INC addObserver:[iTM2Runtime class] selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
	//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  runtimeObserveCompleteInstallation
+ (void)prepareRuntimeObserveCompleteInstallation;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	//iTM2_START;
	NSAssert([NSBundle iTM2_swizzleClassMethodSelector:@selector(SWZ_iTM2Bndl_loadNibNamed:owner:)]
			 && [NSBundle iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Bndl_load)]
			 && [NSBundle iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Bndl_pathForAuxiliaryExecutable:)],
			 @"**** HUGE ERROR: no swizzling for NSBundle");
	if(![NSApplication iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2BundleKit_run)])
	{
		iTM2_LOG(@"..........  ERROR: Bad configuration, things won't work as expected...");
	}
	//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
@end

