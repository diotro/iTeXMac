/*
//
//  @version Subversion: $Id: iTM2TreeKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
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

#ifndef LOG4iTM3
	#define LOG4iTM3 NSLog
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TreeNode

#import "iTM2TreeKit.h"

#define DIAGNOSTIC4iTM3

@interface iTM2TreeNode()
@property (assign,readwrite) __strong NSArray * children;
@end

@implementation iTM2TreeNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:29:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
		self.value = nil;
		self.nonretainedValue = nil;
		self.children = nil;
		self.parent = nil;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithParent:value:
- (id <iTM2TreeNode>)initWithParent:(id <iTM2TreeNode>)aParent value:(id)anObject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = self.init) {
		self.value = anObject;
		self.parent = aParent;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithParent:
- (id <iTM2TreeNode>)initWithParent:(id <iTM2TreeNode>)aParent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = self.init) {
		self.value = [NSMutableDictionary dictionary];
		self.parent = aParent;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithParent:nonretainedValue:
- (id <iTM2TreeNode>)initWithParent:(id <iTM2TreeNode>)aParent nonretainedValue:(id)anObject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = self.init)) {
		self.nonretainedValue = anObject;
		self.parent = aParent;
	}
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  automaticallyNotifiesObserversForKey:
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey;
/*"Description Forthcoming.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return ![theKey isEqualToString:@"value"]
		&& ![theKey isEqualToString:@"nonretainedValue"]
		&& ![theKey isEqualToString:@"children"]
		&& [super automaticallyNotifiesObserversForKey:theKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  copy
- (id)copy;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - for 2.0: Sat May 24 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	id result = [[self.class alloc] initWithParent:nil value:self.value];
	[result setNonretainedValue:self.nonretainedValue];
	NSUInteger index = self.countOfChildren;
	while(index--)
	{
		id child = [self objectInChildrenAtIndex:index];
		[result insertObject:[child copy] inChildrenAtIndex:0];
	}
	//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  copyWithZone:
- (id)copyWithZone:(NSZone *)aZone;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - for 2.0: Sat May 24 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
	return self.copy;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setValue:
- (void)setValue:(id)argument;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	if ([iVarValue4iTM3 isEqual:argument]) {
		return;
	}
	[self willChangeValueForKey:@"value"];
	iVarValue4iTM3 = argument;
	[self didChangeValueForKey:@"value"];
    return;
}
@synthesize value=iVarValue4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNonretainedValue:
- (void)setNonretainedValue:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 16:06:16 UTC 2010
To Do List:
"*/
{
//START4iTM3;
	if ([iVarNonretainedValue4iTM3 isEqual:argument]) {
		return;
	}
	[self willChangeValueForKey:@"nonretainedValue"];
	iVarNonretainedValue4iTM3 = argument;
	[self didChangeValueForKey:@"nonretainedValue"];
    return;
}
@synthesize nonretainedValue=iVarNonretainedValue4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setParent
- (void)setParent:(id <iTM2TreeNode>)aNode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	if (aNode != iVarParent4iTM3) {
		[iVarParent4iTM3 removeObjectFromChildren:self];
		iVarParent4iTM3 = aNode;
		if ([iVarParent4iTM3 indexOfObjectInChildren:self] == (NSUInteger)NSNotFound) {
			[iVarParent4iTM3 addObjectInChildren:self];
		}
	}
    return;
}
@synthesize parent = iVarParent4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareChildren
- (void)prepareChildren;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iVarprepareChildren4iTM3
- (void)iVarprepareChildren4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	// reentrant management
	if (iVarFlags4iTM3&1>0)
	{
		return;
	}
	iVarFlags4iTM3|=1;
	self.prepareChildren;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  children
- (id)children;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
    return [iVarChildren4iTM3 copy];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfChildren
- (NSUInteger)countOfChildren;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
    return self.children.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCountOfChildren:
