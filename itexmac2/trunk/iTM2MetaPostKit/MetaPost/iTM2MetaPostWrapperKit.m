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

NSString * const iTM2MetaPostParseFirstLineKey = @"iTM2_MP_parse_first_line";
NSString * const iTM2MetaPostPARSETranslationKey = @"iTM2_MP_PARSE_translate";
NSString * const iTM2MetaPostUSETranslationKey = @"iTM2_MP_USE_translate";
NSString * const iTM2MetaPostTranslationKey = @"iTM2_MP_translate_file";
NSString * const iTM2MetaPostInteractionName = @"iTM2_MP_interaction";
NSString * const iTM2MetaPostFormatKey = @"iTM2_MP_mem";
NSString * const iTM2MetaPostUSEProgNameKey = @"iTM2_MP_USE_progname";
NSString * const iTM2MetaPostProgNameKey = @"iTM2_MP_progname";
NSString * const iTM2MetaPostUSEJobNameKey = @"iTM2_MP_USE_jobname";
NSString * const iTM2MetaPostJobNameKey = @"iTM2_MP_jobname";
NSString * const iTM2MetaPostFileLineErrorStyleKey = @"iTM2_MP_file_line_error";
NSString * const iTM2MetaPostRecorderKey = @"iTM2_MP_recorder";
NSString * const iTM2MetaPostIniKey = @"iTM2_MP_ini";
NSString * const iTM2MetaPostTroffKey = @"iTM2_MP_troff";
NSString * const iTM2MetaPostHaltOnErrorKey = @"iTM2_MP_halt_on_error";
NSString * const iTM2MetaPostOutputDirectoryKey = @"iTM2_MP_output_directory";
NSString * const iTM2MetaPostUSEOutputDirectoryKey = @"iTM2_MP_USE_output_directory";
NSString * const iTM2MetaPostTeXParseFirstLineKey = @"iTM2_MP_TeX_parse_first_line";
NSString * const iTM2MetaPostTeXFormatKey = @"iTM2_MP_TeX_format";
NSString * const iTM2MetaPostConvertToPDFKey = @"iTM2_MP_convert_to_pdf";
NSString * const iTM2MetaPostPDFConverterKey = @"iTM2_MP_pdf_converter";

