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

#import "iTM2DvipsWrapperKit.h"

//copies
NSString * const iTM2Dvips_multiple_copies = @"iTM2_dvips_multiple_copies";// 1, 0
NSString * const iTM2Dvips_num_copies = @"iTM2_dvips_num_copies";// NUM
NSString * const iTM2Dvips_collated_copies = @"iTM2_dvips_collated_copies";// NUM
NSString * const iTM2Dvips_duplicate_page_body = @"iTM2_dvips_duplicate_page_body";// NUM
NSString * const iTM2Dvips_even_TeX_pages = @"iTM2_dvips_even_TeX_pages";//-B
NSString * const iTM2Dvips_odd_TeX_pages = @"iTM2_dvips_odd_TeX_pages";//-A
NSString * const iTM2Dvips_last_page = @"iTM2_dvips_last_page";//-l [=]NUM
NSString * const iTM2Dvips_first_page = @"iTM2_dvips_first_page";//-p [=]NUM
NSString * const iTM2Dvips_physical_pages = @"iTM2_dvips_physical_pages";
NSString * const iTM2Dvips_USE_page_ranges = @"iTM2_dvips_USE_page_ranges";
NSString * const iTM2Dvips_page_ranges = @"iTM2_dvips_page_ranges";//-pp
NSString * const iTM2Dvips_USE_max_num_pages = @"iTM2_dvips_USE_max_num_pages";
NSString * const iTM2Dvips_max_num_pages = @"iTM2_dvips_max_num_pages";///-n NUM

//page setup
NSString * const iTM2Dvips_USE_offset = @"iTM2_dvips_USE_offset";//
NSString * const iTM2Dvips_x_offset = @"iTM2_dvips_x_offset";//-O X-OFFSET,Y-OFFSET
NSString * const iTM2Dvips_x_offset_unit = @"iTM2_dvips_x_offset_unit";//
NSString * const iTM2Dvips_y_offset = @"iTM2_dvips_y_offset";//
NSString * const iTM2Dvips_y_offset_unit = @"iTM2_dvips_y_offset_unit";//
NSString * const iTM2Dvips_USE_magnification = @"iTM2_dvips_USE_magnification";
NSString * const iTM2Dvips_both_magnifications = @"iTM2_dvips_both_magnifications";
NSString * const iTM2Dvips_x_magnification = @"iTM2_dvips_x_magnification";//-x NUM
NSString * const iTM2Dvips_y_magnification = @"iTM2_dvips_y_magnification";//-y NUM
NSString * const iTM2Dvips_both_resolutions = @"iTM2_dvips_both_resolutions";//-D NUM
NSString * const iTM2Dvips_USE_resolution = @"iTM2_dvips_USE_resolution";
NSString * const iTM2Dvips_x_resolution = @"iTM2_dvips_x_resolution";//-X NUM
NSString * const iTM2Dvips_y_resolution = @"iTM2_dvips_y_resolution";//-Y NUM
NSString * const iTM2Dvips_USE_paper = @"iTM2_dvips_USE_paper";
NSString * const iTM2Dvips_paper = @"iTM2_dvips_paper";// -t  PAPERTYPE
NSString * const iTM2Dvips_landscape = @"iTM2_dvips_landscape";// -t landscape
NSString * const iTM2Dvips_custom_paper = @"iTM2_dvips_custom_paper";
NSString * const iTM2Dvips_paper_width = @"iTM2_dvips_paper_width";//-T HSIZE,VSIZE
NSString * const iTM2Dvips_paper_width_unit = @"iTM2_dvips_paper_width_unit";
NSString * const iTM2Dvips_paper_height = @"iTM2_dvips_paper_height";//-T HSIZE,VSIZE
NSString * const iTM2Dvips_paper_height_unit = @"iTM2_dvips_paper_height_unit";

// postscript
NSString * const iTM2Dvips_generate_epsf = @"iTM2_dvips_generate_epsf";//-E, -E*
NSString * const iTM2Dvips_print_crop_mark = @"iTM2_dvips_print_crop_mark";//-k, -k0
NSString * const iTM2Dvips_USE_header = @"iTM2_dvips_USE_header";
NSString * const iTM2Dvips_header = @"iTM2_dvips_header";//-h NAME
NSString * const iTM2Dvips_remove_included_comments = @"iTM2_dvips_remove_included_comments";//-K, -K0
NSString * const iTM2Dvips_no_structured_comments = @"iTM2_dvips_no_structured_comments";// -N, -N0

