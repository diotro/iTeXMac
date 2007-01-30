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

NSString * const iTM2TextMarkPlaceholder = @"__";
NSString * const iTM2TextStartPlaceholder = @"__(";
NSString * const iTM2TextStopPlaceholder = @")__";
NSString * const iTM2TextStartINSPlaceholder = @"__(INS:";
NSString * const iTM2TextStartARGPlaceholder = @"__(ARG:";
NSString * const iTM2TextStartOPTPlaceholder = @"__(OPT:";
NSString * const iTM2TextStartTEXTPlaceholder = @"__(TEXT:";
NSString * const iTM2TextStartFILEPlaceholder = @"__(FILE:";
NSString * const iTM2TextStartTIPPlaceholder = @"__(TIP:";
NSString * const iTM2TextStartSELPlaceholder = @"__(SEL:";
NSString * const iTM2TextINSPlaceholder = @"__(INS:)__";
NSString * const iTM2TextSELPlaceholder = @"__(SEL:)__";// out of use with perl support
NSString * const iTM2TextTABPlaceholder = @"__(TAB)__";

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

NSString * const iTM2MacroServerComponent = @"Macros.localized";
NSString * const iTM2MacroServerSummaryComponent = @"Summary";
NSString * const iTM2MacrosDirectoryName = @"Macros";
NSString * const iTM2MacrosPathExtension = @"iTM2-macros";


@interface iTM2MacroRootNode: iTM2TreeNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
@end

@implementation iTM2MacroRootNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
{
	return [self objectInChildrenWithValue:domain forKeyPath:@"value.domain"];
}
@end

@interface iTM2MacroDomainNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent domain:(NSString *)domain;
- (id)objectInChildrenWithCategory:(NSString *)category;
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
@end

@implementation iTM2MacroContextNode: iTM2TreeNode
- (id)initWithParent:(iTM2TreeNode *)parent context:(NSString *)context;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:context forKeyPath:@"value.context"];
	}
	return self;
}
- (id)objectInChildrenWithID:(NSString *)ID;
{
	return [self objectInChildrenWithValue:ID forKeyPath:@"value.ID"];
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
	NSArray * nodes = [element nodesForXPath:@"ARG" error:&localError];
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
@end

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@interface iTM2MacroController(PRIVATE)
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
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
			iTM2_LOG(@"[leafNode countOfChildren]:%i",[leafNode countOfChildren]);
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
		iTM2MacroLeafNode * leafNode = [[iTM2MacroController sharedMacroController] macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
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
			if(!leafNode || action == @selector(noop:) || !action && ![leafNode argument])
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
			[[iTM2MacroController sharedMacroController] executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain substitutions:nil target:nil];
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
	SEL action = [leafNode action];
	if(!action)
	{
		action = NSSelectorFromString(@"insertMacro:");
	}
	id argument = [leafNode argument];
	if([substitutions count])
	{
		argument = [[argument mutableCopy] autorelease];
		NSEnumerator * E = [substitutions keyEnumerator];
		NSString * old;
		while(old = [E nextObject])
		{
			NSString * new = [substitutions objectForKey:old];
			NSRange searchRange = NSMakeRange(0,[argument length]);
			[argument replaceOccurrencesOfString:old withString:new options:nil range:searchRange];
		}
	}
	if([target respondsToSelector:action])
	{
		[target performSelector:action withObject:argument];
		return YES;
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
	NSString * key = [self macroDomainKey];
	[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
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
	NSString * key = [self macroCategoryKey];
	[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask];
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
	NSString * key = [self macroContextKey];
	[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask];
    return;
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
    return [self superview]?[[self superview] macroCategoryKey]:[[self window] macroCategoryKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self superview]?[[self superview] macroContextKey]:[[self window] macroContextKey];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self delegate]?[[self delegate] macroContextKey]:([self windowController]?[[self windowController] macroContextKey]:[super macroContextKey]);
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self document]?[[self document] macroContextKey]:[super macroContextKey];
}
@end

@implementation NSResponder(iTM2MacroKit)
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self nextResponder]?[[self nextResponder] macroContextKey]:[super macroContextKey];
}
@end

@implementation iTM2GenericScriptButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= menu
- (NSMenu *)menu;
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
	[self setMenu:[self menu]];
	[[self cell] setAutoenablesItems:YES];
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

#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2MainInstaller(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroKitCompleteInstallation
+ (void)iTM2MacroKitCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * path = [[self classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateMacrosHashTable.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
//		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
//		[TW addArgument:P];
		[TW addArgument:@"/Users"];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:YES];
		[TC setDeaf:YES];
		[TC start];
		[TC becomeStandalone];
	}
	else
	{
		iTM2_LOG(@"ERROR: bad configuration, bin/iTM2CreateMacrosHashTable.pl is missing");
	}
//iTM2_END;
	return;
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
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		// if this is a SEL placeholder, just remove the markers
		NSRange R;
		R = [S rangeOfString:iTM2TextStartSELPlaceholder options:NSAnchoredSearch range:selectedRange];
		if(R.length)
		{
			R = selectedRange;
			R.location += [iTM2TextStartSELPlaceholder length];
			R.length -= [iTM2TextStopPlaceholder length] + [iTM2TextStartSELPlaceholder length];
			NSString * replacement = [S substringWithRange:R];
			[self insertText:replacement];
			selectedRange.length = 0;
		}
		else
		{
			[self insertText:@""];
			selectedRange.length = 0;
		}
	}
	markRange = [S rangeOfPlaceholderFromIndex:0 cycle:NO tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
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
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		// if this is a SEL placeholder, just remove the markers
		NSRange R;
		R = [S rangeOfString:iTM2TextStartSELPlaceholder options:NSAnchoredSearch range:selectedRange];
		if(R.length)
		{
			R = selectedRange;
			R.location += [iTM2TextStartSELPlaceholder length];
			R.length -= [iTM2TextStopPlaceholder length] + [iTM2TextStartSELPlaceholder length];
			NSString * replacement = [S substringWithRange:R];
			[self insertText:replacement];
			selectedRange.length = 0;
		}
		else
		{
			[self insertText:@""];
			selectedRange.length = 0;
		}
	}
	markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
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
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		// if this is a SEL placeholder, just remove the markers
		NSRange R;
		R = [S rangeOfString:iTM2TextStartSELPlaceholder options:NSAnchoredSearch range:selectedRange];
		if(R.length)
		{
			R = selectedRange;
			R.location += [iTM2TextStartSELPlaceholder length];
			R.length -= [iTM2TextStopPlaceholder length] + [iTM2TextStartSELPlaceholder length];
			NSString * replacement = [S substringWithRange:R];
			[self insertText:replacement];
			selectedRange.length = 0;
		}
		else
		{
			[self insertText:@""];
			selectedRange.length = 0;
		}
	}
	markRange = [S rangeOfPlaceholderToIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectINSPlaceholders:
- (IBAction)selectINSPlaceholders:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * selectedRanges = [NSMutableArray array];
	NSValue * V;
	NSRange R;
	unsigned index = 0;
	NSString * string = [self string];
	NSString * replacementString;
next:
	R = [string rangeOfINSPlaceholderFromIndex:index getTemplate:&replacementString];
	if(R.length)
	{
		if([self shouldChangeTextInRange:R replacementString:replacementString])
		{
			[self replaceCharactersInRange:R withString:replacementString];
			R.length = [replacementString length];
			[self didChangeText];
		}
		V = [NSValue valueWithRange:R];
		[selectedRanges addObject:V];
		index = NSMaxRange(R);
		goto next;
	}
	[self setSelectedRanges:selectedRanges];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextTabAnchor:
- (void)selectNextTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [self string];
    int anchor = NSMaxRange([self selectedRange]);
    NSString * anchorString = [self tabAnchor];
    NSRange foundRange = [S rangeOfString:anchorString options:0 range:NSMakeRange(anchor, [S length]-anchor)];
    if(!foundRange.length)
        foundRange = [S rangeOfString:anchorString options:0
                            range: NSMakeRange(0, MIN([S length], anchor + [anchorString length]-1))];
    if(!foundRange.length)
    {
        foundRange = NSMakeRange(NSMaxRange([self selectedRange]), 0);
        [self postNotificationWithToolTip:
            [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"No %@ tab anchor found.",
                @"TeX", [NSBundle bundleForClass:[self class]],
                    @"Status displayed when navigating within tab anchors."), anchorString]];
        iTM2Beep();
        [self setSelectedRange:NSMakeRange(anchor, 0)];
    }
    else
        [self setSelectedRange:foundRange];
    [self scrollRangeToVisible:foundRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextTabAnchorAndDelete:
- (void)selectNextTabAnchorAndDelete:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/21/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self selectNextTabAnchor:sender];
    if([self selectedRange].length) [self deleteBackward:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousTabAnchorAndDelete:
- (void)selectPreviousTabAnchorAndDelete:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/21/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self selectPreviousTabAnchor:sender];
    if([self selectedRange].length) [self deleteBackward:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousTabAnchor:
- (void)selectPreviousTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [self string];
    int anchor = [self selectedRange].location;
    NSString * anchorString = [self tabAnchor];
    NSRange foundRange = [S rangeOfString:anchorString options:NSBackwardsSearch
                                range: NSMakeRange(0, anchor)];
    if(!foundRange.length)
    {
        anchor = (anchor < [iTM2TextTABPlaceholder length])? 0:anchor-[anchorString length] + 1;
        foundRange = [S rangeOfString:anchorString options:NSBackwardsSearch
                            range: NSMakeRange(anchor, [S length]-anchor)];
    }
    if(!foundRange.length)
    {
        foundRange = NSMakeRange([self selectedRange].location, 0);
        [self postNotificationWithToolTip:
            [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"No %@ tab anchor found.",
                @"TeX", [NSBundle bundleForClass:[self class]],
                    @"Status displayed when navigating within tab anchors."), anchorString]];
        iTM2Beep();
    }
    [self setSelectedRange:foundRange];
    [self scrollRangeToVisible:foundRange];
    return;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:
- (void)insertMacro:(id)argument;
/*"Description forthcoming. argument is either a dictionary with strings for keys "before", "selected" and "after" or a string playing the role of before keyed object (the other strings are blank). When the argument is a NSMenuItem (or so) we add a pretreatment replacing the argument by its represented object.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self insertMacro:argument tabAnchor:[self tabAnchor]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:tabAnchor:
- (void)insertMacro:(id)argument tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming. argument is either a dictionary with strings for keys "before", "selected" and "after" or a string playing the role of before keyed object (the other strings are blank). When the argument is a NSMenuItem (or so) we add a pretreatment replacing the argument by its represented object.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
     if(!tabAnchor)
        tabAnchor = @"";
    if([argument conformsToProtocol:@protocol(NSMenuItem)])
        argument = [argument representedObject];
// this new part concerns the new macro design. 2006
    if([argument isKindOfClass:[NSString class]])
	{
//iTM2_LOG(@"argument:%@",argument);
		NSRange selectedRange = [self selectedRange];
		NSString * S = [self string];
		int numberOfSpacesPerTab = [self numberOfSpacesPerTab];
		unsigned indentationLevelAtInsertLocation = [S indentationLevelAtIndex:selectedRange.location withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		
		argument = [argument stringByRemovingTipPlaceHolders];
		argument = [argument stringByNormalizingIndentationWithNumberOfSpacesPerTab:numberOfSpacesPerTab];

		NSMutableString * replacementString = [NSMutableString string];
		
		// auxiliary variables
		NSString * string;
		NSRange range;
		NSRange searchRange, SELRange;
		NSArray * components;
		NSEnumerator * E;
		unsigned currentIndentation;
		NSString * line;
		
		searchRange.location = 0;
		searchRange.length = [argument length];
		if(selectedRange.length)
		{
			// we must ignore the __(SEL:template)___
			SELRange = [argument rangeOfSELPlaceholderFromIndex:searchRange.location getTemplate:nil];
			if(SELRange.length)
			{
				// prepare the selection
				NSString * selectedString = [S substringWithRange:selectedRange];// this will not move!
				selectedString = [NSString stringWithFormat:@"%@%@%@",iTM2TextStartSELPlaceholder,selectedString,iTM2TextStopPlaceholder];
				NSArray * selectedLines = [selectedString lineComponents];
				
				// first copy what is before the SEL placeholder
				// we start with full lines
				string = [argument substringToIndex:SELRange.location];
				// split into lines
				// copy each line of this head string managing indentation properly
				
nextSELRange:
				components = [string lineComponents];
				E = [components objectEnumerator];
				currentIndentation = indentationLevelAtInsertLocation;
				line = [E nextObject];// there is at least one object
				[replacementString appendString:line];
//iTM2_LOG(@"replacementString:%@",replacementString);
				// the other lines have special indentation
				while(line = [E nextObject])
				{
					unsigned relativeIndentation = [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
					// this is the actual level
					// this is what we would have if the macro were inserted exactly at the left margin
					currentIndentation = indentationLevelAtInsertLocation+relativeIndentation;
					line = [line stringWithIndentationLevel:currentIndentation atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
					[replacementString appendString:line];
//iTM2_LOG(@"replacementString:%@",replacementString);
				}
				// all the lines have been inserted
				// now we insert the selection, adding the current indentation
				E = [selectedLines objectEnumerator];
				line = [E nextObject];
				[replacementString appendString:line];
//iTM2_LOG(@"replacementString:%@",replacementString);
				// the other lines have special indentation
				while(line = [E nextObject])
				{
					unsigned relativeIndentation = [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
					// this is the actual level
					// this is what we would have if the macro were inserted exactly at the left margin
					unsigned localIndentation = currentIndentation+relativeIndentation;
					line = [line stringWithIndentationLevel:localIndentation atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
					[replacementString appendString:line];
//iTM2_LOG(@"replacementString:%@",replacementString);
				}
				// then we append the remaining part of the argument
				// there might be other selection placeholders
				searchRange.location = NSMaxRange(SELRange);
				searchRange.length = [argument length] - searchRange.location;
				SELRange = [argument rangeOfSELPlaceholderFromIndex:searchRange.location getTemplate:nil];
				if(SELRange.length)
				{
					// first copy what is before the SEL placeholder
					range = searchRange;
					range.length = SELRange.location - searchRange.location;
					string = [argument substringWithRange:range];
					goto nextSELRange;
				}
				argument = [argument substringFromIndex:searchRange.location];
			}
		}
		//
//iTM2_LOG(@"replacementString:%@",replacementString);
		components = [argument lineComponents];
		E = [components objectEnumerator];
		line = [E nextObject];// there is at least one object
		[replacementString appendString:line];
		// the other lines have special indentation
		while(line = [E nextObject])
		{
			unsigned relativeIndentation = [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
			// this is the actual level
			// this is what we would have if the macro were inserted exactly at the left margin
			currentIndentation = indentationLevelAtInsertLocation+relativeIndentation;
			line = [line stringWithIndentationLevel:currentIndentation atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
			[replacementString appendString:line];
		}
//iTM2_LOG(@"replacementString:%@",replacementString);
		[replacementString appendString:iTM2TextTABPlaceholder];
		NSMutableArray * selectedRanges = [NSMutableArray array];
		unsigned index = 0;
		while(index<[replacementString length])
		{
			NSString * template;
			range = [argument rangeOfINSPlaceholderFromIndex:index getTemplate:&template];
			if(range.length)
			{
				[replacementString replaceCharactersInRange:range withString:template];
				range.length = [template length];
				NSValue * V = [NSValue valueWithRange:range];
				[selectedRanges addObject:V];
				index += range.length;
			}
			else
			{
				break;
			}
		}
		if([self shouldChangeTextInRange:selectedRange replacementString:replacementString])
		{
			[self replaceCharactersInRange:selectedRange withString:replacementString];
			[self didChangeText];
			if([selectedRanges count])
			{
				[self setSelectedRanges:selectedRanges];
			}
			else
			{
				range = NSMakeRange(selectedRange.location+[replacementString length],0);
				[self selectFirstPlaceholder:self];
			}
		}
		return;
	}
#if 0
	{
		// Get the indentation level at the line where we are going to insert things
		// we record this level and we will propagate it if the insterted material
		// spans on many lines
		// the indentation level is an integer specifying how many _Tab's are used to indent
		// We get the extent of the contents of the line
		unsigned start, contentsEnd, end;
		NSRange R = selectedRange;
		R.length = 0;
		[S getLineStart:&start end:nil contentsEnd:&contentsEnd forRange:R];
		
		// get the indentation in the original selected string, starting at the second line
		// then split the selection into lines in order to manage the indentation
		// ensuring that the white prefix is of the apropriate format
		// the indentation comes from the selected text and also from the macro itself
		// if the selection should be inserted in an indented place,
		// indentation should be fixed accordingly
		NSMutableArray * replacementLines = [NSMutableArray array];
		// replacementLines will hold the selection split into lines
		// each line has a proper indentation relative to the first line of the text where the selection starts
		// except the first line which will be inserted continuously in the text
		R = NSMakeRange(0,0);
		[_OriginalSelectedString getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
		// now R.location is the first index of the second line
		NSString * blackString = [_OriginalSelectedString substringWithRange:NSMakeRange(0,R.location)];
		blackString = [iTM2TextStartSELPlaceholder stringByAppendingString:blackString];
		[replacementLines addObject:blackString];
		// now, the first object is the first line of the selection
		// we prepended the iTM2TextStartSELPlaceholder, the stop placeholder will be appended to the last replacement line
		// for the rest of the selection, we just record the white prefix and black line content
		// the white prefix is a level of indentation
		NSMutableArray * whitePrefixes = [NSMutableArray array];
		NSMutableArray * blackStrings = [NSMutableArray array];
		unsigned indentationOfTheSelectedString = 0;
		NSNumber * N;
		unsigned lineIndentation = 0;
		if(R.location < [_OriginalSelectedString length])
		{
			
			indentationOfTheSelectedString = UINT_MAX;// it will decrease as there is a second line
			do
			{
				[_OriginalSelectedString getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
				lineIndentation = 0;
				while(R.location<contentsEnd)
				{
					theChar = [_OriginalSelectedString characterAtIndex:R.location++];
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
				}
				lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
				if(lineIndentation<indentationOfTheSelectedString)
				{
					indentationOfTheSelectedString = lineIndentation;
				}
				N = [NSNumber numberWithUnsignedInt:lineIndentation];
				[whitePrefixes addObject:N];
				blackString = [_OriginalSelectedString substringWithRange:NSMakeRange(R.location,end-R.location)];
				[blackStrings addObject:blackString];
				R.location = end;
			}
			while(R.location < [_OriginalSelectedString length]);
		}
		else
		{
			// there was no second line in the selection
			// R.location == [_OriginalSelectedString length]
		}
		NSEnumerator * whiteE = [whitePrefixes objectEnumerator];
		NSEnumerator * blackE = [blackStrings objectEnumerator];
		while((N = [whiteE nextObject]) && (blackString = [blackE nextObject]))
		{
			lineIndentation = [N unsignedIntValue];
			if(lineIndentation>indentationOfTheSelectedString)
			{
				lineIndentation-=indentationOfTheSelectedString;
				NSMutableString * MS = [NSMutableString string];
				while(lineIndentation--)
				{
					[MS appendString:_Tab];
				}
				[MS appendString:blackString];
				[replacementLines addObject:MS];
			}
			else
			{
				[replacementLines addObject:blackString];
			}
		}
		blackString = [replacementLines lastObject];
		blackString = [blackString stringByAppendingString:iTM2TextStopPlaceholder];
		[replacementLines removeLastObject];
		[replacementLines addObject:blackString];
		// now the replacement lines are ready
		
		// let's work now on the soon inserted macro
		NSString * completion = argument;// this is the starting macro
		NSMutableString * longCompletionString = [NSMutableString string];// this is the resulting macro, once we have inserted the selection, indentation...
		// first we clean the white prefix, using only _Tab string
		R = NSMakeRange(0,0);
		[completion getLineStart:nil end:&R.location contentsEnd:nil forRange:R];// range of the first line
		blackString = [completion substringWithRange:NSMakeRange(0,R.location)];
		[longCompletionString appendString:blackString];
		if(R.location < [completion length])
		{
			do
			{
				[completion getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];// range of the next line
				lineIndentation = 0;
				currentLength = 0;
				while(R.location<contentsEnd)
				{
					theChar = [completion characterAtIndex:R.location++];
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
				}
				lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
				// we found the line indentation
				// now we normalize the white prefix:
				NSMutableString * whitePrefix = [NSMutableString string];
				while(lineIndentation--)
				{
					[whitePrefix appendString:_Tab];
				}
				NSMutableString * line = [NSMutableString stringWithString:whitePrefix];
				blackString = [completion substringWithRange:NSMakeRange(R.location,end-R.location)];
				
				NSRange searchRange = NSMakeRange(0,0);
				searchRange.length = [blackString length] - searchRange.location;
//				NSRange SELRange = [blackString rangeOfString:iTM2TextSELPlaceholder options:nil range:searchRange];
				NSRange SELRange;
				if([_OriginalSelectedString length])
				{
					SELRange = [blackString rangeOfSELPlaceholderFromIndex:searchRange.location template:nil];
				}
				else
				{
					NSString * template = @"";
					SELRange = [blackString rangeOfSELPlaceholderFromIndex:searchRange.location template:&template];
					replacementLines = [NSMutableArray array];

					if(R.location < [template length])
					{
						
						indentationOfTheSelectedString = UINT_MAX;// it will decrease as there is a second line
						do
						{
							[_OriginalSelectedString getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
							lineIndentation = 0;
							while(R.location<contentsEnd)
							{
								theChar = [_OriginalSelectedString characterAtIndex:R.location++];
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
							}
							lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
							if(lineIndentation<indentationOfTheSelectedString)
							{
								indentationOfTheSelectedString = lineIndentation;
							}
							N = [NSNumber numberWithUnsignedInt:lineIndentation];
							[whitePrefixes addObject:N];
							blackString = [_OriginalSelectedString substringWithRange:NSMakeRange(R.location,end-R.location)];
							[blackStrings addObject:blackString];
							R.location = end;
						}
						while(R.location < [_OriginalSelectedString length]);
					}
					else
					{
						// there was no second line in the selection
						// R.location == [_OriginalSelectedString length]
					}





					
				}
				if(SELRange.length)
				{
					// copy what is before the selection
					
					R = NSMakeRange(searchRange.location,SELRange.location-searchRange.location);
					NSString * s = [blackString substringWithRange:R];
					[line appendString:s];
					NSEnumerator * replacementE = [replacementLines objectEnumerator];
					s = [replacementE nextObject];
					[line appendString:s];
					while(s = [replacementE nextObject])
					{
						[line appendString:whitePrefix];
						[line appendString:s];
					}
next:
					searchRange.location = NSMaxRange(SELRange);
					if([blackString length]>searchRange.location)
					{
						searchRange.length = [blackString length] - searchRange.location;
						SELRange = [blackString rangeOfString:iTM2TextSELPlaceholder options:nil range:searchRange];
						if(SELRange.length)
						{
							s = [blackString substringWithRange:NSMakeRange(searchRange.location,SELRange.location-searchRange.location)];
							[line appendString:s];
							replacementE = [replacementLines objectEnumerator];
							s = [replacementE nextObject];
							[line appendString:s];
							while(s = [replacementE nextObject])
							{
								[line appendString:whitePrefix];
								[line appendString:s];
							}
							goto next;
						}
					}
				}
				else
				{
					[line appendString:blackString];
				}
				[longCompletionString appendString:line];
				R.location = end;
				R.length = 0;
			}
			while(R.location < [completion length]);
		}

		NSArray * components = [longCompletionString componentsSeparatedByINSPlaceholder];
		NSString * replacementString = [components componentsJoinedByString:@""];
		NSMutableArray * selectedRanges = [NSMutableArray array];
		NSEnumerator * E = [components objectEnumerator];
		NSString * component;
		R = selectedRange;
		NSValue * V = nil;
		while(component = [E nextObject])
		{
			R.location += [component length];
			R.length = 0;
			if(component = [E nextObject])
			{
				R.length = [component length];
				V = [NSValue valueWithRange:R];
				[selectedRanges addObject:V];
			}
			else
			{
				break;
			}
		}
		if(![selectedRanges count])
		{
			// is there any place holder?
			R = [replacementString rangeOfPlaceholderFromIndex:0 cycle:NO tabAnchor:tabAnchor];
			if(R.length)
			{
				if(NSMaxRange(R)<[replacementString length])
				{
					R.location = [replacementString length];
					replacementString = [replacementString stringByAppendingString:iTM2TextTABPlaceholder];
					R.length = [replacementString length] - R.location;
				}
			}
			else
			{
				R.location = [replacementString length];
				R.length = 0;
			}
			R.location += selectedRange.location;
			NSValue * V = [NSValue valueWithRange:R];
			[selectedRanges addObject:V];
		}
		// if the last placeholder is selected wherease there is a placeholder before, remove the corresponding selected range
		R = [replacementString rangeOfPlaceholderToIndex:[replacementString length] cycle:NO tabAnchor:tabAnchor];
		if(R.length)
		{
			if(R.location)
			{
				if([replacementString rangeOfPlaceholderToIndex:R.location-1 cycle:NO tabAnchor:tabAnchor].length)
				{
					R.location += selectedRange.location;
					V = [NSValue valueWithRange:R];
					if([selectedRanges containsObject:V])
					{
						[selectedRanges removeObject:V];
						R.location = NSMaxRange(R);
						R.length = 0;
						V = [NSValue valueWithRange:R];
						[selectedRanges addObject:V];
					}
				}
			}
		}
		if([self shouldChangeTextInRange:_SelectedRange replacementString:replacementString])
		{
			[self replaceCharactersInRange:_SelectedRange withString:replacementString];
			[self didChangeText];
			[self setSelectedRanges:selectedRanges];
		}
		return;
	}
#endif
	if([argument isKindOfClass:[NSArray class]])
	{
		NSEnumerator * E = [argument objectEnumerator];
		while(argument = [E nextObject])
		{
			[self insertMacro:argument tabAnchor:tabAnchor];
		}
	}
    NSLog(@"Don't know what to do with this argument: %@", argument);
//iTM2_END;
    return;
}
@end

@interface NSString(iTM2TextPlaceholder_PRIVATE)
- (NSRange)__rangeOfPlaceholderStartingAtIndex:(unsigned)index;
- (NSRange)__rangeOfPlaceholderEndingAtIndex:(unsigned)index;
@end

@implementation NSString(iTM2TextPlaceholder)
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingTipPlaceHolders
- (NSString *)stringByRemovingTipPlaceHolders;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [self rangeOfString:iTM2TextStartTIPPlaceholder];
	if(R.length)
	{
		R = [self rangeOfPlaceholderAtIndex:R.location];
		NSRange r;
		r.location = NSMaxRange(R);
		r.length = [self length] - r.location;
		NSString * avant = [self substringWithRange:r];
		r = NSMakeRange(0,R.location);
		NSString * apres = [self substringWithRange:r];
		avant = [avant length]? ([apres length]?[avant stringByAppendingString:apres]:avant):apres;
		return [avant stringByRemovingTipPlaceHolders];
	}
//iTM2_END;
	return self;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfINSPlaceholderFromIndex:getTemplate:
- (NSRange)rangeOfINSPlaceholderFromIndex:(unsigned int)index getTemplate:(NSString **)templateRef;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange searchRange = NSMakeRange(index,[self length]-index);
	NSRange result = [self rangeOfString:iTM2TextStartINSPlaceholder options:nil range:searchRange];
	if(result.length)
	{
		result = [self __rangeOfPlaceholderStartingAtIndex:result.location];
		if(result.length)
		{
			if(templateRef)
			{
				NSRange R = result;
				R.location += [iTM2TextStartINSPlaceholder length];
				R.length -= [iTM2TextStartINSPlaceholder length];
				R.length -= [iTM2TextStopPlaceholder length];
				* templateRef = [self substringWithRange:R];
			}
		}
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfSELPlaceholderFromIndex:getTemplate:
- (NSRange)rangeOfSELPlaceholderFromIndex:(unsigned int)index getTemplate:(NSString **)templateRef;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange searchRange = NSMakeRange(index,[self length]-index);
	NSRange result = [self rangeOfString:iTM2TextStartSELPlaceholder options:nil range:searchRange];
	if(result.length)
	{
		result = [self __rangeOfPlaceholderStartingAtIndex:result.location];
		if(result.length)
		{
			if(templateRef)
			{
				NSRange R = result;
				R.location += [iTM2TextStartSELPlaceholder length];
				R.length -= [iTM2TextStartSELPlaceholder length];
				R.length -= [iTM2TextStopPlaceholder length];
				* templateRef = [self substringWithRange:R];
			}
		}
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingSELTemplates
- (NSString *)stringByRemovingSELTemplates;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * normalized = [NSMutableString string];
	NSRange SELRange, searchRange;
	NSString * S;
	searchRange.location = 0;
	searchRange.length = [self length];
nextSELRange:
	if(searchRange.location<[self length])
	{
		searchRange.length = [self length] - searchRange.location;
		SELRange = [self rangeOfString:iTM2TextStartSELPlaceholder options:nil range:searchRange];
		if(SELRange.length)
		{
			SELRange = [self rangeOfPlaceholderAtIndex:SELRange.location];
			if(SELRange.length)
			{
				[normalized appendString:iTM2TextSELPlaceholder];
				searchRange.location = NSMaxRange(SELRange);
				goto nextSELRange;
			}
			else
			{
				S = [self substringWithRange:searchRange];
				[normalized appendString:S];
			}
		}
		else
		{
			S = [self substringWithRange:searchRange];
			[normalized appendString:S];
		}
	}
//iTM2_END;
	return normalized;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceHolderMarks
- (NSString *)stringByRemovingPlaceHolderMarks;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self stringByRemovingTipPlaceHolders];
	NSArray * components = [S componentsSeparatedByINSPlaceholder];
	S = [components componentsJoinedByString:@""];
	NSMutableString * result = [[S mutableCopy] autorelease];
	[result replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:@"__(INS)__" withString:@"" options:0 range:NSMakeRange(0,[result length])];// compatibility
	[result replaceOccurrencesOfString:iTM2TextINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartSELPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartARGPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartOPTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartTEXTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartFILEPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStopPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= componentsSeparatedByINSPlaceholder
- (NSArray *)componentsSeparatedByINSPlaceholder;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [NSMutableArray array];
	NSRange searchRange = NSMakeRange(0,[self length]);
	NSRange foundRange, R, placeholderRange;
	NSString * S;
nextINS:
	foundRange = [self rangeOfString:iTM2TextStartINSPlaceholder options:nil range:searchRange];
	if(foundRange.length)
	{
		placeholderRange = [self rangeOfPlaceholderAtIndex:foundRange.location];
		if(placeholderRange.length)
		{
			R = searchRange;
			R.length = placeholderRange.location - R.location;
			S = [self substringWithRange:R];
			[result addObject:S];
			R = placeholderRange;
			R.location+=[iTM2TextStartINSPlaceholder length];
			R.length-=[iTM2TextStartINSPlaceholder length];
			S = [self substringWithRange:R];
			[result addObject:S];
			searchRange.location = NSMaxRange(placeholderRange);
			searchRange.length = [self length] - searchRange.location;
			goto nextINS;
		}
		else
		{
			iTM2_LOG(@"Inconsistent receiver with respect to macros:%@",self);
			foundRange.length = [self length] - foundRange.location;
			S = [self substringWithRange:foundRange];
			[result addObject:S];
			// finish
		}
	}
	else
	{
		S = [self substringWithRange:searchRange];
		[result addObject:S];
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceHolderMarksWithSelection:
- (NSString *)stringByRemovingPlaceHolderMarksWithSelection:(NSString *)selection;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [[[self stringByRemovingTipPlaceHolders] mutableCopy] autorelease];
	[result replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:@"__(INS)__" withString:@"" options:0 range:NSMakeRange(0,[result length])];// compatibility
	[result replaceOccurrencesOfString:iTM2TextINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];

	[result replaceOccurrencesOfString:iTM2TextStartINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartARGPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartOPTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartTEXTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartFILEPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];

	if([selection length])
	{
		//- (NSRange)rangeOfSELPlaceholderFromIndex:(unsigned int)index getTemplate:(NSString **)templateRef;

		selection = [NSString stringWithFormat:@"%@%@%@",iTM2TextStartSELPlaceholder,selection,iTM2TextStopPlaceholder];
		[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:selection options:0 range:NSMakeRange(0,[result length])];
	}
	else
	{
		[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	}
	[result replaceOccurrencesOfString:iTM2TextStartPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStopPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __rangeOfPlaceholderStartingAtIndex:
- (NSRange)__rangeOfPlaceholderStartingAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];
	unsigned length = [self length];
	unsigned depth = 1;
	unsigned idx;
	NSRange markR;
	NSRange searchRange;
	searchRange.location = index + 1;
nextMark:
	searchRange.length = length - searchRange.location;
	markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
	if(markR.length)
	{
		// stop or start?
		idx = NSMaxRange(markR);
		// is it a start?
		if(idx<length)
		{
			if([self characterAtIndex:idx] == startChar)
			{
				// it is a start place holder
				// we are getting deeper in placeholder grouping
				++depth;
			}
		}
		// is it a stop?
		if([self characterAtIndex:markR.location-1] == stopChar)
		{
			// is is a stop placeholder, get out
			if(--depth==0)
			{
				return NSMakeRange(index,NSMaxRange(markR)-index);
			}
		}
		// go to the next marker
		searchRange.location = NSMaxRange(markR);
		goto nextMark;
	}
//iTM2_END;
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __rangeOfPlaceholderEndingAtIndex:
- (NSRange)__rangeOfPlaceholderEndingAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];
	unsigned depth = 1;
	unsigned idx;
	NSRange markR;
	NSRange searchRange;
	searchRange.location = 0;
	searchRange.length = index;
previousMark:
	markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
	if(markR.length)
	{
		// stop or start?
		idx = NSMaxRange(markR);
		// is it a start?
		if([self characterAtIndex:idx] == startChar)
		{
			// is is a start placeholder, get out
			if(--depth==0)
			{
				return NSMakeRange(markR.location,index - markR.location);
			}
		}
		// is it a stop?
		if(markR.location)
		{
			if([self characterAtIndex:markR.location-1] == stopChar)
			{
				// it is a stop place holder
				// we are getting deeper in placeholder grouping
				++depth;
			}
		}
		// go to the previous marker
		searchRange.location = NSMaxRange(markR);
		goto previousMark;
	}
//iTM2_END;
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	if(index>=length)
	{
		return NSMakeRange(NSNotFound,0);
	}
	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];

	unsigned idx;
	unsigned top = UINT_MAX;
	
	NSRange searchRange = NSMakeRange(0,0);
	searchRange.location = index+1;
	
	NSRange markR;
	if(searchRange.location<length)
	{
		searchRange.length = length-searchRange.location;
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
		if(markR.length)
		{
			if(markR.location<top)
			{
				top = NSMaxRange(markR)-1;
			}
nextMark:
			// is it a start?
			idx = NSMaxRange(markR);
			if(idx<length)
			{
				if([self characterAtIndex:idx] == startChar)
				{
					markR = [self __rangeOfPlaceholderStartingAtIndex:markR.location];
					if(markR.length)
					{
						searchRange.location = NSMaxRange(markR);
						if(searchRange.location<length)
						{
							searchRange.length = length-searchRange.location;
							markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
							if(markR.length)
							{
								if(markR.location<top)
								{
									top = NSMaxRange(markR)-1;
								}
								goto nextMark;
							}
						}
					}
					// no closed placeholder range:
					return NSMakeRange(NSNotFound,0);
				}
			}
			// is it a stop?
			if(markR.location)
			{
				if([self characterAtIndex:markR.location-1] == stopChar)
				{
					// it is a stop placeholder
					// close this 
					markR = [self __rangeOfPlaceholderEndingAtIndex:top];// this is not the real top but it saves computational time
					if(markR.length)
					{
						searchRange.location = NSMaxRange(markR);
						return NSMakeRange(markR.location,idx-markR.location);
					}
					// no closed placeholder range:
					return NSMakeRange(NSNotFound,0);
				}
			}
		}
		else
		{
			// there is no placeholder range in [index+1,length]
			// the only possibility is to have a stop placeholder mark ending at index exactly
			searchRange.length = index;
			searchRange.location = 0;
			markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch|NSAnchoredSearch range:searchRange];
			if(markR.length)
			{
				return [self __rangeOfPlaceholderEndingAtIndex:index];
			}
		}
	}
//iTM2_END;
	return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderFromIndex:cycle:tabAnchor:
- (NSRange)rangeOfPlaceholderFromIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// next stop placeholder
	// preceding start placeholder
	// if the index is in an apropriate range, it's okay
	// start from the beginning if necessary
	NSRange stopR = NSMakeRange(NSNotFound,0);
	unsigned length = [self length];
	if(index>length)
	{
		return stopR;
	}
	NSRange searchRange = NSMakeRange(0,0);
	NSRange markR;
	// a TAB anchor?
	if([tabAnchor length])
	{
		searchRange.location = index;
		searchRange.length = length-searchRange.location;
		markR = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}

	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];

	unsigned idx;
	unsigned floor = 0;

	searchRange.location = MAX(index,2)-2;	
	searchRange.length = length-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		searchRange.location = floor;
		searchRange.length = stopR.location-searchRange.location;
previousMark:
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			// is it a start?
			idx = NSMaxRange(markR);// we do have idx < length!
			if([self characterAtIndex:idx]==startChar)
			{
				// it is a start place holder
				return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
			}
			// the first time, it can be a stop
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
nextStop:
				floor = NSMaxRange(stopR);
				searchRange.location = floor;
				searchRange.length = length-searchRange.location;
				stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
				if(stopR.length)
				{
					searchRange.location = floor;
					searchRange.length = stopR.location-searchRange.location;
morePreviousMark:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);// we do have idx < length!
						if([self characterAtIndex:idx]==startChar)
						{
							// it is a start place holder
							return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.length = markR.location-searchRange.location;
						goto morePreviousMark;
					}
					goto nextStop;
				}
				goto below;
			}
			searchRange.length = markR.location-searchRange.location;
			goto previousMark;
		}
		floor = NSMaxRange(stopR);
		searchRange.location = floor;
		goto nextStop;
	}
below:
	searchRange.length = length-searchRange.location;
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = 0;
	searchRange.length = index-searchRange.location;
	// a TAB anchor?
	if([tabAnchor length])
	{
		markR = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	searchRange.length = index-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		searchRange.length = stopR.location-searchRange.location;
previousMarkBefore:
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			// is it a start?
			idx = NSMaxRange(markR);
			if([self characterAtIndex:idx]==startChar)
			{
				// it is a start place holder
				return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
			}
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
nextStopBefore:
				searchRange.length = index-searchRange.location;
				stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
				if(stopR.length)
				{
					searchRange.length = stopR.location-searchRange.location;
morePreviousMarkBefore:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);
						if([self characterAtIndex:idx]==startChar)
						{
							// it is a start place holder
							return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.length = markR.location-searchRange.location;
						goto morePreviousMarkBefore;
					}
					searchRange.location = NSMaxRange(stopR);
					goto nextStopBefore;
				}
				goto final;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.length = markR.location-searchRange.location;
			goto previousMarkBefore;
		}
		searchRange.location = NSMaxRange(stopR);
		goto nextStopBefore;
	}
final:
	// If I reach this point, it means that I have not found any atomic placeholder
	// select the start and stop markers
	searchRange.location = MIN(length,MAX(index,2)-2);
	searchRange.length = length-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	NSRange startR = NSMakeRange(NSNotFound,0);
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:nil range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = 0;
	searchRange.length = index-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:nil range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderToIndex:cycle:tabAnchor:
- (NSRange)rangeOfPlaceholderToIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement NSBackwardsSearch
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// next stop placeholder
	// preceding start placeholder
	// if the index is in an apropriate range, it's okay
	// restart from the end if necessary
	NSRange startR = NSMakeRange(NSNotFound,0);
	unsigned length = [self length];
	if(index>length)
	{
		index = length;
	}
	NSRange searchRange = NSMakeRange(0,index);
	NSRange markR;
	// a TAB anchor?
	if([tabAnchor length])
	{
		markR = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	
	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder characterAtIndex:0];

	unsigned top = length;

	unsigned idx;
	
	searchRange.location = 0;
	searchRange.length = MIN(index+2,length);
	
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		searchRange.location = NSMaxRange(startR);
nextMark:
		searchRange.length = top-searchRange.location;
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
		if(markR.length)
		{
			// is it a stop?
			if([self characterAtIndex:markR.location-1]==stopChar)
			{
				// it is a stop place holder
				return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
			}
			// is it a start?
			idx = NSMaxRange(markR);
			if((idx < length) && ([self characterAtIndex:markR.location]==startChar))
			{
				searchRange.location = 0;
				top = startR.location;
				searchRange.length = top;
previousStart:
				startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
				if(startR.length)
				{
					searchRange.location = NSMaxRange(startR);
moreNextMark:
					searchRange.length = top-searchRange.location;
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
					if(markR.length)
					{
						// is it a stop?
						if([self characterAtIndex:markR.location-1]==stopChar)
						{
							// it is a stop place holder
							return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.location = NSMaxRange(markR);
						goto moreNextMark;
					}
					top = startR.location;
					searchRange.location = 0;
					searchRange.length = top;
					goto previousStart;
				}
				goto below;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.location = NSMaxRange(markR);
			goto nextMark;
		}
		top = startR.location;
		searchRange.location = 0;
		searchRange.length = top;
		goto previousStart;
	}
below:
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	// a TAB anchor?
	if([tabAnchor length])
	{
		searchRange.location = index;
		searchRange.length = length-index;
		markR = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	top = length;
	unsigned floor = MAX(index,2)-2;
	searchRange.location = floor;
	searchRange.length = top-searchRange.location;
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		searchRange.location = NSMaxRange(startR);
nextMarkAfter:
		searchRange.length = top-searchRange.location;// we do not want a stop after a different start
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
		if(markR.length)
		{
			// is it a stop?
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
				// it is a stop place holder
				return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
			}
			// is is a start
			idx = NSMaxRange(markR);
			if((idx < length) && ([self characterAtIndex:idx]==startChar))
			{
				searchRange.location = floor;
previousStartAfter:
				searchRange.length = top-searchRange.location;
				startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
				if(startR.length)
				{
					searchRange.location = NSMaxRange(startR);
moreNextMarkAfter:
					searchRange.length = top-searchRange.location;// we do not want a stop after a different start
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
					if(markR.length)
					{
						// is it a stop?
						if([self characterAtIndex:markR.location-1]==stopChar)
						{
							// it is a stop place holder
							return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.location = NSMaxRange(markR);
						goto moreNextMarkAfter;
					}
					top = startR.location;
					searchRange.location = floor;
					goto previousStartAfter;
				}
				goto final;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.location = NSMaxRange(markR);
			goto nextMarkAfter;
		}
		top = startR.location;
		searchRange.location = floor;
		goto previousStartAfter;
	}
final:
	// If I reach this point, it means that I have not found any atomic placeholder
	// select the start and stop markers
	searchRange.location = 0;	
	searchRange.length = floor;	
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	NSRange stopR = NSMakeRange(NSNotFound,0);
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:NSBackwardsSearch range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = floor;
	searchRange.length = length-searchRange.location;
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:NSBackwardsSearch range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	return NSMakeRange(NSNotFound,0);
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

