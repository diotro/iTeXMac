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

NSString * const iTM2BundleDidLoadNotification = @"iTM2BundleDidLoad";

NSString * const iTM2BundleContentsComponent = @"Contents";

#import "iTM2NotificationKit.h"
#import "iTM2Runtime.h"
#import <sys/sysctl.h>
#import <mach/machine.h>

NSString * _NSLogOutputPath4iTM3 = nil;
@implementation NSBundle(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Bndl_load
- (BOOL)SWZ_iTM2Bndl_load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Feb 21 12:49:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.isLoaded) {
		return YES;
    }
	if (self.SWZ_iTM2Bndl_load) {
		[iTM2Runtime flushCache];
		[INC postNotificationName:iTM2BundleDidLoadNotification object:self];
		return YES;
	} else {
		return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Bndl_loadNibNamed:owner:
+ (BOOL)SWZ_iTM2Bndl_loadNibNamed:(NSString *)aNibName owner:(id)owner;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self SWZ_iTM2Bndl_loadNibNamed:aNibName owner:owner]) {
		return YES;
	}
	Class class = [owner class];
	Class superclass;
	while((superclass = [class superclass]) && (superclass != class)) {
		NSBundle * B = [NSBundle bundleForClass:superclass];
		NSURL * url = [B URLForResource:aNibName withExtension:@"nib"];// maybe the resource is not in the class bundle
//LOG4iTM3(@"fileName is: %@", fileName);
		if (url.isFileURL
			&& [B loadNibFile:url.path
				externalNameTable: [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"]
					withZone: [owner zone]])
			return YES;
		class = superclass;
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Bndl_pathForAuxiliaryExecutable:
- (NSString *)SWZ_iTM2Bndl_pathForAuxiliaryExecutable:(NSString *)executableName;
/*"Overriden pethod to add support of frameworks.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
Latest Revision: Fri Jan 29 20:16:28 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * result = [self SWZ_iTM2Bndl_pathForAuxiliaryExecutable:executableName];
	if (result.length) {
		return result;
    } else if ([[NSBundle allFrameworks] containsObject:self]) 	{
		result = [self.bundlePath stringByAppendingPathComponent:executableName];
		if (![DFM isExecutableFileAtPath:result]) {
			result = nil;
        }
	}
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isX86_4iTM3
+ (BOOL)isX86_4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	int cpu_type;
	size_t length = sizeof(cpu_type);
	sysctlbyname("hw.cputype", &cpu_type, &length, NULL, ZER0);
//END4iTM3;
	return cpu_type & ~CPU_ARCH_ABI64 == CPU_TYPE_X86;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  hasABI64_4iTM3
+ (BOOL)hasABI64_4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	int cpu_type;
	size_t length = sizeof(cpu_type);
	sysctlbyname("hw.cputype", &cpu_type, &length, NULL, ZER0);
//END4iTM3;
	return cpu_type | CPU_ARCH_ABI64;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  plugInPathExtension4iTM3
- (NSString *)plugInPathExtension4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"iTM2";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM3FoundationBundle
+ (NSBundle *)iTM3FoundationBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSBundle bundleWithIdentifier:iTM3FoundationBundleIdentifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTeXMac2Bundle
+ (NSBundle *)iTeXMac2Bundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSBundle bundleWithIdentifier:iTeXMac2BundleIdentifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  allURLsForSupportExecutables4iTM3
- (NSArray *)allURLsForSupportExecutables4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 20:26:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSMapTable * cache = nil;
	if (!cache) {
		cache = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsZeroingWeakMemory|NSPointerFunctionsOpaquePersonality
                    valueOptions:NSPointerFunctionsStrongMemory];
	}
	NSMutableArray * result = [cache objectForKey:self];
	if (result) {
		return result;
	}
	[cache setObject:(result = [NSMutableArray array]) forKey:self];
	NSURL * baseURL = nil;
    NSString * component = nil;
    baseURL = [self URLForSupportDirectory4iTM3:iTM2SupportBinaryComponent inDomain:NSNetworkDomainMask create:NO];
	if ([DFM pushDirectory4iTM3:baseURL.path]) {
		for (component in [DFM subpathsAtPath:[DFM currentDirectoryPath]]) {
			if ([DFM isExecutableFileAtPath:component]) {
				[result addObject:[baseURL URLByAppendingPathComponent:component]];
			}
		}
		if (![DFM popDirectory4iTM3]) {
			return result;
		}
	}
    baseURL = [self URLForSupportDirectory4iTM3:iTM2SupportBinaryComponent inDomain:NSLocalDomainMask create:NO];
	if ([DFM pushDirectory4iTM3:baseURL.path]) {
		for (component in [DFM subpathsAtPath:[DFM currentDirectoryPath]]) {
			if ([DFM isExecutableFileAtPath:component]) {
				[result addObject:[baseURL URLByAppendingPathComponent:component]];
			}
		}
		if (![DFM popDirectory4iTM3]) {
			return result;
		}
	}
    baseURL = [self URLForSupportDirectory4iTM3:iTM2SupportBinaryComponent inDomain:NSUserDomainMask create:NO];
	if ([DFM pushDirectory4iTM3:baseURL.path]) {
		for (component in [DFM subpathsAtPath:baseURL.path]) {
			if ([DFM isExecutableFileAtPath:component]) {
				[result addObject:[NSURL URLWithPath4iTM3:component relativeToURL:baseURL]];
			}
		}
		if (![DFM popDirectory4iTM3]) {
			return result;
		}
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  allURLsForSupportScripts4iTM3
- (NSArray *)allURLsForSupportScripts4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 20:57:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSMapTable * cache = nil;
	if (!cache) {
		cache = [NSMapTable mapTableWithWeakToStrongObjects];
	}
	NSMutableArray * result = [cache objectForKey:self];
	if (result) {
		return result;
	}
	[cache setObject:(result = [NSMutableArray array]) forKey:self];
	NSURL * baseURL = nil;
    NSString * component = nil;
    baseURL = [self URLForSupportDirectory4iTM3:iTM2SupportScriptsComponent inDomain:NSNetworkDomainMask create:NO];
	if ([DFM pushDirectory4iTM3:baseURL.path]) {
		for (component in [DFM subpathsAtPath:baseURL.path]) {
			if ([DFM isExecutableFileAtPath:component]) {
				[result addObject:[NSURL URLWithPath4iTM3:component relativeToURL:baseURL]];
			}
		}
		if (![DFM popDirectory4iTM3]) {
			return result;
		}
	}
    baseURL = [self URLForSupportDirectory4iTM3:iTM2SupportScriptsComponent inDomain:NSLocalDomainMask create:NO];
	if ([DFM pushDirectory4iTM3:baseURL.path]) {
		for (component in [DFM subpathsAtPath:baseURL.path]) {
			if ([DFM isExecutableFileAtPath:component]) {
				[result addObject:[NSURL URLWithPath4iTM3:component relativeToURL:baseURL]];
			}
		}
		if (![DFM popDirectory4iTM3]) {
			return result;
		}
	}
    baseURL = [self URLForSupportDirectory4iTM3:iTM2SupportScriptsComponent inDomain:NSUserDomainMask create:NO];
	if ([DFM pushDirectory4iTM3:baseURL.path]) {
		for (component in [DFM subpathsAtPath:baseURL.path]) {
			if ([DFM isExecutableFileAtPath:component]) {
				[result addObject:[NSURL URLWithPath4iTM3:component relativeToURL:baseURL]];
			}
		}
		if (![DFM popDirectory4iTM3]) {
			return result;
		}
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  uniqueApplicationIdentifier4iTM3
- (NSString *)uniqueApplicationIdentifier4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [[NSProcessInfo processInfo] globallyUniqueString];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  temporaryDirectoryURL4iTM3
- (NSURL *)temporaryDirectoryURL4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSURL * baseURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSURL * returnURL = [[NSURL URLWithPath4iTM3:self.uniqueApplicationIdentifier4iTM3 relativeToURL:baseURL]
                            URLByAppendingPathComponent:@""];// force a trailing '/'
    NSError * localError = nil;
    if (![DFM createDirectoryAtPath:returnURL.path withIntermediateDirectories:YES attributes:nil error:&localError]) {
        LOG4iTM3(@"..........  ERROR: Directory expected at %@... returning %@ instead (error: %@)", returnURL.path, NSTemporaryDirectory(), localError);
        return baseURL;
    }
//END4iTM3;
	return returnURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  temporaryBinaryDirectoryURL4iTM3
- (NSURL *)temporaryBinaryDirectoryURL4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 20:43:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSURL * baseURL = self.temporaryDirectoryURL4iTM3;
    NSURL * returnURL = [[NSURL URLWithPath4iTM3:@"bin" relativeToURL:baseURL] URLByAppendingPathComponent:@""];
    NSError * localError = nil;
	if (![DFM createDirectoryAtPath:returnURL.path withIntermediateDirectories:YES attributes:nil error:&localError]) {
        LOG4iTM3(@"..........  ERROR: Directory expected at %@... returning %@ instead (error: %@)", returnURL.path, NSTemporaryDirectory(), localError);
		return baseURL;
	}
//END4iTM3;
	return returnURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  createSymbolicLinkWithExecutableContentURL4iTM3:error:
- (BOOL) createSymbolicLinkWithExecutableContentURL4iTM3:(NSURL *)executableURL error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 20:56:30 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (executableURL.isFileURL) {
        NSURL * binaryDirectoryURL = self.temporaryBinaryDirectoryURL4iTM3;
        NSURL * linkURL = [binaryDirectoryURL URLByAppendingPathComponent:executableURL.lastPathComponent];// no URLByStandardizingPath please
        NSString * path = linkURL.path;
        if (([DFM fileExistsAtPath:path] || [DFM destinationOfSymbolicLinkAtPath:path error:RORef])
                && (![DFM isDeletableFileAtPath:path] || ![DFM removeItemAtPath:path error:RORef])) {
            if (RORef && !*RORef) {
                * RORef = [NSError errorWithDomain:iTM3FoundationErrorDomain code:1 userInfo:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        NSLocalizedStringFromTableInBundle(@"Setup failure", iTM2LocalizedExtension, self.classBundle4iTM3, ""), NSLocalizedDescriptionKey,
                        [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"I CANNOT remove existing file at %@", iTM2LocalizedExtension, self.classBundle4iTM3, ""), path], NSLocalizedFailureReasonErrorKey,
                        [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Remove file at %@", iTM2LocalizedExtension, self.classBundle4iTM3, ""), path], NSLocalizedRecoverySuggestionErrorKey,
                            nil]];
            }
        } else if ([DFM createSymbolicLinkAtPath:path withDestinationPath:executableURL.path error:RORef]) {
            if (iTM2DebugEnabled) {
                LOG4iTM3(@"INFO: new soft link from\n%@\nto %@...", path, executableURL.path);
            }
            return YES;
        } else if (RORef && !*RORef) {
            * RORef = [NSError errorWithDomain:iTM3FoundationErrorDomain code:1 userInfo:
                [NSDictionary dictionaryWithObjectsAndKeys:
                    NSLocalizedStringFromTableInBundle(@"Setup failure", iTM2LocalizedExtension, self.classBundle4iTM3, ""), NSLocalizedDescriptionKey,
                    [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"I CANNOT make a soft link to\n%@\nfrom\n%@", iTM2LocalizedExtension, myBUNDLE, ""), path, executableURL.path], NSLocalizedFailureReasonErrorKey,
                    [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Please make a soft link to\n%@\nfrom\n%@", iTM2LocalizedExtension, myBUNDLE, ""), path, executableURL.path], NSLocalizedRecoverySuggestionErrorKey,
                        nil]];
        }
    }
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  temporaryUniqueDirectoryURL4iTM3
- (NSURL *)temporaryUniqueDirectoryURL4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 21:00:08 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * directoryURL = [self.temporaryDirectoryURL4iTM3 URLByAppendingPathComponent:@"Unique"];
	NSURL * url;
    NSString * path;
	NSUInteger i = ZER0;
	do {
		NSString * component = [NSString stringWithFormat:@"%lu", i++];
		url = [directoryURL URLByAppendingPathComponent:component];
        path = url.path;
	} while ([DFM fileExistsAtPath:path] || [DFM destinationOfSymbolicLinkAtPath:path error:NULL]);
	
	if ([DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]){
		return url;
	} else {
		return self.temporaryDirectoryURL4iTM3;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  defaultWritableFolderURL4iTM3
- (NSURL *)defaultWritableFolderURL4iTM3;
/*"Description forthcoming. Does not check for existence.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
Latest Revision: Fri Jan 29 21:02:38 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSURL * baseURL = self.temporaryDirectoryURL4iTM3;
    NSURL * url = [baseURL URLByAppendingPathComponent:@"default"];
    NSString * path = url.path;
	BOOL isDirectory = NO;
    if ([DFM fileExistsAtPath:path isDirectory:&isDirectory]) {
		if (isDirectory) {
			return url;
		}
	} else if ((![DFM destinationOfSymbolicLinkAtPath:path error:NULL]
			|| [DFM removeItemAtPath:path error:NULL])
				&& [DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL]) {
		return url;
	}
    LOG4iTM3(@"Directory expected at %@... returning %@ instead", path, baseURL);
	return baseURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadPlugIns4iTM3
- (void)loadPlugIns4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
Latest Revision: Fri Jan 29 21:13:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"INFO: Loading the plug-ins of %@...START", self);
	}
	NSString * ext = self.plugInPathExtension4iTM3;
	NSArray * availableURLs = [self availablePlugInURLsWithExtension4iTM3:ext];
	NSMutableArray * URLs = [NSMutableArray arrayWithArray:availableURLs];
	while (YES) {
		for (NSURL * url in [[URLs copy] autorelease]) {
//LOG4iTM3(@"Starting to load plug-in at url: %@", url);
			NSBundle * B = [NSBundle bundleWithURL:url];
			if (B && ![B isLoaded]) {
				NSString * principalClassName = [[B infoDictionary] objectForKey:@"NSPrincipalClass"];
//LOG4iTM3(@"NSPrincipalClass is: %@", principalClassName);
				if (principalClassName.length) {
					if (NSClassFromString(principalClassName)) {
						LOG4iTM3(@"Plug-in ignored at path:\n%@\nPrincipal class conflict (%@)\nThis can be expected behaviour...", url, principalClassName);
						[URLs removeObject:url];
                        continue;
					} else {
						NSString * K = [NSString stringWithFormat:@"iTM2IgnorePlugin_%@", url.lastPathComponent.stringByDeletingPathExtension];
						if ([SUD boolForKey:K]) {
							LOG4iTM3(@"Plug-in at path\n%@ temporarily disabled, you can activate is from the terminal\nterminal% defaults delete comp.text.TeX.iTeXMac2 '%@'", url, K);
						} else {
							NSArray * requiredClasses = [[B infoDictionary] objectForKey:@"iTM2RequiredClasses"];
                            if ([requiredClasses isKindOfClass:[NSArray class]]) {
                                BOOL canLoad = YES;
                                for (NSString * requiredClassName in requiredClasses) {
                                    if (!NSClassFromString(requiredClassName)) {
                                        canLoad = NO;
                                        if (iTM2DebugEnabled) {
                                            LOG4iTM3(@"Plug-in: unable to load %@\nRequired class missing: %@ (bundle: %@)", B, requiredClassName, [NSBundle allBundles]);
                                        }
                                        break;
                                    }
                                }
                                if (canLoad) {
                                    if ([B load]) {
                                        if (iTM2DebugEnabled) {
                                            LOG4iTM3(@"Plug-in: loaded %@\nPrincipal class: %@\nIf this plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
                                        }
                                        [[B principalClass] class];// sends a +load message as expected side effect
                                    } else {
                                        LOG4iTM3(@"Plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
                                    }
                                    [URLs removeObject:url];
                                    continue;
                                } else {
                                    NS_DURING
                                    if ([B load]) {
                                        LOG4iTM3(@"Plug-in: loaded %@\nPrincipal class: %@\nIf this plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
                                        [[B principalClass] class];
                                    } else {
                                        LOG4iTM3(@"Plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
                                    }
                                    NS_HANDLER
                                    LOG4iTM3(@"Plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
                                    NS_ENDHANDLER
                                    [URLs removeObject:url];
                                    continue;
                                }
                            }
						}
					}
				} else if (iTM2DebugEnabled) {
					LOG4iTM3(@"No principal class in bundle: %@", B);
					[URLs removeObject:url];
                    continue;
				}
			} else {
				[URLs removeObject:url];
                continue;
            }
		}
        break;
	}
//LOG4iTM3(@"INFO: Plug-ins loaded.");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= availablePlugInURLsWithExtension4iTM3:
- (NSArray *)availablePlugInURLsWithExtension4iTM3:(NSString *)ext;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * URLs = [NSMutableArray array];
	// all the plug ins
	NSBundle * B = [NSBundle mainBundle];
	[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:
		[B URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO]
				withExtension:ext]];
	[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:
		[B URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
				withExtension:ext]];
	[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:
		[B URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
				withExtension:ext]];
	[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:[B builtInPlugInsURL] withExtension:ext]];
	// the frameworks
	for (NSBundle * bb in [NSBundle allFrameworks]) {
		if (![bb isEqual:B]) {
			[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:
				[bb URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO]
						withExtension:ext]];
			[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:
				[bb URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
						withExtension:ext]];
			[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:
				[bb URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
						withExtension:ext]];
//LOG4iTM3(@"[B builtInPlugInsPath]:%@, B:%@", [B builtInPlugInsPath], B);
			[URLs addObjectsFromArray:[self availablePlugInURLsAtURL4iTM3:[bb builtInPlugInsURL] withExtension:ext]];
		}
	}
//END4iTM3;
    return URLs;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= availablePlugInURLsAtURL4iTM3:withExtension:
- (NSArray *)availablePlugInURLsAtURL4iTM3:(NSURL *)baseURL withExtension:(NSString *)ext;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
Latest Revision: Fri Jan 29 21:27:54 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"path is: %@", path);
    NSMutableArray * result = [NSMutableArray array];
    if (baseURL.isFileURL) {
        baseURL = baseURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;
        NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:baseURL.path];
        for (NSString * component in DE) {
            if ([component.pathExtension pathIsEqual4iTM3:ext]) {
                NSURL * url = [NSURL URLWithPath4iTM3:component relativeToURL:baseURL];
                [result addObject:url];
                if (![[NSBundle bundleWithURL:url] bundleIsWrapper4iTM3]) {
                    [DE skipDescendants];// be shalow
                }
            }
        }
    }
//LOG4iTM3(@"Available plug-ins loaded at path: %@ are %@", path, result);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleForResourceAtURL4iTM3:
- (NSBundle *)bundleForResourceAtURL4iTM3:(NSURL *)baseURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
Latest Revision: Fri Jan 29 21:32:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (baseURL.isFileURL) {
        while (baseURL.lastPathComponent.length>2) {
            //  beware:it must contain regex characters "/.+\..+"
            NSBundle * B = [NSBundle mainBundle];
            if ([baseURL isEqual:[B bundleURL]]) {
                return B;
            }
            NSString * extension = [baseURL pathExtension];
            B = [NSBundle bundleWithURL:baseURL];
            if ([extension pathIsEqual4iTM3:self.plugInPathExtension4iTM3]
                    || [extension pathIsEqual4iTM3:@"framework"]) {
                return B;
            }
            if ([[B infoDictionary] count]) {
                return B;
            }
            baseURL = [baseURL URLByDeletingLastPathComponent];
        }
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= URLsForSupportResource4iTM3:withExtension:subdirectory:domains:
- (NSArray *)URLsForSupportResource4iTM3:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath domains:(NSSearchPathDomainMask)domainMask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
Latest Revision: Fri Jan 29 21:42:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * result = [NSMutableArray array];
	NSURL * url = nil;
    NSBundle * B = nil;
	if (domainMask & NSNetworkDomainMask) {
		url = [self URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO];
		for (url in [self availablePlugInURLsAtURL4iTM3:url withExtension:self.plugInPathExtension4iTM3]) {
			B = [NSBundle bundleWithURL:url];
			url = [B URLForResource:name withExtension:ext subdirectory:subpath];
			if (url.isFileURL) {
				[result addObject:url];
            }
		}
	}
	if (domainMask & NSLocalDomainMask) {
		url = [self URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO];
		for (url in [self availablePlugInURLsAtURL4iTM3:url withExtension:self.plugInPathExtension4iTM3]) {
			B = [NSBundle bundleWithURL:url];
			url = [B URLForResource:name withExtension:ext subdirectory:subpath];
			if (url.isFileURL) {
				[result addObject:url];
            }
		}
	}
	if (domainMask & NSUserDomainMask) {
		url = [self URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:NO];
		for (url in [self availablePlugInURLsAtURL4iTM3:url withExtension:self.plugInPathExtension4iTM3]) {
            B = [NSBundle bundleWithURL:url];
			url = [B URLForResource:name withExtension:ext subdirectory:subpath];
            if (url.isFileURL) {
				[result addObject:url];
            }
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleIsWrapper4iTM3
- (BOOL) bundleIsWrapper4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.infoDictionary objectForKey:@"iTM2BundleIsWrapper"] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleHFSTypeCode4iTM3
- (OSType) bundleHFSTypeCode4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
Latest Revision: Fri Jan 29 21:42:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return *(OSType *)[[[self.infoDictionary objectForKey:@"CFBundlePackageType"] stringByPaddingToLength:4 withString:@"\0" startingAtIndex:ZER0] cStringUsingEncoding:NSUTF8StringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleHFSCreatorCode4iTM3
- (OSType) bundleHFSCreatorCode4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
Latest Revision: Fri Jan 29 21:42:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return *(OSType *)[[[self.infoDictionary objectForKey:@"CFBundleSignature"] stringByPaddingToLength:4 withString:@"\0" startingAtIndex:ZER0] cStringUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addBundlesAtURL4iTM3:inMutableArray:
+ (void)addBundlesAtURL4iTM3:(NSURL *)baseURL inMutableArray:(NSMutableArray *)mutableArray;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
Latest Revision: Fri Jan 29 21:43:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSParameterAssert(baseURL);
    NSBundle * B = [NSBundle bundleWithURL:baseURL];
    NSDictionary * ID = [B infoDictionary];
    NSString * identifier = [ID objectForKey:(NSString *)kCFBundleIdentifierKey];
    if (identifier.length) {
        [mutableArray addObject:B];
    } else if (baseURL.isFileURL) {
        //  scan all the subdirectories
        for (NSString * pathComponent in [DFM contentsOfDirectoryAtPath:baseURL.path error:NULL]) {
            NSURL * url = [baseURL URLByAppendingPathComponent:pathComponent];
            [self addBundlesAtURL4iTM3:url inMutableArray:mutableArray];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allBundlesAtURL4iTM3:
+ (NSArray *)allBundlesAtURL4iTM3:(NSURL *)URL;
/*"Description forthcoming. startup fraction ZER0,25561067801
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
Latest Revision: Fri Jan 29 21:44:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!URL.isFileURL) {
		return [NSArray array];
	}
	static NSMutableDictionary * cachedBundles = nil;
	if (!cachedBundles) {
		cachedBundles = [[NSMutableDictionary dictionary] retain];
	}
    NSString * path = URL.path;
	NSMutableArray * result = [cachedBundles objectForKey:path];
	if (result) {
		return result;
	}
	result = [NSMutableArray array];
	[self addBundlesAtURL4iTM3:URL inMutableArray:result];
	[cachedBundles setObject:result forKey:path];
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  supportBundlesInDomain4iTM3:
- (NSArray *)supportBundlesInDomain4iTM3:(NSSearchPathDomainMask) domainMask;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSURL * URL = [self URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:domainMask create:NO];
    //  do not put anything recursive in the plugins folder
    //  The bundles in the plug ins folder are shallow, they do not contain included plugins
    return [NSBundle allBundlesAtURL4iTM3:URL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= embeddedBundles4iTM3
- (NSArray *)embeddedBundles4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 21:47:12 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * result = [NSMutableArray array];
	NSURL * url = self.privateFrameworksURL;
	NSArray * RA = [NSBundle allBundlesAtURL4iTM3:url];
	[result addObjectsFromArray:RA];
	url = self.sharedFrameworksURL;
	RA = [NSBundle allBundlesAtURL4iTM3:url];
	[result addObjectsFromArray:RA];
	url = self.builtInPlugInsURL;
	RA = [NSBundle allBundlesAtURL4iTM3:url];
	[result addObjectsFromArray:RA];
//END4iTM3;
	return result;
}
#if 0
- (NSArray *)URLsForDirectory:(NSSearchPathDirectory)directory inDomains:(NSSearchPathDomainMask)domainMask AVAILABLE_MAC_OS_X_VERSION_10_6_AND_LATER;

/* -URLForDirectory:inDomain:appropriateForURL:create:error: is a URL-based replacement for FSFindFolder(). It allows for the specification and (optional) creation of a specific directory for a particular purpose (e.g. the replacement of a particular item on disk, or a particular Library directory.
 
    You may pass only one of the values from the NSSearchPathDomainMask enumeration, and you may not pass NSAllDomainsMask.
 */
- (NSURL *)URLForDirectory:(NSSearchPathDirectory)directory inDomain:(NSSearchPathDomainMask)domain appropriateForURL:(NSURL *)url create:(BOOL)shouldCreate error:(NSError **)error AVAILABLE_MAC_OS_X_VERSION_10_6_AND_LATER;
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= URLsForBuiltInResource4iTM3:withExtension:subdirectory:
- (NSArray *)URLsForBuiltInResource4iTM3:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 21:50:47 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * result = [NSMutableArray array];
	for (NSBundle * B in self.embeddedBundles4iTM3) {
		NSArray * URLs = [B URLsForBuiltInResource4iTM3:name withExtension:ext subdirectory:subpath];
		[result addObjectsFromArray:URLs];
	}
	if (!ext.length) {
		ext = [name pathExtension];
		name = name.stringByDeletingPathExtension;
	}
	NSURL * url = [self URLForResource:name withExtension:ext subdirectory:subpath];
	if (url.isFileURL) {
		[result addObject:url];
    }
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= URLsForSupportResource4iTM3:withExtension:subdirectory:
- (NSArray *)URLsForSupportResource4iTM3:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 22:01:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!ext.length) {
		ext = [name pathExtension];
		name = name.stringByDeletingPathExtension;
	}
	NSMutableArray * result = [NSMutableArray array];
	NSArray * RA = nil;
	NSBundle * B = nil;
	for (B in self.embeddedBundles4iTM3) {
		RA = [B URLsForSupportResource4iTM3:name withExtension:ext subdirectory:subpath];
		[result addObjectsFromArray:RA];
	}
	NSURL * url = nil;
	for (B in [self supportBundlesInDomain4iTM3:NSNetworkDomainMask]) {
		RA = [B URLsForSupportResource4iTM3:name withExtension:ext subdirectory:subpath];
		[result addObjectsFromArray:RA];
		if ((url = [B URLForResource:name withExtension:ext subdirectory:subpath])) {
			[result addObject:url];
		}
	}
	for (B in [self supportBundlesInDomain4iTM3:NSLocalDomainMask]) {
		RA = [B URLsForSupportResource4iTM3:name withExtension:ext subdirectory:subpath];
		[result addObjectsFromArray:RA];
		if ((url = [B URLForResource:name withExtension:ext subdirectory:subpath])) {
			[result addObject:url];
		}
	}
	if ([ext isEqualToString:iTM2LocalizedExtension]) {
		// from preview 13 to 14, folders in the application support directory now are localizable
		// if I am looking for a .localized folder and I just find a not localized one,
		// turn the old into the new...
		NSMutableArray * URLs = [NSMutableArray array];
		for (B in [self supportBundlesInDomain4iTM3:NSUserDomainMask]) {
			RA = [B URLsForSupportResource4iTM3:name withExtension:@"" subdirectory:subpath domains:NSUserDomainMask];
			[URLs addObjectsFromArray:RA];
		}
		for (url in URLs) {
			NSURL * newURL = [url URLByAppendingPathExtension:iTM2LocalizedExtension];
            NSString * path = url.path;
            NSString * newPath = newURL.path;
			if ([DFM fileExistsAtPath:newPath] || [DFM destinationOfSymbolicLinkAtPath:path error:NULL]) {
				REPORTERROR4iTM3(1, ([NSString stringWithFormat:@"Recycle file at:\n%@", path]), nil);
				if (![SWS performFileOperation:NSWorkspaceRecycleOperation
                    source:path.stringByDeletingLastPathComponent destination:@""
                        files:[NSArray arrayWithObject:path.lastPathComponent] tag:nil]) {
					REPORTERROR4iTM3(1, ([NSString stringWithFormat:@"Failed to recycle file at:\n%@\nWould you do it for me?", path]), nil);
				}
			} else if (![DFM moveItemAtPath:path toPath:newPath error:NULL]) {
				REPORTERROR4iTM3(1, ([NSString stringWithFormat:@"Failed to move:\n%@\nto\n%@\nWould you do it for me?", path, newPath]), nil);
			}
		}
	}
	for(B in [self supportBundlesInDomain4iTM3:NSUserDomainMask]) {
		RA = [B URLsForSupportResource4iTM3:name withExtension:ext subdirectory:subpath];
		[result addObjectsFromArray:RA];
		if ((url = [B URLForResource:name withExtension:ext subdirectory:subpath])) {
			[result addObject:url];
		}
	}
	// resource in the Application Support, not in any bundle
	RA = [self URLsForSupportResource4iTM3:name withExtension:ext subdirectory:subpath domains: NSAllDomainsMask];
	[result addObjectsFromArray:RA];
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allURLsForResource4iTM3:withExtension:subdirectory:
- (NSArray *)allURLsForResource4iTM3:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 22:27:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!ext.length) {
		ext = [name pathExtension];
		name = name.stringByDeletingPathExtension;
	}
	NSMutableArray * result = [NSMutableArray array];
	NSArray * RA = [self URLsForSupportResource4iTM3:name withExtension:ext subdirectory:subpath];
	[result addObjectsFromArray:RA];
	RA = [self URLsForBuiltInResource4iTM3:name withExtension:ext subdirectory:subpath];
	[result addObjectsFromArray:RA];
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allURLsForResource4iTM3:withExtension:
- (NSArray *)allURLsForResource4iTM3:(NSString *)component withExtension:(NSString *)ext;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/05/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self allURLsForResource4iTM3:component withExtension:ext subdirectory:@""];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= allURLsForImageResource4iTM3:
- (NSArray *)allURLsForImageResource4iTM3:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 22:27:09 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * result = [NSMutableArray array];
	for (NSBundle * B in self.embeddedBundles4iTM3) {
		NSArray * RA = [B allURLsForImageResource4iTM3:name];
		[result addObjectsFromArray:RA];
	}
	NSURL * url = [self URLForImageResource:name];
	if (url.isFileURL) {
        [result addObject:url];
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bundleForClass4iTM3:localizedStringForKey:value:table:
+ (NSString *)bundleForClass4iTM3:(Class)aClass localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 22:27:02 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSBundle * bundle = [NSBundle bundleForClass:aClass];
	NSString * candidate = [bundle localizedStringForKey:key value:@"___" table:tableName];
	if ([candidate isEqualToString:@"___"]) 	{
		Class superclass = [aClass superclass];
		if (aClass == superclass) {
			return value;
		}
		return [self bundleForClass4iTM3:superclass localizedStringForKey:key value:value table:tableName];
	}
//END4iTM3;
	return candidate;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeObject4iTM3:performSelector:withOrderedBundleURLsForComponent:
+ (void) makeObject4iTM3:(id)anObject performSelector:(SEL)aSelector withOrderedBundleURLsForComponent:(NSString *)component;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 22:26:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	NSParameterAssert([anObject respondsToSelector:aSelector]);
	INIT_POOL4iTM3;
//START4iTM3;
	// read the built in stuff
	// inside frameworks then bundles.
	NSArray * frameworks = [NSBundle allFrameworks];
	NSMutableArray * plugins = [NSMutableArray arrayWithArray:[NSBundle allBundles]];
	[plugins removeObjectsInArray:frameworks];// plugins are bundles
	NSBundle * mainBundle = [NSBundle mainBundle];
	[plugins removeObject:mainBundle];// plugins are bundles, except the main one
	// sorting the frameworks and plugins
	// separating them according to their domain
	NSURL * networkPrefixURL = [mainBundle URLForSupportDirectory4iTM3:@"" inDomain:NSNetworkDomainMask create:NO];
	networkPrefixURL = [networkPrefixURL URLByAppendingPathComponent:@""];
	NSURL * localPrefixURL = [mainBundle URLForSupportDirectory4iTM3:@"" inDomain:NSLocalDomainMask create:NO];
	localPrefixURL = [localPrefixURL URLByAppendingPathComponent:@""];
	NSURL * userPrefixURL = [mainBundle URLForSupportDirectory4iTM3:@"" inDomain:NSUserDomainMask create:NO];
	userPrefixURL = [userPrefixURL URLByAppendingPathComponent:@""];
	
	NSMutableArray * networkFrameworks = [NSMutableArray array];
	NSMutableArray * localFrameworks = [NSMutableArray array];
	NSMutableArray * userFrameworks = [NSMutableArray array];
	NSMutableArray * otherFrameworks = [NSMutableArray array];

	NSString * P = nil;
	NSBundle * B = nil;
	for (B in frameworks) {
		P = [B bundlePath];
		if ([P hasPrefix:userPrefixURL.path]) {
			[userFrameworks addObject:B];
		} else if ([P hasPrefix:localPrefixURL.path]) {
			[localFrameworks addObject:B];
		} else if ([P hasPrefix:networkPrefixURL.path]) {
			[networkFrameworks addObject:B];
		} else {
			[otherFrameworks addObject:B];
        }
	}
	NSMutableArray * networkPlugIns = [NSMutableArray array];
	NSMutableArray * localPlugIns = [NSMutableArray array];
	NSMutableArray * userPlugIns = [NSMutableArray array];
	NSMutableArray * otherPlugIns = [NSMutableArray array];
	for(B in plugins) {
		P = [B bundlePath];
		if ([P hasPrefix:userPrefixURL.path]) {
			[userPlugIns addObject:B];
		} else if ([P hasPrefix:localPrefixURL.path]) {
			[localPlugIns addObject:B];
		} else if ([P hasPrefix:networkPrefixURL.path]) {
			[networkPlugIns addObject:B];
		} else {
			[otherPlugIns addObject:B];
        }
	}
	// reload
    NSURL * url;
	#define RELOAD(ARRAY)\
	for (B in ARRAY) {\
		url = [B URLForResource:component withExtension:nil];\
		[anObject performSelector:aSelector withObject:url];\
	}
	RELOAD(otherFrameworks);
	RELOAD(otherPlugIns);
	url = [mainBundle URLForResource:component withExtension:nil];
	[anObject performSelector:aSelector withObject:url];
	RELOAD(networkFrameworks);
	RELOAD(networkPlugIns);
	url = [mainBundle URLForSupportDirectory4iTM3:component inDomain:NSNetworkDomainMask create:NO];
	[anObject performSelector:aSelector withObject:url];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	url = [mainBundle URLForSupportDirectory4iTM3:component inDomain:NSLocalDomainMask create:NO];
	[anObject performSelector:aSelector withObject:url];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	url = [mainBundle URLForSupportDirectory4iTM3:component inDomain:NSUserDomainMask create:YES];
	[anObject performSelector:aSelector withObject:url];
	#undef RELOAD
//END4iTM3;
	return;
}
#pragma mark -
- (NSURL *)SWZ_iTM2Bndl_URLForResource:(NSString *)name withExtension:(NSString *)ext;
{
    NSURL * result = [self SWZ_iTM2Bndl_URLForResource:(NSString *)name withExtension:(NSString *)ext];
    if (result.isFileURL) {
        if (![DFM fileExistsAtPath:result.path]) {
            NSLog(@"==> Bug, the cocoa returned URL %@ points to nothing, returning nil instead",result);
            return nil;
        }
        return result;
    }
    for (result in [self URLsForResourcesWithExtension:ext subdirectory:nil]) {
        if ([result.lastPathComponent.stringByDeletingPathExtension isEqualToString:name]) {
            NSLog(@"==> Bug, cocoa unexpectedly returned nil instead of %@",result);
            return result;
        }
    }
    return nil;
}
- (NSURL *)SWZ_iTM2Bndl_URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath;
{
    NSURL * result = [self SWZ_iTM2Bndl_URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath];
    if (result.isFileURL) {
        if (![DFM fileExistsAtPath:result.path]) {
            NSLog(@"==> Bug, the cocoa returned URL %@ points to nothing, returning nil instead",result);
            return nil;
        }
        return result;
    }
    for (result in [self URLsForResourcesWithExtension:ext subdirectory:subpath]) {
        if ([result.lastPathComponent.stringByDeletingPathExtension isEqualToString:name]) {
            NSLog(@"==> Bug, cocoa unexpectedly returned nil instead of %@",result);
            return result;
        }
    }
    return nil;
}
- (NSURL *)SWZ_iTM2Bndl_URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath localization:(NSString *)localizationName;
{
    NSURL * result = [self SWZ_iTM2Bndl_URLForResource:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath localization:(NSString *)localizationName];
    if (result.isFileURL) {
        if (![DFM fileExistsAtPath:result.path]) {
            NSLog(@"==> Bug, the cocoa returned URL %@ points to nothing, returning nil instead",result);
            return nil;
        }
        return result;
    }
    for (result in [self URLsForResourcesWithExtension:ext subdirectory:subpath localization:(NSString *)localizationName]) {
        if ([result.lastPathComponent.stringByDeletingPathExtension isEqualToString:name]) {
            NSLog(@"==> Bug, cocoa unexpectedly returned nil instead of %@",result);
            return result;
        }
    }
    return nil;
}
#if 0
- (NSURL *)URLForResource4iTM3:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath;
- (NSURL *)URLForResource4iTM3:(NSString *)name withExtension:(NSString *)ext subdirectory:(NSString *)subpath localization:(NSString *)localizationName;
#endif
#pragma mark -
#pragma mark ======  Crash Reporter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSLogOutputPath4iTM3
+ (NSString *)NSLogOutputPath4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 22:54:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([DFM fileExistsAtPath:_NSLogOutputPath4iTM3]) {
		return _NSLogOutputPath4iTM3;
	}
	NSArray * libraries = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSLocalDomainMask,NO);
	NSString * library = libraries.lastObject;
	NSNumber * N = [NSNumber numberWithUnsignedInteger:getuid()];
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	// this must occur very early, the stuff in the bundles will be correctly coded
//LOG4iTM3(@".....     START: LOAD THE BUNDLES");
	NSBundle.mainBundle.loadPlugIns4iTM3;
