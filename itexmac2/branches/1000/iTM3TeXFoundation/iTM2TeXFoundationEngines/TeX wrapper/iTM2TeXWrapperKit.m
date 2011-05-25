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
NSString * const iTM2TeX_ini = @"ini";
NSString * const iTM2TeX_mltex = @"mltex";
NSString * const iTM2TeX_enc = @"enc";

NSString * const iTM2TeXMoreArgumentKey = @"MoreArgument";

NSString * const iTM2TeX_mktex = @"mktex";

NSString * const iTM2TeX_USE_output_directory = @"USE_output_directory";
NSString * const iTM2TeX_output_directory = @"output_directory";

// format switcher
NSString * const iTM2TeX_fmt = @"fmt";
NSString * const iTM2TeX_PARSE_first_line = @"PARSE_first_line";
NSString * const iTM2TeX_USE_progname = @"USE_progname";
NSString * const iTM2TeX_progname = @"progname";
NSString * const iTM2TeX_USE_jobname = @"USE_jobname";
NSString * const iTM2TeX_jobname = @"jobname";
NSString * const iTM2TeX_USE_French_Pro = @"USE_French_Pro";
NSString * const iTM2TeX_shell_escape = @"AllTeX_shell_escape4iTM3";
NSString * const iTM2TeX_src_specials = @"src_specials";
NSString * const iTM2TeX_src_specials_where_no_cr = @"src_specials_where_no_cr";
NSString * const iTM2TeX_src_specials_where_no_display = @"src_specials_where_no_display";
NSString * const iTM2TeX_src_specials_where_no_hbox = @"src_specials_where_no_hbox";
NSString * const iTM2TeX_src_specials_where_no_parent = @"src_specials_where_no_parent";
NSString * const iTM2TeX_src_specials_where_no_par = @"src_specials_where_no_par";
NSString * const iTM2TeX_src_specials_where_no_math = @"src_specials_where_no_math";
NSString * const iTM2TeX_src_specials_where_no_vbox = @"src_specials_where_no_vbox";
NSString * const iTM2TeX_USE_output_comment = @"USE_output_comment";
NSString * const iTM2TeX_output_comment = @"output_comment";

NSString * const iTM2TeX_USE_translate_file = @"USE_translate_file";
NSString * const iTM2TeX_translate_file = @"translate_file";
NSString * const iTM2TeX_PARSE_translate_file = @"PARSE_translate_file";
// debugger
NSString * const iTM2TeX_recorder = @"recorder";
NSString * const iTM2TeX_file_line_error = @"file_line_error";
NSString * const iTM2TeX_halt_on_error = @"halt_on_error";
NSString * const iTM2TeX_interaction = @"interaction";

NSString * const iTM2TeX_kpathsea_debug = @"kpathsea_debug";


@implementation iTM2EngineTeX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_TeX4iTM3";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSArray arrayWithObjects:@"tex", @"ltx", @"ins", @"pdf", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2TeX_PARSE_first_line,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_translate_file,
                [NSNumber numberWithBool:NO], iTM2TeX_PARSE_translate_file,
                @"", iTM2TeX_translate_file,
                @"errorstopmode", iTM2TeX_interaction,
                @"", iTM2TeX_fmt,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_progname,
                @"", iTM2TeX_progname,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_jobname,
                @"", iTM2TeX_jobname,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_French_Pro,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_output_comment,
                @"", iTM2TeX_output_comment,
                [NSNumber numberWithBool:NO], iTM2TeX_USE_output_directory,
                @"", iTM2TeX_output_directory,
                [NSNumber numberWithBool:YES], iTM2TeX_file_line_error,
                [NSNumber numberWithBool:NO], iTM2TeX_recorder,
                [NSNumber numberWithBool:NO], iTM2TeX_ini,
                [NSNumber numberWithBool:NO], iTM2TeX_enc,
                [NSNumber numberWithBool:NO], iTM2TeX_mltex,
// NO                [NSNumber numberWithBool:NO], iTM2TeX_shell_escape,
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeX_fmt,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeX_fmt,nil]?:@"")];
    return ![[self info4iTM3ForKeyPaths:iTM2TeX_PARSE_first_line,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseFormat:
- (IBAction)chooseFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[[sender selectedItem] representedObject] forKeyPaths:iTM2TeX_fmt,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseFormat:
- (BOOL)validateChooseFormat:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [(NSMenuItem *)sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
        {
			[sender removeAllItems];
			[sender.menu addItem:[NSMenuItem separatorItem]];// for the title...
			NSDictionary * D = [iTM2TeXDistributionController fmtsAtPath:[[self.document fileName] stringByDeletingLastPathComponent]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if(RA.count) {
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats(Project)", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if(RA.count) {
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats(Project)", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			if([sender numberOfItems]==1)
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, myBUNDLE, "")];		
			D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			RA = [D objectForKey:@"TeX"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if(RA.count) {
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
		}
		return ![[self info4iTM3ForKeyPaths:iTM2TeX_PARSE_first_line,nil] boolValue];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[NSNumber numberWithBool:[[sender selectedCell] tag] != ZER0] forKeyPaths:iTM2TeX_PARSE_first_line,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender selectCellWithTag: ([[self info4iTM3ForKeyPaths:iTM2TeX_PARSE_first_line,nil] boolValue]? 1:ZER0)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleProgName:
- (IBAction)toggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_USE_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
- (BOOL)validateToggleProgName:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_USE_progname,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
- (IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeX_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
- (BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([[self info4iTM3ForKeyPaths:iTM2TeX_USE_progname,nil] boolValue])
    {
        NSString * v = [self info4iTM3ForKeyPaths:iTM2TeX_progname,nil];
        if(!v.length)
        {
            v = [self info4iTM3ForKeyPaths:iTM2TeX_fmt,nil];
            [self setInfo4TM3:v forKeyPaths:iTM2TeX_progname,nil];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeX_fmt,nil]?:@"")];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[[sender selectedItem] representedObject] forKeyPaths:iTM2TeX_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseProgName:
- (BOOL)validateChooseProgName:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [(NSMenuItem *)sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
		{
			[sender removeAllItems];
			[sender.menu addItem:[NSMenuItem separatorItem]];// for the title...
			NSDictionary * D = D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
		}
		return [[self info4iTM3ForKeyPaths:iTM2TeX_USE_progname,nil] boolValue];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFrenchPro:
- (IBAction)toggleFrenchPro:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2TeX_USE_French_Pro,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFrenchPro:
- (BOOL)validateToggleFrenchPro:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_USE_French_Pro,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
- (IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeX_translate_file,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
- (BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeX_translate_file,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2TeX_USE_translate_file,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTable:
- (IBAction)toggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2TeX_USE_translate_file,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTable:
- (BOOL)validateToggleTable:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_USE_translate_file,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleParseTable:
- (IBAction)toggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2TeX_PARSE_translate_file,nil];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleParseTable:
- (BOOL)validateToggleParseTable:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_PARSE_translate_file,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2TeX_PARSE_first_line,nil] boolValue];
}
#pragma mark =-=-=-=-=-  Output
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecials:
- (IBAction)toggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vaidateToggleSrcSpecials:
- (BOOL)validateToggleSrcSpecials:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials,nil] boolValue]? NSOnState:NSOffState);
    return ![[self info4iTM3ForKeyPaths:iTM2TeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecialsWhere:
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	
	switch([[sender selectedCell] tag])
	{
		case 0:  [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_cr,nil]; break;
		case 1:  [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_display,nil]; break;
		case 2:  [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_hbox,nil]; break;
		case 3:  [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_parent,nil]; break;
		case 4:  [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_par,nil]; break;
		case 5:  [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_math,nil]; break;
		default: [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_vbox,nil]; break;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSrcSpecialsWhere:
- (BOOL)validateToggleSrcSpecialsWhere:(NSMatrix *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[sender cellWithTag:ZER0] setState: ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_cr,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:1] setState: ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_display,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:2] setState: ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_hbox,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:3] setState: ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_parent,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:4] setState: ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_par,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:5] setState: ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_math,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:6] setState: ([[self info4iTM3ForKeyPaths:iTM2TeX_src_specials_where_no_vbox,nil] boolValue]? NSOnState:NSOffState)];
    return [[self info4iTM3ForKeyPaths:iTM2TeX_src_specials,nil] boolValue] && ![[self info4iTM3ForKeyPaths:iTM2TeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputComment:
- (IBAction)toggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_USE_output_comment,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputComment:
- (BOOL)validateToggleOutputComment:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_USE_output_comment,nil] boolValue]? NSOnState:NSOffState);
    return ![[self info4iTM3ForKeyPaths:iTM2TeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputComment:
- (IBAction)editOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeX_USE_output_comment,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputComment:
- (BOOL)validateEditOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeX_output_comment,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2TeX_USE_output_comment,nil] boolValue] && ![[self info4iTM3ForKeyPaths:iTM2TeX_ini,nil] boolValue];
}
#pragma mark =-=-=-=-=-  INI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
- (IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_ini,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
- (BOOL)validateToggleIni:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_ini,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnc:
- (IBAction)toggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_enc,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnc:
- (BOOL)validateToggleEnc:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_enc,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2TeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleMLTeX:
- (IBAction)toggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_mltex,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleMLTeX:
- (BOOL)validateToggleMLTeX:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_mltex,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2TeX_ini,nil] boolValue];
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
- (IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeX_jobname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
- (BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeX_jobname,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2TeX_USE_jobname,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
- (IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_USE_jobname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
- (BOOL)validateToggleJobName:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_USE_jobname,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputDirectory:
- (IBAction)editOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeX_output_directory,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputDirectory:
- (BOOL)validateEditOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeX_output_directory,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2TeX_USE_output_directory,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_USE_output_directory,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_USE_output_directory,nil] boolValue]? NSOnState:NSOffState);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * v;
    switch([[sender selectedCell] tag])
    {
        case 0: v = @"batchmode"; break;
        case 1: v = @"nonstopmode"; break;
        case 2: v = @"scrollmode"; break;
        default:
        case 3: v = @"errorstopmode"; break;
    }
    [self setInfo4TM3:v forKeyPaths:iTM2TeX_interaction,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self info4iTM3ForKeyPaths:iTM2TeX_interaction,nil]]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_file_line_error,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineError:
- (BOOL)validateToggleFileLineError:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_file_line_error,nil] boolValue]? NSOffState:NSOnState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRecorder:
- (IBAction)toggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_recorder,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
- (BOOL)validateToggleRecorder:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_recorder,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleHaltOnError:
- (IBAction)toggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeX_halt_on_error,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleHaltOnError:
- (BOOL)validateToggleHaltOnError:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeX_halt_on_error,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
@end

// ini
NSString * const iTM2PDFTeX_ini = @"ini";
NSString * const iTM2PDFTeX_mltex = @"mltex";
NSString * const iTM2PDFTeX_enc = @"enc";

NSString * const iTM2PDFTeXMoreArgumentKey = @"MoreArgument";

NSString * const iTM2PDFTeX_mktex = @"mktex";

NSString * const iTM2PDFTeX_USE_output_directory = @"USE_output_directory";
NSString * const iTM2PDFTeX_output_directory = @"output_directory";

// switcher dvi/pdf
NSString * const iTM2PDFTeX_output_format = @"output_format";
// format switcher
NSString * const iTM2PDFTeX_fmt = @"fmt";
NSString * const iTM2PDFTeX_PARSE_first_line = @"PARSE_first_line";
NSString * const iTM2PDFTeX_USE_progname = @"USE_progname";
NSString * const iTM2PDFTeX_progname = @"progname";
NSString * const iTM2PDFTeX_USE_jobname = @"USE_jobname";
NSString * const iTM2PDFTeX_jobname = @"jobname";
NSString * const iTM2PDFTeX_USE_French_Pro = @"USE_French_Pro";
//NSString * const iTM2TeX_shell_escape = @"shell_escape";
NSString * const iTM2PDFTeX_pdfsync = @"PDFSYNC";
NSString * const iTM2PDFTeX_src_specials = @"src_specials";
NSString * const iTM2PDFTeX_src_specials_where_no_cr = @"src_specials_where_no_cr";
NSString * const iTM2PDFTeX_src_specials_where_no_display = @"src_specials_where_no_display";
NSString * const iTM2PDFTeX_src_specials_where_no_hbox = @"src_specials_where_no_hbox";
NSString * const iTM2PDFTeX_src_specials_where_no_parent = @"src_specials_where_no_parent";
NSString * const iTM2PDFTeX_src_specials_where_no_par = @"src_specials_where_no_par";
NSString * const iTM2PDFTeX_src_specials_where_no_math = @"src_specials_where_no_math";
NSString * const iTM2PDFTeX_src_specials_where_no_vbox = @"src_specials_where_no_vbox";
NSString * const iTM2PDFTeX_USE_output_comment = @"USE_output_comment";
NSString * const iTM2PDFTeX_output_comment = @"output_comment";

NSString * const iTM2PDFTeX_USE_translate_file = @"USE_translate_file";
NSString * const iTM2PDFTeX_translate_file = @"translate_file";
NSString * const iTM2PDFTeX_PARSE_translate_file = @"PARSE_translate_file";
// debugger
NSString * const iTM2PDFTeX_recorder = @"recorder";
NSString * const iTM2PDFTeX_file_line_error = @"file_line_error";
NSString * const iTM2PDFTeX_halt_on_error = @"halt_on_error";
NSString * const iTM2PDFTeX_interaction = @"interaction";

NSString * const iTM2PDFTeX_kpathsea_debug = @"kpathsea_debug";
NSString * const iTM2PDFTeX_eight_bit = @"eight_bit";


@implementation iTM2EnginePDFTeX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_PDFTeX4iTM3";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSArray arrayWithObjects:@"tex", @"ltx", @"ins", @"pdf", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                @"pdf", iTM2PDFTeX_output_format,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_PARSE_first_line,
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
// NO PLEASE                [NSNumber numberWithBool:NO], iTM2TeX_shell_escape,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_USE_French_Pro,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_halt_on_error,
                [NSNumber numberWithBool:NO], iTM2PDFTeX_src_specials,
				[NSNumber numberWithBool:YES], iTM2PDFTeX_eight_bit,
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2PDFTeX_fmt,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2PDFTeX_fmt,nil]?:@"")];
    return ![[self info4iTM3ForKeyPaths:iTM2PDFTeX_PARSE_first_line,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseFormat:
- (IBAction)chooseFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[[sender selectedItem] representedObject] forKeyPaths:iTM2TeX_fmt,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseFormat:
- (BOOL)validateChooseFormat:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [(NSMenuItem *)sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]] && ([sender numberOfItems]<2))
	{
		[sender removeAllItems];
		[sender.menu addItem:[NSMenuItem separatorItem]];// for the title...
		NSDictionary * D = [iTM2TeXDistributionController fmtsAtPath:[[self.document fileName] stringByDeletingLastPathComponent]];// beware, hard coded format location
		NSArray * RA = [D objectForKey:@"PDFTeX"];
		if(RA.count)
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDFTeX formats(Project)", iTM2TeXProjectEngineTable, myBUNDLE, "")];
			NSEnumerator * E = RA.objectEnumerator;
			NSString * fmt;
			while(fmt = E.nextObject)
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[sender.itemArray.lastObject setRepresentedObject:fmt];
			}
		}
		RA = [D objectForKey:@"Other"];
		if(RA.count)
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats(Project)", iTM2TeXProjectEngineTable, myBUNDLE, "")];
			NSEnumerator * E = RA.objectEnumerator;
			NSString * fmt;
			while(fmt = E.nextObject)
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[sender.itemArray.lastObject setRepresentedObject:fmt];
			}
		}
		if([sender numberOfItems]==1)
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, myBUNDLE, "")];		
		D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
		RA = [D objectForKey:@"PDFTeX"];
		if(RA.count)
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDFTeX formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
			NSEnumerator * E = RA.objectEnumerator;
			NSString * fmt;
			while(fmt = E.nextObject)
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[sender.itemArray.lastObject setRepresentedObject:fmt];
			}
		}
		RA = [D objectForKey:@"Other"];
		if(RA.count)
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
			NSEnumerator * E = RA.objectEnumerator;
			NSString * fmt;
			while(fmt = E.nextObject)
			{
				[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
				[sender.itemArray.lastObject setRepresentedObject:fmt];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[NSNumber numberWithBool:[[sender selectedCell] tag] != ZER0] forKeyPaths:iTM2PDFTeX_PARSE_first_line,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender selectCellWithTag: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_PARSE_first_line,nil] boolValue]? 1:ZER0)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleProgName:
- (IBAction)toggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_USE_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
- (BOOL)validateToggleProgName:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_progname,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
- (IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2PDFTeX_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
- (BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_progname,nil] boolValue])
    {
        NSString * v = [self info4iTM3ForKeyPaths:iTM2PDFTeX_progname,nil];
        if(!v.length)
        {
            v = [self info4iTM3ForKeyPaths:iTM2PDFTeX_fmt,nil];
            [self setInfo4TM3:v forKeyPaths:iTM2PDFTeX_progname,nil];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2PDFTeX_fmt,nil]?:@"")];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[[sender selectedItem] representedObject] forKeyPaths:iTM2PDFTeX_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseProgName:
- (BOOL)validateChooseProgName:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [(NSMenuItem *)sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
		{
			[sender removeAllItems];
			[sender.menu addItem:[NSMenuItem separatorItem]];// for the title...
			NSDictionary * D = D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"PDFTeX"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDFTeX formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
		}
		return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_progname,nil] boolValue];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFrenchPro:
- (IBAction)toggleFrenchPro:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_USE_French_Pro,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFrenchPro:
- (BOOL)validateToggleFrenchPro:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_French_Pro,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
- (IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2PDFTeX_translate_file,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
- (BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2PDFTeX_translate_file,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_translate_file,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTable:
- (IBAction)toggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_USE_translate_file,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTable:
- (BOOL)validateToggleTable:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_translate_file,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleParseTable:
- (IBAction)toggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_PARSE_translate_file,nil];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleParseTable:
- (BOOL)validateToggleParseTable:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_PARSE_first_line,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_PARSE_first_line,nil] boolValue];
}
#pragma mark =-=-=-=-=-  Output
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputFormat:
- (IBAction)toggleOutputFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3: ([[sender selectedCell] tag]? @"dvi":@"pdf") forKeyPaths:iTM2PDFTeX_output_format,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputFormat:
- (BOOL)validateToggleOutputFormat:(NSMatrix *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[sender selectCellWithTag: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_output_format,nil] isEqualToString:@"pdf"]? ZER0:1)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecials:
- (IBAction)toggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vaidateToggleSrcSpecials:
- (BOOL)validateToggleSrcSpecials:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_output_format,nil] isEqualToString:@"dvi"]
			&& ![[self info4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecialsWhere:
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	
	switch([[sender selectedCell] tag])
	{
		case 0:  [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_cr,nil]; break;
		case 1:  [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_display,nil]; break;
		case 2:  [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_hbox,nil]; break;
		case 3:  [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_parent,nil]; break;
		case 4:  [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_par,nil]; break;
		case 5:  [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_math,nil]; break;
		default: [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_vbox,nil]; break;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSrcSpecialsWhere:
- (BOOL)validateToggleSrcSpecialsWhere:(NSMatrix *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[sender cellWithTag:ZER0] setState: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_cr,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:1] setState: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_display,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:2] setState: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_hbox,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:3] setState: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_parent,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:4] setState: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_par,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:5] setState: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_math,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:6] setState: ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials_where_no_vbox,nil] boolValue]? NSOnState:NSOffState)];
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_output_format,nil] isEqualToString:@"dvi"]
		&& [[self info4iTM3ForKeyPaths:iTM2PDFTeX_src_specials,nil] boolValue] && ![[self info4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputComment:
- (IBAction)toggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_comment,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputComment:
- (BOOL)validateToggleOutputComment:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_comment,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_output_format,nil] isEqualToString:@"dvi"]
			&& ![[self info4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputComment:
- (IBAction)editOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2PDFTeX_USE_output_comment,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputComment:
- (BOOL)validateEditOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2PDFTeX_output_comment,nil]?:@"")];
//LOG4iTM3(@"[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_comment,nil]: %@", [self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_comment,nil]);
//LOG4iTM3(@"clas: %@", [[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_comment,nil] class]);
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_comment,nil] boolValue]
		&& [[self info4iTM3ForKeyPaths:iTM2PDFTeX_output_format,nil] isEqualToString:@"dvi"]
			&& ![[self info4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePdfSync:
- (IBAction)togglePdfSync:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_pdfsync,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePdfSync:
- (BOOL)validateTogglePdfSync:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_pdfsync,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_output_format,nil] isEqualToString:@"pdf"];
}
#pragma mark =-=-=-=-=-  INI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
- (IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
- (BOOL)validateToggleIni:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnc:
- (IBAction)toggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_enc,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnc:
- (BOOL)validateToggleEnc:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_enc,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleMLTeX:
- (IBAction)toggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_mltex,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleMLTeX:
- (BOOL)validateToggleMLTeX:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_mltex,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_ini,nil] boolValue];
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
- (IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2PDFTeX_jobname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
- (BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2PDFTeX_jobname,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_jobname,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
- (IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_USE_jobname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
- (BOOL)validateToggleJobName:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_jobname,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputDirectory:
- (IBAction)editOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2PDFTeX_output_directory,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputDirectory:
- (BOOL)validateEditOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2PDFTeX_output_directory,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_directory,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_directory,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_USE_output_directory,nil] boolValue]? NSOnState:NSOffState);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * v;
    switch([[sender selectedCell] tag])
    {
        case 0: v = @"batchmode"; break;
        case 1: v = @"nonstopmode"; break;
        case 2: v = @"scrollmode"; break;
        default:
        case 3: v = @"errorstopmode"; break;
    }
    [self setInfo4TM3:v forKeyPaths:iTM2PDFTeX_interaction,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self info4iTM3ForKeyPaths:iTM2PDFTeX_interaction,nil]]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_file_line_error,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineError:
- (BOOL)validateToggleFileLineError:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_file_line_error,nil] boolValue]? NSOffState:NSOnState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRecorder:
- (IBAction)toggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_recorder,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
- (BOOL)validateToggleRecorder:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_recorder,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleHaltOnError:
- (IBAction)toggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_halt_on_error,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleHaltOnError:
- (BOOL)validateToggleHaltOnError:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_halt_on_error,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEightBit:
- (IBAction)toggleEightBit:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2PDFTeX_eight_bit,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEightBit:
- (BOOL)validateToggleEightBit:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2PDFTeX_eight_bit,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
@end

// ini
NSString * const iTM2XeTeX_ini = @"ini";
NSString * const iTM2XeTeX_mltex = @"mltex";
NSString * const iTM2XeTeX_enc = @"enc";

NSString * const iTM2XeTeXMoreArgumentKey = @"MoreArgument";

NSString * const iTM2XeTeX_mktex = @"mktex";

NSString * const iTM2XeTeX_USE_output_directory = @"USE_output_directory";
NSString * const iTM2XeTeX_output_directory = @"output_directory";

// format switcher
NSString * const iTM2XeTeX_fmt = @"fmt";
NSString * const iTM2XeTeX_PARSE_first_line = @"PARSE_first_line";
NSString * const iTM2XeTeX_USE_progname = @"USE_progname";
NSString * const iTM2XeTeX_progname = @"progname";
NSString * const iTM2XeTeX_USE_jobname = @"USE_jobname";
NSString * const iTM2XeTeX_jobname = @"jobname";
NSString * const iTM2XeTeX_USE_French_Pro = @"USE_French_Pro";
//NSString * const iTM2TeX_shell_escape = @"shell_escape";
NSString * const iTM2XeTeX_src_specials = @"src_specials";
NSString * const iTM2XeTeX_src_specials_where_no_cr = @"src_specials_where_no_cr";
NSString * const iTM2XeTeX_src_specials_where_no_display = @"src_specials_where_no_display";
NSString * const iTM2XeTeX_src_specials_where_no_hbox = @"src_specials_where_no_hbox";
NSString * const iTM2XeTeX_src_specials_where_no_parent = @"src_specials_where_no_parent";
NSString * const iTM2XeTeX_src_specials_where_no_par = @"src_specials_where_no_par";
NSString * const iTM2XeTeX_src_specials_where_no_math = @"src_specials_where_no_math";
NSString * const iTM2XeTeX_src_specials_where_no_vbox = @"src_specials_where_no_vbox";
NSString * const iTM2XeTeX_USE_output_comment = @"USE_output_comment";
NSString * const iTM2XeTeX_output_comment = @"output_comment";

NSString * const iTM2XeTeX_USE_translate_file = @"USE_translate_file";
NSString * const iTM2XeTeX_translate_file = @"translate_file";
NSString * const iTM2XeTeX_PARSE_translate_file = @"PARSE_translate_file";
// debugger
NSString * const iTM2XeTeX_recorder = @"recorder";
NSString * const iTM2XeTeX_file_line_error = @"file_line_error";
NSString * const iTM2XeTeX_halt_on_error = @"halt_on_error";
NSString * const iTM2XeTeX_interaction = @"interaction";

NSString * const iTM2XeTeX_kpathsea_debug = @"kpathsea_debug";

NSString * const iTM2XeTeX_eight_bit = @"eight_bit";
NSString * const iTM2XeTeX_enable_etex = @"enable_etex";

NSString * const iTM2XeTeX_no_pdf = @"no_pdf";
NSString * const iTM2XeTeX_output_format = @"output_format";
NSString * const iTM2XeTeX_output_driver = @"output_driver";
NSString * const iTM2XeTeX_custom_output_driver = @"custom_output_driver";


@implementation iTM2EngineXeTeX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_XeTeX4iTM3";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSArray arrayWithObjects:@"tex", @"ltx", @"ins", @"pdf", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2XeTeX_PARSE_first_line,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_translate_file,
                [NSNumber numberWithBool:NO], iTM2XeTeX_PARSE_translate_file,
                @"", iTM2XeTeX_translate_file,
                @"errorstopmode", iTM2XeTeX_interaction,
                @"", iTM2XeTeX_fmt,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_progname,
                @"", iTM2XeTeX_progname,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_jobname,
                @"", iTM2XeTeX_jobname,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_French_Pro,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_output_comment,
                @"", iTM2XeTeX_output_comment,
                [NSNumber numberWithBool:NO], iTM2XeTeX_USE_output_directory,
                @"", iTM2XeTeX_output_directory,
                [NSNumber numberWithBool:YES], iTM2XeTeX_file_line_error,
                [NSNumber numberWithBool:NO], iTM2XeTeX_recorder,
                [NSNumber numberWithBool:NO], iTM2XeTeX_ini,
                [NSNumber numberWithBool:NO], iTM2XeTeX_enc,
                [NSNumber numberWithBool:NO], iTM2XeTeX_mltex,
// NO PLEASE                [NSNumber numberWithBool:NO], iTM2TeX_shell_escape,
                [NSNumber numberWithBool:NO], iTM2XeTeX_halt_on_error,
                [NSNumber numberWithBool:YES], iTM2XeTeX_src_specials,
				@"", iTM2XeTeXMoreArgumentKey,
				[NSNumber numberWithBool:YES], iTM2XeTeX_eight_bit,
				[NSNumber numberWithBool:YES], iTM2XeTeX_enable_etex,
				@"iTeXMac2", iTM2XeTeX_output_driver,
				@"", iTM2XeTeX_custom_output_driver,
				[NSNumber numberWithBool:NO], iTM2XeTeX_no_pdf,
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2XeTeX_fmt,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditFormat:
- (BOOL)validateEditFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2XeTeX_fmt,nil]?:@"")];
    return ![[self info4iTM3ForKeyPaths:iTM2XeTeX_PARSE_first_line,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseFormat:
- (IBAction)chooseFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[[sender selectedItem] representedObject] forKeyPaths:iTM2XeTeX_fmt,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseFormat:
- (BOOL)validateChooseFormat:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [(NSMenuItem *)sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
        {
			[sender removeAllItems];
			[sender.menu addItem:[NSMenuItem separatorItem]];// for the title...
			NSDictionary * D = [iTM2TeXDistributionController fmtsAtPath:[[self.document fileName] stringByDeletingLastPathComponent]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats(Project)", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats(Project)", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			if([sender numberOfItems]==1)
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No project format", iTM2TeXProjectEngineTable, myBUNDLE, "")];		
			D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			RA = [D objectForKey:@"TeX"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
		}
		return ![[self info4iTM3ForKeyPaths:iTM2XeTeX_PARSE_first_line,nil] boolValue];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[NSNumber numberWithBool:[[sender selectedCell] tag] != ZER0] forKeyPaths:iTM2XeTeX_PARSE_first_line,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchFormat:
- (BOOL)validateSwitchFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender selectCellWithTag: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_PARSE_first_line,nil] boolValue]? 1:ZER0)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleProgName:
- (IBAction)toggleProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_USE_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleProgName:
- (BOOL)validateToggleProgName:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_progname,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editProgName:
- (IBAction)editProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2XeTeX_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditProgName:
- (BOOL)validateEditProgName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_progname,nil] boolValue])
    {
        NSString * v = [self info4iTM3ForKeyPaths:iTM2XeTeX_progname,nil];
        if(!v.length)
        {
            v = [self info4iTM3ForKeyPaths:iTM2XeTeX_fmt,nil];
            [self setInfo4TM3:v forKeyPaths:iTM2XeTeX_progname,nil];
        }
        [sender setStringValue: (v?:@"")];
        return YES;
    }
    else
    {
        [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2XeTeX_fmt,nil]?:@"")];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[[sender selectedItem] representedObject] forKeyPaths:iTM2XeTeX_progname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseProgName:
- (BOOL)validateChooseProgName:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSMenuItem class]])
		return [(NSMenuItem *)sender representedObject] != nil;
	else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		if([sender numberOfItems]<2)
		{
			[sender removeAllItems];
			[sender.menu addItem:[NSMenuItem separatorItem]];// for the title...
			NSDictionary * D = D = [iTM2TeXDistributionController fmtsAtPath:[iTM2TeXDistributionController formatsPath]];// beware, hard coded format location
			NSArray * RA = [D objectForKey:@"TeX"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"TeX formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
			RA = [D objectForKey:@"Other"];
			if(RA.count)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Other formats", iTM2TeXProjectEngineTable, myBUNDLE, "")];
				for (NSString * fmt in RA) {
					[sender addItemWithTitle:[NSString stringWithFormat:@"  %@", fmt]];
					[sender.itemArray.lastObject setRepresentedObject:fmt];
				}
			}
		}
		return [[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_progname,nil] boolValue];
	}
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFrenchPro:
- (IBAction)toggleFrenchPro:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_USE_French_Pro,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFrenchPro:
- (BOOL)validateToggleFrenchPro:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_French_Pro,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
#pragma mark =-=-=-=-=-  Translate
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editTable:
- (IBAction)editTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2XeTeX_translate_file,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditTable:
- (BOOL)validateEditTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2XeTeX_translate_file,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_translate_file,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTable:
- (IBAction)toggleTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_USE_translate_file,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTable:
- (BOOL)validateToggleTable:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_translate_file,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleParseTable:
- (IBAction)toggleParseTable:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_PARSE_translate_file,nil];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleParseTable:
- (BOOL)validateToggleParseTable:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_PARSE_translate_file,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_PARSE_first_line,nil] boolValue];
}
#pragma mark =-=-=-=-=-  Output
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecials:
- (IBAction)toggleSrcSpecials:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vaidateToggleSrcSpecials:
- (BOOL)validateToggleSrcSpecials:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials,nil] boolValue]? NSOnState:NSOffState);
    return ![[self info4iTM3ForKeyPaths:iTM2XeTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSrcSpecialsWhere:
- (IBAction)toggleSrcSpecialsWhere:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	
	switch([[sender selectedCell] tag])
	{
		case 0:  [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_cr,nil]; break;
		case 1:  [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_display,nil]; break;
		case 2:  [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_hbox,nil]; break;
		case 3:  [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_parent,nil]; break;
		case 4:  [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_par,nil]; break;
		case 5:  [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_math,nil]; break;
		default: [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_vbox,nil]; break;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSrcSpecialsWhere:
- (BOOL)validateToggleSrcSpecialsWhere:(NSMatrix *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[sender cellWithTag:ZER0] setState: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_cr,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:1] setState: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_display,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:2] setState: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_hbox,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:3] setState: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_parent,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:4] setState: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_par,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:5] setState: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_math,nil] boolValue]? NSOnState:NSOffState)];
	[[sender cellWithTag:6] setState: ([[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials_where_no_vbox,nil] boolValue]? NSOnState:NSOffState)];
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_src_specials,nil] boolValue] && ![[self info4iTM3ForKeyPaths:iTM2XeTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputComment:
- (IBAction)toggleOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_USE_output_comment,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputComment:
- (BOOL)validateToggleOutputComment:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_output_comment,nil] boolValue]? NSOnState:NSOffState);
    return ![[self info4iTM3ForKeyPaths:iTM2XeTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputComment:
- (IBAction)editOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2XeTeX_USE_output_comment,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputComment:
- (BOOL)validateEditOutputComment:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2XeTeX_output_comment,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_output_comment,nil] boolValue] && ![[self info4iTM3ForKeyPaths:iTM2XeTeX_ini,nil] boolValue];
}
#pragma mark =-=-=-=-=-  INI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIni:
- (IBAction)toggleIni:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_ini,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIni:
- (BOOL)validateToggleIni:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_ini,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnc:
- (IBAction)toggleEnc:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_enc,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnc:
- (BOOL)validateToggleEnc:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_enc,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_ini,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleMLTeX:
- (IBAction)toggleMLTeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_mltex,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleMLTeX:
- (BOOL)validateToggleMLTeX:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_mltex,nil] boolValue]? NSOnState:NSOffState);
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_ini,nil] boolValue];
}
#pragma mark =-=-=-=-=-  Advanced
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editJobName:
- (IBAction)editJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2XeTeX_jobname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditJobName:
- (BOOL)validateEditJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2XeTeX_jobname,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_jobname,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleJobName:
- (IBAction)toggleJobName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_USE_jobname,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleJobName:
- (BOOL)validateToggleJobName:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_jobname,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputDirectory:
- (IBAction)editOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2XeTeX_output_directory,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputDirectory:
- (BOOL)validateEditOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2XeTeX_output_directory,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_output_directory,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_USE_output_directory,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_USE_output_directory,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnableETeX:
- (IBAction)toggleEnableETeX:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_enable_etex,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnableETeX:
- (BOOL)validateToggleEnableETeX:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_enable_etex,nil] boolValue]? NSOnState:NSOffState);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * v;
    switch([[sender selectedCell] tag])
    {
        case 0: v = @"batchmode"; break;
        case 1: v = @"nonstopmode"; break;
        case 2: v = @"scrollmode"; break;
        default:
        case 3: v = @"errorstopmode"; break;
    }
    [self setInfo4TM3:v forKeyPaths:iTM2XeTeX_interaction,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self info4iTM3ForKeyPaths:iTM2XeTeX_interaction,nil]]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchOutputFormat:
- (IBAction)switchOutputFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * v;
    switch([[sender selectedCell] tag])
    {
        case 0: v = @"pdf"; break;
        default: v = @"xdv"; break;
    }
    [self setInfo4TM3:v forKeyPaths:iTM2XeTeX_output_format,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchOutputFormat:
- (BOOL)validateSwitchOutputFormat:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"pdf", @"xdv", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self info4iTM3ForKeyPaths:iTM2XeTeX_output_format,nil]]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchOutputDriver:
- (IBAction)switchOutputDriver:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * v;
    switch([[sender selectedCell] tag])
    {
        case 0: v = @"XeTeX"; break;
        case 1: v = @"iTeXMac2"; break;
        default: v = @"custom"; break;
    }
    [self setInfo4TM3:v forKeyPaths:iTM2XeTeX_output_driver,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchOutputDriver:
- (BOOL)validateSwitchOutputDriver:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    static NSArray * modes = nil;
    if(!modes) modes = [[NSArray arrayWithObjects:@"XeTeX", @"iTeXMac2", @"custom", nil] retain];
    [sender selectCellWithTag:[modes indexOfObject:[self info4iTM3ForKeyPaths:iTM2XeTeX_output_driver,nil]]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOutputDriver:
- (IBAction)editOutputDriver:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2XeTeX_custom_output_driver,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOutputDriver:
- (BOOL)validateEditOutputDriver:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue:[self info4iTM3ForKeyPaths:iTM2XeTeX_custom_output_driver,nil]];
    return [[self info4iTM3ForKeyPaths:iTM2XeTeX_output_driver,nil] isEqual:@"custom"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEightBit:
- (IBAction)toggleEightBit:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_eight_bit,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEightBit:
- (BOOL)validateToggleEightBit:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_eight_bit,nil] boolValue]? NSOnState:NSOffState);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_file_line_error,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFileLineError:
- (BOOL)validateToggleFileLineError:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_file_line_error,nil] boolValue]? NSOffState:NSOnState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRecorder:
- (IBAction)toggleRecorder:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_recorder,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleRecorder:
- (BOOL)validateToggleRecorder:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_recorder,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleHaltOnError:
- (IBAction)toggleHaltOnError:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2XeTeX_halt_on_error,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleHaltOnError:
- (BOOL)validateToggleHaltOnError:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2XeTeX_halt_on_error,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
@end

@implementation iTM2MainInstaller(TeXWrapperKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXWrapperKitCompleteInstallation4iTM3
+ (void)iTM2TeXWrapperKitCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    [iTM2EngineTeX installBinary];
    [iTM2EnginePDFTeX installBinary];
    [iTM2EngineXeTeX installBinary];
//END4iTM3;
    return;
}
@end

@implementation iTM2TeXPCommandsInspector(TeXWrapper)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shellEscapeSheetDidEnd:returnCode:contextInfo:
- (void)shellEscapeSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
	if(NSAlertDefaultReturn != returnCode)
	{
		// the user has not confirmed the use of write 18
		// return to the original state
		[self toggleInfo4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil];
		[self.document updateChangeCount:NSChangeUndone];
		[self isWindowContentValid4iTM3];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShellEscape:
- (IBAction)toggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
	[self toggleInfo4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil];
	[self.document updateChangeCount:NSChangeDone];
	if(![[self info4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil] boolValue])
	{
		[self isWindowContentValid4iTM3];
		return;
	}
	NSBeginAlertSheet(
		NSLocalizedStringFromTableInBundle(@"Shell Escape", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:[iTM2EngineTeX class]], ""),
		nil,
		NSLocalizedStringFromTableInBundle(@"Cancel",iTM2ProjectTable,[NSBundle bundleForClass:[iTM2ProjectDocument class]],""),
		nil,
		self.window, self, @selector(shellEscapeSheetDidEnd:returnCode:contextInfo:), NULL, nil,
		NSLocalizedStringFromTableInBundle(@"Really authorize TeX to launch shell processes with \\write18{}?", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:[iTM2EngineTeX class]], ""));
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShellEscape:
- (BOOL)validateToggleShellEscape:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = ([[self info4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
@end

@implementation iTM2TeXPEngineInspector(TeXWrapper)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shellEscapeSheetDidEnd:returnCode:contextInfo:
- (void)shellEscapeSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
	if(NSAlertDefaultReturn != returnCode)
	{
		// the user has not confirmed the use of write 18
		// return to the original state
		[self toggleInfo4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil];
		[self.document updateChangeCount:NSChangeUndone];
		[self isWindowContentValid4iTM3];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShellEscape:
- (IBAction)toggleShellEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
#warning ! FAILED does the shell escape flag work for general purpose
	[self toggleInfo4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil];
	[self.document updateChangeCount:NSChangeDone];
	if(![[self info4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil] boolValue])
	{
		[self isWindowContentValid4iTM3];
		return;
	}
	NSBeginAlertSheet(
		NSLocalizedStringFromTableInBundle(@"Shell Escape", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:[iTM2EngineTeX class]], ""),
		nil,
		NSLocalizedStringFromTableInBundle(@"Cancel",iTM2ProjectTable,[NSBundle bundleForClass:[iTM2ProjectDocument class]],""),
		nil,
		self.window, self, @selector(shellEscapeSheetDidEnd:returnCode:contextInfo:), NULL, nil,
		NSLocalizedStringFromTableInBundle(@"Really authorize TeX to launch shell processes with \\write18{}?", iTM2TeXProjectEngineTable, [NSBundle bundleForClass:[iTM2EngineTeX class]], ""));
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShellEscape:
- (BOOL)validateToggleShellEscape:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = ([[self info4iTM3ForKeyPaths:iTM2TPFEEnginesKey,iTM2ProjectDefaultsKey,iTM2TeX_shell_escape,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
@end