@implementation iTM2EngineMetaPost
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+(NSString *)engineMode;
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
+(NSArray *)inputFileExtensions;
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
+(NSDictionary *)defaultShellEnvironment;
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
-(IBAction)editFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MetaPostFormatKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
-(BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2MetaPostFormatKey]?:@"")];
    return ![self modelFlagForKey:iTM2MetaPostParseFirstLineKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseFormat:
-(IBAction)chooseFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2MetaPostFormatKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseFormat:
-(BOOL)validateChooseFormat:(id)sender;
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
		return ![self modelFlagForKey:iTM2MetaPostParseFirstLineKey];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchFormat:
-(IBAction)switchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[NSNumber numberWithBool:[[sender selectedCell] tag] != 0] forKey:iTM2MetaPostParseFirstLineKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
-(BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL flag = [self modelFlagForKey:iTM2MetaPostParseFirstLineKey];
    [sender selectCellWithTag: (flag? 1:0)];
	if([self modelFlagForKey:iTM2MetaPostPARSETranslationKey] != flag)
	{
		[self takeModelValue:[NSNumber numberWithBool:flag] forKey:iTM2MetaPostPARSETranslationKey];
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleProgName:
-(IBAction)toggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MetaPostUSEProgNameKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
-(BOOL)validateToggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostUSEProgNameKey]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
-(IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MetaPostProgNameKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
-(BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self modelFlagForKey:iTM2MetaPostUSEProgNameKey])
    {
        NSString * v = [self modelValueForKey:iTM2MetaPostProgNameKey];
        if(![v length])
        {
            v = [self modelValueForKey:iTM2MetaPostFormatKey];
            [[self model] takeValue:v forKey:iTM2MetaPostProgNameKey];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self modelValueForKey:iTM2MetaPostFormatKey]?:@"")];
        return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseProgName:
-(IBAction)chooseProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2MetaPostProgNameKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseProgName:
-(BOOL)validateChooseProgName:(id)sender;
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
		return [self modelFlagForKey:iTM2MetaPostUSEProgNameKey];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTeXFormat:
-(IBAction)editTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MetaPostTeXFormatKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
-(BOOL)validateEditTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2MetaPostTeXFormatKey]?:@"")];
    return ![self modelFlagForKey:iTM2MetaPostTeXParseFirstLineKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXFormat:
-(IBAction)chooseTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2MetaPostTeXFormatKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseTeXFormat:
-(BOOL)validateChooseTeXFormat:(id)sender;
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
		return ![self modelFlagForKey:iTM2MetaPostTeXParseFirstLineKey];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchTeXFormat:
-(IBAction)switchTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[NSNumber numberWithBool:[[sender selectedCell] tag] != 0] forKey:iTM2MetaPostTeXParseFirstLineKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchTeXFormat:
-(BOOL)validateSwitchTeXFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag: ([self modelFlagForKey:iTM2MetaPostTeXParseFirstLineKey]? 1:0)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleConvertToPDF:
-(IBAction)toggleConvertToPDF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[NSNumber numberWithBool: ![self modelFlagForKey:iTM2MetaPostConvertToPDFKey]] forKey:iTM2MetaPostConvertToPDFKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleConvertToPDF:
-(BOOL)validateToggleConvertToPDF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostConvertToPDFKey]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchPDFConverter:
-(IBAction)switchPDFConverter:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[NSNumber numberWithInt:[[sender selectedCell] tag]] forKey:iTM2MetaPostPDFConverterKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchPDFConverter:
-(BOOL)validateSwitchPDFConverter:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [sender selectCellWithTag:[[self modelValueForKey:iTM2MetaPostPDFConverterKey] intValue]] && [self modelFlagForKey:iTM2MetaPostConvertToPDFKey];
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
-(IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MetaPostTranslationKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
-(BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2MetaPostTranslationKey]?:@"")];
    return ![self modelFlagForKey:iTM2MetaPostPARSETranslationKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchTable:
-(IBAction)switchTable:(id)sender;
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
-(BOOL)validateSwitchTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag: ([self modelFlagForKey:iTM2MetaPostPARSETranslationKey]? 1:0)];
    return NO;
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTROFF:
-(IBAction)toggleTROFF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MetaPostTroffKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTROFF:
-(BOOL)validateToggleTROFF:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostTroffKey]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
-(IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MetaPostIniKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
-(BOOL)validateToggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostIniKey]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
-(IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MetaPostJobNameKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
-(BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2MetaPostJobNameKey]?:@"")];
    return [self modelFlagForKey:iTM2MetaPostUSEJobNameKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
-(IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MetaPostUSEJobNameKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
-(BOOL)validateToggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostUSEJobNameKey]? NSOnState:NSOffState)];
    return YES;
}
#pragma mark =-=-=-=-=-  Output directory
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
-(IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MetaPostUSEOutputDirectoryKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
-(BOOL)validateToggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostUSEOutputDirectoryKey]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputDirectory:
-(IBAction)editOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MetaPostOutputDirectoryKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputDirectory:
-(BOOL)validateEditOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL enabled = [self modelFlagForKey:iTM2MetaPostUSEOutputDirectoryKey];
    [sender setStringValue: (enabled? ([self modelValueForKey:iTM2MetaPostOutputDirectoryKey]?:@""):
		[(iTM2TeXProjectDocument*)[self document] commonCommandOutputDirectory])];
//iTM2_END;
    return enabled;
}
#pragma mark =-=-=-=-=-  Interaction
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchInteraction:
-(IBAction)switchInteraction:(id)sender;
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
    [self takeModelValue:v forKey:iTM2MetaPostInteractionName];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