//LOG4iTM3(@".....     END:   LOAD THE BUNDLES");
	if (iTM2DebugEnabled) {
		[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], @"NSShowNonLocalizedStrings", nil]];
	}
	RELEASE_POOL4iTM3;
	[self SWZ_iTM2BundleKit_run];
	// Don't add code below, it won't ever be reached...
//END4iTM3;
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
//START4iTM3;
	if (_NSLogOutputPath4iTM3) {
		return;
	}
	_NSLogOutputPath4iTM3 = @"";
	INIT_POOL4iTM3;
	NSArray * libraries = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	if (!libraries.count)
	{
		RELEASE_POOL4iTM3;
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
	NSString * bundlePath = [PI.arguments objectAtIndex:ZER0];
	NSMutableArray * components = [[[bundlePath pathComponents] mutableCopy] autorelease];
	while(![components.lastObject isEqual:@"Contents"]) {
		[components removeLastObject];
	}
	[components removeLastObject];
	[components addObject:@""];
	bundlePath = [NSString pathWithComponents4iTM3:components];
	NSBundle * mainBundle = [NSBundle bundleWithPath:bundlePath];
	NSString * version = [mainBundle objectForInfoDictionaryKey:@"iTM2SourceVersion"];
	NSString * executable = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleExecutableKey];