//fonts
NSString * const iTM2Dvips_download_only_needed_characters = @"iTM2_dvips_download_only_needed_characters";//-j, -j0
NSString * const iTM2Dvips_USE_metafont_mode = @"iTM2_dvips_USE_metafont_mode";
NSString * const iTM2Dvips_metafont_mode = @"iTM2_dvips_metafont_mode";//-mode MODE
NSString * const iTM2Dvips_no_automatic_font_generation = @"iTM2_dvips_no_automatic_font_generation";//-M, -M0
NSString * const iTM2Dvips_USE_psmap_files = @"iTM2_dvips_USE_psmap_files";
NSString * const iTM2Dvips_psmap_files = @"iTM2_dvips_psmap_files";//-u PSMAPFILE
NSString * const iTM2Dvips_download_non_resident_fonts = @"iTM2_dvips_download_non_resident_fonts";//-V, -V0
NSString * const iTM2Dvips_compress_bitmap_fonts = @"iTM2_dvips_compress_bitmap_fonts";//-Z, -Z0
NSString * const iTM2Dvips_maximum_drift = @"iTM2_dvips_maximum_drift";//-e
NSString * const iTM2Dvips_shift_non_printing_characters = @"iTM2_dvips_shift_non_printing_characters";//-G, -G*

//other
NSString * const iTM2Dvips_USE_printer = @"iTM2_dvips_USE_printer";
NSString * const iTM2Dvips_printer = @"iTM2_dvips_printer";// -P PRINTER
NSString * const iTM2Dvips_no_virtual_memory_saving = @"iTM2_dvips_no_virtual_memory_saving";// -U,-U0
//NSString * const iTM2Dvips_manual_feed = @"iTM2_dvips_manual_feed";//-m, -m0
NSString * const iTM2Dvips_pass_html = @"iTM2_dvips_pass_html";//-z, -z0
NSString * const iTM2Dvips_debug = @"iTM2_dvips_debug";
NSString * const iTM2Dvips_debug_level = @"iTM2_dvips_debug_level";//-d
NSString * const iTM2Dvips_conserve_memory = @"iTM2_dvips_conserve_memory";//-a, -a0
NSString * const iTM2Dvips_separate_sections = @"iTM2_dvips_separate_sections";//-i, -i0
NSString * const iTM2Dvips_section_num_pages = @"iTM2_dvips_section_num_pages";//-S NUM (with -i)
NSString * const iTM2Dvips_USE_output = @"iTM2_dvips_USE_output";
NSString * const iTM2Dvips_output = @"iTM2_dvips_output";//-o NAME
NSString * const iTM2Dvips_USE_more_arguments = @"iTM2_dvips_USE_more_arguments";
NSString * const iTM2Dvips_more_arguments = @"iTM2_dvips_more_arguments";

