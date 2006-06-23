/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat May 24 2003.
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
//  Version history:(format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TreeNode

#import "iTM2TreeKit.h"
#define iTM2_DIAGNOSTIC
@implementation iTM2TreeNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
		[_Value autorelease];
		_Value = nil;
		[_Children autorelease];
		_Children = [[NSMutableArray array] retain];
		_Parent = nil;
		[self setParent:nil];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithParent:value:
- (id)initWithParent:(id)aParent value:(id)anObject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
		[self setValue:anObject];
		[_Children autorelease];
		_Children = [[NSMutableArray array] retain];
		[self setParent:aParent];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithParent:nonRetainedValue:
- (id)initWithParent:(id)aParent nonRetainedValue:(id)anObject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
		[self setNonRetainedValue:anObject];
		[_Children autorelease];
		_Children = [[NSMutableArray array] retain];
		[self setParent:aParent];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  automaticallyNotifiesObserversForKey:
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return ![theKey isEqualToString:@"value"]
		&& ![theKey isEqualToString:@"nonRetainedValue"]
		&& ![theKey isEqualToString:@"children"]
		&& [super automaticallyNotifiesObserversForKey:theKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	[self setParent:nil];
	[_Value autorelease];
	_Value = nil;
	[_NonRetainedValue autorelease];
	_NonRetainedValue = nil;
	NSEnumerator * E = [_Children objectEnumerator];
	id child;
	while(child = [E nextObject])
	{
		[_Children removeObject:child];
	}
	[_Children autorelease];
	_Children = nil;
	[super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  value
- (id)value;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    return _Value;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setValue:
- (void)setValue:(id)argument;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	if([_Value isEqual:argument])
	{
		return;
	}
	[self willChangeValueForKey:@"value"];
	[_Value autorelease];
	_Value = [argument retain];
	[self didChangeValueForKey:@"value"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nonRetainedValue
- (id)nonRetainedValue;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    return _NonRetainedValue;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNonRetainedValue:
- (void)setNonRetainedValue:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	if([_NonRetainedValue isEqual:argument])
	{
		return;
	}
	[self willChangeValueForKey:@"nonRetainedValue"];
	[_NonRetainedValue autorelease];
	_NonRetainedValue = [[NSValue valueWithNonretainedObject:argument] retain];
	[self didChangeValueForKey:@"nonRetainedValue"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  parent
- (id)parent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    return _Parent;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setParent
- (void)setParent:(id)aNode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	if(aNode != _Parent)
	{
		[self retain];
		[_Parent removeObjectFromChildren:self];
		_Parent = aNode;
		if([_Parent indexOfObjectInChildren:self] == NSNotFound)
		{
			[_Parent addObjectInChildren:self];
		}
		[self release];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfChildren
- (unsigned)countOfChildren;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    return [_Children count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCountOfChildren:
- (void)setCountOfChildren:(unsigned int) argument;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	while(argument < [self countOfChildren])
		[_Children removeLastObject];
	while(argument > [self countOfChildren])
		[_Children addObject:[NSNull null]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInChildrenAtIndex:
- (id)objectInChildrenAtIndex:(unsigned) index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    return index < [_Children count]? [_Children objectAtIndex:index]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indexOfObjectInChildren:
- (unsigned)indexOfObjectInChildren:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    return [_Children indexOfObject:anObject];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addObjectInChildren:
- (void)addObjectInChildren:(id)node;
/*"Description forthcoming.
The data model of the receiver is modified.
nil is returned when nothing is added, including when the key identifier is already in use.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	NSAssert1((!node || [node isKindOfClass:[iTM2TreeNode class]]), @"Bad node to be inserted; %@", node);
	NSIndexSet * IS = [NSIndexSet indexSetWithIndex:[_Children count]];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
    [_Children addObject:node];
	[node setParent:self];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildren:
- (void)removeObjectFromChildren:(id)anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	unsigned index = [_Children indexOfObject:anObject];
	if(index != NSNotFound)
	{
		NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
		[_Children removeObject:anObject];
		[anObject setParent:nil];
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inChildrenAtIndex:
- (void)insertObject:(id)node inChildrenAtIndex:(unsigned int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	NSAssert1((!node || [node isKindOfClass:[iTM2TreeNode class]]), @"Bad node to be inserted; %@", node);
	NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
	[_Children insertObject:node atIndex:index];
	[node setParent:self];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceObjectInChildrenAtIndex:withObject:
- (void)replaceObjectInChildrenAtIndex:(unsigned) index withObject:(id)node;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	NSAssert1((!node || [node isKindOfClass:[iTM2TreeNode class]]), @"Bad node to be inserted; %@", node);
	NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:IS forKey:@"children"];
	id object = [[_Children objectAtIndex:index] retain];
    [_Children replaceObjectAtIndex:index withObject:node];
	[object setParent:nil];
	[object autorelease];
	[node setParent:self];
	[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:IS forKey:@"children"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildrenAtIndex:
- (void)removeObjectFromChildrenAtIndex:(unsigned int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
    // implementation specific code
	NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
	id object = [[_Children objectAtIndex:index] retain];
	[_Children removeObjectAtIndex:index];
	[object setParent:nil];
	[object autorelease];
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInChildrenWithValue:
- (id)objectInChildrenWithValue:(id) anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.4: Sat May 24 2003
To Do List:
"*/
{
//iTM2_START;
	NSEnumerator * E = [_Children objectEnumerator];
	iTM2TreeNode * N = nil;
	if(anObject)
	{
		while(N = [E nextObject])
			if([[N value] isEqual:anObject])
				break;
	}
	else
	{
		while((N = [E nextObject]) && [N value])
			;
	}
    return N;
}
@end
