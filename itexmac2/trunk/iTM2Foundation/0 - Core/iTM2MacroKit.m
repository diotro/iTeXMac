/*
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2MacroKit.h>

#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2TaskKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2InheritanceKit.h>

NSString * const iTM2TextPlaceholderMark = @"@@";

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

NSString * const iTM2MacroControllerComponent = @"Macros.localized";
NSString * const iTM2MacroPersonalComponent = @"Personal";
NSString * const iTM2MacroServerSummaryComponent = @"Summary";
NSString * const iTM2MacroTemplateComponent = @"Template";
NSString * const iTM2MacrosDirectoryName = @"Macros";
NSString * const iTM2MacroPathExtension = @"iTM2-macros";
NSString * const iTM2MacroMenuPathExtension = @"iTM2-menu";

NSString * const iTM2KeyBindingPathExtension = @"iTM2-key-bindings";

@interface iTM2MacroRootNode: iTM2TreeNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
- (NSArray *)availableDomains;
@end

@implementation iTM2MacroRootNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
{
	return [self objectInChildrenWithValue:domain forKeyPath:@"value.domain"];
}
- (NSArray *)availableDomains;
{
	NSMutableArray * result = [NSMutableArray array];
	NSArray * children = [self children];
	NSEnumerator * E = [children objectEnumerator];
	id child;
	id domain;
	while(child = [E nextObject])
	{
		domain = [child valueForKeyPath:@"value.domain"];
		if(domain && ![result containsObject:domain])
		{
			[result addObject:domain];
		}
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	[result sortUsingDescriptors:SDs];
	return result;
}
@end

@interface iTM2MacroDomainNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent domain:(NSString *)domain;
- (id)objectInChildrenWithCategory:(NSString *)category;
- (NSArray *)availableCategories;
@end

@implementation iTM2MacroDomainNode
- (id)initWithParent:(iTM2TreeNode *)parent domain:(NSString *)domain;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:domain forKeyPath:@"value.domain"];
	}
	return self;
}
- (id)objectInChildrenWithCategory:(NSString *)category;
{
	return [self objectInChildrenWithValue:category forKeyPath:@"value.category"];
}
- (NSArray *)availableCategories;
{
	NSMutableArray * result = [NSMutableArray array];
	NSArray * children = [self children];
	NSEnumerator * E = [children objectEnumerator];
	id child;
	id category;
	while(child = [E nextObject])
	{
		category = [child valueForKeyPath:@"value.category"];
		if(category && ![result containsObject:category])
		{
			[result addObject:category];
		}
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	[result sortUsingDescriptors:SDs];
	return result;
}
@end

@interface iTM2MacroCategoryNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent category:(NSString *)category;
- (id)objectInChildrenWithContext:(NSString *)context;
- (id)objectInChildrenWithMutableContext:(NSString *)context;
@end

@implementation iTM2MacroCategoryNode
- (id)initWithParent:(iTM2TreeNode *)parent category:(NSString *)category;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:category forKeyPath:@"value.category"];
	}
	return self;
}
- (id)objectInChildrenWithContext:(NSString *)context;
{
	return [self objectInChildrenWithValue:context forKeyPath:@"value.context"];
}
- (id)objectInChildrenWithMutableContext:(NSString *)context;
{
	return [self objectInChildrenWithValue:context forKeyPath:@"value.mutableContext"];
}
@end

@interface iTM2MacroContextNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
- (id)objectInChildrenWithID:(NSString *)ID;
- (NSArray *)availableIDs;
- (NSXMLElement *)templateXMLElement;
- (Class)leafClass;
- (NSString *)pathExtension;
- (void)readXMLElement:(NSXMLElement *)element mutable:(BOOL)mutable;
@end

@interface iTM2MacroDocumentManager:iTM2Object
+ (void)addURLPromise:(NSURL *)url client:(id)client;
+ (void)honorURLPromisesOfClient:(id)client;
+ (void)readContentOfURL:(NSURL *)url client:(id)client;
+ (NSArray *)documentURLsOfClient:(id)client;
+ (NSArray *)honoredDocumentURLsOfClient:(id)client;
+ (NSXMLDocument *)documentForURL:(NSURL *)url client:(id)client;
+ (void)setDocument:(NSXMLDocument *)document forURL:(NSURL *)url client:(id)client;
+ (NSXMLElement *)templateXMLElementOfClient:(id)client;
+ (NSURL *)personalURLOfClient:(id)client;
@end

@implementation iTM2MacroDocumentManager
+ (void)addURLPromise:(NSURL *)url client:(id)client;
{
	NSMutableArray * URLsPromise = [client valueForKeyPath:@"value.URLsPromise"];
	if(!URLsPromise)
	{
		URLsPromise = [NSMutableArray array];
		[client setValue:URLsPromise forKeyPath:@"value.URLsPromise"];
		URLsPromise = [client valueForKeyPath:@"value.URLsPromise"];
	}
	[URLsPromise addObject:url];
iTM2_LOG(@"url:%@",url);
	return;
}
+ (void)readContentOfURL:(NSURL *)url client:(id)client;
{
	NSMutableDictionary * documentsByURLs = [client valueForKeyPath:@"value.documentsByURLs"];
	if(!documentsByURLs)
	{
		documentsByURLs = [NSMutableDictionary dictionary];
		[client setValue:documentsByURLs forKeyPath:@"value.documentsByURLs"];
	}
	NSArray * allKeys = [documentsByURLs allKeys];
	if([allKeys containsObject:url])
	{
		return;
	}
	NSBundle * MB = [NSBundle mainBundle];
	NSString * dir = [MB pathForSupportDirectory:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:NO];
	NSString * path = [url path];
	BOOL mutable = path && [DFM isWritableFileAtPath:path] && [path belongsToDirectory:dir];
iTM2_LOG(@"mutable:%@\ndir: %@\npath:%@",(mutable?@"Y":@"N"),dir,path);
	NSError * localError =  nil;
//			NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodePreserveAll error:&localError] autorelease];// raise for an unknown reason
	NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeCompactEmptyElement error:&localError] autorelease];
iTM2_LOG(@"document:%@",document);
	if(localError)
	{
		iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
	}
	else
	{
		[documentsByURLs setObject:document forKey:url];
		NSMutableArray * URLsPromise = [[[client valueForKeyPath:@"value.URLsPromise"] retain] autorelease];// for the reentrant management
		if(![URLsPromise containsObject:url])
		{
			return;
		}
		[[url retain] autorelease];
		[URLsPromise removeObject:url];
		// now create the children
		// also manage the mutability
		NSXMLElement * rootElement = [document rootElement];
		[client readXMLElement:rootElement mutable:mutable];
	}
	return;
}
+ (void)honorURLPromisesOfClient:(id)client;
{
	NSMutableArray * URLsPromise = [client valueForKeyPath:@"value.URLsPromise"];
	NSEnumerator * E = [URLsPromise objectEnumerator];
	NSURL * url;
	while(url = [E nextObject])
	{
		[self readContentOfURL:url client:client];
	}
	return;
}
+ (NSArray *)documentURLsOfClient:(id)client;
{
	NSMutableDictionary * documentsByURLs = [client valueForKeyPath:@"value.documentsByURLs"];
	NSArray * result = [documentsByURLs allKeys];
	NSMutableSet * set = [NSMutableSet setWithArray:result];
	result = [client valueForKeyPath:@"value.URLsPromise"];
	[set addObjectsFromArray:result];
	result = [set allObjects];
	return result;
}
+ (NSArray *)honoredDocumentURLsOfClient:(id)client;
{
	NSMutableDictionary * documentsByURLs = [client valueForKeyPath:@"value.documentsByURLs"];
	NSArray * result = [documentsByURLs allKeys];
	return result;
}
+ (NSXMLDocument *)documentForURL:(NSURL *)url client:(id)client;
{
	[self readContentOfURL:url client:client];// if the url was a promise, it will be read here; otherwise does nothing
	NSMutableDictionary * documentsByURLs = [client valueForKeyPath:@"value.documentsByURLs"];
	return [documentsByURLs objectForKey:url];
}
+ (void)setDocument:(NSXMLDocument *)document forURL:(NSURL *)url client:(id)client;
{
	NSMutableDictionary * documentsByURLs = [client valueForKeyPath:@"value.documentsByURLs"];
	if(!documentsByURLs)
	{
		documentsByURLs = [NSMutableDictionary dictionary];
		[client setValue:documentsByURLs forKeyPath:@"value.documentsByURLs"];
	}
	[documentsByURLs setObject:document forKey:url];
	return; 
}
+ (NSXMLElement *)templateXMLElementOfClient:(id)client;
{
	NSXMLElement * element = nil;// cached template?
	NSBundle * MB = [NSBundle mainBundle];
	NSString * pathExtension = [client pathExtension];
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
		NSXMLElement * node = [document rootElement];
		while(node = (NSXMLElement *)[node nextNode])
		{
			if([node kind] == NSXMLElementKind)
			{
				element = node;
				[element detach];
				[client setValue:element forKeyPath:@"value.templateXMLElement"];
				break;
			}
		}
		url = [self personalURLOfClient:client];
		if(![self documentForURL:url client:client])
		{
			node = [document rootElement];
			while([node childCount])
			{
				[node removeChildAtIndex:0];
			}
			[self setDocument:document forURL:url client:client];
		}
	}
	else
	{
		iTM2_LOG(@"***  MISSING MACRO TEMPLATE FILE, REPORT");
		return nil;
	}
	return element; 
}
+ (NSURL *)personalURLOfClient:(id)client;
{
	// what is the URL of the personal macros?
	NSString * path = [client pathExtension];
	path = [iTM2MacroPersonalComponent stringByAppendingPathExtension:path];
	id aNode = [client parent];
	NSString * component = [aNode valueForKeyPath:@"value.category"];
	path = [component stringByAppendingPathComponent:path];
	aNode = [aNode parent];
	component = [aNode valueForKeyPath:@"value.domain"];
	path = [component stringByAppendingPathComponent:path];
	NSBundle * MB = [NSBundle mainBundle];
	component = [MB pathForSupportDirectory:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:NO];
	path = [component stringByAppendingPathComponent:path];
	NSURL * url = [NSURL fileURLWithPath:path];
	return url;
}
@end

@implementation iTM2MacroContextNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:context forKeyPath:@"value.context"];
		[self addObserver:self
             forKeyPath:@"children" 
                 options:(NSKeyValueObservingOptionNew |
                            NSKeyValueObservingOptionOld)
                    context:NULL];
	}
	return self;
}
- (void)readXMLElement:(NSXMLElement *)element mutable:(BOOL)mutable;
{
	NSArray * children = [element children];
	NSEnumerator * e = [children objectEnumerator];
	while(element = [e nextObject])
	{
		NSXMLNode * node = [element attributeForName:@"ID"];
		NSString * ID = [node stringValue];
		id child = (iTM2MacroLeafNode *)[self objectInChildrenWithID:ID];
		if(child)
		{
			[element detach];
			iTM2_LOG(@"remove element:%@",element);
		}
		else
		{
			child = [[[iTM2MacroLeafNode alloc] initWithParent:self] autorelease];
			[child setID:ID];
			id D = [self valueForKeyPath:@"value.cachedChildrenID"];
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
				child = (iTM2MacroLeafNode *)[self objectInChildrenWithID:ID];
				iTM2_LOG(@"child:%@",child);
			}
		}
	}
	return;
}
- (id)objectInChildrenWithID:(NSString *)ID;
{
	[iTM2MacroDocumentManager honorURLPromisesOfClient:self];
	id D = [self valueForKeyPath:@"value.cachedChildrenID"];
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
		[self setValue:D forKeyPath:@"value.cachedChildrenID"];
	}
	id result = [D objectForKey:ID];
	return result;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	id D = [self valueForKeyPath:@"value.cachedChildrenID"];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		[self setValue:D forKeyPath:@"value.cachedChildrenID"];
	}
	NSString * ID;
    if ([keyPath isEqual:@"children"])
	{
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
- (NSArray *)children;
{
	[iTM2MacroDocumentManager honorURLPromisesOfClient:self];
	return [super children];
}
- (NSXMLElement *)templateXMLElement;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.templateXMLElement"];// cached template?
	if(!element)
	{
		element = [iTM2MacroDocumentManager templateXMLElementOfClient:self];
		[self setValue:element forKeyPath:@"value.templateXMLElement"];// cache
	}
	NSURL * url = [iTM2MacroDocumentManager personalURLOfClient:self];
	NSXMLDocument * document = [iTM2MacroDocumentManager documentForURL:url client:self];
	NSXMLElement * node = [document rootElement];
	element = [[element copy] autorelease];
	[node addChild:element];
iTM2_LOG(@"XMLDOC:%@",[[element rootDocument] XMLStringWithOptions:NSXMLNodePrettyPrint]);
	return element; 
}
- (Class)leafClass;
{
	return [iTM2MacroLeafNode class];
}
- (id)customOnly;
{
	return [self valueForKeyPath:@"value.customOnly"];
}
- (void)setCustomOnly:(id)sender;
{
	[self willChangeValueForKey:@"availableMacros"];
	[self willChangeValueForKey:@"customOnly"];
	[self setValue:sender forKeyPath:@"value.customOnly"];
	[self didChangeValueForKey:@"customOnly"];
	[self setValue:nil forKeyPath:@"value.availableMacros"];
	[self didChangeValueForKey:@"availableMacros"];
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
- (id)objectInAvailableMacrosAtIndex:(int) index;
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
	NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableMacros"];
	[object setParent:self];
	NSXMLElement * element = [iTM2MacroDocumentManager templateXMLElementOfClient:self];// expected side effect
	[object addMutableXMLElement:element];
	[object setID:ID];
iTM2_LOG(@"XMLDOC:%@",[[element rootDocument] XMLStringWithOptions:NSXMLNodePrettyPrint]);
	[self setValue:nil forKeyPath:@"value.availableMacros"];//clean cache
	[self setValue:nil forKeyPath:@"value.cachedChildrenID"];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableMacros"];
	IDs = [self availableIDs];// updated
	if(![IDs containsObject:ID])
	{
		iTM2_LOG(@"***  THE MACRO WAS NOT ADDED");
	}
//iTM2_END;
    return;
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
	[self setValue:nil forKeyPath:@"value.cachedChildrenID"];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroSortDescriptors
- (NSArray *)macroSortDescriptors;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSSortDescriptor * SD = [[[NSSortDescriptor allocWithZone:[self zone]] initWithKey:@"ID" ascending:YES] autorelease];
//iTM2_END;
    return [NSArray arrayWithObject:SD];
}
- (NSString *)pathExtension;
{
	return iTM2MacroPathExtension;
}
@end

@interface iTM2MacroController(PRIVATE)
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (void)setSelectedMode:(NSString *)mode;
- (void)readMacrosAtPath:(NSString *)repository inRootNode:(iTM2MacroRootNode *)rootNode mutable:(BOOL)flag;
- (void)macroLeafNode:(iTM2MacroLeafNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
- (id)keyBindingTree;
- (void)synchronizeMacroSelectionWithKeyBindingSelection;
- (void)synchronizeKeyBindingSelectionWithMacroSelection;
- (id)keysTreeController;
@end

@implementation iTM2MacroLeafNode: iTM2TreeNode
- (id)init;
{
	if(self = [super init])
	{
		[self setValue:[NSMutableDictionary dictionary]];
	}
	return self;
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
		return @"insertMacro:";
	}
}
- (void)setActionName:(NSString *)newActionName;
{
	if(![self isMutable])
	{
		return;
	}
	if(![self isVisible])
	{
		return;
	}
	NSString * oldActionName = [self actionName];
	if([oldActionName isEqual:newActionName])
	{
		return;
	}
	[self willChangeValueForKey:@"macroTabViewItemIdentifier"];
	[self willChangeValueForKey:@"actionName"];
	NSXMLElement * element = [self XMLElement];
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
	[self didChangeValueForKey:@"macroTabViewItemIdentifier"];
	return;
}
- (BOOL)isVisible;
{
	return ![[self ID] hasPrefix:@"."];
}
- (BOOL)isMutable;
{
	NSArray *  mutableXMLElements = [self mutableXMLElements];
	unsigned int count = [mutableXMLElements count];
	return count>0;
}
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
	[[iTM2MacroController sharedMacroController] macroLeafNode:self didChangeIDFrom:oldID to:newID];
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
	iTM2MacroContextNode * node = [self parent];
	NSArray * availableIDs = [node availableIDs];
	if([availableIDs containsObject:newID])
	{
		iTM2_OUTERROR(4,([NSString stringWithFormat:@"\"%@\" is already a macro ID",newID]),nil);
		return NO;
	}
	return YES;
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
	[self willChangeValueForKey:@"hiddenArgument"];
	[self willChangeValueForKey:@"mustShowArgument"];
	[self willChangeValueForKey:@"argument"];
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node = nil;
	if(![self isMutable])
	{
		element = [[element copy] autorelease];
		[element detach];
		// connect to another document
		iTM2MacroContextNode * contextNode = (iTM2MacroContextNode *)[self parent];
		id otherElement = [iTM2MacroDocumentManager templateXMLElementOfClient:contextNode];
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
	[self didChangeValueForKey:@"argument"];
	[self didChangeValueForKey:@"mustShowArgument"];
	[self didChangeValueForKey:@"hiddenArgument"];
	return;
}
- (BOOL)mustShowArgument;
{
	return [[self argument] length] != 0;
}
- (BOOL)hiddenArgument;
{
	return ![self mustShowArgument] && ![self shouldShowArgument];
}
- (BOOL)shouldShowArgument;
{
	NSNumber * N = [self valueForKeyPath:@"value.shouldShowArgument"];
	return [N boolValue];
}
- (void)setShouldShowArgument:(BOOL)flag;
{
	if(flag != [self shouldShowArgument])
	{
		[self willChangeValueForKey:@"hiddenArgument"];
		[self willChangeValueForKey:@"shouldShowArgument"];
		NSNumber * N = [NSNumber numberWithBool:flag];
		[self setValue:N forKeyPath:@"value.shouldShowArgument"];
		[self didChangeValueForKey:@"shouldShowArgument"];
		[self didChangeValueForKey:@"hiddenArgument"];
	}
	return;
}
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
	NSMutableArray * XMLElements = [self XMLElements];
	[XMLElements addObject:element];
	return;
}
- (void)addMutableXMLElement:(NSXMLElement *)element;
{
	NSParameterAssert(element);
	NSMutableArray * mutableXMLElements = [self mutableXMLElements];
	[mutableXMLElements addObject:element];
	return;
}
- (void)removeLastXMLElement;
{
	NSMutableArray * XMLElements = [self XMLElements];
	[XMLElements removeLastObject];
	return;
}
- (void)removeLastMutableXMLElement;
{
	NSMutableArray * mutableXMLElements = [self mutableXMLElements];
	NSXMLElement * element = [mutableXMLElements lastObject];
	[element detach];
	[mutableXMLElements removeLastObject];
	return;
}
- (NSString *)description;
{
	return [NSString stringWithFormat:@"%@(%@)",[super description],[self ID]];
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
- (NSString *)macroDescription;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"DESC" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no description.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No description available";
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
- (NSString *)mode;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"@MODE" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: MODE attribute?";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"";
	}
}
@end

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@interface iTM2HumanReadableActionNameValueTransformer: NSValueTransformer
@end

@implementation iTM2HumanReadableActionNameValueTransformer: NSValueTransformer
+ (BOOL)allowsReverseTransformation;
{
	return YES;
}
- (id)transformedValue:(id)value;
{
	return value;
}
- (id)reverseTransformedValue:(id)value;
{
	return value;
}
@end

@interface iTM2TabViewItemIdentifierForActionValueTransformer: NSValueTransformer
@end

@implementation iTM2TabViewItemIdentifierForActionValueTransformer: NSValueTransformer
+ (BOOL)allowsReverseTransformation;
{
	return NO;
}
- (id)transformedValue:(id)value;
{
	return [value hasSuffix:@"Path:"]?@"path":@"macro";
}
- (id)reverseTransformedValue:(id)value;
{
	return value;
}
@end

@implementation iTM2MacroController

static id _iTM2MacroAvailableActionNames = nil;
static id _iTM2MacroController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString bullet], iTM2TextTabAnchorStringKey,
                nil]];
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableActionName"])
	{
		iTM2HumanReadableActionNameValueTransformer * transformer = [[[iTM2HumanReadableActionNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableActionName"];
	}
	if(![NSValueTransformer valueTransformerForName:@"iTM2TabViewItemIdentifierForAction"])
	{
		iTM2TabViewItemIdentifierForActionValueTransformer * transformer = [[[iTM2TabViewItemIdentifierForActionValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2TabViewItemIdentifierForAction"];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}

+ (id)sharedMacroController;
{
	return _iTM2MacroController?:( _iTM2MacroController = [[self alloc] init]);
}

- (id)init;
{
	if(_iTM2MacroController)
	{
		return [_iTM2MacroController retain];
	}
	else if(self = [super init])
	{
		[self setMacroTree:nil];
	}
	return _iTM2MacroController = self;
}
- (id)macroTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	iTM2MacroRootNode * rootNode = [self treeForPathExtension:iTM2MacroPathExtension contextNodeClass:[iTM2MacroContextNode class]];
	metaSETTER(rootNode);
	return rootNode;
}
- (id)treeForPathExtension:(NSString *)requiredPathExtension contextNodeClass:(Class)aClass;
{
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained later
	// list all the *.iTM2-macros files
	// Create a Macros.localized in the Application\ Support folder as side effect
	NSBundle * MB = [NSBundle mainBundle];
	[MB pathForSupportDirectory:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:YES];
	NSArray * RA = [MB allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
	while(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:requiredPathExtension])
				{
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					id contextNode = nil;
					if(component = [e nextObject])
					{
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if(component = [e nextObject])
						{
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if(component = [e nextObject])
							{
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
							}
							else
							{
								component = @"";
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
							}
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							contextNode = [categoryNode objectInChildrenWithContext:component]?:
									[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
						}
					}
					else
					{
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						contextNode = [categoryNode objectInChildrenWithContext:component]?:
								[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
					}
					subpath = [repository stringByAppendingPathComponent:subpath];
					NSURL * url = [NSURL fileURLWithPath:subpath];
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"url:%@",url);
					}
					[iTM2MacroDocumentManager addURLPromise:url client:contextNode];
				}
			}
			[DFM popDirectory];
		}
	}
	return rootNode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroTree:
- (void)setMacroTree:(id)aTree;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= IDsForContext:ofCategory:inDomain:
- (NSArray *)IDsForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self macroTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroContextNode * contextNode = [categoryNode objectInChildrenWithContext:context];
	NSArray * leafNodes = [contextNode children];
	NSEnumerator * E = [leafNodes objectEnumerator];
	iTM2MacroLeafNode * leafNode;
	NSMutableArray * result = [NSMutableArray array];
	while(leafNode = [E nextObject])
	{
		NSString * ID = [leafNode ID];
		[result addObject:ID];
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroRunningNodeForID:context:ofCategory:inDomain:
- (id)macroRunningNodeForID:(NSString *)ID context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self macroTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
#warning NO context in macros
	context = @"";
	iTM2MacroContextNode * contextNode = [categoryNode objectInChildrenWithContext:context];
	iTM2MacroLeafNode * leafNode = [contextNode objectInChildrenWithID:ID];
	if(!leafNode)
	{
		iTM2_LOG(@"No macro with ID: %@ forContext:%@ ofCategory:%@ inDomain:%@",ID,context,category,domain);
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"[rootNode countOfChildren]:%i",[rootNode countOfChildren]);
			iTM2_LOG(@"[domainNode countOfChildren]:%i",[domainNode countOfChildren]);
			iTM2_LOG(@"[categoryNode countOfChildren]:%i",[categoryNode countOfChildren]);
			iTM2_LOG(@"[contextNode countOfChildren]:%i",[contextNode countOfChildren]);
		}
	}
//iTM2_END;
	return leafNode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= menuTree
- (id)menuTree;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	NSBundle * MB = [NSBundle mainBundle];
	[MB pathForSupportDirectory:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:YES];
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [MB allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * repository = nil;
	NSURL * repositoryURL = nil;
	NSDirectoryEnumerator * DE = nil;
	NSString * subpath = nil;
	while(repository = [E nextObject])
	{
		if([DFM pushDirectory:repository])
		{
			repositoryURL = [NSURL fileURLWithPath:repository];
			DE = [DFM enumeratorAtPath:repository];
			while(subpath = [DE nextObject])
			{
				NSString * extension = [subpath pathExtension];
				if([extension isEqual:iTM2MacroMenuPathExtension])
				{
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					// for menus there are only two levels
					// no level for the context depth
					if(component = [e nextObject])
					{
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if(component = [e nextObject])
						{
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if(component = [E nextObject])
							{
								component = [subpath lastPathComponent];
								component = [component stringByDeletingPathExtension];
							}
						}
					}
					else
					{
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
					}
					component = [subpath lastPathComponent];
					component = [component stringByDeletingPathExtension];
					iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:component];
					if(!menuNode)
					{
						iTM2MacroMenuNode * menuNode = [[[iTM2MacroMenuNode alloc] initWithParent:categoryNode context:component] autorelease];
						NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
						[menuNode setValue:url forKeyPath:@"value.URL"];
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(rootNode);
	return rootNode;
}

- (void)setMenuTree:(id)aTree;
{
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuForContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroRootNode * rootNode = [self menuTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:context];
	NSMenu * M = [menuNode valueForKeyPath:@"value.menu"];
	if(!M)
	{
		NSURL * url = [menuNode valueForKeyPath:@"value.URL"];
		if(url)
		{
			NSError * localError = nil;
			NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeCompactEmptyElement error:&localError] autorelease];
			if(localError)
			{
				[SDC presentError:localError];
			}
			NSXMLElement * rootElement = [xmlDoc rootElement];
			M = [self macroMenuWithXMLElement:rootElement forContext:context ofCategory:category inDomain:domain error:&localError];
			[menuNode setValue:M forKeyPath:@"value.menu"];
		}
	}
//iTM2_END;
	return M;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"MENU"])
	{
		NSString * prefix = [[element attributeForName:@"ID"] stringValue];
		if(!prefix)
			prefix = @"";
		if([element childCount])
		{
			NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
			id child = [element childAtIndex:0];
			do
			{
				NSMenuItem * MI = [self macroMenuItemWithXMLElement:child forContext:context ofCategory:category inDomain:domain error:outErrorPtr];
				if(MI)
					[M addItem:MI];
			}
			while(child = [child nextSibling]);
			return M;
		}
	}
	else if(element)
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuItemWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"SEP"])
	{
		return [NSMenuItem separatorItem];
	}
	else if([name isEqualToString:@"ITEM"])
	{
		NSString * ID = [[element attributeForName:@"ID"] stringValue];
		iTM2MacroLeafNode * leafNode = [SMC macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
		name = [leafNode name];
		if(!leafNode)
		{
			name = ID;
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle:name action:NULL keyEquivalent: @""] autorelease];
		[MI setToolTip:[leafNode tooltip]];
		id submenuList = [[element elementsForName:@"MENU"] lastObject];
		NSMenu * M = [self macroMenuWithXMLElement:submenuList forContext:context ofCategory:category inDomain:domain error:outErrorPtr];
		[MI setSubmenu:M];
		if([ID length])
		{
			[MI setRepresentedObject:[NSArray arrayWithObjects:ID, context, category, domain, nil]];
			SEL action = [leafNode action];
			if([ID hasPrefix:@"."] || !leafNode || action == @selector(noop:))
			{
				// no action;
				if(!M)
				{
					[MI setAction:@selector(___catch:)];
					[MI setTarget:self];
				}
			}
			else
			{
				[MI setAction:@selector(___insertMacro:)];
				[MI setTarget:self];
			}
		}
		return MI;
	}
	else
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
- (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:20], @"iTM2NumberOfRecentMacros", nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___catch:
- (void)___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___catch:
- (BOOL)validate___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___insertMacro:
- (void)___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && [RA count])
	{
		NSString * ID = [RA objectAtIndex:0];
		NSString * context;
		NSString * category;
		NSString * domain;
		if([RA count] > 3)
		{
			context = [RA objectAtIndex:1];
			category = [RA objectAtIndex:2];
			domain = [RA objectAtIndex:3];
		}
		else
		{
			context = @"";
			if([RA count] > 2)
			{
				category = [RA objectAtIndex:1];
				domain = [RA objectAtIndex:2];
			}
			else
			{
				category = @"";
				if([RA count] > 1)
				{
					context = @"";
					domain = [RA objectAtIndex:1];
				}
				else
				{
					domain = @"";
				}
			}
		}
		if([ID length])
		{
			if([SMC executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain substitutions:nil target:nil])
			{
				NSMenu * recentMenu = [self macroMenuForContext:context ofCategory:@"Recent" inDomain:domain error:nil];
				int index = [recentMenu indexOfItemWithTitle:[sender title]];
				if(index!=-1)
				{
					[recentMenu removeItemAtIndex:index];
				}
				NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:[sender title] action:[sender action] keyEquivalent:@""] autorelease];
				[MI setTarget:self];
				[MI setRepresentedObject:RA];
				[recentMenu insertItem:MI atIndex:1];
				NSMutableDictionary * MD = [NSMutableDictionary dictionary];
				index = 0;
				int max = [SUD integerForKey:@"iTM2NumberOfRecentMacros"];
				while([recentMenu numberOfItems] > max)
				{
					[recentMenu removeItemAtIndex:[recentMenu numberOfItems]-1];
				}
				while(++index < [recentMenu numberOfItems])
				{ 
					MI = [recentMenu itemAtIndex:index];
					RA = [MI  representedObject];
					if(RA)
					{
						[MD setObject:RA forKey:[MI title]];
					}
				}
				[SUD setObject:MD forKey:[NSString pathWithComponents:[NSArray arrayWithObjects:@"", @"Recent", domain, nil]]];
			}
		}
	}
	else if(RA)
	{
		iTM2_LOG(@"Unknown design [sender representedObject]:%@", RA);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___insertMacro:
- (BOOL)validate___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && ([RA count] > 2))
	{
		NSString * ID = [RA objectAtIndex:0];
		if([ID length])
			return YES;
	}
	iTM2_LOG(@"sender is:%@",sender);
//iTM2_END;
    return [sender hasSubmenu];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithID:forContext:ofCategory:inDomain:substitutions:target:
- (BOOL)executeMacroWithID:(NSString *)ID forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain substitutions:(NSDictionary *)substitutions target:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroLeafNode * leafNode = [self macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
	if(!target)
	{
		target = [[NSApp keyWindow] firstResponder];
	}
	BOOL result = NO;
	SEL action = [leafNode action];
	id argument = [leafNode argument];
	NSString * mode = [leafNode mode];
	if(!argument)
	{
		argument = ID;
	}
	NSMethodSignature * MS;
	if(action)
	{
		MS = [target methodSignatureForSelector:action];
		if(!MS)
		{
			iTM2_LOG(@"FAILED, Unsupported Action in macro:%@",NSStringFromSelector(action));
		}
	}
	else
	{
		action = NSSelectorFromString(ID);
		MS = [target methodSignatureForSelector:action];
		if(!MS)
		{
			action = NSSelectorFromString(@"insertMacro:substitutions:mode:");
			if(MS = [target methodSignatureForSelector:action])
			{
				NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
				[I setTarget:target];
				[I setSelector:action];
				[I setArgument:&argument atIndex:2];
				[I setArgument:&substitutions atIndex:3];
				[I setArgument:&mode atIndex:4];
				NS_DURING
				[I invoke];
				result = YES;
				NS_HANDLER
				iTM2_LOG(@"Exception catched:%@",[localException reason]);
				NS_ENDHANDLER
				return result;
			}
			else
			{
				return NO;
			}
		}
	}
	if([MS numberOfArguments] == 3)
	{
		NS_DURING
		[target performSelector:action withObject:argument];
		result = YES;
		NS_HANDLER
		NS_ENDHANDLER
		return result;
	}
	else if([MS numberOfArguments] == 2)
	{
		NS_DURING
		[target performSelector:action];
		result = YES;
		NS_HANDLER
		NS_ENDHANDLER
		return result;
	}
	else if(MS)
	{
		return NO;
	}
	if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:argument]
		|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:argument])
	{
		return YES;
	}
	else
	{
		iTM2_LOG(@"No target for %@ with no argument:%@", NSStringFromSelector(action),argument);
	}
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  PREFERENCES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if ([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	NSNumber * N = [NSNumber numberWithUnsignedInt:0];
	[self setValue:N forKey:@"masterTabViewItemIndex"];// unless the segmented control is not properly highlighted
	// try to bind something
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableDomains
- (NSArray *)availableDomains;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self macroTree] availableDomains];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedDomain
- (NSString *)selectedDomain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
	NSString * key = @".";
	id result = [MD objectForKey:key];
	NSArray * availableDomains = [self availableDomains];
	if([availableDomains containsObject:result])
	{
		// do nothing
	}
	else if(result = [[self availableDomains] lastObject])
	{
		MD = [[MD mutableCopy] autorelease];
		[MD setObject:result forKey:key];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedDomain:
- (void)setSelectedDomain:(NSString *)domain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * old = [self selectedDomain];
	if(![old isEqual:domain])
	{
		[self willChangeValueForKey:@"availableModes"];
		[self willChangeValueForKey:@"selectedDomain"];
		if(domain)
		{
			id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
			MD = [[MD mutableCopy] autorelease];
			NSString * key = @".";
			[MD setValue:domain forKey:key];
			[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
		}
		[self didChangeValueForKey:@"selectedDomain"];
		[self didChangeValueForKey:@"availableModes"];
		[self setSelectedMode:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableModes
- (NSArray *)availableModes;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * domain = [self selectedDomain];
	id node = [[self macroTree] objectInChildrenWithDomain:domain];
//iTM2_END;
    return [node availableCategories];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedMode
- (NSString *)selectedMode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
	NSString * key = [self selectedDomain]?:@"";
	id result = [MD objectForKey:key];
	NSArray * availableModes = [self availableModes];
	if([availableModes containsObject:result])
	{
		// do nothing
	}
	else if(result = [[self availableModes] lastObject])
	{
		MD = [[MD mutableCopy] autorelease];
		[MD setObject:result forKey:key];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedMode:
- (void)setSelectedMode:(NSString *)mode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * old = [self selectedMode];
	if(![old isEqual:mode])
	{
		[self willChangeValueForKey:@"macroEditor"];
		[self willChangeValueForKey:@"keyBindingEditor"];
		[self willChangeValueForKey:@"selectedMode"];
		if(mode)
		{
			id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
			MD = [[MD mutableCopy] autorelease];
			NSString * key = [self selectedDomain]?:@"";
			[MD setValue:mode forKey:key];
			[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
		}
		[self didChangeValueForKey:@"selectedMode"];
		[self setValue:nil forKey:@"keyBindingEditor_meta"];
		[self didChangeValueForKey:@"keyBindingEditor"];
		[self setValue:nil forKey:@"macroEditor_meta"];
		[self didChangeValueForKey:@"macroEditor"];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  MACROS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroEditor
- (id)macroEditor;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id node = [self valueForKey:@"macroEditor_meta"];
	if(node)
	{
		return node;
	}
	NSString * domain = [self selectedDomain];
	node = [self macroTree];
	node = [node objectInChildrenWithDomain:domain];
	NSString * mode = [self selectedMode];
	node = [node objectInChildrenWithCategory:mode];
	node = [node objectInChildrenWithContext:@""];
	[self setValue:node forKey:@"macroEditor_meta"];
//iTM2_END;
    return node;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  applyForNode
- (void)applyForNode:(id)node;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// for all the context nodes, save the XML document for the personal URL
	NSArray * children = [node children];
	NSEnumerator * E = [children objectEnumerator];
	NSBundle * MB = [NSBundle mainBundle];
	NSString * dir = [MB pathForSupportDirectory:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:NO];
	while(node = [E nextObject])
	{
		// now the domain level
		children = [node children];
		NSEnumerator * EE = [children objectEnumerator];
		while(node = [EE nextObject])
		{
			// now the category level
			children = [node children];
			NSEnumerator * EEE = [children objectEnumerator];
			while(node = [EEE nextObject])
			{
				// now the context level
				children = [iTM2MacroDocumentManager honoredDocumentURLsOfClient:node];
				NSEnumerator * EEEE = [children objectEnumerator];
				NSURL * url;
				while(url = [EEEE nextObject])
				{
//iTM2_LOG(@"url:%@",url);
					if([url isFileURL])
					{
						NSString * path = [url path];
						if([path belongsToDirectory:dir])
						{
							NSXMLDocument * document = [iTM2MacroDocumentManager documentForURL:url client:node];
							if(document)
							{
								NSData * D = [document XMLDataWithOptions:NSXMLNodePrettyPrint];
								NSError * localError = nil;
								NSString * dirname = [path stringByDeletingLastPathComponent];
								if(![DFM createDeepDirectoryAtPath:dirname attributes:nil error:&localError])
								{
									iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Could create directory at %@",dirname]),localError);
								}
								else if(![D writeToURL:url options:NSAtomicWrite error:&localError])
								{
									iTM2_REPORTERROR(2,([NSString stringWithFormat:@"Could not write to %@",url]),localError);
								}
							}
						}
					}
				}
			}
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  apply
- (IBAction)apply:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id node = [self macroTree];
	[self applyForNode:node];
	node = [self keyBindingTree];
	[self applyForNode:node];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canApply
- (BOOL)canApply;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel
- (IBAction)cancel:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCancel
- (BOOL)canCancel;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedMacro
- (id)selectedMacro;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedMacro:
- (void)setSelectedMacro:(id)newMacro;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self selectedMacro];
	if([old isEqual:newMacro])
	{
		return;
	}
	[self willChangeValueForKey:@"showArgumentView"];
	[self willChangeValueForKey:@"canHideArgumentView"];
	[self willChangeValueForKey:@"selectedMacro"];
	metaSETTER(newMacro);
	[self didChangeValueForKey:@"selectedMacro"];
	[self didChangeValueForKey:@"canHideArgumentView"];
	[self didChangeValueForKey:@"showArgumentView"];
//iTM2_END;
    return;
}
-(unsigned int)masterTabViewItemIndex;
{
	return [[self valueForKey:@"masterTabViewItemIndex_meta"] unsignedIntValue];
}
-(void)setMasterTabViewItemIndex:(unsigned int)newIndex;// the macro/key tabView
{
	[self willChangeValueForKey:@"selectedMacro"];
	[self willChangeValueForKey:@"masterTabViewItemIndex"];
	NSNumber * N = [NSNumber numberWithUnsignedInt:newIndex];
	[self setValue:N forKey:@"masterTabViewItemIndex_meta"];
	[self didChangeValueForKey:@"masterTabViewItemIndex"];
	[self didChangeValueForKey:@"selectedMacro"];
	return;
}
-(id)macrosArrayController;// nib outlets won't accept kvc (10.4)
{
	return metaGETTER;
}
-(void)setMacrosArrayController:(id)argument;
{
	[self willChangeValueForKey:@"selectedMacro"];
	metaSETTER(argument);
	[self didChangeValueForKey:@"selectedMacro"];
	return;
}
- (NSArray *)availableActionNames;
{
	if(!_iTM2MacroAvailableActionNames)
	{
		_iTM2MacroAvailableActionNames = [[NSMutableArray array] retain];
		NSBundle * MB = [NSBundle mainBundle];
		NSArray * paths = [MB allPathsForResource:@"iTM2BindableActions" ofType:@"plist"];
		NSEnumerator * E = [paths objectEnumerator];
		NSString * path;
		NSArray * otherArray;
		while(path = [E nextObject])
		{
			if(otherArray = [NSArray arrayWithContentsOfFile:path])
			{
				[_iTM2MacroAvailableActionNames addObjectsFromArray:otherArray];
			}
		}
	}
	iTM2MacroLeafNode * macro = [self selectedMacro];
	NSString * actionName = [macro actionName];
	if([actionName length])
	{
		if(![_iTM2MacroAvailableActionNames containsObject:actionName])
		{
			[_iTM2MacroAvailableActionNames addObject:actionName];
		}
	}
	return _iTM2MacroAvailableActionNames;
}
- (BOOL)canEditActionName;
{
	iTM2MacroLeafNode * node = [self selectedMacro];
	return [node isVisible];
}
- (BOOL)canEdit;
{
	iTM2MacroLeafNode * node = [self selectedMacro];
	return [node isVisible];
}
- (BOOL)canHideArgumentView;
{
	iTM2MacroLeafNode * node = [self selectedMacro];
	NSString * argument = [node argument];
	return [argument length]==0;
}
- (BOOL)showArgumentView;
{
	id result = metaGETTER;
	if([result boolValue])
	{
		return YES;
	}
	iTM2MacroLeafNode * node = [self selectedMacro];
	NSString * argument = [node argument];
	return [argument length]>0;
}
- (void)macroLeafNode:(iTM2MacroLeafNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
{
	id parent = [node parent];
	if(![parent isKindOfClass:[iTM2MacroContextNode class]])
	{
		[self synchronizeMacroSelectionWithKeyBindingSelection];
		return;
	}
	NSTreeController * keysTreeController = [self keysTreeController];
	NSDictionary * contentArrayBindingDict = [keysTreeController infoForBinding:@"contentArray"];
	NSString * observedKeyPath = [contentArrayBindingDict objectForKey:NSObservedKeyPathKey];
	NSString * childrenKeyPath = [keysTreeController childrenKeyPath];
	NSMutableArray * childrenEnumeratorStack = [NSMutableArray array];
	NSEnumerator * E = nil;		
	id controller = nil;
	id children = nil;
	if(controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey])
	{
		if(children = [controller mutableArrayValueForKeyPath:observedKeyPath])
		{
			if([children count])
			{
pushed:
				E = [children objectEnumerator];
poped:
				while(controller = [E nextObject])
				{
					if(children = [controller mutableArrayValueForKeyPath:childrenKeyPath])
					{
						if([children count])
						{
							[childrenEnumeratorStack addObject:E];
							goto pushed;
						}
						else
						{
							NSString * itsID = [controller ID];
							if([itsID isEqual:oldID])
							{
								[controller setID:newID];
							}
						}
					}
				}
				if(E = [childrenEnumeratorStack lastObject])
				{
					[childrenEnumeratorStack removeLastObject];
					goto poped;
				}
			}
		}
	}
}
#pragma mark =-=-=-=-=-  BINDINGS
- (id)keyBindingTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	Class C = [iTM2KeyBindingContextNode class];
	iTM2MacroRootNode * rootNode = [self treeForPathExtension:iTM2KeyBindingPathExtension contextNodeClass:C];
	metaSETTER(rootNode);
	return rootNode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setKeyBindingTree:
- (void)setKeyBindingTree:(id)aTree;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = metaGETTER;
	if([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingEditor
- (id)keyBindingEditor;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id node = [self valueForKey:@"keyBindingEditor_meta"];
	if(node)
	{
		return node;
	}
	NSString * domain = [self selectedDomain];
	node = [self keyBindingTree];
	node = [node objectInChildrenWithDomain:domain]?:
				[[[iTM2MacroDomainNode alloc] initWithParent:node domain:domain] autorelease];;
	NSString * mode = [self selectedMode];
	node = [node objectInChildrenWithCategory:mode]?:
				[[[iTM2MacroCategoryNode alloc] initWithParent:node category:mode] autorelease];
	node = [node objectInChildrenWithContext:@""]?:
				[[[iTM2KeyBindingContextNode alloc] initWithParent:node context:@""] autorelease];
	[self setValue:node forKey:@"keyBindingEditor_meta"];
//iTM2_END;
    return node;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedKeyBinding
- (id)selectedKeyBinding;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedKeyBinding:
- (void)setSelectedKeyBinding:(id)new;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self selectedKeyBinding];
	if([old isEqual:new])
	{
		return;
	}
	[self willChangeValueForKey:@"selectedKeyBinding"];
	metaSETTER(new);
	[self didChangeValueForKey:@"selectedKeyBinding"];
//iTM2_END;
    return;
}
-(id)keysTreeController;
{
	return metaGETTER;
}
-(void)setKeysTreeController:(id)argument;
{
	[self willChangeValueForKey:@"selectedKeyBinding"];
	metaSETTER(argument);
	[self didChangeValueForKey:@"selectedKeyBinding"];
	return;
}
-(id)selectionIndexPaths;
{
	return metaGETTER;
}
-(void)setSelectionIndexPaths:(NSArray *)new;
{
	NSArray * old = metaGETTER;
	if([old isEqual:new])
	{
		return;
	}
	[self willChangeValueForKey:@"selectionIndexPaths"];
	NSEnumerator * E = [old objectEnumerator];
	NSIndexPath * IP;
	NSTreeController * keysTreeController = [self keysTreeController];
	NSDictionary * contentArrayBindingDict = [keysTreeController infoForBinding:@"contentArray"];
	NSString * observedKeyPath = [contentArrayBindingDict objectForKey:NSObservedKeyPathKey];
	NSString * childrenKeyPath = [keysTreeController childrenKeyPath];
	id controller = nil;
	id children = nil;
	unsigned int index = 0,length = 0,position = 0;
	while(IP = [E nextObject])
	{
		controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey];
		children = [controller mutableArrayValueForKeyPath:observedKeyPath];
		position = 0;
		length = [IP length];
		while(position<length)
		{
			index = [IP indexAtPosition:position];
			if(index<[children count])
			{
				controller = [children objectAtIndex:index];
				children = [controller mutableArrayValueForKeyPath:childrenKeyPath];
			}
			++position;
		}
		[controller unbind:@"ID2"];
	}
	E = [new objectEnumerator];
	while(IP = [E nextObject])
	{
		controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey];
		children = [controller mutableArrayValueForKeyPath:observedKeyPath];
		position = 0;
		int length = [IP length];
		if(length>0)
		{
			while(position<length)
			{
				index = [IP indexAtPosition:position];
				if(index<[children count])
				{
					controller = [children objectAtIndex:index++];
					children = [controller mutableArrayValueForKeyPath:childrenKeyPath];
				}
				++position;
			}
		}
	}
	metaSETTER(new);
	[self didChangeValueForKey:@"selectionIndexPaths"];
	return;
}
-(id)selectionIndexes;
{
	return metaGETTER;
}
-(void)setSelectionIndexes:(NSArray *)new;
{
	id old = metaGETTER;
	if([old isEqual:new])
	{
		return;
	}
	[self willChangeValueForKey:@"selectionIndexes"];
	metaSETTER(new);
	[self didChangeValueForKey:@"selectionIndexes"];
	return;
}
#pragma mark =-=-=-=-=-  DELEGATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuNeedsUpdate:
- (void)menuNeedsUpdate:(NSMenu *)menu;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// availableModes:
	NSArray * itemArray = [menu itemArray];
	NSEnumerator * E = [itemArray objectEnumerator];
	NSMenuItem * MI = nil;
	SEL action = @selector(takeMacroModeFromRepresentedObject:);
	NSMutableArray * availableModes = [NSMutableArray array];
	NSString * mode;
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			mode = [MI representedObject];
			if(![availableModes containsObject:mode])
			{
				[availableModes addObject:mode];
			}
		}
	}
	// expected modes:
	id firstResponder = [NSApp keyWindow];
	firstResponder = [firstResponder firstResponder];
	NSString * domain = [firstResponder macroDomain];
	iTM2MacroRootNode * rootNode = [self macroTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	NSArray * expectedModes = [domainNode availableCategories];
	//
	if([expectedModes isEqual:availableModes])
	{
		return;
	}
	// remove items with takeMacroModeFromRepresentedObject:
	E = [itemArray objectEnumerator];
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			[menu removeItem:MI];
		}
	}
	// recover the "Mode:" title menu item
	int index = [menu indexOfItemWithRepresentedObject:@"iTM2_PRIVATE_MacroModeMenuItem"];
	++index;

	E = [expectedModes objectEnumerator];
	while(mode = [E nextObject])
	{
		MI = [[[NSMenuItem allocWithZone:[menu zone]] initWithTitle:[mode description] action:action keyEquivalent:@""] autorelease];
		[MI setRepresentedObject:mode];
		[MI setIndentationLevel:1];
		[menu insertItem:MI atIndex:index++];
	}
	MI = [NSMenuItem separatorItem];
	[menu insertItem:MI atIndex:index++];
	[menu cleanSeparators];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineViewSelectionDidChange:
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
/*"Synchronize macro selection with key binding selection.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSOutlineView * outlineView = [notification object];
	NSWindow * W = [outlineView window];
	if(outlineView != [W firstResponder])
	{
		return;
	}
	[self synchronizeMacroSelectionWithKeyBindingSelection];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeMacroSelectionWithKeyBindingSelection
- (void)synchronizeMacroSelectionWithKeyBindingSelection;
/*"Synchronize macro selection with key binding selection.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTreeController * keysTreeController = [self keysTreeController];
	NSArray * selectedObjects = [keysTreeController selectedObjects];
	NSArrayController * macrosArrayController = [self macrosArrayController];
	NSIndexSet * indexes = [NSIndexSet indexSet];
	if([selectedObjects count] == 1)
	{
		id node = [selectedObjects lastObject];
		NSString * ID = [node ID];
		NSArray * arrangedObjects = [macrosArrayController arrangedObjects];
		NSEnumerator * E = [arrangedObjects objectEnumerator];
		unsigned index = 0;
		while(node = [E nextObject])
		{
			NSString * itsID = [node ID];
			if([itsID isEqual:ID])
			{
				indexes = [NSIndexSet indexSetWithIndex:index];
				break;
			}
			++index;
		}
	}
	[macrosArrayController setSelectionIndexes:indexes];
//iTM2_END;
	return;
}
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
	NSTableView * TV = [notification object];
	NSWindow * W = [TV window];
	if(TV != [W firstResponder])
	{
		return;
	}
	[self synchronizeKeyBindingSelectionWithMacroSelection];
//	[self performSelector:@selector(setSelectedMacro:) withObject:nil afterDelay:0];// raises [<iTM2MacroMutableLeafNode 0xd5ed670> removeObserver:<NSKeyValueObservationForwarder 0xd94f330> forKeyPath:@"value.ID"] was sent to an object that has no observers" if willChangeValueForKeyPath:... are used
	return;
}
- (void)synchronizeKeyBindingSelectionWithMacroSelection;
{
	NSArrayController * macrosArrayController = [self macrosArrayController];
	NSArray * selectedObjects = [macrosArrayController selectedObjects];
	if([selectedObjects count] == 1)
	{
		id selection = [selectedObjects lastObject];
		NSString * newID = [selection ID];
		NSTreeController * keysTreeController = [self keysTreeController];
		NSDictionary * contentArrayBindingDict = [keysTreeController infoForBinding:@"contentArray"];
		NSString * observedKeyPath = [contentArrayBindingDict objectForKey:NSObservedKeyPathKey];
		NSString * childrenKeyPath = [keysTreeController childrenKeyPath];
		NSMutableArray * childrenEnumeratorStack = [NSMutableArray array];
		unsigned index = 0;
		NSEnumerator * E = nil;		
		id controller = nil;
		NSIndexPath * IP = nil;
		id children = nil;
		if(controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey])
		{
			if(children = [controller mutableArrayValueForKeyPath:observedKeyPath])
			{
				if([children count])
				{
pushed:
					E = [children objectEnumerator];
					index = 0;
poped:
					while(controller = [E nextObject])
					{
						if(children = [controller mutableArrayValueForKeyPath:childrenKeyPath])
						{
							if([children count])
							{
								IP = IP?[IP indexPathByAddingIndex:index]:[NSIndexPath indexPathWithIndex:index];
								[childrenEnumeratorStack addObject:E];
								goto pushed;
							}
							else
							{
								NSString * itsID = [controller ID];
								if([itsID isEqual:newID])
								{
									IP = IP?[IP indexPathByAddingIndex:index]:[NSIndexPath indexPathWithIndex:index];
									childrenEnumeratorStack =  nil;
									E = nil;
									// this will break here
								}
							}
						}
						++index;
					}
					if(E = [childrenEnumeratorStack lastObject])
					{
						[childrenEnumeratorStack removeLastObject];
						unsigned int length = [IP length];
						index = [IP indexAtPosition:length-1];
						IP = length>1?[IP indexPathByRemovingLastIndex]:nil;
						goto poped;
					}
				}
			}
		}
		[keysTreeController setSelectionIndexPath:IP];
	}
//	[self performSelector:@selector(setSelectedMacro:) withObject:nil afterDelay:0];// raises [<iTM2MacroMutableLeafNode 0xd5ed670> removeObserver:<NSKeyValueObservationForwarder 0xd94f330> forKeyPath:@"value.ID"] was sent to an object that has no observers" if willChangeValueForKeyPath:... are used
	return;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2MainInstaller(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroKitCompleteInstallation
+ (void)iTM2MacroKitCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [NSApp mainMenu];
	NSMenuItem * MI = [M deepItemWithAction:@selector(macroMode:)];
	if(MI)
	{
		M = [MI menu];
		[MI setAction:NULL];
		[MI setRepresentedObject:@"iTM2_PRIVATE_MacroModeMenuItem"];
		[M setDelegate:SMC];
	}
	else
	{
		iTM2_LOG(@"No macros menu");
	}
//iTM2_END;
    return;
}
@end

NSString * const iTM2MacroDomainKey = @"iTM2MacroDomain";
NSString * const iTM2MacroCategoryKey = @"iTM2MacroCategory";
NSString * const iTM2MacroContextKey = @"iTM2MacroContext";

@implementation NSObject(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return iTM2MacroDomainKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroDomain
- (NSString *)defaultMacroDomain;
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
	NSString * key = [self macroDomainKey];
	NSString * result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([result length])
	{
		return result;
	}
	result = [self inheritedValueForKey:@"defaultMacroDomain"];
	if(![result length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
	}
	[self setMacroDomain:result];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroDomain:
- (void)setMacroDomain:(NSString *)argument;
{
	argument = [argument description];
	NSString * key = [self macroDomainKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if(![old isEqual:argument])
	{
		[self willChangeValueForKey:@"macroDomain"];
		[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
		[self didChangeValueForKey:@"macroDomain"];
	}
    return;
}//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return iTM2MacroCategoryKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
	NSString * key = [self macroCategoryKey];
	NSString * result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([result length])
	{
		return result;
	}
	result = [self inheritedValueForKey:@"defaultMacroCategory"];
	if(![result length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
	}
	if(![result length])
	{
		result = @"?";// reentrant code management
	}
	[self setMacroCategory:result];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	argument = [argument description];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	[self willChangeValueForKey:@"macroCategory"];
	[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
	[self didChangeValueForKey:@"macroCategory"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return iTM2MacroContextKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroContext
- (NSString *)defaultMacroContext;
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
- (NSString *)macroContext;
{
	NSString * key = [self macroContextKey];
	NSString * result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([result length])
	{
		return result;
	}
	result = [self inheritedValueForKey:@"defaultMacroContext"];
	if(![result length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
	}
	[self setMacroContext:result];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroContext:
- (void)setMacroContext:(NSString *)argument;
{
	argument = [argument description];
	NSString * key = [self macroContextKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if(![old isEqual:argument])
	{
		[self willChangeValueForKey:@"macroEditor"];
		[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
		[self setValue:nil forKey:@"macroEditor_meta"];
		[self didChangeValueForKey:@"macroEditor"];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeMacro:
- (BOOL)executeMacro:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString * macroDomain = [self macroDomain];
	NSString * macroCategory = [self macroCategory];
	NSString * macroContext = [self macroContext];
	return [SMC executeMacroWithID:macro forContext:macroContext ofCategory:macroCategory inDomain:macroDomain substitutions:nil target:self];
}
@end

@implementation NSView(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self superview]?[[self superview] macroDomainKey]:[[self window] macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self superview]?[[self superview] macroCategoryKey]:([[self nextResponder] macroCategoryKey]?:[[self window] macroCategoryKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id superview = [self superview];
	if(superview)
	{
		[superview setMacroCategory:argument];
	}
	else
	{
		id window = [self window];
		if(window)
		{
			[window setMacroCategory:argument];
		}
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self superview]?[[self superview] macroContextKey]:[[self window] macroContextKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacro:
- (BOOL)tryToExecuteMacro:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteMacro:macro]
			|| [[self superview] tryToExecuteMacro:macro]
				|| [[self window] tryToExecuteMacro:macro];// not good
}
@end

@implementation NSWindow(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self delegate]?[[self delegate] macroDomainKey]:([self windowController]?[[self windowController] macroDomainKey]:[super macroDomainKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self delegate]?[[self delegate] macroCategoryKey]:([self windowController]?[[self windowController] macroCategoryKey]:[super macroCategoryKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id delegate = [self delegate];
	if(delegate)
	{
		[delegate setMacroCategory:argument];
	}
	id windowController = [self windowController];
	if(windowController)
	{
		[windowController setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self delegate]?[[self delegate] macroContextKey]:([self windowController]?[[self windowController] macroContextKey]:[super macroContextKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacro:
- (BOOL)tryToExecuteMacro:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteMacro:macro]
			|| [[self delegate] executeMacro:macro]
				|| [[self windowController] tryToExecuteMacro:macro];
}
@end

@implementation NSWindowController(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self document]?[[self document] macroDomainKey]:[super macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self document]?[[self document] macroCategoryKey]:[super macroCategoryKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id document = [self document];
	if(document)
	{
		[document setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self document]?[[self document] macroContextKey]:[super macroContextKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacro:
- (BOOL)tryToExecuteMacro:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteMacro:macro]
			|| [[self document] executeMacro:macro]
				|| (([self owner] != self) && [[self owner] executeMacro:macro]);
}
@end

@interface NSResponder(iTM2MacroKit_)
- (void)resetKeyBindingsManager;
@end

NSString * const iTM2DontUseSmartMacrosKey = @"iTM2DontUseSmartMacros";

#import <iTM2Foundation/iTM2PreferencesKit.h>

@implementation NSResponder(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartMacros:
- (IBAction)toggleSmartMacros:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL old = [self contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextPrivateMask|iTM2ContextProjectMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartMacros:
- (BOOL)validateToggleSmartMacros:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeMacroModeFromRepresentedObject:
- (IBAction)takeMacroModeFromRepresentedObject:(id)sender;
{
	id newMode = [sender representedString];
	if(newMode)
	{
		[self setMacroCategory:newMode];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeMacroModeFromRepresentedObject:
- (BOOL)validateTakeMacroModeFromRepresentedObject:(id)sender;
{
	NSString * representedMode = [sender representedString];
	NSString * currentMode = [self macroCategory];
	[sender setState:([currentMode isEqual:representedMode]?NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroEdit:
- (IBAction)macroEdit:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[iTM2PrefsController sharedPrefsController] displayPrefsPaneWithIdentifier:@"3.Macro"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self nextResponder]?[[self nextResponder] macroDomainKey]:[super macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self nextResponder]?[[self nextResponder] macroCategoryKey]:[super macroCategoryKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id nextResponder = [self nextResponder];
	if(nextResponder)
	{
		[nextResponder setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
	// reentrant management
	id new = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:new])
	{
		return;
	}
	if(old == new)
	{
		return;
	}
	[self resetKeyBindingsManager];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self nextResponder]?[[self nextResponder] macroContextKey]:[super macroContextKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeStringInstruction:
- (BOOL)executeMacro:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self tryToExecuteMacro:macro];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacro:
- (BOOL)tryToExecuteMacro:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [macro rangeOfString:@":"];
	if(R.length)
	{
		R.length = R.location + 1;
		R.location = 0;
		NSString * selectorName = [macro substringWithRange:R];
		SEL action = NSSelectorFromString(selectorName);
		if([self respondsToSelector:action])
		{
			R.location = R.length;
			R.length = [macro length] - R.location;
			NSString * argument = [macro substringWithRange:R];
			if([self tryToPerform:action with:argument])
			{
				return YES;
			}
		}
	}
//iTM2_END;
    return NO;
}
@end

@implementation iTM2GenericScriptButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroMenu
- (NSMenu *)macroMenu;// don't call this "menu"!
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = NSStringFromClass([self class]);
	NSRange R1 = [name rangeOfString:@"Script"];
	if(R1.length)
	{
		NSRange R2 = [name rangeOfString:@"Button"];
		if(R2.length && (R1.location += R1.length, (R2.location > R1.location)))
		{
			R1.length = R2.location - R1.location;
			NSString * context = [name substringWithRange:R1];
			NSString * category = [self macroCategory];
			NSString * domain = [self macroDomain];
			NSMenu * M = [SMC macroMenuForContext:context ofCategory:category inDomain:domain error:nil];
			M = [[M deepCopy] autorelease];
			// insert a void item for the title
			[M insertItem:[[[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""] autorelease] atIndex:0];// for the title
			return M;
		}
	}
//iTM2_END;
    return [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[iTM2GenericScriptButton superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[[self retain] autorelease];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
	[DNC addObserver:self selector:@selector(popUpButtonCellWillPopUpNotification:) name:NSPopUpButtonCellWillPopUpNotification object:[self cell]];
	[[self cell] setAutoenablesItems:YES];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= popUpButtonCellWillPopUpNotification:
- (void)popUpButtonCellWillPopUpNotification:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setMenu:[self macroMenu]];
	[DNC removeObserver:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[DNC removeObserver:self];
	[super dealloc];
//iTM2_END;
    return;
}
@end

#pragma mark -

@implementation NSTextView(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
+ (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [SUD stringForKey:iTM2TextTabAnchorStringKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectFirstPlaceholder:
- (IBAction)selectFirstPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:0 cycle:NO tabAnchor:tabAnchor];
	if(!firstPlaceholderRange.length)
	{
		return;
	}
	// if it is already selected, remove, replace it
	NSRange selectedRange = [self selectedRange];
	if(!NSEqualRanges(selectedRange,firstPlaceholderRange))
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
	if(selectedRange.length>6)// does the selection match: "@@.+@@\."
	{
		switch([S characterAtIndex:selectedRange.location+2])
		{
			case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderARG:// keep the content
				selectedRange.location+=3;
				selectedRange.length -= 6;
				S = [S substringWithRange:selectedRange];
				[self insertText:S];
				goto doSelect;
			
			case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderOPT:default:// remove the content
				[self insertText:@""];
doSelect:
				firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor];
				if(firstPlaceholderRange.length)
				{
					[self setSelectedRange:firstPlaceholderRange];
					[self scrollRangeToVisible:[self selectedRange]];
				}
				return;
		}
	}
		// remove the content
	[self insertText:@""];
	goto doSelect;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectLastPlaceholderAndClean:
- (IBAction)selectLastPlaceholderAndClean:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:0 cycle:NO tabAnchor:tabAnchor];
	if(firstPlaceholderRange.length)
	{
		[self selectFirstPlaceholder:sender];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextPlaceholder:
- (IBAction)selectNextPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange selectedRange = [self selectedRange];
	NSRange actualPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor];
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:NSMaxRange(selectedRange) cycle:YES tabAnchor:tabAnchor];
	if(firstPlaceholderRange.length==0)
	{
iTM2_LOG(@"firstPlaceholderRange:%@",NSStringFromRange(firstPlaceholderRange));
		return;
	}
	// if it is already selected, remove, replace it
	if(!NSEqualRanges(selectedRange,actualPlaceholderRange))
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:firstPlaceholderRange];
		return;
	}
	if(selectedRange.length>6)
	{
		switch([S characterAtIndex:selectedRange.location+2])
		{
			case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderARG:// keep the content
				selectedRange.location+=3;
				selectedRange.length -= 6;
				S = [S substringWithRange:selectedRange];
				[self insertText:S];
				goto doSelect;
			
			case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderOPT:default:// remove the content
				[self insertText:@""];
doSelect:
				firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor];
				if(firstPlaceholderRange.length)
				{
					[self setSelectedRange:firstPlaceholderRange];
					[self scrollRangeToVisible:[self selectedRange]];
				}
				return;
		}
	}
	else
	{
		// simply remove the selected stuff
		[self insertText:@""];
	}
	goto doSelect;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousPlaceholder:
- (IBAction)selectPreviousPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange selectedRange = [self selectedRange];
	NSRange firstPlaceholderRange = [S rangeOfPreviousPlaceholderBeforeIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(!firstPlaceholderRange.length)
	{
		return;
	}
	// if it is already selected, remove, replace it
	if(!NSEqualRanges(selectedRange,firstPlaceholderRange))
	{
		[self setSelectedRange:selectedRange];
		[self scrollRangeToVisible:selectedRange];
		return;
	}
	if(selectedRange.length>6)
	{
		switch([S characterAtIndex:selectedRange.location+2])
		{
			case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderARG:// keep the content
				selectedRange.location+=3;
				selectedRange.length -= 6;
				S = [S substringWithRange:selectedRange];
				[self insertText:S];
				goto doSelect;
			
			case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderOPT:default:// remove the content
				[self insertText:@""];
doSelect:
				firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor];
				if(firstPlaceholderRange.length)
				{
					[self setSelectedRange:firstPlaceholderRange];
					[self scrollRangeToVisible:[self selectedRange]];
				}
				return;
		}
	}
	goto doSelect;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchorKey
+ (NSString *)tabAnchorKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2TextTabAnchorStringKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
- (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextStringForKey:[[self class] tabAnchorKey] domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfSpacesPerTab
- (unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cachedSelection
- (NSString *)cachedSelection;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self string] substringWithRange:[self selectedRange]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacro:
- (BOOL)tryToExecuteMacro:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [macro rangeOfString:@":"];
	if(R.length)
	{
		R.length = R.location + 1;
		R.location = 0;
		NSString * selectorName = [macro substringWithRange:R];
		SEL action = NSSelectorFromString(selectorName);
		if([self respondsToSelector:action])
		{
			R.location = R.length;
			R.length = [macro length] - R.location;
			NSString * argument = [macro substringWithRange:R];
			if([self tryToPerform:action with:argument])
			{
				return YES;
			}
		}
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:
- (void)insertMacro:(id)argument;
/*"Description forthcoming. argument is either a dictionary with strings for keys "before", "selected" and "after" or a string playing the role of before keyed object (the other strings are blank). When the argument is a NSMenuItem (or so) we add a pretreatment replacing the argument by its represented object.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self insertMacro:argument substitutions:nil mode:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getReplacementString:affectedCharRange:forMacro:substitutions:mode:
- (void)getReplacementString:(NSString **)replacementStringRef affectedCharRange:(NSRangePointer)affectedCharRangePtr forMacro:(NSString *)macro substitutions:(NSDictionary *)substitutions mode:(NSString *)mode;
/*"Description forthcoming. Will be completely overriden by subclassers.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange affectedCharRange = [self selectedRange];
	if(affectedCharRangePtr)
	{
		* affectedCharRangePtr = affectedCharRange;
	}
	NSRange range;
	NSEnumerator * E;
	NSString * string1, * string2;
	NSMutableString * replacementString;
	if([substitutions count])
	{
		replacementString = [[macro mutableCopy] autorelease];
		E = [substitutions keyEnumerator];
		while(string1 = [E nextObject])
		{
			string2 = [substitutions objectForKey:string1];
			range = NSMakeRange(0,[replacementString length]);
			[replacementString replaceOccurrencesOfString:string1 withString:string2 options:nil range:range];
		}
		macro = [NSString stringWithString:replacementString];
	}
	NSString * S = [self string];
	NSRange selectedRange = [self selectedRange];
	NSString * selectedString = [S substringWithRange:selectedRange];
	unsigned numberOfSpacesPerTab = [self numberOfSpacesPerTab];
	selectedString = [selectedString stringByNormalizingIndentationWithNumberOfSpacesPerTab:numberOfSpacesPerTab];
	NSArray * components = [selectedString lineComponents];
	NSMutableArray * MRA = [NSMutableArray array];
	E = [components objectEnumerator];
	unsigned lineIndentation = 0;
	unsigned indentation = [S indentationLevelAtIndex:selectedRange.location withNumberOfSpacesPerTab:numberOfSpacesPerTab];
	while(string1 = [E nextObject])
	{
		lineIndentation = [string1 indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		if(lineIndentation>indentation)
		{
			lineIndentation-=indentation;
			string1 = [string1 stringWithIndentationLevel:lineIndentation atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		}
		[MRA addObject:string1];
	}
	selectedString = [MRA componentsJoinedByString:@"__iTM2_INDENTATION_PREFIX__"];
	// managing the parameters, this is LaTeX specific
	replacementString = [NSMutableString string];
	NSString * tabAnchor = [self tabAnchor];
	range = [macro rangeOfNextPlaceholderAfterIndex:0 cycle:NO tabAnchor:tabAnchor];
	NSScanner * scanner;
#warning FAILED: this should live in the latex code
	if([macro hasPrefix:@"\\"] && !range.length)
	{
		components = [macro componentsSeparatedByString:@"|"];
		macro = [components objectAtIndex:0];
		MRA = [NSMutableArray arrayWithArray:components];
		[MRA removeObjectAtIndex:0];
		scanner = [NSScanner scannerWithString:macro];
		NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"[{"];
		E = [MRA objectEnumerator];
		while([scanner scanUpToCharactersFromSet:set intoString:&string2])
		{
			[replacementString appendString:string2];
			
			if([scanner scanString:@"[" intoString:nil])
			{
				[scanner scanUpToString:@"]" intoString:&string2]||(string2=@"");
				if([scanner scanString:@"]" intoString:nil])
				{
					string1 = [E nextObject];
					[replacementString appendString:@"@@[[@@["];
					string2 = [string2 length]?string2:(string1?:selectedString);
					[replacementString appendString:string2];
					[replacementString appendString:@"@@.]@@."];
				}
				else
				{
					[replacementString appendString:string2];
					break;
				}
			}
			else if([scanner scanString:@"{" intoString:nil])
			{
				[scanner scanUpToString:@"}" intoString:&string2]||(string2=@"");
				if([scanner scanString:@"}" intoString:nil])
				{
					[replacementString appendString:@"{@@{"];
					string1 = [E nextObject];
					string2 = [string2 length]?string2:(string1?:selectedString);
					[replacementString appendString:string2];
					[replacementString appendString:@"@@.}"];
				}
				else
				{
					[replacementString appendString:string2];
					break;
				}
			}
		}
		range.location = [scanner scanLocation];
		range.length = [macro length] - range.location;
		string1 = [macro substringWithRange:range];
		[replacementString appendString:string1];
	}
	else
	{
		replacementString = [macro mutableCopy];
	}
	if(selectedRange.length==0)
	{
		// just change the placeholder marks
		range = NSMakeRange(0,[replacementString length]);
		[replacementString replaceOccurrencesOfString:@"@@\"" withString:@"@@{" options:nil range:range];
		[replacementString replaceOccurrencesOfString:@"@@'" withString:@"@@[" options:nil range:range];
 //iTM2_END;
		goto manageTheIndentation;
	}
	macro = [NSString stringWithString:replacementString];
	replacementString = [NSMutableString string];
	unsigned startType = 0,stopType;
	NSRange startRange = NSMakeRange(0,0);
	NSRange stopRange = NSMakeRange(0,0);
	range = NSMakeRange(0,0);
	unsigned index = 0;
	
nextRange:
	startRange = [macro rangeOfNextPlaceholderMarkAfterIndex:index getType:&startType];
	if(startRange.length)
	{
		range.location = NSMaxRange(stopRange);
		range.length = startRange.location - range.location;
		string1 = [macro substringWithRange:range];
		[replacementString appendString:string1];
nextStopRange:
		index = NSMaxRange(startRange);
		stopRange = [macro rangeOfNextPlaceholderMarkAfterIndex:index getType:&stopType];
		if(stopRange.length)
		{
			index = NSMaxRange(stopRange);
			if(startType == kiTM2TextPlaceholderHLT)
			{
				range = startRange;
				range.length = NSMaxRange(stopRange) - range.location;
				string1 = [macro substringWithRange:range];
				[replacementString appendString:string1];
				goto nextRange;
			}
			else if(stopType == kiTM2TextPlaceholderHLT)
			{
				switch(startType)
				{
					case kiTM2TextPlaceholderINS://When no content, use the selection
					case kiTM2TextPlaceholderTAB://When no content, use the selection
						if((stopRange.location == NSMaxRange(startRange)) && [selectedString length])
						{
							string1 = [macro substringWithRange:startRange];
							[replacementString appendString:string1];
							[replacementString appendString:selectedString];
							string1 = [macro substringWithRange:stopRange];
							[replacementString appendString:string1];
						}
						else
						{
							range = startRange;
							range.length = NSMaxRange(stopRange) - range.location;
							string1 = [macro substringWithRange:range];
							[replacementString appendString:string1];
						}
						goto nextRange;
					case kiTM2TextPlaceholderARG://When no selection, use the content
					case kiTM2TextPlaceholderOPT://When no selection, use the content
						if([selectedString length])
						{
							string1 = [macro substringWithRange:startRange];
							[replacementString appendString:string1];
							[replacementString appendString:selectedString];
							string1 = [macro substringWithRange:stopRange];
							[replacementString appendString:string1];
						}
						else
						{
							range = startRange;
							range.length = NSMaxRange(stopRange) - range.location;
							string1 = [macro substringWithRange:range];
							[replacementString appendString:string1];
						}
						goto nextRange;
				}
			}
			else
			{
				range = startRange;
				range.length = stopRange.location - range.location;
				string1 = [macro substringWithRange:range];
				[replacementString appendString:string1];
				startType = stopType;
				startRange = stopRange;
				goto nextStopRange;
			}
		}
		else
		{
			range = startRange;
			range.length = [macro length] - range.location;
			string1 = [macro substringWithRange:range];
			[replacementString appendString:string1];
		}
	}
	else
	{
		range.location = NSMaxRange(stopRange);
		range.length = [macro length] - range.location;
		string1 = [macro substringWithRange:range];
		[replacementString appendString:string1];
	}
manageTheIndentation:
	// now manage the indentation
	MRA = [NSMutableArray array];
	components = [replacementString lineComponents];
	E = [components objectEnumerator];
	unsigned indentationLevel = [S indentationLevelAtIndex:affectedCharRange.location withNumberOfSpacesPerTab:numberOfSpacesPerTab];
	unsigned currentIndentationLevel = 0, localIndentationLevel = 0;
	range.location = 27;
	string1 = [E nextObject];
	[MRA addObject:string1];//no indentation on the first line
	while(string1 = [E nextObject])
	{
		if([string1 hasPrefix:@"__iTM2_INDENTATION_PREFIX__"])
		{
			range.length = [string1 length]-range.location;
			string1 = [string1 substringWithRange:range];
			if(currentIndentationLevel)
			{
				localIndentationLevel = currentIndentationLevel + [string1 indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
				string1 = [string1 stringWithIndentationLevel:localIndentationLevel atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
			}
		}
		else
		{
			currentIndentationLevel = indentationLevel + [string1 indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
			string1 = [string1 stringWithIndentationLevel:currentIndentationLevel atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		}
		[MRA addObject:string1];
	}
	macro = [MRA componentsJoinedByString:@""];
	replacementString = [NSMutableString stringWithString:macro];
	if(index = [replacementString length])
	{
		range = [replacementString rangeOfPreviousPlaceholderBeforeIndex:index cycle:NO tabAnchor:tabAnchor];
		if(range.length)
		{
			if(NSMaxRange(range)<index)
			{
				[replacementString appendString:@"@@{@@."];
			}
		}
	}
	if(replacementStringRef)
	{
		* replacementStringRef = replacementString;
	}
 //iTM2_END;
   return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:substitutions:mode:
- (void)insertMacro:(id)argument substitutions:(NSDictionary *)substitutions mode:(NSString*)mode;
/*"Description forthcoming. argument is either a dictionary with strings for keys "before", "selected" and "after" or a string playing the role of before keyed object (the other strings are blank). When the argument is a NSMenuItem (or so) we add a pretreatment replacing the argument by its represented object.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([argument conformsToProtocol:@protocol(NSMenuItem)])
        argument = [argument representedObject];
// this new part concerns the new macro design. 2006
    if([argument isKindOfClass:[NSString class]])
	{
//iTM2_LOG(@"argument:%@",argument);
		NSString * replacementString = argument;		
		NSString ** replacementStringRef = &argument;		
		NSRange affectedCharRange = [self selectedRange];
		NSRangePointer affectedCharRangePtr = &affectedCharRange;
		NSString * category = [self macroCategory];
		if([category length])
		{
			NSString * action = [NSString stringWithFormat:@"getReplacementString:affectedCharRange:for%@Macro:substitutions:mode:",category];
			SEL selector = NSSelectorFromString(action);
			NSMethodSignature * MS = [self methodSignatureForSelector:selector];
			NSMethodSignature * myMS = [self methodSignatureForSelector:@selector(getReplacementString:affectedCharRange:forMacro:substitutions:mode:)];
			if([MS isEqual:myMS])
			{
				NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
				[I setTarget:self];
				[I setArgument:&replacementStringRef atIndex:2];
				[I setArgument:&affectedCharRangePtr atIndex:3];
				[I setArgument:&substitutions atIndex:4];
				[I setArgument:&mode atIndex:5];
				[I setSelector:selector];
				NS_DURING
				[I invoke];
				affectedCharRange = * affectedCharRangePtr;
				replacementString = * replacementStringRef;
				NS_HANDLER
				iTM2_LOG(@"EXCEPTION Catched: %@", localException);
				NS_ENDHANDLER
			}
			else
			{
				[self getReplacementString:replacementStringRef affectedCharRange:affectedCharRangePtr forMacro:argument substitutions:substitutions mode:mode];
				affectedCharRange = * affectedCharRangePtr;
				replacementString = * replacementStringRef;
			}
		}
		else
		{
			[self getReplacementString:replacementStringRef affectedCharRange:affectedCharRangePtr forMacro:argument substitutions:substitutions mode:mode];
			affectedCharRange = * affectedCharRangePtr;
			replacementString = * replacementStringRef;
		}
		if([self contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextPrivateMask|iTM2ContextExtendedMask])
		{
			replacementString = [replacementString stringByRemovingPlaceholderMarks];
		}
		if([self shouldChangeTextInRange:affectedCharRange replacementString:replacementString])
		{
			[self replaceCharactersInRange:affectedCharRange withString:replacementString];
			[self didChangeText];
			[self selectFirstPlaceholder:self];
		}
		return;
	}
	if([argument isKindOfClass:[NSArray class]])
	{
		NSEnumerator * E = [argument objectEnumerator];
		while(argument = [E nextObject])
		{
			[self insertMacro:argument substitutions:substitutions mode:mode];
		}
	}
    NSLog(@"Don't know what to do with this argument: %@", argument);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroDomain
- (NSString *)defaultMacroDomain;
{
    return @"Text";
}
@end

@implementation NSString(PRIVATE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bullet
+ (NSString *)bullet;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSString * _Bullet = nil;
    return _Bullet? _Bullet: (_Bullet = [[NSString stringWithUTF8String:"•"] copy]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineComponents
- (NSArray *)lineComponents;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * lines = [NSMutableArray array];
	NSRange R = NSMakeRange(0,0);
	unsigned contentsEnd = 0, end = 0;
	while(R.location < [self length])
	{
		R.length = 0;
		[self getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		R.length = end - R.location;
		NSString * S = [self substringWithRange:R];
		[lines addObject:S];
		R.location = end;
		R.length = 0;
	}
	if(contentsEnd<end)
	{
		// the last line is a return line
		[lines addObject:@""];
	}
//iTM2_END;
	return lines;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceholderMarks
- (NSString *)stringByRemovingPlaceholderMarks;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [NSMutableString stringWithCapacity:[self length]];
	NSRange selectRange, markRange;
	unsigned length = [self length];
	NSString * substring;
	selectRange.location = 0;
next:
	markRange = [self rangeOfNextPlaceholderMarkAfterIndex:selectRange.location getType:nil];
	if(markRange.length)
	{
		selectRange.length=markRange.location-selectRange.location;
		substring = [self substringWithRange:selectRange];
		[result appendString:substring];
		selectRange.location = NSMaxRange(markRange);
		goto next;
	}
	selectRange.length=length-selectRange.location;
	substring = [self substringWithRange:selectRange];// the trailer
	[result appendString:substring];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderMarkAfterIndex:getType:
- (NSRange)rangeOfNextPlaceholderMarkAfterIndex:(unsigned)index getType:(unsigned *)typeRef;
/*"Description forthcoming. Just assume that there is no placeholder mark ending at index or index+1
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	NSRange searchRange, markRange;
	searchRange.location = index;
nextMark:
	searchRange.length = length - searchRange.location;
	markRange = [self rangeOfString:iTM2TextPlaceholderMark options:nil range:searchRange];
	if(markRange.length)
	{
whatIsAfter:
		searchRange.location = NSMaxRange(markRange);
		if(searchRange.location<length)
		{
			unichar theChar = [self characterAtIndex:searchRange.location];
			switch(theChar)
			{
				case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderARG: case kiTM2TextPlaceholderOPT: case kiTM2TextPlaceholderHLT:
					++markRange.length;
					if(typeRef)
					{
						*typeRef = theChar;
					}
					return markRange;
				case '@':
					++markRange.location;
					goto whatIsAfter;
				default:
					goto nextMark;
					
			}
			// unreachable point
		}
	}
//iTM2_END;
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderMarkBeforeIndex:getType:
- (NSRange)rangeOfPreviousPlaceholderMarkBeforeIndex:(unsigned)index getType:(unsigned *)typeRef;
/*"Description forthcoming. The leading "@" is before index, index excluded
This will catch a marker starting at index and below
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	NSRange searchRange, markRange;
	searchRange.location = 0;
	markRange.location = MIN(index+1,length);
nextMark:
	searchRange.length=markRange.location;
	markRange = [self rangeOfString:iTM2TextPlaceholderMark options:NSBackwardsSearch range:searchRange];
	if(markRange.length)
	{
		// markRange.location + 2 <= searchRange.length <= MAX(index-1,length-2)
		index = NSMaxRange(markRange);
		if(index<length)
		{
			unichar theChar = [self characterAtIndex:index];
			switch(theChar)
			{
				case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderARG: case kiTM2TextPlaceholderOPT: case kiTM2TextPlaceholderHLT:
					++markRange.length;
					if(typeRef)
					{
						*typeRef=theChar;
					}
					return markRange;
				default:
					break;
			}
		}
		goto nextMark;
	}
//iTM2_END;
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/02/2007
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange startRange, stopRange;
	unsigned depth;
	unsigned anchor = MAX(index,2)-2;
	unsigned type;
nextStop:
	stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:anchor getType:&type];
	if(stopRange.length)
	{
		switch(type)
		{
			case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderARG: case kiTM2TextPlaceholderOPT:
				if(stopRange.location<=index)
				{
					// this is a start mark containing index
					// we have to find a balancing stop mark to the right
					startRange = stopRange;
					depth = 1;
otherNextStop:
					anchor = NSMaxRange(stopRange);
					stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:anchor getType:&type];
					if(stopRange.length)
					{
						switch(type)
						{
							case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderARG: case kiTM2TextPlaceholderOPT:
								++depth;
								goto otherNextStop;
							case kiTM2TextPlaceholderHLT:
								--depth;
								if(depth)
								{
									goto otherNextStop;
								}
								else
								{
									startRange.length = NSMaxRange(stopRange)-startRange.location;
									return startRange;
								}
							default:
								goto otherNextStop;
						}
					}
					return NSMakeRange(NSNotFound,0);
				}
				else
				{
					// this is a start to the right
					depth = 1;
otherNextStopAfter:
					anchor = NSMaxRange(stopRange);
					stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:anchor getType:&type];
					if(stopRange.length)
					{
						switch(type)
						{
							case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderARG: case kiTM2TextPlaceholderOPT:
								++depth;
								goto otherNextStopAfter;
							case kiTM2TextPlaceholderHLT:
								--depth;
								if(depth)
								{
									goto otherNextStopAfter;
								}
								else
								{
									// find the balancing start
previousStart:
									startRange.location = MAX(index,2)-2;
									depth = 1;
otherPreviousStart:
									startRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:startRange.location getType:&type];
									if(startRange.length)
									{
										switch(type)
										{
											case kiTM2TextPlaceholderHLT:
												++depth;
												goto otherPreviousStart;
											case kiTM2TextPlaceholderINS: case kiTM2TextPlaceholderTAB: case kiTM2TextPlaceholderARG: case kiTM2TextPlaceholderOPT:
												if(--depth)
												{
													goto otherPreviousStart;
												}
												else
												{
													startRange.length=NSMaxRange(stopRange)-startRange.location;
													return startRange;
												}
											default:
												goto otherNextStopAfter;
										}
									}
									// no balancing mark available
									return NSMakeRange(NSNotFound,0);
								}
							default:
								goto otherNextStopAfter;
						}
					}
					// no balancing mark available
					return NSMakeRange(NSNotFound,0);
				}
			case kiTM2TextPlaceholderHLT:
				goto previousStart;

			default:
				anchor = NSMaxRange(stopRange);
				goto nextStop;
		}
	}
//iTM2_END;
	return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderAfterIndex:cycle:tabAnchor:
- (NSRange)rangeOfNextPlaceholderAfterIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self rangeOfPlaceholderAtIndex:index];
	if(range.length)
	{
		return range;
	}
	NSRange markRange = [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil];
	NSRange smallerRange;
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location];
		if(range.length)
		{
nextRange1:
			markRange = [self rangeOfNextPlaceholderMarkAfterIndex:range.location+3 getType:nil];
			if(markRange.length)
			{
				if(NSMaxRange(markRange)<NSMaxRange(range))
				{
					smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location];
					if(smallerRange.length)
					{
						range = smallerRange;
						goto nextRange1;
					}
				}
			}
			return range;
		}
	}
	if(cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil];
		if(markRange.length)
		{
			if(NSMaxRange(markRange)<=index)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location];
				if(range.length)
				{
nextRange2:
					markRange = [self rangeOfNextPlaceholderMarkAfterIndex:range.location+3 getType:nil];
					if(markRange.length)
					{
						if(NSMaxRange(markRange)<NSMaxRange(range))
						{
							smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location];
							if(smallerRange.length)
							{
								range = smallerRange;
								goto nextRange2;
							}
						}
					}
					return range;
				}
			}
		}
	}
	// placeholder markers only
	markRange= [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil];
	if(markRange.length)
	{
		return markRange;
	}
	if(cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil];
		if(markRange.length)
		{
			if(NSMaxRange(markRange)<=index)
			{
				return markRange;
			}
		}
	}
	// tabAnchor only
	if([tabAnchor length])
	{
		unsigned length = [self length];
		NSRange searchRange = NSMakeRange(index, length - index);
		range = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(range.length)
		{
			return range;
		}
		if(cycle)
		{
			searchRange = NSMakeRange(0,MIN(length,index+[tabAnchor length]-1));
			range = [self rangeOfString:tabAnchor options:nil range:searchRange];
			if(range.length)
			{
				return range;
			}
		}
	}
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderBeforeIndex:cycle:tabAnchor:
- (NSRange)rangeOfPreviousPlaceholderBeforeIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement NSBackwardsSearch
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self rangeOfPlaceholderAtIndex:index];
	if(range.length)
	{
		return range;
	}
	NSRange markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil];
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location];
		if(range.length)
		{
			return range;
		}
	}
	unsigned length = [self length];
	if(cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil];
		if(markRange.length)
		{
			if(index<=markRange.location)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location];
				if(range.length)
				{
					return range;
				}
			}
		}
	}
	// placeholder markers only
	markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil];
	if(markRange.length)
	{
		return markRange;
	}
	if(cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil];
		if(markRange.length)
		{
			if(index<=markRange.location)
			{
				return markRange;
			}
		}
	}
	// tabAnchor only
	if([tabAnchor length])
	{
		NSRange searchRange = NSMakeRange(0, index);
		range = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(range.length)
		{
			return range;
		}
		if(cycle)
		{
			searchRange = NSMakeRange(index,length-index);
			range = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
			if(range.length)
			{
				return range;
			}
		}
	}
	return NSMakeRange(NSNotFound,0);
}
#pragma mark =-=-=-=-=-  INDENTATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByNormalizingIndentationWithNumberOfSpacesPerTab:
- (NSString *)stringByNormalizingIndentationWithNumberOfSpacesPerTab:(int)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * _Tab = nil;
	int idx = numberOfSpacesPerTab;
	if(idx<=0)
	{
		_Tab = @"\t";
	}
	else
	{
		NSMutableString * MS = [NSMutableString string];
		while(idx--)
		{
			[MS appendString:@" "];
		}
		_Tab = [MS copy];
	}
	if(numberOfSpacesPerTab<0)
	{
		numberOfSpacesPerTab = -numberOfSpacesPerTab;
	}
	else if(numberOfSpacesPerTab==0)
	{
		numberOfSpacesPerTab = 4;
	}

	NSArray * lineComponents = [self lineComponents];
	NSMutableString * normalized = [NSMutableString string];
	NSEnumerator * E = [lineComponents objectEnumerator];
	NSString * line;
	while(line = [E nextObject])
	{
		unsigned lineIndentation = 0;
		unsigned currentLength = 0;
		unsigned charIndex = 0;
		while(charIndex<[line length])
		{
			unichar theChar = [self characterAtIndex:charIndex];
			if(theChar == ' ')
			{
				++currentLength;
			}
			else if(theChar == '\t')
			{
				++lineIndentation;
				lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
				currentLength = 0;
			}
			else
			{
				break;
			}
			++charIndex;
		}
		lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
		while(lineIndentation--)
		{
			[normalized appendString:_Tab];
		}
		NSString * tail = [line substringFromIndex:charIndex];
		[normalized appendString:tail];
	}
//iTM2_END;
	return normalized;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringWithIndentationLevel:atIndex:withNumberOfSpacesPerTab:
- (NSString *)stringWithIndentationLevel:(unsigned)indentation atIndex:(unsigned)index withNumberOfSpacesPerTab:(int)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [NSMutableString string];
	NSRange lineRange = NSMakeRange(index,0);
	lineRange = [self lineRangeForRange:lineRange];// the line range containing the given index
	NSString * string = [self substringToIndex:lineRange.location];// everything before the line
	[result appendString:string];// copied as is
	// now append the expected indentation for the line containing index
	NSString * tabString = nil;
	int idx = numberOfSpacesPerTab;
	if(idx<=0)
	{
		tabString = @"\t";
	}
	else
	{
		NSMutableString * MS = [NSMutableString string];
		while(idx--)
		{
			[MS appendString:@" "];
		}
		tabString = [MS copy];
	}
	while(indentation--)
	{
		[result appendString:tabString];
	}
	// now copying the line without its white prefix
	unsigned top = NSMaxRange(lineRange);
	NSCharacterSet * whiteSet = [NSCharacterSet whitespaceCharacterSet];
	while(lineRange.location<top)
	{
		unichar theChar = [self characterAtIndex:lineRange.location];
		if(![whiteSet characterIsMember:theChar])
		{
			break;
		}
		++lineRange.location;
	}
	lineRange.length = top - lineRange.location;
	string = [self substringWithRange:lineRange];
	[result appendString:string];
	// finally copy the rest of the receiver as is
	string = [self substringFromIndex:top];
	[result appendString:string];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indentationLevelAtIndex:withNumberOfSpacesPerTab:
- (unsigned)indentationLevelAtIndex:(unsigned)index withNumberOfSpacesPerTab:(unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(numberOfSpacesPerTab<0)
	{
		numberOfSpacesPerTab = -numberOfSpacesPerTab;
	}
	else if(!numberOfSpacesPerTab)
	{
		numberOfSpacesPerTab = 4;
	}
	NSRange R;
	R.location = index;
	R.length = 0;
	unsigned top;
	[self getLineStart:&index end:nil contentsEnd:&top forRange:R];
	unsigned result = 0;
	unsigned currentLength = 0;
	while(index<top)
	{
		unichar theChar = [self characterAtIndex:index++];
		if(theChar == ' ')
		{
			++currentLength;
		}
		else if(theChar == '\t')
		{
			++result;
			result += (2*currentLength)/numberOfSpacesPerTab;
			currentLength = 0;
		}
		else
		{
			break;
		}
	}
	result += (2*currentLength)/numberOfSpacesPerTab;
//iTM2_END;
	return result;
}
@end

@implementation iTM2AppleScriptMacro
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithScript:
- (id)initWithScript:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setScript:argument];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setScript:nil];
    [self setToolTip:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  script
- (NSString *)script;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Script;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScript:
- (void)setScript:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    if(![_Script isEqualToString:argument])
    {
        [_Script autorelease];
        _Script = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolTip
- (NSString *)toolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ToolTip;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolTip:
- (void)setToolTip:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    if(![_ToolTip isEqualToString:argument])
    {
        [_ToolTip autorelease];
        _ToolTip = [argument retain];
    }
    return;
}
@end

@implementation iTM2AppleScriptFileMacro
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithPath:
- (id)initWithPath:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setPath:argument];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setPath:nil];
    [self setToolTip:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  path
- (NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPath:
- (void)setPath:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    if(![_Path isEqualToString:argument])
    {
        [_Path autorelease];
        _Path = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolTip
- (NSString *)toolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ToolTip;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolTip:
- (void)setToolTip:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning DID YOU IMPLEMENT THE TOOLTIP SHORTCUT
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    if(![_ToolTip isEqualToString:argument])
    {
        [_ToolTip autorelease];
        _ToolTip = [argument retain];
    }
    return;
}
@end

#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection_MACRO)
/*"Description forthcoming."*/
@implementation NSTextStorage(iTM2Selection_MACRO)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertMacro:inRangeValue:
- (void)insertMacro:(id)argument inRangeValue:(id)rangeValue;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([argument isKindOfClass:[NSString class]] || [argument isKindOfClass:[NSDictionary class]])
    {
        NSTextView * TV = [self mainTextView];
        if([rangeValue respondsToSelector:@selector(rangeValue)])
            [TV setSelectedRange:[rangeValue rangeValue]];
        [TV insertMacro:argument];        
    }
    else
    {
        NSLog(@"JL, you should have raised an exception!!! (code 1789)");
    }
    return;
}
@end

