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
- (void)ACTION:(NSMenuItem *)sender;{[self setInfo4TM3:[NSNumber numberWithBool: ![[self editInfo4iTM3ForKeyPaths:KEY,nil] boolValue]] forKeyPaths:KEY,nil];self.validateWindowContent4iTM3;return;}\
- (BOOL)VALIDATE:(NSMenuItem *)sender;{sender.state = ([[self editInfo4iTM3ForKeyPaths:KEY,nil] boolValue]? NSOnState:NSOffState);return YES;}
#define FEDIT(ACTION, VALIDATE, KEY)\
- (void)ACTION:(NSControl *)sender;{[self setInfo4TM3:[NSNumber numberWithFloat:sender.floatValue] forKeyPaths:KEY,nil];self.validateWindowContent4iTM3;return;}\
- (BOOL)VALIDATE:(NSControl *)sender;{[sender setFloatValue:[[self editInfo4iTM3ForKeyPaths:KEY,nil] floatValue]];return YES;}
#define SEDIT(ACTION, VALIDATE, KEY)\
- (void)ACTION:(NSControl *)sender;{[self setInfo4TM3:[sender stringValue] forKeyPaths:KEY,nil];self.validateWindowContent4iTM3;return;}\
- (BOOL)VALIDATE:(NSControl *)sender;{[sender setStringValue:[self editInfo4iTM3ForKeyPaths:KEY,nil]];return YES;}
#define UNIT(ACTION, VALIDATE, KEY)\
- (void)ACTION:(NSPopUpButton *)sender;\
{\
	switch (sender.selectedItem.tag) {\
		case 0: [self setInfo4TM3:@"bp" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
		case 1: [self setInfo4TM3:@"pt" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
		case 2: [self setInfo4TM3:@"in" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
		default: [self setInfo4TM3:@"cm" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
	}\
    return;\
}\
- (BOOL)VALIDATE:(NSPopUpButton *)sender;\
{\
	NSString * unit = [self editInfo4iTM3ForKeyPaths:KEY,nil];\
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

NSString * const iTM2PDFArrangeUseAddEmpty = @"PDFArrange_USE_addempty4iTM3";
NSString * const iTM2PDFArrangeAddEmpty = @"PDFArrange_addempty4iTM3";
NSString * const iTM2PDFArrangeUseBackground = @"PDFArrange_USE_background4iTM3";
NSString * const iTM2PDFArrangeBackground = @"PDFArrange_background4iTM3";
NSString * const iTM2PDFArrangeUseBackSpace = @"PDFArrange_USE_backSpace4iTM3";
NSString * const iTM2PDFArrangeBackSpaceValue = @"PDFArrange_backSpace_VALUE4iTM3";
NSString * const iTM2PDFArrangeBackSpaceUnit = @"PDFArrange_backSpace_UNIT4iTM3";
NSString * const iTM2PDFArrangeCutMarks = @"PDFArrange_markings4iTM3";
NSString * const iTM2PDFArrangeSingleSided = @"PDFArrange_noduplex4iTM3";
NSString * const iTM2PDFArrangePaper = @"PDFArrange_paper4iTM3";
NSString * const iTM2PDFArrangeUsePaperOffset = @"PDFArrange_USE_paperoffset4iTM3";
NSString * const iTM2PDFArrangePaperOffsetValue = @"PDFArrange_paperoffset_VALUE4iTM3";
NSString * const iTM2PDFArrangePaperOffsetUnit = @"PDFArrange_paperoffset_UNIT4iTM3";
NSString * const iTM2PDFArrangeUsePages = @"PDFArrange_USE_selection4iTM3";
NSString * const iTM2PDFArrangePages = @"PDFArrange_selection4iTM3";
NSString * const iTM2PDFArrangeUseTextWidth = @"PDFArrange_USE_textwidth4iTM3";
NSString * const iTM2PDFArrangeTextWidthValue = @"PDFArrange_textwidth_VALUE4iTM3";
NSString * const iTM2PDFArrangeTextWidthUnit = @"PDFArrange_textwidth_UNIT4iTM3";
NSString * const iTM2PDFArrangeUseTopSpace = @"PDFArrange_USE_topSpace4iTM3";
NSString * const iTM2PDFArrangeTopSpaceValue = @"PDFArrange_topSpace_VALUE4iTM3";
NSString * const iTM2PDFArrangeTopSpaceUnit = @"PDFArrange_topSpace_UNIT4iTM3";
NSString * const iTM2PDFArrangeDirectory = @"PDFArrange_DIRECTORY4iTM3";
NSString * const iTM2PDFArrangeInput = @"PDFArrange_INPUT4iTM3";
NSString * const iTM2PDFArrangeVerbose = @"PDFArrange_verbose4iTM3";
NSString * const iTM2PDFArrangeSilent = @"PDFArrange_silent4iTM3";
NSString * const iTM2PDFArrangeResult = @"PDFArrange_result4iTM3";

@implementation iTM2PDFArrangeInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @".Engine_pdfarrange4iTM3";
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
    return [NSArray arrayWithObject:@"pdf"];
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

NSString * const iTM2PDFCombineCombination = @"PDFCombine_combination4iTM3";
NSString * const iTM2PDFCombineNoBanner = @"PDFCombine_nobanner4iTM3";
NSString * const iTM2PDFCombinePaper = @"PDFCombine_paper4iTM3";
NSString * const iTM2PDFCombineUsePaperOffset = @"PDFCombine_USE_paperoffset4iTM3";
NSString * const iTM2PDFCombinePaperOffsetValue = @"PDFCombine_paperoffset_VALUE4iTM3";
NSString * const iTM2PDFCombinePaperOffsetUnit = @"PDFCombine_paperoffset_UNIT4iTM3";
NSString * const iTM2PDFCombineUseResult = @"PDFCombine_USE_result4iTM3";
NSString * const iTM2PDFCombineResult = @"PDFCombine_result4iTM3";
NSString * const iTM2PDFCombineVerbose = @"PDFCombine_verbose4iTM3";
NSString * const iTM2PDFCombineSilent = @"PDFCombine_silent4iTM3";

@implementation iTM2PDFCombineInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @".Engine_pdfcombine4iTM3";
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
    return [NSArray arrayWithObject:@"pdf"];
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

NSString * const iTM2PDFCopyUseBackground = @"PDFCopy_USE_background4iTM3";
NSString * const iTM2PDFCopyBackground = @"PDFCopy_background4iTM3";
NSString * const iTM2PDFCopyCutMarks = @"PDFCopy_markings4iTM3";
NSString * const iTM2PDFCopyUsePaperOffset = @"PDFCopy_USE_paperoffset4iTM3";
NSString * const iTM2PDFCopyPaperOffsetValue = @"PDFCopy_paperoffset_VALUE4iTM3";
NSString * const iTM2PDFCopyPaperOffsetUnit = @"PDFCopy_paperoffset_UNIT4iTM3";
NSString * const iTM2PDFCopyScale = @"PDFCopy_scale4iTM3";
NSString * const iTM2PDFCopyUseResult = @"PDFCopy_USE_result4iTM3";
NSString * const iTM2PDFCopyResult = @"PDFCopy_result4iTM3";
NSString * const iTM2PDFCopyVerbose = @"PDFCopy_verbose4iTM3";
NSString * const iTM2PDFCopySilent = @"PDFCopy_silent4iTM3";

@implementation iTM2PDFCopyInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @".Engine_pdfcopy4iTM3";
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
    return [NSArray arrayWithObject:@"pdf"];
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

NSString * const iTM2PDFSelectUseAddEmpty = @"PDFSelect_USE_addempty4iTM3";
NSString * const iTM2PDFSelectAddEmpty = @"PDFSelect_addempty4iTM3";
NSString * const iTM2PDFSelectUseBackground = @"PDFSelect_USE_background4iTM3";
NSString * const iTM2PDFSelectBackground = @"PDFSelect_background4iTM3";
NSString * const iTM2PDFSelectUseBackspace = @"PDFSelect_USE_backspace4iTM3";
NSString * const iTM2PDFSelectBackspaceValue = @"PDFSelect_backspace_VALUE4iTM3";
NSString * const iTM2PDFSelectBackspaceUnit = @"PDFSelect_backspace_UNIT4iTM3";
NSString * const iTM2PDFSelectCutMarks = @"PDFSelect_markings4iTM3";
NSString * const iTM2PDFSelectPaper = @"PDFSelect_paper4iTM3";
NSString * const iTM2PDFSelectUseTextWidth = @"PDFSelect_USE_textwidth4iTM3";
NSString * const iTM2PDFSelectTextWidthValue = @"PDFSelect_textwidth_VALUE4iTM3";
NSString * const iTM2PDFSelectTextWidthUnit = @"PDFSelect_textwidth_UNIT4iTM3";
NSString * const iTM2PDFSelectUseTopSpace = @"PDFSelect_USE_topSpace4iTM3";
NSString * const iTM2PDFSelectTopSpaceValue = @"PDFSelect_topSpace_VALUE4iTM3";
NSString * const iTM2PDFSelectTopSpaceUnit = @"PDFSelect_topSpace_UNIT4iTM3";
NSString * const iTM2PDFSelectUseResult = @"PDFSelect_USE_result4iTM3";
NSString * const iTM2PDFSelectResult = @"PDFSelect_result4iTM3";
NSString * const iTM2PDFSelectVerbose = @"PDFSelect_verbose4iTM3";
NSString * const iTM2PDFSelectSilent = @"PDFSelect_silent4iTM3";

@implementation iTM2PDFSelectInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @".Engine_pdfselect4iTM3";
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
    return [NSArray arrayWithObject:@"pdf"];
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
