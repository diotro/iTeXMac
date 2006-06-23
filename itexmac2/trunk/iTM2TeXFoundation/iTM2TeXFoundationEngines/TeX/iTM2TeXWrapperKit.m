/*
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

#import "iTM2TeXWrapperKit.h"

// ini
NSString * const iTM2TeX_ini = @"iTM2_TeX_ini";
NSString * const iTM2TeX_mltex = @"iTM2_TeX_mltex";
NSString * const iTM2TeX_enc = @"iTM2_TeX_enc";

NSString * const iTM2TeXMoreArgumentKey = @"iTM2_TeX_MoreArgument";

NSString * const iTM2TeX_mktex = @"iTM2_TeX_mktex";

NSString * const iTM2TeX_USE_output_directory = @"iTM2_TeX_USE_output_directory";
NSString * const iTM2TeX_output_directory = @"iTM2_TeX_output_directory";

// format switcher
NSString * const iTM2TeX_fmt = @"iTM2_TeX_fmt";
NSString * const iTM2TeX_parse_first_line = @"iTM2_TeX_parse_first_line";
NSString * const iTM2TeX_USE_progname = @"iTM2_TeX_USE_progname";
NSString * const iTM2TeX_progname = @"iTM2_TeX_progname";
NSString * const iTM2TeX_USE_jobname = @"iTM2_TeX_USE_jobname";
NSString * const iTM2TeX_jobname = @"iTM2_TeX_jobname";
NSString * const iTM2TeX_shell_escape = @"iTM2_TeX_shell_escape";
NSString * const iTM2TeX_src_specials = @"iTM2_TeX_src_specials";
NSString * const iTM2TeX_src_specials_where_no_cr = @"iTM2_TeX_src_specials_where_no_cr";
NSString * const iTM2TeX_src_specials_where_no_display = @"iTM2_TeX_src_specials_where_no_display";
NSString * const iTM2TeX_src_specials_where_no_hbox = @"iTM2_TeX_src_specials_where_no_hbox";
NSString * const iTM2TeX_src_specials_where_no_parent = @"iTM2_TeX_src_specials_where_no_parent";
NSString * const iTM2TeX_src_specials_where_no_par = @"iTM2_TeX_src_specials_where_no_par";
NSString * const iTM2TeX_src_specials_where_no_math = @"iTM2_TeX_src_specials_where_no_math";
NSString * const iTM2TeX_src_specials_where_no_vbox = @"iTM2_TeX_src_specials_where_no_vbox";
NSString * const iTM2TeX_USE_output_comment = @"iTM2_TeX_USE_output_comment";
NSString * const iTM2TeX_output_comment = @"iTM2_TeX_output_comment";

NSString * const iTM2TeX_USE_translate_file = @"iTM2_TeX_USE_translate_file";
NSString * const iTM2TeX_translate_file = @"iTM2_TeX_translate_file";
NSString * const iTM2TeX_PARSE_translate_file = @"iTM2_TeX_PARSE_translate_file";
// debugger
NSString * const iTM2TeX_recorder = @"iTM2_TeX_recorder";
NSString * const iTM2TeX_file_line_error = @"iTM2_TeX_file_line_error";
NSString * const iTM2TeX_halt_on_error = @"iTM2_TeX_halt_on_error";
NSString * const iTM2TeX_interaction = @"iTM2_TeX_interaction";

NSString * const iTM2TeX_kpathsea_debug = @"iTM2_TeX_kpathsea_debug";


@implementation iTM2EngineTeX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_TeX";
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
    return [NSArray arrayWithObjects:@"tex", @"ltx", @"dvi", @"pdf", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2TeX_parse_first_line,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_translate_file,
                [NSNumber numberWithBool:NO], iTM2TeX_PARSE_translate_file,
                @"", iTM2TeX_translate_file,
                @"errorstopmode", iTM2TeX_interaction,
                @"", iTM2TeX_fmt,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_progname,
                @"", iTM2TeX_progname,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_jobname,
                @"", iTM2TeX_jobname,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_output_comment,
                @"", iTM2TeX_output_comment,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_output_directory,
                @"", iTM2TeX_output_directory,
                [NSNumber numberWithBool:YES], iTM2TeX_file_line_error,
                [NSNumber numberWithBool:NO], iTM2TeX_recorder,
                [NSNumber numberWithBool:NO], iTM2TeX_ini,
                [NSNumber numberWithBool:NO], iTM2TeX_enc,
                [NSNumber numberWithBool:NO], iTM2TeX_mltex,
                [NSNumber numberWithBool:NO], iTM2TeX_shell_escape,
                [NSNumber numberWithBool:NO], iTM2TeX_halt_on_error,
                [NSNumber numberWithBool:YES], iTM2TeX_src_specials,
				@"", iTM2TeXMoreArgumentKey,
					nil];
}
#pragma mark =-=-=-=-=- FORMAT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editFormat:
- (IBAction)editFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2TeX_fmt];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2TeX_fmt]?:@"")];
    return ![self modelFlagForKey:iTM2TeX_parse_first_line];
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
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2TeX_fmt];
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
			NSDictionary * D = [iTM2TeXDistributionController fmtsAtPath:[[[self document] fileName] stringByDeletingLastPathComponent]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			if([sender numberOfItems]==1)
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];		
			D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			RA = [D objectForKey:@"TeX"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
		}
		return ![self modelFlagForKey:iTM2TeX_parse_first_line];
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
    [self takeModelValue:[NSNumber numberWithBool:[[sender selectedCell] tag] != 0] forKey:iTM2TeX_parse_first_line];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag: ([self modelFlagForKey:iTM2TeX_parse_first_line]? 1:0)];
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
    [self toggleModelFlagForKey:iTM2TeX_USE_progname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
- (BOOL)validateToggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_USE_progname]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
- (IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2TeX_progname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
- (BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self modelFlagForKey:iTM2TeX_USE_progname])
    {
        NSString * v = [self modelValueForKey:iTM2TeX_progname];
        if(![v length])
        {
            v = [self modelValueForKey:iTM2TeX_fmt];
            [[self model] takeValue:v forKey:iTM2TeX_progname];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self modelValueForKey:iTM2TeX_fmt]?:@"")];
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
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2TeX_progname];
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
			NSDictionary * D = D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
		}
		return [self modelFlagForKey:iTM2TeX_USE_progname];
	}
    else
        return NO;
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
- (IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2TeX_translate_file];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
- (BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2TeX_translate_file]?:@"")];
    return [self modelFlagForKey:iTM2TeX_USE_translate_file];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTable:
- (IBAction)toggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self toggleModelFlagForKey:iTM2TeX_USE_translate_file];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTable:
- (BOOL)validateToggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_USE_translate_file]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleParseTable:
- (IBAction)toggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self toggleModelFlagForKey:iTM2TeX_PARSE_translate_file];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleParseTable:
- (BOOL)validateToggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_PARSE_translate_file]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2TeX_parse_first_line];
}
#pragma mark =-=-=-=-=-  Output
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecials:
- (IBAction)toggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_src_specials];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vaidateToggleSrcSpecials:
- (BOOL)validateToggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_src_specials]? NSOnState:NSOffState)];
    return ![self modelFlagForKey:iTM2TeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecialsWhere:
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	
	switch([[sender selectedCell] tag])
	{
		case 0:  [self toggleModelFlagForKey:iTM2TeX_src_specials_where_no_cr]; break;
		case 1:  [self toggleModelFlagForKey:iTM2TeX_src_specials_where_no_display]; break;
		case 2:  [self toggleModelFlagForKey:iTM2TeX_src_specials_where_no_hbox]; break;
		case 3:  [self toggleModelFlagForKey:iTM2TeX_src_specials_where_no_parent]; break;
		case 4:  [self toggleModelFlagForKey:iTM2TeX_src_specials_where_no_par]; break;
		case 5:  [self toggleModelFlagForKey:iTM2TeX_src_specials_where_no_math]; break;
		default: [self toggleModelFlagForKey:iTM2TeX_src_specials_where_no_vbox]; break;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSrcSpecialsWhere:
- (BOOL)validateToggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[sender cellWithTag:0] setState: ([self modelFlagForKey:iTM2TeX_src_specials_where_no_cr]? NSOnState:NSOffState)];
	[[sender cellWithTag:1] setState: ([self modelFlagForKey:iTM2TeX_src_specials_where_no_display]? NSOnState:NSOffState)];
	[[sender cellWithTag:2] setState: ([self modelFlagForKey:iTM2TeX_src_specials_where_no_hbox]? NSOnState:NSOffState)];
	[[sender cellWithTag:3] setState: ([self modelFlagForKey:iTM2TeX_src_specials_where_no_parent]? NSOnState:NSOffState)];
	[[sender cellWithTag:4] setState: ([self modelFlagForKey:iTM2TeX_src_specials_where_no_par]? NSOnState:NSOffState)];
	[[sender cellWithTag:5] setState: ([self modelFlagForKey:iTM2TeX_src_specials_where_no_math]? NSOnState:NSOffState)];
	[[sender cellWithTag:6] setState: ([self modelFlagForKey:iTM2TeX_src_specials_where_no_vbox]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2TeX_src_specials] && ![self modelFlagForKey:iTM2TeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputComment:
- (IBAction)toggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_USE_output_comment];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputComment:
- (BOOL)validateToggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_USE_output_comment]? NSOnState:NSOffState)];
    return ![self modelFlagForKey:iTM2TeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputComment:
- (IBAction)editOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2TeX_USE_output_comment];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputComment:
- (BOOL)validateEditOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2TeX_output_comment]?:@"")];
    return [self modelFlagForKey:iTM2TeX_USE_output_comment] && ![self modelFlagForKey:iTM2TeX_ini];
}
#pragma mark =-=-=-=-=-  INI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
- (IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_ini];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
- (BOOL)validateToggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_ini]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnc:
- (IBAction)toggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_enc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnc:
- (BOOL)validateToggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_enc]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2TeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleMLTeX:
- (IBAction)toggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_mltex];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleMLTeX:
- (BOOL)validateToggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_mltex]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2TeX_ini];
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShellEscape:
- (IBAction)toggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_shell_escape];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShellEscape:
- (BOOL)validateToggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_shell_escape]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
- (IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2TeX_jobname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
- (BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2TeX_jobname]?:@"")];
    return [self modelFlagForKey:iTM2TeX_USE_jobname];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
- (IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_USE_jobname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
- (BOOL)validateToggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_USE_jobname]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOuputDirectory:
- (IBAction)editOuputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2TeX_output_directory];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOuputDirectory:
- (BOOL)validateEditOuputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2TeX_output_directory]?:@"")];
    return [self modelFlagForKey:iTM2TeX_USE_output_directory];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_USE_output_directory];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_USE_output_directory]? NSOnState:NSOffState)];
    return YES;
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
    [self takeModelValue:v forKey:iTM2TeX_interaction];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self modelValueForKey:iTM2TeX_interaction]]];
    return YES;
}
#pragma mark =-=-=-=-=-  DEBUG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFileLineError:
- (IBAction)toggleFileLineError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_file_line_error];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineError:
- (BOOL)validateToggleFileLineError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_file_line_error]? NSOffState:NSOnState)];
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
    [self toggleModelFlagForKey:iTM2TeX_recorder];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
- (BOOL)validateToggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_recorder]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleHaltOnError:
- (IBAction)toggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2TeX_halt_on_error];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleHaltOnError:
- (BOOL)validateToggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2TeX_halt_on_error]? NSOnState:NSOffState)];
    return YES;
}
@end

// ini
NSString * const iTM2PDFTeX_ini = @"iTM2_PDFTeX_ini";
NSString * const iTM2PDFTeX_mltex = @"iTM2_PDFTeX_mltex";
NSString * const iTM2PDFTeX_enc = @"iTM2_PDFTeX_enc";

NSString * const iTM2PDFTeXMoreArgumentKey = @"iTM2_PDFTeX_MoreArgument";

NSString * const iTM2PDFTeX_mktex = @"iTM2_PDFTeX_mktex";

NSString * const iTM2PDFTeX_USE_output_directory = @"iTM2_PDFTeX_USE_output_directory";
NSString * const iTM2PDFTeX_output_directory = @"iTM2_PDFTeX_output_directory";

// switcher dvi/pdf
NSString * const iTM2PDFTeX_output_format = @"iTM2_PDFTeX_output_format";
// format switcher
NSString * const iTM2PDFTeX_fmt = @"iTM2_PDFTeX_fmt";
NSString * const iTM2PDFTeX_parse_first_line = @"iTM2_PDFTeX_parse_first_line";
NSString * const iTM2PDFTeX_USE_progname = @"iTM2_PDFTeX_USE_progname";
NSString * const iTM2PDFTeX_progname = @"iTM2_PDFTeX_progname";
NSString * const iTM2PDFTeX_USE_jobname = @"iTM2_PDFTeX_USE_jobname";
NSString * const iTM2PDFTeX_jobname = @"iTM2_PDFTeX_jobname";
NSString * const iTM2PDFTeX_shell_escape = @"iTM2_PDFTeX_shell_escape";
NSString * const iTM2PDFTeX_pdfsync = @"iTM2_PDFTeX_PDFSYNC";
NSString * const iTM2PDFTeX_src_specials = @"iTM2_PDFTeX_src_specials";
NSString * const iTM2PDFTeX_src_specials_where_no_cr = @"iTM2_PDFTeX_src_specials_where_no_cr";
NSString * const iTM2PDFTeX_src_specials_where_no_display = @"iTM2_PDFTeX_src_specials_where_no_display";
NSString * const iTM2PDFTeX_src_specials_where_no_hbox = @"iTM2_PDFTeX_src_specials_where_no_hbox";
NSString * const iTM2PDFTeX_src_specials_where_no_parent = @"iTM2_PDFTeX_src_specials_where_no_parent";
NSString * const iTM2PDFTeX_src_specials_where_no_par = @"iTM2_PDFTeX_src_specials_where_no_par";
NSString * const iTM2PDFTeX_src_specials_where_no_math = @"iTM2_PDFTeX_src_specials_where_no_math";
NSString * const iTM2PDFTeX_src_specials_where_no_vbox = @"iTM2_PDFTeX_src_specials_where_no_vbox";
NSString * const iTM2PDFTeX_USE_output_comment = @"iTM2_PDFTeX_USE_output_comment";
NSString * const iTM2PDFTeX_output_comment = @"iTM2_PDFTeX_output_comment";

NSString * const iTM2PDFTeX_USE_translate_file = @"iTM2_PDFTeX_USE_translate_file";
NSString * const iTM2PDFTeX_translate_file = @"iTM2_PDFTeX_translate_file";
NSString * const iTM2PDFTeX_PARSE_translate_file = @"iTM2_PDFTeX_PARSE_translate_file";
// debugger
NSString * const iTM2PDFTeX_recorder = @"iTM2_PDFTeX_recorder";
NSString * const iTM2PDFTeX_file_line_error = @"iTM2_PDFTeX_file_line_error";
NSString * const iTM2PDFTeX_halt_on_error = @"iTM2_PDFTeX_halt_on_error";
NSString * const iTM2PDFTeX_interaction = @"iTM2_PDFTeX_interaction";

NSString * const iTM2PDFTeX_kpathsea_debug = @"iTM2_PDFTeX_kpathsea_debug";


@implementation iTM2EnginePDFTeX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_PDFTeX";
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
    return [NSArray arrayWithObjects:@"tex", @"ltx", @"dvi", @"pdf", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                @"pdf", iTM2PDFTeX_output_format,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_parse_first_line,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_USE_translate_file,
                @"", iTM2PDFTeX_translate_file,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_PARSE_translate_file,
                @"errorstopmode", iTM2PDFTeX_interaction,
                @"", iTM2PDFTeX_fmt,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_USE_progname,
                @"", iTM2PDFTeX_progname,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_USE_jobname,
                @"", iTM2PDFTeX_jobname,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_USE_output_comment,
                @"", iTM2PDFTeX_output_comment,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_USE_output_directory,
                @"", iTM2PDFTeX_output_directory,
                [NSNumber numberWithBool:YES], iTM2PDFTeX_file_line_error,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_recorder,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_ini,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_enc,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_mltex,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_shell_escape,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_halt_on_error,
                [NSNumber numberWithBool:YES], iTM2PDFTeX_src_specials,
				@"", iTM2PDFTeXMoreArgumentKey,
					nil];
}
#pragma mark =-=-=-=-=- FORMAT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editFormat:
- (IBAction)editFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2PDFTeX_fmt];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2PDFTeX_fmt]?:@"")];
    return ![self modelFlagForKey:iTM2PDFTeX_parse_first_line];
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
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2TeX_fmt];
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
	else if([sender isKindOfClass:[NSPopUpButton class]] && ([sender numberOfItems]<2))
	{
		[sender removeAllItems];
		[[sender menu] addItem:[NSMenuItem separatorItem]];// for the title...
		NSDictionary * D = [iTM2TeXDistributionController fmtsAtPath:[[[self document] fileName] stringByDeletingLastPathComponent]];// beware, hard coded format location
		NSArray * RA = [D objectForKey:@"PDFTeX"];
		if([RA count])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDFTeX formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
			NSEnumerator * E = [RA objectEnumerator];
			NSString * fmt;
			while(fmt = [E nextObject])
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[[[sender itemArray] lastObject] setRepresentedObject:fmt];
			}
		}
		RA = [D objectForKey:@"Other"];
		if([RA count])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
			NSEnumerator * E = [RA objectEnumerator];
			NSString * fmt;
			while(fmt = [E nextObject])
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[[[sender itemArray] lastObject] setRepresentedObject:fmt];
			}
		}
		if([sender numberOfItems]==1)
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];		
		D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
		RA = [D objectForKey:@"PDFTeX"];
		if([RA count])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDFTeX formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
			NSEnumerator * E = [RA objectEnumerator];
			NSString * fmt;
			while(fmt = [E nextObject])
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[[[sender itemArray] lastObject] setRepresentedObject:fmt];
			}
		}
		RA = [D objectForKey:@"Other"];
		if([RA count])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
			NSEnumerator * E = [RA objectEnumerator];
			NSString * fmt;
			while(fmt = [E nextObject])
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[[[sender itemArray] lastObject] setRepresentedObject:fmt];
			}
		}
	}
    return YES;
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
    [self takeModelValue:[NSNumber numberWithBool:[[sender selectedCell] tag] != 0] forKey:iTM2PDFTeX_parse_first_line];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag: ([self modelFlagForKey:iTM2PDFTeX_parse_first_line]? 1:0)];
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
    [self toggleModelFlagForKey:iTM2PDFTeX_USE_progname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
- (BOOL)validateToggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_USE_progname]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
- (IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2PDFTeX_progname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
- (BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self modelFlagForKey:iTM2PDFTeX_USE_progname])
    {
        NSString * v = [self modelValueForKey:iTM2PDFTeX_progname];
        if(![v length])
        {
            v = [self modelValueForKey:iTM2PDFTeX_fmt];
            [[self model] takeValue:v forKey:iTM2PDFTeX_progname];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self modelValueForKey:iTM2PDFTeX_fmt]?:@"")];
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
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2PDFTeX_progname];
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
			NSDictionary * D = D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"PDFTeX"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDFTeX formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
		}
		return [self modelFlagForKey:iTM2PDFTeX_USE_progname];
	}
    else
        return NO;
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
- (IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2PDFTeX_translate_file];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
- (BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2PDFTeX_translate_file]?:@"")];
    return [self modelFlagForKey:iTM2PDFTeX_USE_translate_file];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTable:
- (IBAction)toggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self toggleModelFlagForKey:iTM2PDFTeX_USE_translate_file];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTable:
- (BOOL)validateToggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_USE_translate_file]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleParseTable:
- (IBAction)toggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self toggleModelFlagForKey:iTM2PDFTeX_PARSE_translate_file];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleParseTable:
- (BOOL)validateToggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_parse_first_line]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2PDFTeX_parse_first_line];
}
#pragma mark =-=-=-=-=-  Output
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputFormat:
- (IBAction)toggleOutputFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue: ([[sender selectedCell] tag]? @"dvi":@"pdf") forKey:iTM2PDFTeX_output_format];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputFormat:
- (BOOL)validateToggleOutputFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender selectCellWithTag: ([[self modelValueForKey:iTM2PDFTeX_output_format] isEqual:@"pdf"]? 0:1)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecials:
- (IBAction)toggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_src_specials];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vaidateToggleSrcSpecials:
- (BOOL)validateToggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials]? NSOnState:NSOffState)];
    return [[self modelValueForKey:iTM2PDFTeX_output_format] isEqual:@"dvi"]
			&& ![self modelFlagForKey:iTM2PDFTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecialsWhere:
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	
	switch([[sender selectedCell] tag])
	{
		case 0:  [self toggleModelFlagForKey:iTM2PDFTeX_src_specials_where_no_cr]; break;
		case 1:  [self toggleModelFlagForKey:iTM2PDFTeX_src_specials_where_no_display]; break;
		case 2:  [self toggleModelFlagForKey:iTM2PDFTeX_src_specials_where_no_hbox]; break;
		case 3:  [self toggleModelFlagForKey:iTM2PDFTeX_src_specials_where_no_parent]; break;
		case 4:  [self toggleModelFlagForKey:iTM2PDFTeX_src_specials_where_no_par]; break;
		case 5:  [self toggleModelFlagForKey:iTM2PDFTeX_src_specials_where_no_math]; break;
		default: [self toggleModelFlagForKey:iTM2PDFTeX_src_specials_where_no_vbox]; break;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSrcSpecialsWhere:
- (BOOL)validateToggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[sender cellWithTag:0] setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials_where_no_cr]? NSOnState:NSOffState)];
	[[sender cellWithTag:1] setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials_where_no_display]? NSOnState:NSOffState)];
	[[sender cellWithTag:2] setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials_where_no_hbox]? NSOnState:NSOffState)];
	[[sender cellWithTag:3] setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials_where_no_parent]? NSOnState:NSOffState)];
	[[sender cellWithTag:4] setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials_where_no_par]? NSOnState:NSOffState)];
	[[sender cellWithTag:5] setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials_where_no_math]? NSOnState:NSOffState)];
	[[sender cellWithTag:6] setState: ([self modelFlagForKey:iTM2PDFTeX_src_specials_where_no_vbox]? NSOnState:NSOffState)];
    return [[self modelValueForKey:iTM2PDFTeX_output_format] isEqual:@"dvi"]
		&& [self modelFlagForKey:iTM2PDFTeX_src_specials] && ![self modelFlagForKey:iTM2PDFTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputComment:
- (IBAction)toggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_USE_output_comment];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputComment:
- (BOOL)validateToggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_USE_output_comment]? NSOnState:NSOffState)];
    return [[self modelValueForKey:iTM2PDFTeX_output_format] isEqual:@"dvi"]
			&& ![self modelFlagForKey:iTM2PDFTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputComment:
- (IBAction)editOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2PDFTeX_USE_output_comment];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputComment:
- (BOOL)validateEditOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2PDFTeX_output_comment]?:@"")];
//iTM2_LOG(@"[self modelValueForKey:iTM2PDFTeX_USE_output_comment]: %@", [self modelValueForKey:iTM2PDFTeX_USE_output_comment]);
//iTM2_LOG(@"clas: %@", [[self modelValueForKey:iTM2PDFTeX_USE_output_comment] class]);
    return [self modelFlagForKey:iTM2PDFTeX_USE_output_comment]
		&& [[self modelValueForKey:iTM2PDFTeX_output_format] isEqual:@"dvi"]
			&& ![self modelFlagForKey:iTM2PDFTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePdfSync:
- (IBAction)togglePdfSync:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_pdfsync];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePdfSync:
- (BOOL)validateTogglePdfSync:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_pdfsync]? NSOnState:NSOffState)];
    return [[self modelValueForKey:iTM2PDFTeX_output_format] isEqual:@"pdf"];
}
#pragma mark =-=-=-=-=-  INI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
- (IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_ini];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
- (BOOL)validateToggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_ini]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnc:
- (IBAction)toggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_enc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnc:
- (BOOL)validateToggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_enc]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2PDFTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleMLTeX:
- (IBAction)toggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_mltex];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleMLTeX:
- (BOOL)validateToggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_mltex]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2PDFTeX_ini];
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShellEscape:
- (IBAction)toggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_shell_escape];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShellEscape:
- (BOOL)validateToggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_shell_escape]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
- (IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2PDFTeX_jobname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
- (BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2PDFTeX_jobname]?:@"")];
    return [self modelFlagForKey:iTM2PDFTeX_USE_jobname];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
- (IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_USE_jobname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
- (BOOL)validateToggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_USE_jobname]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputDirectory:
- (IBAction)editOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2PDFTeX_output_directory];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputDirectory:
- (BOOL)validateEditOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2PDFTeX_output_directory]?:@"")];
    return [self modelFlagForKey:iTM2PDFTeX_USE_output_directory];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_USE_output_directory];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_USE_output_directory]? NSOnState:NSOffState)];
    return YES;
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
    [self takeModelValue:v forKey:iTM2PDFTeX_interaction];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self modelValueForKey:iTM2PDFTeX_interaction]]];
    return YES;
}
#pragma mark =-=-=-=-=-  DEBUG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFileLineError:
- (IBAction)toggleFileLineError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_file_line_error];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineError:
- (BOOL)validateToggleFileLineError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_file_line_error]? NSOffState:NSOnState)];
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
    [self toggleModelFlagForKey:iTM2PDFTeX_recorder];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
- (BOOL)validateToggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_recorder]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleHaltOnError:
- (IBAction)toggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2PDFTeX_halt_on_error];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleHaltOnError:
- (BOOL)validateToggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2PDFTeX_halt_on_error]? NSOnState:NSOffState)];
    return YES;
}
@end

// ini
NSString * const iTM2XeTeX_ini = @"iTM2_XeTeX_ini";
NSString * const iTM2XeTeX_mltex = @"iTM2_XeTeX_mltex";
NSString * const iTM2XeTeX_enc = @"iTM2_XeTeX_enc";

NSString * const iTM2XeTeXMoreArgumentKey = @"iTM2_XeTeX_MoreArgument";

NSString * const iTM2XeTeX_mktex = @"iTM2_XeTeX_mktex";

NSString * const iTM2XeTeX_USE_output_directory = @"iTM2_XeTeX_USE_output_directory";
NSString * const iTM2XeTeX_output_directory = @"iTM2_XeTeX_output_directory";

// format switcher
NSString * const iTM2XeTeX_fmt = @"iTM2_XeTeX_fmt";
NSString * const iTM2XeTeX_parse_first_line = @"iTM2_XeTeX_parse_first_line";
NSString * const iTM2XeTeX_USE_progname = @"iTM2_XeTeX_USE_progname";
NSString * const iTM2XeTeX_progname = @"iTM2_XeTeX_progname";
NSString * const iTM2XeTeX_USE_jobname = @"iTM2_XeTeX_USE_jobname";
NSString * const iTM2XeTeX_jobname = @"iTM2_XeTeX_jobname";
NSString * const iTM2XeTeX_shell_escape = @"iTM2_XeTeX_shell_escape";
NSString * const iTM2XeTeX_src_specials = @"iTM2_XeTeX_src_specials";
NSString * const iTM2XeTeX_src_specials_where_no_cr = @"iTM2_XeTeX_src_specials_where_no_cr";
NSString * const iTM2XeTeX_src_specials_where_no_display = @"iTM2_XeTeX_src_specials_where_no_display";
NSString * const iTM2XeTeX_src_specials_where_no_hbox = @"iTM2_XeTeX_src_specials_where_no_hbox";
NSString * const iTM2XeTeX_src_specials_where_no_parent = @"iTM2_XeTeX_src_specials_where_no_parent";
NSString * const iTM2XeTeX_src_specials_where_no_par = @"iTM2_XeTeX_src_specials_where_no_par";
NSString * const iTM2XeTeX_src_specials_where_no_math = @"iTM2_XeTeX_src_specials_where_no_math";
NSString * const iTM2XeTeX_src_specials_where_no_vbox = @"iTM2_XeTeX_src_specials_where_no_vbox";
NSString * const iTM2XeTeX_USE_output_comment = @"iTM2_XeTeX_USE_output_comment";
NSString * const iTM2XeTeX_output_comment = @"iTM2_XeTeX_output_comment";

NSString * const iTM2XeTeX_USE_translate_file = @"iTM2_XeTeX_USE_translate_file";
NSString * const iTM2XeTeX_translate_file = @"iTM2_XeTeX_translate_file";
NSString * const iTM2XeTeX_PARSE_translate_file = @"iTM2_XeTeX_PARSE_translate_file";
// debugger
NSString * const iTM2XeTeX_recorder = @"iTM2_XeTeX_recorder";
NSString * const iTM2XeTeX_file_line_error = @"iTM2_XeTeX_file_line_error";
NSString * const iTM2XeTeX_halt_on_error = @"iTM2_XeTeX_halt_on_error";
NSString * const iTM2XeTeX_interaction = @"iTM2_XeTeX_interaction";

NSString * const iTM2XeTeX_kpathsea_debug = @"iTM2_XeTeX_kpathsea_debug";


@implementation iTM2EngineXeTeX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_XeTeX";
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
    return [NSArray arrayWithObjects:@"tex", @"ltx", @"dvi", @"pdf", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2XeTeX_parse_first_line,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_translate_file,
                [NSNumber numberWithBool:NO], iTM2XeTeX_PARSE_translate_file,
                @"", iTM2XeTeX_translate_file,
                @"errorstopmode", iTM2XeTeX_interaction,
                @"", iTM2XeTeX_fmt,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_progname,
                @"", iTM2XeTeX_progname,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_jobname,
                @"", iTM2XeTeX_jobname,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_output_comment,
                @"", iTM2XeTeX_output_comment,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_output_directory,
                @"", iTM2XeTeX_output_directory,
                [NSNumber numberWithBool:YES], iTM2XeTeX_file_line_error,
                [NSNumber numberWithBool:NO], iTM2XeTeX_recorder,
                [NSNumber numberWithBool:NO], iTM2XeTeX_ini,
                [NSNumber numberWithBool:NO], iTM2XeTeX_enc,
                [NSNumber numberWithBool:NO], iTM2XeTeX_mltex,
                [NSNumber numberWithBool:NO], iTM2XeTeX_shell_escape,
                [NSNumber numberWithBool:NO], iTM2XeTeX_halt_on_error,
                [NSNumber numberWithBool:YES], iTM2XeTeX_src_specials,
				@"", iTM2XeTeXMoreArgumentKey,
					nil];
}
#pragma mark =-=-=-=-=- FORMAT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editFormat:
- (IBAction)editFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2XeTeX_fmt];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2XeTeX_fmt]?:@"")];
    return ![self modelFlagForKey:iTM2XeTeX_parse_first_line];
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
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2XeTeX_fmt];
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
			NSDictionary * D = [iTM2TeXDistributionController fmtsAtPath:[[[self document] fileName] stringByDeletingLastPathComponent]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats(Project)", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			if([sender numberOfItems]==1)
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];		
			D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			RA = [D objectForKey:@"TeX"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
		}
		return ![self modelFlagForKey:iTM2XeTeX_parse_first_line];
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
    [self takeModelValue:[NSNumber numberWithBool:[[sender selectedCell] tag] != 0] forKey:iTM2XeTeX_parse_first_line];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag: ([self modelFlagForKey:iTM2XeTeX_parse_first_line]? 1:0)];
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
    [self toggleModelFlagForKey:iTM2XeTeX_USE_progname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
- (BOOL)validateToggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_USE_progname]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
- (IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2XeTeX_progname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
- (BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self modelFlagForKey:iTM2XeTeX_USE_progname])
    {
        NSString * v = [self modelValueForKey:iTM2XeTeX_progname];
        if(![v length])
        {
            v = [self modelValueForKey:iTM2XeTeX_fmt];
            [[self model] takeValue:v forKey:iTM2XeTeX_progname];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self modelValueForKey:iTM2XeTeX_fmt]?:@"")];
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
    [self takeModelValue:[[sender selectedItem] representedObject] forKey:iTM2XeTeX_progname];
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
			NSDictionary * D = D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if([RA count])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:isa], "")];
				NSEnumerator * E = [RA objectEnumerator];
				NSString * fmt;
				while(fmt = [E nextObject])
				{
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[[[sender itemArray] lastObject] setRepresentedObject:fmt];
				}
			}
		}
		return [self modelFlagForKey:iTM2XeTeX_USE_progname];
	}
    else
        return NO;
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
- (IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2XeTeX_translate_file];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
- (BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2XeTeX_translate_file]?:@"")];
    return [self modelFlagForKey:iTM2XeTeX_USE_translate_file];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTable:
- (IBAction)toggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self toggleModelFlagForKey:iTM2XeTeX_USE_translate_file];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTable:
- (BOOL)validateToggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_USE_translate_file]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleParseTable:
- (IBAction)toggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self toggleModelFlagForKey:iTM2XeTeX_PARSE_translate_file];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleParseTable:
- (BOOL)validateToggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_PARSE_translate_file]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2XeTeX_parse_first_line];
}
#pragma mark =-=-=-=-=-  Output
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecials:
- (IBAction)toggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_src_specials];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vaidateToggleSrcSpecials:
- (BOOL)validateToggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_src_specials]? NSOnState:NSOffState)];
    return ![self modelFlagForKey:iTM2XeTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecialsWhere:
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	
	switch([[sender selectedCell] tag])
	{
		case 0:  [self toggleModelFlagForKey:iTM2XeTeX_src_specials_where_no_cr]; break;
		case 1:  [self toggleModelFlagForKey:iTM2XeTeX_src_specials_where_no_display]; break;
		case 2:  [self toggleModelFlagForKey:iTM2XeTeX_src_specials_where_no_hbox]; break;
		case 3:  [self toggleModelFlagForKey:iTM2XeTeX_src_specials_where_no_parent]; break;
		case 4:  [self toggleModelFlagForKey:iTM2XeTeX_src_specials_where_no_par]; break;
		case 5:  [self toggleModelFlagForKey:iTM2XeTeX_src_specials_where_no_math]; break;
		default: [self toggleModelFlagForKey:iTM2XeTeX_src_specials_where_no_vbox]; break;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSrcSpecialsWhere:
- (BOOL)validateToggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[sender cellWithTag:0] setState: ([self modelFlagForKey:iTM2XeTeX_src_specials_where_no_cr]? NSOnState:NSOffState)];
	[[sender cellWithTag:1] setState: ([self modelFlagForKey:iTM2XeTeX_src_specials_where_no_display]? NSOnState:NSOffState)];
	[[sender cellWithTag:2] setState: ([self modelFlagForKey:iTM2XeTeX_src_specials_where_no_hbox]? NSOnState:NSOffState)];
	[[sender cellWithTag:3] setState: ([self modelFlagForKey:iTM2XeTeX_src_specials_where_no_parent]? NSOnState:NSOffState)];
	[[sender cellWithTag:4] setState: ([self modelFlagForKey:iTM2XeTeX_src_specials_where_no_par]? NSOnState:NSOffState)];
	[[sender cellWithTag:5] setState: ([self modelFlagForKey:iTM2XeTeX_src_specials_where_no_math]? NSOnState:NSOffState)];
	[[sender cellWithTag:6] setState: ([self modelFlagForKey:iTM2XeTeX_src_specials_where_no_vbox]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2XeTeX_src_specials] && ![self modelFlagForKey:iTM2XeTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputComment:
- (IBAction)toggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_USE_output_comment];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputComment:
- (BOOL)validateToggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_USE_output_comment]? NSOnState:NSOffState)];
    return ![self modelFlagForKey:iTM2XeTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputComment:
- (IBAction)editOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2XeTeX_USE_output_comment];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputComment:
- (BOOL)validateEditOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2XeTeX_output_comment]?:@"")];
    return [self modelFlagForKey:iTM2XeTeX_USE_output_comment] && ![self modelFlagForKey:iTM2XeTeX_ini];
}
#pragma mark =-=-=-=-=-  INI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
- (IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_ini];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
- (BOOL)validateToggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_ini]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnc:
- (IBAction)toggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_enc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnc:
- (BOOL)validateToggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_enc]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2XeTeX_ini];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleMLTeX:
- (IBAction)toggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_mltex];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleMLTeX:
- (BOOL)validateToggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_mltex]? NSOnState:NSOffState)];
    return [self modelFlagForKey:iTM2XeTeX_ini];
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShellEscape:
- (IBAction)toggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_shell_escape];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShellEscape:
- (BOOL)validateToggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_shell_escape]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
- (IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2XeTeX_jobname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
- (BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2XeTeX_jobname]?:@"")];
    return [self modelFlagForKey:iTM2XeTeX_USE_jobname];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
- (IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_USE_jobname];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
- (BOOL)validateToggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_USE_jobname]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOuputDirectory:
- (IBAction)editOuputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeModelValue:[sender stringValue] forKey:iTM2XeTeX_output_directory];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOuputDirectory:
- (BOOL)validateEditOuputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self modelValueForKey:iTM2XeTeX_output_directory]?:@"")];
    return [self modelFlagForKey:iTM2XeTeX_USE_output_directory];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_USE_output_directory];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_USE_output_directory]? NSOnState:NSOffState)];
    return YES;
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
    [self takeModelValue:v forKey:iTM2XeTeX_interaction];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self modelValueForKey:iTM2XeTeX_interaction]]];
    return YES;
}
#pragma mark =-=-=-=-=-  DEBUG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFileLineError:
- (IBAction)toggleFileLineError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_file_line_error];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineError:
- (BOOL)validateToggleFileLineError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_file_line_error]? NSOffState:NSOnState)];
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
    [self toggleModelFlagForKey:iTM2XeTeX_recorder];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
- (BOOL)validateToggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_recorder]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleHaltOnError:
- (IBAction)toggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleModelFlagForKey:iTM2XeTeX_halt_on_error];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleHaltOnError:
- (BOOL)validateToggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([self modelFlagForKey:iTM2XeTeX_halt_on_error]? NSOnState:NSOffState)];
    return YES;
}
@end

@implementation iTM2MainInstaller(TeXWrapperKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXWrapperKitCompleteInstallation
+ (void)iTM2TeXWrapperKitCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2EngineTeX installBinary];
    [iTM2EnginePDFTeX installBinary];
    [iTM2EngineXeTeX installBinary];
//iTM2_END;
    return;
}
@end
