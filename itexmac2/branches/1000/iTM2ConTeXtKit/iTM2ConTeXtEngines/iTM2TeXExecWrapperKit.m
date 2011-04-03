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
- (void)ACTION:(NSMenuItem *)sender;{[self setInfo4TM3:[NSNumber numberWithBool: ![[self editInfo4iTM3ForKeyPaths:KEY,nil] boolValue]] forKeyPaths:KEY,nil];self.validateWindowContent4iTM3;return;}\
- (BOOL)VALIDATE:(NSMenuItem *)sender;{sender.state = ([[self editInfo4iTM3ForKeyPaths:KEY,nil] boolValue]? NSOnState:NSOffState);return YES;}
#define FEDIT(ACTION, VALIDATE, KEY, USE_KEY)\
- (void)ACTION:(NSControl *)sender;{[self setInfo4TM3:[NSNumber numberWithFloat:sender.floatValue] forKeyPaths:KEY,nil];self.validateWindowContent4iTM3;return;}\
- (BOOL)VALIDATE:(NSControl *)sender;{[sender setFloatValue:[[self editInfo4iTM3ForKeyPaths:KEY,nil] floatValue]];\
return [[self editInfo4iTM3ForKeyPaths:USE_KEY,nil] boolValue];}
//return ![self editInfo4iTM3ForKeyPaths:USE_KEY,nil] || [[self editInfo4iTM3ForKeyPaths:USE_KEY,nil] boolValue];}
#define IEDIT(ACTION, VALIDATE, KEY, USE_KEY)\
- (void)ACTION:(NSControl *)sender;{[self setInfo4TM3:[NSNumber numberWithInteger:[sender integerValue]] forKeyPaths:KEY,nil];self.validateWindowContent4iTM3;return;}\
- (BOOL)VALIDATE:(NSControl *)sender;{[sender setIntegerValue:[[self editInfo4iTM3ForKeyPaths:KEY,nil] integerValue]];\
return [[self editInfo4iTM3ForKeyPaths:USE_KEY,nil] boolValue];}
#define SEDIT(ACTION, VALIDATE, KEY, USE_KEY)\
- (void)ACTION:(NSControl *)sender;{[self setInfo4TM3:[sender stringValue] forKeyPaths:KEY,nil];self.validateWindowContent4iTM3;return;}\
- (BOOL)VALIDATE:(NSControl *)sender;{[sender setStringValue:[self editInfo4iTM3ForKeyPaths:KEY,nil]];\
return [[self editInfo4iTM3ForKeyPaths:USE_KEY,nil] boolValue];}
#define UNIT(ACTION, VALIDATE, KEY)\
- (void)ACTION:(NSControl *)sender;\
{\
	switch([[sender selectedItem] tag])\
	{\
		case 0: [self setInfo4TM3:@"bp" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
		case 1: [self setInfo4TM3:@"pt" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
		case 2: [self setInfo4TM3:@"in" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
		default: [self setInfo4TM3:@"cm" forKeyPaths:KEY,nil]; self.validateWindowContent4iTM3; return;\
	}\
    return;\
}\
- (BOOL)VALIDATE:(NSControl *)sender;\
{\
	NSString * unit = [self editInfo4iTM3ForKeyPaths:KEY,nil];\
	if([unit isEqual:@"bp"])\
		[sender selectItemWithTag:ZER0];\
	else if([unit isEqual:@"pt"])\
		[sender selectItemWithTag:1];\
	else if([unit isEqual:@"in"])\
		[sender selectItemWithTag:2];\
	else\
		[sender selectItemWithTag:3];\
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
NSString * const iTM2TeXExecOnce = @"TeXExec_once4iTM3";
NSString * const iTM2TeXExecFast = @"TeXExec_fast4iTM3";
NSString * const iTM2TeXExecFinal = @"TeXExec_final4iTM3";
NSString * const iTM2TeXExecBatch = @"TeXExec_batch4iTM3";
NSString * const iTM2TeXExecNonStop = @"TeXExec_nonstop4iTM3";
NSString * const iTM2TeXExecUseMode = @"TeXExec_USE_mode4iTM3";
NSString * const iTM2TeXExecMode = @"TeXExec_mode4iTM3";
NSString * const iTM2TeXExecUseResult = @"TeXExec_USE_result4iTM3";
NSString * const iTM2TeXExecResult = @"TeXExec_result4iTM3";
NSString * const iTM2TeXExecUseXeTeX = @"TeXExec_USE_XeTeX4iTM3";
NSString * const iTM2TeXExecUseTXCPassOn = @"TeXExec_USE_TXC_passon4iTM3";
NSString * const iTM2TeXExecTXCPassOn = @"TeXExec_TXC_passon4iTM3";
NSString * const iTM2TeXExecUsePassOn = @"TeXExec_USE_passon4iTM3";
NSString * const iTM2TeXExecPassOn = @"TeXExec_passon4iTM3";
NSString * const iTM2TeXExecVerbose = @"TeXExec_verbose4iTM3";
NSString * const iTM2TeXExecSilent = @"TeXExec_silent4iTM3";
NSString * const iTM2TeXExecOutput = @"TeXExec_output4iTM3";
// unsupported in the GUI
NSString * const iTM2TeXExecAlone = @"TeXExec_alone4iTM3";
NSString * const iTM2TeXExecRuns = @"TeXExec_runs4iTM3";
NSString * const iTM2TeXExecArrange = @"TeXExec_arrange4iTM3";
NSString * const iTM2TeXExecAutoMPRun = @"TeXExec_automprun4iTM3";
NSString * const iTM2TeXExecNoMP = @"TeXExec_nomp4iTM3";
NSString * const iTM2TeXExecNoMPRun = @"TeXExec_nomprun4iTM3";
NSString * const iTM2TeXExecUseMPFormat = @"TeXExec_USE_mpformat4iTM3";
NSString * const iTM2TeXExecMPFormat = @"TeXExec_mpformat4iTM3";
NSString * const iTM2TeXExecMpTeX = @"TeXExec_mptex4iTM3";
NSString * const iTM2TeXExecMpxTeX = @"TeXExec_mpxtex4iTM3";
NSString * const iTM2TeXExecCenterPage = @"TeXExec_centerpage4iTM3";
NSString * const iTM2TeXExecColor = @"TeXExec_color4iTM3";
NSString * const iTM2TeXExecUseFigures = @"TeXExec_USE_figures4iTM3";
NSString * const iTM2TeXExecFigures = @"TeXExec_figures4iTM3";
NSString * const iTM2TeXExecUseInterface = @"TeXExec_USE_interface4iTM3";
NSString * const iTM2TeXExecInterface = @"TeXExec_interface4iTM3";
NSString * const iTM2TeXExecUseLanguage = @"TeXExec_USE_language4iTM3";
NSString * const iTM2TeXExecLanguage = @"TeXExec_language4iTM3";
NSString * const iTM2TeXExecListing = @"TeXExec_listing4iTM3";
NSString * const iTM2TeXExecModule = @"TeXExec_module4iTM3";
NSString * const iTM2TeXExecUseInput = @"TeXExec_USE_input4iTM3";
NSString * const iTM2TeXExecInput = @"TeXExec_input4iTM3";
NSString * const iTM2TeXExecUnknownOutput = @"TeXExec_UNKKNOWN_output4iTM3";
NSString * const iTM2TeXExecUsePages = @"TeXExec_USE_pages4iTM3";
NSString * const iTM2TeXExecPages = @"TeXExec_pages4iTM3";
NSString * const iTM2TeXExecPaper = @"TeXExec_paper4iTM3";
NSString * const iTM2TeXExecPrint = @"TeXExec_print4iTM3";
NSString * const iTM2TeXExecUseSuffix = @"TeXExec_USE_suffix4iTM3";
NSString * const iTM2TeXExecSuffix = @"TeXExec_suffix4iTM3";
NSString * const iTM2TeXExecUsePath = @"TeXExec_USE_path4iTM3";
NSString * const iTM2TeXExecPath = @"TeXExec_path4iTM3";
NSString * const iTM2TeXExecScreenSaver = @"TeXExec_screensaver4iTM3";
NSString * const iTM2TeXExecUseSetFile = @"TeXExec_USE_setfile4iTM3";
NSString * const iTM2TeXExecSetFile = @"TeXExec_setfile4iTM3";
NSString * const iTM2TeXExecMake = @"TeXExec_make4iTM3";
NSString * const iTM2TeXExecUseFormat = @"TeXExec_USE_format4iTM3";
NSString * const iTM2TeXExecFormat = @"TeXExec_format4iTM3";
NSString * const iTM2TeXExecTeX = @"TeXExec_tex4iTM3";
NSString * const iTM2TeXExecUseTeXTree = @"TeXExec_USE_textree4iTM3";
NSString * const iTM2TeXExecTeXTree = @"TeXExec_textree4iTM3";
NSString * const iTM2TeXExecUseTeXRoot = @"TeXExec_USE_texroot4iTM3";
NSString * const iTM2TeXExecTeXRoot = @"TeXExec_texroot4iTM3";
NSString * const iTM2TeXExecTeXUtil = @"TeXExec_texutil4iTM3";
NSString * const iTM2TeXExecUseUseModule = @"TeXExec_USE_usemodule4iTM3";
NSString * const iTM2TeXExecUseModule = @"TeXExec_usemodule4iTM3";
NSString * const iTM2TeXExecUseEnvironment = @"TeXExec_USE_environment4iTM3";
NSString * const iTM2TeXExecEnvironment = @"TeXExec_environment4iTM3";
NSString * const iTM2TeXExecUseXMLFilter = @"TeXExec_USE_xmlfilter4iTM3";
NSString * const iTM2TeXExecXMLFilter = @"TeXExec_xmlfilter4iTM3";

@implementation iTM2EngineTeXExec
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:54:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_texexec4iTM3";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:54:52 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSArray arrayWithObjects:@"tex", @"xml", nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:54:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:NO], iTM2TeXExecOnce,
				[NSNumber numberWithBool:NO], iTM2TeXExecAlone,
				[NSNumber numberWithBool:NO], iTM2TeXExecFast,
				[NSNumber numberWithBool:NO], iTM2TeXExecFinal,
				[NSNumber numberWithInteger:ZER0], iTM2TeXExecRuns,
				[NSNumber numberWithBool:NO], iTM2TeXExecArrange,
				[NSNumber numberWithBool:NO], iTM2TeXExecAutoMPRun,
				[NSNumber numberWithBool:NO], iTM2TeXExecNoMP,
				[NSNumber numberWithBool:NO], iTM2TeXExecNoMPRun,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseMPFormat,
				@"", iTM2TeXExecMPFormat,
				[NSNumber numberWithBool:NO], iTM2TeXExecMpTeX,
				[NSNumber numberWithBool:NO], iTM2TeXExecMpxTeX,
				[NSNumber numberWithBool:NO], iTM2TeXExecBatch,
				[NSNumber numberWithBool:NO], iTM2TeXExecNonStop,
				[NSNumber numberWithBool:NO], iTM2TeXExecCenterPage,
				[NSNumber numberWithBool:NO], iTM2TeXExecColor,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseFigures,
				@"a", iTM2TeXExecFigures,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseInterface,
				@"en", iTM2TeXExecInterface,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseLanguage,
				[NSNumber numberWithBool:NO], iTM2TeXExecLanguage,
				[NSNumber numberWithBool:NO], iTM2TeXExecListing,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseMode,
				@"", iTM2TeXExecMode,
				[NSNumber numberWithBool:NO], iTM2TeXExecModule,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseInput,
				@"", iTM2TeXExecInput,
				@"pdftex", iTM2TeXExecOutput,
				[NSNumber numberWithBool:NO], iTM2TeXExecUsePages,
				@"", iTM2TeXExecPages,
				@"", iTM2TeXExecPaper,
				@"", iTM2TeXExecPrint,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseInput,
				@"", iTM2TeXExecInput,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseResult,
				@"", iTM2TeXExecResult,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseSuffix,
				@"", iTM2TeXExecSuffix,
				[NSNumber numberWithBool:NO], iTM2TeXExecUsePath,
				@"", iTM2TeXExecPath,
				[NSNumber numberWithBool:NO], iTM2TeXExecScreenSaver,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseSetFile,
				@"", iTM2TeXExecSetFile,
				[NSNumber numberWithBool:NO], iTM2TeXExecMake,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseFormat,
				@"", iTM2TeXExecFormat,
				[NSNumber numberWithBool:NO], iTM2TeXExecUsePassOn,
				@"", iTM2TeXExecPassOn,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseTXCPassOn,
				@"", iTM2TeXExecTXCPassOn,
				@"", iTM2TeXExecTeX,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseTeXTree,
				@"", iTM2TeXExecTeXTree,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseTeXRoot,
				@"", iTM2TeXExecTeXRoot,
				[NSNumber numberWithBool:NO], iTM2TeXExecTeXUtil,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseUseModule,
				@"", iTM2TeXExecUseModule,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseEnvironment,
				@"", iTM2TeXExecEnvironment,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseXMLFilter,
				@"", iTM2TeXExecXMLFilter,
				[NSNumber numberWithBool:NO], iTM2TeXExecVerbose,
				[NSNumber numberWithBool:NO], iTM2TeXExecSilent,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseResult,
				@"", iTM2TeXExecResult,
				[NSNumber numberWithBool:NO], iTM2TeXExecUseXeTeX,
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
- (void)result:(NSControl *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:57:22 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setInfo4TM3:sender.stringValue forKeyPaths:iTM2TeXExecResult,nil];
	self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateResult:
- (BOOL)validateResult:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:57:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * extension = @"pdf";
	iTM2TeXProjectDocument * myTPD = self.document;
	NSString * FN = [[myTPD nameForFileKey:[myTPD masterFileKey]] stringByDeletingPathExtension];
	NSString * mode = [self editInfo4iTM3ForKeyPaths:iTM2TeXExecMode,nil];
	if ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseMode,nil] boolValue] && mode.length) {
		// if the result has a length, it is a custom output and I should use it
		// if not, 
		
		[sender.formatter setStringForNilObjectValue:
			[[NSString stringWithFormat:@"%@(%@)", FN, mode] stringByAppendingPathExtension:extension]];
	} else {
		// this is the default output
		[[sender formatter] setStringForNilObjectValue:
			[FN stringByAppendingPathExtension:extension]];
	}
	sender.stringValue = ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseResult,nil] boolValue]? [self editInfo4iTM3ForKeyPaths:iTM2TeXExecResult,nil]:@"");
//END4iTM3;
	return [[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseResult,nil] boolValue];
}
TOGGLE(useMode, validateUseMode, iTM2TeXExecUseMode);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mode:
- (void)mode:(NSControl *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:57:15 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * string = sender.stringValue;
	NSMutableString * MS = [[string mutableCopy] autorelease];
	[MS replaceOccurrencesOfString:@" " withString:@"," options:ZER0 range:iTM3MakeRange(ZER0, MS.length)];
	[MS replaceOccurrencesOfString:@",," withString:@"," options:ZER0 range:iTM3MakeRange(ZER0, MS.length)];
	string = [[MS copy] autorelease];
	[self setInfo4TM3:string forKeyPaths:iTM2TeXExecMode,nil];
	self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMode:
- (BOOL)validateMode:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:57:12 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.stringValue = [self editInfo4iTM3ForKeyPaths:iTM2TeXExecMode,nil];
//END4iTM3;
	return ![self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseMode,nil] || [[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseMode,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent4iTM3:
- (BOOL)validateWindowContent4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:57:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![self.implementation metaValueForKey:@"iTM2 unknown output"]) {
		[self.implementation takeMetaValue:@"" forKey:@"iTM2 unknown output"];
		NSString * output = [self editInfo4iTM3ForKeyPaths:iTM2TeXExecOutput,nil];
		if (![[NSArray arrayWithObjects:@"", @"dvips", @"pdftex", nil] containsObject:output]) {
			[self setInfo4TM3:output forKeyPaths:iTM2TeXExecUnknownOutput,nil];
		}
		if ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecBatch,nil] boolValue]) {
			[self setInfo4TM3:[NSNumber numberWithBool:NO] forKeyPaths:iTM2TeXExecNonStop,nil];
		}
	}
//END4iTM3;
	return [super validateWindowContent4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useXeTeX:
- (void)useXeTeX:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:57:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setInfo4TM3:[NSNumber numberWithBool: ![[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseXeTeX,nil] boolValue]] forKeyPaths:iTM2TeXExecUseXeTeX,nil];
	self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUseXeTeX:
- (BOOL)validateUseXeTeX:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:58:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecOutput,nil] isEqual:[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUnknownOutput,nil]]) {
		sender.state = NSMixedState;
//END4iTM3;
		return NO;
	} else {
		sender.state = ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseXeTeX,nil] boolValue]? NSOnState:NSOffState);
//END4iTM3;
		return YES;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchInteraction:
- (IBAction)switchInteraction:(NSMatrix *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 08:00:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch ([sender.selectedCell tag]) {
        case 0:
			[self setInfo4TM3:[NSNumber numberWithBool:YES] forKeyPaths:iTM2TeXExecBatch,nil];
			[self setInfo4TM3:[NSNumber numberWithBool:NO] forKeyPaths:iTM2TeXExecNonStop,nil];
		break;// batchmode
        case 1:
			[self setInfo4TM3:[NSNumber numberWithBool:NO] forKeyPaths:iTM2TeXExecBatch,nil];
			[self setInfo4TM3:[NSNumber numberWithBool:YES] forKeyPaths:iTM2TeXExecNonStop,nil];
		break;// nonstopmode
        default:
			[self setInfo4TM3:[NSNumber numberWithBool:NO] forKeyPaths:iTM2TeXExecBatch,nil];
			[self setInfo4TM3:[NSNumber numberWithBool:NO] forKeyPaths:iTM2TeXExecNonStop,nil];
		break;// errorstopmode
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSwitchInteraction:
- (BOOL)validateSwitchInteraction:(NSMatrix *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 08:00:01 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecBatch,nil] boolValue]) {
		// @"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode"
		[sender selectCellWithTag:ZER0];
	} else if ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecNonStop,nil] boolValue]) {
		// @"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode"
		[sender selectCellWithTag:1];
	} else {
		// @"batchmode", @"nonstopmode", @"scrollmode", @"errorstopmode"
		[sender selectCellWithTag:3];
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputFormat:
- (IBAction)outputFormat:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 07:59:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseXeTeX,nil] boolValue]) {
		switch (sender.selectedItem.tag) {
			case 0:// dvi
			case 1:// xdv
				[self setInfo4TM3:@"" forKeyPaths:iTM2TeXExecOutput,nil];	
				break;
			default:
				[self setInfo4TM3:@"pdftex" forKeyPaths:iTM2TeXExecOutput,nil];	
				break;
		}
	} else {
		switch (sender.selectedItem.tag) {
			case 0:// dvi
			case 1:// xdv
				[self setInfo4TM3:@"" forKeyPaths:iTM2TeXExecOutput,nil];	
				break;
			case 2:// ps
				[self setInfo4TM3:@"dvips" forKeyPaths:iTM2TeXExecOutput,nil];	
				break;
			case -1:// unknown
				break;
			case 3:// pdf
			default:
				[self setInfo4TM3:@"pdftex" forKeyPaths:iTM2TeXExecOutput,nil];	
				break;
		}
	}
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOutputFormat:
- (BOOL)validateOutputFormat:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 08:00:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL useXeTeX = [[self editInfo4iTM3ForKeyPaths:iTM2TeXExecUseXeTeX,nil] boolValue];
	if ([sender isKindOfClass:[NSPopUpButton class]]) {
		NSString * output = [self editInfo4iTM3ForKeyPaths:iTM2TeXExecOutput,nil];
        NSMenuItem * MI = nil;
		if ([output isEqual:@""]) {
			[sender selectItemWithTag: (useXeTeX? 1:ZER0)];
		} else if ([output isEqual:@"dvips"]) {
			[sender selectItemWithTag:2];
		} else if ([output isEqual:@"pdftex"]) {
			[sender selectItemWithTag:3];
		} else {
			[self setInfo4TM3:output forKeyPaths:iTM2TeXExecUnknownOutput,nil];
			if (!(MI = [sender itemAtIndex:[sender indexOfItemWithTag: -1]])) {
				[sender addItemWithTitle:output];
				MI = sender.lastItem;
				MI.tag = -1;
			} else
				MI.title = output;
			[sender selectItemWithTag: -1];
		}
		NSString * unknownOutput = [self editInfo4iTM3ForKeyPaths:iTM2TeXExecUnknownOutput,nil];
		if (unknownOutput.length) {
			if(!(MI = [sender itemAtIndex:[sender indexOfItemWithTag: -1]])) {
				[sender addItemWithTitle:unknownOutput];
				MI = sender.lastItem;
				MI.tag = -1;
			}
			else
				MI.title = unknownOutput;
		}
		return YES;
	}
	switch (sender.tag) {
		case 0: return !useXeTeX;
		case 1: return useXeTeX;
		case 2: return !useXeTeX;
	}
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtPragmaADE:
- (IBAction)ConTeXtPragmaADE:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 08:01:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SWS openURL:[iTM2ConTeXtInspector ConTeXtPragmaADEURL]];
//END4iTM3;
	return;
}
@end

@implementation iTM2MainInstaller(dvipdfm)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXExecCompleteInstallation4iTM3
+ (void)iTM2TeXExecCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 08:01:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [iTM2EngineTeXExec installBinary];
//END4iTM3;
    return;
}
@end

@implementation iTM2ConTeXtResultFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedStringForObjectValue:withDefaultAttributes:
- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Mar 16 08:01:15 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([[self stringForObjectValue:obj] length])
		return [super attributedStringForObjectValue:obj withDefaultAttributes:attrs];
	return [self attributedStringForNilObjectValueWithDefaultAttributes:attrs];
}
@end

