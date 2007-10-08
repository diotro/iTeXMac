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

#import "iTM2MacroKit_Controller.h"
#import "iTM2MacroKit_Tree.h"
#import "iTM2MacroKit_Model.h"

#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2MenuKit.h>

NSString * const iTM2MacroMenuPathExtension = @"iTM2-menu";
NSString * const iTM2MacrosDirectoryName = @"Macros";

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@interface iTM2MacroAbstractContextNode(Controller)
+ (id)treeWithContentsOfURLs;
@end

@implementation iTM2MacroAbstractContextNode(Controller)
+ (id)treeWithContentsOfURLs;
{
	NSString * requiredPathExtension = [self pathExtension];
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
										[[[self alloc] initWithParent:categoryNode context:component] autorelease];
							}
							else
							{
								component = @"";
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[self alloc] initWithParent:categoryNode context:component] autorelease];
							}
						}
						else
						{
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							contextNode = [categoryNode objectInChildrenWithContext:component]?:
									[[[self alloc] initWithParent:categoryNode context:component] autorelease];
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
								[[[self alloc] initWithParent:categoryNode context:component] autorelease];
					}
					subpath = [repository stringByAppendingPathComponent:subpath];
					NSURL * url = [NSURL fileURLWithPath:subpath];
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"url:%@",url);
					}
					[contextNode addURLPromise:url];
				}
			}
			[DFM popDirectory];
		}
	}
	return rootNode;
}
@end

@interface iTM2MacroController(PRIVATE)
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
+ (void)prefsInitBindings;
- (void)bindingsDealloc;
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
			[NSNumber numberWithInt:20],@"iTM2NumberOfRecentMacros",
                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
+ (void)initialize;
{
	[super initialize];
	NSDictionary * d = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:20], @"iTM2NumberOfRecentMacros",
			nil];
	[SUD registerDefaults:d];
	if([self respondsToSelector:@selector(prefsInitBindings)])
	{
		[self prefsInitBindings];
	}
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
- (void)dealloc;
{
	if([self respondsToSelector:@selector(bindingsDealloc)])
	{
		[self bindingsDealloc];
	}
	[super dealloc];
	return;
}
- (id)treeForContextNodeClass:(Class)aClass;
{
	NSString * requiredPathExtension = [aClass pathExtension];
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
					[contextNode addURLPromise:url];
				}
			}
			[DFM popDirectory];
		}
	}
	return rootNode;
}
#pragma mark =-=-=-=-=-  MACROS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroTree
- (id)macroTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	iTM2MacroRootNode * rootNode = [iTM2MacroContextNode treeWithContentsOfURLs];
	metaSETTER(rootNode);
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
	iTM2MacroList * macroList = [contextNode list];
	iTM2MacroNode * leafNode = [macroList objectInChildrenWithID:ID];
	if(!leafNode)
	{
		leafNode = [[[iTM2MacroNode alloc] init] autorelease];
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
	return nil;
}
#pragma mark =-=-=-=-=-  SAVE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveTree
- (void)saveTree:(id)node;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// for all the context nodes, save the XML document for the personal URL
	// node is either the macro tree or the key bindings tree
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
				children = [node honoredDocumentURLs];
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
							NSXMLDocument * document = [node documentForURL:url];
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
#pragma mark =-=-=-=-=-  BINDINGS
- (id)keyBindingTree;
{
	id result = metaGETTER;
	if(result)
	{
		return result;
	}
	iTM2MacroRootNode * rootNode = [iTM2KeyBindingContextNode treeWithContentsOfURLs];
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
#pragma mark =-=-=-=-=-  MENU
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
#pragma mark =-=-=-=-=-  MENU
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
		iTM2MacroNode * leafNode = [SMC macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
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
					[MI setTarget:self];// self is expected to last forever
				}
			}
			else
			{
				[MI setAction:@selector(___insertMacro:)];
				[MI setTarget:self];// self is expected to last forever
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