- (void)setCountOfChildren:(NSUInteger) argument;
/*"Description Forthcoming.
Default implementation returns the number of objects in the #{children} array.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	if (argument < self.countOfChildren) {
		do {
			[iVarChildren4iTM3 removeLastObject];
		} while(argument < self.countOfChildren);
	} else if (argument > self.countOfChildren) {
		if (!iVarChildren4iTM3) {
			iVarChildren4iTM3 = [[NSMutableArray array] retain];
		}
		do {
			[iVarChildren4iTM3 addObject:[NSNull null]];
		} while(argument > self.countOfChildren);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInChildrenAtIndex:
- (id <iTM2TreeNode>)objectInChildrenAtIndex:(NSUInteger) index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
    return index < self.children.count? [iVarChildren4iTM3 objectAtIndex:index]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indexOfObjectInChildren:
- (NSUInteger)indexOfObjectInChildren:(id <iTM2TreeNode>)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
    return iVarChildren4iTM3?[iVarChildren4iTM3 indexOfObject:anObject]:NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addObjectInChildren:
- (void)addObjectInChildren:(id <iTM2TreeNode>)node;
/*"Description forthcoming.
The data model of the receiver is modified.
nil is returned when nothing is added, including when the key identifier is already in use.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	NSAssert1((!node || [node isKindOfClass:[iTM2TreeNode class]]), @"Bad node to be inserted; %@", node);
	NSIndexSet * IS = [NSIndexSet indexSetWithIndex:self.children.count];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
	if (!iVarChildren4iTM3) {
		iVarChildren4iTM3 = [NSMutableArray array];
	}
    [iVarChildren4iTM3 addObject:node];
	[node setParent:self];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildren:
- (void)removeObjectFromChildren:(id <iTM2TreeNode>)anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	if (!iVarChildren4iTM3) {
		return;
	}
	NSUInteger index = [iVarChildren4iTM3 indexOfObject:anObject];
	if (index != (NSUInteger)NSNotFound) {
		NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
		[iVarChildren4iTM3 removeObject:anObject];
		anObject.parent=nil;
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inChildrenAtIndex:
- (void)insertObject:(id <iTM2TreeNode>)node inChildrenAtIndex:(NSUInteger)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:42:45 UTC 2010
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	NSAssert1((!node || [node isKindOfClass:[iTM2TreeNode class]]), @"Bad node to be inserted; %@", node);
	NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
	if (!iVarChildren4iTM3) {
		iVarChildren4iTM3 = [[NSMutableArray array] retain];
	}
	[iVarChildren4iTM3 insertObject:node atIndex:index];
	node.parent=self;
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:IS forKey:@"children"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceObjectInChildrenAtIndex:withObject:
- (void)replaceObjectInChildrenAtIndex:(NSUInteger) index withObject:(id <iTM2TreeNode>)node;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:42:37 UTC 2010
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	NSAssert1((!node || [node isKindOfClass:[iTM2TreeNode class]]), @"Bad node to be inserted; %@", node);
	iTM2TreeNode * object = [iVarChildren4iTM3 objectAtIndex:index];
	if (![object isEqual:node]) {
		NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
		[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:IS forKey:@"children"];
		[iVarChildren4iTM3 replaceObjectAtIndex:index withObject:node];
		object.parent = nil;
		node.parent = self;
		[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:IS forKey:@"children"];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromChildrenAtIndex:
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
    // implementation specific code
	self.iVarprepareChildren4iTM3;
	NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
	iTM2TreeNode * object = [iVarChildren4iTM3 objectAtIndex:index];
	object.parent = nil;
	[iVarChildren4iTM3 removeObjectAtIndex:index];
	[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:IS forKey:@"children"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInChildrenWithValue:
- (id <iTM2TreeNode>)objectInChildrenWithValue:(id) anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:39:23 UTC 2010
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	iTM2TreeNode * N = nil;
	if (anObject) {
		for(N in self.children) {
			if ([N.value isEqual:anObject]) {
				break;
			}
		}
	} else {
		for(N in iVarChildren4iTM3) {
			if (!N.value) {
				break;
			}
		}
	}
    return N;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInChildrenWithNonretainedValue:
- (id <iTM2TreeNode>)objectInChildrenWithNonretainedValue:(id) anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:41:42 UTC 2010
To Do List:
"*/
{
	//START4iTM3;
	self.iVarprepareChildren4iTM3;
	iTM2TreeNode * N = nil;
	if (anObject) {
		for (N in self.children) {
			if ([N.nonretainedValue isEqual:anObject]) {
				break;
			}
		}
	} else {
		for (N in self.children) {
			if (!N.nonretainedValue) {
				break;
			}
		}
	}
    return N;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  deepObjectInChildrenWithValue:
- (id <iTM2TreeNode>)deepObjectInChildrenWithValue:(id) anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:41:34 UTC 2010
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	iTM2TreeNode * N = [self objectInChildrenWithValue:anObject];
	if (N) {
		return N;
	}
	for (N in self.children) {
		if (N = [N deepObjectInChildrenWithValue:anObject]) {
			break;// no return here due to a problem with intel gcc, unconfirmed
		}
	}
    return N;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  deepObjectInChildrenWithNonretainedValue:
- (id <iTM2TreeNode>)deepObjectInChildrenWithNonretainedValue:(id) anObject;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:41:10 UTC 2010
To Do List:
"*/
{
	//START4iTM3;
	self.iVarprepareChildren4iTM3;
	iTM2TreeNode * N = [self objectInChildrenWithNonretainedValue:anObject];
	if (N) {
		return N;
	}
	for (N in self.children) {
		if (N = [N deepObjectInChildrenWithNonretainedValue:anObject]) {
			break;// no return here due to a problem with intel gcc, unconfirmed
		}
	}
    return N;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInChildrenWithValue:forKeyPath:
- (id <iTM2TreeNode>)objectInChildrenWithValue:(id) anObject forKeyPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 15:40:42 UTC 2010
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	iTM2TreeNode * N = nil;
	if (anObject) {
		for(N in self.children) {
			if ([[N valueForKeyPath:path] isEqual:anObject]) {
				break;// no return here due to a problem with intel gcc, unconfirmed
            }
        }
	} else {
		for(N in self.children) {
			if (![N valueForKeyPath:path]) {
				break;// no return here due to a problem with intel gcc, unconfirmed
            }
        }
	}
    return N;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  deepObjectInChildrenWithValue:forKeyPath:
- (id <iTM2TreeNode>)deepObjectInChildrenWithValue:(id) anObject forKeyPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Sat May 24 2003
To Do List:
"*/
{
//START4iTM3;
	self.iVarprepareChildren4iTM3;
	iTM2TreeNode * N = [self objectInChildrenWithValue:anObject forKeyPath:path];
	if (N) {
		return N;
	}
	for(N in iVarChildren4iTM3) {
		if (N = [N deepObjectInChildrenWithValue:anObject forKeyPath:path]) {
			break;// no return here due to a problem with intel gcc, unconfirmed
		}
	}
    return N;
}
- (id <iTM2TreeNode>)nextSibling;
{
	iTM2TreeNode * myParent = self.parent;
	NSUInteger index = [myParent indexOfObjectInChildren:self];
	if (++index<[myParent countOfChildren]) {
		return [myParent objectInChildrenAtIndex:index];
	}
	return nil;
}
- (id <iTM2TreeNode>)nextParentSibling;
{
	self = self.parent;
	return self.nextSibling?:self.nextParentSibling;
}
- (id <iTM2TreeNode>)nextNode;
{
	if (self.countOfChildren) {
		return [self objectInChildrenAtIndex:0];
	}
	return self.nextSibling?:self.nextParentSibling;
}
- (NSIndexPath *)indexPath;
{
	id myParent = self.parent;
	NSIndexPath * IP = [myParent indexPath];
	if (myParent) {
		NSUInteger index = [myParent indexOfObjectInChildren:self];
		IP = IP?[IP indexPathByAddingIndex:index]:[NSIndexPath indexPathWithIndex:index];
	}
	return IP;
}
@synthesize children=iVarChildren4iTM3;
@synthesize flags=iVarFlags4iTM3;
@end

/*!
    @class       iTM2PatriciaNode 
    @superclass  NSObject
    @abstract    This is the data model for the patricia tree node
    @discussion  All instance variables are public to gain efficiency
			But you are not authorized to do whatever you want with these.
			No public method is defined by this class: this is just a placeholder.
			The main object is the iTM2PatriciaController.
*/
@interface iTM2PatriciaNode: NSObject
{
@public
    NSUInteger countOfCharacters;
    unichar * characters;
    NSUInteger countOfChildren;
    id * children;
	id representedObject;
}
- (NSXMLElement *)XMLElement;
- (id)initWithXMLElement:(NSXMLElement *)element;
@property NSUInteger countOfCharacters;
@property unichar * characters;
@property NSUInteger countOfChildren;
@property id * children;
@property (retain) id representedObject;
@end

/*!
    @class       iTM2PatriciaLeafNode
    @superclass  iTM2PatriciaNode
    @abstract    A patricia leaf node ends a registered word/expression 
    @discussion  for tool, toolbar and toolbox, both correspond to a patricia leaf node
		for battle and battling, both are patricia leaf node but there is an intermediate node corresponding to "battl" which is just a patricia node
*/
@interface iTM2PatriciaLeafNode: iTM2PatriciaNode
@end

@implementation iTM2PatriciaNode
@synthesize countOfCharacters;
@synthesize characters;
@synthesize countOfChildren;
@synthesize children;
@synthesize representedObject;

- (id)init;
{
	if ((self = [super init])) {
		countOfCharacters = 0;
		characters = nil;
		countOfChildren = 0;
		children = nil;
	}
	return self;
}
- (id)initWithXMLElement:(NSXMLElement *)element;
{
	if ((self = self.init)) {
		NSXMLNode * child = nil;
		NSString * s = nil;
		NSUInteger index = 0;
		if ([[element name] isEqual:@"L"]) {
			object_setClass(self,[iTM2PatriciaLeafNode class]);
        }
		if (countOfChildren = [element childCount]) {
			// the first child is expected to be a text node
			child = [element childAtIndex:index];
			if ([child kind] == NSXMLTextKind) {
				s = [child stringValue];
				countOfCharacters = s.length;
				if (countOfCharacters) {
					characters = (unichar *)NSAllocateCollectable(countOfCharacters*sizeof(unichar),1);
					[s getCharacters:characters];
//NSLog(@"%@:%@",[element name],s);
				}
				--countOfChildren;
				children = NSAllocateCollectable(countOfChildren*sizeof(id),0);
				while (index<countOfChildren) {
//NSLog(@"index:%u",index);
					child = [element childAtIndex:index+1];
					children[index] = [[iTM2PatriciaNode alloc] initWithXMLElement:(NSXMLElement *)child];
					++index;
				}
			} else {
				children = NSAllocateCollectable(countOfChildren*sizeof(id),0);
				do
				{
//NSLog(@"index:%u",index);
					child = [element childAtIndex:index];
					children[index] = [[iTM2PatriciaNode alloc] initWithXMLElement:(NSXMLElement *)child];
				}
				while(++index<countOfChildren);
			}
		}
	}
	return self;
}

- (void)finalize;
{
	countOfCharacters = 0;
	countOfChildren = 0;
	[super finalize];
	return;
}
- (NSXMLElement *)XMLElement;
{
	NSString * S = [NSString stringWithCharacters:self->characters length:self->countOfCharacters];
	NSXMLElement * element = [NSXMLNode elementWithName:@"N" stringValue:S];
	NSUInteger index;
	for(index=0;index<countOfChildren;++index)
	{
		NSXMLElement * child = [children[index] XMLElement];
		[element addChild:child];
	}
	return element;
}
@end

@implementation iTM2PatriciaLeafNode
- (NSXMLElement *)XMLElement;
{
	NSXMLElement * element = [super XMLElement];
	[element setName:@"R"];
	NSString * S = [NSString stringWithCharacters:self->characters length:self->countOfCharacters];
	return [NSXMLNode elementWithName:@"L" stringValue:S];
}
@end

@interface iTM2PatriciaController(PRIVATE)

- (NSArray *)stringListOfNode:(iTM2PatriciaNode *)node withPrefix:(NSString *)prefix;
- (NSArray *)stringListOfChildrenOfNode:(iTM2PatriciaNode *)node withPrefix:(NSString *)prefix;

@end

@implementation iTM2PatriciaController
#if 0
+ (void)initialize;
{
	NSAutoreleasePool * P = [[NSAutoreleasePool alloc] init];
	iTM2RedirectNSLogOutput();

#if 1
	iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
	[PC addString:@"Home"];
	[PC addString:@"HReference"];
	[PC addString:@"HLibrary"];
	[PC addString:@"HOGuides"];
	[PC addString:@"HOTools"];
	NSURL * url = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"COMPLETION.xml"]];
	[PC writeToURL:url error:nil];
	NSLog(@"OU");
#endif

#if 0
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"a"];
		[PC addString:@"b"];
		[PC addString:@"c"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"b"];
		[PC addString:@"a"];
		[PC addString:@"c"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"b"];
		[PC addString:@"c"];
		[PC addString:@"a"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"a"];
		[PC addString:@"c"];
		[PC addString:@"b"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"c"];
		[PC addString:@"a"];
		[PC addString:@"b"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"c"];
		[PC addString:@"b"];
		[PC addString:@"a"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"a"];
		[PC addString:@"ab"];
		[PC addString:@"abc"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"a"];
		[PC addString:@"abc"];
		[PC addString:@"ab"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"ab"];
		[PC addString:@"abc"];
		[PC addString:@"a"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"ab"];
		[PC addString:@"a"];
		[PC addString:@"abc"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"abc"];
		[PC addString:@"a"];
		[PC addString:@"ab"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"abc"];
		[PC addString:@"ab"];
		[PC addString:@"a"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"abd"];
		[PC addString:@"abc"];
		LOG4iTM3(@"%@",[PC stringList]);
		[PC addString:@"ab"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
#endif
#if 0
	iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
	[PC addString:@"Home"];
	[PC addString:@"HReference"];
	[PC addString:@"HLibrary"];
	[PC addString:@"HOGuides"];
	[PC addString:@"HOTools"];
	NSUInteger index = 100000;
	while(index--)
	{
		NSAutoreleasePool * P = [[NSAutoreleasePool alloc] init];
		LOG4iTM3(@"---------- %i",index);
		[PC addString:@"HLiff"];
		[PC removeString:@"HLiff"];
		[P drain];
	}
#endif
#if 0
	NSUInteger index = 100000;
	while(index--)
	{
		NSAutoreleasePool * P = [[NSAutoreleasePool alloc] init];
		LOG4iTM3(@"---------- %i",index);
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
#if 1
		[PC addString:@"Home"];
		[PC addString:@"Reference"];
		[PC addString:@"Library"];
		[PC addString:@"Guides"];
		[PC addString:@"Tools"];
		[PC addString:@"Xcode"];
		[PC addString:@"Xcode"];
		[PC addString:@"2.3"];
		[PC addString:@"User"];
		[PC addString:@"Guide"];
		[PC addString:@"Targets"];
		[PC addString:@"Show"];
		[PC addString:@"TOC	<"];
		[PC addString:@"Previous"];
		[PC addString:@"PageNext"];
		[PC addString:@"Page"];
		[PC addString:@"Creating"];
		[PC addString:@"Targets"];
		[PC addString:@"When"];
		[PC addString:@"you"];
		[PC addString:@"create"];
		[PC addString:@"a"];
		[PC addString:@"new"];
		[PC addString:@"project"];
		[PC addString:@"from"];
		[PC addString:@"one"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"Xcode"];
		[PC addString:@"project"];
		[PC addString:@"templates,"];
		[PC addString:@"Xcode"];
		[PC addString:@"automatically"];
		[PC addString:@"creates"];
		[PC addString:@"a"];
		[PC addString:@"target"];
		[PC addString:@"for"];
		[PC addString:@"you."];
		[PC addString:@"If,"];
		[PC addString:@"however,"];
		[PC addString:@"your"];
		[PC addString:@"project"];
		[PC addString:@"needs"];
		[PC addString:@"to"];
		[PC addString:@"contain"];
		[PC addString:@"more"];
		[PC addString:@"than"];
		[PC addString:@"one"];
		[PC addString:@"because"];
		[PC addString:@"you"];
		[PC addString:@"are"];
		[PC addString:@"creating"];
		[PC addString:@"more"];
		[PC addString:@"than"];
		[PC addString:@"one"];
		[PC addString:@"can"];
		[PC addString:@"also"];
		[PC addString:@"add"];
		[PC addString:@"new"];
		[PC addString:@"targets"];
		[PC addString:@"to"];
		[PC addString:@"an"];
		[PC addString:@"existing"];
		[PC addString:@"project."];
		[PC addString:@"This"];
		[PC addString:@"section"];
		[PC addString:@"shows"];
		[PC addString:@"you"];
		[PC addString:@"how"];
		[PC addString:@"to:"];
		[PC addString:@"Create"];
		[PC addString:@"a"];
		[PC addString:@"new"];
		[PC addString:@"target"];
		[PC addString:@"Duplicate"];
		[PC addString:@"an"];
		[PC addString:@"existing"];
		[PC addString:@"target"];
		[PC addString:@"Remove"];
		[PC addString:@"unused"];
		[PC addString:@"targets"];
		[PC addString:@"from"];
		[PC addString:@"the"];
		[PC addString:@"project"];
		[PC addString:@"In"];
		[PC addString:@"this"];
		[PC addString:@"section:"];
		[PC addString:@"Creating"];
		[PC addString:@"a"];
		[PC addString:@"Target"];
		[PC addString:@"Special"];
		[PC addString:@"Types"];
		[PC addString:@"of"];
		[PC addString:@"Targets"];
		[PC addString:@"Duplicating"];
		[PC addString:@"a"];
		[PC addString:@"Target"];
		[PC addString:@"Removing"];
		[PC addString:@"a"];
		[PC addString:@"Target"];
		[PC addString:@"Creating"];
		[PC addString:@"a"];
		[PC addString:@"Target"];
		[PC addString:@"If"];
		[PC addString:@"you"];
		[PC addString:@"are"];
		[PC addString:@"adding"];
		[PC addString:@"new"];
		[PC addString:@"targets"];
		[PC addString:@"to"];
		[PC addString:@"your"];
		[PC addString:@"project,"];
		[PC addString:@"chances"];
		[PC addString:@"are"];
		[PC addString:@"already"];
		[PC addString:@"made"];
		[PC addString:@"a"];
		[PC addString:@"number"];
		[PC addString:@"of"];
		[PC addString:@"decisions"];
		[PC addString:@"about"];
		[PC addString:@"product"];
		[PC addString:@"type,"];
		[PC addString:@"programming"];
		[PC addString:@"language,"];
		[PC addString:@"and"];
		[PC addString:@"framework."];
		[PC addString:@"Xcode"];
		[PC addString:@"provides"];
		[PC addString:@"a"];
		[PC addString:@"number"];
		[PC addString:@"of"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"to"];
		[PC addString:@"support"];
		[PC addString:@"your"];
		[PC addString:@"choices."];
		[PC addString:@"The"];
		[PC addString:@"selection"];
		[PC addString:@"of"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"is"];
		[PC addString:@"similar"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"selection"];
		[PC addString:@"of"];
		[PC addString:@"project"];
		[PC addString:@"templates."];
		[PC addString:@"The"];
		[PC addString:@"target"];
		[PC addString:@"specifies"];
		[PC addString:@"the"];
		[PC addString:@"product"];
		[PC addString:@"type,"];
		[PC addString:@"a"];
		[PC addString:@"list"];
		[PC addString:@"of"];
		[PC addString:@"default"];
		[PC addString:@"build"];
		[PC addString:@"phases,"];
		[PC addString:@"and"];
		[PC addString:@"default"];
		[PC addString:@"specifications"];
		[PC addString:@"for"];
		[PC addString:@"some"];
		[PC addString:@"build"];
		[PC addString:@"settings."];
		[PC addString:@"A"];
		[PC addString:@"target"];
		[PC addString:@"template"];
		[PC addString:@"typically"];
		[PC addString:@"includes"];
		[PC addString:@"all"];
		[PC addString:@"build"];
		[PC addString:@"settings"];
		[PC addString:@"and"];
		[PC addString:@"build"];
		[PC addString:@"phases"];
		[PC addString:@"required"];
		[PC addString:@"to"];
		[PC addString:@"build"];
		[PC addString:@"a"];
		[PC addString:@"basic"];
		[PC addString:@"instance"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"specified"];
		[PC addString:@"product."];
		[PC addString:@"Unlike"];
		[PC addString:@"the"];
		[PC addString:@"project"];
		[PC addString:@"templates"];
		[PC addString:@"provided"];
		[PC addString:@"by"];
		[PC addString:@"Xcode,"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"do"];
		[PC addString:@"not"];
		[PC addString:@"specify"];
		[PC addString:@"any"];
		[PC addString:@"default"];
		[PC addString:@"files;"];
		[PC addString:@"you"];
		[PC addString:@"must"];
		[PC addString:@"add"];
		[PC addString:@"files"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"yourself,"];
		[PC addString:@"as"];
		[PC addString:@"described"];
		[PC addString:@"in"];
		[PC addString:@"Working"];
		[PC addString:@"With"];
		[PC addString:@"Files"];
		[PC addString:@"in"];
		[PC addString:@"a"];
		[PC addString:@"Target."];
		[PC addString:@"Note:"];
		[PC addString:@"New"];
		[PC addString:@"targets"];
		[PC addString:@"created"];
		[PC addString:@"with"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"have"];
		[PC addString:@"no"];
		[PC addString:@"framework"];
		[PC addString:@"references."];
		[PC addString:@"Any"];
		[PC addString:@"frameworks"];
		[PC addString:@"or"];
		[PC addString:@"libraries"];
		[PC addString:@"that"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"is"];
		[PC addString:@"configured"];
		[PC addString:@"to"];
		[PC addString:@"link"];
		[PC addString:@"with"];
		[PC addString:@"are"];
		[PC addString:@"added"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"Other"];
		[PC addString:@"Linker"];
		[PC addString:@"Flags"];
		[PC addString:@"build"];
		[PC addString:@"setting."];
		[PC addString:@"You"];
		[PC addString:@"can"];
		[PC addString:@"add"];
		[PC addString:@"framework"];
		[PC addString:@"references"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"yourself,"];
		[PC addString:@"as"];
		[PC addString:@"described"];
		[PC addString:@"in"];
		[PC addString:@"Figure"];
		[PC addString:@"24-9."];
		[PC addString:@"You"];
		[PC addString:@"can"];
		[PC addString:@"create"];
		[PC addString:@"a"];
		[PC addString:@"new"];
		[PC addString:@"target"];
		[PC addString:@"and"];
		[PC addString:@"add"];
		[PC addString:@"it"];
		[PC addString:@"to"];
		[PC addString:@"an"];
		[PC addString:@"existing"];
		[PC addString:@"project"];
		[PC addString:@"in"];
		[PC addString:@"either"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"following"];
		[PC addString:@"ways:"];
		[PC addString:@"Choose"];
		[PC addString:@"Project"];
		[PC addString:@"New"];
		[PC addString:@"Target."];
		[PC addString:@"Control-click"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"Groups"];
		[PC addString:@"&"];
		[PC addString:@"Files"];
		[PC addString:@"list"];
		[PC addString:@"and"];
		[PC addString:@"choose"];
		[PC addString:@"Add"];
		[PC addString:@"New"];
		[PC addString:@"Target"];
		[PC addString:@"from"];
		[PC addString:@"the"];
		[PC addString:@"contextual"];
		[PC addString:@"menu."];
		[PC addString:@"Xcode"];
		[PC addString:@"presents"];
		[PC addString:@"you"];
		[PC addString:@"with"];
		[PC addString:@"the"];
		[PC addString:@"New"];
		[PC addString:@"Target"];
		[PC addString:@"Assistant,"];
		[PC addString:@"shown"];
		[PC addString:@"in"];
		[PC addString:@"Figure"];
		[PC addString:@"24-5,"];
		[PC addString:@"which"];
		[PC addString:@"lets"];
		[PC addString:@"you"];
		[PC addString:@"choose"];
		[PC addString:@"from"];
		[PC addString:@"a"];
		[PC addString:@"number"];
		[PC addString:@"of"];
		[PC addString:@"possible"];
		[PC addString:@"target"];
		[PC addString:@"templates."];
		[PC addString:@"Each"];
		[PC addString:@"target"];
		[PC addString:@"template"];
		[PC addString:@"corresponds"];
		[PC addString:@"to"];
		[PC addString:@"a"];
		[PC addString:@"particular"];
		[PC addString:@"type"];
		[PC addString:@"of"];
		[PC addString:@"product,"];
		[PC addString:@"such"];
		[PC addString:@"as"];
		[PC addString:@"an"];
		[PC addString:@"application"];
		[PC addString:@"or"];
		[PC addString:@"loadable"];
		[PC addString:@"bundle."];
		[PC addString:@"Select"];
		[PC addString:@"one"];
		[PC addString:@"of"];
		[PC addString:@"these"];
		[PC addString:@"templates"];
		[PC addString:@"and"];
		[PC addString:@"click"];
		[PC addString:@"Next."];
		[PC addString:@"Enter"];
		[PC addString:@"the"];
		[PC addString:@"name"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"target;"];
		[PC addString:@"if"];
		[PC addString:@"more"];
		[PC addString:@"than"];
		[PC addString:@"one"];
		[PC addString:@"project"];
		[PC addString:@"is"];
		[PC addString:@"open,"];
		[PC addString:@"you"];
		[PC addString:@"can"];
		[PC addString:@"choose"];
		[PC addString:@"which"];
		[PC addString:@"project"];
		[PC addString:@"to"];
		[PC addString:@"add"];
		[PC addString:@"the"];
		[PC addString:@"new"];
		[PC addString:@"target"];
		[PC addString:@"to"];
		[PC addString:@"from"];
		[PC addString:@"the"];
		[PC addString:@"Add"];
		[PC addString:@"to"];
		[PC addString:@"Project"];
		[PC addString:@"menu."];
		[PC addString:@"When"];
		[PC addString:@"you"];
		[PC addString:@"click"];
		[PC addString:@"Finish,"];
		[PC addString:@"Xcode"];
		[PC addString:@"creates"];
		[PC addString:@"a"];
		[PC addString:@"new"];
		[PC addString:@"target"];
		[PC addString:@"configured"];
		[PC addString:@"for"];
		[PC addString:@"the"];
		[PC addString:@"specified"];
		[PC addString:@"product"];
		[PC addString:@"type."];
		[PC addString:@"Xcode"];
		[PC addString:@"also"];
		[PC addString:@"creates"];
		[PC addString:@"a"];
		[PC addString:@"reference"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"product"];
		[PC addString:@"and"];
		[PC addString:@"places"];
		[PC addString:@"it"];
		[PC addString:@"in"];
		[PC addString:@"your"];
		[PC addString:@"project,"];
		[PC addString:@"although"];
		[PC addString:@"the"];
		[PC addString:@"product"];
		[PC addString:@"does"];
		[PC addString:@"not"];
		[PC addString:@"exist"];
		[PC addString:@"on"];
		[PC addString:@"disk"];
		[PC addString:@"until"];
		[PC addString:@"you"];
		[PC addString:@"build"];
		[PC addString:@"the"];
		[PC addString:@"target."];
		[PC addString:@"Figure"];
		[PC addString:@"24-5"];
		[PC addString:@"The"];
		[PC addString:@"New"];
		[PC addString:@"Target"];
		[PC addString:@"Assistant"];
		[PC addString:@"Xcode"];
		[PC addString:@"provides"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"listed"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"following"];
		[PC addString:@"tables."];
		[PC addString:@"Table"];
		[PC addString:@"24-1"];
		[PC addString:@"lists"];
		[PC addString:@"templates"];
		[PC addString:@"that"];
		[PC addString:@"create"];
		[PC addString:@"targets"];
		[PC addString:@"using"];
		[PC addString:@"the"];
		[PC addString:@"native"];
		[PC addString:@"build"];
		[PC addString:@"system."];
		[PC addString:@"Because"];
		[PC addString:@"it"];
		[PC addString:@"performs"];
		[PC addString:@"all"];
		[PC addString:@"target"];
		[PC addString:@"and"];
		[PC addString:@"file-level"];
		[PC addString:@"dependency"];
		[PC addString:@"analysis"];
		[PC addString:@"for"];
		[PC addString:@"targets"];
		[PC addString:@"using"];
		[PC addString:@"the"];
		[PC addString:@"native"];
		[PC addString:@"build"];
		[PC addString:@"system,"];
		[PC addString:@"Xcode"];
		[PC addString:@"can"];
		[PC addString:@"offer"];
		[PC addString:@"detailed"];
		[PC addString:@"feedback"];
		[PC addString:@"about"];
		[PC addString:@"the"];
		[PC addString:@"build"];
		[PC addString:@"process"];
		[PC addString:@"and"];
		[PC addString:@"integration"];
		[PC addString:@"with"];
		[PC addString:@"the"];
		[PC addString:@"user"];
		[PC addString:@"interface"];
		[PC addString:@"for"];
		[PC addString:@"these"];
		[PC addString:@"targets."];
		[PC addString:@"Table"];
		[PC addString:@"24-1"];
		[PC addString:@"Xcode"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"Target"];
		[PC addString:@"template"];
		[PC addString:@"Creates"];
		[PC addString:@"BSD"];
		[PC addString:@"Dynamic"];
		[PC addString:@"Library"];
		[PC addString:@"A"];
		[PC addString:@"dynamic"];
		[PC addString:@"library,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"C,"];
		[PC addString:@"that"];
		[PC addString:@"makes"];
		[PC addString:@"use"];
		[PC addString:@"of"];
		[PC addString:@"BSD."];
		[PC addString:@"Shell"];
		[PC addString:@"Tool"];
		[PC addString:@"A"];
		[PC addString:@"command-line"];
		[PC addString:@"utility,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"C."];
		[PC addString:@"Static"];
		[PC addString:@"Library"];
		[PC addString:@"A"];
		[PC addString:@"static"];
		[PC addString:@"library,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"C,"];
		[PC addString:@"that"];
		[PC addString:@"makes"];
		[PC addString:@"use"];
		[PC addString:@"of"];
		[PC addString:@"BSD."];
		[PC addString:@"Carbon"];
		[PC addString:@"Application"];
		[PC addString:@"An"];
		[PC addString:@"application,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"C"];
		[PC addString:@"or"];
		[PC addString:@"C++,"];
		[PC addString:@"that"];
		[PC addString:@"links"];
		[PC addString:@"against"];
		[PC addString:@"the"];
		[PC addString:@"Carbon"];
		[PC addString:@"framework."];
		[PC addString:@"Dynamic"];
		[PC addString:@"Library"];
		[PC addString:@"A"];
		[PC addString:@"dynamic"];
		[PC addString:@"library"];
		[PC addString:@"that"];
		[PC addString:@"links"];
		[PC addString:@"against"];
		[PC addString:@"the"];
		[PC addString:@"Carbon"];
		[PC addString:@"framework."];
		[PC addString:@"Framework"];
		[PC addString:@"A"];
		[PC addString:@"framework"];
		[PC addString:@"based"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"Carbon"];
		[PC addString:@"framework."];
		[PC addString:@"Loadable"];
		[PC addString:@"Bundle"];
		[PC addString:@"A"];
		[PC addString:@"bundle,"];
		[PC addString:@"such"];
		[PC addString:@"as"];
		[PC addString:@"a"];
		[PC addString:@"plug-in,"];
		[PC addString:@"that"];
		[PC addString:@"can"];
		[PC addString:@"be"];
		[PC addString:@"loaded"];
		[PC addString:@"into"];
		[PC addString:@"a"];
		[PC addString:@"running"];
		[PC addString:@"program."];
		[PC addString:@"Shell"];
		[PC addString:@"Tool"];
		[PC addString:@"A"];
		[PC addString:@"command-line"];
		[PC addString:@"utility"];
		[PC addString:@"based"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"Carbon"];
		[PC addString:@"framework."];
		[PC addString:@"Static"];
		[PC addString:@"Library"];
		[PC addString:@"A"];
		[PC addString:@"static"];
		[PC addString:@"library,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"C"];
		[PC addString:@"or"];
		[PC addString:@"C++,"];
		[PC addString:@"based"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"Carbon"];
		[PC addString:@"framework."];
		[PC addString:@"Unit"];
		[PC addString:@"Test"];
		[PC addString:@"Bundle"];
		[PC addString:@"A"];
		[PC addString:@"target"];
		[PC addString:@"that"];
		[PC addString:@"compiles"];
		[PC addString:@"test"];
		[PC addString:@"code"];
		[PC addString:@"into"];
		[PC addString:@"a"];
		[PC addString:@"bundle,"];
		[PC addString:@"links"];
		[PC addString:@"it"];
		[PC addString:@"with"];
		[PC addString:@"the"];
		[PC addString:@"Unit"];
		[PC addString:@"Test"];
		[PC addString:@"framework"];
		[PC addString:@"and"];
		[PC addString:@"an"];
		[PC addString:@"executable"];
		[PC addString:@"to"];
		[PC addString:@"be"];
		[PC addString:@"tested,"];
		[PC addString:@"and"];
		[PC addString:@"runs"];
		[PC addString:@"a"];
		[PC addString:@"series"];
		[PC addString:@"of"];
		[PC addString:@"unit"];
		[PC addString:@"tests."];
		[PC addString:@"Cocoa"];
		[PC addString:@"Application"];
		[PC addString:@"An"];
		[PC addString:@"application,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"Objective-C"];
		[PC addString:@"or"];
		[PC addString:@"Objective-C++,"];
		[PC addString:@"that"];
		[PC addString:@"links"];
		[PC addString:@"against"];
		[PC addString:@"the"];
		[PC addString:@"Cocoa"];
		[PC addString:@"framework."];
		[PC addString:@"Dynamic"];
		[PC addString:@"Library"];
		[PC addString:@"A"];
		[PC addString:@"dynamic"];
		[PC addString:@"library"];
		[PC addString:@"that"];
		[PC addString:@"links"];
		[PC addString:@"against"];
		[PC addString:@"the"];
		[PC addString:@"Cocoa"];
		[PC addString:@"framework."];
		[PC addString:@"Framework"];
		[PC addString:@"A"];
		[PC addString:@"framework"];
		[PC addString:@"based"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"Cocoa"];
		[PC addString:@"framework."];
		[PC addString:@"Loadable"];
		[PC addString:@"Bundle"];
		[PC addString:@"A"];
		[PC addString:@"bundle,"];
		[PC addString:@"such"];
		[PC addString:@"as"];
		[PC addString:@"a"];
		[PC addString:@"plug-in,"];
		[PC addString:@"that"];
		[PC addString:@"can"];
		[PC addString:@"be"];
		[PC addString:@"loaded"];
		[PC addString:@"into"];
		[PC addString:@"a"];
		[PC addString:@"running"];
		[PC addString:@"program."];
		[PC addString:@"Shell"];
		[PC addString:@"Tool"];
		[PC addString:@"A"];
		[PC addString:@"command-line"];
		[PC addString:@"utility"];
		[PC addString:@"based"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"Cocoa"];
		[PC addString:@"framework."];
		[PC addString:@"Static"];
		[PC addString:@"Library"];
		[PC addString:@"A"];
		[PC addString:@"static"];
		[PC addString:@"library,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"Objective-C"];
		[PC addString:@"or"];
		[PC addString:@"Objective-C++,"];
		[PC addString:@"based"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"Cocoa"];
		[PC addString:@"framework."];
		[PC addString:@"Unit"];
		[PC addString:@"Test"];
		[PC addString:@"Bundle"];
		[PC addString:@"A"];
		[PC addString:@"target"];
		[PC addString:@"that"];
		[PC addString:@"compiles"];
		[PC addString:@"test"];
		[PC addString:@"code"];
		[PC addString:@"into"];
		[PC addString:@"a"];
		[PC addString:@"bundle,"];
		[PC addString:@"links"];
		[PC addString:@"it"];
		[PC addString:@"with"];
		[PC addString:@"the"];
		[PC addString:@"Unit"];
		[PC addString:@"Test"];
		[PC addString:@"framework"];
		[PC addString:@"and"];
		[PC addString:@"an"];
		[PC addString:@"executable"];
		[PC addString:@"to"];
		[PC addString:@"be"];
		[PC addString:@"tested,"];
		[PC addString:@"and"];
		[PC addString:@"runs"];
		[PC addString:@"a"];
		[PC addString:@"series"];
		[PC addString:@"of"];
		[PC addString:@"unit"];
		[PC addString:@"tests."];
		[PC addString:@"Kernel"];
		[PC addString:@"Extension"];
		[PC addString:@"Generic"];
		[PC addString:@"Kernel"];
		[PC addString:@"Extension"];
		[PC addString:@"A"];
		[PC addString:@"kernel"];
		[PC addString:@"extension"];
		[PC addString:@"IOKit"];
		[PC addString:@"Driver"];
		[PC addString:@"A"];
		[PC addString:@"device"];
		[PC addString:@"driver"];
		[PC addString:@"that"];
		[PC addString:@"uses"];
		[PC addString:@"the"];
		[PC addString:@"I/O"];
		[PC addString:@"Kit."];
		[PC addString:@"Xcode"];
		[PC addString:@"also"];
		[PC addString:@"supports"];
		[PC addString:@"targets"];
		[PC addString:@"that"];
		[PC addString:@"use"];
		[PC addString:@"Project"];
		[PC addString:@"Jam-based"];
		[PC addString:@"build"];
		[PC addString:@"system."];
		[PC addString:@"Table"];
		[PC addString:@"24-2"];
		[PC addString:@"lists"];
		[PC addString:@"the"];
		[PC addString:@"templates"];
		[PC addString:@"that"];
		[PC addString:@"create"];
		[PC addString:@"targets"];
		[PC addString:@"using"];
		[PC addString:@"the"];
		[PC addString:@"Project"];
		[PC addString:@"Builder"];
		[PC addString:@"build"];
		[PC addString:@"system,"];
		[PC addString:@"called"];
		[PC addString:@"legacy"];
		[PC addString:@"targets."];
		[PC addString:@"Note"];
		[PC addString:@"that"];
		[PC addString:@"Jam-based"];
		[PC addString:@"targets"];
		[PC addString:@"are"];
		[PC addString:@"supported"];
		[PC addString:@"only"];
		[PC addString:@"for"];
		[PC addString:@"compatibility"];
		[PC addString:@"with"];
		[PC addString:@"existing"];
		[PC addString:@"Project"];
		[PC addString:@"Builder"];
		[PC addString:@"projects."];
		[PC addString:@"Where"];
		[PC addString:@"possible,"];
		[PC addString:@"you"];
		[PC addString:@"should"];
		[PC addString:@"use"];
		[PC addString:@"native"];
		[PC addString:@"targets"];
		[PC addString:@"instead."];
		[PC addString:@"Legacy"];
		[PC addString:@"targets"];
		[PC addString:@"are"];
		[PC addString:@"discussed"];
		[PC addString:@"further"];
		[PC addString:@"in"];
		[PC addString:@"Converting"];
		[PC addString:@"a"];
		[PC addString:@"Project"];
		[PC addString:@"Builder"];
		[PC addString:@"Target."];
		[PC addString:@"Table"];
		[PC addString:@"24-2"];
		[PC addString:@"Legacy"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"Template"];
		[PC addString:@"Creates"];
		[PC addString:@"Application"];
		[PC addString:@"An"];
		[PC addString:@"application"];
		[PC addString:@"bundle."];
		[PC addString:@"Bundle"];
		[PC addString:@"A"];
		[PC addString:@"standard"];
		[PC addString:@"bundle."];
		[PC addString:@"Cocoa"];
		[PC addString:@"Application"];
		[PC addString:@"An"];
		[PC addString:@"application,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"Objective-C"];
		[PC addString:@"or"];
		[PC addString:@"Objective-C++,"];
		[PC addString:@"that"];
		[PC addString:@"links"];
		[PC addString:@"against"];
		[PC addString:@"the"];
		[PC addString:@"Cocoa"];
		[PC addString:@"framework"];
		[PC addString:@"Framework"];
		[PC addString:@"A"];
		[PC addString:@"framework."];
		[PC addString:@"Java"];
		[PC addString:@"Application"];
		[PC addString:@"An"];
		[PC addString:@"application,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"Java,"];
		[PC addString:@"and"];
		[PC addString:@"packaged"];
		[PC addString:@"as"];
		[PC addString:@"an"];
		[PC addString:@"application"];
		[PC addString:@"bundle."];
		[PC addString:@"Applet"];
		[PC addString:@"A"];
		[PC addString:@"Java"];
		[PC addString:@"applet,"];
		[PC addString:@"built"];
		[PC addString:@"as"];
		[PC addString:@"a"];
		[PC addString:@"JAR"];
		[PC addString:@"file."];
		[PC addString:@"Package"];
		[PC addString:@"A"];
		[PC addString:@"package"];
		[PC addString:@"of"];
		[PC addString:@"Java"];
		[PC addString:@"classes."];
		[PC addString:@"Tool"];
		[PC addString:@"A"];
		[PC addString:@"command-line"];
		[PC addString:@"utility,"];
		[PC addString:@"written"];
		[PC addString:@"in"];
		[PC addString:@"Java"];
		[PC addString:@"and"];
		[PC addString:@"built"];
		[PC addString:@"as"];
		[PC addString:@"a"];
		[PC addString:@"JAR"];
		[PC addString:@"file."];
		[PC addString:@"Kernel"];
		[PC addString:@"Extension"];
		[PC addString:@"Generic"];
		[PC addString:@"Kernel"];
		[PC addString:@"Extension"];
		[PC addString:@"A"];
		[PC addString:@"kernel"];
		[PC addString:@"extension"];
		[PC addString:@"IOKit"];
		[PC addString:@"Driver"];
		[PC addString:@"A"];
		[PC addString:@"device"];
		[PC addString:@"driver"];
		[PC addString:@"that"];
		[PC addString:@"uses"];
		[PC addString:@"the"];
		[PC addString:@"I/O"];
		[PC addString:@"Kit."];
		[PC addString:@"Library"];
		[PC addString:@"A"];
		[PC addString:@"dynamic"];
		[PC addString:@"or"];
		[PC addString:@"static"];
		[PC addString:@"library"];
		[PC addString:@"Tool"];
		[PC addString:@"A"];
		[PC addString:@"command-line"];
		[PC addString:@"utility."];
		[PC addString:@"In"];
		[PC addString:@"addition"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"described"];
		[PC addString:@"above,"];
		[PC addString:@"Xcode"];
		[PC addString:@"defines"];
		[PC addString:@"a"];
		[PC addString:@"handful"];
		[PC addString:@"of"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"that"];
		[PC addString:@"do"];
		[PC addString:@"not"];
		[PC addString:@"necessarily"];
		[PC addString:@"correspond"];
		[PC addString:@"to"];
		[PC addString:@"a"];
		[PC addString:@"particular"];
		[PC addString:@"product"];
		[PC addString:@"type."];
		[PC addString:@"These"];
		[PC addString:@"targets"];
		[PC addString:@"are"];
		[PC addString:@"described"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"next"];
		[PC addString:@"section."];
		[PC addString:@"Special"];
		[PC addString:@"Types"];
		[PC addString:@"of"];
		[PC addString:@"Targets"];
		[PC addString:@"Xcode"];
		[PC addString:@"defines"];
		[PC addString:@"a"];
		[PC addString:@"handful"];
		[PC addString:@"of"];
		[PC addString:@"target"];
		[PC addString:@"templates"];
		[PC addString:@"that"];
		[PC addString:@"do"];
		[PC addString:@"not"];
		[PC addString:@"necessarily"];
		[PC addString:@"correspond"];
		[PC addString:@"to"];
		[PC addString:@"a"];
		[PC addString:@"particular"];
		[PC addString:@"product"];
		[PC addString:@"type."];
		[PC addString:@"Instead,"];
		[PC addString:@"these"];
		[PC addString:@"targets"];
		[PC addString:@"can"];
		[PC addString:@"be"];
		[PC addString:@"used"];
		[PC addString:@"to:"];
		[PC addString:@"Build"];
		[PC addString:@"a"];
		[PC addString:@"group"];
		[PC addString:@"of"];
		[PC addString:@"targets"];
		[PC addString:@"together"];
		[PC addString:@"Build"];
		[PC addString:@"a"];
		[PC addString:@"product"];
		[PC addString:@"using"];
		[PC addString:@"an"];
		[PC addString:@"external"];
		[PC addString:@"build"];
		[PC addString:@"system"];
		[PC addString:@"Run"];
		[PC addString:@"a"];
		[PC addString:@"shell"];
		[PC addString:@"script"];
		[PC addString:@"Copy"];
		[PC addString:@"files"];
		[PC addString:@"to"];
		[PC addString:@"a"];
		[PC addString:@"specific"];
		[PC addString:@"location"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"file"];
		[PC addString:@"system"];
		[PC addString:@"Aggregate"];
		[PC addString:@"Xcode"];
		[PC addString:@"defines"];
		[PC addString:@"a"];
		[PC addString:@"special"];
		[PC addString:@"type"];
		[PC addString:@"of"];
		[PC addString:@"target"];
		[PC addString:@"that"];
		[PC addString:@"lets"];
		[PC addString:@"you"];
		[PC addString:@"build"];
		[PC addString:@"a"];
		[PC addString:@"group"];
		[PC addString:@"of"];
		[PC addString:@"targets"];
		[PC addString:@"at"];
		[PC addString:@"once,"];
		[PC addString:@"even"];
		[PC addString:@"if"];
		[PC addString:@"those"];
		[PC addString:@"targets"];
		[PC addString:@"do"];
		[PC addString:@"not"];
		[PC addString:@"depend"];
		[PC addString:@"on"];
		[PC addString:@"each"];
		[PC addString:@"other."];
		[PC addString:@"An"];
		[PC addString:@"aggregate"];
		[PC addString:@"target"];
		[PC addString:@"has"];
		[PC addString:@"no"];
		[PC addString:@"associated"];
		[PC addString:@"product"];
		[PC addString:@"and"];
		[PC addString:@"no"];
		[PC addString:@"build"];
		[PC addString:@"rules."];
		[PC addString:@"Instead,"];
		[PC addString:@"an"];
		[PC addString:@"aggregate"];
		[PC addString:@"target"];
		[PC addString:@"depends"];
		[PC addString:@"on"];
		[PC addString:@"each"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"targets"];
		[PC addString:@"you"];
		[PC addString:@"want"];
		[PC addString:@"to"];
		[PC addString:@"build"];
		[PC addString:@"together."];
		[PC addString:@"For"];
		[PC addString:@"example,"];
		[PC addString:@"you"];
		[PC addString:@"may"];
		[PC addString:@"have"];
		[PC addString:@"a"];
		[PC addString:@"suite"];
		[PC addString:@"of"];
		[PC addString:@"applications"];
		[PC addString:@"and"];
		[PC addString:@"want"];
		[PC addString:@"to"];
		[PC addString:@"build"];
		[PC addString:@"them"];
		[PC addString:@"at"];
		[PC addString:@"once"];
		[PC addString:@"for"];
		[PC addString:@"a"];
		[PC addString:@"final"];
		[PC addString:@"build."];
		[PC addString:@"You"];
		[PC addString:@"would"];
		[PC addString:@"create"];
		[PC addString:@"an"];
		[PC addString:@"aggregate"];
		[PC addString:@"target"];
		[PC addString:@"and"];
		[PC addString:@"make"];
		[PC addString:@"it"];
		[PC addString:@"depend"];
		[PC addString:@"on"];
		[PC addString:@"each"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"individual"];
		[PC addString:@"application"];
		[PC addString:@"targets;"];
		[PC addString:@"to"];
		[PC addString:@"build"];
		[PC addString:@"the"];
		[PC addString:@"entire"];
		[PC addString:@"application"];
		[PC addString:@"suite,"];
		[PC addString:@"just"];
		[PC addString:@"build"];
		[PC addString:@"the"];
		[PC addString:@"aggregate"];
		[PC addString:@"target."];
		[PC addString:@"An"];
		[PC addString:@"aggregate"];
		[PC addString:@"target"];
		[PC addString:@"may"];
		[PC addString:@"contain"];
		[PC addString:@"a"];
		[PC addString:@"custom"];
		[PC addString:@"Run"];
		[PC addString:@"Script"];
		[PC addString:@"build"];
		[PC addString:@"phase"];
		[PC addString:@"or"];
		[PC addString:@"a"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"build"];
		[PC addString:@"phase,"];
		[PC addString:@"but"];
		[PC addString:@"it"];
		[PC addString:@"cannot"];
		[PC addString:@"contain"];
		[PC addString:@"any"];
		[PC addString:@"other"];
		[PC addString:@"build"];
		[PC addString:@"phases."];
		[PC addString:@"Any"];
		[PC addString:@"build"];
		[PC addString:@"settings"];
		[PC addString:@"that"];
		[PC addString:@"the"];
		[PC addString:@"aggregate"];
		[PC addString:@"target"];
		[PC addString:@"contains"];
		[PC addString:@"are"];
		[PC addString:@"not"];
		[PC addString:@"interpreted"];
		[PC addString:@"but"];
		[PC addString:@"are"];
		[PC addString:@"passed"];
		[PC addString:@"to"];
		[PC addString:@"any"];
		[PC addString:@"build"];
		[PC addString:@"phases"];
		[PC addString:@"that"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"contains."];
		[PC addString:@"For"];
		[PC addString:@"more"];
		[PC addString:@"information"];
		[PC addString:@"on"];
		[PC addString:@"aggregate"];
		[PC addString:@"targets,"];
		[PC addString:@"see"];
		[PC addString:@"Preprocessing"];
		[PC addString:@"Info.plist"];
		[PC addString:@"Files"];
		[PC addString:@"External"];
		[PC addString:@"Xcode"];
		[PC addString:@"allows"];
		[PC addString:@"you"];
		[PC addString:@"to"];
		[PC addString:@"create"];
		[PC addString:@"targets"];
		[PC addString:@"that"];
		[PC addString:@"do"];
		[PC addString:@"not"];
		[PC addString:@"use"];
		[PC addString:@"the"];
		[PC addString:@"native"];
		[PC addString:@"Xcode"];
		[PC addString:@"build"];
		[PC addString:@"system"];
		[PC addString:@"but"];
		[PC addString:@"instead"];
		[PC addString:@"use"];
		[PC addString:@"an"];
		[PC addString:@"external"];
		[PC addString:@"build"];
		[PC addString:@"tool"];
		[PC addString:@"that"];
		[PC addString:@"you"];
		[PC addString:@"specify."];
		[PC addString:@"For"];
		[PC addString:@"example,"];
		[PC addString:@"if"];
		[PC addString:@"you"];
		[PC addString:@"have"];
		[PC addString:@"an"];
		[PC addString:@"existing"];
		[PC addString:@"project"];
		[PC addString:@"with"];
		[PC addString:@"a"];
		[PC addString:@"makefile,"];
		[PC addString:@"you"];
		[PC addString:@"can"];
		[PC addString:@"use"];
		[PC addString:@"an"];
		[PC addString:@"external"];
		[PC addString:@"target"];
		[PC addString:@"to"];
		[PC addString:@"run"];
		[PC addString:@"make"];
		[PC addString:@"and"];
		[PC addString:@"build"];
		[PC addString:@"the"];
		[PC addString:@"product."];
		[PC addString:@"An"];
		[PC addString:@"external"];
		[PC addString:@"target"];
		[PC addString:@"creates"];
		[PC addString:@"a"];
		[PC addString:@"product"];
		[PC addString:@"but"];
		[PC addString:@"does"];
		[PC addString:@"not"];
		[PC addString:@"contain"];
		[PC addString:@"build"];
		[PC addString:@"phases."];
		[PC addString:@"Instead,"];
		[PC addString:@"it"];
		[PC addString:@"calls"];
		[PC addString:@"a"];
		[PC addString:@"build"];
		[PC addString:@"tool"];
		[PC addString:@"in"];
		[PC addString:@"a"];
		[PC addString:@"directory."];
		[PC addString:@"With"];
		[PC addString:@"an"];
		[PC addString:@"external"];
		[PC addString:@"target,"];
		[PC addString:@"you"];
		[PC addString:@"can"];
		[PC addString:@"take"];
		[PC addString:@"full"];
		[PC addString:@"advantage"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"Xcode"];
		[PC addString:@"editor,"];
		[PC addString:@"class"];
		[PC addString:@"browser,"];
		[PC addString:@"and"];
		[PC addString:@"source-level"];
		[PC addString:@"debugger."];
		[PC addString:@"However,"];
		[PC addString:@"many"];
		[PC addString:@"Xcode"];
		[PC addString:@"as"];
		[PC addString:@"ZeroLink"];
		[PC addString:@"and"];
		[PC addString:@"Fix"];
		[PC addString:@"and"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"build"];
		[PC addString:@"information"];
		[PC addString:@"maintained"];
		[PC addString:@"by"];
		[PC addString:@"Xcode"];
		[PC addString:@"for"];
		[PC addString:@"targets"];
		[PC addString:@"using"];
		[PC addString:@"the"];
		[PC addString:@"native"];
		[PC addString:@"build"];
		[PC addString:@"system."];
		[PC addString:@"As"];
		[PC addString:@"a"];
		[PC addString:@"result,"];
		[PC addString:@"these"];
		[PC addString:@"are"];
		[PC addString:@"not"];
		[PC addString:@"available"];
		[PC addString:@"to"];
		[PC addString:@"an"];
		[PC addString:@"external"];
		[PC addString:@"target."];
		[PC addString:@"Furthermore,"];
		[PC addString:@"you"];
		[PC addString:@"must"];
		[PC addString:@"maintain"];
		[PC addString:@"your"];
		[PC addString:@"custom"];
		[PC addString:@"build"];
		[PC addString:@"system"];
		[PC addString:@"yourself."];
		[PC addString:@"For"];
		[PC addString:@"instance,"];
		[PC addString:@"if"];
		[PC addString:@"you"];
		[PC addString:@"need"];
		[PC addString:@"to"];
		[PC addString:@"add"];
		[PC addString:@"files"];
		[PC addString:@"to"];
		[PC addString:@"an"];
		[PC addString:@"external"];
		[PC addString:@"target"];
		[PC addString:@"built"];
		[PC addString:@"using"];
		[PC addString:@"make,"];
		[PC addString:@"you"];
		[PC addString:@"must"];
		[PC addString:@"edit"];
		[PC addString:@"the"];
		[PC addString:@"makefile"];
		[PC addString:@"yourself."];
		[PC addString:@"Shell"];
		[PC addString:@"Script"];
		[PC addString:@"A"];
		[PC addString:@"Shell"];
		[PC addString:@"Script"];
		[PC addString:@"target"];
		[PC addString:@"is"];
		[PC addString:@"an"];
		[PC addString:@"aggregate"];
		[PC addString:@"target"];
		[PC addString:@"that"];
		[PC addString:@"contains"];
		[PC addString:@"only"];
		[PC addString:@"one"];
		[PC addString:@"build"];
		[PC addString:@"phase,"];
		[PC addString:@"a"];
		[PC addString:@"Run"];
		[PC addString:@"Script"];
		[PC addString:@"build"];
		[PC addString:@"phase."];
		[PC addString:@"Building"];
		[PC addString:@"a"];
		[PC addString:@"Shell"];
		[PC addString:@"Script"];
		[PC addString:@"target"];
		[PC addString:@"simply"];
		[PC addString:@"runs"];
		[PC addString:@"the"];
		[PC addString:@"associated"];
		[PC addString:@"shell"];
		[PC addString:@"script."];
		[PC addString:@"Shell"];
		[PC addString:@"Script"];
		[PC addString:@"targets"];
		[PC addString:@"are"];
		[PC addString:@"useful"];
		[PC addString:@"if"];
		[PC addString:@"you"];
		[PC addString:@"have"];
		[PC addString:@"custom"];
		[PC addString:@"build"];
		[PC addString:@"steps"];
		[PC addString:@"that"];
		[PC addString:@"need"];
		[PC addString:@"to"];
		[PC addString:@"be"];
		[PC addString:@"performed."];
		[PC addString:@"While"];
		[PC addString:@"Run"];
		[PC addString:@"Script"];
		[PC addString:@"build"];
		[PC addString:@"phases"];
		[PC addString:@"allow"];
		[PC addString:@"you"];
		[PC addString:@"to"];
		[PC addString:@"add"];
		[PC addString:@"custom"];
		[PC addString:@"steps"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"build"];
		[PC addString:@"process"];
		[PC addString:@"for"];
		[PC addString:@"a"];
		[PC addString:@"single"];
		[PC addString:@"target,"];
		[PC addString:@"a"];
		[PC addString:@"Shell"];
		[PC addString:@"Script"];
		[PC addString:@"target"];
		[PC addString:@"lets"];
		[PC addString:@"you"];
		[PC addString:@"define"];
		[PC addString:@"a"];
		[PC addString:@"custom"];
		[PC addString:@"build"];
		[PC addString:@"operation"];
		[PC addString:@"that"];
		[PC addString:@"you"];
		[PC addString:@"can"];
		[PC addString:@"use"];
		[PC addString:@"with"];
		[PC addString:@"many"];
		[PC addString:@"different"];
		[PC addString:@"targets."];
		[PC addString:@"For"];
		[PC addString:@"example,"];
		[PC addString:@"if"];
		[PC addString:@"your"];
		[PC addString:@"project"];
		[PC addString:@"has"];
		[PC addString:@"several"];
		[PC addString:@"targets"];
		[PC addString:@"that"];
		[PC addString:@"each"];
		[PC addString:@"use"];
		[PC addString:@"the"];
		[PC addString:@"files"];
		[PC addString:@"generated"];
		[PC addString:@"by"];
		[PC addString:@"a"];
		[PC addString:@"Shell"];
		[PC addString:@"Script"];
		[PC addString:@"target,"];
		[PC addString:@"you"];
		[PC addString:@"can"];
		[PC addString:@"make"];
		[PC addString:@"each"];
		[PC addString:@"of"];
		[PC addString:@"those"];
		[PC addString:@"targets"];
		[PC addString:@"depend"];
		[PC addString:@"upon"];
		[PC addString:@"the"];
		[PC addString:@"Shell"];
		[PC addString:@"Script"];
		[PC addString:@"target."];
		[PC addString:@"For"];
		[PC addString:@"more"];
		[PC addString:@"information"];
		[PC addString:@"on"];
		[PC addString:@"using"];
		[PC addString:@"shell"];
		[PC addString:@"scripts"];
		[PC addString:@"as"];
		[PC addString:@"part"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"build"];
		[PC addString:@"process,"];
		[PC addString:@"see"];
		[PC addString:@"Run"];
		[PC addString:@"Script"];
		[PC addString:@"Build"];
		[PC addString:@"Phase."];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"A"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"target"];
		[PC addString:@"is"];
		[PC addString:@"an"];
		[PC addString:@"aggregate"];
		[PC addString:@"target"];
		[PC addString:@"that"];
		[PC addString:@"contains"];
		[PC addString:@"only"];
		[PC addString:@"one"];
		[PC addString:@"build"];
		[PC addString:@"phase,"];
		[PC addString:@"a"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"build"];
		[PC addString:@"phase."];
		[PC addString:@"Building"];
		[PC addString:@"a"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"target"];
		[PC addString:@"simply"];
		[PC addString:@"copies"];
		[PC addString:@"the"];
		[PC addString:@"associated"];
		[PC addString:@"files"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"specified"];
		[PC addString:@"destination"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"file"];
		[PC addString:@"system."];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"targets"];
		[PC addString:@"are"];
		[PC addString:@"useful"];
		[PC addString:@"if"];
		[PC addString:@"you"];
		[PC addString:@"have"];
		[PC addString:@"custom"];
		[PC addString:@"build"];
		[PC addString:@"steps"];
		[PC addString:@"that"];
		[PC addString:@"require"];
		[PC addString:@"files"];
		[PC addString:@"that"];
		[PC addString:@"are"];
		[PC addString:@"not"];
		[PC addString:@"specific"];
		[PC addString:@"to"];
		[PC addString:@"any"];
		[PC addString:@"other"];
		[PC addString:@"targets"];
		[PC addString:@"to"];
		[PC addString:@"be"];
		[PC addString:@"copied."];
		[PC addString:@"While"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"build"];
		[PC addString:@"phases"];
		[PC addString:@"allow"];
		[PC addString:@"you"];
		[PC addString:@"to"];
		[PC addString:@"add"];
		[PC addString:@"a"];
		[PC addString:@"step"];
		[PC addString:@"to"];
		[PC addString:@"the"];
		[PC addString:@"build"];
		[PC addString:@"process"];
		[PC addString:@"for"];
		[PC addString:@"a"];
		[PC addString:@"single"];
		[PC addString:@"target"];
		[PC addString:@"that"];
		[PC addString:@"copies"];
		[PC addString:@"files"];
		[PC addString:@"in"];
		[PC addString:@"that"];
		[PC addString:@"target,"];
		[PC addString:@"a"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"target"];
		[PC addString:@"lets"];
		[PC addString:@"you"];
		[PC addString:@"copy"];
		[PC addString:@"files"];
		[PC addString:@"that"];
		[PC addString:@"are"];
		[PC addString:@"not"];
		[PC addString:@"specific"];
		[PC addString:@"to"];
		[PC addString:@"any"];
		[PC addString:@"one"];
		[PC addString:@"target."];
		[PC addString:@"For"];
		[PC addString:@"example,"];
		[PC addString:@"if"];
		[PC addString:@"your"];
		[PC addString:@"project"];
		[PC addString:@"has"];
		[PC addString:@"several"];
		[PC addString:@"targets"];
		[PC addString:@"that"];
		[PC addString:@"require"];
		[PC addString:@"the"];
		[PC addString:@"same"];
		[PC addString:@"files"];
		[PC addString:@"to"];
		[PC addString:@"be"];
		[PC addString:@"installed"];
		[PC addString:@"at"];
		[PC addString:@"a"];
		[PC addString:@"particular"];
		[PC addString:@"location,"];
		[PC addString:@"you"];
		[PC addString:@"can"];
		[PC addString:@"use"];
		[PC addString:@"a"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"target"];
		[PC addString:@"to"];
		[PC addString:@"copy"];
		[PC addString:@"the"];
		[PC addString:@"files,"];
		[PC addString:@"and"];
		[PC addString:@"make"];
		[PC addString:@"each"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"other"];
		[PC addString:@"targets"];
		[PC addString:@"depend"];
		[PC addString:@"upon"];
		[PC addString:@"the"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"target."];
		[PC addString:@"For"];
		[PC addString:@"more"];
		[PC addString:@"information"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"build"];
		[PC addString:@"phase,"];
		[PC addString:@"see"];
		[PC addString:@"Copy"];
		[PC addString:@"Files"];
		[PC addString:@"Build"];
		[PC addString:@"Phase."];
		[PC addString:@"Duplicating"];
		[PC addString:@"a"];
		[PC addString:@"Target"];
		[PC addString:@"There"];
		[PC addString:@"are"];
		[PC addString:@"two"];
		[PC addString:@"main"];
		[PC addString:@"reasons"];
		[PC addString:@"why"];
		[PC addString:@"you"];
		[PC addString:@"might"];
		[PC addString:@"need"];
		[PC addString:@"to"];
		[PC addString:@"duplicate"];
		[PC addString:@"a"];
		[PC addString:@"target:"];
		[PC addString:@"you"];
		[PC addString:@"require"];
		[PC addString:@"two"];
		[PC addString:@"targets"];
		[PC addString:@"that"];
		[PC addString:@"are"];
		[PC addString:@"very"];
		[PC addString:@"similar"];
		[PC addString:@"but"];
		[PC addString:@"contain"];
		[PC addString:@"slight"];
		[PC addString:@"differences"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"files"];
		[PC addString:@"or"];
		[PC addString:@"build"];
		[PC addString:@"phases"];
		[PC addString:@"that"];
		[PC addString:@"they"];
		[PC addString:@"include,"];
		[PC addString:@"or"];
		[PC addString:@"you"];
		[PC addString:@"have"];
		[PC addString:@"a"];
		[PC addString:@"complicated"];
		[PC addString:@"set"];
		[PC addString:@"of"];
		[PC addString:@"options"];
		[PC addString:@"that"];
		[PC addString:@"you"];
		[PC addString:@"build"];
		[PC addString:@"with"];
		[PC addString:@"and"];
		[PC addString:@"would"];
		[PC addString:@"prefer"];
		[PC addString:@"to"];
		[PC addString:@"simply"];
		[PC addString:@"start"];
		[PC addString:@"with"];
		[PC addString:@"a"];
		[PC addString:@"copy"];
		[PC addString:@"of"];
		[PC addString:@"a"];
		[PC addString:@"target"];
		[PC addString:@"that"];
		[PC addString:@"already"];
		[PC addString:@"contains"];
		[PC addString:@"those"];
		[PC addString:@"build"];
		[PC addString:@"settings."];
		[PC addString:@"Xcode"];
		[PC addString:@"allows"];
		[PC addString:@"you"];
		[PC addString:@"to"];
		[PC addString:@"duplicate"];
		[PC addString:@"a"];
		[PC addString:@"target,"];
		[PC addString:@"creating"];
		[PC addString:@"a"];
		[PC addString:@"copy"];
		[PC addString:@"that"];
		[PC addString:@"contains"];
		[PC addString:@"all"];
		[PC addString:@"of"];
		[PC addString:@"the"];
		[PC addString:@"same"];
		[PC addString:@"files,"];
		[PC addString:@"build"];
		[PC addString:@"phases,"];
		[PC addString:@"dependencies"];
		[PC addString:@"and"];
		[PC addString:@"build"];
		[PC addString:@"configuration"];
		[PC addString:@"definitions."];
		[PC addString:@"You"];
		[PC addString:@"can"];
		[PC addString:@"create"];
		[PC addString:@"a"];
		[PC addString:@"copy"];
		[PC addString:@"of"];
		[PC addString:@"a"];
		[PC addString:@"target"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"following"];
		[PC addString:@"way:"];
		[PC addString:@"In"];
		[PC addString:@"the"];
		[PC addString:@"Groups"];
		[PC addString:@"&"];
		[PC addString:@"Files"];
		[PC addString:@"list,"];
		[PC addString:@"select"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"you"];
		[PC addString:@"want"];
		[PC addString:@"to"];
		[PC addString:@"copy."];
		[PC addString:@"Choose"];
		[PC addString:@"Edit"];
		[PC addString:@"Duplicate,"];
		[PC addString:@"or"];
		[PC addString:@"Control-click"];
		[PC addString:@"and"];
		[PC addString:@"choose"];
		[PC addString:@"Duplicate"];
		[PC addString:@"from"];
		[PC addString:@"the"];
		[PC addString:@"contextual"];
		[PC addString:@"menu."];
		[PC addString:@"Removing"];
		[PC addString:@"a"];
		[PC addString:@"Target"];
		[PC addString:@"If"];
		[PC addString:@"your"];
		[PC addString:@"project"];
		[PC addString:@"contains"];
		[PC addString:@"targets"];
		[PC addString:@"that"];
		[PC addString:@"are"];
		[PC addString:@"no"];
		[PC addString:@"longer"];
		[PC addString:@"in"];
		[PC addString:@"use,"];
		[PC addString:@"you"];
		[PC addString:@"can"];
		[PC addString:@"remove"];
		[PC addString:@"them"];
		[PC addString:@"from"];
		[PC addString:@"the"];
		[PC addString:@"project"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"following"];
		[PC addString:@"way:"];
		[PC addString:@"Select"];
		[PC addString:@"the"];
		[PC addString:@"target"];
		[PC addString:@"to"];
		[PC addString:@"delete"];
		[PC addString:@"in"];
		[PC addString:@"the"];
		[PC addString:@"Groups"];
		[PC addString:@"&"];
		[PC addString:@"Files"];
		[PC addString:@"list."];
		[PC addString:@"Press"];
		[PC addString:@"the"];
		[PC addString:@"Delete"];
		[PC addString:@"key"];
		[PC addString:@"or"];
		[PC addString:@"choose"];
		[PC addString:@"Edit"];
		[PC addString:@"Delete."];
		[PC addString:@"When"];
		[PC addString:@"you"];
		[PC addString:@"delete"];
		[PC addString:@"a"];
		[PC addString:@"target,"];
		[PC addString:@"Xcode"];
		[PC addString:@"also"];
		[PC addString:@"deletes"];
		[PC addString:@"the"];
		[PC addString:@"product"];
		[PC addString:@"reference"];
		[PC addString:@"for"];
		[PC addString:@"the"];
		[PC addString:@"product"];
		[PC addString:@"created"];
		[PC addString:@"by"];
		[PC addString:@"that"];
		[PC addString:@"target"];
		[PC addString:@"and"];
		[PC addString:@"removes"];
		[PC addString:@"any"];
		[PC addString:@"dependencies"];
		[PC addString:@"on"];
		[PC addString:@"the"];
		[PC addString:@"deleted"];
		[PC addString:@"target."];
		[PC addString:@"Show"];
		[PC addString:@"TOC	<"];
		[PC addString:@"Previous"];
		[PC addString:@"PageNext"];
		[PC addString:@"Page"];
		[PC addString:@"2004,"];
		[PC addString:@"2006"];
		[PC addString:@"Apple"];
		[PC addString:@"Computer,"];
		[PC addString:@"Inc."];
		[PC addString:@"All"];
		[PC addString:@"Rights"];
		[PC addString:@"Reserved."];
		[PC addString:@"(Last"];
		[PC addString:@"updated:"];
		[PC addString:@"2006-05-23)"];
		[PC addString:@"Did"];
		[PC addString:@"this"];
		[PC addString:@"document"];
		[PC addString:@"help"];
		[PC addString:@"you?"];
		[PC addString:@"Yes:"];
		[PC addString:@"Tell"];
		[PC addString:@"us"];
		[PC addString:@"what"];
		[PC addString:@"works"];
		[PC addString:@"for"];
		[PC addString:@"you."];
		[PC addString:@"good,"];
		[PC addString:@"but:"];
		[PC addString:@"Report"];
		[PC addString:@"typos,"];
		[PC addString:@"inaccuracies,"];
		[PC addString:@"and"];
		[PC addString:@"so"];
		[PC addString:@"forth."];
		[PC addString:@"It"];
		[PC addString:@"helpful:"];
		[PC addString:@"Tell"];
		[PC addString:@"us"];
		[PC addString:@"what"];
		[PC addString:@"would"];
		[PC addString:@"have"];
#endif
#if 1
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specifi"]);
		if ([PC removeString:@"specific"])
		{
			LOG4iTM3(@"%@",[PC stringListForPrefix:@"specifi"]);
		}
		else
		{
			LOG4iTM3(@"Failure");
		}
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"a"]);
		if ([PC removeString:@"all"])
		{
			LOG4iTM3(@"%@",[PC stringListForPrefix:@"al"]);
		}
		else
		{
			LOG4iTM3(@"Failure");
		}
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"ad"]);
		if ([PC removeString:@"added"])
		{
			LOG4iTM3(@"%@",[PC stringListForPrefix:@"ad"]);
		}
		else
		{
			LOG4iTM3(@"Failure");
		}
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"al"]);
		if ([PC removeString:@"also"])
		{
			LOG4iTM3(@"%@",[PC stringListForPrefix:@"al"]);
		}
		else
		{
			LOG4iTM3(@"Failure");
		}
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"app"]);
		if ([PC removeString:@"applications"])
		{
			LOG4iTM3(@"%@",[PC stringListForPrefix:@"app"]);
		}
		else
		{
			LOG4iTM3(@"Failure");
		}
#elif 0
		LOG4iTM3(@"%@",[PC stringList]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"s"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"sp"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"spe"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"spec"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"speci"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specif"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specifi"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specific"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specifica"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specificat"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specificati"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specificatio"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specification"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specifications"]);
		LOG4iTM3(@"%@",[PC stringListForPrefix:@"specifications "]);
#elif 0
		[PC stringList];
		[PC stringListForPrefix:@"s"];
		[PC stringListForPrefix:@"sp"];
		[PC stringListForPrefix:@"spe"];
		[PC stringListForPrefix:@"spec"];
		[PC stringListForPrefix:@"speci"];
		[PC stringListForPrefix:@"specif"];
		[PC stringListForPrefix:@"specifi"];
		[PC stringListForPrefix:@"specific"];
		[PC stringListForPrefix:@"specifica"];
		[PC stringListForPrefix:@"specificat"];
		[PC stringListForPrefix:@"specificati"];
		[PC stringListForPrefix:@"specificatio"];
		[PC stringListForPrefix:@"specification"];
		[PC stringListForPrefix:@"specifications"];
		[PC stringListForPrefix:@"specifications "];
#endif
		[P drain];
	}
#endif
#if 0
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"ab"];
		[PC addString:@"ac"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"ac"];
		[PC addString:@"ab"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"adb"];
		[PC addString:@"adc"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"adc"];
		[PC addString:@"adb"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"123"];
		[PC addString:@"15"];
		[PC addString:@"124"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"123"];
		[PC addString:@"124"];
		[PC addString:@"125"];
		[PC addString:@"167"];
		[PC addString:@"168"];
		[PC addString:@"169"];
		[PC addString:@"1ab"];
		[PC addString:@"1ac"];
		[PC addString:@"1ad"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
	{
		LOG4iTM3(@"----------");
		iTM2PatriciaController * PC = [[[iTM2PatriciaController alloc] init] autorelease];
		[PC addString:@"123"];
		[PC addString:@"124"];
		[PC addString:@"125"];
		[PC addString:@"167"];
		LOG4iTM3(@"%@",[PC stringList]);
		[PC addString:@"168"];
		LOG4iTM3(@"%@",[PC stringList]);
	}
#endif
	[P drain];

	return;
}
#endif

