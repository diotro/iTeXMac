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

#import <iTM2TeXFoundation/iTM2TeXInfoWrapperKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>
#import <iTM2TeXFoundation/iTM2TeXPCommandWrapperKit.h>
//#import "iTM2TeXProjectEngineerKit.h"
////#import "iTM2ValidationKit.h"

NSString * const iTM2TeXPCommandWrapperTable = @"Command";
NSString * const iTM2TeXPIndexExtension = @"idx";
NSString * const iTM2TeXPGlossaryExtension = @"glo";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCommandWrapperKit
/*"Description forthcoming."*/

NSString * const iTM2TeXPIndexUseOutputKey = @"Index_UseOutput4iTM3";
NSString * const iTM2TeXPIndexOutputKey = @"Index_Output4iTM3";
NSString * const iTM2TeXPIndexUseStyleKey = @"Index_UseStyle4iTM3";
NSString * const iTM2TeXPIndexStyleKey = @"Index_Style4iTM3";
NSString * const iTM2TeXPIndexCompressBlanksKey = @"Index_CompressBlanks4iTM3";
NSString * const iTM2TeXPIndexGermanOrderingKey = @"Index_GermanOrdering4iTM3";
NSString * const iTM2TeXPIndexLetterOrderingKey = @"Index_LetterOrdering4iTM3";
NSString * const iTM2TeXPIndexNoImplicitPageRangeKey = @"Index_NoImplicitPageRange4iTM3";
NSString * const iTM2TeXPIndexIsSeparateKey = @"Index_IsSeparate4iTM3";
NSString * const iTM2TeXPIndexSeparateStartKey = @"Index_SeparateStart4iTM3";
NSString * const iTM2TeXPIndexRunSilentlyKey = @"Index_RunSilently4iTM3";

@implementation iTM2TeXPIndexInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2TeXPIndexUseOutputKey,
                @"", iTM2TeXPIndexOutputKey,
                [NSNumber numberWithBool:NO], iTM2TeXPIndexUseStyleKey,
                @"", iTM2TeXPIndexStyleKey,
                [NSNumber numberWithBool:NO], iTM2TeXPIndexCompressBlanksKey,
                [NSNumber numberWithBool:NO], iTM2TeXPIndexGermanOrderingKey,
                [NSNumber numberWithBool:NO], iTM2TeXPIndexLetterOrderingKey,
                [NSNumber numberWithBool:NO], iTM2TeXPIndexNoImplicitPageRangeKey,
                [NSNumber numberWithBool:NO], iTM2TeXPIndexIsSeparateKey,
                @"any", iTM2TeXPIndexSeparateStartKey,
                [NSNumber numberWithBool:NO], iTM2TeXPIndexRunSilentlyKey,
					nil];
}
#pragma mark =-=-=-=-=-  OUTPUT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseOutput:
- (IBAction)toggleUseOutput:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexUseOutputKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseOutput:
- (BOOL)validateToggleUseOutput:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexUseOutputKey, nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputEdited:
- (IBAction)outputEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.document setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeXPIndexOutputKey, nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOutputEdited:
- (BOOL)validateOutputEdited:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TeXProjectDocument * myTPD = (iTM2TeXProjectDocument *)self.document;
    NSString * output = [self info4iTM3ForKeyPaths:iTM2TeXPIndexOutputKey,nil];
    if(!output.length)
    {
		NSString * path = [[myTPD nameForFileKey:[myTPD masterFileKey]] stringByDeletingPathExtension];
		[self setInfo4TM3:(path.length? [path stringByAppendingPathExtension:iTM2TeXPIndexExtension]:@"") forKeyPaths:iTM2TeXPIndexOutputKey, nil];
        output = [self info4iTM3ForKeyPaths:iTM2TeXPIndexOutputKey, nil]?: @"";
    }
    sender.stringValue = output;
//END4iTM3;
    return [[self info4iTM3ForKeyPaths:iTM2TeXPIndexUseOutputKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  STYLE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseStyle:
- (IBAction)toggleUseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexUseStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseStyle:
- (BOOL)validateToggleUseStyle:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexUseStyleKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseStyle:
- (IBAction)chooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseStyle:
- (BOOL)validateChooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editStyle:
- (IBAction)editStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeXPIndexStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditStyle:
- (BOOL)validateEditStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeXPIndexStyleKey,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2TeXPIndexUseStyleKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  OPTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCompressBlanks:
- (IBAction)toggleCompressBlanks:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexCompressBlanksKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleCompressBlanks:
- (BOOL)validateToggleCompressBlanks:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexCompressBlanksKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleGermanOrdering:
- (IBAction)toggleGermanOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexGermanOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleGermanOrdering:
- (BOOL)validateToggleGermanOrdering:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexGermanOrderingKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleLetterOrdering:
- (IBAction)toggleLetterOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexLetterOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleLetterOrdering:
- (BOOL)validateToggleLetterOrdering:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexLetterOrderingKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNoImplicitPageRange:
- (IBAction)toggleNoImplicitPageRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexNoImplicitPageRangeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNoImplicitPageRange:
- (BOOL)validateToggleNoImplicitPageRange:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexNoImplicitPageRangeKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
#pragma mark =-=-=-=-=-  SEPARATE INDEX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSeparateIndex:
- (IBAction)toggleSeparateIndex:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSeparateIndex:
- (BOOL)validateToggleSeparateIndex:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startingAtChosen:
- (IBAction)startingAtChosen:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * option;
    switch([sender indexOfSelectedItem])
    {
        case 0:
            option = @"any";
            break;
        case 1:
            option = @"odd";
            break;
        case 2:
            option = @"even";
            break;
        default:
            option = [NSString stringWithFormat:@"%d", MAX([([self info4iTM3ForKeyPaths:iTM2TeXPIndexSeparateStartKey,nil]) integerValue], 1)];
            break;
    }
    [self setInfo4TM3:option forKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
	[self isWindowContentValid4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtChosen:
- (BOOL)validateStartingAtChosen:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * option = [self info4iTM3ForKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
		NSInteger index = 3;
		if([option isEqualToString:@"any"])
			index = ZER0;
		else if([option isEqualToString:@"odd"])
			index = 1;
		else if([option isEqualToString:@"even"])
			index = 2;
		[sender selectItemAtIndex:index];
		return [[self info4iTM3ForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil] boolValue];
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startingAtEdited:
- (IBAction)startingAtEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[NSNumber numberWithInteger:[sender integerValue]] forKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtEdited:
- (BOOL)validateStartingAtEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * option = [self info4iTM3ForKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
	BOOL enabled = !([option isEqualToString:@"any"] || [option isEqualToString:@"odd"] || [option isEqualToString:@"even"]);
    [sender setIntegerValue:[option integerValue]];
    return [[self info4iTM3ForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil] boolValue] && enabled;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRunSilently:
- (IBAction)toggleRunSilently:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPIndexRunSilentlyKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateToggleRunSilently:
- (BOOL)validateToggleRunSilently:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPIndexRunSilentlyKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
@end

NSString * const iTM2TeXPGlossaryUseOutputKey = @"Glossary_UseOutput4iTM3";
NSString * const iTM2TeXPGlossaryOutputKey = @"Glossary_Output4iTM3";
NSString * const iTM2TeXPGlossaryUseStyleKey = @"Glossary_UseStyle4iTM3";
NSString * const iTM2TeXPGlossaryStyleKey = @"Glossary_Style4iTM3";
NSString * const iTM2TeXPGlossaryCompressBlanksKey = @"Glossary_CompressBlanks4iTM3";
NSString * const iTM2TeXPGlossaryGermanOrderingKey = @"Glossary_GermanOrdering4iTM3";
NSString * const iTM2TeXPGlossaryLetterOrderingKey = @"Glossary_LetterOrdering4iTM3";
NSString * const iTM2TeXPGlossaryNoImplicitPageRangeKey = @"Glossary_NoImplicitPageRange4iTM3";
NSString * const iTM2TeXPGlossaryIsSeparateKey = @"Glossary_IsSeparate4iTM3";
NSString * const iTM2TeXPGlossarySeparateStartKey = @"Glossary_SeparateStart4iTM3";
NSString * const iTM2TeXPGlossaryRunSilentlyKey = @"Glossary_RunSilently4iTM3";

@implementation iTM2TeXPGlossaryInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryUseOutputKey,
                @"", iTM2TeXPGlossaryOutputKey,
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryUseStyleKey,
                @"", iTM2TeXPGlossaryStyleKey,
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryCompressBlanksKey,
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryGermanOrderingKey,
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryLetterOrderingKey,
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryNoImplicitPageRangeKey,
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryIsSeparateKey,
                @"any", iTM2TeXPGlossarySeparateStartKey,
                [NSNumber numberWithBool:NO], iTM2TeXPGlossaryRunSilentlyKey,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allEnvironmentVariables
+ (NSArray *)allEnvironmentVariables;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSArray arrayWithObjects:
                iTM2TeXPGlossaryUseOutputKey,
                iTM2TeXPGlossaryOutputKey,
                iTM2TeXPGlossaryUseStyleKey,
                iTM2TeXPGlossaryStyleKey,
                iTM2TeXPGlossaryCompressBlanksKey,
                iTM2TeXPGlossaryGermanOrderingKey,
                iTM2TeXPGlossaryLetterOrderingKey,
                iTM2TeXPGlossaryNoImplicitPageRangeKey,
                iTM2TeXPGlossaryIsSeparateKey,
                iTM2TeXPGlossarySeparateStartKey,
                iTM2TeXPGlossaryRunSilentlyKey,
			nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"iTM2TeXProjectIndex";
}
#pragma mark =-=-=-=-=-  OUTPUT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseOutput:
- (IBAction)toggleUseOutput:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryUseOutputKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseOutput:
- (BOOL)validateToggleUseOutput:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryUseOutputKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputEdited:
- (IBAction)outputEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeXPGlossaryOutputKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOutputEdited:
- (BOOL)validateOutputEdited:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * output = [self info4iTM3ForKeyPaths:iTM2TeXPGlossaryOutputKey,nil];
    if(!output.length)
    {
        iTM2TeXProjectDocument * myTPD = (iTM2TeXProjectDocument *)self.document;
		output = [[[myTPD nameForFileKey:[myTPD masterFileKey]] stringByDeletingPathExtension] stringByAppendingPathExtension:iTM2TeXPGlossaryExtension];
        [self setInfo4TM3:output forKeyPaths:iTM2TeXPGlossaryOutputKey,nil];
        output = [self info4iTM3ForKeyPaths:iTM2TeXPGlossaryOutputKey,nil]?: @"";
    }
    sender.stringValue = output;
    return [[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryUseOutputKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  STYLE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseStyle:
- (IBAction)toggleUseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryUseStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseStyle:
- (BOOL)validateToggleUseStyle:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryUseStyleKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseStyle:
- (IBAction)chooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseStyle:
- (BOOL)validateChooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editStyle:
- (IBAction)editStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeXPGlossaryStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditStyle:
- (BOOL)validateEditStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([self info4iTM3ForKeyPaths:iTM2TeXPGlossaryStyleKey,nil]?:@"")];
    return [[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryUseStyleKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  OPTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCompressBlanks:
- (IBAction)toggleCompressBlanks:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryCompressBlanksKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleCompressBlanks:
- (BOOL)validateToggleCompressBlanks:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryCompressBlanksKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleGermanOrdering:
- (IBAction)toggleGermanOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryGermanOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleGermanOrdering:
- (BOOL)validateToggleGermanOrdering:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryGermanOrderingKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleLetterOrdering:
- (IBAction)toggleLetterOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryLetterOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleLetterOrdering:
- (BOOL)validateToggleLetterOrdering:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryLetterOrderingKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNoImplicitPageRange:
- (IBAction)toggleNoImplicitPageRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryNoImplicitPageRangeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNoImplicitPageRange:
- (BOOL)validateToggleNoImplicitPageRange:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryNoImplicitPageRangeKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
#pragma mark =-=-=-=-=-  SEPARATE INDEX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSeparateIndex:
- (IBAction)toggleSeparateIndex:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSeparateIndex:
- (BOOL)validateToggleSeparateIndex:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startingAtChosen:
- (IBAction)startingAtChosen:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * option;
    switch([sender indexOfSelectedItem])
    {
        case 0:
            option = @"any";
            break;
        case 1:
            option = @"odd";
            break;
        case 2:
            option = @"even";
            break;
        default:
            option = [NSString stringWithFormat:@"%d", MAX([([self info4iTM3ForKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil]) integerValue], 1)];
            break;
    }
    [self setInfo4TM3:option forKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
	[self isWindowContentValid4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtChosen:
- (BOOL)validateStartingAtChosen:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * option = [self info4iTM3ForKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
		NSInteger index = 3;
		if([option isEqualToString:@"any"])
			index = ZER0;
		else if([option isEqualToString:@"odd"])
			index = 1;
		else if([option isEqualToString:@"even"])
			index = 2;
		[sender selectItemAtIndex:index];
		return [[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil] boolValue];
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startingAtEdited:
- (IBAction)startingAtEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[NSNumber numberWithInteger:[sender integerValue]] forKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtEdited:
- (BOOL)validateStartingAtEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * option = [self info4iTM3ForKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
	BOOL enabled = !([option isEqualToString:@"any"] || [option isEqualToString:@"odd"] || [option isEqualToString:@"even"]);
    [sender setIntegerValue:[option integerValue]];
    return [[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil] boolValue] && enabled;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRunSilently:
- (IBAction)toggleRunSilently:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPGlossaryRunSilentlyKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateToggleRunSilently:
- (BOOL)validateToggleRunSilently:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPGlossaryRunSilentlyKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
@end

NSString * const iTM2TeXPBibliographyRunSilentlyKey = @"Bibliography_RunSilently4iTM3";
NSString * const iTM2TeXPBibliographyUseAuxNameKey = @"Bibliography_UseAuxName4iTM3";
NSString * const iTM2TeXPBibliographyAuxNameKey = @"Bibliography_AuxName4iTM3";
NSString * const iTM2TeXPBibliographyMinXReferencesKey = @"Bibliography_MinXReferences4iTM3";

@implementation iTM2TeXPBibliographyInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:NO], iTM2TeXPBibliographyRunSilentlyKey,
                [NSNumber numberWithBool:NO], iTM2TeXPBibliographyUseAuxNameKey,
                @"", iTM2TeXPBibliographyAuxNameKey,
                [NSNumber numberWithInteger:NO], iTM2TeXPBibliographyMinXReferencesKey,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRunSilently:
- (IBAction)toggleRunSilently:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPBibliographyRunSilentlyKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateToggleRunSilently:
- (BOOL)validateToggleRunSilently:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPBibliographyRunSilentlyKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
#pragma mark =-=-=-=-=-  AUX NAME
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseAuxName:
- (IBAction)toggleUseAuxName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self toggleInfo4iTM3ForKeyPaths:iTM2TeXPBibliographyUseAuxNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseAuxName:
- (BOOL)validateToggleUseAuxName:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self info4iTM3ForKeyPaths:iTM2TeXPBibliographyUseAuxNameKey,nil] boolValue]? NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  auxNameEdited:
- (IBAction)auxNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[sender stringValue] forKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAuxNameEdited:
- (BOOL)validateAuxNameEdited:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * output = [self info4iTM3ForKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil];
    if(!output.length) {
        iTM2TeXProjectDocument * myTPD = (iTM2TeXProjectDocument *)self.document;
		output = [[myTPD nameForFileKey:[myTPD masterFileKey]] stringByDeletingPathExtension];
        [self setInfo4TM3:output forKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil];
        output = ([self info4iTM3ForKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil]?: @"");
    }
    sender.stringValue = output;
    return [[self info4iTM3ForKeyPaths:iTM2TeXPBibliographyUseAuxNameKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  MIN X REFs
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  minXReferencesEdited:
- (IBAction)minXReferencesEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[NSNumber numberWithInteger:[sender integerValue]] forKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMinXReferencesEdited:
- (BOOL)validateMinXReferencesEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSNumber * N = [self info4iTM3ForKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];
    if(!N)
    {
        [self setInfo4TM3:[NSNumber numberWithInteger:2] forKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];// 2 is a default value
        N = [self info4iTM3ForKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];
    }
    [sender setIntegerValue:[N integerValue]];
    return YES;
}
@end

@implementation iTM2TeXPRenderInspector
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allEnvironmentVariables
+ (NSArray *)allEnvironmentVariables;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSArray arrayWithObjects:
			nil];
}
#endif
@end

NSString * const iTM2TeXPTypesetModeKey = @"Typeset_Mode4iTM3";

NSString * const iTM2TeXPTypesetDefaultMode = @"default";
NSString * const iTM2TeXPTypesetLaTeXMode = @"latex";
NSString * const iTM2TeXPTypesetLaTeXBookMode = @"latex-book";
NSString * const iTM2TeXPTypesetLaTeXCompleteMode = @"latex-complete";

@implementation iTM2TeXPTypesetInspector
static NSArray * _iTM2TeXProjectTypesetModes;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(!_iTM2TeXProjectTypesetModes)
    {
        [super initialize];
        _iTM2TeXProjectTypesetModes =
            [[NSArray arrayWithObjects:iTM2TeXPTypesetDefaultMode, iTM2TeXPTypesetLaTeXMode, iTM2TeXPTypesetLaTeXBookMode, iTM2TeXPTypesetLaTeXCompleteMode, nil] retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				iTM2TeXPTypesetDefaultMode, iTM2TeXPTypesetModeKey,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allEnvironmentVariables
+ (NSArray *)allEnvironmentVariables;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSArray arrayWithObjects:
                iTM2TeXPTypesetModeKey,
			nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchMode:
- (IBAction)switchMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger tag = [[sender selectedCell] tag];
    [self setInfo4TM3:[_iTM2TeXProjectTypesetModes objectAtIndex: (tag>3? ZER0:tag)] forKeyPaths:iTM2TeXPTypesetModeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchMode:
- (BOOL)validateSwitchMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender selectCellWithTag:[_iTM2TeXProjectTypesetModes indexOfObject:[[self info4iTM3ForKeyPaths:iTM2TeXPTypesetModeKey,nil] lowercaseString]]];
    return YES;
}
@end

NSString * const iTM2TeXPCleanModeKey = @"Clean_Mode4iTM3";
NSString * const iTM2TeXPCleanExtensionsKey = @"Clean_Extensions4iTM3";
NSString * const iTM2TeXPCleanFoldersKey = @"Clean_Folders4iTM3";
NSString * const iTM2TeXPCleanLevelKey = @"Clean_Level4iTM3";

@implementation iTM2TeXPCleanInspector
static NSArray * _iTM2TeXProjectCleanModes;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(!_iTM2TeXProjectCleanModes)
    {
        [super initialize];
        _iTM2TeXProjectCleanModes =
            [[NSArray arrayWithObjects:@"default", @"filter", nil] retain];
        [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
            [NSArray arrayWithObjects:@"log", @"blg", @"ilg", @"aux", @"dvi", @"lof", @"lot", nil], iTM2TeXPCleanExtensionsKey,
            [NSArray arrayWithObjects:@"Figures", @"gfx", @"Graphics", nil], iTM2TeXPCleanFoldersKey,
                nil]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				[SUD objectForKey:iTM2TeXPCleanModeKey], iTM2TeXPCleanModeKey,
                [SUD objectForKey:iTM2TeXPCleanExtensionsKey], iTM2TeXPCleanExtensionsKey,
                [NSArray array], iTM2TeXPCleanFoldersKey,
                iTM2TeXPCleanLevelKey,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchMode:
- (IBAction)switchMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger tag = [[sender selectedCell] tag];
    [self setInfo4TM3:[_iTM2TeXProjectCleanModes objectAtIndex: (tag>1? ZER0:tag)] forKeyPaths:iTM2TeXPCleanModeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchMode:
- (BOOL)validateSwitchMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender selectCellWithTag:[_iTM2TeXProjectCleanModes indexOfObject:[[self info4iTM3ForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extensionsEdited:
- (IBAction)extensionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [[[sender stringValue] componentsSeparatedByString:@","] objectEnumerator];
    NSString * S;
    while(S = E.nextObject)
        [MRA addObject:[S stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [self setInfo4TM3:[[MRA copy] autorelease] forKeyPaths:iTM2TeXPCleanExtensionsKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateExtensionsEdited:
- (BOOL)validateExtensionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([[self info4iTM3ForKeyPaths:iTM2TeXPCleanExtensionsKey,nil] componentsJoinedByString:@", "] ?:@"")];
    return [_iTM2TeXProjectCleanModes indexOfObject:[[self info4iTM3ForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]>ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  foldersEdited:
- (IBAction)foldersEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [[[sender stringValue] componentsSeparatedByString:@","] objectEnumerator];
    NSString * S;
    while(S = E.nextObject)
        [MRA addObject:[S stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [self setInfo4TM3:[[MRA copy] autorelease] forKeyPaths:iTM2TeXPCleanFoldersKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFoldersEdited:
- (BOOL)validateFoldersEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setStringValue: ([[self info4iTM3ForKeyPaths:iTM2TeXPCleanFoldersKey,nil] componentsJoinedByString:@", "] ?:@"")];
    return ([_iTM2TeXProjectCleanModes indexOfObject:[[self info4iTM3ForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]>ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  levelEdited:
- (IBAction)levelEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo4TM3:[NSNumber numberWithInteger:MAX(ZER0, MIN([sender integerValue], 5))] forKeyPaths:iTM2TeXPCleanLevelKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateLevelEdited:
- (BOOL)validateLevelEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setIntegerValue:[[self info4iTM3ForKeyPaths:iTM2TeXPCleanLevelKey,nil] integerValue]];
    return ([_iTM2TeXProjectCleanModes indexOfObject:[[self info4iTM3ForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]>ZER0);
}
@end

@implementation iTM2TeXPSpecialInspector
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
					nil];
}
#endif
@end

@interface iTM2TeXPBibliographyPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPBibliographyPerformer
+ (NSInteger)commandGroup;{return 20;}
+ (NSInteger)commandLevel;{return 10;}
@end
@interface iTM2TeXPIndexPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPIndexPerformer
+ (NSInteger)commandGroup;{return 20;}
+ (NSInteger)commandLevel;{return 20;}
@end
@interface iTM2TeXPGlossaryPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPGlossaryPerformer
+ (NSInteger)commandGroup;{return 20;}
+ (NSInteger)commandLevel;{return 30;}
@end
@interface iTM2TeXPCleanPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPCleanPerformer
+ (NSInteger)commandGroup;{return 30;}
+ (NSInteger)commandLevel;{return 10;}
@end
@interface iTM2TeXPRenderPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPRenderPerformer
+ (NSInteger)commandGroup;{return 30;}
+ (NSInteger)commandLevel;{return ZER0;}
@end

#warning %%%%%%%%%%%%%%%  ALL THE CLASSES HAVE BEEN DEFINED
#undef DEFINECLASS

////#import <iTM3Foundation/iTM2Runtime.h>

@interface iTM2TeXPTypesetPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPTypesetPerformer
+ (NSInteger)commandGroup;
{DIAGNOSTIC4iTM3;
	return 10;
}
+ (NSInteger)commandLevel;
{DIAGNOSTIC4iTM3;
	return 20;
}
@end

@interface iTM2TeXPSpecialPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPSpecialPerformer
+ (NSInteger)commandGroup;
{DIAGNOSTIC4iTM3;
	return 30;
}
+ (NSInteger)commandLevel;
{DIAGNOSTIC4iTM3;
	return 20;
}
@end

#import <iTM2TeXFoundation/iTM2TeXProjectTaskKit.h>

@interface iTM2TeXPStopPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPStopPerformer
+ (NSInteger)commandGroup;
{DIAGNOSTIC4iTM3;
	return INT_MAX;
}
+ (NSInteger)commandLevel;
{DIAGNOSTIC4iTM3;
	return 20;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
+ (BOOL)validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
		return [[[[SPC currentProject] taskController] currentTask] isRunning];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doPerformCommandForProject:
+ (void)doPerformCommandForProject:(iTM2TeXProjectDocument *)project;
/*"Call back must have the following signature:
- (void)documentController:(if)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1: 03/10/2002
To Do List: to be improved...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[[project taskController] currentTask] interrupt];
    return;
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  TOOLBAR

NSString * const iTM2ToolbarTypesetItemIdentifier = @"typesetCurrentProject";

@implementation iTM2ProjectDocumentResponder(TeXPCommand)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  typesetCurrentProject:
- (IBAction)typesetCurrentProject:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-05 20:58:42 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:nil ROR4iTM3];
	NSImage * I = nil;
	if([[TPD.taskController currentTask] isRunning]) {
		[TPD.taskController stop];
		I = [NSImage cachedImageNamed4iTM3:@"typesetCurrentProject"];
	} else {
		NSString * commandName = [TPD context4iTM3ValueForKey:@"iTM2TeXProjectLastCommandName" domain:iTM2ContextAllDomainsMask ROR4iTM3];
		Class performer = [iTM2TeXPCommandManager commandPerformerForName:(commandName?:@"Compile")];
		[performer performCommandForProject: TPD];
		I = [NSImage cachedImageNamed4iTM3:@"stopTypesetCurrentProject"];
	}
	sender.image = I;
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTypesetCurrentProject:
- (BOOL)validateTypesetCurrentProject:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-05 20:58:53 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:sender ROR4iTM3];
	sender.image = [NSImage cachedImageNamed4iTM3:
		([[TPD.taskController currentTask] isRunning]?@"stopTypesetCurrentProject":@"typesetCurrentProject")];
//END4iTM3;
    return TPD != nil;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doubleTypesetCurrentProject:
- (IBAction)doubleTypesetCurrentProject:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-05 20:59:01 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:nil ROR4iTM3];
	NSImage * I = nil;
	if([[TPD.taskController currentTask] isRunning])
	{
		[TPD.taskController stop];
		I = [NSImage cachedImageNamed4iTM3:@"typesetCurrentProject"];
	}
	else
	{
		[[iTM2TeXPCommandManager commandPerformerForName:@"Typeset"]//very bad design...
			performCommandForProject: TPD];
		I = [NSImage cachedImageNamed4iTM3:@"stopTypesetCurrentProject"];
	}
	sender.image = I;
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDoubleTypesetCurrentProject:
- (BOOL)validateDoubleTypesetCurrentProject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-05 20:59:08 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:nil ROR4iTM3];
//END4iTM3;
    return [[iTM2TeXPCommandManager commandPerformerForName:@"Typeset"]//very bad design...
			canPerformCommandForProject: TPD];
}  
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXPIndexInspector classBundle4iTM3]];}

@implementation NSToolbarItem(iTM2TeXProjectFrontendKit)
DEFINE_TOOLBAR_ITEM(stopTypesetCurrentProjectToolbarItem)
+ (NSToolbarItem *)typesetCurrentProjectToolbarItem;
{
	[NSToolbarItem stopTypesetCurrentProjectToolbarItem];// initialize the image named @"stopTypesetCurrentProject" as desired side effect
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXPIndexInspector classBundle4iTM3]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	B.image = toolbarItem.image;
	[B setImagePosition:NSImageOnly];
	B.action = @selector(typesetCurrentProject:);
	B.doubleAction = @selector(doubleTypesetCurrentProject:);
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[B.cell setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	toolbarItem.view = B;
	[toolbarItem setMaxSize:frame.size];
	toolbarItem.minSize = frame.size;
	B.target = nil;
	[B.cell setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSEnumerator * E  = [[iTM2TeXPCommandManager orderedBuiltInCommandNames] objectEnumerator];
	NSEnumerator * e;
	if(e = [E.nextObject objectEnumerator])
	{
		NSString * name;
next:
		while(name = e.nextObject)
		{
			Class performer = [iTM2TeXPCommandManager commandPerformerForName:name];
			SEL action = @selector(performCommand:);
			if([performer respondsToSelector:action])
			{
				NSMenuItem * mi = [[[NSMenuItem alloc] initWithTitle:[[performer class] localizedNameForName:name]
						action: action
							keyEquivalent: @""] autorelease];
				mi.representedObject = performer;
				mi.target = performer;// performer is expected to last forever
				[M addItem:mi];
			}
		}
		if(e = [E.nextObject objectEnumerator])
		{
			[M addItem:[NSMenuItem separatorItem]];
			goto next;
		}
	}
	NSPopUpButton * PB = [[[NSPopUpButton alloc] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB insertItemWithTitle:@"" atIndex:ZER0];// the title is the first item
	[PB setPullsDown:YES];
	[PB selectItem:nil];
	[B.cell setPopUpCell:PB.cell];
	return toolbarItem;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCommandWrapperKit


