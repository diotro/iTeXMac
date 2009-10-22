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
#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>
#import <iTM2TeXFoundation/iTM2TeXInfoWrapperKit.h>
#import <iTM2Foundation/iTM2Invocation.h>
#import <iTM2Foundation/iTM2BundleKit.h>
//#import <iTM2TeXFoundation/iTM2TeXProjectTaskKit.h>

NSString * const iTM2TeXProjectInfoComponent = @"Info";// = iTM2ProjectInfoComponent, unused

NSString * const iTM2TeXProjectTable = @"TeX Project";

NSString * const iTM2TeXProjectInspectorType = @"TeX Project Type";

NSString * const iTM2TeXPCachedKeysKey = @"info_cachedKeys";

CFStringRef const iTM2UTTypeTeXWrapper = CFSTR("org.tug.texd");
CFStringRef const iTM2UTTypeTeXProject = CFSTR("org.tug.texp");

NSString * const iTM2TeXWrapperDocumentType = @"TeX Project Wrapper";
NSString * const iTM2TeXProjectDocumentType = @"TeX Project Document";
NSString * const iTM2TeXWrapperPathExtension = @"texd";
NSString * const iTM2TeXProjectPathExtension = @"texp";

NSString * const iTM2TPDKModeKey = @"mode";
NSString * const iTM2TPDKExtensionKey = @"extension";
NSString * const iTM2TPDKPrettyExtensionKey = @"pretty_extension";
NSString * const iTM2TPDKVariantKey = @"variant";
NSString * const iTM2TPDKOutputKey = @"output";
NSString * const iTM2TPDKNameKey = @"name";

@implementation NSDocumentController(iTM2TeXProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TeXP_iTM2_projectPathExtension
- (NSString *)SWZ_iTM2TeXP_iTM2_projectPathExtension;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TeXP_iTM2_wrapperPathExtension
- (NSString *)SWZ_iTM2TeXP_iTM2_wrapperPathExtension;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TeXP_iTM2_projectDocumentType
- (CFStringRef)SWZ_iTM2TeXP_iTM2_projectDocumentType;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2UTTypeTeXProject;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TeXP_iTM2_wrapperDocumentType
- (CFStringRef)SWZ_iTM2TeXP_iTM2_wrapperDocumentType;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2UTTypeTeXWrapper;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectDocumentKit
/*"Description forthcoming."*/
@implementation iTM2TeXProjectDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smallImageLogo
+ (NSImage *)smallImageLogo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = @"showCurrentProjectSettings(small)";
	NSImage * I = [NSImage iTM2_cachedImageNamed:name];
	if([I iTM2_isNotNullImage])
	{
		return I;
	}
	I = [[NSImage iTM2_cachedImageNamed:@"showCurrentProjectSettings"] copy];
	[I iTM2_setSizeSmallIcon];
	[I setName:name];
    return I;
}
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
        NSString * resolved = [path iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
        if([[[DM attributesOfItemAtPath:resolved error:NULL] objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink])
        {
            resolved = [@"/private" stringByAppendingPathComponent:resolved];
        }
        if(![DM fileExistsAtPath:resolved isDirectory:&isDirectory])
            isDirectory = [DM createDirectoryAtPath:resolved withIntermediateDirectories:YES attributes:nil error:NULL];
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
                isDirectory = [DM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
            if(isDirectory)
            {
                if([DM isReadableFileAtPath:path] && [DM isWritableFileAtPath:path])
                {
                    path = [[path stringByAppendingPathComponent:@"Default Output"] stringByStandardizingPath];
                    if(![DFM fileExistsAtPath:path isDirectory:&isDirectory])
                        isDirectory = [DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
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
	[DFM removeItemAtPath:[[self fileName] stringByAppendingPathComponent:@".iTM2"] error:NULL];// this directory was created by iTeXMac2
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
#pragma mark =-=-=-=-=-  PROJECT HELPERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  helperProject
- (id)helperProject;
/*Decription forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setHelperProject:
- (void)setHelperProject:(id)helperProject;
/*"Decription forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(helperProject);
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  SAVE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateBaseProjectsCompleteWriteToURL:ofType:error:
- (BOOL)updateTeXBaseProjectsCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)error;
/*"Update the list of cached base projects if the receiver is a base project, ie belongs to the directory of base projects.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([absoluteURL isFileURL])
	{
		ICURegEx * RE = [[[ICURegEx alloc]
			initWithSearchPattern:[NSString stringWithFormat:@"/Library/.*/%@(?:$|/)",[iTM2ProjectBaseComponent stringByEscapingICUREControlCharacters]]
				options:0 error:nil] autorelease];
		[RE setInputString:[absoluteURL path]];
		if([RE nextMatch])
		{
			[SPC updateTeXBaseProjectsNotified:nil];
		}
	}
//iTM2_END;
    return YES;
}
@end

@implementation NSString(PRIVATE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXProjectProperties
- (NSDictionary *)TeXProjectProperties;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * mode = @"";
    NSString * output = @"";
    NSString * variant = @"";
    NSString * extension = @"";
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:@"(?:\\((.*?)\\))?([^\\+-]*)(?:\\+([^-]*))?(?:-(.*))?" options:0L error:nil] autorelease];
    NSString * name = [[self lastPathComponent] stringByDeletingPathExtension];
	[RE setInputString:name];
	if([RE nextMatch] && ([RE numberOfCaptureGroups]>3))
	{
		extension = [RE substringOfCaptureGroupAtIndex:1];
		mode = [RE substringOfCaptureGroupAtIndex:2];
		output = [RE substringOfCaptureGroupAtIndex:3];
		variant = [RE substringOfCaptureGroupAtIndex:4];
	}
	NSString * prettyExtension = NSLocalizedStringFromTableInBundle([extension lowercaseString],iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"");
    return [NSDictionary dictionaryWithObjectsAndKeys:mode, iTM2TPDKModeKey, extension, iTM2TPDKExtensionKey, prettyExtension, iTM2TPDKPrettyExtensionKey, output, iTM2TPDKOutputKey, variant, iTM2TPDKVariantKey, name, iTM2TPDKNameKey, nil];
}
@end

