/*
//  list menu controller tutorial
//
//  @version Subversion: $Id: iTM2ObjectServer.m 287 2006-11-14 06:59:21Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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

#import "iTM2ObjectServer.h"

@implementation iTM2ObjectServer
static id _iTM2SharedObjectServer = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
    if (!_iTM2SharedObjectServer)
        _iTM2SharedObjectServer = [[NSMutableDictionary dictionary] retain];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableDictionary
+ (id)mutableDictionary;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTM2SharedObjectServer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectForType:key:
+ (id)objectForType:(id)type key:(id)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[[self.mutableDictionary objectForKey:type] objectForKey:key] objectForKey:@"address"] nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  typeEnumerator
+ (NSEnumerator *)typeEnumerator;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.mutableDictionary keyEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEnumeratorForType:
+ (NSEnumerator *)keyEnumeratorForType:(id)type;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.mutableDictionary objectForKey:type] keyEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectEnumeratorForType:
+ (NSEnumerator *)objectEnumeratorForType:(id)type;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [[self.mutableDictionary objectForKey:type] objectEnumerator];
    NSDictionary * D;
    while(D = E.nextObject)
        [MRA addObject:[[D objectForKey:@"address"] nonretainedObjectValue]];
    return MRA.objectEnumerator;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerObject:forType:key:retain:
+ (BOOL)registerObject:(id)argument forType:(id)type key:(id)key retain:(BOOL)yorn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"argument:%@,type:%@,key:%@,retain:%@",argument,type,key,(yorn?@"Y":@"N"));
	}
    NSMutableDictionary * MD = [self.mutableDictionary objectForKey:type];
    if (!MD)
    {
        MD = [NSMutableDictionary dictionary];
        [self.mutableDictionary setObject:MD forKey:type];
    }
    id old = [[[MD objectForKey:key] objectForKey:@"address"] nonretainedObjectValue];
    if (old == argument)
        return NO;
    [MD setObject:(yorn?
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithNonretainedObject:argument], @"address",
            argument, @"value", nil]:
        [NSDictionary dictionaryWithObject:[NSValue valueWithNonretainedObject:argument] forKey:@"address"])
            forKey: key];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unregisterObjectForType:key:
+ (void)unregisterObjectForType:(id)type key:(id)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(key != nil, @"Unexpected nil key");
    [[self.mutableDictionary objectForKey:type] removeObjectForKey:key];
//END4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ObjectServer

