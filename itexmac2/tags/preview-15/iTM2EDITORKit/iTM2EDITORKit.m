/*
//  iTM2EDITORKit.h
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Sun Jun 24 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "iTM2EDITORKit.h"

NSString * const iTM2EDITORInspectorMode = @"EDITOR";
NSString * const iTM2EDITORToolbarIdentifier = @"iTM2 EDITOR Toolbar: Tiger";

@implementation iTM2EDITORInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *) inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2EDITORInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void) windowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super windowDidLoad];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL) windowPositionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
@end

@implementation iTM2EDITOREditor
@end

@implementation iTM2EDITORWindow
@end

