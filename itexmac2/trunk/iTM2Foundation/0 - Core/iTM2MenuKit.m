/*
//
//  @version Subversion: $Id$ 
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


#import <iTM2Foundation/iTM2MenuKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenu(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSMenu(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cleanSeparators
-(void)cleanSeparators;
/*"Extends the #{itemWithTitle:} to look down the menu hierarchy beginning from the receiver.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// clean heading separators
	int index = 0;
	while(index < [self numberOfItems])
	{
		if([[self itemAtIndex:index] isSeparatorItem])
		{
			[self removeItemAtIndex:index];
		}
		else
			break;
	}
	// clean successive separators
	BOOL wasSeparator = NO;
	++index;
	while(index < [self numberOfItems])
		if([[self itemAtIndex:index] isSeparatorItem])
		{
			if(wasSeparator)
			{
				[self removeItemAtIndex:index];
			}
			else
			{
				wasSeparator = YES;
				++index;
			}
		}
		else
		{
			wasSeparator = NO;
			++index;
		}
	// clean trailing separators
	index = [self numberOfItems];
	while((--index >= 0) && [[self itemAtIndex:index] isSeparatorItem])
		[self removeItemAtIndex:index];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithTitle:
-(id)deepItemWithTitle:(NSString *)aTitle;
/*"Extends the #{itemWithTitle:} to look down the menu hierarchy beginning from the receiver.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    static int depth=0;
    id result = nil;
    ++depth;
    if(depth<8)
    {
        NSEnumerator * enumerator = [[self itemArray] objectEnumerator];
        id item;
        while(item=[enumerator nextObject])
        {
            if([item submenu]!=nil)
            {
                result = [[item submenu] deepItemWithTitle:aTitle];
                if(result!=nil)
                    break;
            }
            else if([[item title] isEqualToString:aTitle])
            {
                result = item;
                break;
            }
        }
    }
    --depth;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= itemWithAction:
-(id)itemWithAction:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSEnumerator * enumerator = [[self itemArray] objectEnumerator];
    id item;
    while(item=[enumerator nextObject])
        if([item action] == aSelector)
            return item;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexOfItemWithAction:
-(int)indexOfItemWithAction:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    int index = [self numberOfItems];
    while(--index >=0) if([[self itemAtIndex:index] action] == aSelector) break;
    return index;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexOfItemWithTarget:
-(int)indexOfItemWithTarget:(id)aTarget;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    int index = [self numberOfItems];
    while(--index >=0) if([[[self itemAtIndex:index] target] isEqual:aTarget]) break;
    return index;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithAction:
-(id)deepItemWithAction:(SEL)aSelector;
/*"Extends the #{itemWithTitle:} to look down the menu hierarchy beginning from the receiver.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    static int depth = 0;
    id result = nil;
    ++depth;
    if(depth<32)
    {
        NSEnumerator * enumerator = [[self itemArray] objectEnumerator];
        id item;
        while(item=[enumerator nextObject])
        {
//NSLog(@"%@, %@", [item title], NSStringFromSelector([item action]));
            if([item hasSubmenu])
            {
                result = [[item submenu] deepItemWithAction:aSelector];
                if(result!=nil)
                    break;
            }
            if([item action] == aSelector)
            {
                result = item;
                break;
            }
        }
    }
    --depth;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithRepresentedObject:
-(id)deepItemWithRepresentedObject:(id)anObject;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Better management of the nil arg
"*/
{iTM2_DIAGNOSTIC;
    static int depth = 32;
    id result = nil;
    if(!anObject)
        [NSException raise:NSInvalidArgumentException format:@"%@ no nil argument.",
            __PRETTY_FUNCTION__];
    if((anObject) && (depth>0))
    {
		--depth;
        NSEnumerator * enumerator = [[self itemArray] objectEnumerator];
        id item;
        while(item = [enumerator nextObject])
        {
            if([item hasSubmenu])
            {
                if(result = [[item submenu] deepItemWithRepresentedObject:anObject])
                    break;
            }
            if([[item representedObject] isEqual:anObject])
            {
                result = item;
                break;
            }
        }
		++depth;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepItemWithKeyEquivalent:modifierMask:
-(id)deepItemWithKeyEquivalent:(NSString *)key modifierMask:(unsigned int)mask;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Better management of the nil arg
"*/
{iTM2_DIAGNOSTIC;
    static int depth = 32;
    id result = nil;
    if(depth>0)
    {
		--depth;
        NSEnumerator * enumerator = [[self itemArray] objectEnumerator];
        id item;
        while(item = [enumerator nextObject])
        {
            if([item hasSubmenu])
            {
                if(result = [[item submenu] deepItemWithKeyEquivalent:key modifierMask:mask])
                    break;
            }
            if([[item keyEquivalent] isEqual:key] && ([item keyEquivalentModifierMask] == mask))
            {
                result = item;
                break;
            }
        }
		++depth;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= itemWithRepresentedObject:
-(id)itemWithRepresentedObject:(id)anObject;
/*"Seeks the menu hierarchy beginning from the receiver, the first positive occurrence is returned.
Only items with no submenus are searched for.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSEnumerator * enumerator = [[self itemArray] objectEnumerator];
    id item = nil;
    while(item = [enumerator nextObject])
        if([[item representedObject] isEqual:anObject])
            break;
    return item;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isRootMenu
-(BOOL)isRootMenu;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return ([self supermenu] == nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rootMenu
-(NSMenu *)rootMenu;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSMenu * result = self;
	while(![result isRootMenu])
		result = [result supermenu];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deselectItemsWithAction:
-(void)deselectItemsWithAction:(SEL)anAction;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSEnumerator * enumerator = [[self itemArray] objectEnumerator];
    id item;
    while(item=[enumerator nextObject])
        if([item action] == anAction)
            [item setState:NSOffState];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeItemsWithAction:
-(void)removeItemsWithAction:(SEL)anAction;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    int index;
    while((index = [self indexOfItemWithAction:anAction]) != -1)
            [self removeItemAtIndex:index];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeItemsWithRepresentedObject:
-(void)removeItemsWithRepresentedObject:(id)anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    int index;
    while((index = [self indexOfItemWithRepresentedObject:anObject]) != -1)
            [self removeItemAtIndex:index];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepCopy
-(NSMenu *)deepCopy;
/*"Simply forwards a #{deepCopyWithZone:} to the receiver, with the receiver's zone as argument.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return [self deepCopyWithZone:[self zone]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepCopyWithZone:
-(NSMenu *)deepCopyWithZone:(NSZone *)aZone;
/*"The menu items are also copied, not only retained.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{iTM2_DIAGNOSTIC;
    NSMenu * result = [[[self class] allocWithZone:aZone] initWithTitle:[self title]];
    int index = 0;
    while(index < [[self itemArray] count])
    {
        NSMenuItem * MI5 = [self itemAtIndex:index];
        NSMenuItem * MI6 = [[[MI5 class] allocWithZone:aZone] initWithTitle:[MI5 title]
                                            action: [MI5 action] keyEquivalent:[MI5 keyEquivalent]];
        [MI6 setTarget:[MI5 target]];
        [MI6 setRepresentedObject:[MI5 representedObject]];
		if([MI5 hasSubmenu])
		{
			[MI6 setSubmenu:[[[MI5 submenu] deepCopyWithZone:aZone] autorelease]];
		}
        [result addItem:MI6];
        ++index;
        [MI6 release];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _MakeCellSizeSmall
-(void)_MakeCellSizeSmall;
/*"Use the deep variant unless your app will crash...
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{iTM2_DIAGNOSTIC;
    if (![self menuRepresentation])
        [self setMenuRepresentation:[[[NSMenuView alloc] initWithFrame:NSZeroRect] autorelease]];
    [[self menuRepresentation] setFont:[NSFont menuFontOfSize:[NSFont smallSystemFontSize]]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepMakeCellSizeSmall
-(void)deepMakeCellSizeSmall;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{iTM2_DIAGNOSTIC;
    NSEnumerator * E = [[self itemArray] objectEnumerator];
    NSMenuItem * MI;
    while(MI = [E nextObject])
        if([MI hasSubmenu])
            [[MI submenu] deepMakeCellSizeSmall];
    [self _MakeCellSizeSmall];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepEnableItems
-(void)deepEnableItems;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{iTM2_DIAGNOSTIC;
    NSEnumerator * E = [[self itemArray] objectEnumerator];
    NSMenuItem * MI;
    while(MI = [E nextObject])
        if([MI hasSubmenu])
            [[MI submenu] deepEnableItems];
        else if([MI action] != NULL)
        {
            [MI setEnabled:YES];
            if(![MI isEnabled]) {[MI setEnabled:YES];NSLog(@"%@ %@", [MI title], @"NO");}
        }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepSetTarget:
-(void)deepSetTarget:(id)aTarget;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: We should write a NSMenuItem category to implement the #{copy} method but it is worth doing it.
The cell is not copied. Better should be done.
"*/
{iTM2_DIAGNOSTIC;
    NSEnumerator * E = [[self itemArray] objectEnumerator];
    NSMenuItem * MI;
    while(MI = [E nextObject])
        if([MI hasSubmenu])
            [[MI submenu] deepSetTarget:aTarget];
        else if([MI action] != NULL)
            [MI setTarget:aTarget];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deepSetAutoenablesItems:
-(void)deepSetAutoenablesItems:(BOOL)aFlag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSEnumerator * E = [[self itemArray] objectEnumerator];
    NSMenuItem * MI;
    while(MI = [E nextObject])
        if([MI hasSubmenu])
            [[MI submenu] deepSetAutoenablesItems:aFlag];
    [self setAutoenablesItems:aFlag];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= hierarchicalMenuAtPath:action:target:
+(NSMenu *)hierarchicalMenuAtPath:(NSString *)aFullPath action:(SEL)aSelector target:(id)aTarget;
/*"Description Forthcoming. ".hidden" files compatible.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: retain?
"*/
{iTM2_DIAGNOSTIC;
    NSDictionary * D = [aFullPath length]?
        [[[[NSFileWrapper alloc] initWithPath:aFullPath] autorelease] fileWrappers]:nil;
    if(D)
    {
        NSMenu * result = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[NSString string]] autorelease];
        NSEnumerator * enumerator = [[[D allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * key;
        NSMutableArray * hiddenFiles = [NSMutableArray array];
        {
            NSString * dotHidden = [NSString stringWithContentsOfFile:
                [[aFullPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@".hidden"]];
            NSEnumerator * E = [[dotHidden componentsSeparatedByString:@"\n"] objectEnumerator];
            id object;
            while(object = [E nextObject])
                if([object isKindOfClass:[NSString class]] && [(NSString *)object length])
                    [hiddenFiles addObjectsFromArray:[object componentsSeparatedByString:@"\r"]];
        }
        while(key = [enumerator nextObject])
        {
            NSFileWrapper * FW = [[[D objectForKey:key] retain] autorelease];
            NSString * menuItemTitle = [FW preferredFilename];
            if((![menuItemTitle hasPrefix:@"."]) && ([hiddenFiles indexOfObject:menuItemTitle] == NSNotFound))
            {
                int recursionFireWall = 32;
                while([FW isSymbolicLink] && (recursionFireWall-->0))
                    FW = [[[NSFileWrapper alloc] initWithPath:[FW symbolicLinkDestination]] autorelease];
                NSString * P = [aFullPath stringByAppendingPathComponent:[FW preferredFilename]];
                if([FW isRegularFile])
                {
                    NSMenuItem * MI = [result addItemWithTitle:menuItemTitle action:aSelector
                                                    keyEquivalent: [NSString string]];
                    [MI setTarget:aTarget];
                    [MI setRepresentedObject:P];
                }
                else if([FW isDirectory])
                {
                    NSMenuItem * MI = [result addItemWithTitle:menuItemTitle action:NULL
                                                    keyEquivalent: [NSString string]];
                    if([[NSWorkspace sharedWorkspace] isFilePackageAtPath:P])
                    {
                        [MI setTarget:aTarget];
                        [MI setRepresentedObject:P];
                    }
                    else
                        [MI setSubmenu:[self hierarchicalMenuAtPath:P action:aSelector target:aTarget]];
                }
            }
        }
        return result;
    }
    else
        return nil;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenu(iTeXMac2)

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSMenuItem(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSMenuItem(iTM2Representation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedString
-(NSString *)representedString;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self representedObject];
    return [result isKindOfClass:[NSString class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedDictionary
-(NSDictionary *)representedDictionary;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self representedObject];
    return [result isKindOfClass:[NSDictionary class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compareUsingTitle:
-(NSComparisonResult)compareUsingTitle:(id)MI;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // assuming that they have windows as targets
    return [MI respondsToSelector:@selector(title)]? [[self title] compare:[MI title]]:NSOrderedDescending;
}
@end

@implementation NSCell(iTM2Representation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedString
-(NSString *)representedString;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self representedObject];
    return [result isKindOfClass:[NSString class]]? result:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= representedDictionary
-(NSDictionary *)representedDictionary;
/*"Description forthcoming
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self representedObject];
    return [result isKindOfClass:[NSDictionary class]]? result:nil;
}
@end
