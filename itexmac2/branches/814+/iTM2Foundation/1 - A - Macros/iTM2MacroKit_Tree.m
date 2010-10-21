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
#import "iTM2MacroKit_Prefs.h"

@implementation iTM2KeyStroke
- (BOOL)isEqualToKeyStroke:(iTM2KeyStroke *)rhs;
{
	if (![rhs isKindOfClass:[iTM2KeyStroke class]])
	{
		return NO;
	}
	return ([self codeName]==[rhs codeName] || [[self codeName] isEqual:[rhs codeName]])
		&& [self modifierFlags] == [rhs modifierFlags];
}
#define DEFINE(GETTER,SETTER)\
- (NSString *)GETTER;{return GETTER;}\
- (void)SETTER:(NSString *)new;{[GETTER autorelease];GETTER = [new copy];return;}
DEFINE(altCodeName,setAltCodeName)
DEFINE(codeName,setCodeName)
#undef DEFINE
- (NSUInteger)modifierFlags;
{
	return modifierFlags;
}
- (void)setModifierFlags:(NSUInteger)newModifiers;
{
	modifierFlags = newModifiers;
}
+ (iTM2KeyStroke *)keyStrokeWithKey:(NSString *)key;
{
	iTM2KeyStroke * result = [[[iTM2KeyStroke alloc] init] autorelease];
	[result setCodeName:key];
	return result;
}
+ (iTM2KeyStroke *)keyStrokeWithEvent:(NSEvent *)theEvent;
{
	if ([theEvent type] == NSKeyDown || [theEvent type] == NSKeyUp)
	{
		iTM2KeyStroke * result = [[[iTM2KeyStroke alloc] init] autorelease];
		NSUInteger modifiers = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask & ~(NSFunctionKeyMask|NSAlphaShiftKeyMask|NSNumericPadKeyMask);
		NSString * candidate = [KCC nameForKeyCode:[theEvent charactersIgnoringModifiers]];
		NSString * altCandidate = [KCC nameForKeyCode:[theEvent characters]];
		if ([altCandidate isEqual:candidate])
		{
			altCandidate = nil;
		}
		if (((modifiers & (NSShiftKeyMask)) == 0) && (candidate.length == 1))
		{
			unichar c = [candidate characterAtIndex:0];
			if (c>='a' && c<='z')
			{
				candidate = [candidate uppercaseString];
			}
			else if (![[NSCharacterSet letterCharacterSet] characterIsMember:c])
			{
				modifiers &= ~NSShiftKeyMask;
			}
		}
		[result setModifierFlags:modifiers];
		[result setCodeName:candidate];
		[result setAltCodeName:altCandidate];
		return result;
	}
	return nil;
}
- (NSString *)key;
{
	NSMutableString * result = [NSMutableString string];
	if (modifierFlags & NSAlphaShiftKeyMask) [result appendString:@"A"];
	if (modifierFlags & NSShiftKeyMask)		[result appendString:@"$"];
	if (modifierFlags & NSControlKeyMask)	[result appendString:@"^"];
	if (modifierFlags & NSAlternateKeyMask)	[result appendString:@"~"];
	if (modifierFlags & NSCommandKeyMask)	[result appendString:@"@"];
//	if (modifierFlags & NSNumericPadKeyMask) [result appendString:@"#"];
//	if (modifierFlags & NSHelpKeyMask)		[result appendString:@"?"];
	if (modifierFlags & NSFunctionKeyMask)	[result appendString:@"&"];
	if (result.length)	[result appendString:@"+"];
	[result appendString:codeName];
	return result;
}
- (NSString *)altKey;
{
	if ((modifierFlags & NSAlternateKeyMask > 0)
		&& altCodeName.length
			&& ![altCodeName isEqual:codeName])
	{
		NSMutableString * result = [NSMutableString string];
		if (modifierFlags & NSAlphaShiftKeyMask) [result appendString:@"A"];
		if (modifierFlags & NSShiftKeyMask)		[result appendString:@"$"];
		if (modifierFlags & NSControlKeyMask)	[result appendString:@"^"];
//		if (modifierFlags & NSAlternateKeyMask)	[result appendString:@"~"]; the effect of the alt key is recorded in the alt code
		if (modifierFlags & NSCommandKeyMask)	[result appendString:@"@"];
//		if (modifierFlags & NSNumericPadKeyMask) [result appendString:@"#"];
//		if (modifierFlags & NSHelpKeyMask)		[result appendString:@"?"];
		if (modifierFlags & NSFunctionKeyMask)	[result appendString:@"&"];
		if (result.length)	[result appendString:@"+"];
		[result appendString:altCodeName];
	}
	return [self key];
}
+ (NSUInteger)getModifierFlags:(NSString *)modifiers;
{
	NSUInteger index = modifiers.length;
	NSUInteger result = 0;
	while(index--)
	{
		switch([modifiers characterAtIndex:index])
		{
			case 'A': result |= NSAlphaShiftKeyMask;break;
			case '$': result |= NSShiftKeyMask;break;
			case '^': result |= NSControlKeyMask;break;
			case '~': result |= NSAlternateKeyMask;break;
			case '@': result |= NSCommandKeyMask;break;
//			case '#': result |= NSNumericPadKeyMask;break;
//			case '?': result |= NSHelpKeyMask;break;
			case '&': result |= NSFunctionKeyMask;break;
		}
	}
	return result;
}
@end

