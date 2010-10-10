/*
//  iTM2MorePasteboard.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Tue Mar 18 2003.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2MorePasteboard.h>


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSPasteboard
/*"Description forthcoming."*/
@implementation NSPasteboard(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  morePasteboardWithIndex:
+ (NSPasteboard *) morePasteboardWithIndex: (NSInteger) index;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Tue Mar 18 2003
To Do List:
"*/
{
//LOG4iTM3;
    static id names = nil;
    if(!names)
    {
        names = [[NSMutableArray alloc] initWithCapacity: self.morePasteboardCount];
        NSInteger idx;
        for(idx = 0; idx<self.morePasteboardCount;++idx)
            [names addObject: [NSString stringWithFormat: @"iTeXMac2#%iPBoard", idx]];
    }
    if((index>=0) && (index<names.count))
        return [self pasteboardWithName: [names objectAtIndex: index]];
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  morePasteboardCount
+ (NSInteger) morePasteboardCount;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Tue Mar 18 2003
To Do List:
"*/
{
//LOG4iTM3;
    #define NUMBER_OF_NAMES 5
    return NUMBER_OF_NAMES;
}
@end

@implementation NSTextView(iTM2PasteBoard)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moreCopy:
- (IBAction) moreCopy: (id) sender;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Tue Mar 18 2003
To Do List:
"*/
{
//LOG4iTM3;
    NSPasteboard * P = [NSPasteboard morePasteboardWithIndex: sender.tag];
    if(!P)
    {
        iTM2Beep();
        return;
    }
    [P declareTypes: self.writablePasteboardTypes owner: nil];
    [self writeSelectionToPasteboard: P types: self.writablePasteboardTypes];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moreCut:
- (IBAction) moreCut: (id) sender;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Tue Mar 18 2003
To Do List:
"*/
{
//LOG4iTM3;
    NSPasteboard * P = [NSPasteboard morePasteboardWithIndex: sender.tag];
    if(!P)
    {
        iTM2Beep();
        return;
    }
    [P declareTypes: self.writablePasteboardTypes owner: nil];
    [self writeSelectionToPasteboard: P types: self.writablePasteboardTypes];
    [self delete: self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  morePaste:
- (IBAction) morePaste: (id) sender;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Tue Mar 18 2003
To Do List:
"*/
{
//LOG4iTM3;
    NSPasteboard * P = [NSPasteboard morePasteboardWithIndex: sender.tag];
    if(!P)
    {
        iTM2Beep();
        return;
    }
    [self readSelectionFromPasteboard: P];
    return;
}
@end

@implementation iTM2MorePboardMenu
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  update
- (void) update;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.3: Tue Mar 18 2003
To Do List:
"*/
{
//LOG4iTM3;
    [super update];
    NSEnumerator * E = [self.itemArray objectEnumerator];
    NSMenuItem * MI;
    while(MI = E.nextObject)
    {
//NSLog(@"MI: %@", MI);
        SEL selector = MI.action;
//NSLog(@"NSStringFromSelector(selector): %@", NSStringFromSelector(selector));
        if((selector == @selector(moreCopy:)) || (selector == @selector(moreCut:)) || (selector == @selector(morePaste:)))
        {
            NSPasteboard * P = [NSPasteboard morePasteboardWithIndex: MI.tag];
            NSString * S = [P stringForType: NSStringPboardType];
            if(S.length > 64)
                S = [NSString stringWithFormat: @"%@...", [S substringWithRange: iTM3MakeRange(0, 60)]];
            [MI setTitle: [NSString stringWithFormat: @"  %i: %@", MI.tag, S]];
        }
        else if(selector == @selector(moreCopyMenuItem:))
        {
            NSInteger index = [self indexOfItem: MI] + 1;
            NSInteger tag = [NSPasteboard morePasteboardCount];
            while(tag>0)
                [[self insertItemWithTitle: @"" action: @selector(moreCopy:) keyEquivalent: @"" atIndex: index] setTag: --tag];
            MI.action = NULL;
            self.update;
        }
        else if(selector == @selector(moreCutMenuItem:))
        {
            NSInteger index = [self indexOfItem: MI] + 1;
            NSInteger tag = [NSPasteboard morePasteboardCount];
            while(tag>0)
                [[self insertItemWithTitle: @"" action: @selector(moreCut:) keyEquivalent: @"" atIndex: index] setTag: --tag];
            MI.action = NULL;
            self.update;
        }
        else if(selector == @selector(morePasteMenuItem:))
        {
            NSInteger index = [self indexOfItem: MI] + 1;
            NSInteger tag = [NSPasteboard morePasteboardCount];
            while(tag>0)
                [[self insertItemWithTitle: @"" action: @selector(morePaste:) keyEquivalent: @"" atIndex: index] setTag: --tag];
            MI.action = NULL;
            self.update;
        }
    }
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PasteBoardController

