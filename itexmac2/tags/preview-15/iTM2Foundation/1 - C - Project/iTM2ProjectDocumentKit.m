/*
//  iTM2ProjectDocumentKit.m
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)")
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2ProjectDocumentKit.h>
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

NSString * const iTM2WrapperDocumentType = @"Wrapper Document";
NSString * const iTM2ProjectDocumentType = @"Project Document";
NSString * const iTM2WrapperPathExtension = @"wrapper";
NSString * const iTM2ProjectPathExtension = @"project";

NSString * const iTM2ProjectInfoType = @"info";
NSString * const iTM2ProjectComponent = @"Project";
NSString * const iTM2ProjectInfoComponent = @"Info";
NSString * const iTM2ProjectMetaInfoComponent = @"MetaInfo";
NSString * const iTM2ProjectPlistPathExtension = @"plist";
NSString * const iTM2ProjectTable = @"Project";
NSString * const iTM2ProjectInspectorType = @"project";
NSString * const iTM2SubdocumentsInspectorMode = @"Project Subdocuments Mode";
static NSString * const iTM2ProjectCachedKeysKey = @"info_cachedKeys";
static NSString * const iTM2ContextOpenDocuments = @"Open Documents";

NSString * const TWSKeyedFilesKey = @"files";
NSString * const TWSKeyedPropertiesKey = @"properties";
static NSString * const iTM2ProjectLastKeyKey = @"_LastKey";

NSString * const TWSFrontendComponent = @"frontends";
NSString * const iTM2ProjectFrontendType = @"frontends";

NSString * const iTM2ProjectMetaType = @"projectMeta";

NSString * const iTM2ProjectNoneKey = @"iTM2ProjectNone";

@interface iTM2ProjectDocument(FrontendKit_PRIVATE)
- (void)canCloseAllSubdocumentsWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
- (BOOL)prepareFrontendCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
- (void)dissimulateWindows;
- (void)exposeWindows;
- (NSString *)recordedKeyForFileName:(NSString *)fileName;// only use the links or finder aliases
- (NSString *)fileNameForRecordedKey:(NSString *)key;
/*! 
    @method     guessedKeyForFileName:
    @abstract   The guessed key for the given file name.
    @discussion When no key has been given yet to the argument, this method will try to guess the key from the available cached information.
				This method is private, used by keyForFileName:
				This method does not create a new key for the file name. It just use the information that once was created.
				If the returned key is not void, it is the answer of subsequent calls the keyForFileName: as long as the same argument is used.
    @param      fileName is a full path name, or relative to the project directory
    @result     An NSMutableDictionary
*/
- (NSString *)guessedKeyForFileName: (NSString *)fileName;

- (void)recordHandleToFileName:(NSString *)fileName;
@end

@interface iTM2ProjectDocument(__PRIVATE)

- (NSString *)externalFileNameForKey:(NSString *)key;// different from absoluteFileNameForKey: for external projects
- (void)_removeKey:(NSString *)key;

@end

NSString * const iTM2ProjectDefaultKey = @"_";

static NSString * const iTM2ProjectContextKeyedFilesKey = @"FileContexts";
#define iVarContextKeyedFiles modelValueForKey:iTM2ProjectContextKeyedFilesKey ofType:iTM2ProjectMetaType
#define iVarContextTypes modelValueForKey:iTM2ContextTypesKey ofType:iTM2ProjectMetaType
#define iVarContextExtensions modelValueForKey:iTM2ContextExtensionsKey ofType:iTM2ProjectMetaType

#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>

NSString * const iTM2ProjectFileKeyKey = @"iTM2ProjectFileKey";
NSString * const iTM2ProjectAbsolutePathKey = @"iTM2ProjectAbsolutePath";
NSString * const iTM2ProjectRelativePathKey = @"iTM2ProjectRelativePath";
NSString * const iTM2ProjectAliasPathKey = @"iTM2ProjectAliasPathKey";// unused

#import <iTM2Foundation/iTM2TextDocumentKit.h>

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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteDealloc
- (void)projectCompleteDealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SPC forgetProject:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromURL:ofType:error:
- (BOOL)dataCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
iTM2_LOG(@"fileURL is %@",fileURL);
	if(outError)
	{
		*outError = nil;
	}
	NSParameterAssert(fileURL);
	NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
	if([fileURL isFileURL])
	{
		NSString * path = [fileURL path];
		path = [path stringByAppendingPathComponent:component];
		fileURL = [NSURL fileURLWithPath:path];
	}
	else
	{
		fileURL = [NSURL URLWithString:component relativeToURL:fileURL];
	}
	NSData * D = [NSData dataWithContentsOfURL:fileURL];
//iTM2_END;
    if([IMPLEMENTATION loadModelValueOfDataRepresentation:D ofType:iTM2ProjectInfoType error:outError])
	{
		return YES;
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"Problem loading data at\n%@", fileURL]), (outError?*outError:nil));
		return NO;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteWriteToURL:ofType:error:
- (BOOL)dataCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outError)
	{
		*outError = nil;
	}
	NSParameterAssert(fileURL);
	[IMPLEMENTATION takeModelValue:iTM2ProjectInfoType forKey:@"isa" ofType:iTM2ProjectInfoType];
    NSData * D = [IMPLEMENTATION dataRepresentationOfModelOfType:iTM2ProjectInfoType error:outError];
