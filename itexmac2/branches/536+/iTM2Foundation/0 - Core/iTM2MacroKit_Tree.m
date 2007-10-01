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

#import "iTM2MacroKit_Tree.h"

@implementation iTM2MacroTreeNode
- (void)honorURLPromises;
{
	iTM2MacroTreeNode * parent = [self parent];
	[parent honorURLPromises];
	return;
}
- (NSArray *)children;
{
	[self honorURLPromises];
	return [super children];
}
- (id)contextNode;
{
	iTM2MacroAbstractContextNode * contextNode = [self parent];
	while(contextNode && ![contextNode isKindOfClass:[iTM2MacroAbstractContextNode class]])
	{
		contextNode = [contextNode parent];
	}
	return contextNode;
}
@end

NSString * const iTM2MacroControllerComponent = @"Macros.localized";

#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>

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
	if(![result count])
	{
		[result addObject:@""];// the "do nothing" domain
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	[result sortUsingDescriptors:SDs];
	return result;
}
@end

@implementation iTM2MacroDomainNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent domain:(NSString *)domain;
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

@implementation iTM2MacroCategoryNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent category:(NSString *)category;
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
- (NSArray *)availableContexts;
{
	NSMutableArray * result = [NSMutableArray array];
	NSArray * children = [self children];
	NSEnumerator * E = [children objectEnumerator];
	id child;
	id context;
	while(child = [E nextObject])
	{
		context = [child valueForKeyPath:@"value.context"];
		if(context && ![result containsObject:context])
		{
			[result addObject:context];
		}
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	[result sortUsingDescriptors:SDs];
	return result;
}
@end

NSString * const iTM2MacroPersonalComponent = @"Personal";

#pragma mark =-=-=-=-=-  CONCRETE CONTEXT NODES
@implementation iTM2MacroAbstractContextNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent context:(NSString *)context;
{
	if(self = [super initWithParent:parent])
	{
		[self setValue:context forKeyPath:@"value.context"];
	}
	return self;
}
- (void)addURLPromise:(NSURL *)url;
{
	NSMutableArray * URLsPromise = [self valueForKeyPath:@"value.URLsPromise"];
	if(!URLsPromise)
	{
		URLsPromise = [NSMutableArray array];
		[self setValue:URLsPromise forKeyPath:@"value.URLsPromise"];
		URLsPromise = [self valueForKeyPath:@"value.URLsPromise"];
	}
	[URLsPromise addObject:url];
	return;
}
- (void)readContentOfURL:(NSURL *)url;
{
	NSMutableDictionary * documentsByURLs = [self valueForKeyPath:@"value.documentsByURLs"];
	if(!documentsByURLs)
	{
		documentsByURLs = [NSMutableDictionary dictionary];
		[self setValue:documentsByURLs forKeyPath:@"value.documentsByURLs"];
		documentsByURLs = [self valueForKeyPath:@"value.documentsByURLs"];
	}
	NSArray * allKeys = [documentsByURLs allKeys];
	if([allKeys containsObject:url])
	{
		return;
	}
	NSBundle * MB = [NSBundle mainBundle];
	NSString * userMacrosDir = [MB pathForSupportDirectory:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:NO];
	NSString * path = [url path];
	BOOL mutable = path && [DFM isWritableFileAtPath:path] && [path belongsToDirectory:userMacrosDir];
//iTM2_LOG(@"mutable:%@\nuserMacrosDir: %@\npath:%@",(mutable?@"Y":@"N"),userMacrosDir,path);
	NSError * localError =  nil;
//			NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodePreserveAll error:&localError] autorelease];// raise for an unknown reason
	NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeCompactEmptyElement error:&localError] autorelease];