@interface iTM2KeyBindingParser:NSObject <NSXMLParserDelegate>
{
@private
	iTM2KeyBindingNode * bindings;// the bindings
	iTM2KeyBindingNode * current;// the current binding, not retain
	struct
	{
		NSUInteger
			started:1,
			where:3,
			reserved:28;
	} status;
	ICURegEx * keyValidationRE;
	BOOL uniqueKey;
}
- (iTM2KeyBindingNode *)bindings;
- (void)setBindings:(iTM2KeyBindingNode *)new;
- (iTM2KeyBindingNode *)current;
- (void)setCurrent:(iTM2KeyBindingNode *)new;
- (ICURegEx *)keyValidationRE;
@property (getter=uniqueKey,setter=setUniqueKey:) BOOL uniqueKey;
@end

@implementation iTM2KeyBindingParser
- (BOOL)uniqueKey;
{
	return uniqueKey;
}
- (void)setUniqueKey:(BOOL)new;
{
	uniqueKey = new;
	return;
}
- (iTM2KeyBindingNode *)bindings;
{
	return bindings;
}
- (void)setBindings:(iTM2KeyBindingNode *)new;
{
	[bindings autorelease];
	bindings = [new retain];
	return;
}
- (iTM2KeyBindingNode *)current;
{
	return current;
}
- (void)setCurrent:(iTM2KeyBindingNode *)new;
{
	[current autorelease];
	current = [new retain];
	return;
}
- (ICURegEx *)keyValidationRE;
{
	return keyValidationRE?:(keyValidationRE = [ICURegEx regExWithSearchPattern:@"(?:(.*?)\\+)?(.+)" error:NULL]);
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
	if (status.started)
	{
		if ([elementName isEqual:@"BIND"])
		{
			// create a new key binding, or use an old one if available
			// get the KEY:
			NSString * key = [attributeDict objectForKey:@"KEY"];
			if ([self.keyValidationRE matchString:key])
			{
				NSUInteger modifierFlags = [iTM2KeyStroke getModifierFlags:[keyValidationRE substringOfCaptureGroupAtIndex:1]];
				NSString * codeName = [keyValidationRE substringOfCaptureGroupAtIndex:2];
				unichar c;
				if (codeName.length == 1)
				{
					c = [codeName characterAtIndex:0];
					if ((c>='a') && (c<='z'))
					{
						codeName = [codeName uppercaseString];
					}
				}
				NSString * altCodeName = [attributeDict objectForKey:@"ALT"];
				iTM2KeyBindingNode * KB;
				if ([self uniqueKey] && (KB = [current objectInChildrenWithCodeName:codeName modifierFlags:modifierFlags]))
				{
					[KB setMacroID:[attributeDict objectForKey:@"ID"]];
					if (((modifierFlags & (NSShiftKeyMask|NSAlphaShiftKeyMask)) == 0) && (codeName.length == 1))
					{
						c = [codeName characterAtIndex:0];
						if (c>='a' && c<='z')
						{
							codeName = [codeName uppercaseString];
						}
					}
					[KB setCodeName:codeName];
					[KB setModifierFlags:modifierFlags];
					[KB setAltCodeName:([altCodeName isEqual:codeName]?nil:altCodeName)];
				}
				else
				{
					KB = [[[[current class] alloc] init] autorelease];
					if (((modifierFlags & (NSShiftKeyMask|NSAlphaShiftKeyMask)) == 0) && (codeName.length == 1))
					{
						c = [codeName characterAtIndex:0];
						if (c>='a' && c<='z')
						{
							codeName = [codeName uppercaseString];
						}
					}
					[KB setCodeName:codeName];
					[KB setModifierFlags:modifierFlags];
					[KB setAltCodeName:([altCodeName isEqual:codeName]?nil:altCodeName)];
					[current insertObject:KB inChildrenAtIndex:[[current children] count]];
					[KB setMacroID:[attributeDict objectForKey:@"ID"]];// after the KB is inserted!
				}
				[self setCurrent:KB];
			}
		}
	}
	else if ([elementName isEqual:@"BINDINGS"])
	{
		status.started = 1;
		if (!bindings)
		{
			[self setBindings:[[[iTM2KeyBindingNode alloc] init] autorelease]];
		}
		[self setCurrent:[self bindings]];
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
	if ([elementName isEqual:@"BIND"])
	{
		[self setCurrent:[[self current] parent]];
	}
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
{
	if (status.started)
	{
		NSLog(@"*** parser error:%@",parseError);
	}
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError;
{
	NSLog(@"*** validation error:%@",validationError);
}
@end

@implementation iTM2KeyBindingNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithParent:
- (id)initWithParent:(id)aParent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [self init])
    {
		[self setChildren:[NSMutableArray array]];
		[self setParent:aParent];
    }
    return self;
}
- (NSString *)macroID;
{
	return macroID;
}
- (void)setMacroID:(NSString *)new;
{
	[macroID autorelease];
	macroID = [new copy];
	return;
}
- (NSMutableArray *)children;
{
	return children;
}
- (void)setChildren:(NSMutableArray *)new;
{
	[children autorelease];
	children = [new retain];
}
- (NSString *)description;
{
	return [NSString stringWithFormat:@"ID:%@, modifierFlags:%u, codeName:%@, altCodeName:%@, children:%@",
		macroID, [self modifierFlags], [self codeName], [self altCodeName], children];
}
- (iTM2KeyBindingNode *)parent;
{
	return parent;
}
- (void)setParent:(iTM2KeyBindingNode *)aParent;
{
	parent = aParent;// not retained to avoid circular references
}
- (NSUInteger)countOfChildren;
{
	return children.count;
}
- (id)objectInChildrenAtIndex:(NSUInteger)index;
{
	return [children objectAtIndex:index];
}
- (void)insertObject:(id)object inChildrenAtIndex:(NSUInteger)index;
{
	if (!children)
	{
		children = [[NSMutableArray array] retain];
	}
	[object setParent:self];
	[children insertObject:object atIndex:index];
}
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)index;
{
	[[children objectAtIndex:index] setParent:nil];
	[children removeObjectAtIndex:index];
	if (!children.count)
	{
		[children release];
		children = nil;
	}
}
- (id)objectInChildrenWithCodeName:(NSString *)theCodeName modifierFlags:(NSUInteger)modifierFlags;
{
	iTM2KeyBindingNode * child;
	for(child in children)
	{
		if ([[child codeName] isEqual:theCodeName] && [child modifierFlags] == modifierFlags)
		{
			return child;
		}
	}
	return nil;
}
- (id)objectInChildrenWithKeyStroke:(iTM2KeyStroke *)keyStroke;
{
	iTM2KeyBindingNode * child;
	for(child in children)
	{
		if ([child isEqualToKeyStroke:keyStroke])
		{
			return child;
		}
	}
	// second chance to get things working: use the last code name and remove the alt key
	iTM2KeyStroke * KS;
	if ([[keyStroke altCodeName] length])
	{
		KS= [[[iTM2KeyStroke alloc] init] autorelease];
		[KS setCodeName:[keyStroke altCodeName]];
		[KS setModifierFlags:[keyStroke modifierFlags]&~NSAlternateKeyMask];
		for(child in children)
		{
			if ([child isEqualToKeyStroke:KS])
			{
				return child;
			}
		}
	}
	// third chance, remove the shift if the code is not a letter
	if (([[keyStroke codeName] length] == 1) 
		&& (([keyStroke modifierFlags]&NSShiftKeyMask)>0)
			&& ![[NSCharacterSet letterCharacterSet] characterIsMember:[[keyStroke codeName] characterAtIndex:0]])
	{
		KS = [[[iTM2KeyStroke alloc] init] autorelease];
		[KS setCodeName:[keyStroke codeName]];
		[KS setModifierFlags:[keyStroke modifierFlags]&~NSShiftKeyMask];
		for(child in children)
		{
			if ([child isEqualToKeyStroke:KS])
			{
				return child;
			}
		}
	}
	return nil;
}
- (id)objectInKeyBindingsWithKeyStroke:(iTM2KeyStroke *)keyStroke;
{
	iTM2KeyBindingNode * child;
	for(child in children)
	{
		if ([child isEqualToKeyStroke:keyStroke])
		{
			return child;
		}
	}
	return [self objectInChildrenWithKeyStroke:keyStroke];
}
- (void)parseData:(NSData *)data uniqueKey:(BOOL)flag;
{
	if (data)
	{
		NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
		iTM2KeyBindingParser * delegate = [[iTM2KeyBindingParser alloc] init];
		[delegate setBindings:self];
		[delegate setUniqueKey:flag];
		[parser setDelegate:delegate];
		[parser setShouldResolveExternalEntities:NO];
		[parser parse];
		[delegate release];
		[parser release];
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
    return [[self parent] macroDomain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
    return [[self parent] macroCategory];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
- (NSString *)macroContext;
{
    return [[self parent] macroContext];
}
@end

@interface iTM2MacroParser:NSObject <NSXMLParserDelegate>
{
@private
	NSMutableDictionary * macros;// the macros
	iTM2MacroNode * current;// the current macro
	Class macroClass;
	id owner;// not retained
	struct _MPDstatus
	{
		NSUInteger started:1;
		NSUInteger where:3;
		NSUInteger reserved:28;
	} status;
}
- (id)initWithClass:(Class)theClass owner:(id)anOwner;
- (NSMutableDictionary *)macros;
- (void)setMacros:(NSMutableDictionary *)new;
- (iTM2MacroNode *)current;
- (void)setCurrent:(iTM2MacroNode *)new;
@property Class macroClass;
@property (retain) id owner;
@end

@implementation iTM2MacroNode
#define DEFINE(GETTER,SETTER) \
- (NSString *)GETTER;{return GETTER;}\
- (void)SETTER:(NSString *)new;{[GETTER autorelease];GETTER = [new copy];return;}
DEFINE(macroID,setMacroID)
DEFINE(selector,setSelector)
DEFINE(name,setName)
DEFINE(macroDescription,setMacroDescription)
DEFINE(insertion,setInsertion)
DEFINE(tooltip,setTooltip)
#undef DEFINE
- (NSDictionary *)substitutions;
{
	return substitutions;
}
- (void)setSubstitutions:(NSDictionary *)newSubstitutions;
{
	[substitutions autorelease];
	substitutions = [newSubstitutions retain];
}
- (void)setOwner:(id)anOwner;
{
	// do nothing, this will be used by the iTM2PrefsMacroNode
}
- (NSString *)description;
{
	return [NSString stringWithFormat:@"class:%@, name:%@, desc:%@, tip:%@, sel:%@, insertion:%@",
		NSStringFromClass([self class]),
		[self valueForKey:@"macroDescription"],
		[self valueForKey:@"macroID"],
		[self valueForKey:@"tooltip"],
		[self valueForKey:@"selector"],
		[self valueForKey:@"insertion"]];// KVC compliant
}
+ (NSMutableDictionary *)macrosWithData:(NSData *)data owner:(id)anOwner;
{
	NSMutableDictionary * result = [NSMutableDictionary dictionary];
	if (data)
	{
		NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
		iTM2MacroParser * delegate = [[iTM2MacroParser alloc] initWithClass:self owner:anOwner];
		[parser setDelegate:delegate];
		[parser setShouldResolveExternalEntities:NO];
		if ([parser parse])
		{
			result = [[[delegate macros] retain] autorelease];
		}
		[delegate release];
		[parser release];
	}
	return result;
}
@end

@implementation iTM2MacroParser
- (id)initWithClass:(Class)theClass owner:(id)anOwner;
{
	if (self = [self init])
	{
		macroClass = theClass;
		owner = anOwner;
	}
	return self;
}
- (NSMutableDictionary *)macros;
{
	return macros;
}
- (void)setMacros:(NSMutableDictionary *)new;
{
	[macros autorelease];
	macros = [new retain];
	return;
}
- (iTM2MacroNode *)current;
{
	return current;
}
- (void)setCurrent:(iTM2MacroNode *)new;
{
	[current autorelease];
	current = [new retain];
	return;
}
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
	if (status.started)
	{
		if ([elementName isEqual:@"ACTION"])
		{
			// create a new macro
			// get the ID:
			NSString * ID = [attributeDict objectForKey:@"ID"];
			status.where = 0;// the top of a macro, if any
			if (ID.length)
			{
				[self setCurrent:[[[macroClass alloc] init] autorelease]];
				[current setSelector:[attributeDict objectForKey:@"SEL"]];
				[current setMacroID:ID];
				[current setOwner:owner];
				[macros setObject:current forKey:ID];
			}
			else
			{
				[self setCurrent:nil];// 0 lengthed ID are ignored
			}
		}
		else if ([elementName isEqual:@"INS"])
		{
			status.where = 1;
		}
		else if ([elementName isEqual:@"NAME"])
		{
			status.where = 2;
		}
		else if ([elementName isEqual:@"DESC"])
		{
			status.where = 3;
		}
		else if ([elementName isEqual:@"TIP"])
		{
			status.where = 4;
		}
		else
		{
			status.where = -1;// nowhere
		}
	}
	else if ([elementName isEqual:@"MACROS"])
	{
		status.started = 1;
		status.where = -1;
		self.macros = [[NSMutableDictionary dictionary] retain];
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
	status.where = -1;
	if ([elementName isEqual:@"MACROS"])
	{
		status.started = 0;
	}
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
	switch(status.where)
	{
		case 1: current.insertion = string; break;
		case 2: current.name = string; break;
		case 3: current.macroDescription = string; break;
		case 4: current.tooltip = string; break;
	}
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError;
{
	if (status.started)
	{
		LOG4iTM3(@"*** parser error:%@",parseError);
	}
}
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError;
{
	LOG4iTM3(@"*** validation error:%@",validationError);
}
@synthesize macroClass;
@synthesize owner;
@end

@implementation iTM2MacroTreeNode
- (id)contextNode;
{
	iTM2TreeNode * contextNode = [self parent];
	while(contextNode && ![contextNode isKindOfClass:[iTM2MacroAbstractContextNode class]])
	{
		contextNode = [contextNode parent];
	}
	return contextNode;// the result can be nil, in particular for category and domain nodes
}
@end

NSString * const iTM2MacroControllerComponent = @"Macros.localized";

#import "iTM2PathUtilities.h"
#import "iTM2BundleKit.h"

@implementation iTM2MacroRootNode
- (id)objectInChildrenWithDomain:(NSString *)domain;
{
	return [self objectInChildrenWithValue:domain forKeyPath:@"value.domain"];
}
- (NSArray *)availableDomains;
{
	NSMutableArray * result = [NSMutableArray array];
	NSArray * children = [self children];
	id child;
	id domain;
	for(child in children)
	{
		domain = [child valueForKeyPath:@"value.domain"];
		if (domain && ![result containsObject:domain])
		{
			[result addObject:domain];
		}
	}
	if (!result.count)
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
	NSParameterAssert(domain);
	if (self = [super initWithParent:parent])
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
	id child;
	id category;
	for(child in children)
	{
		category = [child valueForKeyPath:@"value.category"];
		if (category && ![result containsObject:category])
		{
			[result addObject:category];
		}
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	[result sortUsingDescriptors:SDs];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
    return [self valueForKeyPath:@"value.domain"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
    return [[self parent] macroCategory];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
- (NSString *)macroContext;
{
    return [[self parent] macroContext];
}
@end

@implementation iTM2MacroCategoryNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent category:(NSString *)category;
{
	NSParameterAssert(category);
	if (self = [super initWithParent:parent])
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
	id child;
	id context;
	for(child in children)
	{
		context = [child valueForKeyPath:@"value.context"];
		if (context && ![result containsObject:context])
		{
			[result addObject:context];
		}
	}
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"description" ascending:YES] autorelease];
	NSArray * SDs = [NSArray arrayWithObject:SD];
	[result sortUsingDescriptors:SDs];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
    return [[self parent] macroDomain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
    return [self valueForKeyPath:@"value.category"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
- (NSString *)macroContext;
{
    return [[self parent] macroContext];
}
@end

NSString * const iTM2MacroPersonalComponent = @"Personal";

#pragma mark =-=-=-=-=-  ABSTRACT CONTEXT NODES
@implementation iTM2MacroAbstractContextNode
- (id)initWithParent:(iTM2MacroTreeNode *)parent context:(NSString *)context;
{
	NSParameterAssert(context);
	if (self = [super initWithParent:parent])
	{
		[self setValue:context forKeyPath:@"value.context"];
	}
	return self;
}
- (void)addURLPromise:(NSURL *)url;
{
	NSMutableArray * URLsPromise = [self valueForKeyPath:@"value.URLsPromise"];// ordered list of urls, the latter overrides the former
	if (!URLsPromise)
	{
		URLsPromise = [NSMutableArray array];
		[self setValue:URLsPromise forKeyPath:@"value.URLsPromise"];
		URLsPromise = [self valueForKeyPath:@"value.URLsPromise"];
	}
	[URLsPromise addObject:url];
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"URL promise:%@",url);
	}
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
	NSURL * url = [MB URLForSupportDirectory4iTM3:iTM2MacroControllerComponent inDomain:NSUserDomainMask create:NO];
	url = [url URLByAppendingPathComponent:path];
	return url;
}
- (NSData *)personalDataForSaving;
{
	NSAssert(NO,@"You are not allowed to use this method, override -personalDataForSaving");
	return nil;
}
+ (NSString *)pathExtension;
{
	NSAssert(NO,@"You are not allowed to use this class, override +pathExtension");
	return @"NONE";
}
- (NSString *)pathExtension;
{
	return [[self class] pathExtension];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
    return [[self parent] macroDomain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
    return [[self parent] macroCategory];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
- (NSString *)macroContext;
{
    return [self valueForKeyPath:@"value.context"];
}
- (void)update;
{
	return;// subclassers will do what they want here
}
@end

NSString * const iTM2MacroPathExtension = @"iTM2-macros";

@implementation iTM2MacroContextNode
+ (NSString *)pathExtension;
{
	return iTM2MacroPathExtension;
}
- (NSMutableDictionary *)macros;
{
	NSMutableDictionary * result = [self valueForKeyPath:@"value.macros"];
	if (!result)
	{
		NSMutableDictionary * MD = [NSMutableDictionary dictionary];
		NSEnumerator * E = [[self valueForKeyPath:@"value.URLsPromise"] objectEnumerator];
		NSURL * url = nil;
		NSURL * personalUrl = [self personalURL];
		NSError * localError =  nil;
		NSData * data = nil;
		NSDictionary * D = nil;
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"Reading Macros");
		}
		while(url = [E nextObject])
		{
			if (![url isEqual:personalUrl])
			{
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"Reading Macros at URL:%@",url);
				}
				data = [NSData dataWithContentsOfURL:url options:0 error:&localError];
				if (localError)
				{
					LOG4iTM3(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
					localError = nil;
				}
				if (D = [iTM2MacroNode macrosWithData:data owner:self])
				{
					[MD addEntriesFromDictionary:D];
				}
				else
				{
					LOG4iTM3(@"Failure in reading Macros at URL:%@",url);
				}
			}
		}
		data = [NSData dataWithContentsOfURL:personalUrl options:0 error:&localError];
		if (localError)
		{
			LOG4iTM3(@"*** The macro file might be corrupted at\n%@\nerror:%@", personalUrl,localError);
		}
		if (D = [iTM2MacroNode macrosWithData:data owner:self])
		{
			[MD addEntriesFromDictionary:D];
		}
		[self setMacros:MD];
	}
	return result;
}
- (void)setMacros:(NSMutableDictionary *)macros;
{
	[[[self valueForKeyPath:@"value.macros"] retain] autorelease];
	[self setValue:macros forKeyPath:@"value.macros"];
}
- (void)update;
{
	[self setMacros:nil];
}
@end

NSString * const iTM2KeyBindingPathExtension = @"iTM2-key-bindings";

@implementation iTM2KeyBindingContextNode
+ (NSString *)pathExtension;
{
	return iTM2KeyBindingPathExtension;
}
- (BOOL)uniqueKey;
{
	return YES;
}
- (iTM2KeyBindingNode *)keyBindings;
{
	iTM2KeyBindingNode * result = [self valueForKeyPath:@"value.keyBindings"];
	if (result)
	{
		return result;
	}
	result = [[[iTM2KeyBindingNode alloc] init] autorelease];
	NSEnumerator * E = [[self valueForKeyPath:@"value.URLsPromise"] objectEnumerator];
	NSURL * url = nil;
	NSURL * personalURL = [self personalURL];
	NSError * localError =  nil;
	NSData * data = nil;
	while(url = [E nextObject])
	{
		if (![url isEqual:personalURL])
		{
			data = [NSData dataWithContentsOfURL:url options:0 error:&localError];
			if (localError)
			{
				LOG4iTM3(@"*** The macro file might be corrupted at\n%@\nerror:%@", url,localError);
				localError = nil;
			}
			[result parseData:data uniqueKey:[self uniqueKey]];
		}
	}
	BOOL isDirectory;
	if (personalURL.isFileURL && [DFM fileExistsAtPath:personalURL.path isDirectory:&isDirectory] && !isDirectory)
	{
		data = [NSData dataWithContentsOfURL:personalURL options:0 error:&localError];
		if (localError)
		{
			LOG4iTM3(@"*** The macro file might be corrupted at\n%@\nerror:%@", personalURL,localError);
		}
		[result parseData:data uniqueKey:[self uniqueKey]];
	}
	[self setKeyBindings:result];
	return result;
}
- (void)setKeyBindings:(iTM2KeyBindingNode *)keyBindings;
{
	[[[self valueForKeyPath:@"value.keyBindings"] retain] autorelease];
	[self setValue:keyBindings forKeyPath:@"value.keyBindings"];
}
- (void)update;
{
	[self setKeyBindings:nil];
}
@end

