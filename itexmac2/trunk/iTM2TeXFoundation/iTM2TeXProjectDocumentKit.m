/*
//
//  @version Subversion: $Id$ 
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

#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>
//#import <iTM2TeXFoundation/iTM2TeXProjectTaskKit.h>

NSString * const iTM2TeXProjectInfoType = @"info";// = iTM2ProjectInfoType

NSString * const iTM2TeXProjectInfoComponent = @"Info";// = iTM2ProjectInfoComponent, unused

NSString * const iTM2TeXProjectTable = @"TeX Project";

NSString * const iTM2TeXProjectInspectorType = @"TeX Project Type";

NSString * const iTM2TeXPCachedKeysKey = @"info_cachedKeys";

NSString * const TWSMasterFileKey = @"main";

NSString * const iTM2TeXWrapperDocumentType = @"TeX Project Wrapper";
NSString * const iTM2TeXProjectDocumentType = @"TeX Project Document";
NSString * const iTM2TeXWrapperPathExtension = @"texd";
NSString * const iTM2TeXProjectPathExtension = @"texp";

@interface NSDocumentController_iTM2TeXProject:iTM2DocumentController
@end
@implementation NSDocumentController_iTM2TeXProject
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
	[NSDocumentController_iTM2TeXProject poseAsClass:[iTM2DocumentController class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
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
	return iTM2TeXProjectPathExtension;
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
	return iTM2TeXWrapperPathExtension;
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
    return iTM2TeXProjectDocumentType;
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
    return iTM2TeXWrapperDocumentType;
}
@end

NSString * const iTM2TeXProjectBaseComponent = @"Base Projects.localized";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectDocumentKit
/*"Description forthcoming."*/
@implementation iTM2TeXProjectDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	NSString * userLibraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSString * string = [[[userLibraryPath stringByAppendingPathComponent:@"TeX"] stringByAppendingPathComponent:@"bin"] stringByAppendingPathComponent:@"iTeXMac2 edit -line %d -file %s"];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                    string, @"TEXEDIT",
                    string, @"MPEDIT",
                    @"NO", @"iTM2_BIB_All",
                    NSTemporaryDirectory(), @"TEXMFOUTPUT",
					[iTM2StringFormatController nameOfCoreFoundationStringEncoding:CFStringConvertNSStringEncodingToEncoding(NSMacOSRomanStringEncoding)], TWSStringEncodingFileKey,
					@"\n", TWSEOLFileKey,
                    nil]];
    NSString * path = [SUD stringForKey:@"TEXMFOUTPUT"];
    NSFileManager * DM = DFM;
    BOOL isDirectory = NO;
    if([path length])
    {
        NSString * resolved = [path stringByResolvingSymlinksAndFinderAliasesInPath];
        if([[[DM fileAttributesAtPath:resolved traverseLink:NO] objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink])
        {
            resolved = [@"/private" stringByAppendingPathComponent:resolved];
        }
        if(![DM fileExistsAtPath:resolved isDirectory:&isDirectory])
            isDirectory = [DM createDirectoryAtPath:resolved attributes:nil];
        if(!isDirectory)
        {
            NSBeginAlertSheet(NSLocalizedStringFromTableInBundle(@"Bad TEXMFOUTPUT", @"Project", [self classBundle], nil),
        nil, nil, nil, nil, nil, NULL, NULL, nil,//(void *) TS,
    NSLocalizedStringFromTableInBundle(@"Bad TEXMFOUTPUT provided\n%@", @"Project", [self classBundle], ""), path);
            [SUD removeObjectForKey:@"TEXMFOUTPUT"];
        }
    }
    if(!isDirectory)// twice...
    {
        NSArray * RA = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if([RA count])
        {
            path = [[[RA objectAtIndex:0] stringByAppendingPathComponent:@"TeX"] stringByStandardizingPath];
                if(![DM fileExistsAtPath:path isDirectory:&isDirectory])
                isDirectory = [DM createDirectoryAtPath:path attributes:nil];
            if(isDirectory)
            {
                if([DM isReadableFileAtPath:path] && [DM isWritableFileAtPath:path])
                {
                    path = [[path stringByAppendingPathComponent:@"Default Output"] stringByStandardizingPath];
                    if(![DFM fileExistsAtPath:path isDirectory:&isDirectory])
                        isDirectory = [DFM createDirectoryAtPath:path attributes:nil];
                    if(isDirectory && [DM isReadableFileAtPath:path] && [DM isWritableFileAtPath:path])
                        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                            path,  @"TEXMFOUTPUT",
                                nil]];
                }
            }
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDocumentsInspector
- (id)projectDocumentsInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self inspectorAddedWithMode:[iTM2TeXSubdocumentsInspector inspectorMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  close
- (void)close;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[DFM removeFileAtPath:[[self fileName] stringByAppendingPathComponent:@".iTM2"] handler:NULL];// this directory was created by iTeXMac2
	[super close];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= needsToUpdate
- (BOOL)needsToUpdate;
/*"The project is known to be modified externally (see the .iTM folder). Do not update.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wasNotModified
- (BOOL)wasNotModified;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setWasNotModified:
- (void)setWasNotModified:(BOOL)yorn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithBool:yorn]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  realMasterFileKey
- (NSString *)realMasterFileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [IMPLEMENTATION modelValueForKey:TWSMasterFileKey ofType:iTM2TeXProjectInfoType];
}
#pragma mark =-=-=-=-=-  TWS Support
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  masterFileKey
- (NSString *)masterFileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [IMPLEMENTATION modelValueForKey:TWSMasterFileKey ofType:iTM2TeXProjectInfoType];
	if([key isEqualToString:@"...iTM2FrontDocument"])
	{
		// get the front most document of the project
		NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * W;
		while(W = [E nextObject])
		{
			NSDocument * D = [[W windowController] document];
			if([D isEqual:self])
			{
				return @"";
			}
			if([[SPC projectForSource:D] isEqual:self])
			{
				return [self keyForFileName:[D fileName]];
			}
		}
		return @"";
	}
	if([key length])
		return key;
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self allKeys]];
	[Ks removeObject:[self keyForFileName:[self fileName]]];
	if([Ks count] == 1)
	{
		NSString * fileKey = [Ks lastObject];
		[IMPLEMENTATION takeModelValue:fileKey forKey:TWSMasterFileKey ofType:iTM2TeXProjectInfoType];
		return fileKey;
	}
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMasterFileKey:
- (void)setMasterFileKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([key isEqualToString:@"...iTM2FrontDocument"] || [self relativeFileNameForKey:key])
	{
		[IMPLEMENTATION takeModelValue:key forKey:TWSMasterFileKey ofType:iTM2TeXProjectInfoType];
	}
	else
	{
		iTM2_LOG(@"Only file name keys are authorized here, got %@ not in %@", key, [self allKeys]);
	}
    return;
}
#pragma mark =-=-=-=-=-  SAVE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateBaseProjectsCompleteWriteToURL:ofType:error:
- (BOOL)updateTeXBaseProjectsCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([absoluteURL isFileURL])
	{
		NSString * path = [absoluteURL path];
		NSString * prefix = [[NSBundle mainBundle] pathForSupportDirectory:iTM2TeXProjectBaseComponent inDomain:NSUserDomainMask create:YES];
		if([path hasPrefix:prefix])
		{
			[SPC updateTeXBaseProjectsNotified:nil];
		}
	}
//iTM2_END;
    return YES;
}
@end

//#import <iTM2Foundation/iTM2ValidationKit.h>
//#import <iTM2Foundation/iTM2WindowKit.h>

@implementation iTM2TeXPFilesWindow
@end

//#import <iTM2Foundation/iTM2TextDocumentKit.h>

NSString * iTM2ProjectLocalizedChooseMaster = nil;

@implementation iTM2TeXSubdocumentsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2SubdocumentsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowFrameIdentifier
- (NSString *)windowFrameIdentifier;
/*"YESSSS.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"TeX Project Files";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
#pragma mark <<<<  HUNTING
#ifndef HUNTING
#pragma mark =-=-=-=-=-  UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  help:
- (IBAction)help:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectPathEdited:
- (IBAction)projectPathEdited:(id) sender;
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
- (BOOL)validateProjectPathEdited:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [[self document] fileName];
	if([fileName belongsToFarawayProjectsDirectory])
	{
		fileName = [fileName stringByStrippingFarawayProjectsDirectory];
		fileName = [fileName stringByDeletingLastPathComponent];
		fileName = [fileName stringByDeletingLastPathComponent];
		fileName = [@"..." stringByAppendingPathComponent:fileName];
	}
    [sender setStringValue:([fileName length]?fileName:([[self document] displayName]?:@""))];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseMainFile:
- (IBAction)chooseMainFile:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// just a message catcher
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseMainFile:
- (BOOL)validateChooseMainFile:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender %@", sender);
    if(![sender isKindOfClass:[NSPopUpButton class]])
        return NO;
	NSMenu * senderMenu = [sender menu];
	NSMenuItem * frontDocumentMenuItem = [[senderMenu itemWithRepresentedObject:@"...iTM2FrontDocument"] copy];
	if(!frontDocumentMenuItem)
	{
		frontDocumentMenuItem = [(NSMenuItem *)[senderMenu itemWithTag:-1] copy];
		[frontDocumentMenuItem setRepresentedObject:@"...iTM2FrontDocument"];
	}
	[frontDocumentMenuItem setState:NSOffState];
	[frontDocumentMenuItem setAction:NULL];
	[frontDocumentMenuItem setTarget:nil];
    [sender removeAllItems];// now frontDocumentMenuItem is mine only
	[sender addItemWithTitle:iTM2ProjectLocalizedChooseMaster];
	[senderMenu addItem:[NSMenuItem separatorItem]];
//	[[sender lastItem] setAction:@selector(takeMainFileFromRepresentedObject:)];
//	[[sender lastItem] setTarget:self];
    NSArray * fileKeys = [self orderedFileKeys];
    int row = 0;
    iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSString * fileKey = nil;
    while(row<[fileKeys count])
    {
        fileKey = [fileKeys objectAtIndex:row];
        if([fileKey length])
        {
            NSString * FN = [project relativeFileNameForKey:fileKey];
            if([FN length])
            {
                [sender addItemWithTitle:FN];
				id item = [sender lastItem];
                [item setRepresentedObject:[[fileKey copy] autorelease]];
                [item setAction:@selector(takeMainFileFromRepresentedObject:)];
                [item setTarget:self];
            }
        }
        ++row;
    }
    if([sender numberOfItems] > 0)
	{
		[senderMenu addItem:[NSMenuItem separatorItem]];
	}
	unsigned lastIndex = [sender numberOfItems];
	if(frontDocumentMenuItem)
	{
		[senderMenu addItem:frontDocumentMenuItem];
		[frontDocumentMenuItem autorelease];
		id item = [sender lastItem];
		[item setAction:@selector(takeMainFileFromRepresentedObject:)];
		[item setTarget:self];
	}
	fileKey = [project realMasterFileKey];
	int idx = [sender indexOfItemWithRepresentedObject:fileKey];
	if(idx < 0)
	{
		;
	}
	else if	(idx<[sender numberOfItems])
	{
		[sender selectItemAtIndex:idx];
		return YES;
	}
	[sender selectItemAtIndex:lastIndex];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMainFileFromRepresentedObject:
- (IBAction)takeMainFileFromRepresentedObject:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
    NSString * oldK = [project realMasterFileKey];
    NSString * newK = [sender representedString];
    if(![oldK isEqualToString:newK])
    {
        [project setMasterFileKey:newK];
        [project updateChangeCount:NSChangeDone];
        [self validateWindowContent];
    }
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileNameEdited:
- (IBAction)fileNameEdited:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int row = [[self documentsView] selectedRow];
	NSArray * orderedFileKeys = [self orderedFileKeys];
    if(row < 0 || row >= [orderedFileKeys count])
	{
        return;
	}
    else if(row)
    {
		NSString * key = [orderedFileKeys objectAtIndex:row];
		iTM2ProjectDocument * PD = [self document];
        NSString * oldRelative = [PD relativeFileNameForKey:key];
        if(![oldRelative length])
		{
			return;
		}
		NSString * newRelative = [sender stringValue];
		if([newRelative pathIsEqual:oldRelative])
		{
			return;
		}
		NSString * projectName = [PD fileName];
		NSString * dirName = [projectName stringByDeletingLastPathComponent];
		if([dirName belongsToFarawayProjectsDirectory])
		{
			dirName = [dirName stringByDeletingLastPathComponent];
			dirName = [dirName stringByStrippingFarawayProjectsDirectory];
		}
		NSString * new = [dirName stringByAppendingPathComponent:newRelative];
		new = [new stringByStandardizingPath];
		// is this file acceptable?
		newRelative = [new stringByAbbreviatingWithDotsRelativeToDirectory:dirName];
		NSBundle * B = [iTM2ProjectDocument classBundle];
		if([newRelative hasPrefix:@".."])
		{
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Bad name", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				[self window],
				nil, NULL, NULL,
				nil,// will be released below
				NSLocalizedStringFromTableInBundle(@"The name %@ must not contain \"..\".", iTM2ProjectTable, B, ""),
				new);
			return;
		}
		NSString * old = [PD absoluteFileNameForKey:key];
		old = [old stringByStandardizingPath];
		if(![DFM fileExistsAtPath:old])
		{
			// nothing to copy
			return;
		}
		NSDocument * subDocument = [PD subdocumentForFileName:old];
		if([subDocument isDocumentEdited])
		{
			return;
		}
		if([old pathIsEqual:new])
		{
			return;
		}
		NSString * newKey = [PD keyForFileName:new];
		if([newKey length])
		{
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Name conflict", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				[self window],
				nil, NULL, NULL,
				nil,// will be released below
				NSLocalizedStringFromTableInBundle(@"The name %@ is already used.", iTM2ProjectTable, B, ""),
				new);
			return;
		}
		if([DFM fileExistsAtPath:new])
		{
			// there is a possible conflict
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Naming problem", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				[self window],
				nil, NULL, NULL,
				nil,
				NSLocalizedStringFromTableInBundle(@"Already existing file at\n%@", iTM2ProjectTable, B, ""),
				new);
			return;
		}
		NSError * localError = nil;
		if([DFM createDeepDirectoryAtPath:[new stringByDeletingLastPathComponent] attributes:nil error:&localError])
		{
			if(![DFM movePath:old toPath:new handler:nil])
			{
				NSBeginAlertSheet(
					NSLocalizedStringFromTableInBundle(@"Naming problem", iTM2ProjectTable, B, ""),
					nil, nil, nil,
					[self window],
					nil, NULL, NULL,
					nil,// will be released below
					NSLocalizedStringFromTableInBundle(@"A file could not move.", iTM2ProjectTable, B, ""));
				return;
			}
			[subDocument setFileURL:[NSURL fileURLWithPath:new]];// before the project is aware of a file change
			[PD setFileName:new forKey:key makeRelative:YES];// after the document name has changed
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Name successfully changed from %@ to %@", old, new);
			}
		}
		else
		{
			if(localError)
			{
				[SDC presentError:localError];
			}
			return;
		}
		[sender validateWindowContent];
    }
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFileNameEdited:
- (BOOL)validateFileNameEdited:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL editable = NO;
	NSTableView * DV = [self documentsView];
    int row = [DV selectedRow];
    NSString * title = nil;
	NSBundle * B = [iTM2ProjectDocument classBundle];
    if(row < 0 || row >= [DV numberOfRows])
	{
        title = NSLocalizedStringFromTableInBundle(@"No selection", iTM2ProjectTable, B, "Description Forthcoming");
	}
    else if(row)
    {
		id DS = [DV dataSource];
		NSTableColumn * TC = [DV tableColumnWithIdentifier:@"path"];
        title = [DS tableView:DV objectValueForTableColumn:TC row:row];
        if([title length])
		{
			NSArray * fileKeys = [self orderedFileKeys];
			NSString * key = [fileKeys objectAtIndex:row];
			iTM2ProjectDocument * PD = [self document];
			NSDocument * D = [PD subdocumentForKey:key];
			editable = ![D isDocumentEdited];
		}
        else
		{
            title = NSLocalizedStringFromTableInBundle(@"Multiple selection", iTM2ProjectTable, B, "Description Forthcoming");
		}
    }
    else
	{
        title = NSLocalizedStringFromTableInBundle(@"Default", iTM2ProjectTable, B, "Description Forthcoming");
	}
    [sender setStringValue:(title? :NSLocalizedStringFromTableInBundle(@"Erreur", iTM2ProjectTable, B, "Description Forthcoming"))];
	[sender setEditable:editable];
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseStringEncoding:
- (IBAction)chooseStringEncoding:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// message catcher
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseStringEncoding:
- (BOOL)validateChooseStringEncoding:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		// the menu is 
		// an optional "Multiple Selection" dimmed item
		// a "Default Encoding"
		// the list of preferred encoding
		// other encodings if they are not in the list
		// rules for disabling
		// one of the selected items does not correspond to a text file nor the "default".
		// rules for "Multiple Selection" (2 items are selected at least indeed)
		// If a file has no encoding set, it inherites from the setting of the "Defaults" file, with the iTM2ProjectDefaultsKey
		// one of the following conditions is fullfilled
		// - The Defaults is selected
		// - All the selected items do not have the same setting.
        if([[sender menu] numberOfItems] < 2)
		{
			[sender setMenu:[iTM2StringFormatController stringEncodingMenuWithAction:@selector(takeStringEncodingFromTag:) target:self]];
		}		
		// removing all the items with a iTM2_noop:action: this is mainly the "Multiple Selection" item
		NSMenu * M = [sender menu];
		NSEnumerator * E = [[M itemArray] objectEnumerator];
		NSMenuItem * MI;
		SEL noop = @selector(iTM2_noop:);
		while(MI = [E nextObject])
		{
			if([MI action] == noop)
				[M removeItem:MI];
		}
		[M cleanSeparators];
		// updating the Defaults menu
        iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
        NSArray * fileKeys = [self orderedFileKeys];
		NSString * fileKey = [fileKeys objectAtIndex:0];
		NSString * stringEncodingName = nil;
		NSStringEncoding encoding = 0;
		NSString * title = nil;
		SEL takeStringEncodingFromDefaults = @selector(takeStringEncodingFromDefaults:);
		stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
		encoding = [NSString stringEncodingWithName:stringEncodingName];
		title = [NSString localizedNameOfStringEncoding:encoding];
		title = [NSString stringWithFormat:iTM2StringEncodingDefaultFormat, title];
		if(!(MI = [M itemWithAction:takeStringEncodingFromDefaults]))
		{
			MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title
						action:takeStringEncodingFromDefaults keyEquivalent:[NSString string]] autorelease];
			[MI setTarget:self];
			[MI setEnabled:YES];
			[M insertItem:[NSMenuItem separatorItem] atIndex:0];
			[M insertItem:MI atIndex:0];
		}
		else
		{
			[MI setTitle:title];
		}
		NSTableView * documentsView = [self documentsView];
		NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
		if(![selectedRowIndexes count])// no item selected
		{
			[sender selectItem:nil];
//iTM2_END;
			return NO;
		}
		BOOL enabled = NO;
		if([selectedRowIndexes count]>1)// no item selected
		{
			enabled = NO;
//multipleSelection:
			title = NSLocalizedStringFromTableInBundle(@"Multiple selection",iTM2ProjectTable,[NSBundle iTM2FoundationBundle],"Description Forthcoming");
			MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:noop keyEquivalent:[NSString string]] autorelease];
			[MI setTarget:nil];
			[MI setEnabled:NO];
			[M insertItem:[NSMenuItem separatorItem] atIndex:0];
			[M insertItem:MI atIndex:0];
			[sender selectItemAtIndex:0];
//iTM2_END;
			return enabled;
		}
		fileKey = iTM2ProjectDefaultsKey;
		NSNumber * N = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
		BOOL defaultIsAutoStringEncoding = [N boolValue];// beware, contextBoolForKey should be preferred, once it is well implemented
		NSString * defaultStringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];// we are expecting something
		NSAssert(defaultStringEncodingName,(@"The defaults string encoding has not been registered, some code is broken in the iTM2StringFormatterKit"));
		NSStringEncoding defaultStringEncoding = [NSString stringEncodingWithName:defaultStringEncodingName];
		unsigned int row = [selectedRowIndexes firstIndex];
		if(row == 0)
        {
			enabled = YES;
			encoding = defaultStringEncoding;
selectOneItem:
			row = [sender indexOfItemWithTag:encoding];
			if(row<0)
			{
				// no item found, one should be created
				title = [NSString localizedNameOfStringEncoding:encoding];
				title = [NSString stringWithFormat:iTM2StringEncodingDefaultFormat, title];
				MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title
						action:@selector(takeStringEncodingFromTag:) keyEquivalent:[NSString string]] autorelease];
				NSFont * F = [NSFont fontWithName:@"Helvetica-Oblique" size:[NSFont systemFontSize]*1.1];
				if(F)
				{
					NSDictionary * attrs = [NSDictionary dictionaryWithObject:F forKey:NSFontAttributeName];
					NSAttributedString * AS = [[[NSAttributedString allocWithZone:[MI zone]] initWithString:title
						attributes:attrs] autorelease];
					[MI setAttributedTitle:AS];
				}
				[MI setRepresentedObject:@"Supplemental encoding"];
				[MI setTarget:self];
				[MI setEnabled:YES];
				// where should I place this menu item?
				// this item will appear as a separated item in the list
				// to collect all the other item, I use the represented object
				NSMenuItem * mi;
				NSEnumerator * e = [[M itemArray] reverseObjectEnumerator];
				while(mi = [e nextObject])
				{
					if([[mi representedObject] isEqual:@"Supplemental encoding"])
					{
						row = [M indexOfItem:mi];
						++row;
						[M insertItem:MI atIndex:row];
						[sender selectItemAtIndex:row];
//iTM2_END;
						return enabled;
					}
				}
				row = [M numberOfItems];
				[M insertItem:MI atIndex:row];
				[M insertItem:[NSMenuItem separatorItem] atIndex:row];
			}
			[sender selectItemAtIndex:row];
//iTM2_END;
			return enabled;
		}
		
		// here is how we menage things
		// first remember the project defaults values
		// list all the selected items and record there status
		// we only have to know if there is on item in given categories
		// what is the encoding situation
		
		id document = nil;
		fileKey = [fileKeys objectAtIndex:row];
		if(document = [project subdocumentForKey:fileKey])
		{
			if([document isKindOfClass:[iTM2TextDocument class]])
			{
				N = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
				if([N boolValue])
				{
					iTM2StringFormatController * SFC = [document stringFormatter];
					encoding = [SFC stringEncoding];
					enabled = NO;
					goto selectOneItem;
				}
				
			}
		}
		NSString * fileName = [project relativeFileNameForKey:fileKey];
		if([fileName length])
		{
			Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fileName pathExtension]]];
			if([C isSubclassOfClass:[iTM2TextDocument class]])
			{
				N = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
				if([N boolValue])
				{
					[sender selectItem:nil];
//iTM2_END;
					return NO;
				}
				else if(N)
				{
bibiche:
					if(stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask])
					{
						encoding = [NSString stringEncodingWithName:stringEncodingName];
						enabled = YES;
						goto selectOneItem;
					}
					else
					{
						[sender selectItemAtIndex:0];
//iTM2_END;
						return YES;
					}
				}
				else if(defaultIsAutoStringEncoding)
				{
					[sender selectItem:nil];
//iTM2_END;
					return NO;
				}
				else
				{
					goto bibiche;
				}
			}
			else
			{// do not go further
				[sender selectItem:nil];
//iTM2_END;
				return NO;
			}
		}
		else
		{// do not go further
			[sender selectItem:nil];
//iTM2_END;
			return NO;
		}
    }
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSStringEncoding stringEncoding = [sender tag];
	unsigned int new = CFStringConvertNSStringEncodingToEncoding(stringEncoding);
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSArray * fileKeys = [self orderedFileKeys];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	unsigned int row = [selectedRowIndexes firstIndex];
	unsigned int top = [fileKeys count];
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		NSString * stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
		unsigned int old = [iTM2StringFormatController coreFoundationStringEncodingWithName:stringEncodingName];
		if(new != old)
		{
			id D = [project subdocumentForKey:fileKey];
			if([D respondsToSelector:@selector(setStringEncoding:)])
			{
				[D setStringEncoding:new];
			}
			else
			{
				stringEncodingName = [iTM2StringFormatController nameOfCoreFoundationStringEncoding:new];
				if(D)
				{
					[D takeContextValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
				}
				else
				{
					[project takePropertyValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
				}
			}
			changed = YES;
		}
		row = [selectedRowIndexes indexGreaterThanIndex:row];
	}
	if(changed)
	{
		[project updateChangeCount:NSChangeDone];		
	}
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromDefaults:
- (IBAction)takeStringEncodingFromDefaults:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSString * stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	NSStringEncoding stringEncoding = [NSString stringEncodingWithName:stringEncodingName];
	unsigned int new = CFStringConvertNSStringEncodingToEncoding(stringEncoding);
	NSArray * fileKeys = [self orderedFileKeys];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	unsigned int row = [selectedRowIndexes firstIndex];
	unsigned int top = [fileKeys count];
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
		if(stringEncodingName)
		{
			id D = [project subdocumentForKey:fileKey];
			if([D respondsToSelector:@selector(setStringEncoding:)])
			{
				[D setStringEncoding:new];
			}
			else if(D)
			{
				[D takeContextValue:nil forKey:TWSStringEncodingFileKey domain:iTM2ContextStandardLocalMask];
				[D takeContextValue:nil forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextStandardLocalMask];
			}
			else
			{
				[project takePropertyValue:nil forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
				[project takeContextValue:nil forKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
			}
			changed = YES;
		}
		row = [selectedRowIndexes indexGreaterThanIndex:row];
	}
	if(changed)
	{
		[project updateChangeCount:NSChangeDone];		
	}
	[self validateWindowContent];
//iTM2_END;
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
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSArray * fileKeys = [self orderedFileKeys];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	unsigned int row = [selectedRowIndexes firstIndex];
	unsigned int top = [fileKeys count];
	id D = nil;
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		NSString * fileName = [project relativeFileNameForKey:fileKey];
		id isAuto = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
		BOOL old = [isAuto boolValue];
		// this is a 3 states switch: YES, NO, inherited
		if([fileName length])
		{
			isAuto = isAuto?(old?[NSNumber numberWithBool:NO]:nil):[NSNumber numberWithBool:YES];
			Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fileName pathExtension]]];
			if([C isSubclassOfClass:[iTM2TextDocument class]])
			{
				if(D = [project subdocumentForKey:fileKey])
				{
					[D takeContextValue:isAuto forKey:iTM2StringEncodingIsAutoKey domain:iTM2ContextStandardLocalMask];
				}
				else
				{
					[project takeContextValue:isAuto forKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
				}
				changed = YES;
			}
		}
		else if([fileKey isEqual:iTM2ProjectDefaultsKey])
		{
			isAuto = [NSNumber numberWithBool:!old];
			changed = [project takeContextValue:isAuto forKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
		}
		row = [selectedRowIndexes indexGreaterThanIndex:row];
	}
	if(changed)
	{
		[project updateChangeCount:NSChangeDone];		
	}
	[self validateWindowContent];
//iTM2_END;
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
	// the menu is 
	// an optional "Multiple Selection" dimmed item
	// a "Default EOL"
	// the list of preferred EOL
	// other encodings if they are not in the list
	// rules for disabling
	// one of the selected items does not correspond to a text file nor the "default".
	// rules for "Multiple Selection" (2 items are selected at least indeed)
	// If a file has no encoding set, it inherites from the setting of the "Defaults" file, with the iTM2ProjectDefaultsKey
	// one of the following conditions is fullfilled
	// - The Defaults is selected
	// - All the selected items do not have the same setting.
	// updating the Defaults menu
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSArray * fileKeys = [self orderedFileKeys];
	NSString * fileKey = [fileKeys objectAtIndex:0];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	if(![selectedRowIndexes count])// no item selected
	{
//iTM2_END;
		[sender setState:NSOffState];
		return NO;
	}
	if([selectedRowIndexes count]>1)// no item selected
	{
//iTM2_END;
		[sender setState:NSMixedState];
		return NO;
	}
	fileKey = @"";
	NSString * fileName = @"";
	NSNumber * N;
	BOOL hasOn = NO;
	BOOL hasOff = NO;
	BOOL excluded = NO;
	BOOL isDefaults = NO;
	NSString * keyWithAutoDefault = nil;// the last file key having a default string encoding
	unsigned int row = [selectedRowIndexes firstIndex];
	if(row == 0)
	{
		isDefaults = YES;
		keyWithAutoDefault = [fileKeys objectAtIndex:0];
		fileKey = keyWithAutoDefault;
		row = [selectedRowIndexes indexGreaterThanIndex:row];
	}
	else
	{
		fileKey = [fileKeys objectAtIndex:row];
		fileName = [project relativeFileNameForKey:fileKey];
		if([fileName length])
		{
			Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fileName pathExtension]]];
			if([C isSubclassOfClass:[iTM2TextDocument class]])
			{
				if(N = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask])
				{
					if([N boolValue])
					{
						hasOn = YES;
					}
					else
					{
						hasOff = YES;
					}
				}
				else
				{
					keyWithAutoDefault = fileKey;
				}
			}
			else
			{
				[sender setState:NSOffState];
//iTM2_END;
				return NO;
			}
		}
		row = [selectedRowIndexes indexGreaterThanIndex:row];
	}
	// mutliple case
	// hasOn && hasOff
	BOOL x = NO;
	if(N = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:iTM2ProjectDefaultsKey domain:iTM2ContextAllDomainsMask])
	{
		x = [N boolValue];
	}
	if(isDefaults)
	{
		if(hasOn && hasOff)
		{
			// multiple case
			[sender setState:NSMixedState];
			return NO;
		}
		if(x && hasOff)
		{
			// multiple case
			[sender setState:NSMixedState];
			return NO;
		}
		else if(!x && hasOn)
		{
			// multiple case
			[sender setState:NSMixedState];
			return NO;
		}
		else if(x && hasOn)
		{
			// multiple case
			[sender setState:NSOnState];
			return NO;
		}
		else if(!x && hasOff)
		{
			// multiple case
			[sender setState:NSOffState];
			return NO;
		}
		[sender setState:(x?NSOnState:NSOffState)];
		return YES;
	}
	if(keyWithAutoDefault)
	{
		// multiple case with project defaults
		[sender setState:NSMixedState];// the string encoding popup will say if this is auto or not
		return YES;
	}
	else if(hasOn && hasOff)
	{
		// multiple case with no project defaults
		[sender setState:NSMixedState];
		return YES;
	}
	else if(hasOn)
	{
		// single case with no project defaults
		[sender setState:NSOnState];
		return YES;
	}
	else if(hasOff)
	{
		// single case with no project defaults
		[sender setState:NSOffState];
		return YES;
	}
	[sender setState:(x?NSOnState:NSOffState)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseEOL:
- (IBAction)chooseEOL:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// Just a message catcher
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseEOL:
- (BOOL)validateChooseEOL:(id) sender;
/*"Description forthcoming. This is the one in the documents list inspector.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		// the menu is 
		// an optional "Multiple Selection" dimmed item
		// a "Default EOL"
		// the list of preferred EOL
		// other encodings if they are not in the list
		// rules for disabling
		// one of the selected items does not correspond to a text file nor the "default".
		// rules for "Multiple Selection" (2 items are selected at least indeed)
		// If a file has no encoding set, it inherites from the setting of the "Defaults" file, with the iTM2ProjectDefaultsKey
		// one of the following conditions is fullfilled
		// - The Defaults is selected
		// - All the selected items do not have the same setting.
        if([[sender menu] numberOfItems] < 2)
		{
			[sender setMenu:[iTM2StringFormatController EOLMenuWithAction:@selector(takeEOLFromTag:) target:self]];
		}		
		// removing all the items with a iTM2_noop:action: this is mainly the "Multiple Selection" item
		NSMenu * M = [sender menu];
		NSEnumerator * E = [[M itemArray] objectEnumerator];
		NSMenuItem * MI;
		SEL noop = @selector(iTM2_noop:);
		while(MI = [E nextObject])
		{
			if([MI action] == noop)
				[M removeItem:MI];
		}
		[M cleanSeparators];
		// updating the Defaults menu
        iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
        NSArray * fileKeys = [self orderedFileKeys];
		NSString * fileKey = [fileKeys objectAtIndex:0];
		SEL takeEOLFromDefaults = @selector(takeEOLFromDefaults:);
		NSString * EOLName = [project propertyValueForKey:TWSEOLFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
		int EOL = [iTM2StringFormatController EOLForName:EOLName];
		unsigned int row = [sender indexOfItemWithTag:EOL];
		NSString * title = [[sender itemAtIndex:row] title];
		title = [NSString stringWithFormat:iTM2EOLDefaultFormat, title];
		if(!(MI = [M itemWithAction:takeEOLFromDefaults]))
		{
			MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title
						action:takeEOLFromDefaults keyEquivalent:[NSString string]] autorelease];
			[MI setTarget:self];
			[MI setEnabled:YES];
			[M insertItem:[NSMenuItem separatorItem] atIndex:0];
			[M insertItem:MI atIndex:0];
		}
		else
		{
			[MI setTitle:title];
		}
		NSTableView * documentsView = [self documentsView];
		NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
		if(![selectedRowIndexes count])// no item selected
		{
			[sender selectItem:nil];
//iTM2_END;
			return NO;
		}
		if([selectedRowIndexes count]>1)// no item selected
		{
			[sender selectItem:nil];
//iTM2_END;
			return NO;
		}
		fileKey = @"";
		NSString * fileName = @"";
		NSMutableSet * EOLNames = [NSMutableSet set];
		BOOL excluded = NO;
		BOOL isDefaults = NO;
		BOOL enabled = NO;
		NSString * keyWithDefault = nil;// the last file key having a default string encoding
        row = [selectedRowIndexes firstIndex];
		if(row == 0)
        {
			isDefaults = YES;
            keyWithDefault = [fileKeys objectAtIndex:0];
			fileKey = keyWithDefault;
		}
		else
        {
            fileKey = [fileKeys objectAtIndex:row];
			fileName = [project relativeFileNameForKey:fileKey];
			if([fileName length])
			{
				Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fileName pathExtension]]];
				if([C isSubclassOfClass:[iTM2TextDocument class]])
				{
					if(EOLName = [project propertyValueForKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask])
					{
						[EOLNames addObject:EOLName];
					}
					else
					{
						keyWithDefault = fileKey;
					}
				}
				else
				{
					excluded = YES;
				}
			}
			row = [selectedRowIndexes indexGreaterThanIndex:row];
		}
		if(excluded)// no item with a string encoding
		{
			[sender selectItem:nil];
//iTM2_END;
			return NO;
		}
		if([EOLNames count] == 0)
		{
			if(keyWithDefault)
			{
				fileKey = iTM2ProjectDefaultsKey;
				EOLName = [project propertyValueForKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
				EOL = [iTM2StringFormatController EOLForName:EOLName];
				if([fileKey isEqual:keyWithDefault])
				{
					// there is only one file selected and this is the defaults one
					enabled = YES;
selectOneItem:
					row = [sender indexOfItemWithTag:EOL];
					if(row<0)
					{
						// no item found, one should be created
						title = [iTM2StringFormatController nameOfEOL:EOL];
						title = [NSString stringWithFormat:iTM2EOLDefaultFormat, title];
						MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title
								action:@selector(takeEOLFromTag:) keyEquivalent:[NSString string]] autorelease];
						NSFont * F = [NSFont fontWithName:@"Helvetica-Oblique" size:[NSFont systemFontSize]];
						if(F)
						{
							NSDictionary * attrs = [NSDictionary dictionaryWithObject:F forKey:NSFontAttributeName];
							NSAttributedString * AS = [[[NSAttributedString allocWithZone:[MI zone]] initWithString:title
								attributes:attrs] autorelease];
							[MI setAttributedTitle:AS];
						}
						[MI setRepresentedObject:@"Supplemental EOL"];
						[MI setTarget:self];
						[MI setEnabled:YES];
						// where should I place this menu item?
						// this item will appear as a separated item in the list
						// to collect all the other item, I use the represented object
						NSMenuItem * mi;
						NSEnumerator * e = [[M itemArray] reverseObjectEnumerator];
						while(mi = [e nextObject])
						{
							if([[mi representedObject] isEqual:@"Supplemental EOL"])
							{
								row = [M indexOfItem:mi];
								++row;
								[M insertItem:MI atIndex:row];
								[sender selectItemAtIndex:row];
//iTM2_END;
								return enabled;
							}
						}
						row = [M numberOfItems];
						[M insertItem:MI atIndex:row];
						[M insertItem:[NSMenuItem separatorItem] atIndex:row];
					}
					[sender selectItemAtIndex:row];
//iTM2_END;
					return enabled;
				}
				if(isDefaults)
				{
					enabled = NO;
multipleSelection:
					title = NSLocalizedStringFromTableInBundle(@"Multiple selection",iTM2ProjectTable,[NSBundle iTM2FoundationBundle],"Description Forthcoming");
					MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:noop keyEquivalent:[NSString string]] autorelease];
					[MI setTarget:nil];
					[MI setEnabled:NO];
					[M insertItem:[NSMenuItem separatorItem] atIndex:0];
					[M insertItem:MI atIndex:0];
					[sender selectItemAtIndex:0];
//iTM2_END;
					return enabled;
				}
				[sender selectItemAtIndex:0];
	//iTM2_END;
				return YES;
			}
			else
			{// nothing is selected
				[sender selectItem:nil];
//iTM2_END;
				return NO;
			}
		}
		if(([EOLNames count] == 1) && !keyWithDefault )
		{// all the selected items have the same encoding
			enabled = YES;
			EOLName = [EOLNames anyObject];
			EOL = [iTM2StringFormatController EOLForName:EOLName];
			goto selectOneItem;
		}
		enabled = NO;//keyWithDefault == nil;
		goto multipleSelection;
    }
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int EOL = [sender tag];
	NSString * new = [iTM2StringFormatController terminationStringForEOL:EOL];
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSArray * fileKeys = [self orderedFileKeys];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	unsigned int row = [selectedRowIndexes firstIndex];
	unsigned int top = [fileKeys count];
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		NSString * old = [project propertyValueForKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
		if(![new isEqualToString:old])
		{
			id D = [project subdocumentForKey:fileKey];
			if([D respondsToSelector:@selector(setEOL:)])
			{
				[D setEOL:EOL];
			}
			else if(D)
			{
				[D takeContextValue:new forKey:TWSEOLFileKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
			}
			else
			{
				[project takePropertyValue:new forKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
			}
			changed = YES;
		}
		row = [selectedRowIndexes indexGreaterThanIndex:row];
	}
	if(changed)
	{
		[project updateChangeCount:NSChangeDone];		
	}
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerWillResizeContents:toSize:
- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = NSStringFromSize(contentSize);
	[self takeContextValue:string forKey:@"iTM2ProjectSubdocumentsDrawerSize" domain:iTM2ContextAllDomainsMask];
//iTM2_END;
	return contentSize;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerWillOpen:
- (void)drawerWillOpen:(NSNotification *) notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDrawer * drawer = [notification object];
    [drawer validateContent];
	NSSize contentSize = [drawer contentSize];
	NSString * string = [self contextStringForKey:@"iTM2ProjectSubdocumentsDrawerSize" domain:iTM2ContextAllDomainsMask];
	if(string)
	{
		NSRectEdge edge = [drawer preferredEdge];
		NSSize maxContentSize = [drawer maxContentSize];
		NSSize minContentSize = [drawer minContentSize];
		NSSize defaultsSize = NSSizeFromString(string);
		if((edge == NSMinXEdge) || (edge == NSMaxXEdge))
		{
			contentSize.width = MAX(minContentSize.width,defaultsSize.width);
			contentSize.width = MIN(maxContentSize.width,contentSize.width);
		}
		else
		{
			contentSize.height = MAX(minContentSize.height,defaultsSize.height);
			contentSize.height = MIN(maxContentSize.height,contentSize.height);
		}
		[drawer setContentSize:contentSize];	
	}
	else
	{
		string = NSStringFromSize(contentSize);
		[self takeContextValue:string forKey:@"iTM2ProjectSubdocumentsDrawerSize" domain:iTM2ContextAllDomainsMask];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender action] == @selector(mainFileChosen:))
		return YES;
	else
		return [super validateMenuItem:sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  interpretKeyStrokeEnter:
- (BOOL)interpretKeyStrokeEnter:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self importDocument:self];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  interpretKeyStrokeReturn:
- (BOOL)interpretKeyStrokeReturn:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self importDocument:self];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  interpretKeyStrokeBackspace:
- (BOOL)interpretKeyStrokeBackspace:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self removeDocument:self];
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
#pragma mark >>>>  HUNTING
#endif
@end


//#import <iTM2Foundation/iTM2PathUtilities.h>

@implementation iTM2MainInstaller(TeXProjectDocument)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
This message is sent at initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[iTM2MileStone registerMileStone:@"Localization is not complete" forKey:@"TeX Project Menu Items"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXProjectControllerCompleteInstallation
+ (void)iTM2TeXProjectControllerCompleteInstallation;
/*"Description forthcoming.
This message is sent at initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2TeXProjectController setSharedProjectController:
		[[[iTM2TeXProjectController alloc] init] autorelease]];// very very early in the morning!!!
    if(![[SPC baseProjects] count])
    {
        [SPC updateTeXBaseProjectsNotified:nil];
    }
	if(!iTM2ProjectLocalizedChooseMaster)
	{
		NSMenuItem * MI = [[NSApp mainMenu] deepItemWithAction:@selector(projectChooseMaster:)];
		NSString * proposal = [MI title];
		if([[proposal componentsSeparatedByString:@"%"] count] != 1)
		{
			proposal = @"Choose Master...";
			iTM2_LOG(@"Localization BUG, the menu item with action projectChooseMaster:in the iTeXMac2.nib must exist and contain one %%@,\nand no other formating directive");
		}
		else
		{
			[iTM2MileStone putMileStoneForKey:@"TeX Project Menu Items"];
		}
		[iTM2ProjectLocalizedChooseMaster autorelease];
		iTM2ProjectLocalizedChooseMaster = [proposal copy];
		NSMenu * m = [MI menu];
		[m removeItem:MI];
		[m cleanSeparators];
	}
//iTM2_END;
    return;
}
@end

@implementation iTM2TeXProjectController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateTeXBaseProjectsNotified:
- (void)updateTeXBaseProjectsNotified:(NSNotification *) irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[NSBundle mainBundle] pathForSupportDirectory:iTM2TeXProjectBaseComponent inDomain:NSUserDomainMask create:YES];
	NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:iTM2TeXProjectBaseComponent ofType:@""] reverseObjectEnumerator];
	NSString * path = nil;
	while(path = [E nextObject])
	{
		NSEnumerator * e = [[DFM directoryContentsAtPath:path] objectEnumerator];
		NSString * component = nil;
		NSString * requiredExtension = [SDC projectPathExtension];
		while(component = [e nextObject])
		{
			if([component hasPrefix:@"."])
			{
				// do nothing, this is can't be a base project
			}
			else if([[component pathExtension] pathIsEqual:requiredExtension])
			{
				NSString * core = [component stringByDeletingPathExtension];
				if(![core hasSuffix:@"~"])// this is not a backup
				{
					NSString * type = [SDC typeFromFileExtension:[component pathExtension]];
					id v = [SDC makeUntitledDocumentOfType:type error:nil];
					NSString * name = [path stringByAppendingPathComponent:component];
					NSURL * url = [NSURL fileURLWithPath:name];
					[v setFileURL:url];
					[v setFileType:type];
					if([v readFromURL:url ofType:type error:nil])
					{
						[self addBaseProject:v];
					}
					else
					{
						iTM2_LOG(@"Could not open the project document:%@", name);
					}
				}
			}
		}
	}
    return;
}
@end

@interface iTM2StringFormatController_iTM2TeXProjectDocumentKit:iTM2StringFormatController
@end

@implementation iTM2StringFormatController_iTM2TeXProjectDocumentKit
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
	[iTM2StringFormatController_iTM2TeXProjectDocumentKit poseAsClass:[iTM2StringFormatController class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOL
- (unsigned int)EOL;
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
		NSString * FN = [D fileName];
		NSString * fileKey = [P keyForFileName:FN];
		if([fileKey length])
		{
			NSString * EOLName = [P propertyValueForKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
			unsigned int EOL = [iTM2StringFormatController EOLForName:EOLName];
			return EOL == iTM2UnknownEOL? [iTM2StringFormatController EOLForName:EOLName]:EOL;
		}
	}
    return [super EOL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOL:
- (void)setEOL:(unsigned int) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setEOL:argument];
	id D = [self document];
	id P = [D project];
	NSString * FN = [D fileName];
	NSString * fileKey = [P keyForFileName:FN];
	if([fileKey length])
	{
		NSString * EOLString = [iTM2StringFormatController nameOfEOL:argument];
		[P takePropertyValue:EOLString forKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncoding
- (NSStringEncoding)stringEncoding;
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
		NSString * FN = [D fileName];
		NSString * fileKey = [P keyForFileName:FN];
		NSString * stringEncodingName = [P propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextAllDomainsMask];
		CFStringEncoding encoding = [iTM2StringFormatController coreFoundationStringEncodingWithName:stringEncodingName];
		return CFStringConvertEncodingToNSStringEncoding(encoding);
	}
    return [super stringEncoding];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncoding:
- (void)setStringEncoding:(NSStringEncoding) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super setStringEncoding:argument];
	id D = [self document];
	id P = [D project];
	NSString * fileName = [D fileName];
	NSString * fileKey = [P keyForFileName:fileName];
	if([fileKey length])
	{
		NSString * stringEncodingName = [iTM2StringFormatController nameOfCoreFoundationStringEncoding:CFStringConvertNSStringEncodingToEncoding(argument)];
		[P takePropertyValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
	}
	return;
}
@end

@implementation iTM2TeXWrapperDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  representedClass
+ (id)representedClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [iTM2TeXProjectDocument class];
}
@end

@interface NSNotificationCenter_DEBUG:NSNotificationCenter
@end
@implementation NSNotificationCenter_DEBUG
- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
{
	iTM2_LOG(@"aName is:%@", aName);
	iTM2_LOG(@"anObject is:%@", anObject);
	iTM2_LOG(@"aUserInfo is:%@", aUserInfo);
	[super postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo];
	return;
}
@end


@implementation NSWorkspace(iTM2TeXProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isTeXProjectPackageAtPath:
- (BOOL)isTeXProjectPackageAtPath:(NSString *) fullPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [fullPath length] && [self isFilePackageAtPath:fullPath] && [[fullPath pathExtension] pathIsEqual:iTM2TeXProjectPathExtension];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isTeXWrapperPackageAtPath:
- (BOOL)isTeXWrapperPackageAtPath:(NSString *) fullPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self isFilePackageAtPath:fullPath] && [[fullPath pathExtension] pathIsEqual:iTM2TeXWrapperPathExtension];
}
@end

#import <iTM2TeXFoundation/iTM2TeXDocumentKit.h>

@implementation iTM2TeXDocument(TeXProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  environmentForExternalHelper
- (NSDictionary *)environmentForExternalHelper;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:self];
	NSString * fileKey = [TPD keyForFileName:[self fileName]];
	NSString * codeset = [TPD propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
//iTM2_END;
    return [codeset length]?[NSDictionary dictionaryWithObjectsAndKeys:
		codeset,TWSStringEncodingFileKey,
			nil]:[NSDictionary dictionary];
}
@end