/*
//  iTM2TeXExecWrapperKit.m
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

#import "iTM2TeXExecWrapperKit.h"
#import <iTM2ConTeXtKit/iTM2ConTeXtKit.h>

#define TOGGLE(ACTION, VALIDATE, KEY)\
-(void)ACTION: (id) sender;{[self takeModelValue: [NSNumber numberWithBool: ![[self modelValueForKey: KEY] boolValue]] forKey: KEY];[self validateWindowContent];return;}\
-(BOOL)VALIDATE: (id) sender;{[sender setState: ([[self modelValueForKey: KEY] boolValue]? NSOnState: NSOffState)];return YES;}
#define FEDIT(ACTION, VALIDATE, KEY, USE_KEY)\
-(void)ACTION:  (id)  sender;{[self takeModelValue: [NSNumber numberWithFloat: [sender floatValue]] forKey: KEY];[self validateWindowContent];return;}\
-(BOOL)VALIDATE: (id) sender;{[sender setFloatValue: [[self modelValueForKey: KEY] floatValue]];\
return [[self modelValueForKey: USE_KEY] boolValue];}
//return ![self modelValueForKey: USE_KEY] || [[self modelValueForKey: USE_KEY] boolValue];}
#define IEDIT(ACTION, VALIDATE, KEY, USE_KEY)\
-(void)ACTION:  (id)  sender;{[self takeModelValue: [NSNumber numberWithInt: [sender intValue]] forKey: KEY];[self validateWindowContent];return;}\
-(BOOL)VALIDATE: (id) sender;{[sender setIntValue: [[self modelValueForKey: KEY] intValue]];\
return [[self modelValueForKey: USE_KEY] boolValue];}
#define SEDIT(ACTION, VALIDATE, KEY, USE_KEY)\
-(void)ACTION:  (id)  sender;{[self takeModelValue: [sender stringValue] forKey: KEY];[self validateWindowContent];return;}\
-(BOOL)VALIDATE: (id) sender;{[sender setStringValue: [self modelValueForKey: KEY]];\
return [[self modelValueForKey: USE_KEY] boolValue];}
#define UNIT(ACTION, VALIDATE, KEY)\
- (void) ACTION:  (id)  sender;\
{\
	switch([[sender selectedItem] tag])\
	{\
		case 0: [self takeModelValue: @"bp" forKey: KEY]; [self validateWindowContent]; return;\
		case 1: [self takeModelValue: @"pt" forKey: KEY]; [self validateWindowContent]; return;\
		case 2: [self takeModelValue: @"in" forKey: KEY]; [self validateWindowContent]; return;\
		default: [self takeModelValue: @"cm" forKey: KEY]; [self validateWindowContent]; return;\
	}\
    return;\
}\
- (BOOL) VALIDATE:  (id)  sender;\
{\
	NSString * unit = [self modelValueForKey: KEY];\
	if([unit isEqual: @"bp"])\
		[sender selectItemWithTag: 0];\
	else if([unit isEqual: @"pt"])\
		[sender selectItemWithTag: 1];\
	else if([unit isEqual: @"in"])\
		[sender selectItemWithTag: 2];\
	else\
		[sender selectItemWithTag: 3];\
	return YES;\
}

#if 0
               --once   run TeX only once (no TeXUtil either)
               --alone   bypass utilities (e.g. fmtutil for non-standard fmt)
                --fast   skip as much as possible
               --final   add a final run without skipping
                 --runs   maximum number of TeX runs
                           =n        : number of runs

            --arrange   process and arrange
          --noarrange   process but ignore arrange

           --automprun   MetaPost at runtime when needed
                --nomp   don't run MetaPost at all
             --nomprun   don't run MetaPost at runtime

            --mpformat   mem file
                           =name     : format file (memory dump)
               --mptex   run an MetaPost plus btex-etex cycle
              --mpxtex   generatet an MetaPostmpx file

               --batch   run in batch mode (don't pause)
           --nonstop   run in non stop mode (don't pause)

          --centerpage   center the page on the paper
               --color   enable color (when not yet enabled)
           --figures   typeset figure directory
                           =a        : room for corrections
                           =b        : just graphics
                           =c        : one (cropped) per page

               --help   show this or more, e.g. '--help interface'
          --interface   user interface
                           =cz       : Czech
                           =de       : German
                           =en       : English
                           =it       : Italian
                           =nl       : Dutch
                           =uk       : Brittish
            --language   main hyphenation language
                           =xx       : standard abbreviation
             --listing   produce a verbatim listing
 
              --mode   running mode
                           =list     : modes to set

              --module   typeset tex/pl/mp module

             --output   specials to use
                           =dvipdfm  : Mark Wicks' dvi to pdf converter
                           =dvipdfmx : Jin-Hwan Cho's extended dvipdfm
                           =dvips    : Thomas Rokicky's dvi to ps converter
                           =dvipsone : YandY's dvi to ps converter
                           =dviwindo : YandY's windows previewer
                           =pdftex   : Han The Than's pdf backend
                --pdf   produce PDF directly using pdf(e)tex

               --pages   pages to output
                           =even     : even pages
                           =odd      : odd pages
                           =x,y:z    : pages x and y to z
               --paper   paper input and output format
                           =a4a3     : A4 printed on A3
                           =a5a4     : A5 printed on A4
               --print   page imposition scheme
                           =down     : 2 rotated pages per sheet doubleside
                           =up       : 2 pages per sheet doublesided

               --input   input file (if used)
                           =name     : filename
             --result   resulting file
                           =name     : filename
             --suffix   resulting file suffix
                           =string   : suffix
               --path   document source path
                           =string   : path


        --screensaver   turn graphic file into a (pdf) full screen file

             --setfile   load environment (batch) file

                --make   build format files
             --format   fmt file
                           =name     : format file (memory dump)
              --passon   switches to pass to TeX (--src for MikTeX)
                 --tex   TeX binary
                          =name     : binary of executable
             --texroot   root of tex trees
                           =path     : tex root
             --textree   additional texmf tree to be used
                           =path     : subpath of tex root
             --texutil   force TeXUtil run

           --usemodule   load some modules first
                           =name     : list of modules
         --environment   load some environments first
                           =name     : list of environments

          --xmlfilter   apply XML filter
                           =name     : list of filters


              --result   resulting file
                           =name     : filename
             --verbose   shows some additional info
              --silent   minimize (status) messages

//the format

                --make   build format files
            --bodyfont   bodyfont to preload
              --format   TeX format
            --language   patterns to include
            --mpformat   MetaPost format
             --program   TeX program
            --response   response interface language
#endif

// supported
NSString * const iTM2TeXExecOnce = @"iTM2_TeXExec_once";
NSString * const iTM2TeXExecFast = @"iTM2_TeXExec_fast";
NSString * const iTM2TeXExecFinal = @"iTM2_TeXExec_final";
NSString * const iTM2TeXExecBatch = @"iTM2_TeXExec_batch";
NSString * const iTM2TeXExecNonStop = @"iTM2_TeXExec_nonstop";
NSString * const iTM2TeXExecUseMode = @"iTM2_TeXExec_USE_mode";
NSString * const iTM2TeXExecMode = @"iTM2_TeXExec_mode";
NSString * const iTM2TeXExecUseResult = @"iTM2_TeXExec_USE_result";
NSString * const iTM2TeXExecResult = @"iTM2_TeXExec_result";
NSString * const iTM2TeXExecUseXeTeX = @"iTM2_TeXExec_USE_XeTeX";
NSString * const iTM2TeXExecUseTXCPassOn = @"iTM2_TeXExec_USE_TXC_passon";
NSString * const iTM2TeXExecTXCPassOn = @"iTM2_TeXExec_TXC_passon";
NSString * const iTM2TeXExecUsePassOn = @"iTM2_TeXExec_USE_passon";
NSString * const iTM2TeXExecPassOn = @"iTM2_TeXExec_passon";
NSString * const iTM2TeXExecVerbose = @"iTM2_TeXExec_verbose";
NSString * const iTM2TeXExecSilent = @"iTM2_TeXExec_silent";
NSString * const iTM2TeXExecOutput = @"iTM2_TeXExec_output";
// unsupported in the GUI
NSString * const iTM2TeXExecAlone = @"iTM2_TeXExec_alone";
NSString * const iTM2TeXExecRuns = @"iTM2_TeXExec_runs";
NSString * const iTM2TeXExecArrange = @"iTM2_TeXExec_arrange";
NSString * const iTM2TeXExecAutoMPRun = @"iTM2_TeXExec_automprun";
NSString * const iTM2TeXExecNoMP = @"iTM2_TeXExec_nomp";
NSString * const iTM2TeXExecNoMPRun = @"iTM2_TeXExec_nomprun";
NSString * const iTM2TeXExecUseMPFormat = @"iTM2_TeXExec_USE_mpformat";
NSString * const iTM2TeXExecMPFormat = @"iTM2_TeXExec_mpformat";
NSString * const iTM2TeXExecMpTeX = @"iTM2_TeXExec_mptex";
NSString * const iTM2TeXExecMpxTeX = @"iTM2_TeXExec_mpxtex";
NSString * const iTM2TeXExecCenterPage = @"iTM2_TeXExec_centerpage";
NSString * const iTM2TeXExecColor = @"iTM2_TeXExec_color";
NSString * const iTM2TeXExecUseFigures = @"iTM2_TeXExec_USE_figures";
NSString * const iTM2TeXExecFigures = @"iTM2_TeXExec_figures";
NSString * const iTM2TeXExecUseInterface = @"iTM2_TeXExec_USE_interface";
NSString * const iTM2TeXExecInterface = @"iTM2_TeXExec_interface";
NSString * const iTM2TeXExecUseLanguage = @"iTM2_TeXExec_USE_language";
NSString * const iTM2TeXExecLanguage = @"iTM2_TeXExec_language";
NSString * const iTM2TeXExecListing = @"iTM2_TeXExec_listing";
NSString * const iTM2TeXExecModule = @"iTM2_TeXExec_module";
NSString * const iTM2TeXExecUseInput = @"iTM2_TeXExec_USE_input";
NSString * const iTM2TeXExecInput = @"iTM2_TeXExec_input";
NSString * const iTM2TeXExecUnknownOutput = @"iTM2_TeXExec_UNKKNOWN_output";
NSString * const iTM2TeXExecUsePages = @"iTM2_TeXExec_USE_pages";
NSString * const iTM2TeXExecPages = @"iTM2_TeXExec_pages";
NSString * const iTM2TeXExecPaper = @"iTM2_TeXExec_paper";
NSString * const iTM2TeXExecPrint = @"iTM2_TeXExec_print";
NSString * const iTM2TeXExecUseSuffix = @"iTM2_TeXExec_USE_suffix";
NSString * const iTM2TeXExecSuffix = @"iTM2_TeXExec_suffix";
NSString * const iTM2TeXExecUsePath = @"iTM2_TeXExec_USE_path";
NSString * const iTM2TeXExecPath = @"iTM2_TeXExec_path";
NSString * const iTM2TeXExecScreenSaver = @"iTM2_TeXExec_screensaver";
NSString * const iTM2TeXExecUseSetFile = @"iTM2_TeXExec_USE_setfile";
NSString * const iTM2TeXExecSetFile = @"iTM2_TeXExec_setfile";
NSString * const iTM2TeXExecMake = @"iTM2_TeXExec_make";
NSString * const iTM2TeXExecUseFormat = @"iTM2_TeXExec_USE_format";
NSString * const iTM2TeXExecFormat = @"iTM2_TeXExec_format";
NSString * const iTM2TeXExecTeX = @"iTM2_TeXExec_tex";
NSString * const iTM2TeXExecUseTeXTree = @"iTM2_TeXExec_USE_textree";
NSString * const iTM2TeXExecTeXTree = @"iTM2_TeXExec_textree";
NSString * const iTM2TeXExecUseTeXRoot = @"iTM2_TeXExec_USE_texroot";
NSString * const iTM2TeXExecTeXRoot = @"iTM2_TeXExec_texroot";
NSString * const iTM2TeXExecTeXUtil = @"iTM2_TeXExec_texutil";
NSString * const iTM2TeXExecUseUseModule = @"iTM2_TeXExec_USE_usemodule";
NSString * const iTM2TeXExecUseModule = @"iTM2_TeXExec_usemodule";
NSString * const iTM2TeXExecUseEnvironment = @"iTM2_TeXExec_USE_environment";
NSString * const iTM2TeXExecEnvironment = @"iTM2_TeXExec_environment";
NSString * const iTM2TeXExecUseXMLFilter = @"iTM2_TeXExec_USE_xmlfilter";
NSString * const iTM2TeXExecXMLFilter = @"iTM2_TeXExec_xmlfilter";

@implementation iTM2EngineTeXExec
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *) engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_texexec";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *) inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSArray arrayWithObjects: @"tex", @"xml", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *) defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool: NO], iTM2TeXExecOnce,
				[NSNumber numberWithBool: NO], iTM2TeXExecAlone,
				[NSNumber numberWithBool: NO], iTM2TeXExecFast,
				[NSNumber numberWithBool: NO], iTM2TeXExecFinal,
				[NSNumber numberWithInt: 0], iTM2TeXExecRuns,
				[NSNumber numberWithBool: NO], iTM2TeXExecArrange,
				[NSNumber numberWithBool: NO], iTM2TeXExecAutoMPRun,
				[NSNumber numberWithBool: NO], iTM2TeXExecNoMP,
				[NSNumber numberWithBool: NO], iTM2TeXExecNoMPRun,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseMPFormat,
				@"", iTM2TeXExecMPFormat,
				[NSNumber numberWithBool: NO], iTM2TeXExecMpTeX,
				[NSNumber numberWithBool: NO], iTM2TeXExecMpxTeX,
				[NSNumber numberWithBool: NO], iTM2TeXExecBatch,
				[NSNumber numberWithBool: NO], iTM2TeXExecNonStop,
				[NSNumber numberWithBool: NO], iTM2TeXExecCenterPage,
				[NSNumber numberWithBool: NO], iTM2TeXExecColor,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseFigures,
				@"a", iTM2TeXExecFigures,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseInterface,
				@"en", iTM2TeXExecInterface,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseLanguage,
				[NSNumber numberWithBool: NO], iTM2TeXExecLanguage,
				[NSNumber numberWithBool: NO], iTM2TeXExecListing,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseMode,
				@"", iTM2TeXExecMode,
				[NSNumber numberWithBool: NO], iTM2TeXExecModule,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseInput,
				@"", iTM2TeXExecInput,
				@"pdftex", iTM2TeXExecOutput,
				[NSNumber numberWithBool: NO], iTM2TeXExecUsePages,
				@"", iTM2TeXExecPages,
				@"", iTM2TeXExecPaper,
				@"", iTM2TeXExecPrint,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseInput,
				@"", iTM2TeXExecInput,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseResult,
				@"", iTM2TeXExecResult,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseSuffix,
				@"", iTM2TeXExecSuffix,
				[NSNumber numberWithBool: NO], iTM2TeXExecUsePath,
				@"", iTM2TeXExecPath,
				[NSNumber numberWithBool: NO], iTM2TeXExecScreenSaver,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseSetFile,
				@"", iTM2TeXExecSetFile,
				[NSNumber numberWithBool: NO], iTM2TeXExecMake,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseFormat,
				@"", iTM2TeXExecFormat,
				[NSNumber numberWithBool: NO], iTM2TeXExecUsePassOn,
				@"", iTM2TeXExecPassOn,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseTXCPassOn,
				@"", iTM2TeXExecTXCPassOn,
				@"", iTM2TeXExecTeX,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseTeXTree,
				@"", iTM2TeXExecTeXTree,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseTeXRoot,
				@"", iTM2TeXExecTeXRoot,
				[NSNumber numberWithBool: NO], iTM2TeXExecTeXUtil,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseUseModule,
				@"", iTM2TeXExecUseModule,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseEnvironment,
				@"", iTM2TeXExecEnvironment,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseXMLFilter,
				@"", iTM2TeXExecXMLFilter,
				[NSNumber numberWithBool: NO], iTM2TeXExecVerbose,
				[NSNumber numberWithBool: NO], iTM2TeXExecSilent,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseResult,
				@"", iTM2TeXExecResult,
				[NSNumber numberWithBool: NO], iTM2TeXExecUseXeTeX,
					nil];
}
TOGGLE(alone, validateAlone, iTM2TeXExecAlone);
IEDIT(runs, validateRuns, iTM2TeXExecRuns, @" ");
TOGGLE(arrange, validateArrange, iTM2TeXExecArrange);
TOGGLE(autoMPRun, validateAutoMPRun, iTM2TeXExecAutoMPRun);
TOGGLE(noMP, validateNoMP, iTM2TeXExecNoMP);
TOGGLE(noMPRun, validateNoMPRun, iTM2TeXExecNoMPRun);
TOGGLE(useMPFormat, validateUseMPFormat, iTM2TeXExecUseMPFormat);
SEDIT(MPFormat, validateMPFormat, iTM2TeXExecMPFormat, iTM2TeXExecUseMPFormat);
TOGGLE(MpTeX, validateMpTeX, iTM2TeXExecMpTeX);
TOGGLE(MpxTeX, validateMpxTeX, iTM2TeXExecMpxTeX);
TOGGLE(batch, validateBatch, iTM2TeXExecBatch);
TOGGLE(nonStop, validateNonStop, iTM2TeXExecNonStop);
TOGGLE(centerPage, validateCenterPage, iTM2TeXExecCenterPage);
TOGGLE(color, validateColor, iTM2TeXExecColor);
TOGGLE(useFigures, validateUseFigures, iTM2TeXExecUseFigures);
SEDIT(figures, validateFigures, iTM2TeXExecFigures, iTM2TeXExecUseFigures);
TOGGLE(useInterface, validateUseInterface, iTM2TeXExecUseInterface);
SEDIT(interface, validateInterface, iTM2TeXExecInterface, iTM2TeXExecUseInterface);
TOGGLE(useLanguage, validateUseLanguage, iTM2TeXExecUseLanguage);
SEDIT(language, validateLanguage, iTM2TeXExecLanguage, iTM2TeXExecUseLanguage);
TOGGLE(listing, validateListing, iTM2TeXExecListing);
TOGGLE(useInput, validateUseInput, iTM2TeXExecUseInput);
SEDIT(input, validateInput, iTM2TeXExecInput, iTM2TeXExecUseInput);
SEDIT(output, validateOutput, iTM2TeXExecOutput, @" ");
TOGGLE(usePages, validateUsePages, iTM2TeXExecUsePages);
SEDIT(pages, validatePages, iTM2TeXExecPages, iTM2TeXExecUsePages);
SEDIT(paper, validatePaper, iTM2TeXExecPaper, @" ");
SEDIT(print, validatePrint, iTM2TeXExecPrint, @" ");
TOGGLE(useSuffix, validateUseSuffix, iTM2TeXExecUseSuffix);
SEDIT(suffix, validateSuffix, iTM2TeXExecSuffix, iTM2TeXExecUseSuffix);
TOGGLE(usePath, validateUsePath, iTM2TeXExecUsePath);
SEDIT(path, validatePath, iTM2TeXExecPath, iTM2TeXExecUsePath);
TOGGLE(screenSaver, validateScreenSaver, iTM2TeXExecScreenSaver);
TOGGLE(useSetFile, validateUseSetFile, iTM2TeXExecUseSetFile);
SEDIT(setFile, validateSetFile, iTM2TeXExecSetFile, iTM2TeXExecUseSetFile);
TOGGLE(make, validateMake, iTM2TeXExecMake);
TOGGLE(useFormat, validateUseFormat, iTM2TeXExecUseFormat);
SEDIT(format, validateFormat, iTM2TeXExecFormat, iTM2TeXExecUseFormat);
SEDIT(TeX, validateTeX, iTM2TeXExecTeX, @" ");
TOGGLE(useTeXTree, validateUseTeXTree, iTM2TeXExecUseTeXTree);
SEDIT(TeXTree, validateTeXTree, iTM2TeXExecTeXTree, iTM2TeXExecUseTeXTree);
TOGGLE(useTeXRoot, validateUseTeXRoot, iTM2TeXExecUseTeXRoot);
SEDIT(TeXRoot, validateTeXRoot, iTM2TeXExecTeXRoot, iTM2TeXExecUseTeXRoot);
TOGGLE(TeXUtil, validateTeXUtil, iTM2TeXExecTeXUtil);
TOGGLE(useUseModule, validateUseUseModule, iTM2TeXExecUseUseModule);
SEDIT(useModule, validateUseModule, iTM2TeXExecUseModule, iTM2TeXExecUseUseModule);
TOGGLE(useEnvironment, validateUseEnvironment, iTM2TeXExecUseEnvironment);
SEDIT(environment, validateEnvironment, iTM2TeXExecEnvironment, iTM2TeXExecUseEnvironment);
TOGGLE(useXMLFilter, validateUseXMLFilter, iTM2TeXExecUseXMLFilter);
SEDIT(XMLFilter, validateXMLFilter, iTM2TeXExecXMLFilter, iTM2TeXExecUseXMLFilter);
#pragma mark =-=-=-=-=-  SUPPORTED
TOGGLE(once, validateOnce, iTM2TeXExecOnce);
TOGGLE(fast, validateFast, iTM2TeXExecFast);
TOGGLE(final, validateFinal, iTM2TeXExecFinal);
TOGGLE(verbose, validateVerbose, iTM2TeXExecVerbose);
TOGGLE(silent, validateSilent, iTM2TeXExecSilent);
TOGGLE(usePassOn, validateUsePassOn, iTM2TeXExecUsePassOn);
SEDIT(passOn, validatePassOn, iTM2TeXExecPassOn, iTM2TeXExecUsePassOn);
TOGGLE(useTXCPassOn, validateUseTXCPassOn, iTM2TeXExecUseTXCPassOn);
SEDIT(TXCPassOn, validateTXCPassOn, iTM2TeXExecTXCPassOn, iTM2TeXExecUseTXCPassOn);
TOGGLE(useResult, validateUseResult, iTM2TeXExecUseResult);
//SEDIT(result, validateResult, iTM2TeXExecResult, iTM2TeXExecUseResult);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  result:
-(void) result: (id)  sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeModelValue: [sender stringValue] forKey: iTM2TeXExecResult];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateResult:
-(BOOL) validateResult: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * extension = @"pdf";
	iTM2TeXProjectDocument * myTPD = [self document];
	NSString * FN = [[myTPD relativeFileNameForKey: [myTPD masterFileKey]] stringByDeletingPathExtension];
	NSString * mode = [self modelValueForKey: iTM2TeXExecMode];
	if([[self modelValueForKey: iTM2TeXExecUseMode] boolValue] && [mode length])
	{
		// if the result has a length, it is a custom output and I should use it
		// if not, 
		
		[[sender formatter] setStringForNilObjectValue:
			[[NSString stringWithFormat: @"%@(%@)", FN, mode] stringByAppendingPathExtension: extension]];
	}
	else
	{
		// this is the default output
		[[sender formatter] setStringForNilObjectValue:
			[FN stringByAppendingPathExtension: extension]];
	}
	[sender setStringValue: ([[self modelValueForKey: iTM2TeXExecUseResult] boolValue]? [self modelValueForKey: iTM2TeXExecResult]: @"")];
//iTM2_END;
	return [[self modelValueForKey: iTM2TeXExecUseResult] boolValue];
}
TOGGLE(useMode, validateUseMode, iTM2TeXExecUseMode);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mode:
-(void) mode: (id)  sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = [sender stringValue];
	NSMutableString * MS = [[string mutableCopy] autorelease];
	[MS replaceOccurrencesOfString: @" " withString: @"," options: 0 range: NSMakeRange(0, [MS length])];
	[MS replaceOccurrencesOfString: @",," withString: @"," options: 0 range: NSMakeRange(0, [MS length])];
	string = [[MS copy] autorelease];
	[self takeModelValue: string forKey: iTM2TeXExecMode];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMode:
-(BOOL) validateMode: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setStringValue: [self modelValueForKey: iTM2TeXExecMode]];
//iTM2_END;
	return ![self modelValueForKey: iTM2TeXExecUseMode] || [[self modelValueForKey: iTM2TeXExecUseMode] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent:
- (BOOL) validateWindowContent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self implementation] metaValueForKey: @"iTM2 unknown output"])
	{
		[[self implementation] takeMetaValue: @"" forKey: @"iTM2 unknown output"];
		NSString * output = [self modelValueForKey: iTM2TeXExecOutput];
		if(![[NSArray arrayWithObjects: @"", @"dvips", @"pdftex", nil] containsObject: output])
		{
			[self takeModelValue: output forKey: iTM2TeXExecUnknownOutput];
		}
		if([[self modelValueForKey: iTM2TeXExecBatch] boolValue])
		{
			[self takeModelValue: [NSNumber numberWithBool: NO] forKey: iTM2TeXExecNonStop];
		}
	}
//iTM2_END;
	return [super validateWindowContent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useXeTeX:
-(void)useXeTeX: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeModelValue: [NSNumber numberWithBool: ![[self modelValueForKey: iTM2TeXExecUseXeTeX] boolValue]] forKey: iTM2TeXExecUseXeTeX];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUseXeTeX:
-(BOOL)validateUseXeTeX: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self modelValueForKey: iTM2TeXExecOutput] isEqual: [self modelValueForKey: iTM2TeXExecUnknownOutput]])
	{
		[sender setState: NSMixedState];
//iTM2_END;
		return NO;
	}
	else
	{
		[sender setState: ([[self modelValueForKey: iTM2TeXExecUseXeTeX] boolValue]? NSOnState: NSOffState)];
//iTM2_END;
		return YES;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchInteraction:
- (IBAction) switchInteraction: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 29 08:07:47 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    switch([[sender selectedCell] tag])
    {
        case 0:
			[self takeModelValue: [NSNumber numberWithBool: YES] forKey: iTM2TeXExecBatch];
			[self takeModelValue: [NSNumber numberWithBool: NO] forKey: iTM2TeXExecNonStop];
		break;// batchmode
        case 1:
			[self takeModelValue: [NSNumber numberWithBool: NO] forKey: iTM2TeXExecBatch];
			[self takeModelValue: [NSNumber numberWithBool: YES] forKey: iTM2TeXExecNonStop];
		break;// nonstopmode
        default:
			[self takeModelValue: [NSNumber numberWithBool: NO] forKey: iTM2TeXExecBatch];
			[self takeModelValue: [NSNumber numberWithBool: NO] forKey: iTM2TeXExecNonStop];
		break;// errorstopmode
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL) validateSwitchInteraction: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self modelValueForKey: iTM2TeXExecBatch] boolValue])
	{
		// @"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode"
		[sender selectCellWithTag: 0];
	}
	else if([[self modelValueForKey: iTM2TeXExecNonStop] boolValue])
	{
		// @"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode"
		[sender selectCellWithTag: 1];
	}
	else
	{
		// @"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode"
		[sender selectCellWithTag: 3];
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputFormat:
- (IBAction) outputFormat: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self modelValueForKey: iTM2TeXExecUseXeTeX] boolValue])
	{
		switch([[sender selectedItem] tag])
		{
			case 0:// dvi
			case 1:// xdv
				[self takeModelValue: @"" forKey: iTM2TeXExecOutput];	
				break;
			default:
				[self takeModelValue: @"pdftex" forKey: iTM2TeXExecOutput];	
				break;
		}
	}
	else
	{
		switch([[sender selectedItem] tag])
		{
			case 0:// dvi
			case 1:// xdv
				[self takeModelValue: @"" forKey: iTM2TeXExecOutput];	
				break;
			case 2:// ps
				[self takeModelValue: @"dvips" forKey: iTM2TeXExecOutput];	
				break;
			case -1:// unknown
				break;
			case 3:// pdf
			default:
				[self takeModelValue: @"pdftex" forKey: iTM2TeXExecOutput];	
				break;
		}
	}
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOutputFormat:
- (BOOL) validateOutputFormat: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL useXeTeX = [[self modelValueForKey: iTM2TeXExecUseXeTeX] boolValue];
	if([sender isKindOfClass: [NSPopUpButton class]])
	{
		NSString * output = [self modelValueForKey: iTM2TeXExecOutput];
		if([output isEqual: @""])
		{
			[sender selectItemWithTag: (useXeTeX? 1: 0)];
		}
		else if([output isEqual: @"dvips"])
		{
			[sender selectItemWithTag: 2];
		}
		else if([output isEqual: @"pdftex"])
		{
			[sender selectItemWithTag: 3];
		}
		else
		{
			[self takeModelValue: output forKey: iTM2TeXExecUnknownOutput];
			id <NSMenuItem> MI = [sender itemAtIndex: [sender indexOfItemWithTag: -1]];
			if(!MI)
			{
				[sender addItemWithTitle: output];
				MI = [sender lastItem];
				[MI setTag: -1];
			}
			else
				[MI setTitle: output];
			[sender selectItemWithTag: -1];
		}
		NSString * unknownOutput = [self modelValueForKey: iTM2TeXExecUnknownOutput];
		if([unknownOutput length])
		{
			id <NSMenuItem> MI = [sender itemAtIndex: [sender indexOfItemWithTag: -1]];
			if(!MI)
			{
				[sender addItemWithTitle: unknownOutput];
				MI = [sender lastItem];
				[MI setTag: -1];
			}
			else
				[MI setTitle: unknownOutput];
		}
		return YES;
	}
	switch([sender tag])
	{
		case 0: return !useXeTeX;
		case 1: return useXeTeX;
		case 2: return !useXeTeX;
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtPragmaADE:
- (IBAction) ConTeXtPragmaADE: (id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SWS openURL: [iTM2ConTeXtInspector ConTeXtPragmaADEURL]];
//iTM2_END;
	return;
}
@end

@implementation iTM2MainInstaller(dvipdfm)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXExecCompleteInstallation
+ (void) iTM2TeXExecCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2EngineTeXExec installBinary];
//iTM2_END;
    return;
}
@end

@implementation iTM2ConTeXtResultFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedStringForObjectValue:withDefaultAttributes:
- (NSAttributedString *) attributedStringForObjectValue: (id) obj withDefaultAttributes: (NSDictionary *) attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self stringForObjectValue: obj] length])
		return [super attributedStringForObjectValue: obj withDefaultAttributes: attrs];
	return [self attributedStringForNilObjectValueWithDefaultAttributes: attrs];
}
@end

