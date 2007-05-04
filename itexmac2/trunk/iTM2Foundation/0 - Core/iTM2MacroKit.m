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

NSString * const iTM2TextPlaceholderMark = @"@@@";

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

NSString * const iTM2MacroControllerComponent = @"Macros.localized";
NSString * const iTM2MacroScriptsComponent = @"Scripts.localized";
NSString * const iTM2MacroPersonalComponent = @"Personal";
NSString * const iTM2MacroServerSummaryComponent = @"Summary";
NSString * const iTM2MacroTemplateComponent = @"Template";
NSString * const iTM2MacrosDirectoryName = @"Macros";
NSString * const iTM2MacroPathExtension = @"iTM2-macros";
NSString * const iTM2MacroMenuPathExtension = @"iTM2-menu";

NSString * const iTM2KeyBindingPathExtension = @"iTM2-key-bindings";

static NSArray * _iTM2MacroTypes = nil;

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
		NSXMLElement * rootElement = [document rootElement];
		NSXMLElement * node = rootElement;
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
			while([rootElement childCount])
			{
				[rootElement removeChildAtIndex:0];
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
	NSXMLElement * element = [iTM2MacroDocumentManager templateXMLElementOfClient:self];// expected side effect
	NSURL * url = [iTM2MacroDocumentManager personalURLOfClient:self];
	NSXMLDocument * document = [iTM2MacroDocumentManager documentForURL:url client:self];
	NSXMLElement * rootElement = [document rootElement];
	[rootElement addChild:element];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableScripts
- (NSArray *)_X_availableScripts;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [self valueForKeyPath:@"value.availableScripts"];
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	id parent = [self parent];
	NSString * category = [parent valueForKeyPath:@"value.category"];
	parent = [parent parent];
	NSString * subpath = [parent valueForKeyPath:@"value.domain"];
	subpath = [subpath stringByAppendingPathComponent:category];
	subpath = [subpath stringByAppendingPathComponent:iTM2MacroScriptsComponent];
	NSBundle * MB = [NSBundle mainBundle];
	NSArray * RA = [MB allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		if([DFM pushDirectory:path])
		{
			if([DFM pushDirectory:subpath])
			{
				NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:@"."];
				while(path = [DE nextObject])
				{
					BOOL flag;
					if([path hasPrefix:@"."])
					{
						// do nothing, this is a hidden file
					}
					else
					{
						
						if([path hasPrefix:@"."])// missing finder test (kIsVisibleFlag?)
						{
							// do nothing, this is a hidden file here too
						}
						else if([DFM fileExistsAtPath:path isDirectory:&flag] && flag)
						{
							// do nothing, this is a directory
						}
						else
						{
							[result addObject:path];
						}
					}
				}
				[DFM popDirectory];
			}
			else if([DFM fileExistsAtPath:subpath isDirectory:nil])
			{
				iTM2_LOG(@"*** SILENT Error: could not push \"%@/%@\"",[DFM currentDirectoryPath],subpath);
			}
			[DFM popDirectory];
		}
		else
		{
			iTM2_LOG(@"*** SILENT Error: could not push \"%@\"",path);
		}
	}
	[result sortUsingSelector:@selector(compare:)];
	[self setValue:result forKeyPath:@"value.availableScripts"];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfAvailableScripts
- (unsigned int)countOfAvailableScripts;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableScripts] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableScriptsAtIndex:
- (id)objectInAvailableScriptsAtIndex:(int) index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableScripts] objectAtIndex:index];
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
- (id)copyWithZone:(NSZone *)aZone;
{
	id clone = [[[[self class] allocWithZone:aZone] init] autorelease];
	NSXMLElement * element = [self XMLElement];
	element = [element copy];
	[element detach];
	[clone addMutableXMLElement:element];
	return clone;
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
	if(![self isVisible])
	{
		return;
	}
	NSXMLElement * element = [self XMLElement];
	NSXMLNode * node;
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
	NSString * oldActionName = [self actionName];
	if([oldActionName isEqual:newActionName])
	{
		return;
	}
	[self willChangeValueForKey:@"macroTabViewItemIdentifier"];
	[self willChangeValueForKey:@"actionName"];
	[element removeAttributeForName:@"SEL"];
	if([@"insertMacro:" isEqual:newActionName] || [@"noop:" isEqual:newActionName] || ![newActionName length])
	{
		;//do nothing
	}
	else
	{
		node = [NSXMLNode attributeWithName:@"SEL" stringValue:newActionName];
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
	if(![newArgument length])
	{
		[node detach];
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
	[self willChangeValueForKey:@"isMutable"];
	NSMutableArray * mutableXMLElements = [self mutableXMLElements];
	[mutableXMLElements addObject:element];
	[self didChangeValueForKey:@"isMutable"];
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
	[self willChangeValueForKey:@"isMutable"];
	NSMutableArray * mutableXMLElements = [self mutableXMLElements];
	NSXMLElement * element = [mutableXMLElements lastObject];
	[element detach];
	[mutableXMLElements removeLastObject];
	[self didChangeValueForKey:@"isMutable"];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithTarget:selector:substitutions:
- (BOOL)executeMacroWithTarget:(id)target selector:(SEL)action substitutions:(NSDictionary *)substitutions;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!target)
	{
		target = [[NSApp keyWindow] firstResponder];
	}
	BOOL result = NO;
	NSMethodSignature * MS = nil;
	if(action && (MS = [target methodSignatureForSelector:action]))
	{
here:
		if(substitutions)
		{
			[self setValue:substitutions forKeyPath:@"value.substitutions"];
		}
		if([MS numberOfArguments] == 3)
		{
			NS_DURING
			[target performSelector:action withObject:self];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if([MS numberOfArguments] == 2)
		{
			NS_DURING
			[target performSelector:action];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if(MS)
		{
		}
		else if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:self]
			|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:self])
		{
			result = YES;
		}
		else
		{
			iTM2_LOG(@"No target for %@ with argument:%@", NSStringFromSelector(action),self);
		}
		[self setValue:nil forKeyPath:@"value.substitutions"];
//iTM2_END;
		return result;
	}
	if([self isKindOfClass:[iTM2MacroLeafNode class]]
		&& (action = [self action])
			&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if((action = NSSelectorFromString([self ID]))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if((action = NSSelectorFromString(@"insertMacro:"))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
//iTM2_END;
	return NO;
}
@end

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@interface iTM2HumanReadableActionNameValueTransformer: NSValueTransformer
+ (NSArray *)actionNames;
@end

static id iTM2HumanReadableActionNames = nil;
@implementation iTM2HumanReadableActionNameValueTransformer: NSValueTransformer
+ (void)initialize;
{
	[super initialize];
	if(!iTM2HumanReadableActionNames)
	{
		iTM2HumanReadableActionNames = [[NSMutableDictionary dictionary] retain];
		NSBundle * MB = [NSBundle mainBundle];
		NSArray * RA = [MB allPathsForResource:@"iTM2HumanReadableActionNames" ofType:@"plist"];
		NSEnumerator * E = [RA objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
			NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
			if(D)
			{
				[iTM2HumanReadableActionNames addEntriesFromDictionary:D];
			}
		}
	}
	return;
}
+ (NSArray *)actionNames;
{
	return [iTM2HumanReadableActionNames allKeys];
}
+ (BOOL)allowsReverseTransformation;
{
	return YES;
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
	id result = [iTM2HumanReadableActionNames objectForKey:value];
	return result?:value;
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id reverseTransformedValue = [self reverseTransformedValue:value];
			[result addObject:(reverseTransformedValue?:value)];
		}
		return result;
	}
	id result = [iTM2HumanReadableActionNames allKeysForObject:value];
	return [result lastObject]?:value;
}
@end

@implementation iTM2MacroController(actionNames)
- (NSArray *)availableActionNames;
{
	return [iTM2HumanReadableActionNameValueTransformer actionNames];
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
	if(!_iTM2MacroTypes)
	{
		_iTM2MacroTypes = [[NSArray arrayWithObjects:
			@"ACTION",@"PATH",@"COMMAND",@"COPY",@"MATH",
			@"INPUT_PATH",@"INPUT_ALL",@"INPUT_SELECTION",@"INPUT_LINE",//unused?
			@"PERL_INPUT_ALL",@"PERL_INPUT_SELECTION",@"PERL_INPUT_LINE",
			@"PERL_REPLACE_SELECTION",@"PERL_REPLACE_LINE",@"PERL_REPLACE_ALL",
			@"RUBY_INPUT_ALL",@"RUBY_INPUT_SELECTION",@"RUBY_INPUT_LINE",
			@"RUBY_REPLACE_SELECTION",@"RUBY_REPLACE_LINE",@"RUBY_REPLACE_ALL",
			@"PREPEND_SELECTION",@"SELECTION",@"REPLACE_SELECTION",@"APPEND_SELECTION",
			@"PREPEND_LINE",@"REPLACE_LINE",@"LINE",@"APPEND_LINE",
			@"PREPEND_ALL",@"REPLACE_ALL",@"ALL",@"APPEND_ALL",nil] retain];
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
- (id)testView;
{
	return metaGETTER;
}
- (void)setTestView:(id)argument;
{
	metaSETTER(argument);
	return;
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
		leafNode = [[[iTM2MacroLeafNode alloc] init] autorelease];
		NSXMLElement * element = [NSXMLElement elementWithName:@"ACTION"];
		[leafNode addMutableXMLElement:element];
		[leafNode setID:ID];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"No macro with ID: %@ forContext:%@ ofCategory:%@ inDomain:%@",ID,context,category,domain);
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
			if([SMC executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain target:nil])
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithText:forContext:ofCategory:inDomain:target:
- (BOOL)executeMacroWithText:(NSString *)text forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain target:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned idx = 0;
	BOOL result = NO;
	while(idx<[text length])
	{
		NSString * type = nil;
		NSRange range = [text rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:YES];
		if(!range.length)
		{
			return NO;
		}
		else if(type)
		{
			NSRange fullRange = [text rangeOfPlaceholderAtIndex:range.location getType:nil ignoreComment:YES];
			if(fullRange.location == range.location && fullRange.length > range.length)
			{
				fullRange.length = NSMaxRange(fullRange);
				fullRange.location = NSMaxRange(range);
				if(fullRange.length>fullRange.location)
				{
					fullRange.length-=fullRange.location;
					if(fullRange.length>4)
					{
						fullRange.length-=4;
						text = [text substringWithRange:fullRange];
						iTM2MacroLeafNode * leafNode = [self macroRunningNodeForID:text context:context ofCategory:category inDomain:domain];
						SEL action = NULL;
						NSString * actionName = [NSString stringWithFormat:@"insertMacro_%@:",type];
						action = NSSelectorFromString(actionName);
						result = result || [leafNode executeMacroWithTarget:target selector:action substitutions:nil];
					}
				}
			}
		}
		idx = NSMaxRange(range);
	}

//iTM2_START;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithID:forContext:ofCategory:inDomain:target:
- (BOOL)executeMacroWithID:(NSString *)ID forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain target:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MacroLeafNode * leafNode = [self macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
	BOOL result = [leafNode executeMacroWithTarget:target selector:NULL substitutions:nil];
//iTM2_END;
    return result;
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
	// did the argument text view saved its content?
	NSWindow * W = [sender window];
	NSResponder * firstResponder = [W firstResponder];
	[W makeFirstResponder:nil]; 
	id node = [self macroTree];
	[self applyForNode:node];
	node = [self keyBindingTree];
	[self applyForNode:node];
	[W makeFirstResponder:firstResponder]; 
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
	if(!node)
	{
		return;
	}
	id parent = [node parent];
	id D = [parent valueForKeyPath:@"value.cachedChildrenIDs"];
	[D removeObjectForKey:oldID];
	[D setObject:node forKey:newID];
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
	NSString * result = @"";
	NSString * key = [self macroDomainKey];
	if([key length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
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
	}
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
	NSString * result = @"";
	NSString * key = [self macroCategoryKey];
	if([key length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
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
	}
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
	NSString * result = @"";
	NSString * key = [self macroContextKey];
	if([key length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
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
	}
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
	return [SMC executeMacroWithID:macro forContext:macroContext ofCategory:macroCategory inDomain:macroDomain target:self];
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
#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>
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
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:0 cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
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
	NSString * replacement = @"";
	if(selectedRange.length>8)
	{
		selectedRange.location += 4;
		selectedRange.length -= 8;
		replacement = [S substringWithRange:selectedRange];
	}
	[self insertText:replacement];
	firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length)
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
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
	NSRange actualPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	unsigned idx = NSMaxRange(selectedRange);
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:idx cycle:YES tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length==0)
	{
//iTM2_LOG(@"firstPlaceholderRange:%@",NSStringFromRange(firstPlaceholderRange));
		return;
	}
	// if it is already selected, remove, replace it
	if(!NSEqualRanges(selectedRange,actualPlaceholderRange))
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:firstPlaceholderRange];
		return;
	}
	NSString * replacement = @"";
	if(selectedRange.length>8)
	{
		selectedRange.location+=4;
		selectedRange.length -= 8;
		replacement = [S substringWithRange:selectedRange];
	}
	[self insertText:replacement];
	firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length)
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
	}
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
	NSRange firstPlaceholderRange = [S rangeOfPreviousPlaceholderBeforeIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor ignoreComment:YES];
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
	NSString * replacement = @"";
	if(selectedRange.length>8)
	{
		selectedRange.location+=4;
		selectedRange.length -= 8;
		replacement = [S substringWithRange:selectedRange];
	}
	[self insertText:replacement];
	firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length)
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
	}
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
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_APPEND_ALL:
- (void)insertMacro_APPEND_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(0,0);
	range.location = [[self string] length];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_REPLACE_ALL:
- (void)insertMacro_REPLACE_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(0,0);
	range.length = [[self string] length];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_PREPEND_ALL:
