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

NSString * const iTM2Dvipdfm_USE_offset = @"USE_offset";// "0" (default) or "1"(bool)
NSString * const iTM2Dvipdfm_x_offset = @"x_offset";//-x, "1" (default) as number
NSString * const iTM2Dvipdfm_y_offset = @"y_offset";//-y, "1" (default) as number
NSString * const iTM2Dvipdfm_x_offset_unit = @"x_offset_unit";// "in" (default) as string, "bp", "pt" or "cm"
NSString * const iTM2Dvipdfm_y_offset_unit = @"y_offset_unit";// "in" (default) as string, "bp", "pt" or "cm"
NSString * const iTM2Dvipdfm_USE_paper = @"USE_paper";// "0" (default) or "1"(bool)
NSString * const iTM2Dvipdfm_paper = @"paper";//-p, "a4" (default), should be read from the config file...
NSString * const iTM2Dvipdfm_landscape = @"landscape";//-l, "0" (default) or "1"
NSString * const iTM2Dvipdfm_USE_magnification = @"USE_magnification";// "0" (default) or "1"
NSString * const iTM2Dvipdfm_magnification = @"magnification";//-m, "1000" (default)

NSString * const iTM2Dvipdfm_embed_all_fonts = @"embed_all_fonts";//-e, "0" (default) or "1"
NSString * const iTM2Dvipdfm_USE_map_file = @"USE_map_file ";//-f, "0" (default) or "1"
NSString * const iTM2Dvipdfm_map_file = @"map_file ";//-f, "" (default)
NSString * const iTM2Dvipdfm_USE_resolution = @"USE_resolution";//r
NSString * const iTM2Dvipdfm_resolution = @"resolution";//r

NSString * const iTM2Dvipdfm_ignore_color_specials = @"ignore_color_specials";//-c, "0" (default) or "1"
NSString * const iTM2Dvipdfm_USE_output_name = @"USE_output_name";// "0" (default) or "1"(bool)
NSString * const iTM2Dvipdfm_output_name = @"output_name";//-o, "" (default)
NSString * const iTM2Dvipdfm_USE_page_specifications = @"USE_page_specifications";
NSString * const iTM2Dvipdfm_page_specifications = @"page_specifications";
NSString * const iTM2Dvipdfm_verbosity_level = @"verbosity_level";//0, 1 for -v, 2 for -vv
NSString * const iTM2Dvipdfm_compression_level = @"compression_level";//-z "0" to "9" (default)


//NSString * const iTM2Dvipdfm_remove_thumbnails = @"remove_thumbnails";//-d
//NSString * const iTM2Dvipdfm_include_thumbnails = @"include_thumbnails";//-t

