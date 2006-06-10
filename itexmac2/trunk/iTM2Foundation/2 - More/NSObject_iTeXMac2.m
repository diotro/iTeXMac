/*
//  NSObject_iTeXMac2.m
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri May 31 2002.
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

#import "NSObject_iTeXMac2.h"

@interface NSObject(iTM2Scripting_Private)
- (NSRange) rangeValue;
- (unsigned) index;
- (unsigned) insertionIndex;
- (unsigned) intValue;
- (NSScriptObjectSpecifier *)startSpecifier;
- (NSScriptObjectSpecifier *)endSpecifier;
- (BOOL)validateUserInterfaceItem:(id <NSValidatedUserInterfaceItem>)anItem;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSObject(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSObject(iTeXMac2)
+ (Class) distantClass;
{
	return self;
}
- (Class) distantClass;
{
	iTM2_LOG(@"Returning %@", [self class]);
	return [self class];
}
+ (bool) isDistantClass;
{
	return YES;
}
- (bool) isDistantClass;
{
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  evaluatedPosition
- (unsigned) evaluatedPosition;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG;
    if([self respondsToSelector:@selector(insertionIndex)])
    {
        return [self insertionIndex];
    }
    else if([self respondsToSelector:@selector(index)])
    {
        return [self index];
    }
    else if([self respondsToSelector:@selector(intValue)])
    {
        return [self intValue];
    }
    else
        return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  evaluatedRange
- (NSRange) evaluatedRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG;
    if([self isKindOfClass:[NSRangeSpecifier class]])
    {
        unsigned start = [[self startSpecifier] evaluatedPosition];
        unsigned end = [[self endSpecifier] evaluatedPosition];
        return NSMakeRange(start, end - start);
    }
    else if([self respondsToSelector:@selector(rangeValue)])
    {
        return [self rangeValue];
    }
    else
        return NSMakeRange(NSNotFound, 0);
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSObject(iTeXMac2)

