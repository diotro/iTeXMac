/*
//
//  @version Subversion: $Id: iTM2MacroKit.m 490 2007-05-04 09:05:15Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

#import "iTM2MacroKit_Model.h"
#import "iTM2MacroKit_Prefs.h"
#import "iTM2MacroKit_Tree.h"
#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2KeyBindingsKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>

NSString * const iTM2MacroTemplateComponent = @"Template";

@implementation iTM2MacroAbstractContextNode(Model)
- (NSXMLDocument *)personalXMLDocument;
{
	NSURL * url = [self personalURL];
	NSXMLDocument * document = [self documentForURL:url];
	if(!document)
	{
		NSBundle * MB = [NSBundle mainBundle];
		NSString * pathExtension = [[self class] pathExtension];
		NSArray * RA = [MB allPathsForResource:iTM2MacroTemplateComponent ofType:pathExtension];
		NSString * path = [RA lastObject];
		if([DFM fileExistsAtPath:path])
		{
			NSError * localError =  nil;
			if(document = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] options:NSXMLNodeCompactEmptyElement error:&localError] autorelease])
			{
				// clean the root element by removing all its children
				NSXMLElement * rootElement = [document rootElement];
				while([[rootElement children] count])
				{
					[rootElement removeChildAtIndex:0];
				}
				[self setDocument:document forURL:url];
			}
			if(localError)
			{
				iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
				return nil;
			}
		}
		else
		{
			iTM2_LOG(@"***  MISSING MACRO TEMPLATE FILE, REPORT ERROR");
			return nil;
		}
	}
	return document;
}
- (NSXMLElement *)personalXMLRootElement;
{
	NSXMLDocument * document = [self personalXMLDocument];
	return [document rootElement];
}
- (NSXMLElement *)templateXMLChildElement;
{
	// this must be abstract
	NSXMLElement * element = [self valueForKeyPath:@"value.templateXMLChildElement"];
	if(element)
	{
		return [[element copy] autorelease];
	}
	NSBundle * MB = [NSBundle mainBundle];
	NSString * pathExtension = [[self class] pathExtension];
	NSArray * RA = [MB allPathsForResource:iTM2MacroTemplateComponent ofType:pathExtension];
	NSString * path = [RA lastObject];
	if([DFM fileExistsAtPath:path])
	{
		NSURL * url = [NSURL fileURLWithPath:path];
		NSError * localError =  nil;
		NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeCompactEmptyElement error:&localError] autorelease];
		if(localError)
		{
			iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
			return nil;
		}
		NSXMLElement * rootElement = [document rootElement];
		NSXMLElement * node = rootElement;
		while(node = (NSXMLElement *)[node nextNode])
		{
			if([node kind] == NSXMLElementKind)
			{
				element = node;
				[element detach];
				[self setValue:element forKeyPath:@"value.templateXMLChildElement"];
				break;
			}
		}
		return [[element copy] autorelease]; 
	}
	else
	{
		iTM2_LOG(@"***  MISSING MACRO TEMPLATE FILE, REPORT");
		return nil;
	}
}
@end

@implementation iTM2MacroAbstractModelNode(Model)
- (id)copyWithZone:(NSZone *)aZone;
{
	id clone = [[[[self class] allocWithZone:aZone] init] autorelease];
	NSXMLElement * element = [self XMLElement];
	element = [element copy];
	[element detach];
	[clone addMutableXMLElement:element];// the clone is not yet connected to any model
	return clone;
}
#pragma mark =-=-=-=-=-  Templates
- (NSString *)pathExtension;
{
	return [[self parent] pathExtension];
}
- (NSXMLElement *)templateXMLChildElement;
{
	return [[self parent] templateXMLChildElement];
}
- (NSXMLElement *)mutablePersonalXMLElement;
{
	// the mutablePersonalXMLElement is the muable XMLElement that belongs to the mutablePersonalXMLElement of the parent
	// for the 
	id myContextNode = [self contextNode];
	id myParent = [self parent];
	if(myParent == myContextNode)
	{
		// this is the top most list either macro or key bindings
		return [myContextNode personalXMLRootElement];
	}
	NSXMLElement * myParentElement = [myParent mutablePersonalXMLElement];
	NSArray * elements = [self mutableXMLElements];
	NSEnumerator * E = [elements objectEnumerator];
	NSXMLElement * element = nil;
next:
	if(element = [E nextObject])
	{
		id parentElement = [element parent];
		if([parentElement isEqual:myParentElement])
		{
			return element;
		}
		else
		{
			goto next;
		}
	}
	else
	{
		if(!element)
		{
			element = [self XMLElement];
		}
		if(!element)
		{
			element = [myParent templateXMLChildElement];
		}
		element = [[element copy] autorelease];
		[myParentElement addChild:element];
		[self addMutableXMLElement:element];
	}
	return element;
}
- (NSXMLElement *)mutableXMLElement;
{
	if(![SUD boolForKey:@"iTM2MacroEditNonPersonal"])
	{
		return [self mutablePersonalXMLElement];// default
	}
	NSArray * elements = [self mutableXMLElements];
	NSXMLElement * element = [elements lastObject];
	if(element)
	{
		return element;
	}
// If I am a list, things are different
	id myContextNode = [self contextNode];
	id myParent = [self parent];
	if(myParent == myContextNode)
	{
		// this is the top most list either macro or key bindings
		return [myContextNode personalXMLRootElement];
	}
	id parentElement = [myParent mutableXMLElement];
	element = [self XMLElement];
	if(!element)
	{
		element = [myParent templateXMLChildElement];
	}
	element = [[element copy] autorelease];
	[parentElement addChild:element];
	[self addMutableXMLElement:element];
	return element;
}
#pragma mark =-=-=-=-=-  Elements
- (NSXMLElement *)XMLElement;
{
	NSArray * elements = [self mutableXMLElements];
	NSXMLElement * element = [elements lastObject];
	if(element)
	{
		return element;
	}
	elements = [self XMLElements];
	element = [elements lastObject];
	return element;
}
- (BOOL)beMutable;
{
	// expected side effect
	return [self mutableXMLElement] != nil;
}
- (NSMutableArray *)XMLElements;
{
	NSMutableArray * XMLElements = [self valueForKeyPath:@"value.XMLElements"];
	if(!XMLElements)
	{
		XMLElements = [NSMutableArray array];
		[self setValue:XMLElements forKeyPath:@"value.XMLElements"];
	}
	return XMLElements;
}
- (NSMutableArray *)mutableXMLElements;
{
	NSMutableArray * mutableXMLElements = [self valueForKeyPath:@"value.mutableXMLElements"];
	if(!mutableXMLElements)
	{
		mutableXMLElements = [NSMutableArray array];
		[self setValue:mutableXMLElements forKeyPath:@"value.mutableXMLElements"];
	}
	return mutableXMLElements;
}
- (void)addXMLElement:(NSXMLElement *)element;
{
	NSParameterAssert(element);
	[[self XMLElements] addObject:element];
	return;
}
- (void)addMutableXMLElement:(NSXMLElement *)element;
{
	NSParameterAssert(element);
	[self willChangeValueForKey:@"isMutable"];
	NSMutableArray * mutableXMLElements = [self mutableXMLElements];
	[mutableXMLElements addObject:element];
	[self didChangeValueForKey:@"isMutable"];
	return;
}
- (void)readXMLElement:(NSXMLElement *)element mutable:(BOOL)mutable;
{
	NSAssert(NO,@"You are not allowed to use this class, override -readXMLRootElement:mutable:");
	return;
}
- (BOOL)isMutable;
{
	NSArray *  mutableXMLElements = [self mutableXMLElements];
	unsigned int count = [mutableXMLElements count];
	return count>0;
}
- (void)removeLastMutableXMLElement;
{
	[self willChangeValueForKey:@"isMutable"];
	NSMutableArray * mutableXMLElements = [self mutableXMLElements];
	NSXMLElement * element = [mutableXMLElements lastObject];
	[element detach];
	[mutableXMLElements removeLastObject];
	[self didChangeValueForKey:@"isMutable"];
	return;
}
#pragma mark =-=-=-=-=-  Properties
- (NSString *)actionName;
{
	return nil;
}
- (NSString *)argument;
{
	return nil;
}
- (NSArray *)IDs;
{
	NSMutableArray * result = [NSMutableArray array];
	NSXMLElement * element;
	NSEnumerator * E = [[self XMLElements] objectEnumerator];
	while(element = [E nextObject])
	{
		[result addObject:[[element attributeForName:@"ID"] stringValue]];
	}
	E = [[self mutableXMLElements] objectEnumerator];
	while(element = [E nextObject])
	{
		[result addObject:[[element attributeForName:@"ID"] stringValue]];
	}
	return result;
}
@end

NSString * const iTM2MacroPathExtension = @"iTM2-macros";

@implementation iTM2MacroContextNode
+ (NSString *)pathExtension;
{
	return iTM2MacroPathExtension;
}
- (id)list;
{
	id result = [self valueForKeyPath:@"value.list"];
	if(!result)
	{
		result = [[[iTM2MacroList allocWithZone:[self zone]] initWithParent:self] autorelease];
		[self setValue:result forKeyPath:@"value.list"];
		result = [self valueForKeyPath:@"value.list"];
	}
	return result;
}
@end

@implementation iTM2MacroList
- (NSIndexPath *)indexPath;
{
	return nil;
}
- (id)nextSibling;
{
	return nil;
}
- (id)nextParentSibling;
{
	return nil;
}
- (id)objectInChildrenWithID:(NSString *)ID;
{
	[self honorURLPromises];
	id D = [self valueForKeyPath:@"value.cachedChildrenIDs"];
	if(![D count])
	{
		D = [NSMutableDictionary dictionary];
		NSArray * children = [self children];
		NSEnumerator * E = [children objectEnumerator];
		id child;
		while(child = [E nextObject])
		{
			NSString * ID = [child ID];
			[D setObject:child forKey:ID];
		}
		[self setValue:D forKeyPath:@"value.cachedChildrenIDs"];
	}
	id result = [D objectForKey:ID];
	return result;
}
- (void)readXMLElement:(NSXMLElement *)element mutable:(BOOL)mutable;
{
	NSArray * children = [element children];
	NSEnumerator * e = [children objectEnumerator];
	while(element = [e nextObject])
	{
		NSXMLNode * node = [element attributeForName:@"ID"];
		NSString * ID = [node stringValue];
		id child = (iTM2MacroNode *)[self objectInChildrenWithID:ID];
		if(child)
		{
			[element detach];
			iTM2_LOG(@"remove element:%@",element);
		}
		else
		{
			child = [[[iTM2MacroNode alloc] initWithParent:self] autorelease];
			[child setID:ID];
			id D = [self valueForKeyPath:@"value.cachedChildrenIDs"];
			[D setObject:child forKey:ID];
			if(mutable)
			{
				[child addMutableXMLElement:element];
			}
			else
			{
				[child addXMLElement:element];
			}
			if(iTM2DebugEnabled)
			{
				child = (iTM2MacroNode *)[self objectInChildrenWithID:ID];
				iTM2_LOG(@"child:%@",child);
			}
		}
	}
	return;
}
#pragma mark =-=-=-=-=-  BINDINGS
+ (void)prefsInitBindings;
{
    [self setKeys:[NSArray arrayWithObjects:@"customOnly",nil]
		triggerChangeNotificationsForDependentKey:@"availableMacros"];
	return;
}
- (id)customOnly;
{
	return [self valueForKeyPath:@"value.customOnly"];
}
- (void)setCustomOnly:(id)sender;
{
	[self willChangeValueForKey:@"customOnly"];
	[self setValue:sender forKeyPath:@"value.customOnly"];
	[self didChangeValueForKey:@"customOnly"];
	[self setValue:nil forKeyPath:@"value.availableMacros"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableMacros
- (NSArray *)_X_availableMacros;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * result = [self valueForKeyPath:@"value.availableMacros"];
	if(result)
	{
		return result;
	}
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT(ID BEGINSWITH \".\")"];
	result = [self children];
	result = [result filteredArrayUsingPredicate:predicate];
	if([[self customOnly] boolValue])
	{
		predicate = [NSPredicate predicateWithFormat:@"isMutable = YES"];
		result = [result filteredArrayUsingPredicate:predicate];
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"ID" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	result = [result sortedArrayUsingDescriptors:SDs];
	[self setValue:result forKeyPath:@"value.availableMacros"];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfAvailableMacros
- (unsigned int)countOfAvailableMacros;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableMacros] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableMacrosAtIndex:
- (id)objectInAvailableMacrosAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableMacros] objectAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableMacrosWithID:
- (id)objectInAvailableMacrosWithID:(NSString *)ID;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString *attributeName = @"ID";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K LIKE '%@'",attributeName, ID];
	NSArray * result = [self _X_availableMacros];
	result = [result filteredArrayUsingPredicate:predicate];
	if(![result count])
	{
		result = [self _X_availableMacros];
		NSEnumerator * E = [result objectEnumerator];
		result = [NSMutableArray array];
		id node;
		while(node = [E nextObject])
		{
			if([ID isEqual:[node ID]])
			{
				[(NSMutableArray *)result addObject:node];
			}
		}
	}
	result = [result lastObject];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromAvailableMacrosAtIndex:
- (void)removeObjectFromAvailableMacrosAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * availableMacros = [self _X_availableMacros];
	id O = [availableMacros objectAtIndex:index];
	if([O isMutable])
	{
		NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:index];
		NSArray * RA = [O mutableXMLElements];
		unsigned int totalNumberOfXMLElements = [RA count];
		RA = [O XMLElements];
		totalNumberOfXMLElements += [RA count];
		if(totalNumberOfXMLElements>1)
		{
			[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"availableMacros"];
			[O removeLastMutableXMLElement];
			[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"availableMacros"];
		}
		else
		{
			[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableMacros"];
			[O setParent:nil];
			[self setValue:nil forKeyPath:@"value.availableMacros"];
			[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableMacros"];
		}
	}
	[self setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inAvailableMacrosAtIndex:withID:
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index withID:(NSString *)ID;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * IDs = [self availableIDs];
	if([IDs containsObject:ID])
	{
		// do nothing, this is already there
		return;
	}
	if(![ID length])
	{
		return;
	}
	NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableMacros"];
	[object setParent:self];
	NSXMLElement * element = [self templateXMLChildElement];
	NSXMLElement * myMutableXMLElement = [self mutableXMLElement];
	[myMutableXMLElement addChild:element];
	[object addMutableXMLElement:element];
	[object setID:ID];
	[self setValue:nil forKeyPath:@"value.availableMacros"];//clean cache
	[self setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableMacros"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inAvailableMacrosAtIndex:
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * ID = [object ID];
	NSArray * IDs = [self availableIDs];
	if([IDs containsObject:ID])
	{
		// do nothing, this is already there
		return;
	}
	if(![ID length])
	{
		ID = @"macro";
		if([IDs containsObject:ID])
		{
			unsigned index = 0;
			do
			{
				ID = [NSString stringWithFormat:@"macro %i",++index];
			}
			while([IDs containsObject:ID]);
		}
	}
	[self insertObject:(id)object inAvailableMacrosAtIndex:(int)index withID:ID];
	IDs = [self availableIDs];// updated
	if(![IDs containsObject:ID])
	{
		iTM2_LOG(@"***  THE MACRO WAS NOT ADDED");
	}
//iTM2_END;
    return;
}
- (NSArray *)availableIDs;
{
	NSMutableArray * availableIDs = [NSMutableArray array];
	NSArray * macros = [self _X_availableMacros];
	NSEnumerator * E = [macros objectEnumerator];
	id macro;
	id ID;
	while(macro = [E nextObject])
	{
		ID = [macro ID];
		if(ID && ![availableIDs containsObject:ID])
		{
			[availableIDs addObject:ID];
		}
	}
	return availableIDs;
}
- (NSXMLElement *)mutableXMLElement;
{
	NSMutableArray * mutableXMLElements = [self mutableXMLElements];
	id lastMutableXMLElement = [mutableXMLElements lastObject];
	if(!lastMutableXMLElement)
	{
		iTM2MacroAbstractContextNode * contextNode = [self contextNode];
		NSXMLDocument * document = [contextNode personalXMLDocument];
		lastMutableXMLElement = [document rootElement];
		[self addMutableXMLElement:lastMutableXMLElement];
	}
	return lastMutableXMLElement; 
}
- (NSXMLElement *)templateXMLChildElement;
{
	return [[self parent] templateXMLChildElement];
}
@end

@implementation iTM2MacroNode(Properties_)
- (NSString *)ID;
{
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node = [element attributeForName:@"ID"];
	NSString * ID = [node stringValue];
	return ID;
}
- (void)setID:(NSString *)newID;
{
	if(![self isMutable])
	{
		return;
	}
	NSString * oldID = [self ID];
	if([oldID isEqual:newID])
	{
		return;
	}
	[self willChangeValueForKey:@"ID"];
	NSXMLElement * element = [self XMLElement];
	[element removeAttributeForName:@"ID"];
	NSXMLNode * node = [NSXMLNode attributeWithName:@"ID" stringValue:newID];
	[element addAttribute:node];
	[self didChangeValueForKey:@"ID"];
	return;
}
- (BOOL)validateID:(NSString **)newIDRef error:(NSError **)outErrorPtr;
{
	if(!newIDRef)
	{
		iTM2_REPORTERROR(1,@"Missing ioValue",nil);
		return NO;
	}
	NSString * newID = *newIDRef;
	NSString * oldID = [self ID];
	if([newID isEqual:oldID])
	{
		return YES;
	}
	if(![newID isKindOfClass:[NSString class]])
	{
		iTM2_OUTERROR(2,@"Expected NSString as ioValue",nil);
		return NO;
	}
	if([newID hasPrefix:@"."])
	{
		iTM2_OUTERROR(3,([NSString stringWithFormat:@"Forbidden \".\" prefix in %@",newID]),nil);
		return NO;
	}
	// there must be no macro already available for that name
	iTM2MacroList * macroList = [self parent];
	NSArray * availableIDs = [macroList availableIDs];
	if([availableIDs containsObject:newID])
	{
		iTM2_OUTERROR(4,([NSString stringWithFormat:@"\"%@\" is already a macro ID",newID]),nil);
		return NO;
	}
	return YES;
}
- (BOOL)isVisible;// binding
{
	return ![[self ID] hasPrefix:@"."];
}
- (SEL)action;
{
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node = [element attributeForName:@"SEL"];
	if(node)
	{
		return NSSelectorFromString([node stringValue]);
	}
	else
	{
		return NULL;
	}
}
- (BOOL)isMessage;
{
	NSArray * responderMessages = [iTM2RuntimeBrowser responderMessages];
	NSString * ID = [self ID];
	SEL selector = NSSelectorFromString(ID);
	NSValue * V = [NSValue valueWithPointer:selector];
	return [responderMessages containsObject:V];
}
- (NSString *)actionName;
{
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node = [element attributeForName:@"SEL"];
	if(![self isVisible])
	{
		return nil;
	}
	else if(node)
	{
		return [node stringValue];
	}
	else
	{
		return [self isMessage]?[self ID]:@"insertMacro:";
	}
}
- (void)setActionName:(NSString *)newActionName;
{
	NSXMLElement * element = [self mutableXMLElement];
	if(!element)
	{
		return;
	}
	NSString * oldActionName = [self actionName];
	if([oldActionName isEqual:newActionName])
	{
		return;
	}
	[self willChangeValueForKey:@"actionName"];
	[element removeAttributeForName:@"SEL"];
	if([@"insertMacro:" isEqual:newActionName] || [@"noop:" isEqual:newActionName] || ![newActionName length])
	{
		;//do nothing
	}
	else
	{
		NSXMLNode * node = [NSXMLNode attributeWithName:@"SEL" stringValue:newActionName];
		[element addAttribute:node];
	}
	[self didChangeValueForKey:@"actionName"];
	return;
}
- (NSString *)name;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"NAME" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no name.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No name available";
	}
}
- (NSString *)tooltip;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"TIP" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no tooltip.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No name tooltip";
	}
}
- (NSString *)argument;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"INS" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no arguments.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return nil;
	}
}
- (void)setArgument:(NSString *)newArgument;
{
	NSString * old = [self argument];
	if([old isEqual:newArgument])
	{
		return;
	}
	[self willChangeValueForKey:@"argument"];
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node = nil;
	if(![self isMutable])
	{
		element = [[element copy] autorelease];
		[element detach];
		// connect to another document
		id myParent = [self parent];
		id otherElement = [myParent templateXMLChildElement];
		node = [otherElement rootDocument];
		[otherElement detach];
		node = [(id)node rootElement];
		[(id)node addChild:element];
		[self addMutableXMLElement:element];
	}
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"INS" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
	}
	if(node = [nodes lastObject])
	{
		[node setStringValue:newArgument];
	}
	else
	{
		node = [NSXMLNode elementWithName:@"INS" stringValue:newArgument];
		[element addChild:node];
	}
	if(![newArgument length])
	{
		[node detach];
	}
	[self didChangeValueForKey:@"argument"];
	return;
}
- (NSString *)concreteArgument;
{
	id result = [self argument];
	if(!result)
	{
		result = [self ID];
	}
	id substitutions = [self valueForKeyPath:@"value.substitutions"];
	if([substitutions count])
	{
		NSString * string1, * string2;
		NSMutableString * result = [NSMutableString stringWithString:result];
		NSEnumerator * E = [substitutions keyEnumerator];
		NSRange range;
		while(string1 = [E nextObject])
		{
			string2 = [substitutions objectForKey:string1];
			range = NSMakeRange(0,[result length]);
			[result replaceOccurrencesOfString:string1 withString:string2 options:nil range:range];
		}
	}
	return result;
}
@end

NSString * const iTM2KeyBindingPathExtension = @"iTM2-key-bindings";

@implementation iTM2KeyBindingContextNode
+ (NSString *)pathExtension;
{
	return iTM2KeyBindingPathExtension;
}
- (id)list;
{
	id result = [self valueForKeyPath:@"value.list"];
	if(!result)
	{
		result = [[[iTM2KeyBindingList allocWithZone:[self zone]] initWithParent:self] autorelease];
		[self setValue:result forKeyPath:@"value.list"];
		result = [self valueForKeyPath:@"value.list"];
	}
	return result;
}
@end

@interface iTM2KeyBindingNode(PRIVATE)
- (void)willChangeKeyStroke;
- (void)didChangeKeyStroke;
- (iTM2MacroKeyStroke *)keyStroke;
- (BOOL)isFinal;
@end

@implementation iTM2KeyBindingNode
#if 0
+ (void)initialize;
{
	[super initialize];
	[self exposeBinding:@"ID2"];
	//NSArray * keys = [NSArray arrayWithObject:@"availableKeyBindings",nil];
	//[self setKeys:keys triggerChangeNotificationsForDependentKey:@"availableKeys"];
	return;
}
#endif
#pragma mark =-=-=-=-=-  NODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableKeyBindings
- (NSArray *)_X_availableKeyBindings;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * result = [self valueForKeyPath:@"value.availableKeyBindings"];
	if(result)
	{
		return result;
	}
	result = [self children];
	NSString *attributeName = @"ID";
	NSString *attributeValue = @"noop:";
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(%K LIKE '%@')",
        attributeName, attributeValue];
	result = [result filteredArrayUsingPredicate:predicate];
	[self setValue:result forKeyPath:@"value.availableKeyBindings"];
//iTM2_END;
    return result;
}
- (NSArray *)availableKeys;
{
	NSMutableArray * availableKeys = [NSMutableArray array];
	NSArray * keyBindings = [self _X_availableKeyBindings];
	NSEnumerator * E = [keyBindings objectEnumerator];
	id keyBinding;
	NSString * key;
	while(keyBinding = [E nextObject])
	{
		key = [keyBinding key];
		if(key && ![availableKeys containsObject:key])
		{
			[availableKeys addObject:key];
		}
	}
	return availableKeys;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	id D = [self valueForKeyPath:@"value.cachedChildrenIDs"];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		[self setValue:D forKeyPath:@"value.cachedChildrenIDs"];
	}
	NSString * ID;
    if ([keyPath isEqual:@"children"])
	{
		[self willChangeValueForKey:@"isIDMutable"];
//		NSNumber * kind = [change objectForKey:NSKeyValueChangeKindKey];
		NSArray * new = [change objectForKey:NSKeyValueChangeNewKey];
		NSEnumerator * newE = [new objectEnumerator];
		NSArray * old = [change objectForKey:NSKeyValueChangeOldKey];
		NSEnumerator * oldE = [old objectEnumerator];
//		NSIndexSet * indexes = [change objectForKey:NSKeyValueChangeIndexesKey];
		id child;
		while(child = [oldE nextObject])
		{
			if(ID = [child ID])
			{
				[D removeObjectForKey:ID];
			}
		}
		while(child = [newE nextObject])
		{
			[child addObserver:self forKeyPath:@"value.ID" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
		}
		[self didChangeValueForKey:@"isIDMutable"];
		return;
    }
	else if([keyPath isEqual:@"value.ID"])
	{
		[object removeObserver:self forKeyPath:keyPath];
		if(ID = [object valueForKeyPath:keyPath])
		{
			[D setObject:object forKey:ID];
		}
	}
#if 0
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
#endif
	return;
}
- (id)objectInAvailableKeyBindingsWithKey:(NSString *)key;
{
	[self honorURLPromises];
	id D = [self valueForKeyPath:@"value.cachedChildrenKeys"];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		NSArray * children = [self children];
		NSEnumerator * E = [children objectEnumerator];
		id child;
		while(child = [E nextObject])
		{
			NSString * key = [child key];
			[D setObject:child forKey:key];
		}
		[self setValue:D forKeyPath:@"value.cachedChildrenKeys"];
	}
	id result = [D objectForKey:key];
	return result;
}
- (void)readXMLElement:(NSXMLElement *)element mutable:(BOOL)mutable;
{
	id D = [self valueForKeyPath:@"value.cachedChildrenKeys"];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		[self setValue:D forKeyPath:@"value.cachedChildrenKeys"];
	}
	NSArray * children = [element children];
	NSEnumerator * e = [children objectEnumerator];
	while(element = [e nextObject])
	{
		NSXMLNode * node = [element attributeForName:@"KEY"];
		NSString * key = [node stringValue];
		id child = (iTM2KeyBindingNode *)[self objectInAvailableKeyBindingsWithKey:key];
		if(child)
		{
			if(mutable)
			{
				[child addMutableXMLElement:element];
			}
			else
			{
				[child addXMLElement:element];
			}
		}
		else if(child = [[[iTM2KeyBindingNode alloc] initWithParent:self] autorelease])
		{
			[child setKey:key];
			if(mutable)
			{
				[child addMutableXMLElement:element];
			}
			else
			{
				[child addXMLElement:element];
			}
			[child readXMLElement:element mutable:mutable];
			[D setObject:child forKey:key];
			if(iTM2DebugEnabled)
			{
				child = (iTM2KeyBindingNode *)[self objectInAvailableKeyBindingsWithKey:key];
				iTM2_LOG(@"child:%@",child);
				if(!child)
				{
					iTM2_LOG(@"BIG ERROR");
				}
			}
		}
		else
		{
			iTM2_LOG(@"Could not create a child:%@",child);
		}
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfAvailableKeyBindings
- (unsigned int)countOfAvailableKeyBindings;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableKeyBindings] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indexOfObjectInAvailableKeyBindings:
- (unsigned int)indexOfObjectInAvailableKeyBindings:(id)object;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableKeyBindings] indexOfObject:object];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableKeyBindingsAtIndex:
- (id)objectInAvailableKeyBindingsAtIndex:(int) index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableKeyBindings] objectAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inAvailableKeyBindingsAtIndex:
- (void)insertObject:(id)object inAvailableKeyBindingsAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [object key]?:@"";
	NSArray * keys = [self availableKeys];
	if([keys containsObject:key])
	{
		// do nothing, this is already there
		return;
	}
	NSXMLElement * myLastMutableXMLElement = [self mutableXMLElement];// side effect expected
	if(myLastMutableXMLElement)
	{
		NSXMLElement * myTemplateXMLElement = [self templateXMLChildElement];
		if(myTemplateXMLElement)
		{
			NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:index];
			[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
			[object setParent:self];
			[myLastMutableXMLElement addChild:myTemplateXMLElement];
			[object addMutableXMLElement:myTemplateXMLElement];
			[object setKey:key];// only now: before the object was not mutable and could not change its key
			[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
			[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
			keys = [self availableKeys];// updated
			if(![keys containsObject:key])
			{
				iTM2_LOG(@"***  THE KEY WAS NOT ADDED");
			}
			[self setValue:nil forKeyPath:@"value.cachedChildrenKeys"];
			//[SMC willChangeValueForKey:@"keyBindingEditor"];
			[self willChangeValueForKey:@"availableKeys"];
			[self setValue:nil forKeyPath:@"value.availableKeys"];
			[self setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
			[self didChangeValueForKey:@"availableKeys"];
			//[SMC didChangeValueForKey:@"keyBindingEditor"];
			NSIndexPath * indexPath = [self indexPath];
iTM2_LOG(@"Object inserted at:%@",indexPath);
#if 0
			[SMC setSelectionIndexPaths:[NSArray arrayWithObject:indexPath]];
#endif
		}
		else
		{
			iTM2_LOG(@"SORRY: I have no XML template:%@",self);
		}
	}
	else
	{
		iTM2_LOG(@"SORRY: I am not mutable:%@",self);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeObjectFromAvailableKeyBindingsAtIndex:
- (void)removeObjectFromAvailableKeyBindingsAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * availableKeyBindings = [self _X_availableKeyBindings];
	id O = [availableKeyBindings objectAtIndex:index];
	NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
	if([[O mutableXMLElements] count])
	{
		[O removeLastMutableXMLElement];
		if([[O XMLElements] count] || [[O mutableXMLElements] lastObject])
		{
			[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
			[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
			[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
		}
		else
		{
			[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
			[O setParent:nil];// no more related XML element: clean all
			[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
			[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
		}
	}
	else if([[O XMLElements] count])
	{
		[self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
		[O beMutable];
		[O setID:@"noop:"];
		[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
		[self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
	}
	else
	{
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
		[O setParent:nil];// no more related XML element: clean all
		[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
	}
	[self setValue:nil forKeyPath:@"value.cachedChildrenKeys"];
//iTM2_END;
    return;
}
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%@(%#x):%@>",NSStringFromClass([self class]),self,[self key]];
}
#pragma mark =-=-=-=-=-  LEAF
- (NSString *)key;
{
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node = [element attributeForName:@"KEY"];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return nil;
	}
}
- (void)setKey:(NSString *)newKey;
{
	if(![self isMutable])
	{
		return;
	}
	NSString * oldKey = [self key];
	if([oldKey isEqual:newKey])
	{
		return;
	}
	[self willChangeKeyStroke];
	[self setValue:nil forKeyPath:@"value.keyStroke"];
	NSXMLElement * element = [self XMLElement];
	[element removeAttributeForName:@"KEY"];
	NSXMLNode * node = [NSXMLNode attributeWithName:@"KEY" stringValue:newKey];
	[element addAttribute:node];
	[self keyStroke];// this is useful for reentrant problem
	[self didChangeKeyStroke];
	return;
}
- (BOOL)validateKey:(NSString **)newKeyRef error:(NSError **)outErrorPtr;
{
	if(!newKeyRef)
	{
		iTM2_REPORTERROR(1,@"Missing ioValue",nil);
		return NO;
	}
	NSString * newKey = *newKeyRef;
	NSString * oldKey = [self key];
	if([newKey isEqual:oldKey])
	{
		return YES;
	}
	if(![newKey isKindOfClass:[NSString class]])
	{
		iTM2_OUTERROR(2,@"Expected NSString as ioValue",nil);
		return NO;
	}
	// there must be no macro already available for that name
	iTM2KeyBindingList * list = [self parent];
	NSArray * availableKeys = [list availableKeys];
	if([availableKeys containsObject:newKey])
	{
		iTM2_OUTERROR(4,([NSString stringWithFormat:@"\"%@\" is already a macro Key",newKey]),nil);
		return NO;
	}
	return YES;
}
- (iTM2MacroKeyStroke *)keyStroke;
{
	id result = [self valueForKeyPath:@"value.keyStroke"];
	if(result)
	{
		return result;
	}
	result = [self key];
	result = [result macroKeyStroke];
	[self setValue:result forKeyPath:@"value.keyStroke"];
	return result;
}
- (void)willChangeKeyStroke;
{
	id parent = [self parent];
	id D = [parent valueForKeyPath:@"value.cachedChildrenKeys"];
	NSString * key = [self key];
	if(key)
	{
		[D removeObjectForKey:key];
	}
	[self willChangeValueForKey:@"prettyKey"];
	[self willChangeValueForKey:@"codeName"];
	[self willChangeValueForKey:@"isControl"];
	[self willChangeValueForKey:@"isFunction"];
	[self willChangeValueForKey:@"isShift"];
	[self willChangeValueForKey:@"isAlternate"];
	[self willChangeValueForKey:@"isCommand"];
	return;
}
- (void)didChangeKeyStroke;
{
	NSString *oldKey = [self key];
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	[macroKeyStroke update];
	NSString * newKey = [macroKeyStroke string];
	if(newKey && ![oldKey isEqual:newKey])
	{
		[self setKey:newKey];
	}
	[self didChangeValueForKey:@"isCommand"];
	[self didChangeValueForKey:@"isAlternate"];
	[self willChangeValueForKey:@"isFunction"];
	[self didChangeValueForKey:@"isShift"];
	[self didChangeValueForKey:@"isControl"];
	[self didChangeValueForKey:@"codeName"];
	[self didChangeValueForKey:@"prettyKey"];
	id parent = [self parent];
	id D = [parent valueForKeyPath:@"value.cachedChildrenKeys"];
	NSString * key = [self key];
	if(key)
	{
		[D setObject:self forKey:key];
	}
	return;
}
- (NSString *)prettyKey;
{
	NSString * result = [[self keyStroke] description];
	return result?:@"???";
}
- (NSString *)ID;
{
	if([[self _X_availableKeyBindings] count]>0)
	{
		return @" ";// with @"", the binding does not work
	}
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node = [element attributeForName:@"ID"];
	NSString * ID = [node stringValue];
	return ID;
}
- (void)setID:(NSString *)newID;
{
	if(![self beMutable])
	{
		return;
	}
	NSString * oldID = [self ID];
	if([oldID isEqual:newID])
	{
		return;
	}
	[self willChangeValueForKey:@"isVisible"];
	[self willChangeValueForKey:@"actionName"];
	[self willChangeValueForKey:@"ID"];
	NSXMLElement * element = [self XMLElement];
	[element removeAttributeForName:@"ID"];
	NSXMLNode * node = [NSXMLNode attributeWithName:@"ID" stringValue:newID];
	[element addAttribute:node];
	[self didChangeValueForKey:@"ID"];
	[self didChangeValueForKey:@"actionName"];
	[self didChangeValueForKey:@"isVisible"];
	return;
}
- (BOOL)validateID:(NSString **)newIDRef error:(NSError **)outErrorPtr;
{
	if([[self _X_availableKeyBindings] count]>0)
	{
		iTM2_OUTERROR(6,@"No ID should be given to the start of a multi keystroke sequence",nil);
		return NO;// with @"", the binding does not work
	}
	if(!newIDRef)
	{
		iTM2_REPORTERROR(1,@"Missing ioValue",nil);
		return NO;
	}
	NSString * newID = *newIDRef;
	NSString * oldID = [self ID];
	if([newID isEqual:oldID])
	{
		return YES;
	}
	if(![newID isKindOfClass:[NSString class]])
	{
		iTM2_OUTERROR(2,@"Expected NSString as ioValue",nil);
		return NO;
	}
	if([newID hasPrefix:@"."])
	{
		iTM2_OUTERROR(3,([NSString stringWithFormat:@"Forbidden \".\" prefix in %@",newID]),nil);
		return NO;
	}
	return YES;
}
#if 0
- (NSString *)ID2;
{
	NSString * ID = [self ID];
	return ID;
}
- (void)setID2:(NSString *)new;
{
	NSString * old = [self ID2];
	if([old isEqual:new])
	{
		return;
	}
	if(new)// change only when there 
	{
		[self willChangeValueForKey:@"ID2"];
		[self setID:new];
		[self didChangeValueForKey:@"ID2"];
	}
	return;
}
#endif
- (BOOL)isVisible;// binding
{
	return ![[self ID] hasPrefix:@"."];
}
- (BOOL)isActionMutable;
{
	return [self isFinal] && [self isVisible];
}
- (BOOL)isIDMutable;
{
	return [[self _X_availableKeyBindings] count]==0;
}
- (BOOL)isFinal;
{
	unsigned I = [[self _X_availableKeyBindings] count];
	return I==0;
}
- (BOOL)isMutable;
{
	return YES;
}
- (NSString *)codeName;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	return macroKeyStroke?macroKeyStroke->codeName:nil;
}
- (BOOL)isShift;
{
	NSString * codeName = [self codeName];
	if(([codeName length]==1) && ([codeName characterAtIndex:0]>='A') && ([codeName characterAtIndex:0]<='Z'))
	{
		return YES;
	}
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	return macroKeyStroke?macroKeyStroke->isShift:NO;
}
- (BOOL)isFunction;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	return macroKeyStroke?macroKeyStroke->isFunction:NO;
}
- (BOOL)isControl;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	return macroKeyStroke?macroKeyStroke->isControl:NO;
}
- (BOOL)isCommand;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	return macroKeyStroke?macroKeyStroke->isCommand:NO;
}
- (BOOL)isAlternate;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	return macroKeyStroke?macroKeyStroke->isAlternate:NO;
}
- (void)setCodeName:(NSString *)newCodeName;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	[self willChangeKeyStroke];
	if(macroKeyStroke)
	{
		[macroKeyStroke->codeName autorelease];
		macroKeyStroke->codeName = [newCodeName copy];
	}
	else
	{
		macroKeyStroke = [[[iTM2MacroKeyStroke alloc] initWithCodeName:newCodeName] autorelease];
		[self setValue:macroKeyStroke forKeyPath:@"value.keyStroke"];
	}
	[self didChangeKeyStroke];
}
- (void)setIsShift:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeKeyStroke];
	macroKeyStroke->isShift = yorn;
	[self didChangeKeyStroke];
}
- (void)setIsFunction:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeKeyStroke];
	macroKeyStroke->isFunction = yorn;
	[self didChangeKeyStroke];
}
- (void)setIsControl:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeKeyStroke];
	macroKeyStroke->isControl = yorn;
	[self didChangeKeyStroke];
}
- (void)setIsCommand:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeKeyStroke];
	macroKeyStroke->isCommand = yorn;
	[self didChangeKeyStroke];
}
- (void)setIsAlternate:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeKeyStroke];
	macroKeyStroke->isAlternate = yorn;
	[self didChangeKeyStroke];
}
- (BOOL)canShift;
{
	return [self keyStroke] != nil;
}
- (BOOL)canFunction;
{
	return [self keyStroke] != nil;
}
- (BOOL)canControl;
{
	return [self keyStroke] != nil;
}
- (BOOL)canCommand;
{
	return [self keyStroke] != nil;
}
- (BOOL)canAlternate;
{
	return [self keyStroke] != nil;
}
@end

@implementation iTM2KeyBindingList
- (NSIndexPath *)indexPath;
{
	return nil;
}
- (id)nextSibling;
{
	return nil;
}
- (id)nextParentSibling;
{
	return nil;
}
@end

@implementation iTM2MacroKeyStroke
- (id)initWithCodeName:(NSString*)newCodeName;
{
	if(self = [super init])
	{
		[self setCodeName:newCodeName];
	}
	return self;
}
- (id)copyWithZone:(NSZone *)zone;
{
	iTM2MacroKeyStroke * result = [[[self class] alloc] initWithCodeName:self->codeName];
	result->isCommand = self->isCommand;
	result->isShift = self->isShift;
	result->isAlternate = self->isAlternate;
	result->isControl = self->isControl;
	result->isFunction = self->isFunction;
	return result;
}
- (void)update;
{
	[_description autorelease];
	_description = nil;
	[_string autorelease];
	_string = nil;
	return;
}
- (void)dealloc;
{
	[self setCodeName:nil];
	[self update];
	[super dealloc];
	return;
}
- (void)setCodeName:(NSString *)newCodeName;
{
	if(newCodeName && ![newCodeName isKindOfClass:[NSString class]])
	{
		iTM2_LOG(@"ARRIBA");
	}
	[self->codeName autorelease];
	self->codeName = [newCodeName copy];
	return;
}
- (NSString *)string;
{
	if(_string)
	{
		return _string;
	}
	if(codeName)
	{
		NSString * isCommandString = isCommand?@"@":@"";
		NSString * isShiftString = isShift?@"$":@"";
		NSString * isAlternateString = isAlternate?@"~":@"";
		NSString * isControlString = isControl?@"^":@"";
		NSString * isFunctionString = isFunction?@"&":@"";
		NSString * modifier = [NSString stringWithFormat:@"%@%@%@%@%@",isCommandString, isShiftString, isAlternateString, isControlString, isFunctionString];
		if([modifier length])
		{
			_string = [[NSString stringWithFormat:@"%@+%@",modifier, codeName] retain];
		}
		else
		{
			_string = [codeName copy];
		}
	}
	else
	{
		_string = @"";
	}
	return _string;
}
- (NSString *)description;
{
	if(_description)
	{
		return _description;
	}
	if(codeName)
	{
		NSMutableString * result = [NSMutableString string];
		if(isShift)
		{
			[result appendString:[NSString stringWithUTF8String:"⇧"]];
		}
		else if(([codeName length]==1) && ([codeName characterAtIndex:0]>='A') && ([codeName characterAtIndex:0]<='Z'))
		{
			[result appendString:[NSString stringWithUTF8String:"⇧"]];
		}
		if(isControl)
		{
			[result appendString:[NSString stringWithUTF8String:" ctrl "]];
		}
		if(isAlternate)
		{
			[result appendString:[NSString stringWithUTF8String:"⌥"]];
		}
		if(isCommand)
		{
			[result appendString:[NSString stringWithUTF8String:"⌘"]];
		}
		if(isFunction)
		{
			[result appendString:[NSString stringWithUTF8String:" fn "]];
		}
		if([result length])
		{
			[result appendString:@" "];
		}
		NSString * CN;
		if(([codeName length]==1) && ([codeName characterAtIndex:0]>='a') && ([codeName characterAtIndex:0]<='z'))
		{
			CN = [codeName uppercaseString];
		}
		else
		{
			CN = codeName;
		}
		NSString * localized = [KCC localizedNameForCodeName:CN];
		[result appendString:localized];
		[result replaceOccurrencesOfString:@"  " withString:@" " options:0 range:NSMakeRange(0,[result length])];
		_description = [result stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		_description = [_description copy];
	}
	else
	{
		_description = @"";
	}	
	return _description;
}
@end

@implementation NSString(iTM2MacroKeyStroke)
- (iTM2MacroKeyStroke *)macroKeyStroke;
{
	if(![self length])
	{
		return nil;
	}
	NSString * key = nil;
	NSString * modifier = nil;
	NSRange R = [self rangeOfString:@"+"];// the first occurrence of the '+' is the separator between modifier and key, unless it is also yhe last character
	if(R.length)
	{
		key = [self substringFromIndex:NSMaxRange(R)];
		if([key length])
		{
			modifier = [self substringToIndex:R.location];
		}
		else
		{
			key = self;
		}
	}
	else
	{
		key = self;
	}
	iTM2MacroKeyStroke * result = [[[iTM2MacroKeyStroke alloc] initWithCodeName:key] autorelease];
	unsigned int index = [modifier length];
	while(index--)
	{
		switch([modifier characterAtIndex:index])
		{
			case '@':
				result->isCommand = YES;
				break;
			case '$':
				result->isShift = YES;
				break;
			case '~':
				result->isAlternate = YES;
				break;
			case '^':
				result->isControl = YES;
				break;
			case '&':
				result->isFunction = YES;
				break;
		}
	}
	return result;
}
@end

@implementation NSEvent(iTM2MacroKeyStroke)
/*
	What are the rules for a special treatment: based on
	0 - keep the modified characters
	1 - if the characters corresponds to a function key (NS...FunctionKey)
		remove the eventual function modifier key, stop here
	2 - if the characters without modifiers and the characters are the same, stop here
	3 - if shift is modified and the characters have a lowercase version different from the uppercase one, remove the shift modifier key
	4 - remove the alt modifier, if any
	
*/
- (iTM2MacroKeyStroke *)macroKeyStroke;
{
	if([self type] != NSKeyDown)
	{
		return nil;
	}
	NSMutableString * completeCodeName = [NSMutableString string];
	unsigned int modifierFlags = [self modifierFlags];
	modifierFlags &= NSDeviceIndependentModifierFlagsMask;

	NSString * Cs = [self characters];
	NSString * CIMs = [self charactersIgnoringModifiers];
	if([Cs length] && [CIMs length])
	{
		unichar c = [Cs characterAtIndex:0];
		NSString * name = [KCC nameForKeyCode:c];
		if([name hasSuffix:@"FunctionKey"])
		{
			if(modifierFlags&NSShiftKeyMask)		[completeCodeName appendString:@"$"];
			if(modifierFlags&NSAlternateKeyMask)	[completeCodeName appendString:@"~"];
			if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
			if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
			if([completeCodeName length])			[completeCodeName appendString:@"+"];
													[completeCodeName appendString:name];
iTM2_LOG(completeCodeName);
			return [completeCodeName macroKeyStroke];
		}
		if(c<'!' || c>'~')
		{
			id result = [Cs macroKeyStroke];
			if(result)
			{
				return result;
			}
		}
		CIMs = Cs;
		modifierFlags &= ~NSShiftKeyMask;
		modifierFlags &= ~NSAlternateKeyMask;
		if(modifierFlags&NSShiftKeyMask)
		{
			NSString * lowerCIMs = [CIMs lowercaseString];
			if(![lowerCIMs isEqual:CIMs] || (c>='!' && c<='~'))
			{
				modifierFlags &= ~NSShiftKeyMask;
			}
			if(modifierFlags&NSShiftKeyMask)		[completeCodeName appendString:@"$"];
			if(modifierFlags&NSAlternateKeyMask)	[completeCodeName appendString:@"~"];
			if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
			if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
			if(modifierFlags&NSFunctionKeyMask)		[completeCodeName appendString:@"&"];
			if([completeCodeName length])			[completeCodeName appendString:@"+"];
													[completeCodeName appendString:name];
			return [completeCodeName macroKeyStroke];
		}
		if(modifierFlags&NSAlternateKeyMask)	[completeCodeName appendString:@"~"];
		if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
		if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
		if([completeCodeName length])			[completeCodeName appendString:@"+"];
												[completeCodeName appendString:name];
	}
iTM2_LOG(completeCodeName);
	return [completeCodeName macroKeyStroke];
}
@end
