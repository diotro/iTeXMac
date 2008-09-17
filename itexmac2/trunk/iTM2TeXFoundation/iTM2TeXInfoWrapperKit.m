/*
//
//  @version Subversion: $Id: iTM2InfoWrapperKit.m 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License,or any later version,modified by the addendum below.
//  This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not,write to the Free Software
//  Foundation,Inc.,59 Temple Place - Suite 330,Boston,MA 02111-1307,USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)")
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <iTM2TeXFoundation/iTM2TeXInfoWrapperKit.h>

@interface iTM2TeXProjectDocument(PRIVATE)
- (id)otherInfos;
- (id)mainInfos;
@end

@implementation iTM2TeXProjectDocument(Infos)

#pragma mark =-=-=-=-=-  TWS Support
NSString * const TWSMasterFileKey = @"main";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  realMasterFileKey
- (NSString *)realMasterFileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self mainInfos] infoForKeyPaths:TWSMasterFileKey,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  masterFileKey
- (NSString *)masterFileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [[self mainInfos] infoForKeyPaths:TWSMasterFileKey,nil];
	if([key isEqualToString:iTM2ProjectFrontDocumentKey])
	{
		// get the front most document of the project
		NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * W;
		while(W = [E nextObject])
		{
			NSDocument * D = [[W windowController] document];
			if(![D isEqual:self] && [[SPC projectForSource:D] isEqual:self])
			{
				return [self fileKeyForURL:[D fileURL]];
			}
		}
		return @"";
	}
	if([key length])
	{
		return key;
	}
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self fileKeys]];
	[Ks removeObject:[self fileKeyForURL:[self fileURL]]];
	if([Ks count] == 1)
	{
		NSString * fileKey = [Ks lastObject];
		[self setMasterFileKey:fileKey];
		return fileKey;
	}
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMasterFileKey:
- (void)setMasterFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileKey isEqualToString:iTM2ProjectFrontDocumentKey] || [self nameForFileKey:fileKey])
	{
		[[self mainInfos] setInfo:fileKey forKeyPaths:TWSMasterFileKey,nil];
		return;
	}
	iTM2_LOG(@"Only file name keys are authorized here, got %@ not in %@", fileKey, [self fileKeys]);
    return;
}
#pragma mark =-=-=-=-=-  INFO
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= commandInfos
- (id)commandInfos;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self otherInfos];
}

@end