- (id)init;
{
	if (self = [super init])
	{
		if (iVarImplementation4iTM3 = [[iTM2PatriciaNode alloc] init])
		{
			return self;
		}
		self = nil;
	}
	return self;
}


- (id)initWithContentsOfURL:(NSURL *)url error:(NSError **)outErrorPtr;
{
	if (self = self.init)
	{
		NSError * error = nil;
		NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&error] autorelease];
		if (document)
		{
			NSXMLElement * rootElement = [document rootElement];
			iVarImplementation4iTM3 = [[iTM2PatriciaNode alloc] initWithXMLElement:rootElement];
			return self;
		}
		else if (error && outErrorPtr)
		{
			*outErrorPtr = error;
		}
		return self;
	}
	return nil;
}

- (BOOL)writeToURL:(NSURL *)url error:(NSError **)outErrorPtr;
{
	NSXMLElement * element = [iVarImplementation4iTM3 XMLElement];
	NSXMLDocument * document = [[[NSXMLDocument alloc] initWithRootElement:element] autorelease];
	[document setDocumentContentKind:NSXMLDocumentXMLKind];
	[document setCharacterEncoding:@"UTF-8"];
	NSData * D = [document XMLDataWithOptions:NSXMLNodePrettyPrint];
	return [D writeToURL:url options:NSAtomicWrite error:outErrorPtr];
}

