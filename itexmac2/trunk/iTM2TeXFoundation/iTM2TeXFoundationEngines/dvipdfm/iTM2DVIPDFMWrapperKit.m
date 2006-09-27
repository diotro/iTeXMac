/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan 18 10:34:50 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import "iTM2DVIPDFMWrapperKit.h"

NSString * const iTM2Dvipdfm_use_offset = @"iTM2_dvipdfm_use_offset";// "0" (default) or "1"(bool)
NSString * const iTM2Dvipdfm_x_offset = @"iTM2_dvipdfm_x_offset";//-x, "1" (default) as number
NSString * const iTM2Dvipdfm_y_offset = @"iTM2_dvipdfm_y_offset";//-y, "1" (default) as number
NSString * const iTM2Dvipdfm_x_offset_unit = @"iTM2_dvipdfm_x_offset_unit";// "in" (default) as string, "bp", "pt" or "cm"
NSString * const iTM2Dvipdfm_y_offset_unit = @"iTM2_dvipdfm_y_offset_unit";// "in" (default) as string, "bp", "pt" or "cm"
NSString * const iTM2Dvipdfm_use_paper = @"iTM2_dvipdfm_use_paper";// "0" (default) or "1"(bool)
NSString * const iTM2Dvipdfm_paper = @"iTM2_dvipdfm_paper";//-p, "a4" (default), should be read from the config file...
NSString * const iTM2Dvipdfm_landscape = @"iTM2_dvipdfm_landscape";//-l, "0" (default) or "1"
NSString * const iTM2Dvipdfm_use_magnification = @"iTM2_dvipdfm_use_magnification";// "0" (default) or "1"
NSString * const iTM2Dvipdfm_magnification = @"iTM2_dvipdfm_magnification";//-m, "1000" (default)

NSString * const iTM2Dvipdfm_partial_font_embedding = @"iTM2_dvipdfm_partial_font_embedding";//-e, "0" (default) or "1"
NSString * const iTM2Dvipdfm_use_map_file = @"iTM2_dvipdfm_use_map_file ";//-f, "0" (default) or "1"
NSString * const iTM2Dvipdfm_map_file = @"iTM2_dvipdfm_map_file ";//-f, "" (default)
NSString * const iTM2Dvipdfm_use_resolution = @"iTM2_dvipdfm_use_resolution";//r
NSString * const iTM2Dvipdfm_resolution = @"iTM2_dvipdfm_resolution";//r

NSString * const iTM2Dvipdfm_ignore_color_specials = @"iTM2_dvipdfm_ignore_color_specials";//-c, "0" (default) or "1"
NSString * const iTM2Dvipdfm_use_output_name = @"iTM2_dvipdfm_use_output_name";// "0" (default) or "1"(bool)
NSString * const iTM2Dvipdfm_output_name = @"iTM2_dvipdfm_output_name";//-o, "" (default)
NSString * const iTM2Dvipdfm_use_page_specifications = @"iTM2_dvipdfm_use_page_specifications";
NSString * const iTM2Dvipdfm_page_specifications = @"iTM2_dvipdfm_page_specifications";
NSString * const iTM2Dvipdfm_verbosity_level = @"iTM2_dvipdfm_verbosity_level";//0, 1 for -v, 2 for -vv
NSString * const iTM2Dvipdfm_compression_level = @"iTM2_dvipdfm_compression_level";//-z "0" to "9" (default)


NSString * const iTM2Dvipdfm_remove_thumbnails = @"iTM2_dvipdfm_remove_thumbnails";//-d
NSString * const iTM2Dvipdfm_include_thumbnails = @"iTM2_dvipdfm_include_thumbnails";//-t

