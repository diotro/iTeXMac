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

#import "iTM2PStoPDFWrapperKit.h"

NSString * const iTM2PStoPDF_USE_output = @"USE_output";// "0" (default) or "1"(bool)
NSString * const iTM2PStoPDF_output = @"output";//-o ""
NSString * const iTM2PStoPDF_write_to_log = @"write_to_log";//-l
NSString * const iTM2PStoPDF_progress_message = @"progress_message";// -p

@implementation iTM2EnginePStoPDF
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Engine_pstopdf4iTM3";
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
    return [NSArray arrayWithObjects:@"ps", @"eps", nil];
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
				[NSNumber numberWithBool:NO], iTM2PStoPDF_USE_output,
				@"", iTM2PStoPDF_output,
				[NSNumber numberWithBool:NO], iTM2PStoPDF_write_to_log,
				[NSNumber numberWithBool:NO], iTM2PStoPDF_progress_message,
					nil];
}
#pragma mark =-=-=-=-=-  PAGE SETUP
#define MODEL_BOOL(GETTER, SETTER, KEY)\
- (BOOL)GETTER;{return [[self infoForKeyPaths:KEY,nil] boolValue];}\
- (void)SETTER:(BOOL)yorn;{[self setInfo:[NSNumber numberWithBool:yorn] forKeyPaths:KEY,nil];return;}
#define MODEL_OBJECT(GETTER, SETTER, KEY)\
- (id)GETTER;{return [self infoForKeyPaths:KEY,nil];}\
- (void)SETTER:(id)argument;{[self setInfo:argument forKeyPaths:KEY,nil];return;}
#define MODEL_FLOAT(GETTER, SETTER, KEY)\
- (float)GETTER;{return [[self infoForKeyPaths:KEY,nil] floatValue];}\
- (void)SETTER:(float)argument;{[self setInfo:[NSNumber numberWithFloat:argument] forKeyPaths:KEY,nil];return;}
#define MODEL_INT(GETTER, SETTER, KEY)\
- (NSInteger)GETTER;{return [[self infoForKeyPaths:KEY,nil] integerValue];}\
- (void)SETTER:(NSInteger)argument;{[self setInfo:[NSNumber numberWithInteger:argument] forKeyPaths:KEY,nil];return;}
MODEL_BOOL(useOutput, setUseOutput, iTM2PStoPDF_USE_output);
MODEL_OBJECT(output, setOutput, iTM2PStoPDF_output);
MODEL_BOOL(writeToLog, setWriteToLog, iTM2PStoPDF_write_to_log);
MODEL_BOOL(progressMessage, setProgressMessage, iTM2PStoPDF_progress_message);
@end

@implementation iTM2MainInstaller(pstopdf)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PStoPDFCompleteInstallation4iTM3
+ (void)iTM2PStoPDFCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [iTM2EnginePStoPDF installBinary];
//END4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PStoPDFWrapperKit
#if 0
pstopdf(1)                BSD General Commands Manual               pstopdf(1)

NAME
     pstopdf -- convert PostScript input into a PDF document.

SYNOPSIS
     pstopdf [inputfile] [-o outname] [-l] [-p] [-i]

DESCRIPTION
     pstopdf is a tool to convert PostScript input data into a PDF document.
     The input data may come from a file or may be read from stdin. The PDF
     document is always written to a file. The name of the output PDF file is
     derived from the name of the input file or may be explicitly named using
     the -o option.

     Flags:

     -o outname
             The name of the output file to create. If an explicit file name
             is not supplied, the output file will be created in the current
             directory and named foo.pdf for an input file named foo.ps

     -i      Reads from stdin rather than a named input file. If the output
             file is not explicitly named and the input data comes from stdin
             the named output file will be stdin.pdf

     -l      Specifies that any messages generated during file conversion be
             written to a log file. For an output file named foo.pdf the gen-
             erated log file is foo.pdf.log rather than generated to stdout.
             If there are no messages, the log file is not generated.

     -p      Generates a simple progress message to stdout at the end of each
             page. Because conversion of complex or lengthy PostScript input
             can take time, it is sometimes useful to see that progress is
             being made. Progress messages are always written to stdout even
             when the -l (log file) option is specified.

EXAMPLES
     pstopdf inputfile.ps          Creates a PDF file named inputfile.pdf from
                                   the PostScript data in the input file
                                   inputfile.ps

     pstopdf -i -o outputfilename  Creates a PDF file named outputfilename
                                   from the PostScript data read from stdin.

Apple Computer, Inc.           October 10, 2005           Apple Computer, Inc.
#endif