@implementation NSDictionary(TeXProjectProperties)
- (NSComparisonResult)compareTeXProjectProperties:(id)rhs;
{
	if(![rhs isKindOfClass:[NSDictionary class]])
	{
		return NSOrderedDescending;
	}
    NSString * lhs_mode = [self objectForKey:iTM2TPDKModeKey];
    NSString * lhs_output = [self objectForKey:iTM2TPDKOutputKey];
    NSString * lhs_variant = [self objectForKey:iTM2TPDKVariantKey];
    NSString * lhs_extension = [self objectForKey:iTM2TPDKExtensionKey];
    NSString * rhs_mode = [rhs objectForKey:iTM2TPDKModeKey];
    NSString * rhs_output = [rhs objectForKey:iTM2TPDKOutputKey];
    NSString * rhs_variant = [rhs objectForKey:iTM2TPDKVariantKey];
    NSString * rhs_extension = [rhs objectForKey:iTM2TPDKExtensionKey];
	
	if([lhs_mode isEqual:iTM2ProjectDefaultName])
	{
		if([rhs_mode isEqual:iTM2ProjectDefaultName])
		{
			// both modes are the same,
test_extension:
			if([lhs_extension isEqual:rhs_extension] || [lhs_extension isEqual:@"*"] || [rhs_extension isEqual:@"*"])
			{
				if([lhs_variant isEqual:rhs_variant] || [lhs_variant isEqual:@"*"] || [rhs_variant isEqual:@"*"])
				{
					if([lhs_output isEqual:@"*"] || [rhs_output isEqual:@"*"])
					{
						return NSOrderedSame;
					}
					return [lhs_output compare:rhs_output];
				}
				return [lhs_variant compare:rhs_variant];
			}
			return [lhs_extension compare:rhs_extension];
		}
		return NSOrderedAscending;
	}
	else if([rhs_mode isEqual:iTM2ProjectDefaultName])
	{
		return NSOrderedDescending;
	}
	else if([lhs_mode isEqual:@"Plain"] || [lhs_mode isEqual:@"TeX"])
	{
		if([rhs_mode isEqual:@"Plain"] || [rhs_mode isEqual:@"TeX"])
		{
			// both modes are the same,
			goto test_extension;
		}
		return NSOrderedAscending;
	}
	else if([rhs_mode isEqual:@"Plain"] || [rhs_mode isEqual:@"TeX"])
	{
		return NSOrderedDescending;
	}
	else if([lhs_mode isEqual:rhs_mode] || [lhs_mode isEqual:@"*"] || [rhs_mode isEqual:@"*"])
	{
		// both modes are the same,
		goto test_extension;
	}
	return [lhs_mode compare:rhs_mode];
}
- (NSString *)TeXBaseProjectName;
{
    NSString * mode = [self objectForKey:iTM2TPDKModeKey];
    NSString * output = [self objectForKey:iTM2TPDKOutputKey];
    NSString * variant = [self objectForKey:iTM2TPDKVariantKey];
    NSString * extension = [self objectForKey:iTM2TPDKExtensionKey];
	NSMutableString * result = [NSMutableString string];
	if([extension length])
	{
		[result appendFormat:@"(%@)",extension];
	}
	if([mode length])
	{
		[result appendFormat:@"%@",mode];
	}
	if([output length])
	{
		[result appendFormat:@"+%@",output];
	}
	if([variant length])
	{
		[result appendFormat:@"-%@",variant];
	}
iTM2_LOG(@"result:%@",result);
	return result;
}
@end

