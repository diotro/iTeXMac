/*
//  iTM2PrintInfoController.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Sun Mar 17 2002.
//  Copyright (c) 2001 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2PrintInfoController.h>


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PrintInfoController
/*"Description forthcoming."*/
@implementation iTM2PrintInfoController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  accessoryView
- (NSView*) accessoryView;
/*"Lazy initializer, creates a window controller for "iTM2PageLayoutAccessoryView.nib" with the receiver as owner, then send a window message.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
    if(!_PLAV)
        [[[[NSWindowController alloc] initWithWindowNibName: @"iTM2PageLayoutAccessoryView" owner: self] autorelease] window];
    return _PLAV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAccessoryView:
- (void) setAccessoryView: (NSView *) argument;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
    if(argument && ![argument isKindOfClass: [NSView class]])
        [NSException raise: NSInvalidArgumentException format: @"%@ NSView argument expected: %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    [_PLAV autorelease];
    _PLAV = [argument retain];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  message
- (void) message;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
    return;
}

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PrintInfoController

