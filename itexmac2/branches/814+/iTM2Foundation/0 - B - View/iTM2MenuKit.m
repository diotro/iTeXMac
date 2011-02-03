/*
//
//  @version Subversion: $Id: iTM2MenuKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Sep 22 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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


#import "iTM2MenuKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenu(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSMenu(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cleanSeparators4iTM3
- (void)cleanSeparators4iTM3;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 11:22:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// clean heading separators
	while(self.numberOfItems && [[self itemAtIndex:ZER0] isSeparatorItem]) {
        [self removeItemAtIndex:ZER0];
    }
    //  The first item is not a separator
	//  Clean successive separators
	BOOL wasSeparator = NO;
	NSInteger index = 1;
	while(index < self.numberOfItems) {
		if ([[self itemAtIndex:index] isSeparatorItem]) {
			if (wasSeparator) {
				[self removeItemAtIndex:index];
			} else {
				wasSeparator = YES;
				++index;
			}
		} else {
			wasSeparator = NO;
			++index;
		}
    }
	//  clean trailing separators
	index = self.numberOfItems;
	while((index-- > ZER0) && [[self itemAtIndex:index] isSeparatorItem]) {
		[self removeItemAtIndex:index];
    }
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithTitle4iTM3:maxDepth:
- (id)deepItemWithTitle4iTM3:(NSString *)aTitle maxDepth:(NSUInteger) depth;
/*"Extends the #{itemWithTitle:} to look down the menu hierarchy beginning from the receiver.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 16:36:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSMenuItem * item = nil;
    if (depth) {
        --depth;
        for (item in self.itemArray) {
            if (item.hasSubmenu) {
                id subItem = [item.submenu deepItemWithTitle4iTM3:aTitle maxDepth:depth];
                if (subItem) {
                    return subItem;
                }
            }
            if ([item.title isEqualToString:aTitle]) {
                return item;
            }
        }
    } else {
        for (item in self.itemArray) {
            if ([item.title isEqualToString:aTitle]) {
                return item;
            }
        }
    }
    return item;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithTitle4iTM3:
- (id)deepItemWithTitle4iTM3:(NSString *)aTitle;
/*"Extends the #{itemWithTitle:} to look down the menu hierarchy beginning from the receiver.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 16:36:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [self deepItemWithTitle4iTM3:(NSString *)aTitle maxDepth:8];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= itemWithAction4iTM3:
- (id)itemWithAction4iTM3:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * item in self.itemArray) {
        if (item.action == aSelector) {
            return item;
        }
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexOfItemWithAction4iTM3:
- (NSInteger)indexOfItemWithAction4iTM3:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 16:38:34 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSInteger index = self.numberOfItems;
    while(--index >=ZER0) if ([[self itemAtIndex:index] action] == aSelector) break;
    return index;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexOfItemWithTarget4iTM3:
- (NSInteger)indexOfItemWithTarget4iTM3:(id)aTarget;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 16:38:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSInteger index = self.numberOfItems;
    while(--index >=ZER0) if ([[[self itemAtIndex:index] target] isEqual:aTarget]) break;
    return index;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithAction4iTM3:maxDepth:
- (id)deepItemWithAction4iTM3:(SEL)aSelector maxDepth:(NSUInteger)depth;
/*"Extends the #{itemWithAction:} to look down the menu hierarchy beginning from the receiver.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSMenuItem * item = nil;
    if (depth) {
        --depth;
        for (item in self.itemArray) {
            if (item.hasSubmenu) {
                id subItem = [item.submenu deepItemWithAction4iTM3:aSelector maxDepth:depth];
                if (subItem) {
                    return subItem;
                }
            }
            if (item.action == aSelector) {
                return item;
            }
        }
    } else {
        for (item in self.itemArray) {
            if (item.action == aSelector) {
                return item;
            }
        }
    }
    return item;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithAction4iTM3:
- (id)deepItemWithAction4iTM3:(SEL)aSelector;
/*"Extends the #{itemWithTitle:} to look down the menu hierarchy beginning from the receiver.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [self deepItemWithAction4iTM3:aSelector maxDepth:8];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithRepresentedObject4iTM3:maxDepth:
- (id)deepItemWithRepresentedObject4iTM3:(id)anObject maxDepth:(NSUInteger)depth;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 16:56:45 UTC 2010
To Do List: Better management of the nil arg
"*/
{DIAGNOSTIC4iTM3;
    NSParameterAssert(anObject!=nil);
    NSMenuItem * item = nil;
    if (depth) {
		--depth;
        for (item in self.itemArray) {
            if (item.hasSubmenu) {
                id subItem = [item.submenu deepItemWithRepresentedObject4iTM3:anObject maxDepth:depth];
                if (subItem) {
                    return subItem;
                }
            }
            if ([item.representedObject isEqual:anObject]) {
                return item;
            }
        }
    } else {
        for (item in self.itemArray) {
            if ([item.representedObject isEqual:anObject]) {
                return item;
            }
        }
    }
    return item;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithRepresentedObject4iTM3:
- (id)deepItemWithRepresentedObject4iTM3:(id)anObject;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 16:52:52 UTC 2010
To Do List: Better management of the nil arg
"*/
{DIAGNOSTIC4iTM3;
    return [self deepItemWithRepresentedObject4iTM3:anObject maxDepth:8];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithKeyEquivalent4iTM3:modifierMask:maxDepth:
- (id)deepItemWithKeyEquivalent4iTM3:(NSString *)key modifierMask:(NSUInteger)mask maxDepth:(NSUInteger)depth;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:02:41 UTC 2010
To Do List: Better management of the nil arg
"*/
{DIAGNOSTIC4iTM3;
    NSMenuItem * item = nil;
    if (depth>ZER0) {
		--depth;
        for (item in self.itemArray) {
            if (item.hasSubmenu) {
                id subItem = [item.submenu deepItemWithKeyEquivalent4iTM3:key modifierMask:mask maxDepth:depth];
                if (subItem) {
                    return subItem;
                }
            }
            if ([item.keyEquivalent isEqual:key] && (item.keyEquivalentModifierMask == mask)) {
                return item;
            }
        }
    } else {
        for (item in self.itemArray) {
            if ([item.keyEquivalent isEqual:key] && (item.keyEquivalentModifierMask == mask)) {
                return item;
            }
        }
    }
    return item;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithKeyEquivalent4iTM3:modifierMask:
- (id)deepItemWithKeyEquivalent4iTM3:(NSString *)key modifierMask:(NSUInteger)mask;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:02:36 UTC 2010
To Do List: Better management of the nil arg
"*/
{DIAGNOSTIC4iTM3;
    return [self deepItemWithKeyEquivalent4iTM3:key modifierMask:mask maxDepth:8];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= itemWithRepresentedObject4iTM3:
- (id)itemWithRepresentedObject4iTM3:(id)anObject;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:02:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * item in self.itemArray) {
        if ([item.representedObject isEqual:anObject]) {
            return item;
        }
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isRootMenu4iTM3
- (BOOL)isRootMenu4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:02:49 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return (self.supermenu == nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rootMenu4iTM3
- (NSMenu *)rootMenu4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:02:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	NSMenu * result = self;
	while (!result.isRootMenu4iTM3) {
		result = result.supermenu;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deselectItemsWithAction4iTM3:
- (void)deselectItemsWithAction4iTM3:(SEL)anAction;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:04:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * item in self.itemArray) {
        if (item.action == anAction) {
            item.state = NSOffState;
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeItemsWithAction4iTM3:
- (void)removeItemsWithAction4iTM3:(SEL)anAction;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:04:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSInteger index;
    while((index = [self indexOfItemWithAction4iTM3:anAction]) != -1) {
        [self removeItemAtIndex:index];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeItemsWithRepresentedObject4iTM3:
- (void)removeItemsWithRepresentedObject4iTM3:(id)anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:05:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSInteger index;
    while((index = [self indexOfItemWithRepresentedObject:anObject]) != -1) {
        [self removeItemAtIndex:index];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepCopy4iTM3
- (NSMenu *)deepCopy4iTM3;
/*"The menu items are also copied, not only retained.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Feb 20 17:12:20 UTC 2010
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{DIAGNOSTIC4iTM3;
    NSMenu * result = [[self.class alloc] initWithTitle:self.title];
    NSInteger index = ZER0;
    while(index < self.numberOfItems) {
        NSMenuItem * MI5 = [self itemAtIndex:index];
        NSMenuItem * MI6 = [[MI5.class alloc] initWithTitle:MI5.title
                                            action:MI5.action keyEquivalent:MI5.keyEquivalent];
        MI6.target = MI5.target;
        MI6.representedObject = MI5.representedObject;
        if (MI5.hasSubmenu) {
            MI6.submenu = MI5.submenu.deepCopy4iTM3;
		}
        [result addItem:MI6];
        ++index;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _MakeMennuItemsSmall4iTM3
- (void)_MakeMennuItemsSmall4iTM3;
/*"Use the deep variant unless your app will crash...
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 20:03:47 UTC 2010
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * MI in self.itemArray) {
        MI.attributedTitle = [[NSAttributedString alloc] initWithString:MI.title
            attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                [NSFont menuFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]],NSFontAttributeName,
                    nil]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepMakeMenuItemTitlesSmall4iTM3
- (void)deepMakeMenuItemTitlesSmall4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * MI in self.itemArray)
        if (MI.hasSubmenu)
            [MI.submenu deepMakeMenuItemTitlesSmall4iTM3];
    self._MakeMennuItemsSmall4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepEnableItems4iTM3
- (void)deepEnableItems4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * MI in self.itemArray)
        if ([MI hasSubmenu])
            [[MI submenu] deepEnableItems4iTM3];
        else if (MI.action != NULL)
        {
            [MI setEnabled:YES];
            if (![MI isEnabled]) {[MI setEnabled:YES];NSLog(@"%@ %@", MI.title, @"NO");}
        }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= Target4iTM3:
- (void)Target4iTM3:(id)aTarget;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * MI in self.itemArray)
        if ([MI hasSubmenu])
            [[MI submenu] Target4iTM3:aTarget];
        else if (MI.action != NULL)
            MI.target = aTarget;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= AutoenablesItems4iTM3:
- (void)AutoenablesItems4iTM3:(BOOL)aFlag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    for (NSMenuItem * MI in self.itemArray)
        if ([MI hasSubmenu])
            [[MI submenu] AutoenablesItems4iTM3:aFlag];
    [self setAutoenablesItems:aFlag];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= hierarchicalMenuAtPath4iTM3:action:target:
+ (NSMenu *)hierarchicalMenuAtPath4iTM3:(NSString *)aFullPath action:(SEL)aSelector target:(id)aTarget;
/*"Description Forthcoming. ".hidden" files compatible.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: retain?
"*/
{DIAGNOSTIC4iTM3;
    NSDictionary * D = aFullPath.length?
        [[[[NSFileWrapper alloc] initWithPath:aFullPath] autorelease] fileWrappers]:nil;
    if (D)
    {
        NSMenu * result = [[[NSMenu alloc] initWithTitle:[NSString string]] autorelease];
        NSEnumerator * enumerator = [[[D allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * key;
        NSMutableArray * hiddenFiles = [NSMutableArray array];
        {
            NSString * dotHidden = [NSString stringWithContentsOfFile:
                [aFullPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:@".hidden"] usedEncoding:nil error:nil];
            for (NSString * object in [dotHidden componentsSeparatedByString:@"\n"])
                if ([object isKindOfClass:[NSString class]] && [object length])
                    [hiddenFiles addObjectsFromArray:[object componentsSeparatedByString:@"\r"]];
        }
        while((key = enumerator.nextObject))
        {
            NSFileWrapper * FW = [[[D objectForKey:key] retain] autorelease];
            NSString * menuItemTitle = [FW preferredFilename];
            if ((![menuItemTitle hasPrefix:@"."]) && ([hiddenFiles indexOfObject:menuItemTitle] == NSNotFound))
            {
                NSInteger recursionFireWall = 32;
                while([FW isSymbolicLink] && (recursionFireWall-->ZER0))
                    FW = [[[NSFileWrapper alloc] initWithPath:[FW symbolicLinkDestination]] autorelease];
                NSString * P = [aFullPath stringByAppendingPathComponent:[FW preferredFilename]];
                if ([FW isRegularFile])
                {
                    NSMenuItem * MI = [result addItemWithTitle:menuItemTitle action:aSelector
                                                    keyEquivalent: [NSString string]];
                    MI.target = aTarget;
                    MI.representedObject = P;
                }
                else if ([FW isDirectory])
                {
                    NSMenuItem * MI = [result addItemWithTitle:menuItemTitle action:NULL
                                                    keyEquivalent: [NSString string]];
                    if ([[NSWorkspace sharedWorkspace] isFilePackageAtPath:P])
                    {
                        MI.target = aTarget;
                        MI.representedObject = P;
                    }
                    else
					{
						NSMenu * M = [self hierarchicalMenuAtPath4iTM3:P action:aSelector target:aTarget];
                        [MI setSubmenu:M];
					}
                }
            }
        }
        return result;
    }
    else
        return nil;
}
@end

#import "iTM2TextDocumentKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenu(iTeXMac2)

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenuItem(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSMenuItem(iTM2Representation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedString
- (NSString *)representedString;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = self.representedObject;
    return [result isKindOfClass:[NSString class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedDictionary
- (NSDictionary *)representedDictionary;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = self.representedObject;
    return [result isKindOfClass:[NSDictionary class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compareUsingTitle:
- (NSComparisonResult)compareUsingTitle:(NSMenuItem *)MI;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // assuming that they have windows as targets
    return [MI respondsToSelector:@selector(title)]? [self.title compare:MI.title]:NSOrderedDescending;
}
@end

@implementation NSCell(iTM2Representation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedString
- (NSString *)representedString;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = self.representedObject;
    return [result isKindOfClass:[NSString class]]? result:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedDictionary
- (NSDictionary *)representedDictionary;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = self.representedObject;
    return [result isKindOfClass:[NSDictionary class]]? result:nil;
}
@end
