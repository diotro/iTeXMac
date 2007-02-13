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

#import <iTM2Foundation/iTM2TreeKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2TaskKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>

NSString * const iTM2TextPlaceholderMark = @"@@";

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

NSString * const iTM2MacroServerComponent = @"Macros.localized";
NSString * const iTM2MacroServerSummaryComponent = @"Summary";
NSString * const iTM2MacrosDirectoryName = @"Macros";
NSString * const iTM2MacrosPathExtension = @"iTM2-macros";


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
@end

@interface iTM2MacroContextNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
- (id)objectInChildrenWithID:(NSString *)ID;
- (NSArray *)availableIDs;
@end

@implementation iTM2MacroContextNode: iTM2TreeNode
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
- (id)objectInChildrenWithID:(NSString *)ID;
{
	id D = [self valueForKeyPath:@"value.cachedChildrenID"];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		NSArray * children = [self children];
		NSEnumerator * E = [children objectEnumerator];
		id child;
		while(child = [E nextObject])
		{
			NSString * ID = [child valueForKeyPath:@"value.ID"];
			[D setObject:child forKey:ID];
		}
		[self setValue:D forKeyPath:@"value.cachedChildrenID"];
	}
	return [D objectForKey:ID];
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
			if(ID = [child valueForKeyPath:@"value.ID"])
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
- (NSArray *)availableIDs;
{
	NSMutableArray * result = [NSMutableArray array];
	NSArray * children = [self children];
	NSEnumerator * E = [children objectEnumerator];
	id child;
	id ID;
	while(child = [E nextObject])
	{
		ID = [child valueForKeyPath:@"value.ID"];
		if(ID && ![result containsObject:ID])
		{
			[result addObject:ID];
		}
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	[result sortUsingDescriptors:SDs];
	return result;
}
@end

@interface iTM2MacroLeafNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent ID:(NSString *)ID element:(NSXMLElement *)element;
- (NSString *)name;
- (SEL)action;
- (NSString *)argument;
- (NSString *)description;
- (NSString *)tooltip;
- (NSString *)ID;
- (NSString *)mode;
@end

@implementation iTM2MacroLeafNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent ID:(NSString *)ID element:(NSXMLElement *)element;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:ID forKeyPath:@"value.ID"];
		[self setValue:element forKeyPath:@"value.element"];
	}
	return self;
}
- (NSString *)description;
{
	return [NSString stringWithFormat:@"%@(%@)",[super description],[self valueForKeyPath:@"value.ID"]];
}
- (NSString *)name;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
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
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
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
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
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
- (SEL)action;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
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
- (NSString *)argument;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
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
- (NSString *)ID;
{
	return [self valueForKeyPath:@"value.ID"];
}
- (NSString *)mode;
{
	NSXMLElement * element = [self valueForKeyPath:@"value.element"];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"@MODE" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: MODE atribute?";
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

@interface iTM2MacroController(PRIVATE)
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (void)setSelectedMode:(NSString *)mode;
@end

@implementation iTM2MacroController

static id _iTM2MacroController = nil;

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
		[self setRunningTree:nil];
		[self setValue:nil forKey:@"sourceTree"];// dirty trick to avoid header declaration
	}
	return _iTM2MacroController = self;
}

- (id)runningTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained later
	// list all the *.iTM2-macros files
	// Create a Macros.localized in the Application\ Support folder as side effect
	[[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:YES];
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
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
				if([extension isEqual:@"iTM2-macros"])
				{
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = [components objectEnumerator];
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					iTM2MacroContextNode * contextNode = nil;
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
										[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
							}
							else
							{
								component = @"";
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
							}
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							contextNode = [categoryNode objectInChildrenWithContext:component]?:
									[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
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
								[[[iTM2MacroContextNode alloc] initWithParent:categoryNode context:component] autorelease];
					}
					NSURL * url = [NSURL URLWithString:[subpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:repositoryURL];
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"url:%@",url);
					}
					NSError * localError =  nil;
					NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
					if(localError)
					{
						iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
					}
					else
					{
						// now create the children
						e = [[document nodesForXPath:@"//ACTION" error:&localError] objectEnumerator];
						NSXMLElement * element = nil;
						while(element = [e nextObject])
						{
							[element detach];// no longer belongs to the document
							NSString * ID = [[element attributeForName:@"ID"] stringValue];
							iTM2MacroLeafNode * child = (iTM2MacroLeafNode *)[contextNode objectInChildrenWithID:ID];
							if(!child)
							{
								//iTM2MacroLeafNode * node = 
								[[[iTM2MacroLeafNode alloc] initWithParent:contextNode ID:ID element:element] autorelease];
							}
							if(iTM2DebugEnabled)
							{
								child = (iTM2MacroLeafNode *)[contextNode objectInChildrenWithID:ID];
								iTM2_LOG(@"child:%@",child);
							}
						}
					}
				}
			}
			[DFM popDirectory];
		}
	}
	metaSETTER(rootNode);
	return rootNode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setRunningTree:
- (void)setRunningTree:(id)aTree;
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
	iTM2MacroRootNode * rootNode = [self runningTree];
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
	iTM2MacroRootNode * rootNode = [self runningTree];
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
	[[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:YES];
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	NSArray * RA = [[NSBundle mainBundle] allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
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
				if([extension isEqual:@"iTM2-menu"])
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
			NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
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
    return [[self runningTree] availableDomains];
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
	id node = [[self runningTree] objectInChildrenWithDomain:domain];
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
		[self willChangeValueForKey:@"availableMacros"];
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
		[self didChangeValueForKey:@"availableMacros"];
	}
//iTM2_END;
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
	NSString * domain = [self selectedDomain];
	id node = [[self runningTree] objectInChildrenWithDomain:domain];
	NSString * mode = [self selectedMode];
	node = [node objectInChildrenWithCategory:mode];
	node = [node objectInChildrenWithContext:@""];
//iTM2_END;
    return [node children];
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
//iTM2_END;
    return;
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
	NSSortDescriptor * SD = [[[NSSortDescriptor allocWithZone:[self zone]] initWithKey:@"value.ID" ascending:YES] autorelease];
//iTM2_END;
    return [NSArray arrayWithObject:SD];
}
#pragma mark =-=-=-=-=-  MENU DELEGATE
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
	NSString * domain = [firstResponder macroDomain];
	iTM2MacroRootNode * rootNode = [self runningTree];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