- (void)insertMacro_PREPEND_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(0,0);
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_APPEND_SELECTION:
- (void)insertMacro_APPEND_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.location = NSMaxRange(range);
	range.length = 0;
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_REPLACE_SELECTION:
- (void)insertMacro_REPLACE_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self insertMacro:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_PREPEND_SELECTION:
- (void)insertMacro_PREPEND_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_PREPEND_LINE:
- (void)insertMacro_PREPEND_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
	NSTextStorage * TS = [self textStorage];
	[TS getLineStart:&range.location end:nil contentsEnd:nil forRange:range];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_REPLACE_LINE:
- (void)insertMacro_REPLACE_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
	NSTextStorage * TS = [self textStorage];
	[TS getLineStart:&range.location end:&range.length contentsEnd:nil forRange:range];
	range.length -= range.location;
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_APPEND_LINE:
- (void)insertMacro_APPEND_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
	NSTextStorage * TS = [self textStorage];
	[TS getLineStart:nil end:nil contentsEnd:&range.location forRange:range];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_COPY:
- (void)insertMacro_COPY:(id)argument;
/*"Description forthcoming. .
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(NSNotFound,0);
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroByPreparing:forInsertionInRange:
- (NSString *)macroByPreparing:(NSString *)macro forInsertionInRange:(NSRange)affectedCharRange;
/*"The purpose is to return a macro with the proper indentation.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * MRA = [NSMutableArray array];
	NSArray * components = [macro lineComponents];
	NSEnumerator * E = [components objectEnumerator];
	NSString * S = [self string];
	unsigned numberOfSpacesPerTab = [self numberOfSpacesPerTab];
	unsigned indentationLevel = [S indentationLevelAtIndex:affectedCharRange.location withNumberOfSpacesPerTab:numberOfSpacesPerTab];
	unsigned currentIndentationLevel = 0, localIndentationLevel = 0;
	NSRange range;
	range.location = 27;
	NSString * line;
	if(line = [E nextObject])
	{
		[MRA addObject:line];//no indentation on the first line
		while(line = [E nextObject])
		{
			if([line hasPrefix:@"__iTM2_INDENTATION_PREFIX__"])
			{
				range.length = [line length]-range.location;
				line = [line substringWithRange:range];
				if(currentIndentationLevel)
				{
					localIndentationLevel = currentIndentationLevel + [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
					line = [line stringWithIndentationLevel:localIndentationLevel atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
				}
			}
			else
			{
				currentIndentationLevel = indentationLevel + [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
				line = [line stringWithIndentationLevel:currentIndentationLevel atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
			}
			[MRA addObject:line];
		}
		macro = [MRA componentsJoinedByString:@""];
	}
	NSMutableString * replacement = [NSMutableString stringWithString:macro];
	unsigned index;
	if(index = [replacement length])
	{
		NSString * tabAnchor = [self tabAnchor];
		range = [replacement rangeOfPreviousPlaceholderBeforeIndex:index cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
		if(range.length)
		{
			if(NSMaxRange(range)<index)
			{
				[replacement appendString:@"@@@()@@@"];
			}
		}
	}
//iTM2_END;
    return replacement;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preparedSelectedLineForMacroInsertion
- (NSString *)preparedSelectedLineForMacroInsertion;
/*"The purpose is to return a prepared selected string: indentation is managed here.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange selectedRange = [self selectedRange];
	NSString * S = [self string];
	[S getLineStart:&selectedRange.location end:&selectedRange.length contentsEnd:nil forRange:selectedRange];
	selectedRange.length -= selectedRange.location;
	NSString * selectedString = [S substringWithRange:selectedRange];
//iTM2_END;
    return selectedString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preparedSelectedStringForMacroInsertion
- (NSString *)preparedSelectedStringForMacroInsertion;
/*"The purpose is to return a prepared selected string: indentation is managed here.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange selectedRange = [self selectedRange];
	NSString * S = [self string];
	NSString * selectedString = [S substringWithRange:selectedRange];
	unsigned numberOfSpacesPerTab = [self numberOfSpacesPerTab];
	selectedString = [selectedString stringByNormalizingIndentationWithNumberOfSpacesPerTab:numberOfSpacesPerTab];
	NSArray * components = [selectedString lineComponents];
	NSMutableArray * MRA = [NSMutableArray array];
	NSEnumerator * E = [components objectEnumerator];
	unsigned lineIndentation = 0;
	// selected range used!
	unsigned indentation = [S indentationLevelAtIndex:selectedRange.location withNumberOfSpacesPerTab:numberOfSpacesPerTab];
	NSString * line;
	while(line = [E nextObject])
	{
		lineIndentation = [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		if(lineIndentation>indentation)
		{
			lineIndentation-=indentation;
			line = [line stringWithIndentationLevel:lineIndentation atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		}
		[MRA addObject:line];
	}
	selectedString = [MRA componentsJoinedByString:@"__iTM2_INDENTATION_PREFIX__"];
//iTM2_END;
    return selectedString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForMacro:selection:line:
- (NSString *)concreteReplacementStringForMacro:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
/*"The purpose is to translate some keywords into the value they represent.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * replacementString = [NSMutableString string];
	NSString * all = [self string];
	NSString * path = [[[[self window]windowController]document]fileName];
	BOOL PERL = NO;
	BOOL RUBY = NO;
	NSString * startType = nil;
	NSString * stopType = nil;
	NSString * copyString = nil;
	NSRange startRange = NSMakeRange(0,0);
	NSRange stopRange = NSMakeRange(0,0);
	NSRange copyRange = NSMakeRange(0,0);
	NSString * perlEscapedSelection = nil;
	NSString * perlEscapedLine = nil;
	NSString * perlEscapedAll = nil;
	NSString * perlEscapedPath = nil;
nextRange:
	startRange = [macro rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&startType ignoreComment:YES];
	if(startRange.length)
	{
		copyRange.location = NSMaxRange(stopRange);
		copyRange.length = startRange.location - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
nextStopRange:
		copyRange.location = NSMaxRange(startRange);
		stopRange = [macro rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&stopType ignoreComment:YES];
		if(stopRange.length)
		{
			if(!startType)
			{
				// the startRange was in fact a stop placeholder mark range
				copyRange = startRange;
				copyRange.length = NSMaxRange(stopRange) - copyRange.location;
				copyString = [macro substringWithRange:copyRange];
				[replacementString appendString:copyString];
				// go for a next pair start+stop
				copyRange.location = NSMaxRange(stopRange);
				goto nextRange;
			}
			else if(!stopType)
			{
				if([startType isEqual:@"SELECTION"] || [startType isEqual:@"MATH"])
				{
					if([selection length])
					{
						[replacementString appendString:@"@@@("];
						[replacementString appendString:selection];
						[replacementString appendString:@")@@@"];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							[replacementString appendString:@"@@@("];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:@")@@@"];
						}
					}
				}
				else if([startType isEqual:@"INPUT_SELECTION"])
				{
					if([selection length])
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if([startType isEqual:@"PERL_INPUT_SELECTION"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_SELECTION= <<__END_OF_INPUT__;\n"];
					if(perlEscapedSelection)
					{
						[replacementString appendString:perlEscapedSelection];
					}
					else if([selection length])
					{
						perlEscapedSelection = [selection stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedSelection];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_SELECTION =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_SELECTION=\"$1\";"];
				}
				else if([startType isEqual:@"PERL_INPUT_LINE"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_LINE= <<__END_OF_INPUT__;\n"];
					if(perlEscapedLine)
					{
						[replacementString appendString:perlEscapedLine];
					}
					else if([line length])
					{
						perlEscapedLine = [line stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedLine];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_LINE =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_LINE=\"$1\";"];
				}
				else if([startType isEqual:@"PERL_INPUT_ALL"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_ALL= <<__END_OF_INPUT__;\n"];
					if(perlEscapedAll)
					{
						[replacementString appendString:perlEscapedAll];
					}
					else if([all length])
					{
						perlEscapedAll = [all stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedAll];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_ALL =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_ALL=\"$1\";"];
				}
				else if([startType isEqual:@"PERL_INPUT_PATH"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_PATH= <<__END_OF_INPUT__;\n"];
					if(perlEscapedPath)
					{
						[replacementString appendString:perlEscapedPath];
					}
					else if([path length])
					{
						perlEscapedPath = [path stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedPath];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_PATH =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_PATH=\"$1\";"];
				}
				else if([startType isEqual:@"RUBY_INPUT_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_SELECTION = <<'__END_OF_INPUT__'\n"];
					if([selection length])
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_SELECTION.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"RUBY_INPUT_LINE"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_LINE = <<'__END_OF_INPUT__'\n"];
					if([line length])
					{
						[replacementString appendString:line];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_LINE.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"RUBY_INPUT_ALL"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_ALL= <<'__END_OF_INPUT__'\n"];
					if([all length])
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							//copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_ALL.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"RUBY_INPUT_PATH"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_PATH= <<'__END_OF_INPUT__'\n"];
					if([path length])
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_PATH.gsub!(&/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"ALL"])
				{
					if([all length])
					{
						[replacementString appendString:@"@@@("];
						[replacementString appendString:all];
						[replacementString appendString:@")@@@"];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							[replacementString appendString:@"@@@("];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:@")@@@"];
						}
					}
				}
				else if([startType isEqual:@"INPUT_ALL"])
				{
					if([all length])
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if([startType isEqual:@"INPUT_PATH"])
				{
					if([path length])
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if([startType isEqual:@"PERL_REPLACE_ALL"])
				{
					PERL = YES;
					[replacementString appendString:@"print \"@@@(REPLACE_ALL:$INPUT_ALL)@@@\";\n"];
				}
				else if([startType isEqual:@"PERL_REPLACE_SELECTION"])
				{
					PERL = YES;
					[replacementString appendString:@"print \"@@@(REPLACE_SELECTION:$INPUT_SELECTION)@@@\";\n"];
				}
				else if([startType isEqual:@"PERL_REPLACE_LINE"])
				{
					PERL = YES;
					[replacementString appendString:@"print \"@@@(REPLACE_SELECTION:$INPUT_LINE)@@@\";\n"];
				}
				else if([startType isEqual:@"RUBY_REPLACE_ALL"])
				{
					RUBY = YES;
					[replacementString appendString:@"puts \"@@@(REPLACE_ALL:#{INPUT_ALL})@@@\"\n"];
				}
				else if([startType isEqual:@"RUBY_REPLACE_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendString:@"puts \"@@@(REPLACE_SELECTION:#{INPUT_SELECTION})@@@\""];
				}
				else if([startType isEqual:@"RUBY_REPLACE_LINE"])
				{
					RUBY = YES;
					[replacementString appendString:@"puts \"@@@(REPLACE_LINE:#{INPUT_LINE})@@@\";\n"];
				}
				#if 0
				else if([startType isEqual:@"COMMAND"])// unused
				{
					if([selection length])
					{
						[replacementString appendString:@"@@@("];
						[replacementString appendString:selection];
						[replacementString appendString:@")@@@"];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							[replacementString appendString:@"@@@("];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:@")@@@"];
						}
					}
				}
				#endif
				else
				{
					// the startRange was not a selection placeholder
					// we should add there other goodies
					copyRange.location = startRange.location;
					copyRange.length = stopRange.location - copyRange.location;
					copyRange.length += stopRange.length;
					copyString = [macro substringWithRange:copyRange];
					[replacementString appendString:copyString];
				}
				copyRange.location = NSMaxRange(stopRange);
				goto nextRange;
			}
			else
			{
				// stopType is in fact a start placeholder
				// 
				copyRange = startRange;
				copyRange.length = stopRange.location - startRange.location;
				copyString = [macro substringWithRange:copyRange];
				[replacementString appendString:copyString];
				startType = stopType;
				startRange = stopRange;
				copyRange.location = NSMaxRange(stopRange);
				goto nextStopRange;
			}
		}
		else
		{
			copyRange = startRange;
			copyRange.length = [macro length] - startRange.location;
			copyString = [macro substringWithRange:copyRange];
			[replacementString appendString:copyString];
		}
	}
	else
	{
		copyRange.length = [macro length] - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
	}
	// manage the indentation
	if(PERL)
	{
		if(![replacementString hasPrefix:@"#!/usr/bin/env perl"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/perl"])
		{
			[replacementString insertString:@"#!/usr/bin/env perl -w\n" atIndex:0];
		}
	}
	else if(RUBY)
	{
		if(![replacementString hasPrefix:@"#!/usr/bin/env ruby"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/ruby"])
		{
			[replacementString insertString:@"#!/usr/bin/env ruby\n" atIndex:0];
		}
	}
//iTM2_END;
	return replacementString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replacementStringForMacro:selection:line:
- (NSString *)replacementStringForMacro:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * replacementString = nil;
	NSString * category = [self macroCategory];
	if([category length])
	{
		NSString * action = [NSString stringWithFormat:@"concreteReplacementStringFor%@Macro:selection:line:",category];
		SEL selector = NSSelectorFromString(action);
		NSMethodSignature * MS = [self methodSignatureForSelector:selector];
		SEL mySelector = @selector(concreteReplacementStringForMacro:selection:line:);
		NSMethodSignature * myMS = [self methodSignatureForSelector:mySelector];
		if(![MS isEqual:myMS])
		{
			MS = myMS;
			selector = mySelector;
		}
		NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
		[I setTarget:self];
		[I setArgument:&macro atIndex:2];
		[I setArgument:&selection atIndex:3];
		[I setArgument:&line atIndex:4];
		[I setSelector:selector];
		NS_DURING
		[I invoke];
		[I getReturnValue:&replacementString];
		NS_HANDLER
		iTM2_LOG(@"EXCEPTION Catched: %@", localException);
		replacementString = @"";
		NS_ENDHANDLER
	}
	else
	{
		replacementString = [self concreteReplacementStringForMacro:macro selection:selection line:line];
	}
//iTM2_END;
    return replacementString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:inRange:
- (void)insertMacro:(id)argument inRange:(NSRange)affectedCharRange;
/*"Description forthcoming.
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
		NSString * selection = [self preparedSelectedStringForMacroInsertion];
		NSString * line = [self preparedSelectedLineForMacroInsertion];
		NSString * replacementString = [self replacementStringForMacro:argument selection:selection line:line];		
		if([self contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextPrivateMask|iTM2ContextExtendedMask])
		{
			replacementString = [replacementString stringByRemovingPlaceholderMarks];
		}
		if(affectedCharRange.location == NSNotFound)
		{
			NSPasteboard * PB = [NSPasteboard generalPasteboard];
			NSArray * newTypes = [NSArray arrayWithObject:NSStringPboardType];
			[PB declareTypes:newTypes owner:nil];
			[PB setString:replacementString forType:NSStringPboardType];
		}
		else
		{
			replacementString = [self macroByPreparing:replacementString forInsertionInRange:affectedCharRange];
			if([self shouldChangeTextInRange:affectedCharRange replacementString:replacementString])
			{
				[self replaceCharactersInRange:affectedCharRange withString:replacementString];
				[self didChangeText];
				[self selectFirstPlaceholder:self];
			}
		}
		return;
	}
	if([argument isKindOfClass:[NSArray class]])
	{
		NSEnumerator * E = [argument objectEnumerator];
		while(argument = [E nextObject])
		{
			[self insertMacro:argument inRange:affectedCharRange];
		}
	}
	if([argument isKindOfClass:[iTM2MacroLeafNode class]])
	{
		argument = [argument concreteArgument];
		[self insertMacro:argument inRange:affectedCharRange];
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

#import <iTM2Foundation/iTM2StringKit.h>

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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfMacroTypeAtIndex:
- (NSRange)rangeOfMacroTypeAtIndex:(unsigned int)index;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(index<[self length])
	{
		NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"];
		NSRange result = NSMakeRange(index, 0);
		if([set characterIsMember:[self characterAtIndex:index]])
		{
			++result.length;
			while((++index<[self length]) && [set characterIsMember:[self characterAtIndex:index]])
				++result.length;
			index = result.location;
			while(index-- && [set characterIsMember:[self characterAtIndex:index]])
				++result.length, --result.location;
		}
		return result;
	}
	return NSMakeRange(NSNotFound, 0);
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
	unsigned length = [self length];
	NSMutableString * result = [NSMutableString stringWithCapacity:length];
	NSRange markRange;
	NSRange copyRange = NSMakeRange(0,0);
	NSString * S;
next:
	markRange = [self rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:nil ignoreComment:YES];
	if(markRange.length)
	{
		copyRange.length = markRange.location - copyRange.location;
		S = [self substringWithRange:copyRange];
		[result appendString:S];
		copyRange.location = NSMaxRange(markRange);
		if(copyRange.location<length)
		{
			goto next;
		}
	}
	copyRange.length = length - copyRange.location;
	S = [self substringWithRange:copyRange];
	[result appendString:S];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderMarkAfterIndex:getType:ignoreComment:
- (NSRange)rangeOfNextPlaceholderMarkAfterIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;
/*"Description forthcoming. The returned range correspondes to a placeholder mark,
either '@@@(TYPE/? or ')@@@'.
If the placeholder is @@@(TYPE)@@@, TYPE belongs to the start placeholder mark
TYPE length is one word.
For ")@@@@(", the leading ")@@@" is considered the valid placeholder mark. The trailing "@(" has no special meaning.
the character index of the fist '@' for an opening mark and the ')' for a closing mark is greater than index.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	if(index>=length)
	{
		return NSMakeRange(NSNotFound,0);
	}
	NSRange searchRange,markRange,wordRange;
	searchRange.location = index;
	searchRange.length = length - searchRange.location;
	markRange = [self rangeOfString:@"@@@" options:nil range:searchRange];
	if(!markRange.length)
	{
		return NSMakeRange(NSNotFound,0);
	}
	// There might be a problem if the "@@@" found belongs to a bigger ")@@@@..."
	// for which the placeholder mark starts strictly before index
	unichar theChar;
	if(markRange.location == searchRange.location)
	{
		if(markRange.location>2)
		{
			theChar = [self characterAtIndex:markRange.location-3];
			if(theChar == ')')
			{
				theChar = [self characterAtIndex:markRange.location-2];
				if(theChar == '@')
				{
					theChar = [self characterAtIndex:markRange.location-1];
					if(theChar == '@')
					{
						// this is not the right stuff
						searchRange.location = markRange.location+1;
nextMark:
						searchRange.length = length - searchRange.location;
						markRange = [self rangeOfString:@"@@@" options:nil range:searchRange];
						if(!markRange.length)
						{
							return NSMakeRange(NSNotFound,0);
						}
noProblemo:
						if(markRange.location)
						{
							theChar = [self characterAtIndex:markRange.location-1];
							if(theChar == ')')
							{
								--markRange.location;
								++markRange.length;
								if(typeRef)
								{
									*typeRef = nil;
								}
								return markRange;
							}
						}
nextChar:		
						searchRange.location = NSMaxRange(markRange);
						if(searchRange.location<length)
						{
							theChar = [self characterAtIndex:searchRange.location];
							if(theChar == '(')
							{
								++markRange.length;
								index = NSMaxRange(markRange);
								NSString * type = @"";
								if(index<length)
								{
									wordRange = [self rangeOfMacroTypeAtIndex:index];
									type = [self substringWithRange:wordRange];
									if([_iTM2MacroTypes containsObject:type])
									{
										markRange.length += wordRange.length;
										index = NSMaxRange(markRange);
										if((index<length) && ([self characterAtIndex:index] != ')'))
										{
											++markRange.length;
										}
									}
									else
									{
										type = @"";
									}
								}
								if(typeRef)
								{
									*typeRef = [type uppercaseString];
								}
								return markRange;
							}
							if(theChar == '@')
							{
								++markRange.location;
								goto nextChar;
							}
							goto nextMark;
						}
						// else we reached the end of the string: no room for a '(' character
						return NSMakeRange(NSNotFound,0);
					}
					else if(theChar == ')')
					{
						// this is a stop placeholder starting just before
						searchRange.location = markRange.location+3;
						goto nextMark;
					}
					else
					{
						// this is not a stop placeholder mark
						goto nextChar;
					}
					// unreachable point
twoCharsBefore:
					theChar = [self characterAtIndex:markRange.location-2];
				}
				if(theChar == ')')
				{
					theChar = [self characterAtIndex:markRange.location-1];
					if(theChar == '@')
					{
						// this is not the right stuff
						searchRange.location = markRange.location+2;
						goto nextMark;
					}
				}
				else
				{
oneCharBefore:
					theChar = [self characterAtIndex:markRange.location-1];
				}
				if(theChar == ')')
				{
					searchRange.location = markRange.location+3;
					goto nextMark;
				}
				// this is not a stop placeholder mark
				goto nextChar;
			}
			goto twoCharsBefore;
		}
		if(markRange.location>1)
		{
			goto twoCharsBefore;
		}
		if(markRange.location)
		{
			goto oneCharBefore;
		}
	}
	goto noProblemo;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderMarkBeforeIndex:getType:ignoreComment:
- (NSRange)rangeOfPreviousPlaceholderMarkBeforeIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;
/*"Description forthcoming. The location of the returned range is before index, when the range is not void
This will catch a marker starting before index
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// the placeholder start marker is "@@@(word"
	// there can be a problem if "(word" contains index
	// we make too much test but it leads to simpler code
	// the only weird situation is for ')@@@' when ')' is exactly at index, and unescaped... but this is another story
	unsigned length = [self length];
	if(length<4)
	{
		return NSMakeRange(NSNotFound,0);
	}
	unichar theChar = 0;
	NSRange markRange;
	if(index<UINT_MAX-3 && index+3<length)
	{
		theChar = [self characterAtIndex:index];
		if(theChar == ')')
		{
			theChar = [self characterAtIndex:index+1];
			if(theChar == '@')
			{
				theChar = [self characterAtIndex:index+2];
				if(theChar == '@')
				{
					theChar = [self characterAtIndex:index+3];
					if(theChar == '@')
					{
						markRange = NSMakeRange(index,4);
						if(typeRef)
						{
							*typeRef = nil;
						}
						return markRange;
					}
				}
			}
		}
	}
	NSString * type = nil;
	unsigned end,start;
	index = MIN(index,UINT_MAX-2);
	end = MIN(length-1,index+2);
previousEnd:
	theChar = [self characterAtIndex:end];
	if(theChar=='@')
	{
		NSRange wordRange;
		start = end;
previousStart:
		if(start)
		{
			theChar = [self characterAtIndex:start-1];
			if(theChar=='@')
			{
				--start;
				goto previousStart;
			}
			else if(theChar==')')
			{
				if(end>start+4)
				{
					if(end+1<length)
					{
						// there is room for a start placeholder mark after the stop mark
						theChar = [self characterAtIndex:++end];
						if(theChar == '(')
						{
							// this is a start placeholder delimiter
							start = end - 3;
							type = @"";
							if(++end<length)
							{
								wordRange = [self rangeOfMacroTypeAtIndex:end];
								if(wordRange.length)
								{
									type = [self substringWithRange:wordRange];
									if([_iTM2MacroTypes containsObject:type])
									{
										end += wordRange.length;
										if((end<length) && ([self characterAtIndex:end] != ')'))
										{
											++end;
										}
									}
								}
							}
							if(typeRef)
							{
								*typeRef = [type uppercaseString];
							}
							markRange.location = start;
							markRange.length = end - markRange.location;
							return markRange;
						}
					}
				}
				if(end>start+1)
				{
					markRange = NSMakeRange(start-1,4);
					if(typeRef)
					{
						*typeRef = nil;
					}
					return markRange;
				}
				// no placeholder mark
				if(start>4)
				{
					end = start-1;
					goto previousEnd;
				}
			}
			else if(end>start+1)
			{
				if(end+1<length)
				{
					// there is room for a start placeholder mark after the stop mark
					theChar = [self characterAtIndex:++end];
					if(theChar == '(')
					{
						// this is a start placeholder delimiter, there is no conflict with a start placeholder
						start = end - 3;
						type = @"";
						if(++end<length)
						{
							wordRange = [self rangeOfMacroTypeAtIndex:end];
							if(wordRange.length)
							{
								type = [self substringWithRange:wordRange];
								if([_iTM2MacroTypes containsObject:type])
								{
									end += wordRange.length;
									if((end<length) && ([self characterAtIndex:end] != ')'))
									{
										++end;
									}
								}
							}
						}
						if(typeRef)
						{
							*typeRef = [type uppercaseString];
						}
						markRange.location = start;
						markRange.length = end - markRange.location;
						return markRange;
					}
					else if(start>2)
					{
						end = start;
					}
				}
			}
		}
	}
	if(end--)
	{
		goto previousEnd;
	}
//iTM2_END;
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:getType:ignoreComment:
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/02/2007
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange startRange, stopRange;
	unsigned depth;
	unsigned idx = MAX(index,3)-3;
	NSString * type = nil;
	stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore];
	if(stopRange.length)
	{
		if(type)
		{
			if(stopRange.location<=index)
			{
				// this is in fact a start mark containing index
				// we have to find a balancing stop mark to the right
				startRange = stopRange;
				depth = 1;
otherNextStop:
				idx = NSMaxRange(stopRange);
				stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore];
				if(stopRange.length)
				{
					if(type)
					{
						++depth;
						goto otherNextStop;
					}
					else if(--depth)
					{
						goto otherNextStop;
					}
					else
					{
						startRange.length = NSMaxRange(stopRange)-startRange.location;
						if(typeRef)
						{
							*typeRef = [type uppercaseString];
						}
						return startRange;
					}
				}
				return NSMakeRange(NSNotFound,0);
			}
			else
			{
				// this is a start to the right
				depth = 1;
otherNextStopAfter:
				idx = NSMaxRange(stopRange);
				stopRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:ignore];
				if(stopRange.length)
				{
					if(type)
					{
						++depth;
						goto otherNextStopAfter;
					}
					else if(--depth)
					{
						goto otherNextStopAfter;
					}
					else
					{
						// find the balancing start
previousStart:
						startRange.location = MAX(index,3)-3;
						depth = 1;
otherPreviousStart:
						startRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:startRange.location getType:&type ignoreComment:ignore];
						if(startRange.length)
						{
							if(!type)
							{
								++depth;
								if(startRange.location)
								{
									--startRange.location;
									goto otherPreviousStart;
								}
							}
							else if(--depth)
							{
								if(startRange.location)
								{
									--startRange.location;
									goto otherPreviousStart;
								}
							}
							else
							{
								startRange.length=NSMaxRange(stopRange)-startRange.location;
								if(typeRef)
								{
									*typeRef = [type uppercaseString];
								}
								return startRange;
							}
						}
						// no balancing mark available
						return NSMakeRange(NSNotFound,0);
					}
				}
				// no balancing mark available
				return NSMakeRange(NSNotFound,0);
			}
		}
		else
		{
			goto previousStart;
		}
	}
//iTM2_END;
	return NSMakeRange(NSNotFound, 0);
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderAfterIndex:cycle:tabAnchor:ignoreComment:
- (NSRange)rangeOfNextPlaceholderAfterIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor ignoreComment:(BOOL)ignore;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange markRange = [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil ignoreComment:YES];
	NSRange range;
	NSRange smallerRange;
	unsigned idx = 0;
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
		if(range.length)
		{
nextRange1:
			idx = NSMaxRange(markRange);
			markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil ignoreComment:YES];
			if(markRange.length)
			{
				if(NSMaxRange(markRange)<NSMaxRange(range))
				{
					smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
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
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil ignoreComment:YES];
		if(markRange.length)
		{
			if(NSMaxRange(markRange)<=index)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
				if(range.length)
				{
nextRange2:
					idx = NSMaxRange(markRange);
					markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil ignoreComment:YES];
					if(markRange.length)
					{
						if(NSMaxRange(markRange)<NSMaxRange(range))
						{
							smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:YES];
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
	markRange= [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil ignoreComment:YES];
	if(markRange.length)
	{
		return markRange;
	}
	if(cycle)
	{
		markRange = [self rangeOfNextPlaceholderMarkAfterIndex:0 getType:nil ignoreComment:YES];
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
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfNextPlaceholderAfterIndex:cycle:tabAnchor:
- (NSRange)rangeOfNextPlaceholderAfterIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange markRange = [self rangeOfNextPlaceholderMarkAfterIndex:index getType:nil];
	NSRange range;
	NSRange smallerRange;
	unsigned idx = 0;
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
		if(range.length)
		{
nextRange1:
			idx = NSMaxRange(markRange);
			markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil];
			if(markRange.length)
			{
				if(NSMaxRange(markRange)<NSMaxRange(range))
				{
					smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
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
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
				if(range.length)
				{
nextRange2:
					idx = NSMaxRange(markRange);
					markRange = [self rangeOfNextPlaceholderMarkAfterIndex:idx getType:nil];
					if(markRange.length)
					{
						if(NSMaxRange(markRange)<NSMaxRange(range))
						{
							smallerRange = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil];
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
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPreviousPlaceholderBeforeIndex:cycle:tabAnchor:ignoreComment:
- (NSRange)rangeOfPreviousPlaceholderBeforeIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor ignoreComment:(BOOL)ignore;
/*"Placeholder delimiters are ')@@@' and '@@@(\word?'. 
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement NSBackwardsSearch
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range;
	NSRange markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil ignoreComment:ignore];
	if(markRange.length)
	{
		range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:ignore];
		if(range.length)
		{
			return range;
		}
	}
	unsigned length = [self length];
	if(cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil ignoreComment:ignore];
		if(markRange.length)
		{
			if(index<=markRange.location)
			{
				range = [self rangeOfPlaceholderAtIndex:markRange.location getType:nil ignoreComment:ignore];
				if(range.length)
				{
					return range;
				}
			}
		}
	}
	// placeholder markers only
	markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:index getType:nil ignoreComment:ignore];
	if(markRange.length)
	{
		return markRange;
	}
	if(cycle)
	{
		markRange = [self rangeOfPreviousPlaceholderMarkBeforeIndex:length getType:nil ignoreComment:ignore];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroPlaceholderReplacement
- (NSString *)macroPlaceholderReplacement;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self length]>8)
	{
		unichar theChar = [self characterAtIndex:3];
		if(theChar == '{')
		{
			;
		}
	}
//iTM2_END;
	return @"";
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByEscapingPerlControlCharacters
- (NSString *)stringByEscapingPerlControlCharacters;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [[self mutableCopy] autorelease];
	NSRange searchRange = NSMakeRange(0,[result length]);
	[result replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:searchRange];
	searchRange.length = [result length];
	[result replaceOccurrencesOfString:@"$" withString:@"\\$" options:0 range:searchRange];
	searchRange.length = [result length];
	[result replaceOccurrencesOfString:@"@" withString:@"\\@" options:0 range:searchRange];
	searchRange.length = [result length];
	[result replaceOccurrencesOfString:@"[" withString:@"\\[" options:0 range:searchRange];
//iTM2_END;
	return result;
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
	[self keyStroke];// this is useful for reentrant problem
	[self didChangeMacroKeyStroke];
	return;
}
- (void)willChangeMacroKeyStroke;
{
	id parent = [self parent];
	id D = [parent valueForKeyPath:@"value.cachedChildrenKeys"];
	NSString * key = [self key];
	[D removeObjectForKey:key];
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
	[self didChangeValueForKey:@"isShift"];
	[self didChangeValueForKey:@"isControl"];
	[self didChangeValueForKey:@"codeName"];
	[self didChangeValueForKey:@"prettyKey"];
	id parent = [self parent];
	id D = [parent valueForKeyPath:@"value.cachedChildrenKeys"];
	NSString * key = [self key];
	[D setObject:self forKey:key];
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
	iTM2KeyBindingContextNode * node = [self parent];
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
	[self setValue:nil forKeyPath:@"value.cachedChildrenKeys"];
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
	[macroEditor setValue:nil forKeyPath:@"value.cachedChildrenIDs"];
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
		[self setValue:nil forKeyPath:@"value.cachedChildrenKeys"];
	}
//iTM2_END;
    return;
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
		id child = (iTM2MacroLeafNode *)[self objectInChildrenWithKey:key];
		if(child)
		{
			[element detach];
			iTM2_LOG(@"removed element:%@",element);
		}
		else if(child = [[[iTM2KeyBindingLeafNode alloc] initWithParent:self] autorelease])
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
				child = (iTM2MacroLeafNode *)[self objectInChildrenWithKey:key];
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
		NSString * localized = [[iTM2KeyCodesController sharedController] localizedNameForCodeName:codeName];
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
	NSRange R = [self rangeOfString:@"+"];
	if(R.length)
	{
		key = [self substringFromIndex:NSMaxRange(R)];
		modifier = [self substringToIndex:R.location];
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
	modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;

	NSString * CIMs = [self charactersIgnoringModifiers];
	NSString * Cs = [self characters];
	NSString * lowerCs = [Cs lowercaseString];
	NSString * name = Cs;
	unichar c = 0;
	if([Cs length])
	{
		c = [Cs characterAtIndex:0];
		if(modifierFlags&NSControlKeyMask)
		{
			if(c<'!' || c>'~')
			{
				if([CIMs length])
				{
					c = [CIMs characterAtIndex:0];
					if(c<'!' || c>'~')
					{
						modifierFlags &= ~NSControlKeyMask;
					}
					else
					{
						Cs = CIMs;
					}
				}
			}
		}
		c = [Cs characterAtIndex:0];
		name = [KCC nameForKeyCode:c];
		if([CIMs isEqual:Cs])
		{
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
			if(modifierFlags&NSShiftKeyMask)
			{
				if([Cs isEqual:lowerCs])
				{
					[completeCodeName appendString:@"$"];
				}
				if(modifierFlags&NSAlternateKeyMask)	[completeCodeName appendString:@"~"];
				if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
				if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
				if(modifierFlags&NSFunctionKeyMask)		[completeCodeName appendString:@"&"];
				if([completeCodeName length])			[completeCodeName appendString:@"+"];
														[completeCodeName appendString:name];
iTM2_LOG(completeCodeName);
				return [completeCodeName macroKeyStroke];
			}
			if(modifierFlags&NSAlternateKeyMask)	[completeCodeName appendString:@"~"];
			if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
			if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
			if(![name hasSuffix:@"FunctionKey"] && (modifierFlags&NSFunctionKeyMask))
													[completeCodeName appendString:@"&"];
			if([completeCodeName length])			[completeCodeName appendString:@"+"];
													[completeCodeName appendString:name];
iTM2_LOG(completeCodeName);
			return [completeCodeName macroKeyStroke];
		}

		if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
		if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
		if(modifierFlags&NSFunctionKeyMask)		[completeCodeName appendString:@"&"];
		if([completeCodeName length])			[completeCodeName appendString:@"+"];
		[completeCodeName appendString:name];
iTM2_LOG(completeCodeName);
	}
	return [completeCodeName macroKeyStroke];
}
- (iTM2MacroKeyStroke *)macroKeyStrokeWithoutModifiers;
{
	if([self type] != NSKeyDown)
	{
		return nil;
	}
	NSMutableString * completeCodeName = [NSMutableString string];
	unsigned int modifierFlags = [self modifierFlags];
	modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;

	NSString * CIMs = [self charactersIgnoringModifiers];
	NSString * name = CIMs;
	if([CIMs length])
	{
		unichar c = [CIMs characterAtIndex:0];
		name = [KCC nameForKeyCode:c];
		if(modifierFlags&NSControlKeyMask)
		{
			if(c<'!' || c>'~')
			{
				modifierFlags &= ~NSControlKeyMask;
			}
		}
	}
	if([name hasSuffix:@"FunctionKey"])
	{
		if(modifierFlags&NSShiftKeyMask)		[completeCodeName appendString:@"$"];
		if(modifierFlags&NSAlternateKeyMask)	[completeCodeName appendString:@"~"];
		if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
		if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
		if([completeCodeName length])			[completeCodeName appendString:@"+"];
												[completeCodeName appendString:CIMs];
iTM2_LOG(completeCodeName);
		return [completeCodeName macroKeyStroke];
	}
	if(modifierFlags&NSShiftKeyMask)
	{
		[completeCodeName appendString:@"$"];
		CIMs = [CIMs lowercaseString];
	}
	if(modifierFlags&NSAlternateKeyMask)	[completeCodeName appendString:@"~"];
	if(modifierFlags&NSControlKeyMask)		[completeCodeName appendString:@"^"];
	if(modifierFlags&NSCommandKeyMask)		[completeCodeName appendString:@"@"];
	if(![name hasSuffix:@"FunctionKey"] && (modifierFlags&NSFunctionKeyMask))
											[completeCodeName appendString:@"&"];
	if([completeCodeName length])			[completeCodeName appendString:@"+"];
											[completeCodeName appendString:CIMs];
iTM2_LOG(completeCodeName);
	return [completeCodeName macroKeyStroke];
}
@end

@interface iTM2MacroTableView:NSTableView
@end

@implementation iTM2MacroTableView
- (SEL)doubleAction;
{
	return @selector(executeMacro:);
}
- (void)copy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			NSMutableDictionary * copy = [NSMutableDictionary dictionary];
			NSMutableArray * IDs = [NSMutableArray array];
			[copy setObject:IDs forKey:@"IDs"];
			id node = [selectedObjects lastObject];
			node = [node parent];
			NSString * context = [node valueForKeyPath:@"value.context"];
			node = [node parent];
			NSString * category = [node valueForKeyPath:@"value.category"];
			node = [node parent];
			NSString * domain = [node valueForKeyPath:@"value.domain"];
			[copy setObject:domain forKey:@"domain"];
			[copy setObject:category forKey:@"category"];
			[copy setObject:context forKey:@"context"];
			NSEnumerator * E = [selectedObjects objectEnumerator];
			while(node = [E nextObject])
			{
				NSString * ID = [node ID];
				[IDs addObject:ID];
			}
			NSPasteboard * GP = [NSPasteboard generalPasteboard];
			NSString * type = @"iTM2MacroPBoard";
			NSArray * newTypes = [NSArray arrayWithObject:type];
			[GP declareTypes:newTypes owner:nil];
			[GP setPropertyList:copy forType:type];
		}
	}
	return;
}
- (BOOL)validateCopy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			return YES;
		}
	}
	return NO;
}
- (void)paste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	if(!availableType)
	{
		return;
	}
	NSDictionary * copies = [GP propertyListForType:availableType];
	NSString * domain = [copies objectForKey:@"domain"];
	NSString * category = [copies objectForKey:@"category"];
	NSString * context = [copies objectForKey:@"context"];
	NSArray * IDs = [copies objectForKey:@"IDs"];
	NSEnumerator * E = [IDs objectEnumerator];
	NSString * ID;
	id sourceTree = [SMC macroTree];
	sourceTree = [sourceTree objectInChildrenWithDomain:domain];
	sourceTree = [sourceTree objectInChildrenWithCategory:category];
	sourceTree = [sourceTree objectInChildrenWithContext:context];
	id targetTree = [SMC macroEditor];
	id node, alreadyNode;
	while(ID = [E nextObject])
	{
		if(node = [sourceTree objectInChildrenWithID:ID])
		{
			node = [node copy];
			if(alreadyNode = [targetTree objectInChildrenWithID:ID])
			{
				//The only thing I have to do is connect the last mutableXMLElement;
				NSURL * url = [iTM2MacroDocumentManager personalURLOfClient:targetTree];
				NSXMLDocument * personalDocument = [iTM2MacroDocumentManager documentForURL:url client:targetTree];
				NSXMLElement * personalRootElement = [personalDocument rootElement];
				NSMutableArray * alreadyMutableXMLElements = [alreadyNode mutableXMLElements];
				NSXMLElement * element = [alreadyMutableXMLElements lastObject];
				if(element)
				{
					NSString * XPath = [NSString stringWithFormat:@"/@ID=\"%@\"",ID];
					NSArray * RA = [personalRootElement nodesForXPath:XPath error:nil];
					id elt;
					NSEnumerator * EE = [RA objectEnumerator];
					while(elt = [EE nextObject])
					{
						[elt detach];
					}
					NSXMLDocument * rootDocument = [element rootDocument];
					if([personalDocument isEqual:rootDocument])
					{
						[alreadyMutableXMLElements removeLastObject];
					}
					[element detach];
				}
				element = [node XMLElement];
				if(!element)
				{
					element = [NSXMLElement elementWithName:@"ACTION"];
					NSXMLNode * attribute = [NSXMLNode attributeWithName:@"ID" stringValue:ID];
					[element addAttribute:attribute];
				}
				[element detach];
				[personalRootElement addChild:element];
				[alreadyNode addMutableXMLElement:element];
			}
			else
			{
				[targetTree insertObject:node inAvailableMacrosAtIndex:0];
			}
		}
		else
		{
			iTM2_LOG(@"No macro with domain:%@, category:%@, context:%@, ID:%@",
				domain,category,context,ID);
		}
	}
	return;
}
- (BOOL)validatePaste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	return availableType != nil;
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
	return YES;
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
		NSMutableArray * result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id reverseTransformedValue = [self reverseTransformedValue:value];
			[result addObject:(reverseTransformedValue?:value)];
		}
		return result;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroTestView
- (id)macroTestView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroTestView:
- (void)setMacroTestView:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER(argument);
	return;
}
@end

@interface iTM2MacroPopUpButton:NSPopUpButton
@end

@implementation iTM2MacroPopUpButton
- (void)awakeFromNib;
{
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	NSView * superview = [self superview];
	[self retain];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self positioned:NSWindowBelow relativeTo:nil];
	return;
}
@end

@interface iTM2MacroEditor:NSTextView
@end

@implementation iTM2MacroEditor
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

@interface iTM2MacroTestView:iTM2TextEditor
@end

@implementation iTM2MacroTestView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacro:
- (void)executeMacro:(id)macro;
{
	if([macro respondsToSelector:@selector(executeMacroWithTarget:selector:substitutions:)])
	{
		[macro executeMacroWithTarget:self selector:NULL substitutions:nil];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
    return [SMC selectedDomain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
    return [SMC selectedMode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
@end
