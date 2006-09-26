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

NSString * const iTM2TeXProjectInfoComponent = @"Info";// = iTM2ProjectInfoComponent

NSString * const iTM2TeXProjectTable = @"TeX Project";

NSString * const iTM2TeXProjectInspectorType = @"TeX Project Type";

NSString * const iTM2TeXPCachedKeysKey = @"info_cachedKeys";

NSString * const TWSMasterFileKey = @"main";
NSString * const TWSStringEncodingFileKey = @"codeset";
NSString * const TWSEOLFileKey = @"eol";

NSString * const iTM2TeXPDefaultKey = @"_";

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
        if([[[DM fileAttributesAtPath:resolved traverseLink:NO] objectForKey:NSFileType] isEqual:NSFileTypeSymbolicLink])
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
	if([key isEqual:@"...iTM2FrontDocument"])
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
		NSString * K = [Ks lastObject];
		[IMPLEMENTATION takeModelValue:K forKey:TWSMasterFileKey ofType:iTM2TeXProjectInfoType];
		return K;
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
	if([key isEqual:@"...iTM2FrontDocument"] || [self relativeFileNameForKey:key])
	{
		[IMPLEMENTATION takeModelValue:key forKey:TWSMasterFileKey ofType:iTM2TeXProjectInfoType];
	}
	else
	{
		iTM2_LOG(@"Only file name keys are authorized here, got %@ not in %@", key, [self allKeys]);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringEncodingStringForFileKey:
- (NSString *)stringEncodingStringForFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringEncodingString:forFileKey:
- (void)setStringEncodingString:(NSString *) stringEncoding forFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takePropertyValue:stringEncoding forKey:TWSStringEncodingFileKey fileKey:fileKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  EOLStringForFileKey:
- (NSString *)EOLStringForFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self propertyValueForKey:TWSEOLFileKey fileKey:fileKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEOLString:forFileKey:
- (void)setEOLString:(NSString *) EOLString forFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takePropertyValue:EOLString forKey:TWSEOLFileKey fileKey:fileKey];
    return;
}
#pragma mark =-=-=-=-=-  PROPERTIES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertyValueForKey:fileKey:
- (id)propertyValueForKey:(NSString *) key fileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self originalPropertyValueForKey:key fileKey:fileKey]?
		:[super propertyValueForKey:key fileKey:iTM2TeXPDefaultKey];
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
		fileName = [fileName stringByDeletingPathExtension];
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
	NSString * K = nil;
    while(row<[fileKeys count])
    {
        K = [fileKeys objectAtIndex:row];
        if([K length])
        {
            NSString * FN = [project relativeFileNameForKey:K];
            if([FN length])
            {
                [sender addItemWithTitle:FN];
				id item = [sender lastItem];
                [item setRepresentedObject:[[K copy] autorelease]];
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
	K = [project realMasterFileKey];
	int idx = [sender indexOfItemWithRepresentedObject:K];
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
    if(![oldK isEqual:newK])
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
		if([newRelative isEqual:oldRelative])
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
		if([old isEqual:new])
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
        title = [DS tableView:DV objectValueForTableColumn:[[DV tableColumns] lastObject] row:row];
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
        if([[sender menu] numberOfItems] < 2)
		{
			[sender setMenu:[iTM2StringFormatController stringEncodingMenuWithAction:@selector(takeStringEncodingFromTag:) target:self]];
		}		
        iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
        NSArray * fileKeys = [self orderedFileKeys];
        int row = [[self documentsView] selectedRow];
        if((row>=0) && (row<[fileKeys count]))
        {
            NSString * K = [fileKeys objectAtIndex:row];
			NSString * fileName = [project relativeFileNameForKey:K];
			if([fileName length])
			{
				Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fileName pathExtension]]];
				if(C && ![C isSubclassOfClass:[iTM2TextDocument class]])
				{
					[sender selectItem:nil];// nothing selected
					return NO;
				}
			}
			// removing all the items with a iTM2_noop:action
			NSMenu * M = [sender menu];
			NSEnumerator * E = [[M itemArray] objectEnumerator];
			NSMenuItem * MI;
			SEL action = @selector(iTM2_noop:);
			while(MI = [E nextObject])
			{
				if([MI action] == action)
					[M removeItem:MI];
			}
			[M cleanSeparators];
			NSString * stringEncoding = [project originalPropertyValueForKey:TWSStringEncodingFileKey fileKey:K];
			if(stringEncoding)
			{
				NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding([iTM2StringFormatController coreFoundationStringEncodingFromString:stringEncoding]);
				int idx = [sender indexOfItemWithTag:encoding];
				if(idx<0)
				{
					// the stringEncoding is not in the list:add it and select it
					NSString * title = [NSString stringWithFormat:iTM2StringEncodingMissingFormat, [NSString localizedNameOfStringEncoding:encoding]];
					MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:action keyEquivalent:[NSString string]] autorelease];
					[MI setTag:encoding];
					[MI setTarget:nil];
					[M insertItem:MI atIndex:0];
					[sender selectItemAtIndex:0];
					return YES;
				}
				else
					[sender selectItem:(id <NSMenuItem>)(idx>=0 && idx<[sender numberOfItems]? [sender itemAtIndex:idx]:nil)];
			}
			else
			{
				stringEncoding = [project stringEncodingStringForFileKey:K];
				NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding([iTM2StringFormatController coreFoundationStringEncodingFromString:stringEncoding]);
				NSString * title = [NSString localizedNameOfStringEncoding:encoding];
				if(![title length])
					title = [NSString stringWithFormat:@"%d", encoding];
				NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:[NSString stringWithFormat:iTM2StringEncodingDefaultFormat, title] action:action keyEquivalent:[NSString string]] autorelease];
				[MI setTarget:nil];
				[MI setEnabled:NO];
				[MI setTag:encoding];
				[[sender menu] insertItem:[NSMenuItem separatorItem] atIndex:0];
				[[sender menu] insertItem:MI atIndex:0];
				// Got once an exception for the next line:
				// Invalid parameter not satisfying: (index >= 0) && (index < (_itemArray ? CFArrayGetCount((CFArrayRef)_itemArray) : 0))
				[sender selectItemAtIndex:0];
				return YES;
			}
		}
        else
		{
//			[sender selectItem:nil]; Cocoa BUG (NSParameterAssert?)
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
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSArray * fileKeys = [self orderedFileKeys];
	int row = [[self documentsView] selectedRow];
	if((row>=0) && (row<[fileKeys count]))
	{
		NSString * K = [fileKeys objectAtIndex:row];
		unsigned int new = CFStringConvertNSStringEncodingToEncoding([sender tag]);
		unsigned int old = [iTM2StringFormatController coreFoundationStringEncodingFromString:[project originalPropertyValueForKey:TWSStringEncodingFileKey fileKey:K]];
		if(new != old)
		{
			id D = [SDC documentForFileName:[project absoluteFileNameForKey:K]];
			if([D respondsToSelector:@selector(setStringEncoding:)])
				[D setStringEncoding:new];
			[project setStringEncodingString:[iTM2StringFormatController nameOfCoreFoundationStringEncoding:new] forFileKey:K];
			[project updateChangeCount:NSChangeDone];
		}
	}
//iTM2_END;
    return;
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
        if([[sender menu] numberOfItems] < 2)
            [sender setMenu:[iTM2StringFormatController EOLMenuWithAction:@selector(takeEOLFromTag:) target:self]];
        iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
        NSArray * fileKeys = [self orderedFileKeys];
        int row = [[self documentsView] selectedRow];
        if((row>=0) && (row<[fileKeys count]))
        {
            NSString * K = [fileKeys objectAtIndex:row];
			NSString * fileName = [project relativeFileNameForKey:K];
			if([fileName length])
			{
				Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fileName pathExtension]]];
				if(C && ![C isSubclassOfClass:[iTM2TextDocument class]])
				{
					[sender selectItem:nil];// nothing selected
					return NO;
				}
			}
			// removing all the items with a iTM2_noop:action
			NSMenu * M = [sender menu];
			NSEnumerator * E = [[M itemArray] objectEnumerator];
			NSMenuItem * MI;
			SEL action = @selector(iTM2_noop:);
			while(MI = [E nextObject])
			{
				if([MI action] == action)
					[M removeItem:MI];
			}
			[M cleanSeparators];
			NSString * EOLString = [project originalPropertyValueForKey:TWSEOLFileKey fileKey:K];
            if(EOLString)
            {
                unsigned idx = [sender indexOfItemWithTag:[iTM2StringFormatController EOLForTerminationString:EOLString]];
                [sender selectItem:(id <NSMenuItem>)(idx<[sender numberOfItems]? [sender itemAtIndex:idx]:nil)];
                return YES;
            }
            else
            {
				EOLString = [project EOLStringForFileKey:K];
                unsigned idx = [sender indexOfItemWithTag:[iTM2StringFormatController EOLForTerminationString:EOLString]];
				NSString * title = [[sender itemAtIndex:idx] title];
				NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:[NSString stringWithFormat:iTM2EOLDefaultFormat, title] action:action keyEquivalent:[NSString string]] autorelease];
				[MI setTarget:nil];
				[MI setEnabled:NO];
				[[sender menu] insertItem:[NSMenuItem separatorItem] atIndex:0];
				[[sender menu] insertItem:MI atIndex:0];
				[sender selectItemAtIndex:0];
				return YES;
            }
        }
        else
		{
			[sender selectItem:nil];
            return NO;
		}
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
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
        NSArray * fileKeys = [self orderedFileKeys];
        int row = [[self documentsView] selectedRow];
        if((row>=0) && (row<[fileKeys count]))
        {
            NSString * K = [fileKeys objectAtIndex:row];
			int EOL = [[sender selectedItem] tag];
            NSString * new = [iTM2StringFormatController terminationStringForEOL:EOL];
			NSString * old = [project originalPropertyValueForKey:TWSEOLFileKey fileKey:K];
            if(![new isEqualToString:old])
            {
				id D = [SDC documentForFileName:[project absoluteFileNameForKey:K]];
				if([D respondsToSelector:@selector(setEOL:)])
					[D setEOL:EOL];
                [project setEOLString:new forFileKey:K];
                [project updateChangeCount:NSChangeDone];
            }
        }
    }
    return;
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
    [[notification object] validateContent];
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
			else if([[component pathExtension] isEqualToString:requiredExtension])
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
		NSString * name = [P EOLStringForFileKey:[P keyForFileName:[D fileName]]];
		unsigned int EOL = [iTM2StringFormatController EOLForTerminationString:name];
		return EOL == iTM2UnknownEOL? [iTM2StringFormatController EOLForName:name]:EOL;
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
	[P setEOLString:[iTM2StringFormatController nameOfEOL:argument] forFileKey:[P keyForFileName:[D fileName]]];
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
		NSString * key = [P keyForFileName:FN];
		NSString * name = [P stringEncodingStringForFileKey:key];
		CFStringEncoding encoding = [iTM2StringFormatController coreFoundationStringEncodingFromString:name];
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
	NSString * name = [iTM2StringFormatController nameOfCoreFoundationStringEncoding:CFStringConvertNSStringEncodingToEncoding(argument)];
	id D = [self document];
	id P = [D project];
	[P setStringEncodingString:name forFileKey:[P keyForFileName:[D fileName]]];
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
    return [fullPath length] && [self isFilePackageAtPath:fullPath] && [[fullPath pathExtension] isEqualToString:iTM2TeXProjectPathExtension];
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
    return [self isFilePackageAtPath:fullPath] && [[fullPath pathExtension] isEqualToString:iTM2TeXWrapperPathExtension];
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
	NSString * codeset = [TPD originalPropertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey];
//iTM2_END;
    return [codeset length]?[NSDictionary dictionaryWithObjectsAndKeys:
		codeset,TWSStringEncodingFileKey,
			nil]:[NSDictionary dictionary];
}
@end