#else
	NSProcessInfo * PI = [NSProcessInfo processInfo];
	NSArray * arguments = [PI arguments];
	NSString * infoPListPath = [arguments objectAtIndex:ZER0];
	infoPListPath = infoPListPath.stringByDeletingLastPathComponent;
	infoPListPath = infoPListPath.stringByDeletingLastPathComponent;
	infoPListPath = [infoPListPath stringByAppendingPathComponent:@"Info"];
	infoPListPath = [infoPListPath stringByAppendingPathExtension:@"plist"];
	NSDictionary * infoPList = [NSDictionary dictionaryWithContentsOfFile:infoPListPath];
	NSString * version = [infoPList objectForKey:@"iTM2SourceVersion"];
	NSString * executable = [infoPList objectForKey:(NSString *)kCFBundleExecutableKey];
#endif
	if (!version || [version isEqual:@"97531"])
	{
		goto end;
	}
	NSString * logPath = libraries.lastObject;
	logPath = [logPath stringByAppendingPathComponent:@"Logs"];
	logPath = [logPath stringByAppendingPathComponent:executable];
	[DFM createDirectoryAtPath:logPath withIntermediateDirectories:YES attributes:nil error:nil];
	if ([DFM pushDirectory4iTM3:logPath])
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
		while(MRA.count>10)
		{
			attributes = MRA.lastObject;
			[recycles addObject:attributes];
			[MRA removeLastObject];
		}
		for(attributes in recycles)
		{
			NSNumber * N = [attributes objectForKey:NSFileBusy];
			if (![N boolValue])
			{
				component = [attributes objectForKey:@"file name"];
				if (![DFM removeItemAtPath:component error:NULL])
				{
					[logOutput appendFormat:@"could not remove %@/%@\n",logPath,component];
				}
			}
		}
		NSUInteger index = ZER0;
		do
		{
			component = [NSString stringWithFormat:@"%u",index++];
			component = [component stringByAppendingPathExtension:@"log"];
		}
		while([DFM fileExistsAtPath:component]);
		logPath = [logPath stringByAppendingPathComponent:component];
		const char * file = [logPath fileSystemRepresentation];
		if (freopen(file, "a", stderr))
		{
			_NSLogOutputPath4iTM3 = [logPath copy];
		}
		else
		{
			[logOutput appendString:@"No file?\n"];
		}
		[DFM popDirectory4iTM3];
	}
end:
    NSLog(@"Welcome to %@ version %@", executable, version);
	NSString * identifier = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    if (iTM2DebugEnabled)
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
		NSLog(@"RUNNING IN ZER0 DEBUG LEVEL. To have more comments available for debugging purpose");
        NSLog(@"Please, set the iTM2DebugEnabled defaults value to some positive (the higher the more precise):");
        NSLog(@"terminal%% defaults write %@ iTM2DebugEnabled '10000'",identifier);
	}
#endif
	NSLog(@"%@",logOutput);
	RELEASE_POOL4iTM3;
//START4iTM3;
    return;
}

@implementation NSObject(iTM2BundleKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classBundle4iTM3
+ (NSBundle *)classBundle4iTM3;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
    return [NSBundle bundleForClass:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classBundle4iTM3
- (NSBundle *)classBundle4iTM3;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
    return [self.class classBundle4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  localizedDescription4iTM3
+ (NSString *)localizedDescription4iTM3;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
    NSBundle * B = [NSBundle bundleForClass:self];
    return NSLocalizedStringFromTableInBundle(self.description,self.tableName4iTM3, B, "Locale name of a distribution");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  localizedDescription4iTM3
- (NSString *)localizedDescription4iTM3;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
    NSBundle * B = [NSBundle bundleForClass:self.class];
    return NSLocalizedStringFromTableInBundle(self.description,self.tableName4iTM3, B, "Locale name of a distribution");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableName4iTM3
+ (NSString *)tableName4iTM3;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
    return @"default";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableName4iTM3
- (NSString *)tableName4iTM3;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
    //START4iTM3;
    return @"default";
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSBundle(iTeXMac2)

#if 0
#pragma mark -

int
     sysctlbyname(const char *name, void *oldp, size_t *oldlenp, void *newp,
         size_t newlen);

static int sysctlbyname_with_pid (const char *name, pid_t pid, 
                            void *oldp, size_t *oldlenp, 
                            void *newp, size_t newlen)
{
    if (pid == ZER0) {
        if (sysctlbyname(name, oldp, oldlenp, newp, newlen) == -1)  {
            fprintf(stderr, "sysctlbyname_with_pid(ZER0): sysctlbyname  failed:"
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
    return ZER0;
}
int is_pid_native (pid_t pid)
{
    int ret = ZER0;
    size_t sz = sizeof(ret);
 
    if (sysctlbyname_with_pid("sysctl.proc_native", pid, 
                &ret, &sz, NULL, ZER0) == -1) {
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  runtimeObserveCompleteInstallation4iTM3
+ (void)runtimeObserveCompleteInstallation4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
	//START4iTM3;
	[INC addObserver:[iTM2Runtime class] selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
	//END4iTM3;
	RELEASE_POOL4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  runtimeObserveCompleteInstallation4iTM3
+ (void)prepareRuntimeObserveCompleteInstallation4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
	//START4iTM3;
	NSAssert([NSBundle swizzleClassMethodSelector4iTM3:@selector(SWZ_iTM2Bndl_loadNibNamed:owner:) error:NULL]
			 && [NSBundle swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Bndl_load) error:NULL]
//			 && [NSBundle swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Bndl_URLForResource:withExtension:) error:NULL]
//			 && [NSBundle swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Bndl_URLForResource:withExtension:subdirectory:) error:NULL]
//			 && [NSBundle swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Bndl_URLForResource:withExtension:subdirectory:localization:) error:NULL]
			 && [NSBundle swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Bndl_pathForAuxiliaryExecutable:) error:NULL],
                @"**** HUGE ERROR: no swizzling for NSBundle");
	if (![NSApplication swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2BundleKit_run) error:NULL]) {
		LOG4iTM3(@"..........  ERROR: Bad configuration, things won't work as expected...");
	}
	//END4iTM3;
	RELEASE_POOL4iTM3;
	return;
}
@end