-(BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self modelValueForKey:iTM2MetaPostInteractionName]]];
    return YES;
}
#pragma mark =-=-=-=-=-  DEBUG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFileLineErrorStyle:
-(IBAction)toggleFileLineErrorStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MetaPostFileLineErrorStyleKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineErrorStyle:
-(BOOL)validateToggleFileLineErrorStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostFileLineErrorStyleKey]? NSOffState:NSOnState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRecorder:
-(IBAction)toggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MetaPostRecorderKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
-(BOOL)validateToggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MetaPostRecorderKey]? NSOnState:NSOffState)];
    return YES;
}
@end

@implementation iTM2MainInstaller(mpost)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MetaPostCompleteInstallation
+(void)iTM2MetaPostCompleteInstallation;
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

NSString * const iTM2MPtoPDFIsLaTeXKey = @"iTM2_MPtoPDF_is_latex";
NSString * const iTM2MPtoPDFIsRawMPKey = @"iTM2_MPtoPDF_is_raw_mp";
NSString * const iTM2MPtoPDFUSEPassOnKey = @"iTM2_MPtoPDF_USE_pass_on";
NSString * const iTM2MPtoPDFPassOnKey = @"iTM2_MPtoPDF_pass_on";

@implementation iTM2EngineMPtoPDF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+(NSString *)engineMode;
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
+(NSArray *)inputFileExtensions;
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
+(NSDictionary *)defaultShellEnvironment;
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
-(BOOL)isLaTeX;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self modelValueForKey:iTM2MPtoPDFIsLaTeXKey] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setIsLaTeX:
-(void)setIsLaTeX:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeModelValue:[NSNumber numberWithBool:flag] forKey:iTM2MPtoPDFIsLaTeXKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isRawMP
-(BOOL)isRawMP;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self modelValueForKey:iTM2MPtoPDFIsRawMPKey] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setIsRawMP:
-(void)setIsRawMP:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeModelValue:[NSNumber numberWithBool:flag] forKey:iTM2MPtoPDFIsRawMPKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  usePassOn
-(BOOL)usePassOn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self modelValueForKey:iTM2MPtoPDFUSEPassOnKey] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUsePassOn:
-(void)setUsePassOn:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeModelValue:[NSNumber numberWithBool:flag] forKey:iTM2MPtoPDFUSEPassOnKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  passOn
-(NSString *)passOn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self modelValueForKey:iTM2MPtoPDFPassOnKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPassOn:
-(void)setPassOn:(NSString *)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeModelValue:argument forKey:iTM2MPtoPDFPassOnKey];
    return;
}
@end

NSString * const iTM2MPS2PDFUseTeXOptionsKey = @"iTM2_MPS2PDF_USE_tex_options";
NSString * const iTM2MPS2PDFTeXOptionsKey = @"iTM2_MPS2PDF_tex_options";
NSString * const iTM2MPS2PDFUseDviPSOptionsKey = @"iTM2_MPS2PDF_USE_dvips_options";
NSString * const iTM2MPS2PDFDviPSOptionsKey = @"iTM2_MPS2PDF_dvips_options";

@implementation iTM2EngineMPS2PDF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+(NSString *)engineMode;
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
+(NSArray *)inputFileExtensions;
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
+(NSDictionary *)defaultShellEnvironment;
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
-(IBAction)DviPSOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MPS2PDFDviPSOptionsKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDviPSOptionsEdited:
-(BOOL)validateDviPSOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2MPS2PDFDviPSOptionsKey]?:@"")];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXOptionsEdited:
-(IBAction)TeXOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2MPS2PDFTeXOptionsKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTeXOptionsEdited:
-(BOOL)validateTeXOptionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2MPS2PDFTeXOptionsKey]?:@"")];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseDviPSOptions:
-(IBAction)toggleUseDviPSOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MPS2PDFUseDviPSOptionsKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseDviPSOptions:
-(BOOL)validateToggleUseDviPSOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MPS2PDFUseDviPSOptionsKey]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseTeXOptions:
-(IBAction)toggleUseTeXOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2MPS2PDFUseTeXOptionsKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseTeXOptions:
-(BOOL)validateToggleUseTeXOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2MPS2PDFUseTeXOptionsKey]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end
