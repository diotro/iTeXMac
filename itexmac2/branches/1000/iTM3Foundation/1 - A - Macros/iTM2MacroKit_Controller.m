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

#import "iTM2BundleKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2FileManagerKit.h"
#import "iTM2MenuKit.h"

#import "iTM2MacroKit.h"
#import "iTM2MacroKit_Action.h"
#import "iTM2MacroKit_Tree.h"
#import "iTM2MacroKit_Controller.h"

NSString * const iTM2MacroMenuPathExtension = @"iTM2-menu";
NSString * const iTM2MacrosDirectoryName = @"Macros";

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@interface iTM2MacroAbstractContextNode(Controller)
/*!
    @method     treeWithContentsOfURLs
    @abstract   The shallow part of the macros and key bindings trees.
    @discussion Only contains Domain, category and context level.
    @result     The running tree
*/
+ (id)treeWithContentsOfURLs;
@end

@implementation iTM2MacroAbstractContextNode(Controller)
+ (id)treeWithContentsOfURLs;
/*
Latest Revision: Sat Jan 30 09:49:05 UTC 2010
*/
{
	NSString * requiredPathExtension = self.pathExtension;
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained later
	// list all the *."requiredPathExtension" files
	// Create a Macros.localized in the Application\ Support folder as side effect
	NSBundle * MB = [NSBundle mainBundle];
    //  expected side effect in the following code
	[MB URLForSupportDirectory4iTM3:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:YES];
	for(NSURL * repositoryURL in [MB allURLsForResource4iTM3:iTM2MacrosDirectoryName withExtension:iTM2LocalizedExtension])	{
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"Scanning directory:%@",repositoryURL);
		}
		if (repositoryURL.isFileURL && [DFM pushDirectory4iTM3:repositoryURL.path]) {
			for (NSString * subpath in [DFM enumeratorAtPath:[DFM currentDirectoryPath]]) {
				NSString * extension = [subpath pathExtension];
				if ([extension pathIsEqual4iTM3:requiredPathExtension]) {
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
                    //  remove the last component
					[components removeLastObject];
					NSEnumerator * e = components.objectEnumerator;
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					id contextNode = nil;
					if ((component = [e nextObject])) {
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if ((component = [e nextObject])) {
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if ((component = [e nextObject])) {
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[self.alloc initWithParent:categoryNode context:component] autorelease];
							} else {
								component = @"";
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[self.alloc initWithParent:categoryNode context:component] autorelease];
							}
						} else {
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							contextNode = [categoryNode objectInChildrenWithContext:component]?:
									[[self.alloc initWithParent:categoryNode context:component] autorelease];
						}
					} else {
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						contextNode = [categoryNode objectInChildrenWithContext:component]?:
								[[self.alloc initWithParent:categoryNode context:component] autorelease];
					}
					NSURL * url = [repositoryURL URLByAppendingPathComponent:subpath];
					if (iTM2DebugEnabled) {
						LOG4iTM3(@"url:%@",url);
					}
					[contextNode addURLPromise:url];
				}
			}
			[DFM popDirectory4iTM3];
		}
	}
	return rootNode;
}
@end

@interface iTM2MacroController(PRIVATE)
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)RORef;
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)RORef;
+ (void)prefsInitBindings;
- (void)bindingsDealloc;
@end

@implementation iTM2MacroController

static id _iTM2MacroController = nil;

+ (void)initialize;
{
	[super initialize];
	NSDictionary * d = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInteger:20], @"iTM2NumberOfRecentMacros",
			nil];
	[SUD registerDefaults:d];
	if ([self respondsToSelector:@selector(prefsInitBindings)])
	{
		[self prefsInitBindings];
	}
	return;
}
+ (id)sharedMacroController;
{
	return _iTM2MacroController?:( _iTM2MacroController = [self.alloc init]);
}

