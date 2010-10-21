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
#import <iTM2Foundation/iTM2DocumentControllerKit.h>

NSString * const iTM2TeXProjectInfoComponent = @"Info";// = iTM2ProjectInfoComponent, unused

NSString * const iTM2TeXProjectTable = @"TeX Project";

NSString * const iTM2TeXProjectInspectorType = @"TeX Project Type";

NSString * const iTM2TeXPCachedKeysKey = @"info_cachedKeys";

//  You must keep the following declaration for backwards compatibility
NSString * const iTM2UTTypeTeXWrapper = @"comp.text.tex.iTeXMac2.texd";
NSString * const iTM2UTTypeTeXProject = @"comp.text.tex.iTeXMac2.texp";

NSString * const iTM3UTTypeTeXWrapper = @"org.tug.tex.texd";
NSString * const iTM3UTTypeTeXProject = @"org.tug.tex.texp";

NSString * const iTM2TPDKModeKey = @"mode";
NSString * const iTM2TPDKExtensionKey = @"extension";
NSString * const iTM2TPDKPrettyExtensionKey = @"pretty_extension";
NSString * const iTM2TPDKVariantKey = @"variant";
NSString * const iTM2TPDKOutputKey = @"output";
NSString * const iTM2TPDKNameKey = @"name";

@implementation NSDocumentController(iTM2TeXProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TeXP_projectDocumentType4iTM3
- (NSString *)SWZ_iTM2TeXP_projectDocumentType4iTM3;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
Latest Revision: Tue Oct  5 11:46:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM3UTTypeTeXProject;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TeXP_wrapperDocumentType4iTM3
- (NSString *)SWZ_iTM2TeXP_wrapperDocumentType4iTM3;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
Latest Revision: Tue Oct  5 11:46:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM3UTTypeTeXWrapper;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = @"showCurrentProjectSettings(small)";
	NSImage * I = [NSImage cachedImageNamed4iTM3:name];
	if([I isNotNullImage4iTM3])
	{
		return I;
	}
	I = [[NSImage cachedImageNamed4iTM3:@"showCurrentProjectSettings"] copy];
	[I setSizeSmallIcon4iTM3];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSURL * userLibraryURL = [DFM URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask].lastObject;
	NSString * string = [[@"TeX" stringByAppendingPathComponent:@"bin"] stringByAppendingPathComponent:@"iTeXMac2 edit -line %d -file %s"];
    NSURL * URL = [NSURL URLWithPath4iTM3:string relativeToURL:userLibraryURL];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                    URL.path, @"TEXEDIT",
                    URL.path, @"MPEDIT",
                    @"NO", @"BIB_All4iTM3",
					[iTM2StringFormatController nameOfCoreFoundationStringEncoding:CFStringConvertNSStringEncodingToEncoding(NSMacOSRomanStringEncoding)], TWSStringEncodingFileKey,
					@"\n", TWSEOLFileKey,
                        nil]];
    NSString * path = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"TEXMFOUTPUT"] stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
    BOOL isDirectory = NO;
    if ([[[DFM attributesOfItemAtPath:URL.path error:NULL] objectForKey:NSFileType] isEqualToString:NSFileTypeSymbolicLink])  {
        path = [@"/private" stringByAppendingPathComponent:path];
    }
    if (![DFM fileExistsAtPath:path isDirectory:&isDirectory])
        isDirectory = [DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    if (!isDirectory) {
        NSBeginAlertSheet(NSLocalizedStringFromTableInBundle(@"Bad TEXMFOUTPUT", @"Project", myBUNDLE, nil),
    nil, nil, nil, nil, nil, NULL, NULL, nil,//(void *) TS,
NSLocalizedStringFromTableInBundle(@"Bad TEXMFOUTPUT provided\n%@", @"Project", myBUNDLE, ""), path);
    }
    if (!isDirectory)/* twice... */ {
        NSArray * RA = [DFM URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        if (RA.count) {
            NSURL * url = [[[RA objectAtIndex:0] URLByAppendingPathComponent:@"TeX"] URLByStandardizingPath];
            if(![DFM fileExistsAtPath:url.path isDirectory:&isDirectory])
                isDirectory = [DFM createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:NULL];
            if (isDirectory) {
                if ([DFM isReadableFileAtPath:url.path] && [DFM isWritableFileAtPath:url.path]) {
                    path = [[url.path stringByAppendingPathComponent:@"TEXMFOUTPUT"] stringByStandardizingPath];
                    if(![DFM fileExistsAtPath:path isDirectory:&isDirectory])
                        isDirectory = [DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
                    if(isDirectory && [DFM isReadableFileAtPath:path] && [DFM isWritableFileAtPath:path])
                        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                            path,  @"TEXMFOUTPUT",
                                nil]];
                }
            }
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDocumentsInspector
- (id)projectDocumentsInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self inspectorAddedWithMode:[iTM2TeXSubdocumentsInspector inspectorMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  close
- (void)close;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[DFM removeItemAtPath:[self.fileURL.path stringByAppendingPathComponent:@".iTM2"] error:NULL];// this directory was created by iTeXMac2
	[super close];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= needsToUpdate
- (BOOL)needsToUpdate;
/*"The project is known to be modified externally (see the .iTM folder). Do not update.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setHelperProject:
- (void)setHelperProject:(id)helperProject;
/*"Decription forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(helperProject);
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  SAVE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateBaseProjectsCompleteWriteToURL4iTM3:ofType:error:
- (BOOL)updateTeXBaseProjectsCompleteWriteToURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)error;
/*"Update the list of cached base projects if the receiver is a base project, ie belongs to the directory of base projects.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (absoluteURL.isFileURL) {
		ICURegEx * RE = [[[ICURegEx alloc]
			initWithSearchPattern:[NSString stringWithFormat:@"/Library/.*/\\Q%@\\E(?:$|/)",iTM2ProjectBaseComponent]
				options:0 error:nil] autorelease];
		if ([RE matchString:absoluteURL.path]) {
			[SPC updateTeXBaseProjectsNotified:nil];
		}
	}
//END4iTM3;
    return YES;
}
@end