//#import <iTM2Foundation/iTM2ValidationKit.h>
//#import <iTM2Foundation/iTM2WindowKit.h>

@implementation iTM2TeXPFilesWindow
@end

//#import <iTM2Foundation/iTM2TextDocumentKit.h>

NSString * iTM2ProjectLocalizedChooseMaster = nil;

@implementation iTM2TeXSubdocumentsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smallImageLogo
+ (NSImage *)smallImageLogo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = @"showCurrentProjectFiles(small)";
	NSImage * I = [NSImage iTM2_cachedImageNamed:name];
	if([I iTM2_isNotNullImage])
	{
		return I;
	}
	I = [[NSImage iTM2_cachedImageNamed:@"showCurrentProjectFiles"] copy];
	[I iTM2_setSizeSmallIcon];
	[I setName:name];
    return I;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_windowFrameIdentifier
- (NSString *)iTM2_windowFrameIdentifier;
/*"YESSSS.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"TeX Project Files";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_windowPositionShouldBeObserved
- (BOOL)iTM2_windowPositionShouldBeObserved;
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
	NSURL * projectURL = [[self document] fileURL];
	NSURL * sourceURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
    [sender setStringValue:(sourceURL?[sourceURL path]:([[self document] displayName]?:@""))];
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
    NSInteger row = 0;
    iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSString * fileKey = nil;
    while(row<[fileKeys count])
    {
        fileKey = [fileKeys objectAtIndex:row];
        if([fileKey length])
        {
            NSString * FN = [project nameForFileKey:fileKey];
            if([FN length])
            {
                [sender addItemWithTitle:FN];
				id item = [sender lastItem];
                [item setRepresentedObject:[[fileKey copy] autorelease]];
                [item setAction:@selector(takeMainFileFromRepresentedObject:)];
                [item setTarget:self];// sender belongs to the receiver's window
            }
        }
        ++row;
    }
    if([sender numberOfItems] > 0)
	{
		[senderMenu addItem:[NSMenuItem separatorItem]];
	}
	NSUInteger lastIndex = [sender numberOfItems];
	if(frontDocumentMenuItem)
	{
		[senderMenu addItem:frontDocumentMenuItem];
		[frontDocumentMenuItem autorelease];
		id item = [sender lastItem];
		[item setAction:@selector(takeMainFileFromRepresentedObject:)];
		[item setTarget:self];// sender belongs to the receiver's window
	}
	fileKey = [project realMasterFileKey];
	NSInteger idx = [sender indexOfItemWithRepresentedObject:fileKey];
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
        [self iTM2_validateWindowContent];
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
    NSInteger row = [[self documentsView] selectedRow];
	NSArray * orderedFileKeys = [self orderedFileKeys];
    if(row < 0 || row >= [orderedFileKeys count])
	{
        return;
	}
    else if(row)
    {
		NSString * key = [orderedFileKeys objectAtIndex:row];
		iTM2ProjectDocument * PD = [self document];
        NSURL * oldURL = [PD URLForFileKey:key];
        if(!oldURL)
		{
			return;
		}
		if(![DFM fileExistsAtPath:[oldURL path]])
		{
			// nothing to copy
			return;
		}
		NSDocument * subDocument = [PD subdocumentForURL:oldURL];
		if([subDocument isDocumentEdited])
		{
			return;
		}
		NSString * newRelative = [sender stringValue];
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
				newRelative);
			return;
		}
		NSURL * newURL = [NSURL iTM2_URLWithPath:newRelative relativeToURL:[PD contentsURL]];
		if([newURL iTM2_isEquivalentToURL:oldURL])
		{
			return;
		}
		NSString * newKey = [PD fileKeyForURL:newURL];
		if([newKey length])
		{
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Name conflict", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				[self window],
				nil, NULL, NULL,
				nil,// will be released below
				NSLocalizedStringFromTableInBundle(@"The name %@ is already used.", iTM2ProjectTable, B, ""),
				[newURL path]);
			return;
		}
		if([DFM fileExistsAtPath:[newURL path]])
		{
			// there is a possible conflict
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Naming problem", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				[self window],
				nil, NULL, NULL,
				nil,
				NSLocalizedStringFromTableInBundle(@"Already existing file at\n%@", iTM2ProjectTable, B, ""),
				[newURL path]);
			return;
		}
		NSError * localError = nil;
		if([DFM createDirectoryAtPath:[[newURL iTM2_parentDirectoryURL] path] withIntermediateDirectories:YES attributes:nil error:&localError])
		{
			if(![DFM moveItemAtPath:[oldURL path] toPath:[newURL path] error:NULL])
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
			[subDocument setFileURL:newURL];// before the project is aware of a file change
			[PD setURL:newURL forFileKey:key];// after the document name has changed
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Name successfully changed from %@ to %@", [oldURL path], [newURL path]);
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
		[sender iTM2_validateWindowContent];
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
    NSInteger row = [DV selectedRow];
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
			NSDocument * D = [PD subdocumentForFileKey:key];
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
			[sender setMenu:[iTM2StringFormatController stringEncodingMenuWithAction:@selector(takeStringEncodingFromTag:) target:self]];// the menu belongs to self (the target)
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
			MI = [[[NSMenuItem alloc] initWithTitle:title
						action:takeStringEncodingFromDefaults keyEquivalent:[NSString string]] autorelease];
			[MI setTarget:self];// MI belongs to the receiver's window
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
			MI = [[[NSMenuItem alloc] initWithTitle:title action:noop keyEquivalent:[NSString string]] autorelease];
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
		NSUInteger row = [selectedRowIndexes firstIndex];
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
				MI = [[[NSMenuItem alloc] initWithTitle:title
						action:@selector(takeStringEncodingFromTag:) keyEquivalent:[NSString string]] autorelease];
				NSFont * F = [NSFont fontWithName:@"Helvetica-Oblique" size:[NSFont systemFontSize]*1.1];
				if(F)
				{
					NSDictionary * attrs = [NSDictionary dictionaryWithObject:F forKey:NSFontAttributeName];
					NSAttributedString * AS = [[[NSAttributedString alloc] initWithString:title
						attributes:attrs] autorelease];
					[MI setAttributedTitle:AS];
				}
				[MI setRepresentedObject:@"Supplemental encoding"];
				[MI setTarget:self];// MI belongs to the receiver's window
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
		if(document = [project subdocumentForFileKey:fileKey])
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
		NSString * fileName = [project nameForFileKey:fileKey];
		if([fileName length])
		{
			NSURL * fileURL = [project URLForFileKey:fileKey];
			NSString * type = [SDC typeForContentsOfURL:fileURL error:NULL];
			Class C = [SDC documentClassForType:type];
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
	NSUInteger new = CFStringConvertNSStringEncodingToEncoding(stringEncoding);
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSArray * fileKeys = [self orderedFileKeys];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = [fileKeys count];
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		NSString * stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
		NSUInteger old = [iTM2StringFormatController coreFoundationStringEncodingWithName:stringEncodingName];
		if(new != old)
		{
			id D = [project subdocumentForFileKey:fileKey];
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
					[project setPropertyValue:stringEncodingName forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
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
	[self iTM2_validateWindowContent];
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
	NSUInteger new = CFStringConvertNSStringEncodingToEncoding(stringEncoding);
	NSArray * fileKeys = [self orderedFileKeys];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = [fileKeys count];
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
		if(stringEncodingName)
		{
			id D = [project subdocumentForFileKey:fileKey];
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
				[project setPropertyValue:nil forKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
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
	[self iTM2_validateWindowContent];
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
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = [fileKeys count];
	id D = nil;
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		id isAuto = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
		BOOL old = [isAuto boolValue];
		// this is a 3 states switch: YES, NO, inherited
		NSString * fileName = [project nameForFileKey:fileKey];
		if([fileName length])
		{
			isAuto = isAuto?(old?[NSNumber numberWithBool:NO]:nil):[NSNumber numberWithBool:YES];
			NSURL * fileURL = [project URLForFileKey:fileKey];
			NSString * type = [SDC typeForContentsOfURL:fileURL error:NULL];
			Class C = [SDC documentClassForType:type];
			if([C isSubclassOfClass:[iTM2TextDocument class]])
			{
				if(D = [project subdocumentForFileKey:fileKey])
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
	[self iTM2_validateWindowContent];
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
	BOOL isDefaults = NO;
	NSString * keyWithAutoDefault = nil;// the last file key having a default string encoding
	NSUInteger row = [selectedRowIndexes firstIndex];
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
		fileName = [project nameForFileKey:fileKey];
		if([fileName length])
		{
			NSURL * fileURL = [project URLForFileKey:fileKey];
			NSString * type = [SDC typeForContentsOfURL:fileURL error:NULL];
			Class C = [SDC documentClassForType:type];
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
			[sender setMenu:[iTM2StringFormatController EOLMenuWithAction:@selector(takeEOLFromTag:) target:self]];// the menu belongs to self
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
		NSInteger EOL = [iTM2StringFormatController EOLForName:EOLName];
		NSUInteger row = [sender indexOfItemWithTag:EOL];
		NSString * title = [[sender itemAtIndex:row] title];
		title = [NSString stringWithFormat:iTM2EOLDefaultFormat, title];
		if(!(MI = [M itemWithAction:takeEOLFromDefaults]))
		{
			MI = [[[NSMenuItem alloc] initWithTitle:title
						action:takeEOLFromDefaults keyEquivalent:[NSString string]] autorelease];
			[MI setTarget:self];// MI belongs to the receiver's window
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
			fileName = [project nameForFileKey:fileKey];
			if([fileName length])
			{
				NSURL * fileURL = [project URLForFileKey:fileKey];
				NSString * type = [SDC typeForContentsOfURL:fileURL error:NULL];
				Class C = [SDC documentClassForType:type];
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
						MI = [[[NSMenuItem alloc] initWithTitle:title
								action:@selector(takeEOLFromTag:) keyEquivalent:[NSString string]] autorelease];
						NSFont * F = [NSFont fontWithName:@"Helvetica-Oblique" size:[NSFont systemFontSize]];
						if(F)
						{
							NSDictionary * attrs = [NSDictionary dictionaryWithObject:F forKey:NSFontAttributeName];
							NSAttributedString * AS = [[[NSAttributedString alloc] initWithString:title
								attributes:attrs] autorelease];
							[MI setAttributedTitle:AS];
						}
						[MI setRepresentedObject:@"Supplemental EOL"];
						[MI setTarget:self];// MI belongs to the receiver's window
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
					MI = [[[NSMenuItem alloc] initWithTitle:title action:noop keyEquivalent:[NSString string]] autorelease];
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
	NSInteger EOL = [sender tag];
	NSString * new = [iTM2StringFormatController terminationStringForEOL:EOL];
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)[self document];
	NSArray * fileKeys = [self orderedFileKeys];
	NSTableView * documentsView = [self documentsView];
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = [fileKeys count];
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		NSString * old = [project propertyValueForKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
		if(![new isEqualToString:old])
		{
			id D = [project subdocumentForFileKey:fileKey];
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
				[project setPropertyValue:new forKey:TWSEOLFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
			}
			changed = YES;
		}
		row = [selectedRowIndexes indexGreaterThanIndex:row];
	}
	if(changed)
	{
		[project updateChangeCount:NSChangeDone];		
	}
	[self iTM2_validateWindowContent];
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
    [drawer iTM2_validateContent];
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
- (BOOL)validateMenuItem:(id) sender;
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

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op;
    // This method is used by NSTableView to determine a valid drop target.  Based on the mouse position, the table view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropRow:dropOperation:and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op;
#endif
#pragma mark >>>>  HUNTING
#endif
@end


//#import <iTM2Foundation/iTM2PathUtilities.h>

@implementation iTM2MainInstaller(TeXProjectDocument)
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
    if(![SPC countOfBaseProjects])
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
			iTM2_MILESTONE((@"TeX Project Menu Items"),(@"Localization is not complete"));
		}
		[iTM2ProjectLocalizedChooseMaster autorelease];
		iTM2ProjectLocalizedChooseMaster = [proposal copy];
		NSMenu * m = [MI menu];
		[m removeItem:MI];
		[m cleanSeparators];
	}
	if([NSDocumentController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2TeXP_iTM2_projectPathExtension)]
		&& [NSDocumentController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2TeXP_iTM2_wrapperPathExtension)]
	   && [NSDocumentController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2TeXP_iTM2_projectDocumentType)]
	   && [NSDocumentController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2TeXP_iTM2_wrapperDocumentType)])
	{
		iTM2_MILESTONE((@"NSDocumentController(iTM2TeXProject)"),(@"The various document types do not conform to the TeX design"));
	}
    return;
}
@end

@interface iTM2TeXProjectController(PRIVATE)
- (void)updateBaseProjectsNotified:(NSNotification *) irrelevant;
@end

@implementation iTM2TeXProjectController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateTeXBaseProjectsNotified:
- (void)updateTeXBaseProjectsNotified:(NSNotification *) irrelevant;
/*"Description forthcoming. startup time used 1883/4233=0,44483817623, 0,23483309144
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning updateTeXBaseProjectsNotified THIS SHOULD BE REMOVED
	[self updateBaseProjectsNotified:(NSNotification *) irrelevant];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedBaseProjectNames
- (NSArray *)orderedBaseProjectNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * baseProjectsRepository = [NSBundle iTM2_temporaryBaseProjectsDirectory];
	NSMutableSet * MS = [NSMutableSet set];
	for(NSString * path in [DFM contentsOfDirectoryAtPath:baseProjectsRepository error:NULL])
	{
		path = [baseProjectsRepository stringByAppendingPathComponent:path];
		NSString * requiredExtension = [SDC iTM2_projectPathExtension];
		for(NSString * component in [DFM contentsOfDirectoryAtPath:path error:NULL])
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
	[IMPLEMENTATION takeMetaValue:nil forKey:@"writable project name -> base name mapping"];
	if(![MS count])
	{
		iTM2_LOG(@"ERROR: no base projects are available, please reinstall");
		return nil;
	}
	// get in MRA an ordered list of the project names, from the shortest to the longest
	NSArray * RA = [NSArray arrayWithArray:[[MS allObjects] valueForKey:@"TeXProjectProperties"]];
	RA = [RA sortedArrayUsingSelector:@selector(compareTeXProjectProperties:)];
iTM2_LOG(@"4-%@",[RA valueForKey:iTM2TPDKNameKey]);// beware, no message sent to a collection of dictionaries
//iTM2_END;
	return [RA valueForKey:iTM2TPDKNameKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyBaseNamesOfAncestorsForBaseProjectName:
- (NSArray *)lazyBaseNamesOfAncestorsForBaseProjectName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	name = [[name lastPathComponent] stringByDeletingPathExtension];// useless?
	// the result
	id result = [NSMutableSet set];
	if([[self baseProjectNames] containsObject:name])
	{
		[result addObject:name];
	}
	NSDictionary * TPPs = [name TeXProjectProperties];
	id O = [[TPPs mutableCopy] autorelease];
	NSString * mode = [TPPs objectForKey:iTM2TPDKModeKey];
	if([mode isEqual:iTM2ProjectDefaultName])
	{
		// do nothing
	}
	else if([mode isEqual:@"TeX"])
	{
		mode = nil;
		[O setObject:iTM2ProjectDefaultName forKey:iTM2TPDKModeKey];
		O = [O TeXBaseProjectName];
		O = [self lazyBaseNamesOfAncestorsForBaseProjectName:O];
		[result addObjectsFromArray:O];
	}
	else if([mode isEqual:@"Plain"])
	{
		mode = nil;
		[O setObject:@"TeX" forKey:iTM2TPDKModeKey];
		O = [O TeXBaseProjectName];
		if(![name isEqual:O])
		{
			O = [self lazyBaseNamesOfAncestorsForBaseProjectName:O];
			[result addObjectsFromArray:O];
		}
	}
	else if(mode)
	{
		mode = nil;
		[O setObject:@"Plain" forKey:iTM2TPDKModeKey];
		O = [O TeXBaseProjectName];
		if(![name isEqual:O])
		{
			O = [self lazyBaseNamesOfAncestorsForBaseProjectName:O];
			[result addObjectsFromArray:O];
		}
	}
	else
	{
		return [NSArray array];
	}
	O = [[TPPs mutableCopy] autorelease];
	[O removeObjectForKey:iTM2TPDKExtensionKey];
	O = [O TeXBaseProjectName];
	if([O length] < [name length])
	{
		O = [self lazyBaseNamesOfAncestorsForBaseProjectName:O];
		[result addObjectsFromArray:O];
	}
	O = [[TPPs mutableCopy] autorelease];
	[O removeObjectForKey:iTM2TPDKVariantKey];
	O = [O TeXBaseProjectName];
	if([O length] < [name length])
	{
		O = [self lazyBaseNamesOfAncestorsForBaseProjectName:O];
		[result addObjectsFromArray:O];
	}
	NSMutableArray * MRA = [[[[self orderedBaseProjectNames] valueForKey:@"TeXProjectProperties"] mutableCopy] autorelease];
iTM2_LOG(@"1-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	O = [TPPs objectForKey:iTM2TPDKModeKey];
	if([O length])
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@",iTM2TPDKModeKey,O]];
	}
	else
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKModeKey,@"^$"]];
	}
iTM2_LOG(@"2-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	O = [TPPs objectForKey:iTM2TPDKVariantKey];
	if([O length])
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@",iTM2TPDKVariantKey,O]];
	}
	else
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKVariantKey,@"^$"]];
	}
iTM2_LOG(@"3-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	O = [TPPs objectForKey:iTM2TPDKExtensionKey];
	if([O length])
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@",iTM2TPDKExtensionKey,O]];
	}
	else
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKExtensionKey,@"^$"]];
	}
iTM2_LOG(@"4-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	O = [TPPs objectForKey:iTM2TPDKOutputKey];
	if([O length])
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains %K",O,iTM2TPDKOutputKey]];
	}
	else
	{
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKOutputKey,@"^$"]];
	}
iTM2_LOG(@"5-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	MRA = [[[MRA valueForKey:iTM2TPDKNameKey] mutableCopy] autorelease];
	[MRA removeObject:name];
	[result addObjectsFromArray:MRA];
	result = [result valueForKey:@"TeXProjectProperties"];
	result = [NSMutableArray arrayWithArray:[result allObjects]];
	[result sortUsingSelector:@selector(compareTeXProjectProperties:)];
	result = [result valueForKey:iTM2TPDKNameKey];
//iTM2_END;
iTM2_LOG(@"%@,\n%@",name,[[result reverseObjectEnumerator] allObjects]);
	return [[result reverseObjectEnumerator] allObjects];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isTeXProjectPackageAtURL:
- (BOOL)iTM2_isTeXProjectPackageAtURL:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString * type = [SDC typeForContentsOfURL:url error:nil];
	BOOL result = UTTypeEqual((CFStringRef)type,iTM2UTTypeTeXProject);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isTeXWrapperPackageAtURL:
- (BOOL)iTM2_isTeXWrapperPackageAtURL:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString * type = [SDC typeForContentsOfURL:url error:nil];
	BOOL result = UTTypeEqual((CFStringRef)type,iTM2UTTypeTeXWrapper);
    return result;
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
	NSString * fileKey = [TPD fileKeyForURL:[self fileURL]];
	NSString * codeset = [TPD propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
//iTM2_END;
    return [codeset length]?[NSDictionary dictionaryWithObjectsAndKeys:
		codeset,TWSStringEncodingFileKey,
			nil]:[NSDictionary dictionary];
}
@end