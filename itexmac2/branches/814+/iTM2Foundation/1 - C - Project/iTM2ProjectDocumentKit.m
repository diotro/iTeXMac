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
#import "iTM2ImageKit.h"
#import "iTM2Invocation.h"
#import "iTM2TreeKit.h"

NSString * const iTM2UTTypeWrapper = @"comp.text.tex.iTeXMac.wrapper";
NSString * const iTM2UTTypeProject = @"comp.text.tex.iTeXMac.project";

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
- (BOOL)prepareFrontendCompleteWriteToURL4iTM3:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
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
#import "iTM2NotificationKit.h"
#import "iTM2FileManagerKit.h"

NSString * const iTM2ProjectFileKeyKey = @"iTM2ProjectFileKey";
NSString * const iTM2ProjectBookmarkKey = @"iTM2ProjectBookmark";
NSString * const iTM2ProjectAbsolutePathKey = @"iTM2ProjectAbsolutePath";
NSString * const iTM2ProjectRelativePathKey = @"iTM2ProjectRelativePath";
NSString * const iTM2ProjectOwnRelativePathKey = @"iTM2ProjectOwnRelativePathKey";
NSString * const iTM2ProjectOwnAbsolutePathKey = @"iTM2ProjectOwnAbsolutePathKey";
NSString * const iTM2ProjectOwnAliasKey = @"iTM2ProjectOwnAliasKey";
NSString * const iTM2ProjectAliasKey = @"iTM2ProjectAliasKey";
NSString * const iTM2ProjectURLKey = @"iTM2ProjectURLKey";

#import "iTM2TextDocumentKit.h"
#import "iTM2InfoWrapperKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocumentKit
/*"Description forthcoming."*/
@interface iTM2ProjectDocument()
/*! 
 @property   mutableSubdocuments4iTM3
 @abstract   The documents managed by the project
 @discussion Forthcoming...
 @param      Irrelevant.
 @result     None.
 */
@property (retain,readwrite) NSMutableSet * mutableSubdocuments4iTM3;
/*! 
    @property   keyedSubdocuments
    @abstract   The key project documents mapping.
    @discussion Description forthcoming.
    @param      None
    @result     a dictionary mapping keys to project documents.
*/
@property (retain,readonly) NSMapTable * keyedSubdocuments;


@end

@implementation iTM2ProjectDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2ProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ((self = [super init])) {
		[DNC removeObserver:self];
		[DNC addObserver:self selector:@selector(windowWillCloseNotified:) name:NSWindowWillCloseNotification object:nil];
	}
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillCloseNotified:
- (void)windowWillCloseNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayName
- (NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:53:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * result = self.projectName;
//END4iTM3;
	return result.length? result:super.displayName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectName
- (NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:52:56 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * projectName = self.wrapperURL.lastPathComponent.stringByDeletingPathExtension;
	if (projectName.length)
		return projectName;
    projectName = self.fileURL.lastPathComponent.stringByDeletingPathExtension;
	return [projectName.lowercaseString isEqualToString:@"project"]? @"":projectName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectName
- (NSString *)baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:06:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2ProjectDefaultName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBaseProjectName:
- (void)setBaseProjectName:(NSString *)baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:06:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  closeIfNeeded
- (void)closeIfNeeded
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:08:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.fileURL:%@",self.fileURL);
	// never close a base project
	if ([SPC isBaseProject:self]) {
		return;
	}
	// according to the defaults
	if ([self contextBoolForKey:@"iTM2ProjectDontCloseWhenNoWindowAreVisible" domain:iTM2ContextAllDomainsMask]) {
		return;
	}
	// don't close if there are pending documents
	if (self.mutableSubdocuments4iTM3.count) {
		return;//do nothing
	}
	// don't close if stated:
	if (!self.shouldCloseWhenLastSubdocumentClosed) {
		return;//do nothing
	}
	// don't close if there is any visible window, except _GWC
	id GWC = [IMPLEMENTATION metaValueForKey:@"_GWC"];
	for (NSWindowController * WC in self.windowControllers) {
		if ([WC isEqual:GWC]) {
			continue;
		} else if (WC.isWindowLoaded) {
			if (WC.window.isVisible) {
				return;
			}
		}
	}
	self.close;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldCloseWhenLastSubdocumentClosed
- (BOOL)shouldCloseWhenLastSubdocumentClosed;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:08:56 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [IMPLEMENTATION metaValueForSelector:_cmd];
//END4iTM3;
	return N.boolValue;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setShouldCloseWhenLastSubdocumentClosed:
- (void)setShouldCloseWhenLastSubdocumentClosed:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:09:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [NSNumber numberWithBool:yorn];
	[IMPLEMENTATION takeMetaValue:N forSelector:_cmd];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autosavingFileType
- (NSString *)autosavingFileType;
/*"Autosave can be disabled for the project documents from the defaults.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:09:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self contextBoolForKey:@"iTM2AutosaveProjectDocuments" domain:iTM2ContextAllDomainsMask]?[super autosavingFileType]:nil;
}
@synthesize mutableSubdocuments4iTM3 = iVarMutableSubdocuments4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocuments
- (NSSet *)subdocuments;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:09:39 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.mutableSubdocuments4iTM3 copy] autorelease];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (IBAction)saveDocument:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.fileURL:%@",self.fileURL);
	[super saveDocument:sender];
//END4iTM3;
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
Latest Revision: Wed Mar 17 17:11:01 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// if the files have been moved around while iTeXMac2 was not editing the project,
	// we should automagically update the file names as far as possible
	// we try to find a conservative solution
	for (NSString * key in self.fileKeys) {
		NSURL * url = [self URLForFileKey:key];
		if (![DFM fileExistsAtPath:url.path]){
			NSURL * recordedURL = [self recordedURLForFileKey:key];
			if ([DFM fileExistsAtPath:recordedURL.path]) {
				// is url acceptable?
				// or does url belong of the contents folder?
				if ([recordedURL isRelativeToURL4iTM3:self.contentsURL]
                        && ![self.contentsURL isEqual:self.parentURL]) {
					[self setURL:recordedURL forFileKey:key];
					[[self subdocumentForURL:url] setFileURL:recordedURL];
				} else if ([[SPC getProjectURLsInHierarchyForURL:url error:nil] count]) {
					// this URL belongs to another project
#warning MISSING IMPLEMENTATION
				} else {
					// we should ask the user;
				}
			}
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _fixWritableProjectConsistency
- (BOOL) _fixWritableProjectConsistency;
/*"A cached project is very special. It was created in the cached location
You should not send this message by yourself, unless you are named fixWritableProjectConsistency
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 19 06:15:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * projectURL = self.fileURL;
	if (!projectURL.isFileURL) {
		return NO;
	}
	if (!projectURL.belongsToFactory4iTM3) {// this is not an external project: do nothing
		return NO;
	}
	NSString * path = projectURL.path;
	if (![DFM isWritableFileAtPath:path]) {// we can't do everything we want
		return YES;
	}
	// first clean all the keys that point to nothing
	// record all the file names
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
	NSURL * url = nil;
	for (key in self.fileKeys) {
		if ([SPC isReservedFileKey:key]) {
			// do nothing, this will be managed later
		} else if ((name = [self nameForFileKey:key]),name.length) {
			BOOL isDir;
			url = [self URLForFileKey:key];
			if (url.isFileURL) {
				if ([DFM fileExistsAtPath:url.path isDirectory:&isDir] && !isDir) {
					// this is the expected situation
					// the key was created while a file was existing
					// there is still a file at that location
					// nothing has changed
					[oldExistingURLs setObject:url forKey:key];
				} else if ((url = [self factoryURLForFileKey:key]),url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory:&isDir] && !isDir) {
					// the key corresponds to a factory url
					[oldFactoryURLs setObject:url forKey:key];
				} else if ((url = [self recordedURLForFileKey:key]),url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory:&isDir] && !isDir) {
					// the key corresponds to a previously recorded url
					// we assume the file has moved
					[oldMovedURLs setObject:url forKey:key];
				} else {
					// the file is no longer available, I don't know whre it is
					[oldMissingURLs addObject:key];
				}
			} else {
				// I do not know yet what to do for non file urls.
			}
		} else {
			// the returned name is either NULL or 0 lengthed
			// the project does not know this key
			[self removeFileKey:key];
		}
	}
	NSURL * oldProjectURL = [SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterBookmark inProjectWithURL:projectURL];
	// oldProjectURL was previously recorded for the case of a move...
	NSString * requiredCore = projectURL.path.lastPathComponent.stringByDeletingPathExtension;
	NSArray * commonComponents = nil;
	if ([oldProjectURL isEquivalentToURL4iTM3:projectURL]) {
		// the project has not moved since the last time it was saved by iTeXMac2
		// If some files have moved, I might need to move the project accordingly
		// as an external project, I just have to follow the containing directory
		// but what is the containing directory?
changeName:
		for (url in oldExistingURLs.allValues) {
			commonComponents = url.URLByDeletingLastPathComponent.pathComponents4iTM3;
			if ([commonComponents containsObject:@".Trash"]) {
				commonComponents = nil;			
			} else {
				break;
			}
		}
		for (url in oldExistingURLs.allValues) {
			commonComponents = [commonComponents arrayWithCommon1stObjectsOfArray4iTM3:url.pathComponents4iTM3];
		}
		if (!commonComponents.count) {
			for (url in oldMovedURLs.allValues) {
				commonComponents = url.URLByDeletingLastPathComponent.pathComponents4iTM3;
				if ([commonComponents containsObject:@".Trash"]) {
					commonComponents = nil;			
				} else {
					break;
				}
			}
		}
		for (url in oldMovedURLs.allValues) {
			commonComponents = [commonComponents arrayWithCommon1stObjectsOfArray4iTM3:url.pathComponents4iTM3];
		}
        // the commonComponents are not expected to belong to the external project directory
		if (!commonComponents.count) {
			// all the files have been trashed?
			return YES;
		}
		NSURL * expectedDirURL = [NSURL fileURLWithPathComponents4iTM3:commonComponents];
		if (expectedDirURL.belongsToFactory4iTM3) {
			REPORTERROR4iTM3(2,(@"Unexpected common components in the Writable Projects directory. Report a bug please."),nil);
		}
		//
		NSURL * projectDirURL = [projectURL.enclosingWrapperURL4iTM3.parentDirectoryURL4iTM3 URLByRemovingFactoryBaseURL4iTM3];
		if ([expectedDirURL isEquivalentToURL4iTM3:projectDirURL]) {
			// there is absolutely no need to move the project
			// just update the moved files
			if (oldMovedURLs.count) {
                for (key in oldMovedURLs.allKeys) {
                    [self setURL:[oldMovedURLs objectForKey:key] forFileKey:key];
                }
				[self saveDocument:self];
			}
			return YES;
		}
		// I should move the project to follow the files it contains
		NSURL * src = projectURL.enclosingWrapperURL4iTM3;
		NSString * S = [SDC wrapperPathExtension4iTM3];
		S = [requiredCore stringByAppendingPathExtension:S];
		S = [expectedDirURL.path stringByAppendingPathComponent:S];
		NSURL * dest = [NSURL URLWithPath4iTM3:S relativeToURL:[NSURL factoryURL4iTM3]];
		if ([DFM moveItemAtPath:src.path toPath:dest.path error:NULL]) {
			// also change the receiver's file name
            name = [projectURL pathRelativeToURL4iTM3:src];
            [self setFileURL:[NSURL URLWithPath4iTM3:name relativeToURL:dest]];
			for (key in self.fileKeys) {
				url = [self URLForFileKey:key];
				if ([DFM fileExistsAtPath:url.path]) {
					[self setURL:url forFileKey:key];
				} else if (url = [oldExistingURLs objectForKey:key]) {
					[self setURL:url forFileKey:key];
				} else if (url = [oldMovedURLs objectForKey:key]) {
					[self setURL:url forFileKey:key];
				} else if (url = [oldFactoryURLs objectForKey:key]) {
					[self setURL:url forFileKey:key];
				}
			}
			[self saveDocument:self];
			return YES;
		} else {
			REPORTERROR4iTM3(3,([NSString stringWithFormat:@"Problem %@ could not be moved to %@",src,dest]),nil);
		}
		return YES;
	}
	// the project has changed
	if (oldMissingURLs.count) {
		// can I catch a file name for that?
		// I assume that only the files not in the faraway wrapper need to be retrieved
		for (key in oldMissingURLs.allObjects) {
			url = [SPC URLForFileKey:key filter:iTM2PCFilterRegular inProjectWithURL:oldProjectURL];
			if ([DFM fileExistsAtPath:url.path]) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * projectURL = self.fileURL;
	if (![projectURL belongsToFactory4iTM3]) {// this is not an external project: do nothing
		return NO;
	}
	if (self.mutableSubdocuments4iTM3.count) {
		return YES;// do nothing because things are already in use,don't want to break
	}
	if (![DFM isWritableFileAtPath:projectURL.path]) {// we can't do everything we want
		return YES;
	}
	// this is a critical method
	// the first diagnostic determines whether the project is consistent or not
	// We assume that projects are consistent in general such that we do not merge actions
	// A project is consistent if all its file keys are honoured,
	// which means that there is a file at the URL for all the file keys.
	// Testing for the keys, shallow consistency.
	NSArray * allKeys = self.fileKeys;
	NSString * key = nil;
	NSURL * URL = nil;
	for (key in allKeys)/* this is too early? */{
		if (![SPC isReservedFileKey:key]) {
			URL = [self URLForFileKey:key];
			if (URL.isFileURL && ![DFM fileExistsAtPath:URL.path]) {
				return self._fixWritableProjectConsistency;
			}
		}
	}
	// Project file name
	URL = [SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL];
	if (![URL isEquivalentToURL4iTM3:projectURL]) {
		// the project has most certainly moved
		return self._fixWritableProjectConsistency;
	}
	URL = [SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAbsoluteLink inProjectWithURL:projectURL];
	if (![URL isEquivalentToURL4iTM3:projectURL]) {
		// the project has most certainly moved
		return self._fixWritableProjectConsistency;
	}
	// the project has not moved, test for the file names
	for (key in self.fileKeys) {
		if (![SPC isReservedFileKey:key]) {
			URL = [self URLForFileKey:key];
			if (URL.isFileURL && ![DFM fileExistsAtPath:URL.path]) {
				URL = [self factoryURLForFileKey:key];
				if (URL.isFileURL && ![DFM fileExistsAtPath:URL.path]) {
					URL = [self recordedURLForFileKey:key];
					if (URL.isFileURL && [DFM fileExistsAtPath:URL.path]) {
						// a file has most certainly moved
						return self._fixWritableProjectConsistency;
					}
				}
			}
		}
	}
	// 
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * projectURL = self.fileURL;
	if (projectURL == nil) {// the receiver has no file name yet,we can't do anything serious
		return NO;// we are definitely pesimistic.
	}
	NSString * key = nil;
	NSString * name = nil;
	NSURL * url = nil;
	NSArray * allKeys = self.fileKeys;
	NSURL * enclosingWrapperURL = projectURL.enclosingWrapperURL4iTM3;
	NSString * previousProjectDirectory = nil;
	NSString * actualProjectDirectory = nil;
	NSMutableArray * inconsistentKeys = [NSMutableArray array];
	if (enclosingWrapperURL) {
		// the project does belong to a wrapper
		// was the project moved around?
		previousProjectDirectory = [[SPC URLForFileKey:TWSProjectKey filter:iTM2PCFilterAlias inProjectWithURL:projectURL] path];
		previousProjectDirectory = previousProjectDirectory.stringByDeletingLastPathComponent;
		actualProjectDirectory = projectURL.path.stringByDeletingLastPathComponent;
		if ([actualProjectDirectory pathIsEqual4iTM3:previousProjectDirectory]) {
			// simply list the registered files and see if things were inadvertantly broken...
			for (key in allKeys) {
				if (![SPC isReservedFileKey:key]) {
					if ((url = [self URLForFileKey:key]),[DFM fileExistsAtPath:url.path]) {
						// do nothing
					} else if ((url = [self recordedURLForFileKey:key]),[DFM fileExistsAtPath:url.path]) {
						[self setURL:url forFileKey:key];
					} else if ((name = [self nameForFileKey:key]),name.length) {
						LOG4iTM3(@"Project\n%@\nLost file\n%@",projectURL,name);
					} else {
						[inconsistentKeys addObject:key];
					}
				}
			}
			goto cleanKeys;
		} else {// the project has been moved, things might be more delicate to handle
			for (key in self.fileKeys) {
				if (![SPC isReservedFileKey:key]) {
					if ((url = [self URLForFileKey:key]),[DFM fileExistsAtPath:url.path]) {
						//do nothing;
					} else if ((url = [self recordedURLForFileKey:key]),[DFM fileExistsAtPath:url.path]) {
						[self setURL:url forFileKey:key];
					} else if ((name = [self nameForFileKey:key]),name.length) {
						LOG4iTM3(@"Project\n%@\nLost file\n%@",projectURL,name);
					} else {
						[inconsistentKeys addObject:key];
					}
				}
			}
		}
		// the project belongs to a wrapper,synchronize the names if it makes sense
		NSArray * enclosed = [enclosingWrapperURL enclosedProjectURLs4iTM3];
		if (enclosed.count == 1) {
			//Synchronize the project name and the wrapper name
			NSString * required = enclosingWrapperURL.path.lastPathComponent;
			required = required.stringByDeletingPathExtension;
			required = [required stringByAppendingPathExtension:[projectURL.path pathExtension]];
			required = [projectURL.path.stringByDeletingLastPathComponent stringByAppendingPathComponent:required];
			if (![required pathIsEqual4iTM3:projectURL.path])/* Contents directory? */{
				if ([DFM moveItemAtPath:projectURL.path toPath:required error:NULL]) {
					NSURL * url = [NSURL fileURLWithPath:required];
					[self setFileURL:url];
					[self saveDocument:self];
				} else {
					LOG4iTM3(@"Could not move %@ to %@...");
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
	previousProjectDirectory = previousProjectDirectory.stringByDeletingLastPathComponent;
	actualProjectDirectory = projectURL.path.stringByDeletingLastPathComponent;
	if ([actualProjectDirectory pathIsEqual4iTM3:previousProjectDirectory]) {
		// simply list the registered files and see if things were inadvertantly broken...
		for (key in allKeys) {
			if (![SPC isReservedFileKey:key]) {
				if ((url = [self URLForFileKey:key]),[DFM fileExistsAtPath:url.path]) {
					// do nothing;
				} else if (url = [self recordedURLForFileKey:key]) {
					[self setURL:url forFileKey:key];
				} else if ([(name = [self nameForFileKey:key]) length]) {
					LOG4iTM3(@"Project\n%@\nLost file\n%@",projectURL,name);
				} else {
					[inconsistentKeys addObject:key];
				}
			}
		}
		goto cleanKeys;
	} else if ([DFM fileExistsAtPath:previousProjectDirectory]) {
		// do nothing: the project might have been duplicated
	} else {// the project has been moved,things are delicate
		for (key in self.fileKeys) {
			if (![SPC isReservedFileKey:key]) {
				if ([DFM fileExistsAtPath:[[self URLForFileKey:key] path]]) {
					// do nothing;
				} else if (url = [self recordedURLForFileKey:key]) {
					[self setURL:url forFileKey:key];
				} else if ([(name = [self nameForFileKey:key]) length]) {
					LOG4iTM3(@"Project\n%@\nLost file\n%@",projectURL,name);
				} else {
					[inconsistentKeys addObject:key];
				}
			}
		}
	}
//END4iTM3;
cleanKeys:
	for (key in inconsistentKeys) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.mutableSubdocuments4iTM3.count) {
		return YES;// do nothing because things are already in use, don't want to break
	}
//END4iTM3;
	return self.fixWritableProjectConsistency || self.fixInternalProjectConsistency;
}
#pragma mark =-=-=-=-=-  UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeWindowControllers
- (void)makeWindowControllers;
/*"Projects are no close documents!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.windowControllers.count) {
		return;
	}
    [super makeWindowControllers];// after the documents are open
    self.addGhostWindowController;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allowsSubdocumentsInteraction
- (BOOL)allowsSubdocumentsInteraction;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return nil == [self.implementation metaValueForKey:@"is opening subdocuments"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWindows
- (void)showWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super showWindows];
    if (![self contextBoolForKey:@"iTM2DontOpenSubdocumentsWindow" domain:iTM2ContextAllDomainsMask])
    {
        NS_DURING;
        NSArray * previouslyOpenDocuments = [self contextValueForKey:iTM2ContextOpenDocuments domain:iTM2ContextAllDomainsMask];
        if (iTM2DebugEnabled>1000)
        {
            LOG4iTM3(@"The documents to be opened are:%@",previouslyOpenDocuments);
        }
		[self.implementation takeMetaValue:[NSNull null] forKey:@"is opening subdocuments"];
        NSString * K;
        for(K in previouslyOpenDocuments)
		{
			NSError * localError = nil;
            if (![self openSubdocumentForKey:K display:YES error:&localError] && localError)
			{
				REPORTERROR4iTM3(1,([NSString stringWithFormat:@"Problem opening file at\n%@",[self nameForFileKey:K]]),localError);
			}
		}
        NS_HANDLER
        LOG4iTM3(@"***  CATCHED exception:%@",[localException reason]);
        NS_ENDHANDLER
		[self.implementation takeMetaValue:nil forKey:@"is opening subdocuments"];
    }
	[self setShouldCloseWhenLastSubdocumentClosed:YES];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeWindowController:
- (void)removeWindowController:(NSWindowController *)windowController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super removeWindowController:windowController];
	self.closeIfNeeded;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addWindowController:
- (void)addWindowController:(NSWindowController *)windowController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// this trick is used to force the gost window controller to always be the last in the list
	// that way,the ghost window is not used when sheets are to be displayed.
	id GWC = [IMPLEMENTATION metaValueForKey:@"_GWC"];
	if (GWC) {
		[super removeWindowController:GWC];
		[super addWindowController:windowController];
		[super addWindowController:GWC];
	} else {
		[super addWindowController:windowController];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addGhostWindowController
- (void)addGhostWindowController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindowController * GWC = [IMPLEMENTATION metaValueForKey:@"_GWC"];
	if (!GWC) {
		iTM2ProjectGhostWindow * W = [[[iTM2ProjectGhostWindow alloc]
            initWithContentRect:NSMakeRect(10,60,50,50)
                styleMask:NSTitledWindowMask
                    backing:NSBackingStoreNonretained
                        defer:YES] autorelease];
        if (iTM2DebugEnabled<1000)
            [W setFrameOrigin: NSMakePoint(15000,15000)];
		GWC = [[[NSWindowController alloc] initWithWindow:W] autorelease];
		[self addWindowController:GWC];
		[IMPLEMENTATION takeMetaValue:GWC forKey:@"_GWC"];
		[W setExcludedFromWindowsMenu:YES];
		[W orderFront:self];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeDefaultInspector
- (void)makeDefaultInspector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.windowControllers.count && !self.mutableSubdocuments4iTM3.count)
    {
        self.makeSubdocumentsInspector;
        if (!self.windowControllers.count)
        {
			REPORTERROR4iTM3(1,@"NO DEFAULT WINDOW: I don't know what to do!!!\nPerhaps a missing plug-in?",nil);
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showSubdocuments:
- (void)showSubdocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.makeSubdocumentsInspector;
    NSEnumerator * E = [self.windowControllers objectEnumerator];
    NSWindowController * WC;
    while(WC = E.nextObject)
        if ([WC isKindOfClass:[iTM2SubdocumentsInspector class]])
        {
            [WC.window makeKeyAndOrderFront:self];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dissimulateWindows
- (void)dissimulateWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	CGFloat otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
	if (otherAlpha<0.01)
	{
		otherAlpha = 0.01;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	else if (otherAlpha>1)
	{
		otherAlpha = 1;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	NSHashTable * windows = [self.implementation metaValueForKey:@"_WindowsMarkedWithTransparency"];
	if (!windows)
	{
		windows = [NSHashTable hashTableWithWeakObjects];
		[self.implementation takeMetaValue:windows forKey:@"_WindowsMarkedWithTransparency"];
	}
	for (NSWindow * W in [NSApp windows])
	{
		if ([SPC projectForSource:W] == self)
		{
			if (![windows containsObject:W])
			{
				[windows addObject:W];
				[W setAlphaValue:[W alphaValue]*otherAlpha];
				[W.contentView setNeedsDisplay:YES];
			}
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  exposeWindows
- (void)exposeWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	CGFloat otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
	if (otherAlpha<0.01)
	{
		otherAlpha = 0.01;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	else if (otherAlpha>1)
	{
		otherAlpha = 1;
		[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
	}
	NSHashTable * windows = [self.implementation metaValueForKey:@"_WindowsMarkedWithTransparency"];
	for(NSWindow * W in [NSApp windows])
	{
		if ([SPC projectForSource:W] == self)
		{
			if ([windows containsObject:W])
			{
				[W setAlphaValue:[W alphaValue]/otherAlpha];
				[W.contentView setNeedsDisplay:YES];
			}
		}
	}
	[self.implementation takeMetaValue:nil forKey:@"_WindowsMarkedWithTransparency"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  miniaturizeWindows
- (void)miniaturizeWindows;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
	NSWindow * W;
	while(W = E.nextObject)
		if (self == [SPC projectForSource:W])
		{
//LOG4iTM3(@"miniaturize for project:%@",self);
			[W miniaturize:self];
		}

//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.subdocumentsInspector;
    if (!self.windowControllers.count) {
        REPORTERROR4iTM3(1,@"NO DEFAULT WINDOW: I don't know what to do!!!\nPerhaps a missing plug-in?",nil);
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentsInspector
- (iTM2SubdocumentsInspector *)subdocumentsInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self inspectorAddedWithMode:[iTM2SubdocumentsInspector inspectorMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareSubdocumentsFixImplementation4iTM3
- (void)prepareSubdocumentsFixImplementation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.mutableSubdocuments4iTM3 = [NSMutableSet set];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addSubdocument:
- (void)addSubdocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!document || (document == self)|| [document isKindOfClass:[iTM2WrapperDocument class]]|| [document isKindOfClass:[iTM2ProjectDocument class]])
		return;
	iTM2ProjectDocument * PD = [SPC projectForURL:document.fileURL];
	// beware , the next assertion does not fit with autosave feature
#warning BUG: !!! PROBLEM
	// problem: save a tex file as, open this saved as file, add this newly opened file to the original project: PROBLEM
	NSAssert3(!PD || (PD == self),@"The document <%@> cannot be assigned to project <%@> because it already belongs to another project <%@>",document.fileURL,self.fileURL,PD.fileURL);
	NSAssert1(![[SDC documents] containsObject:document],@"The document <%@> must not belong to the project controller.",document.fileURL);
	[self.mutableSubdocuments4iTM3 addObject:document];// added into a set,no effect if the object is already there...
	[self createNewFileKeyForURL:document.fileURL];
	NSString * key = [self fileKeyForSubdocument:document];// create the appropriate binding as side effect
	NSAssert(key.length,@"Missing key for a document...");
	[SPC setProject:self forDocument:document];
	if (![self isEqual:[SPC projectForSource:document]]) {
		[SPC flushCaches];
		[SPC setProject:self forDocument:document];
		if (![self isEqual:[SPC projectForSource:document]]) {
			LOG4iTM3(@".........  ERROR:There is a really big problem,the SPC does not want to link a document and its project");
		}
	}
	[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ownsSubdocument:
- (BOOL)ownsSubdocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	for (id subdocument in self.subdocuments)
		if (subdocument == document)
			return YES;
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forgetSubdocument:
- (void)forgetSubdocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self.mutableSubdocuments4iTM3 containsObject:document]) {
		[[document retain] autorelease];
        [self.mutableSubdocuments4iTM3 removeObject:document];
		[SPC setProject:nil forDocument:document];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
    }
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  closeSubdocument:
- (void)closeSubdocument:(NSDocument *)document;
/*"Description forthcoming.This is the preferred method
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self.mutableSubdocuments4iTM3 containsObject:document]) {
		[document saveContext:nil];
		[self forgetSubdocument:document];
		self.closeIfNeeded;
    }
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSubdocument:
- (void)removeSubdocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self.mutableSubdocuments4iTM3 containsObject:document])
    {
		[[document retain] autorelease];
		NSString * key = [self fileKeyForSubdocument:document];
		[self removeFileKey:key];
        [self.mutableSubdocuments4iTM3 removeObject:document];
		[SPC setProject:nil forDocument:document];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
    }
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveSubdocuments:
- (void)saveSubdocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.mutableSubdocuments4iTM3 makeObjectsPerformSelector:@selector(saveDocument:) withObject:sender];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"delegate is:%@,shouldCloseSelector is:%@,contextInfo is:%#x",delegate,NSStringFromSelector(shouldCloseSelector),contextInfo);
#if 0
    if (self.isDocumentEdited)
	{
		// order front the first project window found in the list,except the ghost window
		// this front window will be used for the save sheet
		NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * W;
		while(W = E.nextObject)
		{
			if (![W isKindOfClass:[iTM2ProjectGhostWindow class]])
			{
				NSWindowController * WC = W.windowController;
				if (WC.document == self))
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
	if (self.isDocumentEdited)
	{
		// try to order some project window front
		// get the first window except the ghost window,order it front
		NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * W = nil;
		while(W = E.nextObject)
		{
			if ([[W.windowController document] isEqual:self] && ![W isKindOfClass:[iTM2ProjectGhostWindow class]])
			{
				goto orderFront;
			}
		}
		W = self.subdocumentsInspector.window;
orderFront:
		[W orderFront:self];
	}
#endif
 	NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
	if (MS)
	{
		NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
		[I retainArguments];
		[I setArgument:&self atIndex:2];
		I.target = delegate;
		[I setSelector:shouldCloseSelector];
		if (contextInfo)
			[I setArgument:&contextInfo atIndex:4];
		[super canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__project:shouldCloseProject:shouldCloseInvocation:)contextInfo:[I retain]];
//END4iTM3;
		return;
	}
	LOG4iTM3(@"A delegate is expected to implement a should close selector:\ndelegate; %@\nselector:%@",delegate,NSStringFromSelector(shouldCloseSelector));
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __project:shouldCloseProject:shouldCloseInvocation:
- (void)__project:(NSDocument *)doc shouldCloseProject:(BOOL)shouldClose shouldCloseInvocation:(NSInvocation *)invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"invocation is:%@",invocation);
	if (shouldClose && (self.mutableSubdocuments4iTM3.count))
	{
		[self canCloseAllSubdocumentsWithDelegate:self shouldCloseSelector:@selector(__project:shouldCloseAllSubdocuments:shouldCloseInvocation:)contextInfo:(void *)invocation];
    }
	else
	{
		[invocation autorelease];
		[invocation setArgument:&shouldClose atIndex:3];// there is a problem of range "parameter index 3 not in range (-1,2)",nonsense! now "parameter index 3 not in range (-1,3)"
		[invocation invoke];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __project:shouldCloseAllSubdocuments:shouldCloseInvocation:
- (void)__project:(id)project shouldCloseAllSubdocuments:(BOOL)shouldCloseAll shouldCloseInvocation:(NSInvocation *)invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[invocation autorelease];
	[invocation setArgument:&shouldCloseAll atIndex:3];
    [invocation invoke];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCloseAllSubdocumentsWithDelegate:shouldCloseSelector:contextInfo:
- (void)canCloseAllSubdocumentsWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"delegate is:%@,shouldCloseSelector is:%@,contextInfo is:%#x",delegate,NSStringFromSelector(shouldCloseSelector),contextInfo);
	NSSet * subdocuments = self.subdocuments;
	if (subdocuments.count)
	{
		NSMutableDictionary * contextDictionary = [NSMutableDictionary dictionary];
		[contextDictionary setObject:[NSMutableArray arrayWithArray:[subdocuments allObjects]]
			forKey:@"Should close documents"];
		[self saveContext:nil];
		NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
		if (MS)
		{
			NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
			[I retainArguments];
			[I setArgument:&self atIndex:2];
			I.target = delegate;
			[I setSelector:shouldCloseSelector];
			if (contextInfo)
				[I setArgument:&contextInfo atIndex:4];
			[contextDictionary setObject:I forKey:@"Invocation"];
		}
		else if (delegate)
		{
			LOG4iTM3(@"ERROR:The delegate is expected to implement %@",NSStringFromSelector(shouldCloseSelector));
		}
		id subdocument;
		for(subdocument in subdocuments)
		{
			[subdocument canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__subdocument:shouldClose:contextDictionary:)contextInfo:[contextDictionary retain]];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __subdocument:shouldClose:contextDictionary:
- (void)__subdocument:(NSDocument *)doc shouldClose:(BOOL)shouldClose contextDictionary:(NSMutableDictionary *)contextDictionary;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"doc.fileURL.path is:%@,contextInfo is:%#x",doc.fileURL.path,contextInfo);
    [contextDictionary autorelease];// Compensates the retains
	if (!shouldClose)
        [contextDictionary setObject:[NSNumber numberWithBool:YES]
			forKey:@"There are edited project documents"];
    NSMutableArray * MRA = [contextDictionary objectForKey:@"Should close documents"];
    [MRA removeObject:doc];
    if (MRA.count == 0)
    {
        NSInvocation * I = [[contextDictionary objectForKey:@"Invocation"] retain];
    //LOG4iTM3(@"PURE RETAIN? %i",self.retainCount);
        shouldClose = shouldClose&&![[contextDictionary objectForKey:@"There are edited project documents"] boolValue];
        [I setArgument:&shouldClose atIndex:3];
        [I invoke];
		[I release];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteWillClose4iTM3
- (void)projectCompleteWillClose4iTM3;
/*"Description forthcoming.
We have two different situations.
In the first one,the documents will be closed by the document controller,
in the second one,the project is responsible for closing the docs.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self saveContext:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentWillClose4iTM3
- (void)documentWillClose4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super documentWillClose4iTM3];
	[self.subdocuments makeObjectsPerformSelector:@selector(close)];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SPC flushCaches];
	[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([SUD boolForKey:@"iTM2ApplicationIsTerminating"]) /* this is YES when terminating,awful patch */ {
		for (NSDocument * D in self.subdocuments) {
			if ([D isDocumentEdited]) {
				return YES;
            }
        }
	}
	for (NSWindowController * WC in self.windowControllers) {
		if ([WC isWindowLoaded] && [WC.window isDocumentEdited]) {
			return YES;
        }
    }
    return [super isDocumentEdited];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocument:
- (BOOL)validateSaveDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.isDocumentEdited;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentsCompleteSaveContext4iTM3:
- (void)subdocumentsCompleteSaveContext4iTM3:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSEnumerator * E = [self.subdocuments objectEnumerator];
	NSDocument * D;
	while(D = E.nextObject)
	{
//		NSString * name = D.fileURL.path.lastPathComponent;
		[D saveContext:sender];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentForURL:
- (id)subdocumentForURL:(NSURL *)url;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocument * D = nil;
	for (D in self.subdocuments) {
		if ([url isEquivalentToURL4iTM3:D.fileURL]) {
			return D;
		}
		if ([url isEquivalentToURL4iTM3:[D originalFileURL4iTM3]]) {
			return D;
		}
		if ([url isEquivalentToURL4iTM3:[self factoryURLForFileKey:[self fileKeyForSubdocument:D]]]) {
			return D;
		}
	}
	for (D in self.subdocuments) {
		if ([D childDocumentForURL:url])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.mainInfos fileKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keysDidChange
- (void)keysDidChange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SPC flushCaches];
	[self removeFactory];
	[self updateChangeCount:NSChangeDone];
	[IMPLEMENTATION takeMetaValue:nil forKey:iTM2ProjectCachedKeysKey];// clean the cached keys
	
	for (iTM2SubdocumentsInspector * WC in self.windowControllers) {
		if ([WC respondsToSelector:@selector(updateOrderedFileKeys)]) {
			WC.updateOrderedFileKeys;
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contentsURL
- (NSURL *)contentsURL;
/*"This is the directory where all the sources are expected to be collected.
This is cached and updated each time the file URL of the receiver changes.
It assumes that cocoa is smart enough to make all the changes in the file URL through the setFileURL: method.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:32:30 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSURL * url = metaGETTER;
	id reentrant = [NSNull null];
	if ([url isEqual: reentrant]) {
		return nil;
	}
	if (url) {
		return url;
	}
	metaSETTER(reentrant);
	url = [self URLForFileKey:TWSContentsKey];
	metaSETTER(url);
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  parentURL
- (NSURL *)parentURL;
/*"This is the URL of the parent directory.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:32:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSURL * url = metaGETTER;
	id reentrant = [NSNull null];
	if ([url isEqual: reentrant]) {
		return nil;
	}
	if (url) {
		return url;
	}
	metaSETTER(reentrant);
	url = [self URLForFileKey:iTM2ParentKey];
	metaSETTER(url);
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForFileKey:
- (NSURL *)URLForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:36:02 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.mainInfos URLForFileKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLsForFileKeys:
- (NSArray *)URLsForFileKeys:(NSArray *)keys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:35:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.mainInfos URLsForFileKeys:keys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setURL:forFileKey:
- (NSURL *)setURL:(NSURL *)fileURL forFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:35:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self.mainInfos setURL:fileURL forFileKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  factoryURL
- (NSURL *)factoryURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:35:49 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSURL * url = metaGETTER;
	id reentrant = [NSNull null];
	if ([url isEqual: reentrant]) {
		return nil;
	}
	if (url) {
		return url;
	}
	metaSETTER(reentrant);
	url = [self URLForFileKey:TWSFactoryKey];
	metaSETTER(url);
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeFactory
- (BOOL)removeFactory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 09:09:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * url = self.factoryURL;
	if (url.isFileURL) {
		return [DFM removeItemAtPath:url.path error:NULL];
	}
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLInFactoryForURL:
- (NSURL *)URLInFactoryForURL:(NSURL *)url;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 09:03:27 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([url.baseURL isEqual:self.fileURL]) {
        if (![url.relativeString hasPrefix:@".."]) {
            //  The given url is obviously a file in the project, at leat physically
            return [NSURL URLWithString:url.relativeString relativeToURL:self.factoryURL];
        }
        //  the given url lives outside the current project
    }
    if (url.isFileURL && self.fileURL.isFileURL) {
        NSArray * RA = url.pathComponents4iTM3;
        NSArray * ra = self.fileURL.pathComponents4iTM3;
        #warning FAILED
    }
    //  maybe the given url already belongs to the factory url
    if ([url isRelativeToURL4iTM3:NSURL.factoryURL4iTM3]) {
        return url;
    }
    //  maybe the given url already belongs to the factory url
    if ([url isRelativeToURL4iTM3:NSURL.factoryURL4iTM3]) {
        return url;
    }
    //  Then check if url is rela
    if (url.isFileURL && self.fileURL.isFileURL) {
        NSArray * RA = url.pathComponents4iTM3;
        NSArray * ra = self.fileURL.pathComponents4iTM3;
        #warning FAILED
    }
    if (url.isFileURL && self.fileURL.isFileURL) {
        NSArray * RA = url.pathComponents4iTM3;
        NSArray * ra = self.fileURL.pathComponents4iTM3;
    }
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  factoryURLForFileKey:
- (NSURL *)factoryURLForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * relativeName = [self nameForFileKey:key];
//END4iTM3;
	NSURL * url = [NSURL URLWithPath4iTM3:relativeName relativeToURL:nil];
	if (url.isFileURL) {
		// the relative name was in fact a full URL;
//END4iTM3;
		return url;
	}
	if ([relativeName.pathExtension isEqual:TWSFactoryExtension]) {
		relativeName = relativeName.stringByDeletingPathExtension;
	}
//END4iTM3;
	return [NSURL URLWithPath4iTM3:relativeName relativeToURL:self.factoryURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForName:
- (NSString *)fileKeyForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.mainInfos fileKeyForName:name];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameForFileKey:
- (NSString *)nameForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 21 21:39:25 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.mainInfos nameForFileKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  namesForFileKeys:
- (NSArray *)namesForFileKeys:(NSArray *)keys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:29:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.mainInfos namesForFileKeys:keys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setName:forFileKey:
- (void)setName:(NSString *)name forFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 19:56:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!key.length) {
		return;
	}
	if (![self.fileKeys containsObject:key]) {
		return;
	}
	NSString * 	old = [self nameForFileKey:key];
	if (![old pathIsEqual4iTM3:name]) {
		[self.mainInfos setName:name forFileKey:key];
		[IMPLEMENTATION takeMetaValue:nil forKey:iTM2ProjectCachedKeysKey];// clean the cached keys
		NSAssert3([key isEqualToString:[self fileKeyForName:name]],(@"AIE AIE INCONSITENT STATE %@,%@ != %@"),__iTM2_PRETTY_FUNCTION__,key,[self fileKeyForName:name]);
		self.keysDidChange;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (nil == fileURL)// untitled documents will go there
	{
		return nil;
	}
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
    if (nil == cachedKeys)
    {
        cachedKeys = [NSMutableDictionary dictionary];
        [IMPLEMENTATION takeMetaValue:cachedKeys forKey:iTM2ProjectCachedKeysKey];
    }
//LOG4iTM3(@"BEFORE cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	fileURL = [fileURL absoluteURL];
    NSString * result;
	if (result = [cachedKeys objectForKey:fileURL])
	{
		return result;
	}
	// Is it me?
	if ([fileURL isEqual:[self.fileURL absoluteURL]])
	{
		result = @".";
		[cachedKeys setObject:result forKey:fileURL];
		return result;
	}
//LOG4iTM3(@"fileName:%@",fileName);
//LOG4iTM3(@"path:%@",path);}
	// Here begins the hard work
	NSArray * Ks = self.fileKeys;
//LOG4iTM3(@"self.keyedNames:%@",self.keyedNames);
//LOG4iTM3(@"path: %@",path);
//LOG4iTM3(@"fileName: %@",fileName);
	for(result in Ks)
	{
		if ([fileURL isEquivalentToURL4iTM3:[self URLForFileKey:result]])
		{
			[cachedKeys setObject:result forKey:fileURL];
			return result;
		}
	}
	// last chance if the file name is in the factory
	// this one should not be in use now
	if ([fileURL belongsToFactory4iTM3])
	{
		for(result in Ks)
		{
			if ([fileURL isEquivalentToURL4iTM3:[self factoryURLForFileKey:result]])
			{
				if (![[self fileKeyForURL:[fileURL URLByRemovingFactoryBaseURL4iTM3]] length])
				{
					[self setURL:fileURL forFileKey:result];
					[cachedKeys setObject:result forKey:fileURL];
					return result;
				}
			}
		}
	}
//LOG4iTM3(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	fileURL = [fileURL absoluteURL];
	NSURL * projectURL = self.fileURL;
	NSEnumerator * E = nil;
	NSString * K = nil;
	NSUInteger filter;
	NSURL * url = nil;
	filter = iTM2PCFilterAlias;
	E = [[SPC fileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	while(K = E.nextObject)
	{
		if ([fileURL isEqual:[[SPC URLForFileKey:K filter:filter inProjectWithURL:projectURL] absoluteURL]])
		{
			return K;
		}
	}
	filter = iTM2PCFilterAbsoluteLink;
	E = [[SPC fileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	while(K = E.nextObject)
	{
		url = [[SPC URLForFileKey:K filter:filter inProjectWithURL:projectURL] absoluteURL];
		if ([fileURL isEqual:url])
		{
			return K;
		}
	}
	filter = iTM2PCFilterRelativeLink;
	E = [[SPC fileKeysWithFilter:filter inProjectWithURL:projectURL] objectEnumerator];
	while(K = E.nextObject)
	{
		url = [[SPC URLForFileKey:K filter:filter inProjectWithURL:projectURL] absoluteURL];
		if ([fileURL isEqual:url])
		{
			return K;
		}
	}
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordedURLForFileKey:
- (NSURL *)recordedURLForFileKey:(NSString *)aKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([aKey isEqualToString:TWSProjectKey] || [aKey isEqualToString:@"."])
	{
		return self.fileURL;
	}
	NSURL * url;
	if (url = [SPC URLForFileKey:aKey filter:iTM2PCFilterAlias inProjectWithURL:self.fileURL])
	{
		if ([DFM isPrivateFileAtPath4iTM3:url.path])
		{
			return nil;
		}
		if ([DFM fileExistsAtPath:url.path])
		{
			return url;
		}
	}
	if (url = [SPC URLForFileKey:aKey filter:iTM2PCFilterAbsoluteLink inProjectWithURL:self.fileURL])
	{
		if ([DFM isPrivateFileAtPath4iTM3:url.path])
		{
			return nil;
		}
		if ([DFM fileExistsAtPath:url.path])
		{
			return url;
		}
	}
	if (url = [SPC URLForFileKey:aKey filter:iTM2PCFilterRelativeLink inProjectWithURL:self.fileURL])
	{
		if ([DFM isPrivateFileAtPath4iTM3:url.path])
		{
			return nil;
		}
		if ([DFM fileExistsAtPath:url.path])
		{
			return url;
		}
	}
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewFileKeyForURL:fileContext:
- (NSString *)createNewFileKeyForURL:(NSURL *)fileURL fileContext:(NSDictionary *)context;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * key = [self createNewFileKeyForURL:fileURL];
	if (key.length) {
		return key;
	}
	key = [context objectForKey:iTM2ProjectFileKeyKey];
	if ([key isKindOfClass:[NSString class]] && key.length) {
		// is this key already registered?
		NSURL * alreadyURL = [self URLForFileKey:key];
		if (alreadyURL) {
			NSAssert(![alreadyURL isEquivalentToURL4iTM3:fileURL],@"You missed something JL... Shame on u");
			// yes it is
			// is it a copy or is it a move
			if ([DFM fileExistsAtPath:alreadyURL.path]) {
				// it is a copy
				key = [self createNewFileKeyForURL:fileURL];
			} else {
				// it is a move
				// was it an absolute or a relative file name?
#warning NYI:I can't know  easily if the file name was absolute or relative...
				[self setURL:fileURL forFileKey:key];
			}
		} else {
			[self setURL:fileURL forFileKey:key];
		}
	} else {
		key = @"";
	}
	
//END4iTM3;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewFileKeyForURL:
- (NSString *)createNewFileKeyForURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self createNewFileKeyForURL:fileURL save:NO];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createNewFileKeyForURL:save:
- (NSString *)createNewFileKeyForURL:(NSURL *)fileURL save:(BOOL)shouldSave;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(fileURL != nil,@"Unexpected void file name,please report bug");
	// is it an already registered file name?
    NSString * key = [self fileKeyForURL:fileURL];
	if (key.length) {
		[self recordHandleToURL:fileURL];// just in case...
	// Are the corresponding link and alias up to date?
	//LOG4iTM3(@"key: %@,fileName: %@",key,fileName);
	//LOG4iTM3(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
		if (shouldSave) {
			[self saveDocument:nil];
		}
		NSAssert1([key isEqual:[self fileKeyForURL:fileURL]],(@"AIE AIE INCONSITENT STATE %@"),__iTM2_PRETTY_FUNCTION__);
		return key;
	}
	// it is not an already registered file name,as far as I could guess...
	key = [self fileKeyForRecordedURL:fileURL];
//LOG4iTM3(@"BEFORE cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	if (key.length) {
		[self setURL:fileURL forFileKey:key];
		[self recordHandleToURL:fileURL];// just in case...
//LOG4iTM3(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
		if (shouldSave) {
			[self saveDocument:nil];
		}
//LOG4iTM3(@"fileName:%@",fileName);
//LOG4iTM3(@"self.keyedNames:%@",self.keyedNames);
//LOG4iTM3(@"[self fileKeyForURL:fileName]:%@",[self fileKeyForURL:fileName]);
		NSAssert1([key isEqual:[self fileKeyForURL:fileURL]],(@"AIE AIE INCONSITENT STATE %@"),__iTM2_PRETTY_FUNCTION__);
		return key;
	}
	// it is not an already registered file name,as far as I could guess...
	// the given file seems to be a really new one
	key = [self.mainInfos nextAvailableKey];// WARNING!!! there once was a problem I don't understand here
	[self setURL:fileURL forFileKey:key];
	if (![key isEqualToString:[self fileKeyForURL:fileURL]]) {
		[self fileKeyForURL:fileURL];// stop here for debugging
	}
	NSAssert2([key isEqualToString:[self fileKeyForURL:fileURL]],@"***  ERROR:[self fileKeyForURL:...] is %@ instead of %@",[self fileKeyForURL:fileURL],key);
	[self updateChangeCount:NSChangeDone];
	for(iTM2SubdocumentsInspector * WC in self.windowControllers) {
		if ([WC respondsToSelector:@selector(updateOrderedFileKeys)]) {
			[WC updateOrderedFileKeys];
		}
	}
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"the new key for %@ (fileName)",fileURL);
		LOG4iTM3(@"is %@ (key)",key);
	}
	[self recordHandleToURL:fileURL];// just in case...
// Are the corresponding link and alias up to date?
//LOG4iTM3(@"key: %@,fileName: %@",key,fileName);
//LOG4iTM3(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	if (shouldSave) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self _recordHandleToURL:fileURL];
	NSURL * myURL = self.fileURL;
	if (![fileURL isEqualToFileURL4iTM3:myURL]) {
		[self _recordHandleToURL:myURL];
	}
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![DFM isWritableFileAtPath:self.fileURL.path]) {
		// We are asked for an information that does not exist, do nothing
		return;
	}
	if (fileURL.isFileURL) {
		NSString * K = [self fileKeyForURL:fileURL];
		if (K.length) {
			NSString * key = [K isEqualToString:@"."]?TWSProjectKey:K;
			BOOL isDirectory = NO;
			NSString * path = nil;
			NSString * projectName = self.fileURL.path;
			NSString * base = nil;
			base = [SPC finderAliasesSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			if ([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory
                    || [DFM createDirectoryAtPath:base withIntermediateDirectories:YES attributes:nil error:nil]) {
				if (![DFM fileExistsAtPath:(path = [base stringByAppendingPathComponent:@"Readme.txt"])]) {
					[@"This directory contains finder aliases to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [base stringByAppendingPathComponent:key];
//LOG4iTM3(@"alias to fileURL: %@",fileURL);
//LOG4iTM3(@"stored at path: %@",path);
				[DFM removeItemAtPath:path error:NULL];
				if ([DFM fileExistsAtPath:fileURL.path]) {
					NSError * localError = nil;
					NSData * bookmarkData = [fileURL bookmarkDataWithOptions:NSURLBookmarkCreationMinimalBookmark|NSURLBookmarkCreationSuitableForBookmarkFile
                        includingResourceValuesForKeys:[NSArray array]
                            relativeToURL:nil
                                error:&localError];
					if (localError) {
						[SDC presentError:localError];
					}
					if (bookmarkData) {
						NSURL * url = [NSURL fileURLWithPath:path];
						if (![NSURL writeBookmarkData:bookmarkData toURL:url
                            options:NSURLBookmarkCreationMinimalBookmark|NSURLBookmarkCreationSuitableForBookmarkFile
                                error:&localError]) {
							if (localError) {
								[SDC presentError:localError];
							} else if (iTM2DebugEnabled) {
								[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
									userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write a bookmark to %@ at %@",fileURL,path]
										forKey:NSLocalizedDescriptionKey]]];
							} else {
								LOG4iTM3(@"*** ERROR: Could not write a bookmark to %@ at %@ (report bug)",fileURL,path);
							}
						} else if (iTM2DebugEnabled>200) {
#warning: there is a big problem here
							// the operation is not revertible
                            NSAssert1((bookmarkData = [NSURL bookmarkDataWithContentsOfURL:url error:&localError]),@"Error: bookmark was just saved at %@",url);
							if (localError) {
								[SDC presentError:localError];
							}
                            NSURL * target = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:NULL error:&localError];
							if (localError) {
								[SDC presentError:localError];
							}
							NSAssert2([target isEqualToFileURL4iTM3:fileURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3],@"Error unexpected difference\n%@\nvs\n%@ (report bug)",fileURL,target);
						}
					}
				}
			} else if (iTM2DebugEnabled) {
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:2
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write bookmark information in\n%@",base]
						forKey:NSLocalizedDescriptionKey]]];
			} else {
				LOG4iTM3(@"Could not write bookmark information in\n%@",base);
			}
			base = [SPC absoluteSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			if ([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory
				|| [DFM createDirectoryAtPath:base withIntermediateDirectories:YES attributes:nil error:nil])
			{
				path = [base stringByAppendingPathComponent:@"Readme.txt"];
				if (![DFM fileExistsAtPath:path])
				{
					[@"This directory contains soft links to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [base stringByAppendingPathComponent:key];
//LOG4iTM3(@"fileURL is: %@",fileURL);
//LOG4iTM3(@"path is: %@",path);
				[DFM removeItemAtPath:path error:NULL];
				if (![DFM createSoftLinkAtPath4iTM3:path pathContent:fileURL.path])
				{
					if (iTM2DebugEnabled)
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create a symbolic link to %@ at %@",fileURL,path]
								forKey:NSLocalizedDescriptionKey]]];
					}
					else
					{
						LOG4iTM3(@"*** ERROR: Could not create a symbolic link %@ at %@ (report bug)",fileURL,path);
					}
				}
			}
			else if (iTM2DebugEnabled)
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write soft links information in\n%@",base]
						forKey:NSLocalizedDescriptionKey]]];
			}
			else
			{
				LOG4iTM3(@"Could not write soft links information in\n%@",base);
			}
			base = [SPC relativeSoftLinksSubdirectory];
			base = [projectName stringByAppendingPathComponent:base];
			if ([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory
				|| [DFM createDirectoryAtPath:base withIntermediateDirectories:YES attributes:nil error:nil])
			{
				path = [base stringByAppendingPathComponent:@"Readme.txt"];
				if (![DFM fileExistsAtPath:path])
				{
					[@"This directory contains relative soft links to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [base stringByAppendingPathComponent:key];
//LOG4iTM3(@"fileURL is: %@",fileURL);
//LOG4iTM3(@"path is: %@",path);
				[DFM removeItemAtPath:path error:NULL];
				NSString * dirName = self.fileURL.path;
				dirName = dirName.stringByDeletingLastPathComponent;
				NSString * relativeFileName = [fileURL.path stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:dirName];
				if (![DFM createSoftLinkAtPath4iTM3:path pathContent:relativeFileName])
				{
					if (iTM2DebugEnabled)
					{
						[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create a symbolic link to %@ at %@",relativeFileName,path]
								forKey:NSLocalizedDescriptionKey]]];
					}
					else
					{
						LOG4iTM3(@"*** ERROR: Could not create a soft link %@ at %@ (report bug)",relativeFileName,path);
					}
				}
			}
			else if (iTM2DebugEnabled)
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write soft links information in\n%@",base]
						forKey:NSLocalizedDescriptionKey]]];
			}
			else
			{
				LOG4iTM3(@"Could not write soft links information in\n%@",base);
			}
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeFileKey:
- (void)removeFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocument * document = [self subdocumentForFileKey:key];
	if (document)
	{
		[document canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__document:shouldRemove:key:) contextInfo:[key retain]];
	}
	else
	{
		[self _removeFileKey:key];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __document:shouldRemove:key:
- (void)__document:(NSDocument *)document shouldRemove:(BOOL)shouldClose key:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[key autorelease];
	if (shouldClose)
	{
		[document close];
		[self _removeFileKey:key];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _removeFileKey:
- (void)_removeFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"self.fileKeys are:%@",self.fileKeys);
	}
    [self setName:nil forFileKey:key];
    [self.mainInfos setProperties:nil forFileKey:key];
    [self.keyedSubdocuments removeObjectForKey:key];
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"self.fileKeys are:%@",self.fileKeys);
	}
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
//LOG4iTM3(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
    [cachedKeys removeObjectsForKeys:[cachedKeys allKeysForObject:key]];
//LOG4iTM3(@"AFTER  cachedKeys: %@",[IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
    [SPC flushCaches];
    NSEnumerator * E = [self.windowControllers objectEnumerator];
    id WC;
    while(WC = E.nextObject)
        if ([WC respondsToSelector:@selector(updateOrderedFileKeys)])
            [WC updateOrderedFileKeys];
	// then I remove all the references,either links or finder aliases,used as cache
	NSString * projectFileName = self.fileURL.path;
	NSString * subdirectory = [projectFileName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
	NSString * path = [[subdirectory stringByAppendingPathComponent:key] stringByAppendingPathExtension:iTM2SoftLinkExtension];
	if ([DFM fileExistsAtPath:path] && ![DFM removeItemAtPath:path error:NULL])
	{
		LOG4iTM3(@"*** ERROR: I could not remove %@,please do it for me...",path);
	}
	subdirectory = [projectFileName stringByAppendingPathComponent:[SPC absoluteSoftLinksSubdirectory]];
	path = [[subdirectory stringByAppendingPathComponent:key] stringByAppendingPathExtension:iTM2SoftLinkExtension];
	if (([DFM fileExistsAtPath:path] || [DFM destinationOfSymbolicLinkAtPath:path error:NULL]) && ![DFM removeItemAtPath:path error:NULL])
	{
		LOG4iTM3(@"*** ERROR: I could not remove %@,please do it for me...",path);
	}
	[self saveDocument:nil];
//END4iTM3
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addURL:
- (void)addURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 09:04:46 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([fileURL isEquivalentToURL4iTM3:self.fileURL])
	{
		LOG4iTM3(@"I ignore:%@,it is the project",fileURL);            
	}
	else if ([self fileKeyForURL:fileURL])
	{
		LOG4iTM3(@"I ignore: %@,it is already there",fileURL);
	}
	else if ([self createNewFileKeyForURL:fileURL])
	{
		[self updateChangeCount:NSChangeDone];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
	else
	{
		LOG4iTM3(@"I ignore: %@,I don't want it...",fileURL);
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL*)url;
/*"Some projects are no close documents!!!
We must change the various caches.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 19 19:47:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// missing test for file extension ?
    if (url.isFileReferenceURL) {
        super.fileURL = url;
    }
    // normalize the URL
    url = url.normalizedDirectoryURL4iTM3;
	NSURL * old = self.fileURL;
	if (![old isEqual:url]) {
		// CLEAN the cached data
		[SPC flushCaches];
		[self.implementation takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(parentURL))];
		[self.implementation takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(factoryURL))];
		[self.implementation takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(contentsURL))];
		[super setFileURL:url];
		[self.mainInfos replaceProjectURL:url error:nil];
		// We must also manage the file URLs of the subdocuments
		for (NSDocument * document in self.subdocuments) {
			if (document.fileURL.baseURL) {
				// the document is expected to follow the project
				// the relative path should remain unchanged
				// only the base URL changes
				// If the documents did not change with the project
				// then they may point to nothing in the file system
				// The contentsURL might need some change
				// At first glance, the user will be given the opportunity to make the change by herself
				NSString * K = [self fileKeyForSubdocument:document];
				NSURL * newURL = [self URLForFileKey:K];
				document.fileURL = newURL;
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
/*"Designated creator.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 14:57:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (outErrorPtr) {
		* outErrorPtr = nil;
    }
	if ([fileURL isEquivalentToURL4iTM3:self.fileURL]) {
		if (display) {
			self.makeWindowControllers;
			self.showWindows;
		}
		return self;// this is when we open the wrapper
	}
	// I am not trying to open myself...
	if (!fileURL.isFileURL) {// only file urls are supported
		return nil;
	}
	if (![DFM fileExistsAtPath:fileURL.path]) {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"There is nothing at\n%@",fileURL]),nil);
		return nil;
	}
	fileURL = fileURL.URLByResolvingSymlinksInPath;// and finder aliases?
	if ([fileURL isEquivalentToURL4iTM3:self.wrapperURL]) {
		return self;// we should not get there!
	}
	// is it an already open document?
	// beware of the faraway project support (once implemented incompletely)
    NSDocument * doc = nil;
    for (doc in self.subdocuments) {
		NSURL * url = doc.fileURL;
		if (url.isFileURL) {
			url = [url URLByResolvingSymlinksAndFinderAliasesInPath4iTM3];
			if ([url isEqualToFileURL4iTM3:fileURL]) {
tahiti:
				if (display) {
					[doc makeWindowControllers];
					[doc showWindows];
				}
	//END4iTM3;
				[SDC noteNewRecentDocument:doc];
				return doc;
			}
		}
    }
	// Assign a key,if not already available
	if (!context) {
		context = [iTM2Document contextDictionaryFromURL:fileURL];
	}
	NSString * key = [self createNewFileKeyForURL:fileURL fileContext:context];
//LOG4iTM3(@"[self fileKeyForURL:fileName]:<%@>,key:%@",[self fileKeyForURL:fileName],key);
	if (key.length) {
		fileURL = [self URLForFileKey:key];// normalize the URL as side effect
		[SPC setProject:self forURL:fileURL];// this is the weaker link project<->file name, the sooner, the better
		// Is it a document managed by iTeXMac2? Some document might need an external helper
		NSString * typeName = [SDC typeForContentsOfURL:fileURL error:outErrorPtr];
		if ((!outErrorPtr ||!*outErrorPtr) && (doc = [SDC makeDocumentWithContentsOfURL:fileURL ofType:typeName error:outErrorPtr])) {
			[doc setFileURL:fileURL];
			[self addSubdocument:doc];
			if ([typeName isEqualToUTType4iTM3:iTM2WildcardDocumentType]) {
				// this kind of documents can be managed by external helpers
				if (display) {
					NSString * bundleIdentifier = [self propertyValueForKey:@"Bundle Identifier" fileKey:key contextDomain:iTM2ContextAllDomainsMask];
					if (bundleIdentifier && (
						[SWS openURLs:[NSArray arrayWithObject:fileURL] withAppBundleIdentifier:bundleIdentifier options:0 additionalEventParamDescriptor:nil launchIdentifiers:nil]
                            || [SWS openURLs:[NSArray arrayWithObject:fileURL] withAppBundleIdentifier:nil options:0 additionalEventParamDescriptor:nil launchIdentifiers:nil])) {
						[SDC noteNewRecentDocument:doc];
						return doc;
					}
				}
			}
			if ([doc readFromURL:fileURL ofType:typeName error:outErrorPtr]) {
				goto tahiti;
			}
			[self removeSubdocument:doc];
		}
		[SPC setProject:nil forURL:fileURL];// no more linkage
//LOG4iTM3(@"INFO:Could open document %@",fileName);
		if (outErrorPtr) {
			OUTERROR4iTM3(1,([NSString stringWithFormat:@"Cocoa could not create document at\n%@",fileURL]),(outErrorPtr?*outErrorPtr:nil));
		}
		return nil;
	}
	// is it an already registered document that changed its name?
	NSString * typeName = [SDC typeForContentsOfURL:fileURL error:outErrorPtr];
    if (!outErrorPtr && (doc = [SDC makeDocumentWithContentsOfURL:fileURL ofType:typeName error:outErrorPtr])) {
        [self addSubdocument:doc];
//LOG4iTM3(@"self:%@,has documents:%@",self,self.subdocuments);
        goto tahiti;
    } else {
        LOG4iTM3(@"Sorry,I could not create a document for:%@ (1)",fileURL);
    }
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSubdocumentForKey:display:outErrorPtr:
- (id)openSubdocumentForKey:(NSString *)key display:(BOOL)display error:(NSError**)outErrorPtr;
/*"Description forthhcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 15:01:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (outErrorPtr) {
		* outErrorPtr = nil;
	}
	// is it a document already open by the project
	NSDocument * D = [self subdocumentForFileKey:key];
	if (D) {
		if (display) {
			D.makeWindowControllers;
			D.showWindows;
		}
		return D;
	}
	// is it a document already open by the shared document controller
	// but not yet register to its project. This is not a natural situation...
	for (D in [SDC documents]) {
		if ([D.project4iTM3 isEqual:self] && [key isEqualToString:[self fileKeyForURL:D.fileURL]]) {
			if (display) {
				D.makeWindowControllers;
                D.showWindows;
			}
			return D;
		}
	}
	// I must open a new document
	NSURL * fileURL = [self URLForFileKey:key];
	NSURL * factoryURL = [self factoryURLForFileKey:key];
	BOOL onceMore = YES;
onceMore:
	if ([DFM fileExistsAtPath:fileURL.path]) {
		if ([factoryURL isEquivalentToURL4iTM3:fileURL]) {
			// both are the same, this is the expected situation.
absoluteFileNameIsChosen:
			return [self openSubdocumentWithContentsOfURL:fileURL context:nil display:display error:outErrorPtr];
		} else if ([DFM fileExistsAtPath:factoryURL.path]) {
			//Problem: there are 2 different candidates,which one is the best
			[SWS activateFileViewerSelectingURLs:[NSArray arrayWithObjects:factoryURL,fileURL,nil]];
			[NSApp activateIgnoringOtherApps:YES];
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"Which one do you want?",NSLocalizedDescriptionKey,
				[NSString stringWithFormat:@"1:%@\nor\n2:%@\n1 will be chosen unless you remove it now from the Finder.",fileURL,factoryURL],NSLocalizedRecoverySuggestionErrorKey,
					nil];
			[self presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:3 userInfo:dict]];
			if (onceMore) {
				onceMore = NO;
				goto onceMore;
			} else {
				goto absoluteFileNameIsChosen;
			}
		} else {
			goto absoluteFileNameIsChosen;
		}
	} else if (fileURL) {
#warning TEST HERE
		if ([DFM fileExistsAtPath:factoryURL.path])
		{
			// I also choose the absolute file name.
			return [self openSubdocumentWithContentsOfURL:factoryURL context:nil display:display error:outErrorPtr];
		}
		NSURL * recordedURL = [self recordedURLForFileKey:key];
		BOOL isDirectory;
		if ([DFM fileExistsAtPath:recordedURL.path isDirectory:&isDirectory] && !isDirectory) {
			if ([recordedURL.path belongsToDirectory4iTM3:self.fileURL.path.stringByDeletingLastPathComponent]) {
				[self setURL:recordedURL forFileKey:key];
				return [self openSubdocumentWithContentsOfURL:recordedURL context:nil display:display error:outErrorPtr];
			} else {
				// make a copy of the file
				if ([DFM copyItemAtURL:recordedURL toURL:fileURL error:NULL]) {
					return [self openSubdocumentWithContentsOfURL:fileURL context:nil display:display error:outErrorPtr];
				}
			}
		}
		if ([factoryURL isEquivalentToURL4iTM3:fileURL]) {
			// problem: no file available
			OUTERROR4iTM3(2,([NSString stringWithFormat:@"No file at\n%@",fileURL]),(outErrorPtr?*outErrorPtr:nil));
		} else {
			// problem: no files available
			OUTERROR4iTM3(1,([NSString stringWithFormat:@"No file at\n%@\nnor\n%@",fileURL,factoryURL]),(outErrorPtr?*outErrorPtr:nil));
		}
	}
	// else the key does not correspond to a file,it has certainly been removed and we've been asked for a scorie.
//END4iTM3;
    return nil;
}
#pragma mark =-=-=-=-=-  DOCUMENT <-> KEY
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyedSubdocuments
- (NSMapTable *)keyedSubdocuments;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 15:05:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = metaGETTER;
    if (!result) {
        metaSETTER([NSMapTable mapTableWithStrongToWeakObjects]);
        result = metaGETTER;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForSubdocument:
- (NSString *)fileKeyForSubdocument:(NSDocument *)subdocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 15:05:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self ownsSubdocument:subdocument]) {
        NSString * result = [[self.keyedSubdocuments.dictionaryRepresentation allKeysForObject:subdocument] lastObject];
		if (result) {
			return result;
		}
		NSURL * fileURL = subdocument.fileURL;
		result = [self fileKeyForURL:fileURL];
		if (!result.length) {
			result = [self createNewFileKeyForURL:fileURL];
		}
		NSAssert2(result.length,@"There is a patent inconsistency:the project\n%@\ndoes not want the subdocument\n%@",self.fileURL,fileURL);
		[self.keyedSubdocuments setObject:subdocument forKey:result];
		return result;
    }
    return [self fileKeyForURL:subdocument.fileURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentForFileKey:
- (id)subdocumentForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocument * result = [self.keyedSubdocuments objectForKey:key];
	if ([self ownsSubdocument:result])
		return result;
	[self.keyedSubdocuments removeObjectForKey:key];
    return nil;
}
#pragma mark =-=-=-=-=-  PROPERTIES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertyValueForKey:fileKey:contextDomain:
- (id)propertyValueForKey:(NSString *)key fileKey:(NSString *)fileKey contextDomain:(NSUInteger)mask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(key);
	NSParameterAssert(fileKey);
	id result = nil;
	id Ps = [self.mainInfos propertiesForFileKey:fileKey];
	if (result = [Ps valueForKey:key])
	{
		return result;
	}
    return [self contextValueForKey:key fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPropertyValue:forKey:fileKey:contextDomain:
- (void)setPropertyValue:(id)property forKey:(NSString *)aKey fileKey:(NSString *)fileKey contextDomain:(NSUInteger)mask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self.mainInfos setPropertyValue:property forKey:aKey fileKey:fileKey])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL)
	{
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"Only file URLs are supported,no:\n%@",absoluteURL]),nil);
		return NO;
	}
	BOOL result = [super writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr];
	if (!result)
	{
		LOG4iTM3(@"WHAT CAN I DO,no save possible...%@",(outErrorPtr?(id)(*outErrorPtr):@"NOTHING"));
	}
	NSString * fullProjectPath = absoluteURL.path;
#warning DEBUG
	BOOL isDirectory = NO;
	if ([DFM fileExistsAtPath:fullProjectPath isDirectory:&isDirectory] && !isDirectory)
	{
		LOG4iTM3(@"*** TEST: what the hell,I want to change the current directory to %@",fullProjectPath);
	}
	if (saveOperation == NSSaveOperation)
	{
		// just save the subdocuments where they normally stand...
		NSEnumerator * E = [self.subdocuments objectEnumerator];
		NSDocument * D;
		while(D = E.nextObject)
		{
			if ([D isDocumentEdited])
			{
				NSLock * L = [[[NSLock alloc] init] autorelease];
				[L lock];
				NSURL * url = [[D.fileURL retain] autorelease];
				NSString * fileType = [D fileType];
				if ([D writeSafelyToURL:url ofType:fileType forSaveOperation:saveOperation error:outErrorPtr])
//				if ([D writeToURL:url ofType:fileType forSaveOperation:saveOperation originalContentsURL:url error:outErrorPtr])
				{
					[D updateChangeCount:NSChangeCleared];
#if 1
		// COMMENT: if we put this trick here, then the document has lost its own name...and gets tagged as untitled
		// this trick is for the "document lost its FSRef" problem
		// when in continuous typesetting mode,
		// we cannot save transparently
		// the document has the expected file name and url but some internals are broken
		// such that the internals no longer make the URL point to the proper file node
		NSURL * url = self.fileURL;
		[self setFileURL:nil];
		[self setFileURL:url];
#endif
				}
				else
				{
					LOG4iTM3(@"*** FAILURE: document could not be saved at:\n%@",D.fileURL);
					result = NO;
				}
				[L unlock];
			}
		}
	}
	else if (saveOperation == NSSaveAsOperation)
	{
		// just save the subdocuments where they normally stand...
		NSEnumerator * E = [self.subdocuments objectEnumerator];
		NSDocument * D;
		while(D = E.nextObject)
		{
			NSString * key = [self fileKeyForSubdocument:D];
			NSString * name = [self nameForFileKey:key];
			if ([name hasPrefix:@".."])
			{
				[self setURL:D.fileURL forFileKey:key];
			}
			else
			{
				[D setFileURL:[self URLForFileKey:key]];
			}
			if ([D isDocumentEdited])
			{
				if ([D writeSafelyToURL:D.fileURL ofType:[D fileType] forSaveOperation:saveOperation error:outErrorPtr])
				{
					[D updateChangeCount:NSChangeCleared];
				}
				else
				{
					LOG4iTM3(@"*** FAILURE: document for key %@ could not be saved",key);
					[D updateChangeCount:NSChangeCleared];
					result = NO;
				}
			}
		}
	}
	else if (saveOperation == NSSaveToOperation)
	{
		NSEnumerator * E = [self.subdocuments objectEnumerator];
		NSDocument * D;
		while(D = E.nextObject)
		{
			NSString * K = [self fileKeyForSubdocument:D];
			if (K.length)
			{
				NSString * relativePath = [self nameForFileKey:K];
				NSString * fullPath = [fullProjectPath stringByAppendingPathComponent:relativePath];
				[DFM createDirectoryAtPath:fullPath.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil];
				NSURL * url = [NSURL fileURLWithPath:fullPath];
				if (![D writeSafelyToURL:url ofType:[D fileType] forSaveOperation:saveOperation error:outErrorPtr])
				{
					LOG4iTM3(@"*** FAILURE: document for key %@ could not be saved",K);
					result = NO;
				}
				if ((saveOperation == NSSaveOperation)|| (saveOperation == NSSaveAsOperation))
					[D updateChangeCount:NSChangeCleared];
			}
			else
			{
				LOG4iTM3(@"*** WARNING: No key for a project document");
			}
		}
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareProjectCompleteWriteMetaToURL4iTM3:ofType:error:
- (BOOL)prepareProjectCompleteWriteMetaToURL4iTM3:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//	[self prepareFrontendCompleteWriteToURL4iTM3:fileURL ofType:type error:outErrorPtr];// create the frontend dedicated directory inside the project
	NSMutableArray * mra = [NSMutableArray array];
	NSEnumerator * E = [self.subdocuments objectEnumerator];
	id D;
	while(D = E.nextObject)
	{
		NSURL * url = [D originalFileURL4iTM3];
		NSString * K = [self fileKeyForURL:url];
		if (K)
		{
			[mra addObject:K];
		}
		else
		{
			LOG4iTM3(@"****  WARNING:The project document had no key:%@",url);
			if (K = [self createNewFileKeyForURL:url])
			{
				[mra addObject:K];
			}
		}
	}
	[self takeContextValue:mra forKey:iTM2ContextOpenDocuments domain:iTM2ContextAllDomainsMask];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareFrontendCompleteWriteToURL4iTM3:ofType:error:
- (BOOL)prepareFrontendCompleteWriteToURL4iTM3:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// aliases and symlinks might not be fully supported here.
    BOOL result = YES;
	NSString * fileName = fileURL.path;
//LOG4iTM3(@"fileName is: %@",fileName);
	fileName = [fileName lazyStringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
//LOG4iTM3(@"fileName is: %@",fileName);
	// I should have a directory there
	BOOL isDir = NO;
	if ([DFM fileExistsAtPath:fileName isDirectory:&isDir] && !isDir)
	{
		[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nwas unexpected and will be recycled",fileName] forKey:NSLocalizedDescriptionKey]]];
		[SWS activateFileViewerSelectingURLs:[NSArray arrayWithObject:[NSURL fileURLWithPath:fileName]]];
		// it is not a directory: recycle it.
		NSInteger tag;
		if ([SWS performFileOperation:NSWorkspaceRecycleOperation source:fileName.stringByDeletingLastPathComponent destination:@"" files:[NSArray arrayWithObject:fileName.lastPathComponent] tag:&tag])
		{
			[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
				userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nwas unexpected and was recycled",fileName] forKey:NSLocalizedDescriptionKey]]];
		}
		else
		{
			NSString * fileNamePutAside = [fileName.stringByDeletingPathExtension stringByAppendingPathExtension:@"put_aside_by_iTeXMac2"];
			if ([DFM fileExistsAtPath:fileNamePutAside] && ![DFM removeItemAtPath:fileNamePutAside error:NULL])
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nshould be recycled...",fileNamePutAside] forKey:NSLocalizedDescriptionKey]]];
			}
			if (![DFM copyItemAtPath:fileName toPath:fileNamePutAside error:NULL])
			{
				[SDC presentError:[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nhas been put aside...",fileNamePutAside] forKey:NSLocalizedDescriptionKey]]];
			}
			if (![DFM removeItemAtPath:fileName error:NULL])
			{
				if (outErrorPtr)
				{
					*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:tag
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove\n%@\nDon't be surprised if things don't work as expected...",fileNamePutAside] forKey:NSLocalizedDescriptionKey]];
				}
				else
				{
					LOG4iTM3(@"Could not remove\n%@\nDon't be surprised if things don't work as expected...",fileNamePutAside);
				}
				return NO;
			}
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveAllSubdocumentsWithDelegate:didSaveSelector:contextInfo:
- (void)saveAllSubdocumentsWithDelegate:(id)delegate didSaveAllSelector:(SEL)action contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(id)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1:03/10/2002
To Do List:to be improved... to allow different signature
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.mutableSubdocuments4iTM3 makeObjectsPerformSelector:@selector(saveDocument:)withObject:self];
    BOOL resultFlag = YES;
    NSMethodSignature * myMS = [self methodSignatureForSelector:
                                    @selector(_fakeProject:didSaveAllSubdocuments:contextInfo:)];
    if ([myMS isEqual:[delegate methodSignatureForSelector:action]])
    {
        NSInvocation * I = [[NSInvocation invocationWithMethodSignature:myMS] retain];
        [I setSelector:action];
        I.target = delegate;
        [I setArgument:&self atIndex:2];
        [I setArgument:&resultFlag atIndex:3];
        if (contextInfo)
            [I setArgument:&contextInfo atIndex:4];
        [I invoke];
		[I release];
    }
    else
    {
	//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteLoadContext4iTM3:
- (void)projectCompleteLoadContext4iTM3:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// this is where oui set up initial context values
	id expected = [self contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextStandardLocalMask];
	if (![expected respondsToSelector:@selector(boolValue)])
	{
		expected = [self contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextAllDomainsMask];
		if ([expected respondsToSelector:@selector(boolValue)])
		{
			[self takeContextValue:expected forKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextStandardLocalMask];
		}
	}
	if (![self propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextStandardLocalMask])
	{
		expected = [self contextValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextAllDomainsMask];//something should be returned because this registered as defaults in the string formatter kit
		[self setPropertyValue:expected forKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextStandardLocalMask];
	}
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  WRAPPER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapper
- (id)wrapper;
/*"Lazy initializer. Not yet supported.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:55:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id lazyWrapper = metaGETTER;
	if ([lazyWrapper isKindOfClass:[NSNull class]])
		return nil;
	else if (!lazyWrapper) {
		metaSETTER([NSNull null]);// reentrant management,BIG problem here
		NSURL * wrapperURL = self.wrapperURL;
		if (wrapperURL) {
			NSString * typeName = [SDC typeForContentsOfURL:wrapperURL error:NULL];
			if (lazyWrapper = [SDC makeDocumentWithContentsOfURL:wrapperURL ofType:typeName]) {
				metaSETTER(lazyWrapper);// the wrapper is automatically dealloc'd when the owner is dealloc'd.
//LOG4iTM3(@"[SDC documents] are:%@",[SDC documents]);
			}
			return lazyWrapper;
		} else
			return nil;
	}
//END4iTM3;
    return lazyWrapper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setWrapper:
- (void)setWrapper:(id)argument;
/*"Lazy initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:55:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
	[SDC removeDocument:argument];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapperURL
- (NSURL *)wrapperURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:56:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return self.fileURL.enclosingWrapperURL4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentAs:
- (IBAction)saveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocument * wrapper = self.wrapper4iTM3;
	if (wrapper)
		[wrapper saveDocumentAs:(id)sender];
	else
		[super saveDocumentAs:(id)sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentTo:
- (IBAction)saveDocumentTo:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocument * wrapper = self.wrapper4iTM3;
	if (wrapper)
		[wrapper saveDocumentTo:(id)sender];
	else
		[super saveDocumentTo:(id)sender];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self.fileURL belongsToFactory4iTM3])
		return nil;
	iTM2WrapperDocument * W = self.wrapper4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// really disable undo registration!!!
	BOOL needsToUpdate = self.needsToUpdate;
	NSUndoManager * UM = self.undoManager;
	BOOL isUndoRegistrationEnabled = [UM isUndoRegistrationEnabled];
	[UM disableUndoRegistration];
	[self.mutableSubdocuments4iTM3 makeObjectsPerformSelector:_cmd withObject:irrelevant];
	[super saveContext:irrelevant];
	if (isUndoRegistrationEnabled)
		[UM enableUndoRegistration];
	NSError ** outErrorPtr = nil;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] writeToURL:self.fileURL ofType:self.fileType error:outErrorPtr];
    [I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteWriteMetaToURL4iTM3:ofType:error:" signature:[I methodSignature] inherited:YES]];
	if (!needsToUpdate)
		[self recordFileModificationDateFromURL4iTM3:self.fileURL];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (result = [super getContextValueForKey:aKey domain:mask&iTM2ContextStandardLocalMask])
	{
		return result;
	}
	NSString * fileKey = @".";
	if (result = [self getContextValueForKey:aKey fileKey:fileKey domain:mask&iTM2ContextStandardLocalMask])
	{
		return result;
	}
    return [super getContextValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (NSUInteger)setContextValue:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * project = self.project4iTM3;
	id contextManager = self.contextManager;
	NSAssert2(((project != contextManager) || (!project && !contextManager) || ((id)project == self)),@"*** %@ %#x The document's project must not be the context manager!",__iTM2_PRETTY_FUNCTION__, self);
	NSUInteger didChange = [super setContextValue:object forKey:aKey domain:mask];
	NSString * fileKey = @".";// weird...
//LOG4iTM3(@"self.contextDictionary is:%@",self.contextDictionary);
    return didChange | [self setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:fileKey:domain;
- (id)contextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.contextDictionary is:%@",self.contextDictionary);
//END4iTM3;
    return [self getContextValueForKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:fileKey:domain;
- (id)getContextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask&iTM2ContextStandardLocalMask) {
		if ((result = [self metaInfoForKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil])) {
			return result;
		}
	}
	if (mask&iTM2ContextStandardProjectMask) {
		if ((result = [self metaInfoForKeyPaths:iTM2ProjectContextKeyedFilesKey,iTM2ProjectDefaultsKey,aKey,nil])) {
			return result;
		}
	}
	if (mask&iTM2ContextExtendedProjectMask) {
		NSString * fileName = [self nameForFileKey:fileKey];
		NSString * extensionKey = [fileName pathExtension];
		if (extensionKey.length) {
			if ((result = [self metaInfoForKeyPaths:iTM2ContextExtensionsKey,extensionKey,aKey,nil])) {
				return result;
			}
		}
		NSDocument * document = [self subdocumentForFileKey:fileKey];
		NSString * type = [document fileType];
		if (type.length) {
			if ((result = [self metaInfoForKeyPaths:iTM2ContextTypesKey,type,aKey,nil])) {
				return result;
			}
		}
		if (extensionKey.length) {
			NSURL * fileURL = [self URLForFileKey:fileKey];
			NSString * type4URL = [SDC typeForContentsOfURL:fileURL error:NULL];
			if (type4URL.length && ![type4URL isEqualToUTType4iTM3:type]) {
				if ((result = [self metaInfoForKeyPaths:iTM2ContextTypesKey,type4URL,aKey,nil])) {
					return result;
				}
			}
		}
	}
    return [fileKey isEqual:@"."]?[super getContextValueForKey:aKey domain:mask]:nil;// not self, reentrant code management
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:fileKey:domain:
- (NSUInteger)takeContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:fileKey:domain:
- (NSUInteger)setContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(aKey != nil);
	NSString * fileName = [self nameForFileKey:fileKey];// not the file name!
	if (!fileName.length && ![fileKey isEqual:iTM2ProjectDefaultsKey] && ![fileKey isEqual:@"."]) {
		return NO;
	}
	NSUInteger didChange = 0;
	if (mask & iTM2ContextStandardLocalMask) {
		if ([self setMetaInfo:object forKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil]) {
			didChange |= iTM2ContextStandardProjectMask;
		}
	}
	if (mask & iTM2ContextStandardProjectMask) {
		fileKey = iTM2ProjectDefaultsKey;
		if ([self setMetaInfo:object forKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil]) {
			didChange |= iTM2ContextStandardProjectMask;
		}
	}
	if (mask & iTM2ContextExtendedProjectMask) {
		NSString * extension = [fileName pathExtension];
		if (extension.length) {
			if ([self setMetaInfo:object forKeyPaths:iTM2ContextExtensionsKey,extension,aKey,nil]) {
				didChange |= iTM2ContextExtendedProjectMask;
			}
			NSURL * fileURL = [self URLForFileKey:fileKey];
			NSString * type4URL = [SDC typeForContentsOfURL:fileURL error:NULL];
			if (type4URL.length) {
				if ([self setMetaInfo:object forKeyPaths:iTM2ContextTypesKey,type4URL,aKey,nil]) {
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

@interface iTM2SubdocumentsInspector()
@property (readwrite, copy) NSMutableArray * orderedFileKeys;
@property (readwrite, assign) NSTableView * documentsView;
@end

@implementation iTM2SubdocumentsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2ProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2SubdocumentsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowShouldClose:
- (BOOL)windowShouldClose:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3:Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.window orderOut:self];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.updateOrderedFileKeys;
    self.window.delegate = self;
	// from Laurent Daudelin,mamasam START
	NSImageCell * imageCell = [[[NSImageCell alloc] initImageCell:nil] autorelease];
	[imageCell setImageScaling:NSScaleProportionally];
	NSTableView * documentsView = self.documentsView;
	NSTableColumn * TC = [documentsView tableColumnWithIdentifier:@"icon"];
	[TC setDataCell:imageCell];
	// from Laurent Daudelin,mamasam STOP
	NSArray * draggedTypes = [NSArray arrayWithObjects:NSFilenamesPboardType,NSURLPboardType,nil];
	[documentsView registerForDraggedTypes:draggedTypes];
    [super windowDidLoad];// validates the contents
//LOG4iTM3(@"the window class is:%@",NSStringFromClass([self.window class]));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateOrderedFileKeys
- (void)updateOrderedFileKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:19:13 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
    NSString * K;
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    for (K in PD.fileKeys)
        [MD setValue:K forKey:[PD nameForFileKey:K]];
    NSMutableArray * MRA = [NSMutableArray array];
    [MRA addObject:iTM2ProjectDefaultsKey];
    for (K in [MD.allKeys sortedArrayUsingSelector:@selector(compare:)])
		if (K.length)
			[MRA addObject:[MD valueForKey:K]];
	[self setOrderedFileKeys:MRA];
	id DV = self.documentsView;
    [DV reloadData];
	[DV setNeedsDisplay:YES];
	self.validateWindowContent4iTM3;
    return;
}
@synthesize orderedFileKeys = iVarOrderedFileKeys4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:19:23 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!displayName.length) {
        displayName = [self.document displayName];// retrieve the "untitled"
    }
    return [NSString stringWithFormat:
        NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)",iTM2ProjectTable,myBUNDLE,"blah (project name)"),
        [self.class prettyInspectorMode],
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName4iTM3:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName4iTM3:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:19:34 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // the format trick allows to have a return value even if nothing is defined in the locales...
    // it might be useless...
    return [self.class prettyInspectorMode];
}
#pragma mark =-=-=-=-=-  TABLEVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocumentsView:
- (void)setDocumentsView:(NSTableView *)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:19:40 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    ASSERT_INCONSISTENCY4iTM3(!argument || [argument isKindOfClass:[NSTableView class]]);
    if (iVarDocumentsView4iTM3 != argument) {
        iVarDocumentsView4iTM3.delegate = iVarDocumentsView4iTM3.dataSource = nil;
        if ((iVarDocumentsView4iTM3 = argument)) {
            iVarDocumentsView4iTM3.delegate = iVarDocumentsView4iTM3.dataSource = iVarDocumentsView4iTM3.target = self;
            argument.doubleAction = @selector(_tableViewDoubleAction:);
        }
    }
    return;
}
@synthesize documentsView = iVarDocumentsView4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:19:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.orderedFileKeys.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 17:19:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSArray * fileKeys = self.orderedFileKeys;
    NSUInteger top = fileKeys.count;
    if (!row) {
        return [tableColumn.identifier isEqualToString:@"icon"]? nil:NSLocalizedStringFromTableInBundle(@"Default",iTM2ProjectTable,myBUNDLE,"");  
    } else if (row>0 && row<top) {
        iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
		NSString * key = [fileKeys objectAtIndex:row];
		if ([tableColumn.identifier isEqualToString:iTM2PDTableViewPathIdentifier]) {
			return [PD nameForFileKey:key];
		}
        NSURL * inAbsoluteURL = [PD URLForFileKey:key];
		if ([tableColumn.identifier isEqualToString:iTM2PDTableViewTypeIdentifier]) {
			return [SDC localizedTypeForContentsOfURL:inAbsoluteURL error4iTM3:nil]?:@"";// retained by the SDC
		}
		if ([DFM fileExistsAtPath:inAbsoluteURL.path]) {
			return [SWS iconForFile:inAbsoluteURL.path];
		}
        NSURL * factoryURL = [PD factoryURLForFileKey:key];
		return [SWS iconForFile:factoryURL.path];
    } else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)tableView setObjectValue:(NSString *)name forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming. NOT USED!
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	//  name is expected to be either a full path or a relative path
    //  When relevant, this is relative to the contents directory of the project
    if (![tableColumn.identifier isEqualToString:iTM2PDTableViewPathIdentifier])
		return;
    NSArray * fileKeys = self.orderedFileKeys;
    NSUInteger top = fileKeys.count;
    if (row>0 && row<top) {
        iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
		NSString * otherKey = [PD fileKeyForName:name];
		if (otherKey.length) {
			LOG4iTM3(@"INFO:the new relative path is already in use,nothing changed.");
			return;
		}
		NSString * key = [fileKeys objectAtIndex:row];
        NSString * oldName = [PD nameForFileKey:key];
		if (![oldName isEqual:name]) {
			NSString * absolute = [[PD URLForFileKey:key] path];
			// if the file was already existing,just move it around without removing existing files
			if ([DFM fileExistsAtPath:absolute]) {
				[PD setURL:[NSURL fileURLWithPath:name] forFileKey:key];
				NSString * newAbsolute = [[PD URLForFileKey:key] path];
				if ([DFM createDirectoryAtPath:newAbsolute.stringByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:nil])
				{
					if (![DFM copyItemAtPath:absolute toPath:newAbsolute error:NULL])
					{
						[PD setURL:[NSURL fileURLWithPath:oldName] forFileKey:key];// revert
						LOG4iTM3(@"*** ERROR:Could not move %@ to %@\ndue to problem %i,please do it by hand",absolute,newAbsolute);
					}
					// the concerned documents should now that a file name has changed
				} else {
					[PD setURL:[NSURL fileURLWithPath:oldName] forFileKey:key];// revert
					LOG4iTM3(@"*** ERROR:Could not create %@,please do it by hand",newAbsolute.stringByDeletingLastPathComponent);
				}
			}
			else
			{
				[PD setURL:[NSURL fileURLWithPath:name] forFileKey:key];
			}
		}
    }
	self.updateOrderedFileKeys;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:willDisplayCell:forTableColumn:row:
- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([[aTableColumn identifier] isEqualToString:iTM2PDTableViewPathIdentifier])
	{
		if (rowIndex)
		{
			NSArray * fileKeys = self.orderedFileKeys;
			NSString * key = [fileKeys objectAtIndex:rowIndex];
			iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
			NSString * absolute = [[PD URLForFileKey:key] path];
			NSString * faraway = [[PD factoryURLForFileKey:key] path];
			BOOL YORN = [DFM fileExistsAtPath:absolute] || [DFM fileExistsAtPath:faraway];
			[aCell setTextColor:(YORN? [NSColor controlTextColor]:[NSColor disabledControlTextColor])];
		}
		else
		{
			NSAttributedString * AS = [aCell attributedStringValue];
			if (AS.length)
			{
				NSMutableDictionary * attributes = [[[AS attributesAtIndex:0 effectiveRange:nil] mutableCopy] autorelease];
				NSFont * actualFont = [attributes objectForKey:NSFontAttributeName];
				NSFont * txtFont = [NSFont boldSystemFontOfSize:[actualFont pointSize]];
				if (txtFont)
				{
					[attributes setObject:txtFont forKey:NSFontAttributeName];
					NSAttributedString *attrStr = [[[NSAttributedString alloc]
														initWithString:[AS string] attributes:attributes] autorelease];
					[aCell setAttributedStringValue:attrStr];
				}
			}
		}
	}
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:shouldEditTableColumn:row:
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [iTM2EventObserver isAlternateKeyDown] && [tableColumn.identifier isEqualToString:iTM2PDTableViewPathIdentifier] && (row>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _tableViewDoubleAction:
- (IBAction)_tableViewDoubleAction:(NSTableView *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:26:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSArray * fileKeys = self.orderedFileKeys;
    NSInteger row = sender.selectedRow;
    iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
    if ((row>=0)&& (row<fileKeys.count)) {
        NSString * K = [fileKeys objectAtIndex:row];
		if ([K isEqual:iTM2ProjectDefaultsKey]) {
			return;
		}
		NSError * localError = nil;
		if ([PD openSubdocumentForKey:K display:YES error:&localError]) {
			return;
		}
		if (localError) {
			[SDC presentError:localError];
		}
		for (NSDrawer * D in self.window.drawers) {
			if ([D.contentView controlWithAction:@selector(fileNameEdited:)])
			{
				[D open:nil];
				break;
			}
		}
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:toolTipForCell:rect:tableColumn:row:mouseLocation::
- (NSString *)tableView:(NSTableView *)tv toolTipForCell:(NSCell *)cell rect:(NSRectPointer)rectRef tableColumn:(NSTableColumn *)tc row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation;
/*"Thx http://www.corbinstreehouse.com/blog/?p=50.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:29:43 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([tc.identifier isEqual:iTM2PDTableViewPathIdentifier]) {
		NSArray * fileKeys = self.orderedFileKeys;
		if (row>0 && row<fileKeys.count) {
			iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
			NSString * key = [fileKeys objectAtIndex:row];
			return [PD URLForFileKey:key].path;
		}
	}
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
		NSAttributedString * AS = cell.attributedStringValue;
        if (AS.size.width > rectRef->size.width) {
//END4iTM3;
            return cell.stringValue;
        }
    }
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:writeRowsWithIndexes:toPasteboard:
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:35:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSArray * fileKeys = self.orderedFileKeys;
	iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
	NSMutableArray * array = [NSMutableArray array];
	NSUInteger row = [rowIndexes firstIndex];
	while (row != NSNotFound) {
		[array addObject:[PD URLForFileKey:[fileKeys objectAtIndex:row]]];
		row = [rowIndexes indexGreaterThanIndex:row];
	}
//END4iTM3;
    return array.count>0 && ([pboard clearContents],[pboard writeObjects:array]);
}
- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
    // Add code here to validate the drop
	iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
	NSURL * projectURL = PD.fileURL;
	if ([projectURL belongsToFactory4iTM3]) {
		return NSDragOperationNone;
	}
	NSPasteboard * draggingPasteboard = [info draggingPasteboard];
    NSArray *classArray = [NSArray arrayWithObject:[NSURL class]]; // types of objects you are looking for
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSPasteboardURLReadingFileURLsOnlyKey];
    NSArray *arrayOfURLs = [draggingPasteboard readObjectsForClasses:classArray options:options]; // read objects of those classes

    for (NSURL * url in arrayOfURLs) {
        BOOL isDirectory = NO;
        NSURL * contentsURL = [PD URLForFileKey:TWSContentsKey];
        NSURL * factoryURL = [PD URLForFileKey:TWSFactoryKey];
        if (![PD fileKeyForURL:url]
                &&([url isRelativeToURL4iTM3:contentsURL] || [url isRelativeToURL4iTM3:factoryURL])
                &&([DFM fileExistsAtPath:url.path isDirectory:&isDirectory] && !isDirectory)) {
            return NSDragOperationCopy;
        }
    }
    return NSDragOperationNone;
}
- (BOOL)tableView:(NSTableView *)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op
{
	BOOL result = NO;
	iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
	NSURL * projectURL = PD.fileURL;
	if ([projectURL belongsToFactory4iTM3]) {
		return result;
	}
	NSPasteboard * draggingPasteboard = [info draggingPasteboard];
    NSArray *classArray = [NSArray arrayWithObject:[NSURL class]]; // types of objects you are looking for
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:NSPasteboardURLReadingFileURLsOnlyKey];
    NSArray *arrayOfURLs = [draggingPasteboard readObjectsForClasses:classArray options:options]; // read objects of those classes

    for (NSURL * url in arrayOfURLs) {
        BOOL isDirectory = NO;
        NSURL * contentsURL = [PD URLForFileKey:TWSContentsKey];
        NSURL * factoryURL = [PD URLForFileKey:TWSFactoryKey];
        if (![PD fileKeyForURL:url]
                &&([url isRelativeToURL4iTM3:contentsURL] || [url isRelativeToURL4iTM3:factoryURL])
                &&([DFM fileExistsAtPath:url.path isDirectory:&isDirectory] && !isDirectory)) {
            result = YES;
        }
    }
    return result;
}

#if 0
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView;
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row;
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
Latest Revision: Wed Mar 17 14:45:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([NSApp tryToPerform:@selector(newDocumentFromRunningAssistantPanelForProject4iTM3:)with:self.document]) {
		return;
	}
	[SDC newDocument:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  importDocument:
- (IBAction)importDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:49:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSOpenPanel * OP = [NSOpenPanel openPanel];
	NSString * oldDirectory = [OP directory];
    [OP setCanChooseFiles:YES];
    [OP setCanChooseDirectories:NO];
    [OP setTreatsFilePackagesAsDirectories:YES];
    [OP setAllowsMultipleSelection:YES];
    OP.delegate = self;
    [OP setResolvesAliases:YES];
	[OP setPrompt:NSLocalizedStringFromTableInBundle(@"Add",iTM2ProjectTable,myBUNDLE,"")];
	NSString * directory = [self.document URLForFileKey:TWSContentsKey].path;
    [OP beginSheetForDirectory:directory
        file:nil types:nil modalForWindow:self.window
            modalDelegate:self didEndSelector:@selector(openPanelDidImportDocument:returnCode:contextInfo:)
				contextInfo:(oldDirectory? [NSDictionary dictionaryWithObject:oldDirectory forKey:@"oldDirectory"]:nil)];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openPanelDidImportDocument:returnCode:contextInfo:
- (void)openPanelDidImportDocument:(NSOpenPanel *)sheet returnCode:(NSInteger)returnCode contextInfo:(NSDictionary *)contextInfo
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:06:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[contextInfo autorelease];
	id oldDirectory = [contextInfo objectForKey:@"oldDirectory"];
	if (oldDirectory) {
		[sheet setDirectory:oldDirectory];
	}
    if (NSOKButton == returnCode) {
		// Always copy to the close location, not the Writable Projects location...
		// Always copy stuff that do not belong to the faraway folder
		NSMutableArray * URLs = [sheet.URLs mutableCopy];
        NSURL * URL = nil;
		iTM2ProjectDocument * PD = self.document;
		NSURL * contentsURL = [PD URLForFileKey:TWSContentsKey];
		NSMutableArray * copiables = [NSMutableArray array];
        for (URL in sheet.URLs) {
			if (![URL isEquivalentToURL4iTM3:contentsURL] && ![URL isEquivalentToURL4iTM3:contentsURL]) {
				[copiables addObject:URL];
				[URLs removeObject:URL];
			}
		}
		if (copiables.count) {
			NSInteger code = NSRunAlertPanel(
					NSLocalizedStringFromTableInBundle(@"Project Documents Panel",iTM2ProjectTable,myBUNDLE,""),
					NSLocalizedStringFromTableInBundle(@"Copy the documents in the project folder?",iTM2ProjectTable,myBUNDLE,""),
					NSLocalizedStringFromTableInBundle(@"Yes",iTM2ProjectTable,myBUNDLE,""),
					nil,
					NSLocalizedStringFromTableInBundle(@"No",iTM2ProjectTable,myBUNDLE,"")
				);
			if (code == NSAlertDefaultReturn) {
				BOOL problem = NO;
				for (URL in copiables) {
					NSString * lastComponent = URL.lastPathComponent;
					NSURL * targetURL = [contentsURL URLByAppendingPathComponent:lastComponent];
					if ([DFM fileExistsAtPath:targetURL.path] || [DFM destinationOfSymbolicLinkAtPath:targetURL.path error:NULL]) {
						problem = YES;
					} else {
						NSURL * dirURL = URL.URLByDeletingLastPathComponent;
						NSInteger tag;
						if ([SWS performFileOperation:NSWorkspaceCopyOperation source:dirURL.path
										destination:contentsURL.path files:[NSArray arrayWithObject:lastComponent] tag:&tag]) {
							[PD addURL:targetURL];
							[PD openSubdocumentWithContentsOfURL:targetURL context:nil display:YES error:nil];
							[URLs removeObject:URL];
						} else {
							LOG4iTM3(@"Could not copy synchronously file at %@ (tag is %i)",targetURL,tag);
						}
					}
				}
				if (problem) {
					NSRunAlertPanel(
						NSLocalizedStringFromTableInBundle(@"Project Documents Panel",iTM2ProjectTable,myBUNDLE,""),
						NSLocalizedStringFromTableInBundle(@"Name conflict,copy not complete.",iTM2ProjectTable,myBUNDLE,""),
						NSLocalizedStringFromTableInBundle(@"Acknowledge",iTM2ProjectTable,myBUNDLE,""),
						nil,
						nil);
				}
			}
		}
        for (URL in URLs) {
			[PD openSubdocumentWithContentsOfURL:URL context:nil display:YES error:nil];
		}
    }
	self.updateOrderedFileKeys;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  copyProjectDocumentSheetDidDismiss:returnCode:copiables:
- (void)copyProjectDocumentSheetDidDismiss:(NSWindow *)sheet returnCode:(NSInteger)returnCode copiables:(NSMutableArray *)copiables;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:06:26 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (returnCode == NSAlertDefaultReturn) {
		BOOL problem = NO;
		iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
		NSURL * contentsURL = [PD URLForFileKey:TWSContentsKey];
		for (NSURL * URL in copiables) {
			NSString * lastComponent = URL.lastPathComponent;
			NSURL * targetURL = [contentsURL URLByAppendingPathComponent:lastComponent];
			if ([DFM fileExistsAtPath:targetURL.path] || [DFM destinationOfSymbolicLinkAtPath:targetURL.path error:NULL]) {
				problem = YES;
			} else {
				NSURL * dirURL = URL.URLByDeletingLastPathComponent;
				NSInteger tag;
                if ([SWS performFileOperation:NSWorkspaceCopyOperation source:dirURL.path
								destination:contentsURL.path files:[NSArray arrayWithObject:lastComponent] tag:&tag]) {
					[PD addURL:targetURL];
					[PD openSubdocumentWithContentsOfURL:targetURL context:nil display:YES error:nil];
				} else {
					LOG4iTM3(@"Could not copy synchronously file at %@ (tag is %i)",URL,tag);
				}
			}
		}
		if (problem) {
			NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Project documents panel",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Acknowledge",iTM2ProjectTable,myBUNDLE,""),
			nil,
			nil,
			self.window,// bof
			nil,
			NULL,
			NULL,
			nil,
			NSLocalizedStringFromTableInBundle(@"Name conflict,copy not complete.",iTM2ProjectTable,myBUNDLE,""));
		}
	}
	self.updateOrderedFileKeys;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeDocument:
- (IBAction)removeDocument:(NSView *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:56:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSArray * fileKeys = self.orderedFileKeys;
    NSRange R = iTM3MakeRange(0,fileKeys.count);
    iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
    NSURL * dirURL = PD.fileURL.URLByRemovingFactoryBaseURL4iTM3.parentDirectoryURL4iTM3;
	NSMutableArray * recyclable = [NSMutableArray array];
	NSMutableArray * removable = [NSMutableArray array];
 	NSIndexSet * IS = self.documentsView.selectedRowIndexes;
	NSInteger index = IS.firstIndex;
	NSString * fileKey = nil;
	while(index != NSNotFound) {
		if (iTM3LocationInRange(index,R)) {
            [PD updateChangeCount:NSChangeDone];// RAISE
			fileKey = [fileKeys objectAtIndex:index];
			NSURL * url = [PD URLForFileKey:fileKey];
			if (![url isEquivalentToURL4iTM3:PD.fileURL]// don't recycle the project
			   && ![url isEquivalentToURL4iTM3:dirURL]// nor its containing directory!!!
                    && ([DFM fileExistsAtPath:url.path] || [DFM destinationOfSymbolicLinkAtPath:url.path error:NULL])) {
				// if the file belongs to another project it should not be recycled
				[recyclable addObject:fileKey];
			} else {
				[removable addObject:fileKey];
			}
        }
		index = [IS indexGreaterThanIndex:index];
	}
	for(fileKey in removable) {
		[PD removeFileKey:fileKey];
	}
	self.updateOrderedFileKeys;
	if (recyclable.count)
        NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Suppressing project documents references",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Keep",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Recycle",iTM2ProjectTable,myBUNDLE,""),
			NSLocalizedStringFromTableInBundle(@"Cancel",iTM2ProjectTable,myBUNDLE,""),
			sender.window,
			self,
			NULL,
			@selector(removeSubdocumentSheetDidDismiss:returnCode:recyclable:),
			recyclable,
			NSLocalizedStringFromTableInBundle(@"Also recycle the selected project documents?",iTM2ProjectTable,myBUNDLE,""));
	// Inform the shared project controller that something has changed
	[SPC flushCaches];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRemoveDocument:
- (BOOL)validateRemoveDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:56:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return self.documentsView.numberOfSelectedRows > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSubdocumentSheetDidDismiss:returnCode:recyclable:
- (void)removeSubdocumentSheetDidDismiss:(NSWindow *)sheet returnCode:(NSInteger)returnCode recyclable:(NSMutableArray *)recyclable;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (returnCode == NSAlertOtherReturn)// cancel!!
		return;
	BOOL recycle = (returnCode == NSAlertAlternateReturn);
    iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
	NSDictionary * contextInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:recycle] forKey:@"recycle"];
    for(NSString * fileKey in recyclable) {
		NSURL * url = [PD URLForFileKey:fileKey];
		NSDocument * subdocument = [SDC documentForURL:url];
        if (subdocument) {
			[subdocument canCloseDocumentWithDelegate:self
				shouldCloseSelector:@selector(subdocument:shouldRemoveFromProject:contextInfo:)
					contextInfo:contextInfo];
		} else {
			NSString * lastComponent = url.lastPathComponent;
			NSURL * dirURL = url.URLByDeletingLastPathComponent;
			NSInteger tag;
			if (recycle) {
				if ([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirURL.path
								destination:@"" files:[NSArray arrayWithObject:lastComponent] tag:&tag]) {
					LOG4iTM3(@"Recycling synchronously file at %@ in directory %@...",lastComponent,dirURL);
				} else {
					LOG4iTM3(@"Could not recycle synchronously file at %@ (tag is %i)",url,tag);
				}
				[PD removeFileKey:fileKey];
			} else {
				NSURL * destinationURL = url.enclosingWrapperURL4iTM3;
				if (destinationURL) {
					destinationURL = destinationURL.URLByDeletingLastPathComponent;
					if ([SWS performFileOperation:NSWorkspaceMoveOperation source:dirURL.path
									destination:destinationURL.path files:[NSArray arrayWithObject:lastComponent] tag:&tag]) {
						LOG4iTM3(@"Moving file at %@ in directory %@...",lastComponent,dirURL);
					} else {
						LOG4iTM3(@"Could not move synchronously file at %@ (tag is %i)",url,tag);
					}
				}
				[PD removeFileKey:fileKey];
			}
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocument:shouldRemoveFromProject:contextInfo:
- (void)subdocument:(NSDocument *)subdocument shouldRemoveFromProject:(BOOL)shouldRemove contextInfo:(NSDictionary *)contextInfo
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:21:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!shouldRemove)
		return;
	NSURL * fileURL = subdocument.fileURL;
	iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
	NSString * fileKey = [PD fileKeyForURL:fileURL];
	if (!fileKey.length)
		return;
	BOOL recycle = [[contextInfo objectForKey:@"recycle"] boolValue];
	NSString * lastComponent = fileURL.lastPathComponent;
	NSURL * dirURL = fileURL.URLByDeletingLastPathComponent;
	NSInteger tag;
	if (recycle) {
		if ([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirURL.path
						destination:@"" files:[NSArray arrayWithObject:lastComponent] tag:&tag]) {
			LOG4iTM3(@"Recycling %@ from directory %@",lastComponent,dirURL);
		} else {
			LOG4iTM3(@"Could not recycle synchronously file at %@ (tag is %i)",fileURL,tag);
		}
    } else {
		NSURL * destinationURL = fileURL.enclosingWrapperURL4iTM3.URLByRemovingFactoryBaseURL4iTM3.parentDirectoryURL4iTM3;
		if (destinationURL) {
			if ([SWS performFileOperation:NSWorkspaceMoveOperation source:dirURL.path
							destination:destinationURL.path files:[NSArray arrayWithObject:lastComponent] tag:&tag])
			{
				LOG4iTM3(@"Moving file at %@ in directory %@...",lastComponent,dirURL);
			} else {
				LOG4iTM3(@"Could not move synchronously file at %@ (tag is %i)",destinationURL,tag);
			}
		}
	}
	[PD removeFileKey:fileKey];
    self.updateOrderedFileKeys;
	[subdocument canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(subdocument:shouldClose:contextInfo:) contextInfo:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocument:shouldClose:contextInfo:
- (void)subdocument:(NSDocument *)subdocument shouldClose:(BOOL)shouldClose contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:22:22 UTC 2010
To Do:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (shouldClose) {
		[subdocument close];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  panel:shouldEnableURL:
- (BOOL)panel:(id)sender shouldEnableURL:(NSURL *)fileURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:07:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = (iTM2ProjectDocument *)self.document;
	NSURL * url = PD.fileURL;
	if ([url isEquivalentToURL4iTM3:fileURL]) {
		return NO;
	}
	url = url.enclosingWrapperURL4iTM3;
	if ([url isEquivalentToURL4iTM3:fileURL]) {
		return NO;
	}
//END4iTM3;
    return [PD fileKeyForURL:fileURL].length == 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  help:
- (IBAction)help:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:22:27 UTC 2010
To Do iTM2ProjectDocument *ist:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectPathEdited:
- (IBAction)projectPathEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:22:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectPathEdited:
- (BOOL)validateProjectPathEdited:(NSTextField *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 14:22:39 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocument * doc = self.document;
	NSString * name = doc.fileURL.path?:(doc.displayName?:@"");
	sender.stringValue = name;
	sender.toolTip = name;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileNameEdited:
- (IBAction)fileNameEdited:(NSControl *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:03:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger row = self.documentsView.selectedRow;
    if (row < 0 || row >= self.documentsView.numberOfRows) {
        return;
	} else if (row) {
        NSString * oldRelative = [self.documentsView.dataSource
                        tableView:self.documentsView
                    objectValueForTableColumn:self.documentsView.tableColumns.lastObject
                row:row];
        if (oldRelative.length) {
			NSString * newRelative = sender.stringValue;
			if ([newRelative pathIsEqual4iTM3:oldRelative])
				return;
			iTM2ProjectDocument * PD = self.document;
			NSURL * dirURL = PD.fileURL.URLByDeletingLastPathComponent;
			NSURL * new = [dirURL URLByAppendingPathComponent:newRelative];
			NSString * key = [PD fileKeyForURL:new];
			if (key.length) {
				REPORTERROR4iTM3(1,([NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"The name %@ is already used.",iTM2ProjectTable,myBUNDLE,""),
					new]),nil);
				return;
			}
			NSURL * old = [dirURL URLByAppendingPathComponent:oldRelative];
			key = [PD fileKeyForURL:old];
			if (0 == key.length) {
				return;
			}
			NSError * localError = nil;
			if ([DFM createDirectoryAtPath:new.URLByDeletingLastPathComponent.path withIntermediateDirectories:YES attributes:nil error:&localError]) {
				if ([DFM fileExistsAtPath:old.path]) {
					if ([DFM fileExistsAtPath:new.path]) {
						[PD setURL:new forFileKey:key];
						[[PD subdocumentForURL:old] setFileURL:new];
						if (iTM2DebugEnabled) {
							LOG4iTM3(@"Name successfully changed from %@ to %@",old,new);
						}
					} else if ([DFM moveItemAtPath:old.path toPath:new.path error:NULL]) {
						[PD setURL:new forFileKey:key];
						[[PD subdocumentForURL:old] setFileURL:new];
						if (iTM2DebugEnabled) {
							LOG4iTM3(@"Name successfully changed from %@ to %@",old,new);
						}
					} else {
						REPORTERROR4iTM3(1,(NSLocalizedStringFromTableInBundle(@"A file could not be moved.",iTM2ProjectTable,myBUNDLE,"")),nil);
						return;
					}
				} else {
					[PD setURL:new forFileKey:key];
					[[PD subdocumentForURL:old] setFileURL:new];
					if (iTM2DebugEnabled) {
						LOG4iTM3(@"Name successfully changed from %@ to %@",old,new);
					}
				}
			} else {
				REPORTERROR4iTM3(1,(NSLocalizedStringFromTableInBundle(@"A directory could not be created.",iTM2ProjectTable,myBUNDLE,"")),localError);
				return;
			}
			[sender validateWindowContent4iTM3];
		}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFileNameEdited:
- (BOOL)validateFileNameEdited:(NSTextField *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:19:52 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL editable = NO;
	NSTableView * documentsView = self.documentsView;
	NSIndexSet * selectedRowIndexes = documentsView.selectedRowIndexes;
    NSString * p = nil;
	if (selectedRowIndexes.count == 0) {
        p = NSLocalizedStringFromTableInBundle(@"No selection",iTM2ProjectTable,myBUNDLE,"Description Forthcoming");
	} else if (selectedRowIndexes.count == 1) {
		NSUInteger row = selectedRowIndexes.firstIndex;
		NSTableColumn * TC = [documentsView tableColumnWithIdentifier:iTM2PDTableViewPathIdentifier];
		id dataSource = documentsView.dataSource;
        p = [dataSource tableView:documentsView objectValueForTableColumn:TC row:row];
        if (p.length) {
			editable = YES;
			//toolTip = [dataSource tableView:documentsView toolTipForCell:nil rect:nil tableColumn:TC row:row mouseLocation:NSZeroPoint];
		} else {
			p = NSLocalizedStringFromTableInBundle(@"Default",iTM2ProjectTable,myBUNDLE,"Description Forthcoming");
		}
	} else {
		p = NSLocalizedStringFromTableInBundle(@"Multiple selection",iTM2ProjectTable,myBUNDLE,"Description Forthcoming");
	}
    sender.stringValue = p?:@"ERROR";
	[sender setEditable:editable];
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  relativeToEdited:
- (IBAction)relativeToEdited:(NSPathControl *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRelativeToEdited:
- (BOOL)validateRelativeToEdited:(NSPathControl *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:20:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = [SPC projectForSource:self];
    sender.URL = [PD URLForFileKey:TWSContentsKey];
	sender.toolTip = sender.URL.path;
//START4iTM3;
    return YES;
}
@end

@implementation NSDocument(Project)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project4iTM3
- (id)project4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:20:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.hasProject4iTM3? [SPC projectForDocument:self]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapper4iTM3
- (id)wrapper4iTM3;
/*"Lazy initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = self.project4iTM3;
//END4iTM3;
    return (PD != self)? PD.wrapper4iTM3:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hasProject4iTM3
- (BOOL)hasProject4iTM3;
/*"Lazy initializer. If setHasProject4iTM3: has already been used, the value set then is returned.
If this is the first time the receiver is asked for hasProject, then its answer relies upon the project controller -projectForURL: method
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning FAILED: to be revisited, is it necessary to cache the project? Won't project for document or project for filename be efficient enough.
	id wrapper = metaGETTER;
	if (wrapper)// this assumes that setHasProject: is never called without good reason
	{
		return [wrapper boolValue];
	}
	id P = [SPC projectForURL:self.fileURL];// weaker link
	BOOL result = (P != nil);
	[self setHasProject4iTM3:result];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setHasProject4iTM3
- (void)setHasProject4iTM3:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:34:40 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    metaSETTER([NSNumber numberWithBool:yorn]);
	self.updateContextManager;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentCompleteSaveContext4iTM3:
- (void)subdocumentCompleteSaveContext4iTM3:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:34:49 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * url = self.fileURL;
	iTM2ProjectDocument * P = [SPC projectForURL:url];
	NSURL * projectURL = P.fileURL;
	NSData * aliasData = nil;
	if (projectURL) {
		[self takeContextValue:[[projectURL.path copy] autorelease] forKey:iTM2ProjectAbsolutePathKey domain:iTM2ContextPrivateMask];
		[self takeContextValue:[projectURL.path stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:url.path.stringByDeletingLastPathComponent] forKey:iTM2ProjectRelativePathKey domain:iTM2ContextPrivateMask];
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
	[self takeContextValue:url.absoluteString forKey:iTM2ProjectURLKey domain:iTM2ContextPrivateMask];
	[self takeContextValue:[P fileKeyForSubdocument:self] forKey:iTM2ProjectFileKeyKey domain:iTM2ContextPrivateMask];
	[self takeContextValue:url.path forKey:iTM2ProjectOwnAbsolutePathKey domain:iTM2ContextPrivateMask];
	[self takeContextValue:[P nameForFileKey:[P fileKeyForURL:url]] forKey:iTM2ProjectOwnRelativePathKey domain:iTM2ContextPrivateMask];
    NSData * D = [url bookmarkDataWithOptions:NSURLBookmarkCreationPreferFileIDResolution|NSURLBookmarkCreationSuitableForBookmarkFile includingResourceValuesForKeys:[NSArray array] relativeToURL:nil error:NULL];
	[self takeContextValue:D forKey:iTM2ProjectBookmarkKey domain:iTM2ContextPrivateMask];
//END4iTM3;
    return;
}
@end

@implementation NSWindowController(Project)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_windowTitleForDocumentDisplayName:
- (NSString *)SWZ_iTM2_windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:14:18 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// we should manage the lengthy names...
	iTM2ProjectDocument * P = [SPC projectForSource:self];
	if (P) {
		if (!displayName.length) {
			displayName = [self.document displayName];// retrieve the "untitled"
		}
		NSString * projectDisplayName = P.fileURL.enclosingWrapperURL4iTM3.path;
		if (projectDisplayName.length) {
			projectDisplayName = projectDisplayName.stringByDeletingLastPathComponent.stringByDeletingPathExtension;
		} else {
			projectDisplayName = P.displayName;
		}
		return [NSString stringWithFormat:
			NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)",iTM2ProjectTable,myBUNDLE,"blah (project name)"),
			displayName,projectDisplayName];
	}
	return [self SWZ_iTM2_windowTitleForDocumentDisplayName:displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_windowsMenuItemTitleForDocumentDisplayName4iTM3:
- (NSString *)SWZ_iTM2_windowsMenuItemTitleForDocumentDisplayName4iTM3:(NSString *)displayName;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:14:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//START4iTM3;
    return [self SWZ_iTM2_windowTitleForDocumentDisplayName:displayName];
}
@end

@implementation NSWindowController(iTM2ProjectDocument)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldCascadeWindows
- (BOOL)SWZ_iTM2ProjectDocument_shouldCascadeWindows;
/*"Gives a default value,useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:15:01 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self SWZ_iTM2ProjectDocument_shouldCascadeWindows] && (![SPC projectForSource:self]);
}
@end

NSString * const iTM2OtherProjectWindowsAlphaValue = @"iTM2OtherProjectWindowsAlphaValue";

@implementation NSWindow(iTM2ProjectDocument)
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2ProjectDocument_display
- (void)SWZ_iTM2ProjectDocument_display;
/*"Gives a default value,useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id PD = [SPC projectForSource:self];
	if ((project != nil)&& (project != [SPC currentProject]))
	{
		// encapsulate the inherited display method to change the alpha channel
		CGFloat otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
		if (otherAlpha<0)
		{
			otherAlpha = 0.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		else if (otherAlpha>1)
		{
			otherAlpha = 1.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		if (otherAlpha<1)
		{
//LOG4iTM3(@"YES");
			BOOL wasOpaque = self.isOpaque;
			[self setOpaque:NO];
			CGFloat oldAlpha = self.alphaValue;
			[self setAlphaValue:oldAlpha * otherAlpha];
			[self SWZ_iTM2ProjectDocument_display];
			[self setAlphaValue:oldAlpha];
			[self setOpaque:wasOpaque];
//END4iTM3;
			return;
		}
	}
	[self SWZ_iTM2ProjectDocument_display];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2ProjectDocument_displayIfNeeded
- (void)SWZ_iTM2ProjectDocument_displayIfNeeded;
/*"Gives a default value,useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id PD = [SPC projectForSource:self];
	if ((project != nil)&& (project != [SPC currentProject]))
	{
		// encapsulate the inherited display method to change the alpha channel
		CGFloat otherAlpha = [SUD floatForKey:iTM2OtherProjectWindowsAlphaValue];
		if (otherAlpha<0)
		{
			otherAlpha = 0.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		else if (otherAlpha>1)
		{
			otherAlpha = 1.0;
			[SUD setFloat:otherAlpha forKey:iTM2OtherProjectWindowsAlphaValue];
		}
		if (otherAlpha<1)
		{
			BOOL wasOpaque = self.isOpaque;
			[self setOpaque:NO];
			CGFloat oldAlpha = self.alphaValue;
			[self setAlphaValue:oldAlpha * otherAlpha];
//LOG4iTM3(@"YES");
			[self SWZ_iTM2ProjectDocument_displayIfNeeded];
			[self setAlphaValue:oldAlpha];
			[self setOpaque:wasOpaque];
//END4iTM3;
			return;
		}
	}
	[self SWZ_iTM2ProjectDocument_displayIfNeeded];
//END4iTM3;
    return;
}
#endif
@end

@interface NSDocument_iTM2ProjectDocumentKit:NSDocument
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSDocument(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_setFileURL:
- (void)SWZ_iTM2ProjectDocument_setFileURL:(NSURL*)newURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:15:22 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * oldURL = self.fileURL;
    //  If this is the first time we are asked to set the url, do nothing special.
    //  Same if the new url and the old one are the same.
	if (!oldURL || [oldURL isEqual:newURL]) {
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		return;
	}
	//  this is not the first time we are asked to set the file URL
    //  or we are asked to change the url
	iTM2ProjectDocument * oldPD = self.project4iTM3;
    //  The receiver is a project document, it is its own project
	if (!oldPD || (self == (id)oldPD)) {
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		return;
	}
	iTM2WrapperDocument * WD = self.wrapper4iTM3;
    //  The receiver is a wrapper (it is its own wrapper)
	if (self == (id)WD) {
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		return;
	}
	// the receiver is not a project nor a wrapper, but belongs to project PD
	NSString * oldKey = [oldPD fileKeyForSubdocument:self];
	NSAssert2(oldKey.length,@"NON SENSE! the project %@ owns the document %@ but has no key for it!",oldPD,self);
	iTM2ProjectDocument * newPD = [SPC projectForURL:newURL];
	NSURL * url = nil;
	if (nil == newPD) {
		url = newURL;
#warning ERROR POSSIBLE: display NO
		newPD = [SPC freshProjectForURLRef:&url display:NO error:nil];
		if (![url isEquivalentToURL4iTM3:newURL]) {
			[self SWZ_iTM2ProjectDocument_setFileURL:url];
		#warning THERE MIGHT BE A PROBLEM HERE
			LOG4iTM3(@"----  BE EXTREMELY CAREFUL: writeSafelyToURL will be used");
			if (![self writeSafelyToURL:oldURL ofType:self.fileType forSaveOperation:NSSaveOperation error:nil]) {
				LOG4iTM3(@"*** THERE IS SOMETHING WRONG WITH THAT FILE NAME:%@",url.path);
			}
		}
	}
	// removing all the previously existing document with the same file name
	// except the receiver, of course
	id properties = nil;
	if (newPD == oldPD) {
//		[[newPD keyedSubdocuments] setValue:nil forKey:oldKey];
		url = self.fileURL;
		NSString * newKey = [newPD createNewFileKeyForURL:url];
		properties = [[oldPD mainInfos] propertiesForFileKey:oldKey];
		properties = [[properties mutableCopy] autorelease];
		[[newPD mainInfos] setProperties:properties forFileKey:newKey];
		[self SWZ_iTM2ProjectDocument_setFileURL:url];
		return;
	} else if ([newPD ownsSubdocument:self]) {
		// This is not expected:two different projects own the same document
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		//NSAssert3(NO,@"INCONSISTENT CODE:projects %@ and %@ are not allowed to own the same document:%@",oldPD,newPD,self);
		// bib files and others might be shared between projects
		return;
	} else if (newPD) {
		[oldPD removeSubdocument:self];
		// remove in newPD the project documents with the same name
		NSDocument * newD;
		while ((newD = [newPD subdocumentForURL:newURL])) {
			[newPD removeSubdocument:newD];
			[newD canCloseDocumentWithDelegate:self.class
				shouldCloseSelector:@selector(document4iTM3:setFileNameShouldClose:contextInfo0213:)
					contextInfo:nil];
		}
		[newPD addSubdocument:self];
		NSString * newKey = [newPD fileKeyForSubdocument:self];
		properties = [[[oldPD.mainInfos propertiesForFileKey:oldKey] mutableCopy] autorelease];
		[newPD.mainInfos setProperties:properties forFileKey:newKey];
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
		// what about the context?
	} else {
		[SDC addDocument:self];
		[oldPD removeSubdocument:self];
		[self SWZ_iTM2ProjectDocument_setFileURL:newURL];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  document4iTM3:setFileNameShouldClose:contextInfo0213:
+ (void)document4iTM3:(NSDocument *)doc setFileNameShouldClose:(BOOL)shouldClose contextInfo0213:(void *)contextInfo;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:17:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (shouldClose) {
		[doc close];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:18:54 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if ((result = [super getContextValueForKey:aKey domain:mask&iTM2ContextStandardLocalMask])) {
		return result;
	}
	iTM2ProjectDocument * project = self.project4iTM3;
	id contextManager = self.contextManager;
	NSAssert2(((project != contextManager) || (!project && !contextManager) || ((id)project == self)),@"*** %@ %#x The document's project must not be the context manager!",__iTM2_PRETTY_FUNCTION__, self);
	if ((id)project != self)/* reentrant code management */ {
		NSString * fileKey = [project fileKeyForURL:self.fileURL];
		if (fileKey.length) {
			if (result = [project getContextValueForKey:aKey fileKey:fileKey domain:mask]) {
				return result;
			}
		}
	}
    return [super getContextValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (NSUInteger)setContextValue:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:18:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * project = self.project4iTM3;
	id contextManager = self.contextManager;
	NSAssert2(((project != contextManager) || (!project && !contextManager) || ((id)project == self)),@"*** %@ %#x The document's project must not be the context manager!",__iTM2_PRETTY_FUNCTION__, self);
	NSURL * fileURL = self.fileURL;// not the file name!
	if (fileURL) {
		NSString * fileKey = [project fileKeyForURL:fileURL];
		if (fileKey.length) {
			[project setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
		} else if (project) {
			LOG4iTM3(@"*** ERROR:the project %@ does not seem to own the document %@ at %@.",project,self,fileURL);
//LOG4iTM3([project fileKeyForURL:fileName]);
		}
	}
	BOOL didChange = [super setContextValue:object forKey:aKey domain:mask];// last to be sure we have registered
//LOG4iTM3(@"self.contextDictionary is:%@",self.contextDictionary);
    return didChange;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_newRecentDocument
- (id)SWZ_iTM2_newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:19:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = self.project4iTM3;
	if ([PD.fileURL belongsToFactory4iTM3]) {
		return [self SWZ_iTM2_newRecentDocument];
	}
    return PD? [PD newRecentDocument]:[self SWZ_iTM2_newRecentDocument];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  catched_document4iTM3:didSave:contextInfo:
- (void)catched_document4iTM3:(NSDocument *)document didSave:(BOOL)didSaveSuccessfully contextInfo:(NSDictionary *)contextInfo;
/*"Description Forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 15:16:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInvocation * I = [contextInfo objectForKey:@"invocation"];
	[I setArgument:&didSaveSuccessfully atIndex:3];
	NSURL * newURL = [contextInfo objectForKey:@"newURL"];
	if (!newURL.isFileURL) {
		[I invoke];
		return;
	}
	iTM2ProjectDocument * newPD = [SPC projectForURL:newURL];
	if (!newPD) {
		[I invoke];
		return;
	}
	NSURL * oldURL = [contextInfo objectForKey:@"oldURL"];
	if (!oldURL.isFileURL) {
		[I invoke];
		return;
	}
	iTM2ProjectDocument * oldPD = [SPC projectForDocument:document];
	NSString * oldKey = [oldPD fileKeyForURL:oldURL];
	if (didSaveSuccessfully) {
		NSString * newKey = [newPD fileKeyForURL:newURL];
		id properties = [oldPD.mainInfos propertiesForFileKey:oldKey];
		properties = [[properties mutableCopy] autorelease];
		[newPD.mainInfos setProperties:properties forFileKey:newKey];
		if ([newPD isEqual:oldPD]) {
			if (![oldKey isEqual:newKey]) {
				NSMapTable * MT = oldPD.keyedSubdocuments;
				[MT removeObjectForKey:oldKey];
				[MT setObject:document forKey:newKey];
			}
		} else {
			[oldPD forgetSubdocument:document];
			[newPD addSubdocument:document];
		}
	}
	[I invoke];
	return;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:
- (void)SWZ_iTM2ProjectDocument_saveToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo;
/*"This is one of the 2 critical methods where the document and its project can be separated. (the other one is setFileURL:)
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:21:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL || (saveOperation != NSSaveAsOperation))
	{
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:delegate didSaveSelector:didSaveSelector contextInfo:contextInfo];
#if 0
		// COMMENT: if we put this trick here, then the document has lost its own name...and gets tagged as untitled
		// this trick is for the "document lost its FSRef" problem
		// when in continuous typesetting mode,
		// we cannot save transparently
		// the document has the expected file name and url but some internals are broken
		// such that the internals no longer make the URL point to the proper file node
		NSURL * url = self.fileURL;
		[self setFileURL:nil];
		[self setFileURL:url];
#endif
		return;
	}
	NSURL * oldURL = self.fileURL;
	if (!oldURL.isFileURL) {
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:delegate didSaveSelector:didSaveSelector contextInfo:contextInfo];
		return;
	}
	NSMutableDictionary * info = [NSMutableDictionary dictionary];
	[info setObject:oldURL forKey:@"oldURL"];
	[info setObject:absoluteURL forKey:@"newURL"];
	[info setObject:(typeName?:@"") forKey:@"typeName"];
	NSInvocation * I = nil;
	NSMethodSignature * sig = [delegate methodSignatureForSelector:didSaveSelector];
	if (sig) {
		I = [NSInvocation invocationWithMethodSignature:sig];
		[I setSelector:didSaveSelector];
		I.target = delegate;
		[I setArgument:&self atIndex:2];
		[I setArgument:(contextInfo?&contextInfo:nil) atIndex:4];
		[info setObject:I forKey:@"invocation"];
	}
	iTM2ProjectDocument * newPD = [SPC projectForURL:absoluteURL];
	if (newPD) {
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:self didSaveSelector:@selector(catched_document4iTM3:didSave:contextInfo:) contextInfo:info];
		return;
	}
	NSURL * url = absoluteURL;
	NSError * error = nil;
	if ([SPC freshProjectForURLRef:&url display:YES error:&error]) {
		if (![absoluteURL isEquivalentToURL4iTM3:url]) {
			absoluteURL = url;
			[info setObject:absoluteURL forKey:@"newURL"];
		}
		[self SWZ_iTM2ProjectDocument_saveToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation delegate:self didSaveSelector:@selector(catched_document4iTM3:didSave:contextInfo:) contextInfo:info];
		return;
	}
	if (error) {
		REPORTERROR4iTM3(1,(@"Could not create a new project, save operation cancelled"),error);
	}
	if ([self isKindOfClass:[iTM2ProjectDocument class]]) {
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
Latest Revision: Wed Mar 17 16:23:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= title
- (NSString *)title;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:23:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSString * T = super.title;
	return T.length? T:@"...";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowsMenuItemTitle4iTM3
- (NSString *)windowsMenuItemTitle4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:23:48 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [[self.windowController document] displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= constrainFrameRect:toScreen:
- (NSRect)constrainFrameRect:(NSRect)frameRect toScreen:(NSScreen *)screen;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:23:52 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return frameRect;
}
@end

@implementation NSDocumentController(iTM2ProjectDocumentKit)
#pragma mark =-=-=-=-=-  NEW STUFF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectPathExtension4iTM3
- (NSString *)projectPathExtension4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:23:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    NSString * extension = (NSString *) UTTypeCopyPreferredTagWithClass(
        (CFStringRef)(self.projectDocumentType4iTM3),
            kUTTagClassFilenameExtension);
	return extension;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapperPathExtension4iTM3
- (NSString *)wrapperPathExtension4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:24:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    NSString * extension = (NSString *) UTTypeCopyPreferredTagWithClass(
        (CFStringRef)(self.wrapperDocumentType4iTM3),
            kUTTagClassFilenameExtension);
	return extension;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDocumentType4iTM3
- (NSString *)projectDocumentType4iTM3;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
Latest Revision: Wed Mar 17 16:24:12 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM2UTTypeProject;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapperDocumentType4iTM3
- (NSString *)wrapperDocumentType4iTM3;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
Latest Revision: Wed Mar 17 16:24:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM2UTTypeWrapper;
}
@end

#import "iTM2ResponderKit.h"

@interface iTM2ProjectDocumentResponder(PRIVATE)
- (BOOL)validateProjectAddCurrentDocument:(id)sender;
- (void)_moveToDestinationURL:(NSURL *)destinationURL;
@end

static NSString * _iTM2CurrentProjectLocalizedFormat = @"PROJECT:%@";
static NSString * _iTM2NoProjectLocalizedTitle = @"NO PROJECT";
static NSString * _iTM2NewProjectLocalizedTitle = @"NEW PROJECT?";


@implementation NSApplication(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _iTM2ProjectDocumentResponderCompleteDidFinishLaunching4iTM3
- (void)_iTM2ProjectDocumentResponderCompleteDidFinishLaunching4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:24:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL OK = YES;
	NSMenuItem * MI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(projectCurrentCreate:)];
	NSString * proposal = MI.title;
	if (!proposal.length || [proposal rangeOfString:@"%"].length) {
		proposal = @"Open/Create a project first";
		LOG4iTM3(@"Localization BUG,the menu item with action projectCurrentAlternate:must exist and contain no %%");
		OK = NO;
	}
	_iTM2NewProjectLocalizedTitle = proposal;
	[MI.menu removeItem:MI];
	MI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(projectCurrentNone:)];
	proposal = MI.title;
	if (!proposal.length || [proposal rangeOfString:@"%"].length) {
		proposal = @"No active project";
		LOG4iTM3(@"Localization BUG,the menu item with action projectCurrentAlternate:must exist and contain no %%");
		OK = NO;
	}
	_iTM2NoProjectLocalizedTitle = proposal;
	[MI.menu removeItem:MI];
	MI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(projectCurrent:)];
	proposal = MI.title;
	if (!proposal.length || ([[proposal componentsSeparatedByString:@"%"] count] != 2)|| ([[proposal componentsSeparatedByString:@"%@"] count] != 2)) {
		proposal = @"Project:%@";
		LOG4iTM3(@"Localization BUG,the menu item with action projectCurrent:must exist and contain one %%@,\nand no other formating directive");
		OK = NO;
	}
	if (OK) {
		MILESTONE4iTM3((@"iTM2LocalizedProjectMenuItems"),(@"No project menu item localization available"));
	}
	_iTM2CurrentProjectLocalizedFormat = proposal;
	if ([NSApp targetForAction:@selector(performCloseProject:)]) {
		MILESTONE4iTM3((@"iTM2ProjectDocumentResponder"),(@"No responder available to handle the performCloseProject: action"));
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocumentKit_terminate:
- (void)SWZ_iTM2ProjectDocumentKit_terminate:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:24:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"iTM2ApplicationIsTerminating"]];
	[self SWZ_iTM2ProjectDocumentKit_terminate:sender];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"iTM2ApplicationIsTerminating"]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocumentKit_arrangeInFront:
- (void)SWZ_iTM2ProjectDocumentKit_arrangeInFront:(id)sender;
/*"When I rearranged the window menu,I broke something and arrangeInFront:no longer works.
This patch mimics the behaviour except that all windows are ordered front.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:25:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	for (NSWindow * W in self.orderedWindows.reverseObjectEnumerator) {
		if (![W isKindOfClass:[iTM2ExternalWindow class]]) {
			[W orderFront:sender];
		}
	}
	//[self SWZ_iTM2ProjectDocumentKit_arrangeInFront:(id)sender];
//END4iTM3;
    return;
}
@end

#import "iTM2MiscKit.h"

@interface iTM2ProjectDocumentResponderTreeNode: iTM2TreeNode
{
@private
    NSURL * iVarURL4iTM3;
    NSURL * iVarNewURL4iTM3;
    NSString * iVarComponent4iTM3;
    NSString * iVarRelativePath4iTM3;
    BOOL iVarIsProject4iTM3;
    BOOL iVarFollowsProject4iTM3;
    BOOL iVarContainsFollowsProject4iTM3;
    BOOL iVarOverride4iTM3;
    NSInteger iVarShouldFollowProject4iTM3;
}
//@property (assign) __weak iTM2ProjectDocumentResponderTreeNode * parent;
//- (iTM2ProjectDocumentResponderTreeNode * )parent;
@property (assign) NSURL * URL;
@property (assign) NSURL * newURL;
@property (assign) NSString * component;
@property (assign) NSString * relativePath;
@property (assign) BOOL isProject;
@property (assign) BOOL followsProject;
@property (assign) BOOL containsFollowsProject;
@property (assign) NSInteger shouldFollowProject;
@property (readonly) BOOL isEditable;
@property (readonly) BOOL isEnabled;
@property (readonly) BOOL override;
- (void)revert;
- (void)setupFollowsProject;
@end

@interface iTM2ProjectToggleWrapperInspector()
@property (assign) iTM2ProjectDocumentResponderRootNode * root;
@property (readwrite,assign) NSArray * nodes;
@end

@interface iTM2ProjectDocumentResponderRootNode: iTM2ProjectDocumentResponderTreeNode
@end

@implementation iTM2ProjectDocumentResponderRootNode
- (iTM2ProjectDocumentResponderRootNode * )root;
{
    return self;
}
+ (iTM2ProjectDocumentResponderRootNode *)rootNodeForDestinationURL:(NSURL *)destinationURL projectDocument:(iTM2ProjectDocument *)PD;
/*"We are going tp move the project file for PD at destinationURL.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Sun Mar 21 10:43:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!destinationURL) {
        return nil;
    }
    NSURL * containerURL = destinationURL.URLByDeletingLastPathComponent;
    iTM2ProjectDocumentResponderTreeNode * N = nil;
    iTM2ProjectDocumentResponderTreeNode * n = nil;
    iTM2ProjectDocumentResponderRootNode * root = [[iTM2ProjectDocumentResponderRootNode alloc] initWithParent:nil];
    N = root; 
    NSString * component = nil;
    for (component in containerURL.pathComponents) {
        if (!(n = [N objectInChildrenWithValue:component forKeyPath:@"component"])) {
            n = [[iTM2ProjectDocumentResponderRootNode alloc] initWithParent:N];
            n.component = component;
        }
        N = n;
    }
    N.URL = containerURL;
    NSDirectoryEnumerator * DE = [DFM enumeratorAtURL:containerURL
        includingPropertiesForKeys:[NSArray array]
            options:NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsHiddenFiles
                errorHandler:NULL];
    //  DE contains at least destinationURL
    NSMutableSet * projectNodes = [NSMutableSet set];
    NSURL * url = nil;
    for (url in DE) {
        N = root; 
        for (component in url.pathComponents) {
            if (!(n = [N objectInChildrenWithValue:component forKeyPath:@"component"])) {
                n = [[iTM2ProjectDocumentResponderTreeNode alloc] initWithParent:N];
                n.component = component;
            }
            N = n;
        }
        N.URL = url;
        if ([SWS isProjectPackageAtURL4iTM3:url]) {
            N.isProject = YES;
            [projectNodes addObject:N];
        }
    }
    //  The tree node contains the file hierarchy
    //  All the nodes contain an url value, except the components of containerURL
    //  The higher nodes of the tree only contain 1 child and no url value
    //  We remove these nodes to keep the one that corresponds to containerURL
    NSAssert(N = [root deepObjectInChildrenWithValue:containerURL forKeyPath:@"url"],@"Internal Inconsistency");
    NSAssert([N isKindOfClass:[iTM2ProjectDocumentResponderRootNode class]],@"Internal Inconsistency");
    root = (id)N;
    //  root is an object of the root node class.
    //  all the children are simple nodes
    root.parent = nil;
    //  Now root corresponds exactly to containerURL
    root.URL = containerURL;
    root.component = iTM2PathComponentDot;
    root.relativePath = iTM2PathComponentDot;
    //  Completing the relative path of all the nodes
    N = root;
    NSMutableSet * allTheNodes = [NSMutableSet set];
    while ((N = N.nextNode)) {
        N.relativePath = [[N.parent relativePath] stringByAppendingPathComponent:N.component];
        N.newURL = [containerURL URLByAppendingPathComponent:N.relativePath];
        [allTheNodes addObject:N];
    }
    //  All the URL's known by the project will follow it during the move, if they are in the same hierarchy
    NSMutableSet * followingNodes = [NSMutableSet set];
    for (N in allTheNodes) {
        if ([PD fileKeyForURL:N.URL]) {
            [followingNodes addObject:N];
        }
    }
    //  Now, find if there are other projects that should follow the current project
    //  We exclude from allTheNodes the projects and the already following nodes
    [allTheNodes minusSet:followingNodes];
    [allTheNodes minusSet:projectNodes];
    //  For the remaining nodes, we test if one of the projects recognizes them
    //  This is relevant, only if there are more than one project
    //  And if there is something to activate
    if (allTheNodes.count) {
        //  We first create a list of project info wrappers
        NSMutableSet * infoWrappers = [NSMutableSet set];
        for (N in projectNodes) {
            [infoWrappers addObject:[[iTM2MainInfoWrapper alloc] initWithProjectURL:N.URL error:NULL]];
        }
        NSMutableSet * followingProjects = [NSMutableSet set];
        while (YES) {
            //  Is there a project declaring one of the following nodes.
            for (N in followingNodes.copy) {
                url = N.URL;N = nil;
                for (iTM2MainInfoWrapper * MIW in infoWrappers.copy) {
                    if ([MIW fileKeyForURL:url]) {
                        //  the url belongs to the project for MIW
                        //  We are going to manage MIW
                        //  Remove MIW from the list
                        [infoWrappers removeObject:MIW];
                        //  Retrieve the node for the projectURL of MIW
                        N = [root deepObjectInChildrenWithValue:MIW.projectURL forKeyPath:@"url"];
                        //  Add this node to the list of following projects
                        //  The current project corresponds to one of these nodes
                        [followingProjects addObject:N];
                        [followingNodes addObject:N];
                        [allTheNodes removeObject:N];
                        //  Pick up all the nodes that belong to this newly managed project
                        for (N in allTheNodes.copy) {
                            if ([MIW fileKeyForURL:N.URL]) {
                                [followingNodes addObject:N];
                                [allTheNodes removeObject:N];
                               continue;
                            }
                        }
                    }
                }
            }
            break;
        }
        //  Mark the nodes that will follow the project
        for (N in followingNodes) {
            N.followsProject = YES;
            [N.parent setContainsFollowsProject:YES];
        }
    }
    //  Now we have setup the nodes
    //  Change the nodes to indicate that they follow the project
    root.setupFollowsProject;
    root.revert;
//END4iTM3;
	return root;
}
@end

@implementation iTM2ProjectDocumentResponderTreeNode
- (void)fixConsistencyWithChildren;
{
    while (self.countOfChildren) {
        for (iTM2ProjectDocumentResponderTreeNode * N in self.children) {
            if (!N.followsProject) {
                break;
            }
        }
        self.followsProject = YES;
        self.value = self.children.copy;// keep track of the children
        self.countOfChildren = 0;// remove the children from the hierarchy
    }
}
- (void)setupFollowsProject;
{
    [self.children makeObjectsPerformSelector:_cmd];
    self.fixConsistencyWithChildren;
}
- (void)completeFollowsProject;
{
    [self.children makeObjectsPerformSelector:_cmd];
    if (self.shouldFollowProject) {
        self.followsProject = YES;
    }
    self.fixConsistencyWithChildren;
}
#if 0
- (iTM2ProjectDocumentResponderTreeNode * )parent;
{
    return (iTM2ProjectDocumentResponderTreeNode * )super.parent;
}
- (void)setParent:(iTM2ProjectDocumentResponderTreeNode * )parent;
{
    super.parent = parent;
}
#endif
- (iTM2ProjectDocumentResponderRootNode * )root;
{
    return [self.parent root];
}
- (void)revert;
{
    [self.children makeObjectsPerformSelector:_cmd];
    if (self.followsProject) {
        self.shouldFollowProject = NSOnState;
    } else if (self.containsFollowsProject) {
        self.shouldFollowProject = NSMixedState;
    } else {
        self.shouldFollowProject = NSOffState;
    }
}
- (void)updateShouldFollowProject;
{
    if (self.followsProject) return;
    BOOL shouldFollowProject = NO;
    BOOL all = YES; 
    for (iTM2ProjectDocumentResponderTreeNode * N in self.children) {
        if (N.shouldFollowProject) {
            //  either 1 or -1
            shouldFollowProject = YES;
        } else {
            all = NO;
        }
    }
    self.shouldFollowProject = shouldFollowProject?(all?NSOnState:NSMixedState):NSOffState;
}
@synthesize URL = iVarURL4iTM3;
@synthesize newURL = iVarNewURL4iTM3;
@synthesize component = iVarComponent4iTM3;
@synthesize relativePath = iVarRelativePath4iTM3;
@synthesize isProject = iVarIsProject4iTM3;
@synthesize followsProject = iVarFollowsProject4iTM3;
@synthesize override = iVarOverride4iTM3;
- (void)setContainsFollowsProject:(BOOL)yorn;
{
    if (yorn && iVarContainsFollowsProject4iTM3 != yorn) {
        [self.parent setContainsFollowsProject:iVarContainsFollowsProject4iTM3 = YES];
    }
}
@synthesize containsFollowsProject = iVarContainsFollowsProject4iTM3;
- (void)setShouldFollowProject:(NSInteger)state;
{
    if (iVarShouldFollowProject4iTM3 != state) {
        iVarShouldFollowProject4iTM3 = state;
        iTM2ProjectDocumentResponderTreeNode * N = self.parent;
        N.updateShouldFollowProject;
    }
}
- (BOOL)validateShouldFollowProject:(NSInteger *)stateRef error:(NSError **)outError {
    if (self.containsFollowsProject && *stateRef == NSOffState) {
        *stateRef = NSMixedState;
    }
    return YES;
}
@synthesize shouldFollowProject = iVarShouldFollowProject4iTM3;
- (BOOL) isEditable;
{
    return !self.followsProject;
}
- (BOOL) isEnabled;
{
    return !self.followsProject;
}
- (BOOL) isMoveable;
{
    return ![DFM fileExistsAtPath:self.newURL.path];
}
@end

@implementation iTM2ProjectToggleWrapperInspector
@synthesize root = iVarRoot4iTM3;
@synthesize nodes = iVarNodes4iTM3;
@synthesize treeController = iVarTreeController4iTM3;
@synthesize arrayController = iVarArrayController4iTM3;
@synthesize copyView = iVarCopyView4iTM3;
@synthesize errorView = iVarErrorView4iTM3;
- (IBAction)OK:(id)sender;
{
    [NSApp stopModal];
}
- (IBAction)cancel:(id)sender;
{
    [NSApp abortModal];
}
- (IBAction)revertAll:(id)sender;
{
    self.root.revert;
}
- (IBAction)revert:(id)sender;
{
    self.root.revert;
}
- (void)setupCopyPanel;
{
    NSView * CV = self.window.contentView;
    NSView * V = [CV subviewsWhichClassInheritsFromClass:[NSOutlineView class]].lastObject;
    V = V.enclosingScrollView;
    [V.superview.animator replaceSubview:V with:self.copyView];
    [[CV controlWithAction:@selector(revert:)] setHidden:YES];
    [[CV controlWithAction:@selector(revertAll:)] setHidden:YES];
}
- (void)setupErrorPanel;
{
    //  use this method after the setupCopyPanel method above.
    NSTableView * V = (id)self.copyView;
    [V.superview.animator replaceSubview:self.copyView with:self.errorView];
    [[self.window.contentView controlWithAction:@selector(cancel:)] setHidden:YES];
    V = [self.errorView subviewsWhichClassInheritsFromClass:[NSTableView class]].lastObject;
    [V setDelegate:self];
    [V setTarget:self];
    [V setDoubleAction:@selector(errorTableViewDidDoubleClick:)];
}
- (void)errorTableViewDidDoubleClick:(NSTableView *)tableView;
{
    for (NSError * error in self.arrayController.selectedObjects) {
        [NSApp presentError:error];
    }
    return;
}
@end

@implementation iTM2ProjectDocumentResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performCloseProject:
- (IBAction)performCloseProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:25:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[[SDC currentDocument] project4iTM3] smartClose4iTM3];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCloseProject:
- (BOOL)validatePerformCloseProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:25:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [[SDC currentDocument] project4iTM3] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCurrent:
- (IBAction)projectCurrent:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:26:02 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectCurrent:
- (BOOL)validateProjectCurrent:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:26:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = [SPC projectForSource:sender];
	if (!PD) PD = [SPC currentProject];
	//[name belongsToFarawayProjectsDirectory];
	NSString * wrapperName = PD.wrapperURL.path;
	NSImage * I = nil;
    sender.image = nil;
	if (wrapperName.length) {
		if (I=[SWS iconForFile:wrapperName]) {
			I.size = NSMakeSize(16,16);
			sender.image = I;
		}
	} else if (PD &&(I=[SWS iconForFile:PD.fileURL.path])) {
		I.size = NSMakeSize(16,16);
		sender.image = I;
	}
//LOG4iTM3(@"[SDC currentDocument] is:%@",[SDC currentDocument]);
    if (PD && !PD.displayName) {
        LOG4iTM3(@"What is this PD? %@,%@",PD,PD.fileURL.path);
		sender.title = @"...";
		return NO;
    }
    [sender setTitle:(PD? [NSString stringWithFormat:_iTM2CurrentProjectLocalizedFormat,PD.displayName]
		:([SDC currentDocument]? _iTM2NoProjectLocalizedTitle
			:([[SPC projects] count]? _iTM2NoProjectLocalizedTitle:_iTM2NewProjectLocalizedTitle)))];
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowDocumentsFromRepresentedObject:
- (IBAction)projectShowDocumentsFromRepresentedObject:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:26:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSValue * V = sender.representedObject;
	if ([V isKindOfClass:[NSValue class]]) {
		iTM2ProjectDocument * PD = V.nonretainedObjectValue;
		if ([SPC isProject:PD] || [SPC isBaseProject:PD])
			[PD showSubdocuments:sender];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowWindowsFromRepresentedObject:
- (IBAction)projectShowWindowsFromRepresentedObject:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:27:13 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSValue * V = sender.representedObject;
	if ([V isKindOfClass:[NSValue class]]) {
		iTM2ProjectDocument * PD = V.nonretainedObjectValue;
		if ([SPC isProject:PD] || [SPC isBaseProject:PD]) {
			// finding the first window not related to the project.
			NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
			NSWindow * W;
			while((W = E.nextObject)&& (PD == [SPC projectForSource:W]))
				;
			NSWindow * w;
			while(w = E.nextObject)
				if (PD == [SPC projectForSource:w])
					[w orderWindow:NSWindowAbove relativeTo:W.windowNumber];
			return;
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowDocuments:
- (IBAction)projectShowDocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:28:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[SPC projectForSource:sender] showSubdocuments:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectShowDocuments:
- (BOOL)validateProjectShowDocuments:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:28:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [SPC currentProject] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowSettings:
- (IBAction)projectShowSettings:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:28:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[SPC projectForSource:sender] showSettings:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectShowSettings:
- (BOOL)validateProjectShowSettings:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 16:29:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!sender.image) {
		NSString * name = @"projectShowSettings(small)";
		NSImage * I = [NSImage cachedImageNamed4iTM3:name];
		if (![I isNotNullImage4iTM3]) {
			I = [[[NSImage cachedImageNamed4iTM3:@"showCurrentProjectSettings"] copy] autorelease];// cached!
            [I performSelector:@selector(retain)];
			[I setName:name];
			[I setSizeSmallIcon4iTM3];
		}
		sender.image = I;
	}
//END4iTM3;
    return [SPC currentProject] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectEditDocumentUsingRepresentedObject:
- (void)projectEditDocumentUsingRepresentedObject:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:29:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMenu * M = sender.menu;
	NSValue * V = [[[M supermenu] itemAtIndex:[[M supermenu] indexOfItemWithSubmenu:M]] representedObject];
	if ([V isKindOfClass:[NSValue class]]) {
		id PD = [V nonretainedObjectValue];
		if ([SPC isProject:PD] || [SPC isBaseProject:PD]) {
			NSString * key = sender.representedObject;
			if ([key isKindOfClass:[NSString class]]) {
				NSURL * url = [PD URLForFileKey:key];
				NSError * localError = nil;
                [SDC openDocumentWithContentsOfURL:url display:YES error:&localError];
				if (localError) {
					[SDC presentError:localError];
				}
			}
			return;
		}
	}
	LOG4iTM3(@"*** BIG UNEXPECTED PROBLEM");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectEditUsingRepresentedInspectorMode:
- (void)projectEditUsingRepresentedInspectorMode:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:30:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMenu * M = sender.menu;
	NSValue * V = [[[M supermenu] itemAtIndex:[[M supermenu] indexOfItemWithSubmenu:M]] representedObject];
	if ([V isKindOfClass:[NSValue class]]) {
		iTM2ProjectDocument * PD = V.nonretainedObjectValue;
		if ([SPC isProject:PD] || [SPC isBaseProject:PD]) {
            [[[PD inspectorAddedWithMode:sender.representedObject] window] makeKeyAndOrderFront:self];
			return;
		}
	}
	LOG4iTM3(@"*** BIG UNEXPECTED PROBLEM");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectEditUsingRepresentedInspectorMode:
- (BOOL)validateProjectEditUsingRepresentedInspectorMode:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:30:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMenu * M = sender.menu;
	NSValue * V = [M.supermenu itemAtIndex:[M.supermenu indexOfItemWithSubmenu:M]].representedObject;
	if ([V isKindOfClass:[NSValue class]]) {
		id PD = V.nonretainedObjectValue;
		if ([SPC isProject:PD] || [SPC isBaseProject:PD]) {
			NSString * key = sender.representedObject;
			if ([key isKindOfClass:[NSString class]]) {
				if (!sender.image) {
				#warning FORTHCOMING IMAGES
					;
				}
				NSURL * url = [PD URLForFileKey:key];
				NSURL * factoryURL = [PD factoryURLForFileKey:key];
                [sender setAttributedTitle:([DFM fileExistsAtPath:url.path]||[DFM fileExistsAtPath:factoryURL.path]? nil:
                    [[[NSAttributedString alloc] initWithString:sender.title
                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSColor redColor],NSForegroundColorAttributeName,
                                nil]] autorelease])];
			}
			return YES;
		}
	}
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectAddDocument:
- (IBAction)projectAddDocument:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:33:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMenu * M = sender.menu;
	NSValue * V = [M.supermenu itemAtIndex:[M.supermenu indexOfItemWithSubmenu:M]].representedObject;
	if ([V isKindOfClass:[NSValue class]]) {
		iTM2ProjectDocument * PD = V.nonretainedObjectValue;
		if ([SPC isProject:PD] || [SPC isBaseProject:PD]) {
			iTM2SubdocumentsInspector * WC = [PD inspectorAddedWithMode:[iTM2SubdocumentsInspector inspectorMode]];
			[WC.window makeKeyAndOrderFront:self];
			[WC importDocument:self];
			return;
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectAddCurrentDocument:
- (IBAction)projectAddCurrentDocument:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:34:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![self validateProjectAddCurrentDocument:sender])
		return;
	NSValue * V = sender.representedObject;
	if ([V isKindOfClass:[NSValue class]]) {
		iTM2ProjectDocument * PD = V.nonretainedObjectValue;
		if ([SPC isProject:PD] && ![SPC isBaseProject:PD]) {
			NSDocument * currentDocument = [SDC currentDocument];
			// we cannot add project documents to project documents?
			if ([SPC isProject:currentDocument])
				return;
			[currentDocument takeContextValue:nil forKey:@"_iTM2:Document With No Project" domain:iTM2ContextAllDomainsMask];
			[SDC removeDocument:currentDocument];
			[PD addURL:currentDocument.fileURL];
			[PD addSubdocument:currentDocument];
			[currentDocument setHasProject4iTM3:YES];
			return;
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectAddCurrentDocument:
- (BOOL)validateProjectAddCurrentDocument:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:35:34 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDocument * currentDocument = [SDC currentDocument];
//END4iTM3;
	return currentDocument != nil && currentDocument.project4iTM3 == nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectToggleStandalone:
- (IBAction)projectToggleStandalone:(id)sender;
/*"Description forthcoming. Does nothing, just a catcher
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:35:52 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectToggleStandalone:
- (BOOL)validateProjectToggleStandalone:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Wed Mar 17 16:36:03 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = [SPC currentProject];
	sender.state = ([PD.fileURL belongsToFactory4iTM3]?NSOnState:NSOffState);
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _moveProject:toDestinationURL:
- (void)_moveProject:(iTM2ProjectDocument *)PD toDestinationURL:(NSURL *)destinationURL;
/*"Change a simple project to a normal one.
The purpose is to move the current project from its old location to a new one.
The problem is that some files and folders must be moved around while already open in iTM2 or not.
This is a critical method.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Fri Mar 19 21:27:40 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  What are all the files to be moved?
    //  The candidates are the files and folders as well as their contents at the same level than destinationURL
    //  All the files known by the project will be moved.
    //  If there are files or folders unknown by the project, it might just be an omission.
    //  In that case, we ask the user to check the files/folders to be renamed like the attached files.
    //  For that purpose, we show in a panel an outline view listing all the possibilities.
    //  The data model underlying the outline view is a tree
    iTM2ProjectDocumentResponderRootNode * root = [iTM2ProjectDocumentResponderRootNode rootNodeForDestinationURL:destinationURL projectDocument:PD];
    //  There might be a problem for projects sharing the same file.
    //  We only solve this potential problem for projects already opened by iTM2
	if ([root deepObjectInChildrenWithValue:[NSNumber numberWithBool:NO] forKeyPath:@"followsProject"]) {
        //  There are remaining files that we do not know how to manage
        //  We ask the user for that purpose
        //  For that purpose, we display a modal dialog window
        iTM2ProjectToggleWrapperInspector * inspector = [[iTM2ProjectToggleWrapperInspector alloc] init];
        inspector.root = root;
        if ([NSApp runModalForWindow:inspector.window] == NSRunStoppedResponse) {
            //  walk through all the nodes and record the ones that follow the project
            NSMutableArray * Ns = [NSMutableArray array];
            iTM2ProjectDocumentResponderTreeNode * N = root;
            while ((N = N.nextNode)) {
                if (!N.countOfChildren && (N.shouldFollowProject || N.followsProject)) {
                    [Ns addObject:N];
                }
            }
            if (Ns.count) {
                inspector.nodes = Ns;
                inspector.setupCopyPanel;// change the main panel to the copy panel
                if ([NSApp runModalForWindow:inspector.window] == NSRunStoppedResponse) {
                    //  Now I can perform the move;
                    NSMutableSet * localErrors = [NSMutableSet set];
                    for (N in inspector.nodes) {
                        //  Move each file associated to that node
                        NSError * localError = nil;
                        [DFM createDirectoryAtPath:N.URL.directoryURL4iTM3.path withIntermediateDirectories:YES attributes:nil error:&localError];
                        if (localError ) {
                            //  Record the error if any
                            [localErrors addObject:localError];
                            localError = nil;
                        } else {
                            [DFM moveItemAtURL:N.URL toURL:N.newURL error:&localError];
                            if (localError) {
                                //  Record the error if any
                                [localErrors addObject:localError];
                                localError = nil;
                            }
                        }
                    }
                    if (localErrors.count>1) {
                        //  Many different errors
                        //  Present a list of localized descriptions
                        inspector.nodes = localErrors.allObjects;
                        inspector.setupErrorPanel;
                        [NSApp runModalForWindow:inspector.window];
                    } else if (localErrors.count) {
                        //  Only one error, present it directly
                        [NSApp presentError:localErrors.anyObject];
                    }
                }
            }
        }
        [inspector.window orderOut:self];
    }
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectToggleNormal:
- (IBAction)projectToggleNormal:(id)sender;
/*"Change a simple project to a normal one.
The problem is that some files and folders must be moved around while already open in iTM2 or not.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Fri Mar 19 21:47:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = [SPC currentProject];
	[self _moveProject:PD toDestinationURL:PD.wrapperURL.URLByDeletingPathExtension];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectToggleNormal:
- (BOOL)validateProjectToggleNormal:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Fri Mar 19 21:27:08 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = [SPC currentProject];
	NSURL * url = PD.fileURL.enclosingWrapperURL4iTM3;
	sender.state = (nil!=url?NSOffState:NSOnState);
//END4iTM3;
	return nil!=url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectToggleWrapper:
- (IBAction)projectToggleWrapper:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Fri Mar 19 21:48:09 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = [SPC currentProject];
	NSURL * wrapperURL = PD.fileURL.enclosingWrapperURL4iTM3;
	NSURL * destinationURL = nil;
    if (wrapperURL && !wrapperURL.belongsToFactory4iTM3) {
        //  This is a wrapper that do not belong to the factory folder
        //  we just have to replace the wrapper by a simple folder
        //  In fact, renaming the wrapper folder is sufficient.
        destinationURL = wrapperURL.URLByDeletingPathExtension;
        //  we will move wrapperURL to destinationURL
        //  All the embedded projects will move accordingly
        //  If one of the projects is open in iTM2, the change must be taken into account
        NSHashTable * HT = [NSHashTable hashTableWithWeakObjects];
        for (NSURL * url in wrapperURL.enclosedProjectURLs4iTM3) {
            if ((PD = [SPC projectForURL:url])) {
                [HT addObject:PD];
            }
        }
        //  Now rename the wrapper
        NSError * localError = nil;
        if (![DFM moveItemAtURL:wrapperURL toURL:destinationURL error:&localError]) {
			REPORTERROR4iTM3(2,(@"Could not move."),localError);
            return;
        }
        //  Update the open projects accordingly
        //  first the URL of the project
        //  Then the URL's of the documents
        
        for (PD in HT) {
            NSString * relative = [PD.fileURL pathRelativeToURL4iTM3:wrapperURL];
            PD.fileURL = [NSURL URLWithPath4iTM3:relative relativeToURL:destinationURL];
            //  That is all, the project is responsible of the other updates
        }
        return;
    }
    //  We have to turn the project and its attached files into a wrapper
    //  if the project belongs to the base factory, the enclosing wrapper is simply ignored.
    //  We try to create a new folder and populate it with the project and the attached files.
    //  Two problems: 1 - choose the new name, 2 - choose the attached files in case of problem.
    //  We work in two times, first we determine what files will move (and where) then we try to move the files.
    //  We might have to check for authorization.
    //  The directory of the new file name is just the old one without its extension.
    //  We will have to append a path component which can be the last component of the old name.
    destinationURL = wrapperURL?
        wrapperURL.URLByRemovingFactoryBaseURL4iTM3.URLByDeletingPathExtension:
            PD.fileURL.URLByDeletingPathExtension;
    [self _moveProject:PD toDestinationURL:destinationURL];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectToggleWrapper:
- (BOOL)validateProjectToggleWrapper:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
Latest Revision: Fri Mar 19 21:26:47 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = [SPC currentProject];
	NSURL * wrapperURL = PD.fileURL.enclosingWrapperURL4iTM3;
	BOOL flag = wrapperURL &&! wrapperURL.belongsToFactory4iTM3;
	sender.state = (flag?NSOnState:NSOffState);
//END4iTM3;
	return flag;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocumentKit

// wrapper documents are not used?
NSString * const iTM2WrapperInspectorType = @"Wrapper";

@implementation iTM2WrapperDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2WrapperInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project4iTM3
- (id)project4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 15:27:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	for (iTM2ProjectDocument * PD in [SPC projects])
		if (self == PD.wrapper4iTM3)
			return PD;
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapper4iTM3
- (id)wrapper4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.fileURL belongsToFactory4iTM3]? nil:self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentAs:
- (IBAction)saveDocumentAs:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 19 21:23:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2ProjectDocument * PD = self.project4iTM3;
	NSURL * old = PD.fileURL;
//  I assume that the project is just under the wrapper
	[super saveDocumentAs:(id)sender];
	if (old.isFileURL) {
		NSURL * new = [self.fileURL URLByAppendingPathComponent:old.lastPathComponent];
		if (![new isEquivalentToURL4iTM3:old]) {
			PD.fileURL = new;
			[PD updateChangeCount:NSChangeCleared];
			for (NSDocument * D in PD.subdocuments) {
				NSString * k = [PD fileKeyForSubdocument:D];
				if (k.length) {
					D.fileURL = [PD URLForFileKey:k];
				}
				[D updateChangeCount:NSChangeCleared];
			}
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSafelyToURL:ofType:forSaveOperation:error:
- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outErrorPtr
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 19 21:16:49 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	if (saveOperation == NSSaveAsOperation) {
		NSURL * src = self.fileURL;
		if ([src isEquivalentToURL4iTM3:absoluteURL]) {
			LOG4iTM3(@"*** WARNING:You gave twice the same name! (%@)",src);
			return YES;
		} else if ([DFM copyItemAtPath:src.path toPath:absoluteURL.path error:NULL]) {
			iTM2ProjectDocument * PD = self.project4iTM3;
			NSURL * fullProjectURL = [absoluteURL URLByAppendingPathComponent:PD.fileURL.lastPathComponent];
			[self writeSafelyToURL:fullProjectURL ofType:[PD fileType] forSaveOperation:NSSaveAsOperation error:nil];
			[PD setFileURL:fullProjectURL];
			[SPC flushCaches];
			[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
			return YES;
		} else {
			LOG4iTM3(@"*** ERROR:There is something wrong:I cannot make a copy");
			return NO;
		}
	} else if (saveOperation == NSSaveToOperation) {
		NSURL * src = self.fileURL;
		if ([src isEquivalentToURL4iTM3:absoluteURL]) {
			LOG4iTM3(@"*** WARNING:You gave twice the same name! (%@)",src);
			return YES;
		} else if ([DFM copyItemAtPath:src.path toPath:absoluteURL.path error:NULL]) {
			iTM2ProjectDocument * PD = self.project4iTM3;
			NSURL * fullProjectURL = [absoluteURL URLByAppendingPathComponent:PD.fileURL.lastPathComponent];
			BOOL result = [PD writeSafelyToURL:fullProjectURL ofType:[PD fileType] forSaveOperation:NSSaveToOperation error:nil];
			[SPC flushCaches];
			[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
			return result;
		} else {
			LOG4iTM3(@"*** ERROR:There is something wrong:I cannot make a copy");
			return NO;
		}
	} else {
		LOG4iTM3(@"*** ERROR:Operation not supported,report BUG");
		return NO;
	}
}
@end

@implementation iTM2StringFormatController(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_EOL
- (NSUInteger)SWZ_iTM2ProjectDocument_EOL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id D = self.document;
	id P = [D project4iTM3];
	if (P)
	{
		NSString * fileKey = [P fileKeyForSubdocument:D];
		if (fileKey.length)
		{
			NSString * EOLName = [P propertyValueForKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
			NSUInteger EOL = [iTM2StringFormatController EOLForName:EOLName];
			return EOL == iTM2UnknownEOL? [iTM2StringFormatController EOLForName:EOLName]:EOL;
		}
	}
    return [self SWZ_iTM2ProjectDocument_EOL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2ProjectDocument_setEOL:
- (void)SWZ_iTM2ProjectDocument_setEOL:(NSUInteger) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self SWZ_iTM2ProjectDocument_setEOL:argument];
	id D = self.document;
	id P = [D project4iTM3];
	NSString * fileKey = [P fileKeyForSubdocument:D];
	if (fileKey.length)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id D = self.document;
	id P = [D project4iTM3];
	if (P) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self SWZ_iTM2ProjectDocument_setStringEncoding:argument];
	id D = self.document;
	id P = [D project4iTM3];
	NSString * fileKey = [P fileKeyForSubdocument:D];
	NSString * stringEncodingName = [iTM2StringFormatController nameOfCoreFoundationStringEncoding:CFStringConvertNSStringEncodingToEncoding(argument)];
	if (fileKey.length) {
		[P setPropertyValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
	}
	fileKey = iTM2ProjectDefaultsKey;
	NSString * defaultStringEncodingName = [P propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];// we are expecting something
	if (!defaultStringEncodingName) {
		[P setPropertyValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
	}
	return;
}
@end

@implementation iTM2SubdocumentsInspector(StringFormat)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [NSNumber numberWithInteger:sender.tag];
	[self.document setPropertyValue:N forKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingToggleAuto:
- (IBAction)stringEncodingToggleAuto:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [self.document propertyValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	BOOL old = [N respondsToSelector:@selector(boolValue)]?[N boolValue]:NO;
	N = [NSNumber numberWithBool:!old];
	[self.document setPropertyValue:N forKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextStandardLocalMask];
	self.validateWindowContent4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStringEncodingToggleAuto:
- (BOOL)validateStringEncodingToggleAuto:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [self.document propertyValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	BOOL isAuto = [N respondsToSelector:@selector(boolValue)]?[N boolValue]:NO;
    sender.state = (isAuto? NSOnState:NSOffState);
	BOOL enabled = !isAuto;

	N = [self.document propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	NSInteger tag = [N respondsToSelector:@selector(integerValue)]?[N integerValue]:4;// why 4? why not
	BOOL stringEncodingNotAvailable = YES;
	NSMenu * menu = sender.menu;
	NSEnumerator * E = [menu.itemArray objectEnumerator];
	while(sender = E.nextObject)
	{
		if (sender.action == @selector(takeStringEncodingFromTag:))
		{
			[sender setEnabled:enabled];
			if (sender.tag == tag)
			{
				sender.state = NSOnState;
				stringEncodingNotAvailable = NO;
			}
			else if ([[sender attributedTitle] length])
			{
				[menu removeItem:sender];// the menu item was added because the encoding was missing in the menu
			}
			else
			{
				sender.state = NSOffState;
			}
		}
	}
	if (stringEncodingNotAvailable)
	{
		LOG4iTM3(@"StringEncoding %i is not available", tag);
		NSString * title = [NSString localizedNameOfStringEncoding:tag];
		if (!title.length)
			title = [NSString stringWithFormat:@"StringEncoding:%u", tag];
		sender = [[[NSMenuItem alloc] initWithTitle:title action:@selector(takeStringEncodingFromTag:) keyEquivalent:@""] autorelease];
		NSFont * F = [NSFont menuFontOfSize:[NSFont systemFontSize]*1.1];
		F = [SFM convertFont:F toFamily:@"Helvetica"];
		F = [SFM convertFont:F toHaveTrait:NSItalicFontMask];
		[sender setAttributedTitle:[[[NSAttributedString alloc] initWithString:title attributes:[NSDictionary dictionaryWithObjectsAndKeys:F, NSFontAttributeName, nil]] autorelease]];
		[sender setEnabled:NO];
		sender.tag = tag;
		sender.state = NSOnState;
		[menu insertItem:sender atIndex:0];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [NSNumber numberWithInteger:sender.tag];
	[self.document setPropertyValue:N forKey:TWSEOLFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeEOLFromTag:
- (BOOL)validateTakeEOLFromTag:(NSMenuItem *)sender;
/*"Description Forthcoming. This is the one form the main menu.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [self.document propertyValueForKey:TWSEOLFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	NSInteger tag = [N respondsToSelector:@selector(integerValue)]?[N integerValue]:4;// why 4? why not
	sender.state = (sender.tag == tag? NSOnState:NSOffState);
	return YES;
}
@end

@implementation NSURL(iTM2ProjectDocumentKit)
- (NSURL *)enclosingProjectURL4iTM3;
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * baseURL = self.baseURL;
	NSURL * url = baseURL.enclosingProjectURL4iTM3;
	if (url) {
		return url;
	}
	url = self;
    NSUInteger min = NSUIntegerMax;
    while (YES) {
        if ([SWS isProjectPackageAtURL4iTM3:url]) {
    //END4iTM3;
            return url;
        }
        NSUInteger L = url.relativePath.stringByStandardizingPath.length;
        if (L >= min) {
            return nil;
        }
    //END4iTM3;
        min = L;
        url = url.parentDirectoryURL4iTM3;
    }
}
- (NSURL *)enclosingWrapperURL4iTM3;
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * url = [self.baseURL enclosingWrapperURL4iTM3];
	if (url) {
		return url;
	}
	url = self;
    while (url.path.length>1) {
        if ([SWS isWrapperPackageAtURL4iTM3:url]) {
//END4iTM3;
            return url;
        }
        url = [url URLByDeletingLastPathComponent];
    };
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosedProjectURLs4iTM3
- (NSArray *)enclosedProjectURLs4iTM3;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
Latest Revision: Wed Mar 17 16:53:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!self.isFileURL) {
		return nil;
	}
	NSMutableArray * projects = [NSMutableArray array];
	NSDirectoryEnumerator * DE = [DFM enumeratorAtURL:self
        includingPropertiesForKeys:[NSArray array]
            options:NSDirectoryEnumerationSkipsPackageDescendants|NSDirectoryEnumerationSkipsHiddenFiles
                errorHandler:NULL];
	for (NSURL * theURL in DE) {
		if ([SWS isProjectPackageAtURL4iTM3:theURL]) {
			[projects addObject:theURL];
		}
	}
//END4iTM3;
	return projects;
}
@end

@implementation iTM2MainInstaller(ProjectDocumentKit)

+ (void)prepareProjectDocumentKitCompleteInstallation4iTM3;
{
    NSError * ROR = nil;
	if ([iTM2StringFormatController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocument_EOL) error:&ROR]
		&& [iTM2StringFormatController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocument_setEOL:) error:&ROR]
		&& [iTM2StringFormatController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocument_stringEncoding) error:&ROR]
		&& [iTM2StringFormatController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocument_setStringEncoding:) error:&ROR])
	{
		MILESTONE4iTM3((@"iTM2StringFormatController(iTM2ProjectDocumentKit)"),(@"No patch for EOL and StringEncoding management which is project friendly"));
	} else if (ROR) {
        LOG4iTM3(@"ROR: %@",ROR);
    }
	if ([NSApplication swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocumentKit_terminate:) error:&ROR])
	{
		MILESTONE4iTM3((@"NSApplication(iTM2ProjectDocumentKit)"),(@"WARNING:terminate message could not be patched..."));
	} else if (ROR) {
        LOG4iTM3(@"ROR: %@",ROR);
    }
	if ([NSWindowController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_windowTitleForDocumentDisplayName:) error:&ROR]
		   &&[NSWindowController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_windowsMenuItemTitleForDocumentDisplayName4iTM3:) error:&ROR])
	{
		MILESTONE4iTM3((@"NSWindowController(Project)"),(@"It is unlikely that things will work as expected..."));
	} else if (ROR) {
        LOG4iTM3(@"ROR: %@",ROR);
    }
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:1],iTM2OtherProjectWindowsAlphaValue,// to be improved...
                                nil]];
	if ([NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocument_setFileURL:) error:&ROR]
		&& [NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocument_saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:) error:&ROR]
		&& [NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_newRecentDocument) error:&ROR]
		&& [NSWindowController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocument_shouldCascadeWindows) error:&ROR])
	{
		MILESTONE4iTM3((@"NSDocument(iTM2ProjectDocumentKit)"),(@"project documents do not behave as expected"));
	} else if (ROR) {
        LOG4iTM3(@"ROR: %@",ROR);
    }
}

@end
#if 0
(?x:#
# scheme:
(?:([a-zA-Z0-9+\-\.]+):)#
# network location:
(?x://#
((?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=;?]|%[0-9a-fA-F]{2})*))?#
# path: read everything up to a slash
(?x:
(/?# <- optional leading slash
(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=]|%[0-9a-fA-F]{2})+# <- non void component
(?:/(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=]|%[0-9a-fA-F]{2})*(?=/))*# <- next components
(?:(?:#
/\.?(?:[a-zA-Z0-9\$\-_+!*''(),:@&=]|%[0-9a-fA-F]{2})(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=]|%[0-9a-fA-F]{2})*#
|/\.\.(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=]|%[0-9a-fA-F]{2})+#
|(/\.{0,2}))# <- last component
#(?:(/\.{0,2})|/(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=]|%[0-9a-fA-F]{2})*)# last component, if any
)?#
)#
)
# params:
(?:;((?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=/;]|%[0-9a-fA-F]{2})*))?#
# query:
(?:\?((?:[a-zA-Z0-9\$\-_+\.!*''(),;/?:@&=]|%[0-9a-fA-F]{2})*))?#
# fragment
(?:\#((?:[a-zA-Z0-9\$\-_+\.!*''(),;/?:@&=\#]|%[0-9a-fA-F]{2})*))?#
)# done
scheme://location@yoyodine.net/the/path/../.;pa;ram/et;ers?que;ry#frag/me?nt
sd://nets/truc/mucge/mucge/mucge/mucge/mucge
sd://nets/truc
sd://nets/truc/
sd://nets/truc/mucge/;params_sd://nets/truc/mucge/
sd://nets/truc/mucge/#fragment_sd://nets/truc/mucge/
sd://nets/truc/mucge/?query_sd://nets/truc/mucge/
sd://nets/truc/mucge/?query_sd://nets/truc/mucge/#fragment_sd://nets/truc/mucge/
sd://nets/truc/mucge/#fragment_sd://nets/truc/mucge/?query_sd://nets/truc/mucge/#fragment_sd://nets/truc/mucge/












(?x:#
# scheme:
(?:([a-zA-Z0-9+\-\.]+):)#
# network location:
(?x://#
((?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=;?]|%[0-9a-fA-F]{2})*))?#
# path: read everything up to a slash
(?x:
(/?# optional leading slash
(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=/]|%[0-9a-fA-F]{2})+# non void component
#(?:/(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=]|%[0-9a-fA-F]{2})*(?>/))*# next components
#(/\.{0,2})|(?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=]|%[0-9a-fA-F]{2})*# last component, if any
)?#
)
# params:
(?:;((?:[a-zA-Z0-9\$\-_+\.!*''(),:@&=/;]|%[0-9a-fA-F]{2})*))?#
# query:
(?:\?((?:[a-zA-Z0-9\$\-_+\.!*''(),;/?:@&=]|%[0-9a-fA-F]{2})*))?#
# fragment
(?:#((?:[a-zA-Z0-9\$\-_+\.!*''(),;/?:@&=]|%[0-9a-fA-F]{2})*))?#
)
#endif