/*"Description forthcoming."*/
@interface iTM2MacroArrayController: NSArrayController
@end

@implementation iTM2MacroArrayController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  canRemove
- (BOOL)canRemove;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSIndexSet * indexSet = [self selectionIndexes];
	NSArray * RA = [self arrangedObjects];
	unsigned int index = [indexSet firstIndex];
	while(index != NSNotFound)
	{
		id O = [RA objectAtIndex:index];
		if([O respondsToSelector:@selector(isMutable)] && [O isMutable])
		{
			return YES;
		}
		index = [indexSet indexGreaterThanIndex:index];
	}
	RA = [self content];
//iTM2_END;
    return NO;
}
- (void)insertObject:(id)object atArrangedObjectIndex:(unsigned int)index;    // inserts into the content objects and the arranged objects (as specified by index in the arranged objects) - will raise an exception if the object does not match all filters currently applied
{
	[super insertObject:(id)object atArrangedObjectIndex:(unsigned int)index];
	NSArray * arrangedObjects = [self arrangedObjects];
	index = [arrangedObjects indexOfObject:object];
	[self setSelectionIndex:index];
	return;
}
@end

@interface iTM2MacroKeyStroke: NSObject <NSCopying>
{
@public
	NSString * codeName;
	NSString * _description;
	NSString * _string;
	BOOL isCommand;
	BOOL isShift;
	BOOL isAlternate;
	BOOL isControl;
	BOOL isFunction;
}
- (id)initWithCodeName:(NSString*)newCodeName;
- (NSString *)string;
- (NSString *)description;
- (void)setCodeName:(NSString *)codeName;
- (void)update;
@end