@interface iTM2EngineDvips(PRIVATE)
- (id)paperWidthUnitModel;
- (BOOL)usePaper;
- (BOOL)customPaper;
- (void)setCustomPaper:(BOOL)argument;
- (void)setUsePaper:(BOOL)argument;
@end
@implementation iTM2EngineDvips
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_dvips";
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
				[NSNumber numberWithBool:NO], iTM2Dvips_multiple_copies,
				[NSNumber numberWithInt:1], iTM2Dvips_num_copies,
				[NSNumber numberWithBool:NO], iTM2Dvips_collated_copies,
				[NSNumber numberWithBool:NO], iTM2Dvips_duplicate_page_body,
				[NSNumber numberWithBool:YES], iTM2Dvips_even_TeX_pages,
				[NSNumber numberWithBool:YES], iTM2Dvips_odd_TeX_pages,
				[NSNumber numberWithBool:YES], iTM2Dvips_physical_pages,
				[NSNumber numberWithInt:100000], iTM2Dvips_last_page,
				[NSNumber numberWithInt:1], iTM2Dvips_first_page,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_page_ranges,
				@"", iTM2Dvips_page_ranges,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_max_num_pages,
				[NSNumber numberWithInt:0], iTM2Dvips_max_num_pages,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_offset,
				[NSNumber numberWithFloat:0], iTM2Dvips_x_offset,
				@"in", iTM2Dvips_x_offset_unit,
				[NSNumber numberWithFloat:0], iTM2Dvips_y_offset,
				@"in", iTM2Dvips_y_offset_unit,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_magnification,
				[NSNumber numberWithFloat:1000], iTM2Dvips_x_magnification,
				[NSNumber numberWithFloat:1000], iTM2Dvips_y_magnification,
				[NSNumber numberWithBool:YES], iTM2Dvips_both_resolutions,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_resolution,
				[NSNumber numberWithFloat:600], iTM2Dvips_x_resolution,
				[NSNumber numberWithFloat:600], iTM2Dvips_y_resolution,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_paper,
				@"a4", iTM2Dvips_paper,
				[NSNumber numberWithBool:NO], iTM2Dvips_landscape,
				[NSNumber numberWithBool:NO], iTM2Dvips_custom_paper,
				[NSNumber numberWithFloat:21], iTM2Dvips_paper_width,
				@"cm", iTM2Dvips_paper_width_unit,
				[NSNumber numberWithFloat:29.7], iTM2Dvips_paper_height,
				@"cm", iTM2Dvips_paper_height_unit,
				[NSNumber numberWithInt:0], iTM2Dvips_generate_epsf,
				[NSNumber numberWithInt:0], iTM2Dvips_print_crop_mark,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_header,
				@"", iTM2Dvips_header,
				[NSNumber numberWithInt:0], iTM2Dvips_remove_included_comments,
				[NSNumber numberWithInt:0], iTM2Dvips_no_structured_comments,
				[NSNumber numberWithInt:0], iTM2Dvips_download_only_needed_characters,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_metafont_mode,
				@"", iTM2Dvips_metafont_mode,
				[NSNumber numberWithInt:0], iTM2Dvips_no_automatic_font_generation,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_psmap_files,
				@"", iTM2Dvips_psmap_files,
				[NSNumber numberWithInt:0], iTM2Dvips_download_non_resident_fonts,
				[NSNumber numberWithInt:0], iTM2Dvips_compress_bitmap_fonts,
				[NSNumber numberWithInt:0], iTM2Dvips_maximum_drift,
				[NSNumber numberWithInt:0], iTM2Dvips_shift_non_printing_characters,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_printer,
				@"", iTM2Dvips_printer,
				[NSNumber numberWithInt:0], iTM2Dvips_no_virtual_memory_saving,
				[NSNumber numberWithInt:1], iTM2Dvips_pass_html,
				[NSNumber numberWithBool:NO], iTM2Dvips_debug,
				[NSNumber numberWithInt: -1 ], iTM2Dvips_debug_level,
				[NSNumber numberWithInt:0], iTM2Dvips_conserve_memory,
				[NSNumber numberWithInt:0], iTM2Dvips_separate_sections,
				[NSNumber numberWithInt:0], iTM2Dvips_section_num_pages,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_output,
				@"", iTM2Dvips_output,
				[NSNumber numberWithBool:NO], iTM2Dvips_USE_more_arguments,
				@"", iTM2Dvips_more_arguments,
					nil];
}
#pragma mark =-=-=-=-=-  COPIES
#define MODEL_BOOL(GETTER, SETTER, KEY)\
- (BOOL)GETTER;{return [[self modelValueForKey:KEY] boolValue];}\
- (void)SETTER:(BOOL)yorn;{[self takeModelValue:[NSNumber numberWithBool:yorn] forKey:KEY];return;}
#define MODEL_OBJECT(GETTER, SETTER, KEY)\
- (id)GETTER;{return [self modelValueForKey:KEY];}\
- (void)SETTER:(id)argument;{[self takeModelValue:argument forKey:KEY];return;}
#define MODEL_FLOAT(GETTER, SETTER, KEY)\
- (float)GETTER;{return [[self modelValueForKey:KEY] floatValue];}\
- (void)SETTER:(float)argument;{[self takeModelValue:[NSNumber numberWithFloat:argument] forKey:KEY];return;}
#define MODEL_INT(GETTER, SETTER, KEY)\
- (int)GETTER;{return [[self modelValueForKey:KEY] intValue];}\
- (void)SETTER:(int)argument;{[self takeModelValue:[NSNumber numberWithInt:argument] forKey:KEY];return;}
MODEL_BOOL(duplicatePageBody, setDuplicatePageBody, iTM2Dvips_duplicate_page_body);
MODEL_BOOL(collatedCopies, setCollatedCopies, iTM2Dvips_collated_copies);
MODEL_BOOL(multipleCopies, setMultipleCopies, iTM2Dvips_multiple_copies);
MODEL_INT(numberOfCopies, setNumberOfCopies, iTM2Dvips_num_copies);
MODEL_BOOL(physicalPage, setPhysicalPage, iTM2Dvips_physical_pages);
MODEL_BOOL(evenTeXPages, setEvenTeXPages, iTM2Dvips_even_TeX_pages);
MODEL_BOOL(oddTeXPages, setOddTeXPages, iTM2Dvips_odd_TeX_pages);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXPageMode
- (int)TeXPageMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self evenTeXPages])
	{
		if([self oddTeXPages])
		{
			return 0;// all
		}
		else
			return 1;// even
	}
	else if([self oddTeXPages])
		return 2;// odd
	else
		return 3;// custom
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTeXPageMode:
- (void)setTeXPageMode:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch(argument)
	{
		case 1: [self setEvenTeXPages:YES]; [self setOddTeXPages:NO]; return;
		case 2: [self setEvenTeXPages:NO]; [self setOddTeXPages:YES]; return;
		case 3: [self setEvenTeXPages:NO]; [self setOddTeXPages:NO]; return;
		case 0: default:[self setEvenTeXPages:YES]; [self setOddTeXPages:YES]; return;
	}
//iTM2_END;
    return;
}
MODEL_INT(lastPage, setLastPage, iTM2Dvips_last_page);
MODEL_INT(firstPage, setFirstPage, iTM2Dvips_first_page);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  usePageRange
- (BOOL)usePageRange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [self TeXPageMode] == 3;
}
MODEL_BOOL(usePageRanges, setUsePageRanges, iTM2Dvips_USE_page_ranges);
MODEL_OBJECT(pageRanges, setPageRanges, iTM2Dvips_page_ranges);
MODEL_BOOL(useMaxNumberOfPages, setUseMaxNumberOfPages, iTM2Dvips_USE_max_num_pages);
MODEL_INT(maxNumberOfPages, setMaxNumberOfPages, iTM2Dvips_max_num_pages);
#pragma mark =-=-=-=-=-  PAGE SETUP
MODEL_BOOL(useOffset, setUseOffset, iTM2Dvips_USE_offset);
MODEL_FLOAT(xOffset, setXOffset, iTM2Dvips_x_offset);
MODEL_OBJECT(xOffsetUnitModel, setXOffsetUnitModel, iTM2Dvips_x_offset_unit);
MODEL_FLOAT(yOffset, setYOffset, iTM2Dvips_y_offset);
MODEL_OBJECT(yOffsetUnitModel, setYOffsetUnitModel, iTM2Dvips_y_offset_unit);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  xOffsetUnit
- (int)xOffsetUnit;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * unit = [self xOffsetUnitModel];
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
		case 0: [self setXOffsetUnitModel:@"bp"]; return;
		case 1: [self setXOffsetUnitModel:@"pt"]; return;
		case 3: [self setXOffsetUnitModel:@"cm"]; return;
		default: [self setXOffsetUnitModel:@"in"]; return;
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
	NSString * unit = [self yOffsetUnitModel];
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
		case 0: [self setYOffsetUnitModel:@"bp"]; return;
		case 1: [self setYOffsetUnitModel:@"pt"]; return;
		case 3: [self setYOffsetUnitModel:@"cm"]; return;
		default: [self setYOffsetUnitModel:@"in"]; return;
	}
