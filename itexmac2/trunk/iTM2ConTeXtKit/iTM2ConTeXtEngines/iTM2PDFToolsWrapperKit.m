/*
//  iTM2PDFToolsWrapperKit.m
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

#define TOGGLE(ACTION, VALIDATE, KEY)\
-(void)ACTION:(id)sender;{[self takeModelValue:[NSNumber numberWithBool: ![[self modelValueForKey:KEY] boolValue]] forKey:KEY];[self validateWindowContent];return;}\
-(BOOL)VALIDATE:(id)sender;{[sender setState:([[self modelValueForKey:KEY] boolValue]? NSOnState:NSOffState)];return YES;}
#define FEDIT(ACTION, VALIDATE, KEY)\
-(void)ACTION:(id)sender;{[self takeModelValue:[NSNumber numberWithFloat:[sender floatValue]] forKey:KEY];[self validateWindowContent];return;}\
-(BOOL)VALIDATE:(id)sender;{[sender setFloatValue:[[self modelValueForKey:KEY] floatValue]];return YES;}
#define SEDIT(ACTION, VALIDATE, KEY)\
-(void)ACTION:(id)sender;{[self takeModelValue:[sender stringValue] forKey:KEY];[self validateWindowContent];return;}\
-(BOOL)VALIDATE:(id)sender;{[sender setStringValue:[self modelValueForKey:KEY]];return YES;}
#define UNIT(ACTION, VALIDATE, KEY)\
-(void)ACTION:(id)sender;\
{\
	switch([[sender selectedItem] tag])\
	{\
		case 0: [self takeModelValue:@"bp" forKey:KEY]; [self validateWindowContent]; return;\
		case 1: [self takeModelValue:@"pt" forKey:KEY]; [self validateWindowContent]; return;\
		case 2: [self takeModelValue:@"in" forKey:KEY]; [self validateWindowContent]; return;\
		default: [self takeModelValue:@"cm" forKey:KEY]; [self validateWindowContent]; return;\
	}\
    return;\
}\
-(BOOL)VALIDATE:(id)sender;\
{\
	NSString * unit = [self modelValueForKey:KEY];\
	if([unit isEqual:@"bp"])\
		[sender selectItemWithTag:0];\
	else if([unit isEqual:@"pt"])\
		[sender selectItemWithTag:1];\
	else if([unit isEqual:@"in"])\
		[sender selectItemWithTag:2];\
	else\
		[sender selectItemWithTag:3];\
	return YES;\
}

#import "iTM2TeXExecWrapperKit.h"

NSString * const iTM2PDFArrangeUseAddEmpty = @"iTM2_PDFArrange_USE_addempty";
NSString * const iTM2PDFArrangeAddEmpty = @"iTM2_PDFArrange_addempty";
NSString * const iTM2PDFArrangeUseBackground = @"iTM2_PDFArrange_USE_background";
NSString * const iTM2PDFArrangeBackground = @"iTM2_PDFArrange_background";
NSString * const iTM2PDFArrangeUseBackSpace = @"iTM2_PDFArrange_USE_backSpace";
NSString * const iTM2PDFArrangeBackSpaceValue = @"iTM2_PDFArrange_backSpace_VALUE";
NSString * const iTM2PDFArrangeBackSpaceUnit = @"iTM2_PDFArrange_backSpace_UNIT";
NSString * const iTM2PDFArrangeCutMarks = @"iTM2_PDFArrange_markings";
NSString * const iTM2PDFArrangeSingleSided = @"iTM2_PDFArrange_noduplex";
NSString * const iTM2PDFArrangePaper = @"iTM2_PDFArrange_paper";
NSString * const iTM2PDFArrangeUsePaperOffset = @"iTM2_PDFArrange_USE_paperoffset";
NSString * const iTM2PDFArrangePaperOffsetValue = @"iTM2_PDFArrange_paperoffset_VALUE";
NSString * const iTM2PDFArrangePaperOffsetUnit = @"iTM2_PDFArrange_paperoffset_UNIT";
NSString * const iTM2PDFArrangeUsePages = @"iTM2_PDFArrange_USE_selection";
NSString * const iTM2PDFArrangePages = @"iTM2_PDFArrange_selection";
NSString * const iTM2PDFArrangeUseTextWidth = @"iTM2_PDFArrange_USE_textwidth";
NSString * const iTM2PDFArrangeTextWidthValue = @"iTM2_PDFArrange_textwidth_VALUE";
NSString * const iTM2PDFArrangeTextWidthUnit = @"iTM2_PDFArrange_textwidth_UNIT";
NSString * const iTM2PDFArrangeUseTopSpace = @"iTM2_PDFArrange_USE_topSpace";
NSString * const iTM2PDFArrangeTopSpaceValue = @"iTM2_PDFArrange_topSpace_VALUE";
NSString * const iTM2PDFArrangeTopSpaceUnit = @"iTM2_PDFArrange_topSpace_UNIT";
NSString * const iTM2PDFArrangeDirectory = @"iTM2_PDFArrange_DIRECTORY";
NSString * const iTM2PDFArrangeInput = @"iTM2_PDFArrange_INPUT";
NSString * const iTM2PDFArrangeVerbose = @"iTM2_PDFArrange_verbose";
NSString * const iTM2PDFArrangeSilent = @"iTM2_PDFArrange_silent";
NSString * const iTM2PDFArrangeResult = @"iTM2_PDFArrange_result";

@implementation iTM2PDFArrangeInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @".iTM2_Engine_pdfarrange";
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
    return [NSArray arrayWithObject:@"pdf"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+(NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:NO], iTM2PDFArrangeUseAddEmpty,
				@"", iTM2PDFArrangeAddEmpty,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeUseBackground,
				@"", iTM2PDFArrangeBackground,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeUseBackSpace,
				[NSNumber numberWithFloat:0], iTM2PDFArrangeBackSpaceValue,
				@"cm", iTM2PDFArrangeBackSpaceUnit,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeCutMarks,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeSingleSided,
				@"A4", iTM2PDFArrangePaper,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeUsePaperOffset,
				[NSNumber numberWithFloat:0], iTM2PDFArrangePaperOffsetValue,
				@"cm", iTM2PDFArrangePaperOffsetUnit,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeUsePages,
				@"", iTM2PDFArrangePages,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeUseTextWidth,
				[NSNumber numberWithFloat:0], iTM2PDFArrangeTextWidthValue,
				@"cm", iTM2PDFArrangeTextWidthUnit,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeUseTopSpace,
				[NSNumber numberWithFloat:0], iTM2PDFArrangeTopSpaceValue,
				@"cm", iTM2PDFArrangeTopSpaceUnit,
				@"", iTM2PDFArrangeInput,
				@"", iTM2PDFArrangeResult,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeVerbose,
				[NSNumber numberWithBool:NO], iTM2PDFArrangeSilent,
					nil];
}
TOGGLE(useAddEmpty, validateUseAddEmpty, iTM2PDFArrangeUseAddEmpty);
TOGGLE(useBackground, validateUseBackground, iTM2PDFArrangeUseBackground);
TOGGLE(useBackSpace, validateUseBackSpace, iTM2PDFArrangeUseBackSpace);
TOGGLE(cutMarks, validateCutMarks, iTM2PDFArrangeCutMarks);
TOGGLE(singleSided, validateSingleSided, iTM2PDFArrangeSingleSided);
TOGGLE(usePaperOffset, validateUsePaperOffset, iTM2PDFArrangeUsePaperOffset);
TOGGLE(usePages, validateUsePages, iTM2PDFArrangeUsePages);
TOGGLE(useTextWidth, validateUseTextWidth, iTM2PDFArrangeUseTextWidth);
TOGGLE(useTopSpace, validateUseTopSpace, iTM2PDFArrangeUseTopSpace);
TOGGLE(verbose, validateVerbose, iTM2PDFArrangeVerbose);
TOGGLE(silent, validateSilent, iTM2PDFArrangeSilent);
SEDIT(addEmpty, validateAddEmpty, iTM2PDFArrangeAddEmpty);
SEDIT(background, validateBackground, iTM2PDFArrangeBackground);
SEDIT(input, validateInput, iTM2PDFArrangeInput);
SEDIT(result, validateResult, iTM2PDFArrangeResult);
SEDIT(paper, validatePaper, iTM2PDFArrangePaper);
SEDIT(pages, validatePages, iTM2PDFArrangePages);
FEDIT(backSpaceValue, validateBackSpaceValue, iTM2PDFArrangeBackSpaceValue);
FEDIT(paperOffsetValue, validatePaperOffsetValue, iTM2PDFArrangePaperOffsetValue);
FEDIT(textWidthValue, validateTextWidthValue, iTM2PDFArrangeTextWidthValue);
FEDIT(topSpaceValue, validateTopSpaceValue, iTM2PDFArrangeTopSpaceValue);
UNIT(backSpaceUnitPopUp, validateBackSpaceUnitPopUp, iTM2PDFArrangeBackSpaceUnit);
UNIT(paperOffsetUnitPopUp, validatePaperOffsetUnitPopUp, iTM2PDFArrangePaperOffsetUnit);
UNIT(textWidthUnitPopUp, validateTextWidthUnitPopUp, iTM2PDFArrangeTextWidthUnit);
UNIT(TopSpaceUnitPopUp, validateTopSpaceUnitPopUp, iTM2PDFArrangeTopSpaceUnit);
@end

#if 0
         --combination   n*m pages per page
            --nobanner   no footerline
       	       --paper   paper format
         --paperoffset   room left at paper border
#endif

NSString * const iTM2PDFCombineCombination = @"iTM2_PDFCombine_combination";
NSString * const iTM2PDFCombineNoBanner = @"iTM2_PDFCombine_nobanner";
NSString * const iTM2PDFCombinePaper = @"iTM2_PDFCombine_paper";
NSString * const iTM2PDFCombineUsePaperOffset = @"iTM2_PDFCombine_USE_paperoffset";
NSString * const iTM2PDFCombinePaperOffsetValue = @"iTM2_PDFCombine_paperoffset_VALUE";
NSString * const iTM2PDFCombinePaperOffsetUnit = @"iTM2_PDFCombine_paperoffset_UNIT";
NSString * const iTM2PDFCombineUseResult = @"iTM2_PDFCombine_USE_result";
NSString * const iTM2PDFCombineResult = @"iTM2_PDFCombine_result";
NSString * const iTM2PDFCombineVerbose = @"iTM2_PDFCombine_verbose";
NSString * const iTM2PDFCombineSilent = @"iTM2_PDFCombine_silent";

@implementation iTM2PDFCombineInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @".iTM2_Engine_pdfcombine";
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
    return [NSArray arrayWithObject:@"pdf"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+(NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				@"1*1", iTM2PDFCombineCombination,
				[NSNumber numberWithBool:NO], iTM2PDFCombineNoBanner,
				@"A4", iTM2PDFCombinePaper,
				[NSNumber numberWithBool:NO], iTM2PDFCombineUsePaperOffset,
				[NSNumber numberWithFloat:0], iTM2PDFCombinePaperOffsetValue,
				@"cm", iTM2PDFCombinePaperOffsetUnit,
				[NSNumber numberWithBool:NO], iTM2PDFCombineVerbose,
				[NSNumber numberWithBool:NO], iTM2PDFCombineSilent,
					nil];
}
TOGGLE(usePaperOffset, validateUsePaperOffset, iTM2PDFCombineUsePaperOffset);
TOGGLE(noBanner, validateNoBanner, iTM2PDFCombineNoBanner);
TOGGLE(verbose, validateVerbose, iTM2PDFCombineVerbose);
TOGGLE(silent, validateSilent, iTM2PDFCombineSilent);
TOGGLE(useResult, validateUseResult, iTM2PDFCombineUseResult);
FEDIT(paperOffsetValue, validatePaperOffsetValue, iTM2PDFCombinePaperOffsetValue);
SEDIT(result, validateResult, iTM2PDFCombineResult);
SEDIT(combination, validateCombination, iTM2PDFCombineCombination);
SEDIT(paper, validatepaper, iTM2PDFCombinePaper);
SEDIT(paperOffsetUnit, validatePaperOffsetUnit, iTM2PDFCombinePaperOffsetUnit);
@end

#if 0
             --pdfcopy   scale pages down/up
          --background
                           =string   : background graphic
            --markings   add cutmarks
         --paperoffset   room left at paper border
               --scale   new page scale
              --result   resulting file
                           =name     : filename
             --verbose   shows some additional info
              --silent   minimize (status) messages
#endif

NSString * const iTM2PDFCopyUseBackground = @"iTM2_PDFCopy_USE_background";
NSString * const iTM2PDFCopyBackground = @"iTM2_PDFCopy_background";
NSString * const iTM2PDFCopyCutMarks = @"iTM2_PDFCopy_markings";
NSString * const iTM2PDFCopyUsePaperOffset = @"iTM2_PDFCopy_USE_paperoffset";
NSString * const iTM2PDFCopyPaperOffsetValue = @"iTM2_PDFCopy_paperoffset_VALUE";
NSString * const iTM2PDFCopyPaperOffsetUnit = @"iTM2_PDFCopy_paperoffset_UNIT";
NSString * const iTM2PDFCopyScale = @"iTM2_PDFCopy_scale";
NSString * const iTM2PDFCopyUseResult = @"iTM2_PDFCopy_USE_result";
NSString * const iTM2PDFCopyResult = @"iTM2_PDFCopy_result";
NSString * const iTM2PDFCopyVerbose = @"iTM2_PDFCopy_verbose";
NSString * const iTM2PDFCopySilent = @"iTM2_PDFCopy_silent";

@implementation iTM2PDFCopyInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @".iTM2_Engine_pdfcopy";
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
    return [NSArray arrayWithObject:@"pdf"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+(NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:NO], iTM2PDFCopyUseBackground,
				[NSNumber numberWithBool:NO], iTM2PDFCopyCutMarks,
				[NSNumber numberWithBool:NO], iTM2PDFCopyUsePaperOffset,
				[NSNumber numberWithBool:NO], iTM2PDFCopyUseResult,
				[NSNumber numberWithBool:NO], iTM2PDFCopyVerbose,
				[NSNumber numberWithBool:NO], iTM2PDFCopySilent,
				[NSNumber numberWithFloat:0], iTM2PDFCopyScale,
				[NSNumber numberWithFloat:0], iTM2PDFCopyPaperOffsetValue,
				@"", iTM2PDFCopyResult,
				@"", iTM2PDFCopyBackground,
				@"cm", iTM2PDFCopyPaperOffsetUnit,
					nil];
}
TOGGLE(useBackground, validateUseBackground, iTM2PDFCopyUseBackground);
TOGGLE(markings, validateCutMarks, iTM2PDFCopyCutMarks);
TOGGLE(usePaperOffset, validateUsePaperOffset, iTM2PDFCopyUsePaperOffset);
TOGGLE(useResult, validateUseResult, iTM2PDFCopyUseResult);
TOGGLE(verbose, validateVerbose, iTM2PDFCopyVerbose);
TOGGLE(silent, validateSilent, iTM2PDFCopySilent);
FEDIT(scale, validateScale, iTM2PDFCopyScale);
FEDIT(paperOffsetValue, validatePaperOffsetValue, iTM2PDFCopyPaperOffsetValue);
SEDIT(result, validateResult, iTM2PDFCopyResult);
SEDIT(background, validateBackgrounf, iTM2PDFCopyBackground);
UNIT(backSpaceUnitPopUp, validateBackSpaceUnitPopUp, iTM2PDFCopyPaperOffsetUnit);
@end

#if 0
          --pdfselect   select pdf pages
            --addempty   add empty page after
          --background
                           =string   : background graphic
           --backspace   inner margin of the page
            --markings   add cutmarks
         --paper   paper format
         --paperoffset   room left at paper border
           --pages   pages to select
                           =even     : even pages
                           =odd      : odd pages
                           =x,y:z    : pages x and y to z
           --textwidth   width of the original (one sided) text
            --topSpace   top/bottom margin of the page
#endif

NSString * const iTM2PDFSelectUseAddEmpty = @"iTM2_PDFSelect_USE_addempty";
NSString * const iTM2PDFSelectAddEmpty = @"iTM2_PDFSelect_addempty";
NSString * const iTM2PDFSelectUseBackground = @"iTM2_PDFSelect_USE_background";
NSString * const iTM2PDFSelectBackground = @"iTM2_PDFSelect_background";
NSString * const iTM2PDFSelectUseBackspace = @"iTM2_PDFSelect_USE_backspace";
NSString * const iTM2PDFSelectBackspaceValue = @"iTM2_PDFSelect_backspace_VALUE";
NSString * const iTM2PDFSelectBackspaceUnit = @"iTM2_PDFSelect_backspace_UNIT";
NSString * const iTM2PDFSelectCutMarks = @"iTM2_PDFSelect_markings";
NSString * const iTM2PDFSelectPaper = @"iTM2_PDFSelect_paper";
NSString * const iTM2PDFSelectUseTextWidth = @"iTM2_PDFSelect_USE_textwidth";
NSString * const iTM2PDFSelectTextWidthValue = @"iTM2_PDFSelect_textwidth_VALUE";
NSString * const iTM2PDFSelectTextWidthUnit = @"iTM2_PDFSelect_textwidth_UNIT";
NSString * const iTM2PDFSelectUseTopSpace = @"iTM2_PDFSelect_USE_topSpace";
NSString * const iTM2PDFSelectTopSpaceValue = @"iTM2_PDFSelect_topSpace_VALUE";
NSString * const iTM2PDFSelectTopSpaceUnit = @"iTM2_PDFSelect_topSpace_UNIT";
NSString * const iTM2PDFSelectUseResult = @"iTM2_PDFSelect_USE_result";
NSString * const iTM2PDFSelectResult = @"iTM2_PDFSelect_result";
NSString * const iTM2PDFSelectVerbose = @"iTM2_PDFSelect_verbose";
NSString * const iTM2PDFSelectSilent = @"iTM2_PDFSelect_silent";

@implementation iTM2PDFSelectInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @".iTM2_Engine_pdfselect";
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
    return [NSArray arrayWithObject:@"pdf"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+(NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:NO], iTM2PDFCopyUseBackground,
				[NSNumber numberWithBool:NO], iTM2PDFCopyCutMarks,
				[NSNumber numberWithBool:NO], iTM2PDFCopyUsePaperOffset,
				[NSNumber numberWithBool:NO], iTM2PDFCopyUseResult,
				[NSNumber numberWithBool:NO], iTM2PDFCopyVerbose,
				[NSNumber numberWithBool:NO], iTM2PDFCopySilent,
				[NSNumber numberWithBool:NO], iTM2PDFCopyVerbose,
				[NSNumber numberWithBool:NO], iTM2PDFCopySilent,
				[NSNumber numberWithFloat:0], iTM2PDFCopyScale,
				[NSNumber numberWithFloat:0], iTM2PDFCopyPaperOffsetValue,
				@"", iTM2PDFCopyResult,
				@"", iTM2PDFCopyBackground,
				@"cm", iTM2PDFCopyPaperOffsetUnit,
					nil];
}
TOGGLE(useAddEmpty, validateUseAddEmpty, iTM2PDFSelectUseAddEmpty);
TOGGLE(useBackground, validateUseBackground, iTM2PDFSelectUseBackground);
TOGGLE(useBackSpace, validateUseBackSpace, iTM2PDFSelectUseBackspace);
TOGGLE(markings, validateCutMarks, iTM2PDFSelectCutMarks);
TOGGLE(useTextWidth, validateUseTextWidth, iTM2PDFSelectUseTextWidth);
TOGGLE(verbose, validateVerbose, iTM2PDFSelectVerbose);
TOGGLE(silent, validateSilent, iTM2PDFSelectSilent);
TOGGLE(useResult, validateUseResult, iTM2PDFSelectUseResult);
TOGGLE(useTopSpace, validateUseTopSpace, iTM2PDFSelectUseTopSpace);
SEDIT(result, validateResult, iTM2PDFSelectResult);
SEDIT(addEmpty, validateAddEmpty, iTM2PDFSelectAddEmpty);
SEDIT(background, validateBackground, iTM2PDFSelectBackground);
SEDIT(paper, validatepaper, iTM2PDFSelectPaper);
FEDIT(backSpaceValue, validateBackSpaceValue, iTM2PDFSelectUseBackspace);
FEDIT(topSpaceValue, validateTopSpaceValue, iTM2PDFSelectTopSpaceValue);
FEDIT(textWidthValue, validateTextWidthValue, iTM2PDFSelectTextWidthValue);
UNIT(backSpaceUnitPopUp, validateBackSpaceUnitPopUp, iTM2PDFSelectBackspaceUnit);
UNIT(textWidthUnitPopUp, validateTextWidthUnitPopUp, iTM2PDFSelectTextWidthUnit);
UNIT(topSpaceUnitPopUp, validateTopSpaceUnitPopUp, iTM2PDFSelectTopSpaceUnit);
@end