@interface NSString(iTM2MacroKeyStroke)
- (iTM2MacroKeyStroke *)macroKeyStroke;
@end

@interface NSEvent(iTM2MacroKeyStroke)
- (iTM2MacroKeyStroke *)macroKeyStroke;
@end


@interface iTM2KeyBindingLeafNode:iTM2KeyBindingContextNode
- (NSString *)key;
- (void)setKey:(NSString *)key;
- (iTM2MacroKeyStroke *)keyStroke;
- (void)willChangeMacroKeyStroke;
- (void)didChangeMacroKeyStroke;
- (BOOL)isFinal;
@end

@implementation iTM2KeyBindingLeafNode
+ (void)initialize;
{
	[super initialize];
	[self exposeBinding:@"ID2"];
	return;
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
- (NSString *)codeName;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	return macroKeyStroke?macroKeyStroke->codeName:nil;
}
- (BOOL)isShift;
{
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
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	[macroKeyStroke->codeName autorelease];
	macroKeyStroke->codeName = [newCodeName copy];
	[self didChangeMacroKeyStroke];
}
- (void)setIsShift:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isShift = yorn;
	[self didChangeMacroKeyStroke];
}
- (void)setIsFunction:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isFunction = yorn;
	[self didChangeMacroKeyStroke];
}
- (void)setIsControl:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isControl = yorn;
	[self didChangeMacroKeyStroke];
}
- (void)setIsCommand:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isCommand = yorn;
	[self didChangeMacroKeyStroke];
}
- (void)setIsAlternate:(BOOL)yorn;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	if(!macroKeyStroke)
	{
		return;
	}
	[self willChangeMacroKeyStroke];
	macroKeyStroke->isAlternate = yorn;
	[self didChangeMacroKeyStroke];
}
- (NSString *)prettyKey;
{
	return [[self keyStroke] description];
}
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
	[self willChangeMacroKeyStroke];
	[self setValue:nil forKeyPath:@"value.keyStroke"];
	NSXMLElement * element = [self XMLElement];
	[element removeAttributeForName:@"KEY"];
	NSXMLNode * node = [NSXMLNode attributeWithName:@"KEY" stringValue:newKey];
	[element addAttribute:node];
	[self didChangeMacroKeyStroke];
	return;
}
- (void)willChangeMacroKeyStroke;
{
	[self willChangeValueForKey:@"prettyKey"];
	[self willChangeValueForKey:@"codeName"];
	[self willChangeValueForKey:@"isControl"];
	[self willChangeValueForKey:@"isShift"];
	[self willChangeValueForKey:@"isAlternate"];
	[self willChangeValueForKey:@"isCommand"];
	return;
}
- (void)didChangeMacroKeyStroke;
{
	iTM2MacroKeyStroke * macroKeyStroke = [self keyStroke];
	[macroKeyStroke update];
	NSString * newKey = [macroKeyStroke string];
	[self setKey:newKey];
	[self didChangeValueForKey:@"isCommand"];
	[self didChangeValueForKey:@"isAlternate"];
	[self didChangeValueForKey:@"isShift"];
	[self didChangeValueForKey:@"isControl"];
	[self didChangeValueForKey:@"codeName"];
	[self didChangeValueForKey:@"prettyKey"];
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
	iTM2MacroContextNode * node = [self parent];
	NSArray * availableKeys = [node availableKeys];
	if([availableKeys containsObject:newKey])
	{
		iTM2_OUTERROR(4,([NSString stringWithFormat:@"\"%@\" is already a macro Key",newKey]),nil);
		return NO;
	}
	return YES;
}
- (NSString *)ID;
{
	if([self countOfAvailableKeyBindings]>0)
	{
		return @" ";// with @"", the binding does not work
	}
	NSString * ID = [super ID];
	return ID;
}
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
- (BOOL)isActionMutable;
{
	return [self isFinal] && [self isVisible];
}
- (BOOL)isIDMutable;
{
	return [self countOfAvailableKeyBindings]==0;
}
- (BOOL)isFinal;
{
	unsigned I = [self countOfAvailableKeyBindings];
	return I==0;
}
@end

@implementation iTM2KeyBindingContextNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:context forKeyPath:@"value.context"];
		[self addObserver:self
             forKeyPath:@"children" 
                 options:(NSKeyValueObservingOptionNew |
                            NSKeyValueObservingOptionOld)
                    context:NULL];
	}
	return self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	id D = [self valueForKeyPath:@"value.cachedChildrenID"];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		[self setValue:D forKeyPath:@"value.cachedChildrenID"];
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
- (NSXMLElement *)templateXMLElement;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.templateXMLElement"];// cached template?
	if(!element)
	{
		element = [iTM2MacroDocumentManager templateXMLElementOfClient:self];
		[self setValue:element forKeyPath:@"value.templateXMLElement"];// cache
	}
	NSURL * url = [iTM2MacroDocumentManager personalURLOfClient:self];
iTM2_LOG(@"url:%@",url);
	NSXMLDocument * document = [iTM2MacroDocumentManager documentForURL:url client:self];
	NSXMLElement * node = [document rootElement];
	element = [[element copy] autorelease];
	[node addChild:element];
iTM2_LOG(@"XMLDOC:%@",[[element rootDocument] XMLStringWithOptions:NSXMLNodePrettyPrint]);
	return element; 
}
- (NSString *)pathExtension;
{
	return iTM2KeyBindingPathExtension;
}
- (NSArray *)availableKeys;
{
	NSMutableArray * availableKeys = [NSMutableArray array];
	NSArray * keyBindings = [self _X_availableKeyBindings];
	NSEnumerator * E = [keyBindings objectEnumerator];
	id keyBinding;
	id key;
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
- (Class)leafClass;
{
	return [iTM2KeyBindingLeafNode class];
}
- (NSArray *)children;
{
	[iTM2MacroDocumentManager honorURLPromisesOfClient:self];
	return [super children];
}
- (id)objectInChildrenWithKey:(NSString *)key;
{
	[iTM2MacroDocumentManager honorURLPromisesOfClient:self];
	id D = [self valueForKeyPath:@"value.cachedChildrenKeys"];
	if(![D count])
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
	if(!result)
	{
iTM2_LOG(@"D:%@",D);}
	return result;
}
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
	[self setValue:result forKeyPath:@"value.availableKeyBindings"];
//iTM2_END;
    return result;
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
	NSString * key = [object key]?:@"X";
	NSArray * keys = [self availableKeys];
	if([keys containsObject:key])
	{
		// do nothing, this is already there
		return;
	}
	NSArray * mutableXMLElements = [self mutableXMLElements];
	NSXMLElement * myElement = [mutableXMLElements lastObject];
	NSXMLElement * element = nil;
	if(!myElement)
	{
		id parent = [self parent];
		if(![parent isKindOfClass:[iTM2MacroCategoryNode class]])
		{
			// do nothing, this is not mutable
			return;
		}
		element = [self templateXMLElement];
		myElement = [[element rootDocument] rootElement];
		[element detach];
		[self addMutableXMLElement:myElement];
	}
	NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:index];
	[self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
	[object setParent:self];
	[object setKey:key];
	element = [self templateXMLElement];// expected side effect
	if(myElement)
	{
		[element detach];
		[myElement addChild:element];
	}
	[object addMutableXMLElement:element];
//iTM2_LOG(@"XMLDOC:%@",[[element rootDocument] XMLStringWithOptions:NSXMLNodePrettyPrint]);
	[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
	[self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
	keys = [self availableKeys];// updated
	if(![keys containsObject:key])
	{
		iTM2_LOG(@"***  THE KEY WAS NOT ADDED");
	}
	[self setValue:nil forKeyPath:@"value.cachedChildrenKey"];
	iTM2MacroContextNode * macroEditor = [SMC macroEditor];
	NSString * ID = [object ID];
	[SMC willChangeValueForKey:@"macroEditor"];
	[macroEditor willChangeValueForKey:@"availableMacros"];
	id macro = [macroEditor objectInChildrenWithID:ID];
	if(!macro)
	{
		macro = [[[iTM2MacroLeafNode allocWithZone:[macroEditor zone]] init] autorelease];
		NSXMLElement * element = [macroEditor templateXMLElement];
		[macro addMutableXMLElement:element];
		[macro setID:ID];
		[macroEditor insertObject:macro inAvailableMacrosAtIndex:0];
		macro = [macroEditor objectInChildrenWithID:ID];
	}
	[macroEditor setValue:nil forKeyPath:@"value.availableMacros"];
	[macroEditor setValue:nil forKeyPath:@"value.cachedChildrenID"];
	[macroEditor didChangeValueForKey:@"availableMacros"];
	[SMC didChangeValueForKey:@"macroEditor"];
	[SMC performSelector:@selector(synchronizeMacroSelectionWithKeyBindingSelection) withObject:nil afterDelay:0];
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
	if([O isMutable])
	{
		NSIndexSet * indexes = [NSIndexSet indexSetWithIndex:index];
		[self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
		[O removeLastMutableXMLElement];
		if(![O isMutable])
		{
			[O setParent:nil];
		}
		[self setValue:nil forKeyPath:@"value.availableKeyBindings"];
		[self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:@"availableKeyBindings"];
		[self setValue:nil forKeyPath:@"value.cachedChildrenKey"];
	}
//iTM2_END;
    return;
}
- (void)readXMLElement:(NSXMLElement *)element mutable:(BOOL)mutable;
{
	NSArray * children = [element children];
	NSEnumerator * e = [children objectEnumerator];
	while(element = [e nextObject])
	{
		NSXMLNode * node = [element attributeForName:@"KEY"];
		NSString * key = [node stringValue];
		id child = (iTM2MacroLeafNode *)[self objectInChildrenWithKey:key];
		if(child)
		{
			[element detach];
			iTM2_LOG(@"removed element:%@",element);
		}
		else
		{
			child = [[[iTM2KeyBindingLeafNode alloc] initWithParent:self] autorelease];
			[child setKey:key];
			id D = [self valueForKeyPath:@"value.cachedChildrenKeys"];
			[D setObject:child forKey:key];
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
				child = (iTM2MacroLeafNode *)[self objectInChildrenWithKey:key];
				iTM2_LOG(@"child:%@",child);
			}
			[child readXMLElement:element mutable:mutable];
		}
	}
}
@end

#import <iTM2Foundation/iTM2KeyBindingsKit.h>

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
			_string = [[NSString stringWithFormat:@"%@->%@",modifier, codeName] retain];
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
		[result appendString:@" "];
		NSString * localized = [[iTM2KeyCodesController sharedController] localizedNameForCodeName:codeName];
		if([localized length] == 1)
		{
			localized = [localized uppercaseString];
		}
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
	NSMutableArray * components = [[[self componentsSeparatedByString:@"->"] mutableCopy] autorelease];
	NSString * component = [components lastObject];
	iTM2MacroKeyStroke * result = [[[iTM2MacroKeyStroke alloc] initWithCodeName:component] autorelease];
	[components removeLastObject];
	component = [components lastObject];
	unsigned int index = [component length];
	while(index--)
	{
		switch([self characterAtIndex:index])
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
- (iTM2MacroKeyStroke *)macroKeyStroke;
{
	if([self type] != NSKeyDown)
	{
		return nil;
	}
	NSMutableString * completeCodeName = [NSMutableString string];
	unsigned int modifierFlags = [self modifierFlags];
	modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;
	if(modifierFlags&NSShiftKeyMask)
	{
		[completeCodeName appendString:@"$"];
	}
	if(modifierFlags&NSControlKeyMask)
	{
		[completeCodeName appendString:@"^"];
	}
	if(modifierFlags&NSAlternateKeyMask)
	{
		[completeCodeName appendString:@"~"];
	}
	if(modifierFlags&NSCommandKeyMask)
	{
		[completeCodeName appendString:@"@"];
	}
	if(modifierFlags&NSFunctionKeyMask)
	{
		[completeCodeName appendString:@"&"];
	}
	[completeCodeName appendString:@"->"];
	NSString * CIMs = [self charactersIgnoringModifiers];
	if([CIMs length])
	{
		unichar c = [CIMs characterAtIndex:0];
		CIMs = [KCC nameForKeyCode:c];
		[completeCodeName appendString:CIMs];
	}
	return [completeCodeName macroKeyStroke];
}
@end

@interface iTM2KeyBindingOutlineView:NSOutlineView
@end

@implementation iTM2KeyBindingOutlineView
- (void)keyDown:(NSEvent *)theEvent;
{
	if([self numberOfSelectedRows]==1)
	{
		unsigned int modifierFlags = [theEvent modifierFlags];
		modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;
//		if((modifierFlags&NSFunctionKeyMask)==0)
		{
#if 0
			// this does not work
			int selectedRow = [self selectedRow];
			id item = [self itemAtRow:selectedRow];
			iTM2_LOG(@"item:%@",item);
#endif
			// see http://svn.sourceforge.net/viewvc/redshed/trunk/cocoa/NSTableView%2BCocoaBindingsDeleteKey/NSTableView%2BCocoaBindingsDeleteKey.m?view=markup
			NSArray *columns = [self tableColumns];
			unsigned columnIndex = 0, columnCount = [columns count];
			NSDictionary *valueBindingDict = nil;
			for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
				valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
			}
			id treeController = [valueBindingDict objectForKey:NSObservedObjectKey];
			if ([treeController isKindOfClass:[NSTreeController class]]) {
				//	Found a column bound to a tree controller.
				NSArray * selectedObjects = [treeController selectedObjects];
				id selection = [selectedObjects lastObject];
				// first turn the event into a key stroke object
				iTM2MacroKeyStroke * keyStroke = [theEvent macroKeyStroke];
iTM2_LOG(@"keyStroke:%@",keyStroke);
				NSString * key = [keyStroke string];
				// is this key already used?
				NSError * error = nil;
				if([selection validateKey:&key error:&error])
				{
					[selection setKey:key];
				}
				else
				{
					iTM2_LOG(@"error:%@",error);
				}
				return;
			}
#if 0
				NSAlphaShiftKeyMask =		1 << 16,
	 =		1 << 17,
	NSControlKeyMask =		1 << 18,
	NSAlternateKeyMask =		1 << 19,
	NSCommandKeyMask =		1 << 20,
	NSNumericPadKeyMask =		1 << 21,
	NSHelpKeyMask =			1 << 22,
	NSFunctionKeyMask =		1 << 23,
#endif
		}
	}
	[super keyDown:theEvent];
	return;
}
@end

@interface iTM2HumanReadableCodeNameValueTransformer: NSValueTransformer
@end

@implementation iTM2HumanReadableCodeNameValueTransformer: NSValueTransformer
+ (BOOL)allowsReverseTransformation;
{
	return NO;
}
- (id)transformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id transformedValue = [self transformedValue:value];
			[result addObject:(transformedValue?:value)];
		}
		return result;
	}
	return [KCC localizedNameForCodeName:value];
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		return value;
	}
	return [KCC codeNameForLocalizedName:value];
}
@end

@interface _iTM2KeyCodesController: iTM2KeyCodesController
{
	id keyCodesForNames;
	id orderedCodeNames;
}
@end

static id iTM2SharedKeyCodesController = nil;

@implementation iTM2KeyCodesController
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[super initialize];
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableCodeName"])
	{
		iTM2HumanReadableActionNameValueTransformer * transformer = [[[iTM2HumanReadableCodeNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableCodeName"];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
+ (id)sharedController;
{
	return iTM2SharedKeyCodesController?:(iTM2SharedKeyCodesController = [[_iTM2KeyCodesController alloc] init]);
}
- (id)init;
{
	if([self isKindOfClass:[_iTM2KeyCodesController class]])
	{
		return [super init];
	}
	[self dealloc];
	return [[iTM2KeyCodesController sharedController] retain];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	[self dealloc];
	return [[iTM2KeyCodesController sharedController] retain];
}
@end

@implementation _iTM2KeyCodesController
- (id)init;
{
	if(self = [super init])
	{
		keyCodesForNames = [[NSMutableDictionary dictionary] retain];
		NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"iTM2KeyCodes" ofType:@"xml"];
		if([RA count])
		{
			NSString * path = [RA objectAtIndex:0];
			NSURL * url = [NSURL fileURLWithPath:path];
			NSError * localError = nil;
			NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeCompactEmptyElement error:&localError] autorelease];
			if(localError)
			{
				[SDC presentError:localError];
			}
			else
			{
				NSArray * nodes = [doc nodesForXPath:@"/*/KEY" error:&localError];
				if(localError)
				{
					[SDC presentError:localError];
				}
				else
				{
					NSEnumerator * E = [nodes objectEnumerator];
					id node = nil;
					while(node = [E nextObject])
					{
						NSString * KEY = [node stringValue];//case sensitive
						if([KEY length])
						{
							if(node = [node attributeForName:@"CODE"])
							{
								NSString * stringCode = [node stringValue];
								NSScanner * scanner = [NSScanner scannerWithString:stringCode];
								unsigned int code = 0;
								if([scanner scanHexInt:&code])
								{
									NSNumber * codeValue = [NSNumber numberWithUnsignedInt:code];
									[keyCodesForNames setObject:codeValue forKey:KEY];
								}
							}
						}
					}
					iTM2_LOG(@"availableKeyCodes are: %@", keyCodesForNames);
				}
			}
		}
	}
	return self;
}
- (void)dealloc;
{
	[keyCodesForNames release];
	keyCodesForNames = nil;
	[orderedCodeNames release];
	orderedCodeNames = nil;
	[super dealloc];
	return;
}
- (NSArray *)orderedCodeNames;
{
	if(orderedCodeNames)
	{
		return orderedCodeNames;
	}
	NSArray * keyCodes = [keyCodesForNames allValues];
	keyCodes = [keyCodes sortedArrayUsingSelector:@selector(compare:)];
	orderedCodeNames = [NSMutableArray array];
	id code;
	NSEnumerator * E = [keyCodes objectEnumerator];
	while(code = [E nextObject])
	{
		keyCodes = [keyCodesForNames allKeysForObject:code];
		code = [keyCodes lastObject];
		[orderedCodeNames addObject:code];
	}
	return [orderedCodeNames retain];
}
- (unichar)keyCodeForName:(NSString *)name;
{
	NSNumber * N = [keyCodesForNames objectForKey:name];
	if(N)
	{
		return [N unsignedIntValue];
	}
	if([name length])
	{
		return [name characterAtIndex:0];
	}
	return 0;
}
- (NSString *)nameForKeyCode:(unichar) code;
{
	NSNumber * N = [NSNumber numberWithUnsignedInt:code];
	NSArray * keys = [keyCodesForNames allKeysForObject:N];
	if([keys count])
	{
		return [keys lastObject];
	}
	NSString * result = [NSString stringWithCharacters:&code length:1];
	result = [result uppercaseString];// does it work for non ascii chars?
	return result;
}
- (NSString *)localizedNameForCodeName:(NSString *)codeName;
{
	NSString * result = NSLocalizedStringWithDefaultValue(codeName, @"iTM2KeyCodes", [NSBundle bundleForClass:[self class]], @"NO LOCALIZATION", "");
	return [result isEqualToString:@"NO LOCALIZATION"]?codeName:result;
}
- (NSString *)codeNameForLocalizedName:(NSString *)localizedName;
{
	NSEnumerator * E = [orderedCodeNames objectEnumerator];
	NSString * codeName;
	while(codeName = [E nextObject])
	{
		NSString * localized = [self localizedNameForCodeName:codeName];
		if([localized isEqual:localizedName])
		{
			return codeName;
		}
	}
	return localizedName;
}
@end

@implementation iTM2MacroPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"3.Macro";
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willUnselect
- (void)willUnselect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super willUnselect];
    return;
}
#endif
@end