//iTM2_LOG(@"[IMPLEMENTATION modelOfType:iTM2ProjectInfoType]:%@",[IMPLEMENTATION modelOfType:iTM2ProjectInfoType]);
	if(D)
	{
#if 1
		NSURL * url = [NSURL URLWithString:[iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension]
			relativeToURL:fileURL];
		NSString * path = [fileURL path];
		path = [path stringByAppendingPathComponent:iTM2ProjectInfoComponent];
		path = [path stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		fileURL = [NSURL fileURLWithPath:path];
		if(![[fileURL path] isEqual:[url path]])
		{
			iTM2_LOG(@"THIS IS NOT THE SAME PATH:\n%@\n%@\n%@\n%@", fileURL, url, [fileURL path], [url path]);
		}
#else
		NSString * path = [fileURL path];
		path = [path stringByAppendingPathComponent:iTM2ProjectInfoComponent];
		path = [path stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		fileURL = [NSURL fileURLWithPath:path];
#endif
//iTM2_LOG(@"fileURL: %@",fileURL);
//iTM2_LOG(@"path: %@",[fileURL path]);
		if([D writeToURL:fileURL options:NSAtomicWrite error:outError])
//		if([D writeToURL:fileURL options:0 error:outError])
		{
//RL fileiTM2_LOG(@"SAVED: %@",[NSDictionary dictionaryWithContentsOfURL:fileURL]);
			return YES;
		}
		else
		{
			iTM2_OUTERROR(2,([NSString stringWithFormat:@"Could not write %@ to\n%@", iTM2ProjectInfoType, fileURL]), (outError?*outError:nil));
			return NO;
		}
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"Could create data for\n%@", iTM2ProjectInfoType]), (outError?*outError:nil));
		return NO;
	}
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
	return [[projectName lowercaseString] isEqual:@"project"]? @"":projectName;
}
#warning DEBUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL*)url;
/*"Projects are no close documents!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * old = [self fileURL];
	if(![old isEqual:url])
	{
		// CLEAN the cached data
		[SPC flushCaches];
	}
    [super setFileURL:url];
    return;
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
    return @"BASE";
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
//iTM2_LOG(@"[self fileURL]:%@", [self fileURL]);
	[super saveDocument:sender];
//iTM2_END;
	return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  refixConsistency
- (void)refixConsistency;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// there might be some external changes in the project since the last time we opened it
	// we can try to fix weird things
	// - test for moved files:
	// if every file of the project have moved the same way, then we can assume that the project should move accordingly
	NSArray * allKeys = [self allKeys];
	NSEnumerator * E = [allKeys objectEnumerator];
	NSString * key = nil;
	NSString * path = nil;
	NSMutableDictionary * absoluteFileNames = [NSMutableDictionary dictionary];
	while(key = [E nextObject])
	{
		path = [self absoluteFileNameForKey:key];
		if([DFM fileExistsAtPath:path])
		{
			[absoluteFileNames setObject:path forKey:key];
		}
		else
		{
			path = [self fileNameForRecordedKey:key];
			if([DFM fileExistsAtPath:path])
			{
				[self setFileName:path forKey:key makeRelative:YES];
				[absoluteFileNames setObject:path forKey:key];
			}
		}
	}
	// don't go further for project embedded in wrappers
	NSString * projectName = [self fileName];
	NSString * wrapperName = [projectName enclosingWrapperFileName];
	if([wrapperName length] && ![wrapperName belongsToExternalProjectsDirectory])
	{
		return;
	}
	// should I move the project?
	// Getting the directory where all the files are stored
	NSMutableDictionary * tree = [NSMutableDictionary dictionary];
	E = [allKeys objectEnumerator];
	while(key = [E nextObject])
	{
		path = [self absoluteFileNameForKey:key];
iTM2_LOG(@"key: %@, path: %@", key, path);
		if(![path belongsToExternalProjectsDirectory])// actually this never occurs due to the def of absoluteFileNameForKey (06/02/06)
		{
			NSMutableDictionary * subtree = tree;
			NSArray * pathComponents = [path pathComponents];
			NSEnumerator * e = [pathComponents objectEnumerator];
			while(path = [e nextObject])
			{
				NSMutableDictionary * md = [subtree objectForKey:path];
				if([md count]>1)
				{
					// no need to go further
					break;
				}
				else if(!md)
				{
					[subtree setObject:[NSMutableDictionary dictionary] forKey:path];
					md = [subtree objectForKey:path];
				}
				subtree = md;
			}
		}
	}
iTM2_LOG(@"tree is: %@", tree);
	NSMutableArray * commonComponents = [NSMutableArray array];
	while([tree count] == 1)
	{
		key = [[tree allKeys] lastObject];
		[commonComponents addObject:key];
		tree = [tree objectForKey:key];
	}
iTM2_LOG(@"commonComponents is: %@", commonComponents);
iTM2_LOG(@"[self fileName] is: %@", [self fileName]);
	NSString * ancestor = [NSString pathWithComponents:commonComponents];
	if([ancestor length]<2)
	{
		// all the files in the project belong to the external stuff?
		return;// this is unreachable code (06/02/06)
	}
	NSString * relative = nil;
	NSString * dest = nil;
	NSString * wrapperAncestor = [ancestor enclosingWrapperFileName];
	if([wrapperAncestor length])
	{
		NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:wrapperAncestor];
		NSString * component = nil;
		while(component = [DE nextObject])
		{
			NSString * fullPath = [wrapperAncestor stringByAppendingPathComponent:component];
			if([SWS isProjectPackageAtPath:fullPath])
			{
				return;
			}
		}
		iTM2_LOG(@"***  ERROR: this wrapper %@ seems to miss a project...", wrapperAncestor);
		#warning PLEASE try to add a project to this wrapper
	}
	if([projectName belongsToExternalProjectsDirectory])
	{
		if([wrapperName belongsToExternalProjectsDirectory])
		{
			// this is one of the natural ways of thinking
			relative = [projectName stringByAbbreviatingWithDotsRelativeToDirectory:wrapperName];
			dest = [wrapperName lastPathComponent];
			dest = [ancestor stringByAppendingPathComponent:dest];
			dest = [[NSString externalProjectsDirectory] stringByAppendingPathComponent:dest];
			dest = [dest stringByStandardizingPath];
			if([dest isEqual:wrapperName])
			{
				return;
			}
			[DFM createDeepDirectoryAtPath:ancestor attributes:nil error:nil];
			BOOL yorn = NO;
			if([DFM fileExistsAtPath:ancestor isDirectory:&yorn] && yorn)
			{
				if([DFM fileExistsAtPath:dest])
				{
					iTM2_LOG(@"*** WARNING: at first glance, there should be nothing at\n%@\nit will be replaced.",dest);
					if(![DFM removeFileAtPath:dest handler:NULL])
					{
						iTM2_LOG(@"*** WARNING: could not remove file at %@",dest);
						return;
					}
				}
				if([DFM movePath:wrapperName toPath:dest handler:NULL])
				{
					path = [dest stringByAppendingPathComponent:relative];
					path = [path stringByStandardizingPath];
					[self setFileName:path];
					allKeys = [absoluteFileNames allKeys];
					E = [allKeys objectEnumerator];
					while(key = [E nextObject])
					{
						path = [absoluteFileNames objectForKey:key];
						[self setFileName:path forKey:key makeRelative:YES];
					}
					return;
				}
				else
				{
					iTM2_LOG(@"*** WARNING: could not move\n%@\nto\n%@.",wrapperName,dest);
				}
			}
			return;
		}
		// the wrapper must be created as a simple directory
		relative = [projectName lastPathComponent];
		ancestor = [ancestor stringByAppendingPathComponent:relative];
		ancestor = [ancestor stringByDeletingPathExtension];
		ancestor = [ancestor stringByAppendingPathExtension:[SDC wrapperPathExtension]];
		//
		[DFM createDeepDirectoryAtPath:ancestor attributes:nil error:nil];
		BOOL yorn = NO;
		if([DFM fileExistsAtPath:ancestor isDirectory:&yorn] && yorn)
		{
			dest = [ancestor stringByAppendingPathComponent:relative];
			if([DFM fileExistsAtPath:dest])
			{
				iTM2_LOG(@"*** WARNING: at first glance, there should be nothing at\n%@\nit will be replaced.",dest);
				if(![DFM removeFileAtPath:dest handler:NULL])
				{
					iTM2_LOG(@"*** WARNING: could not remove file at %@",dest);
					return;
				}
			}
			if([DFM movePath:projectName toPath:dest handler:NULL])
			{
				[self setFileName:dest];
				allKeys = [absoluteFileNames allKeys];
				E = [allKeys objectEnumerator];
				while(key = [E nextObject])
				{
					path = [absoluteFileNames objectForKey:key];
					[self setFileName:path forKey:key makeRelative:YES];
				}
				return;
			}
			else
			{
				iTM2_LOG(@"*** WARNING: could not move\n%@\nto\n%@.",wrapperName,dest);
			}
		}
		return;
	}
	// the project is not external
	// the ancestor is not external
	// the ancestor does not belong to a wrapper
	if([wrapperName length])
	{// don't touch the project
		return;
	}
	// Can I move the project to this location?
	relative = [projectName lastPathComponent];
	dest = [ancestor stringByAppendingPathComponent:relative];
	if([projectName isEqual:dest])
	{
		return;
	}
	if([DFM fileExistsAtPath:dest])
	{
		iTM2_LOG(@"*** WARNING: at first glance, there should be nothing at\n%@\nit will be replaced.",dest);
		if(![DFM removeFileAtPath:dest handler:NULL])
		{
			iTM2_LOG(@"*** WARNING: could not remove file at %@",dest);
			return;
		}
	}
	if([DFM movePath:projectName toPath:dest handler:NULL])
	{
		[self setFileName:dest];
		allKeys = [absoluteFileNames allKeys];
		E = [allKeys objectEnumerator];
		while(key = [E nextObject])
		{
			path = [absoluteFileNames objectForKey:key];
			[self setFileName:path forKey:key makeRelative:YES];
		}
		return;
	}
	else
	{
		iTM2_LOG(@"*** WARNING: could not move\n%@\nto\n%@.",wrapperName,dest);
	}
//iTM2_END;
	return;
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
		return;
    [super makeWindowControllers];// after the documents are open
    [self addGhostWindowController];
//iTM2_END;
    return;
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
    if(![self contextBoolForKey:@"iTM2DontOpenSubdocumentsWindow"])
    {
        NS_DURING;
        NSArray * previouslyOpenDocuments = [self contextValueForKey:iTM2ContextOpenDocuments];
        if(iTM2DebugEnabled>1000)
        {
            iTM2_LOG(@"The documents to be opened are:%@", previouslyOpenDocuments);
        }
        NSString * dirName = [[self fileName] stringByDeletingLastPathComponent];
		if([dirName belongsToExternalProjectsDirectory])
		{
			dirName = [dirName stringByStrippingExternalProjectsDirectory];
			dirName = [dirName stringByDeletingLastPathComponent];
		}
        NSEnumerator * E = [previouslyOpenDocuments objectEnumerator];
        NSString * K;
        while(K = [E nextObject])
		{
			NSError * localError = nil;
            if(![self openSubdocumentForKey:K display:YES error:&localError] && localError)
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Problem opening file at\n%@",[self relativeFileNameForKey:K]]),localError);
			}
		}
        NS_HANDLER
        iTM2_LOG(@"***  CATCHED exception:%@", [localException reason]);
        NS_ENDHANDLER
    }	
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
	// that way, the ghost window is not used when sheets are to be displayed.
	id GWC = [IMPLEMENTATION metaValueForKey:@"_GWC"];
	[super removeWindowController:GWC];
	[super addWindowController:windowController];
	[super addWindowController:GWC];
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
            [W setFrameOrigin:NSMakePoint(15000, 15000)];
		GWC = [[[NSWindowController allocWithZone:[self zone]] initWithWindow:W] autorelease];
		[self addWindowController:GWC];
		[IMPLEMENTATION takeMetaValue:GWC forKey:@"_GWC"];
		[[GWC window] setExcludedFromWindowsMenu:NO];
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
    if(![[self windowControllers] count] && ![[self subdocuments] count])
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
	NSEnumerator * E = [[NSApp windows] objectEnumerator];
	NSWindow * W;
	NSMutableArray * windows = [[self implementation] metaValueForKey:@"_WindowsMarkedWithTransparency"];
	if(!windows)
	{
		windows = [NSMutableArray array];
		[[self implementation] takeMetaValue:windows forKey:@"_WindowsMarkedWithTransparency"];
	}
	while(W = [E nextObject])
	{
		if([SPC projectForSource:W] == self)
		{
			NSValue * V = [NSValue valueWithNonretainedObject:W];
			if(![windows containsObject:V])
			{
				[windows addObject:V];
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
	NSEnumerator * E = [[NSApp windows] objectEnumerator];
	NSWindow * W;
	NSMutableArray * windows = [[self implementation] metaValueForKey:@"_WindowsMarkedWithTransparency"];
	while(W = [E nextObject])
	{
		if([SPC projectForSource:W] == self)
		{
			NSValue * V = [NSValue valueWithNonretainedObject:W];
			if([windows containsObject:V])
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
//iTM2_LOG(@"miniaturize for project:%@", self);
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocuments
- (id)subdocuments;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSubdocuments:
- (void)setSubdocuments:(id)documents;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareSubdocumentsFixImplementation
- (void)prepareSubdocumentsFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setSubdocuments:[NSMutableSet set]];
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
	id projectDocument = [SPC projectForFileName:[document fileName]];
	NSAssert3(!projectDocument || (projectDocument == self), @"The document\n%@\ncannot be assigned to project\n%@\nbecause it already belongs to another project\n%@",[document fileName],[self fileName],[projectDocument fileName]);
	[self newKeyForFileName:[document fileName]];
//iTM2_LOG(@"[self keyForFileName:[document fileName]]:<%@>",[self keyForFileName:[document fileName]]);
	[SDC removeDocument:[[document retain] autorelease]];// remove first
	[[self subdocuments] addObject:document];// added into a set, no effect if the object is already there...
	NSString * key = [self keyForSubdocument:document];// create the appropriate binding as side effect
	NSAssert([key length], @"Missing key for a document...");
	[SPC setProject:self forDocument:document];
	if(![self isEqual:[SPC projectForSource:document]])
	{
		[SPC flushCaches];
		[SPC setProject:self forDocument:document];
		if(![self isEqual:[SPC projectForSource:document]])
		{
			iTM2_LOG(@".........  ERROR:There is a really big problem, the SPC does not want to link a document and its project");
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeSubdocument:
- (void)removeSubdocument:(id)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self subdocuments] containsObject:document])
    {
		[[document retain] autorelease];
		NSString * key = [self keyForSubdocument:document];
		[self removeKey:key];
        [[self subdocuments] removeObject:document];
		[SPC setProject:nil forDocument:document];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
    }
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  closeSubdocument:
- (void)closeSubdocument:(id)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self subdocuments] containsObject:document])
    {
		[[document retain] autorelease];
		[document saveContext:nil];
		[SPC setProject:nil forDocument:document];
        [[self subdocuments] removeObject:document];
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
	[[self subdocuments] makeObjectsPerformSelector:@selector(saveDocument:) withObject:sender];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:
- (void)canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
/*"If the receiver can close, it asks its project documents to close.
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
//iTM2_LOG(@"delegate is:%@, shouldCloseSelector is:%@, contextInfo is:%#x", delegate, NSStringFromSelector(shouldCloseSelector), contextInfo);
#if 0
    if([self isDocumentEdited])
	{
		// order front the first project window found in the list, except the ghost window
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
#elif 0
	// there is a problem with the window.
	// if we do nothing the sheet won't display from the correct window.
	if([self isDocumentEdited])
	{
		// try to order some project window front
		// get the first window except the ghost window, order it front
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
	theEnd:;
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
	iTM2_LOG(@"A delegate is expected to implement a should close selector:\ndelegate; %@\nselector:%@", delegate, NSStringFromSelector(shouldCloseSelector));
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
//iTM2_LOG(@"invocation is:%@", invocation);
	if(shouldClose && ([[self subdocuments] count]))
	{
		[self canCloseAllSubdocumentsWithDelegate:self shouldCloseSelector:@selector(__project:shouldCloseAllSubdocuments:shouldCloseInvocation:)contextInfo:(void *)invocation];
    }
	else
	{
		[invocation autorelease];
		[invocation setArgument:&shouldClose atIndex:3];// there is a problem of range "parameter index 3 not in range (-1,2)", nonsense! now "parameter index 3 not in range (-1,3)"
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
//iTM2_LOG(@"delegate is:%@, shouldCloseSelector is:%@, contextInfo is:%#x", delegate, NSStringFromSelector(shouldCloseSelector), contextInfo);
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
			iTM2_LOG(@"ERROR:The delegate is expected to implement %@", NSStringFromSelector(shouldCloseSelector));
		}
		NSEnumerator * E = [subdocuments objectEnumerator];
		id subdocument;
		while(subdocument = [E nextObject])
			[subdocument canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__subdocument:shouldClose:contextDictionary:)contextInfo:[contextDictionary retain]];
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
//iTM2_LOG(@"[doc fileName] is:%@, contextInfo is:%#x", [doc fileName], contextInfo);
    [contextDictionary autorelease];// Compensates the retains
	if(!shouldClose)
        [contextDictionary setObject:[NSNumber numberWithBool:YES]
			forKey:@"There are edited project documents"];
    NSMutableArray * MRA = [contextDictionary objectForKey:@"Should close documents"];
    [MRA removeObject:doc];
    if([MRA count] == 0)
    {
        NSInvocation * I = [[contextDictionary objectForKey:@"Invocation"] retain];
    //iTM2_LOG(@"PURE RETAIN? %i", [self retainCount]);
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
In the first one, the documents will be closed by the document controller,
in the second one, the project is responsible for closing the docs.
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
In the first one, the documents will be closed by the document controller,
in the second one, the project is responsible for closing the docs.
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
//In the standard cocoa, closing a project document can cause the sub documents to be closed too despite they are edited
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
	if([SUD boolForKey:@"iTM2ApplicationIsTerminating"])// this is YES when terminating, awful patch
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentForFileName:
- (id)subdocumentForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	NSDocument * D;
	while(D = [E nextObject])
		if([[D fileName] isEqualToFileName:fileName] || [[D originalFileName] isEqualToFileName:fileName])
			return D;
    return nil;
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
	id SD = nil;
	while(SD = [E nextObject])
	{
		if([url isEqual:[SD fileURL]])
		{
			return SD;
		}
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentURLForKey:
- (NSURL *)subdocumentURLForKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * AFN = [self absoluteFileNameForKey:key];
    return [AFN length]? [NSURL fileURLWithPath:AFN]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  externalSubdocumentURLForKey:
- (NSURL *)externalSubdocumentURLForKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * EFN = [self externalFileNameForKey:key];
    return [EFN length]? [NSURL fileURLWithPath:EFN]:nil;
}
#pragma mark =-=-=-=-=-  FILE <-> KEY
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  relativeFileNameForKey:
- (NSString *)relativeFileNameForKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([key length])
	{
		NSMutableDictionary * keyedFileNames = [self keyedFileNames];
		NSString * result = [keyedFileNames valueForKey:key];
		if([result hasPrefix:iTM2PathComponentsSeparator])
		{
			// there was an error: it seems to be an absolute file name instead of a relative one.
			// make it relative and things will most certainly go better
			NSString * path = [self fileName];
			iTM2_LOG(@"WARNING: automatic correction of project named %@\na file name for key %@ was expected to be relative: %@",
				path, key, result);
			path = [path stringByDeletingLastPathComponent];
			if([path belongsToExternalProjectsDirectory])
			{
				if([result belongsToExternalProjectsDirectory])
				{
					result = [result stringByAbbreviatingWithDotsRelativeToDirectory:path];
				}
				else
				{
					path = [path stringByStrippingExternalProjectsDirectory];
					result = [result stringByAbbreviatingWithDotsRelativeToDirectory:path];
				}
			}
			else if([result belongsToExternalProjectsDirectory])
			{
				result = [result stringByStrippingExternalProjectsDirectory];
				result = [result stringByAbbreviatingWithDotsRelativeToDirectory:path];
			}
			else
			{
				result = [result stringByAbbreviatingWithDotsRelativeToDirectory:path];
			}
			[keyedFileNames setValue:result forKey:key];
		}
		return result;
	}
//iTM2_END;
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  absoluteFileNameForKey:
- (NSString *)absoluteFileNameForKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * end = [self relativeFileNameForKey:key];
	NSString * dirName = [[self fileName] stringByStandardizingPath];
	dirName = [dirName stringByStandardizingPath];
	dirName = [dirName stringByDeletingLastPathComponent];
	NSString * result = @"";
	if([dirName belongsToExternalProjectsDirectory])
	{
		dirName = [dirName stringByDeletingLastPathComponent];// the *.texd last component is removed
		dirName = [dirName stringByStrippingExternalProjectsDirectory];
	}
	result = [dirName stringByAppendingPathComponent:end];
	result = [result stringByStandardizingPath];
	return result;// does it exist? I don't care, the client will decide
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  externalFileNameForKey:
- (NSString *)externalFileNameForKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * end = [self relativeFileNameForKey:key];
	NSString * dirName = [[self fileName] stringByStandardizingPath];
	dirName = [dirName stringByStandardizingPath];
	dirName = [dirName stringByDeletingLastPathComponent];
	NSString * result = [dirName stringByAppendingPathComponent:end];
	result = [result stringByStandardizingPath];
//iTM2_END;
	return result;// does it exist? I don't care, the client will decide
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileName:forKey:makeRelative:
- (void)setFileName:(NSString *)fileName forKey:(NSString *)key makeRelative:(BOOL)makeRelativeFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![key length])
		return;
	if(![[self allKeys] containsObject:key])
		return;
	if([fileName hasPrefix:iTM2PathComponentsSeparator] && [DFM fileExistsAtPath:fileName] && !makeRelativeFlag)
	{
		iTM2_LOG(@"WARNING: the file name %@ being absolute, it is made relative", fileName);
		makeRelativeFlag = YES;
	}
	NSString * old = makeRelativeFlag? [self absoluteFileNameForKey:key]:[self relativeFileNameForKey:key];
	if([fileName belongsToExternalProjectsDirectory])
	{
		fileName = [fileName stringByStrippingExternalProjectsDirectory];
	}
	fileName = [fileName stringByResolvingSymlinksAndFinderAliasesInPath];// no more soft link
	NSString * dirName = [[self fileName] stringByStandardizingPath];
	if([dirName belongsToExternalProjectsDirectory])
	{
		dirName = [dirName stringByStrippingExternalProjectsDirectory];
		dirName = [dirName stringByDeletingLastPathComponent];
	}
	dirName = [dirName stringByDeletingLastPathComponent];
	dirName = [dirName stringByResolvingSymlinksAndFinderAliasesInPath];// no more soft link
	NSString * new = makeRelativeFlag? [fileName stringByAbbreviatingWithDotsRelativeToDirectory:dirName] :fileName;
//iTM2_LOG(@"old: %@", old);
//iTM2_LOG(@"new: %@", new);
	if(![old isEqual:new])
	{
		[[self keyedFileNames] takeValue:new forKey:key];
		NSAssert1([key isEqual:[self keyForFileName:fileName]],(@"AIE AIE INCONSITENT STATE %s"),__PRETTY_FUNCTION__);
		[SPC flushCaches];
		[self updateChangeCount:NSChangeDone];
		[IMPLEMENTATION takeMetaValue:nil forKey:iTM2ProjectCachedKeysKey];// clean the cached keys
		
		NSEnumerator * E = [[self windowControllers] objectEnumerator];
		id WC;
		while(WC = [E nextObject])
		{
			if([WC respondsToSelector:@selector(updateOrderedFileKeys)])
			{
				[WC updateOrderedFileKeys];
				[WC validateWindowContent];
			}
		}
	}
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyForFileName:
- (NSString *)keyForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileName length])// untitled documents will go there
		return @"";
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
    if(!cachedKeys)
    {
        cachedKeys = [NSMutableDictionary dictionary];
        [IMPLEMENTATION takeMetaValue:cachedKeys forKey:iTM2ProjectCachedKeysKey];
    }
//iTM2_LOG(@"BEFORE cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	fileName = [fileName stringByStandardizingPath];
    NSString * result;
	if(result = [cachedKeys objectForKey:fileName])
	{
		return result;
	}
	// Is it me?
	NSString * path = [self fileName];
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	if([path isEqual:fileName])
	{
		result = @".";
		[cachedKeys setObject:result forKey:fileName];
	}
	// Here begins the hard work
	NSArray * Ks = [self allKeys];
//iTM2_LOG(@"[self keyedFileNames]:%@",[self keyedFileNames]);
//iTM2_LOG(@"path: %@",path);
//iTM2_LOG(@"fileName: %@",fileName);
	NSEnumerator * E = nil;
	E = [Ks objectEnumerator];
	while(result = [E nextObject])
	{
		path = [self absoluteFileNameForKey:result];
		if([path isEqualToString:fileName])
		{
			[cachedKeys setObject:result forKey:fileName];
			return result;
		}
	}
	// last chance if the file name is external
	if([fileName belongsToExternalProjectsDirectory])
	{
		NSString * dirName = [self fileName];
		dirName = [dirName stringByDeletingLastPathComponent];
		E = [Ks objectEnumerator];
		while(result = [E nextObject])
		{
			path = [self externalFileNameForKey:result];
//iTM2_LOG(@"path  is: %@", path);
//iTM2_LOG(@"fileName: %@", fileName);
			if([path isEqualToString:fileName])
			{
				[cachedKeys setObject:result forKey:fileName];
				return result;
			}
		}
	}
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	return result;
}
#elif 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyForFileName:
- (NSString *)keyForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileName length])// untitled documents will go there
		return @"";
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
    if(!cachedKeys)
    {
        cachedKeys = [NSMutableDictionary dictionary];
        [IMPLEMENTATION takeMetaValue:cachedKeys forKey:iTM2ProjectCachedKeysKey];
    }
//iTM2_LOG(@"BEFORE cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	fileName = [fileName stringByStandardizingPath];
	NSMutableArray * fileNames = [NSMutableArray array];
    NSString * result;
	if(result = [cachedKeys objectForKey:fileName])
	{
		return result;
	}
	// This is most certainly the first time this key is requested
	// try to give it a key...
	
	[fileNames addObject:fileName];
	NSString * name = [fileName stringByResolvingSymlinksAndFinderAliasesInPath];
	if(result = [cachedKeys objectForKey:name])
	{
		NSAssert1([result isKindOfClass:[NSString class]], @"Expected string instead of %@", result);
		[cachedKeys takeValue:result forKey:fileName];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
		return result;
	}
	[fileNames addObject:name];
	result = @"";
	NSMutableArray * dirNames = [NSMutableArray array];
	NSString * projectName = [[self fileName] stringByStandardizingPath];
	NSString * dirName = [[projectName stringByDeletingLastPathComponent] stringByStandardizingPath];
	[dirNames addObject:dirName];
	BOOL isDirectory = NO;
	NSString * resolved = nil;
	if([dirName belongsToExternalProjectsDirectory])
	{
		name = [dirName stringByStrippingExternalProjectsDirectory];
		name = [name stringByDeletingLastPathComponent];
		resolved = [name stringByResolvingSymlinksAndFinderAliasesInPath];
		if([DFM fileExistsAtPath:resolved isDirectory:&isDirectory] && isDirectory)
		{
			[dirNames addObject:name];
		}
	}
	resolved = [dirName stringByResolvingSymlinksAndFinderAliasesInPath];
	if([DFM fileExistsAtPath:resolved isDirectory:&isDirectory] && isDirectory)
	{
		[dirNames addObject:resolved];
	}
	NSString * relativeName = nil;
	NSEnumerator * E = [fileNames objectEnumerator];
	while(name = [E nextObject])
	{
		NSEnumerator * e = [dirNames objectEnumerator];
		while(dirName = [e nextObject])
		{
			relativeName = [fileName stringByAbbreviatingWithDotsRelativeToDirectory:dirName];
			if([name isEqual:projectName])
			{
				result = @".";
				[cachedKeys takeValue:result forKey:fileName];
				[cachedKeys takeValue:result forKey:relativeName];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
				return result;
			}
			else if(result = [[[self keyedFileNames] allKeysForObject:relativeName] lastObject])
			{
				NSAssert1([result isKindOfClass:[NSString class]], @"Expected string instead of %@", result);
				[cachedKeys takeValue:result forKey:fileName];
				[cachedKeys takeValue:result forKey:relativeName];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
				return result;
			}
		}
	}
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	return result;
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyForFileName:
- (NSString *)keyForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileName length])// untitled documents will go there
		return @"";
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
    if(!cachedKeys)
    {
        cachedKeys = [NSMutableDictionary dictionary];
        [IMPLEMENTATION takeMetaValue:cachedKeys forKey:iTM2ProjectCachedKeysKey];
    }
//iTM2_LOG(@"BEFORE cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	fileName = [fileName stringByStandardizingPath];
	NSMutableArray * fileNames = [NSMutableArray array];
    NSString * result;
	if(result = [cachedKeys objectForKey:fileName])
		return result;
	[fileNames addObject:fileName];
	NSString * name = [fileName stringByResolvingSymlinksAndFinderAliasesInPath];
	if(result = [cachedKeys objectForKey:name])
	{
		NSAssert1([result isKindOfClass:[NSString class]], @"Expected string instead of %@", result);
		[cachedKeys takeValue:result forKey:fileName];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
		return result;
	}
	[fileNames addObject:name];
	result = @"";
	NSMutableArray * dirNames = [NSMutableArray array];
	NSString * projectName = [[self fileName] stringByStandardizingPath];
	NSString * dirName = [[projectName stringByDeletingLastPathComponent] stringByStandardizingPath];
	[dirNames addObject:dirName];
	BOOL isDirectory = NO;
	NSString * resolved = nil;
	if([dirName belongsToExternalProjectsDirectory])
	{
		name = [dirName stringByStrippingExternalProjectsDirectory];
		name = [name stringByDeletingLastPathComponent];
		resolved = [name stringByResolvingSymlinksAndFinderAliasesInPath];
		if([DFM fileExistsAtPath:resolved isDirectory:&isDirectory] && isDirectory)
		{
			[dirNames addObject:name];
		}
	}
	resolved = [dirName stringByResolvingSymlinksAndFinderAliasesInPath];
	if([DFM fileExistsAtPath:resolved isDirectory:&isDirectory] && isDirectory)
	{
		[dirNames addObject:resolved];
	}
	NSString * relativeName = nil;
	NSEnumerator * E = [fileNames objectEnumerator];
	while(name = [E nextObject])
	{
		NSEnumerator * e = [dirNames objectEnumerator];
		while(dirName = [e nextObject])
		{
			relativeName = [fileName stringByAbbreviatingWithDotsRelativeToDirectory:dirName];
			if([name isEqual:projectName])
			{
				result = @".";
				[cachedKeys takeValue:result forKey:fileName];
				[cachedKeys takeValue:result forKey:relativeName];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
				return result;
			}
			else if(result = [[[self keyedFileNames] allKeysForObject:relativeName] lastObject])
			{
				NSAssert1([result isKindOfClass:[NSString class]], @"Expected string instead of %@", result);
				[cachedKeys takeValue:result forKey:fileName];
				[cachedKeys takeValue:result forKey:relativeName];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
				return result;
			}
		}
	}
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	return result;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordedKeyForFileName:
- (NSString *)recordedKeyForFileName:(NSString *)fileName;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = @"";
	NSString * projectName = [self fileName];
	projectName = [projectName stringByStandardizingPath];
	NSString * subdirectory = [projectName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:subdirectory];
	// subdirectory variable is free now
	NSString * source = nil;
	NSString * target = nil;
	while(key = [DE nextObject])
	{
		source = [subdirectory stringByAppendingPathComponent:key];
		NSURL * url = [NSURL fileURLWithPath:source];
		NSData * aliasData = [NSData aliasDataWithContentsOfURL:url error:nil];
		target = [aliasData pathByResolvingDataAliasRelativeTo:nil error:nil];
		if([target isEqual:fileName])
		{
			// OK, this alias points to the given named file.
			// the file was just moved around
			// is it this key available
			target = [self absoluteFileNameForKey:key];
			if([target isEqual:fileName])
			{
				return key;
			}
			if([DFM fileExistsAtPath:target])
			{
				// it is certainly a duplicate file
				if([DFM removeFileAtPath:source handler:NULL])
				{
					iTM2_LOG(@"Information: there was an alias pointing to the wrong object at\n%@", source);
				}
				else
				{
					iTM2_LOG(@"WARNING(1): COULD NOT REMOVE FILE AT PATH:\n%@", source);
				}
				return nil;
			}
			return key;
		}
		else if([target length] && ![DFM fileExistsAtPath:target])
		{
			if([DFM removeFileAtPath:source handler:NULL])
			{
				iTM2_LOG(@"Information: there was an alias pointing to nothing at\n%@", source);
			}
			else
			{
				iTM2_LOG(@"WARNING(4): COULD NOT REMOVE FILE AT PATH:\n%@", source);
			}
		}
	}
	subdirectory = [projectName stringByAppendingPathComponent:[SPC softLinksSubdirectory]];
	DE = [DFM enumeratorAtPath:subdirectory];
	// subdirectory is free now
	while(key = [DE nextObject])
	{
		source = [subdirectory stringByAppendingPathComponent:key];
		target = [DFM pathContentOfSymbolicLinkAtPath:source];
		if([target isEqual:fileName])
		{
			// OK, this soft link points to the given named file.
			// is it this key available
			target = [self absoluteFileNameForKey:key];
			if([target isEqual:fileName])
			{
				return key;
			}
			if([DFM fileExistsAtPath:target])
			{
				// it is certainly a duplicate file
				if(![DFM removeFileAtPath:source handler:NULL])
				{
					iTM2_LOG(@"WARNING(3): COULD NOT REMOVE FILE AT PATH:\n%@", source);
				}
				return @"";
			}
			return key;
		}
		else if([target length] && ![DFM fileExistsAtPath:target] && ![DFM removeFileAtPath:source handler:NULL])
		{
			iTM2_LOG(@"WARNING(4): COULD NOT REMOVE FILE AT PATH:\n%@", source);
		}
	}
//iTM2_END;
	return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileNameForRecordedKey:
- (NSString *)fileNameForRecordedKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning NYI
#if 0
	NSString * projectName = [self fileName];
	projectName = [projectName stringByStandardizingPath];
	NSString * subdirectory = [projectName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:subdirectory];
	// subdirectory variable is free now
	NSString * source = nil;
	NSString * target = nil;
	while(key = [DE nextObject])
	{
		source = [subdirectory stringByAppendingPathComponent:key];
		NSURL * url = [NSURL fileURLWithPath:source];
		NSData * aliasData = [NSData aliasDataWithContentsOfURL:url error:nil];
		target = [aliasData pathByResolvingDataAliasRelativeTo:nil error:nil];
		if([target isEqual:fileName])
		{
			// OK, this alias points to the given named file.
			// is it this key available
			target = [self absoluteFileNameForKey:key];
			if([target isEqual:fileName])
			{
				return key;
			}
			if([DFM fileExistsAtPath:target])
			{
				// it is certainly a duplicate file
				if([DFM removeFileAtPath:source handler:NULL])
				{
					iTM2_LOG(@"Information: there was an alias pointing to the wrong object at\n%@", source);
				}
				else
				{
					iTM2_LOG(@"WARNING(1): COULD NOT REMOVE FILE AT PATH:\n%@", source);
				}
				return nil;
			}
			return key;
		}
		else if([target length] && ![DFM fileExistsAtPath:target])
		{
			if([DFM removeFileAtPath:source handler:NULL])
			{
				iTM2_LOG(@"Information: there was an alias pointing to nothing at\n%@", source);
			}
			else
			{
				iTM2_LOG(@"WARNING(4): COULD NOT REMOVE FILE AT PATH:\n%@", source);
			}
		}
	}
	subdirectory = [projectName stringByAppendingPathComponent:[SPC softLinksSubdirectory]];
	DE = [DFM enumeratorAtPath:subdirectory];
	// subdirectory is free now
	while(key = [DE nextObject])
	{
		source = [subdirectory stringByAppendingPathComponent:key];
		target = [DFM pathContentOfSymbolicLinkAtPath:source];
		if([target isEqual:fileName])
		{
			// OK, this soft link points to the given named file.
			// is it this key available
			target = [self absoluteFileNameForKey:key];
			if([target isEqual:fileName])
			{
				return key;
			}
			if([DFM fileExistsAtPath:target])
			{
				// it is certainly a duplicate file
				if(![DFM removeFileAtPath:source handler:NULL])
				{
					iTM2_LOG(@"WARNING(3): COULD NOT REMOVE FILE AT PATH:\n%@", source);
				}
				return @"";
			}
			return key;
		}
		else if([target length] && ![DFM fileExistsAtPath:target] && ![DFM removeFileAtPath:source handler:NULL])
		{
			iTM2_LOG(@"WARNING(4): COULD NOT REMOVE FILE AT PATH:\n%@", source);
		}
	}
#endif
//iTM2_END;
	return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newKeyForFileName:fileContext:
- (NSString *)newKeyForFileName:(NSString *)fileName fileContext:(NSDictionary *)context;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	fileName = [fileName stringByStandardizingPath];
	NSString * key = [self newKeyForFileName:fileName];
	if([key length])
		return key;
	key = [context objectForKey:iTM2ProjectFileKeyKey];
	if([key isKindOfClass:[NSString class]] && [key length])
	{
		// is this key already registered?
		NSString * alreadyFileName = [self absoluteFileNameForKey:key];
		NSAssert(![alreadyFileName isEqual:fileName], @"You missed something JL... Shame on u");
		if([alreadyFileName length])
		{
			// yes it is
			// is it a copy or is it a move
			if([DFM fileExistsAtPath:alreadyFileName])
			{
				// it is a copy
				key = [self newKeyForFileName:fileName];
			}
			else
			{
				// it is a move
				// was it an absolute or a relative file name?
#warning NYI:I can't know  easily if the file name was absolute or relative...
				[self setFileName:fileName forKey:key makeRelative:YES];
			}
		}
		else
		{
			[self setFileName:fileName forKey:key makeRelative:YES];
		}
	}
	else
	{
		key = @"";
	}
	
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newKeyForFileName:
- (NSString *)newKeyForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self newKeyForFileName:fileName save:NO];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newKeyForFileName:save:
- (NSString *)newKeyForFileName:(NSString *)fileName save:(BOOL)shouldSave;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(fileName != nil, @"Unexpected void file name, please report bug");
	fileName = [fileName stringByStandardizingPath];
	// is it an already registered file name?
    NSString * key = [self keyForFileName:fileName];
	if([key length])
	{
		[self recordHandleToFileName:fileName];// just in case...
		return key;
	}
	// it is not an already registered file name, as far as I could guess...
	key = [self recordedKeyForFileName:fileName];
//iTM2_LOG(@"BEFORE cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	if([key length])
	{
		[self recordHandleToFileName:fileName];// just in case...
		[[self keyedFileNames] takeValue:fileName forKey:key];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
		if(shouldSave)
		{
			[self saveDocument:nil];
		}
		NSAssert1([key isEqual:[self keyForFileName:fileName]],(@"AIE AIE INCONSITENT STATE %s"),__PRETTY_FUNCTION__);
		return key;
	}
	// it is not an already registered file name, as far as I could guess...
	// the given file seems to be a really new one
	NSString * dirName = [[self fileName] stringByStandardizingPath];
	if([dirName belongsToExternalProjectsDirectory] && ![fileName belongsToExternalProjectsDirectory])
	{
		dirName = [dirName stringByStrippingExternalProjectsDirectory];
		dirName = [dirName stringByDeletingLastPathComponent];
		fileName = [fileName stringByStandardizingPath];
	}
	dirName = [dirName stringByDeletingLastPathComponent];
	key = [self nextAvailableKey];// WARNING!!! there once was a problem I don't understand here
	NSString * relativeName = [fileName stringByAbbreviatingWithDotsRelativeToDirectory:dirName];
	[[self keyedFileNames] takeValue:relativeName forKey:key];
	[self setFileName:relativeName forKey:key makeRelative:NO];
	if(![key isEqual:[self keyForFileName:fileName]])
		[self keyForFileName:fileName];
	NSAssert2([key isEqual:[self keyForFileName:fileName]], @"***  ERROR:[self keyForFileName:...] is %@ instead of %@", [self keyForFileName:fileName], key);
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
		iTM2_LOG(@"the new key for %@ (fileName)", fileName);
		iTM2_LOG(@"is %@ (key)", key);
	}
	[self recordHandleToFileName:fileName];
	// Are the corresponding link and alias up to date?
//iTM2_LOG(@"key: %@, fileName: %@", key, fileName);
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
	if(shouldSave)
	{
		[self saveDocument:nil];
	}
    return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordHandleToFileName:
- (void)recordHandleToFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [self keyForFileName:fileName];
	if([key length])
	{
		if(![key isEqual:@"."])
		{
			NSString * subdirectory = [self fileName];
			if(![DFM isWritableFileAtPath:subdirectory])
			{
				return;
			}
			subdirectory = [subdirectory stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
			BOOL isDirectory = NO;
			NSString * path;
			if([DFM fileExistsAtPath:subdirectory isDirectory:&isDirectory] && isDirectory
				|| [DFM createDeepDirectoryAtPath:subdirectory attributes:nil error:nil])
			{
				path = [subdirectory stringByAppendingPathComponent:@"Readme.txt"];
				if(![DFM fileExistsAtPath:path])
				{
					[@"This directory contains finder alias to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [subdirectory stringByAppendingPathComponent:key];
//iTM2_LOG(@"fileName is: %@", fileName);
//iTM2_LOG(@"path is: %@", path);
				[DFM removeFileAtPath:path handler:NULL];
				if([DFM fileExistsAtPath:fileName])
				{
					NSError * localError = nil;
					NSData * aliasData = [fileName dataAliasRelativeTo:nil error:&localError];
					if(localError)
					{
						[SDC presentError:localError];
					}
					if(aliasData)
					{
						NSURL * url = [NSURL fileURLWithPath:path];
						if(![aliasData writeAsFinderAliasToURL:url options:0 error:&localError])
						{
							if(localError)
							{
								[SDC presentError:localError];
							}
							else if(iTM2DebugEnabled)
							{
								[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
									userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write an alias to %@ at %@", fileName, path]
										forKey:NSLocalizedDescriptionKey]]];
							}
							else
							{
								iTM2_LOG(@"*** ERROR: Could not write an alias to %@ at %@ (report bug)", fileName, path);
							}
						}
						else if(iTM2DebugEnabled)
						{
							aliasData = [NSData aliasDataWithContentsOfURL:url error:nil];
							NSString * target = [aliasData pathByResolvingDataAliasRelativeTo:nil error:nil];
							NSAssert2([target isEqualToFileName:[fileName stringByResolvingSymlinksAndFinderAliasesInPath]],@"Error unexpected difference\n%@\nvs\n%@ (report bug)", fileName, target);
						}
					}
				}
			}
			else if(iTM2DebugEnabled)
			{
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:2
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write alias information in\n%@", subdirectory]
						forKey:NSLocalizedDescriptionKey]]];
			}
			else
			{
				iTM2_LOG(@"Could not write alias information in\n%@", subdirectory);
			}
			subdirectory = [self fileName];
			subdirectory = [subdirectory stringByAppendingPathComponent:[SPC softLinksSubdirectory]];
			if([DFM fileExistsAtPath:subdirectory isDirectory:&isDirectory] && isDirectory
				|| [DFM createDeepDirectoryAtPath:subdirectory attributes:nil error:nil])
			{
				path = [subdirectory stringByAppendingPathComponent:@"Readme.txt"];
				if(![DFM fileExistsAtPath:path])
				{
					[@"This directory contains soft links to files the project is aware of.\niTeXMac2" writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
				}
				path = [subdirectory stringByAppendingPathComponent:key];
//iTM2_LOG(@"fileName is: %@", fileName);
//iTM2_LOG(@"path is: %@", path);
				[DFM removeFileAtPath:path handler:NULL];
				if(![DFM createSymbolicLinkAtPath:path pathContent:fileName])
				{
					if(iTM2DebugEnabled)
					{
						[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create a symbolic link to %@ at %@", fileName, path]
								forKey:NSLocalizedDescriptionKey]]];
					}
					else
					{
						iTM2_LOG(@"*** ERROR: Could not create a symbolic link %@ at %@ (report bug)", fileName, path);
					}
				}
			}
			else if(iTM2DebugEnabled)
			{
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:3
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not write soft links information in\n%@", subdirectory]
						forKey:NSLocalizedDescriptionKey]]];
			}
			else
			{
				iTM2_LOG(@"Could not write soft links information in\n%@", subdirectory);
			}
		}
	}
	else
	{
//iTM2_LOG(@"0 length key");
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nextAvailableKey
- (NSString *)nextAvailableKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * keyedFileNames = [self keyedFileNames];
	NSString * result = [[[keyedFileNames valueForKey:iTM2ProjectLastKeyKey] copy] autorelease];
	if(!result)
	{
		result = [NSString stringWithFormat:@"%i", [keyedFileNames count]];
	}
	NSString * afterKey = [NSString stringWithFormat:@"%i", [result intValue] + 1];
	[keyedFileNames setObject:afterKey forKey:iTM2ProjectLastKeyKey];
//iTM2_LOG(@"afterKey: %@", afterKey);
//iTM2_LOG(@"result: %@", result);
    return [[result copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeKey:
- (void)removeKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDocument * document = [self subdocumentForKey:key];
	if(document)
	{
		[document canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(__document:shouldRemove:key:) contextInfo:[key retain]];
	}
	else
	{
		[self _removeKey:key];
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
		[self _removeKey:key];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _removeKey:
- (void)_removeKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"[self allKeys] are:%@", [self allKeys]);
	}
    [[self keyedFileNames] takeValue:nil forKey:key];
    [[self keyedProperties] takeValue:nil forKey:key];
    [[self keyedSubdocuments] takeValue:nil forKey:key];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"[self allKeys] are:%@", [self allKeys]);
	}
    NSMutableDictionary * cachedKeys = [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
    [cachedKeys removeObjectsForKeys:[cachedKeys allKeysForObject:key]];
//iTM2_LOG(@"AFTER  cachedKeys: %@", [IMPLEMENTATION metaValueForKey:iTM2ProjectCachedKeysKey]);
    [SPC flushCaches];
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    id WC;
    while(WC = [E nextObject])
        if([WC respondsToSelector:@selector(updateOrderedFileKeys)])
            [WC updateOrderedFileKeys];
	// then I remove all the references, either links or finder aliases, used as cache
	NSString * projectName = [self fileName];
	NSString * subdirectory = [projectName stringByAppendingPathComponent:[SPC finderAliasesSubdirectory]];
	NSString * path = [subdirectory stringByAppendingPathComponent:key];
	if([DFM fileExistsAtPath:path isDirectory:nil] && ![DFM removeFileAtPath:path handler:NULL])
	{
		iTM2_LOG(@"*** ERROR: I could not remove %@, please do it for me...", path);
	}
	subdirectory = [projectName stringByAppendingPathComponent:[SPC softLinksSubdirectory]];
	path = [subdirectory stringByAppendingPathComponent:key];
	if([DFM fileExistsAtPath:path isDirectory:nil] && ![DFM removeFileAtPath:path handler:NULL])
	{
		iTM2_LOG(@"*** ERROR: I could not remove %@, please do it for me...", path);
	}
	[self saveDocument:nil];
//iTM2_END
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allKeys
- (NSArray *)allKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [[[[self keyedFileNames] allKeys] mutableCopy] autorelease];
    [MRA removeObject:iTM2ProjectLastKeyKey];
    return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyedFileNames
- (id)keyedFileNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [IMPLEMENTATION modelValueForKey:TWSKeyedFilesKey ofType:iTM2ProjectInfoType];
    if(!result)
    {
        [IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionary] forKey:TWSKeyedFilesKey ofType:iTM2ProjectInfoType];
        result = [IMPLEMENTATION modelValueForKey:TWSKeyedFilesKey ofType:iTM2ProjectInfoType];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addFileName:
- (void)addFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileName isEqualToString:[self fileName]])
	{
		iTM2_LOG(@"I ignore:%@, it is the project", fileName);            
	}
	else if([self keyForFileName:fileName])
	{
		iTM2_LOG(@"I ignore: %@, it is already there", fileName);
	}
	else if([self newKeyForFileName:fileName])
	{
		[self updateChangeCount:NSChangeDone];
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
	else
	{
		iTM2_LOG(@"I ignore: %@, I don't want it...", fileName);
	}
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  OPEN SUBDOCUMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSubdocumentWithContentsOfURL:context:display:outError:
- (id)openSubdocumentWithContentsOfURL:(NSURL *)fileURL context:(NSDictionary *)context display:(BOOL)display error:(NSError**)outError;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3:07/26/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outError)
		* outError = nil;
	if([fileURL isEqual:[self fileURL]])
	{
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[self makeWindowControllers];
				[self showWindows];
			}
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
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"There is nothing at\n%@", fileName]),nil);
		return nil;
	}
	fileName = [fileName stringByResolvingSymlinksInPath];// and finder aliases?
	if([fileName isEqual:[self wrapperName]])
	{
		return self;// we should not get there!
	}
	// is it an already open document?
	// beware of the external project support
    NSEnumerator * E = [[self subdocuments] objectEnumerator];
    id doc;
    while(doc = [E nextObject])
    {
		NSURL * url = [doc fileURL];
		if([url isFileURL])
		{
			NSString * docName = [url path];
			docName = [docName stringByResolvingSymlinksAndFinderAliasesInPath];
			if([docName isEqual:fileName])
			{
tahiti:
				if([SDC shouldCreateUI])
				{
					if(display)
					{
						[doc makeWindowControllers];
						[doc showWindows];
					}
				}
	//iTM2_END;
				return doc;
			}
		}
    }
	// Assign a key, if not already available
	if(!context)
	{
		context = [iTM2Document contextDictionaryFromFile:fileName];
	}
	NSString * key = [self newKeyForFileName:fileName fileContext:context];
//iTM2_LOG(@"[self keyForFileName:fileName]:<%@>, key:%@",[self keyForFileName:fileName],key);
	if([key length])
	{
		// Is it a document managed by iTeXMac2? Some document might need an external helper
		NSString * typeName = [SDC typeFromFileExtension:[fileName pathExtension]];
		if([typeName isEqual:iTM2WildcardDocumentType])
		{
			NSString * bundleIdentifier = [self propertyValueForKey:@"Bundle Identifier" fileKey:key];
			if(![SWS openURLs:[NSArray arrayWithObject:fileURL] withAppBundleIdentifier:bundleIdentifier options:0 additionalEventParamDescriptor:nil launchIdentifiers:nil]
				&& bundleIdentifier)
			{
				[SWS openURLs:[NSArray arrayWithObject:fileURL] withAppBundleIdentifier:nil options:0 additionalEventParamDescriptor:nil launchIdentifiers:nil];
			}
			return nil;
		}
		if(doc = [SDC makeDocumentWithContentsOfURL:fileURL ofType:typeName error:outError])
		{
//iTM2_LOG(@"[self keyForFileName:fileName]:<%@>",[self keyForFileName:fileName]);
			[self addSubdocument:doc];
	//iTM2_LOG(@"self:%@, has documents:%@", self, [self subdocuments]);
			goto tahiti;
		}
//iTM2_LOG(@"INFO:Could open document %@", fileName);
		if(outError)
		{
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"Cocoa could not create document at\n%@", fileURL]),*outError);
		}
		return nil;
	}
	// is it an already registered document that changed its name?
	NSString * typeName = [SDC typeFromFileExtension:[fileName pathExtension]];
    if(doc = [SDC makeDocumentWithContentsOfURL:fileURL ofType:typeName error:outError])
    {
        [self addSubdocument:doc];
//iTM2_LOG(@"self:%@, has documents:%@", self, [self subdocuments]);
        goto tahiti;
    }
    else
    {
        iTM2_LOG(@"Sorry, I could not create a document for:%@ (1)", fileName);
    }
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openSubdocumentForKey:display:outError:
- (id)openSubdocumentForKey:(NSString *)key display:(BOOL)display error:(NSError**)outError;
/*"Description forthhcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3:07/26/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outError)
		* outError = nil;
	// is it a document already open by the project
	id SD = [self subdocumentForKey:key];
	if(SD)
	{
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[SD makeWindowControllers];
				[SD showWindows];
			}
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
		if([P isEqual:self] && [key isEqual:[self keyForFileName:[D fileName]]])
		{
			if([SDC shouldCreateUI])
			{
				if(display)
				{
					[SD makeWindowControllers];
					[SD showWindows];
				}
			}
			return SD;
		}
	}
	// I must open a new document
	NSString * absoluteFileName = [[self absoluteFileNameForKey:key] stringByResolvingSymlinksAndFinderAliasesInPath];// finder alias support?
	NSString * externalFileName = [[self externalFileNameForKey:key] stringByResolvingSymlinksAndFinderAliasesInPath];// finder alias support?
	NSURL * fileURL = nil;
	BOOL onceMore = YES;
onceMore:
	if([DFM fileExistsAtPath:absoluteFileName])
	{
		if([externalFileName isEqual:absoluteFileName])
		{
			// both are the same, this is the expected situation.
absoluteFileNameIsChosen:
			fileURL = [NSURL fileURLWithPath:absoluteFileName];
			return [self openSubdocumentWithContentsOfURL:fileURL context:nil display:display error:outError];
		}
		else if([DFM fileExistsAtPath:externalFileName])
		{
			//Problem: there are 2 different candidates, which one is the best
			[SWS selectFile:absoluteFileName inFileViewerRootedAtPath:[absoluteFileName stringByDeletingLastPathComponent]];
			[SWS selectFile:externalFileName inFileViewerRootedAtPath:[externalFileName stringByDeletingLastPathComponent]];
			[NSApp activateIgnoringOtherApps:YES];
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"Which one do you want?", NSLocalizedDescriptionKey,
				[NSString stringWithFormat:@"1:%@\nor\n2:%@",absoluteFileName, externalFileName], NSLocalizedFailureReasonErrorKey,
				@"1 will be chosen unless you remove it.", NSLocalizedRecoverySuggestionErrorKey,
					nil];
			[self presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:3 userInfo:dict]];
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
	else if([DFM fileExistsAtPath:externalFileName])
	{
		// I also choose the absolute file name.
		fileURL = [NSURL fileURLWithPath:absoluteFileName];
		return [self openSubdocumentWithContentsOfURL:fileURL context:nil display:display error:outError];
	}
	else if([absoluteFileName length])
	{
		if([externalFileName isEqual:absoluteFileName])
		{
			// problem: no file available
			iTM2_OUTERROR(2,([NSString stringWithFormat:@"No file at\n%@",absoluteFileName]),(outError?*outError:nil));
		}
		else
		{
			// problem: no files available
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"No file at\n%@\nnor\n%@",absoluteFileName,externalFileName]),(outError?*outError:nil));
		}
	}
	// else the key does not correspond to a file, it has certainly been removed and we've been asked for a scorie.
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyForSubdocument:
- (NSString *)keyForSubdocument:(id)subdocument;
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
			return result;
		NSString * fileName = [subdocument fileName];
		result = [self keyForFileName:fileName];
		if(![result length])
		{
			result = [self newKeyForFileName:fileName];
		}
		NSAssert2([result length], @"There is a patent inconsistency:the project\n%@\ndoes not want the subdocument\n%@", [self fileURL], fileName);
		[[self keyedSubdocuments] takeValue:V forKey:result];
		return result;
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentForKey:
- (id)subdocumentForKey:(NSString *)key;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyedProperties
- (id)keyedProperties;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [IMPLEMENTATION modelValueForKey:TWSKeyedPropertiesKey ofType:iTM2ProjectInfoType];
    if(!result)
    {
        [IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionary] forKey:TWSKeyedPropertiesKey ofType:iTM2ProjectInfoType];
        result = [IMPLEMENTATION modelValueForKey:TWSKeyedPropertiesKey ofType:iTM2ProjectInfoType];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertiesForFileKey
- (id)propertiesForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id Ps = [self keyedProperties];
    id result = [Ps valueForKey:key];
    if(!result)
    {
        [Ps takeValue:[NSMutableDictionary dictionary] forKey:key];
        result = [Ps valueForKey:key];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertiesForFileName:
- (id)propertiesForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(fileName != nil, @"Unexpected void fileName:please report BUG...");
    return [self propertiesForFileKey:[self keyForFileName:fileName]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  originalPropertyValueForKey:fileKey:
- (id)originalPropertyValueForKey:(NSString *)key fileKey:(NSString *)fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self propertiesForFileKey:fileKey] valueForKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertyValueForKey:fileKey:
- (id)propertyValueForKey:(NSString *)key fileKey:(NSString *)fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self propertiesForFileKey:fileKey] valueForKey:key]?:[self contextValueForKey:key fileKey:fileKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePropertyValue:forKey:fileKey:
- (void)takePropertyValue:(id)property forKey:(NSString *)key fileKey:(NSString *)fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self propertyValueForKey:key fileKey:fileKey];
	if(![property isEqual:old] && (property != old))
	{
		[[self propertiesForFileKey:fileKey] takeValue:property forKey:key];
		[self takeContextValue:property forKey:key];
		[self updateChangeCount:NSChangeDone];
	}
    return;
}
#pragma mark =-=-=-=-=- I/O
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToFile:ofType:originalFile:saveOperation:
//- (BOOL)writeToFile:(NSString *)fullDocumentPath ofType:(NSString *)documentTypeName originalFile:(NSString *)fullOriginalDocumentPath saveOperation:(NSSaveOperationType)saveOperation;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSafelyToURL:ofType:forSaveOperation:error:
//- (BOOL)writeWithBackupToFile:(NSString *)fullProjectPath ofType:(NSString *)docType saveOperation:(NSSaveOperationType)saveOperation;
- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"Only file URLs are supported, no:\n%@",absoluteURL]),nil);
		return NO;
	}
//iTM2_LOG(@"absoluteURL: %@", absoluteURL);
//	NSString * oldFileName = [self fileName];
	NSString * fullProjectPath = [absoluteURL path];
//	BOOL result = [self writeToFile:fullProjectPath ofType:docType originalFile:[self fileName] saveOperation:saveOperation];No longer used
#warning DEBUG
	BOOL isDirectory = NO;
	if([DFM fileExistsAtPath:fullProjectPath isDirectory:&isDirectory] && !isDirectory)
	{
		iTM2_LOG(@"*** TEST: what the hell, I want to change the current directory to %@", fullProjectPath);
	}
	BOOL result = [super writeSafelyToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation error:outError];
	if(!result)
	{
		iTM2_LOG(@"WHAT CAN I DO, no save possible...%@", (outError?*outError:@"NOTHING"));
	}
	if(![DFM changeFileAttributes:[self fileAttributesToWriteToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteURL error:outError] atPath:fullProjectPath])
	{
		iTM2_LOG(@"*** ERROR: could not change the file attributes at path:%@", fullProjectPath);
	}
	NSString * oldDirectoryPath = [DFM currentDirectoryPath];
	if(![DFM changeCurrentDirectoryPath:fullProjectPath])
	{
		iTM2_LOG(@"*** ERROR: what the hell, I cannot change the current directory to %@", fullProjectPath);
		BOOL isDirectory = NO;
		NSLog(@"exists: %@", ([DFM fileExistsAtPath:fullProjectPath isDirectory:&isDirectory]?@"Y":@"N"));
		NSLog(@"is directory: %@", (isDirectory?@"Y":@"N"));
		NSLog(@"The current directory is %@", oldDirectoryPath);
		return NO;
	}
	#if 1
	else
	{
		NSLog(@"----------  fullProjectPath: %@", fullProjectPath);
		NSDirectoryEnumerator * e = [DFM enumeratorAtPath:fullProjectPath];
		NSString * path = nil;
		while(path = [e nextObject])
		{
			NSLog(@"path: %@", path);
		}
	}
	#endif
	if(saveOperation == NSSaveOperation)
	{
		// just save the subdocuments where they normally stand...
		NSEnumerator * E = [[self subdocuments] objectEnumerator];
		NSDocument * D;
		while(D = [E nextObject])
		{
			if([D isDocumentEdited])
			{
				if([D writeSafelyToURL:[D fileURL] ofType:[D fileType] forSaveOperation:saveOperation error:outError])
				{
					[D updateChangeCount:NSChangeCleared];
				}
				else
				{
					iTM2_LOG(@"*** FAILURE: document could not be saved at:\n%@", [D fileURL]);
					[D updateChangeCount:NSChangeCleared];
					result = NO;
				}
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
			NSString * key = [self keyForSubdocument:D];
			NSString * name = [self relativeFileNameForKey:key];
			if([name hasPrefix:@".."])
			{
				[self setFileName:[D fileName] forKey:key makeRelative:YES];
			}
			else
			{
				name = [self absoluteFileNameForKey:key];
				[D setFileURL:[NSURL fileURLWithPath:name]];
			}
			if([D isDocumentEdited])
			{
				if([D writeSafelyToURL:[D fileURL] ofType:[D fileType] forSaveOperation:saveOperation error:outError])
				{
					[D updateChangeCount:NSChangeCleared];
				}
				else
				{
					iTM2_LOG(@"*** FAILURE: document for key %@ could not be saved", key);
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
			NSString * K = [self keyForSubdocument:D];
			if([K length])
			{
				NSString * relativePath = [self relativeFileNameForKey:K];
				NSString * fullPath = [fullProjectPath stringByAppendingPathComponent:relativePath];
				[DFM createDeepDirectoryAtPath:[fullPath stringByDeletingLastPathComponent] attributes:nil error:nil];
				NSURL * url = [NSURL fileURLWithPath:fullPath];
				if(![D writeSafelyToURL:url ofType:[D fileType] forSaveOperation:saveOperation error:outError])
				{
					iTM2_LOG(@"*** FAILURE: document for key %@ could not be saved", K);
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
	if(![DFM changeCurrentDirectoryPath:oldDirectoryPath])
	{
		iTM2_LOG(@"*** ERROR: what the hell, I cannot retrieve the old current directory %@", oldDirectoryPath);
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectMetaCompleteReadFromURL:ofType:error:
- (BOOL)projectMetaCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError **)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [fileURL path];
    NSString * FN = [[[fileName stringByAppendingPathComponent:TWSFrontendComponent]
            stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]]
                stringByAppendingPathComponent:[iTM2ProjectMetaInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension]];
				
    if([IMPLEMENTATION loadModelValueOfDataRepresentation:[NSData dataWithContentsOfFile:FN] ofType:iTM2ProjectMetaType])
    {
        if(iTM2DebugEnabled>100)
        {
            iTM2_LOG(@"meta model read is %@", [IMPLEMENTATION modelOfType:iTM2ProjectMetaType]);
        }
    }
	else
    {
        if(iTM2DebugEnabled)
        {
            iTM2_LOG(@"Could not read front end meta data from %@", FN);
        }
        [IMPLEMENTATION takeModel:[NSMutableDictionary dictionary] ofType:iTM2ProjectMetaType];
    }
	NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa
		withSuffix:@"rojectMetaFixImplementation"
			signature:(NSMethodSignature *)[self methodSignatureForSelector:@selector(prepareProjectFixImplementation)]
				inherited:YES]
				objectEnumerator];
	SEL selector;
	while(selector = (SEL)[[E nextObject] pointerValue])
	{
//iTM2_LOG(@"----  Performing selector:%@", NSStringFromSelector(selector));
		[self performSelector:selector withObject:nil];
	}
//iTM2_LOG(@"frontend model:%@", [IMPLEMENTATION modelOfType:iTM2ProjectMetaType]);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectMetaCompleteWriteToURL:ofType:error:
- (BOOL)projectMetaCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [fileURL path];
    NSString * FN = [fileName stringByAppendingPathComponent:TWSFrontendComponent];
	FN = [FN stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
	if(![DFM createDeepDirectoryAtPath:FN attributes:nil error:outError])
		return NO;
    FN = [FN stringByAppendingPathComponent:iTM2ProjectMetaInfoComponent];
    FN = [FN stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
	NSData * D = [IMPLEMENTATION dataRepresentationOfModelOfType:iTM2ProjectMetaType];
	if(D && ![D writeToURL:[NSURL fileURLWithPath:FN] options:NSAtomicWrite error:outError])
	{
		iTM2_LOG(@"Could not write front end data to %@", FN);
	}
	else if(![D length])
	{
		iTM2_LOG(@"No front end meta data to write to %@", FN);
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareProjectMetaCompleteWriteToURL:ofType:error:
- (BOOL)prepareProjectMetaCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//	[self prepareFrontendCompleteWriteToURL:fileURL ofType:type error:outError];// create the frontend dedicated directory inside the project
	NSMutableArray * mra = [NSMutableArray array];
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	id D;
	while(D = [E nextObject])
	{
		NSString * OFN = [D originalFileName];
		NSString * K = [self keyForFileName:OFN];
		if(K)
			[mra addObject:K];
		else
		{
			iTM2_LOG(@"****  WARNING:The project document had no key:%@", OFN);
			if(K = [self newKeyForFileName:OFN])
				[mra addObject:K];
		}
	}
	[self takeContextValue:mra forKey:iTM2ContextOpenDocuments];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareFrontendCompleteWriteToURL:ofType:error:
- (BOOL)prepareFrontendCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
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
//iTM2_LOG(@"fileName is: %@", fileName);
	fileName = [fileName stringByResolvingSymlinksAndFinderAliasesInPath];
//iTM2_LOG(@"fileName is: %@", fileName);
	// I should have a directory there
	BOOL isDir = NO;
	if([DFM fileExistsAtPath:fileName isDirectory:&isDir])
	{
		if(isDir)
		{
			goto Zatsoquet;
		}
#if 1
#warning THIS IS DEBUG CODE
		[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nwas unexpected and will be recycled", fileName] forKey:NSLocalizedDescriptionKey]]];
		[SWS selectFile:fileName inFileViewerRootedAtPath:[fileName lastPathComponent]];
#endif
		// it is not a directory: recycle it.
		int tag;
		if([SWS performFileOperation:NSWorkspaceRecycleOperation source:[fileName stringByDeletingLastPathComponent] destination:@"" files:[NSArray arrayWithObject:[fileName lastPathComponent]] tag:&tag])
		{
			[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:tag
				userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nwas unexpected and was recycled", fileName] forKey:NSLocalizedDescriptionKey]]];
		}
		else
		{
			NSString * fileNamePutAside = [[fileName stringByDeletingPathExtension] stringByAppendingPathExtension:@"put_aside_by_iTeXMac2"];
			if([DFM fileExistsAtPath:fileNamePutAside] && ![DFM removeFileAtPath:fileNamePutAside handler:nil])
			{
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:tag
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nshould be recycled...", fileNamePutAside] forKey:NSLocalizedDescriptionKey]]];
			}
			if(![DFM copyPath:fileName toPath:fileNamePutAside handler:nil])
			{
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:tag
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"The file at\n%@\nhas been put aside...", fileNamePutAside] forKey:NSLocalizedDescriptionKey]]];
			}
			if(![DFM removeFileAtPath:fileName handler:nil])
			{
				if(outError)
				{
					*outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:tag
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove\n%@\nDon't be surprised if things don't work as expected...", fileNamePutAside] forKey:NSLocalizedDescriptionKey]];
				}
				else
				{
					iTM2_LOG(@"Could not remove\n%@\nDon't be surprised if things don't work as expected...", fileNamePutAside);
				}
				return NO;
			}
		}
	}
Zatsoquet:
    fileName = [fileName stringByAppendingPathComponent:TWSFrontendComponent];
    fileName = [fileName stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]];
    if([DFM fileExistsAtPath:fileName isDirectory:&isDir])
	{
		if(!isDir)
		{// there is already a file but it is not a directory, simply drop it and inform the user
			if([DFM removeFileAtPath:fileName handler:nil])
			{
				iTM2_LOG(@"*** INFO: The file %@ has been removed", fileName);
			}
			else
			{
				int tag = 0;
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:tag
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove\n%@", fileName] forKey:NSLocalizedDescriptionKey]]];
				return NO;
			}
		}
	}
	else
	{
		if(![DFM createDeepDirectoryAtPath:fileName attributes:nil error:outError])
		{
			iTM2_LOG(@"Could not create directory at %@", fileName);
			if([DFM fileExistsAtPath:[fileURL path] isDirectory:&isDir])
			{
				NSLog(@"parent exists: Y");
				NSLog(@"is directory: %@", (isDir?@"Y":@"N"));
			}
			return NO;
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteReadFromURL:ofType:error:
- (BOOL)projectCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [fileURL path];
    NSString * FN = [[[fileName stringByAppendingPathComponent:TWSFrontendComponent]
            stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]]
                stringByAppendingPathComponent:[iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension]];
	NSData * D = [NSData dataWithContentsOfFile:FN];
    if([IMPLEMENTATION loadModelValueOfDataRepresentation:D ofType:iTM2ProjectFrontendType])
    {
        if(iTM2DebugEnabled>100)
        {
            iTM2_LOG(@"model of %@ read is %@", self, [IMPLEMENTATION modelOfType:iTM2ProjectFrontendType]);
        }
    }
	else
    {
        if(iTM2DebugEnabled)
        {
            iTM2_LOG(@"Could not read front end data from %@", FN);
        }
        [IMPLEMENTATION takeModel:[NSMutableDictionary dictionary] ofType:iTM2ProjectFrontendType];
    }
	NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa
		withSuffix:@"rojectFixImplementation"
			signature:(NSMethodSignature *)[self methodSignatureForSelector:@selector(prepareProjectFixImplementation)]
				inherited:YES]
				objectEnumerator];
	SEL selector;
	while(selector = (SEL)[[E nextObject] pointerValue])
	{
//iTM2_LOG(@"----  Performing selector:%@", NSStringFromSelector(selector));
		[self performSelector:selector withObject:nil];
	}
//iTM2_LOG(@"frontend model:%@", [IMPLEMENTATION modelOfType:iTM2ProjectFrontendType]);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCompleteWriteToURL:ofType:error:
- (BOOL)projectCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [fileURL path];
	NSString * FN = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
	FN = [[[NSBundle mainBundle] bundleIdentifier] stringByAppendingPathComponent:FN];
	FN = [TWSFrontendComponent stringByAppendingPathComponent:FN];
    FN = [fileName stringByAppendingPathComponent:FN];
	NSURL * url = [NSURL fileURLWithPath:FN];
	NSData * D = [IMPLEMENTATION dataRepresentationOfModelOfType:iTM2ProjectFrontendType];
    return !D || [D writeToURL:url options:NSAtomicWrite error:outError];
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
    [[self subdocuments] makeObjectsPerformSelector:@selector(saveDocument:)withObject:self];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext:
- (void)saveContext:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// really disable undo registration!!!
	BOOL needsToUpdate = [self needsToUpdate];
	NSUndoManager * UM = [self undoManager];
	BOOL isUndoRegistrationEnabled = [UM isUndoRegistrationEnabled];
	[UM disableUndoRegistration];
	[[self subdocuments] makeObjectsPerformSelector:_cmd withObject:irrelevant];
	[super saveContext:irrelevant];
	if(isUndoRegistrationEnabled)
		[UM enableUndoRegistration];
	NSURL * fileURL = [self fileURL];
	NSString * filetype = [self fileType];
	NSError ** outError = nil;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:@selector(writeToURL:ofType:error:)];
    NSInvocation * I = [[NSInvocation invocationWithMethodSignature:sig0] retain];
    [I setTarget:self];
    [I setArgument:&fileURL atIndex:2];
    [I setArgument:&filetype atIndex:3];
    [I setArgument:&outError atIndex:4];
    NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"MetaCompleteWriteToURL:ofType:error:" signature:sig0 inherited:YES] objectEnumerator];
    SEL selector;
    while(selector = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:selector];
        [I invoke];
    }
	[I release];
	if(!needsToUpdate)
		[self recordFileModificationDateFromURL:fileURL];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:fileKey:
- (id)contextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result;
	if(result = [[[[self implementation] iVarContextKeyedFiles] valueForKey:fileKey] valueForKey:aKey])
		return result;
	NSString * extensionKey = [[self originalFileName] pathExtension];
	if([extensionKey length])
		if(result = [[[[self implementation] iVarContextExtensions] valueForKey:extensionKey] valueForKey:aKey])
			return result;
	NSString * type = [self fileType];
	if(result = [[[[self implementation] iVarContextTypes] valueForKey:type] valueForKey:aKey])
		return result;
    return [super contextValueForKey:aKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:fileKey:
- (void)takeContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(aKey != nil);
	[super takeContextValue:object forKey:aKey];
	NSString * fileName = [self relativeFileNameForKey:fileKey];// not the file name!
	if(!fileName)
		return;
	id D, server;
	if(server = [[self implementation] iVarContextKeyedFiles], D = [[[server objectForKey:fileKey] mutableCopy] autorelease])
	{
		[D takeValue:object forKey:aKey];
		[server takeValue:D forKey:fileKey];
	}
	NSString * extension = [fileName pathExtension];
	if(server = [[self implementation] iVarContextExtensions], D = [[[server objectForKey:extension] mutableCopy] autorelease])
	{
		[D takeValue:object forKey:aKey];
		[server takeValue:D forKey:extension];
	}
	NSString * type = [SDC typeFromFileExtension:extension];
	if(server = [[self implementation] iVarContextTypes], D = [[[server objectForKey:type] mutableCopy] autorelease])
	{
		[D takeValue:object forKey:aKey];
		[server takeValue:D forKey:type];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareDocumentContextProjectMetaFixImplementation
- (void)prepareDocumentContextProjectMetaFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// Ok, I assume that I have read the stored data and I am going to create the list of commands.
	// first we make some consistency test.
	id O;
	#define CREATE(key)\
	O = [IMPLEMENTATION modelValueForKey:key ofType:iTM2ProjectMetaType];\
	if([O isKindOfClass:[NSDictionary class]])\
		[IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionaryWithDictionary:O] forKey:key ofType:iTM2ProjectMetaType];\
	else\
		[IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionary] forKey:key ofType:iTM2ProjectMetaType];
	CREATE(iTM2ProjectContextKeyedFilesKey);
	CREATE(iTM2ContextTypesKey);
	CREATE(iTM2ContextExtensionsKey);
	#undef CREATE
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
		metaSETTER([NSNull null]);// reentrant management, BIG problem here
		NSString * wrapperName = [self wrapperName];
		if([wrapperName length])
		{
			NSString * typeName = [SDC typeFromFileExtension:[wrapperName pathExtension]];
			if(lazyWrapper = [SDC makeDocumentWithContentsOfFile:wrapperName ofType:typeName])
			{
				metaSETTER(lazyWrapper);// the wrapper is automatically dealloc'd when the owner is dealloc'd.
				[SDC removeDocument:lazyWrapper];//useless?
//iTM2_LOG(@"[SDC documents] are:%@", [SDC documents]);
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
	NSString * fileName = [self fileName];
	NSString * wpe = [SDC wrapperPathExtension];
	oneMoreTime:
	fileName = [fileName stringByDeletingLastPathComponent];
	if([[fileName pathExtension] isEqualToString:wpe])
		return fileName;
	else if([fileName length]>[wpe length])
		goto oneMoreTime;
	else
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
	if([SPC isBaseProject:self])
		return nil;
	if([[self fileName] belongsToExternalProjectsDirectory])
		return nil;
	iTM2WrapperDocument * W = [self wrapper];
    return W? [W newRecentDocument]:self;
}
@end

NSString * const iTM2PDTableViewPathIdentifier = @"path";

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
	// from Laurent Daudelin, mamasam START
	NSImageCell * imageCell = [[[NSImageCell alloc] initImageCell:nil] autorelease];
	[imageCell setImageScaling:NSScaleProportionally];
	[[[self documentsView] tableColumnWithIdentifier:@"icon"] setDataCell:imageCell];
	// from Laurent Daudelin, mamasam STOP
    [super windowDidLoad];// validates the contents
//iTM2_LOG(@"the window class is:%@", NSStringFromClass([[self window] class]));
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
    NSEnumerator * E = [[projectDocument allKeys] objectEnumerator];
    NSString * K;
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    while(K = [E nextObject])
        [MD takeValue:K forKey:[projectDocument relativeFileNameForKey:K]];
    E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
    NSMutableArray * MRA = [NSMutableArray array];
    [MRA addObject:iTM2ProjectDefaultKey];
    while(K = [E nextObject])
		if([K length])
			[MRA addObject:[MD valueForKey:K]];
	[self setOrderedFileKeys:MRA];
    [[self documentsView] reloadData];
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
        NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)", iTM2ProjectTable, myBUNDLE, "blah (project name)"),
        [isa prettyInspectorMode],
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName:(NSString *)displayName;
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
        [NSException raise:NSInvalidArgumentException format:@"%@ NSTableView class expected, got:%@.",
            __PRETTY_FUNCTION__, argument];
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
        return [[tableColumn identifier] isEqual:@"icon"]? nil:NSLocalizedStringFromTableInBundle(@"Default", iTM2ProjectTable, myBUNDLE, "");  
    }
    else if(row>0 && row<top)
    {
        iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
		NSString * key = [fileKeys objectAtIndex:row];
		if([[tableColumn identifier] isEqual:iTM2PDTableViewPathIdentifier])
		{
			return [projectDocument relativeFileNameForKey:key];
		}
        NSString * absoluteName = [projectDocument absoluteFileNameForKey:key];
		return [SWS iconForFile:absoluteName];
    }
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// object is expected to be a relative path
    if(![[tableColumn identifier] isEqual:iTM2PDTableViewPathIdentifier])
		return;
    NSArray * fileKeys = [self orderedFileKeys];
    int top = [fileKeys count];
    if(row>0 && row<top)
    {
        iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
		NSString * otherKey = [projectDocument keyForFileName:object];
		if([otherKey length])
		{
			iTM2_LOG(@"INFO:the new relative path is already in use, nothing changed.");
			return;
		}
		NSString * key = [fileKeys objectAtIndex:row];
        NSString * oldObject = [projectDocument relativeFileNameForKey:key];
		if(![oldObject isEqual:object])
		{
			NSString * absolute = [projectDocument absoluteFileNameForKey:key];
			// if the file was already existing, just move it around without removing existing files
			if([DFM fileExistsAtPath:absolute])
			{
				[projectDocument setFileName:object forKey:key makeRelative:NO];
				NSString * newAbsolute = [projectDocument absoluteFileNameForKey:key];
				if([DFM createDeepDirectoryAtPath:[newAbsolute stringByDeletingLastPathComponent] attributes:nil error:nil])
				{
					if(![DFM copyPath:absolute toPath:newAbsolute handler:nil])
					{
						[projectDocument setFileName:oldObject forKey:key makeRelative:NO];// revert
						iTM2_LOG(@"*** ERROR:Could not move %@ to %@\ndue to problem %i, please do it by hand", absolute, newAbsolute);
					}
					// the concerned documents should now that a file name has changed
				}
				else
				{
					[projectDocument setFileName:oldObject forKey:key makeRelative:NO];// revert
					iTM2_LOG(@"*** ERROR:Could not create %@, please do it by hand", [newAbsolute stringByDeletingLastPathComponent]);
				}
			}
			else
			{
				[projectDocument setFileName:object forKey:key makeRelative:NO];
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
    [self validateWindowContent];
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
	if([[aTableColumn identifier] isEqual:iTM2PDTableViewPathIdentifier])
	{
		if(rowIndex)
		{
			NSArray * fileKeys = [self orderedFileKeys];
			iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
			BOOL YORN = [DFM fileExistsAtPath:[projectDocument absoluteFileNameForKey:[fileKeys objectAtIndex:rowIndex]]];
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
	return [iTM2EventObserver isAlternateKeyDown] && [[tableColumn identifier] isEqual:iTM2PDTableViewPathIdentifier] && (row>0);
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
	[OP setPrompt:NSLocalizedStringFromTableInBundle(@"Add", iTM2ProjectTable, myBUNDLE, "")];
//iTM2_LOG(@"::::OLD DIRECTORY:%@", oldDirectory);
//iTM2_LOG(@"::::DIRECTORY:%@", [[[self document] fileName] stringByDeletingLastPathComponent]);
    [OP beginSheetForDirectory:[[[self document] fileName] stringByDeletingLastPathComponent]
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
	iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
	NSString * name = [projectDocument fileName];
	if([name isEqual:filename])
	{
		return NO;
	}
	name = [name enclosingWrapperFileName];
	if([name isEqual:filename])
	{
		return NO;
	}
	name = [projectDocument keyForFileName:filename];
//iTM2_END;
    return [name length]==0;
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
		NSMutableArray * FNs = [[[sheet filenames] mutableCopy] autorelease];
        NSEnumerator * E = [FNs objectEnumerator];
        NSString * fileName = nil;
		iTM2ProjectDocument * projectDocument = [self document];
		NSString * dirName = [[projectDocument fileName] stringByStandardizingPath];
		if([dirName belongsToExternalProjectsDirectory])
		{
			dirName = [dirName stringByStrippingExternalProjectsDirectory];
			dirName = [dirName stringByDeletingLastPathComponent];
		}
		dirName = [dirName stringByDeletingLastPathComponent];
		NSArray * components = [dirName pathComponents];
		NSRange R = NSMakeRange(0, [components count]);
		NSMutableArray * copiables = [NSMutableArray array];
        while(fileName = [E nextObject])
		{
			NSArray * fileNameComponents = [fileName pathComponents];
			if([fileNameComponents count] > R.length)
			{
				if([components isEqual:[fileNameComponents subarrayWithRange:R]])
				{
					[projectDocument addFileName:fileName];
				}
				else
				{
					[copiables addObject:fileName];
					[FNs removeObject:fileName];
				}
			}
			else if(![fileName isEqual:dirName])
			{
				[copiables addObject:fileName];
				[FNs removeObject:fileName];
			}
		}
		if([copiables count])
		{
			int code = NSRunAlertPanel(
			NSLocalizedStringFromTableInBundle(@"Project Documents Panel", iTM2ProjectTable, myBUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Copy the external documents in the project?", iTM2ProjectTable, myBUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Yes", iTM2ProjectTable, myBUNDLE, ""),
			nil,
			NSLocalizedStringFromTableInBundle(@"No", iTM2ProjectTable, myBUNDLE, "")
				);
			if(code == NSAlertDefaultReturn)
			{
				BOOL problem = NO;
				NSEnumerator * E = [copiables objectEnumerator];
				NSString * fullPath;
				iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
				NSString * projectDirName = [[projectDocument fileName] stringByStandardizingPath];
				NSString * EPD = [NSString externalProjectsDirectory];
				if([projectDirName belongsToExternalProjectsDirectory])
				{
					projectDirName = [projectDirName substringWithRange:NSMakeRange([EPD length], [projectDirName length] - [EPD length])];
					projectDirName = [projectDirName stringByDeletingLastPathComponent];
				}
				projectDirName = [projectDirName stringByDeletingLastPathComponent];
				while(fullPath = [E nextObject])
				{
					NSString * lastComponent = [fullPath lastPathComponent];
					NSString * target = [projectDirName stringByAppendingPathComponent:lastComponent];
					if([DFM fileExistsAtPath:target isDirectory:nil])
					{
						problem = YES;
					}
					else
					{
						NSString * dirName = [fullPath stringByDeletingLastPathComponent];
						int tag;
						if([SWS performFileOperation:NSWorkspaceCopyOperation source:dirName
										destination:projectDirName files:[NSArray arrayWithObject:lastComponent] tag:&tag])
						{
							[projectDocument addFileName:target];
							NSURL * url = [NSURL fileURLWithPath:target];
							[projectDocument openSubdocumentWithContentsOfURL:url context:nil display:YES error:nil];
						}
						else
						{
							iTM2_LOG(@"Could not copy synchronously file at %@ (tag is %i)", fullPath, tag);
						}
					}
				}
				if(problem)
				{
					NSRunAlertPanel(
						NSLocalizedStringFromTableInBundle(@"Project Documents Panel", iTM2ProjectTable, myBUNDLE, ""),
						NSLocalizedStringFromTableInBundle(@"Name conflict, copy not complete.", iTM2ProjectTable, myBUNDLE, ""),
						NSLocalizedStringFromTableInBundle(@"Acknowledge", iTM2ProjectTable, myBUNDLE, ""),
						nil,
						nil);
				}
			}
		}
		E = [FNs objectEnumerator];
        while(fileName = [E nextObject])
		{
			NSURL * url = [NSURL fileURLWithPath:fileName];
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
		NSEnumerator * E = [copiables objectEnumerator];
		NSString * fullPath;
		iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
		NSString * projectDirName = [[projectDocument fileName] stringByStandardizingPath];
		NSString * EPD = [NSString externalProjectsDirectory];
		if([projectDirName belongsToExternalProjectsDirectory])
		{
			projectDirName = [projectDirName substringWithRange:NSMakeRange([EPD length], [projectDirName length] - [EPD length])];
			projectDirName = [projectDirName stringByDeletingLastPathComponent];
		}
		projectDirName = [projectDirName stringByDeletingLastPathComponent];
		while(fullPath = [E nextObject])
		{
			NSString * lastComponent = [fullPath lastPathComponent];
			NSString * target = [projectDirName stringByAppendingPathComponent:lastComponent];
			if([DFM fileExistsAtPath:target isDirectory:nil])
			{
				problem = YES;
			}
			else
			{
				NSString * dirName = [fullPath stringByDeletingLastPathComponent];
				int tag;
				if([SWS performFileOperation:NSWorkspaceCopyOperation source:dirName
								destination:projectDirName files:[NSArray arrayWithObject:lastComponent] tag:&tag])
				{
					[projectDocument addFileName:target];
					NSURL * url = [NSURL fileURLWithPath:target];
					[projectDocument openSubdocumentWithContentsOfURL:url context:nil display:YES error:nil];
				}
				else
				{
					iTM2_LOG(@"Could not copy synchronously file at %@ (tag is %i)", fullPath, tag);
				}
			}
		}
		if(problem)
		{
			NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Project documents panel", iTM2ProjectTable, myBUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Acknowledge", iTM2ProjectTable, myBUNDLE, ""),
			nil,
			nil,
			[self window],// bof
			nil,
			NULL,
			NULL,
			nil,
			NSLocalizedStringFromTableInBundle(@"Name conflict, copy not complete.", iTM2ProjectTable, myBUNDLE, ""));
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
    NSRange R = NSMakeRange(0, [fileKeys count]);
    iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
    NSString * projectName = [projectDocument fileName];
    NSString * dirName = [projectName stringByStandardizingPath];
	NSString * EPD = [NSString externalProjectsDirectory];
	if([dirName belongsToExternalProjectsDirectory])
	{
		dirName = [dirName substringWithRange:NSMakeRange([EPD length], [dirName length] - [EPD length])];
		dirName = [dirName stringByDeletingLastPathComponent];
	}
	dirName = [dirName stringByDeletingLastPathComponent];
	NSMutableArray * recyclable = [NSMutableArray array];
    NSEnumerator * E = [[self documentsView] selectedRowEnumerator];
    NSNumber * N;
    while(N = [E nextObject])
    {
        int index = [N intValue];
        if(NSLocationInRange(index, R))
        {
            [projectDocument updateChangeCount:NSChangeDone];
			NSString * fileKey = [fileKeys objectAtIndex:index];
			NSString * fullPath = [projectDocument absoluteFileNameForKey:fileKey];
			if(![fullPath isEqual:[projectDocument fileName]]// don't recycle the project
				&& ![fullPath isEqual:dirName]// nor its containing directory!!!
					&& [DFM fileExistsAtPath:fullPath isDirectory:nil])
			{
				// if the file belongs to another project it should not be recycled
				[recyclable addObject:fileKey];
			}
			else
			{
				[projectDocument removeKey:fileKey];
			}
        }
    }
	[self updateOrderedFileKeys];
	if([recyclable count])
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Suppressing project documents references", iTM2ProjectTable, myBUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Keep", iTM2ProjectTable, myBUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Cancel", iTM2ProjectTable, myBUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Recycle", iTM2ProjectTable, myBUNDLE, ""),
			[sender window],
			self,
			NULL,
			@selector(removeSubdocumentSheetDidDismiss:returnCode:recyclable:),
			[recyclable retain],// will be released below
			NSLocalizedStringFromTableInBundle(@"Also recycle the selected project documents?", iTM2ProjectTable, myBUNDLE, ""));
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
	if(returnCode == NSAlertAlternateReturn)// cancel!!
		return;
	BOOL recycle = (returnCode == NSAlertOtherReturn);
    iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
    NSEnumerator * E = [recyclable objectEnumerator];
	NSString * fileKey;
	NSDictionary * contextInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:recycle] forKey:@"recycle"];
    while(fileKey = [E nextObject])
    {
		NSString * fullPath = [projectDocument absoluteFileNameForKey:fileKey];
		NSDocument * subdocument = [SDC documentForFileName:fullPath];
		if(subdocument)
		{
			[subdocument canCloseDocumentWithDelegate:self
				shouldCloseSelector:@selector(subdocument:shouldRemoveFromProject:contextInfo:)
					contextInfo:[contextInfo retain]];// contextInfo will be released below
		}
		else
		{
			NSString * lastComponent = [fullPath lastPathComponent];
			NSString * dirName = [fullPath stringByDeletingLastPathComponent];
			int tag;
			if(recycle)
			{
				if([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName
								destination:@"" files:[NSArray arrayWithObject:lastComponent] tag:&tag])
				{
					iTM2_LOG(@"Recycling synchronously file at %@ in directory %@...", lastComponent, dirName);
				}
				else
				{
					iTM2_LOG(@"Could not recycle synchronously file at %@ (tag is %i)", fullPath, tag);
				}
				[projectDocument removeKey:fileKey];
			}
			else
			{
				NSString * destination = [fullPath enclosingWrapperFileName];
				if([destination length])
				{
					destination = [destination stringByDeletingLastPathComponent];
					if([SWS performFileOperation:NSWorkspaceMoveOperation source:dirName
									destination:destination files:[NSArray arrayWithObject:lastComponent] tag:&tag])
					{
						iTM2_LOG(@"Moving file at %@ in directory %@...", lastComponent, dirName);
					}
					else
					{
						iTM2_LOG(@"Could not move synchronously file at %@ (tag is %i)", fullPath, tag);
					}
				}
				[projectDocument removeKey:fileKey];
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
	NSString * fullPath = [subdocument fileName];
	iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
	NSString * fileKey = [projectDocument keyForFileName:fullPath];
	if(![fileKey length])
		return;
	BOOL recycle = [[contextInfo objectForKey:@"recycle"] boolValue];
	NSString * lastComponent = [fullPath lastPathComponent];
	NSString * dirName = [fullPath stringByDeletingLastPathComponent];
	int tag;
	if(recycle)
	{
		if([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName
						destination:@"" files:[NSArray arrayWithObject:lastComponent] tag:&tag])
		{
			iTM2_LOG(@"Recycling %@ from directory %@", lastComponent, dirName);
		}
		else
		{
			iTM2_LOG(@"Could not recycle synchronously file at %@ (tag is %i)", fullPath, tag);
		}
    }
	else
	{
		NSString * destination = [fullPath enclosingWrapperFileName];
		if([destination length])
		{
			destination = [destination stringByDeletingLastPathComponent];
			if([SWS performFileOperation:NSWorkspaceMoveOperation source:dirName
							destination:destination files:[NSArray arrayWithObject:lastComponent] tag:&tag])
			{
				iTM2_LOG(@"Moving file at %@ in directory %@...", lastComponent, dirName);
			}
			else
			{
				iTM2_LOG(@"Could not move synchronously file at %@ (tag is %i)", fullPath, tag);
			}
		}
		[projectDocument removeKey:fileKey];
	}
	[projectDocument removeKey:fileKey];
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
	[sender setStringValue:([[self document] fileName]?:([[self document] displayName]?:@""))];
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
        return;
    else if(row)
    {
        oldRelative = [[[self documentsView] dataSource]
                        tableView:[self documentsView]
                    objectValueForTableColumn:[[[self documentsView] tableColumns] lastObject]
                row:row];
        if([oldRelative length])
		{
			NSString * newRelative = [sender stringValue];
			if([newRelative isEqual:oldRelative])
				return;
			iTM2ProjectDocument * projectDocument = [self document];
			NSString * dirName = [[projectDocument fileName] stringByDeletingLastPathComponent];
			NSString * new = [dirName stringByAppendingPathComponent:newRelative];
			NSString * key = [projectDocument keyForFileName:new];
#warning REPORT AN ERROR
			if([key length])
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"The name %@ is already used.", iTM2ProjectTable, myBUNDLE, ""),
					new]),nil);
				return;
			}
			NSString * old = [dirName stringByAppendingPathComponent:oldRelative];
			key = [projectDocument keyForFileName:oldRelative];
			if(![key length])
				return;
			NSError * localError = nil;
			if([DFM createDeepDirectoryAtPath:[new stringByDeletingLastPathComponent] attributes:nil error:&localError])
			{
				if([DFM fileExistsAtPath:old])
				{
					if([DFM fileExistsAtPath:new])
					{
						[projectDocument setFileName:new forKey:key makeRelative:YES];
						[[projectDocument subdocumentForFileName:old] setFileName:new];
						if(iTM2DebugEnabled)
						{
							iTM2_LOG(@"Name successfully changed from %@ to %@", old, new);
						}
					}
					else if([DFM movePath:old toPath:new handler:nil])
					{
						[projectDocument setFileName:new forKey:key makeRelative:YES];
						[[projectDocument subdocumentForFileName:old] setFileName:new];
						if(iTM2DebugEnabled)
						{
							iTM2_LOG(@"Name successfully changed from %@ to %@", old, new);
						}
					}
					else
					{
						iTM2_REPORTERROR(1,(NSLocalizedStringFromTableInBundle(@"A file could not be moved.", iTM2ProjectTable, myBUNDLE, "")),nil);
						return;
					}
				}
				else
				{
					[projectDocument setFileName:new forKey:key makeRelative:YES];
					[[projectDocument subdocumentForFileName:old] setFileName:new];
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Name successfully changed from %@ to %@", old, new);
					}
				}
			}
			else
			{
				iTM2_REPORTERROR(1,(NSLocalizedStringFromTableInBundle(@"A directory could not be created.", iTM2ProjectTable, myBUNDLE, "")),localError);
				return;
			}
			[sender validateWindowContent];
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
    int row = [[self documentsView] selectedRow];
    NSString * p;
    if(row < 0 || row >= [[self documentsView] numberOfRows])
        p = NSLocalizedStringFromTableInBundle(@"No selection", iTM2ProjectTable, myBUNDLE, "Description Forthcoming");
    else if(row)
    {
        p = [[[self documentsView] dataSource]
                        tableView:[self documentsView]
                    objectValueForTableColumn:[[[self documentsView] tableColumns] lastObject]
                row:row];
        if([p length])
			editable = YES;
        else
            p = NSLocalizedStringFromTableInBundle(@"Multiple selection", iTM2ProjectTable, myBUNDLE, "Description Forthcoming");
    }
    else
        p = NSLocalizedStringFromTableInBundle(@"Default", iTM2ProjectTable, myBUNDLE, "Description Forthcoming");
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
	NSString * WN = [projectDocument wrapperName];
    [sender setStringValue:([WN length]? WN:[[projectDocument fileName] stringByDeletingLastPathComponent])];
//iTM2_START;
    return YES;
}
#if 0

// optional - drag and drop support
- (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray*)rows toPasteboard:(NSPasteboard*)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the table view once this call returns with YES.  The rows array is the list of row numbers that will be participating in the drag.

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
    // This method is used by NSTableView to determine a valid drop target.  Based on the mouse position, the table view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropRow:dropOperation:and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)op;
#endif
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
#warning MISSING BETTER DESIGN, automagically create a new project?
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
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [metaGETTER boolValue];
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
	NSString * FN = [self fileName];
	id P = [SPC projectForFileName:FN];
	NSString * PFN = [P fileName];
	if([PFN length])
	{
		[self takeContextValue:[[PFN copy] autorelease] forKey:iTM2ProjectAbsolutePathKey];
		[self takeContextValue:[PFN stringByAbbreviatingWithDotsRelativeToDirectory:[FN stringByDeletingLastPathComponent]] forKey:iTM2ProjectRelativePathKey];
		[self takeContextValue:[P keyForFileName:FN] forKey:iTM2ProjectFileKeyKey];
//		[self takeContextValue:forKey:iTM2ProjectAliasPathKey];
	}
	else
	{
		[self takeContextValue:@"/" forKey:iTM2ProjectAbsolutePathKey];
		[self takeContextValue:@"/" forKey:iTM2ProjectRelativePathKey];
		[self takeContextValue:@"/" forKey:iTM2ProjectFileKeyKey];
	}
//iTM2_END;
    return;
}
@end

@interface NSDocument_iTM2Project:NSDocument
@end
@implementation NSDocument_iTM2Project
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSDocument_iTM2Project poseAsClass:[NSDocument class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateContextManager
- (void)updateContextManager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super updateContextManager];
	if([self hasProject])
	{
		[self setContextDictionary:nil];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subdocumentFixImplementation
- (void)subdocumentFixImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setHasProject:NO];
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
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(windowTitleForDocumentDisplayName:)
		replacement:@selector(iTM2_Swizzled_windowTitleForDocumentDisplayName:)
			forClass:[NSWindowController class]]
	|| ![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(windowsMenuItemTitleForDocumentDisplayName:)
		replacement:@selector(iTM2_Swizzled_windowsMenuItemTitleForDocumentDisplayName:)
			forClass:[NSWindowController class]])
	{
		iTM2_LOG(@"It is unlikely that things will work as expected...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_Swizzled_windowTitleForDocumentDisplayName:
- (NSString *)iTM2_Swizzled_windowTitleForDocumentDisplayName:(NSString *)displayName;
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
		NSString * projectDisplayName = [P fileName];
		projectDisplayName = [projectDisplayName enclosingWrapperFileName];
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
			NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)", iTM2ProjectTable, myBUNDLE, "blah (project name)"),
			displayName, [P displayName]];
	}
	return [self iTM2_Swizzled_windowTitleForDocumentDisplayName:displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_Swizzled_windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)iTM2_Swizzled_windowsMenuItemTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description Forthcoming..
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_START;
    return [self iTM2_Swizzled_windowTitleForDocumentDisplayName:displayName];
}
@end

static NSString * const iTM2ProjectsKey = @"_PCPs";
#define PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsKey]
static NSString * const iTM2ProjectsReentrantKey = @"_PCPRE";
#define REENTRANT_PROJECT [[self implementation] metaValueForKey:iTM2ProjectsReentrantKey]
static NSString * const iTM2ProjectsForFileNamesKey = @"_PCPFFNs";
#define CACHED_PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsForFileNamesKey]
static NSString * const iTM2ProjectsBaseKey = @"_PCPBs";
#define BASE_PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsBaseKey]
static NSString * const iTM2ProjectsBaseForNamesKey = @"_PCPBFNs";
#define CACHED_BASE_PROJECTS [[self implementation] metaValueForKey:iTM2ProjectsBaseForNamesKey]

NSString * const iTM2ProjectContextDidChangeNotification = @"iTM2ProjectContextDidChange";
NSString * const iTM2ProjectCurrentDidChangeNotification = @"iTM2CurrentProjectDidChange";

@interface iTM2ProjectController(CreateNewProject)
/*! 
    @method     getProjectForExternalFileName:
    @abstract   Get the project for the given external file name
    @discussion An external file name lays in the <code>[NSString externalProjectsDirectory]</code>.
				It is either a soft link to an existing file or a finder alias to an existing file, a project wrapper or a directory wrapper.
				This is intensionnally a closed design.
    @param      None
    @result     a Project document
*/
- (id)getProjectForExternalFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
- (id)getContextProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
- (id)getExternalProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
- (id)getOpenProjectForFileName:(NSString *)fileName;
- (id)getBaseProjectForFileName:(NSString *)fileName;
- (NSString *)getProjectNameInWrapperForFileNameRef:(NSString **)fileNameRef error:(NSError **)outError;
- (id)getProjectInWrapperForFileNameRef:(NSString **)fileNameRef display:(BOOL)display error:(NSError **)outError;
- (id)getProjectInHierarchyForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
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
- (NSString *) projectName;
- (void) setFileName: (NSString *) fileName;
- (NSString *) projectDirName;

@end

@implementation iTM2ProjectController
static id _iTM2SharedProjectController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedProjectController
+ (id)sharedProjectController;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_iTM2SharedProjectController != argument)
	{
		[DNC removeObserver:_iTM2SharedProjectController];
		[_iTM2SharedProjectController autorelease];
		_iTM2SharedProjectController = [argument retain];
		if(argument)
		{
			[DNC addObserver:argument selector:@selector(windowDidBecomeKeyOrMainNotified:)name:NSWindowDidBecomeKeyNotification object:nil];
			[DNC addObserver:argument selector:@selector(windowDidBecomeKeyOrMainNotified:)name:NSWindowDidBecomeMainNotification object:nil];
		}
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  flushCaches
- (void)flushCaches;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsForFileNamesKey];
	// we keep track of the information about the documents recently declared with no projects
	// they are expected to belong to the 
	NSEnumerator * E = [[SDC documents] objectEnumerator];
	NSDocument * document;
	while(document = [E nextObject])
	{
		id projectDocument = [SPC projectForFileName:[document fileName]];
		if(projectDocument && (projectDocument != document))
		{
			iTM2_LOG(@"***  WARNING: weird situation, the document named %@ should not belong to the SDC but to one of the projects...", [document fileName]);
		}
		NSValue * V = [NSValue valueWithNonretainedObject:projectDocument];
		id key = [document fileName];
		if(key)
		{
			[CACHED_PROJECTS setObject:V forKey:key];
			key = [key stringByDeletingPathExtension];
			[CACHED_PROJECTS setObject:V forKey:key];
		}
		key = [NSValue valueWithNonretainedObject:document];
		[CACHED_PROJECTS setObject:V forKey:key];
	}
    [IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsBaseForNamesKey];