- (id)init;
{
	if (_iTM2MacroController)
	{
		return [_iTM2MacroController retain];
	}
	else if ((self = [super init]))
	{
		[self setMacroTree:nil];
	}
	return _iTM2MacroController = self;
}
- (id)treeForContextNodeClass:(Class)aClass;
{
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"Start reading macros files...");
	}
	NSString * requiredPathExtension = [aClass pathExtension];
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained later
	// list all the *.iTM2-macros files
	// Create a Macros.localized in the Application\ Support folder as side effect
	NSBundle * MB = [NSBundle mainBundle];
    //  Expected side effect in the next line
	[MB URLForSupportDirectory4iTM3:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:YES];
	for (NSURL * repositoryURL in [MB allURLsForResource4iTM3:iTM2MacrosDirectoryName withExtension:iTM2LocalizedExtension]) {
		if (repositoryURL.isFileURL && [DFM pushDirectory4iTM3:repositoryURL.path]) {
			for (NSString * subpath in [DFM enumeratorAtPath:[DFM currentDirectoryPath]]) {
				NSString * extension = [subpath pathExtension];
				if ([extension pathIsEqual4iTM3:requiredPathExtension]) {
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = components.objectEnumerator;
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					id contextNode = nil;
					if ((component = [e nextObject])) {
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if ((component = [e nextObject])) {
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							if ((component = [e nextObject])) {
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
							} else {
								component = @"";
								contextNode = [categoryNode objectInChildrenWithContext:component]?:
										[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
							}
						} else {
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
							contextNode = [categoryNode objectInChildrenWithContext:component]?:
									[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
						}
					} else {
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						contextNode = [categoryNode objectInChildrenWithContext:component]?:
								[[[aClass alloc] initWithParent:categoryNode context:component] autorelease];
					}
					NSURL * url = [repositoryURL URLByAppendingPathComponent:subpath];
					if (iTM2DebugEnabled) {
						LOG4iTM3(@"macros registered at url:%@",url);
					}
					[contextNode addURLPromise:url];
				}
			}
			[DFM popDirectory4iTM3];
		}
	}
	return rootNode;
}
#pragma mark =-=-=-=-=-  MACROS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroTree
- (id)macroTree;
{
	id result = metaGETTER;
	if (result)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id old = metaGETTER;
	if ([old isEqual:aTree] || (old == aTree))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2MacroRootNode * rootNode = self.macroTree;
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
#pragma message NO context YET in macros
	context = @"";
	iTM2MacroContextNode * contextNode = [categoryNode objectInChildrenWithContext:context];
	iTM2MacroNode * macro = [[contextNode macros] objectForKey:ID];
	if (!macro)
	{
		macro = [[[iTM2MacroNode alloc] init] autorelease];
		[macro setMacroID:ID];
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"No macro with ID: %@ forContext:%@ ofCategory:%@ inDomain:%@",ID,context,category,domain);
			LOG4iTM3(@"[rootNode countOfChildren]:%i",[rootNode countOfChildren]);
			LOG4iTM3(@"[domainNode countOfChildren]:%i",[domainNode countOfChildren]);
			LOG4iTM3(@"[categoryNode countOfChildren]:%i",[categoryNode countOfChildren]);
			LOG4iTM3(@"[contextNode countOfChildren]:%i",[contextNode countOfChildren]);
		}
	}