@implementation NSString(PRIVATE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXProjectProperties4iTM3
- (NSDictionary *)TeXProjectProperties4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * mode = @"";
    NSString * output = @"";
    NSString * variant = @"";
    NSString * extension = @"";
	ICURegEx * RE = [ICURegEx regExForKey:@"TeX Project Properties" error:NULL];
    NSString * name = self.lastPathComponent.stringByDeletingPathExtension;
	if ([RE matchString:name]) {
		extension = [RE substringOfCaptureGroupWithName:@"extension"];
		mode = [RE substringOfCaptureGroupWithName:@"mode"];
		output = [RE substringOfCaptureGroupWithName:@"output"];
		variant = [RE substringOfCaptureGroupWithName:@"variant"];
	}
    RE.forget;
	NSString * prettyExtension = NSLocalizedStringFromTableInBundle([extension lowercaseString],iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"");
    return [NSDictionary dictionaryWithObjectsAndKeys:mode, iTM2TPDKModeKey, extension, iTM2TPDKExtensionKey, prettyExtension, iTM2TPDKPrettyExtensionKey, output, iTM2TPDKOutputKey, variant, iTM2TPDKVariantKey, name, iTM2TPDKNameKey, nil];
}
@end

@implementation NSDictionary(TeXProjectProperties4iTM3)
- (NSComparisonResult)compareTeXProjectProperties4iTM3:(id)rhs;
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
- (NSString *)TeXBaseProjectName4iTM3;
{
    NSString * mode = [self objectForKey:iTM2TPDKModeKey];
    NSString * output = [self objectForKey:iTM2TPDKOutputKey];
    NSString * variant = [self objectForKey:iTM2TPDKVariantKey];
    NSString * extension = [self objectForKey:iTM2TPDKExtensionKey];
	NSMutableString * result = [NSMutableString string];
	if(extension.length)
	{
		[result appendFormat:@"(%@)",extension];
	}
	if(mode.length)
	{
		[result appendFormat:@"%@",mode];
	}
	if(output.length)
	{
		[result appendFormat:@"+%@",output];
	}
	if(variant.length)
	{
		[result appendFormat:@"-%@",variant];
	}
LOG4iTM3(@"result:%@",result);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = @"showCurrentProjectFiles(small)";
	NSImage * I = [NSImage cachedImageNamed4iTM3:name];
	if([I isNotNullImage4iTM3])
	{
		return I;
	}
	I = [[NSImage cachedImageNamed4iTM3:@"showCurrentProjectFiles"] copy];
	[I setSizeSmallIcon4iTM3];
	[I setName:name];
    return I;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2SubdocumentsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowFrameIdentifier4iTM3
- (NSString *)windowFrameIdentifier4iTM3;
/*"YESSSS.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"TeX Project Files";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectPathEdited:
- (IBAction)projectPathEdited:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectPathEdited:
- (BOOL)validateProjectPathEdited:(NSControl *) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * projectURL = [self.document fileURL];
	NSURL * sourceURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
    sender.stringValue = sourceURL?sourceURL.path:([self.document displayName]?:@"");
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseMainFile:
- (IBAction)chooseMainFile:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// just a message catcher
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseMainFile:
- (BOOL)validateChooseMainFile:(NSPopUpButton *) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender %@", sender);
    if(![sender isKindOfClass:[NSPopUpButton class]])
        return NO;
	NSMenu * senderMenu = sender.menu;
	NSMenuItem * frontDocumentMenuItem = [[senderMenu itemWithRepresentedObject4iTM3:@"...iTM2FrontDocument"] copy];
	if(!frontDocumentMenuItem)
	{
		frontDocumentMenuItem = [(NSMenuItem *)[senderMenu itemWithTag:-1] copy];
		frontDocumentMenuItem.representedObject = @"...iTM2FrontDocument";
	}
	frontDocumentMenuItem.state = NSOffState;
	frontDocumentMenuItem.action = NULL;
	frontDocumentMenuItem.target = nil;
    [sender removeAllItems];// now frontDocumentMenuItem is mine only
	[sender addItemWithTitle:iTM2ProjectLocalizedChooseMaster];
	[senderMenu addItem:[NSMenuItem separatorItem]];
//	[[sender lastItem] setAction:@selector(takeMainFileFromRepresentedObject:)];
//	[[sender lastItem] setTarget:self];
    NSArray * fileKeys = self.orderedFileKeys;
    NSInteger row = 0;
    iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
	NSString * fileKey = nil;
    while(row<fileKeys.count)
    {
        fileKey = [fileKeys objectAtIndex:row];
        if(fileKey.length)
        {
            NSString * FN = [project nameForFileKey:fileKey];
            if(FN.length)
            {
                [sender addItemWithTitle:FN];
				NSMenuItem * item = [sender lastItem];
                item.representedObject = [[fileKey copy] autorelease];
                item.action = @selector(takeMainFileFromRepresentedObject:);
                item.target = self;// sender belongs to the receiver's window
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
		NSMenuItem * item = [sender lastItem];
		item.action = @selector(takeMainFileFromRepresentedObject:);
		item.target = self;// sender belongs to the receiver's window
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
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMainFileFromRepresentedObject:
- (IBAction)takeMainFileFromRepresentedObject:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
    NSString * oldK = [project realMasterFileKey];
    NSString * newK = [sender representedString];
    if(![oldK isEqualToString:newK])
    {
        [project setMasterFileKey:newK];
        [project updateChangeCount:NSChangeDone];
        self.validateWindowContent4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger row = [self.documentsView selectedRow];
	NSArray * orderedFileKeys = self.orderedFileKeys;
    if(row < 0 || row >= orderedFileKeys.count)
	{
        return;
	}
    else if(row)
    {
		NSString * key = [orderedFileKeys objectAtIndex:row];
		iTM2ProjectDocument * PD = self.document;
        NSURL * oldURL = [PD URLForFileKey:key];
        if(!oldURL)
		{
			return;
		}
		if(![DFM fileExistsAtPath:oldURL.path])
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
		NSBundle * B = [iTM2ProjectDocument classBundle4iTM3];
		if([newRelative hasPrefix:@".."])
		{
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Bad name", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				self.window,
				nil, NULL, NULL,
				nil,// will be released below
				NSLocalizedStringFromTableInBundle(@"The name %@ must not contain \"..\".", iTM2ProjectTable, B, ""),
				newRelative);
			return;
		}
		NSURL * newURL = [NSURL URLWithPath4iTM3:newRelative relativeToURL:[PD contentsURL]];
		if([newURL isEquivalentToURL4iTM3:oldURL])
		{
			return;
		}
		NSString * newKey = [PD fileKeyForURL:newURL];
		if(newKey.length)
		{
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Name conflict", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				self.window,
				nil, NULL, NULL,
				nil,// will be released below
				NSLocalizedStringFromTableInBundle(@"The name %@ is already used.", iTM2ProjectTable, B, ""),
				newURL.path);
			return;
		}
		if([DFM fileExistsAtPath:newURL.path])
		{
			// there is a possible conflict
			NSBeginAlertSheet(
				NSLocalizedStringFromTableInBundle(@"Naming problem", iTM2ProjectTable, B, ""),
				nil, nil, nil,
				self.window,
				nil, NULL, NULL,
				nil,
				NSLocalizedStringFromTableInBundle(@"Already existing file at\n%@", iTM2ProjectTable, B, ""),
				newURL.path);
			return;
		}
		NSError * localError = nil;
		if([DFM createDirectoryAtPath:[[newURL parentDirectoryURL4iTM3] path] withIntermediateDirectories:YES attributes:nil error:&localError])
		{
			if(![DFM moveItemAtPath:oldURL.path toPath:newURL.path error:NULL])
			{
				NSBeginAlertSheet(
					NSLocalizedStringFromTableInBundle(@"Naming problem", iTM2ProjectTable, B, ""),
					nil, nil, nil,
					self.window,
					nil, NULL, NULL,
					nil,// will be released below
					NSLocalizedStringFromTableInBundle(@"A file could not move.", iTM2ProjectTable, B, ""));
				return;
			}
			[subDocument setFileURL:newURL];// before the project is aware of a file change
			[PD setURL:newURL forFileKey:key];// after the document name has changed
			if(iTM2DebugEnabled)
			{
				LOG4iTM3(@"Name successfully changed from %@ to %@", oldURL.path, newURL.path);
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
		[sender validateWindowContent4iTM3];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL editable = NO;
	NSTableView * DV = self.documentsView;
    NSInteger row = [DV selectedRow];
    NSString * title = nil;
	NSBundle * B = [iTM2ProjectDocument classBundle4iTM3];
    if(row < 0 || row >= [DV numberOfRows])
	{
        title = NSLocalizedStringFromTableInBundle(@"No selection", iTM2ProjectTable, B, "Description Forthcoming");
	}
    else if(row)
    {
		id DS = [DV dataSource];
		NSTableColumn * TC = [DV tableColumnWithIdentifier:@"path"];
        title = [DS tableView:DV objectValueForTableColumn:TC row:row];
        if(title.length)
		{
			NSArray * fileKeys = self.orderedFileKeys;
			NSString * key = [fileKeys objectAtIndex:row];
			iTM2ProjectDocument * PD = self.document;
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
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseStringEncoding:
- (IBAction)chooseStringEncoding:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// message catcher
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseStringEncoding:
- (BOOL)validateChooseStringEncoding:(NSPopUpButton *) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([sender isKindOfClass:[NSPopUpButton class]]) {
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
        if([sender.menu numberOfItems] < 2)
		{
			[sender setMenu:[iTM2StringFormatController stringEncodingMenuWithAction:@selector(takeStringEncodingFromTag:) target:self]];// the menu belongs to self (the target)
		}		
		// removing all the items with a noop4iTM3:action: this is mainly the "Multiple Selection" item
		NSMenu * M = sender.menu;
		NSEnumerator * E = [M.itemArray objectEnumerator];
		NSMenuItem * MI;
		SEL noop = @selector(noop4iTM3:);
		while(MI = E.nextObject)
		{
			if(MI.action == noop)
				[M removeItem:MI];
		}
		[M cleanSeparators4iTM3];
		// updating the Defaults menu
        iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
        NSArray * fileKeys = self.orderedFileKeys;
		NSString * fileKey = [fileKeys objectAtIndex:0];
		NSString * stringEncodingName = nil;
		NSStringEncoding encoding = 0;
		NSString * title = nil;
		SEL takeStringEncodingFromDefaults = @selector(takeStringEncodingFromDefaults:);
		stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
		encoding = [NSString stringEncodingWithName:stringEncodingName];
		title = [NSString localizedNameOfStringEncoding:encoding];
		title = [NSString stringWithFormat:iTM2StringEncodingDefaultFormat, title];
		if(!(MI = [M itemWithAction4iTM3:takeStringEncodingFromDefaults]))
		{
			MI = [[[NSMenuItem alloc] initWithTitle:title
						action:takeStringEncodingFromDefaults keyEquivalent:[NSString string]] autorelease];
			MI.target = self;// MI belongs to the receiver's window
			[MI setEnabled:YES];
			[M insertItem:[NSMenuItem separatorItem] atIndex:0];
			[M insertItem:MI atIndex:0];
		}
		else
		{
			MI.title = title;
		}
		NSTableView * documentsView = self.documentsView;
		NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
		if(!selectedRowIndexes.count)// no item selected
		{
			[sender selectItem:nil];
//END4iTM3;
			return NO;
		}
		BOOL enabled = NO;
		if(selectedRowIndexes.count>1)// no item selected
		{
			enabled = NO;
//multipleSelection:
			title = NSLocalizedStringFromTableInBundle(@"Multiple selection",iTM2ProjectTable,[NSBundle iTM2FoundationBundle],"Description Forthcoming");
			MI = [[[NSMenuItem alloc] initWithTitle:title action:noop keyEquivalent:[NSString string]] autorelease];
			MI.target = nil;
			[MI setEnabled:NO];
			[M insertItem:[NSMenuItem separatorItem] atIndex:0];
			[M insertItem:MI atIndex:0];
			[sender selectItemAtIndex:0];
//END4iTM3;
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
				MI.representedObject = @"Supplemental encoding";
				MI.target = self;// MI belongs to the receiver's window
				[MI setEnabled:YES];
				// where should I place this menu item?
				// this item will appear as a separated item in the list
				// to collect all the other item, I use the represented object
				NSMenuItem * mi;
				NSEnumerator * e = [M.itemArray reverseObjectEnumerator];
				while(mi = e.nextObject)
				{
					if([[mi representedObject] isEqual:@"Supplemental encoding"])
					{
						row = [M indexOfItem:mi];
						++row;
						[M insertItem:MI atIndex:row];
						[sender selectItemAtIndex:row];
//END4iTM3;
						return enabled;
					}
				}
				row = [M numberOfItems];
				[M insertItem:MI atIndex:row];
				[M insertItem:[NSMenuItem separatorItem] atIndex:row];
			}
			[sender selectItemAtIndex:row];
//END4iTM3;
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
		if(fileName.length)
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
//END4iTM3;
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
//END4iTM3;
						return YES;
					}
				}
				else if(defaultIsAutoStringEncoding)
				{
					[sender selectItem:nil];
//END4iTM3;
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
//END4iTM3;
				return NO;
			}
		}
		else
		{// do not go further
			[sender selectItem:nil];
//END4iTM3;
			return NO;
		}
    }
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromTag:
- (IBAction)takeStringEncodingFromTag:(NSControl *) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSStringEncoding stringEncoding = sender.tag;
	NSUInteger new = CFStringConvertNSStringEncodingToEncoding(stringEncoding);
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
	NSArray * fileKeys = self.orderedFileKeys;
	NSTableView * documentsView = self.documentsView;
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = fileKeys.count;
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
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStringEncodingFromDefaults:
- (IBAction)takeStringEncodingFromDefaults:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
	NSString * stringEncodingName = [project propertyValueForKey:TWSStringEncodingFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
	NSStringEncoding stringEncoding = [NSString stringEncodingWithName:stringEncodingName];
	NSUInteger new = CFStringConvertNSStringEncodingToEncoding(stringEncoding);
	NSArray * fileKeys = self.orderedFileKeys;
	NSTableView * documentsView = self.documentsView;
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = fileKeys.count;
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
	self.validateWindowContent4iTM3;
//END4iTM3;
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
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
	NSArray * fileKeys = self.orderedFileKeys;
	NSTableView * documentsView = self.documentsView;
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = fileKeys.count;
	id D = nil;
	BOOL changed = NO;
	while(row < top)
	{
		NSString * fileKey = [fileKeys objectAtIndex:row];
		id isAuto = [project contextValueForKey:iTM2StringEncodingIsAutoKey fileKey:fileKey domain:iTM2ContextStandardLocalMask];
		BOOL old = [isAuto boolValue];
		// this is a 3 states switch: YES, NO, inherited
		NSString * fileName = [project nameForFileKey:fileKey];
		if(fileName.length)
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
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateStringEncodingToggleAuto:
- (BOOL)validateStringEncodingToggleAuto:(NSButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
	NSArray * fileKeys = self.orderedFileKeys;
	NSString * fileKey = [fileKeys objectAtIndex:0];
	NSTableView * documentsView = self.documentsView;
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	if(!selectedRowIndexes.count)// no item selected
	{
//END4iTM3;
		sender.state = NSOffState;
		return NO;
	}
	if(selectedRowIndexes.count>1)// no item selected
	{
//END4iTM3;
		sender.state = NSMixedState;
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
		if(fileName.length)
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
				sender.state = NSOffState;
//END4iTM3;
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
			sender.state = NSMixedState;
			return NO;
		}
		if(x && hasOff)
		{
			// multiple case
			sender.state = NSMixedState;
			return NO;
		}
		else if(!x && hasOn)
		{
			// multiple case
			sender.state = NSMixedState;
			return NO;
		}
		else if(x && hasOn)
		{
			// multiple case
			sender.state = NSOnState;
			return NO;
		}
		else if(!x && hasOff)
		{
			// multiple case
			sender.state = NSOffState;
			return NO;
		}
		sender.state = (x?NSOnState:NSOffState);
		return YES;
	}
	if(keyWithAutoDefault)
	{
		// multiple case with project defaults
		sender.state = NSMixedState;// the string encoding popup will say if this is auto or not
		return YES;
	}
	else if(hasOn && hasOff)
	{
		// multiple case with no project defaults
		sender.state = NSMixedState;
		return YES;
	}
	else if(hasOn)
	{
		// single case with no project defaults
		sender.state = NSOnState;
		return YES;
	}
	else if(hasOff)
	{
		// single case with no project defaults
		sender.state = NSOffState;
		return YES;
	}
	sender.state = (x?NSOnState:NSOffState);
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseEOL:
- (IBAction)chooseEOL:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// Just a message catcher
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseEOL:
- (BOOL)validateChooseEOL:(NSPopUpButton *) sender;
/*"Description forthcoming. This is the one in the documents list inspector.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
        if([sender.menu numberOfItems] < 2)
		{
			[sender setMenu:[iTM2StringFormatController EOLMenuWithAction:@selector(takeEOLFromTag:) target:self]];// the menu belongs to self
		}		
		// removing all the items with a noop4iTM3:action: this is mainly the "Multiple Selection" item
		NSMenu * M = sender.menu;
		NSEnumerator * E = [M.itemArray objectEnumerator];
		NSMenuItem * MI;
		SEL noop = @selector(noop4iTM3:);
		while(MI = E.nextObject)
		{
			if(MI.action == noop)
				[M removeItem:MI];
		}
		[M cleanSeparators4iTM3];
		// updating the Defaults menu
        iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
        NSArray * fileKeys = self.orderedFileKeys;
		NSString * fileKey = [fileKeys objectAtIndex:0];
		SEL takeEOLFromDefaults = @selector(takeEOLFromDefaults:);
		NSString * EOLName = [project propertyValueForKey:TWSEOLFileKey fileKey:iTM2ProjectDefaultsKey contextDomain:iTM2ContextAllDomainsMask];
		NSInteger EOL = [iTM2StringFormatController EOLForName:EOLName];
		NSUInteger row = [sender indexOfItemWithTag:EOL];
		NSString * title = [[sender itemAtIndex:row] title];
		title = [NSString stringWithFormat:iTM2EOLDefaultFormat, title];
		if(!(MI = [M itemWithAction4iTM3:takeEOLFromDefaults]))
		{
			MI = [[[NSMenuItem alloc] initWithTitle:title
						action:takeEOLFromDefaults keyEquivalent:[NSString string]] autorelease];
			MI.target = self;// MI belongs to the receiver's window
			[MI setEnabled:YES];
			[M insertItem:[NSMenuItem separatorItem] atIndex:0];
			[M insertItem:MI atIndex:0];
		}
		else
		{
			MI.title = title;
		}
		NSTableView * documentsView = self.documentsView;
		NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
		if(!selectedRowIndexes.count)// no item selected
		{
			[sender selectItem:nil];
//END4iTM3;
			return NO;
		}
		if(selectedRowIndexes.count>1)// no item selected
		{
			[sender selectItem:nil];
//END4iTM3;
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
			if(fileName.length)
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
//END4iTM3;
			return NO;
		}
		if(EOLNames.count == 0)
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
						MI.representedObject = @"Supplemental EOL";
						MI.target = self;// MI belongs to the receiver's window
						[MI setEnabled:YES];
						// where should I place this menu item?
						// this item will appear as a separated item in the list
						// to collect all the other item, I use the represented object
						NSMenuItem * mi;
						NSEnumerator * e = [M.itemArray reverseObjectEnumerator];
						while(mi = e.nextObject)
						{
							if([[mi representedObject] isEqual:@"Supplemental EOL"])
							{
								row = [M indexOfItem:mi];
								++row;
								[M insertItem:MI atIndex:row];
								[sender selectItemAtIndex:row];
//END4iTM3;
								return enabled;
							}
						}
						row = [M numberOfItems];
						[M insertItem:MI atIndex:row];
						[M insertItem:[NSMenuItem separatorItem] atIndex:row];
					}
					[sender selectItemAtIndex:row];
//END4iTM3;
					return enabled;
				}
				if(isDefaults)
				{
					enabled = NO;
multipleSelection:
					title = NSLocalizedStringFromTableInBundle(@"Multiple selection",iTM2ProjectTable,[NSBundle iTM2FoundationBundle],"Description Forthcoming");
					MI = [[[NSMenuItem alloc] initWithTitle:title action:noop keyEquivalent:[NSString string]] autorelease];
					MI.target = nil;
					[MI setEnabled:NO];
					[M insertItem:[NSMenuItem separatorItem] atIndex:0];
					[M insertItem:MI atIndex:0];
					[sender selectItemAtIndex:0];
//END4iTM3;
					return enabled;
				}
				[sender selectItemAtIndex:0];
	//END4iTM3;
				return YES;
			}
			else
			{// nothing is selected
				[sender selectItem:nil];
//END4iTM3;
				return NO;
			}
		}
		if((EOLNames.count == 1) && !keyWithDefault )
		{// all the selected items have the same encoding
			enabled = YES;
			EOLName = [EOLNames anyObject];
			EOL = [iTM2StringFormatController EOLForName:EOLName];
			goto selectOneItem;
		}
		enabled = NO;//keyWithDefault == nil;
		goto multipleSelection;
    }
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEOLFromTag:
- (IBAction)takeEOLFromTag:(NSControl *) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger EOL = sender.tag;
	NSString * new = [iTM2StringFormatController terminationStringForEOL:EOL];
	iTM2TeXProjectDocument * project = (iTM2TeXProjectDocument *)self.document;
	NSArray * fileKeys = self.orderedFileKeys;
	NSTableView * documentsView = self.documentsView;
	NSIndexSet * selectedRowIndexes = [documentsView selectedRowIndexes];
	NSUInteger row = [selectedRowIndexes firstIndex];
	NSUInteger top = fileKeys.count;
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
	self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerWillResizeContents:toSize:
- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * string = NSStringFromSize(contentSize);
	[self takeContextValue:string forKey:@"iTM2ProjectSubdocumentsDrawerSize" domain:iTM2ContextAllDomainsMask];
//END4iTM3;
	return contentSize;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerWillOpen:
- (void)drawerWillOpen:(NSNotification *) notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDrawer * drawer = [notification object];
    [drawer validateContent4iTM3];
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
- (BOOL)validateMenuItem:(NSMenuItem *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(sender.action == @selector(mainFileChosen:))
		return YES;
	else
		return [super validateMenuItem:sender];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  interpretKeyStrokeEnter:
- (BOOL)interpretKeyStrokeEnter:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self removeDocument:self];
	return YES;
}
#if 0

// optional - drag and drop support
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet*)rows toPasteboard:(NSPasteboard*)pboard;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXProjectControllerCompleteInstallation4iTM3
+ (void)iTM2TeXProjectControllerCompleteInstallation4iTM3;
/*"Description forthcoming.
This message is sent at initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Mar 29 09:26:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM2TeXProjectController setSharedProjectController:
        [[[iTM2TeXProjectController alloc] init] autorelease]];// very very early in the morning!!!
    if (![SPC countOfBaseProjects]) {
        [SPC updateTeXBaseProjectsNotified:nil];
    }
	if (!iTM2ProjectLocalizedChooseMaster) {
		NSMenuItem * MI = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(projectChooseMaster:)];
		NSString * proposal = MI.title;
		if ([[proposal componentsSeparatedByString:@"%"] count] != 1) {
			proposal = @"Choose Master...";
			LOG4iTM3(@"Localization BUG, the menu item with action projectChooseMaster:in the iTeXMac2.nib must exist and contain one %%@,\nand no other formating directive");
		} else {
			MILESTONE4iTM3((@"TeX Project Menu Items"),(@"Localization is not complete"));
		}
		[iTM2ProjectLocalizedChooseMaster autorelease];
		iTM2ProjectLocalizedChooseMaster = [proposal copy];
		NSMenu * m = MI.menu;
		[m removeItem:MI];
		[m cleanSeparators4iTM3];
	}
	if ([NSDocumentController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2TeXP_projectDocumentType4iTM3) error:NULL]
	   && [NSDocumentController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2TeXP_wrapperDocumentType4iTM3) error:NULL]) {
		MILESTONE4iTM3((@"NSDocumentController(iTM2TeXProject)"),(@"The various document types do not conform to the TeX design"));
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * baseProjectsRepositoryURL = [[NSBundle mainBundle] temporaryBaseProjectsDirectoryURL4iTM3];
	NSMutableSet * MS = [NSMutableSet set];
    for(NSURL * url in [DFM contentsOfDirectoryAtURL:baseProjectsRepositoryURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
		NSString * requiredExtension = [SDC projectPathExtension4iTM3];
		for(NSURL * component in [DFM contentsOfDirectoryAtURL:url includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
			if([component.pathExtension pathIsEqual4iTM3:requiredExtension]) {
				NSString * core = component.lastPathComponent.stringByDeletingPathExtension;
				if(![core hasSuffix:@"~"])// this is not a backup
				{
					[MS addObject:core];
				}
			}
		}
	}
	[IMPLEMENTATION takeMetaValue:nil forKey:@"(writable project name -> base name) mapping"];
	if(!MS.count) {
		LOG4iTM3(@"ERROR: no base projects are available, please reinstall");
		return nil;
	}
	// get in MRA an ordered list of the project names, from the shortest to the longest
	NSArray * RA = [NSArray arrayWithArray:[[MS allObjects] valueForKey:@"TeXProjectProperties4iTM3"]];
	RA = [RA sortedArrayUsingSelector:@selector(compareTeXProjectProperties4iTM3:)];
LOG4iTM3(@"4-%@",[RA valueForKey:iTM2TPDKNameKey]);// beware, no message sent to a collection of dictionaries
//END4iTM3;
	return [RA valueForKey:iTM2TPDKNameKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyBaseNamesOfAncestorsForBaseProjectName:
- (NSArray *)lazyBaseNamesOfAncestorsForBaseProjectName:(NSString *)name;
/*"Overriding method.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	name = name.lastPathComponent.stringByDeletingPathExtension;// useless?
	// the result
	id result = [NSMutableSet set];
	if([self.baseProjectNames containsObject:name])
	{
		[result addObject:name];
	}
	NSDictionary * TPPs = [name TeXProjectProperties4iTM3];
	NSMutableDictionary * O = [[TPPs mutableCopy] autorelease];
	NSString * mode = [TPPs objectForKey:iTM2TPDKModeKey];
    NSString * S = nil;
    NSArray * RA = nil;
	if([mode isEqual:iTM2ProjectDefaultName])
	{
		// do nothing
	}
	else if([mode isEqual:@"TeX"])
	{
		mode = nil;
		[O setObject:iTM2ProjectDefaultName forKey:iTM2TPDKModeKey];
		S = O.TeXBaseProjectName4iTM3;
		if(S.length && ![name isEqual:S])
		{
			RA = [self lazyBaseNamesOfAncestorsForBaseProjectName:S];
			[result addObjectsFromArray:RA];
		}
	}
	else if([mode isEqual:@"Plain"])
	{
		mode = nil;
		[O setObject:@"TeX" forKey:iTM2TPDKModeKey];
		S = O.TeXBaseProjectName4iTM3;
		if(S.length && ![name isEqual:S])
		{
			RA = [self lazyBaseNamesOfAncestorsForBaseProjectName:S];
			[result addObjectsFromArray:RA];
		}
	}
	else if(mode)
	{
		mode = nil;
		[O setObject:@"Plain" forKey:iTM2TPDKModeKey];
		S = O.TeXBaseProjectName4iTM3;
		if(S.length && ![name isEqual:S])
		{
			RA = [self lazyBaseNamesOfAncestorsForBaseProjectName:S];
			[result addObjectsFromArray:RA];
		}
	}
	else
	{
		return [NSArray array];
	}
	O = TPPs.mutableCopy;
	[O removeObjectForKey:iTM2TPDKExtensionKey];
	S = O.TeXBaseProjectName4iTM3;
	if(S.length && S.length < name.length)
	{
		RA = [self lazyBaseNamesOfAncestorsForBaseProjectName:S];
		[result addObjectsFromArray:RA];
	}
	O = TPPs.mutableCopy;
	[O removeObjectForKey:iTM2TPDKVariantKey];
	S = O.TeXBaseProjectName4iTM3;
	if(S.length && S.length < name.length)
	{
		RA = [self lazyBaseNamesOfAncestorsForBaseProjectName:S];
		[result addObjectsFromArray:RA];
	}
	NSMutableArray * MRA = [[self.orderedBaseProjectNames valueForKey:@"TeXProjectProperties4iTM3"] mutableCopy];
LOG4iTM3(@"1-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	S = [TPPs objectForKey:iTM2TPDKModeKey];
	if (S.length) {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@",iTM2TPDKModeKey,S]];
	} else {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKModeKey,@"^$"]];
	}
LOG4iTM3(@"2-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	S = [TPPs objectForKey:iTM2TPDKVariantKey];
	if(S.length) {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@",iTM2TPDKVariantKey,S]];
	} else {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKVariantKey,@"^$"]];
	}
LOG4iTM3(@"3-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	S = [TPPs objectForKey:iTM2TPDKExtensionKey];
	if(S.length) {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K like %@",iTM2TPDKExtensionKey,S]];
	} else {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKExtensionKey,@"^$"]];
	}
LOG4iTM3(@"4-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	S = [TPPs objectForKey:iTM2TPDKOutputKey];
	if((S.length)) {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%@ contains %K",S,iTM2TPDKOutputKey]];
	} else {
		[MRA filterUsingPredicate:[NSPredicate predicateWithFormat:@"%K matches %@",iTM2TPDKOutputKey,@"^$"]];
	}
LOG4iTM3(@"5-%@",[MRA valueForKey:iTM2TPDKNameKey]);
	MRA = [[[MRA valueForKey:iTM2TPDKNameKey] mutableCopy] autorelease];
	[MRA removeObject:name];
	[result addObjectsFromArray:MRA];
	result = [result valueForKey:@"TeXProjectProperties4iTM3"];
	result = [NSMutableArray arrayWithArray:[result allObjects]];
	[result sortUsingSelector:@selector(compareTeXProjectProperties4iTM3:)];
	result = [result valueForKey:iTM2TPDKNameKey];
//END4iTM3;
LOG4iTM3(@"%@,\n%@",name,[result reverseObjectEnumerator].allObjects);
	return [result reverseObjectEnumerator].allObjects;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [iTM2TeXProjectDocument class];
}
@end

#if 0
@interface NSNotificationCenter_DEBUG:NSNotificationCenter
@end
@implementation NSNotificationCenter_DEBUG
- (void)postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
{
	LOG4iTM3(@"aName is:%@", aName);
	LOG4iTM3(@"anObject is:%@", anObject);
	LOG4iTM3(@"aUserInfo is:%@", aUserInfo);
	[super postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo];
	return;
}
@end
#endif

@implementation NSWorkspace(iTM2TeXProjectDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isTeXWrapperPackageAtURL4iTM3:
- (BOOL)isTeXWrapperPackageAtURL4iTM3:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 07:13:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSString * type = [SDC typeForContentsOfURL:url error:nil];
    return [type conformsToUTType4iTM3:iTM3UTTypeTeXWrapper];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isTeXProjectPackageAtURL4iTM3:
- (BOOL)isTeXProjectPackageAtURL4iTM3:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 07:13:37 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSString * type = [SDC typeForContentsOfURL:url error:nil];
    return [type conformsToUTType4iTM3:iTM3UTTypeTeXProject];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isiTM2WrapperPackageAtURL4iTM3:
- (BOOL)isiTM2WrapperPackageAtURL4iTM3:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 07:13:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSString * type = [SDC typeForContentsOfURL:url error:nil];
    return [type conformsToUTType4iTM3:iTM2UTTypeTeXWrapper];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isiTM2ProjectPackageAtURL4iTM3:
- (BOOL)isiTM2ProjectPackageAtURL4iTM3:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 07:13:37 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSString * type = [SDC typeForContentsOfURL:url error:nil];
    return [type conformsToUTType4iTM3:iTM2UTTypeTeXProject];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:self];
	NSString * fileKey = [TPD fileKeyForURL:self.fileURL];
	NSString * codeset = [TPD propertyValueForKey:TWSStringEncodingFileKey fileKey:fileKey contextDomain:iTM2ContextStandardLocalMask];
//END4iTM3;
    return codeset.length?[NSDictionary dictionaryWithObjectsAndKeys:
		codeset,TWSStringEncodingFileKey,
			nil]:[NSDictionary dictionary];
}
@end