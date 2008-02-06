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

#import <iTM2Foundation/iTM2ProjectControllerKit.h>
#import <iTM2Foundation/iTM2ProjectDocumentKit.h>
#import <iTM2Foundation/iTM2InfoWrapperKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2BundleKit.h>
//#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2WindowKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2StringFormatKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2EventKit.h>
#import <iTM2Foundation/iTM2ViewKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/ICURegEx.h>

//#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2TextDocumentKit.h>

NSString * const iTM2ProjectComponent = @"Project";
NSString * const iTM2ProjectPlistPathExtension = @"plist";
NSString * const iTM2ProjectDefaultName = @"Default";
NSString * const iTM2ProjectFactoryComponent = @"Factory";
NSString * const TWSFactoryPrefix = @".Factory:";

NSString * const iTM2ProjectContextDidChangeNotification = @"iTM2ProjectContextDidChange";
NSString * const iTM2ProjectCurrentDidChangeNotification = @"iTM2CurrentProjectDidChange";

@interface NSArray(iTM2ProjectControllerKit)
- (NSArray *)arrayWithCommonFirstObjectsOfArray:(NSArray *)array;
@end

static NSString * const iTM2ProjectsKey = @"_PPs";
#define PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsKey]
static NSString * const iTM2ProjectsForFileNamesKey = @"_PCPs";
#define CACHED_PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsForFileNamesKey]
static NSString * const iTM2ProjectsReentrantKey = @"_PCPRE";
#define REENTRANT_PROJECT [[self implementation] metaValueForKey:iTM2ProjectsReentrantKey]

@interface iTM2ProjectController(CreateNewProject)
/*! 
    @method     getProjectForFarawayFileName:
    @abstract   Get the project for the given faraway file name
    @discussion An faraway file name lays in the <code>[NSString cachedProjectsDirectory]</code>.
				It is either a soft link to an existing file or a finder alias to an existing file,a project wrapper or a directory wrapper.
				This is intensionnally a closed design.
    @param      None
    @result     a Project document
*/
- (id)getProjectForFarawayURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getUnregisteredProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getContextProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getOpenProjectForURL:(NSURL *)fileURL;
- (id)getBaseProjectForURL:(NSURL *)fileURL;
- (id)getProjectInWrapperForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getCachedProjectInWrapperForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getProjectInHierarchyForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getCachedProjectInHierarchyForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (Class)newProjectPanelControllerClass;
@end

@interface iTM2NewProjectController: iTM2Inspector
{
@private
	id _FileName;
	id _NewProjectName;
	id _ProjectDirName;
	id _Projects;
	int _SelectedRow;
	int _ToggleProjectMode;
	BOOL _IsAlreadyDirectoryWrapper;
	BOOL _IsDirectoryWrapper;// should be replaced by the SUD
}
- (NSURL *)projectURL;
- (NSString *)projectName;
- (void)setFileName:(NSString *)fileName;
- (NSString *)projectDirName;
- (void)setUpProject:(id)projectDocument;

@end

@implementation iTM2MainInstaller(ProjectController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
This message is sent at initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2MileStone registerMileStone:@"Project Migration Missing" forKey:@"Project Migrator"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ProjectMigratorCompleteInstallation
+ (void)iTM2ProjectMigratorCompleteInstallation;
/*"Change the old faraway project design to the new cached one.
The old faraway project design was used until build 689.
It has been changed to fulfill Time Machine requirements and some weak design choices.
This message is sent at global initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Dim 30 déc 2007 07:48:14 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// purpose: move the whole ~me/Library/Application\ Support/iTeXMac2/Projects.put_aside
	// to ~me/Library/Application\ Support/iTeXMac2/Cached Projects.localized
	// Do I need to migrate ?
	NSString * oldSupport = [[NSBundle mainBundle] pathForSupportDirectory:@"Projects.put_aside" inDomain:NSUserDomainMask create:NO];
	if(![DFM fileExistsAtPath:oldSupport])
	{
		return; // nothing to migrate
	}
	NSString * newSupport = [[NSBundle mainBundle] pathForSupportDirectory:@"Cached Projects.localized" inDomain:NSUserDomainMask create:YES];
	NSEnumerator * E = [[DFM subpathsAtPath:oldSupport] objectEnumerator];
	NSString * path;
	NSString * wrapperType = [SDC wrapperDocumentType];
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT(SELF BEGINSWITH[c] '.')"];
	while(path = [E nextObject])
	{
		if([[SDC typeFromFileExtension:[path pathExtension]] isEqual:wrapperType])
		{
			NSString * oldWrapper = [[oldSupport stringByAppendingPathComponent:path] stringByStandardizingPath];
			NSString * oldProject = [[oldWrapper enclosedProjectFileNames] lastObject];
			BOOL isDirectory = NO;
			if([DFM fileExistsAtPath:oldProject isDirectory:&isDirectory] && isDirectory)
			{
				NSURL * oldProjectURL = [NSURL fileURLWithPath:oldProject];
				NSEnumerator * EE = [[SPC allFileKeysWithFilter:iTM2PCFilterRegular inProjectWithURL:oldProjectURL] objectEnumerator];
				NSString * fileKey = nil;
				while(fileKey = [EE nextObject])
				{
					[SPC URLForFileKey:fileKey filter:iTM2PCFilterRegular inProjectWithURL:[NSURL fileURLWithPath:oldProject]];// side effect: some kind of consistency test
				}
				NSString * newProject = [newSupport stringByAppendingPathComponent:[[path stringByDeletingLastPathComponent]
											stringByAppendingPathComponent:[oldProject lastPathComponent]]];
				NSDate * oldDate = [[DFM fileAttributesAtPath:oldProject traverseLink:NO] fileModificationDate];
				NSDate * newDate = [[DFM fileAttributesAtPath:newProject traverseLink:NO] fileModificationDate];
				if(nil == oldDate)
				{
					[DFM createSymbolicLinkAtPath:newProject pathContent:oldProject];
				}
				else if((nil == newDate) || ([newDate compare:oldDate] == NSOrderedDescending))
				{
					// first delete the old stuff
#warning **** ERROR and FAILED, this is a transitional design
					if(YES && [DFM removeFileAtPath:newProject handler:NULL])
					{
						// just create a symbolic link to keep track of the old design during the transition
						[DFM createSymbolicLinkAtPath:newProject pathContent:oldProject];
					}
					else
					{
						iTM2_REPORTERROR(125,([NSString stringWithFormat:@"Migrating projects: could not migrate %@",oldProject]),nil);
					}
				}
			}
			else
			{
				// this is a document wrapper with no real project wrapper inside
				// simply remove it to clean
				oldWrapper = [oldWrapper stringByStandardizingPath];
up_one_level:
				if([DFM removeFileAtPath:oldWrapper handler:NULL])
				{
					oldWrapper = [oldWrapper stringByDeletingLastPathComponent];
					if([oldWrapper length]>[oldSupport length])
					{
						if(0 == [[[DFM subpathsAtPath:oldWrapper] filteredArrayUsingPredicate:predicate] count])
						{
							goto up_one_level;
						}
					}
				}
				else
				{
					iTM2_REPORTERROR(127,([NSString stringWithFormat:@"Migrating projects: could not remove %@",oldWrapper]),nil);
				}
			}
		}
	}
//iTM2_END;
    return;
}
@end

#import <iTM2Foundation/iTM2FileManagerKit.h>

static NSString * const iTM2ProjectIsDirectoryWrapperKey = @"iTM2ProjectIsDirectoryWrapper";
NSString * const iTM2ProjectContentsComponent = @"Contents";

@implementation NSString(iTM2ProjectControllerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cachedProjectsDirectory
+ (NSString *)cachedProjectsDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * path = nil;
	if(!path)
	{
		path = [[[NSBundle mainBundle] pathForSupportDirectory:@"Cached Projects.localized" inDomain:NSUserDomainMask create:YES] copy];
		NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:[DFM fileAttributesAtPath:path traverseLink:NO]];
		[attributes setObject:[NSNumber numberWithBool:YES] forKey:NSFileExtensionHidden];
		[DFM changeFileAttributes:attributes atPath:path];
	}
	return path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringByStrippingCachedProjectsInfo
- (NSString *)stringByStrippingCachedProjectsInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sat Jan  5 22:11:04 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * cachedProjectsDirectory = [[SPC cachedProjectsDirectoryURL] path];
	NSArray * components = [cachedProjectsDirectory pathComponents];
	NSArray * myComponents = [self pathComponents];
	if([myComponents count] < [components count])
	{
		return self;
	}
	NSEnumerator * myE = [myComponents objectEnumerator];
	NSEnumerator * E = [components objectEnumerator];
	NSString * component = nil;
	while(component = [E nextObject])
	{
		if(![component pathIsEqual:[myE nextObject]])
		{
			return self;
		}
	}
	NSRange range = NSMakeRange([components count],[myComponents count]-[components count]);
	myComponents = [myComponents subarrayWithRange:range];
//iTM2_END;
	return [[NSOpenStepRootDirectory()stringByAppendingPathComponent:[NSString pathWithComponents:myComponents]]
				stringByStandardizingPath];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosedProjectFileNames
- (NSArray *)enclosedProjectFileNames;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: Sat Jan  5 22:11:37 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * projects = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [DFM enumeratorAtPath:self];
	NSString * file = nil;
	while (file = [dirEnum nextObject])
	{
		file = [self stringByAppendingPathComponent:file];
		file = [file stringByStandardizingPath];
		if([SWS isProjectPackageAtPath:file])
		{
			[projects addObject:file];
		}
	}
//iTM2_END;
	return projects;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjectFileNames
- (id)availableProjectFileNames;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * projects = [NSMutableArray array];
	NSArray * contents = [DFM directoryContentsAtPath:self];
	NSEnumerator *E = [contents objectEnumerator];
	NSString * file = nil;
	while (file = [E nextObject])
	{
		if([SWS isProjectPackageAtPath:file])
		{
			file = [self stringByAppendingPathComponent:file];
			file = [file stringByStandardizingPath];
			[projects addObject:file];
		}
	}
//iTM2_END;
	return projects;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosingProjectFileName
- (NSString *)enclosingProjectFileName;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [self stringByStandardizingPath];
	NSString * requiredExtension = [SDC projectPathExtension];
	NSString * extension;
up:
	extension = [fileName pathExtension];
	if([extension pathIsEqual:requiredExtension])
	{
//iTM2_END;
		return fileName;
	}
	else if([fileName length]>1)
	{
		fileName = [fileName stringByDeletingLastPathComponent];
		goto up;
	}
	else
	{
//iTM2_END;
		return nil;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosingWrapperFileName
- (NSString *)enclosingWrapperFileName;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [self stringByStandardizingPath];
	NSString * requiredExtension = [SDC wrapperPathExtension];
	NSString * extension;
up:
	extension = [fileName pathExtension];
	if([extension pathIsEqual:requiredExtension])
	{
//iTM2_END;
		return fileName;
	}
	else if([fileName length]>1)
	{
		fileName = [fileName stringByDeletingLastPathComponent];
		goto up;
	}
	else
	{
//iTM2_END;
		return nil;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringByAppendingBuildComponent
- (NSString *)stringByAppendingBuildComponent;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = [self stringByAppendingPathComponent:iTM2ProjectFactoryComponent];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringByAppendingContentsComponent
- (NSString *)stringByAppendingContentsComponent;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = [self stringByAppendingPathComponent:iTM2ProjectContentsComponent];
//iTM2_END;
	return result;
}
@end

@implementation NSURL(iTM2ProjectControllerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cachedProjectsDirectoryURL
+ (NSURL *)cachedProjectsDirectoryURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSURL * url = nil;
	if(!url)
	{
		NSString * path = [[NSBundle mainBundle] pathForSupportDirectory:@"Cached Projects.localized" inDomain:NSUserDomainMask create:YES];
		NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:[DFM fileAttributesAtPath:path traverseLink:NO]];
		[attributes setObject:[NSNumber numberWithBool:YES] forKey:NSFileExtensionHidden];
		[DFM changeFileAttributes:attributes atPath:path];
		url = [[NSURL fileURLWithPath:path] retain];// this should be a writable directory
	}
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLByRemovingCachedProjectComponent
- (NSURL *)URLByRemovingCachedProjectComponent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self isFileURL]? [NSURL fileURLWithPath:[[self path] stringByStrippingCachedProjectsInfo]]: self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLByPrependingCachedProjectComponent
- (NSURL *)URLByPrependingCachedProjectComponent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self isFileURL]? [NSURL URLWithString:[[self path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
		relativeToURL:[NSURL cachedProjectsDirectoryURL]]: self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  belongsToCachedProjectsDirectory
- (BOOL)belongsToCachedProjectsDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self path] belongsToDirectory:[[NSURL cachedProjectsDirectoryURL] path]];
}
- (NSURL *)enclosingProjectURL;
{
	return [NSURL fileURLWithPath:[[self path] enclosingProjectFileName]];
}
- (NSURL *)enclosingWrapperURL;
{
	return [NSURL fileURLWithPath:[[self path] enclosingWrapperFileName]];
}
- (NSArray *)enclosedProjectURLs;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * projects = [NSMutableArray array];
	NSString * path = [self path];
	NSDirectoryEnumerator *dirEnum = [DFM enumeratorAtPath:path];
	NSString * file = nil;
	while (file = [dirEnum nextObject])
	{
		file = [[path stringByAppendingPathComponent:file] stringByStandardizingPath];
		if([SWS isProjectPackageAtPath:file])
		{
			[projects addObject:[NSURL fileURLWithPath:file]];
		}
	}
//iTM2_END;
	return projects;
}
@end

NSString * const iTM2ProjectCustomInfoComponent = @"CustomInfo";

static NSString * const iTM2ProjectsBaseKey = @"_PCPBs";
#define BASE_PROJECTS [IMPLEMENTATION metaValueForKey:iTM2ProjectsBaseKey]

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return _iTM2SharedProjectController;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSharedProjectController:
+ (void)setSharedProjectController:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Ven 21 déc 2007 21:07:55 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_iTM2SharedProjectController != argument)
	{
		[DNC removeObserver:_iTM2SharedProjectController];
		[WSN removeObserver:_iTM2SharedProjectController];
		[_iTM2SharedProjectController autorelease];
		_iTM2SharedProjectController = [argument retain];
		if(argument)
		{
			[DNC addObserver:argument selector:@selector(windowDidBecomeKeyOrMainNotified:)name:NSWindowDidBecomeKeyNotification object:nil];
			[DNC addObserver:argument selector:@selector(windowDidBecomeKeyOrMainNotified:)name:NSWindowDidBecomeMainNotification object:nil];
			[WSN addObserver:argument selector:@selector(workspaceDidPerformFileOperationNotified:)name:NSWorkspaceDidPerformFileOperationNotification object:nil];
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mainInfoURLFromURL:create:error:
- (NSURL *)mainInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * path = [fileURL path];
		if(yorn)
		{
			[DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		return [NSURL URLWithString:[component stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:fileURL];
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  frontendInfoURLFromURL:create:error:
- (NSURL *)frontendInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * fileName = [fileURL path];
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if(yorn)
		{
			[DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:fileURL];
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaInfoURLFromURL:create:error:
- (NSURL *)metaInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * fileName = [fileURL path];
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if(yorn)
		{
			[DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectMetaInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:fileURL];
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}

//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  customInfoURLFromURL:create:error:
- (NSURL *)customInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * fileName = [fileURL path];
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if(yorn)
		{
			[DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectCustomInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:fileURL];
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}

//iTM2_END;
    return nil;
}
#pragma mark =-=-=-=-=-  FILE KEY ACCESSORS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isReservedFileKey:
- (BOOL)isReservedFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[NSArray arrayWithObjects:TWSSourceKey,TWSFactoryKey,@".",TWSProjectKey,TWSTargetsKey,TWSToolsKey,iTM2ProjectLastKeyKey,iTM2ProjectFrontDocumentKey,nil] containsObject:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  directoryURLOfProjectWithURL:
- (NSURL *)directoryURLOfProjectWithURL:(NSURL *)projectURL;
/*"The URL of the directory enclosing the given URL.
If the given URL corresponds to a cached project, also strips the library part.
Whether or not the result really points to an existing directory is out of purpose in that method.
If the given projectURL is not a file URL, we just return the ".." relative URL with no further testing.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sam 29 déc 2007 09:17:37 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == projectURL)
	{
//iTM2_END;
		return nil;
	}
//iTM2_END;
	return [NSURL URLWithString:@".." relativeToURL:[projectURL URLByRemovingCachedProjectComponent]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sourceOfProjectWithURL:
- (NSString *)sourceOfProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Dim 30 déc 2007 07:48:14 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [self projectForURL:projectURL];
	if(PD)
	{
		return [PD sourceName];
	}
	NSError * outError = nil;
	iTM2MainInfoWrapper * MIW = [[[iTM2MainInfoWrapper allocWithZone:[self zone]] initWithProjectURL:projectURL error:&outError] autorelease];
	if(outError)
	{
		[NSApp presentError:outError];
	}
//iTM2_END;
	return [MIW sourceName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForFileKey:filter:inProjectWithURL:
- (NSURL *)URLForFileKey:(NSString *)key filter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan  1 11:50:32 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == projectURL)
	{
		return nil;
	}
	if([key isEqual:@"."] || [key isEqual:TWSProjectKey])
	{
		if(filter == iTM2PCFilterRegular)
		{
			return projectURL;
		}
		key = TWSProjectKey;
	}
	else if([key isEqual:TWSSourceKey])
	{
		if(filter == iTM2PCFilterRegular)
		{
			NSString * source = [self sourceOfProjectWithURL:projectURL];
			projectURL = [self directoryURLOfProjectWithURL:projectURL];
			if(source = [source stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])
			{
				return [NSURL URLWithString:source relativeToURL:projectURL];
			}
		//iTM2_END;
			return projectURL;// the default source directory
		}
	}
	else if([key isEqual:TWSFactoryKey])
	{
		if(filter == iTM2PCFilterRegular)
		{
			NSString * factory = iTM2ProjectFactoryComponent;
			if(factory = [factory stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])
			{
				return [NSURL URLWithString:factory relativeToURL:projectURL];
			}
		//iTM2_END;
			return [self directoryURLOfProjectWithURL:projectURL];// the default factory directory
		}
	}
	if([self isReservedFileKey:key])
	{
		return nil;
	}
	NSString * projectName = [projectURL path];
	NSString * base = nil;
	switch(filter)
	{
		case iTM2PCFilterAbsoluteLink:
			base = [SPC absoluteSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			base = [base stringByAppendingPathComponent:key];
			base = [DFM pathContentOfSoftLinkAtPath:base];
			break;
		case iTM2PCFilterRelativeLink:
			base = [SPC relativeSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			base = [base stringByAppendingPathComponent:key];
			base = [DFM pathContentOfSoftLinkAtPath:base];
			break;
		case iTM2PCFilterAlias:
			base = [SPC finderAliasesSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			base = [base stringByAppendingPathComponent:key];
			projectURL = [NSURL fileURLWithPath:base];
			NSData * aliasData = [NSData aliasDataWithContentsOfURL:projectURL error:nil];
		//iTM2_END;
			return [aliasData URLByResolvingDataAliasRelativeToURL:nil error:nil];
		case iTM2PCFilterRegular:
		default:
		{
			NSString * relative = [self nameForFileKey:key inProjectWithURL:projectURL];
			if(relative = [relative stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding])
			{
				NSURL * url = [NSURL URLWithString:relative];
				if([url scheme])
				{
					// the relative name was in fact a full URL;
//iTM2_END;
					return url;
				}
			}
			projectURL = [self URLForFileKey:TWSSourceKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
//iTM2_END;
			return [NSURL URLWithString:relative relativeToURL:projectURL];
		}
	}
	if([projectName pathIsEqual:base] || [SWS isProjectPackageAtPath:base])
	{
		return	nil;
	}
//iTM2_END;
	return [NSURL fileURLWithPath:base];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allFileKeysWithFilter:inProjectWithURL:
- (NSArray *)allFileKeysWithFilter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Ven 21 déc 2007 21:07:55 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if(nil == projectURL)
	{
		return nil;
	}
	NSString * projectName = [projectURL path];
	NSString * path = nil;
	switch(filter)
	{
		case iTM2PCFilterAbsoluteLink:
			path = [projectName stringByAppendingPathComponent:[SPC absoluteSoftLinksSubdirectory]];
			return [DFM directoryContentsAtPath:path];
		case iTM2PCFilterRelativeLink:
			path = [projectName stringByAppendingPathComponent:[SPC relativeSoftLinksSubdirectory]];
			return [DFM directoryContentsAtPath:path];
		case iTM2PCFilterAlias:
			path = [projectName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
			return [DFM directoryContentsAtPath:path];
		case iTM2PCFilterRegular:
		default:
		{
			iTM2MainInfoWrapper * MIW = [[self projectForURL:projectURL] mainInfos];
			if(MIW == nil)
			{
				NSError * outError = nil;
				MIW = [[[iTM2MainInfoWrapper allocWithZone:[self zone]] initWithProjectURL:projectURL error:&outError] autorelease];
				if(outError)
				{
					[NSApp presentError:outError];
				}
			}
//iTM2_END;
			return [[MIW keyedNames] allKeys];
		}
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForURL:filter:inProjectWithURL:
- (NSString *)fileKeyForURL:(NSURL *)fileURL filter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
- 2.0: Sun Dec 30 08:39:41 UTC 2007
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == fileURL)// untitled documents will go there
	{
		return nil;
	}
	fileURL = [fileURL absoluteURL];
	// Is it me?
	// Here begins the hard work
	NSEnumerator * E = [[self allFileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	NSString * key;
	while(key = [E nextObject])
	{
		if([[[self URLForFileKey:key filter:filter inProjectWithURL:projectURL] absoluteURL] isEqual:fileURL])
		{
			return key;
		}
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameForFileKey:inProjectWithURL:
- (NSString *)nameForFileKey:(NSString *)key inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Dim 30 déc 2007 07:48:14 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if((0 == [key length]) || (nil == projectURL) || [self isReservedFileKey:key])
	{
		return nil;// untitled documents will stop there
	}
	NSURL * infoURL = [self mainInfoURLFromURL:projectURL create:NO error:nil];
	NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:infoURL options:NSXMLNodeOptionsNone error:nil] autorelease];
	NSString * xpath = [NSString stringWithFormat:@"/plist/dict/key[text()=\"files\"]/following-sibling::dict[1]/key[text()=\"%@\"]/following-sibling::string[1]",key];
	return [[[doc nodesForXPath:xpath error:nil] lastObject] stringValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForName:inProjectWithURL:
- (NSURL *)URLForName:(NSString *)relativeName inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Dim 30 déc 2007 07:48:14 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == projectURL)
	{
		return nil;
	}
	relativeName = [relativeName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL * url = [NSURL URLWithString:relativeName];
	if([url scheme])
	{
		// the relative name was in fact a full URL;
//iTM2_END;
		return url;
	}
//iTM2_END;
	return [NSURL URLWithString:relativeName relativeToURL:[self URLForFileKey:TWSSourceKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  factoryURLForName:inProjectWithURL:
- (NSURL *)factoryURLForName:(NSString *)relativeName inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Dim 30 déc 2007 07:48:14 UTC
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == projectURL)
	{
		return nil;
	}
	relativeName = [relativeName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL * url = [NSURL URLWithString:relativeName];
	if([url scheme])
	{
		// the relative name was in fact a full URL;
//iTM2_END;
		return url;
	}
//iTM2_END;
	return [NSURL URLWithString:relativeName relativeToURL:[self URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL]];
}
#pragma mark =-=-=-=-=-  ELSE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  workspaceDidPerformFileOperationNotified:
- (void)workspaceDidPerformFileOperationNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self projects] makeObjectsPerformSelector:@selector(fixProjectConsistency)];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  flushCaches
- (void)flushCaches;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning ERROR: the 2 following assignments are suspect
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsForFileNamesKey];
//iTM2_END;
return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjectsForPath:
- (id)availableProjectsForPath:(NSString *)dirName;
/*"Description forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first I get the projects file names including the other ones in the hierarchy above dirName
	// I scan the directories for projects,starting from the normal side then looking for library projects
	// it is the responsibility of the user interface controllers to make the difference between writable and not writable
	// Supplemental rule: if the dirName is included in a wrapper,the projects are constrained to that wrapper and
	// projects outside will be ignored.
	// first test if there is an enclosing wrapper
	// recognizing the wrapper
	NSString * wrapperType = [SDC wrapperDocumentType];
	NSString * extension = nil;
	NSString * displayName = nil;
	NSString * path = nil;
	NSString * type = nil;
	if([SDC documentClassForType:wrapperType])
	{
		path = [dirName enclosingWrapperFileName];
		if([path length])
		{
			displayName = [path lastPathComponent];
			NSDictionary * fileAttributes = [DFM fileAttributesAtPath:path traverseLink:NO];
			if([fileAttributes fileExtensionHidden])
			{
				displayName = [displayName stringByDeletingPathExtension];
			}
			return [NSDictionary dictionaryWithObject:displayName forKey:path];
		}
	}
	// there is no enclosing wrapper
	// find all the projects,either internal or library
	// stop as soon as projects are found
	NSString * cachedProjectsPrefix = [NSString cachedProjectsDirectory];
	NSAssert1(![path hasPrefix:cachedProjectsPrefix],@"The path must not be library:\n%@",path);
	NSString * libraryPath = nil;
	NSString * projectType = [SDC projectDocumentType];
	if([SDC documentClassForType:projectType])
	{
		NSMutableArray * paths = [NSMutableArray array];
		NSEnumerator * E = nil;
		NSString * content = nil;
		path = dirName;
		do
		{
			E = [[DFM directoryContentsAtPath:path] objectEnumerator];
			while(content = [E nextObject])
			{
				extension = [content pathExtension];
				type = [SDC typeFromFileExtension:extension];
				if([type isEqualToString:projectType])
				{
					NSString * P = [path stringByAppendingPathComponent:content];
					[paths addObject:P];
				}
			}
			libraryPath = [cachedProjectsPrefix stringByAppendingPathComponent:path];
			E = [[DFM directoryContentsAtPath:libraryPath] objectEnumerator];
			while(content = [E nextObject])
			{
				extension = [content pathExtension];
				type = [SDC typeFromFileExtension:extension];
				if([type isEqualToString:wrapperType])
				{
					NSString * P = [libraryPath stringByAppendingPathComponent:content];
					[paths addObject:P];
				}
			}
		}
		while(([paths count]==0) && (path = [path stringByDeletingLastPathComponent],([path length]>1)));
		// now adding the library projects if relevant
		[paths sortedArrayUsingSelector:@selector(compare:)];
		NSMutableDictionary * first = [NSMutableDictionary dictionary];
		NSMutableDictionary * last  = [NSMutableDictionary dictionary];
		E = [paths objectEnumerator];
		while(path = [E nextObject])
		{
			[first setObject:[path lastPathComponent] forKey:path];
			[last  setObject:[path stringByDeletingLastPathComponent] forKey:path];
		}
		NSArray * allValues = nil;
		NSSet * set = nil;
more:
		allValues = [first allValues];
		set = [NSSet setWithArray:allValues];
		if([allValues count] != [set count])
		{
			E = [set objectEnumerator];
			while(displayName = [E nextObject])
			{
				NSArray * ra = [first allKeysForObject:displayName];
				if([ra count]>1)
				{
					// there are more than one path with the same display name
					// we must make a difference between them
					NSEnumerator * e = [ra objectEnumerator];
					while(path = [e nextObject])
					{
						NSString * oldPath = [last objectForKey:path];
						NSString * oldDisplayName = [first objectForKey:path];
						NSString * newDisplayName = [oldPath lastPathComponent];
						newDisplayName = [newDisplayName stringByAppendingPathComponent:oldDisplayName];
						[first setObject:newDisplayName forKey:path];
						NSString * newPath = [newDisplayName stringByDeletingLastPathComponent];
						[last setObject:newPath forKey:path];
					}
				}
			}
			goto more;
		}
		E = [first keyEnumerator];
		while(path = [E nextObject])
		{
			displayName = [first objectForKey:path];
			dirName = [displayName stringByDeletingLastPathComponent];
			if([dirName length]>1)
			{
				displayName = [displayName lastPathComponent];
				NSDictionary * fileAttributes = [DFM fileAttributesAtPath:path traverseLink:NO];
				if([fileAttributes fileExtensionHidden])
				{
					displayName = [displayName stringByDeletingPathExtension];
				}
				dirName = [[@"..." stringByAppendingPathComponent:dirName] stringByStandardizingPath];
				displayName = [NSString stringWithFormat:@"%@ (%@)",displayName,dirName];
				[first setObject:displayName forKey:path];
			}
		}
		return first;
	}
//iTM2_END;
	return [NSDictionary dictionary];
}
#pragma mark =-=-=-=-=-  PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareProjectsFixImplementation
- (void)prepareProjectsFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![IMPLEMENTATION metaValueForKey:iTM2ProjectsKey])
	{
		[IMPLEMENTATION takeMetaValue:[NSMutableSet set] forKey:iTM2ProjectsKey];
	}
	if(![IMPLEMENTATION metaValueForKey:iTM2ProjectsForFileNamesKey])
	{
		[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsForFileNamesKey];
	}
	if(![IMPLEMENTATION metaValueForKey:iTM2ProjectsReentrantKey])
	{
		[IMPLEMENTATION takeMetaValue:[NSMutableSet set] forKey:iTM2ProjectsReentrantKey];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projects
- (NSArray *)projects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 1
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [PROJECTS objectEnumerator];
    id P;
    while(P = [[E nextObject] nonretainedObjectValue])
        [MRA addObject:P];
    return MRA;
#else
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [[SDC documents] objectEnumerator];
    NSDocument * D;
    while(D = [E nextObject])
        if([D isKindOfClass:[self class]])
            [MRA addObject:D];
    return MRA;
#endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForDocument:
- (id)projectForDocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == document)
	{
		return nil;
	}
	NSURL * fileURL = [document fileURL];
    if(nil == fileURL)
	{
        return nil;
	}
	if(iTM2DebugEnabled>99999)
	{
		iTM2_LOG(@"fileURL:%@",fileURL);
	}
	NSValue * documentValue = [NSValue valueWithNonretainedObject:document];
	iTM2ProjectDocument * projectDocument;
	NSValue * projectValue;
#warning: SIGTRAP here:coder:20060906
//iTM2_LOG(@"CACHED_PROJECTS:%@",CACHED_PROJECTS);
//iTM2_LOG(@"documentValue:%@",documentValue);
    if(projectValue = [CACHED_PROJECTS objectForKey:documentValue])
	{
		if(projectDocument = [projectValue nonretainedObjectValue])
		{
			if([SPC isProject:projectDocument])
			{
				return projectDocument;
			}
		}
		else
		{
			return nil;// this is a document with no project!
		}
	}
	[document setHasProject:NO];
	// if this method is entered once more from here,it will return from one of the above lines,unless the CACHED_PROJECTS are cleaned
	NSEnumerator * E = [[SPC projects] objectEnumerator];
	while(projectDocument = [E nextObject])
	{
		if([projectDocument ownsSubdocument:document])
		{
			[self setProject:projectDocument forDocument:document];
			return projectDocument;
		}
	}
	projectValue = [CACHED_PROJECTS objectForKey:fileURL];
    if(nil != projectValue)
	{
		projectDocument = [projectValue nonretainedObjectValue];
		if(nil != projectDocument)
		{
			if([SPC isProject:projectDocument])
			{
				[self setProject:projectDocument forDocument:document];
				return projectDocument;
			}
		}
		else
		{
			[self setProject:nil forDocument:document];
			return nil;
		}
	}
	NSURL * url = fileURL;
	if(projectDocument = [self newProjectForURLRef:&url display:YES error:nil])
	{
		if([url isFileURL] && ![[url absoluteURL] isEqual:[fileURL absoluteURL]])
		{
			// ensure the containing directory exists
			[DFM createDeepDirectoryAtPath:[[url path] stringByDeletingLastPathComponent] attributes:nil error:nil];
			[document setFileURL:url];
		}
		[projectDocument addSubdocument:document];
		[self setProject:projectDocument forDocument:document];
		return projectDocument;
	}
	[self setProject:nil forDocument:document];
	[document takeContextBool:YES forKey:@"_iTM2:Document With No Project" domain:iTM2ContextAllDomainsMask];
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:forDocument:
- (void)setProject:(id)projectDocument forDocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!document)
		return;
	NSParameterAssert((!projectDocument || [SPC isProject:projectDocument]));

	NSValue * documentValue = [NSValue valueWithNonretainedObject:document];
	NSValue * projectValue = [NSValue valueWithNonretainedObject:projectDocument];
	[CACHED_PROJECTS setObject:projectValue forKey:documentValue];
	[document setHasProject:(projectDocument != nil)];
	NSAssert1((projectDocument == [self projectForDocument:document]),
		@"..........  INCONSISTENCY:unexpected behaviour,report bug 1313 in %@",__iTM2_PRETTY_FUNCTION__);

	NSURL * fileURL = [document fileURL];
	[self setProject:projectDocument forURL:fileURL];
	NSAssert3((!projectDocument || [[projectDocument fileKeyForURL:fileURL] length]),
		@"..........  INCONSISTENCY:unexpected behaviour,report bug 3131 in %@,\nproject:\n%@\nfileName:\n%@",__iTM2_PRETTY_FUNCTION__,projectDocument,fileURL);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForURL:
- (id)projectForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSValue * projectValue = [CACHED_PROJECTS objectForKey:[fileURL absoluteURL]];
	id projectDocument = nil;
	if(nil != projectValue)
	{
		projectDocument = [projectValue nonretainedObjectValue];
		if([SPC isProject:projectDocument])
		{
			return projectDocument;
		}
	}
	else if([fileURL isFileURL])
	{
		NSString * fileName = [[[fileURL path] lowercaseString] stringByStandardizingPath];
		if(![fileName length])
		{
			return nil;
		}
		if(iTM2DebugEnabled>99999)
		{
			iTM2_LOG(@"fileName:%@",fileName);
		}
	//iTM2_LOG(@"CACHED_PROJECTS");
		projectValue = [CACHED_PROJECTS objectForKey:fileName];
		if(nil != projectValue)
		{
			projectDocument = [projectValue nonretainedObjectValue];
			if(nil != projectDocument)
			{
				if([SPC isProject:projectDocument])
				{
					return projectDocument;
				}
			}
			else
			{// document with no project: this is intentional
				return nil;
			}
		}
		projectDocument = [BASE_PROJECTS objectForKey:fileName];
		if(nil != projectDocument)
		{
			return projectDocument;
		}

	//iTM2_LOG(@"Not yet cached");
		NSString * shortFileName = [fileName stringByDeletingPathExtension];
		projectValue = [CACHED_PROJECTS objectForKey:shortFileName];
		projectDocument = [projectValue nonretainedObjectValue];
		if(nil != projectDocument)
		{
			[CACHED_PROJECTS setObject:projectValue forKey:fileURL];
			[projectDocument newFileKeyForURL:fileURL];
			return projectDocument;
		}
	//iTM2_LOG(@"Not yet cached for short name");
		NSEnumerator * E = [[SDC documents] objectEnumerator];
		while(projectDocument = [E nextObject])
		{
			if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
			{
				if([projectDocument fileKeyForURL:fileURL] || [[[projectDocument fileURL] absoluteURL] isEqual:[fileURL absoluteURL]])
					goto theEnd1;
				else if([[[projectDocument wrapperURL] absoluteURL] isEqual:[fileURL absoluteURL]])
					goto theEnd2;
			}
		}
	//iTM2_LOG(@"Not an already existing project document");
	// this is redundant
		E = [[self projects] objectEnumerator];
		while(projectDocument = [E nextObject])
		{
			if([projectDocument fileKeyForURL:fileURL] || [[[projectDocument fileURL] absoluteURL] isEqual:[fileURL absoluteURL]])
				goto theEnd1;
			else if([[[projectDocument wrapperURL] absoluteURL] isEqual:[fileURL absoluteURL]])
				goto theEnd2;
			else if(iTM2DebugEnabled>10)
			{
				iTM2_LOG(@"The project:\n%@ does not know\n%@",[projectDocument fileURL],fileURL);
			}
		}
	//iTM2_LOG(@"Not one of all projects (%@)",[self projects]);
		[self setProject:nil forURL:fileURL];
		return nil;
theEnd1:
		[projectDocument newFileKeyForURL:fileURL];
theEnd2:
		[self setProject:projectDocument forURL:fileURL];
		if(iTM2DebugEnabled>10)
		{
			iTM2_LOG(@"\\infty - The project:%@ knows about %@",[projectDocument fileURL],fileURL);
		}
		return projectDocument;
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:forURL:
- (void)setProject:(id)projectDocument forURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled>99999)
	{
		iTM2_LOG(@"fileURL:%@",fileURL);
	}
	NSParameterAssert((!projectDocument || [SPC isProject:projectDocument]));
	NSValue * projectValue = [NSValue valueWithNonretainedObject:projectDocument];
	[CACHED_PROJECTS setObject:projectValue forKey:[fileURL absoluteURL]];
	NSAssert1((projectDocument == [self projectForURL:fileURL]),
		@"..........  INCONSISTENCY:unexpected behaviour,report bug 3131 in %s",__iTM2_PRETTY_FUNCTION__);
	NSString * path = [fileURL path];
	if([path length]>0)
	{
		[CACHED_PROJECTS setObject:projectValue forKey:path];
	}
	path = [path stringByDeletingPathExtension];
	if([path length]>0)
	{
		[CACHED_PROJECTS setObject:projectValue forKey:path];
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForSource:
- (id)projectForSource:(id)source;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THERE MIGHT BE A REALLY BIG PROBLEM WHEN CREATING NEW DOCUMENTS:the filename is void!!! Use the autosave?
//NSLog(@"source:%@",source);
	[[source retain] autorelease];
    if([source isKindOfClass:[NSURL class]])
        return [self projectForURL:source];
    else if([source isKindOfClass:[NSString class]])
        return [self projectForURL:[NSURL fileURLWithPath:source]];
    else if([source isKindOfClass:[self class]])
        return source;
    else if([source isKindOfClass:[NSDocument class]])
        return [source project];
    else if([source isKindOfClass:[NSWindowController class]])
        return [[source document] project];
    else if([source isKindOfClass:[NSWindow class]])
        return [[[source windowController] document] project];
    else if([source isKindOfClass:[NSView class]])
        return [[[[source window] windowController] document] project];
    else if([source isKindOfClass:[NSToolbarItem class]])
        return [self projectForSource:[source view]];
    else if([source isKindOfClass:[NSValue class]])
	{
		source = [source nonretainedObjectValue];
		NSEnumerator * E = [[SDC documents] objectEnumerator];
		id doc;
		while(doc = [E nextObject])
			if(doc == source)
				return [doc project];
		iTM2_LOG(@"The object wrapped in the value is not owned by the document controller");
        return [self projectForSource:source];
	}
    else
        return [[SDC currentDocument] project];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerProject:
- (void)registerProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"document:%@",projectDocument);
		}
		// testing consistency
		// we are not authorized to register a project document with the same name as a previously registered project document
		NSEnumerator * E = [PROJECTS objectEnumerator];
		id P;
		NSURL * projectURL = [[projectDocument fileURL] absoluteURL];
		while(nil != (P = (id)[[E nextObject] nonretainedObjectValue]))
		{
//iTM2_LOG(@"PROBLEM");if([[P fileName] pathIsEqual:FN]){
//iTM2_LOG(@"PROBLEM");}
			NSAssert2(![[[P fileURL] absoluteURL] isEqual:projectURL],@"You cannot register 2 different project documents with that URL:\n%@==%@",projectURL,[P fileURL]);
		}
		[PROJECTS addObject:[NSValue valueWithNonretainedObject:projectDocument]];
		[self setProject:projectDocument forDocument:projectDocument];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"project:%@",projectDocument);
		}
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forgetProject:
- (void)forgetProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
	{
		NSValue * V = [NSValue valueWithNonretainedObject:projectDocument];
		[PROJECTS removeObject:V];
		[CACHED_PROJECTS removeObjectsForKeys:[CACHED_PROJECTS allKeysForObject:V]];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"project:%@",projectDocument);
		}
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isProject:
- (BOOL)isProject:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return (nil != argument) && [PROJECTS containsObject:[NSValue valueWithNonretainedObject:argument]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  finderAliasesSubdirectory
- (NSString*)finderAliasesSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[TWSFrontendComponent stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"Finder Aliases"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  absoluteSoftLinksSubdirectory
- (NSString*)absoluteSoftLinksSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[TWSFrontendComponent stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"Soft Links"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  relativeSoftLinksSubdirectory
- (NSString*)relativeSoftLinksSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileURL isFileURL] || [REENTRANT_PROJECT containsObject:fileURL])
	{
		return NO;
	}
	BOOL isDirectory = NO;
	NSString * FN = [fileURL path];
	if([DFM fileExistsAtPath:FN isDirectory:&isDirectory])
	{
		if(isDirectory)
		{
			if([SWS isFilePackageAtPath:FN])
			{
				return YES;
			}
			iTM2_OUTERROR(1,(@"No project for a directory that is not a package."),nil);
			return NO;
		}
		return YES;
	}
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(fileURL)
	{
		[REENTRANT_PROJECT addObject:fileURL];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getOpenProjectForURL:
- (id)getOpenProjectForURL:(NSURL *)fileURL;
/*"Does an already open project knows about the document at fileURL?
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[SDC documents] objectEnumerator];
	id projectDocument = nil;
	while(projectDocument = [E nextObject])
	{
		if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
		{
			NSString * key = [projectDocument fileKeyForURL:fileURL];
			if([key length]
				|| [[[projectDocument fileURL] absoluteURL] isEqual:fileURL]
				|| [[[projectDocument wrapperURL] absoluteURL] isEqual:fileURL]
				|| [fileURL isRelativeToURL:[SPC URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:[projectDocument fileURL]]])
			{
				break;
			}
		}
	}
	[self setProject:projectDocument forURL:fileURL];
	if(iTM2DebugEnabled>10)
	{
		iTM2_LOG(@"\\infty - The project:%@ knows about %@",[projectDocument fileURL],fileURL);
	}
//iTM2_END;
    return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectURLInWrapperForURLRef:error:
- (NSURL *)getProjectURLInWrapperForURLRef:(NSURL **)fileURLRef error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == fileURLRef)
	{
		return nil;
	}
	iTM2ProjectDocument * projectDocument = nil;
	NSURL * fileURL = *fileURLRef;
	NSString * fileName = [[fileURL path] stringByStandardizingPath];
	NSString * wrapperName = [fileName enclosingWrapperFileName];
	if([SWS isWrapperPackageAtPath:wrapperName])
	{
		// then we are trying to find a project just below
		BOOL isDirectory = NO;
		if([DFM fileExistsAtPath:wrapperName isDirectory:&isDirectory] && isDirectory)
		{
			NSArray * projectNames = [wrapperName enclosedProjectFileNames];
			NSString * projectName = nil;
			NSString * component = nil;
			if([projectNames count] == 1)
			{
				return [NSURL fileURLWithPath:[projectNames lastObject]];
			}
			else if([projectNames count] > 1)
			{
				component = [wrapperName lastPathComponent];
				component = [component stringByDeletingPathExtension];
				component = [component stringByAppendingPathExtension:[SDC projectPathExtension]];
				projectName = [wrapperName stringByAppendingPathComponent:component];
				if([projectNames containsObject:projectName])
				{
					return [NSURL fileURLWithPath:projectName];
				}
				component = [iTM2ProjectComponent stringByAppendingPathExtension:[SDC projectPathExtension]];
				projectName = [wrapperName stringByAppendingPathComponent:component];
				if([projectNames containsObject:projectName])
				{
					return [NSURL fileURLWithPath:projectName];
				}
				if(outErrorPtr)
				{
					*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Too many projects in the wrapper directory at\n%@\nChoosing the last one.",wrapperName] forKey:NSLocalizedDescriptionKey]];
				}
				return nil;
			}
			else
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.",wrapperName] forKey:NSLocalizedDescriptionKey]]];
				// the following method will create a constrained project
				component = [wrapperName lastPathComponent];
				component = [component stringByDeletingPathExtension];
				component = [component stringByAppendingPathExtension:[SDC projectPathExtension]];
				projectName = [wrapperName stringByAppendingPathComponent:component];
				if([DFM fileExistsAtPath:projectName])
				{
					int tag = 0;
					if(![SWS performFileOperation:NSWorkspaceRecycleOperation source:wrapperName
							destination:@"" files:[NSArray arrayWithObject:component] tag:&tag])
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Impossible to recycle file at\n%@\nProblems forthcoming...",projectName]
								forKey:NSLocalizedDescriptionKey]]];
					}
				}
				NSURL * projectURL = [NSURL fileURLWithPath:projectName];
				if([DFM createDeepDirectoryAtPath:projectName attributes:nil error:outErrorPtr])
				{
					projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:NO error:outErrorPtr];
					[projectDocument fixProjectConsistency];
				}
				else
				{
					projectDocument = [SDC makeUntitledDocumentOfType:[SDC projectPathExtension] error:outErrorPtr];
					[projectDocument setFileURL:projectURL];
					[projectDocument setFileType:[SDC projectDocumentType]];
					[projectDocument fixProjectConsistency];
					[SDC addDocument:projectDocument];
				}
				if(projectDocument)
				{
					[projectDocument newFileKeyForURL:fileURL];
					[projectDocument saveDocument:nil];
					if([fileName pathIsEqual:wrapperName])
					{
						* fileURLRef = projectURL;
					}
					return projectURL;
				}
				else
				{
					if(outErrorPtr)
					{
						*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.",wrapperName] forKey:NSLocalizedDescriptionKey]];
					}
					return nil;
				}
			}
		}
		else
		{
			if(outErrorPtr)
			{
				*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"ERROR:There might be a link at %@:it is no yet supported by iTeXMac2",fileName]
						forKey:NSLocalizedDescriptionKey]];
			}
			return nil;
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectInWrapperForURLRef:display:error:
- (id)getProjectInWrapperForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == fileURLRef)
	{
		return nil;
	}
	NSURL * projectURL = [self getProjectURLInWrapperForURLRef:fileURLRef error:outErrorPtr];
	if(nil != projectURL)
	{
		iTM2ProjectDocument * projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr];
		[projectDocument fixProjectConsistency];
		[projectDocument newFileKeyForURL:*fileURLRef];
		[SPC setProject:projectDocument forURL:*fileURLRef];
		return projectDocument;
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getCachedProjectInWrapperForURLRef:display:error:
- (id)getCachedProjectInWrapperForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if(nil == fileURLRef)
	{
		return nil;
	}
	NSURL * fileURL = [*fileURLRef URLByPrependingCachedProjectComponent];
    id result = [self getProjectInWrapperForURLRef:&fileURL display:display error:outErrorPtr];
	if(result)
	{
		*fileURLRef = fileURL;
	}
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectURLsInHierarchyForURL:error:
- (NSArray *)getProjectURLsInHierarchyForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileURL isFileURL])
	{
		return nil;
	}
	NSString * fileName = [[fileURL path] stringByStandardizingPath];
	NSString * dirName = fileName;
	NSString * component = nil;
	NSString * projectDocumentType = [SDC projectDocumentType];
	iTM2ProjectDocument * projectDocument = nil;
	NSEnumerator * E = nil;
	NSMutableArray * candidates = [NSMutableArray array];
scanDirectoryContent:
	if([SWS isProjectPackageAtPath:dirName])
	{
		[candidates addObject:[NSURL fileURLWithPath:dirName]];
		return candidates;
	}
	if([SWS isWrapperPackageAtPath:dirName])
	{
		[candidates addObjectsFromArray:[dirName enclosedProjectFileNames]];
		return candidates;
	}
	E = [[DFM directoryContentsAtPath:dirName] objectEnumerator];
	BOOL finished = NO;
	NSURL * url = nil;
	while(nil != (component = [E nextObject]))
	{
		if([[SDC typeFromFileExtension:[component pathExtension]] pathIsEqual:projectDocumentType])
		{
			finished = YES;
			NSString * projectFileName = [dirName stringByAppendingPathComponent:component];
			url = [NSURL fileURLWithPath:projectFileName];
			projectDocument = [SDC documentForURL:url];
			if([projectDocument fileKeyForURL:fileURL])
			{
				[candidates addObject:url];
			}
			else if(nil == projectDocument)
			{
				// Open the Info.plist to find out the eventual key for this file
				NSURL * infoURL = [SPC mainInfoURLFromURL:url create:NO error:nil];
				NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:infoURL options:NSXMLNodeOptionsNone error:nil] autorelease];
				NSString * sourceDir = [projectFileName stringByDeletingLastPathComponent];
				NSString * xpath = [NSString stringWithFormat:@"/plist/dict/key[text()=\"%@\"]/following-sibling::*[1]",TWSSourceKey];
				NSArray * nodes = [doc nodesForXPath:xpath error:nil];
				if([nodes count])
				{
					sourceDir = [sourceDir stringByAppendingPathComponent:[[nodes lastObject] stringValue]];
				}
				NSString * relativeFilename = [fileName stringByAbbreviatingWithDotsRelativeToDirectory:sourceDir];
				xpath = [NSString stringWithFormat:@"/plist/dict/key[text()=\"%@\"]/following-sibling::*[1]/string[text()=\"%@\"]",TWSKeyedFilesKey,relativeFilename];
				nodes = [doc nodesForXPath:xpath error:nil];
				if([nodes count] > 0)
				{
					[candidates addObject:url];
				}
			}
		}
	}
	if([candidates count] > 0)
	{
		return candidates;
	}
	E = [[DFM directoryContentsAtPath:dirName] objectEnumerator];
	while(component = [E nextObject])
	{
		if([[SDC typeFromFileExtension:[component pathExtension]] pathIsEqual:projectDocumentType])
		{
			finished = YES;
			NSString * projectFileName = [dirName stringByAppendingPathComponent:component];
			url = [NSURL fileURLWithPath:projectFileName];
			projectDocument = [SDC documentForURL:url];
			if([[projectDocument fileKeyForRecordedURL:fileURL] length])
			{
				[candidates addObject:url];
			}
			else if(!projectDocument)
			{
				NSString * key = nil;
				NSString * subdirectory = [projectFileName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
				NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:subdirectory];
				// subdirectory variable is free now
				NSString * source = nil;
				NSString * target = nil;
				NSString * K;
				while(K = [DE nextObject])
				{
					key = [K isEqualToString:@"project"]?@".":K;
					source = [subdirectory stringByAppendingPathComponent:key];
					NSURL * url = [NSURL fileURLWithPath:source];
					NSData * aliasData = [NSData aliasDataWithContentsOfURL:url error:nil];
					target = [aliasData pathByResolvingDataAliasRelativeTo:nil error:nil];
					if([target pathIsEqual:fileName])
					{
						[candidates addObject:url];
					}
					#if 0
					possible problem with mounted volumes
					else if([target length] && ![DFM fileExistsAtPath:target])
					{
						// clean the alias because it points to an unexisting file, 
						if([DFM removeFileAtPath:source handler:NULL])
						{
							iTM2_LOG(@"Information: there was an alias pointing to nothing at\n%@",source);
						}
						else
						{
							iTM2_LOG(@"WARNING(4): COULD NOT REMOVE FILE AT PATH:\n%@",source);
						}
					}
					#endif
				}
				subdirectory = [projectFileName stringByAppendingPathComponent:[SPC absoluteSoftLinksSubdirectory]];
				DE = [DFM enumeratorAtPath:subdirectory];
				// subdirectory variable is free now
				while(K = [DE nextObject])
				{
					key = [K isEqualToString:@"project"]?@".":K;
					source = [subdirectory stringByAppendingPathComponent:key];
					target = [DFM pathContentOfSymbolicLinkAtPath:source];
					if([target pathIsEqual:fileName])
					{
						[candidates addObject:url];
					}
					#if 0
					possible problem with mounted volumes
					else if([target length] && ![DFM fileExistsAtPath:target] && ![DFM removeFileAtPath:source handler:NULL])
					{
						iTM2_LOG(@"WARNING(4): COULD NOT REMOVE FILE AT PATH:\n%@",source);
					}
					#endif
				}
			}
		}
	}
	if((0 == [candidates count]) && !finished)
	{
		NSString * newDirName = [dirName stringByDeletingLastPathComponent];
		if([newDirName length] < [dirName length])
		{
			dirName = newDirName;
			if([dirName length])
			{
				goto scanDirectoryContent;
			}
		}
	}
//iTM2_END;
    return candidates;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectInHierarchyForURL:display:error:
- (id)getProjectInHierarchyForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * candidates = [self getProjectURLsInHierarchyForURL:fileURL error:outErrorPtr];
	if([candidates count] == 1)
	{
//iTM2_LOG(@"WE have found our project",[SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		return [SDC openDocumentWithContentsOfURL:[candidates objectAtIndex:0] display:display error:outErrorPtr];
	}
	else if([candidates count] > 1)
	{
		[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"THERE ARE MANY DIFFERENT PROJECTS FOR THAT FILE NAME %@,unexpected situation",fileURL] forKey:NSLocalizedDescriptionKey]]];
		return [SDC openDocumentWithContentsOfURL:[candidates objectAtIndex:0] display:display error:outErrorPtr];
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getCachedProjectInHierarchyForURL:display:error:
- (id)getCachedProjectInHierarchyForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self getProjectInHierarchyForURL:[fileURL URLByPrependingCachedProjectComponent] display:display error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getSecondaryLibraryProjectForURL:display:error:
- (id)getSecondaryLibraryProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileURL isFileURL])
	{
		return nil;
	}
	NSString * fileName = [fileURL path];
 	NSString * cachedProjectsDirectory = [NSString cachedProjectsDirectory];
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:cachedProjectsDirectory];
	NSString * component = nil;
	NSString * typeName = [SDC projectDocumentType];
	NSMutableArray * openCandidates = [NSMutableArray array];
	NSMutableArray * candidates = [NSMutableArray array];
	NSMutableArray * recordedOpenCandidates = [NSMutableArray array];
	NSMutableArray * recordedCandidates = [NSMutableArray array];
	NSMutableArray * garbage = [NSMutableArray array];
	NSURL * projectURL = nil;
	NSString * projectName = nil;
	NSURL * wrapperURL = nil;
	NSString * wrapperName = nil;
	iTM2ProjectDocument * projectDocument = nil;
	while(component = [DE nextObject])
	{
		wrapperName = [cachedProjectsDirectory stringByAppendingPathComponent:component];
		if([SWS isWrapperPackageAtPath:wrapperName])
		{
			wrapperURL = [NSURL fileURLWithPath:wrapperName];
			projectURL = [self getProjectURLInWrapperForURLRef:&wrapperURL error:outErrorPtr];
			projectName = [projectURL path];
manageProject:
			if(nil != projectURL)
			{
				BOOL isDirectory = NO;
				if(projectDocument = [SDC documentForURL:projectURL])
				{
					if([[projectDocument fileKeyForURL:fileURL] length]>0)
					{
						[openCandidates addObject:projectDocument];
					}
					else if([[projectDocument fileKeyForRecordedURL:fileURL] length]>0)
					{
						[recordedOpenCandidates addObject:projectDocument];
					}
				}
				else if([DFM fileExistsAtPath:projectName isDirectory:&isDirectory])
				{
					if(isDirectory && (projectDocument = [SDC makeDocumentWithContentsOfURL:projectURL ofType:typeName error:outErrorPtr]))
					{
						if([[projectDocument fileKeyForURL:fileURL] length]>0)
						{
							[candidates addObject:projectDocument];
						}
						else if([[projectDocument fileKeyForRecordedURL:fileURL] length]>0)
						{
							[recordedCandidates addObject:projectDocument];
						}
					}
					else
					{
						[garbage addObject:projectName];
					}
				}
				else
				{
					[garbage addObject:projectName];
				}
			}
			else if(wrapperName)
			{
				[garbage addObject:wrapperName];
			}
			[DE skipDescendents];
		}
		else if([SWS isProjectPackageAtPath:wrapperName])
		{
			projectName = wrapperName;
			wrapperName = nil;
			projectURL = [NSURL fileURLWithPath:projectName];
			goto manageProject;
		}
	}
	if([openCandidates count] == 1)
	{
//iTM2_LOG(@"WE have found our project",[SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		projectDocument = [openCandidates objectAtIndex:0];
		[projectDocument fixProjectConsistency];
		[SPC setProject:projectDocument forURL:fileURL];
		NSEnumerator * E = nil;
		id PD = nil;
clean:
		E = [candidates objectEnumerator];
		while(PD = [E nextObject])
		{
			[garbage addObject:[PD fileName]];
		}
		E = [recordedCandidates objectEnumerator];
		while(PD = [E nextObject])
		{
			[garbage addObject:[PD fileName]];
		}
		E = [garbage objectEnumerator];
		while(projectName = [E nextObject])
		{
			wrapperName = [projectName enclosingWrapperFileName];
			if(![DFM removeFileAtPath:wrapperName handler:NULL])
			{
				if(outErrorPtr)
				{
					* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove the wrapper directory at\n%@\nPlease,do it for me.",wrapperName]
						forKey:NSLocalizedDescriptionKey]];
				}
			}
		}
		return projectDocument;
	}
	else if([openCandidates count])
	{
		projectDocument = nil;
		goto clean;
	}
	else if([recordedOpenCandidates count] == 1)
	{
		// clean everything except the documents owned by the SDC
		projectDocument = [openCandidates objectAtIndex:0];
		[projectDocument fixProjectConsistency];
		[SPC setProject:projectDocument forURL:fileURL];
		goto clean;
	}
	else if([recordedOpenCandidates count])
	{
//iTM2_LOG(@"WE have found our project",[SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		if(outErrorPtr)
		{
			* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Too many projects for:\n%@",fileName]
				forKey:NSLocalizedDescriptionKey]];
		}
		projectDocument = [recordedOpenCandidates objectAtIndex:0];
		[projectDocument fixProjectConsistency];
		[SPC setProject:projectDocument forURL:fileURL];
		goto clean;
	}
	else if([candidates count] == 1)
	{
//iTM2_LOG(@"WE have found our project",[SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		projectDocument = [candidates objectAtIndex:0];
project_found:
		[projectDocument fixProjectConsistency];
		[SDC addDocument:projectDocument];
		[SPC setProject:projectDocument forURL:fileURL];
		projectName = [projectDocument fileName];
		projectURL = [NSURL fileURLWithPath:projectName];
		projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr];
		goto clean;
	}
	else if([candidates count])
	{
		projectDocument = nil;
		goto clean;
	}
	else if([recordedCandidates count] == 1)
	{
		projectDocument = [recordedCandidates objectAtIndex:0];
		goto project_found;
	}
	else if([recordedCandidates count])
	{
		projectDocument = nil;
		goto clean;
	}
	else
	{
		projectDocument = nil;
	}
//iTM2_END;
	return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectDocumentFromProjects:fileKey:forURL:display:error:
- (id)getProjectDocumentFromProjects:(NSMutableArray *)projects fileKey:(NSString **)keyRef forURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"This is the point where we open an existing project. The given file URL does not belong to a project nor a wrapper either cached or not.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * filterE = [[NSArray arrayWithObjects:[NSNumber numberWithInt:iTM2PCFilterRegular],[NSNumber numberWithInt:iTM2PCFilterAlias],[NSNumber numberWithInt:iTM2PCFilterAbsoluteLink],nil] objectEnumerator];
	NSNumber * N;
	NSString * aKey = nil;
	while(N = [filterE nextObject])
	{
		// whether the fileURL was registered by a project
		NSEnumerator * E = [projects objectEnumerator];
		NSURL * projectURL = nil;
		id projectDocument = nil;
		while(projectURL = [E nextObject])
		{
			if(projectURL = [self URLForFileKey:@"." filter:[N intValue] inProjectWithURL:projectURL])
			{
				if(aKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterRegular inProjectWithURL:projectURL])
				{
					// fine, the project at projectURL (if any) knows about fileURL, this should never happen because it was already tested above
					#define OPEN_PROJECT_OR_REMOVE\
					if(projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr])\
					{\
						return projectDocument;\
					}\
					else\
					{\
						[projects removeObject:projectURL];\
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
		E = [projects objectEnumerator];
		while(projectURL = [E nextObject])
		{
			if(projectURL = [self URLForFileKey:@"." filter:[N intValue] inProjectWithURL:projectURL])
			{
				if(aKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterAlias inProjectWithURL:projectURL])
				{
					// this project did know about fileURL, as a finder alias
					// but if there is now an existing document for this key, this is not an acceptable project
					#define LEVEL1\
					aFileName = [[self URLForFileKey:aKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] path];\
					if(![DFM fileExistsAtPath:aFileName])\
					{\
						OPEN_PROJECT_OR_REMOVE;\
					}
					LEVEL1;
				}
			}
		}
		// None of the remaining project candidates knows about the given fileURL as either a regular file or a finder alias
		E = [projects objectEnumerator];
		while(projectURL = [E nextObject])
		{
			if(projectURL = [self URLForFileKey:@"." filter:[N intValue] inProjectWithURL:projectURL])
			{
				if(aKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterAbsoluteLink inProjectWithURL:projectURL])
				{
					// this project did know about fileURL, as an absolute path
					// but if there is now an existing document for this key, either regular or finder alias, this is not an acceptable project
					#define LEVEL2\
					aFileName = [[self URLForFileKey:aKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL] path];\
					if(![DFM fileExistsAtPath:aFileName])\
					{\
						LEVEL1;\
					}
					LEVEL2;
				}
			}
		}
		// None of the remaining project candidates knows about the given fileURL as either a regular file, a finder alias or an absolute link
		E = [projects objectEnumerator];
		while(projectURL = [E nextObject])
		{
			if(projectURL = [self URLForFileKey:@"." filter:[N intValue] inProjectWithURL:projectURL])
			{
				if(aKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterRelativeLink inProjectWithURL:projectURL])
				{
					// this project did know about fileURL, as an relative path
					// but if there is now an existing document for this key, either regular, finder alias or absolute, this is not an acceptable project
					#define LEVEL3\
					aFileName = [[self URLForFileKey:aKey filter:iTM2PCFilterAbsoluteLink inProjectWithURL:projectURL] path];\
					if(![DFM fileExistsAtPath:aFileName])\
					{\
						LEVEL2;\
					}
					LEVEL3;
				}
			}
		}
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getUnregisteredProject:fileKey:forURL:display:error:
- (BOOL)getUnregisteredProject:(id *)projectRef fileKey:(NSString **)keyRef forURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"This is the point where we open an existing project. The given file URL does not belong to a project nor a wrapper either cached or not.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == fileURL)
	{
		return NO;// no fileURL given, no project
	}
	NSMutableArray * projects = [NSMutableArray array];// possible project URL's candidates
	NSDictionary * contextDictionary = [iTM2Document contextDictionaryFromURL:fileURL];// retrieve the project from the context dictionary
	NSString * S = [contextDictionary objectForKey:iTM2ProjectURLKey];// S is expected to be properly escaped!
	NSURL * projectURL = nil;
	NSURL * url = nil;
	NSString * theKey = nil;
	iTM2ProjectDocument * projectDocument = nil;
	if([S isKindOfClass:[NSString class]])
	{
		projectURL = [NSURL URLWithString:S];
newProjectURLCandidate:
		theKey = [contextDictionary objectForKey:iTM2ProjectFileKeyKey];
		if([SWS isProjectPackageAtPath:[projectURL path]])
		{
			url = [self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
			if([[url absoluteURL] isEqual:[fileURL absoluteURL]])
			{
				if(projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr])
				{
theEnd:
					[projectDocument fixProjectConsistency];// this must be revisited
					if(projectRef)
					{
						*projectRef = projectDocument;
					}
					if(keyRef)
					{
						*keyRef = theKey;
					}
					else
					{
						[projectDocument setURL:fileURL forFileKey:theKey];
						[projectDocument newFileKeyForURL:fileURL];// ensure that the file URL is registered.
					}
					return YES;
				}
				// we could not open that document
				// try other otions
			}
			else
			{
				[projects addObject:projectURL];// the context project does not seem to be the good one
			}
		}
	}
	else
	{
		S = [contextDictionary objectForKey:iTM2ProjectAbsolutePathKey];// Old Absolute Project File Name, support for version prior to 689
		if([S isKindOfClass:[NSString class]])
		{
			projectURL = [NSURL fileURLWithPath:S];
			goto newProjectURLCandidate;
		}
	}
	// now we have a new candidate
	// we try to find other candidates
	// we create a project URL relative to the receiver
	NSString * relativeName = [contextDictionary objectForKey:iTM2ProjectRelativePathKey];
	NSString * projectName = nil;
	if([relativeName isKindOfClass:[NSString class]])
	{
		projectName = [[fileURL path] stringByDeletingLastPathComponent];
		projectName = [projectName stringByAppendingPathComponent:relativeName];
		projectName = [projectName stringByStandardizingPath];
		#define ABSOLUTE_FILE_NAME_FOR_KEY\
		projectURL = [NSURL fileURLWithPath:projectName];\
		if(![projects containsObject:projectURL]\
			&& [SWS isProjectPackageAtPath:[projectURL path]])\
		{\
			if([[[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] absoluteURL] isEqual:[fileURL absoluteURL]])\
			{\
				if(projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr])\
				{\
					goto theEnd;\
				}\
			}\
			else\
			{\
				[projects addObject:projectURL];\
			}\
		}
		ABSOLUTE_FILE_NAME_FOR_KEY;
	}
	NSData * aliasData = [contextDictionary objectForKey:iTM2ProjectOwnAliasKey];
	if([aliasData isKindOfClass:[NSData class]]
		&& (projectName = [aliasData pathByResolvingDataAliasRelativeTo:nil error:outErrorPtr]))
	{
		ABSOLUTE_FILE_NAME_FOR_KEY;
	}
	// in the hierarchy
	NSString * dirName = [[fileURL path] stringByDeletingLastPathComponent];
	NSArray * contents = nil;
	NSEnumerator * E = nil;
	NSString * component = nil;
	while([dirName length]>1)
	{
		contents = [DFM directoryContentsAtPath:dirName];
		E = [contents objectEnumerator];
		while(component = [E nextObject])
		{
			projectName = [dirName stringByAppendingPathComponent:component];
			projectURL = [NSURL fileURLWithPath:projectName];
			if(![projects containsObject:projectURL] && [SWS isProjectPackageAtPath:[projectURL path]])
			{
iTM2_LOG(@"projectURL:%@",projectURL);
				if([[[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] absoluteURL] isEqual:[fileURL absoluteURL]])
				{
					if(projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr])
					{
						goto theEnd;
					}
					else
					{
						iTM2_OUTERROR(1,([NSString stringWithFormat:@"Problem opening projectn%@",
							projectName]),(outErrorPtr?*outErrorPtr:nil));
					}
				}
				[projects addObject:projectURL];
			}
		}
		dirName = [dirName stringByDeletingLastPathComponent];
	}
	// in the cached hierarchy, this is only for projects that could not be written because of a lack of right
	NSString * fileName = [fileURL path];
	if(![fileName belongsToDirectory:[[NSURL cachedProjectsDirectoryURL] path]])
	{
		dirName = [fileName stringByDeletingLastPathComponent];
		dirName = [[NSString cachedProjectsDirectory] stringByAppendingPathComponent:dirName];
		while([dirName length]>[[NSString cachedProjectsDirectory] length])
		{
			contents = [DFM directoryContentsAtPath:dirName];
			E = [contents objectEnumerator];
			while(component = [E nextObject])
			{
				projectName = [dirName stringByAppendingPathComponent:component];
				if([SWS isWrapperPackageAtPath:projectName])
				{
					projectName = [[projectName enclosedProjectFileNames] lastObject];
				}
				if([SWS isProjectPackageAtPath:projectName])
				{
					projectURL = [NSURL fileURLWithPath:projectName];
					if(![projects containsObject:projectURL])
					{
iTM2_LOG(@"projectURL:%@",projectURL);
						if([[[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] absoluteURL] isEqual:[fileURL absoluteURL]])
						{
							if(projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr])
							{
								goto theEnd;
							}
							else
							{
								iTM2_OUTERROR(1,([NSString stringWithFormat:@"Problem opening project\n%@",
									projectName]),(outErrorPtr?*outErrorPtr:nil));
							}
						}
						[projects addObject:projectURL];
					}
				}
			}
			dirName = [dirName stringByDeletingLastPathComponent];
		}
	}
	if(projectDocument = [self getProjectDocumentFromProjects:projects fileKey:keyRef forURL:fileURL display:display error:outErrorPtr])
	{
		goto theEnd;
	}
	NSString * oldFileName = [contextDictionary objectForKey:iTM2ProjectAbsolutePathKey];
	if(![oldFileName pathIsEqual:fileName]
		&& ![DFM fileExistsAtPath:oldFileName]
			&& [self getUnregisteredProject:&projectDocument fileKey:&theKey forURL:[NSURL fileURLWithPath:oldFileName] display:display error:outErrorPtr])
	{
		// as we passed a pointer to receive the key, the returned project has not yet set up the key->file binding.
		goto theEnd;
	}
	NSString * resolvedFileName = nil;
	if((aliasData = [contextDictionary objectForKey:iTM2ProjectOwnAliasKey])
		&& [aliasData isKindOfClass:[NSData class]])
	{
		resolvedFileName = [aliasData pathByResolvingDataAliasRelativeTo:nil error:outErrorPtr];
		if(![resolvedFileName pathIsEqual:fileName]
			&& ![resolvedFileName pathIsEqual:oldFileName]
				&& ![DFM fileExistsAtPath:resolvedFileName]
					&& [self getUnregisteredProject:&projectDocument fileKey:&theKey forURL:[NSURL fileURLWithPath:resolvedFileName] display:display error:outErrorPtr])
		{
			goto theEnd;
		}
	}
	NSString * texFileName = [fileName stringByDeletingPathExtension];
	texFileName = [texFileName stringByAppendingPathExtension:@"tex"];
	if(![texFileName pathIsEqual:fileName]
		&& ![texFileName pathIsEqual:oldFileName]
			&& ![texFileName pathIsEqual:resolvedFileName]
				&& [self getUnregisteredProject:&projectDocument fileKey:&theKey forURL:[NSURL fileURLWithPath:texFileName] display:display error:outErrorPtr])
	{
		goto theEnd;
	}
	// scan the cached projects folder
	// this is only relevant when the user can't write where the file URL is located
	// otherwise this is the preferred location of the associated project
	NSString * cachedProjectsDirectory = [NSString cachedProjectsDirectory];
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:cachedProjectsDirectory];
	NSString * wrapperName = nil;
	projects = [NSMutableArray array];
	NSMutableArray * garbage = [NSMutableArray array];
	while(component = [DE nextObject])
	{
		wrapperName = [cachedProjectsDirectory stringByAppendingPathComponent:component];
		if([SWS isWrapperPackageAtPath:wrapperName])
		{
			url = [NSURL fileURLWithPath:wrapperName];
			if(projectURL = [self getProjectURLInWrapperForURLRef:&url error:outErrorPtr])
			{
				if(theKey = [self fileKeyForURL:fileURL filter:iTM2PCFilterRegular inProjectWithURL:projectURL])
				{
					url = [NSURL fileURLWithPath:projectName];
					if(projectDocument = [SDC openDocumentWithContentsOfURL:url display:display error:outErrorPtr])
					{
						goto theEnd;
					}
					else
					{
						[garbage addObject:projectName];
					}
				}
				else
				{
					[projects addObject:projectURL];
				}
			}
			else
			{
				[garbage addObject:projectName];
			}
			[DE skipDescendents];
		}
	}
	if(projectDocument = [self getProjectDocumentFromProjects:projects fileKey:keyRef forURL:fileURL display:display error:outErrorPtr])
	{
		goto theEnd;
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextProjectForURL:display:error:
- (id)getContextProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileURL isFileURL])
	{
		return nil;
	}
	// I assume that all previous attempts to assign a project to the given file have failed
	// This means that there is no acceptable project in the file system hierarchy.
	id projectDocument = nil;
	// so I needed to open the resources. Now documents always have projects,but I still use the resources
	NSDictionary * contextDictionary = [iTM2Document contextDictionaryFromURL:fileURL];
//iTM2_LOG(@"contextDictionary is:%@",contextDictionary);
	// using the absolute hint
	NSString * path = [contextDictionary objectForKey:iTM2ProjectAbsolutePathKey];
	NSURL * url = nil;
	if([path isKindOfClass:[NSString class]] && [SWS isProjectPackageAtPath:path])
	{
		url = [NSURL fileURLWithPath:path];
		NSAssert(![url isEqual:fileURL],@"Recursive call catched... THIS IS A BIG BUG");
	}
	else
	{
		NSString * projectRelativePathHint = [contextDictionary objectForKey:iTM2ProjectRelativePathKey];
		NSString * pathGuessFromRelativeHint = nil;// project absolute path
		if([projectRelativePathHint isKindOfClass:[NSString class]]
			&& [[projectRelativePathHint pathExtension] pathIsEqual:[SDC projectPathExtension]])
		{
			// the document once had a project,or is a copy/move of a document that once had a project
			// we assume that it still belongs to a project...
			#if 1
			NSString * dirName = [fileURL path];
			dirName = [dirName stringByDeletingLastPathComponent];
			pathGuessFromRelativeHint = [dirName stringByAppendingPathComponent:projectRelativePathHint];
			#else
			// there was a bug here: the code below did not provide the same result as the code above
			// whereas it sometimes did.
			// This is in accordance to the compiler specifications where functions may not be composed
			// f(g(x))should be replaced by y=g(x);f(y); NO, I think I misunderstood!
			pathGuessFromRelativeHint = [[fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:projectRelativePathHint];
			#endif
			pathGuessFromRelativeHint = [pathGuessFromRelativeHint stringByStandardizingPath];
			url = [NSURL fileURLWithPath:pathGuessFromRelativeHint];
		}
		else
		{
			return nil;
		}
	}
	if(projectDocument = [SDC documentForURL:url])
	{
		NSString * key = [projectDocument fileKeyForURL:fileURL];
		if([key length])
		{
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
			return projectDocument;
		}
		else
		{
			key = [projectDocument fileKeyForRecordedURL:fileURL];
			// ok this project once had this file name on its own
			if([key length])
			{
				[projectDocument setURL:fileURL forFileKey:key];
				key = [projectDocument newFileKeyForURL:fileURL];// ensure that the file URL is registered.
				if(display)
				{
					[projectDocument makeWindowControllers];
					[projectDocument showWindows];
				}
				return projectDocument;
			}
		}
	}
	path = [url path];
	BOOL isDirectory = NO;
	if([DFM fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory)
	{
		NSString * typeName = [SDC typeForContentsOfURL:url error:outErrorPtr];
		if(nil != (projectDocument = [SDC makeDocumentWithContentsOfURL:url ofType:typeName error:outErrorPtr]))
		{
			[projectDocument fixProjectConsistency];
			// the url might have changed!
			url = [projectDocument fileURL];
			path = [url path];
			NSString * key = [projectDocument fileKeyForURL:fileURL];
			if([key length])
			{
				[SDC addDocument:projectDocument];
				[projectDocument saveDocument:nil];
				if(display)
				{
					[projectDocument makeWindowControllers];
					[projectDocument showWindows];
				}
				return projectDocument;
			}
			else
			{
				key = [projectDocument fileKeyForRecordedURL:fileURL];
				// ok this project once had this file name on its own
				if([key length])
				{
					[SDC addDocument:projectDocument];
					[projectDocument saveDocument:nil];
					[projectDocument setURL:fileURL forFileKey:key];
					key = [projectDocument newFileKeyForURL:fileURL];// ensure that the file name is registered.
					if(display)
					{
						[projectDocument makeWindowControllers];
						[projectDocument showWindows];
					}
					return projectDocument;
				}
			}
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectForCachedURL:display:error:
- (id)getProjectForCachedURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[fileURL path] belongsToDirectory:[[NSURL cachedProjectsDirectoryURL] path]])
	{
		return nil;
	}
	// find the enclosing directory wrapper
	NSURL * url = [fileURL enclosingWrapperURL];
	id projectDocument = nil;
	if(url)
	{
		NSString * path = [[url path] stringByAppendingPathComponent:iTM2ProjectComponent];
		path = [path stringByAppendingPathExtension:[SDC projectPathExtension]];
		url = [NSURL fileURLWithPath:path];
url_is_found:
		projectDocument = [SDC openDocumentWithContentsOfURL:url display:display error:outErrorPtr];
		[projectDocument fixProjectConsistency];
		[SPC setProject:projectDocument forURL:fileURL];
		return projectDocument;
	}
	else if(url = [fileURL enclosingProjectURL])
	{
		goto url_is_found;
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectPanelControllerClass
- (Class)newProjectPanelControllerClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [iTM2NewProjectController class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newCachedProjectForURL:display:error:
- (id)newCachedProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"We create a new library project when it is not possible to create a project,
mainly because we have no write access to the right location.
If we already have a project, but it is readonly, we must create a library project to hold the factory folder.
The library project won't be used for anything else (as of build greater than 689).
If we cannot have a project in the normal location, we will create a library one.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileURL isFileURL])
	{
		return nil;
	}
	// create an 'library' project
	NSString * cachedProjectsDirectory = [NSString cachedProjectsDirectory];
	NSString * typeName = [SDC projectDocumentType];
	iTM2ProjectDocument * projectDocument = [SDC makeUntitledDocumentOfType:typeName error:outErrorPtr];
	if(projectDocument)
	{
		NSString * fileName = [fileURL path];
		NSString * component = [fileName lastPathComponent];
		NSString * coreName = [component stringByDeletingPathExtension];
		NSString * libraryWrapperName = [[fileName stringByDeletingPathExtension] stringByAppendingPathExtension:[SDC wrapperPathExtension]];
		libraryWrapperName = [cachedProjectsDirectory stringByAppendingPathComponent:libraryWrapperName];
		// libraryWrapperName is now the directory wrapper name
		BOOL isDirectory = NO;
		if([DFM fileExistsAtPath:libraryWrapperName isDirectory:&isDirectory])
		{
			if(!isDirectory)
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Unexpected file at\n%@\nwill be removed.",libraryWrapperName]
							forKey:NSLocalizedDescriptionKey]]];
				if(![DFM removeFileAtPath:libraryWrapperName handler:NULL])
				{
					[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove\n%@\nPlease,do it for me now and click OK.",libraryWrapperName]
								forKey:NSLocalizedDescriptionKey]]];
					if([DFM fileOrLinkExistsAtPath:libraryWrapperName])
					{
						if(outErrorPtr)
						{
							*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
								userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"You did not remove file at\n%@\nNo project created...",libraryWrapperName]
										forKey:NSLocalizedDescriptionKey]];
						}
						return nil;
					}
createWrapper:
					if(![DFM createDeepDirectoryAtPath:libraryWrapperName attributes:nil error:outErrorPtr])
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
								userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create folder at\n%@\nPlease do it for me now and click OK",libraryWrapperName]
									forKey:NSLocalizedDescriptionKey]]];
						if(![DFM fileExistsAtPath:libraryWrapperName isDirectory:&isDirectory] || !isDirectory)
						{
							if(outErrorPtr)
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
		projectName = [projectName stringByAppendingPathExtension:[SDC projectPathExtension]];
		if(![DFM createDeepDirectoryAtPath:projectName attributes:nil error:outErrorPtr] && outErrorPtr && (outErrorPtr?*outErrorPtr:nil))
		{
			[SDC presentError:*outErrorPtr];
		}
		NSURL * url = [NSURL fileURLWithPath:projectName];
//iTM2_LOG(@"url: %@",url);
		[projectDocument setFileURL:url];
		[projectDocument setFileType:typeName];// is it necessary?
		[SDC addDocument:projectDocument];
		// the named file is linked to something in the wrapper
		NSString * linkName = [projectName stringByDeletingLastPathComponent];
		linkName = [linkName stringByAppendingPathComponent:component];
		// maybe there is already something at this path: we just remove it
		// if it was a link,I just remove it with
		// it it was a regular file or a directory,recycle it
		if([DFM pathContentOfSymbolicLinkAtPath:linkName])
		{
			if(![DFM removeFileAtPath:linkName handler:nil])
			{
				iTM2_OUTERROR(1,([NSString stringWithFormat:@"Could not remove the link at %@",linkName]),nil);
			}
		}
		else if([DFM fileOrLinkExistsAtPath:linkName])
		{
			NSString * dirName = [linkName stringByDeletingLastPathComponent];
			NSString * component = [linkName lastPathComponent];
			NSArray * RA = [NSArray arrayWithObject:component];
			int tag = 0;
			if(![SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName destination:@"" files:RA tag:&tag])
			{
				iTM2_OUTERROR(tag,([NSString stringWithFormat:@"Could not recycle synchronously file at %@",linkName]),nil);
			}
		}
		if([DFM createSymbolicLinkAtPath:linkName pathContent:fileName])
		{
			fileURL = [NSURL fileURLWithPath:linkName];
		}
		[projectDocument newFileKeyForURL:fileURL];
// can I save to that folder?
		[projectDocument saveDocument:nil];
		NSAssert2([[projectDocument fileKeyForURL:fileURL] length],@"%@ The key must be non void for filename: %@",__iTM2_PRETTY_FUNCTION__,[fileURL path]);
		if(display)
		{
			[projectDocument addGhostWindowController];// not makeWindowControllers
			[projectDocument showWindows];
		}
	}
//iTM2_END;
    return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectFromPanelForFileURLRef:display:error:
- (id)getProjectFromPanelForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == fileURLRef)
	{
		return nil;
	}
	NSURL * fileURL = *fileURLRef;
	if([[fileURL path] belongsToDirectory:[[NSURL cachedProjectsDirectoryURL] path]])
	{
		return nil;
	}
	id projectDocument = nil;
	NSMutableArray * MRA = [[[SUD arrayForKey:@"_iTM2DocumentFileURLsOpenedFromFinder"] mutableCopy] autorelease];
	if(NO && [MRA containsObject:fileURL])
	{
		// if the document was opened from the Finder, we automatically create a new project for it.
		// this is not a good idea, so we remove it for the moment
		[MRA removeObject:fileURL];
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:MRA forKey:@"_iTM2DocumentFileURLsOpenedFromFinder"]];
newLibraryProject:
		projectDocument = [self newCachedProjectForURL:fileURL display:NO error:outErrorPtr];// NO is required unless a ghost window controller is created
		[projectDocument saveDocument:nil];
		[SPC setProject:projectDocument forURL:fileURL];
		return projectDocument;
	}
	NSString * fileName = [fileURL path];
	NSString * dirName = [fileName stringByDeletingLastPathComponent];
	if(![DFM isWritableFileAtPath:dirName])
	{
		// no need to go further
		goto newLibraryProject;
	}
	// reentrant management,if the panel for that particular file is already running,do nothing...
	NSEnumerator * E = [[NSApp windows] objectEnumerator];
	NSWindow * W;
	id controller;
	Class controllerClass = [self newProjectPanelControllerClass];
	while(nil != (W = [E nextObject]))
	{
		controller = [W windowController];
		if([controller isKindOfClass:controllerClass] && [[[controller fileURL] absoluteURL] isEqual:[fileURL absoluteURL]])
		{
			return nil;
		}
	}
//iTM2_LOG(@"fileName is:%@",fileName);
	controller = [[controllerClass alloc] initWithWindowNibName:NSStringFromClass(controllerClass)];
	[controller setFileURL:fileURL];
	int returnCode = 0;
	if(W = [controller window])
	{
		returnCode = [NSApp runModalForWindow:W];
		[W orderOut:self];
	}
	[controller autorelease];// only now, unless you want to break the code in the modal loop above
	NSURL * projectURL = [controller projectURL];
	NSString * projectName = [projectURL path];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"return code is:%u",returnCode);
		iTM2_LOG(@"projectName is:%@",projectName);
	}
	switch(returnCode)
	{
		case iTM2ToggleNewProjectMode:
		{
			if(![DFM createDeepDirectoryAtPath:projectName attributes:nil error:nil])
			{
				iTM2_OUTERROR(1,([NSString stringWithFormat:@"For one reason or another I could not ceate some directory at path:%@",projectName]),nil);
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
			NSString * wrapperName = [projectName enclosingWrapperFileName];
			if([wrapperName length])
			{
				NSString * sourceDirName = [[self URLForFileKey:TWSSourceKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] path];
				// The project does belong to a wrapper
				// we must change the fileURL
				// as I said before, if the fileURL was part of a wrapper, we would have catched it before
				// and the present message would never have been sent
				if(![dirName belongsToDirectory:sourceDirName])
				{
					NSString * component = [fileName lastPathComponent];
					fileURL = [NSURL fileURLWithPath:[sourceDirName stringByAppendingPathComponent:component]];
					* fileURLRef = fileURL;
					int tag;
					if(![SWS performFileOperation:NSWorkspaceMoveOperation
							source:dirName
								destination:sourceDirName
									files:[NSArray arrayWithObject:component]
										tag:&tag])
					{
						iTM2_OUTERROR(tag,([NSString stringWithFormat:@"Could not move %@ to %@\nPlease,do it for me...",fileName,sourceDirName]),nil);
					}
					fileName = [fileURL path];
					dirName = sourceDirName;
				}
			}
			// we will have a project at projectName
			// is there an already existing file at that path?
			NSURL * absoluteURL = [NSURL fileURLWithPath:projectName];
			NSString * typeName = [SDC typeFromFileExtension:[projectName pathExtension]];
			if([SWS isProjectPackageAtPath:projectName] || [DFM createDeepDirectoryAtPath:projectName attributes:nil error:outErrorPtr])
			{
				projectDocument = [SDC openDocumentWithContentsOfURL:absoluteURL display:NO error:outErrorPtr];
			}
			else
			{
				projectDocument = [[[SDC makeUntitledDocumentOfType:typeName error:outErrorPtr] retain] autorelease];
				[projectDocument setFileURL:absoluteURL];
				[projectDocument saveDocument:self];
				[SDC addDocument:projectDocument];
			}
//iTM2_LOG(@"Now the file name of the projectDocument is:%@",[projectDocument fileName]);
//iTM2_LOG(@">>>>>>>>>>>>>>>>>>>   I have a projectDocument:%@",projectDocument);
//iTM2_LOG(@">>>>>>>>>>>>>>>>>>>   [SDC documents] are:%@",[SDC documents]);
			[projectDocument newFileKeyForURL:fileURL];
			[SPC setProject:projectDocument forURL:fileURL];
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
			[DFM setExtensionHidden:YES atPath:projectName];
			return projectDocument;
		}
		break;
		case iTM2ToggleOldProjectMode:
		{
			id projectDocument = [[[SDC openDocumentWithContentsOfURL:projectURL display:NO error:nil] retain] autorelease];
			NSString * projectDirName = [projectDocument fileName];
			NSString * projectWrapperName = [projectDirName enclosingWrapperFileName];
			projectDirName = [projectDirName stringByDeletingLastPathComponent];
			if([projectWrapperName length])
			{
				if(![dirName pathIsEqual:projectDirName])
				{
					// we must change the name
					NSString * component = [fileName lastPathComponent];
					fileName = [projectDirName stringByAppendingPathComponent:component];
					* fileURLRef = [NSURL fileURLWithPath:fileName];
					int tag;
					if(![SWS performFileOperation:NSWorkspaceMoveOperation
							source:dirName
								destination:projectDirName
									files:[NSArray arrayWithObject:component]
										tag:&tag])
					{
						iTM2_OUTERROR(tag,([NSString stringWithFormat:@"Could not move %@ to %@\nPlease,do it for me...",fileName,projectDirName]),nil);
					}
					fileURL = * fileURLRef;
					dirName = projectDirName;
				}
			}
			if([projectDocument newFileKeyForURL:fileURL])
			{
				[projectDocument saveDocument:self];
			}
			[SPC setProject:projectDocument forURL:fileURL];
			if(display)
			{
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
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil != fileURL)
	{
		[REENTRANT_PROJECT removeObject:fileURL];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectForURLRef:display:error:
- (id)newProjectForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!fileURLRef || ![*fileURLRef isFileURL])
	{
		return nil;
	}
	NSURL * fileURL = *fileURLRef;// don't change fileURL
	id projectDocument = [self projectForURL:fileURL];
	if(nil != projectDocument)
	{
		return projectDocument;// this filename is already registered, possibly with a "nil" project ("nil" projects are no longer supported, see "Elementary")
	}
	// reentrant code
	[self setProject:nil forURL:fileURL];
	if(![self canGetNewProjectForURL:fileURL error:outErrorPtr])
	{
		return nil;
	}
	[self willGetNewProjectForURL:fileURL];
	// nil is returned for project file names...
	NSString * projectDocumentType = [SDC projectDocumentType];
	if(([[SDC typeForContentsOfURL:fileURL error:nil] isEqual:projectDocumentType]
		&& Nil != [SDC documentClassForType:projectDocumentType])
		|| (nil != (projectDocument = [self getOpenProjectForURL:fileURL]))
		|| (nil != (projectDocument = [self getProjectInWrapperForURLRef:fileURLRef display:display error:outErrorPtr]))
		|| (nil != (projectDocument = [self getProjectInHierarchyForURL:fileURL display:display error:outErrorPtr]))
//		|| (nil != (projectDocument = [self getLibraryProjectForURL:fileURL display:display error:outErrorPtr]))
		|| (nil != (projectDocument = [self getProjectFromPanelForURLRef:fileURLRef display:display error:outErrorPtr])))
	{
		if([[*fileURLRef path] belongsToDirectory:[[NSURL cachedProjectsDirectoryURL] path]])
		{
			*fileURLRef = fileURL;
		}
		[self setProject:projectDocument forURL:*fileURLRef];// not fileURL!!! it may have changed
		[self didGetNewProjectForURL:fileURL];
		return projectDocument;
	}
	return nil;
}
#pragma mark =-=-=-=-=-  BASE PROJECTS
static NSString * const iTM2ProjectsBaseNamesKey = @"_PCPBNs";
#define BASE_URLs [IMPLEMENTATION metaValueForKey:iTM2ProjectsBaseNamesKey]

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareBaseProjectsFixImplementation
- (void)prepareBaseProjectsFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning ERROR ! those 2 are extremely suspect
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsBaseKey];
	if(![IMPLEMENTATION metaValueForKey:iTM2ProjectsForFileNamesKey])
	{
		[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsForFileNamesKey];
	}
	if(![IMPLEMENTATION metaValueForKey:iTM2ProjectsBaseNamesKey])
	{
		[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsBaseNamesKey];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfBaseProjects
- (unsigned int)countOfBaseProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self baseProjectNames] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectNames
- (NSArray *)baseProjectNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [BASE_URLs allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectForFileName:
- (id)baseProjectForURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    NSParameterAssert(nil != projectURL);
	projectURL = [projectURL absoluteURL];
    id P = [BASE_PROJECTS objectForKey:projectURL];
    if(P)
	{
        return P;
	}
	if(iTM2DebugEnabled>100000)
	{
		iTM2_LOG(@"projectURL:%@",projectURL);
	}
	// is it really a base project we have been asked for?
	NSString * projectFileName = [[projectURL path] stringByStandardizingPath];
	NSString * projectName = [[projectFileName lastPathComponent] stringByDeletingPathExtension];
	NSArray * possibleFileNames = [BASE_URLs objectForKey:projectName];
	NSAssert([possibleFileNames containsObject:projectFileName],@"! CODE ERROR: baseProjectForFileName parameter must be a base project name.");
	NSString * type = [SDC typeFromFileExtension:[projectFileName pathExtension]];
	if(P = [SDC makeUntitledDocumentOfType:type error:nil])
	{
		[P setFileURL:projectURL];
		[P setFileType:type];
		if(![P readFromURL:projectURL ofType:type error:nil])
		{
			iTM2_LOG(@"Could not open the project document:%@", projectURL);
		}
		[BASE_PROJECTS setObject:P forKey:projectURL];
	}
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [BASE_PROJECTS objectForKey:fileURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectWithName:
- (id)baseProjectWithName:(NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * URLs = [BASE_URLs objectForKey:projectName];
//iTM2_END;
	return [URLs count]? [self baseProjectForURL:[URLs objectAtIndex:0]]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyBaseNameMapping
- (NSDictionary *)lazyBaseNameMapping;
/*"Description forthcoming. Subclassers will override this! Not exposed.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * MRA = [NSMutableArray arrayWithArray:[self orderedBaseProjectNames]];
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	while([MRA count])
	{
		NSString * name = [[[MRA lastObject] retain] autorelease];
		[MRA removeLastObject];
		if([name isEqualToString:iTM2ProjectDefaultName])
		{
			[MD setObject:@"" forKey:name];
		}
		else
		{
			NSEnumerator * E = [MRA reverseObjectEnumerator];// from the longest to the shortest, subclassed for a more clever test
			NSString * baseName;
next_baseName:
			if(baseName = [E nextObject])
			{
				if([name rangeOfString:baseName].length)
				{
					[MD setObject:baseName forKey:name];
				}
				else
				{
					goto next_baseName;
				}
			}
			else
			{
				[MD setObject:iTM2ProjectDefaultName forKey:name];
			}
		}
	}
//iTM2_END;
	return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedBaseProjectNames
- (NSArray *)orderedBaseProjectNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * baseProjectsRepository = [NSBundle temporaryBaseProjectsDirectory];
	NSEnumerator * E = [[DFM directoryContentsAtPath:baseProjectsRepository] objectEnumerator];
	NSString * path = nil;
	NSMutableSet * MS = [NSMutableSet set];
	while(path = [E nextObject])
	{
		path = [baseProjectsRepository stringByAppendingPathComponent:path];
		NSEnumerator * e = [[DFM directoryContentsAtPath:path] objectEnumerator];
		NSString * requiredExtension = [SDC projectPathExtension];
		NSString * component = nil;
		while(component = [e nextObject])
		{
			if(![component hasPrefix:@"."] && [[component pathExtension] pathIsEqual:requiredExtension])
			{
				NSString * core = [component stringByDeletingPathExtension];
				if(![core hasSuffix:@"~"])// this is not a backup
				{
					[MS addObject:core];
				}
			}
		}
	}
	[IMPLEMENTATION takeMetaValue:nil forKey:@"baseNamesOfAncestorsForBaseProjectName"];
	if(![MS count])
	{
		iTM2_LOG(@"ERROR: no base projects are available, please reinstall");
		return nil;
	}
	// get in MRA an ordered list of the project names, from the shortest to the longest
	// and alphabetically, when the length is the same
	path = [MS anyObject];
	NSMutableArray * MRA = [NSMutableArray arrayWithObject:path];
	[MS removeObject:path];
	E = [MS objectEnumerator];
	while(path = [E nextObject])
	{
		unsigned index = [MRA count];
next_index:
		if(index--)
		{
			if(([[MRA objectAtIndex:index] length] < [path length])
				|| (([[MRA objectAtIndex:index] length] == [path length]) && ([(NSString *)[MRA objectAtIndex:index] compare: path] == NSOrderedDescending)))
			{
				[MRA insertObject:path atIndex:index+1];
			}
			else
			{
				goto next_index;
			}
				
		}
		else
		{
			[MRA insertObject:path atIndex:0];
		}
		[MS removeObject:path];
	}
iTM2_LOG(@"%@",MRA);
//iTM2_END;
	return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedBaseProjectNamesForName:
- (NSArray *)orderedBaseProjectNamesForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * baseProjectsRepository = [NSBundle temporaryBaseProjectsDirectory];
	NSEnumerator * E = [[DFM directoryContentsAtPath:baseProjectsRepository] objectEnumerator];
	NSString * path = nil;
	NSMutableArray * MRA = [NSMutableArray array];
	while(path = [E nextObject])
	{
		if([[path stringByDeletingPathExtension] pathIsEqual:name])
		{
			[MRA addObject:[path stringByResolvingSymlinksInPath]];
		}
	}
iTM2_LOG(@"name:%@->%@",name,MRA);
//iTM2_END;
	return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateBaseProjectsNotified:
- (void)updateBaseProjectsNotified:(NSNotification *) irrelevant;
/*"Description forthcoming. startup time used 1883/4233=0,44483817623, 0,23483309144
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSBundle * MB = [NSBundle mainBundle];
	[MB pathForSupportDirectory:iTM2ProjectBaseComponent inDomain:NSUserDomainMask create:YES];
	NSArray * paths = [MB allPathsForResource:iTM2ProjectBaseComponent ofType:@""];
	NSString * baseProjectsRepository = [NSBundle temporaryBaseProjectsDirectory];
	unsigned index = [paths count];
	id P = nil;
	NSString * source = nil;
	NSEnumerator * E = nil;
	NSString * K;
	[BASE_URLs setDictionary:[NSDictionary dictionary]];// clean the previous cache
	NSMutableArray * MRA;
	while(index--)
	{
		P = [paths objectAtIndex:index];
		source = [baseProjectsRepository stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.texps",index]];
		if((([DFM fileExistsAtPath:source] || [DFM pathContentOfSymbolicLinkAtPath:source])
				&& ![DFM removeFileAtPath:source handler:self])
					|| ![DFM createSymbolicLinkAtPath:source pathContent:P])
		{
			iTM2_LOG(@"FAILURE: the base project folder %@ is not registered",P);
		}
		else
		{
			E = [[DFM directoryContentsAtPath:P] objectEnumerator];
			while(source = [E nextObject])
			{
				K = [source stringByDeletingPathExtension];
				source = [[P stringByAppendingPathComponent:source] stringByStandardizingPath];// don't miss that!
				if([SWS isProjectPackageAtPath:source])
				{
					if(MRA = [BASE_URLs objectForKey:K])
					{
						[MRA addObject:source];
					}
					else
					{
						[BASE_URLs setObject:[NSMutableArray arrayWithObject:source] forKey:K];
					}
				}
			}
		}
	}
	//remove the extra links that may live here
next:
	source = [baseProjectsRepository stringByAppendingString:[NSString stringWithFormat:@"%i.texps",index]];
	if(([DFM fileExistsAtPath:source] || [DFM pathContentOfSymbolicLinkAtPath:source])
		&& [DFM removeFileAtPath:source handler:self])
	{
		++index;
		goto next;
	}
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:@"baseNamesOfAncestorsForBaseProjectName"];
	// update the base projects
	E = [BASE_PROJECTS keyEnumerator];
	while(P = [E nextObject])
	{
		K = [[P lastPathComponent] stringByDeletingPathExtension];
		if(!(MRA = [BASE_URLs objectForKey:K]) || ![MRA containsObject:P])
		{
			// this project has been removed
			[[[BASE_PROJECTS objectForKey:P] retain] autorelease];
			[BASE_PROJECTS removeObjectForKey:P];

		}
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyBaseNamesOfAncestorsForBaseProjectName:
- (NSArray *)lazyBaseNamesOfAncestorsForBaseProjectName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self baseProjectNames] containsObject:name])
	{
		return [NSArray arrayWithObject:name];
	}
//iTM2_END;
	return [NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseNamesOfAncestorsForBaseProjectName:
- (NSArray *)baseNamesOfAncestorsForBaseProjectName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([name isEqualToString:iTM2ProjectDefaultName])
	{
		return [NSArray array];
	}
	NSMutableDictionary * MD = [IMPLEMENTATION metaValueForKey:@"baseNamesOfAncestorsForBaseProjectName"];
	if(!MD)
	{
		[self updateBaseProjectsNotified:nil];
		MD = [IMPLEMENTATION metaValueForKey:@"baseNamesOfAncestorsForBaseProjectName"];
	}
iTM2_LOG(@"MD is:%@",MD);
//iTM2_END;
	id result = [MD objectForKey:name];
	if(result)
		return result;
	// now is time to cache
	if(result = [self lazyBaseNamesOfAncestorsForBaseProjectName:name])
	{
iTM2_LOG(@"result is:%@",result);
iTM2_LOG(@"MD is:%@",MD);
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
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [BASE_PROJECTS objectEnumerator];
	id O;
	while(O = [E nextObject])
		if(O == argument)// no message ever sent to argument, maybe argument is not an object, or has been freed!
			return YES;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isElementaryProject:
- (BOOL)isElementaryProject:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self isProject:argument] && [argument isElementary];
}
#pragma mark =-=-=-=-=-  CURRENT PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentProject
- (id)currentProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [metaGETTER nonretainedObjectValue];// beware, old can point to nothing consistent
	id result = [[SDC currentDocument] project];
	if(result != old)
	{
		metaSETTER([NSValue valueWithNonretainedObject:result]);// reentrant
		[INC performSelector:@selector(postNotification:) withObject:
			[NSNotification notificationWithName:iTM2ProjectCurrentDidChangeNotification
				object:self userInfo:([self isProject:old]? [NSDictionary dictionaryWithObjectsAndKeys:old,@"oldProject",nil]:nil)]
			afterDelay:0];// notice the isProject:that ensures old is consistent
		NSEnumerator * E = [[self projects] objectEnumerator];
		id projectDocument;
		while(nil != (projectDocument = [E nextObject]))
		{
			if(projectDocument == result)
			{
				[projectDocument exposeWindows];
				while(projectDocument = [E nextObject])
					[projectDocument dissimulateWindows];
			}
			else
			{
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
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self currentProject];
//iTM2_END;
    return;
}
@end

#undef PROJECTS
#undef BASE_PROJECTS
#undef BASE_URLs

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
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled || ![SUD boolForKey:iTM2DontShowNoProjectNote])
	{
		iTM2NoProjectSheetController * WC = [[[self alloc] initWithWindowNibName:@"iTM2NoProjectSheetController"] autorelease];// WARNING will be autoreleased in the did endselector
		NSWindow * W = [WC window];
		if(!W)
		{
			iTM2_LOG(@"WARNING:Missing a  an iTM2NoProjectSheetController window.");
		}
		else
		{
			[NSApp beginSheet:W modalForWindow:window modalDelegate:nil didEndSelector:NULL contextInfo:nil];
			[WC iTM2_validateWindowContent];
//iTM2_LOG(@"sheet is here and validated");
			int returnCode = [NSApp runModalForWindow:W];
			[NSApp endSheet:W];
			[W orderOut:self];
			if(returnCode == 1)
				return YES;
		}
		return NO;
	}
	else
		return YES;
//iTM2_END;
}
- (IBAction)accept:(id)sender;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSApp stopModalWithCode:1];
//iTM2_END;
	return;
}
- (IBAction)refuse:(id)sender;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSApp stopModalWithCode:0];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDontShowAgain:
- (IBAction)toggleDontShowAgain:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG(@"%@ is %@",[SUD objectForKey:iTM2DontShowNoProjectNote],([SUD boolForKey:iTM2DontShowNoProjectNote]? @"Y":@"N"));
	BOOL oldFlag = [SUD boolForKey:iTM2DontShowNoProjectNote];
	[SUD setObject:[NSNumber numberWithBool:!oldFlag] forKey:iTM2DontShowNoProjectNote];
	[sender iTM2_validateWindowContent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDontShowAgain:
- (BOOL)validateToggleDontShowAgain:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG(@"%@ is %@",[SUD objectForKey:iTM2DontShowNoProjectNote],([SUD boolForKey:iTM2DontShowNoProjectNote]? @"Y":@"N"));
	[sender setState:([SUD boolForKey:iTM2DontShowNoProjectNote]? NSOnState:NSOffState)];
	return YES;
}
@end

@implementation iTM2NewProjectController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_Projects autorelease];
	_Projects = nil;
	[_NewProjectName autorelease];
	_NewProjectName = nil;
	[_FileName autorelease];
	_FileName = nil;
	[_ProjectDirName autorelease];
	_ProjectDirName = nil;
	[super dealloc];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpProject:
- (void)setUpProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileName:
- (void)setFileName:(NSString *)fileName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_FileName autorelease];
	_FileName = [fileName copy];
	fileName = [fileName stringByDeletingLastPathComponent];
	[_ProjectDirName autorelease];
	_ProjectDirName = [fileName copy];
	_IsAlreadyDirectoryWrapper = NO;
loop:
	if([[fileName pathExtension] pathIsEqual:[SDC wrapperPathExtension]])
	{
		_IsAlreadyDirectoryWrapper = YES;
		[_ProjectDirName autorelease];
		_ProjectDirName = [fileName copy];
		_ToggleProjectMode = iTM2ToggleNewProjectMode;
		return;
	}
	else if([fileName length] > 4)
	{
		fileName = [fileName stringByDeletingLastPathComponent];
		goto loop;
	}
	// not a .texd descendant
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectURL
- (NSURL *)projectURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [NSURL fileURLWithPath:[self projectName]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectName
- (NSString *)projectName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_ToggleProjectMode == iTM2ToggleNewProjectMode)
		return [[self projectDirName] stringByAppendingPathComponent:_NewProjectName];
	else if(_ToggleProjectMode == iTM2ToggleOldProjectMode)
		return _SelectedRow >= 0 && _SelectedRow < [_Projects count] ?
			[[_Projects objectAtIndex:_SelectedRow] objectForKey:@"path"]:@"";
	else
		return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDirName
- (NSString *)projectDirName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_IsAlreadyDirectoryWrapper)
		return _ProjectDirName;
	if(_IsDirectoryWrapper && (_ToggleProjectMode != iTM2ToggleOldProjectMode))
	{
		NSString * component = [_ProjectDirName stringByAppendingPathComponent:[[_FileName lastPathComponent] stringByDeletingPathExtension]];
		if([component length])
			return [component stringByAppendingPathExtension:[SDC wrapperPathExtension]];
		else
		{
			iTM2_LOG(@"Weird _ProjectDirName");
			return @"";
		}
	}
//iTM2_LOG(@"projectDirName is:%@",result);
	return _ProjectDirName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void)windowWillLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	//Preparing the projects for the table view
	_SelectedRow = 0;
	[_Projects autorelease];
	NSString * dirName = [_FileName stringByDeletingLastPathComponent];
	_Projects = [[NSMutableArray array] retain];
	NSDictionary * availableProjects = [SPC availableProjectsForPath:dirName];
	NSEnumerator * E = [[[availableProjects allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		[_Projects addObject:[NSDictionary dictionaryWithObjectsAndKeys:
			path,@"path",
			[availableProjects objectForKey:path],@"displayName",
			nil]];
	}
//iTM2_LOG(@"_Projects:%@",_Projects);
	_ToggleProjectMode = [_Projects count]>0? iTM2ToggleOldProjectMode:iTM2ToggleNewProjectMode;
	_IsDirectoryWrapper = ([_Projects count]>0)|| [SUD boolForKey:iTM2ProjectIsDirectoryWrapperKey];
    [super windowWillLoad];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowDidLoad];
	[self iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (void)OK:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing for some consistency if we have to create folders at least:
	if(iTM2DebugEnabled && (_ToggleProjectMode == iTM2ToggleNewProjectMode))
	{
		NSString * name = [_NewProjectName stringByStandardizingPath];
		NSString * absolutePath = [name hasPrefix:iTM2PathComponentsSeparator]? name:
					[[[self projectDirName] stringByAppendingPathComponent:name] stringByStandardizingPath];
		if([DFM fileExistsAtPath:absolutePath] || [DFM pathContentOfSymbolicLinkAtPath:absolutePath])
		{
			goto more;
		}

		NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Create Project Panel",iTM2ProjectTable,myBUNDLE,""),
				nil,// localized OK
				nil,
				NSLocalizedStringFromTableInBundle(@"Cancel",iTM2ProjectTable,myBUNDLE,""),
				[sender window],
				self,
				NULL,
				@selector(createProjectSheetDidDismiss:returnCode:irrelevant:),
				nil,
				NSLocalizedStringFromTableInBundle(@"Create project:\n%@?",iTM2ProjectTable,myBUNDLE,""),
				absolutePath);
		return;
	}
	more:
	if(_ToggleProjectMode == iTM2ToggleNewProjectMode)
	{
		[SUD setObject:[NSNumber numberWithBool:_IsDirectoryWrapper] forKey:iTM2ProjectIsDirectoryWrapperKey];
	}
	[NSApp stopModalWithCode:_ToggleProjectMode];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createProjectSheetDidDismiss:returnCode:irrelevant:
- (void)createProjectSheetDidDismiss:(NSWindow *)sheet returnCode:(int)returnCode irrelevant:(void *)irrelevant;
/*"Description forthcoming. Only in DEBUG mode. See method above.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(returnCode == NSAlertDefaultReturn)
	{
		if(_ToggleProjectMode == iTM2ToggleNewProjectMode)
		{
			[SUD setObject:[NSNumber numberWithBool:_IsDirectoryWrapper] forKey:iTM2ProjectIsDirectoryWrapperKey];
		}
		[NSApp stopModalWithCode:_ToggleProjectMode];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  noProject:
- (IBAction)noProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([iTM2NoProjectSheetController alertForWindow:[sender window]])
		[NSApp stopModalWithCode:iTM2ToggleNoProjectMode];
//iTM2_END;
	return ;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNoProject:
- (BOOL)validateNoProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return !_IsAlreadyDirectoryWrapper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileNameEdited:
- (IBAction)fileNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFileNameEdited:
- (BOOL)validateFileNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setStringValue:([(NSString *)_FileName length]? [_FileName lastPathComponent]:@"None")];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dirNameEdited:
- (IBAction)dirNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDirNameEdited:
- (BOOL)validateDirNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([(NSString *)_FileName length]> 0)
		[sender setStringValue:[self projectDirName]];
	else
		[sender setStringValue:@"..."];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNewProject:
- (IBAction)toggleNewProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_ToggleProjectMode = iTM2ToggleNewProjectMode;
	[sender iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNewProject:
- (BOOL)validateToggleNewProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:(_ToggleProjectMode == iTM2ToggleNewProjectMode? NSOnState:NSOffState)];
//iTM2_END;
	return !_IsAlreadyDirectoryWrapper && ([_Projects count]>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDirectoryWrapper:
- (IBAction)toggleDirectoryWrapper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_IsDirectoryWrapper = !_IsDirectoryWrapper;
	[sender iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDirectoryWrapper:
- (BOOL)validateToggleDirectoryWrapper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_IsAlreadyDirectoryWrapper)
	{
		[sender setState:NSOffState];
		return NO;
	}
	else
	{
		[sender setState:(_IsDirectoryWrapper? NSOnState:NSOffState)];
		return _ToggleProjectMode == iTM2ToggleNewProjectMode;
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectNameEdited:
- (IBAction)newProjectNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * senderString = [[sender stringValue] stringByDeletingPathExtension];
	if([senderString length])
	{
		NSString * new = [senderString stringByAppendingPathExtension:[SDC projectPathExtension]];
		if(![new pathIsEqual:_NewProjectName])
		{
			[_NewProjectName autorelease];
			_NewProjectName = [new copy];
			[sender iTM2_validateWindowContent];
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNewProjectNameEdited:
- (BOOL)validateNewProjectNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![(NSString *)_NewProjectName length])
	{
		[_NewProjectName autorelease];
		if(_IsAlreadyDirectoryWrapper)
			_NewProjectName = iTM2ProjectTable;
		else
		{
			NSString * name = [[_FileName lastPathComponent] stringByDeletingPathExtension];
			if([name length])
			{
				_NewProjectName = [[name stringByAppendingPathExtension:[SDC projectPathExtension]] retain];
			}
			else
			{
				iTM2_LOG(@"Weird? void _FileName");
				_NewProjectName = @"";
			}
		}
	}
	[sender setStringValue:[_NewProjectName stringByDeletingPathExtension]];
	if(_ToggleProjectMode == iTM2ToggleNewProjectMode)
	{
		[sender setEnabled:YES];
		if(![[[sender window] firstResponder] isEqual:sender])
		{
			[[sender window] makeFirstResponder:sender];
			[sender selectText:self];
		}
        return YES;
	}
	else
		return NO;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOldProject:
- (IBAction)toggleOldProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_ToggleProjectMode = iTM2ToggleOldProjectMode;
	[sender iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOldProject:
- (BOOL)validateToggleOldProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([_Projects count])
	{
		[sender setState:(_ToggleProjectMode == iTM2ToggleOldProjectMode? NSOnState:NSOffState)];
		return !_IsAlreadyDirectoryWrapper;
	}
	else
	{
		[sender setState:NSOffState];
		[sender setAction:NULL];
		return NO;
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjects
- (id)availableProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAvailableProjects:
- (void)setAvailableProjects:(id) argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  ALREADY EXISTING PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewAction:
- (IBAction)tableViewAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender numberOfRows])
	{
		_ToggleProjectMode = iTM2ToggleOldProjectMode;
		int new  = [sender selectedRow];
		if(new != _SelectedRow)
			_SelectedRow = new;
	}
	else
	{
		[[sender window] makeFirstResponder:[sender superview]];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTableViewAction:
- (BOOL)validateTableViewAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_SelectedRow<0)
		_SelectedRow = 0;
	if(_SelectedRow < [_Projects count])
	{
		[sender deselectAll:self];
		[sender selectRow:_SelectedRow byExtendingSelection:NO];
		return YES;
	}
	else
	{
		[sender setAction:NULL];
		return NO;
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [_Projects count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;

//iTM2_END;
	if(row<0)
		return nil;
	else if(row<[_Projects count])
	{
		return [[_Projects objectAtIndex:row] objectForKey:@"displayName"];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSApp stopModalWithCode:(_IsAlreadyDirectoryWrapper? iTM2ToggleNewProjectMode:iTM2ToggleStandaloneMode)];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCreateNewProject
- (BOOL)canCreateNewProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canInsertInProject
- (BOOL)canInsertInProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [_Projects count]>0;
}
@end

@implementation NSWorkspace(iTM2ProjectControllerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isProjectPackageAtPath:
- (BOOL)isProjectPackageAtPath:(NSString *)fullPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fullPath length])
		return NO;
	if([self isFilePackageAtPath:fullPath])// crash 
	{
		NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
		NSInvocation * I = [[NSInvocation invocationWithMethodSignature:sig0] retain];
		[I setTarget:self];
		[I setArgument:&fullPath atIndex:2];
		NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"ProjectPackageAtPath:" signature:sig0 inherited:YES] objectEnumerator];
		SEL selector;
		while(selector = (SEL)[[E nextObject] pointerValue])
		{
			if(selector != _cmd)
			{
				[I setSelector:selector];
				[I invoke];
				BOOL R = NO;
				[I getReturnValue:&R];
				if(R)
				{
					[I release];
					return YES;
				}
			}
		}
		[I release];
		return [[fullPath pathExtension] pathIsEqual:iTM2ProjectPathExtension];
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isWrapperPackageAtPath:
- (BOOL)isWrapperPackageAtPath:(NSString *)fullPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if((nil != fullPath) && [self isFilePackageAtPath:fullPath])
	{
		NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
		NSInvocation * I = [[NSInvocation invocationWithMethodSignature:sig0] retain];
		[I setTarget:self];
		[I setArgument:&fullPath atIndex:2];
		NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"WrapperPackageAtPath:" signature:sig0 inherited:YES] objectEnumerator];
		SEL selector;
		while(selector = (SEL)[[E nextObject] pointerValue])
		{
			if(selector != _cmd)
			{
				[I setSelector:selector];
				[I invoke];
				BOOL R = NO;
				[I getReturnValue:&R];
				if(R)
				{
					[I release];
					return YES;
				}
			}
		}
		[I release];
		return [[fullPath pathExtension] pathIsEqual:iTM2WrapperPathExtension];
	}
//iTM2_END;
    return NO;
}
@end

@implementation NSArray(iTM2ProjectControllerKit)
- (NSArray *)arrayWithCommonFirstObjectsOfArray:(NSArray *)array;
{
	NSEnumerator * E1 = [self objectEnumerator];
	id O1 = nil;
	NSEnumerator * E2 = [array objectEnumerator];
	id O2 = nil;
	NSMutableArray * result = [NSMutableArray array];
	while((O1=[E1 nextObject])&&(O2=[E2 nextObject])&&[O1 isEqual:O2])
	{
		[result addObject:O1];
	}
	return result;
}
@end

NSString * const iTM2ProjectBaseComponent = @"Base Projects.localized";

@implementation NSBundle(iTM2Project)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  temporaryBaseProjectsDirectory:
+ (NSString *)temporaryBaseProjectsDirectory;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * path = nil;
	if(!path)
	{
		path = [self temporaryDirectory];
		path = [path stringByAppendingPathComponent:iTM2ProjectBaseComponent];
		NSError * localError = nil;
		if([DFM createDeepDirectoryAtPath:path attributes:nil error:&localError])
		{
			[path retain];
		}
		else
		{
			if(localError)
			{
				iTM2_REPORTERROR(125,(@"FAILURE: no temporary repository for base projects, do you have write access somewhere?"),localError);
			}
			path = NSTemporaryDirectory();
			path = [path stringByAppendingPathComponent:iTM2ProjectBaseComponent];
			localError = nil;
			if([DFM createDeepDirectoryAtPath:path attributes:nil error:&localError])
			{
				[path retain];
			}
			else
			{
				if(localError)
				{
					iTM2_REPORTERROR(125,(@"FAILURE: no temporary repository for base projects, do you have write access somewhere?"),localError);
				}
				path = NSTemporaryDirectory();
			}
		}
	}
//iTM2_END;
	return path;
}
@end

#import <iTM2Foundation/iTM2DocumentKit.h>

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

@implementation iTM2PDocumentController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= noteNewRecentDocumentURL:
- (void)noteNewRecentDocumentURL:(NSURL *)absoluteURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([absoluteURL isFileURL])
	{
		NSURL * enclosingURL = [absoluteURL enclosingProjectURL];
		if(enclosingURL && ![[absoluteURL absoluteURL] isEqual:[enclosingURL absoluteURL]])
		{
			[super noteNewRecentDocumentURL:enclosingURL];// we replace the file by its enclosing project
			return;
		}
		NSString * path = [absoluteURL path];
		if([SWS isWrapperPackageAtPath:path] && [absoluteURL belongsToCachedProjectsDirectory])
		{
			return;
		}
		if(enclosingURL = [absoluteURL enclosingWrapperURL])
		{
			NSArray * enclosed = [enclosingURL enclosedProjectURLs];
			if([enclosed count] == 1)
			{
				absoluteURL = [enclosed lastObject];
			}
			else if([SWS isProjectPackageAtPath:path])
			{
				// there are many different projects inside the wrapper but we are asked for one in particular
			}
			else
			{
				// there are many project inside the wrapper,which one should I use?
				iTM2ProjectDocument * PD = [SPC projectForURL:absoluteURL];
				if(PD)
				{
					// due to the previous test,absoluteURL and the project file URL must be different
					// no infinite loop
					if([[PD fileURL] belongsToCachedProjectsDirectory])
					{
						[super noteNewRecentDocumentURL:absoluteURL];// inherited behaviour
						return;
					}
					else
					{
						[super noteNewRecentDocumentURL:[PD fileURL]];// we replace the file by its project
						return;
					}
				}
			}
		}
	}
	[super noteNewRecentDocumentURL:absoluteURL];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addDocument:
- (void)addDocument:(NSDocument *)document;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"document:%@",document);
	}
    [super addDocument:document];
	[SPC registerProject:document];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeDocument:
- (void)removeDocument:(NSDocument *)document;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// concistency check here
	if([[self documents] containsObject:document])
	{
		// the document is owned by the document controller
		// it should not be owned by a project,
		id projectDocument = [document project];
		if(![projectDocument isEqual:document])
			[projectDocument removeSubdocument:document];
	}
	else
	{
		// the document is owned by the project
		// It is removed from the list of open project documents,
		id projectDocument = [document project];
		if(![projectDocument isEqual:document])
			[projectDocument closeSubdocument:document];
	}
    [super removeDocument:document];
//	[SPC forgetProject:document];// too early
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareOpenDocumentWithContentsOfURL:
- (void)prepareOpenDocumentWithContentsOfURL:(NSURL *)absoluteURL;
/*"This one is responsible of the management of the project,including the wrapper.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{// I only catch file URLs
		return;
	}
	// I do not know exactly what I should do here
    id projectDocument = [SPC projectForURL:absoluteURL];
	if(projectDocument)
    {
//iTM2_LOG(@"1");
		return;
    }
	NSMutableArray * MRA = [[[SUD stringArrayForKey:@"_iTM2DocumentFileURLsOpenedFromFinder"] mutableCopy] autorelease];
	if(!MRA)
	{
		MRA = [NSMutableArray array];
	}
	NSString * fileName = [absoluteURL path];// not a link!
	fileName = [fileName stringByStandardizingPath];// not a link!
	if(![MRA containsObject:fileName])
	{
		[MRA addObject:fileName];
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:MRA forKey:@"_iTM2DocumentFileURLsOpenedFromFinder"]];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openDocumentWithContentsOfURL:display:error:
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"This one is responsible of the management of the project,including the wrapper.
Version history: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{// I only catch file URLs
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
	}
	if(outErrorPtr)
	{
		*outErrorPtr = nil;
	}
	NSString * fileName = nil;
	// documents are either
	// - formerly cached projects for standalone documents, to be replaced by the normal stuff, if possible, build number < 690
	// - already open
	// - wrappers
	// - projects
	// - directories that once were wrappers
	// - directories that once were projects
	// - other
	// 0 - is it a cached project or wrapper URL?
	NSURL * url = nil;
	if([absoluteURL belongsToCachedProjectsDirectory])
	{
		url = [absoluteURL URLByRemovingCachedProjectComponent];
		if([DFM fileExistsAtPath:[url path]])
		{
			absoluteURL = url;// we avoid opening directly a project in the Library...
			url = nil;
		}
		else
		{
			// conversion for standalone documents
			fileName = [[url path] stringByDeletingLastPathComponent];
			if([DFM isWritableFileAtPath:fileName] && ![DFM movePath:[absoluteURL path] toPath:[url path] handler:NULL])
			{
				iTM2_OUTERROR(2,([NSString stringWithFormat:@"Could not move\n%@\nto\n%@",absoluteURL,url]),nil);
				return nil;
			}
		}
	}
	id D;
	// A - is it an already open document?
	if(D = [self documentForURL:absoluteURL])
	{
#warning There was a problem: there is a document but it cannot be opened
		id D1 = [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
		if(D1)
		{
			D = D1;
			// return D;?
		}
		if(display)
		{
			[D makeWindowControllers];
			[D showWindows];
		}
		return D;
	}
	else if(iTM2DebugEnabled>0)
	{
		iTM2_LOG(@"No document for %@",absoluteURL);
		iTM2_LOG(@"[self documents] %@",[self documents]);
		NSEnumerator * E = [[self documents] objectEnumerator];
		id D;
		while(D = [E nextObject])
		{
			iTM2_LOG(@"[D fileName] %@",[D fileName]);
			iTM2_LOG(@"[D fileURL] %@",[D fileURL]);
		}
	}
	// there is no already open document for the given URL
	fileName = [[absoluteURL path] stringByStandardizingPath];// not a link!
	if([fileName length]==0)
	{
		// We were asked for a link pointing to something missing
		// break
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
	}
	// is it associated to an already registered project?
	// if the file was trashed, recover it
	NSArray * components = [fileName pathComponents];
	if([components containsObject:@".Trash"] || [components containsObject:@".Trashes"])
	{
		if([DFM fileExistsAtPath:fileName])
		{
			iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Please, get %@ back from the trash before opening it.",[fileName lastPathComponent]]),nil);
			[SWS selectFile:fileName inFileViewerRootedAtPath:[fileName stringByDeletingLastPathComponent]];
		}
		return nil;
	}
	// if the file is in an invisible folder, recover it
	NSEnumerator * E = [components objectEnumerator];
	NSString * component;
	while(component = [E nextObject])
	{
		if([component hasPrefix:@"."])
		{
			iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Please, copy %@ to a visible location of the Finder before opening it.",[fileName lastPathComponent]]),nil);
			[SWS selectFile:fileName inFileViewerRootedAtPath:[fileName stringByDeletingLastPathComponent]];
			return nil;
		}
	}
	// There was no already existing documents
	BOOL isDirectory = NO;
	if(![DFM fileExistsAtPath:fileName isDirectory:&isDirectory])
	{
		iTM2_OUTERROR(2,([NSString stringWithFormat:@"Missing file at\n%@",absoluteURL]),nil);
		return nil;
	}
//iTM2_LOG(@"0");
	// B - is it a wrapper document?
	if([SWS isWrapperPackageAtPath:fileName])
	{
		NSURL * projectURL = [SPC getProjectURLInWrapperForURLRef:&absoluteURL error:outErrorPtr];
		if(nil != projectURL)
		{
			NSAssert1(![[projectURL absoluteURL] isEqual:[absoluteURL absoluteURL]],@"What is this project URL:<%@>",projectURL);
			return [self openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr];// second registerProject
		}
		else
		{
			[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
				userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project inside\n%@\ndocument will open with a simple project...",fileName]
					forKey:NSLocalizedDescriptionKey]]];
			NSAssert(NO,@"Not yet implemented");
			return nil;
		}
	}
	// C - is it a project document?
	else if([SWS isProjectPackageAtPath:fileName])
	{
#warning WE DO NOT MANAGE read access yet?
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];//first registerProject, second registerProject
	}
	// D - is it a former package that lost its path extension?
	else if(isDirectory)
	{
		// Is it a folder corresponding to a former wrapper or project which name was changed by the user?
		// This is possible because the app keeps tracks of the wrappers it opens through some indirect address.
		// trying to open a project document at the first level if any
		id subpaths = [fileName enclosedProjectFileNames];
		NSString * subpath;
		if([subpaths count] == 1)
		{
			subpath = [subpaths lastObject];
			subpath = [fileName stringByAppendingPathComponent:subpath];
			url = [NSURL fileURLWithPath:subpath];
			return [self openDocumentWithContentsOfURL:url display:display error:outErrorPtr];
		}
		else if([subpaths count] > 0)
		{
			subpath = [fileName stringByDeletingLastPathComponent];
			iTM2_OUTERROR(1,(@"Confusing situation:too many projects in that directory.\nSee what you can do from the Finder."),nil);
			[SWS selectFile:fileName inFileViewerRootedAtPath:subpath];
			return nil;
		}
		else
		{
			// it does not contain any project document
			// it may be itself a project wrapper!
			// is it still a project wrapper?
			if(url = [SPC mainInfoURLFromURL:absoluteURL create:NO error:outErrorPtr])
			{
				NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:url];
				if([[dict objectForKey:@"isa"] isEqualToString:iTM2ProjectInfoType])
				{
					// yes this is a former project.
					// Can I add such a file extension by myself?
					// yes, unless it is not possible to move the project
					NSString * destination = [fileName stringByAppendingPathExtension:[SDC projectPathExtension]];
					if([DFM fileExistsAtPath:destination] ||
						![DFM movePath:fileName toPath:destination handler:NULL])
					{
						iTM2_OUTERROR(2,([NSString stringWithFormat:@"Confusing situation:the following directory seems to be a project despite it has no %@ path extension:\n%@\nOne cannot be added.",
									fileName,[SDC projectPathExtension]]),nil);
						return nil;
					}
					url = [NSURL fileURLWithPath:destination];
					return [self openDocumentWithContentsOfURL:url display:display error:outErrorPtr];
				}
				else if(dict)
				{
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"Something weird occurred to that forlder\n%@.",fileName]),nil);
					[SWS selectFile:fileName inFileViewerRootedAtPath:subpath];
					return nil;
				}
				else
				{
					NSString * pattern = [fileName lastPathComponent];
					pattern = [NSString stringWithFormat:@".*%@.*",pattern];
					NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@",pattern];
					subpaths = [DFM directoryContentsAtPath:fileName];
					subpaths = [subpaths filteredArrayUsingPredicate:predicate];
					if([subpaths count])
					{
						NSString * subpath = [fileName stringByAppendingPathComponent:[subpaths lastObject]];
						return [self openDocumentWithContentsOfURL:[NSURL fileURLWithPath:subpath] display:display error:outErrorPtr];
					}
				}
			}
			else
			{
				return nil;
			}
		}
	}
	// Now we assume that fileURL does not point to a project nor wrapper.
    id projectDocument = nil;
	if((projectDocument = [SPC projectForURL:absoluteURL])
		|| (projectDocument = [SPC getProjectInWrapperForURLRef:&absoluteURL display:display error:outErrorPtr])// fileURL belongs to a wrapper
		|| (projectDocument = [SPC getProjectInHierarchyForURL:absoluteURL display:display error:outErrorPtr])// fileURL belongs to a project 
		|| (projectDocument = [SPC getCachedProjectInWrapperForURLRef:&absoluteURL display:display error:outErrorPtr])// fileURL belongs to a cached wrapper
		|| (projectDocument = [SPC getCachedProjectInHierarchyForURL:absoluteURL display:display error:outErrorPtr])// fileURL belongs to a cached project 
		|| [SPC getUnregisteredProject:&projectDocument fileKey:nil forURL:absoluteURL display:display error:outErrorPtr])
    {
//iTM2_LOG(@"1");
		return [projectDocument openSubdocumentWithContentsOfURL:absoluteURL context:nil display:display error:outErrorPtr];
    }
	//I needed to know if the document did not want a project,
#warning NYI:MISSING WORK HERE
	// Do I have to create a project,opening another file?
	url = [[absoluteURL copy] autorelease];
	// What about documents in read only folders?
	projectDocument = [SPC newProjectForURLRef:&url display:display error:outErrorPtr];
    if(nil != projectDocument)
    {
		return [projectDocument openSubdocumentWithContentsOfURL:url context:nil display:display error:outErrorPtr];
    }
    return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outErrorPtr];
 }
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentForURL:
- (id)documentForURL:(NSURL *)absoluteURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
SPC metaInfoURLFromFileURL
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [super documentForURL:absoluteURL];
    if(nil != result)
	{
        return [[result retain] autorelease];
	}
	if([absoluteURL isFileURL])
	{
		return [[SPC projectForURL:absoluteURL] subdocumentForURL:absoluteURL];
	}
	return nil;
}
@end