//END4iTM3;
	return macro;
}
#pragma mark =-=-=-=-=-  SAVE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveTree
- (void)saveTree:(id)node;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// for all the context nodes, save the XML document for the personal URL
	// node is either the macro tree or the key bindings tree
	NSArray * children = [node children];
	NSEnumerator * E = children.objectEnumerator;
	while((node = [E nextObject]))
	{
		// now the domain level
		children = [node children];
		NSEnumerator * EE = children.objectEnumerator;
		while((node = [EE nextObject]))
		{
			// now the category level
			children = [node children];
			NSEnumerator * EEE = children.objectEnumerator;
			while((node = [EEE nextObject]))
			{
				// now the context level
				NSURL * url = [node personalURL];
				NSData * D = [node personalDataForSaving];
				if (D)
				{
					NSError * localError = nil;
					NSString * path = url.isFileURL?url.path:@"";
					NSString * dirname = path.stringByDeletingLastPathComponent;
					if (dirname.length && ![DFM createDirectoryAtPath:dirname withIntermediateDirectories:YES attributes:nil error:&localError])
					{
						REPORTERROR4iTM3(1,([NSString stringWithFormat:@"Could not create directory at %@",dirname]),localError);
					}
					else if (![D writeToURL:url options:NSAtomicWrite error:&localError])
					{
						REPORTERROR4iTM3(2,([NSString stringWithFormat:@"Could not write to %@",url]),localError);
					}
					[node update];
				}
			}
		}
	}
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  BINDINGS
- (id)keyBindingTree;
{
	id result = metaGETTER;
	if (result)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id old = metaGETTER;
	if ([old isEqual:aTree] || (old == aTree))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if (result)
	{
		return result;
	}
	// Create a Macros.localized in the Application\ Support folder as side effect
	NSBundle * MB = [NSBundle mainBundle];
    //  expected side effect in next line
	[MB URLForSupportDirectory4iTM3:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:YES];
	iTM2MacroRootNode * rootNode = [[[iTM2MacroRootNode alloc] init] autorelease];// this will be retained
	// list all the *.iTM2-macros files
	for (NSURL * repositoryURL in [MB allURLsForResource4iTM3:iTM2MacrosDirectoryName withExtension:iTM2LocalizedExtension]) {
		if (repositoryURL.isFileURL && [DFM pushDirectory4iTM3:repositoryURL.path]) {
			for (NSString * subpath in [DFM enumeratorAtPath:[DFM currentDirectoryPath]]) {
				NSString * extension = [subpath pathExtension];
				if ([extension pathIsEqual4iTM3:iTM2MacroMenuPathExtension]) {
					NSMutableArray * components = [[[subpath pathComponents] mutableCopy] autorelease];
					[components removeLastObject];
					NSEnumerator * e = components.objectEnumerator;
					NSString * component = nil;
					iTM2MacroDomainNode * domainNode = nil;
					iTM2MacroCategoryNode * categoryNode = nil;
					// for menus there are only two levels
					// no level for the context depth
					if ((component = [e nextObject])) {
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						if ((component = [e nextObject]))
						{
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						} else {
							component = @"";
							categoryNode = [domainNode objectInChildrenWithCategory:component]?:
									[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
						}
					} else {
						component = @"";
						domainNode = [rootNode objectInChildrenWithDomain:component]?:
								[[[iTM2MacroDomainNode alloc] initWithParent:rootNode domain:component] autorelease];
						categoryNode = [domainNode objectInChildrenWithCategory:component]?:
								[[[iTM2MacroCategoryNode alloc] initWithParent:domainNode category:component] autorelease];
					}
					component = subpath.lastPathComponent;
					component = component.stringByDeletingPathExtension;
					iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:component];
					if (!menuNode) {
						iTM2MacroMenuNode * menuNode = [[[iTM2MacroMenuNode alloc] initWithParent:categoryNode context:component] autorelease];
						NSURL * url = [repositoryURL URLByAppendingPathComponent:subpath];
						[menuNode setValue:url forKeyPath:@"value.URL"];
					}
				}
			}
			[DFM popDirectory4iTM3];
		}
	}
	metaSETTER(rootNode);
	return rootNode;
}