@implementation iTM2EngineDvipdfm
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_dvipdfm4iTM3";
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
    return [NSArray arrayWithObject:@"dvi"];
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
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_landscape,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_USE_paper,
				@"a4", iTM2Dvipdfm_paper,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_USE_offset,
				[NSNumber numberWithFloat:1], iTM2Dvipdfm_x_offset,
				[NSNumber numberWithFloat:1], iTM2Dvipdfm_y_offset,
				@"in", iTM2Dvipdfm_x_offset_unit,
				@"in", iTM2Dvipdfm_y_offset_unit,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_USE_magnification,
				[NSNumber numberWithFloat:1000], iTM2Dvipdfm_magnification,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_embed_all_fonts,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_USE_map_file,
				@"", iTM2Dvipdfm_map_file,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_USE_resolution,
				[NSNumber numberWithFloat:600], iTM2Dvipdfm_resolution,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_ignore_color_specials,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_USE_output_name,
				@"", iTM2Dvipdfm_output_name,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_USE_page_specifications,
				@"-", iTM2Dvipdfm_page_specifications,
				@"", iTM2Dvipdfm_verbosity_level,
				[NSNumber numberWithInteger:9], iTM2Dvipdfm_compression_level,
					nil];
}
#pragma mark =-=-=-=-=-  PAGE SETUP
#define MODEL_BOOL(GETTER, SETTER, KEY)\
- (BOOL)GETTER;{return [[self info4iTM3ForKeyPaths:KEY,nil] boolValue];}\
- (void)SETTER:(BOOL)yorn;{[self setInfo4TM3:[NSNumber numberWithBool:yorn] forKeyPaths:KEY,nil];return;}
MODEL_BOOL(landscape, setLandscape, iTM2Dvipdfm_landscape);
MODEL_BOOL(usePaper, setUsePaper, iTM2Dvipdfm_USE_paper);
#define MODEL_OBJECT(GETTER, SETTER, KEY)\
- (id)GETTER;{return [self info4iTM3ForKeyPaths:KEY,nil];}\
- (void)SETTER:(id)argument;{[self setInfo4TM3:argument forKeyPaths:KEY,nil];return;}
MODEL_OBJECT(paper, setPaper, iTM2Dvipdfm_paper);
MODEL_BOOL(useOffset, setUseOffset, iTM2Dvipdfm_USE_offset);
#define MODEL_FLOAT(GETTER, SETTER, KEY)\
- (CGFloat)GETTER;{return [[self info4iTM3ForKeyPaths:KEY,nil] floatValue];}\
- (void)SETTER:(CGFloat)argument;{[self setInfo4TM3:[NSNumber numberWithFloat:argument] forKeyPaths:KEY,nil];return;}
MODEL_FLOAT(xOffset, setXOffset, iTM2Dvipdfm_x_offset);
MODEL_FLOAT(yOffset, setYOffset, iTM2Dvipdfm_y_offset);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  xOffsetUnit
- (NSInteger)xOffsetUnit;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * unit = [self info4iTM3ForKeyPaths:iTM2Dvipdfm_x_offset_unit,nil];
	if([unit isEqualToString:@"bp"])
		return ZER0;
	else if([unit isEqualToString:@"pt"])
		return 1;
	else if([unit isEqualToString:@"in"])
		return 2;
	else if([unit isEqualToString:@"cm"])
		return 3;
    return 2;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setXOffsetUnit:
- (void)setXOffsetUnit:(NSInteger)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	switch(argument)
	{
		case 0: [self setInfo4TM3:@"bp" forKeyPaths:iTM2Dvipdfm_x_offset_unit,nil]; return;
		case 1: [self setInfo4TM3:@"pt" forKeyPaths:iTM2Dvipdfm_x_offset_unit,nil]; return;
		case 3: [self setInfo4TM3:@"cm" forKeyPaths:iTM2Dvipdfm_x_offset_unit,nil]; return;
		default: [self setInfo4TM3:@"in" forKeyPaths:iTM2Dvipdfm_x_offset_unit,nil]; return;
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  yOffsetUnit
- (NSInteger)yOffsetUnit;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * unit = [self info4iTM3ForKeyPaths:iTM2Dvipdfm_y_offset_unit,nil];
	if([unit isEqualToString:@"bp"])
		return ZER0;
	else if([unit isEqualToString:@"pt"])
		return 1;
	else if([unit isEqualToString:@"in"])
		return 2;
	else if([unit isEqualToString:@"cm"])
		return 3;
    return 2;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setYOffsetUnit:
- (void)setYOffsetUnit:(NSInteger)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	switch(argument)
	{
		case 0: [self setInfo4TM3:@"bp" forKeyPaths:iTM2Dvipdfm_y_offset_unit,nil]; return;
		case 1: [self setInfo4TM3:@"pt" forKeyPaths:iTM2Dvipdfm_y_offset_unit,nil]; return;
		case 3: [self setInfo4TM3:@"cm" forKeyPaths:iTM2Dvipdfm_y_offset_unit,nil]; return;
		default: [self setInfo4TM3:@"in" forKeyPaths:iTM2Dvipdfm_y_offset_unit,nil]; return;
	}
//END4iTM3;
    return;
}
MODEL_BOOL(useMagnification, setUseMagnification, iTM2Dvipdfm_USE_magnification);
MODEL_FLOAT(magnification, setMagnification, iTM2Dvipdfm_magnification);
#pragma mark =-=-=-=-=-  FONTS
MODEL_BOOL(partialFontEmbedding, setPartialFontEmbedding, iTM2Dvipdfm_embed_all_fonts);
MODEL_BOOL(useMapFile, setUseMapFile, iTM2Dvipdfm_USE_map_file);
MODEL_OBJECT(mapFile, setMapFile, iTM2Dvipdfm_map_file);
MODEL_BOOL(useResolution, setUseResolution, iTM2Dvipdfm_USE_resolution);
MODEL_FLOAT(resolution, setResolution, iTM2Dvipdfm_resolution);
#pragma mark =-=-=-=-=-  MORE
MODEL_BOOL(ignoreColorSpecials, setIgnoreColorSpecials, iTM2Dvipdfm_ignore_color_specials);
MODEL_BOOL(usePageSpecifications, setUsePageSpecifications, iTM2Dvipdfm_USE_page_specifications);
MODEL_OBJECT(pageSpecifications, setPageSpecifications, iTM2Dvipdfm_page_specifications);
MODEL_BOOL(useOutputName, setUseOutputName, iTM2Dvipdfm_USE_output_name);
MODEL_OBJECT(outputName, setOutputName, iTM2Dvipdfm_output_name);
#define MODEL_INT(GETTER, SETTER, KEY)\
- (NSInteger)GETTER;{return [[self info4iTM3ForKeyPaths:KEY,nil] integerValue];}\
- (void)SETTER:(NSInteger)argument;{[self setInfo4TM3:[NSNumber numberWithInteger:argument] forKeyPaths:KEY,nil];return;}
MODEL_INT(compressionLevel, setCompressionLevel, iTM2Dvipdfm_compression_level);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  verbosityLevel
- (NSInteger)verbosityLevel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * level = [self info4iTM3ForKeyPaths:iTM2Dvipdfm_verbosity_level,nil];
	if([level isEqualToString:@"v"])
		return 1;
	else if([level isEqualToString:@"vv"])
		return 2;
    return ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setVerbosityLevel:
