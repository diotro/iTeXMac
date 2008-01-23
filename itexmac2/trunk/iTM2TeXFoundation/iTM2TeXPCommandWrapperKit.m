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

NSString * const iTM2TeXPIndexUseOutputKey = @"iTM2_Index_UseOutput";
NSString * const iTM2TeXPIndexOutputKey = @"iTM2_Index_Output";
NSString * const iTM2TeXPIndexUseStyleKey = @"iTM2_Index_UseStyle";
NSString * const iTM2TeXPIndexStyleKey = @"iTM2_Index_Style";
NSString * const iTM2TeXPIndexCompressBlanksKey = @"iTM2_Index_CompressBlanks";
NSString * const iTM2TeXPIndexGermanOrderingKey = @"iTM2_Index_GermanOrdering";
NSString * const iTM2TeXPIndexLetterOrderingKey = @"iTM2_Index_LetterOrdering";
NSString * const iTM2TeXPIndexNoImplicitPageRangeKey = @"iTM2_Index_NoImplicitPageRange";
NSString * const iTM2TeXPIndexIsSeparateKey = @"iTM2_Index_IsSeparate";
NSString * const iTM2TeXPIndexSeparateStartKey = @"iTM2_Index_SeparateStart";
NSString * const iTM2TeXPIndexRunSilentlyKey = @"iTM2_Index_RunSilently";

@implementation iTM2TeXPIndexInspector
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexUseOutputKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseOutput:
- (BOOL)validateToggleUseOutput:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexUseOutputKey, nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputEdited:
- (IBAction)outputEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self document] takeInfo:[sender stringValue] forKeyPaths:iTM2TeXPIndexOutputKey, nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOutputEdited:
- (BOOL)validateOutputEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * myTPD = (iTM2TeXProjectDocument *)[self document];
    NSString * output = [self infoForKeyPaths:iTM2TeXPIndexOutputKey,nil];
    if(![output length])
    {
		NSString * path = [[myTPD nameForFileKey:[myTPD masterFileKey]] stringByDeletingPathExtension];
		[self takeInfo:([path length]? [path stringByAppendingPathExtension:iTM2TeXPIndexExtension]:@"") forKeyPaths:iTM2TeXPIndexOutputKey, nil];
        output = [self infoForKeyPaths:iTM2TeXPIndexOutputKey, nil]?: @"";
    }
    [sender setStringValue:output];