- (BOOL)removeString:(NSString *)aString;
{
	// we will need the number of characters of prefix not previously tested (while entering the loop)
	NSUInteger countOfStringCharsFromPtr = aString.length;
	if (countOfStringCharsFromPtr) {
		// we need an access to prefix characters and we choose to compare unichars
		unichar * const stringCharacters = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),1);
		[aString getCharacters:stringCharacters];
		// we need to compare characters one at a time, for that we use a pointer
		unichar * prefixCharsPtr = stringCharacters;
		// we are using a loop, first, we describe the state of the loop
		// node is the parent node we are currently testing
		iTM2PatriciaNode * node = iVarImplementation4iTM3;// this is the starting point of our comparison
		// when entering the loop, we assume that [prefix substringToIndex:countOfStringCharsFromPtr]
		// is exactly the string of the patricia tree up to node (included)
		NSUInteger maxChildIndex;
nextNode:
		if (maxChildIndex = node->countOfChildren) {
			// there are children at this level level
			// compare the characters of the children with the characters of the prefix for each child
			NSUInteger minChildIndex = 0;
			NSUInteger delta = maxChildIndex;
			delta>>=1;
			NSUInteger childIndex = delta;
			iTM2PatriciaNode * child = nil;
nextChild:
			child = node->children[childIndex];
			unichar * childCharsPtr = child->characters;// the first character has already been tested
			NSUInteger countOfChildCharsFromPtr = child->countOfCharacters;
			if (prefixCharsPtr[0]>childCharsPtr[0]) {
				// index is too short
				if (delta) {
					minChildIndex = ++childIndex;
					delta = maxChildIndex - minChildIndex;
					delta>>=1;
					childIndex += delta;
					// if delta > 0
					// minChildIndex < childIndex < maxChildIndex
					// if delta == 0
					// minChildIndex == childIndex < maxChildIndex
					goto nextChild;
				} else {
					// no node will fit
					return NO;
				}
			} else if (prefixCharsPtr[0]<childCharsPtr[0]) {
				// index is too large
				if (delta) {
					delta >>= 1;
					maxChildIndex = childIndex;
					childIndex = minChildIndex + delta;
					goto nextChild;
				} else {
					// no node will fit
					return NO;
				}
			} else {
nextCharacter:
				if (--countOfStringCharsFromPtr) {
				// Here we assume that prefixCharsPtr and the child node have the same first character
				// then things are a little bit different depending on the length of the strings
					++prefixCharsPtr;
					if (--countOfChildCharsFromPtr) {
						++childCharsPtr;					
						if (prefixCharsPtr[0]==childCharsPtr[0]) {
							goto nextCharacter;
						} else {
							// No match
							return NO;
						}
					} else {
						// we must scan further
						node = child;
						goto nextNode;
					}
				} else if (--countOfChildCharsFromPtr) {
					return NO;
				} else {
					//return [self stringListOfNode:child withPrefix:@"PREFIX"];
					if (child->countOfChildren) {
                        object_setClass(self,[iTM2PatriciaNode class]);
						return YES;
					} else {
						// remove child from node
						if (node->countOfChildren) {
							id * newChildren;
							if (newChildren = NSAllocateCollectable((node->countOfChildren-1)*sizeof(id),0)) {
								if (childIndex && !memmove(newChildren,node->children,childIndex*sizeof(id))) {
									LOG4iTM3(@"memmove problem  1");
									return NO;
								}
								if (childIndex<(node->countOfChildren - 1)
									&& !memmove(newChildren+childIndex,node->children+childIndex+1,(node->countOfChildren - childIndex - 1)*sizeof(id)))
								{
									LOG4iTM3(@"memmove problem  2");
									return NO;
								}
								node->children = newChildren;
								--node->countOfChildren;
								return YES;
							} else {
								LOG4iTM3(@"NSAllocateCollectable problem  1");
								return NO;
							}
						} else {
							node->children = 0;
							return YES;
						}
					}
				}
			}
		} else {
			// the root node has no children yet
			return NO;
		}
	} else {
		return NO;
	}
}

- (NSArray *)stringListForPrefix:(NSString *)prefix;
{
	// we will need the number of characters of prefix not previously tested (while entering the loop)
	NSUInteger countOfPrefixCharsFromPtr = prefix.length;// no char tested yet
	if (countOfPrefixCharsFromPtr) {
		// there are characters to be tested
		// we need an access to prefix characters and we choose to compare unichars
		unichar * const prefixCharacters = (unichar *)NSAllocateCollectable(countOfPrefixCharsFromPtr*sizeof(unichar),0);
		[prefix getCharacters:prefixCharacters];
		// we need to compare characters one at a time, for that we use a pointer
		// prefixCharacters is left untouched because it will be freed later
		unichar * prefixCharsPtr = prefixCharacters;
		// we are using a loop, first, we describe the state of the loop
		// node is the parent node we are currently testing
		iTM2PatriciaNode * node = iVarImplementation4iTM3;// this is the starting point of our comparison
		// when entering the loop, we assume that [prefix substringToIndex:prefix.length-countOfPrefixCharsFromPtr]
		// is exactly the string of the patricia tree up to node (included)
		NSUInteger maxChildIndex;
#pragma mark > nextNode, going deeper
nextNode:
		if (maxChildIndex = node->countOfChildren) {
#pragma mark + root node has children
			// there are children at this level level
			// compare the characters of the children with the characters of the prefix for each child
			NSUInteger minChildIndex = 0;
			NSUInteger delta = maxChildIndex;
			delta>>=1;
			NSUInteger childIndex = delta;
			iTM2PatriciaNode * child;
#pragma mark > nextChild:
nextChild:
			child = node->children[childIndex];// it seems that children is node set despite countOfChildren>0, hence the problem below
			unichar * childCharsPtr = child->characters;// EXC_BADiVarACCESS4iTM3 03/18/2007
			NSUInteger countOfChildCharsFromPtr = child->countOfCharacters;// the number of remaining characters to be tested
			if (prefixCharsPtr[0]>childCharsPtr[0]) {
#pragma mark -+ node is too small
				// index is too short
				if (delta) {
#pragma mark -> nextChild if there are nodes to inspect
					minChildIndex = ++childIndex;
					delta = maxChildIndex - minChildIndex;
					delta>>=1;
					childIndex += delta;
					// if delta > 0
					// minChildIndex < childIndex < maxChildIndex
					// if delta == 0
					// minChildIndex == childIndex < maxChildIndex
					goto nextChild;
				} else {
					// no node will fit
					return [NSArray array];
				}
			} else if (prefixCharsPtr[0]<childCharsPtr[0]) {
#pragma mark -+ node is too big
				// index is too large
				if (delta) {
#pragma mark --> nextChild if there are nodes to inspect
					delta >>= 1;
					maxChildIndex = childIndex;
					childIndex = minChildIndex + delta;
					goto nextChild;
				} else {
#pragma mark --- return void array
					// no node will fit
					return [NSArray array];
				}
			} else {
nextCharacter:
				// one more character matches
				if (--countOfPrefixCharsFromPtr) {
#pragma mark -> nextCharacter because we did not scan all prefix
				// Here we assume that prefixCharsPtr and the child node have the same first characters
				// then things are a little bit different depending on the length of the strings
					++prefixCharsPtr;
					if (--countOfChildCharsFromPtr) {
						++childCharsPtr;					
						if (prefixCharsPtr[0]==childCharsPtr[0]) {
							goto nextCharacter;
						} else {
							// No match
							return [NSArray array];
						}
					} else {
						// we must scan further
						node = child;
						goto nextNode;
					}
				} else if (--countOfChildCharsFromPtr) {
					// all the characters of the prefix match, but the child has more characters available
					NSUInteger index = child->countOfCharacters - countOfChildCharsFromPtr;// the number of characters common to the tail of prefix and child
					index = prefix.length - index;
					prefix = [prefix substringToIndex:index];
					return [self stringListOfNode:child withPrefix:prefix];
				} else {
					NSUInteger index = prefix.length - child->countOfCharacters;
					prefix = [prefix substringToIndex:index];
					prefix = [prefix stringByAppendingString:[NSString stringWithCharacters:child->characters length:child->countOfCharacters]];
					return [self stringListOfChildrenOfNode:child withPrefix:prefix];
				}
			}
		} else {
#pragma mark -- return void array
			// the root node has no children yet
			// just add a node with that string
			return [NSArray array];
		}
	} else {
#pragma mark -- return stringList
		return self.stringList;
	}
}

- (NSArray *)stringListOfNode:(iTM2PatriciaNode *)node withPrefix:(NSString *)prefix;
{
	if (node->countOfCharacters) {
		NSString * childString = [NSString stringWithCharacters:node->characters length:node->countOfCharacters];
		prefix = [prefix stringByAppendingString:childString];
	}
	NSMutableArray * list = [NSMutableArray array];
	NSMutableArray * nodeStack = [NSMutableArray array];
	NSMutableArray * indexStack = [NSMutableArray array];
	NSMutableArray * prefixStack = [NSMutableArray array];
	iTM2PatriciaNode * child;
	NSUInteger index = 0;
nextNode:
	if ([node isKindOfClass:[iTM2PatriciaLeafNode class]]) {
		[list addObject: prefix];
	}
nextChild:
	if (index<node->countOfChildren) {
		[nodeStack addObject:[NSValue valueWithPointer:node]];
		[indexStack addObject:[NSNumber numberWithUnsignedInteger:index]];
		[prefixStack addObject:prefix];
		node = node->children[index];
		index = 0;
		prefix = [prefix stringByAppendingString:[NSString stringWithCharacters:node->characters length:node->countOfCharacters]];
		goto nextNode;
	} else if ((node = [nodeStack.lastObject pointerValue])) {
		[nodeStack removeLastObject];
		index = [indexStack.lastObject unsignedIntegerValue]+1;
		child = node->children[index];
		[indexStack removeLastObject];
		prefix = prefixStack.lastObject;
		[prefixStack removeLastObject];
		goto nextChild;
	}
	return list;
}

- (NSArray *)stringListOfChildrenOfNode:(iTM2PatriciaNode *)node withPrefix:(NSString *)prefix;
{
 	NSMutableArray * list = [NSMutableArray array];
	NSMutableArray * nodeStack = [NSMutableArray array];
	NSMutableArray * indexStack = [NSMutableArray array];
	NSMutableArray * prefixStack = [NSMutableArray array];
	iTM2PatriciaNode * child;
	NSUInteger index = 0;
loop:
	if (index<node->countOfChildren) {
		[nodeStack addObject:[NSValue valueWithPointer:node]];
		[indexStack addObject:[NSNumber numberWithUnsignedInteger:index]];
		[prefixStack addObject:prefix];
		node = node->children[index];
		index = 0;
		prefix = [prefix stringByAppendingString:[NSString stringWithCharacters:node->characters length:node->countOfCharacters]];
		if ([node isKindOfClass:[iTM2PatriciaLeafNode class]])
		{
			[list addObject: prefix];
		}
		goto loop;
	} else if ((node = [nodeStack.lastObject pointerValue])) {
		[nodeStack removeLastObject];
		index = [indexStack.lastObject unsignedIntegerValue]+1;
		child = node->children[index];
		[indexStack removeLastObject];
		prefix = prefixStack.lastObject;
		[prefixStack removeLastObject];
		goto loop;
	}
	return list;
}

- (NSArray *)stringList;
{
	return [self stringListOfNode:iVarImplementation4iTM3 withPrefix:@""];
}

- (BOOL)addStrings:(NSArray *)stringList;
{
    BOOL result = YES;
	for (NSString * aString in stringList) {
        result = [self addString:aString] && result;
	}
	return result;
}

- (BOOL)addString:(NSString *)aString;
{
	// we will need the number of characters of aString not previously tested (while entering the loop)
	NSUInteger countOfStringCharsFromPtr = aString.length;
	if (countOfStringCharsFromPtr) {
		// we have something to add, otherwise we will do nothing (this will not be the same later)
		// we need an access to aString characters and we choose to compare unichars
		unichar * const aStringCharacters = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0);
		[aString getCharacters:aStringCharacters];
		// we need to compare characters one at a time, for that we use a pointer
		unichar * stringCharsPtr = aStringCharacters;
		// we are using a loop, first, we describe the state of the loop
		// node is the parent node we are currently testing
		iTM2PatriciaNode * node = iVarImplementation4iTM3;// this is the starting point of our comparison
		// when entering the loop, we assume that [aString substringToIndex:countOfStringCharsFromPtr]
		// is exactly the string of the patricia tree up to node (included)
		// if aString has to be included, it will be a child of node
		id * newChildren;// aux variables
		iTM2PatriciaNode * newChild = nil;
		unichar * newChars;
		iTM2PatriciaNode * commonChild = nil;
		unichar * commonChars = nil;
		unichar * newChildCharsAfterSplit = nil;
#pragma mark > nextNode
nextNode:
		if (node->countOfChildren) {
#pragma mark + root node has children
			// there are children at the first level
			// compare the first characters of the children with the first character of the string for each child
			// in general lexically ordered strings are added sequentially such that we can expect that we will add the string at the end
			// we make a first test to see if it is really what is happening
			NSUInteger childIndex = node->countOfChildren - 1;
			iTM2PatriciaNode * child = node->children[childIndex];
			// this is the first level so we should not have child == (id)-1
			// moreover we always have at this level child->countOfCharacters>0
			
			if (stringCharsPtr[0]>child->characters[0]) {
#pragma mark -+ "];: first character of aSpring is after first character of last child: append a leaf node
				// this is the most frequent situation, at least when adding a list of lexically ordered words
				// I must add the string after the last node
				if (newChildren = (id *)NSAllocateCollectable((node->countOfChildren+1)*sizeof(id),0)) {
					if (memmove(newChildren,node->children,node->countOfChildren*sizeof(id))) {
						if (newChild = [[iTM2PatriciaLeafNode alloc] init]) {
							if (newChars = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0)) {
								if (memmove(newChars,stringCharsPtr,countOfStringCharsFromPtr*sizeof(unichar))) {
									newChild->countOfCharacters = countOfStringCharsFromPtr;
									newChild->characters = newChars;
									newChildren[node->countOfChildren] = newChild;
									++(node->countOfChildren);
									node->children = newChildren;
									return YES;
								} else {
									// report error?
									LOG4iTM3(@"There was a memory problem 1 (memmove)");
								}
                            } else {
								// report error?
								LOG4iTM3(@"There was a memory problem 1 (NSAllocateCollectable)");
							}
						} else {
							// report error?
							LOG4iTM3(@"There was a memory problem 1 (iTM2PatriciaLeafNode)");
						}
					} else {
						// report error?
						LOG4iTM3(@"There was a memory problem 1 (memmove children)");
					}
				} else {
					// report error?
					LOG4iTM3(@"There was a memory problem 1 (NSAllocateCollectable children)");
				}
				return NO;
			} else if (stringCharsPtr[0]==child->characters[0]) {
				// this is the second most frequent situation, at least when adding a list of lexically ordered words
#pragma mark >+ IveFoundACandidateChild current character of aSpring equals first character of last child
IveFoundACandidateChild:
				// Here we assume that stringCharsPtr and the child node have the same first character
				// then things are a little bit different depending on the length of the strings
				++stringCharsPtr;
				--countOfStringCharsFromPtr;
				unichar * childCharsPtr = child->characters + 1;// the first character has already been tested
				NSUInteger countOfChildCharsFromPtr = child->countOfCharacters - 1;
				NSUInteger countOfCommonChars;// will be used later
				if (countOfStringCharsFromPtr > countOfChildCharsFromPtr) {
#pragma mark >-+ nextTest1: if string is longer than the string of the node
nextTest1:
					if (countOfChildCharsFromPtr) {
#pragma mark ---+ if there are still characters in the node
						if (stringCharsPtr[0]>childCharsPtr[0]) {
#pragma mark >--- "];: splitNodeAndInsertAfter if the first remaining char is bigger than the next node char
splitNodeAndInsertAfter:
							// I must split the node and insert a new node after child
							// all the characters before stringCharsPtr are common
							// newChild is the child before the split
							// its string will be the common part
							if (commonChild = [[iTM2PatriciaNode alloc] init]) {
								// copy the characters that have already been tested
								// how many characters have been tested so far: countOfCharacters - countOfChildCharsFromPtr
								countOfCommonChars = child->countOfCharacters - countOfChildCharsFromPtr;
								if ((commonChars = (unichar *)NSAllocateCollectable(countOfCommonChars*sizeof(unichar),0))) {
									if ((memmove(commonChars,child->characters,countOfCommonChars*sizeof(unichar)))) {
										// 2 children
										if ((newChildren = (id *)NSAllocateCollectable(2*sizeof(id),0))) {
											if ((newChildCharsAfterSplit = (unichar *)NSAllocateCollectable(countOfChildCharsFromPtr*sizeof(unichar),0))) {
												if ((memmove(newChildCharsAfterSplit,childCharsPtr,countOfChildCharsFromPtr*sizeof(unichar)))) {
													if ((newChild = [[iTM2PatriciaLeafNode alloc] init])) {
														if ((newChars = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0))) {
															if ((memmove(newChars,stringCharsPtr,countOfStringCharsFromPtr*sizeof(unichar)))) {
																// every memory allocation has succeeded
																// I can now piece all the things together
																node->children[childIndex] = commonChild;
																commonChild->countOfCharacters = countOfCommonChars;
																commonChild->characters = commonChars;
																commonChild->children = newChildren;
																commonChild->countOfChildren = 2;
																commonChild->children[0] = child;// the children are good but the characters are not
																child->characters = newChildCharsAfterSplit;
																child->countOfCharacters = countOfChildCharsFromPtr;
																commonChild->children[1] = newChild;// the end of the string
																newChild->countOfCharacters = countOfStringCharsFromPtr;
																newChild->characters = newChars;
																return YES;
															} else {
																// report error?
																LOG4iTM3(@"There was a memory problem 2 (memmove)");
															}
														} else {
															// report error?
															LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable)");
														}
													} else {
														// report error?
														LOG4iTM3(@"There was a memory problem 2 (iTM2PatriciaLeafNode)");
													}
												} else {
													// report error?
													LOG4iTM3(@"There was a memory problem 2 (memmove commonChars)");
												}
											} else {
												// report error?
												LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable commonChars)");
											}
										} else {
											// report error?
											LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable children)");
										}
									} else {
										// report error?
										LOG4iTM3(@"There was a memory problem 2 (memmove)");
									}
								} else {
									// report error?
									LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable)");
								}
							} else {
								// report error?
								LOG4iTM3(@"There was a memory problem 2 (iTM2PatriciaLeafNode)");
							}
						} else if (stringCharsPtr[0]==childCharsPtr[0]) {
#pragma mark ---> nextTest1: else if both characters are the same
							++stringCharsPtr;// test the next character in the string
							--countOfStringCharsFromPtr;
							++childCharsPtr;// test the next character in the node
							--countOfChildCharsFromPtr;// 
							goto nextTest1;
						} else {
#pragma mark >--- "];: splitNodeAndInsertBefore if the first remaining char is bigger than the next node char
splitNodeAndInsertBefore:
							// I must split the node and insert a new node before child
							// just like above, except for swapped [0] and [1]
							if ((commonChild = [[iTM2PatriciaNode alloc] init])) {
								// copy the characters that have already been tested
								// how many characters have been tested so far: countOfCharacters - countOfChildCharsFromPtr
								countOfCommonChars = child->countOfCharacters - countOfChildCharsFromPtr;
								if ((commonChars = (unichar *)NSAllocateCollectable(countOfCommonChars*sizeof(unichar),0))) {
									if (memmove(commonChars,child->characters,countOfCommonChars*sizeof(unichar))) {
										// 2 children
										if ((newChildren = (id *)NSAllocateCollectable(2*sizeof(id),0))) {
											if ((newChildCharsAfterSplit = (unichar *)NSAllocateCollectable(countOfChildCharsFromPtr*sizeof(unichar),0))) {
												if (memmove(newChildCharsAfterSplit,childCharsPtr,countOfChildCharsFromPtr*sizeof(unichar))) {
													if ((newChild = [[iTM2PatriciaLeafNode alloc] init])) {
														if (newChars = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0)) {
															if (memmove(newChars,stringCharsPtr,countOfStringCharsFromPtr*sizeof(unichar))) {
																// every memory allocation has succeeded
																// I can now piece all the things together
																node->children[childIndex] = commonChild;
																commonChild->countOfCharacters = countOfCommonChars;
																commonChild->characters = commonChars;
																commonChild->children = newChildren;
																commonChild->countOfChildren = 2;
																commonChild->children[1] = child;// the children are good but the characters are not
																child->characters = newChildCharsAfterSplit;
																child->countOfCharacters = countOfChildCharsFromPtr;
																commonChild->children[0] = newChild;// the end of the string
																newChild->countOfCharacters = countOfStringCharsFromPtr;
																newChild->characters = newChars;
																return YES;
															} else {
																// report error?
																LOG4iTM3(@"There was a memory problem 2 (memmove)");
															}
														} else {
															// report error?
															LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable)");
														}
													} else {
														// report error?
														LOG4iTM3(@"There was a memory problem 2 (iTM2PatriciaLeafNode)");
													}
												} else {
													// report error?
													LOG4iTM3(@"There was a memory problem 2 (memmove commonChars)");
												}
											} else {
												// report error?
												LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable commonChars)");
											}
										} else {
											// report error?
											LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable children)");
										}
									} else {
										// report error?
										LOG4iTM3(@"There was a memory problem 2 (memmove)");
									}
								} else {
									// report error?
									LOG4iTM3(@"There was a memory problem 2 (NSAllocateCollectable)");
								}
							} else {
								// report error?
								LOG4iTM3(@"There was a memory problem 2 (iTM2PatriciaLeafNode)");
							}
						}
					} else {
#pragma mark ---> nextNode else no more characters in the node
						// all the test are fullfilled
						// The candidate is the proper child
						// Now I try to find the depper candidate child
						node = child;
						goto nextNode;
					}
				}
				else// if (countOfStringCharsFromPtr <= child->countOfCharacters)
				{
#pragma mark >-+ nextTest2: else string is not longer than the string of the node
nextTest2:
					if (countOfStringCharsFromPtr) {
#pragma mark ---+ there are remaining characters in aString to be tested
						if (stringCharsPtr[0]>childCharsPtr[0]) {
#pragma mark ----> splitNodeAndInsertAfter: if the next remaining character is too big
							goto splitNodeAndInsertAfter;
						} else if (stringCharsPtr[0]==childCharsPtr[0]) {
#pragma mark ----> nextTest2: if the next remaining character is the same
							++stringCharsPtr;// test the next character in the string
							--countOfStringCharsFromPtr;
							++childCharsPtr;// test the next character in the node
							--countOfChildCharsFromPtr;// 
							goto nextTest2;
						} else {
#pragma mark ----> splitNodeAndInsertBefore: if the next remaining character is too small
							goto splitNodeAndInsertBefore;
						}
					} else {
#pragma mark ---+ else the whole aString has been tested
						// I have reached the end of the string
						if (countOfChildCharsFromPtr) {
#pragma mark >---+ "];: splitAndInsertLeaf if there are more characters in the node
							// I must split the node and insert a leaf string node between node and its child
							// all the characters of stringCharsPtr are common
							// newChild is the child before the split
							// its string will be the common part
							if ((newChildren = (id *)NSAllocateCollectable(sizeof(id),0))) {
								if ((newChild = [[iTM2PatriciaLeafNode alloc] init])) {
									countOfCommonChars = child->countOfCharacters - countOfChildCharsFromPtr;
									if ((newChars = (unichar *)NSAllocateCollectable(countOfCommonChars*sizeof(unichar),0))) {
										if (memmove(newChars,child->characters,countOfCommonChars*sizeof(unichar))) {
											if ((newChildCharsAfterSplit = (unichar *)NSAllocateCollectable(countOfChildCharsFromPtr*sizeof(unichar),0))) {
												if (memmove(newChildCharsAfterSplit,childCharsPtr,countOfChildCharsFromPtr*sizeof(unichar))) {
													node->children[childIndex] = newChild;
													newChild->countOfCharacters = countOfCommonChars;
													newChild->characters = newChars;
													newChild->countOfChildren = 1;
													newChild->children = newChildren;
													newChildren[0] = child;
													// the children are good but the characters are not
													// now I have to update the characters in child
													child->countOfCharacters = countOfChildCharsFromPtr;
													child->characters = newChildCharsAfterSplit;
													return YES;
												} else {
													// report error?
													LOG4iTM3(@"There was a memory problem 4 (memmove newChildCharsAfterSplit)");
												}
											} else {
												// report error?
												LOG4iTM3(@"There was a memory problem 4 (NSAllocateCollectable newChildCharsAfterSplit)");
											}
										} else {
											// report error?
											LOG4iTM3(@"There was a memory problem 4 (memmove newChars)");
										}
									} else {
										// report error?
										LOG4iTM3(@"There was a memory problem 4 (NSAllocateCollectable newChars)");
									}
								} else {
									// report error?
									LOG4iTM3(@"There was a memory problem 4 (iTM2PatriciaLeafNode)");
								}
							} else {
								// report error?
								LOG4iTM3(@"There was a memory problem 4 (NSAllocateCollectable children)");
							}
							return NO;
						} else {
#pragma mark ----+ "];: else no more characters in the node either for a patricia leaf node
							object_setClass(self,[iTM2PatriciaLeafNode class]);
                            return YES;
						}
					}
				}
				return NO;
			}
#pragma mark -+ first character of aSpring is before first character of last child
			else if (childIndex) {
#pragma mark --+ 2 children or more
				// the childIndex we are looking for is such that
				// (node->children[childIndex])->characters[0] == stringCharsPtr[0]
				// 0 <= childIndex < lastChildIndex
				// dichotomy
				NSUInteger minChildIndex = 0;
				NSUInteger maxChildIndex = childIndex;
				NSUInteger delta = childIndex;
				delta>>=1;
				childIndex = delta;
#pragma mark >-- nextChild:
nextChild:
				child = node->children[childIndex];
				if (stringCharsPtr[0]>child->characters[0]) {
#pragma mark ---+ node is too small
					// index is too short
					if (delta) {
#pragma mark ----> nextChild if there are nodes to inspect
						minChildIndex = ++childIndex;
						delta = maxChildIndex - minChildIndex;
						delta>>=1;
						childIndex += delta;
						// if delta > 0
						// minChildIndex < childIndex < maxChildIndex
						// if delta == 0
						// minChildIndex == childIndex < maxChildIndex
						goto nextChild;
					} else {
#pragma mark ----+ "];: else insert a new leaf node after this one.
						// I must insert a new node after this one (at index childIndex + 1)
						++ childIndex;
						if ((newChildren = (id *)NSAllocateCollectable((node->countOfChildren+1)*sizeof(id),0))) {
							if (memmove(newChildren,node->children,sizeof(id) * childIndex)) {
								if (memmove(newChildren + childIndex + 1,node->children + childIndex,sizeof(id) * (node->countOfChildren - childIndex))) {
									if ((newChild = [[iTM2PatriciaLeafNode alloc] init])) {
										if ((newChars = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0))) {
											if (memmove(newChars,stringCharsPtr,countOfStringCharsFromPtr*sizeof(unichar))) {
												newChild->countOfCharacters = countOfStringCharsFromPtr;
												newChild->characters = newChars;
												newChildren[childIndex] = newChild;
												node->children = newChildren;
												++(node->countOfChildren);
												return YES;
											} else {
												// report error?
												LOG4iTM3(@"There was a memory problem 5 (memmove newChars)");
											}
										} else {
											// report error?
											LOG4iTM3(@"There was a memory problem 5 (NSAllocateCollectable newChars)");
										}
									} else {
										// report error?
										LOG4iTM3(@"There was a memory problem 5 (iTM2PatriciaLeafNode)");
									}
								} else {
									// report error?
									LOG4iTM3(@"There was a memory problem 5 (memmove children 2)");
								}
							} else {
								// report error?
								LOG4iTM3(@"There was a memory problem 5 (memmove children 1)");
							}
						} else {
							// report error?
							LOG4iTM3(@"There was a memory problem 5 (NSAllocateCollectable children)");
						}
						return NO;
					}
				} else if (stringCharsPtr[0]<child->characters[0]) {
#pragma mark ---+ node is too big
					// index is too large
					if (delta) {
#pragma mark ----> nextChild if there are nodes to inspect
						delta >>= 1;
						maxChildIndex = childIndex;
						childIndex = minChildIndex + delta;
						goto nextChild;
					} else {
#pragma mark ----+ "];: else insert a new leaf node before this one.
						// I must insert a new node before this one (at childIndex exactly)
						if ((newChildren = (id *)NSAllocateCollectable((node->countOfChildren+1)*sizeof(id),0))) {
							if (memmove(newChildren,node->children,sizeof(id) * childIndex)) {
								if (memmove(newChildren + childIndex + 1,node->children + childIndex,sizeof(id) * (node->countOfChildren - childIndex))) {
									if ((newChild = [[iTM2PatriciaLeafNode alloc] init])) {
										if ((newChars = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0))) {
											if (memmove(newChars,stringCharsPtr,countOfStringCharsFromPtr*sizeof(unichar))) {
												newChild->countOfCharacters = countOfStringCharsFromPtr;
												newChild->characters = newChars;
												newChildren[childIndex] = newChild;
												node->children = newChildren;
												++(node->countOfChildren);
												return YES;
											} else {
												// report error?
												LOG4iTM3(@"There was a memory problem 6 (memmove newChars)");
											}
										} else {
											// report error?
											LOG4iTM3(@"There was a memory problem 6 (NSAllocateCollectable newChars)");
										}
									} else {
										// report error?
										LOG4iTM3(@"There was a memory problem 6 (iTM2PatriciaLeafNode)");
									}
								} else {
									// report error?
									LOG4iTM3(@"There was a memory problem 6 (memmove children 2)");
								}
							} else {
								// report error?
								LOG4iTM3(@"There was a memory problem 6 (memmove children 1)");
							}
						} else {
							// report error?
							LOG4iTM3(@"There was a memory problem 6 (NSAllocateCollectable children)");
						}
						return NO;
					}
				} else {
#pragma mark ---+ node is OK: go to IveFoundACandidateChild
					goto IveFoundACandidateChild;
				}
			} else {
#pragma mark --+ "];: 1 child only, add a new leaf node at the beginning or the list
				// no other nodes: I must add the node at the beginning of the list
				if ((newChildren = (id *)NSAllocateCollectable((node->countOfChildren+1)*sizeof(id),0))) {
					if (memmove(newChildren+1,node->children,sizeof(id) * node->countOfChildren)) {
						if ((newChild = [[iTM2PatriciaLeafNode alloc] init])) {
							if ((newChars = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0))) {
								if (memmove(newChars,stringCharsPtr,countOfStringCharsFromPtr*sizeof(unichar))) {
									newChild->countOfCharacters = countOfStringCharsFromPtr;
									newChild->characters = newChars;
									newChildren[0] = newChild;
									node->children = newChildren;
									++(node->countOfChildren);
									return YES;
								} else {
									// report error?
									LOG4iTM3(@"There was a memory problem 7 (memmove newChars)");
								}
							} else {
								// report error?
								LOG4iTM3(@"There was a memory problem 7 (NSAllocateCollectable newChars)");
							}
						} else {
							// report error?
							LOG4iTM3(@"There was a memory problem 7 (iTM2PatriciaLeafNode)");
						}
					} else {
						// report error?
						LOG4iTM3(@"There was a memory problem 7 (memmove children)");
					}
				} else {
					// report error?
					LOG4iTM3(@"There was a memory problem 7 (NSAllocateCollectable children)");
				}
				return NO;
			}
		} else {
#pragma mark + "];: node has no children, just add a child
			// the root node has no children yet
			// just add a node with that string
			if ((newChildren = (id *)NSAllocateCollectable(sizeof(id),0)))  {
				if ((newChild = [[iTM2PatriciaLeafNode alloc] init])) {
					if ((newChars = (unichar *)NSAllocateCollectable(countOfStringCharsFromPtr*sizeof(unichar),0))) {
						if (memmove(newChars,stringCharsPtr,countOfStringCharsFromPtr*sizeof(unichar))) {
							newChild->countOfCharacters = countOfStringCharsFromPtr;
							newChild->characters = newChars;
							newChildren[0] = newChild;
							node->countOfChildren = 1;
							node->children = newChildren;
							return YES;
						} else {
							// report error?
							LOG4iTM3(@"There was a memory problem 8 (memmove newChars)");
						}
					} else {
						// report error?
						LOG4iTM3(@"There was a memory problem 8 (NSAllocateCollectable newChars)");
					}
				} else {
					// report error?
					LOG4iTM3(@"There was a memory problem 8 (iTM2PatriciaLeafNode)");
				}
			} else {
				// report error?
				LOG4iTM3(@"There was a memory problem 8 (NSAllocateCollectable children)");
			}
			return NO;
		}
	}
	return NO;
}

@synthesize iVarImplementation4iTM3;
@end


@implementation iTM2LinkedNode
- (id)initWithValue:(id)value;
{
	if (self = [super init]) {
		self.value = value;
	}
	return self;
}
- (id)copyWithZone:(NSZone *)aZone;
{
	id clone = [[self.class allocWithZone:aZone] initWithValue:self.value];
	return clone;
}
- (id <iTM2LinkedNode>)firstSibling;
{
	id <iTM2LinkedNode> sibling = self;
	id <iTM2LinkedNode> previousSibling = sibling;
	while(previousSibling) {
		sibling = previousSibling;
		previousSibling = sibling.previousSibling;
	}
	return (id)sibling;
}
- (id <iTM2LinkedNode>)lastSibling;
{
	id <iTM2LinkedNode> sibling = self;
	id <iTM2LinkedNode> nextSibling = sibling;
	while (nextSibling) {
		sibling = nextSibling;
		nextSibling = sibling.nextSibling;
	}
	return (id)sibling;
}
- (id <iTM2LinkedNode>)root;
{
	id <iTM2LinkedNode> parent = self;
	id <iTM2LinkedNode> first = parent;
	while (first) {
		parent = first;
		first = parent.firstChild;
	}
	return (id)parent;
}
- (id <iTM2LinkedNode>)deepestFirstChild;
{
	id <iTM2LinkedNode> child = self;
	id <iTM2LinkedNode> first = child;
	while (first) {
		child = first;
		first = child.firstChild;
	}
	return (id)child;
}
- (id <iTM2LinkedNode>)deepestLastChild;
{
	id <iTM2LinkedNode> child = self;
	id <iTM2LinkedNode> last = child;
	while (last) {
		child = last;
		last = child.lastChild;
	}
	return (id)child;
}
- (id <iTM2LinkedNode>)nextNode;
{
	id <iTM2LinkedNode> result = nil;
	if (result = self.firstChild) {
		return result;
	}
	if (result = self.nextSibling) {
		return result;
	}
	id <iTM2LinkedNode> parent = self.parent;
	if (parent) {
        do {
            if (result = parent.nextSibling) {
                return result;
            }
        } while (parent = parent.parent);
    }
	return nil;
}
- (id <iTM2LinkedNode>)previousNode;
{
	id <iTM2LinkedNode> result = self.previousSibling;
	return result?[result deepestLastChild]:self.parent;
}
- (void)detach;
{
	// detach the receiver (and children) from its owning tree
	id <iTM2LinkedNode> node;
	if ((node = self.previousSibling)) {
		NSAssert(node.nextSibling==self,@"Inconsistency");
		// the owner is the previous sibling
		node.nextSibling = self.nextSibling;
		self.nextSibling.previousSibling = node;
		// the parent of this node might be inconsistant
		if (node.parent.lastChild == self) {
			node.parent.lastChild = node;// now it is consistant
		}
		self.previousSibling = nil;// disconnected
	} else if (node = self.parent) {
		NSAssert(node.firstChild==self,@"Inconsistency");
		// the parent is the owner;
		node.firstChild = self.nextSibling;
		if (self.nextSibling) {
			self.nextSibling.previousSibling = nil;
			self.nextSibling = nil;
		} else {
			node.lastChild = nil;// now it is consistant
		}
	} else {
		// the node is already detached
		return;
	}
	self.updateCountOfObjectsInChildNodes;
	self.parent = nil;
	// now theNode is completely detached from its owning tree
}
- (void)insertSibling:(id <iTM2LinkedNode>)theNode;
{
	if (!theNode) {
		return;
	}
	// detach theNode from its tree: the inserted sibling should have no owner, neither parent nor previous sibling
	[theNode detach];
	id <iTM2LinkedNode> sibling = theNode.lastSibling;
	sibling.nextSibling = self.nextSibling;
	id <iTM2LinkedNode> node = theNode;
	self.nextSibling.previousSibling = node;
	self.nextSibling = theNode;
	theNode.previousSibling = self;
	sibling = theNode;
	while (sibling) {
		sibling.parent = self.parent;
		node = sibling;
		sibling = node.nextSibling;
	}
	[self.parent setLastChild:node];
	[self.parent updateCountOfObjectsInChildNodes];
}
- (void)insertFirstChild:(id <iTM2LinkedNode>)theNode;
{
	if (!theNode) {
		return;
	}
	// the inserted sibling should have no owner, neither parent nor previous sibling
	[theNode detach];
	id <iTM2LinkedNode> node = theNode.lastSibling;
	node.nextSibling = self.firstChild;
	self.firstChild.previousSibling = node;
	self.firstChild = theNode;
	node  = self.firstChild;
	id <iTM2LinkedNode> sibling = node;
	do {
		node.parent = self;
		sibling = node;
	} while(node = node.nextSibling);
	if (!self.lastChild) {
		self.lastChild = sibling;
	}
	self.updateCountOfObjectsInChildNodes;
}
- (void)removeChildren;
{
	id <iTM2LinkedNode> node = self.firstChild;
	while (node) {
		node.parent = nil;
		node = node.nextSibling;
	}
	self.firstChild = nil;
	self.lastChild = nil;
	self.updateCountOfObjectsInChildNodes;
}
- (void)removeNextSibling;
{
	[self.nextSibling detach];
}
- (void)removeSiblings;
{
	id <iTM2LinkedNode> node = self.nextSibling;
	if (node) {
		node.previousSibling = nil;
		do {
			node.parent = nil;
		} while(node = node.nextSibling);
	}
	self.nextSibling = nil;
	[self.parent setLastChild:self];
	[self.parent updateCountOfObjectsInChildNodes];
}
- (void)updateCountOfObjectsInChildNodes;
{
	iVarCountOfObjectsInChildNodes4iTM3 = 0;
	if (iVarFirstChild4iTM3) {
		++iVarCountOfObjectsInChildNodes4iTM3;
		id <iTM2LinkedNode> child = self.firstChild;
		self.countOfObjectsInChildNodes += child.countOfObjectsInChildNodes;
		while (child.nextSibling) {
			++self.countOfObjectsInChildNodes;
			child = child.nextSibling;
			self.countOfObjectsInChildNodes += child.countOfObjectsInChildNodes;
		}
	}
	[self.parent updateCountOfObjectsInChildNodes];
	return;
}
- (NSString *)indentation;
{
	return self.parent?[NSString stringWithFormat:@"%@+-",[self.parent indentation]]:@"+-";
}
- (NSString *)description;
{
	NSString * status = @"";
	if (self.parent &&!self.previousSibling && (self != [self.parent firstChild])) {
		status = @"(BAD parent)";
	} else if (self.firstChild && (self != self.firstChild.parent)) {
		status = @"(BAD child)";
	} else if (self.previousSibling && (self != (iTM2LinkedNode *)[self.previousSibling nextSibling])) {
		status = @"(BAD Owner)";
	} else if (self.nextSibling && (self != self.nextSibling.previousSibling)) {
		status = @"(BAD sibling)";
	} else if (self.previousSibling && (self.parent != [self.previousSibling parent])) {
		status = @"(BAD common parent)";
	}
	return [NSString stringWithFormat:@"%@%@(%i)%@",(self.parent?[self.parent indentation]:@""),self.value,self.countOfObjectsInChildNodes,status];
}

@synthesize parent=iVarParent4iTM3;
@synthesize firstChild=iVarFirstChild4iTM3;
@synthesize lastChild=iVarLastChild4iTM3;
@synthesize nextSibling=iVarNextSibling4iTM3;
@synthesize previousSibling=iVarPreviousSibling4iTM3;
@synthesize countOfObjectsInChildNodes=iVarCountOfObjectsInChildNodes4iTM3;
@synthesize value=iVarValue4iTM3;
@end