- (void)setMenuTree:(id)aTree;
{
	id old = metaGETTER;
	if ([old isEqual:aTree] || (old == aTree))
	{
		return;
	}
	metaSETTER(aTree);
	return;
}
#pragma mark =-=-=-=-=-  MENU
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuItemWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = [element name];
	if ([name isEqualToString:@"SEP"])
	{
		return [NSMenuItem separatorItem];
	}
	else if ([name isEqualToString:@"ITEM"])
	{
		NSString * ID = [[element attributeForName:@"ID"] stringValue];
		iTM2MacroNode * leafNode = [SMC macroRunningNodeForID:ID context:context ofCategory:category inDomain:domain];
		name = [leafNode name];
		if (!name)
		{
			name = ID;
		}
		NSMenuItem * MI = [[[NSMenuItem alloc]
			initWithTitle:name action:NULL keyEquivalent: @""] autorelease];
		MI.toolTip = leafNode.tooltip;
		id submenuList = [[element elementsForName:@"MENU"] lastObject];
		NSMenu * M = [self macroMenuWithXMLElement:submenuList forContext:context ofCategory:category inDomain:domain error:RORef];
		[MI setSubmenu:M];
		if (ID.length)
		{
			MI.representedObject = [NSArray arrayWithObjects:ID, context, category, domain, nil];
			SEL action = leafNode.action;
			if ([ID hasPrefix:@"."] || !leafNode || action == @selector(noop:))
			{
				// no action;
				if (!M)
				{
					MI.action = @selector(___catch:);
					MI.target = self;// self is expected to last forever
				}
			}
			else
			{
				MI.action = @selector(___insertMacro:);
				MI.target = self;// self is expected to last forever
			}
		}
		return MI;
	}
	else
	{
		LOG4iTM3(@"ERROR: unknown name %@.", name);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = [element name];
	if ([name isEqualToString:@"MENU"])
	{
		if ([element childCount])
		{
			NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
			id child = [element childAtIndex:ZER0];
			do {
				NSMenuItem * MI = [self macroMenuItemWithXMLElement:child forContext:context ofCategory:category inDomain:domain error:RORef];
				if (MI)
					[M addItem:MI];
			} while((child = [child nextSibling]));
			return M;
		}
	}
	else if (element)
	{
		LOG4iTM3(@"ERROR: unknown name %@.", name);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuForContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2MacroRootNode * rootNode = self.menuTree;
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	iTM2MacroCategoryNode * categoryNode = [domainNode objectInChildrenWithCategory:category];
	iTM2MacroMenuNode * menuNode = [categoryNode objectInChildrenWithContext:context];
	NSMenu * M = [menuNode valueForKeyPath:@"value.menu"];
	if (!M)
	{
		NSURL * url = [menuNode valueForKeyPath:@"value.URL"];
		if (url)
		{
			NSError * localError = nil;
			NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:ZER0 error:&localError] autorelease];
			if (localError)
			{
				[SDC presentError:localError];
			}
			NSXMLElement * rootElement = [xmlDoc rootElement];
			M = [self macroMenuWithXMLElement:rootElement forContext:context ofCategory:category inDomain:domain error:&localError];
			[menuNode setValue:M forKeyPath:@"value.menu"];
		}
	}
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// availableModes:
	NSArray * itemArray = menu.itemArray;
	NSMenuItem * MI = nil;
	SEL action = @selector(takeMacroModeFromRepresentedObject:);
	NSMutableArray * availableModes = [NSMutableArray array];
	NSString * mode = nil;
	for (MI in itemArray) {
		if (MI.action == action) {
			mode = [MI representedObject];
			if (![availableModes containsObject:mode])
			{
				[availableModes addObject:mode];
			}
		}
	}
	// expected modes:
	id firstResponder = [[NSApp keyWindow] firstResponder];
	NSString * domain = [firstResponder macroDomain];
	iTM2MacroRootNode * rootNode = self.macroTree;
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	NSArray * expectedModes = [domainNode availableCategories];
	//
	if ([expectedModes isEqual:availableModes]) {
		return;
	}
	// remove items with takeMacroModeFromRepresentedObject:
	for(MI in itemArray) {
		if (MI.action == action) {
			[menu removeItem:MI];
		}
	}
	// recover the "Mode:" title menu item
	NSInteger index = [menu indexOfItemWithRepresentedObject:@"PRIVATE_MacroModeMenuItem4iTM3"];
	++index;

	for(mode in expectedModes)
	{
		MI = [[[NSMenuItem alloc] initWithTitle:[mode description] action:action keyEquivalent:@""] autorelease];
		MI.representedObject = mode;
		MI.indentationLevel = 1;
		[menu insertItem:MI atIndex:index++];
	}
	MI = [NSMenuItem separatorItem];
	[menu insertItem:MI atIndex:index];
	[menu cleanSeparators4iTM3];
//END4iTM3;
	return;
}
@end

#import "iTM2InstallationKit.h"

@implementation iTM2MainInstaller(MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroKitCompleteInstallation4iTM3
+ (void)iTM2MacroKitCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * M = [NSApp mainMenu];
	NSMenuItem * MI = [M deepItemWithAction4iTM3:@selector(macroMode:)];
	if (MI)
	{
		M = MI.menu;
		MI.action = NULL;
		MI.representedObject = @"PRIVATE_MacroModeMenuItem4iTM3";
		M.delegate = SMC;
	}
	else
	{
		LOG4iTM3(@"No macros menu");
	}
//END4iTM3;
    return;
}
@end