//iTM2_END;
    return [[self infoForKeyPaths:iTM2TeXPIndexUseOutputKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  STYLE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseStyle:
- (IBAction)toggleUseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexUseStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseStyle:
- (BOOL)validateToggleUseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexUseStyleKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseStyle:
- (IBAction)chooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseStyle:
- (BOOL)validateChooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editStyle:
- (IBAction)editStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[sender stringValue] forKeyPaths:iTM2TeXPIndexStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditStyle:
- (BOOL)validateEditStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self infoForKeyPaths:iTM2TeXPIndexStyleKey,nil]?:@"")];
    return [[self infoForKeyPaths:iTM2TeXPIndexUseStyleKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  OPTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCompressBlanks:
- (IBAction)toggleCompressBlanks:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexCompressBlanksKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleCompressBlanks:
- (BOOL)validateToggleCompressBlanks:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexCompressBlanksKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleGermanOrdering:
- (IBAction)toggleGermanOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexGermanOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleGermanOrdering:
- (BOOL)validateToggleGermanOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexGermanOrderingKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleLetterOrdering:
- (IBAction)toggleLetterOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexLetterOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleLetterOrdering:
- (BOOL)validateToggleLetterOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexLetterOrderingKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNoImplicitPageRange:
- (IBAction)toggleNoImplicitPageRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexNoImplicitPageRangeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNoImplicitPageRange:
- (BOOL)validateToggleNoImplicitPageRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexNoImplicitPageRangeKey,nil] boolValue]? NSOnState:NSOffState)];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSeparateIndex:
- (BOOL)validateToggleSeparateIndex:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startingAtChosen:
- (IBAction)startingAtChosen:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
            option = [NSString stringWithFormat:@"%d", MAX([([self infoForKeyPaths:iTM2TeXPIndexSeparateStartKey,nil]) intValue], 1)];
            break;
    }
    [self takeInfo:option forKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtChosen:
- (BOOL)validateStartingAtChosen:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * option = [self infoForKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
		int index = 3;
		if([option isEqualToString:@"any"])
			index = 0;
		else if([option isEqualToString:@"odd"])
			index = 1;
		else if([option isEqualToString:@"even"])
			index = 2;
		[sender selectItemAtIndex:index];
		return [[self infoForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil] boolValue];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[NSNumber numberWithInt:[sender intValue]] forKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtEdited:
- (BOOL)validateStartingAtEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * option = [self infoForKeyPaths:iTM2TeXPIndexSeparateStartKey,nil];
	BOOL enabled = !([option isEqualToString:@"any"] || [option isEqualToString:@"odd"] || [option isEqualToString:@"even"]);
    [sender setIntValue:[option intValue]];
    return [[self infoForKeyPaths:iTM2TeXPIndexIsSeparateKey,nil] boolValue] && enabled;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRunSilently:
- (IBAction)toggleRunSilently:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPIndexRunSilentlyKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateToggleRunSilently:
- (BOOL)validateToggleRunSilently:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPIndexRunSilentlyKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
@end

NSString * const iTM2TeXPGlossaryUseOutputKey = @"iTM2_Glossary_UseOutput";
NSString * const iTM2TeXPGlossaryOutputKey = @"iTM2_Glossary_Output";
NSString * const iTM2TeXPGlossaryUseStyleKey = @"iTM2_Glossary_UseStyle";
NSString * const iTM2TeXPGlossaryStyleKey = @"iTM2_Glossary_Style";
NSString * const iTM2TeXPGlossaryCompressBlanksKey = @"iTM2_Glossary_CompressBlanks";
NSString * const iTM2TeXPGlossaryGermanOrderingKey = @"iTM2_Glossary_GermanOrdering";
NSString * const iTM2TeXPGlossaryLetterOrderingKey = @"iTM2_Glossary_LetterOrdering";
NSString * const iTM2TeXPGlossaryNoImplicitPageRangeKey = @"iTM2_Glossary_NoImplicitPageRange";
NSString * const iTM2TeXPGlossaryIsSeparateKey = @"iTM2_Glossary_IsSeparate";
NSString * const iTM2TeXPGlossarySeparateStartKey = @"iTM2_Glossary_SeparateStart";
NSString * const iTM2TeXPGlossaryRunSilentlyKey = @"iTM2_Glossary_RunSilently";

@implementation iTM2TeXPGlossaryInspector
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryUseOutputKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseOutput:
- (BOOL)validateToggleUseOutput:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryUseOutputKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputEdited:
- (IBAction)outputEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[sender stringValue] forKeyPaths:iTM2TeXPGlossaryOutputKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOutputEdited:
- (BOOL)validateOutputEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * output = [self infoForKeyPaths:iTM2TeXPGlossaryOutputKey,nil];
    if(![output length])
    {
        iTM2TeXProjectDocument * myTPD = (iTM2TeXProjectDocument *)[self document];
		output = [[[myTPD nameForFileKey:[myTPD masterFileKey]] stringByDeletingPathExtension] stringByAppendingPathExtension:iTM2TeXPGlossaryExtension];
        [self takeInfo:output forKeyPaths:iTM2TeXPGlossaryOutputKey,nil];
        output = [self infoForKeyPaths:iTM2TeXPGlossaryOutputKey,nil]?: @"";
    }
    [sender setStringValue:output];
    return [[self infoForKeyPaths:iTM2TeXPGlossaryUseOutputKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  STYLE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleUseStyle:
- (IBAction)toggleUseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryUseStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseStyle:
- (BOOL)validateToggleUseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryUseStyleKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseStyle:
- (IBAction)chooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseStyle:
- (BOOL)validateChooseStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editStyle:
- (IBAction)editStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[sender stringValue] forKeyPaths:iTM2TeXPGlossaryStyleKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditStyle:
- (BOOL)validateEditStyle:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([self infoForKeyPaths:iTM2TeXPGlossaryStyleKey,nil]?:@"")];
    return [[self infoForKeyPaths:iTM2TeXPGlossaryUseStyleKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  OPTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleCompressBlanks:
- (IBAction)toggleCompressBlanks:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryCompressBlanksKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleCompressBlanks:
- (BOOL)validateToggleCompressBlanks:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryCompressBlanksKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleGermanOrdering:
- (IBAction)toggleGermanOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryGermanOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleGermanOrdering:
- (BOOL)validateToggleGermanOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryGermanOrderingKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleLetterOrdering:
- (IBAction)toggleLetterOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryLetterOrderingKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleLetterOrdering:
- (BOOL)validateToggleLetterOrdering:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryLetterOrderingKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNoImplicitPageRange:
- (IBAction)toggleNoImplicitPageRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryNoImplicitPageRangeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNoImplicitPageRange:
- (BOOL)validateToggleNoImplicitPageRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryNoImplicitPageRangeKey,nil] boolValue]? NSOnState:NSOffState)];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSeparateIndex:
- (BOOL)validateToggleSeparateIndex:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  startingAtChosen:
- (IBAction)startingAtChosen:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
            option = [NSString stringWithFormat:@"%d", MAX([([self infoForKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil]) intValue], 1)];
            break;
    }
    [self takeInfo:option forKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtChosen:
- (BOOL)validateStartingAtChosen:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * option = [self infoForKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
		int index = 3;
		if([option isEqualToString:@"any"])
			index = 0;
		else if([option isEqualToString:@"odd"])
			index = 1;
		else if([option isEqualToString:@"even"])
			index = 2;
		[sender selectItemAtIndex:index];
		return [[self infoForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil] boolValue];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[NSNumber numberWithInt:[sender intValue]] forKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateStartingAtEdited:
- (BOOL)validateStartingAtEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * option = [self infoForKeyPaths:iTM2TeXPGlossarySeparateStartKey,nil];
	BOOL enabled = !([option isEqualToString:@"any"] || [option isEqualToString:@"odd"] || [option isEqualToString:@"even"]);
    [sender setIntValue:[option intValue]];
    return [[self infoForKeyPaths:iTM2TeXPGlossaryIsSeparateKey,nil] boolValue] && enabled;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRunSilently:
- (IBAction)toggleRunSilently:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPGlossaryRunSilentlyKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateToggleRunSilently:
- (BOOL)validateToggleRunSilently:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPGlossaryRunSilentlyKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
@end

NSString * const iTM2TeXPBibliographyRunSilentlyKey = @"iTM2_Bibliography_RunSilently";
NSString * const iTM2TeXPBibliographyUseAuxNameKey = @"iTM2_Bibliography_UseAuxName";
NSString * const iTM2TeXPBibliographyAuxNameKey = @"iTM2_Bibliography_AuxName";
NSString * const iTM2TeXPBibliographyMinXReferencesKey = @"iTM2_Bibliography_MinXReferences";

@implementation iTM2TeXPBibliographyInspector
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
				[NSNumber numberWithBool:NO], iTM2TeXPBibliographyRunSilentlyKey,
                [NSNumber numberWithBool:NO], iTM2TeXPBibliographyUseAuxNameKey,
                @"", iTM2TeXPBibliographyAuxNameKey,
                [NSNumber numberWithInt:NO], iTM2TeXPBibliographyMinXReferencesKey,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleRunSilently:
- (IBAction)toggleRunSilently:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPBibliographyRunSilentlyKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateToggleRunSilently:
- (BOOL)validateToggleRunSilently:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Mar 23 09:07:35 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPBibliographyRunSilentlyKey,nil] boolValue]? NSOnState:NSOffState)];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self toggleInfoForKeyPaths:iTM2TeXPBibliographyUseAuxNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleUseAuxName:
- (BOOL)validateToggleUseAuxName:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[self infoForKeyPaths:iTM2TeXPBibliographyUseAuxNameKey,nil] boolValue]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  auxNameEdited:
- (IBAction)auxNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[sender stringValue] forKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAuxNameEdited:
- (BOOL)validateAuxNameEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * output = [self infoForKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil];
    if(![output length])
    {
        iTM2TeXProjectDocument * myTPD = (iTM2TeXProjectDocument *)[self document];
		output = [[myTPD nameForFileKey:[myTPD masterFileKey]] stringByDeletingPathExtension];
        [self takeInfo:output forKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil];
        output = ([self infoForKeyPaths:iTM2TeXPBibliographyAuxNameKey,nil]?: @"");
    }
    [sender setStringValue:output];
    return [[self infoForKeyPaths:iTM2TeXPBibliographyUseAuxNameKey,nil] boolValue];
}
#pragma mark =-=-=-=-=-  MIN X REFs
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  minXReferencesEdited:
- (IBAction)minXReferencesEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[NSNumber numberWithInt:[sender intValue]] forKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMinXReferencesEdited:
- (BOOL)validateMinXReferencesEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSNumber * N = [self infoForKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];
    if(!N)
    {
        [self takeInfo:[NSNumber numberWithInt:2] forKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];// 2 is a default value
        N = [self infoForKeyPaths:iTM2TeXPBibliographyMinXReferencesKey,nil];
    }
    [sender setIntValue:[N intValue]];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSArray arrayWithObjects:
			nil];
}
#endif
@end

NSString * const iTM2TeXPTypesetModeKey = @"iTM2_Typeset_Mode";

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int tag = [[sender selectedCell] tag];
    [self takeInfo:[_iTM2TeXProjectTypesetModes objectAtIndex: (tag>3? 0:tag)] forKeyPaths:iTM2TeXPTypesetModeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchMode:
- (BOOL)validateSwitchMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag:[_iTM2TeXProjectTypesetModes indexOfObject:[[self infoForKeyPaths:iTM2TeXPTypesetModeKey,nil] lowercaseString]]];
    return YES;
}
@end

NSString * const iTM2TeXPCleanModeKey = @"iTM2_Clean_Mode";
NSString * const iTM2TeXPCleanExtensionsKey = @"iTM2_Clean_Extensions";
NSString * const iTM2TeXPCleanFoldersKey = @"iTM2_Clean_Folders";
NSString * const iTM2TeXPCleanLevelKey = @"iTM2_Clean_Level";

@implementation iTM2TeXPCleanInspector
static NSArray * _iTM2TeXProjectCleanModes;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int tag = [[sender selectedCell] tag];
    [self takeInfo:[_iTM2TeXProjectCleanModes objectAtIndex: (tag>1? 0:tag)] forKeyPaths:iTM2TeXPCleanModeKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchMode:
- (BOOL)validateSwitchMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag:[_iTM2TeXProjectCleanModes indexOfObject:[[self infoForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extensionsEdited:
- (IBAction)extensionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [[[sender stringValue] componentsSeparatedByString:@","] objectEnumerator];
    NSString * S;
    while(S = [E nextObject])
        [MRA addObject:[S stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [self takeInfo:[[MRA copy] autorelease] forKeyPaths:iTM2TeXPCleanExtensionsKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateExtensionsEdited:
- (BOOL)validateExtensionsEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([[self infoForKeyPaths:iTM2TeXPCleanExtensionsKey,nil] componentsJoinedByString:@", "] ?:@"")];
    return [_iTM2TeXProjectCleanModes indexOfObject:[[self infoForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  foldersEdited:
- (IBAction)foldersEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [[[sender stringValue] componentsSeparatedByString:@","] objectEnumerator];
    NSString * S;
    while(S = [E nextObject])
        [MRA addObject:[S stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    [self takeInfo:[[MRA copy] autorelease] forKeyPaths:iTM2TeXPCleanFoldersKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFoldersEdited:
- (BOOL)validateFoldersEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setStringValue: ([[self infoForKeyPaths:iTM2TeXPCleanFoldersKey,nil] componentsJoinedByString:@", "] ?:@"")];
    return ([_iTM2TeXProjectCleanModes indexOfObject:[[self infoForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]>0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  levelEdited:
- (IBAction)levelEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:[NSNumber numberWithInt:MAX(0, MIN([sender intValue], 5))] forKeyPaths:iTM2TeXPCleanLevelKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateLevelEdited:
- (BOOL)validateLevelEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setIntValue:[[self infoForKeyPaths:iTM2TeXPCleanLevelKey,nil] intValue]];
    return ([_iTM2TeXProjectCleanModes indexOfObject:[[self infoForKeyPaths:iTM2TeXPCleanModeKey,nil] lowercaseString]]>0);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
					nil];
}
#endif
@end
// If I don't define the load message, the next classes are ignored...
// This could some kind of buggy optimization
#if 1
#define DEFINECLASS(className, group, level)\
@interface className: iTM2TeXPCommandPerformer\
 @end\
@implementation className\
+ (void)load;\
{iTM2_DIAGNOSTIC;\
	iTM2_INIT_POOL;\
	iTM2RedirectNSLogOutput();\
	[NSObject class];\
	iTM2_RELEASE_POOL;\
	return;\
}\
+ (int)commandGroup;\
{iTM2_DIAGNOSTIC;\
	return group;\
}\
+ (int)commandLevel;\
{iTM2_DIAGNOSTIC;\
	return level;\
}\
@end
#else
#define DEFINECLASS(className, group, level)\
@interface className: iTM2TeXPCommandPerformer\
 @end\
@implementation className\
+ (int)commandGroup;\
{iTM2_DIAGNOSTIC;\
	return group;\
}\
+ (int)commandLevel;\
{iTM2_DIAGNOSTIC;\
	return level;\
}\
@end
#endif
DEFINECLASS(iTM2TeXPBibliographyPerformer, 20, 10)
DEFINECLASS(iTM2TeXPIndexPerformer, 20, 20)
DEFINECLASS(iTM2TeXPGlossaryPerformer, 20, 30)
DEFINECLASS(iTM2TeXPCleanPerformer, 30, 10)
DEFINECLASS(iTM2TeXPRenderPerformer, 30, 0)
//DEFINECLASS(iTM2TeXPTypesetPerformer, 10, 20)
//DEFINECLASS(iTM2TeXPSpecialPerformer, 30, 20)
#warning %%%%%%%%%%%%%%%  ALL THE CLASSES HAVE BEEN DEFINED
#undef DEFINECLASS

////#import <iTM2Foundation/iTM2RuntimeBrowser.h>

@interface iTM2TeXPTypesetPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPTypesetPerformer
+ (int)commandGroup;
{iTM2_DIAGNOSTIC;
	return 10;
}
+ (int)commandLevel;
{iTM2_DIAGNOSTIC;
	return 20;
}
@end

@interface iTM2TeXPSpecialPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPSpecialPerformer
+ (int)commandGroup;
{iTM2_DIAGNOSTIC;
	return 30;
}
+ (int)commandLevel;
{iTM2_DIAGNOSTIC;
	return 20;
}
@end

#import <iTM2TeXFoundation/iTM2TeXProjectTaskKit.h>

@interface iTM2TeXPStopPerformer: iTM2TeXPCommandPerformer
@end
@implementation iTM2TeXPStopPerformer
+ (int)commandGroup;
{iTM2_DIAGNOSTIC;
	return INT_MAX;
}
+ (int)commandLevel;
{iTM2_DIAGNOSTIC;
	return 20;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
+ (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[[project taskController] currentTask] interrupt];
    return;
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  TOOLBAR

NSString * const iTM2ToolbarTypesetItemIdentifier = @"typesetCurrentProject";

@implementation iTM2ProjectDocumentResponder(TeXPCommand)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  typesetCurrentProject:
- (IBAction)typesetCurrentProject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:nil];
	NSImage * I = nil;
	if([[[TPD taskController] currentTask] isRunning])
	{
		[[TPD taskController] stop];
		I = [NSImage iTM2_cachedImageNamed:@"typesetCurrentProject"];
	}
	else
	{
		NSString * commandName = [TPD contextValueForKey:@"iTM2TeXProjectLastCommandName" domain:iTM2ContextAllDomainsMask];
		id performer = [iTM2TeXPCommandManager commandPerformerForName:(commandName?:@"Compile")];
		[performer performCommandForProject: TPD];
		I = [NSImage iTM2_cachedImageNamed:@"stopTypesetCurrentProject"];
	}
	[sender setImage:I];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTypesetCurrentProject:
- (BOOL)validateTypesetCurrentProject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:sender];
	[sender setImage:[NSImage iTM2_cachedImageNamed:
		([[[TPD taskController] currentTask] isRunning]?@"stopTypesetCurrentProject":@"typesetCurrentProject")]];
//iTM2_END;
    return TPD != nil;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doubleTypesetCurrentProject:
- (IBAction)doubleTypesetCurrentProject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:nil];
	NSImage * I = nil;
	if([[[TPD taskController] currentTask] isRunning])
	{
		[[TPD taskController] stop];
		I = [NSImage iTM2_cachedImageNamed:@"typesetCurrentProject"];
	}
	else
	{
		[[iTM2TeXPCommandManager commandPerformerForName:@"Typeset"]//very bad design...
			performCommandForProject: TPD];
		I = [NSImage iTM2_cachedImageNamed:@"stopTypesetCurrentProject"];
	}
	[sender setImage:I];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDoubleTypesetCurrentProject:
- (BOOL)validateDoubleTypesetCurrentProject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [SPC projectForSource:nil];
//iTM2_END;
    return [[iTM2TeXPCommandManager commandPerformerForName:@"Typeset"]//very bad design...
			canPerformCommandForProject: TPD];
}  
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXPIndexInspector classBundle]];}

@implementation NSToolbarItem(iTM2TeXProjectFrontendKit)
DEFINE_TOOLBAR_ITEM(stopTypesetCurrentProjectToolbarItem)
+ (NSToolbarItem *)typesetCurrentProjectToolbarItem;
{
	[NSToolbarItem stopTypesetCurrentProjectToolbarItem];// initialize the image named @"stopTypesetCurrentProject" as desired side effect
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXPIndexInspector classBundle]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	[B setImage:[toolbarItem image]];
	[B setImagePosition:NSImageOnly];
	[B setAction:@selector(typesetCurrentProject:)];
	[B setDoubleAction:@selector(doubleTypesetCurrentProject:)];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[[B cell] setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	[toolbarItem setView:B];
	[toolbarItem setMaxSize:frame.size];
	[toolbarItem setMinSize:frame.size];
	[B setTarget:nil];
	[[B cell] setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	NSEnumerator * E  = [[iTM2TeXPCommandManager orderedBuiltInCommandNames] objectEnumerator];
	NSEnumerator * e;
	if(e = [[E nextObject] objectEnumerator])
	{
		NSString * name;
next:
		while(name = [e nextObject])
		{
			id performer = [iTM2TeXPCommandManager commandPerformerForName:name];
			SEL action = @selector(performCommand:);
			if([performer respondsToSelector:action])
			{
				NSMenuItem * mi = [[[NSMenuItem allocWithZone:[M zone]] initWithTitle:[[performer class] localizedNameForName:name]
						action: action
							keyEquivalent: @""] autorelease];
				[mi setRepresentedObject:performer];
				[mi setTarget:performer];// performer is expected to last forever
				[M addItem:mi];
			}
		}
		if(e = [[E nextObject] objectEnumerator])
		{
			[M addItem:[NSMenuItem separatorItem]];
			goto next;
		}
	}
	NSPopUpButton * PB = [[[NSPopUpButton allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB insertItemWithTitle:@"" atIndex:0];// the title is the first item
	[PB setPullsDown:YES];
	[PB selectItem:nil];
	[[B cell] setPopUpCell:[PB cell]];
	return toolbarItem;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCommandWrapperKit


