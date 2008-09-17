/*
//  iTM2MetaPostWrapperKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import "iTM2MetaPostWrapperKit.h"

NSString * const iTM2MetaPostParseFirstLineKey = @"parse_first_line";
NSString * const iTM2MetaPostPARSETranslationKey = @"PARSE_translate";
NSString * const iTM2MetaPostUSETranslationKey = @"USE_translate";
NSString * const iTM2MetaPostTranslationKey = @"translate_file";
NSString * const iTM2MetaPostInteractionName = @"interaction";
NSString * const iTM2MetaPostFormatKey = @"mem";
NSString * const iTM2MetaPostUSEProgNameKey = @"USE_progname";
NSString * const iTM2MetaPostProgNameKey = @"progname";
NSString * const iTM2MetaPostUSEJobNameKey = @"USE_jobname";
NSString * const iTM2MetaPostJobNameKey = @"jobname";
NSString * const iTM2MetaPostFileLineErrorStyleKey = @"file_line_error";
NSString * const iTM2MetaPostRecorderKey = @"recorder";
NSString * const iTM2MetaPostIniKey = @"ini";
NSString * const iTM2MetaPostTroffKey = @"troff";
NSString * const iTM2MetaPostHaltOnErrorKey = @"halt_on_error";
NSString * const iTM2MetaPostOutputDirectoryKey = @"output_directory";
NSString * const iTM2MetaPostUSEOutputDirectoryKey = @"USE_output_directory";
NSString * const iTM2MetaPostTeXParseFirstLineKey = @"TeX_parse_first_line";
NSString * const iTM2MetaPostTeXFormatKey = @"TeX_format";
NSString * const iTM2MetaPostConvertToPDFKey = @"convert_to_pdf";
NSString * const iTM2MetaPostPDFConverterKey = @"pdf_converter";

@implementation iTM2EngineMetaPost
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_mpost";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSArray arrayWithObject:@"mp"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2MetaPostParseFirstLineKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostPARSETranslationKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostUSETranslationKey,
                @"", iTM2MetaPostTranslationKey,
                @"errorstopmode", iTM2MetaPostInteractionName,
                @"", iTM2MetaPostFormatKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostTeXParseFirstLineKey,
                @"", iTM2MetaPostTeXFormatKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostUSEProgNameKey,
                @"", iTM2MetaPostProgNameKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostUSEJobNameKey,
                @"", iTM2MetaPostJobNameKey,
                [NSNumber numberWithBool:YES], iTM2MetaPostFileLineErrorStyleKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostRecorderKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostIniKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostTroffKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostHaltOnErrorKey,
                [NSNumber numberWithBool:NO], iTM2MetaPostUSEOutputDirectoryKey,
                @"", iTM2MetaPostOutputDirectoryKey,
                [NSNumber numberWithBool:YES], iTM2MetaPostConvertToPDFKey,
                [NSNumber numberWithInt:0], iTM2MetaPostPDFConverterKey,
					nil];
}
#pragma mark =-=-=-=-=- FORMAT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editFormat:
- (IBAction)editFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MetaPostFormatKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self editInfoForKeyPaths:iTM2MetaPostFormatKey,nil]?:@"")];
    return ![[self editInfoForKeyPaths:iTM2MetaPostParseFirstLineKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseFormat:
- (IBAction)chooseFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[[sender selectedItem] representedObject] forKeyPaths:iTM2MetaPostFormatKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseFormat:
- (BOOL)validateChooseFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
        {
			[sender removeAllItems];
			[[sender menu] addItem:[NSMenuItem separatorItem]];// for the title...
			NSArray * RA = [iTM2TeXDistributionController memsAtPath:[[[self document] fileName] stringByDeletingLastPathComponent]];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"MetaPost formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:fmt];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
					[[[sender itemArray] lastObject] setIndentationLevel:1];
				}
			}
			if([sender numberOfItems]==1)
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];		
			RA = [iTM2TeXDistributionController memsAtPath:[iTM2TeXDistributionController formatsPath]];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"MetaPost formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:fmt];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
					[[[sender itemArray] lastObject] setIndentationLevel:1];
				}
			}
		}
		return ![[self editInfoForKeyPaths:iTM2MetaPostParseFirstLineKey,nil] boolValue];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchFormat:
- (IBAction)switchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[NSNumber numberWithBool:[[sender selectedCell] tag] != 0] forKeyPaths:iTM2MetaPostParseFirstLineKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL flag = [[self editInfoForKeyPaths:iTM2MetaPostParseFirstLineKey,nil] boolValue];
    [sender selectCellWithTag: (flag? 1:0)];
	if([[self editInfoForKeyPaths:iTM2MetaPostPARSETranslationKey,nil] boolValue] != flag)
	{
		[self setInfo:[NSNumber numberWithBool:flag] forKeyPaths:iTM2MetaPostPARSETranslationKey,nil];
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleProgName:
- (IBAction)toggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MetaPostUSEProgNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
- (BOOL)validateToggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostUSEProgNameKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
- (IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MetaPostProgNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
- (BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self editInfoForKeyPaths:iTM2MetaPostUSEProgNameKey,nil] boolValue])
    {
        NSString * v = [self editInfoForKeyPaths:iTM2MetaPostProgNameKey,nil];
        if(![v length])
        {
            v = [self editInfoForKeyPaths:iTM2MetaPostFormatKey,nil];
            [self setInfo:v forKeyPaths:iTM2MetaPostProgNameKey,nil];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self editInfoForKeyPaths:iTM2MetaPostFormatKey,nil]?:@"")];
        return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseProgName:
- (IBAction)chooseProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[[sender selectedItem] representedObject] forKeyPaths:iTM2MetaPostProgNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseProgName:
- (BOOL)validateChooseProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
		{
			[sender removeAllItems];
			[[sender menu] addItem:[NSMenuItem separatorItem]];// for the title...
			NSArray * RA = [iTM2TeXDistributionController memsAtPath:[iTM2TeXDistributionController formatsPath]];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"MetaPost formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:fmt];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
					[[[sender itemArray] lastObject] setIndentationLevel:1];
				}
			}
		}
		return [[self editInfoForKeyPaths:iTM2MetaPostUSEProgNameKey,nil] boolValue];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTeXFormat:
- (IBAction)editTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MetaPostTeXFormatKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self editInfoForKeyPaths:iTM2MetaPostTeXFormatKey,nil]?:@"")];
    return ![[self editInfoForKeyPaths:iTM2MetaPostTeXParseFirstLineKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXFormat:
- (IBAction)chooseTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[[sender selectedItem] representedObject] forKeyPaths:iTM2MetaPostTeXFormatKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseTeXFormat:
- (BOOL)validateChooseTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
        {
			[sender removeAllItems];
			[[sender menu] addItem:[NSMenuItem separatorItem]];// for the title...
			NSArray * RA = [iTM2TeXDistributionController memsAtPath:[[[self document] fileName] stringByDeletingLastPathComponent]];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"MetaPost TeX formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:fmt];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
					[[[sender itemArray] lastObject] setIndentationLevel:1];
				}
			}
			if([sender numberOfItems]==1)
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];		
			RA = [iTM2TeXDistributionController memsAtPath:[iTM2TeXDistributionController formatsPath]];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"MetaPost TeX formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:fmt];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
					[[[sender itemArray] lastObject] setIndentationLevel:1];
				}
			}
		}
		return ![[self editInfoForKeyPaths:iTM2MetaPostTeXParseFirstLineKey,nil] boolValue];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchTeXFormat:
- (IBAction)switchTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[NSNumber numberWithBool:[[sender selectedCell] tag] != 0] forKeyPaths:iTM2MetaPostTeXParseFirstLineKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchTeXFormat:
- (BOOL)validateSwitchTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag: ([[self editInfoForKeyPaths:iTM2MetaPostTeXParseFirstLineKey,nil] boolValue]? 1:0)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleConvertToPDF:
- (IBAction)toggleConvertToPDF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[NSNumber numberWithBool: ![[self editInfoForKeyPaths:iTM2MetaPostConvertToPDFKey,nil] boolValue]] forKeyPaths:iTM2MetaPostConvertToPDFKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleConvertToPDF:
- (BOOL)validateToggleConvertToPDF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostConvertToPDFKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchPDFConverter:
- (IBAction)switchPDFConverter:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[NSNumber numberWithInt:[[sender selectedCell] tag]] forKeyPaths:iTM2MetaPostPDFConverterKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchPDFConverter:
- (BOOL)validateSwitchPDFConverter:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [sender selectCellWithTag:[[self editInfoForKeyPaths:iTM2MetaPostPDFConverterKey,nil] intValue]] && [[self editInfoForKeyPaths:iTM2MetaPostConvertToPDFKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
- (IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MetaPostTranslationKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
- (BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self editInfoForKeyPaths:iTM2MetaPostTranslationKey,nil]?:@"")];
    return ![[self editInfoForKeyPaths:iTM2MetaPostPARSETranslationKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchTable:
- (IBAction)switchTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//message catcher
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag: ([[self editInfoForKeyPaths:iTM2MetaPostPARSETranslationKey,nil] boolValue]? 1:0)];
    return NO;
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTROFF:
- (IBAction)toggleTROFF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MetaPostTroffKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTROFF:
- (BOOL)validateToggleTROFF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostTroffKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
- (IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MetaPostIniKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
- (BOOL)validateToggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostIniKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
- (IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MetaPostJobNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
- (BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self editInfoForKeyPaths:iTM2MetaPostJobNameKey,nil]?:@"")];
    return [[self editInfoForKeyPaths:iTM2MetaPostUSEJobNameKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
- (IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MetaPostUSEJobNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
- (BOOL)validateToggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostUSEJobNameKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
#pragma mark =-=-=-=-=-  Output directory
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MetaPostUSEOutputDirectoryKey,nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostUSEOutputDirectoryKey,nil] boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputDirectory:
- (IBAction)editOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MetaPostOutputDirectoryKey,nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputDirectory:
- (BOOL)validateEditOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL enabled = [[self editInfoForKeyPaths:iTM2MetaPostUSEOutputDirectoryKey,nil] boolValue];
    [sender setStringValue: (enabled? ([self editInfoForKeyPaths:iTM2MetaPostOutputDirectoryKey,nil]?:@""):
		[(iTM2TeXProjectDocument*)[self document] commonCommandOutputDirectory])];
//iTM2_END;
    return enabled;
}
#pragma mark =-=-=-=-=-  Interaction
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchInteraction:
- (IBAction)switchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * v;
    switch([[sender selectedCell] tag])
    {
        case 0: v = @"batchmode"; break;
        case 1: v = @"nonstopmode"; break;
        case 2: v = @"scrollmode"; break;
        default:
        case 3: v = @"errorstopmode"; break;
    }
    [self setInfo:v forKeyPaths:iTM2MetaPostInteractionName,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self editInfoForKeyPaths:iTM2MetaPostInteractionName,nil]]];
    return YES;
}
#pragma mark =-=-=-=-=-  DEBUG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFileLineErrorStyle:
- (IBAction)toggleFileLineErrorStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MetaPostFileLineErrorStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineErrorStyle:
- (BOOL)validateToggleFileLineErrorStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostFileLineErrorStyleKey,nil] boolValue]? NSOffState:NSOnState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRecorder:
- (IBAction)toggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MetaPostRecorderKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
- (BOOL)validateToggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MetaPostRecorderKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
@end

@implementation iTM2MainInstaller(mpost)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MetaPostCompleteInstallation
+ (void)iTM2MetaPostCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2EngineMetaPost installBinary];
    [iTM2EngineMPtoPDF installBinary];
    [iTM2EngineMPS2PDF installBinary];
	[[iTM2EngineMetaPost classBundle] installBinaryWithName:@"iTM2_Compile_mp"];
//iTM2_END;
    return;
}
@end

NSString * const iTM2MPtoPDFIsLaTeXKey = @"is_latex";
NSString * const iTM2MPtoPDFIsRawMPKey = @"is_raw_mp";
NSString * const iTM2MPtoPDFUSEPassOnKey = @"USE_pass_on";
NSString * const iTM2MPtoPDFPassOnKey = @"pass_on";

@implementation iTM2EngineMPtoPDF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_mptopdf";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSArray arrayWithObject:@"mp"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:YES], iTM2MPtoPDFIsLaTeXKey,
                [NSNumber numberWithBool:NO], iTM2MPtoPDFIsRawMPKey,
                [NSNumber numberWithBool:NO], iTM2MPtoPDFUSEPassOnKey,
                @"", iTM2MPtoPDFPassOnKey,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isLaTeX
- (BOOL)isLaTeX;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self editInfoForKeyPaths:iTM2MPtoPDFIsLaTeXKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setIsLaTeX:
- (void)setIsLaTeX:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setInfo:[NSNumber numberWithBool:flag] forKeyPaths:iTM2MPtoPDFIsLaTeXKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isRawMP
- (BOOL)isRawMP;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self editInfoForKeyPaths:iTM2MPtoPDFIsRawMPKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setIsRawMP:
- (void)setIsRawMP:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setInfo:[NSNumber numberWithBool:flag] forKeyPaths:iTM2MPtoPDFIsRawMPKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  usePassOn
- (BOOL)usePassOn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self editInfoForKeyPaths:iTM2MPtoPDFUSEPassOnKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUsePassOn:
- (void)setUsePassOn:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setInfo:[NSNumber numberWithBool:flag] forKeyPaths:iTM2MPtoPDFUSEPassOnKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  passOn
- (NSString *)passOn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self editInfoForKeyPaths:iTM2MPtoPDFPassOnKey,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPassOn:
- (void)setPassOn:(NSString *)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setInfo:argument forKeyPaths:iTM2MPtoPDFPassOnKey,nil];
    return;
}
@end

NSString * const iTM2MPS2PDFUseTeXOptionsKey = @"USE_tex_options";
NSString * const iTM2MPS2PDFTeXOptionsKey = @"tex_options";
NSString * const iTM2MPS2PDFUseDviPSOptionsKey = @"USE_dvips_options";
NSString * const iTM2MPS2PDFDviPSOptionsKey = @"dvips_options";

@implementation iTM2EngineMPS2PDF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_mps2pdf";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSArray arrayWithObject:@"mps"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2MPS2PDFUseTeXOptionsKey,
                @"", iTM2MPS2PDFTeXOptionsKey,
                [NSNumber numberWithBool:NO], iTM2MPS2PDFUseDviPSOptionsKey,
                @"", iTM2MPS2PDFDviPSOptionsKey,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  DviPSOptionsEdited:
- (IBAction)DviPSOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MPS2PDFDviPSOptionsKey,nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDviPSOptionsEdited:
- (BOOL)validateDviPSOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self editInfoForKeyPaths:iTM2MPS2PDFDviPSOptionsKey,nil]?:@"")];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXOptionsEdited:
- (IBAction)TeXOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setInfo:[sender stringValue] forKeyPaths:iTM2MPS2PDFTeXOptionsKey,nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTeXOptionsEdited:
- (BOOL)validateTeXOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self editInfoForKeyPaths:iTM2MPS2PDFTeXOptionsKey,nil]?:@"")];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseDviPSOptions:
- (IBAction)toggleUseDviPSOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MPS2PDFUseDviPSOptionsKey,nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseDviPSOptions:
- (BOOL)validateToggleUseDviPSOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MPS2PDFUseDviPSOptionsKey,nil] boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseTeXOptions:
- (IBAction)toggleUseTeXOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2MPS2PDFUseTeXOptionsKey,nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseTeXOptions:
- (BOOL)validateToggleUseTeXOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self editInfoForKeyPaths:iTM2MPS2PDFUseTeXOptionsKey,nil] boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end