+ (NSString *)macroDomain;
{
    return @"";
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
	result = [[self class] macroDomain];
	if([result length])
	{
		return result;
	}
	result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroDomain:
- (void)setMacroDomain:(NSString *)argument;
{
	argument = [argument description];
	NSString * old = [self macroDomain];
	if(![old isEqual:argument])
	{
		NSString * key = [self macroDomainKey];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
+ (NSString *)macroCategory;
{
    return @"";
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
	result = [[self class] macroCategory];
	if([result length])
	{
		return result;
	}
	result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	argument = [argument description];
	NSString * old = [self macroCategory];
	if(![old isEqual:argument])
	{
		NSString * key = [self macroCategoryKey];
		[self willChangeValueForKey:@"macroCategory"];
		[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
		[self didChangeValueForKey:@"macroCategory"];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return iTM2MacroContextKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
+ (NSString *)macroContext;
{
    return @"";
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
	result = [[self class] macroContext];
	if([result length])
	{
		return result;
	}
	result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroContext:
- (void)setMacroContext:(NSString *)argument;
{
	argument = [argument description];
	NSString * old = [self macroContext];
	if(![old isEqual:argument])
	{
		NSString * key = [self macroContextKey];
		[self willChangeValueForKey:@"macroContext"];
		[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
		[self didChangeValueForKey:@"macroContext"];
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
	id superview = [self superview];
	if(superview)
	{
		[superview setMacroCategory:argument];
	}
	id nextResponder = [self nextResponder];
	if(nextResponder)
	{
		[nextResponder setMacroCategory:argument];
	}
	id window = [self window];
	if(window)
	{
		[window setMacroCategory:argument];
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

NSString * const iTM2DontUseSmartMacrosKey = @"iTM2DontUseSmartMacros";

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
	id representedMode = [sender representedString];
	id currentMode = [self macroCategory];
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
	// order front the pref panel
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
	id nextResponder = [self nextResponder];
	if(nextResponder)
	{
		[nextResponder setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
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
#pragma mark =-=-=-=-=- OLD CODE: USED?
static NSMutableDictionary * _iTM2_MacroServer_Data;

@interface iTM2MacroServer(PRIVATE)
+ (NSMenuItem *)_macrosMenuItemFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)error;
+ (NSMenu *)_macrosMenuFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)error;
+ (NSMenuItem *)_macrosMenuItemWithXMLElement:(NSXMLElement *)element error:(NSError **)error;
@end

@implementation iTM2MacroServer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  threadedUpdateUserMacrosHashTable:
+ (void)threadedUpdateUserMacrosHashTable:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSThread setThreadPriority:0.2];// why 0.2? why not...
	NSString * path = [[self classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateMacrosHashTable.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
		[TW addArgument:P];
		[TW addArgument:@"--callback"];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:NO];
		[TC start];
		[TC waitUntilExit];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSource:forKey:relativeTo:
+ (void)setSource:(NSString *)path forKey:(NSString *)key relativeTo:(NSString *)fullPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macrosMenuAtPath:error:
+ (NSMenu *)macrosMenuAtPath:(NSString *)file error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    NSURL *furl = [NSURL fileURLWithPath:file];
    if (!furl) {
        NSLog(@"Can't create an URL from file %@.", file);
        return nil;
    }
	NSXMLDocument *xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:furl
            options:NSXMLNodePreserveCDATA
            error:outErrorPtr] autorelease];
    if (!xmlDoc)  {
		if(outErrorPtr && !(*outErrorPtr))
			*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script.macrosMenuAtPath:error:" code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
					@"File is missing a DOMAIN title", NSLocalizedFailureReasonErrorKey,// NSString
					// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
					// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
					// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
						nil]];
		return nil;
	}
	NSMenu * M = [[[self _macrosMenuItemWithXMLElement:[xmlDoc rootElement] error:outErrorPtr] submenu] retain];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuItemWithXMLElement:error:
+ (NSMenuItem *)_macrosMenuItemWithXMLElement:(NSXMLElement *)element error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[element name] isEqualToString:@"M"])
	{
		NSEnumerator * E = [[element children] objectEnumerator];
		NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
		id child;
		NSString * title = @"";
		NSString * domain = @"";
		NSString * category = @"";
		NSString * key = @"";
		if(child = [E nextObject])
		{
			NSString * name = [child name];
			if([name isEqualToString:@"T"])
			{
				title = [child stringValue];
			}
			else
			{
				if([name isEqualToString:@"D"])
				{
					domain = [child stringValue];
					child = [E nextObject];
					name = [child name];
				}
				if([name isEqualToString:@"C"])
				{
					category = [child stringValue];
					child = [E nextObject];
					name = [child name];
				}
				if([name isEqualToString:@"K"])
				{
					key = [child stringValue];// we must have a key,
				}
				else
				{
					if(outErrorPtr)
						*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemWithXMLElement:error:" code:1 userInfo:
							[NSDictionary dictionaryWithObjectsAndKeys:
								@"File not conforming to its DTD", NSLocalizedDescriptionKey,// NSString
								@"File is missing a K", NSLocalizedFailureReasonErrorKey,// NSString
								// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
								// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
								// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
									nil]];
					return nil;
				}
			}
			while(child = [E nextObject])
			{
				NSMenuItem * mi = [self _macrosMenuItemWithXMLElement:child error:outErrorPtr];
				if(mi)
				{
					[M addItem:mi];
				}
			}
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:NULL keyEquivalent:@""] autorelease];
		[MI setTarget:self];
		[MI setSubmenu:M];
		[MI setRepresentedObject:[NSArray arrayWithObjects:domain, category, key, nil]];
		[MI setSubmenu:M];
		return MI;
	}
	else if([[element name] isEqualToString:@"I"])
	{
		NSEnumerator * E = [[element children] objectEnumerator];
		id child;
		NSString * domain = @"";
		NSString * category = @"";
		NSString * key = @"";
		if(child = [E nextObject])
		{
			NSString * name = [child name];
			if([name isEqualToString:@"D"])
			{
				domain = [child stringValue];
				child = [E nextObject];
				name = [child name];
			}
			if([name isEqualToString:@"C"])
			{
				category = [child stringValue];
				child = [E nextObject];
				name = [child name];
			}
			if([name isEqualToString:@"K"])
			{
				key = [child stringValue];
			}
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:
			[NSString stringWithFormat:@"domain:%@, category:%@, key:%@", domain, category, key] action:@selector(macroAction:) keyEquivalent:@""] autorelease];
		[MI setTarget:self];
		[MI setRepresentedObject:[NSArray arrayWithObjects:domain, category, key, nil]];
		return MI;
	}
	else if([[element name] isEqualToString:@"S"])
		return [NSMenuItem separatorItem];
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macrosMenuAtPath:error:
+ (NSMenu *)___macrosMenuAtPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	// open the file as a string file
	unsigned int encoding;
	NSString * S = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:outErrorPtr];
	if(![S length] || (outErrorPtr && !(*outErrorPtr)))
		return nil;
	unsigned end, contentsEnd;
	[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:NSMakeRange(0, 0)];
	NSString * recordSeparator = [S substringWithRange:NSMakeRange(0, (contentsEnd? :end))];
	NSEnumerator * E = [[S componentsSeparatedByString:recordSeparator] objectEnumerator];
	NSMenu * M = [[self _macrosMenuFromEnumerator:E error:outErrorPtr] retain];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuItemFromEnumerator:error:
+ (NSMenuItem *)_macrosMenuItemFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * title;
	if(title = [enumerator nextObject])
	{
		NSString * record;
		if(record = [enumerator nextObject])
		{
			if([record isEqualToString:@"SUBMENU"])
			{
				NSMenu * M = [self _macrosMenuFromEnumerator:enumerator error:outErrorPtr];
				if(M)
				{
					NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:NULL keyEquivalent:@""] autorelease];
					[MI setSubmenu:M];
					return MI;
				}
			}
			else
			{
				NSString * domain = @"";
				NSString * category = @"";
				NSString * key;
				if([record isEqualToString:@"DOMAIN"])
				{
					domain = [enumerator nextObject];
					if(!domain)
					{
						if(outErrorPtr)
							*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:1 userInfo:
								[NSDictionary dictionaryWithObjectsAndKeys:
									@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
									@"File is missing a DOMAIN title", NSLocalizedFailureReasonErrorKey,// NSString
									// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
									// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
									// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
										nil]];
						return nil;
					}
					record = [enumerator nextObject];
				}
				if([record isEqualToString:@"CATEGORY"])
				{
					category = [enumerator nextObject];
					if(!category)
					{
						if(outErrorPtr)
							*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:1 userInfo:
								[NSDictionary dictionaryWithObjectsAndKeys:
									@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
									@"File is missing a CATEGORY title", NSLocalizedFailureReasonErrorKey,// NSString
									// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
									// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
									// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
										nil]];
						return nil;
					}
					record = [enumerator nextObject];
				}
				if([record isEqualToString:@"KEY"])
				{
					if(key = [enumerator nextObject])
					{
						//error
						NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:@selector(macroAction:) keyEquivalent:@""] autorelease];
						[MI setRepresentedObject:[NSArray arrayWithObjects:domain, category, key, nil]];
						return MI;
					}
					if(outErrorPtr)
						*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:2 userInfo:
							[NSDictionary dictionaryWithObjectsAndKeys:
								@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
								@"File is missing a KEY title", NSLocalizedFailureReasonErrorKey,// NSString
								// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
								// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
								// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
									nil]];
					return nil;
				}
				if(outErrorPtr)
					*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:3 userInfo:
						[NSDictionary dictionaryWithObjectsAndKeys:
							@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
							@"File is missing a KEY record", NSLocalizedFailureReasonErrorKey,// NSString
							// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
							// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
							// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
								nil]];
				return nil;
			}
		}
		else
		{
			if(outErrorPtr)
				*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:4 userInfo:
					[NSDictionary dictionaryWithObjectsAndKeys:
						@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
						@"File is missing an ITEM content", NSLocalizedFailureReasonErrorKey,// NSString
						// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
						// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
						// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
							nil]];
			return nil;
		}
	}
	else
	{
		if(outErrorPtr)
			*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:5 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
					@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
					// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
					// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
					// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
						nil]];
		return nil;
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuFromEnumerator:error:
+ (NSMenu *)_macrosMenuFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	NSString * S = nil;
	if(S = [enumerator nextObject])
	{
		if([S isEqualToString:@"ITEM"])
		{
			NSMenuItem * MI = [self _macrosMenuItemFromEnumerator:enumerator error:outErrorPtr];
			if(MI)
			{
				[M addItem:MI];
nextITEM:
				if(S = [enumerator nextObject])
				{
					if([S isEqualToString:@"ITEM"])
					{
						if(MI = [self _macrosMenuItemFromEnumerator:enumerator error:outErrorPtr])
						{
							[M addItem:MI];
						}
						else
						{
							return M;
						}
					}
					else if([S isEqualToString:@"SEPARATOR"])
					{
						[M addItem:[NSMenuItem separatorItem]];
					}
					else if([S isEqualToString:@"UNEMBUS"])
					{
						return M;
					}
					else
					{
						if(outErrorPtr)
							*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:2 userInfo:
								[NSDictionary dictionaryWithObjectsAndKeys:
									@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
									@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
									// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
									// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
									// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
										nil]];
						return nil;
					}
					goto nextITEM;
				}
				else
				{
					if(outErrorPtr)
						*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:3 userInfo:
							[NSDictionary dictionaryWithObjectsAndKeys:
								@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
								@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
								// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
								// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
								// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
									nil]];
					return nil;
				}
			}
			else
			{
				return M;
			}
		}
		else
		{
			if(outErrorPtr)
				*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:2 userInfo:
					[NSDictionary dictionaryWithObjectsAndKeys:
						@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
						@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
						// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
						// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
						// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
							nil]];
			return nil;
		}
	}
	else
	{
		if(outErrorPtr)
			*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
					@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
					// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
					// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
					// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
						nil]];
		return nil;
	}
