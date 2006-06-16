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

#import <iTM2TeXFoundation/iTM2LaTeXMKWrapperKit.h>

@implementation iTM2LaTeXMKWrapper
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+(void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
	iTM2_INIT_POOL;
//iTM2_START;
    [NSObject completeInstallationOf:self];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  completeInstallation
+(void)completeInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super completeInstallation];
    NSTask * T = [[[NSTask allocWithZone:[self zone]] init] autorelease];
    NSString * path = [[NSBundle bundleForClass:self] pathForAuxiliaryExecutable:@"bin/iTM2_Setup"];
    NSString * P = [[NSBundle bundleForClass:self] pathForAuxiliaryExecutable:@"bin/latexmk"];
    if([path length] && [P length])
    {
        [T setArguments: [NSArray arrayWithObjects:
                [[NSBundle bundleForClass:self] pathForAuxiliaryExecutable:@"bin/latexmk"], nil]];
                #warning you will have to copy other codes here?
        [T setLaunchPath:path];
        [T launch];
    }
    else
    {
        iTM2_LOG(@"Could not find a iTM2_Setup script or a latexmk script");
    }
//iTM2_END;
    return;
}
@end