- (void)setVerbosityLevel:(NSInteger)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	switch(argument)
	{
		case 0: [self setInfo4TM3:@"" forKeyPaths:iTM2Dvipdfm_verbosity_level,nil]; return;
		case 1: [self setInfo4TM3:@"v" forKeyPaths:iTM2Dvipdfm_verbosity_level,nil]; return;
		default: [self setInfo4TM3:@"vv" forKeyPaths:iTM2Dvipdfm_verbosity_level,nil]; return;
	}
    return;
}
@end

#if 0
dvipdfm, version 0.13.2c, Copyright (C) 1998, 1999 by Mark A. Wicks
dvipdfm comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions.  Details are distributed with the software.

Usage: dvipdfm [options] dvifile
-c              Ignore color specials (for B&W printing)
-f filename     Set font map file name [t1fonts.map]
-o filename     Set output file name [dvifile.pdf]
-l              Landscape mode
-m number       Set additional magnification
-p papersize    Set papersize (letter, legal,
                ledger, tabloid, a4, or a3) [letter]
-r resolution   Set resolution (in DPI) for raster fonts [600]
-s pages        Select page ranges (-)
-t              Embed thumbnail images
-d              Remove thumbnail images when finished
-x dimension    Set horizontal offset [1.0in]
-y dimension    Set vertical offset [1.0in]
-e              Disable partial font embedding [default is enabled])
-z number       Set compression level (0-9) [default is 9])
-v              Be verbose
-vv             Be more verbose

All dimensions entered on the command line are "true" TeX dimensions.
Argument of "-s" lists physical page ranges separated by commas, e.g., "-s 1-3,5-6"

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
Select the papersize by name (e.g.,letter,legal,ledger,tabloid,a3,a4,or a5) 
-r size 
Set resolution of bitmapped fonts tosizedots per inch. Bitmapped fonts are generated by the Kpath- 
sea library, which uses MetaFont. Bitmappedfonts are included as type 3 fonts in the PDF output 
file. 
-s page_specifications 
	Select the pages of the DVI file to be converted. The page_specifications consists of a comma separated list of page_ranges: 
	page_specifications := page_specification[,page_specifications] 
	where 
	page_specification := single_page|page_range 
	page_range:=[first_page]-[last_page] 
	An empty first_page is implied to be the first page of the DVI file. An empty last_page is treated as the last page of theDVIfile. 
	Examples: 
		-s 1,3,5 
		includes pages 1, 3, and 5; 
		-s - includes all pages; 
		-s -,- 
		includes twocopies of all pages in theDVIfile; and 
		-s 1-10 
		includes the first ten pages of theDVIfile. 