//iTM2_END;
return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjectsForPath:
- (id)availableProjectsForPath:(NSString *)dirName;
/*"Dictionary: displayName<-full path
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first I get the projects file names including the external ones in the hierarchy above dirName
	// I scan the directories for projects, starting from the normal side then looking for external projects
	// it is the responsibility of the user interface controllers to make the difference between writable and not writable
	// Supplemental rule: if the dirName is included in a wrapper, the projects are constrained to that wrapper and
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
	// find all the projects, either internal or external
	// stop as soon as projects are found
	NSString * externalProjectsPrefix = [NSString externalProjectsDirectory];
	NSAssert1(![path hasPrefix:externalProjectsPrefix],@"The path must not be external:\n%@",path);
	NSString * externalPath = nil;
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
				if([type isEqual:projectType])
				{
					NSString * P = [path stringByAppendingPathComponent:content];
					[paths addObject:P];
				}
			}
			externalPath = [externalProjectsPrefix stringByAppendingPathComponent:path];
			E = [[DFM directoryContentsAtPath:externalPath] objectEnumerator];
			while(content = [E nextObject])
			{
				extension = [content pathExtension];
				type = [SDC typeFromFileExtension:extension];
				if([type isEqual:wrapperType])
				{
					NSString * P = [externalPath stringByAppendingPathComponent:content];
					[paths addObject:P];
				}
			}
		}
		while(([paths count]==0) && (path = [path stringByDeletingLastPathComponent], ([path length]>1)));
		// now adding the external projects if relevant
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
				displayName = [NSString stringWithFormat:@"%@ (%@)",displayName, dirName];
				[first setObject:displayName forKey:path];
			}
		}
		return first;
	}
//iTM2_END;
	return [NSDictionary dictionary];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectsAtPath:
- (id)projectsAtPath:(NSString *)dirName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([dirName length]<2)
	{
		return [NSArray array];
	}
	NSString * projectType = [SDC projectDocumentType];
	if([SDC documentClassForType:projectType])
	{
		// we accept all the projects that live within the dirName.
		// we also accept wrappers at the same level, in that case, the filename will change and the file will be copied
		// we do not display the full path but only the relevant part,
		// something like in the recent documents menu
		NSEnumerator * E = [[DFM directoryContentsAtPath:dirName] objectEnumerator];
		id content;
		NSMutableArray * result = [NSMutableArray array];
		while(content = [E nextObject])
		{
			NSString * extension = [content pathExtension];
			NSString * type = [SDC typeFromFileExtension:extension];
			if([type isEqual:projectType] || [type isEqual:wrapperType])
			{
				NSString * path = [dirName stringByAppendingPathComponent:content];
				[result addObject:path];
			}
		}
		NSString * path;
		E = [[contents allKeys] objectEnumerator];
		while(path = [E nextObject])
		{
			NSArray * keys;
			encorePlus:
			content = [contents objectForKey:path];
			keys = [contents allKeysForObject:content];
			if([keys count] > 1)
			{
				// we cannot use content in the UI because different paths may correspond to the same content
				NSEnumerator * e = [[contents allKeysForObject:content] objectEnumerator];
				BOOL encoreUnTour = YES;
				NSString * path;
				while(path = [e nextObject])
				{
					NSMutableArray * start = [dirNames objectForKey:path];
					if([start count])
					{
						[content insertObject:[start lastObject] atIndex:0];
						[start removeLastObject];
						if(![start count])
							encoreUnTour = NO;
					}
				}
				if(encoreUnTour)
					goto encorePlus;
			}
		}
		E = [[contents allKeys] objectEnumerator];
		while(path = [E nextObject])
		{
			content = [contents objectForKey:path];
			if([content count]>1)
			{
				NSMutableArray * mra = [[content mutableCopy] autorelease];
				[mra removeLastObject];
				[contents setObject:[NSString stringWithFormat:@"%@ (%@)", [content lastObject], [@"..." stringByAppendingPathComponent:[NSString pathWithComponents:mra]]]  forKey:path];
			}
			else if([content count])
			{
				[contents setObject:[content lastObject] forKey:path];
			}
		}
		E = [[[contents allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
		NSMutableArray * projects = [NSMutableArray array];
		while(content = [E nextObject])
		{
			[projects addObject:[NSDictionary dictionaryWithObjectsAndKeys:content, @"displayName", [[contents allKeysForObject:content] lastObject], iTM2PDTableViewPathIdentifier, nil]];
		}
		// now adding the external projects for this path
		
		id externalProjects = [self projectsAtPath:];
		[projects addObjectsFromDictionary:externalProjects];
		return projects;
		return result;
	}
	else
	{
		return [NSArray array];
	}
//iTM2_END;
}
#elif 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectsAtPath:
- (id)projectsAtPath:(NSString *)dirName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * projectType = [SDC projectDocumentType];
	if([SDC documentClassForType:projectType])
	{
		// we accept all the projects that live with or above the current document.
		// we also accept wrappers at the same level, in that case, the filename will change and the file will be copied
		// we do not display the full path but only the relevant part,
		// something like in the recent documents menu
		NSString * wrapperType = [SDC wrapperDocumentType];
		NSEnumerator * E = [[DFM directoryContentsAtPath:dirName] objectEnumerator];
		id content;
		NSMutableDictionary * contents = [NSMutableDictionary dictionary];
		NSMutableDictionary * dirNames = [NSMutableDictionary dictionary];
		while(content = [E nextObject])
		{
			NSString * extension = [content pathExtension];
			if([[SDC typeFromFileExtension:extension] isEqual:projectType]
				|| [[SDC typeFromFileExtension:extension] isEqual:wrapperType])
			{
				NSString * path = [dirName stringByAppendingPathComponent:content];
				[contents setObject:[NSMutableArray arrayWithObject:content] forKey:path];
				[dirNames setObject:[[[dirName pathComponents] mutableCopy] autorelease] forKey:path];
			}
		}
		NSString * path;
		E = [[contents allKeys] objectEnumerator];
		while(path = [E nextObject])
		{
			NSArray * keys;
			encorePlus:
			content = [contents objectForKey:path];
			keys = [contents allKeysForObject:content];
			if([keys count] > 1)
			{
				// we cannot use content in the UI because different paths may correspond to the same content
				NSEnumerator * e = [[contents allKeysForObject:content] objectEnumerator];
				BOOL encoreUnTour = YES;
				NSString * path;
				while(path = [e nextObject])
				{
					NSMutableArray * start = [dirNames objectForKey:path];
					if([start count])
					{
						[content insertObject:[start lastObject] atIndex:0];
						[start removeLastObject];
						if(![start count])
							encoreUnTour = NO;
					}
				}
				if(encoreUnTour)
					goto encorePlus;
			}
		}
		E = [[contents allKeys] objectEnumerator];
		while(path = [E nextObject])
		{
			content = [contents objectForKey:path];
			if([content count]>1)
			{
				NSMutableArray * mra = [[content mutableCopy] autorelease];
				[mra removeLastObject];
				[contents setObject:[NSString stringWithFormat:@"%@ (%@)", [content lastObject], [@"..." stringByAppendingPathComponent:[NSString pathWithComponents:mra]]]  forKey:path];
			}
			else if([content count])
			{
				[contents setObject:[content lastObject] forKey:path];
			}
		}
		E = [[[contents allValues] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectEnumerator];
		NSMutableArray * projects = [NSMutableArray array];
		while(content = [E nextObject])
		{
			[projects addObject:[NSDictionary dictionaryWithObjectsAndKeys:content, @"displayName", [[contents allKeysForObject:content] lastObject], iTM2PDTableViewPathIdentifier, nil]];
		}
		// now adding the external projects for this path
		
		id externalProjects = [self projectsAtPath:];
		[projects addObjectsFromDictionary:externalProjects];
		return projects;
	}
	else
	{
		return [NSMutableArray array];
	}
//iTM2_END;
}
#endif
#pragma mark =-=-=-=-=-  PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareProjectsFixImplementation
- (void)prepareProjectsFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[IMPLEMENTATION takeMetaValue:[NSMutableSet set] forKey:iTM2ProjectsKey];
	[IMPLEMENTATION takeMetaValue:[NSMutableSet set] forKey:iTM2ProjectsReentrantKey];
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsForFileNamesKey];
	// don't know if it is used
	[IMPLEMENTATION takeMetaValue:[[[iTM2ProjectDocument alloc] init] autorelease] forKey:iTM2ProjectNoneKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projects
- (NSArray *)projects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
        if([D isKindOfClass:[iTM2ProjectDocument class]])
            [MRA addObject:D];
    return MRA;
#endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForDocument:
- (id)projectForDocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!document)
		return nil;
	NSString * fileName = [document fileName];
    if(![fileName length])
        return nil;
	if(iTM2DebugEnabled>99999)
	{
		iTM2_LOG(@"fileName:%@", fileName);
	}
	NSValue * documentValue = [NSValue valueWithNonretainedObject:document];
	iTM2ProjectDocument * projectDocument;
	NSValue * projectValue;
    if(projectValue = [CACHED_PROJECTS objectForKey:documentValue])
	{
		if(projectDocument = [projectValue nonretainedObjectValue])
		{
			if([SPC isProject:projectDocument])
				return projectDocument;
		}
		else
		{
			return nil;// this is a document with no project!
		}
	}
	[document setHasProject:NO];
	// if this method is entered once more from here, it will return from one of the above lines, unless the CACHED_PROJECTS are cleaned
	if([document contextBoolForKey:@"_iTM2:Document With No Project"]
		|| [document contextBoolForKey:@"_iTM2:Document With External Project"])
	{
		[document takeContextBool:NO forKey:@"_iTM2:Document With No Project"];
		if(projectDocument = [self getExternalProjectForFileName:fileName display:NO error:nil])
		{
			[document takeContextBool:YES forKey:@"_iTM2:Document With External Project"];
			[self setProject:projectDocument forDocument:document];
			return projectDocument;// this is a document with no project!
		}
		else
		{
			[document takeContextBool:NO forKey:@"_iTM2:Document With External Project"];
		}
	}
	NSEnumerator * E = [[SPC projects] objectEnumerator];
	while(projectDocument = [E nextObject])
		if([projectDocument ownsSubdocument:document])
		{
			[self setProject:projectDocument forDocument:document];
			return projectDocument;
		}
    if(projectValue = [CACHED_PROJECTS objectForKey:fileName])
	{
		if(projectDocument = [projectValue nonretainedObjectValue])
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

	NSString * name = fileName;
	if(projectDocument = [self newProjectForFileNameRef:&name display:YES error:nil])
	{
		if(![name isEqual:fileName])
		{
			// ensure the containing directory exists
			[DFM createDeepDirectoryAtPath:[name stringByDeletingLastPathComponent] attributes:nil error:nil];
			[document setFileName:name];
		}
		[projectDocument addSubdocument:document];
		[self setProject:projectDocument forDocument:document];
		return projectDocument;
	}
	[self setProject:nil forDocument:document];
	[document takeContextBool:YES forKey:@"_iTM2:Document With No Project"];
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:forDocument:
- (void)setProject:(id)projectDocument forDocument:(NSDocument *)document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
		@"..........  INCONSISTENCY:unexpected behaviour, report bug 1313 in %s", __PRETTY_FUNCTION__);

	NSString * fileName = [document fileName];
	NSAssert3((!projectDocument || [[projectDocument keyForFileName:fileName] length]),
		@"..........  INCONSISTENCY:unexpected behaviour, report bug 3131 in %s, %@, %@", __PRETTY_FUNCTION__, projectDocument, fileName);
	[self setProject:projectDocument forFileName:fileName];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:forFileName:
- (void)setProject:(id)projectDocument forFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![fileName length])
        return;
	if(iTM2DebugEnabled>99999)
	{
		iTM2_LOG(@"fileName:%@", fileName);
	}
	NSParameterAssert((!projectDocument || [SPC isProject:projectDocument]));
	NSValue * projectValue = [NSValue valueWithNonretainedObject:projectDocument];
	fileName = [fileName stringByStandardizingPath];
	[CACHED_PROJECTS setObject:projectValue forKey:fileName];
	NSAssert3((projectDocument == [self projectForFileName:fileName]),
		@"..........  INCONSISTENCY:unexpected behaviour, report bug 3131 in %s", __PRETTY_FUNCTION__, projectDocument, fileName);
	fileName = [fileName stringByDeletingPathExtension];
	[CACHED_PROJECTS setObject:projectValue forKey:fileName];
	[projectDocument refixConsistency];// don't call this sooner
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForFileName:
- (id)projectForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	fileName = [fileName stringByStandardizingPath];
    if(![fileName length])
        return nil;
	if(iTM2DebugEnabled>99999)
	{
		iTM2_LOG(@"fileName:%@", fileName);
	}
//iTM2_LOG(@"CACHED_PROJECTS");
	NSValue * projectValue = [CACHED_PROJECTS objectForKey:fileName];
    id projectDocument = nil;
    if(projectValue)
	{
		if(projectDocument = [projectValue nonretainedObjectValue])
		{
			if([SPC isProject:projectDocument])
				return projectDocument;
		}
		else
		{// document with no project: this is intentional
			return nil;
		}
	}

    if(projectDocument = [BASE_PROJECTS objectForKey:fileName])
        return projectDocument;

//iTM2_LOG(@"Not yet cached");
    NSString * shortFileName = [fileName stringByDeletingPathExtension];
	projectValue = [CACHED_PROJECTS objectForKey:shortFileName];
    if(projectDocument = [projectValue nonretainedObjectValue])
	{
		[CACHED_PROJECTS setObject:[CACHED_PROJECTS objectForKey:shortFileName] forKey:fileName];
		[projectDocument newKeyForFileName:fileName];
        return projectDocument;
	}
//iTM2_LOG(@"Not yet cached for short name");
	NSEnumerator * E = [[SDC documents] objectEnumerator];
	while(projectDocument = [E nextObject])
	{
		if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
		{
			if([projectDocument keyForFileName:fileName] || [[projectDocument fileName] isEqual:fileName])
				goto theEnd1;
			else if([[projectDocument wrapperName] isEqual:fileName])
				goto theEnd2;
		}
	}
//iTM2_LOG(@"Not an already existing project document");
// this is redundant
    E = [[self projects] objectEnumerator];
    while(projectDocument = [E nextObject])
        if([projectDocument keyForFileName:fileName] || [[projectDocument fileName] isEqual:fileName])
            goto theEnd1;
        else if([[projectDocument wrapperName] isEqual:fileName])
            goto theEnd2;
        else if(iTM2DebugEnabled>10)
        {
			iTM2_LOG(@"The project:\n%@ does not know\n%@", [projectDocument fileName], fileName);
        }
//iTM2_LOG(@"Not one of all projects (%@)", [self projects]);
	[self setProject:nil forFileName:fileName];
    return nil;
theEnd1:
	[projectDocument newKeyForFileName:fileName];
theEnd2:
	[self setProject:projectDocument forFileName:fileName];
	if(iTM2DebugEnabled>10)
	{
		iTM2_LOG(@"\\infty - The project:%@ knows about %@", [projectDocument fileName], fileName);
	}
    return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectForSource:
- (id)projectForSource:(id)source;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THERE MIGHT BE A REALLY BIG PROBLEM WHEN CREATING NEW DOCUMENTS:the filename is void!!!
//NSLog(@"source:%@", source);
	[[source retain] autorelease];
    if([source isKindOfClass:[NSString class]])
        return [self projectForFileName:source];
    else if([source isKindOfClass:[iTM2ProjectDocument class]])
        return source;
    else if([source isKindOfClass:[NSDocument class]])
        return [source project];
    else if([source isKindOfClass:[NSWindowController class]])
        return [[source document] project];
    else if([source isKindOfClass:[NSWindow class]])
        return [[[source windowController] document] project];
    else if([source isKindOfClass:[NSView class]])
        return [[[[source window] windowController] document] project];
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
	{
		[PROJECTS addObject:[NSValue valueWithNonretainedObject:projectDocument]];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"project:%@", projectDocument);
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
			iTM2_LOG(@"project:%@", projectDocument);
		}
		[INC postNotificationName:iTM2ProjectContextDidChangeNotification object:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectNamesForDirName:
- (NSArray *)projectNamesForDirName:(NSString *)dirName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(NO,@"YOU MUST OVERRIDE THIS");
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  finderAliasesSubdirectory
- (NSString*)finderAliasesSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[TWSFrontendComponent stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"Finder Aliases"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  softLinksSubdirectory
- (NSString*)softLinksSubdirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[TWSFrontendComponent stringByAppendingPathComponent:[[NSBundle mainBundle] bundleIdentifier]] stringByAppendingPathComponent:@"Soft Links"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextProjectForFileName:display:error:
- (id)getContextProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// I assume that all previous attempts to assign a project to the given file have failed
	// This means that there is no acceptable project in the file system hierarchy.
	id projectDocument = nil;
	// so I needed to open the resources. Now documents always have projects, but I still use the resources
	NSDictionary * contextDictionary = [iTM2Document contextDictionaryFromFile:fileName];
//iTM2_LOG(@"contextDictionary is:%@", contextDictionary);
	// using the absolute hint
	NSString * projectAbsolutePathHint = [contextDictionary objectForKey:iTM2ProjectAbsolutePathKey];
	NSURL * url = nil;
	if([projectAbsolutePathHint isKindOfClass:[NSString class]]
		&& [SWS isProjectPackageAtPath:projectAbsolutePathHint])
	{
		NSAssert(![projectAbsolutePathHint isEqual:fileName], @"Recursive call catched... THIS IS A BIG BUG - 1");
		url = [NSURL fileURLWithPath:projectAbsolutePathHint];
	}
	else
	{
		NSString * projectRelativePathHint = [contextDictionary objectForKey:iTM2ProjectRelativePathKey];
		NSString * pathGuessFromRelativeHint = nil;// project absolute path
		if([projectRelativePathHint isKindOfClass:[NSString class]]
			&& [[projectRelativePathHint pathExtension] isEqual:[SDC projectPathExtension]])
		{
			// the document once had a project, or is a copy/move of a document that once had a project
			// we assume that it still belong to a project...
			#if 1
			NSString * dirName = [fileName stringByDeletingLastPathComponent];
			pathGuessFromRelativeHint = [dirName stringByAppendingPathComponent:projectRelativePathHint];
			#else
			// there was a bug here: the code below did not provide the same result as the code above
			// whereas it sometimes did.
			// This is in accordance to the compiler specifications where functions may not be composed
			// f(g(x))should be replaced by y=g(x);f(y);
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
	NSString * typeName = [SDC typeForContentsOfURL:url error:outError];
	if(projectDocument = [SDC makeDocumentWithContentsOfURL:url ofType:typeName error:outError])
	{
		NSString * key = [projectDocument keyForFileName:fileName];
		if([key length])
		{
			[SDC addDocument:projectDocument];
			[projectDocument saveDocument:nil];
			if([SDC shouldCreateUI])
			{
				if(display)
				{
					[projectDocument makeWindowControllers];
					[projectDocument showWindows];
				}
			}
			return projectDocument;
		}
		else
		{
			key = [projectDocument recordedKeyForFileName:fileName];
			// ok this project once had this file name on its own
			if([key length])
			{
				[SDC addDocument:projectDocument];
				[projectDocument saveDocument:nil];
				[projectDocument setFileName:fileName forKey:key makeRelative:YES];
				key = [projectDocument newKeyForFileName:fileName];// ensure that the file name is registered.
				if([SDC shouldCreateUI])
				{
					if(display)
					{
						[projectDocument makeWindowControllers];
						[projectDocument showWindows];
					}
				}
				return projectDocument;
			}
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPrimaryExternalProjectForFileName:display:error:
- (id)getPrimaryExternalProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * externalProjectsDirectory = [NSString externalProjectsDirectory];
	if([fileName belongsToExternalProjectsDirectory])
		return nil;
	NSString * coreName = [fileName lastPathComponent];
	coreName = [coreName stringByDeletingPathExtension];
	NSString * projectName = [fileName stringByDeletingPathExtension];
	projectName = [projectName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
	projectName = [projectName stringByAppendingPathComponent:coreName];
	projectName = [projectName stringByAppendingPathExtension:[SDC projectPathExtension]];
	projectName = [externalProjectsDirectory stringByAppendingPathComponent:projectName];
	BOOL isDirectory = NO;
	if(![DFM fileExistsAtPath:projectName isDirectory:&isDirectory])
	{
		projectName = [fileName stringByDeletingPathExtension];
		projectName = [projectName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
		projectName = [projectName stringByAppendingPathComponent:iTM2ProjectComponent];
		projectName = [projectName stringByAppendingPathExtension:[SDC projectPathExtension]];
		projectName = [externalProjectsDirectory stringByAppendingPathComponent:projectName];
		if(![DFM fileExistsAtPath:projectName isDirectory:&isDirectory])
		{
			return nil;
		}
	}
	if(!isDirectory)
	{
		NSString * standardProjectName = [projectName stringByStandardizingPath];
		if([standardProjectName isEqual:projectName] || ![DFM fileExistsAtPath:standardProjectName isDirectory:&isDirectory])
		{
			return nil;
		}
		projectName = standardProjectName;
	}
	NSURL * url = [NSURL fileURLWithPath:projectName];
	NSString * typeName = [SDC typeForContentsOfURL:url error:outError];
	iTM2ProjectDocument * projectDocument = nil;
	if(projectDocument = [SDC makeDocumentWithContentsOfURL:url ofType:typeName error:outError])
	{
		[SDC addDocument:projectDocument];// register the project document as side effect
		[projectDocument newKeyForFileName:fileName];
		[SPC setProject:projectDocument forFileName:fileName];// the project must be registered.
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
		}
		return projectDocument;
	}
	projectName = [fileName stringByDeletingPathExtension];
	projectName = [projectName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
	projectName = [projectName stringByAppendingPathComponent:iTM2ProjectComponent];
	projectName = [projectName stringByAppendingPathExtension:[SDC projectPathExtension]];
	projectName = [externalProjectsDirectory stringByAppendingPathComponent:projectName];
	url = [NSURL fileURLWithPath:projectName];
	if(projectDocument = [SDC makeDocumentWithContentsOfURL:url ofType:typeName error:outError])
	{
		[SDC addDocument:projectDocument];// register the project document as side effect
		[projectDocument newKeyForFileName:fileName];
		[SPC setProject:projectDocument forFileName:fileName];// the project must be registered.
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
		}
	}
//iTM2_END;
    return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getSecondaryExternalProjectForFileName:display:error:
- (id)getSecondaryExternalProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * externalProjectsDirectory = [NSString externalProjectsDirectory];
	NSDirectoryEnumerator *DE = [DFM enumeratorAtPath:externalProjectsDirectory];
	NSString * component = nil;
	NSString * typeName = [SDC projectDocumentType];
	NSMutableArray * primaryOpenCandidates = [NSMutableArray array];
	NSMutableArray * primaryCandidates = [NSMutableArray array];
	NSMutableArray * secondaryOpenCandidates = [NSMutableArray array];
	NSMutableArray * secondaryCandidates = [NSMutableArray array];
	NSMutableArray * garbage = [NSMutableArray array];
	NSURL * projectURL = nil;
	NSString * projectName = nil;
	NSString * wrapperName = nil;
	iTM2ProjectDocument * projectDocument = nil;
	while (component = [DE nextObject])
	{
		wrapperName = [externalProjectsDirectory stringByAppendingPathComponent:component];
		if([SWS isWrapperPackageAtPath:wrapperName])
		{
			projectName = [self getProjectNameInWrapperForFileNameRef:&wrapperName error:outError];
			if(projectName)
			{
				if(projectURL = [NSURL fileURLWithPath:projectName])
				{
					BOOL isDirectory = NO;
					if(projectDocument = [SDC documentForURL:projectURL])
					{
						if([[projectDocument keyForFileName:fileName] length])
						{
							[primaryOpenCandidates addObject:projectDocument];
						}
						else if([[projectDocument recordedKeyForFileName:fileName] length])
						{
							[secondaryOpenCandidates addObject:projectDocument];
						}
					}
					else if([DFM fileExistsAtPath:projectName isDirectory:&isDirectory])
					{
						if(isDirectory && (projectDocument = [SDC makeDocumentWithContentsOfURL:projectURL ofType:typeName error:outError]))
						{
							if([[projectDocument keyForFileName:fileName] length])
							{
								[primaryCandidates addObject:projectDocument];
							}
							else if([[projectDocument recordedKeyForFileName:fileName] length])
							{
								[secondaryCandidates addObject:projectDocument];
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
				else
				{
					[garbage addObject:projectName];
				}
			}
			else
			{
				[garbage addObject:wrapperName];
			}
			[DE skipDescendents];
		}
	}
	if([primaryOpenCandidates count] == 1)
	{
//iTM2_LOG(@"WE have found our project", [SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		projectDocument = [primaryOpenCandidates objectAtIndex:0];
		[SPC setProject:projectDocument forFileName:fileName];
		NSEnumerator * E = nil;
		id PD = nil;
clean:
		E = [primaryCandidates objectEnumerator];
		while(PD = [E nextObject])
		{
			[garbage addObject:[PD fileName]];
		}
		E = [secondaryCandidates objectEnumerator];
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
				if(outError)
					* outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove the wrapper directory at\n%@\nPlease, do it for me.", wrapperName]
						forKey:NSLocalizedDescriptionKey]];
			}
		}
		return projectDocument;
	}
	else if([primaryOpenCandidates count])
	{
		projectDocument = nil;
		goto clean;
	}
	else if([secondaryOpenCandidates count] == 1)
	{
		// clean everything except the documents owned by the SDC
		projectDocument = [primaryOpenCandidates objectAtIndex:0];
		[SPC setProject:projectDocument forFileName:fileName];
		goto clean;
	}
	else if([secondaryOpenCandidates count])
	{
//iTM2_LOG(@"WE have found our project", [SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		if(outError)
			* outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Too many projects for:\n%@", fileName]
				forKey:NSLocalizedDescriptionKey]];
		projectDocument = [secondaryOpenCandidates objectAtIndex:0];
		[SPC setProject:projectDocument forFileName:fileName];
		goto clean;
	}
	else if([primaryCandidates count] == 1)
	{
//iTM2_LOG(@"WE have found our project", [SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		projectDocument = [primaryCandidates objectAtIndex:0];
		[SDC addDocument:projectDocument];
		[SPC setProject:projectDocument forFileName:fileName];
		projectName = [projectDocument fileName];
		projectURL = [NSURL fileURLWithPath:projectName];
		projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outError];
		goto clean;
	}
	else if([primaryCandidates count])
	{
		projectDocument = nil;
		goto clean;
	}
	else if([secondaryCandidates count] == 1)
	{
		projectDocument = [secondaryCandidates objectAtIndex:0];
		[SDC addDocument:projectDocument];
		[SPC setProject:projectDocument forFileName:fileName];
		projectName = [projectDocument fileName];
		projectURL = [NSURL fileURLWithPath:projectName];
		projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outError];
		goto clean;
	}
	else if([secondaryCandidates count])
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getExternalProjectForFileName:display:error:
- (id)getExternalProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * projectDocument = [self getProjectForExternalFileName:fileName display:display error:outError];
	if(projectDocument)
		return projectDocument;
	else if(projectDocument = [self getPrimaryExternalProjectForFileName:fileName display:display error:outError])
		return projectDocument;
	else if(projectDocument = [self getSecondaryExternalProjectForFileName:fileName display:display error:outError])
		return projectDocument;
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectForExternalFileName:display:error:
- (id)getProjectForExternalFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileName belongsToExternalProjectsDirectory])
		return nil;
	// find the enclosing directory wrapper
	NSString * path = [fileName enclosingWrapperFileName];
	if([path length])
	{
		path = [path stringByAppendingPathComponent:iTM2ProjectComponent];
		path = [path stringByAppendingPathExtension:[SDC projectPathExtension]];
		NSURL * url = [NSURL fileURLWithPath:path];
		id projectDocument = [SDC openDocumentWithContentsOfURL:url display:display error:outError];
		[SPC setProject:projectDocument forFileName:fileName];
		return projectDocument;
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getOpenProjectForFileName:
- (id)getOpenProjectForFileName:(NSString *)fileName;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	fileName = [fileName stringByStandardizingPath];
	NSEnumerator * E = [[SDC documents] objectEnumerator];
	id projectDocument = nil;
	while(projectDocument = [E nextObject])
	{
		if([projectDocument isKindOfClass:[iTM2ProjectDocument class]])
		{
			NSString * key = [projectDocument keyForFileName:fileName];
			if([[projectDocument keyForFileName:fileName] length])
			{
				break;
			}
			else if([[projectDocument fileName] isEqual:fileName])
			{
				[projectDocument newKeyForFileName:fileName];
			}
			else if([[projectDocument wrapperName] isEqual:fileName])
			{
				break;
			}
			else
			{
				key = [projectDocument recordedKeyForFileName:fileName];
				if([key length])
				{
					[projectDocument setFileName:fileName forKey:key makeRelative:YES];
					break;
				}
				
			}
		}
	}
	[self setProject:projectDocument forFileName:fileName];
	if(iTM2DebugEnabled>10)
	{
		iTM2_LOG(@"\\infty - The project:%@ knows about %@", [projectDocument fileName], fileName);
	}
//iTM2_END;
    return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getBaseProjectForFileName:
- (id)getBaseProjectForFileName:(NSString *)fileName;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	fileName = [fileName stringByStandardizingPath];
    return [BASE_PROJECTS objectForKey:fileName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectNameInWrapperForFileNameRef:error:
- (NSString *)getProjectNameInWrapperForFileNameRef:(NSString **)fileNameRef error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!fileNameRef)
		return nil;
	iTM2ProjectDocument * projectDocument = nil;
	NSString * fileName = [*fileNameRef stringByStandardizingPath];
	NSString * wrapperName = [fileName enclosingWrapperFileName];
	if([wrapperName length])
	{
		// then we are trying to find a project just below
		BOOL isDirectory = NO;
		if([DFM fileExistsAtPath:wrapperName isDirectory:&isDirectory] && isDirectory)
		{
			NSString * projectName = nil;
			NSEnumerator * E = [[DFM directoryContentsAtPath:wrapperName] objectEnumerator];
			NSMutableArray * projectNames = [NSMutableArray array];
			NSString * projectDocumentType = [SDC projectDocumentType];
			NSString * component = nil;
			NSURL * url = nil;
			while(component = [E nextObject])
			{
				projectName = [wrapperName stringByAppendingPathComponent:component];
				if([SWS isProjectPackageAtPath:projectName])
					[projectNames addObject:projectName];
			}
			if([projectNames count] == 1)
			{
				return [projectNames lastObject];
			}
			else if([projectNames count])
			{
				component = [wrapperName lastPathComponent];
				component = [component stringByDeletingPathExtension];
				component = [component stringByAppendingPathExtension:[SDC projectPathExtension]];
				projectName = [wrapperName stringByAppendingPathComponent:component];
				if([projectNames containsObject:projectName])
				{
					return projectName;
				}
				component = [iTM2ProjectComponent stringByAppendingPathExtension:[SDC projectPathExtension]];
				projectName = [wrapperName stringByAppendingPathComponent:component];
				if([projectNames containsObject:projectName])
				{
					return projectName;
				}
				if(outError)
				{
					*outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Too many projects in the wrapper directory at\n%@\nChoosing the last one.", wrapperName] forKey:NSLocalizedDescriptionKey]];
				}
				return nil;
			}
			else
			{
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.", wrapperName] forKey:NSLocalizedDescriptionKey]]];
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
						[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:tag
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Impossible to recycle file at\n%@\nProblems forthcoming...", projectName]
								forKey:NSLocalizedDescriptionKey]]];
					}
				}
				url = [NSURL fileURLWithPath:projectName];
				if([DFM createDeepDirectoryAtPath:projectName attributes:nil error:outError])
				{
					projectDocument = [SDC openDocumentWithContentsOfURL:url display:NO error:outError];
				}
				else
				{
					projectDocument = [SDC makeUntitledDocumentOfType:projectDocumentType error:outError];
					[projectDocument setFileURL:url];
					[projectDocument setFileType:projectDocumentType];
					[SDC addDocument:projectDocument];
				}
				if(projectDocument)
				{
					[projectDocument newKeyForFileName:fileName];
					[projectDocument saveDocument:nil];
					if([fileName isEqual:wrapperName])
						* fileNameRef = projectName;
					return projectName;
				}
				else
				{
					if(outError)
					{
						*outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project in the wrapper directory at\n%@\nCreating one.", wrapperName] forKey:NSLocalizedDescriptionKey]];
					}
					return nil;
				}
			}
		}
		else
		{
			if(outError)
			{
				*outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"ERROR:There might be a link at %@:it is no yet supported by iTeXMac2", fileName]
						forKey:NSLocalizedDescriptionKey]];
			}
			return nil;
		}
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectInWrapperForFileNameRef:display:error:
- (id)getProjectInWrapperForFileNameRef:(NSString **)fileNameRef display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!fileNameRef)
		return nil;
	NSString * fileName = [*fileNameRef stringByStandardizingPath];
	NSString * projectName = [self getProjectNameInWrapperForFileNameRef:fileNameRef error:outError];
	if([projectName length])
	{
		NSURL * url = [NSURL fileURLWithPath:projectName];
		iTM2ProjectDocument * projectDocument = [SDC openDocumentWithContentsOfURL:url display:display error:outError];
		[projectDocument newKeyForFileName:fileName];
		[SPC setProject:projectDocument forFileName:fileName];
		return projectDocument;
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectInHierarchyForFileName:display:error:
- (id)getProjectInHierarchyForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	fileName = [fileName stringByStandardizingPath];
	NSString * dirName = [fileName stringByDeletingLastPathComponent];
	NSString * component = nil;
	NSString * projectDocumentType = [SDC projectDocumentType];
	NSURL * url = nil;
	iTM2ProjectDocument * projectDocument = nil;
	NSEnumerator * E = nil;
scanDirectoryContent:
	E = [[DFM directoryContentsAtPath:dirName] objectEnumerator];
	BOOL finished = NO;
	NSMutableArray * candidates = [NSMutableArray array];
	NSMutableArray * secondaryCandidates = [NSMutableArray array];
	while(component = [E nextObject])
	{
		if([[SDC typeFromFileExtension:[component pathExtension]] isEqual:projectDocumentType])
		{
			finished = YES;
			NSString * projectName = [dirName stringByAppendingPathComponent:component];
			url = [NSURL fileURLWithPath:projectName];
			projectDocument = [SDC documentForURL:url];
			if(!projectDocument)
			{
				projectDocument = [SDC makeDocumentWithContentsOfURL:url ofType:[SDC projectDocumentType] error:outError];
			}
			if([[projectDocument keyForFileName:fileName] length])
				[candidates addObject:projectDocument];
			else if([[projectDocument recordedKeyForFileName:fileName] length])
				[secondaryCandidates addObject:projectDocument];
//iTM2_LOG(@"AFTER  [SDC documents] are:%@", [SDC documents]);
		}
	}
	NSURL * projectURL = nil;
	if([candidates count] == 1)
	{
//iTM2_LOG(@"WE have found our project", [SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		projectDocument = [candidates objectAtIndex:0];
		[SDC addDocument:projectDocument];
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
		}
		return projectDocument;
	}
	else if([candidates count])
	{
		[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"THERE ARE MANY DIFFERENT PROJECTS FOR THAT FILE NAME %@, unexpected situation", fileName] forKey:NSLocalizedDescriptionKey]]];
		projectDocument = [candidates objectAtIndex:0];
		[SDC addDocument:projectDocument];
		[SPC setProject:projectDocument forFileName:fileName];
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
		}
		return projectDocument;
	}
	else if(!finished)
	{
		NSString * newDirName = [dirName stringByDeletingLastPathComponent];
		if([newDirName length] < [dirName length])
		{
			dirName = newDirName;
			if([dirName length])
				goto scanDirectoryContent;
		}
	}
	else if([secondaryCandidates count] == 1)
	{
//iTM2_LOG(@"WE have found our project", [SDC documents]);
		// we found only one project that declares the fileName: it is the good one
		projectDocument = [secondaryCandidates objectAtIndex:0];
		[SDC addDocument:projectDocument];
		projectURL = [projectDocument fileURL];
		if(projectDocument = [SDC openDocumentWithContentsOfURL:projectURL display:display error:outError])
		{
			[SPC setProject:projectDocument forFileName:fileName];
			return projectDocument;
		}
	}
	else if([secondaryCandidates count])
	{
		[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
			userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"THERE ARE MANY DIFFERENT PROJECTS FOR THAT FILE NAME %@, unexpected situation", fileName] forKey:NSLocalizedDescriptionKey]]];
		projectDocument = [secondaryCandidates objectAtIndex:0];
		[SDC addDocument:projectDocument];
		[SPC setProject:projectDocument forFileName:fileName];
#warning BAD DESIGN: better choice expected
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
		}
		return projectDocument;
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newExternalProjectForFileName:display:error:
- (id)newExternalProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// create an external project
	NSString * externalProjectsDirectory = [NSString externalProjectsDirectory];
	NSString * typeName = [SDC projectDocumentType];
	iTM2ProjectDocument * projectDocument = [SDC makeUntitledDocumentOfType:typeName error:outError];
	if(projectDocument)
	{
		NSString * component = [fileName lastPathComponent];
		NSString * coreName = [component stringByDeletingPathExtension];
		NSString * externalWrapperName = [fileName stringByDeletingPathExtension];
		externalWrapperName = [externalWrapperName stringByAppendingPathExtension:[SDC wrapperPathExtension]];
		externalWrapperName = [externalProjectsDirectory stringByAppendingPathComponent:externalWrapperName];
		// externalWrapperName is now the directory wrapper name
		BOOL isDirectory = NO;
		if([DFM fileExistsAtPath:externalWrapperName isDirectory:&isDirectory])
		{
			if(!isDirectory)
			{
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:3
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Unexpected file at\n%@\nwill be removed.", externalWrapperName]
							forKey:NSLocalizedDescriptionKey]]];
				if(![DFM removeFileAtPath:externalWrapperName handler:NULL])
				{
					[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:3
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove\n%@\nPlease, do it for me now and click OK.", externalWrapperName]
								forKey:NSLocalizedDescriptionKey]]];
					if([DFM fileExistsAtPath:externalWrapperName isDirectory:nil])
					{
						if(outError)
						{
							*outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:3
								userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"You did not remove file at\n%@\nNo project created...", externalWrapperName]
										forKey:NSLocalizedDescriptionKey]];
						}
						return nil;
					}
createWrapper:
					if(![DFM createDeepDirectoryAtPath:externalWrapperName attributes:nil error:outError])
					{
						[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:3
								userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create folder at\n%@\nPlease do it for me now and click OK", externalWrapperName]
									forKey:NSLocalizedDescriptionKey]]];
						if(![DFM fileExistsAtPath:externalWrapperName isDirectory:&isDirectory] || !isDirectory)
						{
							if(outError)
							{
								*outError = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:3
									userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"You did not create folder at\n%@\nNo project created", externalWrapperName]
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
		NSString * projectName = [externalWrapperName stringByAppendingPathComponent:coreName];
		projectName = [projectName stringByAppendingPathExtension:[SDC projectPathExtension]];
		if(![DFM createDeepDirectoryAtPath:projectName attributes:nil error:outError] && outError && *outError)
		{
			[SDC presentError:*outError];
		}
		NSURL * url = [NSURL fileURLWithPath:projectName];
//iTM2_LOG(@"url: %@", url);
		[projectDocument setFileURL:url];
		[projectDocument setFileType:typeName];// is it necessary?
		[SDC addDocument:projectDocument];
		// the named file is linked to something in the wrapper
		NSString * linkName = [externalWrapperName stringByAppendingPathComponent:component];
		// maybe there is already something at this path: we just remove it
		// if it was a link, I just remove it with
		// it it was a regular file or a directory, recycle it
		if([DFM pathContentOfSymbolicLinkAtPath:linkName])
		{
			if(![DFM removeFileAtPath:linkName handler:nil])
			{
				iTM2_OUTERROR(1, ([NSString stringWithFormat:@"Could not remove the link at %@", linkName]), nil);
			}
		}
		else if([DFM fileExistsAtPath:linkName isDirectory:nil])
		{
			NSString * dirName = [linkName stringByDeletingLastPathComponent];
			NSString * component = [linkName lastPathComponent];
			NSArray * RA = [NSArray arrayWithObject:component];
			int tag = 0;
			if(![SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName destination:@"" files:RA tag:&tag])
			{
				iTM2_OUTERROR(tag, ([NSString stringWithFormat:@"Could not recycle synchronously file at %@", linkName]), nil);
			}
		}
		if([DFM createSymbolicLinkAtPath:linkName pathContent:fileName])
		{
			[projectDocument newKeyForFileName:linkName];
		}
		else
		{
			[projectDocument newKeyForFileName:fileName];
		}
// can I save to that folder?
		[projectDocument saveDocument:nil];
		NSAssert([[projectDocument keyForFileName:fileName] length], @"The key must be non void");
		if([SDC shouldCreateUI])
		{
			if(display)
			{
				[projectDocument makeWindowControllers];
				[projectDocument showWindows];
			}
		}
		return projectDocument;
	}
//iTM2_END;
    return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectPanelControllerClass
- (Class)newProjectPanelControllerClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [iTM2NewProjectController class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getProjectFromPanelForFileNameRef:display:error:
- (id)getProjectFromPanelForFileNameRef:(NSString **)fileNameRef display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!fileNameRef)
		return nil;
	NSString * fileName = *fileNameRef;
	if([fileName belongsToExternalProjectsDirectory])
		return nil;
	NSString * dirName = [fileName stringByDeletingLastPathComponent];
	if(![DFM isWritableFileAtPath:dirName])
	{
		// no need to go further
		id projectDocument = [self newExternalProjectForFileName:fileName display:display error:outError];
		[SPC setProject:projectDocument forFileName:fileName];
		return projectDocument;
	}
	// reentrant management, if the panel for that particular file is already running, do nothing...
	NSEnumerator * E = [[NSApp windows] objectEnumerator];
	NSWindow * W;
	id controller;
	while(W = [E nextObject])
	{
		controller = [W windowController];
		if([controller isKindOfClass:[self newProjectPanelControllerClass]] && [[controller fileName] isEqual:fileName])
			return nil;
	}
//iTM2_LOG(@"fileName is:%@", fileName);
	controller = [[[self newProjectPanelControllerClass] alloc] initWithWindowNibName:NSStringFromClass([self newProjectPanelControllerClass])];
	[controller setFileName:fileName];
	int returnCode = 0;
	if(W = [controller window])
	{
		returnCode = [NSApp runModalForWindow:W];
		[W orderOut:self];
	}
	[controller autorelease];// only now, unless you want to break the code in the modal loop above
	NSString * projectName = [controller projectName];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"return code is:%u", returnCode);
		iTM2_LOG(@"projectName is:%@", projectName);
	}
	switch(returnCode)
	{
		case iTM2ToggleNewProjectMode:
		{
			if(![DFM createDeepDirectoryAtPath:projectName attributes:nil error:nil])
			{
				iTM2_OUTERROR(1,([NSString stringWithFormat:@"For one reason or another I could not ceate some directory at path:%@", projectName]),nil);
				return nil;
			}
			// do I have to change the file name?
			// what is the rule to change the file name?
			// If the file belongs to a wrapper, it should already have a project
			// We assume that the file name does not originally belong to a wrapper
			// So if the returned project name belongs to a wrapper,
			// then the file name should be changed accordingly.
			// if the project file does not belong to a wrapper, then no change.
			// So we just have to compare the dirnames
			NSString * projectDirName = [projectName stringByDeletingLastPathComponent];
			if([SWS isWrapperPackageAtPath:projectDirName])
			{
				// we must change the name
				if(![dirName isEqualToString:projectDirName])
				{
					NSString * component = [fileName lastPathComponent];
					* fileNameRef = [projectDirName stringByAppendingPathComponent:component];
					int tag;
					if(![SWS performFileOperation:NSWorkspaceMoveOperation
							source:dirName
								destination:projectDirName
									files:[NSArray arrayWithObject:component]
										tag:&tag])
					{
						iTM2_OUTERROR(tag,([NSString stringWithFormat:@"Could not move %@ to %@\nPlease, do it for me...", fileName, * fileNameRef]),nil);
					}
					fileName = * fileNameRef;
					dirName = projectDirName;
				}
			}
			// we will have a project at projectName
			// is there an already existing file at that path?
			id projectDocument = nil;
			NSURL * absoluteURL = [NSURL fileURLWithPath:projectName];
			NSString * typeName = [SDC typeFromFileExtension:[projectName pathExtension]];
			if([SWS isProjectPackageAtPath:projectName] || [DFM createDeepDirectoryAtPath:projectName attributes:nil error:outError])
			{
				projectDocument = [SDC openDocumentWithContentsOfURL:absoluteURL display:NO error:outError];
			}
			else
			{
				projectDocument = [[[SDC makeUntitledDocumentOfType:typeName error:outError] retain] autorelease];
				[projectDocument setFileURL:absoluteURL];
				[projectDocument saveDocument:self];
				[SDC addDocument:projectDocument];
			}
//iTM2_LOG(@"Now the file name of the projectDocument is:%@", [projectDocument fileName]);
//iTM2_LOG(@">>>>>>>>>>>>>>>>>>>   I have a projectDocument:%@", projectDocument);
//iTM2_LOG(@">>>>>>>>>>>>>>>>>>>   [SDC documents] are:%@", [SDC documents]);
			[projectDocument newKeyForFileName:fileName];
			[SPC setProject:projectDocument forFileName:fileName];
			if([SDC shouldCreateUI])
			{
				if(display)
				{
					[projectDocument makeWindowControllers];
					[projectDocument showWindows];
				}
			}
			[DFM hideExtensionAtPath:projectName];
			return projectDocument;
		}
		break;
		case iTM2ToggleOldProjectMode:
		{
			NSURL * absoluteURL = [NSURL fileURLWithPath:projectName];
			id projectDocument = [[[SDC openDocumentWithContentsOfURL:absoluteURL display:NO error:nil] retain] autorelease];
			NSString * projectDirName = [projectDocument fileName];
			NSString * projectWrapperName = [projectDirName enclosingWrapperFileName];
			projectDirName = [projectDirName stringByDeletingLastPathComponent];
			if([projectWrapperName length])
			{
				if(![dirName isEqualToString:projectDirName])
				{
					// we must change the name
					NSString * component = [fileName lastPathComponent];
					* fileNameRef = [projectDirName stringByAppendingPathComponent:component];
					int tag;
					if(![SWS performFileOperation:NSWorkspaceMoveOperation
							source:dirName
								destination:projectDirName
									files:[NSArray arrayWithObject:component]
										tag:&tag])
					{
						iTM2_OUTERROR(tag,([NSString stringWithFormat:@"Could not move %@ to %@\nPlease, do it for me...", fileName, * fileNameRef]),nil);
					}
					fileName = * fileNameRef;
					dirName = projectDirName;
				}
			}
			if([projectDocument newKeyForFileName:fileName])
			{
				[projectDocument saveDocument:self];
			}
			[SPC setProject:projectDocument forFileName:fileName];
			if([SDC shouldCreateUI])
			{
				if(display)
				{
					[projectDocument makeWindowControllers];
					[projectDocument showWindows];
				}
			}
			return projectDocument;
		}
		break;
		case iTM2ToggleStandaloneMode:
		{
			// where shall I find this project document?
			id projectDocument = [self newExternalProjectForFileName:fileName display:display error:outError];
			[SPC setProject:projectDocument forFileName:fileName];
			return projectDocument;
		}
		break;
		default:
		{
		// case iTM2ToggleStandaloneMode:
			return nil;
		}
		break;
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willGetNewProjectForFileNameRef:
- (void)willGetNewProjectForFileNameRef:(NSString **)fileNameRef;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(fileNameRef)
		[REENTRANT_PROJECT addObject:*fileNameRef];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didGetNewProjectForFileNameRef:
- (void)didGetNewProjectForFileNameRef:(NSString **)fileNameRef;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(fileNameRef)
		[REENTRANT_PROJECT removeObject:*fileNameRef];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canGetNewProjectForFileNameRef:
- (BOOL)canGetNewProjectForFileNameRef:(NSString **)fileNameRef;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return fileNameRef && ![REENTRANT_PROJECT containsObject:*fileNameRef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectForFileNameRef:display:error:
- (id)newProjectForFileNameRef:(NSString **)fileNameRef display:(BOOL)display error:(NSError **)outError;
/*"Description forthcoming.
Developer note:all the docs open here are .texp files.
Those files are filtered out and won't be open by the posed as class document controller.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!fileNameRef)
	{
		return nil;
	}
	*fileNameRef = [*fileNameRef stringByStandardizingPath];
//iTM2_LOG(*fileNameRef);
	iTM2ProjectDocument * projectDocument = [self projectForFileName:*fileNameRef];
	if(projectDocument)
		return projectDocument;// this filename is already registered, possibly with a "nil" project
	// reentrant code
	[SPC setProject:nil forFileName:*fileNameRef];
	if(![self canGetNewProjectForFileNameRef:fileNameRef])
	{
		return nil;
	}
	[self willGetNewProjectForFileNameRef:fileNameRef];
//iTM2_LOG(*fileNameRef);
	// nil is returned for project file names...
	NSString * projectDocumentType = [SDC projectDocumentType];
	[[SDC typeFromFileExtension:[*fileNameRef pathExtension]] isEqual:projectDocumentType]
	|| ![SDC documentClassForType:projectDocumentType]
	|| (projectDocument = [self getOpenProjectForFileName:*fileNameRef])
	|| (projectDocument = [self getProjectInWrapperForFileNameRef:fileNameRef display:display error:outError])
	|| (projectDocument = [self getProjectInHierarchyForFileName:*fileNameRef display:display error:outError])
	|| (projectDocument = [self getExternalProjectForFileName:*fileNameRef display:display error:outError])
	|| (projectDocument = [self getProjectFromPanelForFileNameRef:fileNameRef display:display error:outError]);
	[self setProject:projectDocument forFileName:*fileNameRef];
	[self didGetNewProjectForFileNameRef:fileNameRef];
	return projectDocument;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isProject:
- (BOOL)isProject:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [PROJECTS containsObject:[NSValue valueWithNonretainedObject:argument]];
}
#pragma mark =-=-=-=-=-  BASE PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareBaseProjectsFixImplementation
- (void)prepareBaseProjectsFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsBaseKey];
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2ProjectsBaseForNamesKey];	
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjects
- (NSDictionary *)baseProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[BASE_PROJECTS copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectWithName:
- (id)baseProjectWithName:(NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSParameterAssert([projectName length] > 0);
	if(iTM2DebugEnabled>100000)
	{
		iTM2_LOG(@"projectName:%@", projectName);
	}
    id P = nil;
//iTM2_LOG(@"CACHED_BASE_PROJECTS");
    if(P = [[CACHED_BASE_PROJECTS objectForKey:projectName] nonretainedObjectValue])
        return P;

//iTM2_LOG(@"Not yet cached");
	NSEnumerator * E = [[self baseProjects] objectEnumerator];
	while(P = [E nextObject])
		if([[P projectName] isEqual:projectName])
		{
			NSValue * V = [NSValue valueWithNonretainedObject:P];
			[CACHED_BASE_PROJECTS takeValue:V forKey:projectName];
			if(iTM2DebugEnabled>10)
			{
				iTM2_LOG(@"\\infty - The project:%@ knows about %@", [P projectName], projectName);
			}
			return P;
		}
	NSString * lower = [projectName lowercaseString];
	if([projectName isEqual:lower])
		return nil;
	P = [self baseProjectWithName:lower];
	if(P)
	{
		NSValue * V = [NSValue valueWithNonretainedObject:P];
		[CACHED_BASE_PROJECTS takeValue:V forKey:projectName];
	}
	return P;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addBaseProject:
- (void)addBaseProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(projectDocument)
	{
		[BASE_PROJECTS setObject:projectDocument forKey:[[projectDocument fileName] lastPathComponent]];// the previously added projects for that key are overriden
		if(iTM2DebugEnabled>10000)
		{
			iTM2_LOG(@"Base project added:%@",  projectDocument);
			iTM2_LOG(@"Base project frontend model is:%@", [[projectDocument implementation] modelOfType:iTM2ProjectFrontendType]);
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeBaseProject:
- (void)removeBaseProject:(id)projectDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(projectDocument)
	{
		[PROJECTS removeObjectsForKeys:[PROJECTS allKeysForObject:projectDocument]];
		[CACHED_PROJECTS removeObjectsForKeys:[CACHED_PROJECTS allKeysForObject:
			[PROJECTS allKeysForObject:[NSValue valueWithNonretainedObject:projectDocument]]]];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"project:%@", projectDocument);
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isBaseProject:
- (BOOL)isBaseProject:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[SPC baseProjects] objectEnumerator];
	id O;
	while(O = [E nextObject])
		if(O == argument)
			return YES;
    return NO;
}
#pragma mark =-=-=-=-=-  CURRENT PROJECTS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentProject
- (id)currentProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [metaGETTER nonretainedObjectValue];// beware, old can point to nothing consistent
	id result = [[SDC currentDocument] project];
	if(result != old)
	{
		metaSETTER([NSValue valueWithNonretainedObject:result]);// reentrant
		[INC performSelector:@selector(postNotification:)withObject:
			[NSNotification notificationWithName:iTM2ProjectCurrentDidChangeNotification
				object:self userInfo:([self isProject:old]? [NSDictionary dictionaryWithObjectsAndKeys:old, @"oldProject", nil]:nil)]
			afterDelay:0];// notice the isProject:that ensures old is consistent
		NSEnumerator * E = [[self projects] objectEnumerator];
		id projectDocument;
		while(projectDocument = [E nextObject])
			if(projectDocument == result)
			{
				[projectDocument exposeWindows];
				while(projectDocument = [E nextObject])
					[projectDocument dissimulateWindows];
			}
			else
				[projectDocument dissimulateWindows];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidBecomeKeyOrMainNotified:
- (void)windowDidBecomeKeyOrMainNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
#undef CACHED_PROJECTS
#undef BASE_PROJECTS
#undef CACHED_BASE_PROJECTS

@interface NSWindowController_iTM2ProjectDocumentKit:NSWindowController
@end

@implementation NSWindowController_iTM2ProjectDocumentKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shouldCascadeWindows
- (BOOL)shouldCascadeWindows;
/*"Gives a default value, useful for window observer?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [super shouldCascadeWindows] && (![SPC projectForSource:self]);
}
#if 0
- (void)synchronizeWindowTitleWithDocumentName;
{iTM2_DIAGNOSTIC;
	[super synchronizeWindowTitleWithDocumentName];
	iTM2_LOG(@"[[self window] title] is:%@", [[self window] title]);
	iTM2_LOG(@"[[self document] fileName] is:%@", [[self document] fileName]);
	if(![[self document] fileName])
		NSLog(@"RIEN");
	
}
#endif
@end

NSString * const iTM2OtherProjectWindowsAlphaValue = @"iTM2OtherProjectWindowsAlphaValue";

@interface NSWindow_iTM2ProjectDocumentKit:NSWindow
@end

@implementation NSWindow_iTM2ProjectDocumentKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithFloat:1], iTM2OtherProjectWindowsAlphaValue,// to be improved...
			nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= display
- (void)display;
/*"Gives a default value, useful for window observer?
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
			[super display];
			[self setAlphaValue:oldAlpha];
			[self setOpaque:wasOpaque];
//iTM2_END;
			return;
		}
	}
	[super display];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayIfNeeded
- (void)displayIfNeeded;
/*"Gives a default value, useful for window observer?
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
			[super displayIfNeeded];
			[self setAlphaValue:oldAlpha];
			[self setOpaque:wasOpaque];
//iTM2_END;
			return;
		}
	}
	[super displayIfNeeded];
//iTM2_END;
    return;
}
#endif
@end

#if 0
@interface NSApplication_iTM2ProjectDocumentKit:NSApplication
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSApplication_iTM2ProjectDocumentKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSApplication_iTM2ProjectDocumentKit poseAsClass:[NSApplication class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  miniaturizeAll:
- (void)miniaturizeAll:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super miniaturizeAll:sender];// to be patched?
//iTM2_END;
    return;
}
- (void)arrangeInFront:(id)sender;
{
	return;// no arrange in front because it is not undoable...
}
@end
#endif

@interface NSDocument_iTM2ProjectDocumentKit:NSDocument
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSDocument_iTM2ProjectDocumentKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSDocument_iTM2ProjectDocumentKit poseAsClass:[NSDocument class]];
	[NSWindowController_iTM2ProjectDocumentKit poseAsClass:[NSWindowController class]];
	[NSWindow_iTM2ProjectDocumentKit poseAsClass:[NSWindow class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL*)newURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * newFileName = [newURL path];
	NSURL * oldURL = [self fileURL];
	if(!oldURL || [oldURL isEqual:newURL])
	{
		[super setFileURL:newURL];
		return;
	}
	iTM2ProjectDocument * oldPD = [self project];
	if(!oldPD || (self == (id)oldPD))
	{
		[super setFileURL:newURL];
		return;
	}
	iTM2WrapperDocument * WD = [self wrapper];
	if(self == (id)WD)
	{
		[super setFileURL:newURL];
		return;
	}
	// the receiver is not a project nor a wrapper, but belongs to project projectDocument
	NSString * oldKey = [oldPD keyForSubdocument:self];
	NSAssert2([oldKey length], @"NON SENSE! the project %@ owns the document %@ but has no key for it!", oldPD, self);
	iTM2ProjectDocument * newPD = [SPC projectForFileName:newFileName];
	if(newPD)
	{
		[super setFileURL:newURL];
	}
	else
	{
		NSString * name = newFileName;
#warning ERROR POSSIBLE: display NO
		newPD = [SPC newProjectForFileNameRef:&name display:NO error:nil];
		[super setFileURL:[NSURL fileURLWithPath:name]];
		if(![name isEqual:newFileName])
		{
		#warning THERE MIGHT BE A PROBLEM HERE
			iTM2_LOG(@"----  BE EXTREMELY CAREFUL: writeSafelyToURL will be used");
			if(![self writeSafelyToURL:oldURL ofType:[self fileType] forSaveOperation:NSSaveOperation error:nil])
			{
				iTM2_LOG(@"*** THERE IS SOMETHING WRONG WITH THAT FILE NAME:%@", name);
			}
#if 0
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Suppressing project documents references", iTM2ProjectTable, myBUNDLE, ""),
				NSLocalizedStringFromTableInBundle(@"Keep", iTM2ProjectTable, myBUNDLE, ""),
				NSLocalizedStringFromTableInBundle(@"Cancel", iTM2ProjectTable, myBUNDLE, ""),
				NSLocalizedStringFromTableInBundle(@"Recycle", iTM2ProjectTable, myBUNDLE, ""),
				[self frontWindow],
				[self class],
				NULL,
				@selector(setFileNameSheetDidDismiss:returnCode:recycleName:),
				[name retain],// will be released below
				NSLocalizedStringFromTableInBundle(@"Also recycle the selected project documents?", iTM2ProjectTable, myBUNDLE, ""));
#endif
		}
	}
	// removing all the previously existing document with the same file name
	// except the receiver, of course
	if(newPD == oldPD)
	{
		[[newPD keyedSubdocuments] takeValue:nil forKey:oldKey];
		NSString * newKey = [newPD newKeyForFileName:[self fileName]];
		[[newPD keyedProperties] takeValue:[[[oldPD propertiesForFileKey:oldKey] mutableCopy] autorelease] forKey:newKey];
		return;
	}
	else if([newPD ownsSubdocument:self])
	{
		// This is not expected:two different projects own the same document
		[super setFileURL:newURL];
		NSAssert3(NO, @"INCONSISTENT CODE:projects %@ and %@ are not allowed to own the same document:%@", oldPD, newPD, self);
		return;
	}
	else if(newPD)
	{
		[oldPD removeSubdocument:self];
		// remove in newPD the project documents with the same name
		NSDocument * newD;
		while(newD = [newPD subdocumentForFileName:newFileName])
		{
			[newPD removeSubdocument:newD];
			[newD canCloseDocumentWithDelegate:[self class]
				shouldCloseSelector:@selector(document:setFileNameShouldClose:contextInfo:)
					contextInfo:nil];
		}
		[newPD addSubdocument:self];
		NSString * newKey = [newPD keyForSubdocument:self];
		[[newPD keyedProperties] takeValue:[[[oldPD propertiesForFileKey:oldKey] mutableCopy] autorelease] forKey:newKey];
		// what about the context?
	}
	else
	{
		[SDC addDocument:self];
		[oldPD removeSubdocument:self];
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
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileNameSheetDidDismiss:returnCode:recycleName:
+ (void)setFileNameSheetDidDismiss:(NSWindow *)sheet returnCode:(int)returnCode recycleName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[fileName autorelease];// was retained above
	if(returnCode == NSAlertAlternateReturn)// cancel!!
		return;
	BOOL recycle = returnCode == NSAlertOtherReturn;
    iTM2ProjectDocument * projectDocument = (iTM2ProjectDocument *)[self document];
    NSEnumerator * E = [recyclable objectEnumerator];
	NSString * fileKey;
	NSDictionary * contextInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:recycle] forKey:@"recycle"];
    while(fileKey = [E nextObject])
    {
		NSString * fullPath = [projectDocument absoluteFileNameForKey:fileKey];
		NSDocument * D = [SDC documentForFileName:fullPath];
		if(D)
			[D canCloseDocumentWithDelegate:self
				shouldCloseSelector:@selector(projectDocument:shouldRemoveFromProject:contextInfo:)
					contextInfo:[contextInfo retain]];// contextInfo will be released below
		else if(recycle)
		{
			NSString * lastComponent = [fullPath lastPathComponent];
			NSString * dirName = [fullPath stringByDeletingLastPathComponent];
			int tag;
			if(![SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName
							destination:@"" files:[NSArray arrayWithObject:lastComponent] tag:&tag])
			{
				iTM2_LOG(@"Could not recycle synchronously file at %@ (tag is %i)", fullPath, tag);
			}
			[projectDocument removeKey:fileKey];
		}
		else
			[projectDocument removeKey:fileKey];
	}
//iTM2_END;
	return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:
- (id)contextValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id projectDocument = [self project];
	if(projectDocument)
	{
		NSString * fileKey = [projectDocument keyForFileName:[self originalFileName]];
		if(![fileKey length])
			return [SUD objectForKey:aKey];
		id result = nil;
#warning got an EXC_BAD_ACCESS in one of the following lines
		id implementation = [projectDocument implementation];
		id O = [implementation iVarContextKeyedFiles];
		O = [O valueForKey:fileKey];
		if(result = [O valueForKey:aKey])
			return result;
		NSString * extensionKey = [[self originalFileName] pathExtension];
		if([extensionKey length])
			if(result = [[[implementation iVarContextExtensions] valueForKey:extensionKey] valueForKey:aKey])
				return result;
		NSString * type = [self fileType];
		if(result = [[[implementation iVarContextTypes] valueForKey:type] valueForKey:aKey])
			return result;
	}
    return [super contextValueForKey:aKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:
- (void)takeContextValue:(id)object forKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(aKey != nil);
	[super takeContextValue:object forKey:aKey];
	NSString * fileName = [[self originalFileName] stringByStandardizingPath];// not the file name!
	if(![fileName length])
		return;
	id projectDocument = [self project];
	NSString * fileKey = [projectDocument keyForFileName:fileName];
	if([fileKey length])
	{
		id server = [[projectDocument implementation] iVarContextKeyedFiles];
		NSMutableDictionary * D = [[[server objectForKey:fileKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
		id old = [D objectForKey:aKey];
		if(![object isEqual:old])
		{
			if(object)
			{
				[D setObject:object forKey:aKey];
				[server setObject:D forKey:fileKey];
				NSString * extension = [fileName pathExtension];
				server = [[projectDocument implementation] iVarContextExtensions];
				D = [[[server objectForKey:extension] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
				[D setObject:object forKey:aKey];
				[server setObject:D forKey:extension];
				NSString * type = [self fileType];
				server = [[projectDocument implementation] iVarContextTypes];
				D = [[[server objectForKey:type] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
				[D setObject:object forKey:aKey];
				[server setObject:D forKey:type];
			}
			else
			{
				[D removeObjectForKey:aKey];
				[server setObject:D forKey:fileKey];
				NSString * extension = [fileName pathExtension];
				server = [[projectDocument implementation] iVarContextExtensions];
				D = [[[server objectForKey:extension] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
				[D removeObjectForKey:aKey];
				[server setObject:D forKey:extension];
				NSString * type = [self fileType];
				server = [[projectDocument implementation] iVarContextTypes];
				D = [[[server objectForKey:type] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
				[D removeObjectForKey:aKey];
				[server setObject:D forKey:type];
			}
		}
	}
	else if(projectDocument)
	{
		iTM2_LOG(@"*** ERROR:the project %@ does not seem to own the document %@ at %@.", projectDocument, self, [self fileName]);
//iTM2_LOG([projectDocument keyForFileName:fileName]);
	}
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
    return;
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
	iTM2ProjectDocument * projectDocument = [self project];
	if([[projectDocument fileName] belongsToExternalProjectsDirectory])
	{
		return [super newRecentDocument];
	}
    return projectDocument? [projectDocument newRecentDocument]:[super newRecentDocument];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowsMenuItemTitle
- (NSString *)windowsMenuItemTitle;
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

#import <iTM2Foundation/iTM2DocumentKit.h>

@implementation iTM2PDocumentController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[iTM2PDocumentController poseAsClass:[iTM2DocumentController class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addDocument:
- (void)addDocument:(NSDocument *)document;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3:07/26/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super addDocument:document];
	[SPC registerProject:document];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeDocument:
- (void)removeDocument:(NSDocument *)document;
/*"Returns the contextInfo of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3:07/26/2003
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openDocumentWithContentsOfURL:display:error:
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)display error:(NSError **)outError;
/*"This one is responsible of the management of the project, including the wrapper.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3:07/26/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outError)
		*outError = nil;
	if(![absoluteURL isFileURL])
	{// I only catch file URLs
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outError];
	}
	NSString * fileName = [[absoluteURL path] stringByStandardizingPath];// not a link!
	if(![fileName length])
	{
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outError];
	}
	// documents are either
	// - already open
	// - wrappers
	// - projects
	// - directories that once were wrappers
	// - directories that once were projects
	// - other
	id D;
	// A - is it an already open document?
	if(D = [self documentForURL:absoluteURL])
	{
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outError];
	}
	BOOL isDirectory = NO;
	if(![DFM fileExistsAtPath:fileName isDirectory:&isDirectory])
	{
		iTM2_OUTERROR(2,([NSString stringWithFormat:@"Missing file at\n%@",absoluteURL]),nil);
		return nil;
	}
	NSURL * url = nil;
//iTM2_LOG(@"0");
		// B - is it a wrapper document?
	if([SWS isWrapperPackageAtPath:fileName])
	{
		NSString * projectName = [SPC getProjectNameInWrapperForFileNameRef:&fileName error:outError];
		if([projectName length])
		{
			NSAssert1(![SWS isWrapperPackageAtPath:projectName], @"%@\nshould not be a wrapper package.", projectName);
#warning WE DO NOT MANAGE read access yet?
			// get an embedded project
			NSURL * url = [NSURL fileURLWithPath:projectName];
			NSAssert1(![url isEqual:absoluteURL], @"What is this project name:<%@>", projectName);
			return [self openDocumentWithContentsOfURL:url display:display error:outError];
		}
		else
		{
			[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
				userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Missing project inside\n%@\ndocument will open with a simple project...", fileName]
					forKey:NSLocalizedDescriptionKey]]];
			NSAssert(NO, @"Not yet implemented");
			return nil;
		}
	}
	// C - is it a project document?
	else if([SWS isProjectPackageAtPath:fileName])
	{
#warning WE DO NOT MANAGE read access yet?
		return [super openDocumentWithContentsOfURL:absoluteURL display:display error:outError];
	}
	else if(isDirectory)
	{
		// Is it a folder corresponding to a former wrapper or project which name was changed by the user?
		// This is possible because the app keeps tracks of the wrappers it opens through some indirect address.
		// trying to open a project document at the first level if any
		NSEnumerator * E = [[DFM subpathsAtPath:fileName] objectEnumerator];
		NSMutableArray * subpaths = [NSMutableArray array];
		NSString * subpath;
		while(subpath = [E nextObject])
		{
			if([[subpath pathExtension] isEqual:[self projectPathExtension]])
				[subpaths addObject:subpath];
		}
		if([subpaths count] == 1)
		{
			subpath = [subpaths lastObject];
			subpath = [fileName stringByAppendingPathComponent:subpath];
			url = [NSURL fileURLWithPath:subpath];
			return [self openDocumentWithContentsOfURL:url display:display error:outError];
		}
		else if([subpaths count])
		{
			subpath = [fileName stringByDeletingLastPathComponent];
			[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:12
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Confusing situation:too many projects in that directory, see what you can do from the Finder."]
						forKey:NSLocalizedDescriptionKey]]];
			[SWS selectFile:fileName inFileViewerRootedAtPath:subpath];
			return nil;
		}
		else
		{
			// is it still project wrapper?
			subpath = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
			subpath = [fileName stringByAppendingPathComponent:subpath];
			url = [NSURL fileURLWithPath:subpath];
			NSDictionary * dict = [NSDictionary dictionaryWithContentsOfURL:url];
			if([[dict objectForKey:@"isa"] isEqual:iTM2ProjectInfoType])
			{
				// yes this is a former project.
				// fileName should return to the old path extension
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:13
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Confusing situation:the following directory seems to be a project despite it has no %@ path extension:\n%@.",
							fileName, [SDC projectPathExtension]]
								forKey:NSLocalizedDescriptionKey]]];
			}
			else if(dict)
			{
				[SDC presentError:[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:14
						userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Something weird occurred to that forlder\n%@.", fileName]
							forKey:NSLocalizedDescriptionKey]]];
				[SWS selectFile:fileName inFileViewerRootedAtPath:subpath];
				return nil;
			}
		}
	}
	// is it associated to an already registered project?
    id projectDocument = [SPC projectForFileName:fileName];
	if(projectDocument)
    {
//iTM2_LOG(@"1");
		return [projectDocument openSubdocumentWithContentsOfURL:absoluteURL context:nil display:display error:outError];
    }
	// Did the file stored project information in its context?
	if(projectDocument = [SPC getContextProjectForFileName:fileName display:display error:outError])
    {
//iTM2_LOG(@"1");
		return [projectDocument openSubdocumentWithContentsOfURL:absoluteURL context:nil display:display error:outError];
    }
	//I needed to know if the document did not want a project,
#warning NYI:MISSING WORK HERE
	// Do I have to create a project, opening another file?
	NSString * name = [[fileName copy] autorelease];
	// What about documents in read only folders?
    if(projectDocument = [SPC newProjectForFileNameRef:&name display:display error:outError])
    {
		url = [NSURL fileURLWithPath:name];// beware:the name, not the fileName!
		return [projectDocument openSubdocumentWithContentsOfURL:url context:nil display:display error:outError];
    }
    else
    {
//iTM2_LOG(@"4");
//iTM2_END;
		url = [NSURL fileURLWithPath:fileName];
		id doc = [super openDocumentWithContentsOfURL:absoluteURL display:display error:outError];
        return doc;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentForURL:
- (id)documentForURL:(NSURL *)absoluteURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result;
    if(result = [super documentForURL:absoluteURL])
        return [[result retain] autorelease];
	if([absoluteURL isFileURL])
	{
		NSString * fileName = [absoluteURL path];
		iTM2ProjectDocument * PD = [SPC projectForFileName:fileName];
		return [PD subdocumentForFileName:fileName];
	}
	return nil;
}
@end

@implementation NSDocumentController(iTM2ProjectDocumentKit)
#pragma mark =-=-=-=-=-  NEW STUFF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectPathExtension
- (NSString *)projectPathExtension;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapperPathExtension
- (NSString *)wrapperPathExtension;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDocumentType
- (NSString *)projectDocumentType;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2ProjectDocumentType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapperDocumentType
- (NSString *)wrapperDocumentType;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2WrapperDocumentType;
}
@end

#import <iTM2Foundation/iTM2ResponderKit.h>

@interface iTM2ProjectDocumentResponder(PRIVATE)
- (BOOL)validateProjectAddCurrentDocument:(id)sender;
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
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(iTM2ProjectDocumentKit_swizzle_terminate:)replacement:@selector(terminate:)forClass:[self class]])
	{
		iTM2_LOG(@"WARNING:terminate message could not be patched...");
	}
#if 0
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(iTM2ProjectDocumentKit_swizzle_arrangeInFront:)replacement:@selector(arrangeInFront:)forClass:[self class]])
	{
		iTM2_LOG(@"WARNING:arrangeInFront message could not be patched...");
	}
#endif
	[iTM2MileStone registerMileStone:@"No installer available" forKey:@"iTM2ProjectDocumentResponder"];
	[iTM2MileStone registerMileStone:@"No project menu item localization available" forKey:@"iTM2LocalizedProjectMenuItems"];
//iTM2_END;
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
		iTM2_LOG(@"Localization BUG, the menu item with action projectCurrentAlternate:must exist and contain no %%");
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
		iTM2_LOG(@"Localization BUG, the menu item with action projectCurrentAlternate:must exist and contain no %%");
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
		iTM2_LOG(@"Localization BUG, the menu item with action projectCurrent:must exist and contain one %%@,\nand no other formating directive");
		OK = NO;
	}
	if(OK)
		[iTM2MileStone putMileStoneForKey:@"iTM2LocalizedProjectMenuItems"];
	[_iTM2CurrentProjectLocalizedFormat autorelease];
	_iTM2CurrentProjectLocalizedFormat = [proposal copy];
	if([NSApp targetForAction:@selector(performCloseProject:)])
		[iTM2MileStone putMileStoneForKey:@"iTM2ProjectDocumentResponder"];
//iTM2_LOG(@"_iTM2CurrentProjectLocalizedFormat = %@", _iTM2CurrentProjectLocalizedFormat);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ProjectDocumentKit_swizzle_terminate:
- (void)iTM2ProjectDocumentKit_swizzle_terminate:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"iTM2ApplicationIsTerminating"]];
	[self iTM2ProjectDocumentKit_swizzle_terminate:sender];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"iTM2ApplicationIsTerminating"]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ProjectDocumentKit_swizzle_arrangeInFront:
- (void)iTM2ProjectDocumentKit_swizzle_arrangeInFront:(id)sender;
/*"When I rearranged the window menu, I broke something and arrangeInFront:no longer works.
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
		if(![W isKindOfClass:[iTM2ExternalWindow class]])
			[W orderFront:sender];
	//[self iTM2ProjectDocumentKit_swizzle_arrangeInFront:(id)sender];
//iTM2_END;
    return;
}
@end

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
- (BOOL)validateProjectCurrent:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2ProjectDocument * projectDocument = [SPC projectForSource:sender];
	if(!projectDocument)projectDocument = [SPC currentProject];
//iTM2_LOG(@"[SDC currentDocument] is:%@", [SDC currentDocument]);
    if(projectDocument && ![projectDocument displayName])
    {
        iTM2_LOG(@"What is this projectDocument? %@, %@", projectDocument, [projectDocument fileName]);
		[sender setTitle:@"..."];
		return NO;
    }
    [sender setTitle:(projectDocument? [NSString stringWithFormat:_iTM2CurrentProjectLocalizedFormat, [projectDocument displayName]]
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
				NSString * path = [projectDocument absoluteFileNameForKey:key];
                [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
			}
			return;
		}
	}
	iTM2_LOG(@"*** BIG UNEXPECTED PROBLEM");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectEditDocumentUsingRepresentedInspectorMode:
- (BOOL)validateProjectEditDocumentUsingRepresentedInspectorMode:(id)sender;
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
				NSString * path = [projectDocument absoluteFileNameForKey:key];
                [sender setAttributedTitle:([DFM fileExistsAtPath:path]? nil:
                    [[[NSAttributedString alloc] initWithString:[sender title]
                        attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSColor redColor], NSForegroundColorAttributeName,
                                nil]] autorelease])];
			}
			return YES;
		}
	}
//iTM2_END;
	return YES;
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
			[currentDocument takeContextValue:nil forKey:@"_iTM2:Document With No Project"];
			[SDC removeDocument:currentDocument];
			[projectDocument addFileName:[currentDocument fileName]];
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
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocumentKit
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
			[WC validateWindowContent];
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG(@"%@ is %@", [SUD objectForKey:iTM2DontShowNoProjectNote], ([SUD boolForKey:iTM2DontShowNoProjectNote]? @"Y":@"N"));
	BOOL oldFlag = [SUD boolForKey:iTM2DontShowNoProjectNote];
	[SUD setObject:[NSNumber numberWithBool:!oldFlag] forKey:iTM2DontShowNoProjectNote];
	[sender validateWindowContent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDontShowAgain:
- (BOOL)validateToggleDontShowAgain:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG(@"%@ is %@", [SUD objectForKey:iTM2DontShowNoProjectNote], ([SUD boolForKey:iTM2DontShowNoProjectNote]? @"Y":@"N"));
	[sender setState:([SUD boolForKey:iTM2DontShowNoProjectNote]? NSOnState:NSOffState)];
	return YES;
}
@end

#import <iTM2Foundation/iTM2FileManagerKit.h>

static NSString * const iTM2ProjectIsDirectoryWrapperKey = @"iTM2ProjectIsDirectoryWrapper";

@implementation iTM2NewProjectController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileName:
- (void)setFileName:(NSString *)fileName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
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
	if([[fileName pathExtension] isEqual:[SDC wrapperPathExtension]])
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectName
- (NSString *)projectName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_ToggleProjectMode == iTM2ToggleNewProjectMode)
		return [[self projectDirName] stringByAppendingPathComponent:_NewProjectName];
	else if(_ToggleProjectMode == iTM2ToggleOldProjectMode)
		return _SelectedRow >= 0 && _SelectedRow < [_Projects count] ?
			[[_Projects objectAtIndex:_SelectedRow] objectForKey:iTM2PDTableViewPathIdentifier]:@"";
	else
		return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDirName
- (NSString *)projectDirName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
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
//iTM2_LOG(@"projectDirName is:%@", result);
	return _ProjectDirName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void)windowWillLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
			path, iTM2PDTableViewPathIdentifier,
			[availableProjects objectForKey:path], @"displayName",
			nil]];
	}
//iTM2_LOG(@"_Projects:%@", _Projects);
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowDidLoad];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (void)OK:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing for some consistency if we have to create folders at least:
	if(iTM2DebugEnabled && (_ToggleProjectMode == iTM2ToggleNewProjectMode))
	{
		NSString * name = [_NewProjectName stringByStandardizingPath];
		NSString * absolutePath = [name hasPrefix:@"/"]? name:
					[[[self projectDirName] stringByAppendingPathComponent:name] stringByStandardizingPath];
		if([DFM fileExistsAtPath:absolutePath isDirectory:nil])
			goto more;

		NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Create Project Panel", iTM2ProjectTable, myBUNDLE, ""),
				nil,// localized OK
				nil,
				NSLocalizedStringFromTableInBundle(@"Cancel", iTM2ProjectTable, myBUNDLE, ""),
				[sender window],
				self,
				NULL,
				@selector(createProjectSheetDidDismiss:returnCode:irrelevant:),
				nil,
				NSLocalizedStringFromTableInBundle(@"Create project:\n%@?", iTM2ProjectTable, myBUNDLE, ""),
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_ToggleProjectMode = iTM2ToggleNewProjectMode;
	[sender validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNewProject:
- (BOOL)validateToggleNewProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_IsDirectoryWrapper = !_IsDirectoryWrapper;
	[sender validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDirectoryWrapper:
- (BOOL)validateToggleDirectoryWrapper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * senderString = [[sender stringValue] stringByDeletingPathExtension];
	if([senderString length])
	{
		NSString * new = [senderString stringByAppendingPathExtension:[SDC projectPathExtension]];
		if(![new isEqual:_NewProjectName])
		{
			[_NewProjectName autorelease];
			_NewProjectName = [new copy];
			[sender validateWindowContent];
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNewProjectNameEdited:
- (BOOL)validateNewProjectNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_ToggleProjectMode = iTM2ToggleOldProjectMode;
	[sender validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOldProject:
- (BOOL)validateToggleOldProject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 2.0: Tue Nov  8 09:18:47 GMT 2005
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
- 2.0: Tue Nov  8 09:18:47 GMT 2005
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
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
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [_Projects count]>0;
}
@end

#warning THIS SEEMS TO BE A BUG only while DEBUGGING
// BREAK at the length while debugging step by step
#if 1
@implementation NSObject(DEBUG)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  length
- (int)length;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return 0;
}
@end
#endif

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
    return [[self fileName] belongsToExternalProjectsDirectory]? nil:self;
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
			[projectDocument setFileName:new];
			[projectDocument updateChangeCount:NSChangeCleared];
			NSEnumerator * E = [[projectDocument subdocuments] objectEnumerator];
			NSDocument * D;
			while(D = [E nextObject])
			{
				NSString * k = [projectDocument keyForSubdocument:D];
				if([k length])
				{
					[D setFileName:[projectDocument absoluteFileNameForKey:k]];
				}
				[D updateChangeCount:NSChangeCleared];
			}
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeSafelyToURL:ofType:forSaveOperation:error:
- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError
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
		if([src isEqual:dest])
		{
			iTM2_LOG(@"*** WARNING:You gave twice the same name! (%@)", src);
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
		if([src isEqual:dest])
		{
			iTM2_LOG(@"*** WARNING:You gave twice the same name! (%@)", src);
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
		iTM2_LOG(@"*** ERROR:Operation not supported, report BUG");
		return NO;
	}
}
@end

@implementation NSString(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  externalProjectsDirectory
+ (NSString *)externalProjectsDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * path = nil;
	if(!path)
	{
		path = [[[NSBundle mainBundle] pathForSupportDirectory:@"Projects.put_aside" inDomain:NSUserDomainMask create:YES] copy];
		NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:[DFM fileAttributesAtPath:path traverseLink:NO]];
		[attributes setObject:[NSNumber numberWithBool:YES] forKey:NSFileExtensionHidden];
		[DFM changeFileAttributes:attributes atPath:path];
	}
	return path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  belongsToExternalProjectsDirectory
-(BOOL)belongsToExternalProjectsDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * externalProjectsDirectory = [NSString externalProjectsDirectory];
	NSArray * components = [externalProjectsDirectory pathComponents];
	NSArray * myComponents = [self pathComponents];
	if([myComponents count] > [components count])
	{
//iTM2_END;
		NSRange range = NSMakeRange(0,[components count]);
		myComponents = [myComponents subarrayWithRange:range];
		return [components isEqual:myComponents];
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringByStrippingExternalProjectsDirectory
-(NSString *)stringByStrippingExternalProjectsDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * externalProjectsDirectory = [NSString externalProjectsDirectory];
	NSArray * components = [externalProjectsDirectory pathComponents];
	NSArray * myComponents = [self pathComponents];
	if([myComponents count] > [components count])
	{
		NSRange range = NSMakeRange(0,[components count]);
		if([components isEqual:[myComponents subarrayWithRange:range]])
		{
			range = NSMakeRange([components count],[myComponents count]-[components count]);
			myComponents = [myComponents subarrayWithRange:range];
//iTM2_END;
			return [[NSOpenStepRootDirectory()stringByAppendingPathComponent:[NSString pathWithComponents:myComponents]] stringByStandardizingPath];
		}
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosedProjectFileNames
- (NSArray *) enclosedProjectFileNames;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * projects = [NSMutableArray array];
	NSString * projectPathExtension = [SDC projectPathExtension];
	NSString * file = nil;
	NSDirectoryEnumerator *dirEnum = [DFM enumeratorAtPath:self];
	while (file = [dirEnum nextObject])
	{
		if ([[file pathExtension] isEqualToString:projectPathExtension])
		{
			[projects addObject:file];
		}
	}
//iTM2_END;
	return projects;
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
	if([extension isEqual:requiredExtension])
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosingProjectFileName
- (NSString *)enclosingProjectFileName;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [self stringByStandardizingPath];
	NSString * requiredExtension = [SDC projectPathExtension];
	NSString * extension;
up:
	extension = [fileName pathExtension];
	if([extension isEqual:requiredExtension])
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
@end

@implementation NSWorkspace(iTM2ProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isProjectPackageAtPath:
- (BOOL)isProjectPackageAtPath:(NSString *)fullPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fullPath length])
		return NO;
	if([self isFilePackageAtPath:fullPath])
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
		return [[fullPath pathExtension] isEqual:iTM2ProjectPathExtension];
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isWrapperPackageAtPath:
- (BOOL)isWrapperPackageAtPath:(NSString *)fullPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if([self isFilePackageAtPath:fullPath])
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
		return [[fullPath pathExtension] isEqual:iTM2WrapperPathExtension];
	}
//iTM2_END;
    return NO;
}
@end
