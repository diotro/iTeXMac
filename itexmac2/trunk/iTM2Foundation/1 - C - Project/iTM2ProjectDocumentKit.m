/*
//
//  @version Subversion: $Id$ 
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
#import <iTM2Foundation/iTM2ImageKit.h>
#import <iTM2Foundation/iTM2Invocation.h>

NSString * const iTM2WrapperDocumentType = @"Wrapper Document";
NSString * const iTM2ProjectDocumentType = @"Project Document";
const CFStringRef iTM2UTTypeWrapper = CFSTR("comp.text.tex.itexmac2.wrapper");
const CFStringRef iTM2UTTypeProject = CFSTR("comp.text.tex.itexmac2.project");
NSString * const iTM2WrapperPathExtension = @"wrapper";
NSString * const iTM2ProjectPathExtension = @"project";
NSString * const iTM2ProjectInfoMainType = @"info";

NSString * const iTM2ProjectTable = @"Project";
NSString * const iTM2ProjectInspectorType = @"project";
NSString * const iTM2SubdocumentsInspectorMode = @"Project Subdocuments Mode";
static NSString * const iTM2ProjectCachedKeysKey = @"info_cachedKeys";
static NSString * const iTM2ContextOpenDocuments = @"Open Documents";

NSString * const TWSFrontendComponent = @"frontends";

NSString * const iTM2NewDocumentEnclosedInWrapperKey = @"iTM2NewDocumentEnclosedInWrapper";
NSString * const iTM2NewProjectCreationModeKey = @"iTM2NewProjectCreationMode";

@interface iTM2ProjectDocument(FrontendKit_PRIVATE)
- (void)canCloseAllSubdocumentsWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
- (BOOL)prepareFrontendCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
- (NSURL *)recordedURLForFileKey:(NSString *)key;
- (void)recordHandleToURL:(NSURL *)fileURL;
- (void)_recordHandleToURL:(NSURL *)fileURL;
- (BOOL)fixWritableProjectConsistency;
- (BOOL)fixInternalProjectConsistency;
- (BOOL)makeNotFaraway;
@end

@interface iTM2ProjectDocument(__PRIVATE)

- (void)_removeFileKey:(NSString *)key;
- (void)closeIfNeeded;

@end

NSString * const iTM2ProjectDefaultsKey = @"_";

//#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>

NSString * const iTM2ProjectFileKeyKey = @"iTM2ProjectFileKey";
NSString * const iTM2ProjectAbsolutePathKey = @"iTM2ProjectAbsolutePath";
NSString * const iTM2ProjectRelativePathKey = @"iTM2ProjectRelativePath";
NSString * const iTM2ProjectOwnRelativePathKey = @"iTM2ProjectOwnRelativePathKey";
NSString * const iTM2ProjectOwnAbsolutePathKey = @"iTM2ProjectOwnAbsolutePathKey";
NSString * const iTM2ProjectOwnAliasKey = @"iTM2ProjectOwnAliasKey";
NSString * const iTM2ProjectAliasKey = @"iTM2ProjectAliasKey";
NSString * const iTM2ProjectURLKey = @"iTM2ProjectURLKey";

@interface NSArray(iTM2ProjectDocumentKit)
- (NSArray *)arrayWithCommonFirstObjectsOfArray:(NSArray *)array;
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>
#import <iTM2Foundation/iTM2InfoWrapperKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocumentKit
/*"Description forthcoming."*/
@implementation iTM2ProjectDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2ProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super init])
	{
		[DNC removeObserver:self];
		[DNC addObserver:self selector:@selector(windowWillCloseNotified:) name:NSWindowWillCloseNotification object:nil];
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillCloseNotified:
- (void)windowWillCloseNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayName
- (NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * result = [self projectName];
//iTM2_END;
	return [result length]? result:[super displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectName
- (NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * projectName = [[[self wrapperName] lastPathComponent] stringByDeletingPathExtension];
	if([projectName length])
		return projectName;
    projectName = [[[self fileName] lastPathComponent] stringByDeletingPathExtension];
	return [[projectName lowercaseString] isEqualToString:@"project"]? @"":projectName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectName
- (NSString *)baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2ProjectDefaultName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBaseProjectName:
- (void)setBaseProjectName:(NSString *)baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  closeIfNeeded
- (void)closeIfNeeded
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self fileURL]:%@",[self fileURL]);
	// never close a base project
	if([SPC isBaseProject:self])
	{
		return;
	}
	// according to the defaults
	if([self contextBoolForKey:@"iTM2ProjectDontCloseWhenNoWindowAreVisible" domain:iTM2ContextAllDomainsMask])
	{
		return;
	}
	// don't close if there are pending documents
	if([[self mutableSubdocuments] count])
	{
		return;//do nothing
	}
	// don't close if stated:
	if(![self shouldCloseWhenLastSubdocumentClosed])
	{
		return;//do nothing
	}
	// don't close if there is any visible window, except _GWC
	NSArray * WCs = [self windowControllers];
	NSWindowController * WC;
	id GWC = [IMPLEMENTATION metaValueForKey:@"_GWC"];
	for(WC in WCs)
	{
		if([WC isEqual:GWC])
		{
			continue;
		}
		else if([WC isWindowLoaded])
		{
			NSWindow * W = [WC window];
			if([W isVisible])
			{
				return;
			}
		}
	}
	[self close];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldCloseWhenLastSubdocumentClosed
- (BOOL)shouldCloseWhenLastSubdocumentClosed;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [IMPLEMENTATION metaValueForSelector:_cmd];
//iTM2_END;
	return [N boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setShouldCloseWhenLastSubdocumentClosed:
- (void)setShouldCloseWhenLastSubdocumentClosed:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [NSNumber numberWithBool:yorn];
	[IMPLEMENTATION takeMetaValue:N forSelector:_cmd];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autosavingFileType
- (NSString *)autosavingFileType;
/*"Autosave can be disabled for the project documents from the defaults.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextBoolForKey:@"iTM2AutosaveProjectDocuments" domain:iTM2ContextAllDomainsMask]?[super autosavingFileType]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableSubdocuments
- (id)mutableSubdocuments;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMutableSubdocuments:
- (void)setMutableSubdocuments:(id)documents;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER(documents);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocuments
- (id)subdocuments;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self mutableSubdocuments] copy] autorelease];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (IBAction)saveDocument:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self fileURL]:%@",[self fileURL]);
	[super saveDocument:sender];
//iTM2_END;
	return;
}
#endif
#pragma mark -
#pragma mark =-=-=-=-=-  FIX PROJECT CONSISTENCY
// this is where various things are cleaned
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateSubdocumentsURLs
- (void)updateSubdocumentsURLs;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// if the files have been moved around while iTeXMac2 was not editing the project,
	// we should automagically update the file names as far as possible
	// we try to find a conservative solution
	NSEnumerator * E = [[self fileKeys] objectEnumerator];
	NSString * key = nil;
	while(key = [E nextObject])
	{
		NSURL * url = [self URLForFileKey:key];
		if(![DFM fileExistsAtPath:[url path]])// traverse the link
		{
			NSURL * recordedURL = [self recordedURLForFileKey:key];
			NSString * path = [url path];
			if([DFM fileExistsAtPath:path])
			{
				// is url acceptable?
				// or does url belong of the contents folder?
				if([recordedURL iTM2_isRelativeToURL:[self contentsURL]]
					&& ![[self contentsURL] isEqual:[self parentURL]])
				{
					[self setURL:recordedURL forFileKey:key];
					[[self subdocumentForURL:url] setFileURL:recordedURL];
				}
				else if([[SPC getProjectURLsInHierarchyForURL:url error:nil] count])
				{
					// this URL belongs to another project
				}
				else
				{
					// we should ask the user;
				}
			}
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _fixWritableProjectConsistency
- (BOOL) _fixWritableProjectConsistency;
/*"A cached project is very special. It was created in the cached location
You should not send this message by yourself, unless you are named fixWritableProjectConsistency
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Nov  8 13:45:07 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * projectURL = [self fileURL];
	if(![projectURL isFileURL])
	{
		return NO;
	}
	if(![projectURL iTM2_belongsToFactory])
	{// this is not an external project: do nothing
		return NO;
	}
	NSString * path = [projectURL path];
	if(![DFM isWritableFileAtPath:path])
	{// we can't do everything we want
		return YES;
	}
	
	// first clean all the keys that point to nothing
	// record all the file names
	NSArray * allKeys = [self fileKeys];
	NSEnumerator * E = [allKeys objectEnumerator];
	NSString * key = nil;
	NSString * name = nil;
	// record all the keyed file names
	// in the following dictionaries, keys are project keys, values are urls, existing ones
	// we sort all the urls
	// oldExistingURLs records urls that were existing
	NSMutableDictionary * oldExistingURLs = [NSMutableDictionary dictionary];
	NSMutableDictionary * oldMovedURLs = [NSMutableDictionary dictionary];
	NSMutableDictionary * oldFactoryURLs  = [NSMutableDictionary dictionary];
	NSMutableSet * oldMissingURLs  = [NSMutableSet set];
	for(key in allKeys)
	{
		if([SPC isReservedFileKey:key])
		{
			// do nothing, this will be managed later
		}
		else if((name = [self nameForFileKey:key]),[name length])
		{
			BOOL isDir;
			NSURL * url = [self URLForFileKey:key];
			if([url isFileURL])
			{
				if([DFM fileExistsAtPath:[url path] isDirectory:&isDir] && !isDir)
				{
					// this is the expected situation
					// the key was created while a file was existing
					// there is still a file at that location
					// nothing has changed
					[oldExistingURLs setObject:url forKey:key];
				}
				else if((url = [self factoryURLForFileKey:key]),[url isFileURL] && [DFM fileExistsAtPath:[url path] isDirectory:&isDir] && !isDir)
				{
					// the key corresponds to a factory url
					[oldFactoryURLs setObject:url forKey:key];
				}
				else if((url = [self recordedURLForFileKey:key]),[url isFileURL] && [DFM fileExistsAtPath:[url path] isDirectory:&isDir] && !isDir)
				{
					// the key corresponds to a previously recorded url
					// we assume the file has moved
					[oldMovedURLs setObject:url forKey:key];
				}
				else
				{
					// the file is no longer available, I don't know whre it is
					[oldMissingURLs addObject:key];
				}
			}
			else
			{
				// I do not know yet what to do for non file urls.
			}
		}
		else
		{
			// the returned name is either NULL or 0 lengthed
			// the project does not know this key
			[self removeFileKey:key];
		}
	}
	NSURL * oldProjectURL = [SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL];
	// oldProjectURL was previously recorded for the case of a move...
	NSArray * RA = nil;
	NSString * expectedDirName = nil;
	NSString * requiredCore = [[[projectURL path] lastPathComponent] stringByDeletingPathExtension];
	NSArray * commonComponents = nil;
	NSURL * url = nil;
	if([[oldProjectURL absoluteURL] isEqual:[projectURL absoluteURL]])
	{
		// the project has not moved since the last time it was saved by iTeXMac2
		// If some files have moved, I might need to move the project accordingly
		// as an external project, I just have to follow the containing directory
		// but what is the containing directory?
changeName:
		E = [[[oldExistingURLs allValues] valueForKey:@"path"] objectEnumerator];
		while(name = [E nextObject])
		{
			name = [name stringByDeletingLastPathComponent];
			commonComponents = [name pathComponents];
			if([commonComponents containsObject:@".Trash"])
			{
				commonComponents = nil;			
			}
			else
			{
				break;
			}
		}
		E = [[[oldExistingURLs allValues] valueForKey:@"path"] objectEnumerator];
		while(name = [E nextObject])
		{
			RA = [name pathComponents];
			commonComponents = [commonComponents arrayWithCommonFirstObjectsOfArray:RA];
		}
		E = [[[oldMovedURLs allValues] valueForKey:@"path"] objectEnumerator];
		if(![commonComponents count])
		{
			while(name = [E nextObject])
			{
				name = [name stringByDeletingLastPathComponent];
				commonComponents = [name pathComponents];
				if([commonComponents containsObject:@".Trash"])
				{
					commonComponents = nil;			
				}
				else
				{
					break;
				}
			}
			E = [[[oldMovedURLs allValues] valueForKey:@"path"] objectEnumerator];
		}
		while(name = [E nextObject])
		{
			RA = [name pathComponents];
			commonComponents = [commonComponents arrayWithCommonFirstObjectsOfArray:RA];
		}
		// the commonComponents are not expected to belong to the external project directory
		if(![commonComponents count])
		{
			// all the files have been trashed?
			return YES;
		}
		expectedDirName = [NSString iTM2_pathWithComponents:commonComponents];
		if([[NSURL fileURLWithPath:expectedDirName] iTM2_belongsToFactory])
		{
			iTM2_REPORTERROR(2,(@"Unexpected common components in the Writable Projects directory. Report a bug please."),nil);
		}
		//
		NSURL * projectDirURL = [projectURL iTM2_enclosingWrapperURL];
		projectDirURL = [projectDirURL iTM2_parentDirectoryURL];
		projectDirURL = [projectDirURL iTM2_URLByRemovingFactoryBaseURL];
		
		NSString * projectDirName = [projectDirURL path];
		if([expectedDirName iTM2_pathIsEqual:projectDirName])
		{
			// there is absolutely no need to move the project
			// just update the moved files
			E = [oldMovedURLs keyEnumerator];
			while(key = [E nextObject])
			{
				[self setURL:[oldMovedURLs objectForKey:key] forFileKey:key];
			}
			if([oldMovedURLs count])
			{
				[self saveDocument:self];
			}
			return YES;
		}
		// I should move the project to follow the files it contains
		NSString * src = [[projectURL iTM2_enclosingWrapperURL] path];
		NSString * dest = [SDC iTM2_wrapperPathExtension];
		dest = [requiredCore stringByAppendingPathExtension:dest];
		dest = [expectedDirName stringByAppendingPathComponent:dest];
		dest = [[NSURL iTM2_URLWithPath:dest relativeToURL:[NSURL iTM2_factoryURL]] path];
		if([DFM movePath:src toPath:dest handler:NULL])
		{
			// also change the receiver's file name
			name = [[projectURL path] iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:src];
			name = [dest stringByAppendingPathComponent:name];
			[self setFileURL:[NSURL fileURLWithPath:name]];
			allKeys = [self fileKeys];
			for(key in allKeys)
			{
				url = [self URLForFileKey:key];
				if([DFM fileExistsAtPath:[url path]])
				{
					[self setURL:url forFileKey:key];
				}
				else if(url = [oldExistingURLs objectForKey:key])
				{
					[self setURL:url forFileKey:key];
				}
				else if(url = [oldMovedURLs objectForKey:key])
				{
					[self setURL:url forFileKey:key];
				}
				else if(url = [oldFactoryURLs objectForKey:key])
				{
				}
			}
			[self saveDocument:self];
			src = [src stringByDeletingLastPathComponent];
			[SWS noteFileSystemChanged:src];
			dest = [dest stringByDeletingLastPathComponent];
			[SWS noteFileSystemChanged:dest];
			return YES;
		}
		else
		{
			iTM2_REPORTERROR(3,([NSString stringWithFormat:@"Problem %@ could not be moved to %@",src,dest]),nil);
		}
		return YES;
	}
	// the project has changed
	NSURL * oldProjectDirURL = [oldProjectURL iTM2_parentDirectoryURL];
	oldProjectDirURL = [oldProjectDirURL iTM2_URLByRemovingFactoryBaseURL];
	if([oldMissingURLs count])
	{
		// can I catch a file name for that?
		// I assume that only the files not in the faraway wrapper need to be retrieved
		E = [[oldMissingURLs allObjects] objectEnumerator];
		while(key = [E nextObject])
		{
			url = [SPC URLForFileKey:key filter:iTM2PCFilterRegular inProjectWithURL:oldProjectURL];
			if([DFM fileExistsAtPath:[url path]])
			{
				[oldExistingURLs setObject:url forKey:key];
				[oldMissingURLs removeObject:key];
			}
		}
	}
	[self saveDocument:self];
	goto changeName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixWritableProjectConsistency
- (BOOL)fixWritableProjectConsistency;
/*"Once this method is complete,we can assume that the receiver is properly located.
This means for example that the file moves have been properly tracked.
We assume that the root directory is the master file's directory,
in case of an external project of course. A project should not include documents higher in the hierarchy.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * projectURL = [self fileURL];
	if(![projectURL iTM2_belongsToFactory])
	{// this is not an external project: do nothing
		return NO;
	}
	if([[self mutableSubdocuments] count])
	{
		return YES;// do nothing because things are already in use,don't want to break
	}
	if(![DFM isWritableFileAtPath:[projectURL path]])
	{// we can't do everything we want
		return YES;
	}
	// this is a critical method
	// the first diagnostic determines whether the project is consistent or not
	// We assume that projects are consistent in general such that we do not merge actions
	// A project is consistent if all its file keys are honoured,
	// which means that there is a file at the URL for all the file keys.
	// Testing for the keys, shallow consistency.
	NSArray * allKeys = [self fileKeys];
	NSString * key = nil;
	NSURL * URL = nil;
	for(key in allKeys)// this is too early?
	{
		if(![SPC isReservedFileKey:key])
		{
			URL = [self URLForFileKey:key];
			if([URL isFileURL] && ![DFM fileExistsAtPath:[URL path]])
			{
				return [self _fixWritableProjectConsistency];
			}
		}
	}
	// Project file name
	NSURL * url = [SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL];
	if(![url iTM2_isEquivalentToURL:projectURL])
	{
		// the project has most certainly moved
		return [self _fixWritableProjectConsistency];
	}
	url = [SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAbsoluteLink inProjectWithURL:projectURL];
	if(![url iTM2_isEquivalentToURL:projectURL])
	{
		// the project has most certainly moved
		return [self _fixWritableProjectConsistency];
	}
	// the project has not moved, test for the file names
	allKeys = [self fileKeys];
	for(key in allKeys)
	{
		if(![SPC isReservedFileKey:key])
		{
			url = [self URLForFileKey:key];
			if([URL isFileURL] && ![DFM fileExistsAtPath:[url path]])
			{
				url = [self factoryURLForFileKey:key];
				if([URL isFileURL] && ![DFM fileExistsAtPath:[url path]])
				{
					url = [self recordedURLForFileKey:key];
					if([URL isFileURL] && [DFM fileExistsAtPath:[url path]])
					{
						// a file has most certainly moved
						return [self _fixWritableProjectConsistency];
					}
				}
			}
		}
	}
	// 
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixInternalProjectConsistency
- (BOOL)fixInternalProjectConsistency;
/*"If the project is the only project of a wrapper,synchronize the names of the project and its enclosing wrapper.
If the project is not a wrapper,there is a risk that things have been messed up.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * projectURL = [self fileURL];
	if(projectURL == nil)
	{// the receiver has no file name yet,we can't do anything serious
		return NO;// we are definitely pesimistic.
	}
	NSEnumerator * E = nil;
	NSString * key = nil;
	NSString * name = nil;
	NSURL * url = nil;
	NSArray * allKeys = [self fileKeys];
	NSURL * enclosingWrapperURL = [projectURL iTM2_enclosingWrapperURL];
	NSString * previousProjectDirectory = nil;
	NSString * actualProjectDirectory = nil;
	NSMutableArray * inconsistentKeys = [NSMutableArray array];
	if(enclosingWrapperURL)
	{
		// the project does belong to a wrapper
		// was the project moved around?
		previousProjectDirectory = [[SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL] path];
		previousProjectDirectory = [previousProjectDirectory stringByDeletingLastPathComponent];
		actualProjectDirectory = [[projectURL path] stringByDeletingLastPathComponent];
		if([actualProjectDirectory iTM2_pathIsEqual:previousProjectDirectory])
		{
			// simply list the registered files and see if things were inadvertantly broken...
			for(key in allKeys)
			{
				if(![SPC isReservedFileKey:key])
				{
					if((url = [self URLForFileKey:key]),[DFM fileExistsAtPath:[url path]])
					{
						// do nothing
					}
					else if((url = [self recordedURLForFileKey:key]),[DFM fileExistsAtPath:[url path]])
					{
						[self setURL:url forFileKey:key];
					}
					else if((name = [self nameForFileKey:key]),[name length])
					{
						iTM2_LOG(@"Project\n%@\nLost file\n%@",projectURL,name);
					}
					else
					{
						[inconsistentKeys addObject:key];
					}
				}
			}
			goto cleanKeys;
		}
		else
		{// the project has been moved, things might be more delicate to handle
			E = [[self fileKeys] objectEnumerator];
			while(key = [E nextObject])
			{
				if(![SPC isReservedFileKey:key])
				{
					if((url = [self URLForFileKey:key]),[DFM fileExistsAtPath:[url path]])
					{
						//do nothing;
					}
					else if((url = [self recordedURLForFileKey:key]),[DFM fileExistsAtPath:[url path]])
					{
						[self setURL:url forFileKey:key];
					}
					else if((name = [self nameForFileKey:key]),[name length])
					{
						iTM2_LOG(@"Project\n%@\nLost file\n%@",projectURL,name);
					}
					else
					{
						[inconsistentKeys addObject:key];
					}
				}
			}
		}
		// the project belongs to a wrapper,synchronize the names if it makes sense
		NSArray * enclosed = [enclosingWrapperURL iTM2_enclosedProjectURLs];
		if([enclosed count] == 1)
		{
			//Synchronize the project name and the wrapper name
			NSString * required = [[enclosingWrapperURL path] lastPathComponent];
			required = [required stringByDeletingPathExtension];
			required = [required stringByAppendingPathExtension:[[projectURL path] pathExtension]];
			required = [[[projectURL path] stringByDeletingLastPathComponent] stringByAppendingPathComponent:required];
			if(![required iTM2_pathIsEqual:[projectURL path]])// Contents directory?
			{
				if([DFM movePath:[projectURL path] toPath:required handler:nil])
				{
					NSURL * url = [NSURL fileURLWithPath:required];
					[self setFileURL:url];
					[self saveDocument:self];
				}
				else
				{
					iTM2_LOG(@"Could not move %@ to %@...");
				}
			}
		}
		goto cleanKeys;
	}
	// the project does not belong to a wrapper
	// list the included files and verify they are where they are expected to be...
	// did the project move since the last date it was saved?
	// If the use moves the project file whereas it is not open in iTeXMac2
	// iTeXMac2 won't be aware of the change
	// But the change will be tracked by the alias cached in the project itself
	previousProjectDirectory = [[SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL] path];
	previousProjectDirectory = [previousProjectDirectory stringByDeletingLastPathComponent];
	actualProjectDirectory = [[projectURL path] stringByDeletingLastPathComponent];
	if([actualProjectDirectory iTM2_pathIsEqual:previousProjectDirectory])
	{
		// simply list the registered files and see if things were inadvertantly broken...
		for(key in allKeys)
		{
			if(![SPC isReservedFileKey:key])
			{
				if((url = [self URLForFileKey:key]),[DFM fileExistsAtPath:[url path]])
				{
					// do nothing;
				}
				else if(url = [self recordedURLForFileKey:key])
				{
					[self setURL:url forFileKey:key];
				}
				else if([(name = [self nameForFileKey:key]) length])
				{
					iTM2_LOG(@"Project\n%@\nLost file\n%@",projectURL,name);
				}
				else
				{
					[inconsistentKeys addObject:key];
				}
			}
		}
		goto cleanKeys;
	}
	else if([DFM fileExistsAtPath:previousProjectDirectory])
	{
		// do nothing: the project might have been duplicated
	}
	else
	{// the project has been moved,things are delicate
		allKeys = [self fileKeys];
		for(key in allKeys)
		{
			if(![SPC isReservedFileKey:key])
			{
				if([DFM fileExistsAtPath:[(url = [self URLForFileKey:key]) path]])
				{
					// do nothing;
				}
				else if(url = [self recordedURLForFileKey:key])
				{
					[self setURL:url forFileKey:key];
				}
				else if([(name = [self nameForFileKey:key]) length])
				{
					iTM2_LOG(@"Project\n%@\nLost file\n%@",projectURL,name);
				}
				else
				{
					[inconsistentKeys addObject:key];
				}
			}
		}
	}
//iTM2_END;
cleanKeys:
	for(key in inconsistentKeys)
	{
		[self removeFileKey:key];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixProjectConsistency
- (BOOL)fixProjectConsistency;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self subdocuments] count])
	{
		return YES;// do nothing because things are already in use, don't want to break
	}
//iTM2_END;
	return [self fixWritableProjectConsistency] || [self fixInternalProjectConsistency];
}
#pragma mark =-=-=-=-=-  UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeWindowControllers
- (void)makeWindowControllers;
/*"Projects are no close documents!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self windowControllers] count])
	{
		return;
	}
    [super makeWindowControllers];// after the documents are open
    [self addGhostWindowController];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allowsSubdocumentsInteraction
- (BOOL)allowsSubdocumentsInteraction;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil == [[self implementation] metaValueForKey:@"is opening subdocuments"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWindows
- (void)showWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super showWindows];
    if(![self contextBoolForKey:@"iTM2DontOpenSubdocumentsWindow" domain:iTM2ContextAllDomainsMask])
    {
        NS_DURING;
        NSArray * previouslyOpenDocuments = [self contextValueForKey:iTM2ContextOpenDocuments domain:iTM2ContextAllDomainsMask];
        if(iTM2DebugEnabled>1000)
        {
            iTM2_LOG(@"The documents to be opened are:%@",previouslyOpenDocuments);
        }
		[[self implementation] takeMetaValue:[NSNull null] forKey:@"is opening subdocuments"];
        NSString * K;
        for(K in previouslyOpenDocuments)
		{
			NSError * localError = nil;
            if(![self openSubdocumentForKey:K display:YES error:&localError] && localError)
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Problem opening file at\n%@",[self nameForFileKey:K]]),localError);
			}
		}
        NS_HANDLER
        iTM2_LOG(@"***  CATCHED exception:%@",[localException reason]);
        NS_ENDHANDLER
		[[self implementation] takeMetaValue:nil forKey:@"is opening subdocuments"];
    }
	[self setShouldCloseWhenLastSubdocumentClosed:YES];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeWindowController:
- (void)removeWindowController:(NSWindowController *)windowController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super removeWindowController:windowController];
	[self closeIfNeeded];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addWindowController:
- (void)addWindowController:(NSWindowController *)windowController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// this trick is used to force the gost window controller to always be the last in the list
	// that way,the ghost window is not used when sheets are to be displayed.
	id GWC = [IMPLEMENTATION metaValueForKey:@"_GWC"];
	if(GWC)
	{
		[super removeWindowController:GWC];
		[super addWindowController:windowController];
		[super addWindowController:GWC];
	}
	else
	{
		[super addWindowController:windowController];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addGhostWindowController
- (void)addGhostWindowController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id GWC = [IMPLEMENTATION metaValueForKey:@"_GWC"];
	if(!GWC)
	{
		iTM2ProjectGhostWindow * W = [[[iTM2ProjectGhostWindow alloc]
            initWithContentRect:NSMakeRect(10,60,50,50)
                styleMask:NSTitledWindowMask
                    backing:NSBackingStoreNonretained
                        defer:YES] autorelease];
        if(iTM2DebugEnabled<1000)
            [W setFrameOrigin:NSMakePoint(15000,15000)];
		GWC = [[[NSWindowController alloc] initWithWindow:W] autorelease];
		[self addWindowController:GWC];
		[IMPLEMENTATION takeMetaValue:GWC forKey:@"_GWC"];
		[[GWC window] setExcludedFromWindowsMenu:YES];
		[[GWC window] orderFront:self];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeDefaultInspector
- (void)makeDefaultInspector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self windowControllers] count] && ![[self mutableSubdocuments] count])
    {
        [self makeSubdocumentsInspector];
        if(![[self windowControllers] count])
        {
			iTM2_REPORTERROR(1,@"NO DEFAULT WINDOW: I don't know what to do!!!\nPerhaps a missing plug-in?",nil);
        }
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showSubdocuments:
- (void)showSubdocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self makeSubdocumentsInspector];
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    NSWindowController * WC;
    while(WC = [E nextObject])
        if([WC isKindOfClass:[iTM2SubdocumentsInspector class]])
        {
            [[WC window] makeKeyAndOrderFront:self];
            return;
        }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showSettings:
- (void)showSettings:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dissimulateWindows
- (void)dissimulateWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
	if(otherAlpha<0.01)
	{
		otherAlpha = 0.01;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	else if(otherAlpha>1)
	{
		otherAlpha = 1;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	NSHashTable * windows = [[self implementation] metaValueForKey:@"_WindowsMarkedWithTransparency"];
	if(!windows)
	{
		windows = [NSHashTable hashTableWithWeakObjects];
		[[self implementation] takeMetaValue:windows forKey:@"_WindowsMarkedWithTransparency"];
	}
	for (NSWindow * W in [NSApp windows])
	{
		if([SPC projectForSource:W] == self)
		{
			if(![windows containsObject:W])
			{
				[windows addObject:W];
				[W setAlphaValue:[W alphaValue]*otherAlpha];
				[[W contentView] setNeedsDisplay:YES];
			}
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  exposeWindows
- (void)exposeWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
	if(otherAlpha<0.01)
	{
		otherAlpha = 0.01;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	else if(otherAlpha>1)
	{
		otherAlpha = 1;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	NSHashTable * windows = [[self implementation] metaValueForKey:@"_WindowsMarkedWithTransparency"];
	for(NSWindow * W in [NSApp windows])
	{
		if([SPC projectForSource:W] == self)
		{
			if([windows containsObject:W])
			{
				[W setAlphaValue:[W alphaValue]/otherAlpha];
				[[W contentView] setNeedsDisplay:YES];
			}
		}
	}
	[[self implementation] takeMetaValue:nil forKey:@"_WindowsMarkedWithTransparency"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  miniaturizeWindows
- (void)miniaturizeWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
	NSWindow * W;
	while(W = [E nextObject])
		if(self == [SPC projectForSource:W])
		{
//iTM2_LOG(@"miniaturize for project:%@",self);
			[W miniaturize:self];
		}

//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  DOCUMENT MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeSubdocumentsInspector
- (void)makeSubdocumentsInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self subdocumentsInspector];
    if(![[self windowControllers] count])
    {
        iTM2_REPORTERROR(1,@"NO DEFAULT WINDOW: I don't know what to do!!!\nPerhaps a missing plug-in?",nil);
    }
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  HELPERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  helper
- (id)helper;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentsInspector
- (id)subdocumentsInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self inspectorAddedWithMode:[iTM2SubdocumentsInspector inspectorMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareSubdocumentsFixImplementation
- (void)prepareSubdocumentsFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setMutableSubdocuments:[NSMutableSet set]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSubdocument:
- (void)addSubdocument:(id)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!document || (document == self)|| [document isKindOfClass:[iTM2WrapperDocument class]]|| [document isKindOfClass:[iTM2ProjectDocument class]])
		return;
	id projectDocument = [SPC projectForURL:[document fileURL]];
	// beware , the next assertion does not fit with autosave feature
#warning BUG: !!! PROBLEM
	// problem: save a tex file as, open this saved as file, add this newly opened file to the original project: PROBLEM
	NSAssert3(!projectDocument || (projectDocument == self),@"The document <%@> cannot be assigned to project <%@> because it already belongs to another project <%@>",[document fileName],[self fileName],[projectDocument fileName]);
	NSAssert1(![[SDC documents] containsObject:document],@"The document <%@> must not belong to the project controller.",[document fileName]);
	[[self mutableSubdocuments] addObject:document];// added into a set,no effect if the object is already there...
	[self newFileKeyForURL:[document fileURL]];
	NSString * key = [self fileKeyForSubdocument:document];// create the appropriate binding as side effect
	NSAssert([key length],@"Missing key for a document...");
	[SPC setProject:self forDocument:document];
	if(![self isEqual:[SPC projectForSource:document]])
	{
		[SPC flushCaches];
		[SPC setProject:self forDocument:document];
		if(![self isEqual:[SPC projectForSource:document]])
		{
			iTM2_LOG(@".........  ERROR:There is a really big problem,the SPC does not want to link a document and its project");
		}
	}
	[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ownsSubdocument:
- (BOOL)ownsSubdocument:(id)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	id subdocument;
	while(subdocument = [E nextObject])
		if(subdocument == document)
			return YES;
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forgetSubdocument:
- (void)forgetSubdocument:(id)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self mutableSubdocuments] containsObject:document])
    {
		[[document retain] autorelease];
        [[self mutableSubdocuments] removeObject:document];
		[SPC setProject:nil forDocument:document];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
    }
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  closeSubdocument:
- (void)closeSubdocument:(id)document;
/*"Description forthcoming.This is the preferred method
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self mutableSubdocuments] containsObject:document])
    {
		[document saveContext:nil];
		[self forgetSubdocument:document];
		[self closeIfNeeded];
    }
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSubdocument:
- (void)removeSubdocument:(id)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self mutableSubdocuments] containsObject:document])
    {
		[[document retain] autorelease];
		NSString * key = [self fileKeyForSubdocument:document];
		[self removeFileKey:key];
        [[self mutableSubdocuments] removeObject:document];
		[SPC setProject:nil forDocument:document];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
    }
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveSubdocuments:
- (void)saveSubdocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self mutableSubdocuments] makeObjectsPerformSelector:@selector(saveDocument:) withObject:sender];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:
- (void)canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
/*"If the receiver can close,it asks its project documents to close.
The problem is to manage asynchronous methods.
We override the standard -canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:method.
We create an invocation to retrieve the standard flow.
Then we call the inherited method for our own selector.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"delegate is:%@,shouldCloseSelector is:%@,contextInfo is:%#x",delegate,NSStringFromSelector(shouldCloseSelector),contextInfo);
#if 0
    if([self isDocumentEdited])
	{
		// order front the first project window found in the list,except the ghost window
		// this front window will be used for the save sheet
		NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * W;
		while(W = [E nextObject])
		{
			if(![W isKindOfClass:[iTM2ProjectGhostWindow class]])
			{
				NSWindowController * WC = [W windowController];
				if([WC document] == self))
				{
					[W orderFront:self];
					goto theEnd;
				}
			}
		}
	    [self showSubdocuments:self];
	}
#elif 1
	// there is a problem with the window.
	// if we do nothing the sheet won't display from the correct window.
	if([self isDocumentEdited])
	{
		// try to order some project window front
		// get the first window except the ghost window,order it front
		NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * W = nil;
		while(W = [E nextObject])
		{
			if([[[W windowController] document] isEqual:self] && ![W isKindOfClass:[iTM2ProjectGhostWindow class]])
			{
				goto orderFront;
			}
		}
		W = [[self subdocumentsInspector] window];
orderFront:
		[W orderFront:self];
	}
#endif
 	NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
	if(MS)
	{
		NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
		[I retainArguments];
		[I setArgument:&self atIndex:2];
		[I setTarget:delegate];
		[I setSelector:shouldCloseSelector];
		if(contextInfo)
			[I setArgument:&contextInfo atIndex:4];
		[super canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__project:shouldCloseProject:shouldCloseInvocation:)contextInfo:[I retain]];
//iTM2_END;
		return;
	}
	iTM2_LOG(@"A delegate is expected to implement a should close selector:\ndelegate; %@\nselector:%@",delegate,NSStringFromSelector(shouldCloseSelector));
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __project:shouldCloseProject:shouldCloseInvocation:
- (void)__project:(NSDocument *)doc shouldCloseProject:(BOOL)shouldClose shouldCloseInvocation:(NSInvocation *)invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"invocation is:%@",invocation);
	if(shouldClose && ([[self mutableSubdocuments] count]))
	{
		[self canCloseAllSubdocumentsWithDelegate:self shouldCloseSelector:@selector(__project:shouldCloseAllSubdocuments:shouldCloseInvocation:)contextInfo:(void *)invocation];
    }
	else
	{
		[invocation autorelease];
		[invocation setArgument:&shouldClose atIndex:3];// there is a problem of range "parameter index 3 not in range (-1,2)",nonsense! now "parameter index 3 not in range (-1,3)"
		[invocation invoke];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __project:shouldCloseAllSubdocuments:shouldCloseInvocation:
- (void)__project:(id)project shouldCloseAllSubdocuments:(BOOL)shouldCloseAll shouldCloseInvocation:(NSInvocation *)invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[invocation autorelease];
	[invocation setArgument:&shouldCloseAll atIndex:3];
    [invocation invoke];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCloseAllSubdocumentsWithDelegate:shouldCloseSelector:contextInfo:
- (void)canCloseAllSubdocumentsWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"delegate is:%@,shouldCloseSelector is:%@,contextInfo is:%#x",delegate,NSStringFromSelector(shouldCloseSelector),contextInfo);
	NSSet * subdocuments = [self subdocuments];
	if([subdocuments count])
	{
		NSMutableDictionary * contextDictionary = [NSMutableDictionary dictionary];
		[contextDictionary setObject:[NSMutableArray arrayWithArray:[subdocuments allObjects]]
			forKey:@"Should close documents"];
		[self saveContext:nil];
		NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
		if(MS)
		{
			NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
			[I retainArguments];
			[I setArgument:&self atIndex:2];
			[I setTarget:delegate];
			[I setSelector:shouldCloseSelector];
			if(contextInfo)
				[I setArgument:&contextInfo atIndex:4];
			[contextDictionary setObject:I forKey:@"Invocation"];
		}
		else if(delegate)
		{
			iTM2_LOG(@"ERROR:The delegate is expected to implement %@",NSStringFromSelector(shouldCloseSelector));
		}
		id subdocument;
		for(subdocument in subdocuments)
		{
			[subdocument canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__subdocument:shouldClose:contextDictionary:)contextInfo:[contextDictionary retain]];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __subdocument:shouldClose:contextDictionary:
- (void)__subdocument:(NSDocument *)doc shouldClose:(BOOL)shouldClose contextDictionary:(NSMutableDictionary *)contextDictionary;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[doc fileName] is:%@,contextInfo is:%#x",[doc fileName],contextInfo);
    [contextDictionary autorelease];// Compensates the retains
	if(!shouldClose)
        [contextDictionary setObject:[NSNumber numberWithBool:YES]
			forKey:@"There are edited project documents"];
    NSMutableArray * MRA = [contextDictionary objectForKey:@"Should close documents"];
    [MRA removeObject:doc];
    if([MRA count] == 0)
    {
        NSInvocation * I = [[contextDictionary objectForKey:@"Invocation"] retain];
    //iTM2_LOG(@"PURE RETAIN? %i",[self retainCount]);
        shouldClose = shouldClose&&![[contextDictionary objectForKey:@"There are edited project documents"] boolValue];
        [I setArgument:&shouldClose atIndex:3];
        [I invoke];
		[I release];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteWillClose
- (void)projectCompleteWillClose;
/*"Description forthcoming.
We have two different situations.
In the first one,the documents will be closed by the document controller,
in the second one,the project is responsible for closing the docs.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self saveContext:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentWillClose
- (void)documentWillClose;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super documentWillClose];
	[[self subdocuments] makeObjectsPerformSelector:@selector(close)];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentMightHaveClosed
- (void)subdocumentMightHaveClosed;
/*"Description forthcoming.
We have two different situations.
In the first one,the documents will be closed by the document controller,
in the second one,the project is responsible for closing the docs.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SPC flushCaches];
	[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
//iTM2_END;
    return;
}
//In the standard cocoa,closing a project document can cause the sub documents to be closed too despite they are edited
//The following is a workaround but the document controller subclassing is a better approach...
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDocumentEdited
- (BOOL)isDocumentEdited;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id O;
	NSEnumerator * E;
	if([SUD boolForKey:@"iTM2ApplicationIsTerminating"])// this is YES when terminating,awful patch
	{
		E = [[self subdocuments] objectEnumerator];
		while(O = [E nextObject])
			if([O isDocumentEdited])
				return YES;
	}
	E = [[self windowControllers] objectEnumerator];
	while(O = [E nextObject])
		if([O isWindowLoaded] && [[O window] isDocumentEdited])
			return YES;
    return [super isDocumentEdited];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocument:
- (BOOL)validateSaveDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self isDocumentEdited];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentsCompleteSaveContext:
- (void)subdocumentsCompleteSaveContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	NSDocument * D;
	while(D = [E nextObject])
	{
//		NSString * name = [[D fileName] lastPathComponent];
		[D saveContext:sender];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentForURL:
- (id)subdocumentForURL:(NSURL *)url;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	id D = nil;
	while(D = [E nextObject])
	{
		if([url iTM2_isEquivalentToURL:[D fileURL]])
		{
			return D;
		}
		if([url iTM2_isEquivalentToURL:[D originalFileURL]])
		{
			return D;
		}
		if([url iTM2_isEquivalentToURL:[self factoryURLForFileKey:[self fileKeyForSubdocument:D]]])
		{
			return D;
		}
	}
	E = [[self subdocuments] objectEnumerator];
	while(D = [E nextObject])
	{
		if([D childDocumentForURL:url])
		{
			return D;
		}
	}
    return nil;
}
#pragma mark =-=-=-=-=-  FILE <-> KEY
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeys
- (NSArray *)fileKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Apr 22 09:08:33 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self mainInfos] fileKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keysDidChange
- (void)keysDidChange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SPC flushCaches];
	[self removeFactory];
	[self updateChangeCount:NSChangeDone];
	[IMPLEMENTATION takeMetaValue:nil forKey:iTM2ProjectCachedKeysKey];// clean the cached keys
	
	NSEnumerator * E = [[self windowControllers] objectEnumerator];
	id WC;
	while(WC = [E nextObject])
	{
		if([WC respondsToSelector:@selector(updateOrderedFileKeys)])
		{
			[WC updateOrderedFileKeys];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  relativeFileNamesForKeys:
- (NSArray *)relativeFileNamesForKeys:(NSArray *)keys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [NSMutableArray array];
	NSString * key = nil;
	for(key in keys)
	{
		NSString * name = [self nameForFileKey:key];
		if([name length])
		{
			[result addObject:name];
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contentsURL
- (NSURL *)contentsURL;
/*"This is the directory where all the sources are expected to be collected.
This is cached and updated each time the file URL of the receiver changes.
It assumes that cocoa is smart enough to make all the chnages in the file URL through the setFileURL: method.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 08:04:30 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSURL * url = metaGETTER;
	id reentrant = [NSNull null];
	if([url isEqual: reentrant])
	{
		return nil;
	}
	if(url)
	{
		return url;
	}
	metaSETTER(reentrant);
	url = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[self fileURL]];
	metaSETTER(url);
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  parentURL
- (NSURL *)parentURL;
/*"This is the directory where all the sources are expected to be collected.
This is cached and updated each time the file URL of the receiver changes.
It assumes that cocoa is smart enough to make all the chnages in the file URL through the setFileURL: method.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 08:04:30 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSURL * url = metaGETTER;
	id reentrant = [NSNull null];
	if([url isEqual: reentrant])
	{
		return nil;
	}
	if(url)
	{
		return url;
	}
	metaSETTER(reentrant);
	url = [SPC URLForFileKey:iTM2ParentKey filter:iTM2PCFilterRegular inProjectWithURL:[self fileURL]];
	metaSETTER(url);
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForFileKey:
- (NSURL *)URLForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 21 16:05:46 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [SPC URLForFileKey:key filter:iTM2PCFilterRegular inProjectWithURL:[self fileURL]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLsForFileKeys:
- (NSArray *)URLsForFileKeys:(NSArray *)keys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [NSMutableArray array];
	NSString * key = nil;
	for(key in keys)
	{
		NSURL * URL = [self URLForFileKey:key];
		if(URL)
		{
			[result addObject:URL];
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setURL:forFileKey:
- (NSURL *)setURL:(NSURL *)fileURL forFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self mainInfos] setURL:fileURL forFileKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  factoryURL
- (NSURL *)factoryURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSURL * url = metaGETTER;
	id reentrant = [NSNull null];
	if([url isEqual: reentrant])
	{
		return nil;
	}
	if(url)
	{
		return url;
	}
	metaSETTER(reentrant);
	url = [SPC URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:[self fileURL]];
	metaSETTER(url);
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeFactory
- (BOOL)removeFactory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * url = [self factoryURL];
	if([url isFileURL]) {
		NSString * factory = [url path];
		return [DFM removeFileAtPath:factory handler:nil];
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  factoryURLForFileKey:
- (NSURL *)factoryURLForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * relativeName = [self nameForFileKey:key];
//iTM2_END;
	NSURL * url = [NSURL iTM2_URLWithPath:relativeName relativeToURL:nil];
	if([url scheme])
	{
		// the relative name was in fact a full URL;
//iTM2_END;
		return url;
	}
	if([[relativeName pathExtension] isEqual:TWSFactoryExtension])
	{
		relativeName = [relativeName stringByDeletingPathExtension];
	}
//iTM2_END;
	return [NSURL iTM2_URLWithPath:relativeName relativeToURL:[self factoryURL]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForName:
- (NSString *)fileKeyForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self mainInfos] fileKeyForName:name];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameForFileKey:
- (NSString *)nameForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 21 21:39:25 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self mainInfos] nameForFileKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setName:forFileKey:
- (void)setName:(NSString *)name forFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 21 21:39:25 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![key length])
	{
		return;
	}
	if(![[self fileKeys] containsObject:key])
	{
		return;
	}
	NSString * 	old = [self nameForFileKey:key];
	if(![old iTM2_pathIsEqual:name])
	{
		[[self mainInfos] setName:name forFileKey:key];
		[IMPLEMENTATION takeMetaValue:nil forKey:iTM2ProjectCachedKeysKey];// clean the cached keys
		NSAssert3([key isEqualToString:[self fileKeyForName:name]],(@"AIE AIE INCONSITENT STATE %@,%@ != %@"),__iTM2_PRETTY_FUNCTION__,key,[self fileKeyForName:name]);
		[self keysDidChange];
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForURL:
- (NSString *)fileKeyForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(nil == fileURL)// untitled documents will go there
	{
		return nil;
	}
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
    if(nil == cachedKeys)
    {
        cachedKeys = [NSMutableDictionary dictionary];
        [IMPLEMENTATION takeMetaValue:cachedKeys forKey:iTM2ProjectCachedKeysKey];
    }
//iTM2_LOG(@"BEFORE cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	fileURL = [fileURL absoluteURL];
    NSString * result;
	if(result = [cachedKeys objectForKey:fileURL])
	{
		return result;
	}
	// Is it me?
	if([fileURL isEqual:[[self fileURL] absoluteURL]])
	{
		result = @".";
		[cachedKeys setObject:result forKey:fileURL];
		return result;
	}
//iTM2_LOG(@"fileName:%@",fileName);
//iTM2_LOG(@"path:%@",path);}
	// Here begins the hard work
	NSArray * Ks = [self fileKeys];
//iTM2_LOG(@"[self keyedNames]:%@",[self keyedNames]);
//iTM2_LOG(@"path: %@",path);
//iTM2_LOG(@"fileName: %@",fileName);
	for(result in Ks)
	{
		if([fileURL iTM2_isEquivalentToURL:[self URLForFileKey:result]])
		{
			[cachedKeys setObject:result forKey:fileURL];
			return result;
		}
	}
	// last chance if the file name is in the factory
	// this one should not be in use now
	if([fileURL iTM2_belongsToFactory])
	{
		for(result in Ks)
		{
			if([fileURL iTM2_isEquivalentToURL:[self factoryURLForFileKey:result]])
			{
				if(![[self fileKeyForURL:[fileURL iTM2_URLByRemovingFactoryBaseURL]] length])
				{
					[self setURL:fileURL forFileKey:result];
					[cachedKeys setObject:result forKey:fileURL];
					return result;
				}
			}
		}
	}
//iTM2_LOG(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForRecordedURL:
- (NSString *)fileKeyForRecordedURL:(NSURL *)fileURL;
/*"The purpose of this method is to find out what is the file URL previously represented by the key.
If some file has been moved around,we can loose its full path.
If the project has been duplicated but not the whole folder,things are partially broken.
Developer note:all the docs opened here are .texp files.
WE DO NOT change the state of the project. Clients of the method will make their own decisions.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	fileURL = [fileURL absoluteURL];
	NSURL * projectURL = [self fileURL];
	NSEnumerator * E = nil;
	NSString * K = nil;
	unsigned filter;
	NSURL * url = nil;
	filter = iTM2PCFilterAlias;
	E = [[SPC fileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	while(K = [E nextObject])
	{
		if([fileURL isEqual:[[SPC URLForFileKey:K filter:filter inProjectWithURL:projectURL] absoluteURL]])
		{
			return K;
		}
	}
	filter = iTM2PCFilterAbsoluteLink;
	E = [[SPC fileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	while(K = [E nextObject])
	{
		url = [[SPC URLForFileKey:K filter:filter inProjectWithURL:projectURL] absoluteURL];
		if([fileURL isEqual:url])
		{
			return K;
		}
	}
	filter = iTM2PCFilterRelativeLink;
	E = [[SPC fileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	while(K = [E nextObject])
	{
		url = [[SPC URLForFileKey:K filter:filter inProjectWithURL:projectURL] absoluteURL];
		if([fileURL isEqual:url])
		{
			return K;
		}
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordedURLForFileKey:
- (NSURL *)recordedURLForFileKey:(NSString *)aKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([aKey isEqualToString:TWSProjectKey] || [aKey isEqualToString:@"."])
	{
		return [self fileURL];
	}
	NSURL * url;
	if(url = [SPC URLForFileKey:aKey filter:iTM2PCFilterAlias inProjectWithURL:[self fileURL]])
	{
		if([DFM isPrivateFileAtPath:[url path]])
		{
			return nil;
		}
		if([DFM fileExistsAtPath:[url path]])
		{
			return url;
		}
	}
	if(url = [SPC URLForFileKey:aKey filter:iTM2PCFilterAbsoluteLink inProjectWithURL:[self fileURL]])
	{
		if([DFM isPrivateFileAtPath:[url path]])
		{
			return nil;
		}
		if([DFM fileExistsAtPath:[url path]])
		{
			return url;
		}
	}
	if(url = [SPC URLForFileKey:aKey filter:iTM2PCFilterRelativeLink inProjectWithURL:[self fileURL]])
	{
		if([DFM isPrivateFileAtPath:[url path]])
		{
			return nil;
		}
		if([DFM fileExistsAtPath:[url path]])
		{
			return url;
		}
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newFileKeyForURL:fileContext:
- (NSString *)newFileKeyForURL:(NSURL *)fileURL fileContext:(NSDictionary *)context;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [self newFileKeyForURL:fileURL];
	if([key length])
	{
		return key;
	}
	key = [context objectForKey:iTM2ProjectFileKeyKey];
	if([key isKindOfClass:[NSString class]] && [key length])
	{
		// is this key already registered?
		NSURL * alreadyURL = [self URLForFileKey:key];
		if(alreadyURL)
		{
			NSAssert(![[alreadyURL absoluteURL] isEqual:[fileURL absoluteURL]],@"You missed something JL... Shame on u");
			// yes it is
			// is it a copy or is it a move
			if([DFM fileExistsAtPath:[alreadyURL path]])
			{
				// it is a copy
				key = [self newFileKeyForURL:fileURL];
			}
			else
			{
				// it is a move
				// was it an absolute or a relative file name?
#warning NYI:I can't know  easily if the file name was absolute or relative...
				[self setURL:fileURL forFileKey:key];
			}
		}
		else
		{
			[self setURL:fileURL forFileKey:key];
		}
	}
	else
	{
		key = @"";
	}
	
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newFileKeyForURL:
- (NSString *)newFileKeyForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self newFileKeyForURL:fileURL save:NO];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newFileKeyForURL:save:
- (NSString *)newFileKeyForURL:(NSURL *)fileURL save:(BOOL)shouldSave;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(fileURL != nil,@"Unexpected void file name,please report bug");
	// is it an already registered file name?
    NSString * key = [self fileKeyForURL:fileURL];
	if([key length])
	{
		[self recordHandleToURL:fileURL];// just in case...
	// Are the corresponding link and alias up to date?
	//iTM2_LOG(@"key: %@,fileName: %@",key,fileName);
	//iTM2_LOG(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
		if(shouldSave)
		{
			[self saveDocument:nil];
		}
		NSAssert1([key isEqual:[self fileKeyForURL:fileURL]],(@"AIE AIE INCONSITENT STATE %@"),__iTM2_PRETTY_FUNCTION__);
		return key;
	}
	// it is not an already registered file name,as far as I could guess...
	key = [self fileKeyForRecordedURL:fileURL];
//iTM2_LOG(@"BEFORE cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	if([key length])
	{
		[self setURL:fileURL forFileKey:key];
		[self recordHandleToURL:fileURL];// just in case...
//iTM2_LOG(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
		if(shouldSave)
		{
			[self saveDocument:nil];
		}
//iTM2_LOG(@"fileName:%@",fileName);
//iTM2_LOG(@"[self keyedNames]:%@",[self keyedNames]);
//iTM2_LOG(@"[self fileKeyForURL:fileName]:%@",[self fileKeyForURL:fileName]);
		NSAssert1([key isEqual:[self fileKeyForURL:fileURL]],(@"AIE AIE INCONSITENT STATE %@"),__iTM2_PRETTY_FUNCTION__);
		return key;
	}
	// it is not an already registered file name,as far as I could guess...
	// the given file seems to be a really new one
	key = [[self mainInfos] nextAvailableKey];// WARNING!!! there once was a problem I don't understand here
	[self setURL:fileURL forFileKey:key];
	if(![key isEqualToString:[self fileKeyForURL:fileURL]])
	{
		[self fileKeyForURL:fileURL];// stop here for debugging
	}
	NSAssert2([key isEqualToString:[self fileKeyForURL:fileURL]],@"***  ERROR:[self fileKeyForURL:...] is %@ instead of %@",[self fileKeyForURL:fileURL],key);
	[self updateChangeCount:NSChangeDone];
	NSEnumerator * E = [[self windowControllers] objectEnumerator];
	id WC;
	while(WC = [E nextObject])
	{
		if([WC respondsToSelector:@selector(updateOrderedFileKeys)])
		{
			[WC updateOrderedFileKeys];
		}
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"the new key for %@ (fileName)",fileURL);
		iTM2_LOG(@"is %@ (key)",key);
	}
	[self recordHandleToURL:fileURL];// just in case...
// Are the corresponding link and alias up to date?
//iTM2_LOG(@"key: %@,fileName: %@",key,fileName);
//iTM2_LOG(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	if(shouldSave)
	{
		[self saveDocument:nil];
	}
    return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordHandleToURL:
- (void)recordHandleToURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self _recordHandleToURL:fileURL];
	NSURL * myURL = [self fileURL];
	if(![fileURL iTM2_isEqualToFileURL:myURL])
	{
		[self _recordHandleToURL:myURL];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _recordHandleToURL:
- (void)_recordHandleToURL:(NSURL *)fileURL;
/*"This is a central method. The purpose is to record some information about files associated to keys.
It will be used to test the project consistency, between to uses.
3 informations are recorded, a relative one, and 2 absolute ones.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 07:57:04 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM isWritableFileAtPath:[[self fileURL] path]])
	{
		// We are asked for an information that does not exist, do nothing
		return;
	}
	if([fileURL isFileURL])
	{
		NSString * fileName = [fileURL path];
		NSString * K = [self fileKeyForURL:fileURL];
		if([K length])
		{
			NSString * key = [K isEqualToString:@"."]?TWSProjectKey:K;
			BOOL isDirectory = NO;
			NSString * path = nil;
			NSString * projectName = [self fileName];
			NSString * base = nil;
			base = [SPC finderAliasesSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			if([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory
				|| [DFM iTM2_createDeepDirectoryAtPath:base attributes:nil error:nil])
			{
				if(![DFM fileExistsAtPath:(path = [base stringByAppendingPathComponent:@"Readme.txt"])])
				{
					[@"This directory contains finder aliases to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [base stringByAppendingPathComponent:key];
//iTM2_LOG(@"alias to fileName: %@",fileName);
//iTM2_LOG(@"stored at path: %@",path);
				[DFM removeFileAtPath:path handler:NULL];
				if([DFM fileExistsAtPath:[fileURL path]])
				{
					NSError * localError = nil;
					NSData * aliasData = [[fileURL path] iTM2_dataAliasRelativeTo:nil error:&localError];
					if(localError)
					{
						[SDC presentError:localError];
					}
					if(aliasData)
					{
						NSURL * url = [NSURL fileURLWithPath:path];
						if(![aliasData iTM2_writeAsFinderAliasToURL:url options:0 error:&localError])
						{
							if(localError)
							{
								[SDC presentError:localError];
							}
							else if(iTM2DebugEnabled)
							{
								[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
									userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write an alias to %@ at %@",fileName,path]
										forKey:NSLocalizedDescriptionKey]]];
							}
							else
							{
								iTM2_LOG(@"*** ERROR: Could not write an alias to %@ at %@ (report bug)",fileName,path);
							}
						}
						else if(iTM2DebugEnabled>200)
						{
#warning: there is a big problem here
							// the operation is not revertible
							NSAssert1((aliasData = [NSData iTM2_aliasDataWithContentsOfURL:url error:&localError]),@"Error: alias was just saved at %@",url);
							if(localError)
							{
								[SDC presentError:localError];
							}
							NSString * target = [aliasData iTM2_pathByResolvingDataAliasRelativeTo:nil error:&localError];
							if(localError)
							{
								[SDC presentError:localError];
							}
							NSAssert2([target iTM2_pathIsEqual:[fileName iTM2_lazyStringByResolvingSymlinksAndFinderAliasesInPath]],@"Error unexpected difference\n%@\nvs\n%@ (report bug)",fileName,target);
						}
					}
				}
			}
			else if(iTM2DebugEnabled)
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:2
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write alias information in\n%@",base]
						forKey:NSLocalizedDescriptionKey]]];
			}
			else
			{
				iTM2_LOG(@"Could not write alias information in\n%@",base);
			}
			base = [SPC absoluteSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			if([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory
				|| [DFM iTM2_createDeepDirectoryAtPath:base attributes:nil error:nil])
			{
				path = [base stringByAppendingPathComponent:@"Readme.txt"];
				if(![DFM fileExistsAtPath:path])
				{
					[@"This directory contains soft links to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [base stringByAppendingPathComponent:key];
//iTM2_LOG(@"fileName is: %@",fileName);
//iTM2_LOG(@"path is: %@",path);
				[DFM removeFileAtPath:path handler:NULL];
				if(![DFM iTM2_createSoftLinkAtPath:path pathContent:fileName])
				{
					if(iTM2DebugEnabled)
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create a symbolic link to %@ at %@",fileName,path]
								forKey:NSLocalizedDescriptionKey]]];
					}
					else
					{
						iTM2_LOG(@"*** ERROR: Could not create a symbolic link %@ at %@ (report bug)",fileName,path);
					}
				}
			}
			else if(iTM2DebugEnabled)
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write soft links information in\n%@",base]
						forKey:NSLocalizedDescriptionKey]]];
			}
			else
			{
				iTM2_LOG(@"Could not write soft links information in\n%@",base);
			}
			base = [SPC relativeSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			if([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory
				|| [DFM iTM2_createDeepDirectoryAtPath:base attributes:nil error:nil])
			{
				path = [base stringByAppendingPathComponent:@"Readme.txt"];
				if(![DFM fileExistsAtPath:path])
				{
					[@"This directory contains relative soft links to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [base stringByAppendingPathComponent:key];
//iTM2_LOG(@"fileName is: %@",fileName);
//iTM2_LOG(@"path is: %@",path);
				[DFM removeFileAtPath:path handler:NULL];
				NSString * dirName = [self fileName];
				dirName = [dirName stringByDeletingLastPathComponent];
				NSString * relativeFileName = [fileName iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:dirName];
				if(![DFM iTM2_createSoftLinkAtPath:path pathContent:relativeFileName])
				{
					if(iTM2DebugEnabled)
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create a symbolic link to %@ at %@",relativeFileName,path]
								forKey:NSLocalizedDescriptionKey]]];
					}
					else
					{
						iTM2_LOG(@"*** ERROR: Could not create a soft link %@ at %@ (report bug)",relativeFileName,path);
					}
				}
			}
			else if(iTM2DebugEnabled)
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write soft links information in\n%@",base]
						forKey:NSLocalizedDescriptionKey]]];
			}
			else
			{
				iTM2_LOG(@"Could not write soft links information in\n%@",base);
			}
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeFileKey:
- (void)removeFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDocument * document = [self subdocumentForFileKey:key];
	if(document)
	{
		[document canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__document:shouldRemove:key:) contextInfo:[key retain]];
	}
	else
	{
		[self _removeFileKey:key];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __document:shouldRemove:key:
- (void)__document:(NSDocument *)document shouldRemove:(BOOL)shouldClose key:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[key autorelease];
	if(shouldClose)
	{
		[document close];
		[self _removeFileKey:key];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _removeFileKey:
- (void)_removeFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"[self fileKeys] are:%@",[self fileKeys]);
	}
    [self setName:nil forFileKey:key];
    [[self mainInfos] setProperties:nil forFileKey:key];
    [[self keyedSubdocuments] takeValue:nil forKey:key];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"[self fileKeys] are:%@",[self fileKeys]);
	}
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
//iTM2_LOG(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
    [cachedKeys removeObjectsForKeys:[cachedKeys allKeysForObject:key]];
//iTM2_LOG(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
    [SPC flushCaches];
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    id WC;
    while(WC = [E nextObject])
        if([WC respondsToSelector:@selector(updateOrderedFileKeys)])
            [WC updateOrderedFileKeys];
	// then I remove all the references,either links or finder aliases,used as cache
	NSString * projectFileName = [[self fileURL] path];
	NSString * subdirectory = [projectFileName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
	NSString * path = [[subdirectory stringByAppendingPathComponent:key] stringByAppendingPathExtension:iTM2SoftLinkExtension];
	if([DFM fileExistsAtPath:path] && ![DFM removeFileAtPath:path handler:NULL])
	{
		iTM2_LOG(@"*** ERROR: I could not remove %@,please do it for me...",path);
	}
	subdirectory = [projectFileName stringByAppendingPathComponent:[SPC absoluteSoftLinksSubdirectory]];
	path = [[subdirectory stringByAppendingPathComponent:key] stringByAppendingPathExtension:iTM2SoftLinkExtension];
	if(([DFM fileExistsAtPath:path] || [DFM pathContentOfSymbolicLinkAtPath:path]) && ![DFM removeFileAtPath:path handler:NULL])
	{
		iTM2_LOG(@"*** ERROR: I could not remove %@,please do it for me...",path);
	}
	[self saveDocument:nil];
//iTM2_END
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addURL:
- (void)addURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 09:04:46 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL iTM2_isEquivalentToURL:[self fileURL]])
	{
		iTM2_LOG(@"I ignore:%@,it is the project",fileURL);            
	}
	else if([self fileKeyForURL:fileURL])
	{
		iTM2_LOG(@"I ignore: %@,it is already there",fileURL);
	}
	else if([self newFileKeyForURL:fileURL])
	{
		[self updateChangeCount:NSChangeDone];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
	else
	{
		iTM2_LOG(@"I ignore: %@,I don't want it...",fileURL);
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL*)url;
/*"Some projects are no close documents!!!
We must change the various caches.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 15:38:23 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// missing test for file extension
	NSURL * old = [self fileURL];
	if(![old isEqual:url])
	{
		// normalize the URL
		url = [url iTM2_normalizedURL];
		// CLEAN the cached data
		[SPC flushCaches];
		[[self implementation] takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(parentURL))];
		[[self implementation] takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(factoryURL))];
		[[self implementation] takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(contentsURL))];
		[super setFileURL:url];
		[[self mainInfos] setProjectURL:url error:nil];
		// We must also manage the file URLs of the subdocuments
		NSEnumerator * E = [[self subdocuments] objectEnumerator];
		NSDocument * document;
		while(document = [E nextObject])
		{
			NSURL * oldURL = [document fileURL];
			if([oldURL baseURL])
			{
				// the document is expected to follow the project
				// the relative path should remain unchanged
				// only the base URL changes
				// If the documents did not change with the project
				// then they may point to nothing it file system
				// The contentsURL might need some change
				// At first glance, the user will be given the opportunity to make the change by herself
				NSString * K = [self fileKeyForSubdocument:document];
				NSURL * newURL = [self URLForFileKey:K];
				[document setFileURL:newURL];
			}
		}
		return;
	}
    [super setFileURL:url];
    return;
}
#pragma mark =-=-=-=-=-  OPEN SUBDOCUMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSubdocumentWithContentsOfURL:context:display:outErrorPtr:
- (id)openSubdocumentWithContentsOfURL:(NSURL *)fileURL context:(NSDictionary *)context display:(BOOL)display error:(NSError**)outErrorPtr;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3:07/26/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outErrorPtr)
		* outErrorPtr = nil;
	if([fileURL iTM2_isEquivalentToURL:[self fileURL]])
	{
		if(display)
		{
			[self makeWindowControllers];
			[self showWindows];
		}
		return self;// this is when we open the wrapper
	}
	// I am not trying to open myself...
	if(![fileURL isFileURL])
	{// only file urls are supported
		return nil;
	}
	NSString * fileName = [fileURL path];
	if(![DFM fileExistsAtPath:fileName])
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"There is nothing at\n%@",fileName]),nil);
		return nil;
	}
	fileName = [fileName stringByResolvingSymlinksInPath];// and finder aliases?
	if([fileName iTM2_pathIsEqual:[self wrapperName]])
	{
		return self;// we should not get there!
	}
	// is it an already open document?
	// beware of the faraway project support
    NSEnumerator * E = [[self subdocuments] objectEnumerator];
    id doc;
    while(doc = [E nextObject])
    {
		NSURL * url = [doc fileURL];
		if([url isFileURL])
		{
			NSString * docName = [url path];
			docName = [docName iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
			if([docName iTM2_pathIsEqual:fileName])
			{
tahiti:
				if(display)
				{
					[doc makeWindowControllers];
					[doc showWindows];
				}
	//iTM2_END;
				[SDC noteNewRecentDocument:doc];
				return doc;
			}
		}
    }
	// Assign a key,if not already available
	if(!context)
	{
		context = [iTM2Document contextDictionaryFromURL:fileURL];
	}
	NSString * key = [self newFileKeyForURL:fileURL fileContext:context];
//iTM2_LOG(@"[self fileKeyForURL:fileName]:<%@>,key:%@",[self fileKeyForURL:fileName],key);
	if([key length])
	{
		fileURL = [self URLForFileKey:key];// normalize the URL as side effect
		[SPC setProject:self forURL:fileURL];// this is the weaker link project<->file name, the sooner, the better
		// Is it a document managed by iTeXMac2? Some document might need an external helper
		NSString * typeName = [SDC typeForContentsOfURL:fileURL error:outErrorPtr];
		if(!outErrorPtr && (doc = [SDC makeDocumentWithContentsOfURL:fileURL ofType:typeName error:outErrorPtr]))
		{
			[doc setFileURL:fileURL];
			[self addSubdocument:doc];
			if(UTTypeEqual((CFStringRef)typeName,(CFStringRef)iTM2WildcardDocumentType))
			{
				// this kind of documents can be managed by external helpers
				if(display)
				{
					NSString * bundleIdentifier = [self propertyValueForKey:@"Bundle Identifier" fileKey:key contextDomain:iTM2ContextAllDomainsMask];
					if(bundleIdentifier && (
						[SWS openURLs:[NSArray arrayWithObject:fileURL] withAppBundleIdentifier:bundleIdentifier options:0 additionalEventParamDescriptor:nil launchIdentifiers:nil]
						|| [SWS openURLs:[NSArray arrayWithObject:fileURL] withAppBundleIdentifier:nil options:0 additionalEventParamDescriptor:nil launchIdentifiers:nil]))
					{
						[SDC noteNewRecentDocument:doc];
						return doc;
					}
				}
			}
			if([doc readFromURL:fileURL ofType:typeName error:outErrorPtr])
			{
				goto tahiti;
			}
			[self removeSubdocument:doc];
		}
		[SPC setProject:nil forURL:fileURL];// no more linkage
//iTM2_LOG(@"INFO:Could open document %@",fileName);
		if(outErrorPtr)
		{
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"Cocoa could not create document at\n%@",fileURL]),(outErrorPtr?*outErrorPtr:nil));
		}
		return nil;
	}
	// is it an already registered document that changed its name?
	NSString * typeName = [SDC typeForContentsOfURL:fileURL error:outErrorPtr];
    if(!outErrorPtr && (doc = [SDC makeDocumentWithContentsOfURL:fileURL ofType:typeName error:outErrorPtr]))
    {
        [self addSubdocument:doc];
//iTM2_LOG(@"self:%@,has documents:%@",self,[self subdocuments]);
        goto tahiti;
    }
    else
    {
        iTM2_LOG(@"Sorry,I could not create a document for:%@ (1)",fileName);
    }
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSubdocumentForKey:display:outErrorPtr:
- (id)openSubdocumentForKey:(NSString *)key display:(BOOL)display error:(NSError**)outErrorPtr;
/*"Description forthhcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3:07/26/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outErrorPtr)
	{
		* outErrorPtr = nil;
	}
	// is it a document already open by the project
	id SD = [self subdocumentForFileKey:key];
	if(SD)
	{
		if(display)
		{
			[SD makeWindowControllers];
			[SD showWindows];
		}
		return SD;
	}
	// is it a document already open by the shared document controller
	// but not yet register to its project. This is not a natural situation...
	NSEnumerator * E = [[SDC documents] objectEnumerator];
	id D = nil;
	while(D = [E nextObject])
	{
		id P = [D project];// now the project should be properly set. reentrant problem here?
		if([P isEqual:self] && [key isEqualToString:[self fileKeyForURL:[D fileURL]]])
		{
			if(display)
			{
				[SD makeWindowControllers];
				[SD showWindows];
			}
			return SD;
		}
	}
	// I must open a new document
	NSURL * fileURL = [self URLForFileKey:key];
	NSURL * factoryURL = [self factoryURLForFileKey:key];
	BOOL onceMore = YES;
onceMore:
	if([DFM fileExistsAtPath:[fileURL path]])
	{
		if([factoryURL iTM2_isEquivalentToURL:fileURL])
		{
			// both are the same, this is the expected situation.
absoluteFileNameIsChosen:
			return [self openSubdocumentWithContentsOfURL:fileURL context:nil display:display error:outErrorPtr];
		}
		else if([DFM fileExistsAtPath:[factoryURL path]])
		{
			//Problem: there are 2 different candidates,which one is the best
			[SWS selectFile:[factoryURL path] inFileViewerRootedAtPath:[[factoryURL path] stringByDeletingLastPathComponent]];
			[SWS selectFile:[fileURL path] inFileViewerRootedAtPath:[[fileURL path] stringByDeletingLastPathComponent]];
			[NSApp activateIgnoringOtherApps:YES];
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"Which one do you want?",NSLocalizedDescriptionKey,
				[NSString stringWithFormat:@"1:%@\nor\n2:%@\n1 will be chosen unless you remove it now from the Finder.",fileURL,factoryURL],NSLocalizedRecoverySuggestionErrorKey,
					nil];
			[self presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3 userInfo:dict]];
			if(onceMore)
			{
				onceMore = NO;
				goto onceMore;
			}
			else
			{
				goto absoluteFileNameIsChosen;
			}
		}
		else
		{
			goto absoluteFileNameIsChosen;
		}
	}
	else if(fileURL)
	{
#warning TEST HERe
		if([DFM fileExistsAtPath:[factoryURL path]])
		{
			// I also choose the absolute file name.
			return [self openSubdocumentWithContentsOfURL:factoryURL context:nil display:display error:outErrorPtr];
		}
#warning Should I refuse directories as possible project subdocuments
		NSURL * recordedURL = [self recordedURLForFileKey:key];
		BOOL isDirectory;
		if([DFM fileExistsAtPath:[recordedURL path] isDirectory:&isDirectory] && !isDirectory)
		{
			if([[recordedURL path] iTM2_belongsToDirectory:[[self fileName] stringByDeletingLastPathComponent]])
			{
				[self setURL:recordedURL forFileKey:key];
				return [self openSubdocumentWithContentsOfURL:recordedURL context:nil display:display error:outErrorPtr];
			}
			else
			{
				// make a copy of the file
				if([DFM copyPath:[recordedURL path] toPath:[fileURL path] handler:NULL])
				{
					fileURL = [NSURL fileURLWithPath:[fileURL path]];
					return [self openSubdocumentWithContentsOfURL:fileURL context:nil display:display error:outErrorPtr];
				}
			}
		}
		if([factoryURL iTM2_isEquivalentToURL:fileURL])
		{
			// problem: no file available
			iTM2_OUTERROR(2,([NSString stringWithFormat:@"No file at\n%@",fileURL]),(outErrorPtr?*outErrorPtr:nil));
		}
		else
		{
			// problem: no files available
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"No file at\n%@\nnor\n%@",fileURL,factoryURL]),(outErrorPtr?*outErrorPtr:nil));
		}
	}
	// else the key does not correspond to a file,it has certainly been removed and we've been asked for a scorie.
//iTM2_END;
    return nil;
}
#pragma mark =-=-=-=-=-  DOCUMENT <-> KEY
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyedSubdocuments
- (id)keyedSubdocuments;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = metaGETTER;
    if(!result)
    {
        metaSETTER([NSMutableDictionary dictionary]);
        result = metaGETTER;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForSubdocument:
- (NSString *)fileKeyForSubdocument:(id)subdocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self ownsSubdocument:subdocument])
	{
		NSValue * V = [NSValue valueWithNonretainedObject:subdocument];
		NSString * result = [[[self keyedSubdocuments] allKeysForObject:V] lastObject];
		if(result)
		{
			return result;
		}
		NSURL * fileURL = [subdocument fileURL];
		result = [self fileKeyForURL:fileURL];
		if(![result length])
		{
			result = [self newFileKeyForURL:fileURL];
		}
		NSAssert2([result length],@"There is a patent inconsistency:the project\n%@\ndoes not want the subdocument\n%@",[self fileURL],fileURL);
		[[self keyedSubdocuments] takeValue:V forKey:result];
		return result;
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentForFileKey:
- (id)subdocumentForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [[[self keyedSubdocuments] objectForKey:key] nonretainedObjectValue];
	if([self ownsSubdocument:result])
		return result;
	[[self keyedSubdocuments] removeObjectForKey:key];
    return nil;
}
#pragma mark =-=-=-=-=-  PROPERTIES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertyValueForKey:fileKey:contextDomain:
- (id)propertyValueForKey:(NSString *)key fileKey:(NSString *)fileKey contextDomain:(unsigned int)mask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(key);
	NSParameterAssert(fileKey);
	id result = nil;
	id Ps = [[self mainInfos] propertiesForFileKey:fileKey];
	if(result = [Ps valueForKey:key])
	{
		return result;
	}
    return [self contextValueForKey:key fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPropertyValue:forKey:fileKey:contextDomain:
- (void)setPropertyValue:(id)property forKey:(NSString *)aKey fileKey:(NSString *)fileKey contextDomain:(unsigned int)mask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self mainInfos] setPropertyValue:property forKey:aKey fileKey:fileKey])
	{
		[self takeContextValue:property forKey:aKey domain:mask];
		[self updateChangeCount:NSChangeDone];
	}
    return;
}
#pragma mark =-=-=-=-=- I/O
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToFile:ofType:originalFile:saveOperation:
//- (BOOL)writeToFile:(NSString *)fullDocumentPath ofType:(NSString *)documentTypeName originalFile:(NSString *)fullOriginalDocumentPath saveOperation:(NSSaveOperationType)saveOperation;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSafelyToURL:ofType:forSaveOperation:error:
//- (BOOL)writeWithBackupToFile:(NSString *)fullProjectPath ofType:(NSString *)docType saveOperation:(NSSaveOperationType)saveOperation;
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outErrorPtr;
//- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outErrorPtr
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"Only file URLs are supported,no:\n%@",absoluteURL]),nil);
		return NO;
	}
	BOOL result = [super writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr];
	if(!result)
	{
		iTM2_LOG(@"WHAT CAN I DO,no save possible...%@",(outErrorPtr?(id)(*outErrorPtr):@"NOTHING"));
	}
	NSString * fullProjectPath = [absoluteURL path];
#warning DEBUG
	BOOL isDirectory = NO;
	if([DFM fileExistsAtPath:fullProjectPath isDirectory:&isDirectory] && !isDirectory)
	{
		iTM2_LOG(@"*** TEST: what the hell,I want to change the current directory to %@",fullProjectPath);
	}
	if(saveOperation == NSSaveOperation)
	{
		// just save the subdocuments where they normally stand...
		NSEnumerator * E = [[self subdocuments] objectEnumerator];
		NSDocument * D;
		while(D = [E nextObject])
		{
			if([D isDocumentEdited])
			{
				NSLock * L = [[[NSLock alloc] init] autorelease];
				[L lock];
				NSURL * url = [[[D fileURL] retain] autorelease];
				NSString * fileType = [D fileType];
				if([D writeSafelyToURL:url ofType:fileType forSaveOperation:saveOperation error:outErrorPtr])
//				if([D writeToURL:url ofType:fileType forSaveOperation:saveOperation originalContentsURL:url error:outErrorPtr])
				{
					[D updateChangeCount:NSChangeCleared];
#if 1
		// COMMENT: if we put this trick here, then the document has lost its own name...and gets tagged as untitled
		// this trick is for the "document lost its FSRef" problem
		// when in continuous typesetting mode,
		// we cannot save transparently
		// the document has the expected file name and url but some internals are broken
		// such that the internals no longer make the URL point to the proper file node
		NSURL * url = [self fileURL];
		[self setFileURL:nil];
		[self setFileURL:url];
#endif
				}
				else
				{
					iTM2_LOG(@"*** FAILURE: document could not be saved at:\n%@",[D fileURL]);
					result = NO;
				}
				[L unlock];
			}
		}
	}
	else if(saveOperation == NSSaveAsOperation)
	{
		// just save the subdocuments where they normally stand...
		NSEnumerator * E = [[self subdocuments] objectEnumerator];
		NSDocument * D;
		while(D = [E nextObject])
		{
			NSString * key = [self fileKeyForSubdocument:D];
			NSString * name = [self nameForFileKey:key];
			if([name hasPrefix:@".."])
			{
				[self setURL:[D fileURL] forFileKey:key];
			}
			else
			{
				[D setFileURL:[self URLForFileKey:key]];
			}
			if([D isDocumentEdited])
			{
				if([D writeSafelyToURL:[D fileURL] ofType:[D fileType] forSaveOperation:saveOperation error:outErrorPtr])
				{
					[D updateChangeCount:NSChangeCleared];
				}
				else
				{
					iTM2_LOG(@"*** FAILURE: document for key %@ could not be saved",key);
					[D updateChangeCount:NSChangeCleared];
					result = NO;
				}
			}
		}
	}
	else if(saveOperation == NSSaveToOperation)
	{
		NSEnumerator * E = [[self subdocuments] objectEnumerator];
		NSDocument * D;
		while(D = [E nextObject])
		{
			NSString * K = [self fileKeyForSubdocument:D];
			if([K length])
			{
				NSString * relativePath = [self nameForFileKey:K];
				NSString * fullPath = [fullProjectPath stringByAppendingPathComponent:relativePath];
				[DFM iTM2_createDeepDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] attributes:nil error:nil];
				NSURL * url = [NSURL fileURLWithPath:fullPath];
				if(![D writeSafelyToURL:url ofType:[D fileType] forSaveOperation:saveOperation error:outErrorPtr])
				{
					iTM2_LOG(@"*** FAILURE: document for key %@ could not be saved",K);
					result = NO;
				}
				if((saveOperation == NSSaveOperation)|| (saveOperation == NSSaveAsOperation))
					[D updateChangeCount:NSChangeCleared];
			}
			else
			{
				iTM2_LOG(@"*** WARNING: No key for a project document");
			}
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareProjectMetaCompleteWriteToURL:ofType:error:
- (BOOL)prepareProjectMetaCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//	[self prepareFrontendCompleteWriteToURL:fileURL ofType:type error:outErrorPtr];// create the frontend dedicated directory inside the project
	NSMutableArray * mra = [NSMutableArray array];
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	id D;
	while(D = [E nextObject])
	{
		NSURL * url = [D originalFileURL];
		NSString * K = [self fileKeyForURL:url];
		if(K)
		{
			[mra addObject:K];
		}
		else
		{
			iTM2_LOG(@"****  WARNING:The project document had no key:%@",url);
			if(K = [self newFileKeyForURL:url])
			{
				[mra addObject:K];
			}
		}
	}
	[self takeContextValue:mra forKey:iTM2ContextOpenDocuments domain:iTM2ContextAllDomainsMask];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareFrontendCompleteWriteToURL:ofType:error:
- (BOOL)prepareFrontendCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// aliases and symlinks might not be fully supported here.
    BOOL result = YES;
	NSString * fileName = [fileURL path];
//iTM2_LOG(@"fileName is: %@",fileName);
	fileName = [fileName iTM2_lazyStringByResolvingSymlinksAndFinderAliasesInPath];
//iTM2_LOG(@"fileName is: %@",fileName);
	// I should have a directory there
	BOOL isDir = NO;
	if([DFM fileExistsAtPath:fileName isDirectory:&isDir] && !isDir)
	{
		[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nwas unexpected and will be recycled",fileName] forKey:NSLocalizedDescriptionKey]]];
		[SWS selectFile:fileName inFileViewerRootedAtPath:[fileName stringByDeletingLastPathComponent]];
		// it is not a directory: recycle it.
		int tag;
		if([SWS performFileOperation:NSWorkspaceRecycleOperation source:[fileName stringByDeletingLastPathComponent] destination:@"" files:[NSArray arrayWithObject:[fileName lastPathComponent]] tag:&tag])
		{
			[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
				userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nwas unexpected and was recycled",fileName] forKey:NSLocalizedDescriptionKey]]];
		}
		else
		{
			NSString * fileNamePutAside = [[fileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"put_aside_by_iTeXMac2"];
			if([DFM fileExistsAtPath:fileNamePutAside] && ![DFM removeFileAtPath:fileNamePutAside handler:nil])
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nshould be recycled...",fileNamePutAside] forKey:NSLocalizedDescriptionKey]]];
			}
			if(![DFM copyPath:fileName toPath:fileNamePutAside handler:nil])
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nhas been put aside...",fileNamePutAside] forKey:NSLocalizedDescriptionKey]]];
			}
			if(![DFM removeFileAtPath:fileName handler:nil])
			{
				if(outErrorPtr)
				{
					*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove\n%@\nDon't be surprised if things don't work as expected...",fileNamePutAside] forKey:NSLocalizedDescriptionKey]];
				}
				else
				{
					iTM2_LOG(@"Could not remove\n%@\nDon't be surprised if things don't work as expected...",fileNamePutAside);
				}
				return NO;
			}
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteReadFromURL:ofType:error:
- (BOOL)projectCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outErrorPtr)
	{
		*outErrorPtr = nil;
	}
	NSMethodSignature * MS = [self methodSignatureForSelector:@selector(prepareProjectFixImplementation)];
	NSHashEnumerator HE = NSEnumerateHashTable([iTM2RuntimeBrowser instanceSelectorsOfClass:[self class] withSuffix:@"rojectFixImplementation" signature:MS inherited:YES]);
	SEL selector;
	while(selector = NSNextHashEnumeratorItem(&HE))
	{
		[self performSelector:selector withObject:nil];
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveAllSubdocumentsWithDelegate:didSaveSelector:contextInfo:
- (void)saveAllSubdocumentsWithDelegate:(id)delegate didSaveAllSelector:(SEL)action contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(id)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1:03/10/2002
To Do List:to be improved... to allow different signature
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
     [[self mutableSubdocuments] makeObjectsPerformSelector:@selector(saveDocument:)withObject:self];
    BOOL resultFlag = YES;
    NSMethodSignature * myMS = [self methodSignatureForSelector:
                                    @selector(_fakeProject:didSaveAllSubdocuments:contextInfo:)];
    if([myMS isEqual:[delegate methodSignatureForSelector:action]])
    {
        NSInvocation * I = [[NSInvocation invocationWithMethodSignature:myMS] retain];
        [I setSelector:action];
        [I setTarget:delegate];
        [I setArgument:&self atIndex:2];
        [I setArgument:&resultFlag atIndex:3];
        if(contextInfo)
            [I setArgument:&contextInfo atIndex:4];
        [I invoke];
		[I release];
    }
    else
    {
	//iTM2_START;
        NSLog(@"Bad method signature in saveAllDocumentsWithDelegate...");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _fakeProject:didSaveAllSubdocuments:contextInfo:
- (void)_fakeProject:(id)DC didSaveAllSubdocuments:(BOOL)flag contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(if)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1:03/10/2002
To Do List:to be improved...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
#pragma mark =-=-=-=-=-  CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteLoadContext:
- (void)projectCompleteLoadContext:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// this is where oui set up initial context values
	id expected = [self contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextStandardLocalMask];
	if(![expected respondsToSelector:@selector(boolValue)])
	{
		expected = [self contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextAllDomainsMask];
		if([expected respondsToSelector:@selector(boolValue)])
		{
			[self takeContextValue:expected forKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextStandardLocalMask];
		}
	}
	if(!(expected = [self propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextStandardLocalMask]))
	{
		expected = [self contextValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextAllDomainsMask];//something should be returned because this registered as defaults in the string formatter kit
		[self setPropertyValue:expected forKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextStandardLocalMask];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  WRAPPER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapper
- (id)wrapper;
/*"Lazy initializer. Not yet supported.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id lazyWrapper = metaGETTER;
	if([lazyWrapper isKindOfClass:[NSNull class]])
		return nil;
	else if(!lazyWrapper)
	{
		metaSETTER([NSNull null]);// reentrant management,BIG problem here
		NSURL * wrapperURL = [self wrapperURL];
		if(wrapperURL)
		{
			NSString * typeName = [SDC typeForContentsOfURL:wrapperURL error:NULL];
			if(lazyWrapper = [SDC makeDocumentWithContentsOfURL:wrapperURL ofType:typeName])
			{
				metaSETTER(lazyWrapper);// the wrapper is automatically dealloc'd when the owner is dealloc'd.
//iTM2_LOG(@"[SDC documents] are:%@",[SDC documents]);
			}
			return lazyWrapper;
		}
		else
			return nil;
	}
//iTM2_END;
    return lazyWrapper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setWrapper:
- (void)setWrapper:(id)argument;
/*"Lazy initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
	[SDC removeDocument:argument];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapperName
- (NSString *)wrapperName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * pattern = [NSString stringWithFormat:@"(^.*\\.%@)(?=/)",[[SDC iTM2_wrapperPathExtension] stringByEscapingICUREControlCharacters]];
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:pattern options:0L error:nil] autorelease];
	[RE setInputString:[self fileName]];
	if([RE nextMatch] && [RE numberOfCaptureGroups])
	{
		return [RE substringOfCaptureGroupAtIndex:1];
	}
	return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapperURL
- (NSURL *)wrapperURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * wrapperName = [self wrapperName];
	return [wrapperName length]? [NSURL fileURLWithPath:wrapperName]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentAs:
- (IBAction)saveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDocument * wrapper = [self wrapper];
	if(wrapper)
		[wrapper saveDocumentAs:(id)sender];
	else
		[super saveDocumentAs:(id)sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentTo:
- (IBAction)saveDocumentTo:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDocument * wrapper = [self wrapper];
	if(wrapper)
		[wrapper saveDocumentTo:(id)sender];
	else
		[super saveDocumentTo:(id)sender];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  PROJECT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project
- (id)project;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self fileURL] iTM2_belongsToFactory])
		return nil;
	iTM2WrapperDocument * W = [self wrapper];
    return W? [W newRecentDocument]:self;
}
#pragma mark =-=-=-=-=-  CONTEXT
static NSString * const iTM2ProjectContextKeyedFilesKey = @"FileContexts";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext:
- (void)saveContext:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// really disable undo registration!!!
	BOOL needsToUpdate = [self needsToUpdate];
	NSUndoManager * UM = [self undoManager];
	BOOL isUndoRegistrationEnabled = [UM isUndoRegistrationEnabled];
	[UM disableUndoRegistration];
	[[self mutableSubdocuments] makeObjectsPerformSelector:_cmd withObject:irrelevant];
	[super saveContext:irrelevant];
	if(isUndoRegistrationEnabled)
		[UM enableUndoRegistration];
	NSError ** outErrorPtr = nil;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] writeToURL:[self fileURL] ofType:[self fileType] error:outErrorPtr];
    [I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"MetaCompleteWriteToURL:ofType:error:" signature:[I methodSignature] inherited:YES]];
	if(!needsToUpdate)
		[self iTM2_recordFileModificationDateFromURL:[self fileURL]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(result = [super getContextValueForKey:aKey domain:mask&iTM2ContextStandardLocalMask])
	{
		return result;
	}
	NSString * fileKey = @".";
	if(result = [self getContextValueForKey:aKey fileKey:fileKey domain:mask&iTM2ContextStandardLocalMask])
	{
		return result;
	}
    return [super getContextValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * project = [self project];
	id contextManager = [self contextManager];
	NSAssert2(((project != contextManager) || (!project && !contextManager) || ((id)project == self)),@"*** %@ %#x The document's project must not be the context manager!",__iTM2_PRETTY_FUNCTION__, self);
	unsigned int didChange = [super setContextValue:object forKey:aKey domain:mask];
	NSString * fileKey = @".";// weird...
//iTM2_LOG(@"[self contextDictionary] is:%@",[self contextDictionary]);
    return didChange |= [self setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:fileKey:domain;
- (id)contextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self contextDictionary] is:%@",[self contextDictionary]);
//iTM2_END;
    return [self getContextValueForKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:fileKey:domain;
- (id)getContextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask&iTM2ContextStandardLocalMask)
	{
		if(result = [self metaInfoForKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil])
		{
			return result;
		}
	}
	if(mask&iTM2ContextStandardProjectMask)
	{
		if(result = [self metaInfoForKeyPaths:iTM2ProjectContextKeyedFilesKey,iTM2ProjectDefaultsKey,aKey,nil])
		{
			return result;
		}
	}
	if(mask&iTM2ContextExtendedProjectMask)
	{
		NSString * fileName = [self nameForFileKey:fileKey];
		NSString * extensionKey = [fileName pathExtension];
		if([extensionKey length])
		{
			if(result = [self metaInfoForKeyPaths:iTM2ContextExtensionsKey,extensionKey,aKey,nil])
			{
				return result;
			}
		}
		NSDocument * document = [self subdocumentForFileKey:fileKey];
		NSString * type = [document fileType];
		if([type length])
		{
			if(result = [self metaInfoForKeyPaths:iTM2ContextTypesKey,type,aKey,nil])
			{
				return result;
			}
		}
		if([extensionKey length])
		{
			NSURL * fileURL = [self URLForFileKey:fileKey];
			NSString * type4URL = [SDC typeForContentsOfURL:fileURL error:NULL];
			if([type4URL length] && !UTTypeEqual((CFStringRef)type4URL,(CFStringRef)type))
			{
				if(result = [self metaInfoForKeyPaths:iTM2ContextTypesKey,type4URL,aKey,nil])
				{
					return result;
				}
			}
		}
	}
    return [fileKey isEqual:@"."]?[super getContextValueForKey:aKey domain:mask]:nil;// not self, reentrant code management
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:fileKey:domain:
- (unsigned int)takeContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:fileKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(aKey != nil);
	NSString * fileName = [self nameForFileKey:fileKey];// not the file name!
	if(![fileName length] && ![fileKey isEqual:iTM2ProjectDefaultsKey] && ![fileKey isEqual:@"."])
	{
		return NO;
	}
	unsigned int didChange = 0;
	if(mask & iTM2ContextStandardLocalMask)
	{
		if([self setMetaInfo:object forKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil])
		{
			didChange |= iTM2ContextStandardProjectMask;
		}
	}
	if(mask & iTM2ContextStandardProjectMask)
	{
		fileKey = iTM2ProjectDefaultsKey;
		if([self setMetaInfo:object forKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil])
		{
			didChange |= iTM2ContextStandardProjectMask;
		}
	}
	if(mask & iTM2ContextExtendedProjectMask)
	{
		NSString * extension = [fileName pathExtension];
		if([extension length])
		{
			if([self setMetaInfo:object forKeyPaths:iTM2ContextExtensionsKey,extension,aKey,nil])
			{
				didChange |= iTM2ContextExtendedProjectMask;
			}
			NSURL * fileURL = [self URLForFileKey:fileKey];
			NSString * type4URL = [SDC typeForContentsOfURL:fileURL error:NULL];
			if([type4URL length])
			{
				if([self setMetaInfo:object forKeyPaths:iTM2ContextTypesKey,type4URL,aKey,nil])
				{
					didChange |= iTM2ContextExtendedProjectMask;
				}
			}
		}
	}
    return didChange;
}
@end

NSString * const iTM2PDTableViewPathIdentifier = @"path";
NSString * const iTM2PDTableViewTypeIdentifier = @"type";

@implementation iTM2SubdocumentsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2ProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2SubdocumentsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowShouldClose:
- (BOOL)windowShouldClose:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self window] orderOut:self];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self updateOrderedFileKeys];
    [[self window] setDelegate:self];
	// from Laurent Daudelin,mamasam START
	NSImageCell * imageCell = [[[NSImageCell alloc] initImageCell:nil] autorelease];
	[imageCell setImageScaling:NSScaleProportionally];
	NSTableView * documentsView = [self documentsView];
	NSTableColumn * TC = [documentsView tableColumnWithIdentifier:@"icon"];
	[TC setDataCell:imageCell];
	// from Laurent Daudelin,mamasam STOP
	NSArray * draggedTypes = [NSArray arrayWithObjects:NSFilenamesPboardType,NSURLPboardType,nil];
	[documentsView registerForDraggedTypes:draggedTypes];
    [super windowDidLoad];// validates the contents
//iTM2_LOG(@"the window class is:%@",NSStringFromClass([[self window] class]));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateOrderedFileKeys
- (void)updateOrderedFileKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
    NSEnumerator * E = [[projectDocument fileKeys] objectEnumerator];
    NSString * K;
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    while(K = [E nextObject])
        [MD takeValue:K forKey:[projectDocument nameForFileKey:K]];
    E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
    NSMutableArray * MRA = [NSMutableArray array];
    [MRA addObject:iTM2ProjectDefaultsKey];
    while(K = [E nextObject])
		if([K length])
			[MRA addObject:[MD valueForKey:K]];
	[self setOrderedFileKeys:MRA];
	id DV = [self documentsView];
    [DV reloadData];
	[DV setNeedsDisplay:YES];
	[self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedFileKeys
- (NSMutableArray *)orderedFileKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOrderedFileKeys
- (void)setOrderedFileKeys:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![displayName length])
        displayName = [[self document] displayName];// retrieve the "untitled"
    return [NSString stringWithFormat:
        NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)",iTM2ProjectTable,myBUNDLE,"blah (project name)"),
        [isa prettyInspectorMode],
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)iTM2_windowsMenuItemTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // the format trick allows to have a return value even if nothing is defined in the locales...
    // it might be useless...
    return [isa prettyInspectorMode];
}
#pragma mark =-=-=-=-=-  TABLEVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentsView
- (NSTableView *)documentsView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocumentsView:
- (void)setDocumentsView:(NSTableView *)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSTableView class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSTableView class expected,got:%@.",
            __iTM2_PRETTY_FUNCTION__,argument];
    else
    {
        NSTableView * old = metaGETTER;
        if(old != argument)
        {
            [old setDelegate:nil];
            [old setDataSource:nil];
            metaSETTER(argument);
            if(argument)
            {
                [argument setDelegate:self];
                [argument setDataSource:self];
                [argument setTarget:self];
                [argument setDoubleAction:@selector(_tableViewDoubleAction:)];
            }
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self orderedFileKeys] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * fileKeys = [self orderedFileKeys];
    int top = [fileKeys count];
    if(!row)
    {
        return [[tableColumn identifier] isEqualToString:@"icon"]? nil:NSLocalizedStringFromTableInBundle(@"Default",iTM2ProjectTable,myBUNDLE,"");  
    }
    else if(row>0 && row<top)
    {
        iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
		NSString * key = [fileKeys objectAtIndex:row];
		if([[tableColumn identifier] isEqualToString:iTM2PDTableViewPathIdentifier])
		{
			return [projectDocument nameForFileKey:key];
		}
        NSURL * inAbsoluteURL = [projectDocument URLForFileKey:key];
		if([[tableColumn identifier] isEqualToString:iTM2PDTableViewTypeIdentifier])
		{
			return [SDC localizedTypeForContentsOfURL:inAbsoluteURL error:nil]?:@"";// retained by the SDC
		}
		if([DFM fileExistsAtPath:[inAbsoluteURL path]])
		{
			return [SWS iconForFile:[inAbsoluteURL path]];
		}
        NSURL * factoryURL = [projectDocument factoryURLForFileKey:key];
		return [SWS iconForFile:[factoryURL path]];
    }
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming. NOT USED!
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// object is expected to be a relative path
    if(![[tableColumn identifier] isEqualToString:iTM2PDTableViewPathIdentifier])
		return;
    NSArray * fileKeys = [self orderedFileKeys];
    int top = [fileKeys count];
    if(row>0 && row<top)
    {
        iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
		NSString * otherKey = [projectDocument fileKeyForURL:object];
		if([otherKey length])
		{
			iTM2_LOG(@"INFO:the new relative path is already in use,nothing changed.");
			return;
		}
		NSString * key = [fileKeys objectAtIndex:row];
        NSString * oldObject = [projectDocument nameForFileKey:key];
		if(![oldObject isEqual:object])
		{
			NSString * absolute = [[projectDocument URLForFileKey:key] path];
			// if the file was already existing,just move it around without removing existing files
			if([DFM fileExistsAtPath:absolute])
			{
				[projectDocument setURL:[NSURL fileURLWithPath:object] forFileKey:key];
				NSString * newAbsolute = [[projectDocument URLForFileKey:key] path];
				if([DFM iTM2_createDeepDirectoryAtPath:[newAbsolute stringByDeletingLastPathComponent] attributes:nil error:nil])
				{
					if(![DFM copyPath:absolute toPath:newAbsolute handler:nil])
					{
						[projectDocument setURL:[NSURL fileURLWithPath:oldObject] forFileKey:key];// revert
						iTM2_LOG(@"*** ERROR:Could not move %@ to %@\ndue to problem %i,please do it by hand",absolute,newAbsolute);
					}
					// the concerned documents should now that a file name has changed
				}
				else
				{
					[projectDocument setURL:[NSURL fileURLWithPath:oldObject] forFileKey:key];// revert
					iTM2_LOG(@"*** ERROR:Could not create %@,please do it by hand",[newAbsolute stringByDeletingLastPathComponent]);
				}
			}
			else
			{
				[projectDocument setURL:[NSURL fileURLWithPath:object] forFileKey:key];
			}
		}
    }
	[self updateOrderedFileKeys];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:willDisplayCell:forTableColumn:row:
- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[aTableColumn identifier] isEqualToString:iTM2PDTableViewPathIdentifier])
	{
		if(rowIndex)
		{
			NSArray * fileKeys = [self orderedFileKeys];
			NSString * key = [fileKeys objectAtIndex:rowIndex];
			iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
			NSString * absolute = [[projectDocument URLForFileKey:key] path];
			NSString * faraway = [[projectDocument factoryURLForFileKey:key] path];
			BOOL YORN = [DFM fileExistsAtPath:absolute] || [DFM fileExistsAtPath:faraway];
			[aCell setTextColor:(YORN? [NSColor controlTextColor]:[NSColor disabledControlTextColor])];
		}
		else
		{
			NSAttributedString * AS = [aCell attributedStringValue];
			if([AS length])
			{
				NSMutableDictionary * attributes = [[[AS attributesAtIndex:0 effectiveRange:nil] mutableCopy] autorelease];
				NSFont * actualFont = [attributes objectForKey:NSFontAttributeName];
				NSFont * txtFont = [NSFont boldSystemFontOfSize:[actualFont pointSize]];
				if(txtFont)
				{
					[attributes setObject:txtFont forKey:NSFontAttributeName];
					NSAttributedString *attrStr = [[[NSAttributedString alloc]
														initWithString:[AS string] attributes:attributes] autorelease];
					[aCell setAttributedStringValue:attrStr];
				}
			}
		}
	}
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:shouldEditTableColumn:row:
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [iTM2EventObserver isAlternateKeyDown] && [[tableColumn identifier] isEqualToString:iTM2PDTableViewPathIdentifier] && (row>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _tableViewDoubleAction:
- (IBAction)_tableViewDoubleAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * fileKeys = [self orderedFileKeys];
    int row = [sender selectedRow];
    iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
    if((row>=0)&& (row<[fileKeys count]))
    {
        NSString * K = [fileKeys objectAtIndex:row];
		if([K isEqual:iTM2ProjectDefaultsKey])
		{
			return;
		}
		NSError * localError = nil;
		if([projectDocument openSubdocumentForKey:K display:YES error:&localError])
		{
			return;
		}
		if(localError)
		{
			[SDC presentError:localError];
		}
		NSEnumerator * E = [[[self window] drawers] objectEnumerator];
		NSDrawer * D;
		while(D = [E nextObject])
		{
			NSControl * C;
			if(C = [[D contentView] controlWithAction:@selector(fileNameEdited:)])
			{
				[D open:nil];
				break;
			}
		}
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:toolTipForCell:rect:tableColumn:row:mouseLocation::
- (NSString *)tableView:(NSTableView *)tv toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)tc row:(int)row mouseLocation:(NSPoint)mouseLocation;
/*"Thx http://www.corbinstreehouse.com/blog/?p=50.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[tc identifier] isEqual:iTM2PDTableViewPathIdentifier])
	{
		NSArray * fileKeys = [self orderedFileKeys];
		int top = [fileKeys count];
		if(row>0 && row<top)
		{
			iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
			NSString * key = [fileKeys objectAtIndex:row];
			return [[projectDocument URLForFileKey:key] path];
		}
	}
    if ([cell isKindOfClass:[NSTextFieldCell class]])
	{
		NSAttributedString * AS = [cell attributedStringValue];
        if ([AS size].width > rect->size.width)
		{
//iTM2_END;
            return [cell stringValue];
        }
    }
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:writeRowsWithIndexes:toPasteboard:
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * fileKeys = [self orderedFileKeys];
	iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
	NSString * path;
	NSString * key;
 	NSMutableArray * array = [NSMutableArray array];
	unsigned int row = [rowIndexes firstIndex];
	while(row != NSNotFound)
	{
		key = [fileKeys objectAtIndex:row];
		path = [[projectDocument URLForFileKey:key] path];
		[array addObject:path];
		row = [rowIndexes indexGreaterThanIndex:row];
	}
	if([array count])
	{
		[pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:self];
//iTM2_END;
		return [pboard setPropertyList:array forType:NSFilenamesPboardType];
	}
//iTM2_END;
    return NO;
}
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op
{
    // Add code here to validate the drop
	iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
	NSURL * projectURL = [projectDocument fileURL];
	if([projectURL iTM2_belongsToFactory])
	{
		return NSDragOperationNone;
	}
	NSPasteboard * draggingPasteboard = [info draggingPasteboard];
	NSArray * types = [draggingPasteboard types];
	NSURL * contentsURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	NSURL * factoryURL = [SPC URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	BOOL isDirectory = NO;
	if([types containsObject:NSFilenamesPboardType])
	{
		NSArray * fileNames = [draggingPasteboard propertyListForType:NSFilenamesPboardType];
		if(![fileNames isKindOfClass:[NSArray class]])
		{
			NSString * path;
			for(path in fileNames)
			{
				if(![projectDocument fileKeyForURL:[NSURL fileURLWithPath:path]]
					&&([path iTM2_belongsToDirectory:[contentsURL path]] || [path iTM2_belongsToDirectory:[factoryURL path]])
					&&([DFM fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory))
				{
					return NSDragOperationCopy;
				}
			}
		}
	}
	if([types containsObject:NSURLPboardType])
	{
		NSURL * url = [NSURL URLFromPasteboard:draggingPasteboard];
		if([url isFileURL])
		{
			if(![projectDocument fileKeyForURL:url]
				&&([url iTM2_isRelativeToURL:contentsURL] || [url iTM2_isRelativeToURL:factoryURL])
					&&([DFM fileExistsAtPath:[url path] isDirectory:&isDirectory] && !isDirectory))
			{
				return NSDragOperationCopy;
			}
		}
	}
    return NSDragOperationNone;
}
- (BOOL)tableView:(NSTableView *)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)op
{
	BOOL result = NO;
	iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
	NSURL * projectURL = [projectDocument fileURL];
	if([projectURL iTM2_belongsToFactory])
	{
		return result;
	}
	NSPasteboard * draggingPasteboard = [info draggingPasteboard];
	NSArray * types = [draggingPasteboard types];
	NSURL * contentsURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	NSURL * factoryURL = [SPC URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	NSURL * url = nil;
	BOOL isDirectory = NO;
	if([types containsObject:NSFilenamesPboardType])
	{
		NSArray * fileNames = [draggingPasteboard propertyListForType:NSFilenamesPboardType];
		if(![fileNames isKindOfClass:[NSArray class]])
		{
			NSString * path;
			for(path in fileNames)
			{
				url = [NSURL fileURLWithPath:path];
				if(![projectDocument fileKeyForURL:url]
					&&([path iTM2_belongsToDirectory:[contentsURL path]] || [path iTM2_belongsToDirectory:[factoryURL path]])
						&&([DFM fileExistsAtPath:path isDirectory:&isDirectory] && !isDirectory)
							&& [projectDocument newFileKeyForURL:url])
				{
					result = YES;
				}
			}
		}
	}
	else if([types containsObject:NSURLPboardType])
	{
		url = [NSURL URLFromPasteboard:draggingPasteboard];
		if([url isFileURL])
		{
			if(![projectDocument fileKeyForURL:url]
				&&([url iTM2_isRelativeToURL:contentsURL] || [url iTM2_isRelativeToURL:factoryURL])
					&&([DFM fileExistsAtPath:[url path] isDirectory:&isDirectory] && !isDirectory)
						&& [projectDocument newFileKeyForURL:url])
			{
				result = YES;
			}
		}
	}
    return result;
}

#if 0
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(int)row;
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView;
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row;
- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn;

- (void)tableView:(NSTableView*)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn;
- (void)tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn;
- (void)tableView:(NSTableView*)tableView didDragTableColumn:(NSTableColumn *)tableColumn;
#endif
#pragma mark =-=-=-=-=-  DOCUMENTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newDocument:
- (IBAction)newDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([NSApp tryToPerform:@selector(newDocumentFromRunningAssistantPanelForProject:)with:[self document]])
	{
		return;
	}
	[SDC newDocument:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  importDocument:
- (IBAction)importDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSOpenPanel * OP = [NSOpenPanel openPanel];
	NSString * oldDirectory = [OP directory];
    [OP setCanChooseFiles:YES];
    [OP setCanChooseDirectories:NO];
    [OP setTreatsFilePackagesAsDirectories:YES];
    [OP setAllowsMultipleSelection:YES];
    [OP setDelegate:self];
    [OP setResolvesAliases:YES];
	[OP setPrompt:NSLocalizedStringFromTableInBundle(@"Add",iTM2ProjectTable,myBUNDLE,"")];
	NSString * directory = [[SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[[self document] fileURL]] path];
    [OP beginSheetForDirectory:directory
        file:nil types:nil modalForWindow:[self window]
            modalDelegate:self didEndSelector:@selector(openPanelDidImportDocument:returnCode:contextInfo:)
				contextInfo:(oldDirectory? [[NSDictionary dictionaryWithObject:oldDirectory forKey:@"oldDirectory"] retain]:nil)];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:shouldShowFilename:
- (BOOL)panel:(id)sender shouldShowFilename:(NSString *)filename;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * fileURL = [NSURL fileURLWithPath:filename];
	iTM2ProjectDocument * PD = (iTM2ProjectDocument *)[self document];
	NSURL * url = [PD fileURL];
	if([url iTM2_isEquivalentToURL:fileURL])
	{
		return NO;
	}
	url = [url iTM2_enclosingWrapperURL];
	if([url iTM2_isEquivalentToURL:fileURL])
	{
		return NO;
	}
//iTM2_END;
    return [[PD fileKeyForURL:fileURL] length]==0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openPanelDidImportDocument:returnCode:contextInfo:
- (void)openPanelDidImportDocument:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(NSDictionary *)contextInfo
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[contextInfo autorelease];
	id oldDirectory = [contextInfo objectForKey:@"oldDirectory"];
	if(oldDirectory)
	{
		[sheet setDirectory:oldDirectory];
	}
    if(NSOKButton == returnCode)
    {
		// Always copy to the close location, not the Writable Projects location...
		// Always copy stuff that do not belong to the faraway folder
		NSMutableArray * FNs = [[[sheet filenames] mutableCopy] autorelease];
        NSEnumerator * E = [[sheet filenames] objectEnumerator];
        NSString * pathToCopy = nil;
		iTM2ProjectDocument * projectDocument = [self document];
		NSURL * contentsURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[projectDocument fileURL]];
		NSString * contentsName = [contentsURL path];
		NSMutableArray * copiables = [NSMutableArray array];
        while(pathToCopy = [E nextObject])
		{
			if(![pathToCopy iTM2_belongsToDirectory:contentsName] && ![pathToCopy iTM2_pathIsEqual:contentsName])
			{
				[copiables addObject:pathToCopy];
				[FNs removeObject:pathToCopy];
			}
		}
		if([copiables count])
		{
			int code = NSRunAlertPanel(
					NSLocalizedStringFromTableInBundle(@"Project Documents Panel",iTM2ProjectTable,myBUNDLE,""),
					NSLocalizedStringFromTableInBundle(@"Copy the documents in the project folder?",iTM2ProjectTable,myBUNDLE,""),
					NSLocalizedStringFromTableInBundle(@"Yes",iTM2ProjectTable,myBUNDLE,""),
					nil,
					NSLocalizedStringFromTableInBundle(@"No",iTM2ProjectTable,myBUNDLE,"")
				);
			if(code == NSAlertDefaultReturn)
			{
				BOOL problem = NO;
				for(pathToCopy in copiables)
				{
					NSString * lastComponent = [pathToCopy lastPathComponent];
					NSString * target = [contentsName stringByAppendingPathComponent:lastComponent];
					if([DFM fileExistsAtPath:target] || [DFM pathContentOfSymbolicLinkAtPath:target])
					{
						problem = YES;
					}
					else
					{
						NSString * dirName = [pathToCopy stringByDeletingLastPathComponent];
						int tag;
						if([SWS performFileOperation:NSWorkspaceCopyOperation source:dirName
										destination:contentsName files:[NSArray arrayWithObject:lastComponent] tag:&tag])
						{
							NSURL * url = [NSURL fileURLWithPath:target];
							[projectDocument addURL:url];
							[projectDocument openSubdocumentWithContentsOfURL:url context:nil display:YES error:nil];
							[FNs removeObject:pathToCopy];
						}
						else
						{
							iTM2_LOG(@"Could not copy synchronously file at %@ (tag is %i)",target,tag);
						}
					}
				}
				if(problem)
				{
					NSRunAlertPanel(
						NSLocalizedStringFromTableInBundle(@"Project Documents Panel",iTM2ProjectTable,myBUNDLE,""),
						NSLocalizedStringFromTableInBundle(@"Name conflict,copy not complete.",iTM2ProjectTable,myBUNDLE,""),
						NSLocalizedStringFromTableInBundle(@"Acknowledge",iTM2ProjectTable,myBUNDLE,""),
						nil,
						nil);
				}
			}
		}
        for(pathToCopy in FNs)
		{
			NSURL * url = [NSURL fileURLWithPath:pathToCopy];
			[projectDocument openSubdocumentWithContentsOfURL:url context:nil display:YES error:nil];
		}
    }
	[self updateOrderedFileKeys];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  copyProjectDocumentSheetDidDismiss:returnCode:copiables:
- (void)copyProjectDocumentSheetDidDismiss:(NSWindow *)sheet returnCode:(int)returnCode copiables:(NSMutableArray *)copiables;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[copiables autorelease];// was retained above
	if(returnCode == NSAlertDefaultReturn)
	{
		BOOL problem = NO;
		NSString * fullPath;
		iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
		NSURL * contentsURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[projectDocument fileURL]];
		NSString * contentsName = [contentsURL path];
		for(fullPath in copiables)
		{
			NSString * lastComponent = [fullPath lastPathComponent];
			NSString * target = [contentsName stringByAppendingPathComponent:lastComponent];
			if([DFM fileExistsAtPath:target] || [DFM pathContentOfSymbolicLinkAtPath:target])
			{
				problem = YES;
			}
			else
			{
				NSString * dirName = [fullPath stringByDeletingLastPathComponent];
				int tag;
				if([SWS performFileOperation:NSWorkspaceCopyOperation source:dirName
								destination:contentsName files:[NSArray arrayWithObject:lastComponent] tag:&tag])
				{
					NSURL * url = [NSURL fileURLWithPath:target];
					[projectDocument addURL:url];
					[projectDocument openSubdocumentWithContentsOfURL:url context:nil display:YES error:nil];
				}
				else
				{
					iTM2_LOG(@"Could not copy synchronously file at %@ (tag is %i)",fullPath,tag);
				}
			}
		}
		if(problem)
		{
			NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Project documents panel",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Acknowledge",iTM2ProjectTable,myBUNDLE,""),
			nil,
			nil,
			[self window],// bof
			nil,
			NULL,
			NULL,
			nil,
			NSLocalizedStringFromTableInBundle(@"Name conflict,copy not complete.",iTM2ProjectTable,myBUNDLE,""));
		}
	}
	[self updateOrderedFileKeys];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeDocument:
- (IBAction)removeDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * fileKeys = [self orderedFileKeys];
    NSRange R = NSMakeRange(0,[fileKeys count]);
    iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
    NSURL * dirURL = [[[projectDocument fileURL] iTM2_URLByRemovingFactoryBaseURL] iTM2_parentDirectoryURL];
	NSMutableArray * recyclable = [NSMutableArray array];
	NSMutableArray * removable = [NSMutableArray array];
    NSEnumerator * E = [[self documentsView] selectedRowEnumerator];
    NSNumber * N;
	NSString * fileKey;
    while(N = [E nextObject])
    {
        int index = [N intValue];
        if(NSLocationInRange(index,R))
        {
            [projectDocument updateChangeCount:NSChangeDone];// RAISE
			fileKey = [fileKeys objectAtIndex:index];
			NSURL * url = [projectDocument URLForFileKey:fileKey];
			if(![[url absoluteURL] isEqual:[[projectDocument fileURL] absoluteURL]]// don't recycle the project
				&& ![[url absoluteURL] isEqual:[dirURL absoluteURL]]// nor its containing directory!!!
					&& ([DFM fileExistsAtPath:[url path]] || [DFM pathContentOfSymbolicLinkAtPath:[url path]]))
			{
				// if the file belongs to another project it should not be recycled
				[recyclable addObject:fileKey];
			}
			else
			{
				[removable addObject:fileKey];
			}
        }
    }
	for(fileKey in removable)
	{
		[projectDocument removeFileKey:fileKey];
	}
	[self updateOrderedFileKeys];
	if([recyclable count])
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Suppressing project documents references",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Keep",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Recycle",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Cancel",iTM2ProjectTable,myBUNDLE,""),
			[sender window],
			self,
			NULL,
			@selector(removeSubdocumentSheetDidDismiss:returnCode:recyclable:),
			[recyclable retain],// will be released below
			NSLocalizedStringFromTableInBundle(@"Also recycle the selected project documents?",iTM2ProjectTable,myBUNDLE,""));
	// Inform the shared project controller that something has changed
	[SPC flushCaches];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRemoveDocument:
- (BOOL)validateRemoveDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self documentsView] numberOfSelectedRows] > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSubdocumentSheetDidDismiss:returnCode:recyclable:
- (void)removeSubdocumentSheetDidDismiss:(NSWindow *)sheet returnCode:(int)returnCode recyclable:(NSMutableArray *)recyclable;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[recyclable autorelease];// was retained above
	if(returnCode == NSAlertOtherReturn)// cancel!!
		return;
	BOOL recycle = (returnCode == NSAlertAlternateReturn);
    iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
	NSString * fileKey;
	NSDictionary * contextInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:recycle] forKey:@"recycle"];
    for(fileKey in recyclable)
    {
		NSURL * url = [projectDocument URLForFileKey:fileKey];
		NSDocument * subdocument = [SDC documentForURL:url];
		if(subdocument)
		{
			[subdocument canCloseDocumentWithDelegate:self
				shouldCloseSelector:@selector(subdocument:shouldRemoveFromProject:contextInfo:)
					contextInfo:[contextInfo retain]];// contextInfo will be released below
		}
		else
		{
			NSString * lastComponent = [[url path] lastPathComponent];
			NSString * dirName = [[url path] stringByDeletingLastPathComponent];
			int tag;
			if(recycle)
			{
				if([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName
								destination:@"" files:[NSArray arrayWithObject:lastComponent] tag:&tag])
				{
					iTM2_LOG(@"Recycling synchronously file at %@ in directory %@...",lastComponent,dirName);
				}
				else
				{
					iTM2_LOG(@"Could not recycle synchronously file at %@ (tag is %i)",[url path],tag);
				}
				[projectDocument removeFileKey:fileKey];
			}
			else
			{
				NSURL * destinationURL = [url iTM2_enclosingWrapperURL];
				if(destinationURL)
				{
					NSString * destination = [destination stringByDeletingLastPathComponent];
					if([SWS performFileOperation:NSWorkspaceMoveOperation source:dirName
									destination:destination files:[NSArray arrayWithObject:lastComponent] tag:&tag])
					{
						iTM2_LOG(@"Moving file at %@ in directory %@...",lastComponent,dirName);
					}
					else
					{
						iTM2_LOG(@"Could not move synchronously file at %@ (tag is %i)",[url path],tag);
					}
				}
				[projectDocument removeFileKey:fileKey];
			}
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocument:shouldRemoveFromProject:contextInfo:
- (void)subdocument:(NSDocument *)subdocument shouldRemoveFromProject:(BOOL)shouldRemove contextInfo:(NSDictionary *)contextInfo
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[contextInfo autorelease];// was retained above
	if(!shouldRemove)
		return;
	NSURL * fileURL = [subdocument fileURL];
	iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
	NSString * fileKey = [projectDocument fileKeyForURL:fileURL];
	if(![fileKey length])
		return;
	BOOL recycle = [[contextInfo objectForKey:@"recycle"] boolValue];
	NSString * lastComponent = [[fileURL path] lastPathComponent];
	NSString * dirName = [[fileURL path] stringByDeletingLastPathComponent];
	int tag;
	if(recycle)
	{
		if([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName
						destination:@"" files:[NSArray arrayWithObject:lastComponent] tag:&tag])
		{
			iTM2_LOG(@"Recycling %@ from directory %@",lastComponent,dirName);
		}
		else
		{
			iTM2_LOG(@"Could not recycle synchronously file at %@ (tag is %i)",fileURL,tag);
		}
    }
	else
	{
		NSURL * destinationURL = [[[fileURL iTM2_enclosingWrapperURL] iTM2_URLByRemovingFactoryBaseURL] iTM2_parentDirectoryURL];
		if(destinationURL)
		{
			if([SWS performFileOperation:NSWorkspaceMoveOperation source:dirName
							destination:[destinationURL path] files:[NSArray arrayWithObject:lastComponent] tag:&tag])
			{
				iTM2_LOG(@"Moving file at %@ in directory %@...",lastComponent,dirName);
			}
			else
			{
				iTM2_LOG(@"Could not move synchronously file at %@ (tag is %i)",[destinationURL path],tag);
			}
		}
	}
	[projectDocument removeFileKey:fileKey];
    [self updateOrderedFileKeys];
	[subdocument canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(subdocument:shouldClose:contextInfo:) contextInfo:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocument:shouldClose:contextInfo:
- (void)subdocument:(NSDocument *)subdocument shouldClose:(BOOL)shouldClose contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(shouldClose)
	{
		[subdocument close];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  help:
- (IBAction)help:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do LÂiTM2ProjectDocument *ist:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectPathEdited:
- (IBAction)projectPathEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectPathEdited:
- (BOOL)validateProjectPathEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [self document];
	NSString * name = [doc fileName]?:([doc displayName]?:@"");
	[sender setStringValue:name];
	[sender setToolTip:name];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileNameEdited:
- (IBAction)fileNameEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int row = [[self documentsView] selectedRow];
    NSString * oldRelative;
    if(row < 0 || row >= [[self documentsView] numberOfRows])
	{
        return;
	}
    else if(row)
    {
        oldRelative = [[[self documentsView] dataSource]
                        tableView:[self documentsView]
                    objectValueForTableColumn:[[[self documentsView] tableColumns] lastObject]
                row:row];
        if([oldRelative length])
		{
			NSString * newRelative = [sender stringValue];
			if([newRelative iTM2_pathIsEqual:oldRelative])
				return;
			iTM2ProjectDocument * projectDocument = [self document];
			NSString * dirName = [[projectDocument fileName] stringByDeletingLastPathComponent];
			NSString * new = [dirName stringByAppendingPathComponent:newRelative];
			NSString * key = [projectDocument fileKeyForURL:[NSURL fileURLWithPath:new]];
			if([key length])
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"The name %@ is already used.",iTM2ProjectTable,myBUNDLE,""),
					new]),nil);
				return;
			}
			NSString * old = [dirName stringByAppendingPathComponent:oldRelative];
			key = [projectDocument fileKeyForURL:[NSURL fileURLWithPath:oldRelative]];
			if(0 == [key length])
			{
				return;
			}
			NSError * localError = nil;
			if([DFM iTM2_createDeepDirectoryAtPath:[new stringByDeletingLastPathComponent] attributes:nil error:&localError])
			{
				if([DFM fileExistsAtPath:old])
				{
					if([DFM fileExistsAtPath:new])
					{
						[projectDocument setURL:[NSURL fileURLWithPath:new] forFileKey:key];
						[[projectDocument subdocumentForURL:[NSURL fileURLWithPath:old]] setFileURL:[NSURL fileURLWithPath:new]];
						if(iTM2DebugEnabled)
						{
							iTM2_LOG(@"Name successfully changed from %@ to %@",old,new);
						}
					}
					else if([DFM movePath:old toPath:new handler:nil])
					{
						[projectDocument setURL:[NSURL fileURLWithPath:new] forFileKey:key];
						[[projectDocument subdocumentForURL:[NSURL fileURLWithPath:old]] setFileURL:[NSURL fileURLWithPath:new]];
						if(iTM2DebugEnabled)
						{
							iTM2_LOG(@"Name successfully changed from %@ to %@",old,new);
						}
					}
					else
					{
						iTM2_REPORTERROR(1,(NSLocalizedStringFromTableInBundle(@"A file could not be moved.",iTM2ProjectTable,myBUNDLE,"")),nil);
						return;
					}
				}
				else
				{
					[projectDocument setURL:[NSURL fileURLWithPath:new] forFileKey:key];
					[[projectDocument subdocumentForURL:[NSURL fileURLWithPath:old]] setFileURL:[NSURL fileURLWithPath:new]];
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Name successfully changed from %@ to %@",old,new);
					}
				}
			}
			else
			{
				iTM2_REPORTERROR(1,(NSLocalizedStringFromTableInBundle(@"A directory could not be created.",iTM2ProjectTable,myBUNDLE,"")),localError);
				return;
			}
			[sender iTM2_validateWindowContent];
		}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFileNameEdited:
- (BOOL)validateFileNameEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL editable = NO;
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
    NSString * p;
	NSString * toolTip = nil;
	if([selectedRowIndexes count] == 0)
	{
        p = NSLocalizedStringFromTableInBundle(@"No selection",iTM2ProjectTable,myBUNDLE,"Description Forthcoming");
	}
	else if([selectedRowIndexes count] == 1)
	{
		unsigned int row = [selectedRowIndexes firstIndex];
		NSTableColumn * TC = [documentsView tableColumnWithIdentifier:iTM2PDTableViewPathIdentifier];
		id dataSource = [documentsView dataSource];
        p = [dataSource tableView:documentsView objectValueForTableColumn:TC row:row];
        if([p length])
		{
			editable = YES;
			toolTip = [dataSource tableView:documentsView toolTipForCell:nil rect:nil tableColumn:TC row:row mouseLocation:NSZeroPoint];
		}
		else
		{
			p = NSLocalizedStringFromTableInBundle(@"Default",iTM2ProjectTable,myBUNDLE,"Description Forthcoming");
		}
	}
	else
	{
		p = NSLocalizedStringFromTableInBundle(@"Multiple selection",iTM2ProjectTable,myBUNDLE,"Description Forthcoming");
	}
    [sender setStringValue:(p? p:@"ERROR")];
	[sender setEditable:editable];
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  relativeToEdited:
- (IBAction)relativeToEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRelativeToEdited:
- (BOOL)validateRelativeToEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * projectDocument = [SPC projectForSource:self];
	NSString * name = [[SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:[projectDocument fileURL]] path];
    [sender setStringValue:name];
    [sender setToolTip:name];
//iTM2_START;
    return YES;
}
@end

@implementation NSDocument(Project)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project
- (id)project;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self hasProject]? [SPC projectForDocument:self]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapper
- (id)wrapper;
/*"Lazy initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * projectDocument = [self project];
//iTM2_END;
    return (projectDocument != self)? [projectDocument wrapper]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hasProject
- (BOOL)hasProject;
/*"Lazy initializer. If setHasProject: has already been used, the value set then is returned.
If this is the first time the receiver is asked for hasProject, then its answer relies upon the project controller -projectForURL: method
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning FAILED: to be revisited, is it necessary to cache the project? Won't project for document or project for filename be efficient enough.
	id wrapper = metaGETTER;
	if(wrapper)// this assumes that setHasProject: is never called without good reason
	{
		return [wrapper boolValue];
	}
	id P = [SPC projectForURL:[self fileURL]];// weaker link
	BOOL result = (P != nil);
	[self setHasProject:result];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setHasProject
- (void)setHasProject:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER([NSNumber numberWithBool:yorn]);
	[self updateContextManager];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentCompleteSaveContext:
- (void)subdocumentCompleteSaveContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * url = [self fileURL];
	id P = [SPC projectForURL:url];
	NSURL * projectURL = [P fileURL];
	NSData * aliasData = nil;
	if(projectURL)
	{
		[self takeContextValue:[[[projectURL path] copy] autorelease] forKey:iTM2ProjectAbsolutePathKey domain:iTM2ContextPrivateMask];
		[self takeContextValue:[[projectURL path] iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:[[url path] stringByDeletingLastPathComponent]] forKey:iTM2ProjectRelativePathKey domain:iTM2ContextPrivateMask];
		[self takeContextValue:[P fileKeyForURL:url] forKey:iTM2ProjectFileKeyKey domain:iTM2ContextPrivateMask];
		[self takeContextValue:aliasData forKey:iTM2ProjectAliasKey domain:iTM2ContextPrivateMask];
	}
	else
	{
		[self takeContextValue:iTM2PathComponentsSeparator forKey:iTM2ProjectAbsolutePathKey domain:iTM2ContextPrivateMask];
		[self takeContextValue:iTM2PathComponentsSeparator forKey:iTM2ProjectRelativePathKey domain:iTM2ContextPrivateMask];
		[self takeContextValue:iTM2PathComponentsSeparator forKey:iTM2ProjectFileKeyKey domain:iTM2ContextPrivateMask];
	}
	[self takeContextValue:aliasData forKey:iTM2ProjectOwnAliasKey domain:iTM2ContextPrivateMask];
	[self takeContextValue:[url absoluteString] forKey:iTM2ProjectURLKey domain:iTM2ContextPrivateMask];
	[self takeContextValue:[P fileKeyForSubdocument:self] forKey:iTM2ProjectFileKeyKey domain:iTM2ContextPrivateMask];
	[self takeContextValue:[url path] forKey:iTM2ProjectOwnAbsolutePathKey domain:iTM2ContextPrivateMask];
	[self takeContextValue:[P nameForFileKey:[P fileKeyForURL:url]] forKey:iTM2ProjectOwnRelativePathKey domain:iTM2ContextPrivateMask];
//iTM2_END;
    return;
}
@end

@implementation NSWindowController(Project)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![NSWindowController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_windowTitleForDocumentDisplayName:)]
	|| ![NSWindowController iTM2_swizzleInstanceMethodSelector:@selector(SWZ__iTM2_windowsMenuItemTitleForDocumentDisplayName:)])
	{
		iTM2_LOG(@"It is unlikely that things will work as expected...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_windowTitleForDocumentDisplayName:
- (NSString *)SWZ_iTM2_windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// we should manage the lengthy names...
	id P = [SPC projectForSource:self];
	if(P)
	{
		if(![displayName length])
		{
			displayName = [[self document] displayName];// retrieve the "untitled"
		}
		NSString * projectDisplayName = [[[P fileURL] iTM2_enclosingWrapperURL] path];
		if([projectDisplayName length])
		{
			projectDisplayName = [projectDisplayName stringByDeletingLastPathComponent];
			projectDisplayName = [projectDisplayName stringByDeletingPathExtension];
		}
		else
		{
			projectDisplayName = [P displayName];
		}
		return [NSString stringWithFormat:
			NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)",iTM2ProjectTable,myBUNDLE,"blah (project name)"),
			displayName,[P displayName]];
	}
	return [self SWZ_iTM2_windowTitleForDocumentDisplayName:displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ__iTM2_windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)SWZ__iTM2_windowsMenuItemTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_START;
    return [self SWZ_iTM2_windowTitleForDocumentDisplayName:displayName];
}
@end

@implementation NSWindowController(iTM2ProjectDocument)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldCascadeWindows
- (BOOL)SWZ_iTM2ProjectDocument_shouldCascadeWindows;
/*"Gives a default value,useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self SWZ_iTM2ProjectDocument_shouldCascadeWindows] && (![SPC projectForSource:self]);
}
@end

NSString * const iTM2OtherProjectWindowsAlphaValue = @"iTM2OtherProjectWindowsAlphaValue";

@implementation NSWindow(iTM2ProjectDocument)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithFloat:1],iTM2OtherProjectWindowsAlphaValue,// to be improved...
			nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2ProjectDocument_display
- (void)SWZ_iTM2ProjectDocument_display;
/*"Gives a default value,useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id projectDocument = [SPC projectForSource:self];
	if((project != nil)&& (project != [SPC currentProject]))
	{
		// encapsulate the inherited display method to change the alpha channel
		float otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
		if(otherAlpha<0)
		{
			otherAlpha = 0.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		else if(otherAlpha>1)
		{
			otherAlpha = 1.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		if(otherAlpha<1)
		{
//iTM2_LOG(@"YES");
			BOOL wasOpaque = [self isOpaque];
			[self setOpaque:NO];
			float oldAlpha = [self alphaValue];
			[self setAlphaValue:oldAlpha * otherAlpha];
			[self SWZ_iTM2ProjectDocument_display];
			[self setAlphaValue:oldAlpha];
			[self setOpaque:wasOpaque];
//iTM2_END;
			return;
		}
	}
	[self SWZ_iTM2ProjectDocument_display];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2ProjectDocument_displayIfNeeded
- (void)SWZ_iTM2ProjectDocument_displayIfNeeded;
/*"Gives a default value,useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id projectDocument = [SPC projectForSource:self];
	if((project != nil)&& (project != [SPC currentProject]))
	{
		// encapsulate the inherited display method to change the alpha channel
		float otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
		if(otherAlpha<0)
		{
			otherAlpha = 0.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		else if(otherAlpha>1)
		{
			otherAlpha = 1.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		if(otherAlpha<1)
		{
			BOOL wasOpaque = [self isOpaque];
			[self setOpaque:NO];
			float oldAlpha = [self alphaValue];
			[self setAlphaValue:oldAlpha * otherAlpha];
//iTM2_LOG(@"YES");
			[self SWZ_iTM2ProjectDocument_displayIfNeeded];
			[self setAlphaValue:oldAlpha];
			[self setOpaque:wasOpaque];
//iTM2_END;
			return;
		}
	}
	[self SWZ_iTM2ProjectDocument_displayIfNeeded];
//iTM2_END;
    return;
}
#endif
@end

@interface NSDocument_iTM2ProjectDocumentKit:NSDocument
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSDocument(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSDocument iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocument_setFileURL:)];
	[NSDocument iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocument_saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:)];
	[NSDocument iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_newRecentDocument)];
	[NSWindowController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocument_shouldCascadeWindows)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_setFileURL:
- (void)SWZ_iTM2ProjectDocument_setFileURL:(NSURL*)newURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * oldURL = [self fileURL];
	if(!oldURL || [oldURL isEqual:newURL])
	{
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		return;
	}
	// this is not the first time we are asked to set the file URL
	iTM2ProjectDocument * oldPD = [self project];
	if(!oldPD || (self == (id)oldPD))
	{
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		return;
	}
	iTM2WrapperDocument * WD = [self wrapper];
	if(self == (id)WD)
	{
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		return;
	}
	// the receiver is not a project nor a wrapper,but belongs to project projectDocument
	NSString * oldKey = [oldPD fileKeyForSubdocument:self];
	NSAssert2([oldKey length],@"NON SENSE! the project %@ owns the document %@ but has no key for it!",oldPD,self);
	iTM2ProjectDocument * newPD = [SPC projectForURL:newURL];
	NSURL * url = nil;
	if(nil == newPD)
	{
		url = newURL;
#warning ERROR POSSIBLE: display NO
		newPD = [SPC freshProjectForURLRef:&url display:NO error:nil];
		if(![[url absoluteURL] isEqual:[newURL absoluteURL]])
		{
			[self SWZ_iTM2ProjectDocument_setFileURL:url];
		#warning THERE MIGHT BE A PROBLEM HERE
			iTM2_LOG(@"----  BE EXTREMELY CAREFUL: writeSafelyToURL will be used");
			if(![self writeSafelyToURL:oldURL ofType:[self fileType] forSaveOperation:NSSaveOperation error:nil])
			{
				iTM2_LOG(@"*** THERE IS SOMETHING WRONG WITH THAT FILE NAME:%@",[url path]);
			}
		}
	}
	// removing all the previously existing document with the same file name
	// except the receiver,of course
	id properties = nil;
	if(newPD == oldPD)
	{
//		[[newPD keyedSubdocuments] takeValue:nil forKey:oldKey];
		url = [self fileURL];
		NSString * newKey = [newPD newFileKeyForURL:url];
		properties = [[oldPD mainInfos] propertiesForFileKey:oldKey];
		properties = [[properties mutableCopy] autorelease];
		[[newPD mainInfos] setProperties:properties forFileKey:newKey];
		[self SWZ_iTM2ProjectDocument_setFileURL:url];
		return;
	}
	else if([newPD ownsSubdocument:self])
	{
		// This is not expected:two different projects own the same document
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		//NSAssert3(NO,@"INCONSISTENT CODE:projects %@ and %@ are not allowed to own the same document:%@",oldPD,newPD,self);
		// bib files and others might be shared between projects
		return;
	}
	else if(newPD)
	{
		[oldPD removeSubdocument:self];
		// remove in newPD the project documents with the same name
		NSDocument * newD;
		while(newD = [newPD subdocumentForURL:newURL])
		{
			[newPD removeSubdocument:newD];
			[newD canCloseDocumentWithDelegate:[self class]
				shouldCloseSelector:@selector(document:setFileNameShouldClose:contextInfo:)
					contextInfo:nil];
		}
		[newPD addSubdocument:self];
		NSString * newKey = [newPD fileKeyForSubdocument:self];
		properties = [[[[oldPD mainInfos] propertiesForFileKey:oldKey] mutableCopy] autorelease];
		[[newPD mainInfos] setProperties:properties forFileKey:newKey];
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		// what about the context?
	}
	else
	{
		[SDC addDocument:self];
		[oldPD removeSubdocument:self];
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  document:setFileNameShouldClose:contextInfo:
+ (void)document:(NSDocument *)doc setFileNameShouldClose:(BOOL)shouldClose contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(shouldClose)
		[doc close];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if((result = [super getContextValueForKey:aKey domain:mask&iTM2ContextStandardLocalMask]))
	{
		return result;
	}
	iTM2ProjectDocument * project = [self project];
	id contextManager = [self contextManager];
	NSAssert2(((project != contextManager) || (!project && !contextManager) || ((id)project == self)),@"*** %@ %#x The document's project must not be the context manager!",__iTM2_PRETTY_FUNCTION__, self);
	if((id)project != self)// reentrant code management
	{
		NSString * fileKey = [project fileKeyForURL:[self fileURL]];
		if([fileKey length])
		{
			if(result = [project getContextValueForKey:aKey fileKey:fileKey domain:mask])
			{
				return result;
			}
		}
	}
    return [super getContextValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * project = [self project];
	id contextManager = [self contextManager];
	NSAssert2(((project != contextManager) || (!project && !contextManager) || ((id)project == self)),@"*** %@ %#x The document's project must not be the context manager!",__iTM2_PRETTY_FUNCTION__, self);
	NSURL * fileURL = [self fileURL];// not the file name!
	if(fileURL)
	{
		NSString * fileKey = [project fileKeyForURL:fileURL];
		if([fileKey length])
		{
			[project setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
		}
		else if(project)
		{
			iTM2_LOG(@"*** ERROR:the project %@ does not seem to own the document %@ at %@.",project,self,fileURL);
//iTM2_LOG([project fileKeyForURL:fileName]);
		}
	}
	BOOL didChange = [super setContextValue:object forKey:aKey domain:mask];// last to be sure we have registered
//iTM2_LOG(@"[self contextDictionary] is:%@",[self contextDictionary]);
    return didChange;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_newRecentDocument
- (id)SWZ_iTM2_newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * projectDocument = [self project];
	if([[projectDocument fileURL] iTM2_belongsToFactory])
	{
		return [self SWZ_iTM2_newRecentDocument];
	}
    return projectDocument? [projectDocument newRecentDocument]:[self SWZ_iTM2_newRecentDocument];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_catched_document:didSave:contextInfo:
- (void)iTM2_catched_document:(NSDocument *)document didSave:(BOOL)didSaveSuccessfully contextInfo:(NSDictionary *)contextInfo;
/*"Description Forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSInvocation * I = [contextInfo objectForKey:@"invocation"];
	[I setArgument:&didSaveSuccessfully atIndex:3];
	NSURL * oldURL = [contextInfo objectForKey:@"oldURL"];
	NSURL * newURL = [contextInfo objectForKey:@"newURL"];
	if(![oldURL isFileURL])
	{
		[I invoke];
		return;
	}
	if(![newURL isFileURL])
	{
		[I invoke];
		return;
	}
	iTM2ProjectDocument * oldPD = [SPC projectForDocument:document];
	NSString * oldKey = [oldPD fileKeyForURL:oldURL];
	iTM2ProjectDocument * newPD = [SPC projectForURL:newURL];
	if(!newPD)
	{
		[I invoke];
		return;
	}
	if(didSaveSuccessfully)
	{
		NSString * newKey = [newPD fileKeyForURL:newURL];
		id properties = [[oldPD mainInfos] propertiesForFileKey:oldKey];
		properties = [[properties mutableCopy] autorelease];
		[[newPD mainInfos] setProperties:properties forFileKey:newKey];
		if([newPD isEqual:oldPD])
		{
			if(![oldKey isEqual:newKey])
			{
				NSMutableDictionary * MD = [oldPD keyedSubdocuments];
				[MD removeObjectForKey:oldKey];
				[MD setObject:[NSValue valueWithNonretainedObject:document] forKey:newKey];
			}
		}
		else
		{
			[oldPD forgetSubdocument:document];
			[newPD addSubdocument:document];
		}
	}
	[I invoke];
	return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:
- (void)SWZ_iTM2ProjectDocument_saveToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo;
/*"This is one of the 2 critical methods where the document and its project can be separated. (the other one is setFileURL:)
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL] || (saveOperation != NSSaveAsOperation))
	{
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:delegate didSaveSelector:didSaveSelector contextInfo:contextInfo];
#if 0
		// COMMENT: if we put this trick here, then the document has lost its own name...and gets tagged as untitled
		// this trick is for the "document lost its FSRef" problem
		// when in continuous typesetting mode,
		// we cannot save transparently
		// the document has the expected file name and url but some internals are broken
		// such that the internals no longer make the URL point to the proper file node
		NSURL * url = [self fileURL];
		[self setFileURL:nil];
		[self setFileURL:url];
#endif
		return;
	}
	NSURL * oldURL = [self fileURL];
	if(![oldURL isFileURL])
	{
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:delegate didSaveSelector:didSaveSelector contextInfo:contextInfo];
		return;
	}
	NSMutableDictionary * info = [NSMutableDictionary dictionary];
	[info setObject:oldURL forKey:@"oldURL"];
	[info setObject:absoluteURL forKey:@"newURL"];
	[info setObject:(typeName?:@"") forKey:@"typeName"];
	NSInvocation * I = nil;
	NSMethodSignature * sig = [delegate methodSignatureForSelector:didSaveSelector];
	if(sig)
	{
		I = [NSInvocation invocationWithMethodSignature:sig];
		[I setSelector:didSaveSelector];
		[I setTarget:delegate];
		[I setArgument:&self atIndex:2];
		[I setArgument:(contextInfo?&contextInfo:nil) atIndex:4];
		[info setObject:I forKey:@"invocation"];
	}
	iTM2ProjectDocument * newPD = [SPC projectForURL:absoluteURL];
	if(newPD)
	{
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:self didSaveSelector:@selector(iTM2_catched_document:didSave:contextInfo:) contextInfo:info];
		return;
	}
	NSURL * url = absoluteURL;
	NSError * error = nil;
	if(newPD = [SPC freshProjectForURLRef:&url display:YES error:&error])
	{
		if(![[absoluteURL absoluteURL] isEqual:[url absoluteURL]])
		{
			absoluteURL = url;
			[info setObject:absoluteURL forKey:@"newURL"];
		}
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:self didSaveSelector:@selector(iTM2_catched_document:didSave:contextInfo:) contextInfo:info];
		return;
	}
	if(error)
	{
		iTM2_REPORTERROR(1,(@"Could not create a new project, save operation cancelled"),error);
	}
	if([self isKindOfClass:[iTM2ProjectDocument class]])
	{
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:delegate didSaveSelector:didSaveSelector contextInfo:contextInfo];
		return;
	}
	BOOL result = NO;
	[I setArgument:&result atIndex:3];
	[I invoke];
	return;
}
@end

@implementation iTM2ProjectGhostWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= display
- (void)display;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= title
- (NSString *)title;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString * T = [super title];
	return [T length]? T:@"...";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_windowsMenuItemTitle
- (NSString *)iTM2_windowsMenuItemTitle;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[[self windowController] document] displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= constrainFrameRect:toScreen:
- (NSRect)constrainFrameRect:(NSRect)frameRect toScreen:(NSScreen *)screen;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return frameRect;
}
@end

@implementation NSDocumentController(iTM2ProjectDocumentKit)
#pragma mark =-=-=-=-=-  NEW STUFF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_projectPathExtension
- (NSString *)iTM2_projectPathExtension;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return iTM2ProjectPathExtension;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_wrapperPathExtension
- (NSString *)iTM2_wrapperPathExtension;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return iTM2WrapperPathExtension;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_projectDocumentType
- (CFStringRef)iTM2_projectDocumentType;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2UTTypeProject;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_wrapperDocumentType
- (CFStringRef)iTM2_wrapperDocumentType;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2UTTypeWrapper;
}
@end

#import <iTM2Foundation/iTM2ResponderKit.h>

@interface iTM2ProjectDocumentResponder(PRIVATE)
- (BOOL)validateProjectAddCurrentDocument:(id)sender;
- (void)_moveToDestination:(NSString *)destination;
@end

static NSString * _iTM2CurrentProjectLocalizedFormat = @"PROJECT:%@";
static NSString * _iTM2NoProjectLocalizedTitle = @"NO PROJECT";
static NSString * _iTM2NewProjectLocalizedTitle = @"NEW PROJECT?";


@implementation NSApplication(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![NSApplication iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocumentKit_terminate:)])
	{
		iTM2_LOG(@"WARNING:terminate message could not be patched...");
	}
#if 0
	if(![iTM2RuntimeBrowser iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocumentKit_arrangeInFront:)])
	{
		iTM2_LOG(@"WARNING:arrangeInFront message could not be patched...");
	}
#endif
	[iTM2MileStone registerMileStone:@"No installer available" forKey:@"iTM2ProjectDocumentResponder"];
	[iTM2MileStone registerMileStone:@"No project menu item localization available" forKey:@"iTM2LocalizedProjectMenuItems"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _iTM2ProjectDocumentResponderDidFinishLaunching
- (void)_iTM2ProjectDocumentResponderDidFinishLaunching;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL OK = YES;
	id MI = [[NSApp mainMenu] deepItemWithAction:@selector(projectCurrentCreate:)];
	NSString * proposal = [MI title];
	if(![proposal length] || [proposal rangeOfString:@"%"].length)
	{
		proposal = @"Open/Create a project first";
		iTM2_LOG(@"Localization BUG,the menu item with action projectCurrentAlternate:must exist and contain no %%");
		OK = NO;
	}
	[_iTM2NewProjectLocalizedTitle autorelease];
	_iTM2NewProjectLocalizedTitle = [proposal copy];
	[[MI menu] removeItem:MI];
	MI = [[NSApp mainMenu] deepItemWithAction:@selector(projectCurrentNone:)];
	proposal = [MI title];
	if(![proposal length] || [proposal rangeOfString:@"%"].length)
	{
		proposal = @"No active project";
		iTM2_LOG(@"Localization BUG,the menu item with action projectCurrentAlternate:must exist and contain no %%");
		OK = NO;
	}
	[_iTM2NoProjectLocalizedTitle autorelease];
	_iTM2NoProjectLocalizedTitle = [proposal copy];
	[[MI menu] removeItem:MI];
	MI = [[NSApp mainMenu] deepItemWithAction:@selector(projectCurrent:)];
	proposal = [MI title];
	if(![proposal length] || ([[proposal componentsSeparatedByString:@"%"] count] != 2)|| ([[proposal componentsSeparatedByString:@"%@"] count] != 2))
	{
		proposal = @"Project:%@";
		iTM2_LOG(@"Localization BUG,the menu item with action projectCurrent:must exist and contain one %%@,\nand no other formating directive");
		OK = NO;
	}
	if(OK)
		[iTM2MileStone putMileStoneForKey:@"iTM2LocalizedProjectMenuItems"];
	[_iTM2CurrentProjectLocalizedFormat autorelease];
	_iTM2CurrentProjectLocalizedFormat = [proposal copy];
	if([NSApp targetForAction:@selector(performCloseProject:)])
		[iTM2MileStone putMileStoneForKey:@"iTM2ProjectDocumentResponder"];
//iTM2_LOG(@"_iTM2CurrentProjectLocalizedFormat = %@",_iTM2CurrentProjectLocalizedFormat);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocumentKit_terminate:
- (void)SWZ_iTM2ProjectDocumentKit_terminate:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"iTM2ApplicationIsTerminating"]];
	[self SWZ_iTM2ProjectDocumentKit_terminate:sender];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"iTM2ApplicationIsTerminating"]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocumentKit_arrangeInFront:
- (void)SWZ_iTM2ProjectDocumentKit_arrangeInFront:(id)sender;
/*"When I rearranged the window menu,I broke something and arrangeInFront:no longer works.
This patch mimics the behaviour except that all windows are ordered front.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self orderedWindows] reverseObjectEnumerator];
	NSWindow * W;
	while(W = [E nextObject])
	{
		if(![W isKindOfClass:[iTM2ExternalWindow class]])
		{
			[W orderFront:sender];
		}
	}
	//[self SWZ_iTM2ProjectDocumentKit_arrangeInFront:(id)sender];
//iTM2_END;
    return;
}
@end

#import <iTM2Foundation/iTM2MiscKit.h>

@implementation iTM2ProjectDocumentResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performCloseProject:
- (IBAction)performCloseProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[[SDC currentDocument] project] smartClose];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCloseProject:
- (BOOL)validatePerformCloseProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[SDC currentDocument] project] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCurrent:
- (IBAction)projectCurrent:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectCurrent:
- (BOOL)validateProjectCurrent:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * projectDocument = [SPC projectForSource:sender];
	if(!projectDocument) projectDocument = [SPC currentProject];
	//[name belongsToFarawayProjectsDirectory];
	NSString * wrapperName = [projectDocument wrapperName];
	NSImage * I;
	[sender setImage:nil];
	if([wrapperName length])
	{
		if(I=[SWS iconForFile:wrapperName])
		{
			[I setSize:NSMakeSize(16,16)];
			[sender setImage:I];
		}
	}
	else if(projectDocument &&(I=[SWS iconForFile:[projectDocument fileName]]))
	{
		[I setSize:NSMakeSize(16,16)];
		[sender setImage:I];
	}
//iTM2_LOG(@"[SDC currentDocument] is:%@",[SDC currentDocument]);
    if(projectDocument && ![projectDocument displayName])
    {
        iTM2_LOG(@"What is this projectDocument? %@,%@",projectDocument,[projectDocument fileName]);
		[sender setTitle:@"..."];
		return NO;
    }
    [sender setTitle:(projectDocument? [NSString stringWithFormat:_iTM2CurrentProjectLocalizedFormat,[projectDocument displayName]]
		:([SDC currentDocument]? _iTM2NoProjectLocalizedTitle
			:([[SPC projects] count]? _iTM2NoProjectLocalizedTitle:_iTM2NewProjectLocalizedTitle)))];
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowDocumentsFromRepresentedObject:
- (IBAction)projectShowDocumentsFromRepresentedObject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSValue * V = [sender representedObject];
	if([V isKindOfClass:[NSValue class]])
	{
		id projectDocument = [V nonretainedObjectValue];
		if([SPC isProject:projectDocument] || [SPC isBaseProject:projectDocument])
			[projectDocument showSubdocuments:sender];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowWindowsFromRepresentedObject:
- (IBAction)projectShowWindowsFromRepresentedObject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSValue * V = [sender representedObject];
	if([V isKindOfClass:[NSValue class]])
	{
		id projectDocument = [V nonretainedObjectValue];
		if([SPC isProject:projectDocument] || [SPC isBaseProject:projectDocument])
		{
			// finding the first window not related to the project.
			NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
			NSWindow * W;
			while((W = [E nextObject])&& (projectDocument == [SPC projectForSource:W]))
				;
			NSWindow * w;
			while(w = [E nextObject])
				if(projectDocument == [SPC projectForSource:w])
					[w orderWindow:NSWindowAbove relativeTo:[W windowNumber]];
			return;
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowDocuments:
- (IBAction)projectShowDocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[SPC projectForSource:sender] showSubdocuments:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectShowDocuments:
- (BOOL)validateProjectShowDocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [SPC currentProject] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowSettings:
- (IBAction)projectShowSettings:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[SPC projectForSource:sender] showSettings:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectShowSettings:
- (BOOL)validateProjectShowSettings:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender image])
	{
		NSString * name = @"projectShowSettings(small)";
		NSImage * I = [NSImage iTM2_cachedImageNamed:name];
		if(![I iTM2_isNotNullImage])
		{
			I = [[NSImage iTM2_cachedImageNamed:@"showCurrentProjectSettings"] copy];// cached!
			[I setName:name];
			[I iTM2_setSizeSmallIcon];
		}
		[sender setImage:I];
	}
//iTM2_END;
    return [SPC currentProject] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectEditDocumentUsingRepresentedObject:
- (void)projectEditDocumentUsingRepresentedObject:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenu * M = [sender menu];
	NSValue * V = [[[M supermenu] itemAtIndex:[[M supermenu] indexOfItemWithSubmenu:M]] representedObject];
	if([V isKindOfClass:[NSValue class]])
	{
		id projectDocument = [V nonretainedObjectValue];
		if([SPC isProject:projectDocument] || [SPC isBaseProject:projectDocument])
		{
			NSString * key = [sender representedObject];
			if([key isKindOfClass:[NSString class]])
			{
				NSURL * url = [projectDocument URLForFileKey:key];
				NSError * localError = nil;
                [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
				if(localError)
				{
					[SDC presentError:localError];
				}
			}
			return;
		}
	}
	iTM2_LOG(@"*** BIG UNEXPECTED PROBLEM");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectEditUsingRepresentedInspectorMode:
- (void)projectEditUsingRepresentedInspectorMode:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenu * M = [sender menu];
	NSValue * V = [[[M supermenu] itemAtIndex:[[M supermenu] indexOfItemWithSubmenu:M]] representedObject];
	if([V isKindOfClass:[NSValue class]])
	{
		id projectDocument = [V nonretainedObjectValue];
		if([SPC isProject:projectDocument] || [SPC isBaseProject:projectDocument])
		{
            [[[projectDocument inspectorAddedWithMode:[sender representedObject]] window] makeKeyAndOrderFront:self];
			return;
		}
	}
	iTM2_LOG(@"*** BIG UNEXPECTED PROBLEM");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectEditUsingRepresentedInspectorMode:
- (BOOL)validateProjectEditUsingRepresentedInspectorMode:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenu * M = [sender menu];
	NSValue * V = [[[M supermenu] itemAtIndex:[[M supermenu] indexOfItemWithSubmenu:M]] representedObject];
	if([V isKindOfClass:[NSValue class]])
	{
		id projectDocument = [V nonretainedObjectValue];
		if([SPC isProject:projectDocument] || [SPC isBaseProject:projectDocument])
		{
			NSString * key = [sender representedObject];
			if([key isKindOfClass:[NSString class]])
			{
				if(![sender image])
				{
				#warning FORTHCOMING IMAGES
					;
				}
				NSURL * url = [projectDocument URLForFileKey:key];
				NSURL * factoryURL = [projectDocument factoryURLForFileKey:key];
                [sender setAttributedTitle:([DFM fileExistsAtPath:[url path]]||[DFM fileExistsAtPath:[factoryURL path]]? nil:
                    [[[NSAttributedString alloc] initWithString:[sender title]
                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSColor redColor],NSForegroundColorAttributeName,
                                nil]] autorelease])];
			}
			return YES;
		}
	}
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectAddDocument:
- (IBAction)projectAddDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenu * M = [sender menu];
	NSValue * V = [[[M supermenu] itemAtIndex:[[M supermenu] indexOfItemWithSubmenu:M]] representedObject];
	if([V isKindOfClass:[NSValue class]])
	{
		id projectDocument = [V nonretainedObjectValue];
		if([SPC isProject:projectDocument] || [SPC isBaseProject:projectDocument])
		{
			id WC = [projectDocument inspectorAddedWithMode:[iTM2SubdocumentsInspector inspectorMode]];
			[[WC window] makeKeyAndOrderFront:self];
			[WC importDocument:self];
			return;
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectAddCurrentDocument:
- (IBAction)projectAddCurrentDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self validateProjectAddCurrentDocument:sender])
		return;
	NSValue * V = [sender representedObject];
	if([V isKindOfClass:[NSValue class]])
	{
		id projectDocument = [V nonretainedObjectValue];
		if([SPC isProject:projectDocument] && ![SPC isBaseProject:projectDocument])
		{
			NSDocument * currentDocument = [[[SDC currentDocument] retain] autorelease];
			// we cannot add project documents to project documents?
			if([SPC isProject:currentDocument])
				return;
			[currentDocument takeContextValue:nil forKey:@"_iTM2:Document With No Project" domain:iTM2ContextAllDomainsMask];
			[SDC removeDocument:currentDocument];
			[projectDocument addURL:[currentDocument fileURL]];
			[projectDocument addSubdocument:currentDocument];
			[currentDocument setHasProject:YES];
			return;
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectAddCurrentDocument:
- (BOOL)validateProjectAddCurrentDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDocument * currentDocument = [[[SDC currentDocument] retain] autorelease];
//iTM2_END;
	return currentDocument != nil && [currentDocument project] == nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectToggleStandalone:
- (IBAction)projectToggleStandalone:(id)sender;
/*"Description forthcoming. Does nothing, just a catcher
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectToggleStandalone:
- (BOOL)validateProjectToggleStandalone:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [SPC currentProject];
	[sender setState:([[PD fileURL] iTM2_belongsToFactory]?NSOnState:NSOffState)];
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectToggleNormal:
- (IBAction)projectToggleNormal:(id)sender;
/*"Change a simple project to a normal one.
The problem is that some files and folders must be moved around while already open in iTM2 or not.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [SPC currentProject];
	NSURL * wrapperURL = [[[PD fileURL] iTM2_enclosingWrapperURL] iTM2_URLByRemovingFactoryBaseURL];
	if(wrapperURL)
	{
		[self _moveToDestination:[[wrapperURL path] stringByDeletingPathExtension]];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _moveToDestination:
- (void)_moveToDestination:(NSString *)destination;
/*"Change a simple project to a normal one.
The problem is that some files and folders must be moved around while already open in iTM2 or not.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [SPC currentProject];
	NSURL * oldURL = [PD fileURL];
	NSString * oldName = [PD fileName];
	NSString * source = [[oldURL iTM2_enclosingWrapperURL] path];
	if([DFM fileExistsAtPath:destination])
	{
		iTM2_LOG(@"%@ is already existing, aborting",destination);
		iTM2_REPORTERROR(1,(@"Already existing directory"),nil);
		return;
	}
	NSString * newName = [oldName iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:source];// source is free now
	newName = [destination stringByAppendingPathComponent:newName];
	NSArray * Ks = [PD allKeys];
	NSArray * oldURLs = [PD URLsForFileKeys:Ks];
	NSError * localError = nil;
	NSString * dirName = [newName stringByDeletingLastPathComponent];
	[DFM iTM2_createDeepDirectoryAtPath:dirName attributes:nil error:&localError];
	if(localError)
	{
		iTM2_LOG(@"Error:%@\ndirName:%@",localError,dirName);
		iTM2_REPORTERROR(2,@"Problem (see console)",localError);
	}
	NSURL * absoluteURL = [NSURL fileURLWithPath:newName];
	NSString * typeName = [PD fileType];
	if(![PD writeSafelyToURL:absoluteURL ofType:typeName forSaveOperation:NSSaveOperation error:&localError])
	{
		iTM2_LOG(@"Error:%@\nabsoluteURL:%@",localError,absoluteURL);
		iTM2_REPORTERROR(2,@"Problem (see console)",localError);
		return;
	}
	absoluteURL = [NSURL fileURLWithPath:oldName];
	[SDC forgetRecentDocumentURL:absoluteURL];
	[PD setFileURL:[NSURL fileURLWithPath:newName]];
	NSArray * newURLs = [PD URLsForFileKeys:Ks];
	iTM2_LOG(@"Moving:\n%@\nto\n%@",oldURLs,newURLs);
	// migrate all the files known by the project into the destination folder
	// if they are already open, change their name and save them to the new location
	// if they are no just move them along
	NSEnumerator * newE = [newURLs objectEnumerator];
	NSURL * newURL = nil;
	for(oldURL in oldURLs)
	{
		oldName = [oldURL path];
		newURL = [newE nextObject];
		newName = [newURL path];
		// recycle what is at newName
		NSArray * files = nil;
		int tag;
		if([DFM fileExistsAtPath:newName])
		{
			source = [newName lastPathComponent];
			files = [NSArray arrayWithObject:source];
			dirName = [newName stringByDeletingLastPathComponent];
			if([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName destination:@"" files:files tag:&tag])
			{
				iTM2_LOG(@"Recycling\n%@...", files);
			}
			else
			{
				iTM2_REPORTERROR(tag,([NSString stringWithFormat:@"Could not recycle an already existing file."]),nil);
				iTM2_LOG(@"**** WARNING: Don't be surprised if things don't work as expected... could not recycle file at %@",files);
			}
		}
		else
		{
			[DFM iTM2_createDeepDirectoryAtPath:dirName attributes:nil error:&localError];
			if(localError)
			{
				iTM2_LOG(@"Error:%@",localError);
				iTM2_REPORTERROR(2,@"Problem (see console)",localError);
			}
		}
		id subdocument = [PD subdocumentForURL:oldURL];
		if(subdocument)
		{
			typeName = [subdocument fileType];
			if([subdocument writeSafelyToURL:newURL ofType:typeName forSaveOperation:NSSaveOperation error:&localError])
			{
				[subdocument setFileURL:newURL];
				source = [oldName lastPathComponent];
				files = [NSArray arrayWithObject:source];
				dirName = [oldName stringByDeletingLastPathComponent];
				if([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName destination:@"" files:files tag:&tag])
				{
					iTM2_LOG(@"Recycling\n%@...", files);
				}
				else
				{
					iTM2_LOG(@"**** WARNING: Don't be surprised if things don't work as expected... could not recycle file at %@",files);
					iTM2_REPORTERROR(tag,([NSString stringWithFormat:@"Could not recycle an already existing file."]),nil);
				}
				[SDC forgetRecentDocumentURL:oldURL];
			}
			else
			{
				iTM2_LOG(@"Error:%@\noldURL:%@",localError,oldURL);
				iTM2_REPORTERROR(2,@"Problem (see console)",localError);
				return;
			}
		}
		else if([DFM movePath:oldName toPath:newName handler:NULL] || [DFM copyPath:oldName toPath:newName handler:NULL])
		{
			[SDC forgetRecentDocumentURL:oldURL];
		}
		else
		{
			iTM2_LOG(@"**** WARNING: Don't be surprised if things don't work as expected... could not move file from\n%@\nto\n%@",oldName,newName);
			iTM2_REPORTERROR(tag,([NSString stringWithFormat:@"Could not move file around."]),nil);
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectToggleNormal:
- (BOOL)validateProjectToggleNormal:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [SPC currentProject];
	NSURL * url = [[PD fileURL] iTM2_enclosingWrapperURL];
	[sender setState:(nil!=url?NSOffState:NSOnState)];
//iTM2_END;
	return nil!=url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectToggleWrapper:
- (IBAction)projectToggleWrapper:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [SPC currentProject];
	NSURL * url = [[PD fileURL] iTM2_enclosingWrapperURL];
	NSString * destination = nil;
	if([url iTM2_belongsToFactory])
	{
		destination = [[url iTM2_URLByRemovingFactoryBaseURL] path];
	}
	else if(url)
	{
		return;
	}
	else
	{
		destination = [[PD fileName] stringByDeletingLastPathComponent];
	}
#warning CHANGE the destination if there are different levels
	destination = [destination stringByDeletingPathExtension];
	NSString * extension = [SDC iTM2_wrapperPathExtension];
	destination = [destination stringByAppendingPathExtension:extension];
	[self _moveToDestination:destination];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectToggleWrapper:
- (BOOL)validateProjectToggleWrapper:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [SPC currentProject];
	NSURL * url = [[PD fileURL] iTM2_enclosingWrapperURL];
	BOOL flag = url &&![url iTM2_belongsToFactory];
	[sender setState:(flag?NSOnState:NSOffState)];
//iTM2_END;
	return flag;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocumentKit

// wrapper documents are not used?
NSString * const iTM2WrapperInspectorType = @"Wrapper";

@implementation iTM2WrapperDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2WrapperInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self fileURL] iTM2_belongsToFactory]? nil:self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project
- (id)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[SPC projects] objectEnumerator];
	iTM2ProjectDocument * projectDocument;
	while(projectDocument = [E nextObject])
		if(self == [projectDocument wrapper])
			return projectDocument;
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapper
- (id)wrapper;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentAs:
- (IBAction)saveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * projectDocument = [self project];
	NSString * old = [projectDocument fileName];
// I assume that the project is just under the wrapper
	[super saveDocumentAs:(id)sender];
	if([old length])
	{
		NSString * new = [[self fileName] stringByAppendingPathComponent:[old lastPathComponent]];
		if(![new isEqualToString:old])
		{
			[projectDocument setFileURL:[NSURL fileURLWithPath:new]];
			[projectDocument updateChangeCount:NSChangeCleared];
			NSEnumerator * E = [[projectDocument subdocuments] objectEnumerator];
			NSDocument * D;
			while(D = [E nextObject])
			{
				NSString * k = [projectDocument fileKeyForSubdocument:D];
				if([k length])
				{
					[D setFileURL:[projectDocument URLForFileKey:k]];
				}
				[D updateChangeCount:NSChangeCleared];
			}
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSafelyToURL:ofType:forSaveOperation:error:
- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outErrorPtr
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSString * fullDocumentPath = [absoluteURL path];
	if(saveOperation == NSSaveAsOperation)
	{
		NSString * src = [self fileName];
		NSString * dest = fullDocumentPath;
		if([src iTM2_pathIsEqual:dest])
		{
			iTM2_LOG(@"*** WARNING:You gave twice the same name! (%@)",src);
			return YES;
		}
		else if([DFM copyPath:src toPath:dest handler:nil])
		{
			iTM2ProjectDocument * projectDocument = [self project];
			NSString * fullProjectPath = [fullDocumentPath stringByAppendingPathComponent:[[projectDocument fileName] lastPathComponent]];
			iTM2_LOG(@"*** ERROR:There is something wrong:I cannot make a copy");
			NSURL * url = [NSURL fileURLWithPath:fullProjectPath];
			[self writeSafelyToURL:url ofType:[projectDocument fileType] forSaveOperation:NSSaveAsOperation error:nil];
			[projectDocument setFileURL:url];
			[SPC flushCaches];
			[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
			return YES;
		}
		else
		{
			iTM2_LOG(@"*** ERROR:There is something wrong:I cannot make a copy");
			return NO;
		}
	}
	else if(saveOperation == NSSaveToOperation)
	{
		NSString * src = [self fileName];
		NSString * dest = fullDocumentPath;
		if([src iTM2_pathIsEqual:dest])
		{
			iTM2_LOG(@"*** WARNING:You gave twice the same name! (%@)",src);
			return YES;
		}
		else if([DFM copyPath:src toPath:dest handler:nil])
		{
			iTM2ProjectDocument * projectDocument = [self project];
			NSString * fullProjectPath = [fullDocumentPath stringByAppendingPathComponent:[[projectDocument fileName] lastPathComponent]];
			iTM2_LOG(@"*** ERROR:There is something wrong:I cannot make a copy");
			NSURL * url = [NSURL fileURLWithPath:fullProjectPath];
			BOOL result = [projectDocument writeSafelyToURL:url ofType:[projectDocument fileType] forSaveOperation:NSSaveToOperation error:nil];
			[SPC flushCaches];
			[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
			return result;
		}
		else
		{
			iTM2_LOG(@"*** ERROR:There is something wrong:I cannot make a copy");
			return NO;
		}
	}
	else
	{
		iTM2_LOG(@"*** ERROR:Operation not supported,report BUG");
		return NO;
	}
}
@end

@implementation NSArray(iTM2ProjectDocumentKit)
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


@implementation iTM2StringFormatController(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2StringFormatController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocument_EOL)];
	[iTM2StringFormatController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocument_setEOL:)];
	[iTM2StringFormatController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocument_stringEncoding)];
	[iTM2StringFormatController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocument_setStringEncoding:)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_EOL
- (unsigned int)SWZ_iTM2ProjectDocument_EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id D = [self document];
	id P = [D project];
	if(P)
	{
		NSString * fileKey = [P fileKeyForSubdocument:D];
		if([fileKey length])
		{
			NSString * EOLName = [P propertyValueForKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
			unsigned int EOL = [iTM2StringFormatController EOLForName:EOLName];
			return EOL == iTM2UnknownEOL? [iTM2StringFormatController EOLForName:EOLName]:EOL;
		}
	}
    return [self SWZ_iTM2ProjectDocument_EOL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_setEOL:
- (void)SWZ_iTM2ProjectDocument_setEOL:(unsigned int) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self SWZ_iTM2ProjectDocument_setEOL:argument];
	id D = [self document];
	id P = [D project];
	NSString * fileKey = [P fileKeyForSubdocument:D];
	if([fileKey length])
	{
		NSString * EOLString = [iTM2StringFormatController nameOfEOL:argument];
		[P setPropertyValue:EOLString forKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_stringEncoding
- (NSStringEncoding)SWZ_iTM2ProjectDocument_stringEncoding;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id D = [self document];
	id P = [D project];
	if(P)
	{
		NSString * fileKey = [P fileKeyForSubdocument:D];
		NSString * stringEncodingName = [P propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextAllDomainsMask];
		CFStringEncoding encoding = [iTM2StringFormatController coreFoundationStringEncodingWithName:stringEncodingName];
		return CFStringConvertEncodingToNSStringEncoding(encoding);
	}
    return [self SWZ_iTM2ProjectDocument_stringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_setStringEncoding:
- (void)SWZ_iTM2ProjectDocument_setStringEncoding:(NSStringEncoding) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self SWZ_iTM2ProjectDocument_setStringEncoding:argument];
	id D = [self document];
	id P = [D project];
	NSString * fileKey = [P fileKeyForSubdocument:D];
	NSString * stringEncodingName = [iTM2StringFormatController nameOfCoreFoundationStringEncoding:CFStringConvertNSStringEncodingToEncoding(argument)];
	if([fileKey length])
	{
		[P setPropertyValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
	}
	fileKey = iTM2ProjectDefaultsKey;
	NSString * defaultStringEncodingName = [P propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];// we are expecting something
	if(!defaultStringEncodingName)
	{
		[P setPropertyValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
	}
	return;
}
@end

@implementation iTM2SubdocumentsInspector(StringFormat)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [NSNumber numberWithInt:[sender tag]];
	[[self document] setPropertyValue:N forKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	[self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingToggleAuto:
- (IBAction)stringEncodingToggleAuto:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [[self document] propertyValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	BOOL old = [N respondsToSelector:@selector(boolValue)]?[N boolValue]:NO;
	N = [NSNumber numberWithBool:!old];
	[[self document] setPropertyValue:N forKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextStandardLocalMask];
	[self iTM2_validateWindowContent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStringEncodingToggleAuto:
- (BOOL)validateStringEncodingToggleAuto:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [[self document] propertyValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	BOOL isAuto = [N respondsToSelector:@selector(boolValue)]?[N boolValue]:NO;
    [sender setState:(isAuto? NSOnState:NSOffState)];
	BOOL enabled = !isAuto;

	N = [[self document] propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	int tag = [N respondsToSelector:@selector(intValue)]?[N intValue]:4;// why 4? why not
	BOOL stringEncodingNotAvailable = YES;
	NSMenu * menu = [sender menu];
	NSEnumerator * E = [[menu itemArray] objectEnumerator];
	while(sender = [E nextObject])
	{
		if([sender action] == @selector(takeStringEncodingFromTag:))
		{
			[sender setEnabled:enabled];
			if([sender tag] == tag)
			{
				[sender setState:NSOnState];
				stringEncodingNotAvailable = NO;
			}
			else if([[sender attributedTitle] length])
			{
				[menu removeItem:sender];// the menu item was added because the encoding was missing in the menu
			}
			else
			{
				[sender setState:NSOffState];
			}
		}
	}
	if(stringEncodingNotAvailable)
	{
		iTM2_LOG(@"StringEncoding %i is not available", tag);
		NSString * title = [NSString localizedNameOfStringEncoding:tag];
		if(![title length])
			title = [NSString stringWithFormat:@"StringEncoding:%u", tag];
		sender = [[[NSMenuItem alloc] initWithTitle:title action:@selector(takeStringEncodingFromTag:) keyEquivalent:@""] autorelease];
		NSFont * F = [NSFont menuFontOfSize:[NSFont systemFontSize]*1.1];
		F = [SFM convertFont:F toFamily:@"Helvetica"];
		F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		[sender setAttributedTitle:[[[NSAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:F, NSFontAttributeName, nil]] autorelease]];
		[sender setEnabled:NO];
		[sender setTag:tag];
		[sender setState:NSOnState];
		[menu insertItem:sender atIndex:0];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [NSNumber numberWithInt:[sender tag]];
	[[self document] setPropertyValue:N forKey:TWSEOLFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	[self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeEOLFromTag:
- (BOOL)validateTakeEOLFromTag:(id)sender;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [[self document] propertyValueForKey:TWSEOLFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	int tag = [N respondsToSelector:@selector(intValue)]?[N intValue]:4;// why 4? why not
	[sender setState:([sender tag] == tag? NSOnState:NSOffState)];
	return YES;
}
@end

@implementation NSURL(iTM2ProjectDocumentKit)
- (NSURL *)iTM2_enclosingProjectURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * baseURL = [self baseURL];
	NSURL * url = [baseURL iTM2_enclosingProjectURL];
	if(url)
	{
		return url;
	}
	url = self;
up:
	if([SWS iTM2_isProjectPackageAtURL:url])
	{
//iTM2_END;
		return url;
	}
	NSString * path = [[url relativePath] stringByStandardizingPath];
	if([path length]>1)
	{
		path = [path stringByDeletingLastPathComponent];
		url = [NSURL iTM2_URLWithPath:path relativeToURL:baseURL];
		goto up;
	}
	else
	{
//iTM2_END;
		return nil;
	}
}
- (NSURL *)iTM2_enclosingWrapperURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * baseURL = [self baseURL];
	NSURL * url = [baseURL iTM2_enclosingProjectURL];
	if(url)
	{
		return url;
	}
	url = self;
up:
	if([SWS iTM2_isWrapperPackageAtURL:url])
	{
//iTM2_END;
		return url;
	}
	NSString * path = [[url relativePath] stringByStandardizingPath];
	if([path length]>1)
	{
		path = [path stringByDeletingLastPathComponent];
		url = [NSURL iTM2_URLWithPath:path relativeToURL:baseURL];
		goto up;
	}
	else
	{
//iTM2_END;
		return nil;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_enclosedProjectURLs
- (NSArray *)iTM2_enclosedProjectURLs;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: Sat Jan  5 22:11:37 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self isFileURL])
	{
		return nil;
	}
	NSMutableArray * projects = [NSMutableArray array];
	NSString * path = [self path];
	NSDirectoryEnumerator *dirEnum = [DFM enumeratorAtPath:path];
	NSString * file = nil;
	while (file = [dirEnum nextObject])
	{
		NSURL * url = [NSURL iTM2_URLWithPath:file relativeToURL:self];
		if([SWS iTM2_isProjectPackageAtURL:url])
		{
			[projects addObject:url];
		}
	}
//iTM2_END;
	return projects;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_availableProjectURLs
- (id)iTM2_availableProjectURLs;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self isFileURL])
	{
		return nil;
	}
	NSMutableArray * projects = [NSMutableArray array];
	NSArray * contents = [DFM directoryContentsAtPath:[self path]];
	NSString * file = nil;
	for (file in contents)
	{
		NSURL * url = [NSURL iTM2_URLWithPath:file relativeToURL:self];
		if([SWS iTM2_isProjectPackageAtURL:url])
		{
			[projects addObject:url];
		}
	}
//iTM2_END;
	return projects;
}
@end