//iTM2_END;
    return;
}
MODEL_BOOL(landscape, setLandscape, iTM2Dvips_landscape);
MODEL_BOOL(useMagnification, setUseMagnification, iTM2Dvips_USE_magnification);
MODEL_BOOL(bothMagnifications, setBothMagnifications, iTM2Dvips_both_magnifications);
- (float)xMagnification;{return [[self modelValueForKey:iTM2Dvips_x_magnification] floatValue]/10.0;}
- (void)setXMagnification:(float)argument;{[self takeModelValue:[NSNumber numberWithFloat:argument*10] forKey:iTM2Dvips_x_magnification];return;}
- (float)yMagnification;{return [[self modelValueForKey:iTM2Dvips_y_magnification] floatValue]/10.0;}\
- (void)setYMagnification:(float)argument;{[self takeModelValue:[NSNumber numberWithFloat:argument*10] forKey:iTM2Dvips_y_magnification];return;}
MODEL_BOOL(usePaper, setUsePaper, iTM2Dvips_USE_paper);
MODEL_OBJECT(paper, setPaper, iTM2Dvips_paper);
MODEL_BOOL(customPaper, setCustomPaper, iTM2Dvips_custom_paper);
MODEL_FLOAT(paperWidth, setPaperWidth, iTM2Dvips_paper_width);
MODEL_OBJECT(paperWidthUnitModel, setPaperWidthUnitModel, iTM2Dvips_paper_width_unit);
MODEL_FLOAT(paperHeight, setPaperHeight, iTM2Dvips_paper_height);
MODEL_OBJECT(paperHeightUnitModel, setPaperHeightUnitModel, iTM2Dvips_paper_height_unit);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  paperType
- (int)paperType;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self usePaper]? 1: ([self customPaper]?2: 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPaperType:
- (void)setPaperType:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch(argument)
	{
		case 2: [self setCustomPaper:YES];[self setUsePaper:NO]; return;
		case 1: [self setUsePaper:YES]; return;
		default: [self setCustomPaper:NO];[self setUsePaper:NO]; return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  paperWidthUnit
- (int)paperWidthUnit;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * unit = [self paperWidthUnitModel];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPaperWidthUnit:
- (void)setPaperWidthUnit:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch(argument)
	{
		case 0: [self setPaperWidthUnitModel:@"bp"]; return;
		case 1: [self setPaperWidthUnitModel:@"pt"]; return;
		case 3: [self setPaperWidthUnitModel:@"cm"]; return;
		default: [self setPaperWidthUnitModel:@"in"]; return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  paperHeightUnit
- (int)paperHeightUnit;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * unit = [self paperHeightUnitModel];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPaperHeightUnit:
- (void)setPaperHeightUnit:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch(argument)
	{
		case 0: [self setPaperHeightUnitModel:@"bp"]; return;
		case 1: [self setPaperHeightUnitModel:@"pt"]; return;
		case 3: [self setPaperHeightUnitModel:@"cm"]; return;
		default: [self setPaperHeightUnitModel:@"in"]; return;
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  PostScript
MODEL_INT(generateEPSF, setGenerateEPSF, iTM2Dvips_generate_epsf);
MODEL_INT(printCropMark, setPrintCropMark, iTM2Dvips_print_crop_mark);
MODEL_BOOL(useHeader, setUseHeader, iTM2Dvips_USE_header);
MODEL_OBJECT(header, setHeader, iTM2Dvips_header);
MODEL_INT(removeIncludedComments, setRemoveIncludedComments, iTM2Dvips_remove_included_comments);
MODEL_INT(noStructuredComments, setNoStructuredComments, iTM2Dvips_no_structured_comments);
#pragma mark =-=-=-=-=-  Fonts
MODEL_INT(downloadOnlyNeededCharacters, setDownloadOnlyNeededCharacters, iTM2Dvips_download_only_needed_characters);
MODEL_BOOL(useMetaFontMode, setUseMetaFontMode, iTM2Dvips_USE_metafont_mode);
MODEL_OBJECT(metaFontMode, setMetaFontMode, iTM2Dvips_metafont_mode);
MODEL_INT(noAutomaticFontGeneration, setNoAutomaticFontGeneration, iTM2Dvips_no_automatic_font_generation);
MODEL_BOOL(usePSMapFiles, setUsePSMapFiles, iTM2Dvips_USE_psmap_files);
MODEL_OBJECT(PSMapFiles, setPSMapFiles, iTM2Dvips_psmap_files);
MODEL_BOOL(useResolution, setUseResolution, iTM2Dvips_USE_resolution);
MODEL_BOOL(bothResolutions, setBothResolutions, iTM2Dvips_both_resolutions);
MODEL_FLOAT(xResolution, setXResolution, iTM2Dvips_x_resolution);
MODEL_FLOAT(yResolution, setYResolution, iTM2Dvips_y_resolution);
MODEL_INT(downloadNonResidentFonts, setDownloadNonResidentFonts, iTM2Dvips_download_non_resident_fonts);
MODEL_INT(compressBitmapFonts, setCompressBitmapFonts, iTM2Dvips_compress_bitmap_fonts);
MODEL_INT(maximumDrift, setMaximumDrift, iTM2Dvips_maximum_drift);
MODEL_INT(shiftNonPrintingCharacters, setShiftNonPrintingCharacters, iTM2Dvips_shift_non_printing_characters);
#pragma mark =-=-=-=-=-  More
MODEL_BOOL(usePrinter, setUsePrinter, iTM2Dvips_USE_printer);
MODEL_OBJECT(printer, setPrinter, iTM2Dvips_printer);
MODEL_INT(noVirtualMemorySaving, setNoVirtualMemorySaving, iTM2Dvips_no_virtual_memory_saving);
MODEL_INT(passHTML, setPassHTML, iTM2Dvips_pass_html);
MODEL_BOOL(debug, setDebug, iTM2Dvips_debug);
MODEL_INT(debugLevel, setDebugLevel, iTM2Dvips_debug_level);
MODEL_INT(conserveMemory, setConserveMemory, iTM2Dvips_conserve_memory);
MODEL_INT(separateSections, setSeparateSections, iTM2Dvips_separate_sections);
MODEL_INT(numberOfPagesInSections, setNumberOfPagesInSections, iTM2Dvips_section_num_pages);
MODEL_BOOL(useOutput, setUseOutput, iTM2Dvips_USE_output);
MODEL_OBJECT(output, setOutput, iTM2Dvips_output);
MODEL_BOOL(useMoreArguments, setUseMoreArguments, iTM2Dvips_USE_more_arguments);
MODEL_OBJECT(moreArguments, setMoreArguments, iTM2Dvips_more_arguments);
@end

@implementation iTM2MainInstaller(dvipdfm)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DvipsCompleteInstallation
+ (void)iTM2DvipsCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2EngineDvips installBinary];
//iTM2_END;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2DvipsWrapperKit

#if 0
Option details
--------------


  Many of the parameterless options listed here can be turned off by
suffixing the option with a zero (`0'); for instance, to turn off page
reversal, use `-r0'.  Such options are marked with a trailing `*'.

`-'
     Read additional options from standard input after processing the
     command line.

`--help'
     Print a usage message and exit.

`--version'
     Print the version number and exit.

`-a*'
     Conserve memory by making three passes over the DVI file instead
     of two and only loading those characters actually used.  Generally
     only useful on machines with a very limited amount of memory, like
     some PCs.

`-A'
     Print only the odd pages.  This option uses TeX page numbers, not
     physical page numbers.

`-b NUM'
     Generate NUM copies of each page, but duplicating the page body
     rather than using the `/#copies' PostScript variable.  This can be
     useful in conjunction with a header file setting `bop-hook' to do
     color separations or other neat tricks.

`-B'
     Print only the even pages.  This option uses TeX page numbers, not
     physical page numbers.

`-c NUM'
     Generate NUM consecutive copies of every page, i.e., the output is
     uncollated.  This merely sets the builtin PostScript variable
     `/#copies'.

`-C NUM'
     Generate NUM copies, but collated (by replicating the data in the
     PostScript file).  Slower than the `-c' option, but easier on the
     hands, and faster than resubmitting the same PostScript file
     multiple times.

`-d NUM'
     Set the debug flags, showing what Dvips (thinks it) is doing.
     This will work unless Dvips has been compiled without the `DEBUG'
     option (not recommended).  Note: Debug options, for the possible
     values of NUM.  Use `-d -1' as the first option for maximum output.


`-D NUM'
     Set both the horizontal and vertical resolution to NUM, given in
     dpi (dots per inch). This affects the choice of bitmap fonts that
     are loaded and also the positioning of letters in resident
     PostScript fonts. Must be between 10 and 10000.  This affects both
     the horizontal and vertical resolution.  If a high resolution
     (something greater than 400 dpi, say) is selected, the `-Z' flag
     should probably also be used.  If you are using fonts made with
     Metafont, such as Computer Modern, `mktexpk' needs to know about
     the value for NUM that you use or Metafont will fail.  See the file
     <ftp://ftp.tug.org/tex/modes.mf> for a list of resolutions and mode
     names for most devices.

`-e NUM'
     Maximum drift in pixels of each character from its `true'
     resolution-independent position on the page. The default value of
     this parameter is resolution dependent (it is the number of
     entries in the list [100, 200, 300, 400, 500, 600, 800, 1000,
     1200, 1600, 2000, 2400, 2800, 3200, ...] that are less than or
     equal to the resolution in dots per inch). Allowing individual
     characters to `drift' from their correctly rounded positions by a
     few pixels, while regaining the true position at the beginning of
     each new word, improves the spacing of letters in words.

`-E*'
     Generate an EPSF file with a tight bounding box.  This only looks
     at marks made by characters and rules, not by any included
     graphics.  In addition, it gets the glyph metrics from the TFM
     file, so characters that print outside their enclosing TFM box may
     confuse it.  In addition, the bounding box might be a bit too
     loose if the character glyph has significant left or right side
     bearings.  Nonetheless, this option works well enough for creating
     small EPSF files for equations or tables or the like.  (Of course,
     Dvips output, especially when using bitmap fonts, is
     resolution-dependent and thus does not make very good EPSF files,
     especially if the images are to be scaled; use these EPSF files
     with care.)  For multiple page input files, also specify `-i' to
     get each page as a separate EPSF file; otherwise, all the pages
     are overlaid in the single output file.

`-f*'
     Run as a filter.  Read the DVI file from standard input and write
     the PostScript to standard output.  The standard input must be
     seekable, so it cannot be a pipe.  If your input must be a pipe,
     write a shell script that copies the pipe output to a temporary
     file and then points Dvips at this file.  This option also
     disables the automatic reading of the `PRINTER' environment
     variable; use `-P$PRINTER' after the `-f' to read it anyway.  It
     also turns off the automatic sending of control-D if it was turned
     on with the `-F' option or in the configuration file; use `-F'
     after the `-f' to send it anyway.

`-F*'
     Write control-D (ASCII code 4) as the very last character of the
     PostScript file.  This is useful when Dvips is driving the printer
     directly instead of working through a spooler, as is common on
     personal systems.  On systems shared by more than one person, this
     is not recommended.

`-G*'
     Shift non-printing characters (ASCII 0-32, 127) to higher-numbered
     positions.  This may be useful sometimes.


`-h NAME'
     Prepend NAME as an additional header file, or, if NAME is `-',
     suppress all header files.  Any definitions in the header file get
     added to the PostScript `userdict'.

`-i*'
     Make each section be a separate file; a "section" is a part of the
     document processed independently, most often created to avoid
     memory overflow.  The filenames are created replacing the suffix
     of the supplied output file name by a three-digit sequence number.
     This option is most often used in conjunction with the `-S'
     option which sets the maximum section length in pages; if `-i' is
     specified and `-S' is not, each page is output as a separate file.
     For instance, some phototypesetters cannot print more than ten or
     so consecutive pages before running out of steam; these options
     can be used to automatically split a book into ten-page sections,
     each to its own file.

`-j*'
     Download only needed characters from Type 1 fonts. This is the
     default in the current release.  Some debugging flags trace this
     operation (Note: Debug options).  You can also control partial
     downloading on a per-font basis (*note psfonts.map::).

`-k*'
     Print crop marks.  This option increases the paper size (which
     should be specified, either with a paper size special or with the
     `-T' option) by a half inch in each dimension.  It translates each
     page by a quarter inch and draws cross-style crop marks.  It is
     mostly useful with typesetters that can set the page size
     automatically.  This works by downloading `crop.pro'.


`-K*'
     Remove comments in included PostScript graphics, font files, and
     headers; only necessary to get around bugs in spoolers or
     PostScript post-processing programs.  Specifically, the `%%Page'
     comments, when left in, often cause difficulties.  Use of this
     flag can cause other graphics to fail, however, since the
     PostScript header macros from some software packages read portion
     the input stream line by line, searching for a particular comment.

`-l [=]NUM'
     The last page printed will be the first one numbered NUM. Default
     is the last page in the document.  If NUM is prefixed by an equals
     sign, then it (and the argument to the `-p' option, if specified)
     is treated as a physical (absolute) page number, rather than a
     value to compare with the TeX `\count0' values stored in the DVI
     file.  Thus, using `-l =9' will end with the ninth page of the
     document, no matter what the pages are actually numbered.

`-m*'
     Specify manual feed, if supported by the output device.

`-mode MODE'
     Use MODE as the Metafont device name for path searching and font
     generation.  This overrides any value from configuration files.
     With the default paths, explicitly specifying the mode also makes
     the program assume the fonts are in a subdirectory named MODE.
     Note: TeX directory structure.
     If Metafont does not understand the MODE name, see Note: Unable to
     generate fonts.


-M*'
     Turns off automatic font generation (`mktexpk').  If `mktexpk',
     the invocation is appended to a file `missfont.log' (by default)
     in the current directory.  You can then execute the log file to
     create the missing files after fixing the problem.  If the current
     directory is not writable and the environment variable or
     configuration file value `TEXMFOUTPUT' is set, its value is used.
     Otherwise, nothing is written.  The name `missfont.log' is
     overridden by the `MISSFONT_LOG' environment variable or
     configuration file value.

`-n NUM'
     Print at most NUM pages. Default is 100000.

`-N*'
     Turns off generation of structured comments such as `%%Page'; this
     may be necessary on some systems that try to interpret PostScript
     comments in weird ways, or on some PostScript printers.  Old
     versions of TranScript in particular cannot handle modern
     Encapsulated PostScript.  Beware: This also disables page
     movement, etc., in PostScript viewers such as Ghostview.


`-o NAME'
     Send output to the file NAME.  If `-o' is specified without NAME,
     the default is `FILE.ps' where the input DVI file was `FILE.dvi'.
     If `-o' isn't given at all, the configuration file default is used.

     If NAME is `-', output goes to standard output.  If the first
     character of NAME is `!' or `|', then the remainder will be used
     as an argument to `popen'; thus, specifying `|lpr' as the output
     file will automatically queue the file for printing as usual.
     (The MS-DOS version will print to the local printer device `PRN'
     when NAME is `|lpr' and a program by that name cannot be found.)

     `-o' disables the automatic reading of the `PRINTER' environment
     variable, and turns off the automatic sending of control-D.  See
     the `-f' option for how to override this.

`-O X-OFFSET,Y-OFFSET'
     Move the origin by X-OFFSET,Y-OFFSET, a comma-separated pair of
     dimensions such as `.1in,-.3cm' (Note: papersize special).  The
     origin of the page is shifted from the default position (of one
     inch down, one inch to the right from the upper left corner of the
     paper) by this amount.  This is usually best specified in the
     printer-specific configuration file.

     This is useful for a printer that consistently offsets output
     pages by a certain amount.  You can use the file `testpage.tex' to
     determine the correct value for your printer.  Be sure to do
     several runs with the same `O' value--some printers vary widely
     from run to run.

     If your printer offsets every other page consistently, instead of
     every page, your best recourse is to use `bop-hook' (Note:
     PostScript hooks).


`-p [=]NUM'
     The first page printed will be the first one numbered NUM. Default
     is the first page in the document.  If NUM is prefixed by an
     equals sign, then it (and the argument to the `-l' option, if
     specified) is treated as a physical (absolute) page number, rather
     than a value to compare with the TeX `\count0' values stored in the
     DVI file.  Thus, using `-p =3' will start with the third page of
     the document, no matter what the pages are actually numbered.

`-pp FIRST-LAST'
     Print pages FIRST through LAST; equivalent to `-p FIRST -l LAST',
     except that multiple `-pp' options accumulate, unlike `-p' and
     `-l'.  The `-' separator can also be `:'.

`-P PRINTER'
     Read the configuration file `config.PRINTER' (`PRINTER.cfg' on
     MS-DOS), which can set the output name (most likely `o |lpr
     -PPRINTER'), resolution, Metafont mode, and perhaps font paths and
     other printer-specific defaults.  It works best to put sitewide
     defaults in the one master `config.ps' file and only things that
     vary printer to printer in the `config.PRINTER' files; `config.ps'
     is read before `config.PRINTER'.

     If no `-P' or `-o' is given, the environment variable `PRINTER' is
     checked.  If that variable exists, and a corresponding
     `config.PRINTER' (`PRINTER.cfg' on MS-DOS) file exists, it is read.
     Note: Configuration file searching.

`-q*'
     Run quietly.  Don't chatter about pages converted, etc. to standard
     output; report no warnings (only errors) to standard error.

`-r*'
     Output pages in reverse order.  By default, page 1 is output first.

NSString * const iTM2Dvips_run_quietly = @"iTM2_dvips_run_quietly";//-q, -q0
//iTM2_dvips_reverse_page_order://-r, -r0
NSString * const iTM2Dvips_run_securely = @"iTM2_dvips_run_securely";//-R
//NSString * const iTM2Dvips_save_restore = @"iTM2_dvips_save_restore";//-s, -s0

`-R'
     Run securely.  This disables shell command execution in `\special'
     (via ``', Note: Dynamic creation of graphics) and config files
     (via the `E' option, Note: Configuration file commands), pipes as
     output files, and opening of any absolute filenames.

`-s*'
     Enclose the output in a global save/restore pair.  This causes the
     file to not be truly conformant, and is thus not recommended, but
     is useful if you are driving a deficient printer directly and thus
     don't care too much about the portability of the output to other
     environments.

`-S NUM'
     Set the maximum number of pages in each `section'.  This option is
     most commonly used with the `-i' option; see its description above
     for more information.


`-t PAPERTYPE'
     Set the paper type to PAPERTYPE, usually defined in one of the
     configuration files, along with the appropriate PostScript code to
     select it (Note: Config file paper sizes).  You can also specify
     a PAPERTYPE of `landscape', which rotates a document by 90
     degrees.  To rotate a document whose paper type is not the
     default, you can use the `-t' option twice, once for the paper
     type, and once for `landscape'.

`-T HSIZE,VSIZE'
     Set the paper size to (HSIZE,VSIZE), a comma-separated pair of
     dimensions such as `.1in,-.3cm' (Note: papersize special).  It
     overrides any paper size special in the DVI file.


`-u PSMAPFILE'
     Set PSMAPFILE to be the file that dvips uses for looking up
     PostScript font aliases.  If PSMAPFILE begins with a `+'
     character, then the rest of the name is used as the name of the
     map file, and the map file is appended to the list of map files
     (instead of replacing the list).  In either case, if the name has
     no extension, then `.map' is added at the end.

`-U*'
     Disable a PostScript virtual memory-saving optimization that
     stores the character metric information in the same string that is
     used to store the bitmap information.  This is only necessary when
     driving the Xerox 4045 PostScript interpreter, which has a bug
     that puts garbage on the bottom of each character.  Not
     recommended unless you must drive this printer.


`-v'
     Print the dvips version number and exit.

`-V*'
     Download non-resident PostScript fonts as bitmaps.  This requires
     use of `mtpk' or `gsftopk' or `pstopk' or some combination thereof
     to generate the required bitmap fonts; these programs are supplied
     with Dvips.  The bitmap must be put into `psfonts.map' as the
     downloadable file for that font.  This is useful only for those
     fonts for which you do not have real outlines, being downloaded to
     printers that have no resident fonts, i.e., very rarely.

`-x NUM'
     Set the x magnification ratio to NUM/1000. Overrides the
     magnification specified in the DVI file.  Must be between 10 and
     100000.  It is recommended that you use standard magstep values
     (1095, 1200, 1440, 1728, 2074, 2488, 2986, and so on) to help
     reduce the total number of PK files generated.  NUM may be a real
     number, not an integer, for increased precision.

`-X NUM'
     Set the horizontal resolution in dots per inch to NUM.

`-y NUM'
     Set the y magnification ratio to NUM/1000.  See `-x' above.

`-Y NUM'
     Set the vertical resolution in dots per inch to NUM.


`-z*'
     Pass `html' hyperdvi specials through to the output for eventual
     distillation into PDF.  This is not enabled by default to avoid
     including the header files unnecessarily, and use of temporary
     files in creating the output.  Note: Hypertext.

`-Z*'
     Compress bitmap fonts in the output file, thereby reducing the
     size of what gets downloaded.  Especially useful at high
     resolutions or when very large fonts are used.  May slow down
     printing, especially on early 68000-based PostScript printers.
     Generally recommend today, and can be enabled in the configuration
     file (Note: Configuration file commands).




Option summary
--------------

  Here is a handy summary of the options; it is printed out when you run
Dvips with no arguments or with the standard "--help" option.

     Usage: dvips [OPTION]... FILENAME[.dvi]
     a*  Conserve memory, not time      A   Print only odd (TeX) pages
     b # Page copies, for posters e.g.  B   Print only even (TeX) pages
     c # Uncollated copies              C # Collated copies
     d # Debugging                      D # Resolution
     e # Maxdrift value                 E*  Try to create EPSF
     f*  Run as filter                  F*  Send control-D at end
                                        G*  Shift low chars to higher pos.
     h f Add header file
     i*  Separate file per section
     j*  Download fonts partially
     k*  Print crop marks               K*  Pull comments from inclusions
     l # Last page
     m*  Manual feed                    M*  Don''t make fonts
     mode s Metafont device name
     n # Maximum number of pages        N*  No structured comments
     o f Output file                    O c Set/change paper offset
     p # First page                     P s Load config.$s
     pp l Print only pages listed
     q*  Run quietly
     r*  Reverse order of pages         R*  Run securely
     s*  Enclose output in save/restore S # Max section size in pages
     t s Paper format                   T c Specify desired page size
     u s PS mapfile                     U*  Disable string param trick
     v   Print version number and quit  V*  Send downloadable PS fonts as PK
     x # Override dvi magnification     X # Horizontal resolution
     y # Multiply by dvi magnification  Y # Vertical resolution
     z*  Hyper PS                       Z*  Compress bitmap fonts
         # = number   f = file   s = string  * = suffix, "0" to turn off
         c = comma-separated dimension pair (e.g., 3.2in,-32.1cm)
         l = comma-separated list of page ranges (e.g., 1-4,7-9)
#endif

