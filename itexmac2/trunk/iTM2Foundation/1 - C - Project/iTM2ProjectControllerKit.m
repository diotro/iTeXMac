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
#import <iTM2Foundation/iTM2Invocation.h>

NSString * const iTM2ProjectComponent = @"Project";
NSString * const iTM2ProjectPlistPathExtension = @"plist";
NSString * const iTM2ProjectDefaultName = @"Default";
NSString * const TWSFactoryExtension = @"iTM2-Factory";

NSString * const iTM2ProjectContextDidChangeNotification = @"iTM2ProjectContextDidChange";
NSString * const iTM2ProjectCurrentDidChangeNotification = @"iTM2CurrentProjectDidChange";

@interface NSArray(iTM2ProjectControllerKit)
- (NSArray *)arrayWithCommonFirstObjectsOfArray:(NSArray *)array;
@end

static NSString * const iTM2ProjectsKey = @"_PPs";
#define PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsKey]
static NSString * const iTM2ProjectsForURLsKey = @"_PCPs";
#define CACHED_PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsForURLsKey]
static NSString * const iTM2ProjectsReentrantKey = @"_PCPRE";
#define REENTRANT_PROJECT [[self implementation] metaValueForKey:iTM2ProjectsReentrantKey]

@interface iTM2ProjectController(CreateNewProject)
- (id)getOpenProjectForURL:(NSURL *)fileURL;
- (id)getBaseProjectForURL:(NSURL *)fileURL;
- (id)getProjectInWrapperForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)geWritableProjectInWrapperForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
- (id)getProjectInHierarchyForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
- (Class)newProjectPanelControllerClass;
@end

@interface iTM2NewProjectController: iTM2Inspector
{
@private
	id _FileURL;
	id _NewProjectName;
	id _ProjectDirURL;
	id _Projects;
	int _SelectedRow;
	int _ToggleProjectMode;
	BOOL _IsAlreadyDirectoryWrapper;
	BOOL _IsDirectoryWrapper;// should be replaced by the SUD
}
- (NSURL *)projectURL;
- (void)setFileURL:(NSURL *)fileURL;
- (NSURL *)projectDirURL;
- (void)setUpProject:(id)projectDocument;

@property (retain) id _FileURL;
@property (retain) id _NewProjectName;
@property (retain) id _ProjectDirURL;
@property (retain) id _Projects;
@property int _SelectedRow;
@property int _ToggleProjectMode;
@property BOOL _IsAlreadyDirectoryWrapper;
@property BOOL _IsDirectoryWrapper;
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
	[iTM2MileStone registerMileStone:@"Project Migration Missing" forKey:@"iTM2 Project Migrator"];
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
	// to ~me/Library/Application\ Support/iTeXMac2/Writable Projects.localized
	// Do I need to migrate ?
	NSString * oldSupport = [[NSBundle mainBundle] iTM2_pathForSupportDirectory:@"Projects.put_aside" inDomain:NSUserDomainMask create:NO];
	if(![DFM fileExistsAtPath:oldSupport])
	{
		return; // nothing to migrate
	}
	NSString * newSupport = [[NSBundle mainBundle] iTM2_pathForSupportDirectory:@"Writable Projects.localized" inDomain:NSUserDomainMask create:YES];
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT(SELF BEGINSWITH[c] '.')"];
	CFStringRef wrapperType = [SDC iTM2_wrapperDocumentType];
	for(NSString * path in [[DFM subpathsAtPath:oldSupport] filteredArrayUsingPredicate:predicate])
	{
		if(UTTypeEqual((CFStringRef)[SDC typeForContentsOfURL:[NSURL fileURLWithPath:path] error:NULL],wrapperType))
		{
			NSString * oldWrapper = [[oldSupport stringByAppendingPathComponent:path] stringByStandardizingPath];
			NSString * oldProject = [[[[NSURL fileURLWithPath:oldWrapper] iTM2_enclosedProjectURLs] lastObject] path];
			BOOL isDirectory = NO;
			if([DFM fileExistsAtPath:oldProject isDirectory:&isDirectory] && isDirectory)
			{
				NSURL * oldProjectURL = [NSURL fileURLWithPath:oldProject];
				NSEnumerator * EE = [[SPC fileKeysWithFilter:iTM2PCFilterRegular inProjectWithURL:oldProjectURL] objectEnumerator];
				NSString * fileKey = nil;
				while(fileKey = [EE nextObject])
				{
					[SPC URLForFileKey:fileKey filter:iTM2PCFilterRegular inProjectWithURL:[NSURL fileURLWithPath:oldProject]];// side effect: some kind of consistency test
				}
				NSString * newProject = [newSupport stringByAppendingPathComponent:[[path stringByDeletingLastPathComponent]
											stringByAppendingPathComponent:[oldProject lastPathComponent]]];
				NSDate * oldDate = [[DFM fileAttributesAtPath:oldProject traverseLink:NO] fileModificationDate];
				NSDate * newDate = [[DFM fileAttributesAtPath:newProject traverseLink:NO] fileModificationDate];
				if(nil == newDate)
				{
					[DFM iTM2_createDeepSymbolicLinkAtPath:newProject pathContent:oldProject];
				}
				else if([newDate compare:oldDate] == NSOrderedDescending)
				{
					// first delete the old stuff
#warning **** ERROR and FAILED, this is a transitional design BUGBUGBUG BUGBUGBUG BUGBUGBUG BUGBUGBUG
					if(YES && [DFM removeFileAtPath:newProject handler:NULL])
					{
						// just create a symbolic link to keep track of the old design during the transition
						[DFM iTM2_createDeepSymbolicLinkAtPath:newProject pathContent:oldProject];
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
	[iTM2MileStone putMileStoneForKey:@"iTM2 Project Migrator"];
//iTM2_END;
    return;
}
@end

#import <iTM2Foundation/iTM2FileManagerKit.h>

static NSString * const iTM2ProjectIsDirectoryWrapperKey = @"iTM2ProjectIsDirectoryWrapper";
NSString * const iTM2ProjectWritableProjectsComponent = @"Writable Projects.localized";

NSString * const iTM2ProjectCustomInfoComponent = @"CustomInfo";

static NSString * const iTM2ProjectsBaseKey = @"_PCPBs";
#define BASE_PROJECTS [IMPLEMENTATION metaValueForKey:iTM2ProjectsBaseKey]

@implementation iTM2ProjectController
static id _iTM2SharedProjectController = nil;
@dynamic currentProject;
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
			[DFM iTM2_createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherInfoURLFromURL:create:error:
- (NSURL *)otherInfoURLFromURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
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
			[DFM iTM2_createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
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
			[DFM iTM2_createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
		}
		NSString * component = [iTM2ProjectInfoMetaComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
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
			[DFM iTM2_createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr];
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
static NSArray * _iTM2PCReservedKeys = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reservedFileKey
- (NSArray *)reservedFileKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 16:33:40 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!_iTM2PCReservedKeys)
	{
		_iTM2PCReservedKeys = [[NSArray arrayWithObjects:
			TWSContentsKey,
			TWSFactoryKey,
			@".",
			TWSProjectKey,
			TWSTargetsKey,
			TWSToolsKey,
			iTM2FinderAliasesKey,
			iTM2SoftLinksKey,
			iTM2ProjectLastKeyKey,
			iTM2ProjectFrontDocumentKey,
				nil] retain];
	}
//iTM2_END;
	return _iTM2PCReservedKeys;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isReservedFileKey:
- (BOOL)isReservedFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 16:33:46 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self reservedFileKeys] containsObject:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForFileKey:filter:inProjectWithURL:
- (NSURL *)URLForFileKey:(NSString *)key filter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;
/*"Depending on the key.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 15:52:19 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == projectURL)
	{
		return nil;
	}
	id PD = nil;
	NSError * outError = nil;
	iTM2MainInfoWrapper * MIW = nil;
	NSURL * url = nil;
	if([key isEqual:@"."] || [key isEqual:TWSProjectKey])
	{
		if(filter == iTM2PCFilterRegular)
		{
			return projectURL;
		}
		key = TWSProjectKey;
	}
	else if([key isEqual:iTM2ParentKey])
	{
		if(filter == iTM2PCFilterRegular)
		{
			if(PD = [self projectForURL:projectURL])
			{
				if(url = [PD parentURL])
				{
					return url;
				}
			}
		}
		url = [self URLForFileKey:TWSProjectKey filter:filter inProjectWithURL:projectURL];
		return [[url iTM2_URLByRemovingFactoryBaseURL] iTM2_parentDirectoryURL];
	}
	else if([key isEqual:TWSContentsKey])
	{
		if(filter == iTM2PCFilterRegular)
		{
			if(PD = [self projectForURL:projectURL])
			{
				if(url = [PD contentsURL])
				{
					return url;
				}
				MIW = [PD mainInfos];
			}
			if(!MIW)
			{
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if(outError)
				{
					[NSApp presentError:outError];
					return [self URLForFileKey:iTM2ParentKey filter:filter inProjectWithURL:projectURL];
				}
			}
			return [MIW URLForFileKey:TWSContentsKey];
		}
//iTM2_END;
	}
	else if([key isEqual:TWSFactoryKey])
	{
		if(filter == iTM2PCFilterRegular)
		{
			if(PD = [self projectForURL:projectURL])
			{
				if(url = [PD factoryURL])
				{
					return url;
				}
				MIW = [PD mainInfos];
			}
			if(!MIW)
			{
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if(outError)
				{
					[NSApp presentError:outError];
					return [NSURL iTM2_URLWithPath:iTM2PathFactoryComponent relativeToURL:projectURL];
				}
			}
			return [MIW URLForFileKey:TWSFactoryKey];
		}
	}
	else if([self isReservedFileKey:key])
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
			base = [DFM iTM2_pathContentOfSoftLinkAtPath:base];
			if(!base) return nil;// the key was not known by the project
		//iTM2_END;
			return [NSURL fileURLWithPath:base];
		case iTM2PCFilterRelativeLink:
			base = [SPC relativeSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			base = [base stringByAppendingPathComponent:key];
			base = [DFM iTM2_pathContentOfSoftLinkAtPath:base];
			if(!base) return nil;// the key was not known by the project
		//iTM2_END;
			return [NSURL fileURLWithPath:base];
		case iTM2PCFilterAlias:
			base = [SPC finderAliasesSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			base = [base stringByAppendingPathComponent:key];
			projectURL = [NSURL fileURLWithPath:base];
			NSData * aliasData = [NSData iTM2_aliasDataWithContentsOfURL:projectURL error:nil];
		//iTM2_END;
			return [aliasData iTM2_URLByResolvingDataAliasRelativeToURL:nil error:nil];
		case iTM2PCFilterRegular:
		default:
			if(PD = [self projectForURL:projectURL])
			{
				MIW = [PD mainInfos];
			}
			if(!MIW)
			{
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if(outError)
				{
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if(nil == projectURL)
	{
		return nil;
	}
	NSString * projectName = [projectURL path];
	NSString * path = nil;
	NSArray * result = nil;
	switch(filter)
	{
		case iTM2PCFilterAbsoluteLink:
			path = [projectName stringByAppendingPathComponent:[SPC absoluteSoftLinksSubdirectory]];
ready_to_go:;
			NSPredicate * predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"SELF ENDSWITH[c] '.%@'",iTM2SoftLinkExtension]];
			result = [DFM directoryContentsAtPath:path];
			result = [result filteredArrayUsingPredicate:predicate];
			return [result valueForKey:@"stringByDeletingPathExtension"];
		case iTM2PCFilterRelativeLink:
			path = [projectName stringByAppendingPathComponent:[SPC relativeSoftLinksSubdirectory]];
			goto ready_to_go;
		case iTM2PCFilterAlias:
			path = [projectName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
			goto ready_to_go;
		case iTM2PCFilterRegular:
		default:
		{
			iTM2MainInfoWrapper * MIW = [[self projectForURL:projectURL] mainInfos];
			if(MIW == nil)
			{
				NSError * outError = nil;
				MIW = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:projectURL error:&outError] autorelease];
				if(outError)
				{
					[NSApp presentError:outError];
				}
			}
//iTM2_END;
			return [MIW fileKeys];
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
	NSParameterAssert(projectURL);
	if(nil == fileURL)// untitled documents will go there
	{
		return nil;
	}
	// Is it me? The factory? The contents? The parent?
	if([[self URLForFileKey:TWSProjectKey filter:filter inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])
	{
		return TWSProjectKey;
	}
	if([[self URLForFileKey:TWSFactoryKey filter:filter inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])
	{
		return TWSFactoryKey;
	}
	if([[self URLForFileKey:TWSContentsKey filter:filter inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])
	{
		return TWSContentsKey;
	}
	if([[self URLForFileKey:iTM2ParentKey filter:filter inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])
	{
		return iTM2ParentKey;
	}
	// Here begins the hardest work which is not so hard in the end
	NSEnumerator * E = [[self fileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	NSString * key;
	while(key = [E nextObject])
	{
		if([[self URLForFileKey:key filter:filter inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])
		{
			return key;
		}
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  normalizedURLWithURL:inProjectWithURL:
-(NSURL *)normalizedURLWithURL:(NSURL *)url inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 10:06:06 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(projectURL);
	// does it belong to the factory?
	NSURL * baseURL = [url baseURL];
	NSString * relativePath = [url relativePath];
	NSURL * U = [self URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if([baseURL isEqual:U] && ![relativePath hasPrefix:@".."])
	{
		return url;
	}
	// does it belong to the contents?
	U = [self URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if([baseURL isEqual:U] && ![relativePath hasPrefix:@".."])
	{
		return url;
	}
	// url was not normalized
	NSString * K = [self fileKeyForURL:url filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if(![K length]) return nil;
	U = [SPC URLForFileKey:K filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
//iTM2_END;
	return [U isEqual:url]?url:U;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForName:inProjectWithURL:
- (NSURL *)URLForName:(NSString *)name inProjectWithURL:(NSURL *)projectURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 22:25:07 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * url = [NSURL URLWithString:name];
	if([[url scheme] length])
	{
		return url;
	}
	url = [self URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
//iTM2_END;
	return [NSURL iTM2_URLWithPath:name relativeToURL:url];
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
	[IMPLEMENTATION takeMetaValue:
				[NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory|NSPointerFunctionsObjectPersonality valueOptions:NSMapTableZeroingWeakMemory|NSPointerFunctionsObjectPointerPersonality]
						   forKey:iTM2ProjectsForURLsKey];
//iTM2_END;
return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _availableProjectsForURL:
- (id)_availableProjectsForURL:(NSURL *)theURL;
/*"Description forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![theURL isFileURL])
	{
		return nil;
	}
	// first I get the projects file names including the other ones in the hierarchy above dirName
	// I scan the directories for projects,starting from the normal side then looking for library projects
	// it is the responsibility of the user interface controllers to make the difference between factory and regular
	// Supplemental rule: if the dirName is included in a wrapper,the projects are constrained to that wrapper and
	// projects outside will be ignored.
	// first test if there is an enclosing wrapper
	// recognizing the wrapper
	NSString * displayName = nil;
	NSString * path = nil;
	NSString * type = nil;
	NSURL * url = nil;
	if(url = [theURL iTM2_enclosingWrapperURL])
	{
		type = [SDC typeForContentsOfURL:url error:nil];
		if([SDC documentClassForType:type])
		{
			path = [url path];
			displayName = [[url path] lastPathComponent];
			NSDictionary * fileAttributes = [DFM fileAttributesAtPath:path traverseLink:NO];
			if([fileAttributes fileExtensionHidden])
			{
				displayName = [displayName stringByDeletingPathExtension];
			}
			return [NSDictionary dictionaryWithObject:displayName forKey:url];
		}
	}
	// there is no enclosing wrapper
	// find all the projects, either regular or in the factory
	// stop as soon as projects are found
	NSAssert1(![theURL iTM2_belongsToFactory], @"The path must not be in the factory domain:\n%@",theURL);
	NSString * factoryPath = nil;
	CFStringRef projectType = [SDC iTM2_projectDocumentType];
	if([SDC documentClassForType:(NSString *)projectType])
	{
		NSMutableArray * URLs = [NSMutableArray array];
		NSEnumerator * E = nil;
		NSString * content = nil;
		path = [theURL path];
		NSURL * theURLInTheFactory = [theURL iTM2_URLByPrependingFactoryBaseURL];
		do
		{
			E = [[DFM directoryContentsAtPath:path] objectEnumerator];
			while(content = [E nextObject])
			{
				url = [NSURL iTM2_URLWithPath:content relativeToURL:theURL];
				type = [SDC typeForContentsOfURL:url error:nil];
				if([SWS iTM2_isProjectPackageAtURL:url] && [SDC documentClassForType:type])
				{
					[URLs addObject:[url iTM2_normalizedURL]];
				}
			}
			factoryPath = [theURLInTheFactory path];
			E = [[DFM directoryContentsAtPath:factoryPath] objectEnumerator];
			while(content = [E nextObject])
			{
				url = [NSURL iTM2_URLWithPath:content relativeToURL:theURLInTheFactory];
				type = [SDC typeForContentsOfURL:url error:nil];
				if([SWS iTM2_isWrapperPackageAtURL:url] && [SDC documentClassForType:type])
				{
					[URLs addObject:[url iTM2_normalizedURL]];
				}
			}
		}
		while(([URLs count]==0) && (path = [path stringByDeletingLastPathComponent],([path length]>1)));
		// now adding the library projects if relevant
		[URLs sortedArrayUsingSelector:@selector(compare:)];
		NSMutableDictionary * first = [NSMutableDictionary dictionary];
		NSMutableDictionary * last  = [NSMutableDictionary dictionary];
		for(url in URLs)
		{
			[first setObject:[[url path] lastPathComponent] forKey:url];
			[last  setObject:[[url path] stringByDeletingLastPathComponent] forKey:url];
		}
		NSArray * allValues = nil;
		NSSet * set = nil;
more:
		allValues = [first allValues];
		set = [NSSet setWithArray:allValues];
		if([allValues count] != [set count])
		{
			for(displayName in set)
			{
				NSArray * ra = [first allKeysForObject:displayName];
				if([ra count]>1)
				{
					// there are more than one path with the same display name
					// we must make a difference between them
					NSEnumerator * e = [ra objectEnumerator];
					while(url = [e nextObject])
					{
						NSString * oldPath = [last objectForKey:url];
						NSString * oldDisplayName = [first objectForKey:url];
						NSString * newDisplayName = [oldPath lastPathComponent];
						newDisplayName = [newDisplayName stringByAppendingPathComponent:oldDisplayName];
						[first setObject:newDisplayName forKey:url];
						NSString * newPath = [newDisplayName stringByDeletingLastPathComponent];
						[last setObject:newPath forKey:url];
					}
				}
			}
			goto more;
		}
		E = [first keyEnumerator];
		while(url = [E nextObject])
		{
			displayName = [first objectForKey:url];
			NSString * dirName = [displayName stringByDeletingLastPathComponent];
			if([dirName length]>1)
			{
				displayName = [displayName lastPathComponent];
				NSDictionary * fileAttributes = [DFM fileAttributesAtPath:[url path] traverseLink:NO];
				if([fileAttributes fileExtensionHidden])
				{
					displayName = [displayName stringByDeletingPathExtension];
				}
				dirName = [[@"..." stringByAppendingPathComponent:dirName] stringByStandardizingPath];
				displayName = [NSString stringWithFormat:@"%@ (%@)",displayName,dirName];
				[first setObject:displayName forKey:url];
			}
		}
		return first;
	}
//iTM2_END;
	return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjectsForURL:
- (id)availableProjectsForURL:(NSURL *)url;
/*"Description forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [url isFileURL]?[self _availableProjectsForURL:url]:[NSDictionary dictionary];
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
		[IMPLEMENTATION takeMetaValue:
					[NSHashTable hashTableWithOptions:NSPointerFunctionsZeroingWeakMemory|NSPointerFunctionsObjectPointerPersonality]
							forKey:iTM2ProjectsKey];
	}
	if(![IMPLEMENTATION metaValueForKey:iTM2ProjectsForURLsKey])
	{
		[self flushCaches];
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
- 2.1: Sun May  4 21:24:56 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 1
    return PROJECTS;
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
	iTM2ProjectDocument * projectDocument;
	for(projectDocument in [SPC projects])
	{
		if([projectDocument ownsSubdocument:document])
		{
			[self setProject:projectDocument forDocument:document];
			return projectDocument;
		}
	}
    if(projectDocument = [CACHED_PROJECTS objectForKey:[fileURL absoluteURL]])
	{
		[self setProject:projectDocument forDocument:document];
		return projectDocument;
	}
	else
	{
		[self setProject:nil forDocument:document];
		return nil;
	}
	[document setHasProject:NO];
	// if this method is entered once more from here,it will return from one of the above lines,unless the CACHED_PROJECTS are cleaned
	NSURL * url = fileURL;
	if(projectDocument = [self freshProjectForURLRef:&url display:YES error:nil])
	{
		if([url isFileURL] && ![url iTM2_isEquivalentToURL:fileURL])
		{
			// ensure the containing directory exists
			[DFM iTM2_createDeepDirectoryAtPath:[[url path] stringByDeletingLastPathComponent] attributes:nil error:nil];
		}
		url = [url iTM2_normalizedURL];
		[document setFileURL:url];
		[projectDocument addSubdocument:document];
		[self setProject:projectDocument forDocument:document];
		return projectDocument;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!document)
		return;
	NSParameterAssert((!projectDocument || [SPC isProject:projectDocument]));
	[document setHasProject:(projectDocument != nil)];
	NSURL * fileURL = [document fileURL];
	[self setProject:projectDocument forURL:fileURL];
	NSAssert1((projectDocument == [self projectForDocument:document]),
		@"..........  INCONSISTENCY:unexpected behaviour,report bug 1313 in %@",__iTM2_PRETTY_FUNCTION__);
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
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	for(id projectDocument in [self projects])
	{
		if([[projectDocument fileKeyForURL:fileURL] length]
			|| [[projectDocument fileURL] iTM2_isEquivalentToURL:fileURL]
			|| [fileURL iTM2_isRelativeToURL:[projectDocument contentsURL]]
			|| [fileURL iTM2_isRelativeToURL:[projectDocument factoryURL]])
		{
			[projectDocument newFileKeyForURL:fileURL];
theEnd:
			[self setProject:projectDocument forURL:fileURL];
			if(iTM2DebugEnabled>10)
			{
				iTM2_LOG(@"\\infty - The project:%@ knows about %@",[projectDocument fileURL],fileURL);
			}
			return projectDocument;
		}
		else if([[projectDocument wrapperURL] iTM2_isEquivalentToURL:fileURL])
			goto theEnd;
		else if(iTM2DebugEnabled>10)
		{
			iTM2_LOG(@"The project:\n%@ does not know\n%@",[projectDocument fileURL],fileURL);
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForURL:
- (id)projectForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:34:25 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(fileURL);
	id projectDocument = [CACHED_PROJECTS objectForKey:[fileURL absoluteURL]];
	if([SPC isProject:projectDocument])
	{
		return projectDocument;
	}
	NSURL * shortFileURL = [fileURL iTM2_URLByDeletingPathExtension];
	projectDocument = [CACHED_PROJECTS objectForKey:[shortFileURL absoluteURL]];
	if([SPC isProject:projectDocument])
	{
		[CACHED_PROJECTS setObject:projectDocument forKey:[fileURL absoluteURL]];
		[projectDocument newFileKeyForURL:fileURL];
		return projectDocument;
	}
	// Not yet cached
	// reentrant management here
	if([projectDocument isEqual:[NSNull null]])
	{
		return nil;
	}
	[CACHED_PROJECTS setObject:[NSNull null] forKey:[fileURL absoluteURL]];
	return [self getOpenProjectForURL:fileURL];// Will cache the result as side effect
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:forURL:
- (void)setProject:(id)projectDocument forURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:34:40 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled>99999)
	{
		iTM2_LOG(@"fileURL:%@",fileURL);
	}
	NSParameterAssert(fileURL);
	NSParameterAssert((!projectDocument || [SPC isProject:projectDocument]));
	[CACHED_PROJECTS setObject:projectDocument forKey:[fileURL absoluteURL]];
	NSAssert1((projectDocument == [self projectForURL:fileURL]),
		@"..........  INCONSISTENCY:unexpected behaviour,report bug 3131 in %s",__iTM2_PRETTY_FUNCTION__);
	fileURL = [fileURL iTM2_URLByDeletingPathExtension];
	[CACHED_PROJECTS setObject:projectDocument forKey:[fileURL absoluteURL]];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForSource:
- (id)projectForSource:(id)source;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:34:46 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THERE MIGHT BE A REALLY BIG PROBLEM WHEN CREATING NEW DOCUMENTS:the filename is void!!! Use the autosave?
//NSLog(@"source:%@",source);
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
    else
        return [[SDC currentDocument] project];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerProject:
- (void)registerProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 21:24:00 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"project:%@",projectDocument);
		}
		// testing consistency
		// we are not authorized to register a project document with the same name as a previously registered project document
		NSURL * projectURL = [[projectDocument fileURL] absoluteURL];
		for(id P in PROJECTS)
		{
//iTM2_LOG(@"PROBLEM");if([[P fileName] iTM2_pathIsEqual:FN]){
//iTM2_LOG(@"PROBLEM");}
			NSAssert2(![[P fileURL] iTM2_isEquivalentToURL:projectURL],@"You cannot register 2 different project documents with that URL:\n%@==%@",projectURL,[P fileURL]);
		}
		[PROJECTS addObject:projectDocument];
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
- 2.1: Sun May  4 21:23:01 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
	{
		[PROJECTS removeObject:projectDocument];
		[CACHED_PROJECTS removeObjectsForKeys:[CACHED_PROJECTS allKeysForObject:projectDocument]];
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
- 2.1: Sun May  4 21:22:53 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return (nil != argument) && [PROJECTS containsObject:argument];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectURLInWrapperForURL:error:
- (NSURL *)getProjectURLInWrapperForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
fileURLRef changes when it is a wrapper URL.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * projectDocument = nil;
	NSString * fileName = [[fileURL path] stringByStandardizingPath];
	NSURL * wrapperURL = [fileURL iTM2_enclosingWrapperURL];
	if([SWS iTM2_isWrapperPackageAtURL:wrapperURL])
	{
		// then we are trying to find a project just below
		BOOL isDirectory = NO;
		if([DFM fileExistsAtPath:[wrapperURL path] isDirectory:&isDirectory] && isDirectory)
		{
			NSArray * projectURLs = [wrapperURL iTM2_enclosedProjectURLs];
			NSURL * projectURL = nil;
			NSString * component = nil;
			if([projectURLs count] == 1)
			{
				return [projectURLs lastObject];
			}
			else if([projectURLs count] > 1)
			{
				component = [[wrapperURL path] lastPathComponent];
				component = [component stringByDeletingPathExtension];
				component = [component stringByAppendingPathExtension:[SDC iTM2_projectPathExtension]];// not well designed, no intrinsic definition
				projectURL = [NSURL iTM2_URLWithPath:component relativeToURL:wrapperURL];
				if([[projectURLs valueForKey:@"absoluteURL"] containsObject:[projectURL absoluteURL]])
				{
					return projectURL;
				}
				if(outErrorPtr)
				{
					*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Too many projects in the wrapper directory at\n%@\nChoosing the last one.",wrapperURL] forKey:NSLocalizedDescriptionKey]];
				}
				return nil;
			}
			else
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.",wrapperURL] forKey:NSLocalizedDescriptionKey]]];
				// the following method will create a constrained project
				component = [[wrapperURL path] lastPathComponent];
				component = [component stringByDeletingPathExtension];
				component = [component stringByAppendingPathExtension:[SDC iTM2_projectPathExtension]];
				projectURL = [NSURL iTM2_URLWithPath:component relativeToURL:wrapperURL];
				if([DFM fileExistsAtPath:[projectURL path]])
				{
					int tag = 0;
					if(![SWS performFileOperation:NSWorkspaceRecycleOperation source:[wrapperURL path]
							destination:@"" files:[NSArray arrayWithObject:component] tag:&tag])
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Impossible to recycle file at\n%@\nProblems forthcoming...",projectURL]
								forKey:NSLocalizedDescriptionKey]]];
					}
				}
				if([DFM iTM2_createDeepDirectoryAtPath:[projectURL path] attributes:nil error:outErrorPtr])
				{
					projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:NO error:outErrorPtr];
					[projectDocument fixProjectConsistency];
				}
				else
				{
					projectDocument = [SDC makeUntitledDocumentOfType:[SDC iTM2_projectPathExtension] error:outErrorPtr];
					[projectDocument setFileURL:projectURL];
					[projectDocument setFileType:(NSString *)[SDC iTM2_projectDocumentType]];
					[projectDocument fixProjectConsistency];
					[SDC addDocument:projectDocument];
				}
				if(projectDocument)
				{
					[projectDocument newFileKeyForURL:fileURL];
					[projectDocument saveDocument:nil];
					return projectURL;
				}
				else
				{
					if(outErrorPtr)
					{
						*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.",wrapperURL] forKey:NSLocalizedDescriptionKey]];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectInWrapperForURL:display:error:
- (id)getProjectInWrapperForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * projectURL = [self getProjectURLInWrapperForURL:fileURL error:outErrorPtr];
	if(nil != projectURL)
	{
		iTM2ProjectDocument * projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outErrorPtr];
		[projectDocument fixProjectConsistency];
		[projectDocument newFileKeyForURL:fileURL];
		[SPC setProject:projectDocument forURL:fileURL];
		return projectDocument;
	}
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if(nil == fileURLRef)
	{
		return nil;
	}
	NSURL * fileURL = [*fileURLRef iTM2_URLByPrependingFactoryBaseURL];
    id result = [self getProjectInWrapperForURL:fileURL display:display error:outErrorPtr];
	if(result)
	{
		// This project is a cached one
		// It was created because some location was not writable
		// If the location status has changed, then this project should be merged with the existing project 
		// There is a problem if there is already a project that we can't modify
		// The preferred situation is with a non cached project
		// We try to recover this more normal situation.
		NSURL * url = [result fileURL];// the project document URL
		url = [url iTM2_URLByRemovingFactoryBaseURL];// the not cached equivalent
		if([DFM fileExistsAtPath:[url path]])
		{
			// there is already a project not cached
			// This is definitely the one we would have opened
			// Remember tha this method is just one of the components of the routine that
			// maps a project to any given URL
			return [SPC getProjectInHierarchyForURL:url display:display error:outErrorPtr];
		}
		if([DFM isWritableFileAtPath:[[url path] stringByDeletingLastPathComponent]])
		{
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileURL isFileURL])
	{
		return nil;
	}
	NSURL * theURL = fileURL;
	NSURL * url = nil;
	NSString * component = nil;
	iTM2ProjectDocument * projectDocument = nil;
	NSMutableArray * candidates = [NSMutableArray array];
scanDirectoryContent:
	if([SWS iTM2_isProjectPackageAtURL:theURL])
	{
		[candidates addObject:theURL];
		return candidates;
	}
	if([SWS iTM2_isWrapperPackageAtURL:theURL])
	{
		[candidates addObjectsFromArray:[theURL iTM2_enclosedProjectURLs]];
		return candidates;
	}
	BOOL finished = NO;
	CFStringRef iTM2_projectDocumentType = [SDC iTM2_projectDocumentType];
	for(component in [DFM directoryContentsAtPath:[theURL path]])
	{
		if(UTTypeEqual((CFStringRef)[SDC typeForContentsOfURL:[NSURL fileURLWithPath:component] error:NULL],iTM2_projectDocumentType))
		{
			finished = YES;
			url = [NSURL iTM2_URLWithPath:component relativeToURL:theURL];
			projectDocument = [SDC documentForURL:url];
			if([projectDocument fileKeyForURL:fileURL])
			{
				[candidates addObject:url];
			}
			else if(nil == projectDocument)
			{
				if([self fileKeyForURL:fileURL filter:iTM2PCFilterRegular inProjectWithURL:url])
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
	for(component in [DFM directoryContentsAtPath:[theURL path]])
	{
		if(UTTypeEqual((CFStringRef)[SDC typeForContentsOfURL:[NSURL fileURLWithPath:component] error:NULL],iTM2_projectDocumentType))
		{
			finished = YES;
			url = [NSURL iTM2_URLWithPath:component relativeToURL:theURL];
			NSString * K = [self fileKeyForURL:fileURL filter:iTM2PCFilterAlias inProjectWithURL:url];
			if(K && ![DFM fileExistsAtPath:[[self URLForFileKey:K filter:iTM2PCFilterRegular inProjectWithURL:url] path]])
			{
				[candidates addObject:url];
			}
		}
	}
	if((0 == [candidates count]) && !finished)
	{
		theURL = [theURL iTM2_parentDirectoryURL];
		if([[theURL path] length]>1)
		{
			goto scanDirectoryContent;
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
/*"This is the point where we open an existing project. The given file URL does not belong to a project nor a wrapper.
Developer note:all the docs open here are .texp files.
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
		if([SWS iTM2_isProjectPackageAtURL:projectURL])
		{
			url = [self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
			if([url iTM2_isEquivalentToURL:fileURL])
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
			&& [SWS iTM2_isProjectPackageAtURL:projectURL])\
		{\
			if([[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])\
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
		&& (projectName = [aliasData iTM2_pathByResolvingDataAliasRelativeTo:nil error:outErrorPtr]))
	{
		ABSOLUTE_FILE_NAME_FOR_KEY;
	}
	// in the hierarchy
	url = [fileURL iTM2_parentDirectoryURL];
	NSString * dirName = [[fileURL path] stringByDeletingLastPathComponent];
	NSArray * contents = nil;
	NSEnumerator * E = nil;
	NSString * component = nil;
	while([[url path] length]>1)
	{
		contents = [DFM directoryContentsAtPath:[url path]];
		E = [contents objectEnumerator];
		while(component = [E nextObject])
		{
			projectURL = [NSURL iTM2_URLWithPath:component relativeToURL:url];
			if(![projects iTM2_containsURL:projectURL] && [SWS iTM2_isProjectPackageAtURL:projectURL])
			{
iTM2_LOG(@"projectURL:%@",projectURL);
				if([[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])
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
		url = [url iTM2_parentDirectoryURL];
	}
	// in the cached hierarchy, this is only for projects that could not be written because of a lack of rights
	NSString * fileName = [fileURL path];
	if(![fileName iTM2_belongsToDirectory:[[NSURL iTM2_factoryURL] path]])
	{
		dirName = [fileName stringByDeletingLastPathComponent];
		dirName = [[NSURL iTM2_URLWithPath:dirName relativeToURL:[NSURL iTM2_factoryURL]] path];
		while([dirName length]>[[[NSURL iTM2_factoryURL] path] length])
		{
			contents = [DFM directoryContentsAtPath:dirName];
			E = [contents objectEnumerator];
			while(component = [E nextObject])
			{
				projectURL = [NSURL iTM2_URLWithPath:component relativeToURL:url];
				if([SWS iTM2_isWrapperPackageAtURL:projectURL])
				{
					projectURL = [[projectURL iTM2_enclosedProjectURLs] lastObject];
				}
				if([SWS iTM2_isProjectPackageAtURL:projectURL])
				{
					if(![projects iTM2_containsURL:projectURL])
					{
iTM2_LOG(@"projectURL:%@",projectURL);
						if([[self URLForFileKey:theKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] iTM2_isEquivalentToURL:fileURL])
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
			url = [fileURL iTM2_parentDirectoryURL];
			dirName = [url path];
		}
	}
	if(projectDocument = [self getProjectDocumentFromProjects:projects fileKey:keyRef forURL:fileURL display:display error:outErrorPtr])
	{
		goto theEnd;
	}
	NSString * oldFileName = [contextDictionary objectForKey:iTM2ProjectAbsolutePathKey];
	if(![oldFileName iTM2_pathIsEqual:fileName]
		&& ![DFM fileExistsAtPath:oldFileName]
			&& oldFileName
				&& [self getUnregisteredProject:&projectDocument fileKey:&theKey forURL:[NSURL fileURLWithPath:oldFileName] display:display error:outErrorPtr])
	{
		// as we passed a pointer to receive the key, the returned project has not yet set up the key->file binding.
		goto theEnd;
	}
	NSString * resolvedFileName = nil;
	if((aliasData = [contextDictionary objectForKey:iTM2ProjectOwnAliasKey])
		&& [aliasData isKindOfClass:[NSData class]])
	{
		resolvedFileName = [aliasData iTM2_pathByResolvingDataAliasRelativeTo:nil error:outErrorPtr];
		if(![resolvedFileName iTM2_pathIsEqual:fileName]
			&& ![resolvedFileName iTM2_pathIsEqual:oldFileName]
				&& ![DFM fileExistsAtPath:resolvedFileName]
					&& [self getUnregisteredProject:&projectDocument fileKey:&theKey forURL:[NSURL fileURLWithPath:resolvedFileName] display:display error:outErrorPtr])
		{
			goto theEnd;
		}
	}
	NSString * texFileName = [fileName stringByDeletingPathExtension];
	texFileName = [texFileName stringByAppendingPathExtension:@"tex"];
	if(![texFileName iTM2_pathIsEqual:fileName]
		&& ![texFileName iTM2_pathIsEqual:oldFileName]
			&& ![texFileName iTM2_pathIsEqual:resolvedFileName]
				&& [self getUnregisteredProject:&projectDocument fileKey:&theKey forURL:[NSURL fileURLWithPath:texFileName] display:display error:outErrorPtr])
	{
		goto theEnd;
	}
	// scan the cached projects folder
	// this is only relevant when the user can't write where the file URL is located
	// otherwise this is the preferred location of the associated project
	NSURL * factoryDirectoryURL = [NSURL iTM2_factoryURL];
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:[factoryDirectoryURL path]];
	projects = [NSMutableArray array];
	NSMutableArray * garbage = [NSMutableArray array];
	while(component = [DE nextObject])
	{
		url = [NSURL iTM2_URLWithPath:component relativeToURL:factoryDirectoryURL];
		if([SWS iTM2_isWrapperPackageAtURL:url])
		{
			if(projectURL = [self getProjectURLInWrapperForURL:url error:outErrorPtr])
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newWritableProjectForURL:display:error:
- (id)newWritableProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;
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
	NSString * factoryDirectory = [[NSURL iTM2_factoryURL] path];
	CFStringRef typeName = [SDC iTM2_projectDocumentType];
	iTM2ProjectDocument * projectDocument = [SDC makeUntitledDocumentOfType:(NSString *)typeName error:outErrorPtr];
	if(projectDocument)
	{
		NSString * fileName = [fileURL path];
		NSString * component = [fileName lastPathComponent];
		NSString * coreName = [component stringByDeletingPathExtension];
		NSString * libraryWrapperName = [[fileName stringByDeletingPathExtension]
			stringByAppendingPathExtension:[SDC iTM2_wrapperPathExtension]];
		libraryWrapperName = [factoryDirectory stringByAppendingPathComponent:libraryWrapperName];
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
					if(![DFM iTM2_createDeepDirectoryAtPath:libraryWrapperName attributes:nil error:outErrorPtr])
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
		projectName = [projectName stringByAppendingPathExtension:[SDC iTM2_projectPathExtension]];
		if(![DFM iTM2_createDeepDirectoryAtPath:projectName attributes:nil error:outErrorPtr] && outErrorPtr && (outErrorPtr?*outErrorPtr:nil))
		{
			[SDC presentError:*outErrorPtr];
		}
		NSURL * url = [NSURL fileURLWithPath:projectName];
//iTM2_LOG(@"url: %@",url);
		[projectDocument setFileURL:url];
		[projectDocument setFileType:(NSString *)typeName];// is it necessary?
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
	if([[fileURL path] iTM2_belongsToDirectory:[[NSURL iTM2_factoryURL] path]])
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
newWritableProject:
		projectDocument = [self newWritableProjectForURL:fileURL display:NO error:outErrorPtr];// NO is required unless a ghost window controller is created
		[projectDocument saveDocument:nil];
		[SPC setProject:projectDocument forURL:fileURL];
		return projectDocument;
	}
	NSString * fileName = [fileURL path];
	NSString * dirName = [fileName stringByDeletingLastPathComponent];
	if(![DFM isWritableFileAtPath:dirName])
	{
		// no need to go further
		// we have no write access
		goto newWritableProject;
	}
	// reentrant management,if the panel for that particular file is already running, do nothing...
	NSEnumerator * E = [[NSApp windows] objectEnumerator];
	NSWindow * W;
	id controller;
	Class controllerClass = [self newProjectPanelControllerClass];
	while(nil != (W = [E nextObject]))
	{
		controller = [W windowController];
		if([controller isKindOfClass:controllerClass] && [[controller fileURL] iTM2_isEquivalentToURL:fileURL])
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
			if(![DFM iTM2_createDeepDirectoryAtPath:projectName attributes:nil error:nil])
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
			NSURL * wrapperURL = [projectURL iTM2_enclosingWrapperURL];
			if(wrapperURL)
			{
				// The project does belong to a wrapper
				// we must change the fileURL
				// as I said before, if the fileURL was part of a wrapper, we would have catched it before
				// and the present method would never have been reached
				NSString * sourceDirName = [[self URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL] path];
				if(![dirName iTM2_belongsToDirectory:sourceDirName])
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
			if([SWS iTM2_isProjectPackageAtURL:projectURL] || [DFM iTM2_createDeepDirectoryAtPath:projectName attributes:nil error:outErrorPtr])
			{
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
			[DFM iTM2_setExtensionHidden:YES atPath:projectName];
			return projectDocument;
		}
		break;
		case iTM2ToggleOldProjectMode:
		{
			id projectDocument = [[[SDC openDocumentWithContentsOfURL:projectURL display:NO error:nil] retain] autorelease];
			NSString * projectDirName = [projectDocument fileName];
			NSString * projectWrapperName = [[[projectDocument fileURL] iTM2_enclosingWrapperURL] path];
			projectDirName = [projectDirName stringByDeletingLastPathComponent];
			if([projectWrapperName length])
			{
				if(![dirName iTM2_pathIsEqual:projectDirName])
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  existingProjectForURLRef:display:error:
- (id)existingProjectForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;
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
	if(projectDocument)
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
	CFStringRef iTM2_projectDocumentType = [SDC iTM2_projectDocumentType];
	if((UTTypeEqual((CFStringRef)[SDC typeForContentsOfURL:fileURL error:nil],iTM2_projectDocumentType)
		&& [SDC documentClassForType:(NSString *)iTM2_projectDocumentType])
		|| (projectDocument = [self getOpenProjectForURL:fileURL])
		|| (projectDocument = [self getProjectInWrapperForURL:fileURL display:display error:outErrorPtr])
		|| (projectDocument = [self getProjectInHierarchyForURL:fileURL display:display error:outErrorPtr])
		|| (projectDocument = [self getProjectFromPanelForURLRef:fileURLRef display:display error:outErrorPtr]))
	{
		if([*fileURLRef iTM2_isRelativeToURL:[NSURL iTM2_factoryURL]])
		{
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
	if(projectDocument)
	{
		return projectDocument;// this filename is already registered, possibly with a "nil" project ("nil" projects are no longer supported, see "Elementary")
	}
	// reentrant code
	if(![self canGetNewProjectForURL:fileURL error:outErrorPtr])
	{
		return nil;
	}
	[self willGetNewProjectForURL:fileURL];
	// nil is returned for project file names...
	CFStringRef iTM2_projectDocumentType = [SDC iTM2_projectDocumentType];
	if((UTTypeEqual((CFStringRef)[SDC typeForContentsOfURL:fileURL error:outErrorPtr],iTM2_projectDocumentType)
		&& [SDC documentClassForType:(NSString *)iTM2_projectDocumentType])
		|| (projectDocument = [self getOpenProjectForURL:fileURL])
		|| (projectDocument = [self getProjectInWrapperForURL:fileURL display:display error:outErrorPtr])
		|| (projectDocument = [self getProjectInHierarchyForURL:fileURL display:display error:outErrorPtr])
		|| (projectDocument = [self getProjectFromPanelForURLRef:fileURLRef display:display error:outErrorPtr]))
	{
		if([*fileURLRef iTM2_isRelativeToURL:[NSURL iTM2_factoryURL]])
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
	if(![IMPLEMENTATION metaValueForKey:iTM2ProjectsForURLsKey])
	{
		[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsForURLsKey];
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
	NSString * type = [SDC typeForContentsOfURL:projectURL error:NULL];
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
    return [BASE_PROJECTS objectForKey:[fileURL absoluteURL]];
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
	NSString * baseProjectsRepository = [NSBundle iTM2_temporaryBaseProjectsDirectory];
	NSEnumerator * E = [[DFM directoryContentsAtPath:baseProjectsRepository] objectEnumerator];
	NSString * path = nil;
	NSMutableSet * MS = [NSMutableSet set];
	while(path = [E nextObject])
	{
		path = [baseProjectsRepository stringByAppendingPathComponent:path];
		NSEnumerator * e = [[DFM directoryContentsAtPath:path] objectEnumerator];
		NSString * requiredExtension = [SDC iTM2_projectPathExtension];
		NSString * component = nil;
		while(component = [e nextObject])
		{
			if(![component hasPrefix:@"."] && [[component pathExtension] iTM2_pathIsEqual:requiredExtension])
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
	NSString * baseProjectsRepository = [NSBundle iTM2_temporaryBaseProjectsDirectory];
	NSEnumerator * E = [[DFM directoryContentsAtPath:baseProjectsRepository] objectEnumerator];
	NSString * path = nil;
	NSMutableArray * MRA = [NSMutableArray array];
	while(path = [E nextObject])
	{
		if([[path stringByDeletingPathExtension] iTM2_pathIsEqual:name])
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
	[MB iTM2_pathForSupportDirectory:iTM2ProjectBaseComponent inDomain:NSUserDomainMask create:YES];
	NSArray * paths = [MB allPathsForResource:iTM2ProjectBaseComponent ofType:@""];
	NSString * baseProjectsRepository = [NSBundle iTM2_temporaryBaseProjectsDirectory];
	unsigned index = [paths count];
	id P = nil;
	NSString * source = nil;
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
			for(source in [DFM directoryContentsAtPath:P])
			{
				iTM2_LOG(@"source is: %@",source);
				K = [source stringByDeletingPathExtension];
				source = [P stringByAppendingPathComponent:source];
				source = [source stringByStandardizingPath];// don't miss that!
				iTM2_LOG(@"source is: %@",source);
				NSURL * url = [NSURL fileURLWithPath:source];
				if([SWS iTM2_isProjectPackageAtURL:url])
				{
					if(MRA = [BASE_URLs objectForKey:K])
					{
						[MRA addObject:url];
					}
					else
					{
						[BASE_URLs setObject:[NSMutableArray arrayWithObject:url] forKey:K];
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
	for(P in [BASE_PROJECTS keyEnumerator])
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
	id result = [[SDC currentDocument] project];
	if(result != iVarCurrentProject)
	{
		id old = iVarCurrentProject;
		iVarCurrentProject = result;// reentrant firewall
		[INC performSelector:@selector(postNotification:) withObject:
			[NSNotification notificationWithName:iTM2ProjectCurrentDidChangeNotification
				object:self userInfo:([self isProject:iVarCurrentProject]? [NSDictionary dictionaryWithObjectsAndKeys:old,@"oldProject",nil]:nil)]
			afterDelay:0];// notice the isProject:that ensures old is consistent
		for(id projectDocument in [self projects])
		{
			if(projectDocument == result)
			{
				[projectDocument exposeWindows];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpProject:
- (void)setUpProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL *)fileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_FileURL autorelease];
	_FileURL = [fileURL copy];
	fileURL = [fileURL iTM2_parentDirectoryURL];
	[_ProjectDirURL autorelease];
	_ProjectDirURL = [fileURL copy];
	_IsAlreadyDirectoryWrapper = NO;
loop:
	if(UTTypeEqual((CFStringRef)[SDC typeForContentsOfURL:fileURL error:NULL],(CFStringRef)iTM2WrapperDocumentType))
	{
		_IsAlreadyDirectoryWrapper = YES;
		[_ProjectDirURL autorelease];
		_ProjectDirURL = [fileURL copy];
		_ToggleProjectMode = iTM2ToggleNewProjectMode;
		return;
	}
	else if(fileURL = [fileURL iTM2_parentDirectoryURL])
	{
		goto loop;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_ToggleProjectMode == iTM2ToggleNewProjectMode)
	{
		return [[NSURL iTM2_URLWithPath:_NewProjectName relativeToURL:[self projectDirURL]] absoluteURL];
	}
	else if(_ToggleProjectMode == iTM2ToggleOldProjectMode)
		return _SelectedRow >= 0 && _SelectedRow < [_Projects count] ?
			[NSURL fileURLWithPath:[[_Projects objectAtIndex:_SelectedRow] objectForKey:@"path"]]:nil;
	else
		return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDirURL
- (NSURL *)projectDirURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_IsAlreadyDirectoryWrapper)
	{
		return _ProjectDirURL;
	}
	if(_IsDirectoryWrapper && (_ToggleProjectMode != iTM2ToggleOldProjectMode))
	{
		NSString * component = [[[_FileURL path] lastPathComponent] stringByDeletingPathExtension];
		if([component length])
		{
			return [[NSURL iTM2_URLWithPath:component relativeToURL:_ProjectDirURL] absoluteURL];
		}
		else
		{
			iTM2_LOG(@"Weird _ProjectDirURL");
			return nil;
		}
	}
//iTM2_LOG(@"projectDirName is:%@",result);
	return _ProjectDirURL;
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
	_Projects = [[NSMutableArray array] retain];
	NSDictionary * availableProjects = [SPC availableProjectsForURL:[_FileURL iTM2_parentDirectoryURL]];
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
	if(_ToggleProjectMode == iTM2ToggleNewProjectMode)
	{
		[SUD setObject:[NSNumber numberWithBool:_IsDirectoryWrapper] forKey:iTM2ProjectIsDirectoryWrapperKey];
	}
	[NSApp stopModalWithCode:_ToggleProjectMode];
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
	{
		[NSApp stopModalWithCode:iTM2ToggleNoProjectMode];
	}
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
	NSString * path = [_FileURL path];
	[sender setStringValue:([path length]? [path lastPathComponent]:@"None")];
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
	NSString * path = [_FileURL path];
	if([path length]> 0)
		[sender setStringValue:[[self projectDirURL] path]];
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
		NSString * new = [senderString stringByAppendingPathExtension:[SDC iTM2_projectPathExtension]];
		if(![new iTM2_pathIsEqual:_NewProjectName])
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
	if(!_NewProjectName)
	{
		[_NewProjectName autorelease];
		if(_IsAlreadyDirectoryWrapper)
			_NewProjectName = iTM2ProjectTable;
		else
		{
			NSString * name = [[[_FileURL path] lastPathComponent] stringByDeletingPathExtension];
			if([name length])
			{
				_NewProjectName = [[name stringByAppendingPathExtension:[SDC iTM2_projectPathExtension]] retain];
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
@synthesize _FileURL;
@synthesize _NewProjectName;
@synthesize _ProjectDirURL;
@synthesize _Projects;
@synthesize _SelectedRow;
@synthesize _ToggleProjectMode;
@synthesize _IsAlreadyDirectoryWrapper;
@synthesize _IsDirectoryWrapper;
@end

@implementation NSWorkspace(iTM2ProjectControllerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isFilePackageAtURL:
- (BOOL)iTM2_isFilePackageAtURL:(NSURL *)url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [url isFileURL]&&[self isFilePackageAtPath:[url path]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isProjectPackageAtURL:
- (BOOL)iTM2_isProjectPackageAtURL:(NSURL *)url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(url)
	{
		NSInvocation * I;
		[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] iTM2_isProjectPackageAtURL:url];
		NSPointerArray * PA = [iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"ProjectPackageAtURL:" signature:[I methodSignature] inherited:YES];
		NSUInteger i = [PA count];
		while(i--)
		{
			SEL selector = (SEL)[PA pointerAtIndex:i];
			if(selector != _cmd)
			{
				[I setSelector:selector];
				[I invoke];
				BOOL R = NO;
				[I getReturnValue:&R];
				if(R)
				{
					return YES;
				}
			}
		}
		return UTTypeConformsTo((CFStringRef)[SDC typeForContentsOfURL:url error:nil],iTM2UTTypeProject);
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isWrapperPackageAtURL:
- (BOOL)iTM2_isWrapperPackageAtURL:(NSURL *)url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if(url)
	{
		NSInvocation * I;
		[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] iTM2_isWrapperPackageAtURL:url];
		NSPointerArray * PA = [iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"WrapperPackageAtURL:" signature:[I methodSignature] inherited:YES];
		NSUInteger i = [PA count];
		while(i--)
		{
			SEL selector = (SEL)[PA pointerAtIndex:i];
			if(selector != _cmd)
			{
				[I setSelector:selector];
				[I invoke];
				BOOL R = NO;
				[I getReturnValue:&R];
				if(R)
				{
					return YES;
				}
			}
		}
		return UTTypeConformsTo((CFStringRef)[SDC typeForContentsOfURL:url error:NULL],iTM2UTTypeWrapper);
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_temporaryBaseProjectsDirectory:
+ (NSString *)iTM2_temporaryBaseProjectsDirectory;
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
		if([DFM iTM2_createDeepDirectoryAtPath:path attributes:nil error:&localError])
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
			if([DFM iTM2_createDeepDirectoryAtPath:path attributes:nil error:&localError])
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

@implementation NSApplication(iTM2DocumentController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentControllerCompleteInstallation
+ (void)documentControllerCompleteInstallation;
/*"Installs the custom document controller.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[iTM2PDocumentController alloc] init];
    return;
}
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
		NSURL * enclosingURL = [absoluteURL iTM2_enclosingProjectURL];
		if(enclosingURL && ![[absoluteURL absoluteURL] isEqual:[enclosingURL absoluteURL]])
		{
			[super noteNewRecentDocumentURL:enclosingURL];// we replace the file by its enclosing project
			return;
		}
		if([SWS iTM2_isWrapperPackageAtURL:absoluteURL] && [absoluteURL iTM2_belongsToFactory])
		{
			return;
		}
		if(enclosingURL = [absoluteURL iTM2_enclosingWrapperURL])
		{
			NSArray * enclosed = [enclosingURL iTM2_enclosedProjectURLs];
			if([enclosed count] == 1)
			{
				absoluteURL = [enclosed lastObject];
			}
			else if([SWS iTM2_isProjectPackageAtURL:absoluteURL])
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
					if([[PD fileURL] iTM2_belongsToFactory])
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
iTM2_LOG(@"[document retainCount]:%i",[document retainCount]);
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
	id projectDocument = [document project];
	if([[self documents] containsObject:document])
	{
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
	iTM2_LOG(@"[document retainCount]:%i",[document retainCount]);
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
	NSError * outError;
	iTM2_LOG(@"[SDC typeForContentsOfURL:absoluteURL error:&outError]:%@",[SDC typeForContentsOfURL:absoluteURL error:&outError]);
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
	//
	// Every other object is owned by a project.
	// There are 2 situations:
	// - this is the first time we open a document
	// - the document was already open once
	//
	// One problem occurs when we have no write access, more precisely in one of 3 situation
	// case "always W-", we never had write authorization
	// the project will be available in a default location with write access
	// case "newly W-", we had write access, but this is no longer true
	// the project can't be modified
	// case "newly W+", exacly the opposit, we did not have write access but this is no longer true.
	// this is exactly the same situation that for 
	// 
	// 0 - is it a cached project or wrapper URL?
	// such url's belong to the cached projects directory
	NSURL * url = nil;
	if([absoluteURL iTM2_belongsToFactory])
	{
		// we avoid opening directly a project in the Library...
		url = [absoluteURL iTM2_URLByRemovingFactoryBaseURL];
		if([DFM fileExistsAtPath:[url path]])
		{
			absoluteURL = url;
			url = nil;
		}
		else
		{
			// conversion for standalone documents
			// we try to move something from the cache location to the uncached one
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
		for(D in [self documents])
		{
			iTM2_LOG(@"[D fileName] %@",[D fileName]);
			iTM2_LOG(@"[D fileURL] %@",[D fileURL]);
		}
	}
	// there is no already open document for the given absoluteURL
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
	NSString * component;
	for(component in components)
	{
		if([component hasPrefix:@"."])
		{
			iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Please, copy %@ to a visible location of the Finder before opening it.",[fileName lastPathComponent]]),nil);
			[SWS selectFile:fileName inFileViewerRootedAtPath:[fileName stringByDeletingLastPathComponent]];
			return nil;
		}
	}
	// There was no already existing documents
	// Every component is visible
	// Is it an existing file?
	BOOL isDirectory = NO;
	if(![DFM fileExistsAtPath:fileName isDirectory:&isDirectory])
	{
		iTM2_OUTERROR(2,([NSString stringWithFormat:@"Missing file at\n%@",absoluteURL]),nil);
		return nil;
	}
//iTM2_LOG(@"0");
	// B - is it a wrapper document?
	if([SWS iTM2_isWrapperPackageAtURL:absoluteURL])
	{
		NSURL * projectURL = [SPC getProjectURLInWrapperForURL:absoluteURL error:outErrorPtr];
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
	else if([SWS iTM2_isProjectPackageAtURL:absoluteURL])
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
		id subpaths = [absoluteURL iTM2_enclosedProjectURLs];
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
				if([[dict objectForKey:@"isa"] isEqualToString:iTM2ProjectInfoMainType])
				{
					// yes this is a former project.
					// Can I add such a file extension by myself?
					// yes, unless it is not possible to move the project
					NSString * destination = [fileName stringByAppendingPathExtension:[SDC iTM2_projectPathExtension]];
					if([DFM fileExistsAtPath:destination] ||
						![DFM movePath:fileName toPath:destination handler:NULL])
					{
						iTM2_OUTERROR(2,([NSString stringWithFormat:@"Confusing situation:the following directory seems to be a project despite it has no %@ path extension:\n%@\nOne cannot be added.",
									fileName,[SDC iTM2_projectPathExtension]]),nil);
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
	// Now we assume that fileURL does not point to a project nor wrapper nor directory.
	// We try to find a project in the hierarchy
	// This is the natural situation.
	// In all the next methods, the URL ref is necessary because we allow the file URL to be modified
	// The only situation where the file URL will be modified if it is a wrapper
	// A wrapper is always replaced by the project it contains
    id projectDocument = nil;
	if((projectDocument = [SPC projectForURL:absoluteURL])
		|| (projectDocument = [SPC getProjectInWrapperForURL:absoluteURL display:display error:outErrorPtr])// fileURL belongs to a wrapper
		|| (projectDocument = [SPC getProjectInHierarchyForURL:absoluteURL display:display error:outErrorPtr])// fileURL belongs to a project in the hierarchy
		|| (projectDocument = [SPC getProjectInHierarchyForURL:[absoluteURL iTM2_URLByPrependingFactoryBaseURL] display:display error:outErrorPtr])// fileURL belongs to a cached project 
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
	projectDocument = [SPC freshProjectForURLRef:&url display:display error:outErrorPtr];
    if(nil != projectDocument)
    {
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