@implementation iTM2EngineDvipdfm
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_dvipdfm";
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
    return [NSArray arrayWithObject:@"dvi"];
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
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_landscape,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_use_paper,
				@"a4", iTM2Dvipdfm_paper,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_use_offset,
				[NSNumber numberWithFloat:1], iTM2Dvipdfm_x_offset,
				[NSNumber numberWithFloat:1], iTM2Dvipdfm_y_offset,
				@"in", iTM2Dvipdfm_x_offset_unit,
				@"in", iTM2Dvipdfm_y_offset_unit,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_use_magnification,
				[NSNumber numberWithFloat:1000], iTM2Dvipdfm_magnification,
				[NSNumber numberWithBool:YES], iTM2Dvipdfm_partial_font_embedding,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_use_map_file,
				@"", iTM2Dvipdfm_map_file,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_use_resolution,
				[NSNumber numberWithFloat:600], iTM2Dvipdfm_resolution,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_ignore_color_specials,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_use_output_name,
				@"", iTM2Dvipdfm_output_name,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_use_page_specifications,
				@"", iTM2Dvipdfm_page_specifications,
				[NSNumber numberWithInt:0], iTM2Dvipdfm_verbosity_level,
				[NSNumber numberWithInt:9], iTM2Dvipdfm_compression_level,
					nil];
}
#pragma mark =-=-=-=-=-  PAGE SETUP
#define MODEL_BOOL(GETTER, SETTER, KEY)\
- (BOOL)GETTER;{return [[self modelValueForKey:KEY] boolValue];}\
- (void)SETTER:(BOOL)yorn;{[self takeModelValue:[NSNumber numberWithBool:yorn] forKey:KEY];return;}
MODEL_BOOL(landscape, setLandscape, iTM2Dvipdfm_landscape);
MODEL_BOOL(usePaper, setUsePaper, iTM2Dvipdfm_use_paper);
#define MODEL_OBJECT(GETTER, SETTER, KEY)\
- (id)GETTER;{return [self modelValueForKey:KEY];}\
- (void)SETTER:(id)argument;{[self takeModelValue:argument forKey:KEY];return;}
MODEL_OBJECT(paper, setPaper, iTM2Dvipdfm_paper);
MODEL_BOOL(useOffset, setUseOffset, iTM2Dvipdfm_use_offset);
#define MODEL_FLOAT(GETTER, SETTER, KEY)\
- (float)GETTER;{return [[self modelValueForKey:KEY] floatValue];}\
- (void)SETTER:(float)argument;{[self takeModelValue:[NSNumber numberWithFloat:argument] forKey:KEY];return;}
MODEL_FLOAT(xOffset, setXOffset, iTM2Dvipdfm_x_offset);
MODEL_FLOAT(yOffset, setYOffset, iTM2Dvipdfm_y_offset);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  xOffsetUnit
- (int)xOffsetUnit;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * unit = [self modelValueForKey:iTM2Dvipdfm_x_offset_unit];
	if([unit isEqualToString:@"bp"])
		return 0;
	else if([unit isEqualToString:@"pt"])
		return 1;
	else if([unit isEqualToString:@"in"])
		return 2;
	else if([unit isEqualToString:@"cm"])
		return 3;
    return 2;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setXOffsetUnit:
- (void)setXOffsetUnit:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch(argument)
	{
		case 0: [self takeModelValue:@"bp" forKey:iTM2Dvipdfm_x_offset_unit]; return;
		case 1: [self takeModelValue:@"pt" forKey:iTM2Dvipdfm_x_offset_unit]; return;
		case 3: [self takeModelValue:@"cm" forKey:iTM2Dvipdfm_x_offset_unit]; return;
		default: [self takeModelValue:@"in" forKey:iTM2Dvipdfm_x_offset_unit]; return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  yOffsetUnit
- (int)yOffsetUnit;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * unit = [self modelValueForKey:iTM2Dvipdfm_y_offset_unit];
	if([unit isEqualToString:@"bp"])
		return 0;
	else if([unit isEqualToString:@"pt"])
		return 1;
	else if([unit isEqualToString:@"in"])
		return 2;
	else if([unit isEqualToString:@"cm"])
		return 3;
    return 2;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setYOffsetUnit:
- (void)setYOffsetUnit:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch(argument)
	{
		case 0: [self takeModelValue:@"bp" forKey:iTM2Dvipdfm_y_offset_unit]; return;
		case 1: [self takeModelValue:@"pt" forKey:iTM2Dvipdfm_y_offset_unit]; return;
		case 3: [self takeModelValue:@"cm" forKey:iTM2Dvipdfm_y_offset_unit]; return;
		default: [self takeModelValue:@"in" forKey:iTM2Dvipdfm_y_offset_unit]; return;
	}
//iTM2_END;
    return;
}
MODEL_BOOL(useMagnification, setUseMagnification, iTM2Dvipdfm_use_magnification);
MODEL_FLOAT(magnification, setMagnification, iTM2Dvipdfm_magnification);
#pragma mark =-=-=-=-=-  FONTS
MODEL_BOOL(partialFontEmbedding, setPartialFontEmbedding, iTM2Dvipdfm_partial_font_embedding);
MODEL_BOOL(useMapFile, setUseMapFile, iTM2Dvipdfm_use_map_file);
MODEL_OBJECT(mapFile, setMapFile, iTM2Dvipdfm_map_file);
MODEL_BOOL(useResolution, setUseResolution, iTM2Dvipdfm_use_resolution);
MODEL_FLOAT(resolution, setResolution, iTM2Dvipdfm_resolution);
#pragma mark =-=-=-=-=-  MORE
MODEL_BOOL(ignoreColorSpecials, setIgnoreColorSpecials, iTM2Dvipdfm_ignore_color_specials);
MODEL_BOOL(usePageSpecifications, setUsePageSpecifications, iTM2Dvipdfm_use_page_specifications);
MODEL_OBJECT(pageSpecifications, setPageSpecifications, iTM2Dvipdfm_page_specifications);
MODEL_BOOL(useOutputName, setUseOutputName, iTM2Dvipdfm_use_output_name);
MODEL_OBJECT(outputName, setOutputName, iTM2Dvipdfm_output_name);
#define MODEL_INT(GETTER, SETTER, KEY)\
- (int)GETTER;{return [[self modelValueForKey:KEY] intValue];}\
- (void)SETTER:(int)argument;{[self takeModelValue:[NSNumber numberWithInt:argument] forKey:KEY];return;}
MODEL_INT(compressionLevel, setCompressionLevel, iTM2Dvipdfm_compression_level);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  verbosityLevel
- (int)verbosityLevel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * level = [self modelValueForKey:iTM2Dvipdfm_verbosity_level];
	if([level isEqualToString:@"v"])
		return 1;
	else if([level isEqualToString:@"vv"])
		return 2;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setVerbosityLevel:
- (void)setVerbosityLevel:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	switch(argument)
	{
		case 0: [self takeModelValue:@"" forKey:iTM2Dvipdfm_verbosity_level]; return;
		case 1: [self takeModelValue:@"v" forKey:iTM2Dvipdfm_verbosity_level]; return;
		default: [self takeModelValue:@"vv" forKey:iTM2Dvipdfm_verbosity_level]; return;
	}
    return;
}
@end

@implementation iTM2MainInstaller(dvipdfm)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DvipdfmCompleteInstallation
+ (void)iTM2DvipdfmCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2EngineDvipdfm installBinary];
//iTM2_END;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2DVIPDFMWrapperKit
#if 0
OPTIONS 
-c Ignore color\specials. The-ctoggles a flag that disables color\specialprocessing. Unlesschanged 
in the configuration file, that flag is off, and color\specialsare interpreted normally. The-coption 
may be used to produce a black and white document from a document containing color TeX\special 
commands. 
-d Remove thumbnail images after including them.(See the-toption for more information.)
-e Toggle partial font embedding flag. If partial font embedding is off, embedded fonts are fully 
embedded. Thedefault, if not changed in the configuration file, is to embed only those glyphs actu- 
ally used in the document. 
-f map_file 
Set the name of the font map file tomap_file. The format of the font map file is documented in the 
Dvipdfm User’sManual. 
-l Select landscape mode. In other words, exchange thexandydimensions of the paper. 
-m mag 
Magnify the input document bymag. 
-o name 
Generate PDF output file having the namename. Bydefault, the name of the output file isfile.pdf. 
-p paper 
Select the papersize by name (e.g.,letter,legal,ledger,tabloid,a3,a4,ora5) 
-r size 
Set resolution of bitmapped fonts tosizedots per inch. Bitmapped fonts are generated by the Kpath- 
sea library, which uses MetaFont. Bitmappedfonts are included as type 3 fonts in the PDF output 
file. 
5/28/2001 1
dvipdfm(1) dvipdfm(1) 
-s page_specifications 
Select the pages of theDVIfile to be converted. Thepage_specificationsconsists of a comma sepa- 
rated list of page_ranges: 
page_specifications := page_specification[,page_specifications] 
where 
page_specification := single_page|page_range 
page_range:=[first_page]-[last_page] 
An emptyfirst_pageis implied to be the first page of theDVIfile. Anemptylast_pageis treated as 
the last page of theDVIfile. 
Examples: 
-s 1,3,5 
includes pages 1, 3, and 5; 
-s - includes all pages; 
-s -,- 
includes twocopies of all pages in theDVIfile; and 
-s 1-10 
includes the first ten pages of theDVIfile. 
-t Search for thumbnail images of each page in the directory named by theTMPenvironment variable. 
The thumbnail images must be named in a specific format. Theymust have the same base name as 
theDVIfile and theymust have the page number as the extension to the file name. Dvipdfm does not 
generate the thumbnails itself, but it is distributed with a wrapper program nameddvipdftthat does 
so. 
-v Increase verbosity. Results of the-voption are cumulative(e.g., -vv)increases the verbosity by 
twoincrements. 
-x x_offset 
Set the left margin tox_offset. The default left margin is1.0in. The dimension may be specified in 
anyunits understood by TeX (e.g.,bpt,pt,in,cm) 
-y y_offset 
Set the top margin toy_offset. The default top margin is1.0in. The dimension may be specified in 
anyunits understood by TeX (e.g.,bpt,pt,in,cm) 
-z compression_level 
Set the compression leveltocompression_level. Compressions levels range from 0 (no compression) 
to 9 (maximum compression) and correspond to the values understood by zlib. 
#endif
