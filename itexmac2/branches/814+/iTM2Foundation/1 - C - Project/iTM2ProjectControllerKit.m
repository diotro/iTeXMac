/*
//
//  @version Subversion: $Id: iTM2ProjectControllerKit.m 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License,or any later version,modified by the addendum below.
//  This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not,write to the Free Software
//  Foundation,Inc.,59 Temple Place - Suite 330,Boston,MA 02111-1307,USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)")
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import "iTM2ProjectControllerKit.h"
#import "iTM2ProjectDocumentKit.h"
#import "iTM2InfoWrapperKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2BundleKit.h"
//#import "iTM2ResponderKit.h"
#import "iTM2WindowKit.h"
#import "iTM2MenuKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2StringFormatKit.h"
#import "iTM2ContextKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2Runtime.h"
#import "iTM2EventKit.h"
#import "iTM2ViewKit.h"
#import "iTM2FileManagerKit.h"
#import "ICURegEx.h"

//#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2TextDocumentKit.h"
#import "iTM2Invocation.h"
#import "iTM2DocumentControllerKit.h"

NSString * const iTM2ProjectComponent = @"Project";
NSString * const iTM2ProjectPlistPathExtension = @"plist";
NSString * const iTM2ProjectDefaultName = @"Default";
NSString * const TWSFactoryExtension = @"iTM2-Factory";

NSString * const iTM2ProjectContextDidChangeNotification = @"iTM2ProjectContextDidChange";
NSString * const iTM2ProjectCurrentDidChangeNotification = @"iTM2CurrentProjectDidChange";

NSString * const iTM3ProjectPreferWrappers = @"Project Prefer Wrappers";

@interface iTM2ProjectController(CreateNewProject)
- (id)getOpenProjectForURL:(NSURL *)fileURL;
- (id)getBaseProjectForURL:(NSURL *)fileURL;
- (id)getProjectInWrapperForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)geWritableProjectInWrapperForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getProjectInHierarchyForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (Class)createNewProjectPanelControllerClass;
@end

@interface iTM2NewProjectController: iTM2Inspector
{
@private
	id _FileURL4iTM3;
	id _NewProjectName4iTM3;
	id _ProjectDirURL4iTM3;
	id _Projects4iTM3;
    id _AvailableProjects4iTM3;
	NSInteger _SelectedRow4iTM3;
	NSInteger _ToggleProjectMode4iTM3;
	BOOL _IsAlreadyDirectoryWrapper4iTM3;
	BOOL _IsDirectoryWrapper4iTM3;// should be replaced by the SUD
}
- (NSURL *)projectURL;
- (NSURL *)projectDirURL;
- (void)setUpProject:(id)projectDocument;

@property (readwrite,retain) NSURL * fileURL;
@property (readwrite,copy) NSString * newProjectName;
@property (readwrite,retain) NSURL * projectDirURL;
@property (readwrite,retain) NSMutableArray * projects;
@property (readwrite,retain) NSMutableArray * availableProjects;
@property (readwrite,assign) NSInteger selectedRow;
@property (readwrite,assign) NSInteger toggleProjectMode;
@property (readwrite,assign) BOOL isAlreadyDirectoryWrapper;
@property (readwrite,assign) BOOL isDirectoryWrapper;
@end

NSString * const iTM3ProjectWritableProjectsComponent = @"Writable Projects.localized";

@implementation iTM2MainInstaller(ProjectController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ProjectMigratorCompleteInstallation4iTM3
+ (void)iTM2ProjectMigratorCompleteInstallation4iTM3;
/*"Change the old faraway project design to the new cached one.
The old faraway project design was used until build 689.
It has been changed to fulfill Time Machine requirements and some weak design choices.
This message is sent at global initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 15:38:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// purpose: move the whole ~me/Library/Application\ Support/iTeXMac2/Projects.put_aside
	// to ~me/Library/Application\ Support/iTeXMac2/Writable Projects.localized
	// First, do I really need to migrate ?
    BOOL removeAll = YES;
	NSURL * theOldSupportURL = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:@"Projects.put_aside" inDomain:NSUserDomainMask create:NO];
	if (!theOldSupportURL.isFileURL || ![DFM fileExistsAtPath:theOldSupportURL.path]) {
		return; // nothing to migrate
	}
	NSURL * theNewSupportURL = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:iTM3ProjectWritableProjectsComponent inDomain:NSUserDomainMask create:YES];
    NSDirectoryEnumerator * DE = [DFM enumeratorAtURL:theOldSupportURL
        includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLTypeIdentifierKey,nil]
            options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
	NSString * wrapperType = [SDC wrapperDocumentType4iTM3];
    for (NSURL * theOldWrapperURL in DE) {
        NSString * theUTI = nil;
        [theOldWrapperURL getResourceValue:&theUTI forKey:NSURLTypeIdentifierKey error:NULL];
        if ([theUTI conformsToUTType4iTM3:wrapperType]) {
            [DE skipDescendants];
            NSURL * theOldProjectURL = theOldWrapperURL.enclosedProjectURLs4iTM3.lastObject;
            if((theOldProjectURL)) {
                NSString * theRelativePath = nil;
                for (NSString * fileKey in [SPC fileKeysWithFilter:iTM2PCFilterRegular inProjectWithURL:theOldProjectURL]) {
                    [SPC URLForFileKey:fileKey filter:iTM2PCFilterRegular inProjectWithURL:theOldProjectURL];// side effect: some kind of consistency test
                }
                theRelativePath = [theOldWrapperURL pathRelativeToURL4iTM3:theOldSupportURL];
                NSURL * theNewWrapperURL = [NSURL URLWithPath4iTM3:theRelativePath relativeToURL:theNewSupportURL];
                BOOL isDirectory = NO;
                if (![DFM fileExistsAtPath:theNewWrapperURL.path isDirectory:&isDirectory]) {
                    //  simply move the old wrapper to the new location
                    [DFM moveItemAtURL:theOldWrapperURL toURL:theNewWrapperURL error:NULL];
                    continue;
                } else if (!isDirectory) {
                    removeAll = removeAll && [DFM removeItemAtURL:theNewWrapperURL error:NULL] && [DFM moveItemAtURL:theOldWrapperURL toURL:theNewWrapperURL error:NULL];
                    continue;
                }
                //  there is already a directory at theNewWrapperURL
                theRelativePath = [theOldProjectURL pathRelativeToURL4iTM3:theOldSupportURL];
                NSURL * theNewProjectURL = [NSURL URLWithPath4iTM3:theRelativePath relativeToURL:theNewSupportURL];
                if (![DFM fileExistsAtPath:theNewProjectURL.path]) {
                    //  simply move the old project to the new location, create the directory where the item will move first
                    removeAll = removeAll && [DFM createDirectoryAtPath:theNewProjectURL.path.stringByDeletingLastPathComponent
                        withIntermediateDirectories:YES
                            attributes:nil error:NULL]
                        &&  [DFM moveItemAtURL:theOldProjectURL toURL:theNewProjectURL error:NULL];
                    continue;
                }
                //  there is a file at the destination URL
                //  keep the most recent and throw away the oldest one
                NSDate * theOldDate = [[DFM attributesOfItemAtPath:theOldProjectURL.path error:NULL] fileModificationDate];
                NSDate * theNewDate = [[DFM attributesOfItemAtPath:theNewProjectURL.path error:NULL] fileModificationDate];
                if (nil == theNewDate || ([theNewDate compare:theOldDate] == NSOrderedAscending)) {
                    removeAll = removeAll && [DFM moveItemAtURL:theOldProjectURL toURL:theNewProjectURL error:NULL];
                }
            }
        }
    }
    if (removeAll) {
        [DFM removeItemAtURL:theOldSupportURL error:NULL];
    }
	MILESTONE4iTM3((@"iTM2 Project Migrator"),(@"Project Migration Missing"));
    [SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:iTM3ProjectPreferWrappers]];
//END4iTM3;
    return;
}
@end

#import "iTM2FileManagerKit.h"

NSString * const iTM2ProjectIsDirectoryWrapperKey = @"iTM2ProjectIsDirectoryWrapper";

NSString * const iTM2ProjectCustomInfoComponent = @"CustomInfo";

@interface iTM2ProjectController()
@property (readwrite,retain) NSHashTable * projects;
@property (readwrite,retain) id baseProjects;
@property (readwrite,retain) id cachedProjects;
@property (readwrite,retain) id reentrantProjects;
@property (readwrite,assign) NSMutableDictionary * baseNamesOfAncestorsForBaseProjectName;//    Utility, only use when informed
@property (readwrite,assign) NSMutableDictionary * baseURLs4ProjectName;
- (void)flushCaches;
@end

@implementation iTM2ProjectController
static id _iTM2SharedProjectController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedProjectController
+ (id)sharedProjectController;
/*"Description forthcoming.
Note on the various handles to file names.
When a file is associated to a project, the project stores various informations about the file location.
1 - the project itself is stored as an absolute URL, or an absolute path and an absolute finder alias.
2 - the "source" directory is stored as a path relative to the diretory of the project, and absolute path and an absolute finder alias.
3 - each file is handled as a path relative to the source directory, an absolute path and an absolute finder alias.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Ven 21 déc 2007 21:07:55 UTC
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return _iTM2SharedProjectController;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSharedProjectController:
+ (void)setSharedProjectController:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Ven 21 déc 2007 21:07:55 UTC
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (_iTM2SharedProjectController != argument) {
		[DNC removeObserver:_iTM2SharedProjectController];
		[WSN removeObserver:_iTM2SharedProjectController];
		[_iTM2SharedProjectController autorelease];
		_iTM2SharedProjectController = [argument retain];
		if (argument) {
			[DNC addObserver:argument selector:@selector(windowDidBecomeKeyOrMainNotified:)name:NSWindowDidBecomeKeyNotification object:nil];
			[DNC addObserver:argument selector:@selector(windowDidBecomeKeyOrMainNotified:)name:NSWindowDidBecomeMainNotification object:nil];
			[WSN addObserver:argument selector:@selector(workspaceDidPerformFileOperationNotified:)name:NSWorkspaceDidPerformFileOperationNotification object:nil];
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:03:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    if (self = [super init]) {
        //  the receiver is the owner of the base projects
        //  base projects are owned during the whole lifetime
        self.baseProjects = [NSMutableDictionary dictionary];
        //  The list of all the projects known by iTM2
        //  This includes the base projects and the ones actually open
        //  We have a handle on projects
        //  - weak handle, because the receiver is not the owner
        //  - project objects are unique, use address as hash value and direct equality instead of isEqual:
        self.projects = [NSHashTable hashTableWithOptions:NSPointerFunctionsZeroingWeakMemory|NSPointerFunctionsObjectPointerPersonality];
        //  utility storage
        self.reentrantProjects = [NSMutableSet set];
        self.baseNamesOfAncestorsForBaseProjectName = nil;// important!
        self.baseURLs4ProjectName = [NSMutableDictionary dictionary];
        self.flushCaches;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mainInfoURLFromURL:create:error:
- (NSURL *)mainInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:03:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (fileURL.isFileURL) {
		NSString * path = fileURL.path;
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		return [NSURL URLWithPath4iTM3:component relativeToURL:fileURL];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherInfoURLFromURL:create:error:
- (NSURL *)otherInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:06:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (fileURL.isFileURL) {
		NSString * fileName = fileURL.path;
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithPath4iTM3:path relativeToURL:fileURL];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaInfoURLFromURL:create:error:
- (NSURL *)metaInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:06:23 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (fileURL.isFileURL) {
		NSString * fileName = fileURL.path;
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectInfoMetaComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithPath4iTM3:path relativeToURL:fileURL];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  customInfoURLFromURL:create:error:
- (NSURL *)customInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:07:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (fileURL.isFileURL) {
		NSString * fileName = fileURL.path;
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectCustomInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithPath4iTM3:path relativeToURL:fileURL];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//END4iTM3;
    return nil;
}
#pragma mark =-=-=-=-=-  FILE KEY ACCESSORS
static NSArray * _iTM2PCReservedKeys = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reservedFileKey
- (NSArray *)reservedFileKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 16:33:40 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!_iTM2PCReservedKeys) {
		_iTM2PCReservedKeys = [[NSArray arrayWithObjects:
			TWSContentsKey,
			TWSFactoryKey,
			TWSDotKey,
			TWSProjectKey,
			TWSTargetsKey,
			TWSToolsKey,
			iTM2FinderAliasesKey,
			iTM2SoftLinksKey,
			iTM2ProjectLastKeyKey,
			iTM2ProjectFrontDocumentKey,
				nil] retain];
	}
//END4iTM3;
	return _iTM2PCReservedKeys;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isReservedFileKey:
- (BOOL)isReservedFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:07:48 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	return [self.reservedFileKeys containsObject:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForFileKey:filter:inProjectWithURL:
- (NSURL *)URLForFileKey:(NSString *)key filter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;
/*"Depending on the key.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 15:52:19 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!projectURL) {
		return nil;
	}
	iTM2ProjectDocument * PD = nil;
	NSError * outError = nil;
	iTM2MainInfoWrapper * MIW = nil;
	NSURL * url = nil;
	if ([key isEqual:TWSDotKey] || [key isEqual:TWSProjectKey]) {
		if (filter == iTM2PCFilterRegular) {
			return projectURL;
		}
		key = TWSProjectKey;
	} else if ([key isEqual:iTM2ParentKey]) {
		if (filter == iTM2PCFilterRegular) {
			if ((PD = [self projectForURL:projectURL])) {
				if ((url = [PD parentURL])) {
					return url;
				}
			}
		}
		url = [self URLForFileKey:TWSProjectKey filter:filter inProjectWithURL:projectURL];
		return [[url URLByRemovingFactoryBaseURL4iTM3] parentDirectoryURL4iTM3];
	} else if ([key isEqual:TWSContentsKey]) {
		if (filter == iTM2PCFilterRegular) {
			if ((PD = [self projectForURL:projectURL])) {
				if (url = [PD contentsURL]) {
					return url;
				}
				MIW = [PD mainInfos];
			}
			if (!MIW) {
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if (outError) {
					[NSApp presentError:outError];
					return [self URLForFileKey:iTM2ParentKey filter:filter inProjectWithURL:projectURL];
				}
			}
			return [MIW URLForFileKey:TWSContentsKey];
		}
//END4iTM3;
	} else if ([key isEqual:TWSFactoryKey]) {
		if (filter == iTM2PCFilterRegular) {
			if (PD = [self projectForURL:projectURL]) {
				if (url = [PD factoryURL]) {
					return url;
				}
				MIW = [PD mainInfos];
			}
			if (!MIW) {
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if (outError) {
					[NSApp presentError:outError];
					return [NSURL URLWithPath4iTM3:iTM2PathFactoryComponent relativeToURL:projectURL];
				}
			}
			return [MIW URLForFileKey:TWSFactoryKey];
		}
	}
	else if ([self isReservedFileKey:key]) {
		return nil;
	}
	NSString * projectName = projectURL.path;
	NSString * base = nil;
    NSData * bookmarkData = nil;
	switch(filter) {
		case iTM2PCFilterAbsoluteLink:
			base = [SPC absoluteSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			base = [base stringByAppendingPathComponent:key];
			base = [DFM pathContentOfSoftLinkAtPath4iTM3:base];
			if (!base) return nil;// the key was not known by the project
		//END4iTM3;
			return [NSURL fileURLWithPath:base];
		case iTM2PCFilterRelativeLink:
			base = [SPC relativeSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			base = [base stringByAppendingPathComponent:key];
			base = [DFM pathContentOfSoftLinkAtPath4iTM3:base];
			if (!base) return nil;// the key was not known by the project
		//END4iTM3;
			return [NSURL fileURLWithPath:base];
		case iTM2PCFilterAlias:
			base = [[SPC finderAliasesSubdirectory] stringByAppendingPathComponent:key];
			projectURL = [NSURL URLWithPath4iTM3:base relativeToURL:projectURL];
			bookmarkData = [NSURL bookmarkDataWithContentsOfURL:projectURL error:NULL];
			projectURL = [NSURL URLWithPath4iTM3:base relativeToURL:projectURL];
			bookmarkData = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:projectURL bookmarkDataIsStale:NULL error:NULL];
		//END4iTM3;
			return [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:NULL error:NULL];
		case iTM2PCFilterBookmark:
			base = [[SPC bookmarksSubdirectory] stringByAppendingPathComponent:key];
			projectURL = [NSURL URLWithPath4iTM3:base relativeToURL:projectURL];
			bookmarkData = [NSURL bookmarkDataWithContentsOfURL:projectURL error:NULL];
		//END4iTM3;
			return [NSURL URLByResolvingBookmarkData:bookmarkData options:0 relativeToURL:nil bookmarkDataIsStale:NULL error:NULL];
		case iTM2PCFilterRegular:
		default:
			if (PD = [self projectForURL:projectURL]) {
				MIW = [PD mainInfos];
			}
			if (!MIW) {
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if (outError) {
					[NSApp presentError:outError];
					return nil;
				}
			}
			return [MIW URLForFileKey:key];
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeysWithFilter:inProjectWithURL:
- (NSArray *)fileKeysWithFilter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Ven 21 déc 2007 21:07:55 UTC
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if (nil == projectURL) {
		return nil;
	}
	NSString * projectName = projectURL.path;
	NSString * path = nil;
	NSArray * result = nil;
	switch(filter) {
		case iTM2PCFilterAbsoluteLink:
			path = [projectName stringByAppendingPathComponent:[SPC absoluteSoftLinksSubdirectory]];
ready_to_go:;
			NSPredicate * predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF ENDSWITH[c] '.%@'",iTM2SoftLinkExtension]];
			result = [DFM contentsOfDirectoryAtPath:path error:NULL];
			result = [result filteredArrayUsingPredicate:predicate];
			return [result valueForKey:@"stringByDeletingPathExtension"];
		case iTM2PCFilterRelativeLink:
			path = [projectName stringByAppendingPathComponent:[SPC relativeSoftLinksSubdirectory]];
			goto ready_to_go;
		case iTM2PCFilterAlias:
			path = [projectName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
			goto ready_to_go;
		case iTM2PCFilterBookmark:
			path = [projectName stringByAppendingPathComponent:[SPC bookmarksSubdirectory]];
			goto ready_to_go;        
		case iTM2PCFilterRegular:
		default:
		{
			iTM2MainInfoWrapper * MIW = [[self projectForURL:projectURL] mainInfos];
			if (MIW == nil) {
				NSError * outError = nil;
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if (outError) {
					[NSApp presentError:outError];
				}
			}
//END4iTM3;
			return [MIW fileKeys];
		}
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForURL:filter:inProjectWithURL:
- (NSString *)fileKeyForURL:(NSURL *)fileURL filter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
Latest Revision: Wed Mar 17 17:35:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(projectURL);
	if (nil == fileURL)// untitled documents will go there
	{
		return nil;
	}
	// Is it me? The factory? The contents? The parent?
	if ([[self URLForFileKey:TWSProjectKey filter:filter inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {
		return TWSProjectKey;
	}
	if ([[self URLForFileKey:TWSFactoryKey filter:filter inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {
		return TWSFactoryKey;
	}
	if ([[self URLForFileKey:TWSContentsKey filter:filter inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {
		return TWSContentsKey;
	}
	if ([[self URLForFileKey:iTM2ParentKey filter:filter inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {
		return iTM2ParentKey;
	}
	// Here begins the hardest work which is not so hard in the end
	for (NSString * key in [self fileKeysWithFilter:filter inProjectWithURL:projectURL]) {
		if ([[self URLForFileKey:key filter:filter inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {
			return key;
		}
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  normalizedURLWithURL:inProjectWithURL:
-(NSURL *)normalizedURLWithURL:(NSURL *)url inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:37:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(projectURL);
	// does it belong to the factory?
	NSURL * baseURL = url.baseURL;
	NSString * relativePath = url.relativePath;
	NSURL * U = [self URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if ([baseURL isEqual:U] && ![relativePath hasPrefix:@".."]) {
		return url;
	}
	// does it belong to the contents?
	U = [self URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if ([baseURL isEqual:U] && ![relativePath hasPrefix:@".."]) {
		return url;
	}
	// url was not normalized
	NSString * K = [self fileKeyForURL:url filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if (!K.length) return nil;
	U = [SPC URLForFileKey:K filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
//END4iTM3;
	return [U isEqual:url]?url:U;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForName:inProjectWithURL:
- (NSURL *)URLForName:(NSString *)name inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:37:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  raises when no name given, unused
	NSURL * url = [NSURL URLWithString:name];
	if (url.scheme.length) {
        //  name was in fact a full url, properly escaped
		return url;
	}
	url = [self URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
//END4iTM3;
	return [NSURL URLWithPath4iTM3:name relativeToURL:url];
}
#pragma mark =-=-=-=-=-  ELSE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  workspaceDidPerformFileOperationNotified:
- (void)workspaceDidPerformFileOperationNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.projects.allObjects makeObjectsPerformSelector:@selector(fixProjectConsistency)];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  flushCaches
- (void)flushCaches;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:40:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.cachedProjects = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory|NSPointerFunctionsObjectPersonality
        valueOptions:NSMapTableZeroingWeakMemory|NSPointerFunctionsObjectPointerPersonality];
//END4iTM3;
return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjectsForURL:
- (id)availableProjectsForURL:(NSURL *)theURL;
/*"Description forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 20:07:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSAssert1(![theURL belongsToFactory4iTM3], @"The path must not be in the factory domain:\n%@",theURL);
	if (!theURL.isFileURL) {
		return [NSDictionary dictionary];
	}
	// first test if there is an enclosing wrapper
    NSURL * theWrapperURL = theURL.enclosingWrapperURL4iTM3;
    if (theWrapperURL) {
        // smartest situation, the file belongs to a wrapper
        NSURL * theProjectURL = theWrapperURL.enclosedProjectURLs4iTM3.lastObject;
        if (theProjectURL) {
            return [NSDictionary dictionaryWithObject:theProjectURL.lastPathComponent.stringByDeletingPathExtension forKey:theProjectURL];
        }
        // missing enclosed project
        return [NSDictionary dictionary];
    }
	// first I get the projects file names including the other ones in the hierarchy above dirName
	// I scan the directories for projects,starting from the normal side then looking for library projects
	// it is the responsibility of the user interface controllers to make the difference between factory and regular
	NSString * displayName = nil;
	NSString * type = nil;
	NSURL * url = nil;

	// there is no enclosing wrapper
	// find all the projects, either regular or in the factory
	// stop as soon as projects are found
	NSMutableArray * URLs = [NSMutableArray array];
    NSString * path = theURL.path;
	NSURL * theURLInTheFactory = theURL.URLByPrependingFactoryBaseURL4iTM3;
    do {
        NSString * content = nil;
        for (content in [DFM contentsOfDirectoryAtPath:theURL.path error:NULL]) {
            url = [NSURL URLWithPath4iTM3:content relativeToURL:theURL];
            type = [SDC typeForContentsOfURL:url error:nil];
            if ([SWS isProjectPackageAtURL4iTM3:url] && [SDC documentClassForType:type]) {
                [URLs addObject:url.normalizedURL4iTM3];
            }
        }
        for (content in [DFM contentsOfDirectoryAtPath:theURLInTheFactory.path error:NULL]) {
            url = [NSURL URLWithPath4iTM3:content relativeToURL:theURLInTheFactory];
            type = [SDC typeForContentsOfURL:url error:nil];
            if ([SWS isWrapperPackageAtURL4iTM3:url] && [SDC documentClassForType:type]) {
                [URLs addObject:url.normalizedURL4iTM3];
            }
        }
        theURL = theURL.parentDirectoryURL4iTM3;
        theURLInTheFactory = theURLInTheFactory.parentDirectoryURL4iTM3;
    } while((URLs.count==0) && (path = path.stringByDeletingLastPathComponent,(path.length>1)));
    // now adding the library projects if relevant
    [URLs sortedArrayUsingSelector:@selector(compare:)];
    NSMutableDictionary * first = [NSMutableDictionary dictionary];
    NSMutableDictionary * last  = [NSMutableDictionary dictionary];
    for (url in URLs) {
        [first setObject:url.path.lastPathComponent forKey:url];
        [last  setObject:url.path.stringByDeletingLastPathComponent forKey:url];
    }
    NSArray * allValues = nil;
    NSSet * set = nil;
more:
    allValues = first.allValues;
    set = [NSSet setWithArray:allValues];
    if (allValues.count != set.count) {// allValues.count >= set.count
        for (displayName in set) {
            NSArray * ra = [first allKeysForObject:displayName];
            if (ra.count>1) {
                // there are more than one path with the same display name
                // we must make a difference between them
                for (url in ra) {
                    NSString * oldPath = [last objectForKey:url];
                    NSString * oldDisplayName = [first objectForKey:url];
                    NSString * newDisplayName = oldPath.lastPathComponent;
                    newDisplayName = [newDisplayName stringByAppendingPathComponent:oldDisplayName];
                    [first setObject:newDisplayName forKey:url];
                    NSString * newPath = newDisplayName.stringByDeletingLastPathComponent;
                    [last setObject:newPath forKey:url];
                }
            }
        }
        goto more;
    }
    for (url in first.keyEnumerator) {
        displayName = [first objectForKey:url];
        NSString * dirName = displayName.stringByDeletingLastPathComponent;
        if (dirName.length>1) {
            displayName = displayName.lastPathComponent;
            NSDictionary * fileAttributes = [DFM attributesOfItemAtPath:url.path error:NULL];
            if ([fileAttributes fileExtensionHidden]) {
                displayName = displayName.stringByDeletingPathExtension;
            }
            dirName = [[@"..." stringByAppendingPathComponent:dirName] stringByStandardizingPath];
            displayName = [NSString stringWithFormat:@"%@ (%@)",displayName,dirName];
            [first setObject:displayName forKey:url];
        }
    }
    return first;
//END4iTM3;
	return [NSDictionary dictionary];
}
#pragma mark =-=-=-=-=-  PROJECTS
@synthesize projects = projects4iTM3;
@synthesize cachedProjects = cached_projects4iTM3;
@synthesize reentrantProjects = reentrant_projects4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForDocument:
- (id)projectForDocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (nil == document) {
		return nil;
	}
	NSURL * fileURL = document.fileURL;
    if (nil == fileURL) {
        return nil;
	}
	if (iTM2DebugEnabled>99999) {
		LOG4iTM3(@"fileURL:%@",fileURL);
	}
	iTM2ProjectDocument * PD;
	for (PD in [SPC projects]) {
		if ([PD ownsSubdocument:document]) {
			[self setProject:PD forDocument:document];
			return PD;
		}
	}
    if (PD = [self.cachedProjects objectForKey:fileURL.absoluteURL]) {
		[self setProject:PD forDocument:document];
		return PD;
	} else {
		[self setProject:nil forDocument:document];
		return nil;
	}
	[document setHasProject4iTM3:NO];
	// if this method is entered once more from here,it will return from one of the above lines, unless the cached projects are cleaned
	NSURL * url = fileURL;
	if ((PD = [self freshProjectForURLRef:&url display:YES error:nil])) {
		if (url.isFileURL && ![url isEquivalentToURL4iTM3:fileURL]) {
			// ensure the containing directory exists
			[DFM createDirectoryAtPath:url.path.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil];
		}
		url = url.normalizedURL4iTM3;
		[document setFileURL:url];
		[PD addSubdocument:document];
		[self setProject:PD forDocument:document];
		return PD;
	}
	[self setProject:nil forDocument:document];
	[document takeContextBool:YES forKey:@"_iTM2:Document With No Project" domain:iTM2ContextAllDomainsMask];// still used?
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:forDocument:
- (void)setProject:(id)projectDocument forDocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:34:15 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!document)
		return;
	NSParameterAssert((!projectDocument || [SPC isProject:projectDocument]));
	[document setHasProject4iTM3:(projectDocument != nil)];
	NSURL * fileURL = document.fileURL;
    if (![[self projectForURL:fileURL] isEqual:projectDocument]) {
        [self setProject:projectDocument forURL:fileURL];
        NSAssert1(!projectDocument || (projectDocument == [self projectForDocument:document]),
            @"..........  INCONSISTENCY:unexpected behaviour,report bug 1313 in %@",__iTM2_PRETTY_FUNCTION__);
    }
	NSAssert3((!projectDocument || [[projectDocument fileKeyForURL:fileURL] length]),
		@"..........  INCONSISTENCY:unexpected behaviour,report bug 3131 in %@,\nproject:\n%@\nfileName:\n%@",__iTM2_PRETTY_FUNCTION__,projectDocument,fileURL);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getOpenProjectForURL:
- (id)getOpenProjectForURL:(NSURL *)fileURL;
/*"Does an already open project knows about the document at fileURL?
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Feb 21 10:33:40 UTC 2010
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	for(iTM2ProjectDocument * projectDocument in self.projects) {
		if ([[projectDocument fileKeyForURL:fileURL] length]
			|| [projectDocument.fileURL isEquivalentToURL4iTM3:fileURL]
			|| [fileURL isRelativeToURL4iTM3:projectDocument.contentsURL]
			|| [fileURL isRelativeToURL4iTM3:projectDocument.factoryURL]) {
			[projectDocument createNewFileKeyForURL:fileURL];
theEnd:
			[self setProject:projectDocument forURL:fileURL];
			if (iTM2DebugEnabled>10) {
				LOG4iTM3(@"\\infty - The project:%@ knows about %@",projectDocument.fileURL,fileURL);
			}
			return projectDocument;
		}
		else if ([projectDocument.wrapperURL isEquivalentToURL4iTM3:fileURL])
			goto theEnd;
		else if (iTM2DebugEnabled>10) {
			LOG4iTM3(@"The project:\n%@ does not know\n%@",projectDocument.fileURL,fileURL);
		}
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForURL:
- (id)projectForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:34:25 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(fileURL);
	id projectDocument = [self.cachedProjects objectForKey:fileURL.URLByStandardizingPath];
	if ([SPC isProject:projectDocument]) {
		return projectDocument;
	}
	NSURL * shortFileURL = fileURL.URLByDeletingPathExtension;
	projectDocument = [self.cachedProjects objectForKey:shortFileURL.URLByStandardizingPath];
	if ([SPC isProject:projectDocument]) {
		[self.cachedProjects setObject:projectDocument forKey:fileURL.URLByStandardizingPath];
		[projectDocument createNewFileKeyForURL:fileURL];
		return projectDocument;
	}
	// Not yet cached
	// reentrant management here
	if ([projectDocument isEqual:[NSNull null]]) {
		return nil;
	}
	[self.cachedProjects setObject:[NSNull null] forKey:fileURL.URLByStandardizingPath];
	return [self getOpenProjectForURL:fileURL];// Will cache the result as side effect
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:forURL:
- (void)setProject:(id)projectDocument forURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:34:40 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled>99999) {
		LOG4iTM3(@"fileURL:%@",fileURL);
	}
	NSParameterAssert(fileURL);
	NSParameterAssert((!projectDocument || [SPC isProject:projectDocument]));
	[self.cachedProjects setObject:projectDocument forKey:fileURL.URLByStandardizingPath];
	NSAssert1(!projectDocument || (projectDocument == [self projectForURL:fileURL]),
		@"..........  INCONSISTENCY:unexpected behaviour,report bug 3131 in %@",__iTM2_PRETTY_FUNCTION__);
	[self.cachedProjects setObject:projectDocument forKey:fileURL.URLByDeletingPathExtension.URLByStandardizingPath];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForSource:
- (id)projectForSource:(id)source;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:34:46 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning THERE MIGHT BE A REALLY BIG PROBLEM WHEN CREATING NEW DOCUMENTS:the filename is void!!! Use the autosave?
//NSLog(@"source:%@",source);
	if ([source isKindOfClass:[NSURL class]])
        return [self projectForURL:source];
    else if ([source isKindOfClass:[NSString class]])
        return [self projectForURL:[NSURL fileURLWithPath:source]];
    else if ([source isKindOfClass:self.class])
        return source;
    else if ([source isKindOfClass:[NSDocument class]])
        return [source project4iTM3];
    else if ([source isKindOfClass:[NSWindowController class]])
        return [[source document] project4iTM3];
    else if ([source isKindOfClass:[NSWindow class]])
        return [[[source windowController] document] project4iTM3];
    else if ([source isKindOfClass:[NSView class]])
        return [[[[source window] windowController] document] project4iTM3];
    else if ([source isKindOfClass:[NSToolbarItem class]])
        return [self projectForSource:[source view]];
    else
        return [[SDC currentDocument] project4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerProject:
- (void)registerProject:(iTM2ProjectDocument *)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:24:00 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([projectDocument isKindOfClass:[iTM2ProjectDocument class]]) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"project:%@",projectDocument);
		}
		// testing consistency
		// we are not authorized to register a project document with the same name as a previously registered project document
		NSURL * projectURL = [projectDocument.fileURL URLByStandardizingPath];
		for(iTM2ProjectDocument * P in self.projects) {
//LOG4iTM3(@"PROBLEM");if ([P.fileURL.path pathIsEqual4iTM3:FN]){
//LOG4iTM3(@"PROBLEM");}
			NSAssert2(![P.fileURL isEquivalentToURL4iTM3:projectURL],@"You cannot register 2 different project documents with that URL:\n%@==%@",projectURL,P.fileURL);
		}
		[self.projects addObject:projectDocument];
		[self setProject:projectDocument forDocument:projectDocument];
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"project:%@",projectDocument);
		}
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forgetProject:
- (void)forgetProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:23:01 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([projectDocument isKindOfClass:[iTM2ProjectDocument class]]) {
		[self.projects removeObject:projectDocument];
		[self.cachedProjects removeObjectsForKeys:[self.cachedProjects allKeysForObject:projectDocument]];
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"project:%@",projectDocument);
		}
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isProject:
- (BOOL)isProject:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:22:53 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return (nil != argument) && [self.projects containsObject:argument];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  finderAliasesSubdirectory
- (NSString*)finderAliasesSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[TWSFrontendComponent stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"Finder Aliases"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bookmarksSubdirectory
- (NSString*)bookmarksSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.finderAliasesSubdirectory;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  absoluteSoftLinksSubdirectory
- (NSString*)absoluteSoftLinksSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[TWSFrontendComponent stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"Soft Links"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  relativeSoftLinksSubdirectory
- (NSString*)relativeSoftLinksSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[TWSFrontendComponent stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"Relative Soft Links"];
}
#pragma mark =-=-=-=-=-  NEW PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canGetNewProjectForURL:error:
- (BOOL)canGetNewProjectForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!fileURL.isFileURL || [self.reentrantProjects containsObject:fileURL]) {
		return NO;
	}
	BOOL isDirectory = NO;
	NSString * FN = fileURL.path;
	if ([DFM fileExistsAtPath:FN isDirectory:&isDirectory]) {
		if (isDirectory) {
			if ([SWS isFilePackageAtPath:FN]) {
				return YES;
			}
			OUTERROR4iTM3(1,(@"No project for a directory that is not a package."),nil);
			return NO;
		}
		return YES;
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willGetNewProjectForURL:
- (void)willGetNewProjectForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (fileURL) {
		[self.reentrantProjects addObject:fileURL];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectURLInWrapperForURL:error:
- (NSURL *)getProjectURLInWrapperForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
fileURLRef changes when it is a wrapper URL.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * projectDocument = nil;
	NSString * fileName = fileURL.path.stringByStandardizingPath;
	NSURL * wrapperURL = fileURL.enclosingWrapperURL4iTM3;
	if (wrapperURL.isFileURL) {
		// then we are trying to find a project just below
		BOOL isDirectory = NO;
		if ([DFM fileExistsAtPath:wrapperURL.path isDirectory:&isDirectory] && isDirectory) {
			NSArray * projectURLs = wrapperURL.enclosedProjectURLs4iTM3;
			NSURL * projectURL = nil;
			NSString * component = nil;
			if (projectURLs.count == 1) {
				return projectURLs.lastObject;
			} else if (projectURLs.count > 1) {
				component = wrapperURL.path.lastPathComponent;
				component = component.stringByDeletingPathExtension;
				component = [component stringByAppendingPathExtension:[SDC projectPathExtension4iTM3]];// not well designed, no intrinsic definition
				projectURL = [NSURL URLWithPath4iTM3:component relativeToURL:wrapperURL];
				if ([[projectURLs valueForKey:@"URLByStandardizingPath"] containsObject:projectURL.URLByStandardizingPath]) {
					return projectURL;
				}
				if (outErrorPtr) {
					*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Too many projects in the wrapper directory at\n%@\nChoosing the last one.",wrapperURL] forKey:NSLocalizedDescriptionKey]];
				}
				return nil;
			} else {
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.",wrapperURL] forKey:NSLocalizedDescriptionKey]]];
				// the following method will create a constrained project
				component = wrapperURL.path.lastPathComponent.stringByDeletingPathExtension;
				component = [component stringByAppendingPathExtension:[SDC projectPathExtension4iTM3]];
				projectURL = [NSURL URLWithPath4iTM3:component relativeToURL:wrapperURL];
				if ([DFM fileExistsAtPath:projectURL.path]) {
					NSInteger tag = 0;
					if (![SWS performFileOperation:NSWorkspaceRecycleOperation source:wrapperURL.path
							destination:@"" files:[NSArray arrayWithObject:component] tag:&tag]) {
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Impossible to recycle file at\n%@\nProblems forthcoming...",projectURL]
								forKey:NSLocalizedDescriptionKey]]];
					}
				}
				if ([DFM createDirectoryAtPath:projectURL.path withIntermediateDirectories:YES attributes:nil error:outErrorPtr]) {
					projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:NO error:outErrorPtr];
					[projectDocument fixProjectConsistency];
				} else {
					projectDocument = [SDC makeUntitledDocumentOfType:[SDC projectPathExtension4iTM3] error:outErrorPtr];
					[projectDocument setFileURL:projectURL];
					[projectDocument setFileType:(NSString *)[SDC projectDocumentType4iTM3]];
					[projectDocument fixProjectConsistency];
					[SDC addDocument:projectDocument];
				}
				if (projectDocument) {
					[projectDocument createNewFileKeyForURL:fileURL];
					[projectDocument saveDocument:nil];
					return projectURL;
				} else {
					if (outErrorPtr) {
						*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.",wrapperURL] forKey:NSLocalizedDescriptionKey]];
					}
					return nil;
				}
			}
		} else {
			if (outErrorPtr) {
				*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"ERROR:There might be a link at %@:it is no yet supported by iTeXMac2",fileName]
						forKey:NSLocalizedDescriptionKey]];
			}
			return nil;
		}
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectInWrapperForURL:display:error:
- (id)getProjectInWrapperForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * projectURL = [self getProjectURLInWrapperForURL:fileURL error:outErrorPtr];
	if (nil != projectURL) {
		iTM2ProjectDocument * projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr];
		[projectDocument fixProjectConsistency];
		[projectDocument createNewFileKeyForURL:fileURL];
		[SPC setProject:projectDocument forURL:fileURL];
		return projectDocument;
	}
//END4iTM3;
    return nil;
}
#if 0
This is no longer supported
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  geWritableProjectInWrapperForURLRef:display:error:
- (id)geWritableProjectInWrapperForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"In earlier iTeXMac2, standalone documents had a project associated with them in the cached projects directory.
It must be considered an obsolete behaviour.
How did it work at that time?
For /my/path/to/foo.tex, the associate project was
/Users/me/Library/Application Support/iTeXMac2/Writable Projects.Localized/my/path/to/foo.texd/foo.texp
Now, things are a bit different.
Every file belongs to a nearby project.
No project will belong to the former Writable Projects.localized directory.
But in the case the user has no write access to the project,
an helper project is provided where it can write anything necessary.
This helper belongs to the Writable Projects.localized
The helper project is not a parent project, in terms of inheritancy.
This facility is just provided for those who want to typeset files that do not belong to a write allowed folder
but do not want to edit them.
There is an associate project in only one situation: the directory is read only.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if (nil == fileURLRef) {
		return nil;
	}
	NSURL * fileURL = [*fileURLRef URLByPrependingFactoryBaseURL4iTM3];
    id result = [self getProjectInWrapperForURL:fileURL display:display error:outErrorPtr];
	if (result) {
		// This project is a cached one
		// It was created because some location was not writable
		// If the location status has changed, then this project should be merged with the existing project 
		// There is a problem if there is already a project that we can't modify
		// The preferred situation is with a non cached project
		// We try to recover this more normal situation.
		NSURL * url = result.fileURL;// the project document URL
		url = [url URLByRemovingFactoryBaseURL4iTM3];// the not cached equivalent
		if ([DFM fileExistsAtPath:url.path]) {
			// there is already a project not cached
			// This is definitely the one we would have opened
			// Remember tha this method is just one of the components of the routine that
			// maps a project to any given URL
			return [SPC getProjectInHierarchyForURL:url display:display error:outErrorPtr];
		}
		if ([DFM isWritableFileAtPath:url.path.stringByDeletingLastPathComponent]) {
			// normally there should not exist a valid project at that location
			// This is the normal location for the project document in result
			
			
		}
		*fileURLRef = fileURL;
	}
	return result;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectURLsInHierarchyForURL:error:
- (NSArray *)getProjectURLsInHierarchyForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!fileURL.isFileURL) {
		return nil;
	}
	NSURL * theURL = fileURL;
	NSURL * url = nil;
	NSString * component = nil;
	iTM2ProjectDocument * projectDocument = nil;
	NSMutableArray * candidates = [NSMutableArray array];
scanDirectoryContent:
	if ([SWS isProjectPackageAtURL4iTM3:theURL]) {
		[candidates addObject:theURL];
		return candidates;
	}
	if ([SWS isWrapperPackageAtURL4iTM3:theURL]) {
		[candidates addObjectsFromArray:theURL.enclosedProjectURLs4iTM3];
		return candidates;
	}
	BOOL finished = NO;
	NSString * projectDocumentType4iTM3 = [SDC projectDocumentType4iTM3];
	for(component in [DFM contentsOfDirectoryAtPath:theURL.path error:NULL]) {
		if ([[SDC typeForContentsOfURL:[NSURL fileURLWithPath:component] error:NULL] conformsToUTType4iTM3:projectDocumentType4iTM3]) {
			finished = YES;
			url = [NSURL URLWithPath4iTM3:component relativeToURL:theURL];
			projectDocument = [SDC documentForURL:url];
			if ([projectDocument fileKeyForURL:fileURL]) {
				[candidates addObject:url];
			}
			else if (nil == projectDocument) {
				if ([self fileKeyForURL:fileURL filter:iTM2PCFilterRegular inProjectWithURL:url]) {
					[candidates addObject:url];
				}
			}
		}
	}
	if (candidates.count > 0) {
		return candidates;
	}
	for(component in [DFM contentsOfDirectoryAtPath:theURL.path error:NULL]) {
		if ([[SDC typeForContentsOfURL:[NSURL fileURLWithPath:component] error:NULL] conformsToUTType4iTM3:projectDocumentType4iTM3]) {
			finished = YES;
			url = [NSURL URLWithPath4iTM3:component relativeToURL:theURL];
			NSString * K = [self fileKeyForURL:fileURL filter:iTM2PCFilterAlias inProjectWithURL:url];
			if (K && ![DFM fileExistsAtPath:[[self URLForFileKey:K filter:iTM2PCFilterRegular inProjectWithURL:url] path]]) {
				[candidates addObject:url];
			}
		}
	}
	if ((0 == candidates.count) && !finished) {
		theURL = [theURL parentDirectoryURL4iTM3];
		if (theURL.path.length>1) {
			goto scanDirectoryContent;
		}
	}
//END4iTM3;
    return candidates;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectInHierarchyForURL:display:error:
- (id)getProjectInHierarchyForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * candidates = [self getProjectURLsInHierarchyForURL:fileURL error:outErrorPtr];
	if (candidates.count == 1) {
//LOG4iTM3(@"WE have found our project",[SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		return [SDC openDocumentWithContentsOfURL:candidates.lastObject display:display error:outErrorPtr];
	}
	else if (candidates.count > 1) {
		[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"THERE ARE MANY DIFFERENT PROJECTS FOR THAT FILE NAME\n%@,\nunexpected situation, you should remove all the projects but one\nsee the open folder in the finder",fileURL] forKey:NSLocalizedDescriptionKey]]];
            
		return [SDC openDocumentWithContentsOfURL:candidates.lastObject display:display error:outErrorPtr];
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectDocumentFromProjectURLs:fileKey:forURL:display:error:
- (id)getProjectDocumentFromProjectURLs:(NSMutableArray *)projectURLs fileKey:(NSString **)keyRef forURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"This is the point where we open an existing project. The given file URL does not belong to a project nor a wrapper either cached or not.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 16:58:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	for (NSNumber * N in [NSArray arrayWithObjects:[NSNumber numberWithInteger:iTM2PCFilterRegular],[NSNumber numberWithInteger:iTM2PCFilterAlias],[NSNumber numberWithInteger:iTM2PCFilterAbsoluteLink],nil]) {
		// whether the fileURL was registered by a project
		NSString * aKey = nil;
        NSURL * projectURL = nil;
		id projectDocument = nil;
		for (projectURL in projectURLs.objectEnumerator) {
			if (projectURL = [self URLForFileKey:TWSDotKey filter:[N integerValue] inProjectWithURL:projectURL]) {
				if ([self fileKeyForURL:fileURL filter:iTM2PCFilterRegular inProjectWithURL:projectURL]) {
					// fine, the project at projectURL (if any) knows about fileURL, this should never happen because it was already tested above
					#define OPEN_PROJECT_OR_REMOVE\
					if (projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr]) {\
						return projectDocument;\
					} else {\
						[projectURLs removeObject:projectURL];\
					}
					OPEN_PROJECT_OR_REMOVE;
				}
			}
		}
		// whether the fileURL was registered by a project, then the URL was modified externally
		// We just try to use various hints:
		// alias data, also useful when the file was moved alone, might be stronger than the absolute path trick because it manages volumes in a softer way.
		// absolute path, useful when the file was moved alone
		// relative path, useful when both the file and the project where moved accordingly
		NSString * aFileName = nil;
		for (projectURL in projectURLs.objectEnumerator) {
			if (projectURL = [self URLForFileKey:TWSDotKey filter:[N integerValue] inProjectWithURL:projectURL]) {
				if (aKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterAlias inProjectWithURL:projectURL]) {
					// this project did know about fileURL, as a finder alias
					// but if there is now an existing document for this key, this is not an acceptable project
					#define LEVEL1\
					aFileName = [[self URLForFileKey:aKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] path];\
					if (![DFM fileExistsAtPath:aFileName]) {\
						OPEN_PROJECT_OR_REMOVE;\
					}
					LEVEL1;
				}
			}
		}
		// None of the remaining project candidates knows about the given fileURL as either a regular file or a finder alias
		for (projectURL in projectURLs.objectEnumerator) {
			if (projectURL = [self URLForFileKey:TWSDotKey filter:[N integerValue] inProjectWithURL:projectURL]) {
				if (aKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterAbsoluteLink inProjectWithURL:projectURL]) {
					// this project did know about fileURL, as an absolute path
					// but if there is now an existing document for this key, either regular or finder alias, this is not an acceptable project
					#define LEVEL2\
					aFileName = [[self URLForFileKey:aKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL] path];\
					if (![DFM fileExistsAtPath:aFileName]) {\
						LEVEL1;\
					}
					LEVEL2;
				}
			}
		}
		// None of the remaining project candidates knows about the given fileURL as either a regular file, a finder alias or an absolute link
		for (projectURL in projectURLs.objectEnumerator) {
			if (projectURL = [self URLForFileKey:TWSDotKey filter:[N integerValue] inProjectWithURL:projectURL]) {
				if (aKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterRelativeLink inProjectWithURL:projectURL]) {
					// this project did know about fileURL, as an relative path
					// but if there is now an existing document for this key, either regular, finder alias or absolute, this is not an acceptable project
					#define LEVEL3\
					aFileName = [[self URLForFileKey:aKey filter:iTM2PCFilterAbsoluteLink inProjectWithURL:projectURL] path];\
					if (![DFM fileExistsAtPath:aFileName]) {\
						LEVEL2;\
					}
					LEVEL3;
				}
			}
		}
	}
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getUnregisteredProjectForURL:fileKey:display:error:
- (id)getUnregisteredProjectForURL:(NSURL *)fileURL fileKey:(NSString **)keyRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"This is one of the points where we open an existing project. The given file URL does not belong to a project nor a wrapper.
Developer note:all the docs open here are .texp files.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 15:50:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (nil == fileURL) {
		return nil;// no fileURL given, no project
	}
	NSMutableArray * projectURLs = [NSMutableArray array];// possible project URL's candidates
	NSDictionary * contextDictionary = [iTM2Document contextDictionaryFromURL:fileURL];// retrieve the project from the context dictionary
	NSString * S = [contextDictionary objectForKey:iTM2ProjectURLKey];// S is expected to be properly escaped!
	NSURL * projectURL = nil;
	NSURL * url = nil;
	NSString * theKey = nil;
	iTM2ProjectDocument * projectDocument = nil;
	if ([S isKindOfClass:[NSString class]]) {
		projectURL = [NSURL URLWithString:S];// S is exactly the string that would appear in the browser search field
newProjectURLCandidate:
		theKey = [contextDictionary objectForKey:iTM2ProjectFileKeyKey];
		if ([SWS isProjectPackageAtURL4iTM3:projectURL]) {
			url = [self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
			if ([url isEquivalentToURL4iTM3:fileURL]) {
                //  OK, the project knows about fileURL
				if ((projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr])) {
theEnd:
					[projectDocument fixProjectConsistency];// this must be revisited
					if (keyRef) {
						*keyRef = theKey;
					}
                    [projectDocument setURL:fileURL forFileKey:theKey];
                    [projectDocument createNewFileKeyForURL:fileURL];// ensure that the file URL is registered.
					return projectDocument;
				}
				// we could not open that document
				// try other options
			} else {
				[projectURLs addObject:projectURL];// the context project does not seem to be the good one
			}
		}
	} else {
		S = [contextDictionary objectForKey:iTM2ProjectAbsolutePathKey];// Old Absolute Project File Name, support for version prior to 689
		if ([S isKindOfClass:[NSString class]]) {
			projectURL = [NSURL fileURLWithPath:S];
			goto newProjectURLCandidate;
		}
        S = @"";
	}
	// now we have a new candidate
	// we try to find other candidates
	// we create a project URL relative to the receiver
	S = [contextDictionary objectForKey:iTM2ProjectRelativePathKey];
	if ([S isKindOfClass:[NSString class]]) {
		projectURL = [fileURL.URLByDeletingLastPathComponent URLByAppendingPathComponent:S].URLByStandardizingPath;
		#define ABSOLUTE_FILE_NAME_FOR_KEY\
		if (![projectURLs containsObject:projectURL]\
                && [SWS isProjectPackageAtURL4iTM3:projectURL]) {\
			if ([[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {\
				if (projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr]) {\
					goto theEnd;\
				}\
			} else {\
				[projectURLs addObject:projectURL];\
			}\
		}
		ABSOLUTE_FILE_NAME_FOR_KEY;
	}
    S = nil;
	NSData * aliasData = [contextDictionary objectForKey:iTM2ProjectOwnAliasKey];
	if ([aliasData isKindOfClass:[NSData class]]
		&& (projectURL = [NSURL URLByResolvingBookmarkData:aliasData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:NULL error:outErrorPtr])) {
		ABSOLUTE_FILE_NAME_FOR_KEY;
	}
    aliasData = nil;
	// in the hierarchy above fileURL
	url = [fileURL parentDirectoryURL4iTM3];
	NSString * component = nil;
	while(url.path.length>1) {
		for(component in [DFM contentsOfDirectoryAtPath:url.path error:NULL]) {
			projectURL = [NSURL URLWithPath4iTM3:component relativeToURL:url];
			if (![projectURLs containsURL4iTM3:projectURL] && [SWS isProjectPackageAtURL4iTM3:projectURL]) {
				if ([[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {
					if (projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr]) {
						goto theEnd;
					} else {
						OUTERROR4iTM3(1,([NSString stringWithFormat:@"Problem opening projectn%@",
							projectURL]),(outErrorPtr?*outErrorPtr:nil));
					}
				}
				[projectURLs addObject:projectURL];
			}
		}
		url = url.parentDirectoryURL4iTM3;
	}
	// in the cached hierarchy, this is only for projects that could not be written because of a lack of rights
    //  Go to the factory folder
	if (!fileURL.belongsToFactory4iTM3) {
        //  We try to find a project in the library
        //  We start from the bottom and go up until we find something acceptable.
        S = [iTM2PathComponentDot stringByAppendingPathComponent:fileURL.path.stringByDeletingLastPathComponent];
        NSString * ignore = @""; // ignore this component in order not to walk through a file subtree twice
        while (S.length>1)/* relative is more than "./..." */{
            NSURL * url = [NSURL URLWithPath4iTM3:S relativeToURL:[NSURL factoryURL4iTM3]];
			for(component in [DFM contentsOfDirectoryAtPath:url.path error:NULL]) {
                if (![component isEqual:ignore]) {
                    projectURL = [NSURL URLWithPath4iTM3:component relativeToURL:url];
                    if ([SWS isWrapperPackageAtURL4iTM3:projectURL]) {
                        projectURL = projectURL.enclosedProjectURLs4iTM3.lastObject;//  One project per wrapper
                    }
                    if ([SWS isProjectPackageAtURL4iTM3:projectURL]) {
                        if (![projectURLs containsURL4iTM3:projectURL]) {
                            if ([[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] isEquivalentToURL4iTM3:fileURL]) {
                                if (projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr]) {
                                    goto theEnd;
                                } else {
                                    OUTERROR4iTM3(1,([NSString stringWithFormat:@"Problem opening project\n%@",
                                        projectURL]),(outErrorPtr?*outErrorPtr:nil));
                                }
                            }
                            [projectURLs addObject:projectURL];
                        }
                    }
                }
			}
            ignore = S.lastPathComponent;
            S = S.stringByDeletingLastPathComponent;
		}
	}
	if ((projectDocument = [self getProjectDocumentFromProjectURLs:projectURLs fileKey:keyRef forURL:fileURL display:display error:outErrorPtr])) {
		goto theEnd;
	}
    NSURL * oldFileURL = nil;
	if ((S = [contextDictionary objectForKey:iTM2ProjectAbsolutePathKey])) {
        oldFileURL = [NSURL URLWithString:S];
        if (!oldFileURL.scheme.length) {
            oldFileURL = [NSURL fileURLWithPath:S];
        }
        if (![oldFileURL isEqualToFileURL4iTM3:fileURL]
            && ![DFM fileExistsAtPath:oldFileURL.path]
                && S
                    && (projectDocument = [self getUnregisteredProjectForURL:oldFileURL fileKey:&theKey display:display error:outErrorPtr])) {
            // as we passed a pointer to receive the key, the returned project has not yet set up the key->file binding.
            goto theEnd;
        }
    }
	NSURL * resolvedFileURL = nil;
	if ((aliasData = [contextDictionary objectForKey:iTM2ProjectOwnAliasKey])
		&& [aliasData isKindOfClass:[NSData class]]) {
		resolvedFileURL = [NSURL URLByResolvingBookmarkData:aliasData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:NULL error:outErrorPtr];
		if (![resolvedFileURL isEqualToFileURL4iTM3:fileURL]
			&& ![resolvedFileURL isEqualToFileURL4iTM3:oldFileURL]
				&& ![DFM fileExistsAtPath:resolvedFileURL.path]) {
			goto theEnd;
		}
	}
    //  This should not live there because the project should not yet know that it rules for TeX.
	NSURL * texFileURL = [fileURL.URLByDeletingPathExtension URLByAppendingPathExtension:@"tex"];
	if (![texFileURL isEqualToFileURL4iTM3:fileURL]
		&& ![texFileURL isEqualToFileURL4iTM3:oldFileURL]
			&& ![texFileURL isEqualToFileURL4iTM3:resolvedFileURL]
				&& (projectDocument = [self getUnregisteredProjectForURL:texFileURL fileKey:&theKey display:display error:outErrorPtr])) {
		goto theEnd;
	}
	if (projectDocument = [self getProjectDocumentFromProjectURLs:projectURLs fileKey:keyRef forURL:fileURL display:display error:outErrorPtr]) {
		goto theEnd;
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewProjectPanelControllerClass
- (Class)createNewProjectPanelControllerClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [iTM2NewProjectController class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewWritableProjectForURL:display:error:
- (id)createNewWritableProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"We create a new library project when it is not possible to create a project,
mainly because we have no write access to the right location.
If we already have a project, but it is readonly, we must create a library project to hold the factory folder.
The library project won't be used for anything else (as of build greater than 689).
If we cannot have a project in the normal location, we will create a library one.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!fileURL.isFileURL) {
		return nil;
	}
	// create an 'library' project
	NSString * factoryDirectory = [[NSURL factoryURL4iTM3] path];
	NSString * typeName = [SDC projectDocumentType4iTM3];
	iTM2ProjectDocument * projectDocument = [SDC makeUntitledDocumentOfType:(NSString *)typeName error:outErrorPtr];
	if (projectDocument) {
		NSString * fileName = fileURL.path;
		NSString * component = fileName.lastPathComponent;
		NSString * coreName = component.stringByDeletingPathExtension;
		NSString * libraryWrapperName = [fileName.stringByDeletingPathExtension
			stringByAppendingPathExtension:[SDC wrapperPathExtension4iTM3]];
		libraryWrapperName = [factoryDirectory stringByAppendingPathComponent:libraryWrapperName];
		// libraryWrapperName is now the directory wrapper name
		BOOL isDirectory = NO;
		if ([DFM fileExistsAtPath:libraryWrapperName isDirectory:&isDirectory]) {
			if (!isDirectory) {
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Unexpected file at\n%@\nwill be removed.",libraryWrapperName]
							forKey:NSLocalizedDescriptionKey]]];
				if (![DFM removeItemAtPath:libraryWrapperName error:NULL]) {
					[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove\n%@\nPlease,do it for me now and click OK.",libraryWrapperName]
								forKey:NSLocalizedDescriptionKey]]];
					if ([DFM fileOrLinkExistsAtPath4iTM3:libraryWrapperName])
					{
						if (outErrorPtr)
						{
							*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
								userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"You did not remove file at\n%@\nNo project created...",libraryWrapperName]
										forKey:NSLocalizedDescriptionKey]];
						}
						return nil;
					}
createWrapper:
					if (![DFM createDirectoryAtPath:libraryWrapperName withIntermediateDirectories:YES attributes:nil error:outErrorPtr])
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
								userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create folder at\n%@\nPlease do it for me now and click OK",libraryWrapperName]
									forKey:NSLocalizedDescriptionKey]]];
						if (![DFM fileExistsAtPath:libraryWrapperName isDirectory:&isDirectory] || !isDirectory)
						{
							if (outErrorPtr)
							{
								*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
									userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"You did not create folder at\n%@\nNo project created",libraryWrapperName]
										forKey:NSLocalizedDescriptionKey]];
							}
							return nil;
						}
					}
				}
			}
		}
		else
		{
			goto createWrapper;
		}
		NSString * projectName = [libraryWrapperName stringByAppendingPathComponent:coreName];
		projectName = [projectName stringByAppendingPathExtension:[SDC projectPathExtension4iTM3]];
		if (![DFM createDirectoryAtPath:projectName withIntermediateDirectories:YES attributes:nil error:outErrorPtr] && outErrorPtr && (outErrorPtr?*outErrorPtr:nil)) {
			[SDC presentError:*outErrorPtr];
		}
		NSURL * url = [NSURL fileURLWithPath:projectName];
//LOG4iTM3(@"url: %@",url);
		[projectDocument setFileURL:url];
		[projectDocument setFileType:(NSString *)typeName];// is it necessary?
		[SDC addDocument:projectDocument];
		// the named file is linked to something in the wrapper
		NSString * linkName = projectName.stringByDeletingLastPathComponent;
		linkName = [linkName stringByAppendingPathComponent:component];
		// maybe there is already something at this path: we just remove it
		// if it was a link,I just remove it with
		// it it was a regular file or a directory,recycle it
		if ([DFM destinationOfSymbolicLinkAtPath:linkName error:NULL]) {
			if (![DFM removeItemAtPath:linkName error:NULL]) {
				OUTERROR4iTM3(1,([NSString stringWithFormat:@"Could not remove the link at %@",linkName]),nil);
			}
		}
		else if ([DFM fileOrLinkExistsAtPath4iTM3:linkName]) {
			NSString * dirName = linkName.stringByDeletingLastPathComponent;
			NSString * component = linkName.lastPathComponent;
			NSArray * RA = [NSArray arrayWithObject:component];
			NSInteger tag = 0;
			if (![SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName destination:@"" files:RA tag:&tag]) {
				OUTERROR4iTM3(tag,([NSString stringWithFormat:@"Could not recycle synchronously file at %@",linkName]),nil);
			}
		}
		if ([DFM createSymbolicLinkAtPath:linkName withDestinationPath:fileName error:NULL]) {
			fileURL = [NSURL fileURLWithPath:linkName];
		}
		[projectDocument createNewFileKeyForURL:fileURL];
// can I save to that folder?
		[projectDocument saveDocument:nil];
		NSAssert2([[projectDocument fileKeyForURL:fileURL] length],@"%@ The key must be non void for filename: %@",__iTM2_PRETTY_FUNCTION__,fileURL.path);
		if (display) {
			[projectDocument addGhostWindowController];// not makeWindowControllers
			[projectDocument showWindows];
		}
	}
//END4iTM3;
    return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectFromPanelForFileURLRef:display:error:
- (id)getProjectFromPanelForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (nil == fileURLRef) {
		return nil;
	}
	NSURL * fileURL = *fileURLRef;
	if ([fileURL.path belongsToDirectory4iTM3:[[NSURL factoryURL4iTM3] path]]) {
		return nil;
	}
	id projectDocument = nil;
    NSString * fileName = fileURL.URLByStandardizingPath.path;
	NSMutableArray * MRA = [[[SUD stringArrayForKey:@"_iTM2DocumentFileURLsOpenedFromFinder"] mutableCopy] autorelease];
	if (NO && [MRA containsObject:fileName]) {
		// if the document was opened from the Finder, we automatically create a new project for it.
		// this is not a good idea, so we remove it for the moment
		[MRA removeObject:fileName];
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:MRA forKey:@"_iTM2DocumentFileURLsOpenedFromFinder"]];
newWritableProject:;
        fileURL = [NSURL fileURLWithPath:fileName];
		projectDocument = [self createNewWritableProjectForURL:fileURL display:NO error:outErrorPtr];// NO is required unless a ghost window controller is created
		[projectDocument saveDocument:nil];
		[SPC setProject:projectDocument forURL:fileURL];
		return projectDocument;
	}
	NSString * dirName = fileName.stringByDeletingLastPathComponent;
	if (![DFM isWritableFileAtPath:dirName]) {
		// no need to go further
		// we have no write access
		goto newWritableProject;
	}
	// reentrant management,if the panel for that particular file is already running, do nothing...
	NSWindow * W;
	iTM2NewProjectController * controller;
	Class controllerClass = self.createNewProjectPanelControllerClass;
	for (W in [NSApp windows]) {
		controller = (iTM2NewProjectController *)W.windowController;
		if ([controller isKindOfClass:controllerClass] && [controller.fileURL isEquivalentToURL4iTM3:fileURL]) {
			return nil;
		}
	}
//LOG4iTM3(@"fileName is:%@",fileName);
	controller = [[controllerClass alloc] initWithWindowNibName:NSStringFromClass(controllerClass)];
	[controller setFileURL:fileURL];
	NSInteger returnCode = 0;
	if (W = controller.window) {
		returnCode = [NSApp runModalForWindow:W];
		[W orderOut:self];
	}
	[controller autorelease];// only now, unless you want to break the code in the modal loop above
	NSURL * projectURL = [controller projectURL];
	NSString * projectName = projectURL.path;
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"return code is:%u",returnCode);
		LOG4iTM3(@"projectName is:%@",projectName);
	}
	switch(returnCode) {
		case iTM2ToggleNewProjectMode:
		{
			if (![DFM createDirectoryAtPath:projectName withIntermediateDirectories:YES attributes:nil error:nil]) {
				OUTERROR4iTM3(1,([NSString stringWithFormat:@"For one reason or another I could not ceate some directory at path:%@",projectName]),nil);
				return nil;
			}
			// do I have to change the file name?
			// what is the rule to change the file name?
			// If the file that originated the project request belongs to a wrapper,
			// it should already have a project catched by one of the methods above,
			// unless the wrapper has been corrupted and has lost its enclosed project.
			// We assume that the file name does not originally belong to a wrapper
			// or that wrappers are not corrupted.
			// So if the returned project name belongs to a wrapper,
			// then the file name should be changed accordingly.
			// if the project file does not belong to a wrapper, then no change.
			// So we just have to compare the dirnames
			NSURL * wrapperURL = projectURL.enclosingWrapperURL4iTM3;
			if (wrapperURL) {
				// The project does belong to a wrapper
				// we must change the fileURL
				// as I said before, if the fileURL was part of a wrapper, we would have catched it before
				// and the present method would never have been reached
				NSString * sourceDirName = [[self URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] path];
				if (![dirName belongsToDirectory4iTM3:sourceDirName]) {
					NSString * component = fileName.lastPathComponent;
					fileURL = [NSURL fileURLWithPath:[sourceDirName stringByAppendingPathComponent:component]];
					* fileURLRef = fileURL;
					NSInteger tag;
					if (![SWS performFileOperation:NSWorkspaceMoveOperation
							source:dirName
								destination:sourceDirName
									files:[NSArray arrayWithObject:component]
										tag:&tag])
					{
						OUTERROR4iTM3(tag,([NSString stringWithFormat:@"Could not move %@ to %@\nPlease,do it for me...",fileName,sourceDirName]),nil);
					}
				}
			}
			// we will have a project at projectName
			// is there an already existing file at that path?
			if ([SWS isProjectPackageAtURL4iTM3:projectURL] || [DFM createDirectoryAtPath:projectName withIntermediateDirectories:YES attributes:nil error:outErrorPtr]) {
				projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:NO error:outErrorPtr];
			}
			else
			{
				NSString * typeName = [SDC typeForContentsOfURL:projectURL error:outErrorPtr];
				projectDocument = [[[SDC makeUntitledDocumentOfType:typeName error:outErrorPtr] retain] autorelease];
				[projectDocument setFileURL:projectURL];
				[projectDocument saveDocument:self];
				[SDC addDocument:projectDocument];
			}
//LOG4iTM3(@"Now the file name of the projectDocument is:%@",projectDocument.fileURL.path);
//LOG4iTM3(@">>>>>>>>>>>>>>>>>>>   I have a projectDocument:%@",projectDocument);
//LOG4iTM3(@">>>>>>>>>>>>>>>>>>>   [SDC documents] are:%@",[SDC documents]);
			[projectDocument createNewFileKeyForURL:fileURL];
			[SPC setProject:projectDocument forURL:fileURL];
			if (display) {
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
			[DFM setExtensionHidden4iTM3:YES atURL:projectURL];
			return projectDocument;
		}
		break;
		case iTM2ToggleOldProjectMode:
		{
			iTM2ProjectDocument * projectDocument = [[[SDC openDocumentWithContentsOfURL:projectURL display:NO error:nil] retain] autorelease];
			NSString * projectDirName = projectDocument.fileURL.path;
			NSString * projectWrapperName = projectDocument.fileURL.enclosingWrapperURL4iTM3.path;
			projectDirName = projectDirName.stringByDeletingLastPathComponent;
			if (projectWrapperName.length) {
				if (![dirName pathIsEqual4iTM3:projectDirName]) {
					// we must change the name
					NSString * component = fileName.lastPathComponent;
					fileName = [projectDirName stringByAppendingPathComponent:component];
					* fileURLRef = [NSURL fileURLWithPath:fileName];
					NSInteger tag;
					if (![SWS performFileOperation:NSWorkspaceMoveOperation
							source:dirName
								destination:projectDirName
									files:[NSArray arrayWithObject:component]
										tag:&tag])
					{
						OUTERROR4iTM3(tag,([NSString stringWithFormat:@"Could not move %@ to %@\nPlease,do it for me...",fileName,projectDirName]),nil);
					}
					fileURL = * fileURLRef;
				}
			}
			if ([projectDocument createNewFileKeyForURL:fileURL]) {
				[projectDocument saveDocument:self];
			}
			[SPC setProject:projectDocument forURL:fileURL];
			if (display) {
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
			return projectDocument;
		}
		break;
		default:
		{
		// case iTM2ToggleForbiddenProjectMode:
			return nil;
		}
		break;
	}
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didGetNewProjectForURL:
- (void)didGetNewProjectForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (nil != fileURL) {
		[self.reentrantProjects removeObject:fileURL];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  existingProjectForURLRef:display:error:
- (id)existingProjectForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!fileURLRef || ![*fileURLRef isFileURL]) {
		return nil;
	}
	NSURL * fileURL = *fileURLRef;// don't change fileURL
	id projectDocument = [self projectForURL:fileURL];
	if (projectDocument) {
		return projectDocument;// this filename is already registered, possibly with a "nil" project ("nil" projects are no longer supported, see "Elementary")
	}
	// reentrant code
	[self setProject:nil forURL:fileURL];
	if (![self canGetNewProjectForURL:fileURL error:outErrorPtr]) {
		return nil;
	}
	[self willGetNewProjectForURL:fileURL];
	// nil is returned for project file names...
	NSString * projectDocumentType4iTM3 = [SDC projectDocumentType4iTM3];
	if (([[SDC typeForContentsOfURL:fileURL error:nil] conformsToUTType4iTM3:projectDocumentType4iTM3]
		&& [SDC documentClassForType:(NSString *)projectDocumentType4iTM3])
		|| (projectDocument = [self getOpenProjectForURL:fileURL])
		|| (projectDocument = [self getProjectInWrapperForURL:fileURL display:display error:outErrorPtr])
		|| (projectDocument = [self getProjectInHierarchyForURL:fileURL display:display error:outErrorPtr])
		|| (projectDocument = [self getProjectFromPanelForURLRef:fileURLRef display:display error:outErrorPtr])) {
		if ([*fileURLRef isRelativeToURL4iTM3:[NSURL factoryURL4iTM3]]) {
			*fileURLRef = fileURL;
		}
		[self setProject:projectDocument forURL:*fileURLRef];// not fileURL!!! it may have changed
		[self didGetNewProjectForURL:fileURL];
		return projectDocument;
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  freshProjectForURLRef:display:error:
- (id)freshProjectForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
Latest Revision: Thu Oct  7 07:15:09 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!fileURLRef || ![*fileURLRef isFileURL]) {
		return nil;
	}
	NSURL * fileURL = *fileURLRef;// don't change the fileURLRef for now
	id projectDocument = [self projectForURL:fileURL];
	if (projectDocument) {
		return projectDocument;// this filename is already registered, possibly with a "nil" project ("nil" projects are no longer supported, see "Elementary")
	}
	// reentrant code in 3 steps, 2 here and the conclusion when everything is terminated
	if (![self canGetNewProjectForURL:fileURL error:outErrorPtr]) {
		return nil;
	}
	[self willGetNewProjectForURL:fileURL];
	// nil is returned for project file names...
	NSString * projectDocumentType4iTM3 = [SDC projectDocumentType4iTM3];
	if (([SWS isProjectPackageAtURL4iTM3:fileURL] && [SDC documentClassForType:projectDocumentType4iTM3])
		&& ((projectDocument = [self getOpenProjectForURL:fileURL])
            || (projectDocument = [self getProjectInWrapperForURL:fileURL display:display error:outErrorPtr])
            || (projectDocument = [self getProjectInHierarchyForURL:fileURL display:display error:outErrorPtr])
            || (projectDocument = [self getProjectFromPanelForURLRef:fileURLRef display:display error:outErrorPtr]))) {
		if ([*fileURLRef isRelativeToURL4iTM3:[NSURL factoryURL4iTM3]]) {
			*fileURLRef = fileURL;
		}
		[self setProject:projectDocument forURL:fileURL];
		[self setProject:projectDocument forURL:*fileURLRef];// not only fileURL!!! it may have changed
		[self didGetNewProjectForURL:fileURL];// reentrant management final step
		return projectDocument;
	}
	return nil;
}

#pragma mark =-=-=-=-=-  BASE PROJECTS
@synthesize baseProjects = base_projects4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfBaseProjects
- (NSUInteger)countOfBaseProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 06:05:47 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.baseProjectNames.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectNames
- (NSArray *)baseProjectNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 06:05:27 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.baseURLs4ProjectName.allKeys;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectForURL:
- (id)baseProjectForURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 06:08:54 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    NSParameterAssert(nil != projectURL);
	projectURL = projectURL.URLByStandardizingPath;
    iTM2ProjectDocument * P = [self.baseProjects objectForKey:projectURL];
    if (P) {
        return P;
	}
	if (iTM2DebugEnabled>100000) {
		LOG4iTM3(@"projectURL:%@",projectURL);
	}
	// is it really a base project we have been asked for?
	NSString * projectName = projectURL.lastPathComponent.stringByDeletingPathExtension;
	NSArray * baseURLs = [self.baseURLs4ProjectName objectForKey:projectName];
	NSAssert([baseURLs containsObject:projectURL],@"! CODE ERROR: baseProjectForURL parameter must be a base project name.");
	NSString * type = [SDC typeForContentsOfURL:projectURL error:NULL];
	if (P = [SDC makeUntitledDocumentOfType:type error:nil]) {
		P.fileURL = projectURL;
		P.fileType = type;
		if (![P readFromURL:projectURL ofType:type error:nil]) {
			LOG4iTM3(@"Could not open the project document:%@", projectURL);
		}
		[self.baseProjects setObject:P forKey:projectURL];
	}
//END4iTM3;
	return P;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getBaseProjectForURL:
- (id)getBaseProjectForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.baseProjects objectForKey:fileURL.URLByStandardizingPath];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectWithName:
- (id)baseProjectWithName:(NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 06:09:27 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * URLs = [self.baseURLs4ProjectName objectForKey:projectName];
//END4iTM3;
	return URLs.count? [self baseProjectForURL:[URLs objectAtIndex:0]]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedBaseProjectNames
- (NSArray *)orderedBaseProjectNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 06:17:21 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// get in MRA an ordered list of the project names, from the shortest to the longest
	// and alphabetically, when the length is the same
    //  This will be overriden by TeX foundation
	NSURL * baseProjectsRepositoryURL = NSBundle.mainBundle.temporaryBaseProjectsDirectoryURL4iTM3;
	NSMutableSet * MS = [NSMutableSet set];
	for (NSURL * url in [DFM contentsOfDirectoryAtURL:baseProjectsRepositoryURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
		for (url in [DFM contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
            if ([SWS isProjectPackageAtURL4iTM3:url] && ![SWS isBackupAtURL4iTM3:url]) {
                [MS addObject:url.lastPathComponent.stringByDeletingPathExtension];
            }
		}
	}
	self.baseNamesOfAncestorsForBaseProjectName = nil;// recreate the map
	if (!MS.count) {
		LOG4iTM3(@"ERROR: no base projects are available, please reinstall");
		return nil;
	}
	NSMutableArray * MRA = [NSMutableArray arrayWithObject:MS.anyObject];
	[MS removeObject:MRA.lastObject];
	for (NSString * path in MS) {
		NSUInteger index = MRA.count;
        while (YES) {
            if (index--) {
                if (([[MRA objectAtIndex:index] length] < path.length)
                    || (([[MRA objectAtIndex:index] length] == path.length)
                        && ([(NSString *)[MRA objectAtIndex:index] compare: path] == NSOrderedDescending))) {
                    [MRA insertObject:path atIndex:index+1];
                } else {
                    continue;
                }
            } else {
                [MRA insertObject:path atIndex:0];
            }
        }
        break;
	}
//END4iTM3;
	return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyBaseNameMapping
- (NSDictionary *)lazyBaseNameMapping;
/*"Description forthcoming. Subclassers will override this! Not exposed.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 13:00:47 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * MRA = [NSMutableArray arrayWithArray:self.orderedBaseProjectNames];
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	while (MRA.count) {
		NSString * name = MRA.lastObject;
		[MRA removeLastObject];
		if ([name isEqualToString:iTM2ProjectDefaultName]) {
			[MD setObject:@"" forKey:name];
		} else {
			NSEnumerator * E = MRA.reverseObjectEnumerator;// from the longest to the shortest, subclassed for a more clever test
			NSString * baseName;
            while (YES) {
                if (baseName = E.nextObject) {
                    if ([name rangeOfString:baseName].length) {
                        [MD setObject:baseName forKey:name];
                    } else {
                        continue;
                    }
                } else {
                    [MD setObject:iTM2ProjectDefaultName forKey:name];
                }
                break;
            }
		}
	}
//END4iTM3;
	return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedBaseProjectURLsForName:
- (NSArray *)orderedBaseProjectURLsForName:(NSString *)expectedName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 06:17:59 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * url = NSBundle.mainBundle.temporaryBaseProjectsDirectoryURL4iTM3;
	NSMutableArray * MRA = [NSMutableArray array];
	for (url in [DFM contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray array] options:0 error:nil]) {
        url = url.URLByResolvingSymlinksInPath;
        if ([expectedName pathIsEqual4iTM3:url.lastPathComponent.stringByDeletingPathExtension]) {
			[MRA addObject:url.standardizedURL4iTM3];
		}
	}
//END4iTM3;
	return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateBaseProjectsNotified:
- (void)updateBaseProjectsNotified:(NSNotification *) irrelevant;
/*"Description forthcoming. startup time used 1883/4233=0,44483817623, 0,23483309144
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  The idea is to use a soft link targeted to the base project and located in a unique directory
	NSBundle * MB = [NSBundle mainBundle];
    //  Create the folder of base projects in the user support domain
    //  This is for the side effect, maybe it is not the good time to do that 
	[MB URLForSupportDirectory4iTM3:iTM2ProjectBaseComponent inDomain:NSUserDomainMask create:YES];
    //  Retrieve all the paths 
	NSArray * URLs = [MB allURLsForResource4iTM3:iTM2ProjectBaseComponent withExtension:@""];
	NSUInteger index = URLs.count;
	NSURL * P = nil;
	NSString * source = nil;
	[self.baseURLs4ProjectName setDictionary:[NSDictionary dictionary]];// clean the previous cache
	DFM.delegate = self;
	NSURL * baseProjectsRepositoryURL = MB.temporaryBaseProjectsDirectoryURL4iTM3;
    NSURL * url = nil;
    NSString * K = nil;
	NSMutableArray * MRA;
	while (index--) {
		P = [URLs objectAtIndex:index];
		url = [baseProjectsRepositoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%i.texps",index]];
        if (url.isFileURL) {
            source = url.path;
            NSError * localError = nil;
             if ((([DFM fileExistsAtPath:source] || [DFM destinationOfSymbolicLinkAtPath:source error:&localError])
                && ![DFM removeItemAtPath:source error:&localError])
                    || ![DFM createSymbolicLinkAtPath:source withDestinationPath:P.path error:&localError]) {
                LOG4iTM3(@"FAILURE: the base project folder %@ is not registered due to error:%@",P,localError);
            } else {
                //  Now there is a symbolic link "index".texps -> P
                //  Explore now the contents of the project folders
                for (url in [DFM contentsOfDirectoryAtURL:P includingPropertiesForKeys:[NSArray array] options:0 error:NULL]) {
                    url = url.URLByResolvingSymlinksInPath;// don't miss that!
                    //  get the base name
                    if ([SWS isProjectPackageAtURL4iTM3:url]) {
                        K = url.lastPathComponent.stringByDeletingPathExtension;
                        if (MRA = [self.baseURLs4ProjectName objectForKey:K]) {
                            [MRA addObject:url];
                        } else {
                            [self.baseURLs4ProjectName setObject:[NSMutableArray arrayWithObject:url] forKey:K];
                        }
                    }
                }
            }
        }
    }
	//remove some extra links that may live there, after index
    while (YES) {
        url = [baseProjectsRepositoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%i.texps",index]];
        source = url.isFileURL?url.path:@"";
        if (([DFM fileExistsAtPath:source] || [DFM destinationOfSymbolicLinkAtPath:source error:NULL])
                && [DFM removeItemAtPath:source error:NULL]) {
            ++index;
            continue;
        }
        break;
    }
    self.baseNamesOfAncestorsForBaseProjectName = [NSMutableDictionary dictionary];
	// update the base projects
	for (P in [self.baseProjects allKeys]) {
		K = P.lastPathComponent.stringByDeletingPathExtension;
		if (!(MRA = [self.baseURLs4ProjectName objectForKey:K]) || ![MRA containsObject:P]) {
			// this project has been removed
			[[[self.baseProjects objectForKey:P] retain] autorelease];
			[self.baseProjects removeObjectForKey:P];

		}
	}
	DFM.delegate = nil;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyBaseNamesOfAncestorsForBaseProjectName:
- (NSArray *)lazyBaseNamesOfAncestorsForBaseProjectName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 21:15:12 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  to be overloaded
	if (![self.baseProjectNames containsObject:name]) {
		return [NSArray arrayWithObject:name];
	}
//END4iTM3;
	return [NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseNamesOfAncestorsForBaseProjectName:
- (NSArray *)baseNamesOfAncestorsForBaseProjectName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 21:15:32 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([name isEqualToString:iTM2ProjectDefaultName]) {
		return [NSArray array];
	}
	NSMutableDictionary * MD = self.baseNamesOfAncestorsForBaseProjectName;
	if (!MD) {
		[self updateBaseProjectsNotified:nil];
		MD = self.baseNamesOfAncestorsForBaseProjectName;
	}
//END4iTM3;
	id result = [MD objectForKey:name];
	if (result) {
		return result;
    }
	// now is time to cache
	if ((result = [self lazyBaseNamesOfAncestorsForBaseProjectName:name])) {
		[MD setObject:result forKey:name];
		return result;
	}
	return [NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isBaseProject:
- (BOOL)isBaseProject:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
Latest Revision: Sat Jan 30 10:15:45 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	for (id O in self.baseProjects)
		if (O == argument)// no message ever sent to argument, maybe argument is not an object, or has been freed!
			return YES;
    return NO;
}
#pragma mark =-=-=-=-=-  CURRENT PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentProject
- (id)currentProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 21:15:58 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [[SDC currentDocument] project4iTM3];
	if (result != currentProject4iTM3) {
		id old = currentProject4iTM3;
		currentProject4iTM3 = result;// reentrant firewall
		[INC performSelector:@selector(postNotification:) withObject:
			[NSNotification notificationWithName:iTM2ProjectCurrentDidChangeNotification
				object:self userInfo:([self isProject:currentProject4iTM3]? [NSDictionary dictionaryWithObjectsAndKeys:old,@"oldProject",nil]:nil)]
			afterDelay:0];// notice the isProject:that ensures old is consistent
		for (iTM2ProjectDocument * projectDocument in self.projects) {
			if (projectDocument == result) {
				[projectDocument exposeWindows];
			} else {
				[projectDocument dissimulateWindows];
			}
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidBecomeKeyOrMainNotified:
- (void)windowDidBecomeKeyOrMainNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 21:16:56 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.currentProject;
//END4iTM3;
    return;
}
@synthesize baseNamesOfAncestorsForBaseProjectName = base_names_of_ancestors4iTM3;
@synthesize baseURLs4ProjectName = base_URLs_4_project_name4iTM3;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectControllerKit
#pragma mark -
@interface iTM2NoProjectSheetController(PRIVATE)
- (IBAction)accept:(id)sender;
- (IBAction)refuse:(id)sender;
- (IBAction)toggleDontShowAgain:(id)sender;
@end

static NSString * const iTM2DontShowNoProjectNote = @"iTM2DontShowNoProjectNote";

@implementation iTM2NoProjectSheetController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  alertForWindow:
+ (BOOL)alertForWindow:(id)window;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 21:19:40 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled || ![SUD boolForKey:iTM2DontShowNoProjectNote]) {
		iTM2NoProjectSheetController * WC = [self.alloc initWithWindowNibName:@"iTM2NoProjectSheetController"];
		NSWindow * W = WC.window;
		if (!W) {
			LOG4iTM3(@"WARNING:Missing a  an iTM2NoProjectSheetController window.");
		} else {
			[NSApp beginSheet:W modalForWindow:window modalDelegate:nil didEndSelector:NULL contextInfo:nil];
			[WC validateWindowContent4iTM3];
//LOG4iTM3(@"sheet is here and validated");
			NSInteger returnCode = [NSApp runModalForWindow:W];
			[NSApp endSheet:W];
			[W orderOut:self];
			if (returnCode == 1)
				return YES;
		}
		return NO;
	} else {
		return YES;
    }
//END4iTM3;
}
- (IBAction)accept:(id)sender;
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSApp stopModalWithCode:1];
//END4iTM3;
	return;
}
- (IBAction)refuse:(id)sender;
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSApp stopModalWithCode:0];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDontShowAgain:
- (IBAction)toggleDontShowAgain:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 21:19:33 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3(@"%@ is %@",[SUD objectForKey:iTM2DontShowNoProjectNote],([SUD boolForKey:iTM2DontShowNoProjectNote]? @"Y":@"N"));
	BOOL oldFlag = [SUD boolForKey:iTM2DontShowNoProjectNote];
	[SUD setObject:[NSNumber numberWithBool:!oldFlag] forKey:iTM2DontShowNoProjectNote];
	[sender validateWindowContent4iTM3];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDontShowAgain:
- (BOOL)validateToggleDontShowAgain:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May 15 21:19:29 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3(@"%@ is %@",[SUD objectForKey:iTM2DontShowNoProjectNote],([SUD boolForKey:iTM2DontShowNoProjectNote]? @"Y":@"N"));
	sender.state = [SUD boolForKey:iTM2DontShowNoProjectNote]? NSOnState:NSOffState;
	return YES;
}
@end

@implementation iTM2NewProjectController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpProject:
- (void)setUpProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL *)fileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
Subclassers
Latest Revision: Sun Mar 28 08:34:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (fileURL != _FileURL4iTM3) {
        _FileURL4iTM3 = fileURL.copy;
        self.projectDirURL = fileURL.directoryURL4iTM3;
        self.isAlreadyDirectoryWrapper = NO;
        while ((fileURL = fileURL.parentDirectoryURL4iTM3)) {
            if ([[SDC typeForContentsOfURL:fileURL error:NULL] conformsToUTType4iTM3:[SDC wrapperDocumentType4iTM3]]) {
                self.isAlreadyDirectoryWrapper = YES;
                self.toggleProjectMode = iTM2ToggleNewProjectMode;
                self.projectDirURL = fileURL;
                return;
            }
        }
    }
	// not a .texd descendant
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectName
- (NSURL *)projectURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.toggleProjectMode == iTM2ToggleNewProjectMode) {
		return [[NSURL URLWithPath4iTM3:self.newProjectName relativeToURL:self.projectDirURL] URLByStandardizingPath];
	} else if (self.toggleProjectMode == iTM2ToggleOldProjectMode) {
		return self.selectedRow >= 0 && self.selectedRow < self.projects.count ?
			[NSURL fileURLWithPath:[[self.projects objectAtIndex:self.selectedRow] objectForKey:@"path"]]:nil;
	} else {
		return nil;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDirURL
- (NSURL *)projectDirURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.isAlreadyDirectoryWrapper) {
		return _ProjectDirURL4iTM3;
	}
	if (self.isDirectoryWrapper && (self.toggleProjectMode != iTM2ToggleOldProjectMode)) {
		NSString * component = self.fileURL.lastPathComponent.stringByDeletingPathExtension;
		if (component.length) {
			return [[NSURL URLWithPath4iTM3:component relativeToURL:_ProjectDirURL4iTM3] URLByStandardizingPath];
		} else {
			LOG4iTM3(@"Weird _ProjectDirURL4iTM3");
			return nil;
		}
	}
//LOG4iTM3(@"projectDirName is:%@",result);
	return _ProjectDirURL4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void)windowWillLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	//Preparing the projects for the table view
	self.selectedRow = 0;
	self.projects = [NSMutableArray array];
	NSDictionary * availableProjects = [SPC availableProjectsForURL:[self.fileURL directoryURL4iTM3]];
	NSEnumerator * E = [[[availableProjects allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	NSString * path;
	while(path = [E nextObject]) {
		[self.projects addObject:[NSDictionary dictionaryWithObjectsAndKeys:
			path,@"path",
			[availableProjects objectForKey:path],@"displayName",
			nil]];
	}
//LOG4iTM3(@"self.projects:%@",self.projects);
	self.toggleProjectMode = self.projects.count>0? iTM2ToggleOldProjectMode:iTM2ToggleNewProjectMode;
	self.isDirectoryWrapper = (self.projects.count>0)|| [SUD boolForKey:iTM2ProjectIsDirectoryWrapperKey];
    [super windowWillLoad];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowDidLoad];
	self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (void)OK:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.toggleProjectMode == iTM2ToggleNewProjectMode) {
		[SUD setObject:[NSNumber numberWithBool:self.isDirectoryWrapper] forKey:iTM2ProjectIsDirectoryWrapperKey];
	}
	[NSApp stopModalWithCode:self.toggleProjectMode];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  noProject:
- (IBAction)noProject:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([iTM2NoProjectSheetController alertForWindow:sender.window]) {
		[NSApp stopModalWithCode:iTM2ToggleNoProjectMode];
	}
//END4iTM3;
	return ;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNoProject:
- (BOOL)validateNoProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return !self.isAlreadyDirectoryWrapper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNewProject:
- (IBAction)toggleNewProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.toggleProjectMode = iTM2ToggleNewProjectMode;
	[sender validateWindowContent4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNewProject:
- (BOOL)validateToggleNewProject:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = self.toggleProjectMode == iTM2ToggleNewProjectMode? NSOnState:NSOffState;
//END4iTM3;
	return !self.isAlreadyDirectoryWrapper && (self.projects.count>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDirectoryWrapper:
- (IBAction)toggleDirectoryWrapper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.isDirectoryWrapper = !self.isDirectoryWrapper;
	[sender validateWindowContent4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDirectoryWrapper:
- (BOOL)validateToggleDirectoryWrapper:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.isAlreadyDirectoryWrapper) {
		sender.state = NSOffState;
		return NO;
	} else {
		sender.state = (self.isDirectoryWrapper? NSOnState:NSOffState);
		return self.toggleProjectMode == iTM2ToggleNewProjectMode;
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectNameEdited:
- (IBAction)newProjectNameEdited:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * senderString = sender.stringValue.stringByDeletingPathExtension;
	if (senderString.length) {
		NSString * new = [senderString stringByAppendingPathExtension:[SDC projectPathExtension4iTM3]];
		if (![new pathIsEqual4iTM3:self.newProjectName]) {
			self.newProjectName = new;
			[sender validateWindowContent4iTM3];
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNewProjectNameEdited:
- (BOOL)validateNewProjectNameEdited:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!self.newProjectName) {
		if (self.isAlreadyDirectoryWrapper) {
			self.newProjectName = iTM2ProjectTable;
		} else {
			NSString * name = self.fileURL.lastPathComponent.stringByDeletingPathExtension;
			if (name.length) {
				self.newProjectName = [name stringByAppendingPathExtension:[SDC projectPathExtension4iTM3]];
			} else {
				LOG4iTM3(@"Weird? void _FileName");
				self.newProjectName = @"";
			}
		}
	}
	sender.stringValue = self.newProjectName.stringByDeletingPathExtension;
	if (self.toggleProjectMode == iTM2ToggleNewProjectMode) {
		[sender setEnabled:YES];
		if (![sender.window.firstResponder isEqual:sender]) {
			[sender.window makeFirstResponder:sender];
			[sender selectText:self];
		}
        return YES;
	}
	else
		return NO;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOldProject:
- (IBAction)toggleOldProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.toggleProjectMode = iTM2ToggleOldProjectMode;
	[sender validateWindowContent4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOldProject:
- (BOOL)validateToggleOldProject:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.projects.count) {
		sender.state = (self.toggleProjectMode == iTM2ToggleOldProjectMode? NSOnState:NSOffState);
		return !self.isAlreadyDirectoryWrapper;
	} else {
		sender.state = NSOffState;
		sender.action = NULL;
		return NO;
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjects
- (id)availableProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAvailableProjects:
- (void)setAvailableProjects:(id) argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  ALREADY EXISTING PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewAction:
- (IBAction)tableViewAction:(NSTableView *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([sender numberOfRows]) {
		self.toggleProjectMode = iTM2ToggleOldProjectMode;
		NSInteger new  = [sender selectedRow];
		if (new != self.selectedRow)
			self.selectedRow = new;
	} else {
		[sender.window makeFirstResponder:[sender superview]];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTableViewAction:
- (BOOL)validateTableViewAction:(NSTableView *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.selectedRow<0) {
		self.selectedRow = 0;
        }
	if (self.selectedRow < self.projects.count) {
		[sender deselectAll:self];
		[sender selectRowIndexes:[NSIndexSet indexSetWithIndex:self.selectedRow] byExtendingSelection:NO];
		return YES;
	} else {
		sender.action = NULL;
		return NO;
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return self.projects.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;

//END4iTM3;
	if (row<0)
		return nil;
	else if (row<self.projects.count) {
		return [[self.projects objectAtIndex:row] objectForKey:@"displayName"];
	}
	else
		return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (void)cancel:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSApp stopModalWithCode:(self.isAlreadyDirectoryWrapper? iTM2ToggleNewProjectMode:iTM2ToggleStandaloneMode)];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCreateNewProject
- (BOOL)canCreateNewProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canInsertInProject
- (BOOL)canInsertInProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return self.projects.count>0;
}
@synthesize fileURL = _FileURL4iTM3;
@synthesize newProjectName = _NewProjectName4iTM3;
@synthesize projectDirURL = _ProjectDirURL4iTM3;
@synthesize projects = _Projects4iTM3;
@synthesize availableProjects = _AvailableProjects4iTM3;
@synthesize selectedRow = _SelectedRow4iTM3;
@synthesize toggleProjectMode = _ToggleProjectMode4iTM3;
@synthesize isAlreadyDirectoryWrapper = _IsAlreadyDirectoryWrapper4iTM3;
@synthesize isDirectoryWrapper = _IsDirectoryWrapper4iTM3;
@end

@implementation NSWorkspace(iTM2ProjectControllerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isBackupAtURL4iTM3:
- (BOOL)isBackupAtURL4iTM3:(NSURL *)url;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Jun  2 06:49:52 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return ![url.lastPathComponent.stringByDeletingPathExtension hasSuffix:@"~"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isFilePackageAtURL4iTM3:
- (BOOL)isFilePackageAtURL4iTM3:(NSURL *)url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return url.isFileURL&&[self isFilePackageAtPath:url.path];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isProjectPackageAtURL4iTM3:
- (BOOL)isProjectPackageAtURL4iTM3:(NSURL *)url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (url) {
		NSInvocation * I;
		[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] isProjectPackageAtURL4iTM3:url];
		NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"ProjectPackageAtURL4iTM3:" signature:[I methodSignature] inherited:YES];
		NSUInteger i = PA.count;
		while(i--) {
			SEL selector = (SEL)[PA pointerAtIndex:i];
			if (selector != _cmd) {
				I.selector = selector;
				I.invoke;
				BOOL R = NO;
				[I getReturnValue:&R];
				if (R) {
					return YES;
				}
			}
		}
        NSString * type = [SDC typeForContentsOfURL:url error:nil];
		return type!=nil && UTTypeConformsTo((CFStringRef)type,(CFStringRef)iTM2UTTypeProject);
	}
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isWrapperPackageAtURL4iTM3:
- (BOOL)isWrapperPackageAtURL4iTM3:(NSURL *)url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 08:17:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if (url) {
		NSInvocation * I;
		[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] isWrapperPackageAtURL4iTM3:url];
		NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"WrapperPackageAtURL4iTM3:" signature:[I methodSignature] inherited:YES];
		NSUInteger i = PA.count;
		while(i--) {
			SEL selector = (SEL)[PA pointerAtIndex:i];
			if (selector != _cmd) {
				I.selector = selector;
				I.invoke;
				BOOL R = NO;
				[I getReturnValue:&R];
				if (R) {
					return YES;
				}
			}
		}
        NSString * theType = [SDC typeForContentsOfURL:url error:NULL];
		return [theType conformsToUTType4iTM3:iTM2UTTypeWrapper];
	}
//END4iTM3;
    return NO;
}
@end

NSString * const iTM2ProjectBaseComponent = @"Base Projects.localized";

@implementation NSBundle(iTM2Project)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  temporaryBaseProjectsDirectoryURL4iTM3
- (NSURL *)temporaryBaseProjectsDirectoryURL4iTM3;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Jan 29 23:59:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSURL * url = nil;
	if (!url) {
		url = self.temporaryDirectoryURL4iTM3;
		url = [url URLByAppendingPathComponent:iTM2ProjectBaseComponent];
		NSError * localError = nil;
		if (![DFM createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:&localError]) {
			if (localError) {
				REPORTERROR4iTM3(125,(@"FAILURE: no temporary repository for base projects, do you have write access somewhere?"),localError);
			}
			url = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
			url = [url URLByAppendingPathComponent:iTM2ProjectBaseComponent];
			localError = nil;
			if (![DFM createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:&localError]) {
				if (localError) {
					REPORTERROR4iTM3(125,(@"FAILURE: no temporary repository for base projects, do you have write access somewhere?"),localError);
				}
				url = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
			}
		}
        [url retain];
	}
//END4iTM3;
	return url;
}
@end

#import "iTM2DocumentKit.h"

@interface iTM2PDocumentController: iTM2DocumentController

/*!
    @method		openDocumentWithContentsOfURL:display:error:
    @abstract	Entry point for the document creation.
    @discussion	This implementation manages the complex wrapper/project/document architecture.
				Roughly speaking, you have wrappers with projects and documents,
				projects with documents but no wrapper, and document with no wrapper nor project.
				As the wrapper is the most intrusive design it is not central in the code.
				The project design is central, so everything is project centric.
				Each project owns its documents, not the document controller!
				And when there is a wrapper, the project is owned by the wrapper, not the document controller.
				Finally the wrapper if any is owned by the document controller.
				But when we have wrappers, we have to automatically open (or create) the associated project,
				and also manage the save as and save to actions in a fancy way.
				See the inherited method for details on the parameters and the result.
    @param		URL.
    @param		display.
    @result		A document.
*/
- (id)openDocumentWithContentsOfURL:(NSURL *)URL display:(BOOL)display error:(NSError **)error;

/*!
    @method		prepareOpenDocumentWithContentsOfURL:
    @abstract	Prepare the receiver to open the given document.
    @discussion	This methods is used when a file is opened by the Finder. If there is no project for the given argument,
				a library project is created without asking the user.
    @param		URL.
*/
- (void)prepareOpenDocumentWithContentsOfURL:(NSURL *)absoluteURL;

@end

@implementation NSApplication(iTM2PDocumentController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentControllerCompleteInstallation4iTM3
+ (void)documentControllerCompleteInstallation4iTM3;
/*"Installs the custom document controller.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocumentController * DC = [[iTM2PDocumentController alloc] performSelector:@selector(init)];
    NSAssert((DC == SDC), @"MISSED, bad document controller...");
    return;
}
@end

@implementation iTM2PDocumentController
- (NSString *)typeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outError;
{
    NSString * theType = [super typeForContentsOfURL:inAbsoluteURL error:outError];
    return theType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= noteNewRecentDocumentURL:
- (void)noteNewRecentDocumentURL:(NSURL *)absoluteURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (absoluteURL.isFileURL) {
		NSURL * enclosingURL = [absoluteURL enclosingProjectURL4iTM3];
		if (enclosingURL && ![[absoluteURL URLByStandardizingPath] isEqual:[enclosingURL URLByStandardizingPath]]) {
			[super noteNewRecentDocumentURL:enclosingURL];// we replace the file by its enclosing project
			return;
		}
		if ([SWS isWrapperPackageAtURL4iTM3:absoluteURL] && [absoluteURL belongsToFactory4iTM3]) {
			return;
		}
		if (enclosingURL = absoluteURL.enclosingWrapperURL4iTM3) {
			NSArray * enclosed = enclosingURL.enclosedProjectURLs4iTM3;
			if (enclosed.count == 1) {
				absoluteURL = enclosed.lastObject;
			}
			else if ([SWS isProjectPackageAtURL4iTM3:absoluteURL]) {
				// there are many different projects inside the wrapper but we are asked for one in particular
			}
			else
			{
				// there are many project inside the wrapper,which one should I use?
				iTM2ProjectDocument * PD = [SPC projectForURL:absoluteURL];
				if (PD) {
					// due to the previous test,absoluteURL and the project file URL must be different
					// no infinite loop
					if ([PD.fileURL belongsToFactory4iTM3])
					{
						[super noteNewRecentDocumentURL:absoluteURL];// inherited behaviour
						return;
					}
					else
					{
						[super noteNewRecentDocumentURL:PD.fileURL];// we replace the file by its project
						return;
					}
				}
			}
		}
	}
	[super noteNewRecentDocumentURL:absoluteURL];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addDocument:
- (void)addDocument:(NSDocument *)document;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"document:%@",document);
	}
    [super addDocument:document];
    [SPC registerProject:(iTM2ProjectDocument *)document];// will be registered only if document has the proper class
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeDocument:
- (void)removeDocument:(NSDocument *)document;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id projectDocument = [document project4iTM3];
	if ([self.documents containsObject:document]) {
		// the document is owned by the document controller
		// it should not be owned by a project,
		[projectDocument removeSubdocument:document];
	}
	else
	{
		// the document is owned by the project
		// It is removed from the list of open project documents,
		[projectDocument closeSubdocument:document];
	}
    [super removeDocument:document];
	LOG4iTM3(@"[document retainCount]:%i",[document retainCount]);
//	[SPC forgetProject:document];// too early
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareOpenDocumentWithContentsOfURL:
- (void)prepareOpenDocumentWithContentsOfURL:(NSURL *)absoluteURL;
/*"This one is responsible of the management of the project,including the wrapper.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL) {// I only catch file URLs
		return;
	}
	// I do not know exactly what I should do here
    id projectDocument = [SPC projectForURL:absoluteURL];
	if (projectDocument)
    {
//LOG4iTM3(@"1");
		return;
    }
	NSMutableArray * MRA = [[[SUD stringArrayForKey:@"_iTM2DocumentFileURLsOpenedFromFinder"] mutableCopy] autorelease];
	if (!MRA) {
		MRA = [NSMutableArray array];
	}
	NSString * fileName = [[absoluteURL URLByStandardizingPath] path];// not a link!
	if (![MRA containsObject:fileName]) {
		[MRA addObject:fileName];
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:MRA forKey:@"_iTM2DocumentFileURLsOpenedFromFinder"]];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _openProjectDocumentWithContentsOfURL:display:error4iTM3:
- (id)_openProjectDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)display error4iTM3:(NSError **)outErrorPtr;
/*"This one is responsible of the management of the project, including the wrapper.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Oct  6 13:39:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![SWS isProjectPackageAtURL4iTM3:absoluteURL]) {
		return nil;
	}
    NSParameterAssert(absoluteURL.isFileURL);
	NSError * outError = nil;
	if (outErrorPtr) {
		*outErrorPtr = nil;
	}
    //  There are 3 kinds of projects
    //  - inside wrappers inside the factory
    //  - inside wrappers out of the factory
    //  - outside wrappers and out of the factory
    NSURL * projectURL1 = absoluteURL.URLByRemovingFactoryBaseURL4iTM3;
    NSURL * projectURL2 = projectURL1.URLByRemovingParentPathExtension4iTM3;
    NSURL * projectURL3 = projectURL1.URLByDeletingParentLastPathComponent4iTM3;
    NSURL * factoryURL = absoluteURL.URLByPrependingFactoryBaseURL4iTM3;
    NSURL * folderURL = nil;
	if (absoluteURL.belongsToFactory4iTM3) {
        //  the factory location is just a convenient place, it must not replace the normal location
        //  unless there is a big problem with RW access
		//  we try to avoid opening directly a project in the factory...
        //  conversion for standalone documents
        //  we try to move something from the cache location to the uncached one
        //  typically,
        //  factoryURL = file://localhost/Volumes/boot_volume/.../Factory/.../MyFolder/foo.texd/foo.texp/
        //  folderURL = file://localhost/Volumes/boot_volume/.../Users/.../MyFolder/
		if ([DFM fileExistsAtPath:projectURL1.path]) {
            if ([DFM isWritableFileAtPath:projectURL1.path]) {
                if ([DFM removeItemAtURL:factoryURL error:&outError]) {
                    factoryURL = factoryURL.URLByDeletingLastPathComponent;
                    if (![[DFM contentsOfDirectoryAtPath:factoryURL.path error:&outError] count]) {
                        [DFM removeItemAtURL:factoryURL error:&outError];
                    }
                }
            }
			return [super openDocumentWithContentsOfURL:projectURL1 display:display error:outErrorPtr];
		} else if ([DFM fileExistsAtPath:projectURL2.path]) {
            if ([DFM isWritableFileAtPath:projectURL2.path]) {
                if ([DFM removeItemAtURL:factoryURL error:&outError]) {
                    factoryURL = factoryURL.URLByDeletingLastPathComponent;
                    if (![[DFM contentsOfDirectoryAtPath:factoryURL.path error:&outError] count]) {
                        [DFM removeItemAtURL:factoryURL error:&outError];
                    }
                }
            }
			return [super openDocumentWithContentsOfURL:projectURL2 display:display error:outErrorPtr];
		} else if ([DFM fileExistsAtPath:projectURL3.path]) {
            if ([DFM isWritableFileAtPath:projectURL3.path]) {
                if ([DFM removeItemAtURL:factoryURL error:&outError]) {
                    factoryURL = factoryURL.URLByDeletingLastPathComponent;
                    if (![[DFM contentsOfDirectoryAtPath:factoryURL.path error:&outError] count]) {
                        [DFM removeItemAtURL:factoryURL error:&outError];
                    }
                }
            }
			return [super openDocumentWithContentsOfURL:projectURL3 display:display error:outErrorPtr];
		} else if ([DFM fileExistsAtPath:factoryURL.path]) {
            //  there is only a project in the factory
            //  This is a situation we are going to avoid by asking the user not to typeset files that are in a read only folder
            //  preferably... which means that we connot absolutely prevent that.
            //  We will try to move the factory project to the normal location
            absoluteURL = [self contextBoolForKey:iTM3ProjectPreferWrappers domain:iTM2ContextAllDomainsMask]?projectURL1:projectURL2;
            //  We are going to move factoryURL to absoluteURL, the latter one does not exist due to the tests above
            folderURL = absoluteURL.URLByDeletingLastPathComponent;
            //  I would like, if necesary, to create the intermediate folder at folderURL and place the factory project package inside
            if (![DFM fileExistsAtPath:folderURL.path] && ![DFM createDirectoryAtPath:folderURL.path withIntermediateDirectories:YES attributes:nil error:&outError]) {
				OUTERROR4iTM3(2,([NSString stringWithFormat:@"Could not create folder at\n%@",absoluteURL,factoryURL]),outError);
                //  unable to create this folder
                //  possibly due to W+ limitations
                //  really return the factory project
                return [super openDocumentWithContentsOfURL:factoryURL display:display error:outErrorPtr];
            }
			if (![DFM moveItemAtURL:factoryURL toURL:absoluteURL error:&outError]) {
				OUTERROR4iTM3(2,([NSString stringWithFormat:@"Could not move\n%@\nto\n%@",absoluteURL,factoryURL]),outError);
                return [super openDocumentWithContentsOfURL:factoryURL display:display error:outErrorPtr];
			}
		}
	}
    return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _openWrapperDocumentWithContentsOfURL:display:error4iTM3:
- (id)_openWrapperDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)display error4iTM3:(NSError **)outErrorPtr;
/*"This one is responsible of the management of the project, including the wrapper.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Oct  6 13:39:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSParameterAssert(absoluteURL.isFileURL);
    if (![SWS isWrapperPackageAtURL4iTM3:absoluteURL]) {
		return nil;
	}
	NSError * outError = nil;
	if (outErrorPtr) {
		*outErrorPtr = nil;
	}
    NSURL * projectURL = [SPC getProjectURLInWrapperForURL:absoluteURL error:&outError];
    if (projectURL) {
        NSAssert1(![projectURL isEquivalentToURL4iTM3:absoluteURL],@"What is this project URL:<%@>",projectURL);
        return [self openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr];// second registerProject
    } else {
        [SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
            userInfo:[NSDictionary dictionaryWithObject:
                [NSString stringWithFormat:@"Missing project inside\n%@\ndocument will open with a simple project...",absoluteURL]
                    forKey:NSLocalizedDescriptionKey]]];
        NSAssert(NO,@"Not yet implemented");
        return nil;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _openFolderDocumentWithContentsOfURL:display:error4iTM3:
- (id)_openFolderDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)display error4iTM3:(NSError **)outErrorPtr;
/*"This one is responsible of the management of the project, including the wrapper.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Oct  6 13:39:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSParameterAssert(absoluteURL.isFileURL);
    NSError * outError = nil;
	if (outErrorPtr) {
		*outErrorPtr = nil;
	}
    if (![absoluteURL isDirectoryOrError4iTM3:outErrorPtr]) {
		return nil;
	}
    if ([SWS isWrapperPackageAtURL4iTM3:absoluteURL]) {
		return nil;
	}
    if ([SWS isProjectPackageAtURL4iTM3:absoluteURL]) {
		return nil;
	}
    // Is it a folder corresponding to a former wrapper or project which name was changed by the user?
    // This is possible because the app keeps tracks of the wrappers it opens through some indirect address.
    // trying to open a project document at the first level if any
    NSArray * URLs = absoluteURL.enclosedProjectURLs4iTM3;
    NSURL * url = nil;
    if (URLs.count == 1) {
        return [self openDocumentWithContentsOfURL:URLs.lastObject display:display error:outErrorPtr];
    } else if ((url = [SPC mainInfoURLFromURL:absoluteURL create:NO error:outErrorPtr])) {
        // it does not contain any project document
        // it may be itself a project wrapper!
        // is it still a project wrapper?
        NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:url];
        if ([[dict objectForKey:@"self.class"] isEqualToString:iTM2ProjectInfoMainType]) {
            // yes this is a former project.
            // Can I add such a file extension by myself?
            // yes, unless it is not possible to move the project
            NSURL * destinationURL = [absoluteURL URLByAppendingPathExtension:[SDC projectPathExtension4iTM3]];
            if ([DFM fileExistsAtPath:destinationURL.path] ||
                    ![DFM moveItemAtURL:absoluteURL toURL:destinationURL error:&outError]) {
                OUTERROR4iTM3(2,([NSString stringWithFormat:@"Confusing situation:the following directory seems to be a project despite it has no %@ path extension:\n%@\nOne cannot be added.",
                            absoluteURL,[SDC projectPathExtension4iTM3]]),outError);
                return nil;
            }
            return [self openDocumentWithContentsOfURL:destinationURL display:display error:outErrorPtr];
        }
        else if (dict) {
            OUTERROR4iTM3(3,([NSString stringWithFormat:@"Something weird occurred to that folder\n%@.",absoluteURL]),nil);
            [SWS activateFileViewerSelectingURLs:[NSArray arrayWithObject:absoluteURL]];
            return nil;
        }
    } else if (URLs.count > 0) {
        NSString * pattern = [NSString stringWithFormat:@".*\\Q%@\\E.*",absoluteURL.lastPathComponent.stringByDeletingPathExtension];
        ICURegEx * RE = [ICURegEx regExWithSearchPattern:pattern error:outErrorPtr];
        NSArray * RA = [DFM contentsOfDirectoryAtPath:absoluteURL.path error:outErrorPtr];
        RA = [RA filteredArrayUsingICURegEx4iTM3:RE];
        if (RA.count) {
            NSURL * url = [absoluteURL URLByAppendingPathComponent:RA.lastObject];
            if (RA.count == 1) {
                return [self openDocumentWithContentsOfURL:url display:display error:outErrorPtr];
            }
            OUTERROR4iTM3(1,(@"Confusing situation:too many projects in that directory.\nSee what you can do from the Finder."),nil);
            [SWS activateFileViewerSelectingURLs:[NSArray arrayWithObject:url]];
        }
        return nil;
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openDocumentWithContentsOfURL:display:error:
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"This one is responsible of the management of the project, including the wrapper.
Every document must belong to a project, either visible or hidden.
When people select the "No project" option, in fact there is a still a notion of project either hidden or virtual,
which means that some functionalities of projects are still available, but not all of them.
If some documents are meant to leave without project, then they will not typeset at all.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Oct  6 13:39:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL) {// I only catch file URLs
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
	}
	NSError * outError = nil;
	if (outErrorPtr) {
		*outErrorPtr = nil;
	}
    //  Normalize the URL according to iTM3 standards
    absoluteURL = absoluteURL.normalizedURL4iTM3;
	//  is it an already open document (including projects and wrappers) ?
    id D = nil;
	if ((D = [self documentForURL:absoluteURL])) {
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
	}
	// if the file was trashed, recover it
	NSArray * components = absoluteURL.pathComponents;
	if ([components containsObject:@".Trash"] || [components containsObject:@".Trashes"]) {
		if ([DFM fileExistsAtPath:absoluteURL.path]) {
			REPORTERROR4iTM3(1,([NSString stringWithFormat:@"Please, get %@ back from the trash before opening it.",absoluteURL.lastPathComponent]),nil);
			[SWS activateFileViewerSelectingURLs:[NSArray arrayWithObject:absoluteURL]];
		}
		return nil;
	}
	// if the file is in an invisible folder, recover it
	NSString * component;
	for(component in components) {
		if ([component hasPrefix:TWSDotKey]) {
			REPORTERROR4iTM3(1,([NSString stringWithFormat:@"Please, copy %@ to a visible location of the Finder before opening it.",absoluteURL.lastPathComponent]),nil);
			[SWS activateFileViewerSelectingURLs:[NSArray arrayWithObject:absoluteURL]];
			return nil;
		}
	}
    if ((D = [self _openProjectDocumentWithContentsOfURL:absoluteURL display:display error4iTM3:&outError])) {
        return D;
    } else if (outError) {
        OUTERROR4iTM3(1,([NSString stringWithFormat:@"Could not open\n%@\ndue to an error",absoluteURL]),outError);
		return nil;
    }
    //  resolve the URL
	NSURL * resolvedURL = [absoluteURL URLByResolvingSymlinksAndBookmarkDataWithOptions:NSURLBookmarkResolutionWithoutUI relativeToURL:nil error4iTM3:&outError];
    if (!outError && [SWS isProjectPackageAtURL4iTM3:resolvedURL]) {
        OUTERROR4iTM3(2,([NSString stringWithFormat:@"Unsupported soft link or alias\n%@\nto\n%@",absoluteURL,resolvedURL]),nil);
		return nil;
	}
    outError = nil;
    if ((D = [self _openWrapperDocumentWithContentsOfURL:absoluteURL display:display error4iTM3:&outError])) {
        return D;
    } else if (outError) {
        OUTERROR4iTM3(3,([NSString stringWithFormat:@"Could not open\n%@\ndue to an error",absoluteURL]),outError);
		return nil;
    }
    if ((D = [self _openWrapperDocumentWithContentsOfURL:resolvedURL display:display error4iTM3:&outError])) {
        return D;
    } else if (outError) {
        OUTERROR4iTM3(4,([NSString stringWithFormat:@"Could not open\n%@\ndue to an error",resolvedURL]),outError);
		return nil;
    }
    if ((D = [self _openFolderDocumentWithContentsOfURL:absoluteURL display:display error4iTM3:&outError])) {
        return D;
    } else if (outError) {
        OUTERROR4iTM3(5,([NSString stringWithFormat:@"Could not open\n%@\ndue to an error",absoluteURL]),outError);
		return nil;
    }
    if ((D = [self _openFolderDocumentWithContentsOfURL:resolvedURL display:display error4iTM3:&outError])) {
        return D;
    } else if (outError) {
        OUTERROR4iTM3(6,([NSString stringWithFormat:@"Could not open\n%@\ndue to an error",resolvedURL]),outError);
		return nil;
    }
    // Now we assume that absoluteURL does not point to a project nor wrapper nor directory.
	// We try to find a project in the hierarchy
	// This is the natural situation.
	// NB: A wrapper is always replaced by the project it contains, as long as NSDocument is concerned
    iTM2ProjectDocument * projectDocument = nil;
    NSURL * factoryURL = absoluteURL.URLByPrependingFactoryBaseURL4iTM3;
	if ((projectDocument = [SPC projectForURL:absoluteURL])
		|| (projectDocument = [SPC getProjectInWrapperForURL:absoluteURL display:display error:outErrorPtr])// fileURL belongs to a wrapper
		|| (projectDocument = [SPC getProjectInHierarchyForURL:absoluteURL display:display error:outErrorPtr])// fileURL belongs to a project in the hierarchy
		|| (projectDocument = [SPC getProjectInHierarchyForURL:factoryURL display:display error:outErrorPtr])// fileURL belongs to a cached project 
		|| (projectDocument = [SPC getUnregisteredProjectForURL:absoluteURL fileKey:nil display:display error:outErrorPtr]))
    {
//LOG4iTM3(@"1");
		return [projectDocument openSubdocumentWithContentsOfURL:absoluteURL context:nil display:display error:outErrorPtr];
    }
	//I needed to know if the document did not want a project,
#warning NYI:MISSING WORK HERE
	// Do I have to create a project,opening another file?
	NSURL * url = absoluteURL;
	// What about documents in read only folders?
	if ((projectDocument = [SPC freshProjectForURLRef:&url display:display error:outErrorPtr])) {
		return [projectDocument openSubdocumentWithContentsOfURL:url context:nil display:display error:outErrorPtr];
    }
	D = [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
    return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentForURL:
- (id)documentForURL:(NSURL *)absoluteURL;
/*"Description forthcoming.
 Version History: jlaurens AT users DOT sourceforge DOT net
 SPC metaInfoURLFromFileURL
 NOT YET VERIFIED
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    id result = [super documentForURL:absoluteURL];
    if (nil != result) {
        return [[result retain] autorelease];
	}
	if (absoluteURL.isFileURL) {
		return [[SPC projectForURL:absoluteURL] subdocumentForURL:absoluteURL];
	}
	return nil;
}
@end