//iTM2_LOG(@"document:%@",document);
	if(localError)
	{
		iTM2_LOG(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
	}
	else
	{
		[documentsByURLs setObject:document forKey:url];
		NSMutableArray * URLsPromise = [[[self valueForKeyPath:@"value.URLsPromise"] retain] autorelease];// for the reentrant management
		if(![URLsPromise containsObject:url])
		{
			return;
		}
		[[url retain] autorelease];
		[URLsPromise removeObject:url];
		// now create the children
		// also manage the mutability
		NSXMLElement * rootElement = [document rootElement];
		[self readXMLRootElement:rootElement mutable:mutable];
	}
	return;
}
- (void)honorURLPromises;
{
	NSMutableArray * URLsPromise = [self valueForKeyPath:@"value.URLsPromise"];
	NSEnumerator * E = [URLsPromise objectEnumerator];
	NSURL * url;
	while(url = [E nextObject])
	{
		[self readContentOfURL:url];
	}
	return;
}
- (NSArray *)documentURLs;
{
	NSMutableDictionary * documentsByURLs = [self valueForKeyPath:@"value.documentsByURLs"];
	NSArray * result = [documentsByURLs allKeys];
	NSMutableSet * set = [NSMutableSet setWithArray:result];
	result = [self valueForKeyPath:@"value.URLsPromise"];
	[set addObjectsFromArray:result];
	result = [set allObjects];
	return result;
}
- (NSArray *)honoredDocumentURLs;
{
	NSMutableDictionary * documentsByURLs = [self valueForKeyPath:@"value.documentsByURLs"];
	NSArray * result = [documentsByURLs allKeys];
	return result;
}
- (NSXMLDocument *)documentForURL:(NSURL *)url;
{
	[self readContentOfURL:url];// if the url was a promise, it will be read here; otherwise does nothing
	NSMutableDictionary * documentsByURLs = [self valueForKeyPath:@"value.documentsByURLs"];
	NSXMLDocument * result = [documentsByURLs objectForKey:url];
	return result;
}
- (void)setDocument:(NSXMLDocument *)document forURL:(NSURL *)url;
{
	NSMutableDictionary * documentsByURLs = [self valueForKeyPath:@"value.documentsByURLs"];
	if(!documentsByURLs)
	{
		documentsByURLs = [NSMutableDictionary dictionary];
		[self setValue:documentsByURLs forKeyPath:@"value.documentsByURLs"];
		documentsByURLs = [self valueForKeyPath:@"value.documentsByURLs"];
	}
	[documentsByURLs setObject:document forKey:url];
	return; 
}
- (NSURL *)personalURL;
{
	// what is the URL of the personal macros?
	NSString * path = [[self class] pathExtension];
	path = [iTM2MacroPersonalComponent stringByAppendingPathExtension:path];
	id aNode = [self parent];
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
+ (NSString *)pathExtension;
{
	NSAssert(NO,@"You are not allowed to use this class, override -pathExtension");
	return @"NONE";
}
- (NSString *)pathExtension;
{
	return [[self class] pathExtension];
}
- (void)readXMLRootElement:(NSXMLElement *)element mutable:(BOOL)mutable;
{
	[[self list] readXMLElement:element mutable:mutable];
	return;
}
- (id)list;
{
	NSAssert1(NO,@"****  ERROR: You must override %@",NSStringFromSelector(_cmd));
	return [self valueForKeyPath:@"value.list"];
}
@end

@interface iTM2MacroAbstractModelNode(PRIVATE)
+ (void)prefsInitBindings;
@end

@implementation iTM2MacroAbstractModelNode:iTM2MacroTreeNode
+ (void)initialize;
{
	[super initialize];
	if([self respondsToSelector:@selector(prefsInitBindings)])
	{
		[self prefsInitBindings];
	}
	return;
}
- (id)init;
{
	if(self = [super init])
	{
		[self setValue:[NSMutableDictionary dictionary]];
	}
	return self;
}
- (void)readXMLElement:(NSXMLElement *)element mutable:(BOOL)mutable;
{
	NSAssert(NO,@"You are not allowed to use this class, override -readXMLElement:mutable:");
	return;
}
@end