-t Search for thumbnail images of each page in the directory named by the TMP environment variable. 
The thumbnail images must be named in a specific format. They must have the same base name as 
the DVI file and theymust have the page number as the extension to the file name. Dvipdfm does not 
generate the thumbnails itself, but it is distributed with a wrapper program named dvipdft that does 
so. 
-v Increase verbosity. Results of the -v option are cumulative(e.g., -vv)increases the verbosity by 
two increments. 
-x x_offset 
Set the left margin tox_offset. The default left margin is 1.0 in. The dimension may be specified in 
any units understood by TeX (e.g.,bp,pt,in,cm) 
-y y_offset Set the top margin toy_offset. The default top margin is 1.0 in. The dimension may be specified in any units understood by TeX (e.g.,bp,pt,in,cm) 
-z compression_level Set the compression level to compression_level. Compressions levels range from 0 (no compression) 
to 9 (maximum compression) and correspond to the values understood by zlib. 
#endif

#if 0
This is dvipdfmx-20061211 by the DVIPDFMx project team,
an extended version of dvipdfm-0.13.2c developed by Mark A. Wicks.

Copyright (C) 2002-2006 by the DVIPDFMx project team

This is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

Usage: dvipdfmx [options] dvifile
-c              Ignore color specials (for B&W printing)
-f filename     Set font map file name [t1fonts.map]
-o filename     Set output file name [dvifile.pdf]
-l              Landscape mode
-m number       Set additional magnification
-p papersize    Set papersize [a4]
-r resolution   Set resolution (in DPI) for raster fonts [600]
-s pages        Select page ranges (-)
-t              Embed thumbnail images
-x dimension    Set horizontal offset [1.0in]
-y dimension    Set vertical offset [1.0in]
-z number       Set zlib compression level (0-9) [9]
-v              Be verbose
-vv             Be more verbose

-d number       Set PDF decimal digits (0-5) [2]
-C number       Specify miscellaneous option flags [0]:
                  0x0001 reserved
                  0x0002 Use semi-transparent filling for tpic shading command,
                         instead of opaque gray color. (requires PDF 1.4)
                  0x0004 Treat all CIDFont as fixed-pitch font.
                  0x0008 Do not replace duplicate fontmap entries.
                Positive values are always ORed with previously given flags.
                And negative values replace old values.
-O number       Set maximum depth of open bookmark items [0]
-P number       Set permission flags for PDF encryption [0x003C]
-S              Enable PDF encryption
-T              Embed thumbnail images. Remove images files when finished.
-V number       Set PDF minor version [3]
-M              Experimental mps-to-pdf mode

All dimensions entered on the command line are "true" TeX dimensions.
Argument of "-s" lists physical page ranges separated by commas, e.g., "-s 1-3,5-6"
Papersize is specified by paper format (e.g., "a4") or by w<unit>,h<unit> (e.g., "20cm,30cm").
#endif

NSString * const iTM2Dvipdfm_decimal_digits = @"decimal_digits";//-d [2]
NSString * const iTM2Dvipdfm_open_bookmark_depth = @"open_bookmark_depth";//-O
NSString * const iTM2Dvipdfm_option_flags = @"option_flags";//-C
NSString * const iTM2Dvipdfm_permission_flags = @"permission_flags";//-P
NSString * const iTM2Dvipdfm_enable_encryption = @"enable_encryption";//-S
NSString * const iTM2Dvipdfm_include_thumbnails = @"include_thumbnails";//-T
NSString * const iTM2Dvipdfm_minor_version = @"minor_version";//-V
NSString * const iTM2Dvipdfm_mps_to_pdf = @"mps_to_pdf";//-M

@implementation iTM2EngineDvipdfmx
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_dvipdfmx4iTM3";
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
	NSMutableDictionary * MD = [[[super defaultShellEnvironment] mutableCopy] autorelease];
	[MD addEntriesFromDictionary:
			[NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInteger:ZER0], iTM2Dvipdfm_open_bookmark_depth,
				[NSNumber numberWithInteger:ZER0], iTM2Dvipdfm_option_flags,
				[NSNumber numberWithInteger:0x003C], iTM2Dvipdfm_permission_flags,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_enable_encryption,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_include_thumbnails,
				[NSNumber numberWithInteger:3], iTM2Dvipdfm_minor_version,
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_mps_to_pdf,
					nil]];
	return [NSDictionary dictionaryWithDictionary:MD];
}
MODEL_BOOL(enableEncryption, setEnableEncryption, iTM2Dvipdfm_enable_encryption);
MODEL_BOOL(includeThumbnails, setIncludeThumbnails, iTM2Dvipdfm_include_thumbnails);
MODEL_BOOL(MPS2PDF, setMPS2PDF, iTM2Dvipdfm_mps_to_pdf);
MODEL_INT(openBookmarkDepth, setOpenBookmarkDepth, iTM2Dvipdfm_open_bookmark_depth);
MODEL_INT(permissionFlags, setPermissionFlags, iTM2Dvipdfm_permission_flags);
MODEL_INT(optionFlags, setOptionFlags, iTM2Dvipdfm_option_flags);
MODEL_INT(minorVersion, setMinorVersion, iTM2Dvipdfm_minor_version);
MODEL_INT(decimalDigits, setDecimalDigits, iTM2Dvipdfm_decimal_digits);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOptionFlagFromTag:
- (IBAction)toggleOptionFlagFromTag:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger options = self.optionFlags;
	NSInteger mask = sender.tag;
	if(options & mask)
		options &= ~mask;
	else
		options |= mask;
	self.optionFlags = options;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOptionFlagFromTag:
- (BOOL)validateToggleOptionFlagFromTag:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger options = self.optionFlags;
	NSInteger mask = sender.tag;
	sender.state = (options & mask?NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
@end

#if 0
This is xdvipdfmx-0.4 by Jonathan Kew and Jin-Hwan Cho,
an extended version of DVIPDFMx, which in turn was
an extended version of dvipdfm-0.13.2c developed by Mark A. Wicks.

Copyright (c) 2006 SIL International and Jin-Hwan Cho.

This is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

Usage: xdvipdfmx [options] xdvfile
-c              Ignore color specials (for B&W printing)
-d number       Set PDF decimal digits (0-5) [2]
-l              Landscape mode
-f filename     Set font map file name [t1fonts.map]
-m number       Set additional magnification
-o filename     Set output file name [dvifile.pdf]
-p papersize    Set papersize [a4]
-r resolution   Set resolution (in DPI) for raster fonts [600]
-s pages        Select page ranges (-)
-t              Embed thumbnail images
-x dimension    Set horizontal offset [1.0in]
-y dimension    Set vertical offset [1.0in]
-z number       Set zlib compression level (0-9) [9]
-v              Be verbose
-vv             Be more verbose
-C number       Specify miscellaneous option flags [0]:
                  0x0001 reserved
                  0x0002 Use semi-transparent filling for tpic shading command,
                         instead of opaque gray color. (requires PDF 1.4)
                  0x0004 Treat all CIDFont as fixed-pitch font.
                  0x0008 Do not replace duplicate fontmap entries.
                Positive values are always ORed with previously given flags.
                And negative values replace old values.
-E              Always try to embed fonts, regardless of licensing flags.
-O number       Set maximum depth of open bookmark items [0]
-P number       Set permission flags for PDF encryption [0x003C]
-S              Enable PDF encryption
-T              Embed thumbnail images. Remove images files when finished.
-M              Experimental mps-to-pdf mode
-V number       Set PDF minor version [3]

All dimensions entered on the command line are "true" TeX dimensions.
Argument of "-s" lists physical page ranges separated by commas, e.g., "-s 1-3,5-6"
Papersize is specified by paper format (e.g., "a4") or by w<unit>,h<unit> (e.g., "20cm,30cm").
#endif

NSString * const iTM2Dvipdfm_ignore_font_license = @"embed_all_fonts";//-M

@implementation iTM2EngineXdvipdfmx
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_xdvipdfmx4iTM3";
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
    return [NSArray arrayWithObject:@"xdv"];
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
	NSMutableDictionary * MD = [[[super defaultShellEnvironment] mutableCopy] autorelease];
	[MD addEntriesFromDictionary:
			[NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithBool:NO], iTM2Dvipdfm_ignore_font_license,
					nil]];
	return [NSDictionary dictionaryWithDictionary:MD];
}
// accessors
MODEL_BOOL(ignoreFontLicense, setIgnoreFontLicense, iTM2Dvipdfm_ignore_font_license);
@end

@implementation iTM2MainInstaller(dvipdfm)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DvipdfmCompleteInstallation4iTM3
+ (void)iTM2DvipdfmCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [iTM2EngineDvipdfm installBinary];
    [iTM2EngineDvipdfmx installBinary];
    [iTM2EngineXdvipdfmx installBinary];
//END4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2DVIPDFMWrapperKit
