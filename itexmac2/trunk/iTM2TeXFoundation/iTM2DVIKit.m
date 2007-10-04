/*
//
//  @version Subversion: $Id: iTM2DVIDocumentKit.m 553 2007-06-24 20:55:38Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import "iTM2DVIKit.h"
#import "iTM2TeXProjectDocumentKit.h"
#import "iTM2TeXProjectCommandKit.h"

NSString * const iTM2DVIDocumentType = @"TeX DeVice Independent";// beware, this MUST appear in the target file...
NSString * const iTM2XDVDocumentType = @"XeTeX DeVice independent";// beware, this MUST appear in the target file...

@implementation iTM2DVIDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
- (id)initWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorRef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{
		return [super initWithContentsOfURL:absoluteURL ofType:typeName error:outErrorRef];
	}
	NSString * path = [absoluteURL path];
	path = [path stringByDeletingPathExtension];
	path = [path stringByAppendingPathExtension:@"pdf"];
	NSURL * url = [NSURL fileURLWithPath:path];
	id result = [SDC documentForURL:url];
	if(result)
	{
		[self dealloc];
		return [result retain];
	}
	if([DFM fileExistsAtPath:path])
	{
		typeName = [SDC typeForContentsOfURL:url error:outErrorRef];
		self = [super initWithContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outErrorRef];
		return self;
	}
	if(result = [SDC documentForURL:absoluteURL])
	{
		[self dealloc];
		return [result retain];
	}
	if(self = [self init])
	{
		[self setFileURL:url];
		[self setFileType:typeName];
		path = [self fileName];
		iTM2TeXProjectDocument * TPD = [SPC projectForFileName:path];
		NSString * K = [TPD keyForFileName:path];
		[TPD setMasterFileKey:K];
		id performer = [iTM2TeXPCommandManager commandPerformerForName:@"Compile"];
		[performer performCommandForProject: TPD];
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeWindowControllers
- (void)makeWindowControllers;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self windowControllers] count])
	{
		return;
	}
	if(![self inspectorAddedWithMode:[iTM2DVIInspector inspectorMode]])
	{
		iTM2_LOG(@".........  Code inconsistency 1, report bug");
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateIfNeeded
- (void)updateIfNeeded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self needsToUpdate])
	{
		[super updateIfNeeded];
	}
//iTM2_END;
    return;
}
@end


@implementation iTM2DVIInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @".PDF Promise";// invisible
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return @"PDF";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroContext
- (NSString *)defaultMacroContext;
{
    return @"";
}
@end