//iTM2_END;
	return nil;
}
@end

@interface NSObject(RIEN)
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
@end

@interface iTM2MacrosServer(PRIVATE)

/*!
	@method			storageForContext:ofCategory:inDomain:
	@abstract		Storage for the various information.
	@discussion 	Do not use this method if you have a more general accessor.
	@param			context
	@param			category
	@param			domain
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (id)storageForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			updateLocalesIndexForContext:ofCategory:inDomain:
	@abstract		Update the locales index.
	@discussion		Discussion forthcoming.
	@param			context
	@param			category
	@param			domain
	@result			a path.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (void)updateLocalesIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			updateActionsIndexForContext:ofCategory:inDomain:
	@abstract		Update the Actions index.
	@discussion		Discussion forthcoming.
	@param			category
	@param			domain
	@result			a path.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (void)updateActionsIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			indexWithContentsOfFile:error:
	@abstract		Return an index from the given location.
	@discussion		It is expected to have a standalone shalow xml file at the given location.
					The root element is a LIST of ITEM's.
					LIST and ITEM's have a key attribute.
					The return object is a dictionary which values are just ITEM's.
					The keys are the key attributes of the ITEM eventually prepended by
					the key attribute of the LIST root element as a common prefix to all the keys.
	@param			path
	@param			outErrorPtr
	@result			A hash...
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (id)indexWithContentsOfFile:(NSString*)path error:(NSError **)outErrorPtr;

/*!
	@method			macrosIndexWithContentsOfFile:error:
	@abstract		Return a macros index from the given location.
	@discussion		It is expected to have a standalone shalow xml file at the given location.
					The root element is a LIST of ITEM's.
					LIST and ITEM's have a key attribute.
					ITEM's string value is the path of the file where the macro.
					If this path starts with ".", it is prepended by the directory part of path.
					The return object is a dictionary which values are those paths.
					The keys are the key attributes of the ITEM eventually prepended by
					the key attribute of the LIST root element as a common prefix to all the keys.
	@param			path
	@param			outErrorPtr
	@result			A hash...
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (id)macrosIndexWithContentsOfFile:(NSString *)path error:(NSError **)outErrorPtr;

- (void)loadMacrosSummaries;
- (void)loadMacrosSummaryAtPath:(NSString *)path;
- (void)loadMacrosSummariesAtPath:(NSString *)path;
- (void)loadMacrosLocaleAtURL:(NSURL *)url;
- (id)macrosServerStorage;

@end

@implementation iTM2MacrosServer
static iTM2MacrosServer * _iTM2SharedMacrosServer = nil;
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
	_iTM2SharedMacrosServer = [[self alloc] init];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString bullet], iTM2TextTabAnchorStringKey,
                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sharedMacrosServer
+ (id)sharedMacrosServer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _iTM2SharedMacrosServer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_iTM2SharedMacrosServer)
	{
		[self dealloc];
		return [_iTM2SharedMacrosServer retain];
	}
//iTM2_END;
	else if(self = [super init])
	{
		[[self implementation] takeMetaValue:[NSMutableDictionary dictionary] forKey:@"MacrosServerStorage"];
	}
    return _iTM2SharedMacrosServer = self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macrosServerStorage
- (id)macrosServerStorage;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= storageForContext:ofCategory:inDomain:
- (id)storageForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [[self macrosServerStorage] objectForKey:domain];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[[self macrosServerStorage] setObject:MD forKey:domain];
	}
	NSMutableDictionary * result = [MD objectForKey:category];
	if(!result)
	{
		result = [NSMutableDictionary dictionary];
		[MD setObject:result forKey:category];
	}
	MD = result;
	result = [MD objectForKey:context];
	if(!result)
	{
		result = [NSMutableDictionary dictionary];
		[MD setObject:result forKey:context];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroURLForKey:context:ofCategory:inDomain:
- (NSURL *)macroURLForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id URLs = [storage objectForKey:@"./URLs"];
	id URL = [URLs objectForKey:key];
//iTM2_END;
	return URL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroLocaleOfType:forKey:context:ofCategory:inDomain:
- (NSString *)macroLocaleOfType:(NSString *)type forKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id locales = [storage objectForKey:@"./Locales"];
	NSDictionary * names = [locales objectForKey:type];
	NSString * name = [names objectForKey:key];
	if(name)
	{
		return name;
	}
	if([context length])
	{
		storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([category length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([domain length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	NSURL * url = [self macroURLForKey:key context:context ofCategory:category inDomain:domain];
	if(url)
	{
		[self loadMacrosLocaleAtURL:url];
		storage = [self storageForContext:context ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([context length])
	{
		if(url = [self macroURLForKey:key context:@"" ofCategory:category inDomain:domain])
		{
			[self loadMacrosLocaleAtURL:url];
			storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
			locales = [storage objectForKey:@"./Locales"];
			names = [locales objectForKey:type];
			if(name = [names objectForKey:key])
			{
				return name;
			}
		}
	}
	if([category length])
	{
		if(url = [self macroURLForKey:key context:@"" ofCategory:@"" inDomain:domain])
		{
			[self loadMacrosLocaleAtURL:url];
			storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
			locales = [storage objectForKey:@"./Locales"];
			names = [locales objectForKey:type];
			if(name = [names objectForKey:key])
			{
				return name;
			}
		}
	}
	if([domain length])
	{
		if(url = [self macroURLForKey:key context:@"" ofCategory:@"" inDomain:@""])
		{
			[self loadMacrosLocaleAtURL:url];
			storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
			locales = [storage objectForKey:@"./Locales"];
			names = [locales objectForKey:type];
			if(name = [names objectForKey:key])
			{
				return name;
			}
		}
	}
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDescriptionForKey:context:ofCategory:inDomain:
- (NSString *)macroDescriptionForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id locales = [storage objectForKey:@"./Locales"];
	NSDictionary * names = [locales objectForKey:@"Description"];
	NSString * name = [names objectForKey:key];
	if(name)
	{
		return name;
	}
	if([context length])
	{
		storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Description"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([category length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Description"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([domain length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Description"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	NSURL * url = [self macroURLForKey:key context:context ofCategory:category inDomain:domain];
	[self loadMacrosLocaleAtURL:url];
	locales = [storage objectForKey:@"./Locales"];
	names = [locales objectForKey:@"Description"];
	if(name = [names objectForKey:key])
	{
		return name;
	}
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroTooltipForKey:context:ofCategory:inDomain:
- (NSString *)macroTooltipForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id locales = [storage objectForKey:@"./Locales"];
	NSDictionary * names = [locales objectForKey:@"Tooltip"];
	NSString * name = [names objectForKey:key];
	if(name)
	{
		return name;
	}
	if([context length])
	{
		storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Tooltip"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([category length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Tooltip"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([domain length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Tooltip"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	NSURL * url = [self macroURLForKey:key context:context ofCategory:category inDomain:domain];
	[self loadMacrosLocaleAtURL:url];
	locales = [storage objectForKey:@"./Locales"];
	names = [locales objectForKey:@"Tooltip"];
	if(name = [names objectForKey:key])
	{
		return name;
	}
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroActionForKey:context:ofCategory:inDomain:
- (id)macroActionForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	NSDictionary * D = [storage objectForKey:@"Actions"];
	if(!D)
	{
		[self updateActionsIndexForContext:context ofCategory:category inDomain:domain];
		D = [storage objectForKey:@"Actions"];
	}
//iTM2_END;
	return [D objectForKey:key];
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateLocalesIndexForContext:ofCategory:inDomain:
- (void)updateLocalesIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * macros = [NSMutableDictionary dictionary];
	// first we scan the built in resources, from the deeper embedded bundle to the main one
	NSString * path = [[iTM2MacroServerComponent stringByAppendingPathComponent:domain] stringByAppendingPathComponent:category];
	NSEnumerator * E = [[[NSBundle mainBundle] pathsForBuiltInResource:@"iTM2LocalesIndex" ofType:@"xml" inDirectory:path] objectEnumerator];
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	// then we have to rebuild the index for the user support domain
	path = [[iTM2TaskWrapper classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateLocalesIndex.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
		[TW addArgument:P];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:YES];
		[TC start];
		[TC waitUntilExit];
	}
	else
	{
		iTM2_LOG(@"*** ERROR: bad configuration, reinstall and report bug if the problem is not solved.");
	}
	E = [[[NSBundle mainBundle] pathsForSupportResource:@"iTM2LocalesIndex" ofType:@"xml" inDirectory:iTM2MacroServerComponent] objectEnumerator];
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	[[self storageForContext:context ofCategory:category inDomain:domain] setObject:macros forKey:@"Locales"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateActionsIndexForContext:ofCategory:inDomain:
- (void)updateActionsIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * macros = [NSMutableDictionary dictionary];
	// first we scan the built in resources, from the deeper embedded bundle to the main one
	NSEnumerator * E = [[[NSBundle mainBundle] pathsForBuiltInResource:@"Actions" ofType:@"xml" inDirectory:[[iTM2MacroServerComponent stringByAppendingPathComponent:domain] stringByAppendingPathComponent:category]] objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	// then we have to rebuild the index for the user support domain
	path = [[iTM2TaskWrapper classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateActionsIndex.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
		[TW addArgument:P];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:NO];
		[TC start];
		[TC waitUntilExit];
	}
	else
	{
		iTM2_LOG(@"*** ERROR: bad configuration, reinstall and report bug if the problem is not solved.");
	}
	E = [[[NSBundle mainBundle] pathsForSupportResource:nil ofType:iTM2MacroServerComponent inDirectory:@"iTM2ActionsIndex"] objectEnumerator];
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	[[self storageForContext:context ofCategory:category inDomain:domain] setObject:macros forKey:@"Actions"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosLocaleAtURL:
- (void)loadMacrosLocaleAtURL:(NSURL *)url;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![url isFileURL])
	{
		return;
	}
	NSString * path = [url path];
	NSArray * components = [path pathComponents];
	path = [path stringByAppendingPathComponent:@"Locales"];
	path = [path stringByAppendingPathExtension:@"xml"];
	int index = [components indexOfObject:iTM2MacroServerComponent];
	if(index==NSNotFound)
	{
		return;
	}
	NSString * domain = @"";
	NSString * category = @"";
	NSString * context = @"";
	if(++index < [components count]-1)
	{
		domain = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		category = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		context = [components objectAtIndex:index];
	}
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category inDomain:domain];
	NSMutableDictionary * locales = [MD objectForKey:@"./Locales"];
	if(!locales)
	{
		locales = [NSMutableDictionary dictionary];
		[MD setObject:locales forKey:@"./Locales"];
	}
	NSURL * sourceURL = [NSURL fileURLWithPath:path];
	NSError * localError = nil;
	NSXMLDocument * source = [[[NSXMLDocument alloc] initWithContentsOfURL:sourceURL options:0 error:&localError] autorelease];
	if(localError)
	{
		iTM2_REPORTERROR(1,([NSString stringWithFormat:@"There was an error while creating the document at:\n%@",sourceURL]), localError);
	}
	id node = [source rootElement];
	if(node = [node nextNode])
	{
		NSString * name = [node name];
		if([name isEqualToString:@"LIST"])
		{
			if(node = [node nextNode])
			{
				NSString * name = [node name];
				if([name isEqualToString:@"ITEM"])
				{
					NSMutableDictionary * D = [NSMutableDictionary dictionary];
					id keyAttribute = [node attributeForName:@"KEY"];
					NSString * K = [keyAttribute stringValue];
					while(node = [node nextNode])
					{
						NSString * name = [node name];
						if([name isEqualToString:@"NAME"])
						{
							[D setObject:[node stringValue] forKey:@"Name"];
						}
						else if([name isEqualToString:@"DESC"])
						{
							[D setObject:[node stringValue] forKey:@"Description"];
						}
						else if([name isEqualToString:@"TIP"])
						{
							[D setObject:[node stringValue] forKey:@"Tooltip"];
						}
						else if([name isEqualToString:@"ITEM"])
						{
							[locales setObject:D forKey:K];
							D = [NSMutableDictionary dictionary];
							keyAttribute = [node attributeForName:@"KEY"];
							K = [keyAttribute stringValue];
						}
					}
					[locales setObject:D forKey:K];
				}
			}
		}
	}
//iTM2_END;
	return;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexWithContentsOfFile:
- (id)indexWithContentsOfFile:(NSString*)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	*outErrorPtr = nil;
	NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] options:0 error:outErrorPtr] autorelease];
	if(*outErrorPtr)
	{
		return nil;
	}
	else
	{
		// parse the doc
		NSXMLElement * element = [xmlDoc rootElement];
		if([[element name] isEqualToString:@"LIST"])
		{
			NSString * prefixKey = [[element attributeForName:@"KEY"] stringValue]?:@"";
			NSMutableDictionary * result = [NSMutableDictionary dictionary];
			NSEnumerator * E = [[element elementsForName:@"ITEM"] objectEnumerator];
			while(element = [E nextObject])
			{
				[result setObject:element forKey:[NSString stringWithFormat:@"%@%@", prefixKey, [[element attributeForName:@"KEY"] stringValue]]];
			}
			return result;
		}
		else
		{
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"The root element must be a LIST node\n%@",path]),nil);
		}
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macrosIndexWithContentsOfFile:error:
- (id)macrosIndexWithContentsOfFile:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	* outErrorPtr = nil;
	NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] options:0 error:outErrorPtr] autorelease];
	if(* outErrorPtr)
	{
		return nil;
	}
	else if(xmlDoc)
	{
		NSXMLElement * element = [xmlDoc rootElement];
		if([[element name] isEqualToString:@"LIST"])
		{
			NSString * base = [path stringByDeletingPathExtension];
			NSMutableDictionary * result = [NSMutableDictionary dictionary];
			NSString * prefixKey = [[element attributeForName:@"KEY"] stringValue]?:@"";
			NSEnumerator * E = [[element elementsForName:@"ITEM"] objectEnumerator];
			while(element = [E nextObject])
			{
				NSString * P = [element stringValue];
				if([P hasPrefix:@"."])
				{
					P = [base stringByAppendingPathComponent:P];
				}
				[result setObject:P forKey:[NSString stringWithFormat:@"%@%@", prefixKey, [[element attributeForName:@"KEY"] stringValue]]];
			}
			return result;
		}
		else if(outErrorPtr)
		{
			*outErrorPtr = [NSError errorWithDomain:@"iTM2MacrosKit" code:2 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"Bad file format", NSLocalizedDescriptionKey,
					@"The root element must be a LIST node", NSLocalizedFailureReasonErrorKey,
					@"Reinstall and report bug if this does not solve thee problem", NSLocalizedRecoverySuggestionErrorKey,
					[NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,
					path, NSFilePathErrorKey,
						nil]];
		}
	}
//iTM2_END;
	return nil;
}
#pragma mark -
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
	if([name isEqualToString:@"LIST"])
	{
		NSString * prefix = [[element attributeForName:@"KEY"] stringValue];
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
		NSString * key = [[element attributeForName:@"KEY"] stringValue];
		context = [[element attributeForName:@"CONT"] stringValue]?:context;
		category = [[element attributeForName:@"CAT"] stringValue]?:category;
		domain = [[element attributeForName:@"DOM"] stringValue]?:domain;
		NSString * toolTip = [[[element elementsForName:@"TIP"] lastObject] stringValue];
		NSString * name = [[[element elementsForName:@"NAME"] lastObject] stringValue];
		if(![name length])
		{
			name = [self macroLocaleOfType:@"Name" forKey:key context:context ofCategory:category inDomain:domain];
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle: name action: NULL keyEquivalent: @""] autorelease];
		if([key length])
		{
			[MI setRepresentedObject:[NSArray arrayWithObjects:key, context, category, domain, nil]];
			[MI setTarget:self];
			[MI setAction:@selector(___insertMacro:)];
		}
		[MI setToolTip:toolTip];
		id list = [[element elementsForName:@"LIST"] lastObject];
		NSMenu * M = [self macroMenuWithXMLElement:list forContext:context ofCategory:category inDomain:domain error:outErrorPtr];
		[MI setSubmenu:M];
		return MI;
	}
	else
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosSummaries
- (void)loadMacrosSummaries;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(!_iTM2_MacroServer_Data)
		_iTM2_MacroServer_Data = [[NSMutableDictionary dictionary] retain];
	// read the built in stuff
	// inside frameworks then bundles.
	NSArray * frameworks = [NSBundle allFrameworks];
	NSMutableArray * plugins = [NSMutableArray arrayWithArray:[NSBundle allBundles]];
	[plugins removeObjectsInArray:frameworks];// plugins are bundles
	NSBundle * mainBundle = [NSBundle mainBundle];
	[plugins removeObject:mainBundle];// plugins are bundles, except the main one
	// sorting the frameworks and plugins
	// separating them according to their domain
	NSString * networkPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSNetworkDomainMask create:NO];
	networkPrefix = [networkPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * localPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSLocalDomainMask create:NO];
	localPrefix = [localPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * userPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSUserDomainMask create:NO];
	userPrefix = [userPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	
	NSMutableArray * networkFrameworks = [NSMutableArray array];
	NSMutableArray * localFrameworks = [NSMutableArray array];
	NSMutableArray * userFrameworks = [NSMutableArray array];
	NSMutableArray * otherFrameworks = [NSMutableArray array];
	NSEnumerator * E = [frameworks objectEnumerator];
	NSBundle * B = nil;
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userFrameworks addObject:B];
		else if([P hasPrefix:localPrefix])
			[localFrameworks addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkFrameworks addObject:B];
		else
			[otherFrameworks addObject:B];
	}
	NSMutableArray * networkPlugIns = [NSMutableArray array];
	NSMutableArray * localPlugIns = [NSMutableArray array];
	NSMutableArray * userPlugIns = [NSMutableArray array];
	NSMutableArray * otherPlugIns = [NSMutableArray array];
	E = [plugins objectEnumerator];
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userPlugIns addObject:B];
		else if([P hasPrefix:localPrefix])
			[localPlugIns addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkPlugIns addObject:B];
		else
			[otherPlugIns addObject:B];
	}
	// load
	#define RELOAD(ARRAY)\
	E = [ARRAY objectEnumerator];\
	while(B = [E nextObject]) [self loadMacrosSummariesAtPath:[B pathForResource:iTM2MacroServerComponent ofType:nil]];
	RELOAD(otherFrameworks);
	RELOAD(otherPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForResource:iTM2MacroServerComponent ofType:nil]];
	RELOAD(networkFrameworks);
	RELOAD(networkPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSNetworkDomainMask create:NO]];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSLocalDomainMask create:NO]];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:YES]];
	#undef RELOAD
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosSummaryAtPath:
- (void)loadMacrosSummaryAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;NSNotFound
	NSArray * components = [path pathComponents];
	int index = [components indexOfObject:iTM2MacroServerComponent];
	if(index==NSNotFound)
	{
		return;
	}
	NSString * domain = @"";
	NSString * category = @"";
	NSString * context = @"";
	if(++index < [components count]-1)
	{
		domain = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		category = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		context = [components objectAtIndex:index];
	}
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category inDomain:domain];
	NSMutableDictionary * URLs = [MD objectForKey:@"./URLs"];
	if(!URLs)
	{
		URLs = [NSMutableDictionary dictionary];
		[MD setObject:URLs forKey:@"./URLs"];
	}
	NSMutableDictionary * CUTs = [MD objectForKey:@"./CUTs"];
	if(!CUTs)
	{
		CUTs = [NSMutableDictionary dictionary];
		[MD setObject:URLs forKey:@"./CUTs"];
	}
	NSURL * sourceURL = [NSURL fileURLWithPath:path];
	path = [path stringByDeletingLastPathComponent];
	NSURL * URL = [NSURL fileURLWithPath:path];
	NSError * localError = nil;
	NSXMLDocument * source = [[[NSXMLDocument alloc] initWithContentsOfURL:sourceURL options:0 error:&localError] autorelease];
	if(localError)
	{
		iTM2_REPORTERROR(1,(@"There was an error while creating the document"), localError);
	}
	id node = [source rootElement];
	if(node = [node nextNode])
	{
		NSString * name = [node name];
		if([name isEqualToString:@"LIST"])
		{
			while(node = [node nextNode])
			{
				NSString * name = [node name];
				if([name isEqualToString:@"ITEM"])
				{
					id keyAttribute = [node attributeForName:@"KEY"];
					[URLs setObject:URL forKey:[keyAttribute stringValue]];
				}
				else if([name isEqualToString:@"CUTS"])
				{
					while(node = [node nextNode])
					{
						NSString * name = [node name];
						if([name isEqualToString:@"CUT"])
						{
							id keyAttribute = [node attributeForName:@"KEY"];
							id cutAttribute = [node attributeForName:@"CUT"];
							[URLs setObject:[keyAttribute stringValue] forKey:[cutAttribute stringValue]];
						}
					}
				}
			}
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosSummariesAtPath:
- (void)loadMacrosSummariesAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(![path length])
		return;
	if(!_iTM2_MacroServer_Data)
		_iTM2_MacroServer_Data = [[NSMutableDictionary dictionary] retain];
	iTM2_INIT_POOL;
//iTM2_START;
	// We find all the Summary.xml files inside
	// then read them and append the result to the server data base.
	NSString * summary = [path stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
	summary = [summary stringByAppendingPathExtension:@"xml"];
	if([DFM fileExistsAtPath:summary])
	{
		[self loadMacrosSummaryAtPath:summary];
	}
	NSEnumerator * domainE = [[DFM directoryContentsAtPath:path] objectEnumerator];
	NSString * domain;
	while(domain = [domainE nextObject])
	{
		domain = [path stringByAppendingPathComponent:domain];
		// is it a directory?
		BOOL isDirectory = NO;
		if([DFM fileExistsAtPath:domain isDirectory:&isDirectory] && isDirectory)
		{
			summary = [domain stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
			summary = [summary stringByAppendingPathExtension:@"xml"];
			if([DFM fileExistsAtPath:summary])
			{
				[self loadMacrosSummaryAtPath:summary];
			}
			NSEnumerator * categoryE = [[DFM directoryContentsAtPath:domain] objectEnumerator];
			NSString * category;
			while(category = [categoryE nextObject])
			{
				category = [domain stringByAppendingPathComponent:category];
				// is it a directory?
				BOOL isDirectory = NO;
				if([DFM fileExistsAtPath:category isDirectory:&isDirectory] && isDirectory)
				{
					summary = [category stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
					summary = [summary stringByAppendingPathExtension:@"xml"];
					if([DFM fileExistsAtPath:summary])
					{
						[self loadMacrosSummaryAtPath:summary];
					}
					NSEnumerator * contextE = [[DFM directoryContentsAtPath:category] objectEnumerator];
					NSString * context;
					while(context = [contextE nextObject])
					{
						context = [category stringByAppendingPathComponent:context];
						// is it a directory?
						BOOL isDirectory = NO;
						if([DFM fileExistsAtPath:context isDirectory:&isDirectory] && isDirectory)
						{
							summary = [category stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
							summary = [summary stringByAppendingPathExtension:@"xml"];
							if([DFM fileExistsAtPath:summary])
							{
								[self loadMacrosSummaryAtPath:summary];
							}
						}
					}
				}
			}
		}
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
@end

@interface NSTextView(PRIVATE)
- (IBAction)selectFirstPlaceholder:(id)sender;
@end

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
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:NSMaxRange(selectedRange) cycle:YES tabAnchor:tabAnchor];
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
            __PRETTY_FUNCTION__, argument];
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
            __PRETTY_FUNCTION__, argument];
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
            __PRETTY_FUNCTION__, argument];
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
            __PRETTY_FUNCTION__, argument];
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
